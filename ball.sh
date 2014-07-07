#!/bin/bash

echo "Content-type: text/html"
echo ""


# removing old files.
rm -f ballbearing.g 
rm -f rt*

rt=rtFile

cat <<EOF | env /usr/brlcad/dev-7.25.0/bin//mged -c ballbearing.g
in s0 rcc 0 0 0 .6 0 0 2.2
in s1 rcc 0 0 0 .6 0 0 2
in s2 rcc 0 0 0 .6 0 0 1.4
in s3 rcc 0 0 0 .6 0 0 1.2
in s4 sph .3 1.7 0 .3
in s5 sph .3 -1.7 0 .3
in s6 sph .3 0 1.7 .3
in s7 sph .3 0 -1.7 .3
in s8 sph .3 1.2 1.2 .3
in s9 sph .3 1.2 -1.2 .3
in s10 sph .3 -1.2 1.2 .3
in s11 sph .3 -1.2 -1.2 .3
r r1.s u s0 - s1
r r2.s u s2 - s3
r r3.s u s4 u s5 u s6 u s7 u s8 u s9 u s10 u s11
comb ballbearing.c u r1.s u r2.s u r3.s
mater ballbearing.c plastic 122 164 220 0
B ballbearing.c
ae 25 35
saveview $rt
EOF


# give executable permissions to raytrace file.
chmod 777 $rt

# executing raytrace file. This will produce raw image in .pix tormat and a log
#file.
./$rt

# converting .pix file to png image using BRLCAD commands.
env /usr/brlcad/dev-7.25.0/bin//pix-png < $rt.pix > $rt.png

# open png image in a frame buffer. Currently not required.
#env /usr/brlcad/bin/png-fb $rt.png

shotwell $rt.png
