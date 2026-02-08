#!/usr/bin/env node
/**
 * mcp-sync.mjs — Syncs MCP server configs across dev tools
 *
 * Supported tools:
 *   - Cursor          (~/.cursor/mcp.json)
 *   - Claude Desktop  (~/Library/Application Support/Claude/claude_desktop_config.json)
 *   - VS Code         (~/Library/Application Support/Code/User/mcp.json)
 *   - OpenCode        (~/.config/opencode/opencode.json)
 *   - Codex           (~/.codex/config.toml)
 *   - Claude Code     (project .mcp.json)
 *
 * Usage:
 *   node scripts/mcp-sync.mjs              # sync (add missing servers to all tools)
 *   node scripts/mcp-sync.mjs --dry-run    # preview changes without writing
 *   node scripts/mcp-sync.mjs --force      # overwrite existing servers with canonical version
 *   node scripts/mcp-sync.mjs --status     # show current state of all configs
 *   node scripts/mcp-sync.mjs --install    # install launchd agent (every 6h)
 *   node scripts/mcp-sync.mjs --uninstall  # remove launchd agent
 */

import fs from 'node:fs';
import path from 'node:path';
import os from 'node:os';
import { execSync } from 'node:child_process';

const HOME = os.homedir();
const DRY_RUN = process.argv.includes('--dry-run');
const VERBOSE = process.argv.includes('--verbose');
const FORCE = process.argv.includes('--force');
const STATUS = process.argv.includes('--status');
const INSTALL = process.argv.includes('--install');
const UNINSTALL = process.argv.includes('--uninstall');

const BACKUP_DIR = path.join(HOME, '.config/mcp-sync/backups');
const LOG_FILE = path.join(HOME, '.config/mcp-sync/sync.log');

// ============= TOOL DEFINITIONS =============

const TOOLS = {
  cursor: {
    path: path.join(HOME, '.cursor/mcp.json'),
    label: 'Cursor',
  },
  claudeDesktop: {
    path: path.join(HOME, 'Library/Application Support/Claude/claude_desktop_config.json'),
    label: 'Claude Desktop',
  },
  vscode: {
    path: path.join(HOME, 'Library/Application Support/Code/User/mcp.json'),
    label: 'VS Code',
  },
  opencode: {
    path: path.join(HOME, '.config/opencode/opencode.json'),
    label: 'OpenCode',
  },
  codex: {
    path: path.join(HOME, '.codex/config.toml'),
    label: 'Codex',
  },
  claudeCode: {
    path: path.join(HOME, 'Documents/n8n/.mcp.json'),
    label: 'Claude Code (.mcp.json)',
  },
};

// Canonical name aliases (alternative name → canonical)
const NAME_ALIASES = {
  'mcp-n8n': 'n8n-dev',
};

// VS Code namespaced names → canonical short names
const VSCODE_TO_CANONICAL = {
  'io.github.upstash/context7': 'context7',
  'microsoft/markitdown': 'markitdown',
  'microsoft/playwright-mcp': 'playwright',
  'io.github.wonderwhy-er/desktop-commander': 'desktop-commander',
  'io.github.tavily-ai/tavily-mcp': 'tavily',
  'firecrawl/firecrawl-mcp-server': 'firecrawl',
  'oraios/serena': 'serena',
  'io.github.github/github-mcp-server': 'github-copilot-http',
};

// Reverse: canonical → VS Code namespaced name (for servers that had one)
const CANONICAL_TO_VSCODE = Object.fromEntries(
  Object.entries(VSCODE_TO_CANONICAL).map(([k, v]) => [v, k])
);

// Servers exclusive to specific tools (skip for all others)
const TOOL_EXCLUSIVE = {
  'github-copilot-http': ['vscode'], // HTTP transport, VS Code only
};

// Merge priority: first tool wins when configs conflict
const PRIORITY = ['cursor', 'claudeCode', 'vscode', 'opencode', 'codex', 'claudeDesktop'];

// ============= LOGGING =============

function log(msg) {
  const line = `[${new Date().toISOString()}] ${msg}`;
  console.log(msg);
  try {
    fs.mkdirSync(path.dirname(LOG_FILE), { recursive: true });
    fs.appendFileSync(LOG_FILE, line + '\n');
  } catch { /* ignore */ }
}

