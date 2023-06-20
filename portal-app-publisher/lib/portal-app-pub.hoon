/+  ethereum
::  we modify some things from ethereum.hoon
|%
++  parse-transaction-result
  =,  dejs:format
  |=  jon=json
  ~|  jon=jon
  ^-  transaction-result
  =-  ((ot -) jon)
  ::  why are some of these units and some not?
  ::  doesn't seem to correspond to (non)required values in eth schemas
  :~  'blockHash'^_~  :: TODO: fails if maybe-num?
      'blockNumber'^maybe-num:rpc:ethereum
      'transactionIndex'^maybe-num:rpc:ethereum
      from+(cu hex-to-num:ethereum so)
      to+maybe-num:rpc:ethereum
      input+so
      value+maybe-num:rpc:ethereum
  ==
::
++  transaction-result
  $:  block-hash=(unit @ux)
      block-number=(unit @ud)
      transaction-index=(unit @ud)
      from=@ux
      to=(unit @ux)
      input=@t
      value=(unit @ux)
  ==
::
::  some helpers
++  parse-dist-desk
  |=  [dist-desk=@t]
  ^-  (unit [dist-name=ship desk-name=@tas])
  =/  dist-desk  (trip dist-desk)
  =/  loc  (find ['/']~ dist-desk)
  ?~  loc  ~
  =/  ship-unit  (slaw %p (crip (scag u.loc dist-desk)))
  ?~  ship-unit  ~
  %-  some  :-  (need ship-unit)
  `@tas`(crip (slag +(u.loc) dist-desk))
--