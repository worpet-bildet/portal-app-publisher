<script>
  import { sigil, stringRenderer } from '@tlon/sigil-js';
  import { state, getApp, getSalesOfDesk } from '@root/state';

  export let params;

  let app = {};
  let sales = [];
  const load = (desk) => {
    app = getApp(desk);
    sales = getSalesOfDesk(desk);
  };

  // Reactive stuff, make sure we load the correct desk information
  $: load(params.desk);
  state.subscribe(() => load(params.desk));

  const formatTxHash = (txHash) =>
    `${txHash.slice(0, 6)}...${txHash.slice(-4)}`;
</script>

<div>
  {#if app}
    {@const { name, image, price, purchases } = app}
    <div class="flex items-start">
      <h1>{name}</h1>
    </div>
    <div class="flex items-center gap-4 rounded-xl p-4">
      <img class="h-24 w-24 rounded-xl object-cover" src={image} />
      <div class="flex flex-col items-start">
        <div>{name}</div>
        <div class="flex gap-4">
          <div>{price} ETH</div>
          <div>{purchases} sales</div>
        </div>
      </div>
    </div>
  {/if}
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
</div>
