<script>
  import Router, { location } from 'svelte-spa-router';
  import { Home, Sell, App, Api } from './pages';
  import { Navbar } from '@components';

  const routes = {
    '/': Home,
    '/sell': Sell,
    '/:desk': App,

    '/dev/api': Api,
    // '/edit': Edit,
    // '/sign': Sign
  };
</script>

<main>
  <Navbar />
  <div class="p-10 pt-0">
    <Router {routes} />
  </div>
</main>
