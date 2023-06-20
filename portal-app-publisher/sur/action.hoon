|%
+$  action  
  $%  [%sign-app dev=ship dist-desk=@t]
      [%agent-init ~]
      [%set-receiving-address receiving-address=@ux]
      [%get-tx-by-hash url=@ta tx-hash=@t]
      ::  DON'T publish with treaty because that automatically makes the desk public
      [%publish =desk eth-price=@ud]  
      ::  [%unpublish =desk] ?
      ::  .^([r=dict:clay w=dict:clay] %cp /=app1=)
      :: |pass c+[%perm %app1 *path [%r `[%white (sy ~[[%.n 'portal-sell-app1']])]]]
      ::  -send-task-take-gift [%cred 'portal-sell-app1' (sy ~[~zod])]
      ::::
      ::  what should be in the state for app-pub (e.g. ships who payed and how much)
      [%blah ~]
      ::
      ::  ask people to make docket file which we read from portal-app-pub
      ::  price -> in %app item (how to get it there?)
      ::  recepient address -> on portal app pub
      ::
      ::  buyer pokes from his portal to seller's app pub
      ::  seller creates random data and saves in state
      ::  sends that data back to the buyer + receiving address
      ::  buyer pays, sends tx-hash
      ::  seller checks tx, makes sure that the amount is correct + random data is correct
      ::  sellers changes perms, sends the poke to buyer, buyer downloads app
      ::
      ::  how much dev has made on portal
      ::  some summarizer of data for devs (how much they've made)
      ::
      ::  how will it look in portal?

  ==
--
