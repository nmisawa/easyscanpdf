import type { Metadata } from "next";
import "./globals.css";

export const metadata: Metadata = {
  title: "EasyScan PDF Screenshots",
  description: "App Store screenshot generator for EasyScan PDF",
};

export default function RootLayout({ children }: LayoutProps<"/">) {
  return (
    <html lang="ja">
      <body
        style={{
          margin: 0,
          fontFamily:
            '-apple-system, "SF Pro Display", "Hiragino Sans", "Hiragino Kaku Gothic ProN", system-ui, sans-serif',
        }}
      >
        {children}
      </body>
    </html>
  );
}
