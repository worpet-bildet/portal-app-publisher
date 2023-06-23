|%
+$  action  
  $%  [%sign-app dev=ship dist-desk=@t]  :: if you sign an app which is for sale, it will send the price
      [%agent-init ~]
      [%publish =desk eth-price=@t receiving-address=@t]  
      [%unpublish =desk]
      [%set-rpc-endpoint endpoint=@ta]
      [%test-payment-confirmed =ship =desk]
      ::
      [%blah ~]
      ::
      ::  ask people to make docket file which we read from portal-app-pub
      ::
      ::  Payment Flow
      ::  buyer pokes from his portal to seller's app pub
      ::  seller creates random data and saves in state
      ::  sends that data back to the buyer + receiving address
      ::  buyer pays, sends tx-hash
      ::  seller checks tx, makes sure that the amount is correct + random data is correct
      ::  sellers changes perms, sends the poke to buyer, buyer downloads app
      ::
      ::
      ::  how much dev has made on portal
      ::  some summarizer of data for devs (how much they've made)
      ::
  ==
--
