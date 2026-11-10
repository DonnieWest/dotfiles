import type { ExtensionAPI, ExtensionCommandContext, SessionEntry } from "@earendil-works/pi-coding-agent";

interface CheckpointData {
	name: string;
	entryId: string;
	createdAt: string;
}

function checkpoints(ctx: ExtensionCommandContext): CheckpointData[] {
	return ctx.sessionManager
		.getEntries()
		.flatMap((entry: SessionEntry) => {
			if (entry.type !== "custom" || entry.customType !== "workflow-checkpoint") return [];
			const data = entry.data as Partial<CheckpointData> | undefined;
			return data?.name && data.entryId ? [data as CheckpointData] : [];
		})
		.toReversed();
}

export default function checkpointExtension(pi: ExtensionAPI): void {
	pi.registerCommand("checkpoint", {
		description: "Bookmark the current conversation state",
		handler: async (args, ctx) => {
			const entryId = ctx.sessionManager.getLeafId();
			if (!entryId) {
				ctx.ui.notify("There is no conversation entry to checkpoint.", "error");
				return;
			}
			const name = args.trim() || `checkpoint-${new Date().toISOString().slice(11, 19).replaceAll(":", "")}`;
			pi.setLabel(entryId, name);
			pi.appendEntry("workflow-checkpoint", { name, entryId, createdAt: new Date().toISOString() } satisfies CheckpointData);
			ctx.ui.notify(`Checkpoint created: ${name}`, "info");
		},
	});

	pi.registerCommand("checkpoints", {
		description: "List conversation checkpoints",
		handler: async (_args, ctx) => {
			const saved = checkpoints(ctx);
			ctx.ui.notify(
				saved.length ? saved.map((item) => `${item.name} · ${item.createdAt}`).join("\n") : "No checkpoints in this session.",
				"info",
			);
		},
	});

	pi.registerCommand("rewind", {
		description: "Rewind conversation context to a checkpoint without reverting files",
		handler: async (args, ctx) => {
			const saved = checkpoints(ctx);
			if (saved.length === 0) {
				ctx.ui.notify("No checkpoints in this session.", "error");
				return;
			}

			const requested = args.trim();
			let selected = requested ? saved.find((item) => item.name === requested) : undefined;
			if (!selected) {
				const name = await ctx.ui.select("Rewind to checkpoint (files will not be changed)", saved.map((item) => item.name));
				selected = saved.find((item) => item.name === name);
			}
			if (!selected) return;

			const confirmed = await ctx.ui.confirm(
				"Rewind conversation?",
				`Return to ${selected.name}. Files in the working tree will remain unchanged.`,
			);
			if (!confirmed) return;

			await ctx.navigateTree(selected.entryId, {
				summarize: true,
				customInstructions:
					"Summarize decisions, changed files, verification results, and unresolved work from the abandoned branch. Do not imply that filesystem changes were reverted.",
				label: `rewound-from-${selected.name}`,
			});
		},
	});
}
