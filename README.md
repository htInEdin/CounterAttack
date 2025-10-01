# CounterAttack
Collection of configs etc to set up DoS protection using fail2ban, ipsets and shorewall

Some time ago I noticed that both the Mercurial and WordPress services
on my public-facing server were attracting large numbers (100,000+ per
day) of requests for internal python (Mercurial) and php (WordPress)
server files.  I started looking at the requests and was surprised to
see that the source IP addresses were changing all the time:  this was
not a small number of very busy bad-guys, but whole IP sub-ranges
ringing the changes so that normal rate-based detection didn't work.

Trying to manage this by hand, by grepping, detecting sub-ranges and
adding specific range-based entries to my shorewall(6) rule files was
clearly not feasible once the scale of the problem became clear.

To cut a long story short, after a number of iterations I've ended up
with a satisfactory approach based on fail2ban and ipsets, making only
minimal use of shorewall, which operates almost completely
automatically and does not sandbag my server.
