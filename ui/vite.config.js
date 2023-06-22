import path from 'path';
import { defineConfig } from 'vite';
import { svelte } from '@sveltejs/vite-plugin-svelte';
import { urbitPlugin } from '@urbit/vite-plugin-urbit';

// https://vitejs.dev/config/
const target = process.env.SHIP_URL ?? 'http://localhost:80';
export default defineConfig({
  plugins: [svelte(), urbitPlugin({ base: 'portal-app-publisher', target })],
  resolve: {
    alias: {
      '@assets': path.resolve('./src/assets'),
      '@root': path.resolve('./src'),
      '@pages': path.resolve('./pages'),
    },
  },
});
