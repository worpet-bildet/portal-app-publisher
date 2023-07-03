import { get, writable } from 'svelte/store';
import { api } from './api';

export const state = writable({
  installedApps: {},
  'processing-payments': [],
  'processed-payments': [],
  'desks-for-sale': {},
  'our-apps': [],
  'rpc-endpoint': '',
});

state.subscribe((s) => {
  console.log('========= STATE ==========', { s });
});

export const merge = (res) => {
  state.update((s) => {
    s = { ...s, ...res };
    return s;
  });
};

export const refreshInstalledApps = () => {
  api.getInstalledApps().then(([{ initial }, kiln]) => {
    let installedApps = {};
    state.update((s) => {
      Object.entries(initial).forEach(([key, data]) => {
        data.ship = kiln[key]?.sync?.ship;
        installedApps[key] = data;
      });
      s.installedApps = installedApps;
      return s;
    });
  });
};

export const getMyPublishedDesks = () => {
  let desks = {};
  Object.entries(get(state)?.installedApps || {})?.forEach(([key, data]) => {
    if (get(state)?.['our-apps']?.find((a) => a.desk === key)) return;
    if (!data.ship) desks[key] = data;
  });
  return desks;
};

export const isForSale = (desk) => {
  return get(state)?.['desks-for-sale']?.[desk];
};

export const getDeskDetails = (desk) => {
  return get(state).installedApps[desk];
};

export const getApp = (desk) => {
  return {
    ...get(state)['desks-for-sale'][desk],
    ...getDeskDetails(desk),
    desk,
  };
};

export const getSalesOfDesk = (desk) => {
  return get(state)?.['processed-payments']?.filter((s) => s.desk === desk);
};

export const handleSubscriptionEvent = (event, type) => {
  console.log({ event, type });
  state.update((s) => {
    s = { ...s, ...event };
    return s;
  });
};

export const refreshAll = () => {
  refreshInstalledApps();

  api.getProcessingPayments().then(merge);
  api.getProcessedPayments().then(merge);
  api.getDesksForSale().then(merge);
  api.getRpcEndpoint().then(merge);
  api.getTreatyPublishedApps().then(merge);
};
refreshAll();

// DEVELOPMENT CODE
