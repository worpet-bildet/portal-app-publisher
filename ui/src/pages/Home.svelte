<script>
  import { push } from 'svelte-spa-router';
  import { state } from '@root/state';

  // TODO:
  // fetch the apps that a user has installed from docket? do we only want to
  // fetch the apps that a user is selling / has published? or all of them?
  // show the information about those apps in a list
  // the user has to enter the name of the desk that they are going to publish
  // i'm not sure whether we can get information about this desk at this point?
</script>

<div class="flex flex-col items-start gap-8">
  <div class="flex w-full justify-between">
    <h1>My Apps</h1>
    <button on:click={() => push('/sell')}>New App</button>
  </div>
  <div class="flex flex-col gap-8 w-full">
    {#each $state.apps as { desk, name, image, price, purchases }}
      <button
        class="flex items-center gap-4 rounded-xl p-4"
        on:click={() => push(`/${desk}`)}
      >
        <img class="h-24 w-24 rounded-xl object-cover" src={image} />
        <div class="flex flex-col items-start">
          <div>{name}</div>
          <div class="flex gap-4">
            <div>{price} ETH</div>
            <div>{purchases} sales</div>
          </div>
        </div>
      </button>
    {/each}
  </div>
</div>
