/-  *action, treaty, portal-devs, portal-message, *app-pub, docket
/+  default-agent, dbug, *sig, *sss, *portal-app-pub, agentio, ethereum
/$  app-pub-result-to-json  %app-pub-result  %json
/$  json-to-action  %json  %action
|%
+$  versioned-state
  $%  state-0
      state-1
      state-2
  ==
+$  state-2
  $:  %2
      =authorized-ships  :: remembers which ships are allowed to represent which apps, in portal
      =processing-payments
      =processed-payments
      =desks-for-sale
      rpc-endpoint=@ta
      our-apps=(set [ship desk])  ::treaty published apps
      treaties=(map [ship desk] treaty:treaty)  ::  treaties of both treaty published and PAP published
      pub-portal-devs=_(mk-pubs portal-devs ,[%portal-devs ~])
  ==
+$  state-1
  $:  %1
      =processing-payments
      =processed-payments
      =desks-for-sale
      rpc-endpoint=@ta
      our-apps=(set [ship desk])  ::treaty published apps
      treaties=(map [ship desk] treaty:treaty)  ::  treaties of both treaty published and PAP published
      pub-portal-devs=_(mk-pubs portal-devs ,[%portal-devs ~])
  ==
+$  state-0
  $:  %0
      our-apps=(set [ship desk])
      treaties=(map [ship desk] treaty:treaty)
      pub-portal-devs=_(mk-pubs portal-devs ,[%portal-devs ~])
  ==
+$  card  card:agent:gall
--
%-  agent:dbug
=|  state-2
=*  state  -
^-  agent:gall
=<
|_  =bowl:gall
+*  this  `agent:gall`.
    default   ~(. (default-agent `agent:gall`this %.n) bowl)
    io        ~(. agentio bowl)
    du-portal-devs  =/  du  (du portal-devs ,[%portal-devs ~])
                    (du pub-portal-devs bowl -:!>(*result:du))
++  on-init
  :_  this
  [%pass /agent-init %agent [our dap]:bowl %poke %action !>([%agent-init ~])]~
::
++  on-save   !>(state)
++  on-load   
  |=  =vase
  ^-  (quip card _this)
  =/  old  !<(versioned-state vase)
  =.  state
    ?-  old
        [%0 *]  
      ^-  state-2
      [%2 *^authorized-ships *^processing-payments *^processed-payments *^desks-for-sale '' +.old]
      ::
      [%1 *]  [%2 *^authorized-ships +.old]
      [%2 *]  old
    ==
  on-init
