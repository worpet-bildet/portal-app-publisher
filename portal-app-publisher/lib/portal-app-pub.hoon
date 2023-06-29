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
      from+so::(cu hex-to-num:ethereum so)
      to+so:dejs-soft:format:: maybe-num:rpc:ethereum
      input+so
      value+so:dejs-soft:format ::maybe-num:rpc:ethereum
  ==
::
++  transaction-result
  $:  block-hash=(unit @ux)
      block-number=(unit @ud)
      transaction-index=(unit @ud)
      from=@t
      to=(unit @t)
      input=@t
      value=(unit @t)  ::  assuming this will always be hex!
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
::
++  group-from-desk
  |=  =desk
  ^-  @ta
  (crip (weld "portal-sold-" (trip desk)))
::
::  paid is hex
::  price is decimal integer
++  paid-enough
  |=  [paid=@t price=@t]
  ^-  ?
  %+  gte
  `@ud`(hex-to-num:ethereum paid)
  `@ud`(scan (trip price) dem)
::
++  add-to-crew
  |=  [=desk =ship our=ship now=time]
  ^-  (list card:agent:gall)
  =/  perms  .^([r=dict:clay w=dict:clay] %cp /(scot %p our)/[desk]/(scot %da now))
  =/  group-name  (group-from-desk desk)
  ?^  crew=(~(get by q.who.rul.r.perms) group-name)
    [%pass /set-group %arvo %c %cred group-name (~(put in u.crew) ship)]~
  ::
  ::  clay overwrites everything, so I have to take all the existing perms
  ::  before adding a perm
  =/  ship-perms  `(set (each @p @ta))`(~(run in p.who.rul.r.perms) |=(ship=@p [%.y ship]))
  =/  cruz-perms  `(set (each @p @ta))`(~(run in ~(key by q.who.rul.r.perms)) |=(crew-name=@ta [%.n crew-name]))
  =/  existing-perms  `(set (each @p @ta))`(~(uni in ship-perms) cruz-perms)
  =+  (~(put in existing-perms) [%.n `@ta`group-name])
  :~  :*  %pass  /create-group  %arvo  %c
          [%perm desk *path [%r `[%white -]]]
      ==
      [%pass /set-group %arvo %c %cred group-name (sy ~[our ship])]
  ==
--