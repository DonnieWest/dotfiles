import { mkdir, readFile, writeFile } from "node:fs/promises";
import { homedir } from "node:os";
import { dirname, join } from "node:path";
import type { ThinkingLevel } from "@earendil-works/pi-agent-core";
import type { ExtensionAPI, ExtensionContext } from "@earendil-works/pi-coding-agent";

const ROLES = ["default", "fast", "deep", "plan", "review", "advisor"] as const;
type Role = (typeof ROLES)[number];

interface RoleConfig {
	provider: string;
	model: string;
	thinking: ThinkingLevel;
}

type RoleMap = Partial<Record<Role, RoleConfig>>;

function configPath(): string {
	return join(process.env.PI_CODING_AGENT_DIR || join(homedir(), ".pi", "agent"), "model-roles.json");
}

async function loadRoles(): Promise<RoleMap> {
	try {
		return JSON.parse(await readFile(configPath(), "utf8")) as RoleMap;
	} catch (error) {
		if ((error as NodeJS.ErrnoException).code === "ENOENT") return {};
		throw error;
	}
}

async function saveRoles(roles: RoleMap): Promise<void> {
	const path = configPath();
	await mkdir(dirname(path), { recursive: true });
	await writeFile(path, `${JSON.stringify(roles, null, 2)}\n`, { encoding: "utf8", mode: 0o600 });
}

function isRole(value: string): value is Role {
	return (ROLES as readonly string[]).includes(value);
}

export default function modelRolesExtension(pi: ExtensionAPI): void {
	let roles: RoleMap = {};
	let currentRole: Role = "default";
	let latestContext: ExtensionContext | undefined;

	async function applyRole(
		role: Role,
		ctx: ExtensionContext,
		options: { notify: boolean } = { notify: true },
	): Promise<boolean> {
		const config = roles[role];
		if (!config) {
			if (options.notify) ctx.ui.notify(`Role ${role} is not configured. Use /role set ${role}.`, "warning");
			return false;
		}
		const model = ctx.modelRegistry.find(config.provider, config.model);
		if (!model || !(await pi.setModel(model))) {
			if (options.notify) ctx.ui.notify(`Model unavailable for ${role}: ${config.provider}/${config.model}`, "error");
			return false;
		}
		pi.setThinkingLevel(config.thinking);
		currentRole = role;
		ctx.ui.setStatus("model-role", ctx.ui.theme.fg("muted", `◈ ${role}`));
		if (options.notify) ctx.ui.notify(`Role ${role}: ${config.provider}/${config.model} · ${config.thinking}`, "info");
		return true;
	}

	pi.registerCommand("role", {
		description: "Select or configure model roles: default, fast, deep, plan, review, advisor",
		handler: async (args, ctx) => {
			const [action, roleArg] = args.trim().split(/\s+/, 2);
			if (action === "status") {
				ctx.ui.notify(
					ROLES.map((role) => {
						const config = roles[role];
						if (!config) return `○ ${role}: not configured`;
						const marker = role === currentRole ? "●" : "○";
						return `${marker} ${role}: ${config.provider}/${config.model} · ${config.thinking}`;
					}).join("\n"),
					"info",
				);
				return;
			}

			if (action === "set") {
				if (!roleArg || !isRole(roleArg) || !ctx.model) {
					ctx.ui.notify("Usage: /role set <default|fast|deep|plan|review|advisor>", "error");
					return;
				}
				roles[roleArg] = { provider: ctx.model.provider, model: ctx.model.id, thinking: pi.getThinkingLevel() };
				await saveRoles(roles);
				currentRole = roleArg;
				ctx.ui.setStatus("model-role", ctx.ui.theme.fg("muted", `◈ ${roleArg}`));
				ctx.ui.notify(`Saved the current model as role ${roleArg}.`, "info");
				return;
			}

			if (action === "clear") {
				if (!roleArg || !isRole(roleArg)) {
					ctx.ui.notify("Usage: /role clear <role>", "error");
					return;
				}
				delete roles[roleArg];
				await saveRoles(roles);
				ctx.ui.notify(`Cleared role ${roleArg}.`, "info");
				return;
			}

			let requested = action;
			if (!requested) {
				requested = await ctx.ui.select(
					"Model role",
					ROLES.map((role) => {
						const config = roles[role];
						return `${role}${config ? ` — ${config.provider}/${config.model}` : " — not configured"}`;
					}),
				);
				requested = requested?.split(" — ", 1)[0] ?? "";
			}
			if (!isRole(requested)) {
				ctx.ui.notify("Usage: /role [role|set role|clear role|status]", "error");
				return;
			}
			await applyRole(requested, ctx);
		},
	});

	pi.events.on("plan-mode:state", (state) => {
		const mode = (state as { mode?: string }).mode;
		let role: Role | undefined;
		if (mode === "plan") role = "plan";
		if (mode === "review") role = "review";
		if ((mode === "build" || mode === "idle") && (currentRole === "plan" || currentRole === "review")) {
			role = "default";
		}
		if (role && roles[role] && latestContext && currentRole !== role) {
			void applyRole(role, latestContext, { notify: false });
		}
	});

	pi.on("session_start", async (_event, ctx) => {
		latestContext = ctx;
		roles = await loadRoles();
		if (!roles.default && ctx.model) {
			roles.default = { provider: ctx.model.provider, model: ctx.model.id, thinking: pi.getThinkingLevel() };
			await saveRoles(roles);
		}
		ctx.ui.setStatus("model-role", ctx.ui.theme.fg("muted", `◈ ${currentRole}`));
	});

	pi.on("session_shutdown", () => {
		latestContext = undefined;
	});
}
