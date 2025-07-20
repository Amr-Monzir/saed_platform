import { defineConfig } from "vite";
import react from "@vitejs/plugin-react";

// https://vite.dev/config/
export default defineConfig({
  plugins: [react()],
  server: {
    host: true,
    port: 5173,
    allowedHosts: ["localhost", "127.0.0.1", "dbb1f7732e59.ngrok-free.app"],
  },
});
