#!/usr/bin/env node

const fs = require('fs');
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

const program = ts.createProgram([fileName], compilerOptions(fileName));
const file = program.getSourceFile(fileName);
if (!file) process.exit(0);

const context = new lit.DefaultLitAnalyzerContext({getProgram: () => program});
context.updateConfig(lit.makeConfig({strict: true}));
const diagnostics = new lit.LitAnalyzer(context).getDiagnosticsInFile(file);

for (const diagnostic of diagnostics) {
  const position = file.getLineAndCharacterOfPosition(diagnostic.location.start);
  const message = diagnostic.message.replace(/\s+/g, ' ').trim();
  console.log(`${position.line + 1}:${position.character} ${diagnostic.severity} ${message}`);
}
