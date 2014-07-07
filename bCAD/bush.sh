#!/bin/bash

echo Content-type: text/html 
echo 
echo "<pre>"

# removing old files.
rm -f bush.g
rm -f rt*
rm -f *.pix
rm -f temp*
rm -f ../../cgi-images/*


#initialising variable for the values filled in the form
#length of the top
x=`echo "$QUERY_STRING" | cut -d"&" -f1 | cut -d"=" -f2`
#Breadth of the top
y=`echo "$QUERY_STRING" | cut -d"&" -f2 | cut -d"=" -f2`
#thickness of the top
z=`echo "$QUERY_STRING" | cut -d"&" -f3 | cut -d"=" -f2`
#length of leg
x1=`echo "$QUERY_STRING" | cut -d"&" -f4 | cut -d"=" -f2`
#width of leg
y1=`echo "$QUERY_STRING" | cut -d"&" -f5 | cut -d"=" -f2`

z1=`echo "$QUERY_STRING" | cut -d"&" -f6 | cut -d"=" -f2`

x2=`expr $z + $y1`


#defining various views
front=frontview
side=sideview
top=topview
iso=isoview

cat <<EOF | env /usr/brlcad/dev-7.24.1/bin/mged -c bush.g
in s1 rpp -$x $x 0 $y 0 $z
in s2 rpp -$x1 $x1 0 $y $z $x2
in s3 rcc 0 0 $x2 0 $y 0 $x1 
in s4 rcc 0 0 $x2 0 $y 0 $z 
in s5 rcc -$y $y1 0 0 0 $z $z1 
in s6 rcc $y $y1 0 0 0 $z $z1
r region u s1 u s2 u s3 
r region1 u region - s4 - s5 - s6 
mater region1 plastic 218 122 178 0
B region1 
ae 0 0
saveview $front
ae 270 0
saveview $side
ae -90 90 
saveview $top
ae 30 30
saveview $iso
EOF

sed '2cenv /usr/brlcad/dev-7.24.1/bin/rt -M \\' $front > tempFile1
sed '2cenv /usr/brlcad/dev-7.24.1/bin/rt -M \\' $side > tempFile2
sed '2cenv /usr/brlcad/dev-7.24.1/bin/rt -M \\' $top > tempFile3
sed '2cenv /usr/brlcad/dev-7.24.1/bin/rt -M \\' $iso > tempFile4

# removing original raytracing file.
rm $front
rm $side
rm $top
rm $iso

# changing name of temporary file to that of original file.
mv tempFile1 $front
mv tempFile2 $side
mv tempFile3 $top
mv tempFile4 $iso

# give executable permissions to raytrace file.
chmod 777 $front
chmod 777 $side
chmod 777 $top
chmod 777 $iso


# executing raytrace file. This will produce raw image in .pix format
# and a log
#file.
sh $front
sh $side
sh $top
sh $iso
 
# converting .pix file to png image using BRLCAD commands.
env /usr/brlcad/dev-7.24.1/bin/pix-png < $front.pix > $front.png
env /usr/brlcad/dev-7.24.1/bin/pix-png < $side.pix > $side.png
env /usr/brlcad/dev-7.24.1/bin/pix-png < $top.pix > $top.png
env /usr/brlcad/dev-7.24.1/bin/pix-png < $iso.pix > $iso.png

chmod 777 $front.png
chmod 777 $side.png
chmod 777 $top.png
chmod 777 $iso.png

# copying final image to public_html for displaying on browser.
cp $front.png ../../cgi-images/
cp $side.png ../../cgi-images/
cp $top.png ../../cgi-images/
cp $iso.png ../../cgi-images/

echo "<meta http-equiv=\"refresh\" content=\"1;url=../../multi_viewbbr.html\">"
echo "Processing your Table:"
echo "<pre>"
