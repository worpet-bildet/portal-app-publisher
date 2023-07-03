import path from 'path';
import { loadEnv, defineConfig } from 'vite';
import { svelte } from '@sveltejs/vite-plugin-svelte';
import { urbitPlugin } from '@urbit/vite-plugin-urbit';

// https://vitejs.dev/config/
export default ({ mode }) => {
  Object.assign(process.env, loadEnv(mode, process.cwd()));
  const target =
    mode === 'production' ? '' : process.env.SHIP_URL ?? 'http://localhost:80';
  console.log({ target });
  defineConfig({
    plugins: [svelte(), urbitPlugin({ base: 'portal-app-publisher', target })],
    resolve: {
      alias: {
        '@root': path.resolve('./src'),
        '@assets': path.resolve('./src/assets'),
        '@components': path.resolve('./src/components'),
        '@fragments': path.resolve('./src/fragments'),
        '@pages': path.resolve('./src/pages'),
      },
    },
  });
};
