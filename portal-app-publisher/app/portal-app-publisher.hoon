/-  *action, treaty, portal-devs, portal-message, *app-pub
/+  default-agent, dbug, *sig, *sss, *portal-app-pub
|%
+$  versioned-state
  $%  state-0
      state-1
  ==
+$  state-1
  $:  %1
      =processing-payments
      =processed-payments
      =desks-for-sale
      rpc-endpoint=@ta
      our-apps=(set [ship desk])
      treaties=(map [ship desk] treaty:treaty)
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
=|  state-1
=*  state  -
^-  agent:gall
|_  =bowl:gall
+*  this  `agent:gall`.
    default   ~(. (default-agent `agent:gall`this %.n) bowl)
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
      [%0 *]  [%1 *^processing-payments *^processed-payments *^desks-for-sale '' +.old]
      [%1 *]  old
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
      `this
      ::
        [%publish *]
      ::  TODO test flow
      ?.  (~(has in .^((set desk) %cd /(scot %p our.bowl)/base/(scot %da now.bowl))) desk.act)
        ~&  "desk doesn't exist"
        `this
      ?.  (~(has in our-apps) [our.bowl desk.act])
        ~&  "desk treaty published, first unpublish it from treaty to sell it"
        `this
      ?:  (~(has by desks-for-sale) desk.act)
        ~&  "desk {<desk>} already published"
        `this
      =/  group-name  (group-from-desk desk.act)
      =.  desks-for-sale  (~(put by desks-for-sale) [desk eth-price receiving-address]:act)
      =/  perms  .^([r=dict:clay w=dict:clay] %cp /=[desk.act]=)
      :_  this
                    ::(map @ta crew) 
      ?^  (~(get by q.who.rul.r.perms) group-name)
        ~
      :~  :*  %pass  /create-group  %arvo  %c
              [%perm desk.act *path [%r `[%white (sy ~[[%.n group-name]])]]]
          ==
          [%pass /set-group %arvo %c %cred group-name (sy ~[our.bowl])]
      ==
      ::
        [%sign-app *]
      =/  dist-desk  (parse-dist-desk dist-desk.act)
      ?~  dist-desk  !!
      =/  treaty  (~(got by treaties) [dist-name desk-name]:u:dist-desk)
      =^  cards-1  pub-portal-devs
        (give:du-portal-devs [%portal-devs ~] [%put [dist-name desk-name]:u:dist-desk dev.act])
      :_  this
      %+  snoc  cards-1
      :*  %pass  /sign  %agent  [dev.act %portal-manager]  %poke  
          %portal-message  
          !>([%sign-app dist-desk.act (sign our.bowl now.bowl act) treaty])
      ==
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
      =/  hex  `@ux`(mod eny.bowl (pow 4 16))
      ::  crash if not for sale
      =/  [=eth-price =receiving-address]  (~(got by desks-for-sale) desk.msg)
      =/  perms  .^([r=dict:clay w=dict:clay] %cp /=[desk.msg]=)
      ?~  crew=(~(get by q.who.rul.r.perms) (group-from-desk desk.msg))
        ~&  >>  "desk not for sale"
        `this
      ?:  (~(has in u.crew) src.bowl)
        ~&  >>  "desk {<desk.msg>} already bought by {<src.bowl>}" 
        `this
      =.  processing-payments
        (~(put by processing-payments) hex [src.bowl desk.msg eth-price receiving-address])
      :_  this
      :~  :*  %pass  /payment-ref  %agent  [src.bowl %portal-manager]  %poke  
          %portal-message  !>([%payment-reference hex eth-price receiving-address])
      ==  ==
      ::
        [%payment-tx-hash *]
      ~&  >  "received hash"
      :_  this
      [%pass /get-tx %arvo %k %fard dap.bowl %get-tx-by-hash %noun !>(['https://mainnet.infura.io/v3/9b96ee8ae39f44f7b6039b5bb73d22a2' tx-hash.msg])]~
    ==
    ::
      %sss-to-pub
    =/  msg  !<(into:du-portal-devs (fled vase))
    =^  cards  pub-portal-devs  (apply:du-portal-devs msg)
    [cards this]
  ==
++  on-watch  on-watch:default
++  on-leave  on-leave:default
++  on-peek
  |=  =path
  ^-  (unit (unit cage))
  ?+    path    (on-peek:default path)
    [%x %processing-payments ~]  ``app-pub-result+!>([%processing-payments processing-payments])
    [%x %processed-payments ~]   ``app-pub-result+!>([%processed-payments processed-payments])
    [%x %desks-for-sale ~]       ``app-pub-result+!>([%desks-for-sale desks-for-sale])
  ==
::
++  on-agent
  |=  [=wire =sign:agent:gall]
  ^-  (quip card _this)
  ?+    wire    (on-agent:default wire sign)
      [%our-apps ~]
    ::  this takes just apps ids
    ?+    -.sign    (on-agent:default wire sign)
        %fact
      =/  upd  !<(update:alliance:treaty q.cage.sign)
      =^  cards  our-apps
        ?-  -.upd
          ::  get treaty, and then add to treaties
            %add  
          :_  (~(put in our-apps) [ship.upd desk.upd])
          :~  :*  %pass  /our-treaty/(scot %p ship.upd)/[desk.upd]  %agent
          [our.bowl %treaty]  %watch  /treaty/(scot %p ship.upd)/[desk.upd]
          ==  ==
          ::
          ::  remove from our-apps, it's okay to keep the treaty in treaties
          %del  `(~(del in our-apps) [ship.upd desk.upd])
          ::
          ::  never get %ini?
          %ini  `init.upd
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
      `this
    ==
  ==
++  on-arvo
  |=  [=wire sign=sign-arvo]
  ^-  (quip card:agent:gall _this)
  ?>  ?=([%get-tx ~] wire)
  ?>  ?=([%khan %arow *] sign)
  ?.  ?=(%.y -.p.sign)
    ~&  >>  "fetching data failed"
    `this
  ::  TODO test flow
  ~&  >>  "didnt test new devasing"
  =+  !<([tx-hash=@ux result=?(~ transaction-result)] q.p.p.sign)
  ?~  result
    ~&  >>  "transaction wasn't made over last 24 hr"
    `this
  =/  hex  (hex-to-num:ethereum input.result)
  ?~  processing-data=(~(get by processing-payments) hex)
    ~&  >>  "payment with this hex never made"
    `this
  ?.  =((need to.result) receiving-address.u.processing-data)  ::  is it possible to have to.result empty?
    ~&  >>  "incorrect receiving address"
    `this
  ?.  (gte `@ud`(need value.result) eth-price.u.processing-data) :: is it possible to have value.result empty?
    ~&  >>  "payment too smol"
    ::  should I remove hex from processing payments here?
    `this
  ~&  >  "success!"
  =.  processing-payments  (~(del by processing-payments) hex)
  =.  processed-payments  %+  snoc  processed-payments
    [buyer.u.processing-data desk.u.processing-data tx-hash now.bowl]
  =/  perms  .^([r=dict:clay w=dict:clay] %cp /=[desk.u.processing-data]=)
  =/  group-name  (group-from-desk desk.u.processing-data)
  :_  this
                     ::(map @ta crew) 
  ?~  crew=(~(get by q.who.rul.r.perms) group-name)
    ~&  >>>  "this group should exist"
    ~
  ::  giving read perms to buyer
  :~  [%pass /set-group %arvo %c %cred group-name (~(put in u.crew) buyer.u.processing-data)] 
      :*  %pass  /payment-confirm  %agent  [buyer.u.processing-data %portal-manager]  %poke  
          %portal-message  !>([%payment-confirmed tx-hash desk.u.processing-data])
  ==  ==
  :: how often should processing payments be purged? once a week?

  ::  give perm to clay
  ::  send poke back that they can install (maybe they can start installing earlier?)
  ::  regardless, send poke back that tx was confirmed
::
++  on-fail   on-fail:default
--
