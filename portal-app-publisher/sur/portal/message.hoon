/-  treaty, *app-pub
/+  *sig
|%
+$  message
  $%  ::  make sure to keep the previous funcitonality, while adding price and paymen
      [%sign-app dist-desk=@t sig=signature =treaty:treaty eth-price=(unit @t)]
      ::
      [%unpublish =desk]
      ::
      ::  seller receives
      [%payment-request =desk]
      ::  seller sends
      [%payment-reference hex=@t eth-price=@t receiving-address=@t]
      ::  seller receives
      [%payment-tx-hash tx-hash=@t]
      ::  sellers sends
      [%payment-confirmed tx-hash=@t =desk]
  ==
--
