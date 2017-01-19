#!/bin/bash

# Usage: ./leakedsource.sh ~/email-list.txt

filename="$1"
count="1"
notice="1"

while read name
do
	if curl -s "https://www.leakedsource.com/main/?email=$name" | grep -q "This data was hacked on"
	then
		echo -e "$count Trying $name -- \033[0;32mSuccess!\033[0m"
		echo $name >> wow.txt
		let count=count+1
		let notice=0

	elif curl -s "https://www.leakedsource.com/main/?email=$name" | grep -q "Anti spam triggered"
	then
		if [[ ! $notice -gt 5 ]]; then
			echo -e "\033[1;33mAnti-spam triggered: Waiting 5 seconds...\033[0m"
			sleep 5
			let notice=notice+1
		else
			echo -e "\033[1;33mYou may have to wait for a while, have patience. Waiting 5 seconds...\033[0m"
			sleep 5
		fi

	else
		echo -e "$count Trying $name -- \033[0;31mNot found\033[0m"
		let count=count+1
		let notice=0
	fi
done < $1
