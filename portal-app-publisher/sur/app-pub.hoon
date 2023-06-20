|%
:: if you hit entropy collision, you will be rewarded 1000 portal score
+$  processing-payments  (map hex [=buyer =desk =eth-price =receiving-address])
+$  desks-for-sale  (map desk [=eth-price =group])
::
+$  receiving-address  @ux
+$  eth-price  @ud
+$  buyer  ship
+$  hex  @ux
+$  group  (set ship)
::
+$  app-pub-result
  $%  [%processing-payments =processing-payments]
      [%desks-for-sale =desks-for-sale]
      [%receiving-address =receiving-address]
  ==
--
