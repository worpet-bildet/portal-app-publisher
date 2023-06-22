<script>
  import { api } from '@root/api';

  let methods = Object.entries(api);
</script>

<div class="flex flex-col gap-8">
  {#each methods as [name, fn]}
    <div class="flex w-full justify-between">
      <div>{name}</div>
      {#await fn()}
        <div>Calling...</div>
      {:then res}
        {console.log({ name, result: res }) || ''}
        <div>Done!</div>
      {:catch}
        <div class="text-error">Failed!</div>
      {/await}
    </div>
  {/each}
</div>
