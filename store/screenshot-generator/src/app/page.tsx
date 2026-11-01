"use client";

import { toPng } from "html-to-image";
import React, { useEffect, useLayoutEffect, useRef, useState } from "react";

/* ------------------------------------------------------------------ */
/* Constants                                                           */
/* ------------------------------------------------------------------ */

const IPHONE_W = 1320;
const IPHONE_H = 2868;
const IPAD_W = 2064;
const IPAD_H = 2752;

const IPHONE_SIZES = [
  { label: '6.9"', w: 1320, h: 2868 },
  { label: '6.5"', w: 1284, h: 2778 },
] as const;
const IPAD_SIZES = [{ label: '13" iPad', w: 2064, h: 2752 }] as const;

// Phone mockup (pre-measured mockup.png)
const MK_W = 1022;
const MK_H = 2082;
const SC_L = (52 / MK_W) * 100;
const SC_T = (46 / MK_H) * 100;
const SC_W = (918 / MK_W) * 100;
const SC_H = (1990 / MK_H) * 100;
const SC_RX = (126 / 918) * 100;
const SC_RY = (126 / 1990) * 100;

// Brand tokens (app icon: teal + amber)
const C = {
  tealDeep: "#0B4F5C",
  teal: "#0E8A8C",
  tealLight: "#2FB3A8",
  amber: "#F7C46C",
  amberDeep: "#F2A94A",
  cream: "#FBF6EC",
  ink: "#10323A",
  inkMuted: "#4A6870",
  white: "#FFFFFF",
};

const LOCALES = ["ja", "en"] as const;
type Locale = (typeof LOCALES)[number];
type Device = "iphone" | "ipad";

/* ------------------------------------------------------------------ */
/* Copy                                                                */
/* ------------------------------------------------------------------ */

type Copy = {
  s1: { label: string; headline: React.ReactNode };
  s2: { label: string; headline: React.ReactNode; query: string; result: string; hit: string };
  s3: { label: string; headline: React.ReactNode; pills: string[] };
  s4: { label: string; headline: React.ReactNode };
  s5: { headline: React.ReactNode; pills: string[] };
};

const COPY: Record<Locale, Copy> = {
  ja: {
    s1: { label: "書類スキャナ", headline: <>撮るだけで、<br />検索できるPDFに。</> },
    s2: {
      label: "端末内 OCR",
      headline: <>紙の文字まで、<br />検索できる。</>,
      query: "486,200",
      result: "見積書 リフォーム工事",
      hit: "お見積金額 ¥486,200",
    },
    s3: {
      label: "プライバシー",
      headline: <>書類の中身は、<br />端末の外に出ない。</>,
      pills: ["端末内で OCR", "アカウント不要", "広告なし"],
    },
    s4: { label: "書類管理", headline: <>紙の山を、<br />すっきり一覧に。</> },
    s5: {
      headline: <>シンプルだから、<br />迷わない。</>,
      pills: [
        "自動で台形補正",
        "複数ページを1つのPDFに",
        "日本語・英語 OCR",
        "PDF をそのまま共有",
        "PNG / JPEG でフォト保存",
        "タイトル編集",
        "iPad 対応",
        "無料",
      ],
    },
  },
  en: {
    s1: { label: "Document Scanner", headline: <>Snap a page.<br />Search it later.</> },
    s2: {
      label: "On-device OCR",
      headline: <>Find any word<br />on any page.</>,
      query: "4,862",
      result: "Kitchen Remodel Estimate",
      hit: "Estimate Total $4,862.00",
    },
    s3: {
      label: "Privacy",
      headline: <>Your papers stay<br />on your device.</>,
      pills: ["On-device OCR", "No account", "No ads"],
    },
    s4: { label: "Organize", headline: <>Paper piles,<br />neatly sorted.</> },
    s5: {
      headline: <>Simple.<br />Nothing to learn.</>,
      pills: [
        "Auto edge detection",
        "Multi-page PDFs",
        "English & Japanese OCR",
        "Share PDFs anywhere",
        "Save pages as PNG / JPEG",
        "Rename documents",
        "Works on iPad",
        "Free",
      ],
    },
  },
};

/* ------------------------------------------------------------------ */
/* Image preloading (data URIs for html-to-image)                      */
/* ------------------------------------------------------------------ */

