|%
:: if you hit entropy collision, you will be rewarded 1000 portal score
+$  processing-payments  (map hex [=buyer =desk =eth-price =receiving-address])
+$  processed-payments  (list [=buyer =desk tx-hash=@ux =time])
+$  desks-for-sale  (map desk [=eth-price =receiving-address])  :: doesn't remember if eth-price changes
::
::  todo receiving address in desks-for-sale and %publish action
+$  receiving-address  @ux
+$  eth-price  @ud
+$  buyer  ship
+$  hex  @ux
+$  group  [name=@ta ships=(set ship)]
::
+$  app-pub-result
  $%  [%processing-payments =processing-payments]
      [%processed-payments =processed-payments]
      [%desks-for-sale =desks-for-sale]
  ==
--