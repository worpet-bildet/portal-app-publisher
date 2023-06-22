import './app.css';
import App from './App.svelte';
import { handleSubscriptionEvent } from './state';

import { usePortalSubscription } from './api';

usePortalSubscription(handleSubscriptionEvent);

const app = new App({
  target: document.getElementById('app'),
});

export default app;
