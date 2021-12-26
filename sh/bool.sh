a=10
b=20

if [ $a == $b ]
then
	echo "a=b"
else
	echo "a~=b"
fi

if [ $a != $b ]
then
	echo "a~=b"
else
	echo "a=b"
fi

if [ $a -lt 100 -a $b -gt 15 ]
then
	echo "a < 100 and b > 15 yes"
else
	echo "a < 100 and b > 15 no"
fi

if [ $a -lt 100 -o $b -gt 15 ]
then
	echo "a < 100 or b > 15 yes"
else
	echo "a < 100 or b > 15 no"
fi