function verbose(msg) {
  if (VERBOSE) console.log(`  ${msg}`);
}

// ============= HELPERS =============

function readJsonSafe(filePath) {
  try {
    return JSON.parse(fs.readFileSync(filePath, 'utf8'));
  } catch (e) {
    if (e.code !== 'ENOENT') log(`  WARN: Cannot parse ${filePath}: ${e.message}`);
    return null;
  }
}

function canonicalize(name) {
  return NAME_ALIASES[name] || name;
}

function backup(filePath) {
  if (DRY_RUN || !fs.existsSync(filePath)) return;
  const ts = new Date().toISOString().replace(/[:.]/g, '-');
  const dest = path.join(BACKUP_DIR, ts, path.basename(filePath));
  fs.mkdirSync(path.dirname(dest), { recursive: true });
  fs.copyFileSync(filePath, dest);
  verbose(`Backup: ${dest}`);
}

function writeFile(filePath, content) {
  if (DRY_RUN) {
    log(`  [DRY RUN] Would write ${filePath}`);
    return;
  }
  fs.mkdirSync(path.dirname(filePath), { recursive: true });
  fs.writeFileSync(filePath, content, 'utf8');
}

// ============= READERS =============

/**
 * Cursor / Claude Desktop / .mcp.json format:
 * { "mcpServers": { "name": { "command", "args", "env" } } }
 */
function readMcpServersFormat(filePath) {
  const data = readJsonSafe(filePath);
  if (!data) return { servers: {}, raw: null };
  const mcpServers = data.mcpServers || {};
  const servers = {};
  for (const [name, cfg] of Object.entries(mcpServers)) {
    servers[canonicalize(name)] = {
      command: cfg.command,
      args: cfg.args || [],
      env: cfg.env || {},
    };
  }
  return { servers, raw: data };
}

/**
 * VS Code format:
 * { "servers": { "name": { "type", "command", "args", "env", "gallery", "version" } }, "inputs": [...] }
 */
function readVSCode(filePath) {
  const data = readJsonSafe(filePath);
  if (!data) return { servers: {}, meta: {}, inputs: [], raw: null };
  const raw = data.servers || {};
  const servers = {};
  const meta = {};

  for (const [name, cfg] of Object.entries(raw)) {
    const canonical = VSCODE_TO_CANONICAL[name] || canonicalize(name);

    // HTTP-only servers
    if (cfg.type === 'http') {
      servers[canonical] = { command: null, args: [], env: {}, _httpOnly: true, _url: cfg.url };
      meta[canonical] = { vscodeName: name, type: 'http', url: cfg.url, gallery: cfg.gallery, version: cfg.version };
      continue;
    }

    // Filter out ${input:...} placeholder env values
    const env = {};
    for (const [k, v] of Object.entries(cfg.env || {})) {
      if (typeof v === 'string' && v.startsWith('${input:')) continue;
      env[k] = v;
    }

    servers[canonical] = { command: cfg.command, args: cfg.args || [], env };
    meta[canonical] = {
      vscodeName: name,
      type: cfg.type || 'stdio',
      gallery: cfg.gallery,
      version: cfg.version,
    };
  }

  return { servers, meta, inputs: data.inputs || [], raw: data };
}

/**
 * OpenCode format:
 * { "$schema": "...", "mcp": { "name": { "type": "local", "command": ["cmd", ...args], "environment": {...} } } }
 */
function readOpenCode(filePath) {
  const data = readJsonSafe(filePath);
  if (!data) return { servers: {}, raw: null };
  const mcp = data.mcp || {};
  const servers = {};
  for (const [name, cfg] of Object.entries(mcp)) {
    const cmdArr = cfg.command || [];
    servers[canonicalize(name)] = {
      command: cmdArr[0] || '',
      args: cmdArr.slice(1),
      env: cfg.environment || {},
    };
  }
  return { servers, raw: data };
}

/**
 * Codex TOML format:
 * [mcp_servers.name]
 * command = "..."
 * args = [...]
 * [mcp_servers.name.env]
 * KEY = "value"
 */
