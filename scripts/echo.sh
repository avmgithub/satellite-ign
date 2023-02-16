
#!/bin/bash -x

echo $1
echo $2
echo $3

sed s/ipaddr/$2/ $3 > ifcfg.$1
