gluon-alt-esc-client
====================

*This is a copy of the PR https://github.com/freifunk-gluon/gluon/pull/1094 which
will eventually be added to gluon anytime soon.*

The *gluon-alt-esc-client* package allows to create an additional wifi interface
with an alternative default gateway.

Accessibility
-------------

The alternative default gateway is configured by its MAC address in the config
mode. This host with its MAC needs to be a accessible directly within the mesh
network (client zone).

An easy way is to use the *gluon-alt-esc-provider* package and copy the
MAC address it presents in the config mode and paste it into the client
side configuration. However, the provider package is not mandatory - in fact
any host in the mesh network can potentially be chosen as an alternative default
gateway (as long as it allows routing, of course).

Only Off-link subnets are rerouted to the alternative exit. On-link subnets are
excluded. They are currently determined via *prefix4*, *prefix6*, *extra_prefixes4*
and *extra_prefixes6* from the site.conf.

Naming / ESSID
--------------

The name (so called ESSID) for the newly created wifi interface can be
freely chosen. However the author suggests to not use the word "Freifunk"
in it (for quite a while the internet is not a free/libre network anymore).

The following two hash tags are automatically appended:

*Zone-ID*: It prevents potential roaming conflicts. (Technically, it is generated
by taking the first four bytes of the hexadecimal form of an md5sum over
"<ipv4-gw-MAC>,<ipv6-gw-MAC>,<essid>")

*Site Code*: The communities site code is appended. To Freifunk enthusiasts it
signalizes:

- free and unaltered access to the Freifunk intranet of the local community
- that this node contributes to the local Freifunk community as a mesh node

Why an extra ESSID?
-------------------

Two reasons:

1. Friendly co-existence with neighboring nodes: Avoiding roaming issues, not everyone wants to use your or a potentially broken gateway; The idea is to keep the option to always choose the community maintained gateways.
2. De-entanglement, concerning the (partial) commercial interests which arose in the past years. This would allow hotels, cafes, bakeries etc. to choose an alternative exit independent of the community infrastructure (as long as they do not use the word "Freifunk" in the new, extra ESSID) while still contributing to it. Such a cleaner separation might become necessary if the charitable nature of Freifunk were to be accepted by the German government