++  on-poke
  |=  [=mark =vase]
  ^-  (quip card _this)
  ?+    mark    (on-poke:default mark vase)
      %action
    ?>  =(our.bowl src.bowl)
    =/  act  !<(action vase)
    ?+    act    !!
        [%set-rpc-endpoint *]
      =.  rpc-endpoint  endpoint.act
      :_  this
      [%give %fact [/updates]~ %app-pub-result !>([%rpc-endpoint rpc-endpoint])]~
      ::
      ::  if desk already for sale, doesn't matter, this is idempotent in that case
      ::  if treaty OOD, publish and sign-app with same settings and it will update
        [%publish *]
      ?.  (~(has in .^((set desk) %cd /(scot %p our.bowl)/base/(scot %da now.bowl))) desk.act)
        ~&  "desk doesn't exist"
        `this
      ?:  (~(has in our-apps) [our.bowl desk.act])
        ~&  "desk treaty published, first unpublish it from treaty to sell it"
        `this
      =/  group-name  (group-from-desk desk.act)
      =/  eth-price  (crip (cass (trip eth-price.act)))
      =/  receiving-address  (crip (cass (trip receiving-address.act)))
      ?:  =(%.n .^(? %cu /(scot %p our.bowl)/[desk.act]/(scot %da now.bowl)/desk/docket-0))
        ~&  >>  "docket doesn't exist"
        `this
      =.  desks-for-sale  (~(put by desks-for-sale) [desk.act eth-price receiving-address])
      =/  docket  .^(docket:docket %cx (scry:io desk.act /desk/docket-0))
      =/  =treaty:treaty  (treaty-from-docket desk.act docket)
      =.  treaties  (~(put by treaties) [our.bowl desk.act] treaty)
    :_  this
      %+  welp 
        :~  [%give %fact [/updates]~ %app-pub-result !>([%desks-for-sale desks-for-sale])]
            [%give %fact [/updates]~ %app-pub-result !>([%treaties treaties])]
            [%pass /docket-next/[desk.act] %arvo %c %warp our.bowl desk.act ~ %next %x da+now.bowl /desk/docket-0]
        ==
      =/  perms  .^([r=dict:clay w=dict:clay] %cp /(scot %p our.bowl)/[desk.act]/(scot %da now.bowl))
                    ::(map @ta crew)
      ?^  (~(get by q.who.rul.r.perms) group-name)
        ~&  >  "if group/crew exists, does nothing"
        ~
      ~&  >  "if group doesnt exist, creates it and gives perms"
      ::  clay overwrites everything, so I have to take all the existing perms
      ::  before adding a perm
      =/  ship-perms  `(set (each @p @ta))`(~(run in p.who.rul.r.perms) |=(ship=@p [%.y ship]))
      =/  cruz-perms  `(set (each @p @ta))`(~(run in ~(key by q.who.rul.r.perms)) |=(crew-name=@ta [%.n crew-name]))
      =/  existing-perms  `(set (each @p @ta))`(~(uni in ship-perms) cruz-perms)
      =+  (~(put in existing-perms) [%.n `@ta`group-name])
      ::  ordering is important
      ::  I guess the cards are taken in a reverse order by Arvo
      :~  [%pass /set-group %arvo %c %cred group-name (sy ~[our.bowl])]
          :*  %pass  /create-group  %arvo  %c
              [%perm desk.act *path [%r `[%white -]]]
          ==
      ==
      ::
      ::  be careful when unpublishing, as buyers will lose access to desk
        [%unpublish *]
      ::  sets desk back to private [%white]
      ?.  (~(has in .^((set desk) %cd /(scot %p our.bowl)/base/(scot %da now.bowl))) desk.act)
        ~&  "desk doesn't exist"
        `this
      ?.  (~(has by desks-for-sale) desk.act)
        ~&  "desk {<desk.act>} not for sale anyways"
        `this
      =/  group-name  (group-from-desk desk.act)
      =.  desks-for-sale  (~(del by desks-for-sale) desk.act)
      =/  perms  .^([r=dict:clay w=dict:clay] %cp /(scot %p our.bowl)/[desk.act]/(scot %da now.bowl))
      :_  this
      ;:  welp  
          [%give %fact [/updates]~ %app-pub-result !>([%desks-for-sale desks-for-sale])]~
          ~&  >>  "unpublish: revoke perms"
          [%pass /set-group %arvo %c %cred group-name *(set ship)]~
          ?~  dev=(~(get by authorized-ships) [our.bowl desk.act])
            ~
          :_  ~
          :*  %pass  /sign  %agent  [u.dev %portal-manager]  %poke  
              %portal-message  !>  [%unpublish desk.act]
          ==
      ==
      ::
        [%sign-app *]
      =/  dist-desk  (parse-dist-desk dist-desk.act)
      ?~  dist-desk  !!
      =/  desk-flag  [dist-name desk-name]:u:dist-desk
      ?~  treaty=(~(gut by treaties) desk-flag ~)
        ~&  >  "app is either not treaty published, or it is not published with %portal-app-publisher"
        `this
      =/  eth-price=(unit @t)
        ?~  v=(~(gut by desks-for-sale) desk-name.u.dist-desk ~)
          ~
        (some eth-price:v)
      =^  cards-1  pub-portal-devs
        (give:du-portal-devs [%portal-devs ~] [%put desk-flag dev.act])
      =.  authorized-ships
        (~(put by authorized-ships) desk-flag dev.act)
      :_  this
      %+  welp  cards-1
      :~  :*  %give  %fact  [/updates]~  %app-pub-result  !>
              [%portal-devs rock:(~(got by read:du-portal-devs) [%portal-devs ~])]  
          ==
          :*  %pass  /sign  %agent  [dev.act %portal-manager]  %poke  
              %portal-message  !>
              [%sign-app dist-desk.act (sign our.bowl now.bowl act) treaty eth-price]
      ==  ==
      ::
        [%agent-init ~]
      =.  our-apps.state  ;;  (set [ship desk])
        %-  tail
        .^  update:alliance:treaty  %gx
            /(scot %p our.bowl)/treaty/(scot %da now.bowl)/alliance/noun
        ==
      =/  cards=(list card)
        =+  ~(tap in our-apps.state)
        %+  murn  -
        |=  [=ship =desk]
        ?:  (~(has by wex.bowl) [/our-treaty/(scot %p ship)/[desk] our.bowl %treaty])
          ~
        %-  some
        :*  %pass  /our-treaty/(scot %p ship)/[desk]  %agent
            [our.bowl %treaty]  %watch  /treaty/(scot %p ship)/[desk]
        ==
      =^  cards-1  pub-portal-devs  
        (give:du-portal-devs [%portal-devs ~] [%init ~])
      :_  this
      ;:  welp  cards  cards-1
      ?:  (~(has by wex.bowl) [/our-apps our.bowl %treaty])
          ~
        [%pass /our-apps %agent [our.bowl %treaty] %watch /alliance]~
      ==
    ==
    ::
      %portal-message
    =/  msg  !<(message:portal-message vase)
    ?+    msg    `this
        [%payment-request *]
      =/  hex  (crip (cass (num-to-hex:ethereum (mod eny.bowl (pow 4 16)))))
      ?~  sale=(~(get by desks-for-sale) desk.msg)
        ~&  >>  "{<desk.msg>} desk not for sale"
        `this
      =,  u.sale  :: exposes eth-price and receiving-address
      =/  perms  .^([r=dict:clay w=dict:clay] %cp /(scot %p our.bowl)/[desk.msg]/(scot %da now.bowl))
      ?~  crew=(~(get by q.who.rul.r.perms) (group-from-desk desk.msg))
        ~&  >>  "perms in clay not correct for desk {<desk.msg>}"
        `this
      ?:  (~(has in u.crew) src.bowl)
        ~&  >>  "desk {<desk.msg>} already bought by {<src.bowl>}" 
        `this
      =.  processing-payments
        (~(put by processing-payments) hex [src.bowl desk.msg eth-price receiving-address])
      :_  this
      :~  :*  %give  %fact  [/updates]~  %app-pub-result  !>
          [%processing-payments processing-payments]  
          ==
          :*  %pass  /payment-ref  %agent  [src.bowl %portal-manager]  %poke  
          %portal-message  !>([%payment-reference hex eth-price receiving-address])
      ==  ==
      ::
        [%payment-tx-hash *]
      :_  this
      ~&  >  "received hash"
      ::  check if in processed payments
      =/  tx-hash-msg  (crip (cass (trip tx-hash.msg)))
      =/  processed  ^-  ^processed-payments  %+  skim  
          processed-payments
        |=  [=buyer =desk tx-hash=@t =time]
        ?&  =(buyer src.bowl)
            =(tx-hash tx-hash-msg)
        ==
      ?~  processed
        ::  if not in processed payments, validate transaction
        [%pass /get-tx %arvo %k %fard q.byk.bowl %get-tx-by-hash %noun !>([rpc-endpoint src.bowl tx-hash-msg])]~
      ::  if in processed payments
      =+  desk:(snag 0 `^processed-payments`processed)
      %+  snoc  (add-to-crew - [src our now]:bowl)
      :*  %pass  /payment-confirm  %agent  [src.bowl %portal-manager]  %poke  
          %portal-message  !>([%payment-confirmed tx-hash-msg -])
      ==
    ==
    ::
      %sss-to-pub
    =/  msg  !<(into:du-portal-devs (fled vase))
    =^  cards  pub-portal-devs  (apply:du-portal-devs msg)
    [cards this]
  ==
++  on-watch  _`this
++  on-leave  on-leave:default
++  on-peek
  |=  =path
  ^-  (unit (unit cage))
  ?+    path    (on-peek:default path)
    [%x %processing-payments ~]  ``app-pub-result+!>([%processing-payments processing-payments])
    [%x %processed-payments ~]   ``app-pub-result+!>([%processed-payments processed-payments])
    [%x %desks-for-sale ~]       ``app-pub-result+!>([%desks-for-sale desks-for-sale])
    [%x %rpc-endpoint ~]         ``app-pub-result+!>([%rpc-endpoint rpc-endpoint])   
    [%x %our-apps ~]             ``app-pub-result+!>([%our-apps our-apps]) 
    [%x %treaties ~]             ``app-pub-result+!>([%treaties treaties]) 
    [%x %portal-devs ~]          ``app-pub-result+!>([%portal-devs rock:(~(got by read:du-portal-devs) [%portal-devs ~])])     
  ==
