import { defineConfig } from 'vite';
import react from '@vitejs/plugin-react';

// https://vitejs.dev/config/
export default defineConfig({
  plugins: [react()],
  server: {
    port: 5173, // فقط أثناء التطوير المحلي
  },
  build: {
    outDir: 'dist', // هذا المجلد الذي سينشره Vercel
  },
  optimizeDeps: {
    exclude: ['lucide-react'],
  },
});