const IPHONE_SHOTS = ["list", "detail", "detail2", "onboarding"] as const;
// iPad の一覧画面は右側が空になるため、別の書類を選択した詳細画面 (doc1 / doc3) も用意している
const IPAD_SHOTS = [...IPHONE_SHOTS, "doc1", "doc3"] as const;
type Shot = (typeof IPAD_SHOTS)[number];
const IMAGE_PATHS = [
  "/mockup.png",
  "/app-icon.png",
  ...LOCALES.flatMap((l) => IPHONE_SHOTS.map((s) => `/screenshots/${l}/${s}.png`)),
  ...LOCALES.flatMap((l) => IPAD_SHOTS.map((s) => `/screenshots-ipad/${l}/${s}.png`)),
];

const imageCache: Record<string, string> = {};

async function preloadAllImages() {
  await Promise.all(
    IMAGE_PATHS.map(async (path) => {
      const resp = await fetch(path);
      const blob = await resp.blob();
      imageCache[path] = await new Promise<string>((resolve) => {
        const reader = new FileReader();
        reader.onloadend = () => resolve(reader.result as string);
        reader.readAsDataURL(blob);
      });
    }),
  );
}

function img(path: string) {
  return imageCache[path] || path;
}

/* ------------------------------------------------------------------ */
/* Device frames                                                       */
/* ------------------------------------------------------------------ */

function Phone({ src, style }: { src: string; style?: React.CSSProperties }) {
  return (
    <div style={{ position: "absolute", aspectRatio: `${MK_W}/${MK_H}`, ...style }}>
      <img src={img("/mockup.png")} alt="" style={{ display: "block", width: "100%", height: "100%" }} draggable={false} />
      <div
        style={{
          position: "absolute",
          zIndex: 10,
          overflow: "hidden",
          left: `${SC_L}%`,
          top: `${SC_T}%`,
          width: `${SC_W}%`,
          height: `${SC_H}%`,
          borderRadius: `${SC_RX}% / ${SC_RY}%`,
        }}
      >
        <img
          src={img(src)}
          alt=""
          style={{ display: "block", width: "100%", height: "100%", objectFit: "cover", objectPosition: "top" }}
          draggable={false}
        />
      </div>
    </div>
  );
}

function IPad({ src, style }: { src: string; style?: React.CSSProperties }) {
  return (
    <div style={{ position: "absolute", aspectRatio: "770/1000", ...style }}>
      <div
        style={{
          width: "100%",
          height: "100%",
          borderRadius: "5% / 3.6%",
          background: "linear-gradient(180deg, #2C2C2E 0%, #1C1C1E 100%)",
          position: "relative",
          overflow: "hidden",
          boxShadow: "inset 0 0 0 1px rgba(255,255,255,0.1), 0 30px 120px rgba(0,0,0,0.35)",
        }}
      >
        <div
          style={{
            position: "absolute",
            top: "1.2%",
            left: "50%",
            transform: "translateX(-50%)",
            width: "0.9%",
            height: "0.65%",
            borderRadius: "50%",
            background: "#111113",
            zIndex: 20,
          }}
        />
        <div
          style={{
            position: "absolute",
            left: "4%",
            top: "2.8%",
            width: "92%",
            height: "94.4%",
            borderRadius: "2.2% / 1.6%",
            overflow: "hidden",
            background: "#000",
          }}
        >
          <img
            src={img(src)}
            alt=""
            style={{ display: "block", width: "100%", height: "100%", objectFit: "cover", objectPosition: "top" }}
            draggable={false}
          />
        </div>
      </div>
    </div>
  );
}

/** Device-agnostic frame: phone on iPhone canvases, CSS iPad on iPad canvases. */
function Device({
  device,
  locale,
  shot,
  style,
}: {
  device: Device;
  locale: Locale;
  shot: Shot;
  style?: React.CSSProperties;
}) {
  const src = device === "iphone" ? `/screenshots/${locale}/${shot}.png` : `/screenshots-ipad/${locale}/${shot}.png`;
  return device === "iphone" ? <Phone src={src} style={style} /> : <IPad src={src} style={style} />;
}

/* ------------------------------------------------------------------ */
/* Shared pieces                                                       */
/* ------------------------------------------------------------------ */

