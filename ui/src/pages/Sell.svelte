<script>
  import { push } from 'svelte-spa-router';
  import { me, api } from '@root/api';
  import {
    state,
    isForSale,
    getDeskDetails,
    getMyPublishedDesks,
  } from '@root/state';
  import { isValidEthAddress, ethToWei } from '@root/utils';

  let app = {
    distributor: me,
  };

  $: deskDetails = getDeskDetails(app.desk);
  $: isValid = deskDetails && isValidEthAddress(app.ethAddress) && app.price;
  $: myPublishedDesks = getMyPublishedDesks($state);

  const publishForSale = async () => {
    await api.publishApp(app.desk, app.ethAddress, ethToWei(app.price));
    await api.signApp(app.distributor, `${me}/${app.desk}`);
    push('/');
  };
</script>

{#if !deskDetails}
  <div class="w-full h-full flex flex-col gap-8">
    <div class="text-left text-2xl">
      Select one of your installed apps to sell
    </div>
    <div class="text-left">
      Apps only appear here if they have not been published via :treaty|publish
    </div>
    {#each Object.entries(myPublishedDesks || {}).filter(([key]) => !isForSale(key)) as [key, data]}
      <button
        class="flex items-center gap-4 rounded-xl p-4 border"
        on:click={() => {
          deskDetails = getDeskDetails(key);
          app.desk = key;
        }}
      >
        <img
          class="h-24 w-24 rounded-xl object-cover border"
          src={data.image}
        />
        <div class="flex flex-col items-start">
          <div>{data.title}</div>
        </div>
      </button>
    {/each}
  </div>
{:else}
  <div class="grid gap-8 w-full">
    <div class="flex flex-col justify-start items-start gap-4">
      <div class="flex flex-col gap-2 items-start">
        <h3>Price (ETH)</h3>
        <input
          class="p-2 border"
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
          size="48"
          bind:value={app.ethAddress}
          placeholder="0x..."
        />
        {#if app.ethAddress && !isValidEthAddress(app.ethAddress)}
          <p class="text-error">Please enter a valid ETH address</p>
        {/if}
      </div>
      <div class="flex flex-col gap-2 items-start">
        <h3>Distributing Ship</h3>
        <div class="text-sm">
          Your app will be shown on this user's Portal page. Do not edit if
          you're unsure.
        </div>
        <input
          class="p-2 border"
          type="text"
          size="28"
          bind:value={app.distributor}
          placeholder="~zod"
        />
      </div>
    </div>
    <div class="border rounded-xl">
      {#if deskDetails}
        {@const { image, info, title, version } = deskDetails}
        <div
          class="p-4 flex flex-col items-start gap-8 text-clip overflow-hidden"
        >
          <div class="flex gap-4">
            <img src={image} class="w-24 h-24 object-cover border rounded-xl" />
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
    <div class="flex w-full justify-end">
      <button
        on:click={publishForSale}
        disabled={!isValid}
        class="px-4 py-2"
        class:text-grey={!isValid}>Publish</button
      >
    </div>
  </div>
{/if}
