// 全ロケール × デバイス × スライドを ../screenshots/ に書き出す。
// 事前に `pnpm dev` を起動しておくこと（BASE_URL で変更可）。
import { chromium } from "playwright";
import { mkdirSync } from "node:fs";
import { dirname, join } from "node:path";
import { fileURLToPath } from "node:url";

const BASE = process.env.BASE_URL ?? "http://localhost:3000";
const OUT = join(dirname(fileURLToPath(import.meta.url)), "..", "..", "screenshots");
const SLIDES = ["hero", "ocr-search", "privacy", "organize", "features"];
const DEVICES = { iphone: { w: 1320, h: 2868, dir: "iphone-6.9" }, ipad: { w: 2064, h: 2752, dir: "ipad-13" } };

const browser = await chromium.launch({ channel: "chrome" });
for (const locale of ["ja", "en"]) {
  for (const [device, d] of Object.entries(DEVICES)) {
    const page = await browser.newPage({ viewport: { width: d.w, height: d.h }, deviceScaleFactor: 1 });
    const dir = join(OUT, locale, d.dir);
    mkdirSync(dir, { recursive: true });
    for (let i = 0; i < SLIDES.length; i++) {
      await page.goto(`${BASE}/?locale=${locale}&device=${device}&capture=${i}`);
      await page.waitForSelector("#capture[data-ready]");
      await page.evaluate(() => document.fonts.ready);
      await page.waitForTimeout(300);
      const file = join(dir, `${String(i + 1).padStart(2, "0")}-${SLIDES[i]}.png`);
      await page.locator("#capture").screenshot({ path: file, omitBackground: false });
      console.log(file);
    }
    await page.close();
  }
}
await browser.close();