function Caption({
  W,
  label,
  headline,
  dark = false,
  align = "left",
  top,
}: {
  W: number;
  label?: string;
  headline: React.ReactNode;
  dark?: boolean;
  align?: "left" | "center";
  top: number;
}) {
  // iPad canvases are wider; cap type so headlines don't dominate.
  const base = Math.min(W, 1500);
  return (
    <div
      style={{
        position: "absolute",
        top,
        left: W * 0.08,
        right: W * 0.08,
        textAlign: align,
        zIndex: 30,
      }}
    >
      {label && (
        <div
          style={{
            display: "inline-block",
            fontSize: base * 0.032,
            fontWeight: 700,
            letterSpacing: "0.04em",
            color: dark ? C.amber : C.teal,
            marginBottom: base * 0.03,
          }}
        >
          {label}
        </div>
      )}
      <div
        style={{
          fontSize: base * 0.088,
          fontWeight: 800,
          lineHeight: 1.18,
          letterSpacing: "-0.01em",
          color: dark ? C.white : C.ink,
        }}
      >
        {headline}
      </div>
    </div>
  );
}

function Blob({ style }: { style: React.CSSProperties }) {
  return <div style={{ position: "absolute", borderRadius: "50%", filter: "blur(10px)", ...style }} />;
}

type SlideProps = { W: number; H: number; device: Device; locale: Locale };

/* ------------------------------------------------------------------ */
/* Slides                                                              */
/* ------------------------------------------------------------------ */

// 1. Hero — icon + main promise + list screen
function Slide1({ W, H, device, locale }: SlideProps) {
  const t = COPY[locale].s1;
  const ipad = device === "ipad";
  const base = Math.min(W, 1500);
  return (
    <div
      style={{
        width: W,
        height: H,
        position: "relative",
        overflow: "hidden",
        background: `linear-gradient(160deg, ${C.tealDeep} 0%, ${C.teal} 55%, ${C.tealLight} 100%)`,
      }}
    >
      <Blob style={{ width: W * 0.9, height: W * 0.9, right: -W * 0.35, top: -W * 0.3, background: "rgba(255,255,255,0.08)" }} />
      <Blob style={{ width: W * 0.8, height: W * 0.8, left: -W * 0.3, bottom: H * 0.05, background: "rgba(247,196,108,0.22)" }} />
      <img
        src={img("/app-icon.png")}
        alt=""
        style={{
          position: "absolute",
          top: H * 0.06,
          left: W * 0.08,
          width: base * 0.16,
          height: base * 0.16,
          borderRadius: base * 0.036,
          boxShadow: "0 20px 60px rgba(0,0,0,0.25)",
        }}
      />
      <Caption W={W} label={t.label} headline={t.headline} dark top={H * 0.06 + base * 0.21} />
      <Device
        device={device}
        locale={locale}
        shot={ipad ? "doc1" : "list"}
        style={
          ipad
            ? { width: "72%", left: "50%", bottom: 0, transform: "translate(-50%, 16%)" }
            : { width: "84%", left: "50%", bottom: 0, transform: "translate(-50%, 13%)" }
        }
      />
    </div>
  );
}

// 2. OCR search — detail screen + floating search card
function Slide2({ W, H, device, locale }: SlideProps) {
  const t = COPY[locale].s2;
  const ipad = device === "ipad";
  const base = Math.min(W, 1500);
  return (
    <div
      style={{
        width: W,
        height: H,
        position: "relative",
        overflow: "hidden",
        background: `linear-gradient(180deg, ${C.cream} 0%, #F6E7CB 100%)`,
      }}
    >
      <Blob style={{ width: W * 1.0, height: W * 1.0, right: -W * 0.45, bottom: -W * 0.2, background: "rgba(14,138,140,0.14)" }} />
      <Caption W={W} label={t.label} headline={t.headline} top={H * 0.065} />
      <Device
        device={device}
        locale={locale}
        shot="detail"
        style={
          ipad
            ? { width: "66%", left: "8%", bottom: 0, transform: "translateY(14%)" }
            : { width: "80%", left: "5%", bottom: 0, transform: "translateY(16%)" }
        }
      />
      {/* Floating search result card */}
      <div
        style={{
          position: "absolute",
          zIndex: 40,
          right: W * 0.05,
          top: ipad ? H * 0.36 : H * 0.42,
          width: ipad ? W * 0.42 : W * 0.62,
          background: C.white,
          borderRadius: base * 0.04,
          padding: base * 0.035,
          boxShadow: "0 30px 80px rgba(16,50,58,0.25)",
          transform: "rotate(2deg)",
        }}
      >
        <div
          style={{
            display: "flex",
            alignItems: "center",
            gap: base * 0.02,
            background: "#EEF3F4",
            borderRadius: base * 0.025,
            padding: `${base * 0.018}px ${base * 0.025}px`,
            fontSize: base * 0.036,
            fontWeight: 600,
            color: C.ink,
          }}
        >
          <svg width={base * 0.04} height={base * 0.04} viewBox="0 0 24 24" fill="none" stroke={C.inkMuted} strokeWidth="2.6" strokeLinecap="round">
            <circle cx="10.5" cy="10.5" r="6.5" />
            <path d="M15.5 15.5L21 21" />
          </svg>
          {t.query}
        </div>
        <div style={{ marginTop: base * 0.03, fontSize: base * 0.03, fontWeight: 700, color: C.ink }}>{t.result}</div>
        <div style={{ marginTop: base * 0.012, fontSize: base * 0.028, color: C.inkMuted }}>
          {t.hit.split(t.query).map((part, i, arr) => (
            <React.Fragment key={i}>
              {part}
              {i < arr.length - 1 && (
                <span style={{ background: C.amber, color: C.ink, borderRadius: 6, padding: "0 6px", fontWeight: 700 }}>{t.query}</span>
              )}
            </React.Fragment>
          ))}
        </div>
      </div>
    </div>
  );
}

