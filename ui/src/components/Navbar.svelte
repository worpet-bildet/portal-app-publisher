<script>
  import { push, link } from 'svelte-spa-router';
</script>

<div class="flex justify-between gap-4 w-full p-10">
  <a use:link href="/" class="text-2xl text-white hover:text-white"
    >💸 Portal App Publisher</a
  >
  <div class="flex gap-4">
    <button on:click={() => push('/')}>Home</button>
    <button on:click={() => push('/sell')}>+ New App</button>
  </div>
</div>