function readCodex(filePath) {
  let text;
  try { text = fs.readFileSync(filePath, 'utf8'); } catch { return { servers: {}, text: '' }; }

  const lines = text.split('\n');
  const servers = {};
  let cur = null;
  let inEnv = false;

  for (const line of lines) {
    const t = line.trim();

    const envMatch = t.match(/^\[mcp_servers\.(.+?)\.env\]$/);
    if (envMatch) {
      cur = canonicalize(envMatch[1]);
      inEnv = true;
      if (!servers[cur]) servers[cur] = { command: '', args: [], env: {} };
      continue;
    }

    const srvMatch = t.match(/^\[mcp_servers\.([^\]]+)\]$/);
    if (srvMatch && !srvMatch[1].includes('.')) {
      cur = canonicalize(srvMatch[1]);
      inEnv = false;
      if (!servers[cur]) servers[cur] = { command: '', args: [], env: {} };
      continue;
    }

    if (t.startsWith('[')) { cur = null; inEnv = false; continue; }

    if (cur && t) {
      const kv = t.match(/^"?([^"=\s]+)"?\s*=\s*(.+)$/);
      if (kv) {
        const [, key, rawVal] = kv;
        if (inEnv) {
          servers[cur].env[key] = stripQuotes(rawVal.trim());
        } else if (key === 'command') {
          servers[cur].command = stripQuotes(rawVal.trim());
        } else if (key === 'args') {
          servers[cur].args = parseTomlArray(rawVal.trim());
        }
      }
    }
  }

  return { servers, text };
}

function stripQuotes(s) {
  if (s.startsWith('"') && s.endsWith('"')) return s.slice(1, -1);
  return s;
}

function parseTomlArray(raw) {
  const m = raw.match(/^\[(.*)\]$/s);
  if (!m) return [];
  const inner = m[1];
  const items = [];
  let buf = '', inQ = false;
  for (let i = 0; i < inner.length; i++) {
    const ch = inner[i];
    if (ch === '"' && (i === 0 || inner[i - 1] !== '\\')) {
      inQ = !inQ;
    } else if (ch === ',' && !inQ) {
      const v = buf.trim();
      if (v) items.push(v);
      buf = '';
    } else {
      buf += ch;
    }
  }
  const last = buf.trim();
  if (last) items.push(last);
  return items;
}

// ============= WRITERS =============

function writeCursorFormat(filePath, servers) {
  const mcpServers = {};
  for (const [name, cfg] of Object.entries(servers)) {
    mcpServers[name] = { command: cfg.command, args: cfg.args, env: cfg.env || {} };
  }
  writeFile(filePath, JSON.stringify({ mcpServers }, null, 2) + '\n');
}

function writeClaudeDesktop(filePath, servers, originalData = {}) {
  const mcpServers = {};
  for (const [name, cfg] of Object.entries(servers)) {
    const entry = { command: cfg.command, args: cfg.args };
    if (cfg.env && Object.keys(cfg.env).length > 0) entry.env = cfg.env;
    mcpServers[name] = entry;
  }
  const output = { mcpServers };
  if (originalData.preferences) output.preferences = originalData.preferences;
  writeFile(filePath, JSON.stringify(output, null, 2) + '\n');
}

function writeVSCode(filePath, servers, meta = {}, inputs = []) {
  const out = {};
  for (const [canonical, cfg] of Object.entries(servers)) {
    const vsName = meta[canonical]?.vscodeName || CANONICAL_TO_VSCODE[canonical] || canonical;
    const m = meta[canonical] || {};

    if (cfg._httpOnly) {
      out[vsName] = { type: 'http', url: cfg._url };
      if (m.gallery) out[vsName].gallery = m.gallery;
      if (m.version) out[vsName].version = m.version;
      continue;
    }

    const entry = { type: m.type || 'stdio', command: cfg.command, args: cfg.args };
    if (cfg.env && Object.keys(cfg.env).length > 0) entry.env = cfg.env;
    if (m.gallery) entry.gallery = m.gallery;
    if (m.version) entry.version = m.version;
    out[vsName] = entry;
  }

  const result = { servers: out };
  if (inputs.length > 0) result.inputs = inputs;
  writeFile(filePath, JSON.stringify(result, null, '\t') + '\n');
}