::
++  on-agent
  |=  [=wire =sign:agent:gall]
  ^-  (quip card _this)
  ?+    wire    (on-agent:default wire sign)
      [~ %sss %scry-response @ @ @ %portal-devs ~]
    =^  cards  pub-portal-devs  (tell:du-portal-devs |3:wire sign)
    [cards this]
    ::
      [%our-apps ~]
    ::  this takes just apps ids
    ?+    -.sign    (on-agent:default wire sign)
        %fact
      =/  upd  !<(update:alliance:treaty q.cage.sign)
      =^  cards  state
        ?-  -.upd
          ::  get treaty, and then add to treaties
            %add  
          =.  our-apps  (~(put in our-apps) [ship.upd desk.upd])
          :_  state
          :~  :*  %pass  /our-treaty/(scot %p ship.upd)/[desk.upd]  %agent
              [our.bowl %treaty]  %watch  /treaty/(scot %p ship.upd)/[desk.upd]
              ==  
             [%give %fact [/updates]~ %app-pub-result !>([%our-apps our-apps])]
          ==
          ::
          ::  remove from our-apps, keep treaty in treaties
            %del
          =.  our-apps  (~(del in our-apps) [ship desk]:upd)
          `state
          ::
          ::  never get %ini?
            %ini  
          =.  our-apps  init.upd
          `state
        ==
      [cards this]
    ==
    ::
      [%our-treaty @ @ ~]
    ::  this take treaty which we subbed to in %add, on %our-apps wire
    ?+    -.sign    (on-agent:default wire sign)
        %fact
      =/  treaty  !<(treaty:treaty q.cage.sign)
      =.  treaties  (~(put by treaties) [our.bowl `@t`i.t.t.wire] treaty)
      :_  this
      [%give %fact [/updates]~ %app-pub-result !>([%treaties treaties])]~
    ==
  ==
