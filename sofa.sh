#!/bin/bash

echo Content-type: text/html
echo
echo "<pre>"

# removing old files.
rm -f sofa.g rt* *.pix temp* ../cgi-images/*


#defining various views
front=frontview
side=sideview
top=topview
iso=isoview

#mged commands
cat <<EOF | env /usr/brlcad/dev-7.25.0/bin//mged -c sofa.g
in s0 rpp 0 62 0 2 0 2
in s1 rpp 0 62 0 2 20 22
in s2 rpp 0 2 0 2 2 20
in s3 rpp 4 6 0 2 2 20
in s4 rpp 8 10 0 2 2 20
in s5 rpp 12 14 0 2 2 20
in s6 rpp 16 18 0 2 2 20
in s7 rpp 20 22 0 2 2 20
in s8 rpp 24 26 0 2 2 20
in s9 rpp 28 30 0 2 2 20
in s10 rpp 32 34 0 2 2 20
in s11 rpp 36 38 0 2 2 20
in s12 rpp 40 42 0 2 2 20
in s13 rpp 44 46 0 2 2 20
in s14 rpp 48 50 0 2 2 20
in s15 rpp 52 54 0 2 2 20
in s16 rpp 56 58 0 2 2 20
in s17 rpp 60 62 0 2 2 20
in s18 rpp 0 2 2 22 0 2
in s19 rpp 0 2 2 22 10 12
in s20 rpp 0 2 4 6 2 10
in s21 rpp 0 2 8 10 2 10
in s22 rpp 0 2 12 14 2 10
in s23 rpp 0 2 16 18 2 10
in s24 rpp 0 2 20 22 2 10
in s25 rpp 60 62 2 22 0 2
in s26 rpp 60 62 2 22 10 12
in s27 rpp 60 62 4 6 0 10
in s28 rpp 60 62 8 10 0 10
in s29 rpp 60 62 12 14 0 10
in s30 rpp 60 62 16 18 0 10
in s31 rpp 60 62 20 22 0 10
in s32 rpp 2 60 2 22 0 2
in s33 rpp 0 4 0 4 -5 0
in s34 rpp 58 62 0 4 -5 0
in s35 rpp 0 4 18 22 -5 0
in s36 rpp 58 62 18 22 -5 0
in s37 rpp 2 60 6 22 2 6
in s38 rpp 2 60 2 6 2 22
r r1 u s0 u s1 u s2 u s3 u s4 u s5 u s6 u s7 u s8 u s9 u s10 u s11 u s12 u s13 u s14 u s15 u s16 u s17 u s18 u s19 u s20 u s21 u s22 u s23 u s24 u s25 u s26 u s27 u s28 u s29 u s30 u s31 u s32 u s33 u s34 u s35 u s36
r r2 u s37 u s38
mater r1 plastic 164 96 38 .
mater r2 plastic 122 164 220 0
B r1 r2
ae 0 0
saveview $front
ae 270 0
saveview $side
ae -90 90 
saveview $top
ae 30 30
saveview $iso
EOF

# adding "env /usr/brlcad/dev-7.25.0/bin/" in the beginning of 2nd line of raytracing file
# and sending output to temporary file.
sed '2cenv /usr/brlcad/dev-7.25.0/bin//rt -M \\' $front > tempFile1 
sed '2cenv /usr/brlcad/dev-7.25.0/bin//rt -M \\' $side > tempFile2
sed '2cenv /usr/brlcad/dev-7.25.0/bin//rt -M \\' $top > tempFile3
sed '2cenv /usr/brlcad/dev-7.25.0/bin//rt -M \\' $iso > tempFile4

# removing original raytracing file.
rm $front $side $top $iso


# changing name of temporary file to that of original file.
mv tempFile1 $front
mv tempFile2 $side
mv tempFile3 $top
mv tempFile4 $iso

# give executable permissions to raytrace file.
chmod 777 $front $side $top $iso


# executing raytrace file. This will produce raw image in .pix tormat and a log
#file.
./$front
./$side
./$top
./$iso

# converting .pix file to png image using BRLCAD commands.
env /usr/brlcad/dev-7.25.0/bin//pix-png < $front.pix > $front.png 
env /usr/brlcad/dev-7.25.0/bin//pix-png < $side.pix > $side.png
env /usr/brlcad/dev-7.25.0/bin//pix-png < $top.pix > $top.png
env /usr/brlcad/dev-7.25.0/bin//pix-png < $iso.pix > $iso.png

chmod 777 $front.png $side.png $top.png $iso.png



# copying final image to public_html for displaying on browser.
cp $front.png ../cgi-images/ $side.png ../cgi-images/ $top.png ../cgi-images/ $iso.png ../cgi-images/cp $top.png ../cgi-images/

# using html <img src tag, display image on browser.
echo "<img src = ../cgi-images/$front.png>"

echo "<h1>front</h1>"

echo "<img src = ../cgi-images/$side.png>"

echo "<h1>side</h1>"

echo "<img src = ../cgi-images/$top.png>"

echo "<h1>top</h1>"

echo "<img src = ../cgi-images/$iso.png>"

echo "<h1>iso</h1>"













