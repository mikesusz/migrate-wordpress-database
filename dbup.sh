#!/usr/bin/env bash
echo "Reading config...." >&2
#var for command argument
loc=./$1

#check to see if argument directory
if [ -d $loc ]; then
	# it is a directory - check for config file
	if [ -f $loc/dbup.cfg ]; then
		# found a config file - source it for tasty variables
		source $loc/dbup.cfg
	else
		# uh-oh, no config file found. ABORT!
		echo 'no config file found!'
		echo 'are you running this command from the location of your dbup.cfg?'
		echo 'see README for more information.'
		exit 1;
	fi
fi

if [ ! -f $loc/$sourcefile ]; then
	# can't read the sql dump file from the path specified. EJECT!
	echo "i can't find the sql file you specified in your dbup.cfg: " $loc$sourcefile
	echo "make sure the path is relative to the location of this file"
	exit 1;
fi

# finding sed - thanks to this thread!
# http://stackoverflow.com/questions/592620/check-if-a-program-exists-from-a-bash-script
type -P sed &>/dev/null || {
	#couldn't find sed - O NOES! RUN AWAY!
	echo "sed is required to do the hostname switching, but i can't find it." >&2; 
exit 1;
}

echo 'everything appears to be in order,'
echo 'all we need is your mysql password for user '$dbuser@$dbhost
sed -e s/$oldname/$newname/g $loc/$sourcefile | mysql -u $dbuser -p -h $dbhost $dbname
