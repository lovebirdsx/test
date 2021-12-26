echo ${var:-"Variable is not set"}
echo "1 - var is ${var}"

echo ${var:="Variable is not set"}
echo "2 - var is ${var}"

unset var

echo ${var:+"This is the default value"}
echo "3 - var is ${var}"

var="Prefix"
echo ${var:+"this is the default value"}
echo "4 - var is ${var}"

# unset var
echo ${var:?"Print this message"}
echo "5 - var is ${var}"