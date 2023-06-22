import Urbit from '@urbit/http-api';

export const urbit = new Urbit('', '', 'portal-app-publisher');
urbit.ship = window.ship;

export const poke = (s) => urbit.poke(s);
export const scry = (s) => urbit.scry(s);

export const me = `~${urbit.ship}`;

export const api = {
  // SCRIES / POKES TO OTHER APPS
  getInstalledApps: () => {
    return Promise.all([
      scry({
        app: 'docket',
        path: '/charges',
      }),
      scry({
        app: 'hood',
        path: '/kiln/pikes',
      }),
    ]);
  },

  // SCRIES / POKES TO PORTAL
  getProcessingPayments: () =>
    scry({ app: 'portal-app-publisher', path: '/processing-payments' }),
  getProcessedPayments: () =>
    scry({ app: 'portal-app-publisher', path: '/processed-payments' }),
  getDesksForSale: () =>
    scry({ app: 'portal-app-publisher', path: '/desks-for-sale' }),
  getRpcEndpoint: () =>
    scry({ app: 'portal-app-publisher', path: '/rpc-endpoint' }),
  getTreatyPublishedApps: () =>
    scry({ app: 'portal-app-publisher', path: '/our-apps' }),
  getPortalDevs: () =>  // devs who we give the privilege to share our app on %portal
    scry({ app: 'portal-app-publisher', path: '/portal-devs' }),

  publishApp: () =>
    poke({
      app: 'portal-app-publisher',
      mark: 'action',
      json: {
        publish: {
          desk: 'sell-me',
          'receiving-address': '0x1CeDC0f3Af8f9841B0a1F5c1a4DDc6e1a1629074',
          'eth-price': 1000,
        },
      },
    }),
  unpublishApp: () =>
    poke({
      app: 'portal-app-publisher',
      mark: 'action',
      json: {
        unpublish: {
          desk: 'sell-me',
        },
      },
    }),
  setRpcEndpoint: () =>
  poke({
    app: 'portal-app-publisher',
    mark: 'action',
    json: {
      "set-rpc-endpoint": {
        endpoint: 'https://mainnet.infura.io/v3/9b96ee8ae39f44f7b6039b5bb73d22a2',
      },
    },
  }),
};

export const usePortalSubscription = async (onEvent) => {
  const portalSub = await urbit.subscribe({
    app: 'portal-manager',
    path: '/updates',
    event: onEvent,
    err: console.error,
    quit: console.error,
  });
  return () => urbit?.unsubscribe(portalSub);
};

export const usePortalAppPublisherSubscription = async (onEvent) => {
  const portalAppPublisherSub = await urbit.subscribe({
    app: 'portal-app-publisher',
    path: '/all',
    event: onEvent,
    err: console.error,
    quit: console.error,
  });
  return () => urbit?.unsubscribe(portalAppPublisherSub);
};
