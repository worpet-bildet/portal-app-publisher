<script>
  import { api, mockData } from '@root/api';

  let methods = Object.entries(api);
  // let methods = [];
</script>

<div class="flex flex-col gap-8">
  {#each methods as [name, fn]}
    {@const data = mockData[name] || []}
    <div class="flex w-full justify-between">
      <div>{name}</div>
      {#await fn(...data)}
        <div>Calling...</div>
      {:then}
        <div>Done!</div>
      {:catch}
        <div class="text-error">Failed!</div>
      {/await}
    </div>
  {/each}
</div>
