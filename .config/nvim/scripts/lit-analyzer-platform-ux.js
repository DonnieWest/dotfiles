#!/usr/bin/env node

const fs = require('fs');
const os = require('os');
const path = require('path');

const analyzerRoot = process.argv[2];
const fileName = path.resolve(process.argv[3] || '');

if (!analyzerRoot || !fileName || !fs.existsSync(fileName)) process.exit(0);

const sourceText = fs.readFileSync(fileName, 'utf8');
if (!/(?:from\s*['"](?:lit|lit-element|lit-html)(?:\/[^'"]*)?['"]|\bLitElement\b)/.test(sourceText)) {
  process.exit(0);
}

const lit = require(analyzerRoot);
const ts = require(path.join(analyzerRoot, 'node_modules/typescript'));
const wca = require(path.join(analyzerRoot, 'node_modules/web-component-analyzer'));

function findUp(start, name) {
  let dir = path.dirname(start);
  while (true) {
    const candidate = path.join(dir, name);
    if (fs.existsSync(candidate)) return candidate;
    const parent = path.dirname(dir);
    if (parent === dir) return undefined;
    dir = parent;
  }
}

function platformRoot(start) {
  const git = findUp(start, '.git');
  if (!git) return undefined;
  const root = path.dirname(git);
  const manifest = path.join(root, 'package.json');
  if (!fs.existsSync(manifest)) return undefined;
  return JSON.parse(fs.readFileSync(manifest, 'utf8')).name === '@banno/platform-ux' ? root : undefined;
}

function packageRoot(root, workspace, packageName) {
  const relative = packageName.split('/');
  for (const base of [workspace, root]) {
    const candidate = path.join(base, 'node_modules', ...relative, 'package.json');
    if (fs.existsSync(candidate)) return path.dirname(candidate);
  }
  return undefined;
}

function walkJs(root, files = []) {
  if (!root || !fs.existsSync(root)) return files;
  for (const entry of fs.readdirSync(root, {withFileTypes: true})) {
    if (entry.name === 'node_modules' || entry.name === 'test' || entry.name === 'demo') continue;
    const fullPath = path.join(root, entry.name);
    if (entry.isDirectory()) walkJs(fullPath, files);
    else if (entry.name.endsWith('.js')) files.push(fullPath);
  }
  return files;
}

function mergeCustomData(target, incoming) {
  const tags = new Map((target.tags || []).map((tag) => [tag.name, tag]));
  for (const tag of incoming.tags || []) {
    const existing = tags.get(tag.name);
    if (!existing) {
      tags.set(tag.name, tag);
      continue;
    }
    const attrs = new Map((existing.attributes || []).map((attr) => [attr.name, attr]));
    for (const attr of tag.attributes || []) attrs.set(attr.name, attr);
    existing.attributes = [...attrs.values()];
    if (!existing.description && tag.description) existing.description = tag.description;
  }
  target.tags = [...tags.values()];
  for (const tag of target.tags) {
    const attrs = new Map();
    for (const attr of tag.attributes || []) {
      attrs.set(attr.name, attr);
      attrs.set(attr.name.toLowerCase(), {...attr, name: attr.name.toLowerCase()});
      const kebab = attr.name.replace(/[A-Z]/g, (letter) => `-${letter.toLowerCase()}`);
      attrs.set(kebab, {...attr, name: kebab});
    }
    tag.attributes = [...attrs.values()];
  }
  return target;
}

function analyzeRoots(roots) {
  const files = roots.flatMap((root) => walkJs(root));
  if (files.length === 0) return {version: 1, tags: [], globalAttributes: [], valueSets: []};
  const input = files.map((name) => ({fileName: name, text: fs.readFileSync(name, 'utf8')}));
  const {results, program} = wca.analyzeText(input);
  return JSON.parse(wca.transformAnalyzerResult('vscode', results, program));
}

