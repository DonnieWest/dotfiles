import { uuidv7 } from "@earendil-works/pi-ai";
import { convertToLlm, serializeConversation, type ExtensionAPI } from "@earendil-works/pi-coding-agent";

const UNSUPPORTED_MODES = new Set(["remote", "snapcompact", "shake", "handoff", "notes"]);

const SUMMARY_INSTRUCTIONS = `Create a compact, continuation-ready technical handoff. Use exactly these headings:

## Goal
## Decisions
## Current state
## Files and changes
## Validation
## Open questions and risks
## Next steps

Record only facts established in the conversation. Preserve exact paths, commands, failures, constraints, and uncompleted work. Do not claim that unverified work succeeded.`;

export default function compactionPlusExtension(pi: ExtensionAPI): void {
	pi.registerCommand("compact-plus", {
		description: "Structured compaction: /compact-plus [focus], /compact-plus soft [focus], /compact-plus structured [focus], or /compact-plus status",
		handler: async (args, ctx) => {
			const [mode = "", ...rest] = args.trim().split(/\s+/);
			if (mode === "status") {
				const usage = ctx.getContextUsage();
				ctx.ui.notify(
					usage
						? `Structured soft compaction is active. Context: ${usage.tokens.toLocaleString()} tokens (${usage.percent ?? "unknown"}%).`
						: "Structured soft compaction is active. Context usage is not available yet.",
					"info",
				);
				return;
			}
			if (UNSUPPORTED_MODES.has(mode)) {
				ctx.ui.notify(
					`${mode} compaction requires OMP core and is not available in Pi. Use /compact-plus soft or /compact-plus structured instead.`,
					"warning",
				);
				return;
			}

			const focus = mode === "soft" || mode === "structured" ? rest.join(" ") : args.trim();
			ctx.compact({
				customInstructions: focus || undefined,
				onComplete: () => ctx.ui.notify("Context compaction completed.", "info"),
				onError: (error) => ctx.ui.notify(`Context compaction failed: ${error.message}`, "error"),
			});
		},
	});

	pi.on("session_before_compact", async (event, ctx) => {
		if (!ctx.model) return;

		const { preparation, signal } = event;
		const messages = [...preparation.messagesToSummarize, ...preparation.turnPrefixMessages];
		if (messages.length === 0) return;

		const previousSummary = preparation.previousSummary
			? `\n\nPrevious summary to update:\n${preparation.previousSummary}`
			: "";
		const conversation = serializeConversation(convertToLlm(messages));
		const focus = event.customInstructions ? `\n\nAdditional focus: ${event.customInstructions}` : "";

		try {
			const response = await ctx.modelRegistry.complete(
				ctx.model,
				{
					messages: [{
						role: "user",
						content: [{
							type: "text",
							text: `${SUMMARY_INSTRUCTIONS}${previousSummary}${focus}\n\nConversation to compact:\n<conversation>\n${conversation}\n</conversation>`,
						}],
						timestamp: Date.now(),
					}],
				},
				{ maxTokens: 8_192, signal, cacheRetention: "none", sessionId: uuidv7() },
			);
			const summary = response.content
				.filter((part): part is { type: "text"; text: string } => part.type === "text")
				.map((part) => part.text)
				.join("\n")
				.trim();
			if (!summary) return;

			return {
				compaction: {
					summary,
					firstKeptEntryId: preparation.firstKeptEntryId,
					tokensBefore: preparation.tokensBefore,
					usage: response.usage,
					details: { strategy: "structured-soft" },
				},
			};
		} catch {
			// Fall back to Pi's built-in compactor on provider or cancellation errors.
			return;
		}
	});
}
