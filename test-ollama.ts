
import { streamSimple } from "@mariozechner/pi-ai";

async function test() {
    const model = {
        provider: "ollama",
        id: "llama3.2:3b",
        baseUrl: "http://127.0.0.1:11434/v1",
        api: "openai-responses", // Try chat API first
        apiKey: "ollama"
    };

    const context = {
        messages: [
            { role: "user", content: "say hello" }
        ]
    };

    console.log("Starting stream...");
    try {
        const response = await streamSimple(model, context, { apiKey: "ollama" });
        for await (const event of response) {
            console.log("Event:", JSON.stringify(event));
        }
        const result = await response.result();
        console.log("Final Result:", JSON.stringify(result));
    } catch (err) {
        console.error("Error:", err);
    }
}

test();