// 3. Privacy — dark contrast, tilted device + pills
function Slide3({ W, H, device, locale }: SlideProps) {
  const t = COPY[locale].s3;
  const ipad = device === "ipad";
  const base = Math.min(W, 1500);
  return (
    <div
      style={{
        width: W,
        height: H,
        position: "relative",
        overflow: "hidden",
        background: `radial-gradient(120% 80% at 80% 100%, #12606B 0%, ${C.tealDeep} 45%, #062A31 100%)`,
      }}
    >
      <Blob style={{ width: W * 0.7, height: W * 0.7, left: -W * 0.2, top: H * 0.35, background: "rgba(47,179,168,0.18)" }} />
      <Caption W={W} label={t.label} headline={t.headline} dark top={H * 0.065} />
      <div
        style={{
          position: "absolute",
          left: W * 0.08,
          top: H * 0.065 + base * 0.34,
          display: "flex",
          flexWrap: "wrap",
          gap: base * 0.022,
          zIndex: 30,
        }}
      >
        {t.pills.map((p) => (
          <div
            key={p}
            style={{
              display: "flex",
              alignItems: "center",
              gap: base * 0.014,
              fontSize: base * 0.033,
              fontWeight: 700,
              color: C.white,
              background: "rgba(255,255,255,0.12)",
              border: "2px solid rgba(255,255,255,0.22)",
              borderRadius: 999,
              padding: `${base * 0.016}px ${base * 0.03}px`,
            }}
          >
            <svg width={base * 0.032} height={base * 0.032} viewBox="0 0 24 24" fill="none" stroke={C.amber} strokeWidth="3.2" strokeLinecap="round" strokeLinejoin="round">
              <path d="M5 12.5l4.5 4.5L19 7.5" />
            </svg>
            {p}
          </div>
        ))}
      </div>
      <Device
        device={device}
        locale={locale}
        shot="detail2"
        style={
          ipad
            ? { width: "64%", right: "-4%", bottom: 0, transform: "translateY(18%) rotate(-4deg)" }
            : { width: "80%", right: "-8%", bottom: 0, transform: "translateY(15%) rotate(-5deg)" }
        }
      />
    </div>
  );
}

// 4. Organize — two devices layered
function Slide4({ W, H, device, locale }: SlideProps) {
  const t = COPY[locale].s4;
  const ipad = device === "ipad";
  return (
    <div
      style={{
        width: W,
        height: H,
        position: "relative",
        overflow: "hidden",
        background: `linear-gradient(200deg, #E4F2F0 0%, #F7F3EA 60%, #FBE9C8 100%)`,
      }}
    >
      <Blob style={{ width: W * 0.8, height: W * 0.8, left: -W * 0.3, top: -W * 0.25, background: "rgba(247,196,108,0.30)" }} />
      <Caption W={W} label={t.label} headline={t.headline} align="center" top={H * 0.065} />
      <Device
        device={device}
        locale={locale}
        shot="onboarding"
        style={
          ipad
            ? { width: "52%", left: "-6%", bottom: 0, opacity: 0.6, transform: "translateY(8%) rotate(-4deg)" }
            : { width: "64%", left: "-10%", bottom: 0, opacity: 0.6, transform: "translateY(4%) rotate(-5deg)" }
        }
      />
      <Device
        device={device}
        locale={locale}
        shot={ipad ? "doc3" : "list"}
        style={
          ipad
            ? { width: "60%", right: "4%", bottom: 0, transform: "translateY(16%)" }
            : { width: "76%", right: "-4%", bottom: 0, transform: "translateY(14%)" }
        }
      />
    </div>
  );
}

