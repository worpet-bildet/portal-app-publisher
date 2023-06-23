/-  *action, docket, treaty, *app-pub
/+  ethereum, treaty-lib=treaty
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
        %rpc-endpoint
      %+  frond  'rpc-endpoint'  s++.result
        %treaties
      %+  frond  'treaties'  (enjs-treaties +.result)
        %our-apps
      %+  frond  'our-apps'  (enjs-our-apps +.result)
        %portal-devs
      %+  frond  'portal-devs'  (enjs-portal-devs +.result)
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
        ['eth-price' s+(scot %ud eth-price)]
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
    :~  ['eth-price' s+(scot %ud eth-price)]
        ['receiving-address' (enjs-hex receiving-address)]
    ==
  ::
  ++  enjs-our-apps
    |=  our-apps=(set [ship=@p desk=@tas])
    ^-  json
    :-  %a
    =+  ~(tap in our-apps)
    %+  turn  -
    |=  [ship=@p desk=@tas]
    ^-  json
    %-  pairs
    :~  ['ship' (enjs-ship ship)]
        ['desk' s+desk]
    ==
  ::
  ++  enjs-portal-devs
    |=  portal-devs=(map [ship=@p desk=@tas] @p)
    ^-  json
    :-  %o
    =+  ~(tap by portal-devs)
    %-  malt  %+  turn  -
    |=  [k=[ship=@p desk=@tas] v=@p]
    ^-  [@t json]
    :-  (crip ;:(welp (scow %p ship.k) "/" (scow %tas desk.k)))
    (enjs-ship v)
  ::
  ++  enjs-treaties
    |=  treaties=(map [ship=@p desk=@tas] treaty:treaty)
    ^-  json
    :-  %o
    =+  ~(tap by treaties)
    %-  malt  %+  turn  -
    |=  [k=[ship=@p desk=@tas] =treaty:treaty]
    ^-  [@t json]
    :-  (crip ;:(welp (scow %p ship.k) "/" (scow %tas desk.k)))
    (enjs-treaty treaty)
  ::
  ++  enjs-treaty
    |=  =treaty:treaty
    (treaty:enjs:treaty-lib treaty)
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
    :~  [%sign-app (ot:dejs ~[dev+dejs-ship dist-desk+so])]
        [%publish (ot:dejs ~[desk+so eth-price+ni receiving-address+dejs-hex])]
        [%unpublish (ot:dejs ~[desk+so])]
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