function writeOpenCode(filePath, servers, originalData = {}) {
  const mcp = {};
  for (const [name, cfg] of Object.entries(servers)) {
    const entry = { type: 'local', command: [cfg.command, ...cfg.args] };
    if (cfg.env && Object.keys(cfg.env).length > 0) entry.environment = cfg.env;
    mcp[name] = entry;
  }
  const output = {};
  if (originalData.$schema) output.$schema = originalData.$schema;
  output.mcp = mcp;
  writeFile(filePath, JSON.stringify(output, null, 2) + '\n');
}

function writeCodex(filePath, servers, existingText = '') {
  // Split existing TOML into: before mcp_servers | mcp_servers (discarded) | after mcp_servers
  const lines = existingText.split('\n');
  const before = [];
  const after = [];
  let state = 'before';

  for (const line of lines) {
    const t = line.trim();
    if (state === 'before') {
      if (t.match(/^\[mcp_servers[.\]]/)) {
        state = 'mcp';
      } else {
        before.push(line);
      }
    } else if (state === 'mcp') {
      if (t.startsWith('[') && !t.match(/^\[mcp_servers[.\]]/)) {
        state = 'after';
        after.push(line);
      }
      // skip mcp lines
    } else {
      after.push(line);
    }
  }

  // Trim trailing empty lines from before
  while (before.length > 0 && before[before.length - 1].trim() === '') before.pop();

  // Generate new mcp_servers TOML
  const mcpLines = [];
  for (const [name, cfg] of Object.entries(servers)) {
    mcpLines.push(`[mcp_servers.${name}]`);
    mcpLines.push(`command = ${tomlStr(cfg.command)}`);
    if (cfg.args && cfg.args.length > 0) {
      mcpLines.push(`args = [${cfg.args.map(a => tomlStr(a)).join(', ')}]`);
    }
    if (cfg.env && Object.keys(cfg.env).length > 0) {
      mcpLines.push('');
      mcpLines.push(`[mcp_servers.${name}.env]`);
      for (const [k, v] of Object.entries(cfg.env)) {
        mcpLines.push(`${k} = ${tomlStr(v)}`);
      }
    }
    mcpLines.push('');
  }

  const result = [...before, '', ...mcpLines, ...after].join('\n');
  writeFile(filePath, result);
}

function tomlStr(s) {
  return `"${String(s).replace(/\\/g, '\\\\').replace(/"/g, '\\"')}"`;
}

// ============= MERGE LOGIC =============

function mergeAll(toolServers) {
  const merged = {};
  const sources = {}; // track which tool contributed each server

  // Collect all unique server names
  const allNames = new Set();
  for (const servers of Object.values(toolServers)) {
    for (const name of Object.keys(servers)) allNames.add(name);
  }

  // For each server, pick config from highest-priority tool
  for (const name of allNames) {
    for (const tool of PRIORITY) {
      if (toolServers[tool]?.[name]) {
        merged[name] = toolServers[tool][name];
        sources[name] = tool;
        break;
      }
    }
  }

  return { merged, sources };
}

function serversForTool(merged, toolName, currentServers) {
  const result = FORCE ? {} : { ...currentServers };

  for (const [name, cfg] of Object.entries(merged)) {
    // Skip tool-exclusive servers
    const exclusive = TOOL_EXCLUSIVE[name];
    if (exclusive && !exclusive.includes(toolName)) continue;

    // Skip HTTP-only servers for non-VS Code tools
    if (cfg._httpOnly && toolName !== 'vscode') continue;

    // In default mode (no --force): only add missing servers
    if (!FORCE && result[name]) continue;

    result[name] = cfg;
  }

  return result;
}

// ============= LAUNCHD =============

const PLIST_LABEL = 'com.user.mcp-sync';
const PLIST_PATH = path.join(HOME, 'Library/LaunchAgents', `${PLIST_LABEL}.plist`);