++  on-arvo
  |=  [=wire sign=sign-arvo]
  ^-  (quip card:agent:gall _this)
  ?+    wire    `this
      [%docket-next @ ~]
    ?>  ?=([?(%clay %behn) %writ *] sign)
    =/  desk  i.t.wire
    ?.  (~(has by treaties) [our.bowl desk])
      `this
    ?~  p.sign  ::  docket file is gone
      ~&  >>>  "{(scow %t desk)} docket file was deleted"
      =.  treaties  (~(del by treaties) [our.bowl desk])
      `this
    =/  cage  r.u.p.sign
    ?.  =(%docket-0 p.cage)
      `this
    =+  !<(=docket:docket q.cage)
    =/  =treaty:treaty  (treaty-from-docket desk docket)
    =.  treaties  (~(put by treaties) [our.bowl desk] treaty)
    :_  this
    %+  welp
      [%pass /docket-next/[desk] %arvo %c %warp our.bowl desk ~ %next %x da+now.bowl /desk/docket-0]^~
    ?~  dev=(~(get by authorized-ships) [our.bowl desk])
      ~
    =/  dist-desk  (crip ;:(welp (scow %p our.bowl) "/" (trip desk)))
    :_  ~
    :*  %pass  /sign  %agent  [u.dev %portal-manager]  %poke  
        %portal-message  !>
        :*  %sign-app
            dist-desk
            (^sign our.bowl now.bowl [%sign-app u.dev dist-desk])
            treaty
            `eth-price:(~(got by desks-for-sale) desk)
    ==  ==
    ::
      [%get-tx ~]
    ?>  ?=([%khan %arow *] sign)
    ?.  ?=(%.y -.p.sign)
      ~&  >>  "fetching data failed"
      `this
    =+  !<([tx-hash=@t src=@p result=?(~ transaction-result)] q.p.p.sign)
    ?~  result
      ~&  >>  "transaction wasn't made over last 24 hr"
      `this
    =/  hex                (crip (cass (trip input.result)))
    =/  receiving-address  (crip (cass (trip (fall to.result ''))))
    =/  eth-paid           (crip (cass (trip (need value.result))))  ::  is this always hex???
    ?~  processing-data=(~(get by processing-payments) hex)
      ~&  >>  "payment with this hex ({<hex>}) not in processing payments"
      `this
    ?:  !=(receiving-address receiving-address.u.processing-data)
      ~&  >>  "tx receiving address: {<(fall to.result '')>}"
      ~&  >>  "our receiving address: {<receiving-address.u.processing-data>}"
      `this
    ?:  !=(src buyer.u.processing-data)
      ~&  >>  "malicious actor!"
      ~&  >>  "{<src>} asked for install, but buyer is actually {<buyer.u.processing-data>}"
      `this
    ?:  !(paid-enough eth-paid eth-price.u.processing-data)
      ~&  >>  "paid: {<eth-paid>}"
      ~&  >>  "price: {<eth-price.u.processing-data>}"
      ~&  >>  "payment too smol"
      `this
    ~&  >  "success!"
    =.  processing-payments  (~(del by processing-payments) hex)
    =.  processed-payments  %+  snoc  processed-payments
      [buyer.u.processing-data desk.u.processing-data (crip (cass (trip tx-hash))) now.bowl]
    :_  this
    %+  welp  ::  giving read perms to buyer
      (add-to-crew desk.u.processing-data buyer.u.processing-data our.bowl now.bowl)
    :~  :*  %pass  /payment-confirm  %agent  [buyer.u.processing-data %portal-manager]  %poke  
            %portal-message  !>([%payment-confirmed tx-hash desk.u.processing-data])
        ==
        :*  %give  %fact  [/updates]~  %app-pub-result  !>
            [%processing-payments processing-payments]  
        ==
        :*  %give  %fact  [/updates]~  %app-pub-result  !>
            [%processed-payments processed-payments]  
        ==
    ==
  ==
::
++  on-fail   on-fail:default
--
|_  =bowl:gall
+*  this  .
    io        ~(. agentio bowl)
++  treaty-from-docket
  |=  [=desk =docket:docket]
  =+  .^(=cass:clay %cw (scry:io desk /desk/docket))
  =+  .^(hash=@uv %cz (scry:io desk ~))
  [our.bowl desk da+da.cass hash docket]
--