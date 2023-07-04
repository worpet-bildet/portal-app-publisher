<script>
  import Router, { location } from 'svelte-spa-router';
  import { Home, Sell, App, Api } from './pages';
  import { Navbar } from '@components';

  const routes = {
    '/': Home,
    '/sell': Sell,
    '/:desk': App,
    '/dev/api': Api,
  };

  // TODO: only bind api route in dev
</script>

<main>
  <Navbar />
  <div class="p-10">
    <Router {routes} />
  </div>
</main>