function installLaunchd() {
  const nodePath = process.execPath;
  const scriptPath = path.resolve(process.argv[1]);

  const plist = `<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>${PLIST_LABEL}</string>
    <key>ProgramArguments</key>
    <array>
        <string>${nodePath}</string>
        <string>${scriptPath}</string>
    </array>
    <key>StartInterval</key>
    <integer>21600</integer>
    <key>StandardOutPath</key>
    <string>${LOG_FILE}</string>
    <key>StandardErrorPath</key>
    <string>${LOG_FILE}</string>
    <key>RunAtLoad</key>
    <true/>
    <key>EnvironmentVariables</key>
    <dict>
        <key>PATH</key>
        <string>/usr/local/bin:/usr/bin:/bin:/opt/homebrew/bin</string>
    </dict>
</dict>
</plist>`;

  fs.mkdirSync(path.dirname(PLIST_PATH), { recursive: true });
  fs.writeFileSync(PLIST_PATH, plist);
  log(`Installed: ${PLIST_PATH}`);
  try { execSync(`launchctl unload "${PLIST_PATH}" 2>/dev/null`, { stdio: 'ignore' }); } catch { /* ok */ }
  execSync(`launchctl load "${PLIST_PATH}"`);
  log('LaunchAgent loaded. Sync will run every 6 hours and on login.');
}

function uninstallLaunchd() {
  try { execSync(`launchctl unload "${PLIST_PATH}" 2>/dev/null`, { stdio: 'ignore' }); } catch { /* ok */ }
  try { fs.unlinkSync(PLIST_PATH); } catch { /* ok */ }
  log('LaunchAgent removed.');
}

// ============= STATUS =============

function showStatus(toolServers) {
  log('=== MCP Sync — Status ===\n');
  const allNames = new Set();
  for (const servers of Object.values(toolServers)) {
    for (const name of Object.keys(servers)) allNames.add(name);
  }
  const sorted = [...allNames].sort();

  // Header
  const labels = Object.values(TOOLS).map(t => t.label);
  const toolKeys = Object.keys(TOOLS);

  // Per-tool counts
  for (const key of toolKeys) {
    const t = TOOLS[key];
    const count = Object.keys(toolServers[key] || {}).length;
    const exists = fs.existsSync(t.path) ? '' : ' (file not found)';
    log(`  ${t.label}: ${count} servers${exists}`);
  }
  log(`\n  Total unique: ${sorted.length} servers\n`);

  // Matrix
  const pad = (s, n) => s.padEnd(n);
  const nameW = Math.max(25, ...sorted.map(s => s.length + 2));
  const colW = 9;

  let header = pad('Server', nameW);
  for (const key of toolKeys) header += pad(TOOLS[key].label.slice(0, colW - 1), colW);
  log(header);
  log('-'.repeat(header.length));

  for (const name of sorted) {
    let row = pad(name, nameW);
    for (const key of toolKeys) {
      row += pad(toolServers[key]?.[name] ? 'yes' : '-', colW);
    }
    log(row);
  }
}

// ============= MAIN =============