// 5. More features — icon + pills, no device
function Slide5({ W, H, locale }: SlideProps) {
  const t = COPY[locale].s5;
  const base = Math.min(W, 1500);
  return (
    <div
      style={{
        width: W,
        height: H,
        position: "relative",
        overflow: "hidden",
        background: `linear-gradient(170deg, ${C.teal} 0%, ${C.tealDeep} 100%)`,
      }}
    >
      <Blob style={{ width: W * 1.1, height: W * 1.1, right: -W * 0.5, bottom: -W * 0.4, background: "rgba(247,196,108,0.25)" }} />
      <Blob style={{ width: W * 0.6, height: W * 0.6, left: -W * 0.25, top: H * 0.1, background: "rgba(255,255,255,0.07)" }} />
      <div
        style={{
          position: "absolute",
          inset: 0,
          display: "flex",
          flexDirection: "column",
          alignItems: "center",
          justifyContent: "center",
          gap: base * 0.07,
          padding: `0 ${W * 0.08}px`,
          zIndex: 10,
        }}
      >
        <img
          src={img("/app-icon.png")}
          alt=""
          style={{
            width: base * 0.26,
            height: base * 0.26,
            borderRadius: base * 0.058,
            boxShadow: "0 30px 80px rgba(0,0,0,0.3)",
          }}
        />
        <div style={{ fontSize: base * 0.088, fontWeight: 800, lineHeight: 1.18, color: C.white, textAlign: "center" }}>{t.headline}</div>
        <div
          style={{
            display: "flex",
            flexWrap: "wrap",
            justifyContent: "center",
            gap: base * 0.024,
            maxWidth: Math.min(W * 0.84, 1500),
          }}
        >
          {t.pills.map((p) => (
            <div
              key={p}
              style={{
                fontSize: base * 0.036,
                fontWeight: 700,
                color: C.ink,
                background: "rgba(255,255,255,0.92)",
                borderRadius: 999,
                padding: `${base * 0.018}px ${base * 0.036}px`,
              }}
            >
              {p}
            </div>
          ))}
        </div>
      </div>
    </div>
  );
}

const SLIDES = [
  { id: "hero", C: Slide1 },
  { id: "ocr-search", C: Slide2 },
  { id: "privacy", C: Slide3 },
  { id: "organize", C: Slide4 },
  { id: "features", C: Slide5 },
] as const;

/* ------------------------------------------------------------------ */
/* Preview + export                                                    */
/* ------------------------------------------------------------------ */

function ScreenshotPreview({
  W,
  H,
  children,
  onExport,
}: {
  W: number;
  H: number;
  children: React.ReactNode;
  onExport: () => void;
}) {
  const ref = useRef<HTMLDivElement>(null);
  const [scale, setScale] = useState(0.2);
  useLayoutEffect(() => {
    if (!ref.current) return;
    const ro = new ResizeObserver(([e]) => setScale(e.contentRect.width / W));
    ro.observe(ref.current);
    return () => ro.disconnect();
  }, [W]);
  return (
    <div className="group relative">
      <div ref={ref} style={{ width: "100%", aspectRatio: `${W}/${H}`, overflow: "hidden", borderRadius: 16, boxShadow: "0 6px 24px rgba(0,0,0,0.12)" }}>
        <div style={{ width: W, height: H, transform: `scale(${scale})`, transformOrigin: "top left" }}>{children}</div>
      </div>
      <button
        onClick={onExport}
        className="absolute bottom-3 right-3 rounded-full bg-black/75 px-4 py-2 text-sm font-semibold text-white opacity-0 transition group-hover:opacity-100"
      >
        Export PNG
      </button>
    </div>
  );
}

async function exportNode(el: HTMLElement, W: number, H: number, outW: number, outH: number, filename: string) {
  el.style.left = "0px";
  el.style.opacity = "1";
  el.style.zIndex = "-1";
  const opts = { width: W, height: H, pixelRatio: 1, cacheBust: true };
  await toPng(el, opts);
  let dataUrl = await toPng(el, opts);
  el.style.left = "-9999px";
  el.style.opacity = "";
  el.style.zIndex = "";

  if (outW !== W || outH !== H) {
    const image = new Image();
    image.src = dataUrl;
    await image.decode();
    const canvas = document.createElement("canvas");
    canvas.width = outW;
    canvas.height = outH;
    canvas.getContext("2d")!.drawImage(image, 0, 0, outW, outH);
    dataUrl = canvas.toDataURL("image/png");
  }
  const a = document.createElement("a");
  a.href = dataUrl;
  a.download = filename;
  a.click();
}

