<script>
  import { push } from 'svelte-spa-router';
  import { sigil, stringRenderer } from '@tlon/sigil-js';
  import { format } from 'timeago.js';
  import { api } from '@root/api';
  import { state, getApp, getSalesOfDesk } from '@root/state';
  import { Modal } from '@fragments';
  import { weiToEth } from '@root/utils';

  export let params;

  let app = {};
  let sales = [];
  let unpublishModalOpen;
  const load = (desk) => {
    app = getApp(desk);
    sales = getSalesOfDesk(desk);
  };

  // Reactive stuff, make sure we load the correct desk information
  $: load(params.desk);
  state.subscribe(() => load(params.desk));

  const handleUnpublish = () => {
    api.unpublishApp(app.desk);
    push('/');
  };

  const formatTxHash = (txHash) =>
    `${txHash.slice(0, 6)}...${txHash.slice(-4)}`;
</script>

<div class="flex flex-col gap-4">
  {#if app}
    <div class="flex items-center gap-4 rounded-xl p-4 border rounded-xl">
      <img class="h-24 w-24 rounded-xl object-cover border" src={app.image} />
      <div class="flex flex-col items-start">
        <div>{app.title}</div>
        <div class="flex flex-col gap-4">
          <div>{weiToEth(app['eth-price'])} ETH</div>
          <a
            href={`https://etherscan.io/address/${app['receiving-address']}`}
            class="hover:underline"
            target="_blank"
            >Payable to: {formatTxHash(app['receiving-address'])}</a
          >
        </div>
      </div>
    </div>
  {/if}
  <div class="border-b border-spacer w-full" />
  <div class="flex w-full justify-end p-5">
    <button class="hover:underline" on:click={() => (unpublishModalOpen = true)}
      >Unpublish</button
    >
  </div>
  <div class="border-b border-spacer w-full" />
  {#if !sales}
    <div class="text-left py-5">
      Nobody has purchased {app.title} yet. Any sales will appear here.
    </div>
  {/if}
  {#if sales}
    <div class="flex flex-col items-start py-5 gap-4">
      <div class="text-3xl">Sales ({sales.length})</div>
      {#each sales as sale}
        <a
          href={`https://etherscan.io/tx/${sale['tx-hash']}`}
          target="_blank"
          class="flex items-center gap-4 rounded-xl p-4 border w-full"
        >
          <div class="h-24 w-24 rounded-xl overflow-hidden h-full object-cover">
            {@html sigil({
              patp: sale.buyer.length > '14' ? '~zod' : sale.buyer,
              renderer: stringRenderer,
              size: 50,
            })}
          </div>
          <div class="flex flex-col items-start">
            <div>{sale.buyer}</div>
            <div class="flex gap-4 hover:underline">
              {formatTxHash(sale['tx-hash'])}
            </div>
            <div>{format(sale.time)}</div>
          </div>
        </a>
      {/each}
    </div>
  {/if}
  <Modal bind:open={unpublishModalOpen}>
    <div class="flex flex-col gap-4">
      <div class="text-2xl">Unpublish {app.title}</div>
      <div>
        If you unpublish this app from Portal, any commits to this desk will not
        be propagated to existing buyers.
      </div>
      <div class="flex w-full justify-end gap-8">
        <button
          class="hover:underline"
          on:click={() => (unpublishModalOpen = false)}>Cancel</button
        >
        <button class="hover:underline" on:click={handleUnpublish}
          >Unpublish</button
        >
      </div>
    </div>
  </Modal>
</div>
