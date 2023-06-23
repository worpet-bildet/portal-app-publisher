<script>
  import { sigil, stringRenderer } from '@tlon/sigil-js';
  import { api } from '@root/api';
  import { state, getApp, getSalesOfDesk } from '@root/state';
  import { Modal } from '@fragments';

  export let params;

  let app = {};
  let sales = [];
  let unpublishModalOpen;
  const load = (desk) => {
    app = getApp(desk);
    sales = getSalesOfDesk(desk);
    console.log({ app });
  };

  // Reactive stuff, make sure we load the correct desk information
  $: load(params.desk);
  state.subscribe(() => load(params.desk));

  const formatTxHash = (txHash) =>
    `${txHash.slice(0, 6)}...${txHash.slice(-4)}`;
</script>

<div>
  {#if app}
    <div class="flex items-center gap-4 rounded-xl p-4">
      <img class="h-24 w-24 rounded-xl object-cover" src={app.image} />
      <div class="flex flex-col items-start">
        <div>{app.title}</div>
        <div class="flex gap-4">
          <div>{app['eth-price']} ETH</div>
        </div>
      </div>
    </div>
  {/if}
  <div class="border-b border-white w-full" />
  <div class="flex w-full justify-end p-5">
    <button on:click={() => (unpublishModalOpen = true)}>Unpublish</button>
  </div>
  <div class="border-b border-white w-full" />
  {#if sales}
    <div class="flex flex-col items-start py-5">
      <div class="text-3xl">Sales</div>
      {#each sales as { buyer, txHash, timestamp }}
        <div class="flex items-center gap-4 rounded-xl p-4">
          <div class="h-24 w-24 rounded-xl overflow-hidden h-full object-cover">
            {@html sigil({
              patp: buyer,
              renderer: stringRenderer,
              size: 50,
            })}
          </div>
          <div class="flex flex-col items-start">
            <div>{buyer}</div>
            <div class="flex gap-4">
              <a href={`https://etherscan.io/tx/${txHash}`} target="_blank"
                >{formatTxHash(txHash)}</a
              >
            </div>
            <div>{timestamp}</div>
          </div>
        </div>
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
      <div class="flex w-full justify-end">
        <button on:click={() => api.unpublishApp(app.desk)}>Confirm</button>
      </div>
    </div>
  </Modal>
</div>
