import type { NextConfig } from "next";

const nextConfig: NextConfig = {
  // 書き出し画像に開発用インジケータが写り込まないようにする
  devIndicators: false,
};

export default nextConfig;
