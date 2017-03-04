
DUMMY_FILE=$HOME/.dummyfile
if [ ! -f $DUMMY_FILE ]
then
    echo "#this file is only here so we only add root once to the authorized x11 users" > $DUMMY_FILE
    xhost local:root
fi