function main() {
  if (INSTALL) return installLaunchd();
  if (UNINSTALL) return uninstallLaunchd();

  log('=== MCP Sync ===');
  if (DRY_RUN) log('(dry run — no files will be modified)\n');
  if (FORCE) log('(force mode — existing servers will be overwritten)\n');

  // ---- READ ----
  log('Reading configs...');

  const cursorData = readMcpServersFormat(TOOLS.cursor.path);
  const claudeDesktopData = readMcpServersFormat(TOOLS.claudeDesktop.path);
  const vscodeData = readVSCode(TOOLS.vscode.path);
  const opencodeData = readOpenCode(TOOLS.opencode.path);
  const codexData = readCodex(TOOLS.codex.path);
  const claudeCodeData = readMcpServersFormat(TOOLS.claudeCode.path);

  const toolServers = {
    cursor: cursorData.servers,
    claudeDesktop: claudeDesktopData.servers,
    vscode: vscodeData.servers,
    opencode: opencodeData.servers,
    codex: codexData.servers,
    claudeCode: claudeCodeData.servers,
  };

  for (const [key, srv] of Object.entries(toolServers)) {
    log(`  ${TOOLS[key].label}: ${Object.keys(srv).length} servers`);
  }

  if (STATUS) return showStatus(toolServers);

  // ---- MERGE ----
  const { merged, sources } = mergeAll(toolServers);
  log(`\nMerged: ${Object.keys(merged).length} unique servers`);

  for (const [name, tool] of Object.entries(sources)) {
    const exclusive = TOOL_EXCLUSIVE[name];
    const note = exclusive ? ` (${exclusive.join(',')} only)` : '';
    const http = merged[name]._httpOnly ? ' [HTTP]' : '';
    verbose(`  ${name} ← ${TOOLS[tool]?.label || tool}${http}${note}`);
  }

  // ---- SYNC & WRITE ----
  log('\nSyncing...');
  const changes = {};

  // Cursor
  {
    const target = serversForTool(merged, 'cursor', cursorData.servers);
    const added = Object.keys(target).filter(n => !cursorData.servers[n]);
    changes.cursor = added;
    if (added.length > 0 || FORCE) {
      backup(TOOLS.cursor.path);
      writeCursorFormat(TOOLS.cursor.path, target);
      log(`  Cursor: +${added.length} servers${added.length ? ' (' + added.join(', ') + ')' : ''}`);
    } else {
      log('  Cursor: up to date');
    }
  }

  // Claude Desktop
  {
    const target = serversForTool(merged, 'claudeDesktop', claudeDesktopData.servers);
    const added = Object.keys(target).filter(n => !claudeDesktopData.servers[n]);
    changes.claudeDesktop = added;
    if (added.length > 0 || FORCE) {
      backup(TOOLS.claudeDesktop.path);
      writeClaudeDesktop(TOOLS.claudeDesktop.path, target, claudeDesktopData.raw || {});
      log(`  Claude Desktop: +${added.length} servers${added.length ? ' (' + added.join(', ') + ')' : ''}`);
    } else {
      log('  Claude Desktop: up to date');
    }
  }

  // VS Code
  {
    const target = serversForTool(merged, 'vscode', vscodeData.servers);
    const added = Object.keys(target).filter(n => !vscodeData.servers[n]);
    changes.vscode = added;
    if (added.length > 0 || FORCE) {
      backup(TOOLS.vscode.path);
      writeVSCode(TOOLS.vscode.path, target, vscodeData.meta, vscodeData.inputs);
      log(`  VS Code: +${added.length} servers${added.length ? ' (' + added.join(', ') + ')' : ''}`);
    } else {
      log('  VS Code: up to date');
    }
  }

  // OpenCode
  {
    const target = serversForTool(merged, 'opencode', opencodeData.servers);
    const added = Object.keys(target).filter(n => !opencodeData.servers[n]);
    changes.opencode = added;
    if (added.length > 0 || FORCE) {
      backup(TOOLS.opencode.path);
      writeOpenCode(TOOLS.opencode.path, target, opencodeData.raw || {});
      log(`  OpenCode: +${added.length} servers${added.length ? ' (' + added.join(', ') + ')' : ''}`);
    } else {
      log('  OpenCode: up to date');
    }
  }

  // Codex
  {
    const target = serversForTool(merged, 'codex', codexData.servers);
    const added = Object.keys(target).filter(n => !codexData.servers[n]);
    changes.codex = added;
    if (added.length > 0 || FORCE) {
      backup(TOOLS.codex.path);
      writeCodex(TOOLS.codex.path, target, codexData.text);
      log(`  Codex: +${added.length} servers${added.length ? ' (' + added.join(', ') + ')' : ''}`);
    } else {
      log('  Codex: up to date');
    }
  }

  // Claude Code (.mcp.json)
  {
    const target = serversForTool(merged, 'claudeCode', claudeCodeData.servers);
    const added = Object.keys(target).filter(n => !claudeCodeData.servers[n]);
    changes.claudeCode = added;
    if (added.length > 0 || FORCE) {
      backup(TOOLS.claudeCode.path);
      writeCursorFormat(TOOLS.claudeCode.path, target);
      log(`  Claude Code: +${added.length} servers${added.length ? ' (' + added.join(', ') + ')' : ''}`);
    } else {
      log('  Claude Code: up to date');
    }
  }

  const totalAdded = Object.values(changes).reduce((s, a) => s + a.length, 0);
  log(`\nDone! ${totalAdded} server entries added across all tools.`);
  if (DRY_RUN) log('(No files were modified — run without --dry-run to apply)');
}

main();
