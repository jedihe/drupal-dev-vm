#!/bin/sh
TZ=MET-1METDST
export TZ
exec /usr/lib/apache2/mpm-prefork/apache2 -DNO_DETACH
