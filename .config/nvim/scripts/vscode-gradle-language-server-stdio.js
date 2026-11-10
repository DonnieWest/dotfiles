#!/usr/bin/env node

const fs = require("fs");
const net = require("net");
const os = require("os");
const path = require("path");
const { spawn } = require("child_process");

const serverPath = process.argv[2];

if (!serverPath) {
  console.error("Usage: vscode-gradle-language-server-stdio.js <gradle-language-server>");
  process.exit(1);
}

function javaMajor(javaHome) {
  try {
    const java = path.join(javaHome, "bin", "java");
    if (!fs.existsSync(java)) return null;
    const result = spawn(java, ["-version"], { stdio: ["ignore", "pipe", "pipe"] });
    let output = "";
    result.stderr.on("data", (data) => {
      output += data.toString();
    });
    return new Promise((resolve) => {
      result.on("close", () => {
        const match = output.match(/version "([0-9]+)/);
        resolve(match ? match[1] : null);
      });
    });
  } catch {
    return Promise.resolve(null);
  }
}

async function selectJavaHome() {
  const candidates = [
    process.env.JAVA_HOME,
    "/opt/homebrew/opt/openjdk@21/libexec/openjdk.jdk/Contents/Home",
    "/opt/homebrew/opt/openjdk@17/libexec/openjdk.jdk/Contents/Home",
  ].filter(Boolean);

  for (const candidate of candidates) {
    const major = await javaMajor(candidate);
    if (major === "21" || major === "17") return candidate;
  }

  return process.env.JAVA_HOME;
}

(async function main() {
  const socketPath = path.join(os.tmpdir(), `nvim-vscode-gradle-${process.pid}.sock`);
  try {
    fs.unlinkSync(socketPath);
  } catch {
  }

  const javaHome = await selectJavaHome();
  const env = { ...process.env };
  if (javaHome) env.JAVA_HOME = javaHome;

  let child;
  const listener = net.createServer((socket) => {
    process.stdin.pipe(socket);
    socket.pipe(process.stdout);

    socket.on("close", () => process.exit(0));
    socket.on("error", (error) => {
      console.error(error.message);
      process.exit(1);
    });
  });

  listener.on("error", (error) => {
    console.error(error.message);
    process.exit(1);
  });

  listener.listen(socketPath, () => {
    child = spawn(serverPath, [socketPath], { env, stdio: ["ignore", "ignore", "pipe"] });
    child.stderr.pipe(process.stderr);
    child.on("exit", (code) => {
      process.exit(code || 0);
    });
  });

  process.on("exit", () => {
    if (child) child.kill();
    try {
      fs.unlinkSync(socketPath);
    } catch {
    }
  });
})();
