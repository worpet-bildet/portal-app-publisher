/-  treaty, *app-pub
/+  *sig
|%
+$  message
  $%  ::  make sure to keep the previous funcitonality, while adding price and paymen
      [%sign-app dist-desk=@t sig=signature =treaty:treaty eth-price=(unit @ud)]
      ::
      ::  seller receives
      [%payment-request =desk]
      ::  seller sends
      [%payment-reference hex=@ux eth-price=@ud receiving-address=@ux]
      ::  seller receives
      [%payment-tx-hash tx-hash=@ux]
      ::  sellers sends
      [%payment-confirmed tx-hash=@ux =desk]
  ==
--
