<script>
  import Router, { location } from 'svelte-spa-router';
  import { Home, Sell, App, Api } from './pages';

  const routes = {
    '/': Home,
    '/sell': Sell,
    '/:desk': App,

    '/dev/api': Api,
    // '/edit': Edit,
    // '/sign': Sign
  };
</script>

<main class="p-10">
  <Router {routes} />
</main>
