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
      =desks-for-sale
      =receiving-address
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
      [%0 *]  [%1 *^processing-payments *^desks-for-sale *^receiving-address +.old]
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
        [%set-receiving-address *]
      =.  receiving-address  receiving-address.act
      `this
      ::
        [%publish *]
      ?:  (~(has by desks-for-sale) desk.act)
        ~&  "desk {<desk>} already published"
        `this
      ::  desk mustn't be treaty published
      ?<  (~(has in our-apps) [our.bowl desk.act])
      ::  TODO confirm desk exists w/ clay
      =.  desks-for-sale
        (~(put by desks-for-sale) desk.act [eth-price.act *group])
      `this
      ::
        [%get-tx-by-hash *]
      =+  (hex-to-num:ethereum tx-hash.act)
      :_  this
      [%pass /get-tx %arvo %k %fard dap.bowl %get-tx-by-hash %noun !>([url.act -])]~
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
        %+  turn  -
        |=  [=ship =desk]
        :*  %pass  /our-treaty/(scot %p ship)/[desk]  %agent
            [our.bowl %treaty]  %watch  /treaty/(scot %p ship)/[desk]
        ==
      =^  cards-1  pub-portal-devs  
        (give:du-portal-devs [%portal-devs ~] [%init ~])
      :_  this
      %+  snoc  (welp cards cards-1)
      [%pass /our-apps %agent [our.bowl %treaty] %watch /alliance]
    ==
    ::
      %portal-message
    =/  msg  !<(message:portal-message vase)
    ?>  ?=([%payment-request *] msg)
    =/  hex  `@ux`(mod eny.bowl (pow 4 16))
    ::  crash if not for sale
    =/  [=eth-price =group]  (~(got by desks-for-sale) desk.msg)
    ?:  (~(has in group) src.bowl)
      ~&  >>  "desk {<desk.msg>} already bought by {<src.bowl>}" 
      `this
    =.  processing-payments
      (~(put by processing-payments) hex [src.bowl desk.msg eth-price receiving-address])
    :_  this
    :~  :*  %pass  /payment-ref  %agent  [src.bowl %portal-manager]  %poke  
        %portal-message  !>([%payment-reference receiving-address hex eth-price])
    ==  ==
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
    [%x %desks-for-sale ~]       ``app-pub-result+!>([%desks-for-sale desks-for-sale])
    [%x %receiving-address ~]    ``app-pub-result+!>([%receiving-address receiving-address])
  ==
::
++  on-agent
  |=  [=wire =sign:agent:gall]
  ^-  (quip card _this)
  ?+    wire    (on-agent:default wire sign)
      [%our-apps ~]
    ?+    -.sign    (on-agent:default wire sign)
        %fact
      =/  upd  !<(update:alliance:treaty q.cage.sign)
      =^  cards  our-apps
        ?-  -.upd
            %add  
          :_  (~(put in our-apps) [ship.upd desk.upd])
          :~  :*  %pass  /our-treaty/(scot %p ship.upd)/[desk.upd]  %agent
          [our.bowl %treaty]  %watch  /treaty/(scot %p ship.upd)/[desk.upd]
          ==  ==
          ::
          %del  `(~(del in our-apps) [ship.upd desk.upd])
          %ini  `init.upd
        ==
      [cards this]
    ==
    ::
      [%our-treaty @ @ ~]
    ?+    -.sign    (on-agent:default wire sign)
        %fact
      =/  treaty  !<(treaty:treaty q.cage.sign)
      =.  treaties  (~(put by treaties) [our.bowl `@t`i.t.t.wire] treaty)
      `this
    ==
    ::
  ==
++  on-arvo
  |=  [=wire sign=sign-arvo]
  ^-  (quip card:agent:gall _this)
  ?>  ?=([%get-tx ~] wire)
  ?>  ?=([%khan %arow *] sign)
  ::  TODO probably remove from processing payments once it's done
  ?:  ?=(%.y -.p.sign)
    =/  result  !<(?(~ transaction-result) q.p.p.sign)
    ?~  result
      ~&  >>  "transaction wasn't made over last 24 hr"
      `this
    ~&  `@ud`(need value.result)
    `this
  ~&  >>  "fetching data failed"
  `this
::
++  on-fail   on-fail:default
--