export default function ScreenshotsPage() {
  const [ready, setReady] = useState(false);
  const [locale, setLocale] = useState<Locale>("ja");
  const [device, setDevice] = useState<Device>("iphone");
  const [sizeIdx, setSizeIdx] = useState(0);
  const [capture, setCapture] = useState<number | null>(null);
  const exportRefs = useRef<(HTMLDivElement | null)[]>([]);

  useEffect(() => {
    const q = new URLSearchParams(window.location.search);
    const l = q.get("locale");
    if (l === "ja" || l === "en") setLocale(l);
    if (q.get("device") === "ipad") setDevice("ipad");
    const c = q.get("capture");
    if (c !== null) setCapture(Number(c));
    preloadAllImages().then(() => setReady(true));
  }, []);

  if (!ready) return <p style={{ padding: 24 }}>Loading images...</p>;

  const W = device === "iphone" ? IPHONE_W : IPAD_W;
  const H = device === "iphone" ? IPHONE_H : IPAD_H;
  const sizes = device === "iphone" ? IPHONE_SIZES : IPAD_SIZES;
  const size = sizes[Math.min(sizeIdx, sizes.length - 1)];

  // Headless capture mode: render one slide at 1:1 at the top-left corner.
  if (capture !== null) {
    const S = SLIDES[capture].C;
    return (
      <div id="capture" data-ready="1" style={{ width: W, height: H }}>
        <S W={W} H={H} device={device} locale={locale} />
      </div>
    );
  }

  const fileName = (i: number) =>
    `${String(i + 1).padStart(2, "0")}-${SLIDES[i].id}-${locale}-${device}-${size.w}x${size.h}.png`;

  const exportOne = (i: number) => exportNode(exportRefs.current[i]!, W, H, size.w, size.h, fileName(i));
  const exportAll = async () => {
    for (let i = 0; i < SLIDES.length; i++) {
      await exportOne(i);
      await new Promise((r) => setTimeout(r, 300));
    }
  };

  const btn = (active: boolean) =>
    `rounded-full px-4 py-1.5 text-sm font-semibold ${active ? "bg-[#0E8A8C] text-white" : "bg-white text-[#10323A]"}`;

  return (
    <main className="min-h-screen p-6">
      <div className="mb-6 flex flex-wrap items-center gap-3">
        <h1 className="mr-4 text-xl font-bold">EasyScan PDF — App Store Screenshots</h1>
        {LOCALES.map((l) => (
          <button key={l} className={btn(locale === l)} onClick={() => setLocale(l)}>
            {l.toUpperCase()}
          </button>
        ))}
        <span className="mx-2 h-6 w-px bg-black/20" />
        {(["iphone", "ipad"] as const).map((d) => (
          <button key={d} className={btn(device === d)} onClick={() => { setDevice(d); setSizeIdx(0); }}>
            {d === "iphone" ? "iPhone" : "iPad"}
          </button>
        ))}
        <select className="rounded-full bg-white px-3 py-1.5 text-sm" value={sizeIdx} onChange={(e) => setSizeIdx(Number(e.target.value))}>
          {sizes.map((s, i) => (
            <option key={s.label} value={i}>
              {s.label} ({s.w}×{s.h})
            </option>
          ))}
        </select>
        <button className={btn(true)} onClick={exportAll}>
          Export all
        </button>
      </div>

      <div className="grid gap-6" style={{ gridTemplateColumns: `repeat(auto-fill, minmax(${device === "iphone" ? 240 : 320}px, 1fr))` }}>
        {SLIDES.map(({ id, C: S }, i) => (
          <ScreenshotPreview key={id} W={W} H={H} onExport={() => exportOne(i)}>
            <S W={W} H={H} device={device} locale={locale} />
          </ScreenshotPreview>
        ))}
      </div>

      {/* Offscreen full-resolution copies for export */}
      <div style={{ position: "absolute", left: -9999, top: 0 }}>
        {SLIDES.map(({ id, C: S }, i) => (
          <div
            key={id}
            ref={(el) => { exportRefs.current[i] = el; }}
            style={{ position: "absolute", left: -9999, top: 0, width: W, height: H }}
          >
            <S W={W} H={H} device={device} locale={locale} />
          </div>
        ))}
      </div>
    </main>
  );
}
