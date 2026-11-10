import type { ExtensionAPI, ExtensionContext } from "@earendil-works/pi-coding-agent";

const dangerousCommands: Array<[RegExp, string]> = [
  [/\bsudo\b/i, "privileged command"],
  [/\brm\b[^\n;&|]*(?:-[a-z]*r[a-z]*f|-[a-z]*f[a-z]*r|--recursive|--force)/i, "recursive/forced deletion"],
  [/\bgit\s+(?:reset\s+--hard|clean\s+-[^\s]*[fdx]|push\b[^\n]*--force|branch\s+-D|checkout\s+--\s|restore\b[^\n]*--worktree)/i, "destructive Git operation"],
  [/\b(?:npm|pnpm|yarn)\s+(?:publish|unpublish)\b/i, "package publication"],
  [/\b(?:gh\s+release|git\s+tag)\b/i, "release or tag operation"],
  [/\b(?:chmod|chown)\b[^\n]*(?:-R|777)\b/i, "broad permission change"],
  [/\b(?:killall|pkill|shutdown|reboot)\b/i, "process/system disruption"],
  [/\b(?:dd|mkfs|diskutil\s+erase)\b/i, "disk operation"],
];

const sensitivePath = /(?:^|\/)(?:\.env(?:\..*)?|\.git(?:\/|$)|\.ssh(?:\/|$)|\.aws(?:\/|$)|\.gnupg(?:\/|$)|.*(?:credential|secret|token|private[-_]?key).*)/i;
const approvedSensitivePaths = new Set<string>();

async function approve(ctx: ExtensionContext, title: string, detail: string): Promise<boolean> {
  if (!ctx.hasUI) return false;
  return ctx.ui.confirm(title, detail);
}

export default function (pi: ExtensionAPI) {
  let approvalMode = "yolo";

  pi.events.on("approval-mode:state", (state) => {
    approvalMode = (state as { mode?: string }).mode ?? "yolo";
  });

  pi.on("tool_call", async (event, ctx) => {
    if (approvalMode !== "yolo") return;

    if (event.toolName === "bash") {
      const command = String((event.input as { command?: unknown }).command ?? "");
      const match = dangerousCommands.find(([pattern]) => pattern.test(command));
      if (match && !(await approve(ctx, `Confirm ${match[1]}`, command))) {
        return { block: true, reason: `${match[1]} was not approved by the user` };
      }
      return;
    }

    if (event.toolName === "write" || event.toolName === "edit") {
      const path = String((event.input as { path?: unknown }).path ?? "");
      if (sensitivePath.test(path) && !approvedSensitivePaths.has(path)) {
        if (!(await approve(ctx, "Confirm sensitive file change", path))) {
          return { block: true, reason: `Change to sensitive path ${path} was not approved by the user` };
        }
        approvedSensitivePaths.add(path);
      }
    }
  });
}
