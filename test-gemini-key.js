
const apiKey = "AIzaSyAb8-wPyEsaTi7Rv4FtDhRpqzlblBzV_AA";
const model = "gemini-1.5-flash"; // Standard Gemini name for test

async function testKey() {
    try {
        const url = `https://generativelanguage.googleapis.com/v1beta/models/${model}:generateContent?key=${apiKey}`;
        const response = await fetch(url, {
            method: "POST",
            headers: {
                "Content-Type": "application/json"
            },
            body: JSON.stringify({
                contents: [{ parts: [{ text: "hi" }] }]
            })
        });
        const data = await response.json();
        console.log(JSON.stringify(data, null, 2));
    } catch (e) {
        console.error(e);
    }
}

testKey();
