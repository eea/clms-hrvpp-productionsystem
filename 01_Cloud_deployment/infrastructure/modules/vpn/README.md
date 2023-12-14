# VPN

This module creates a vpngateway node running strongswan to create a vpn tunnel between it and the checkpoint firewall at Vito. Below is an overview of the networking deployment:

```bash

~ external network
* openstack node
% openstack network
$ openstack router

~~~~~~~~~~~~~~~~~                      **************                      %%%%%%%%%%%%%%%%%%                      $$$$$$$$$$                      ~~~~~~~~~~~~~~~~~~~~
~               ~      Floating IP     *            *                      %                %       Fixed IP       $        $                      ~                  ~
~ Checkpoint FW ~ ==================== * vpngateway * ==================== % remote network % ==================== $ router $ ==================== ~ external network ~
~               ~                      *            *                      %                %                      $        $                      ~                  ~
~~~~~~~~~~~~~~~~~                      **************                      %%%%%%%%%%%%%%%%%%                      $$$$$$$$$$                      ~~~~~~~~~~~~~~~~~~~~

```

This module drops an instance attached to the remote network. In the network it get's a fixed ip, which is then used to create static routes in the router of that subnet to guide the traffic to the internal infra over the instance.
*Notes*
- The subnet must be attached via the router to the external network so that the vpngateway instance can have a floating ip.
- There is no security policy attached to the network interface of the instance, you have to manually remove it after TF has created the node, otherwise no traffic will be visable.

