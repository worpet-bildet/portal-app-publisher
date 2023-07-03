# Portal App Publisher

Requirements:
~sampel-palnet has %portal installed
~dister-sampel-palnet has %portal-app-publisher installed

Note: this is fully general. ~sampel planet is any ship which you use %portal with, and ~dister-sampel-palnet is any ship which distributes your apps. (It doesn't have to be a moon, it can be a star or whatever.)

## Publishing Paid Apps on Portal

### Portal App Publisher and Portal on the Same Ship

~sampel-palnet uses %portal. If ~sampel-palnet follows the user flow on %portal-app-publisher, the apps will show up for sale on ~sampel-palnet's %portal.

### Portal App Publisher and Portal on Different Ships

~dister-sampel-palnet wants to use %portal-app-publisher to sell %app1 on ~sampel-palnet's %portal page. To achieve that, do the following:
- in ~sampel-palnet's terminal type:  `:portal-manager &portal-action [%authorize-ships (sy ~[~sampel-palnet ~dister-sampel-palnet])]`
- return to %portal-app-publisher on ~dister-sampel-palnet and finish the setup. When you are done, %app1 should show up on ~sampel-palnet's %portal page

## Publishing Free Apps on Portal

###  Treaty Published Apps and Portal on the Same Ship

~sampel-palnet uses %portal. All apps `treaty|publish`ed by ~sampel-palnet will show up on their %portal page.

###  Treaty Published Apps and Portal on Different Ships

~dister-sampel-palnet publishes %app1. To make ~sampel-palnet show %app1 on their %portal page:
- in ~sampel-palnet's terminal type:  `:portal-manager &portal-action [%authorize-ships (sy ~[~sampel-palnet ~dister-sampel-palnet])]`
- in ~dister-sampel-palnet's terminal type: `:portal-app-publisher &action [%sign-app ~sampel-palnet '~dister-sampel-palnet/app1'`

%app1 should now be displayed on ~sampel-palnet's %portal page.





