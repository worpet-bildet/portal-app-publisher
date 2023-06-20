/-  treaty
/+  *sig
|%
+$  message
  $%  [%sign-app dist-desk=@t sig=signature =treaty:treaty]
      ::
      [%payment-request =desk]
      [%payment-reference receiving-address=@ux hex=@ux eth-price=@ud]
      [%payment-tx-hash tx-hash=@ux]
      [%payment-confirmed tx-hash=@ux =desk]
  ==
--
