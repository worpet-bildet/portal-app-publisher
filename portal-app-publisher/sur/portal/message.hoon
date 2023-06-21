/-  treaty
/+  *sig
|%
+$  message
  $%  [%sign-app dist-desk=@t sig=signature =treaty:treaty]
      ::
      [%payment-request =desk]
      [%payment-reference hex=@ux eth-price=@ud receiving-address=@ux]
      [%payment-tx-hash tx-hash=@ux]
      [%payment-confirmed tx-hash=@ux =desk]
  ==
--
