<script>
  import { ethers } from 'ethers';
  import { push } from 'svelte-spa-router';
  import { api } from '@root/api';
  import { state, getDeskDetails } from '@root/state';
  import { weiToEth } from '@root/utils';

  const { setRpcEndpoint } = api;

  let desks = [];
  let rpcEndpoint, isEditingRpcEndpoint, isRpcEndpointValid;
  state.subscribe((s) => {
    rpcEndpoint = s['rpc-endpoint'];
    isEditingRpcEndpoint = !rpcEndpoint;
    desks = Object.entries(s['desks-for-sale']).map(([key, data]) => ({
      key,
      ...getDeskDetails(key),
      ...data,
    }));
  });

  const handleSetRpcEndpoint = async () => {
    let provider = new ethers.JsonRpcProvider(rpcEndpoint);
    try {
      isRpcEndpointValid = await provider.getBlock();
      setRpcEndpoint(rpcEndpoint);
      isEditingRpcEndpoint = false;
    } catch (e) {
      isRpcEndpointValid = false;
    }
  };
</script>

<div class="flex flex-col items-end gap-8">
  <div class="flex flex-col gap-2">
    <div class="flex gap-4 items-center">
      ETH RPC:
      {#if !rpcEndpoint || isEditingRpcEndpoint}
        <input
          type="text"
          class="p-2 border rounded-md"
          size="50"
          bind:value={rpcEndpoint}
          placeholder="https://..."
        />
        <button on:click={handleSetRpcEndpoint}>save</button>
      {:else if rpcEndpoint && !isEditingRpcEndpoint}
        <div class="p-2">{rpcEndpoint}</div>
        <button class="text-sm" on:click={() => (isEditingRpcEndpoint = true)}
          >edit</button
        >
      {/if}
    </div>
    {#if !rpcEndpoint}
      <div class="text-right">
        This is required for purchases to be honoured.
      </div>
    {/if}
    {#if isRpcEndpointValid}
      <div class="text-right">RPC is functional!</div>
    {:else if isRpcEndpointValid === false}
      <div class="text-right">
        RPC not functional, please check the URL and try again.
      </div>
    {/if}
  </div>
  <div class="flex flex-col gap-8 w-full">
    <div class="text-2xl text-left">Apps for sale</div>
    {#if desks.length === 0}
      <div class="text-left">You have no apps for sale yet.</div>
      <div class="text-left">
        <button on:click={() => push('/sell')}>+ Sell App</button>
      </div>
    {/if}
    {#each desks as desk}
      <button
        class="flex items-center gap-4 rounded-xl p-4 border rounded-xl"
        on:click={() => push(`/${desk.key}`)}
      >
        <img
          class="h-24 w-24 rounded-xl object-cover border"
          src={desk.image}
        />
        <div class="flex flex-col items-start">
          <div>{desk.title}</div>
          <div class="flex gap-4">
            <div>{weiToEth(desk['eth-price'])} ETH</div>
          </div>
        </div>
      </button>
    {/each}
  </div>
</div>
