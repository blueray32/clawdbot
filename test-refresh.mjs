
import { ensureAuthProfileStore, resolveApiKeyForProfile } from "./dist/agents/auth-profiles.js";

async function main() {
    try {
        const store = ensureAuthProfileStore();
        const profileId = "google-antigravity:ciarancoxliverpool@gmail.com";
        console.log(`Attempting to resolve profile: ${profileId}`);

        const result = await resolveApiKeyForProfile({
            store,
            profileId,
        });

        if (result) {
            console.log("Success! Resolved API key (truncated):", result.apiKey.substring(0, 20) + "...");
        } else {
            console.log("Failed: resolveApiKeyForProfile returned null.");
        }
    } catch (err) {
        console.error("Caught error during resolution:");
        console.error(err);
    }
}

main();
