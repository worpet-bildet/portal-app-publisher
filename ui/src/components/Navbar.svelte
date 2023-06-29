<script>
  import { push, link } from 'svelte-spa-router';
</script>

<div class="flex justify-between gap-4 w-full p-10 border-b border-spacer">
  <a use:link href="/" class="text-2xl text-left"
    ><div class="font-logo text-grey">PORTAL</div>
    <div class="text-sm">app publisher</div></a
  >
  <div class="flex gap-4 font-saucebold">
    <button
      class="rounded-xl flex font-saucebold items-center px-4 hover:duration-500 py-2 md:py-0"
      on:click={() => push('/')}>Home</button
    >
    <button
      class="rounded-xl flex font-saucebold items-center px-4 hover:duration-500 py-2 md:py-0"
      on:click={() => push('/sell')}>+ Sell App</button
    >
  </div>
</div>
