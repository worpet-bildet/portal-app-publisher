import { get, writable } from 'svelte/store';
import { api } from './api';

export const state = writable({
  installedApps: {},
  'processing-payments': {},
  'processed-payments': {},
  'desks-for-sale': {},
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
    console.log({ initial, kiln });
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
  // return get(state).sales.filter((s) => s.desk === desk);
};

export const handleSubscriptionEvent = (event, type) => {
  console.log({ event, type });
};

export const refreshAll = () => {
  refreshInstalledApps();

  api.getProcessingPayments().then(merge);
  api.getProcessedPayments().then(merge);
  api.getDesksForSale().then(merge);
};
refreshAll();

// DEVELOPMENT CODE

const populateState = () => {
  state.update((s) => {
    s.apps = [
      {
        desk: 'fart',
        name: 'Fart App',
        image: 'https://www.newhealthadvisor.org/images/1HT00460/fart.png',
        price: 0.01,
        purchases: 18,
      },
      {
        desk: 'alex',
        name: 'Alex Jones Soundboard',
        image:
          'https://d1i4t8bqe7zgj6.cloudfront.net/11-17-2016/t_1479397457281_name_2016alexjones.jpg',
        price: 0.01,
        purchases: 18,
      },
    ];

    s.sales = [
      {
        desk: 'alex',
        buyer: '~naplud-batmyn',
        txHash:
          '0xe9ef39a97f10a5377aa181df00ec36e1e658e4f501c4d61c5c3dfe741a6b9e36',
        timestamp: '1687339492527',
      },
      {
        desk: 'alex',
        buyer: '~foddur-hodler',
        txHash:
          '0x4b30821b1e362cedfe490c7a4b0c4265117c6a0e8df92b00782273b395c4fbf8',
        timestamp: '1687336492527',
      },
      {
        desk: 'fart',
        buyer: '~naplud-batmyn',
        txHash:
          '0xe9ef39a97f10a5377aa181df00ec36e1e658e4f501c4d61c5c3dfe741a6b9e36',
        timestamp: '1687339492527',
      },
    ];
    return s;
  });
};

setTimeout(() => {
  // populateState();
}, 1500);
