/-  *action, docket, treaty
/+  ethereum
|%
++  enjs
  =,  enjs:format
  |%
  ++  enjs-ship
    |=  ship=@p
    ^-  json
    s+`@t`(scot %p ship)
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
        [%set-receiving-address (ot:dejs ~[receiving-address+dejs-hex])]
        [%publish (ot:dejs ~[desk+so eth-price+ni])]
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