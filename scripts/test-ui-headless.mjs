import { chromium } from "playwright";

(async () => {
  const browser = await chromium.launch();
  const page = await browser.newPage();

  const errors = [];
  page.on("console", (msg) => {
    if (msg.type() === "error") {
      errors.push(`[Console Error] ${msg.text()}`);
    }
  });
  page.on("pageerror", (err) => {
    errors.push(`[Page Error] ${err.toString()}`);
  });

  try {
    console.log("Navigating to http://127.0.0.1:18789/ ...");
    await page.goto("http://127.0.0.1:18789/", { waitUntil: "networkidle" });

    const title = await page.title();
    console.log(`Page Title: ${title}`);

    const paddyApp = await page.$("paddy-app");
    if (paddyApp) {
      console.log("Found <paddy-app> component.");
    } else {
      console.error("ERROR: <paddy-app> component NOT found.");
      errors.push("<paddy-app> component missing from DOM");
    }

    // Check if the error logger div (red box) is present
    const errorDiv = await page.evaluate(() => {
      const div = document.querySelector('div[style*="fixed"][style*="red"]');
      return div ? div.innerText : null;
    });

    if (errorDiv) {
      console.error("Found on-screen error box:");
      console.error(errorDiv);
      errors.push(`On-screen error: ${errorDiv}`);
    }

    if (errors.length > 0) {
      console.error("\nErrors detected during page load:");
      errors.forEach((e) => console.error(e));
      process.exit(1);
    } else {
      console.log("\nSUCCESS: UI loaded without errors.");
    }
  } catch (error) {
    console.error("Test failed:", error);
    process.exit(1);
  } finally {
    await browser.close();
  }
})();
