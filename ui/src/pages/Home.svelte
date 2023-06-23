<script>
  import { push } from 'svelte-spa-router';
  import { api } from '@root/api';
  import { state, getDeskDetails } from '@root/state';

  const { setRpcEndpoint } = api;

  // TODO:
  // fetch the apps that a user has installed from docket? do we only want to
  // fetch the apps that a user is selling / has published? or all of them?
  // show the information about those apps in a list
  // the user has to enter the name of the desk that they are going to publish
  // i'm not sure whether we can get information about this desk at this point?
  let desks = [];
  let rpcEndpoint;
  state.subscribe((s) => {
    ({ rpcEndpoint } = s);
    desks = Object.entries(s['desks-for-sale']).map(([key, data]) => ({
      key,
      ...getDeskDetails(key),
      ...data,
    }));
    console.log({ desks });
  });
</script>

<div class="flex flex-col items-end gap-8">
  <div class="flex gap-4 items-center">
    ETH RPC: <input type="text" class="p-2" bind:value={rpcEndpoint} />
    <button on:click={() => setRpcEndpoint(rpcEndpoint)}>Save</button>
  </div>
  <div class="flex flex-col gap-8 w-full">
    {#each desks as desk}
      <button
        class="flex items-center gap-4 rounded-xl p-4"
        on:click={() => push(`/${desk.key}`)}
      >
        <img class="h-24 w-24 rounded-xl object-cover" src={desk.image} />
        <div class="flex flex-col items-start">
          <div>{desk.title}</div>
          <div class="flex gap-4">
            <div>{desk['eth-price']} ETH</div>
          </div>
        </div>
      </button>
    {/each}
  </div>
</div>
