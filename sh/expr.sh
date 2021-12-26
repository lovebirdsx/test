val=`expr 2 + 2`
echo ${val}

a=10
b=20
val=`expr $a - $b`
echo "a - b = $val"

val=`expr $a + $b`
echo "a + b = $val"

val=`expr $a \* $b`
echo "a * b = $val"

val=`expr $a / $b`
echo "a / b = $val"

val=`expr $a % $b`
echo "a % b = $val"

if [ $a == $b ]
then
	echo "a == b"
fi

if [ $a != $b ]
then
	echo "a != b"
fi
