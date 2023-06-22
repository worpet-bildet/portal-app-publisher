<script>
  import BigNumber from 'bignumber.js';
  import { poke } from '@root/api';
  import { getDeskDetails } from '@root/state';
  import { isValidEthAddress, ethToWei } from '@root/utils';

  let app = {
    desk: 'sell-me',
    price: 0.07,
    ethAddress: '0x1CeDC0f3Af8f9841B0a1F5c1a4DDc6e1a1629074',
  };

  $: deskDetails = getDeskDetails(app.desk);

  const publishForSale = async () => {
    console.log('Publish the app!', { app });
    await poke({
      app: 'portal-app-publisher',
      mark: 'action',
      json: {
        publish: {
          desk: app.desk,
          'receiving-address': app.ethAddress,
          'eth-price': 1000,
          // 'eth-price': ethToWei(app.price),
        },
      },
    });
  };
</script>

<div class="grid grid-cols-2 gap-8 w-full">
  <div class="flex flex-col justify-start items-start col-span-1 gap-4">
    <div class="flex flex-col gap-2 items-start">
      <h3>Desk Name</h3>
      <input
        class="p-2"
        type="text"
        bind:value={app.desk}
        placeholder="my-desk"
      />
    </div>
    <div class="flex flex-col gap-2 items-start">
      <h3>Price (ETH)</h3>
      <input
        class="p-2"
        type="number"
        min="0"
        step="0.001"
        bind:value={app.price}
        placeholder="0.1"
      />
    </div>
    <div class="flex flex-col gap-2 items-start">
      <h3>ETH Address (payments go here)</h3>
      <input
        class="p-2 border"
        class:border-error={app.ethAddress &&
          !isValidEthAddress(app.ethAddress)}
        type="text"
        bind:value={app.ethAddress}
        placeholder="0x..."
      />
      {#if app.ethAddress && !isValidEthAddress(app.ethAddress)}
        <p class="text-error">Please enter a valid ETH address</p>
      {/if}
    </div>
    <button on:click={publishForSale}>Publish</button>
  </div>
  <div class="col-span-1 border border-white border-dash">
    {#if deskDetails}
      {@const { image, info, title, version } = deskDetails}
      <div
        class="p-4 flex flex-col items-start gap-8 text-clip overflow-hidden"
      >
        <div class="flex gap-4">
          <img
            src={image}
            class="w-24 h-24 object-cover border border-white rounded-xl"
          />
          <div class="flex flex-col items-start">
            <div class="font-bold">{title}</div>
            <div>{info}</div>
            <div>Version: {version}</div>
            <div>Price: {app.price} ETH</div>
          </div>
        </div>
        <div class="text-ellipsis">
          Payable to: {app.ethAddress}
        </div>
      </div>
    {/if}
  </div>
</div>
