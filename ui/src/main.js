import './app.css';
import App from './App.svelte';
import { handleSubscriptionEvent } from './state';

import {
  usePortalSubscription,
  usePortalAppPublisherSubscription,
} from './api';

usePortalSubscription(handleSubscriptionEvent);
usePortalAppPublisherSubscription(handleSubscriptionEvent);

const app = new App({
  target: document.getElementById('app'),
});

export default app;
