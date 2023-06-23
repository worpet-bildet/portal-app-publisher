/-  treaty
|%
:: if you hit entropy collision, you will be rewarded 1000 portal score
+$  processing-payments  (map hex [=buyer =desk =eth-price =receiving-address])
+$  processed-payments  (list [=buyer =desk tx-hash=@t =time])
+$  desks-for-sale  (map desk [=eth-price =receiving-address])  :: doesn't remember if eth-price changes
::
::  todo receiving address in desks-for-sale and %publish action
+$  receiving-address  @t
+$  eth-price  @t
+$  buyer  ship
+$  hex  @t
+$  group  [name=@ta ships=(set ship)]
::
+$  app-pub-result
  $%  [%processing-payments =processing-payments]
      [%processed-payments =processed-payments]
      [%desks-for-sale =desks-for-sale]
      [%rpc-endpoint rpc-endpoint=@ta]
      [%treaties treaties=(map [=ship =desk] treaty:treaty)]
      [%our-apps our-apps=(set [=ship =desk])]  :: treaty published apps
      [%portal-devs portal-devs=(map [ship=@p desk=@tas] ship)]  :: desk to portal ship which owns it on portal
  ==
--