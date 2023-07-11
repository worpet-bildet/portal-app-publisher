# Portal App Publisher

`|install ~worpet-bildet %portal-app-publisher`

Portal App Publisher has two main functions:

1. Enabling the sale of Hoon applications for ETH via Portal
2. Linking apps hosted by a comet to your main ship's Portal page

## Publishing Paid Apps on Portal

Firstly, you need an Ethereum mainnet RPC endpoint. [Infura](https://www.infura.io/) has a very generous free tier.

If you have installed Portal on the same ship from which your app is published, open Portal App Publisher on that ship and follow the prompts to list the app for sale on your ship's Portal page.

If you would prefer to list your app for sale on another ship's Portal page (for example, you host the application on a moon and do not want to install Portal on the moon), then there are two extra steps.

1. In your main ship's dojo:

```
:portal-manager &portal-action [%authorize-ships (sy ~[~sampel-palnet ~dister-sampel-palnet])]
```

Where `~sampel-palnet` is your main ship and `~dister-sampel-palnet` is your app-hosting ship.

2. When listing the app for sale via %portal-app-publisher on your app-hosting ship, ensure that you change the ship listed there to your main ship

This does obviously require you to install `%portal-app-publisher` on the moon.

## Publishing Free Apps on Portal

If you are listing an app on Portal for free, but still want to maintain a separation between the app-hosting ship and the ship you use with Portal, then you do not need to use the frontend application. You can use two terminal commands:

1. In your main ship's dojo:

```
:portal-manager &portal-action [%authorize-ships (sy ~[~sampel-palnet ~dister-sampel-palnet])]
```

Where `~sampel-palnet` is your main ship, and `~dister-sampel-palnet` is your app-hosting ship.

2. In your app-hosting ship's dojo:

```
:portal-app-publisher &action [%sign-app ~sampel-palnet '~dister-sampel-palnet/app1']
```

Where `%app1` is the name of the desk. The app should now be displayed on `~sampel-palnet`'s %portal page.
