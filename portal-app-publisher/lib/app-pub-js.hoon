/-  *action, docket, treaty, *app-pub
/+  ethereum
|%
++  enjs
  =,  enjs:format
  |%
  ++  enjs-app-pub-result
    |=  [result=app-pub-result]
    ^-  json
    ?-  -.result
        %processing-payments  
      %+  frond  'processing-payments'  (enjs-processing-payments +.result)
        %processed-payments
      %+  frond  'processed-payments'  (enjs-processed-payments +.result)
        %desks-for-sale
      %+  frond  'desks-for-sale'  (enjs-desks-for-sale +.result)
    ==
  ::
  ++  enjs-processing-payments
    |=  [=processing-payments]
    ^-  json
    :-  %o
    =+  ~(tap by processing-payments)
    %-  malt  %+  turn  -
    |=  [hex=@ux [=buyer =desk =eth-price =receiving-address]]
    ^-  [@t json]
    :-  ;;(@t +:(enjs-hex hex))
    %-  pairs
    :~  ['buyer' (enjs-ship buyer)]
        ['desk' s+desk]
        ['eth-price' n+(scot %ud eth-price)]
        ['receiving-address' (enjs-hex receiving-address)]
    ==
  ::
  ++  enjs-processed-payments
    |=  [=processed-payments]
    ^-  json
    :-  %a
    %+  turn  processed-payments
    |=  [=buyer =desk tx-hash=@ux time=@da]
    ^-  json
    %-  pairs
    :~  ['buyer' `json`(enjs-ship buyer)]
        ['desk' `json`s+desk]
        ['tx-hash' `json`(enjs-hex tx-hash)]
        ['time' `json`(^time time)]
    ==
  ::
  ++  enjs-desks-for-sale
    |=  [=desks-for-sale]
    ^-  json
    :-  %o
    =+  ~(tap by desks-for-sale)
    %-  malt  %+  turn  -
    |=  [=desk [=eth-price =receiving-address]]
    ^-  [@t json]
    :-  desk
    %-  pairs
    :~  ['eth-price' n+(scot %ud eth-price)]
        ['receiving-address' (enjs-hex receiving-address)]
    ==
  ::
  ++  enjs-hex
    |=  hex=@ux
    ^-  json
    s+(crip (num-to-hex:ethereum hex))
  ::
  ++  enjs-ship
    |=  ship=@p
    ^-  json
    s+`@t`(scot %p ship)
  ::++  enjs
  --
::
++  dejs
  =,  dejs:format
  |%
  ++  dejs-action
    |=  jon=json
    ;;  action
    %.  jon
    %-  of
    :~  [%sign-app (ot:dejs ~[dev+dejs-ship dits-desk+so])]
        [%publish (ot:dejs ~[desk+so eth-price+ni receiving-address+dejs-hex])]
        [%set-rpc-endpoint (ot:dejs ~[endpoint+so])]
    ==
  ++  dejs-hex
    |=  jon=json
    ;;  @ux
    ?>  ?=([%s *] jon)
    (hex-to-num:ethereum +.jon)
  ++  dejs-path
    |=  jon=json
    ^-  path
    (path (stab (so:dejs jon)))
  ++  dejs-ship
    |=  jon=json
    ^-  @p
    ((se:dejs %p) jon)
  ++  dejs-hash
    |=  jon=json
    ^-  @uv
    `@uv`(slav %uv (so:dejs jon))
  --
--
