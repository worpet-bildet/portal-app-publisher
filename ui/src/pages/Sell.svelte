<script>
  import BigNumber from 'bignumber.js';
  import { api } from '@root/api';
  import { isForSale, getDeskDetails } from '@root/state';
  import { isValidEthAddress, ethToWei } from '@root/utils';

  let app = {};

  $: deskDetails = getDeskDetails(app.desk);
  $: console.log({ deskDetails });
  $: isValid = deskDetails && isValidEthAddress(app.ethAddress) && app.price;

  const publishForSale = async () => {
    console.log([app.desk, app.ethAddress, ethToWei(app.price)]);
    api.publishApp(app.desk, app.ethAddress, ethToWei(app.price));
    // await poke({
    //   app: 'portal-app-publisher',
    //   mark: 'action',
    //   json: {
    //     publish: {
    //       desk: app.desk,
    //       'receiving-address': app.ethAddress,
    //       'eth-price': ethToWei(app.price),
    //     },
    //   },
    // });
  };
</script>

{#if !deskDetails}
  <div class="w-full h-full flex flex-col items-start">
    <div>Enter the name of your desk.</div>
    <div>Your desk should not be public via :treaty|publish</div>
    <input
      class="p-2"
      type="text"
      bind:value={app.desk}
      placeholder="my-desk"
      class:border-error={isForSale(app.desk)}
    />
    {#if isForSale(app.desk)}
      <p>{app.desk} is already for sale, please enter another desk.</p>
    {/if}
  </div>
{:else if !isForSale(app.desk)}
  <div class="w-full h-full flex flex-col items-start">
    <div class="text-xl">{app.desk}</div>
  </div>
  <div class="grid grid-cols-2 gap-8 w-full">
    <div class="flex flex-col justify-start items-start col-span-1 gap-4">
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
      <button on:click={publishForSale} disabled={!isValid}>Publish</button>
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
            <div class="flex flex-col gap-2 items-start text-left">
              <div class="font-bold">{title}</div>
              <div>{info}</div>
              <div>Version: {version}</div>
              {#if app.price}<div>Price: {app.price} ETH</div>{/if}
            </div>
          </div>
          <div class="text-ellipsis">
            {#if isValidEthAddress(app.ethAddress)}Payable to: {app.ethAddress}{/if}
          </div>
        </div>
      {/if}
    </div>
  </div>
{/if}