function localTags(roots) {
  const names = new Set();
  const literalDefine = /customElements\.define\(\s*['"]([a-z0-9-]+)['"]/g;
  const staticIs = /static\s+get\s+is\s*\(\s*\)\s*{\s*return\s+['"]([a-z0-9-]+)['"]/g;
  for (const file of roots.flatMap((root) => walkJs(root))) {
    const text = fs.readFileSync(file, 'utf8');
    for (const pattern of [literalDefine, staticIs]) {
      pattern.lastIndex = 0;
      for (let match; (match = pattern.exec(text)); ) names.add(match[1]);
    }
  }
  return [...names].map((name) => ({name, attributes: []}));
}

function externalData(root, workspace) {
  const packages = ['@banno/jha-wc', '@jack-henry/jh-elements'];
  const packageRoots = packages.map((name) => packageRoot(root, workspace, name)).filter(Boolean);
  const signature = `v2-${packageRoots
    .map((dir) => {
      const pkg = JSON.parse(fs.readFileSync(path.join(dir, 'package.json'), 'utf8'));
      return `${pkg.name}@${pkg.version}`;
    })
    .join('-') || 'empty'}`;
  const cacheDir = path.join(process.env.XDG_CACHE_HOME || path.join(os.homedir(), '.cache'), 'nvim', 'lit-analyzer');
  const cacheFile = path.join(cacheDir, `${signature.replace(/[^a-zA-Z0-9_.-]/g, '_')}.json`);
  if (fs.existsSync(cacheFile)) return JSON.parse(fs.readFileSync(cacheFile, 'utf8'));

  let data = {version: 1, tags: [], globalAttributes: [], valueSets: []};
  for (const dir of packageRoots) {
    const roots = [path.join(dir, 'src'), path.join(dir, 'components'), path.join(dir, 'dist', 'migration')];
    data = mergeCustomData(data, analyzeRoots(roots));
  }
  fs.mkdirSync(cacheDir, {recursive: true});
  fs.writeFileSync(cacheFile, JSON.stringify(data));
  return data;
}

function compilerOptions(start) {
  const configPath = ts.findConfigFile(path.dirname(start), fs.existsSync, 'tsconfig.json');
  if (configPath) {
    const config = ts.readConfigFile(configPath, (name) => fs.readFileSync(name, 'utf8'));
    const parsed = ts.parseJsonConfigFileContent(config.config, ts.sys, path.dirname(configPath));
    return {...parsed.options, noEmit: true, allowJs: true, strictNullChecks: true, skipLibCheck: true};
  }
  return {
    allowJs: true,
    noEmit: true,
    strictNullChecks: true,
    skipLibCheck: true,
    experimentalDecorators: true,
    target: ts.ScriptTarget.Latest,
    module: ts.ModuleKind.ESNext,
    moduleResolution: ts.ModuleResolutionKind.NodeJs,
    lib: ['lib.esnext.d.ts', 'lib.dom.d.ts'],
  };
}

const root = platformRoot(fileName);
if (!root) {
  require('./lit-analyzer.js');
  process.exit(0);
}

const workspace = fileName.startsWith(path.join(root, 'projects', 'people'))
  ? path.join(root, 'projects', 'people')
  : path.dirname(fileName);
const program = ts.createProgram([fileName], compilerOptions(fileName));
const file = program.getSourceFile(fileName);
if (!file) process.exit(0);

let customData = externalData(root, workspace);
customData = mergeCustomData(customData, {
  version: 1,
  tags: localTags([
    path.join(root, 'projects', 'people', 'src', 'components'),
    path.join(root, 'projects', 'shared', 'components', 'polymer3'),
  ]),
});
customData = mergeCustomData(customData, {
  version: 1,
  tags: [
    {name: 'jha-wc-tabs', attributes: []},
    {name: 'jha-chip', attributes: [{name: 'pill'}]},
    {name: 'jha-wc-card', attributes: [{name: 'wide'}]},
    {name: 'jha-wc-tab-item', attributes: [{name: 'active', valueSet: 'v'}]},
  ],
});

const context = new lit.DefaultLitAnalyzerContext({getProgram: () => program});
context.updateConfig(lit.makeConfig({
  strict: true,
  customHtmlData: [customData],
  rules: {'no-missing-import': 'off', 'no-unknown-property': 'off'},
}));
const diagnostics = new lit.LitAnalyzer(context).getDiagnosticsInFile(file);

for (const diagnostic of diagnostics) {
  const position = file.getLineAndCharacterOfPosition(diagnostic.location.start);
  const message = diagnostic.message.replace(/\s+/g, ' ').trim();
  console.log(`${position.line + 1}:${position.character} ${diagnostic.severity} ${message}`);
}
