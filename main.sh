get_name_add(){
	echo -ne "\ntype a name (user)\n : "
	read name
	if [ -z "$name" ]
	then
		name_add="user"
	else
		name_add="$name"
	fi

	echo -ne "\nexpiration day number (0 for no expiration, 30 for one month)\n : "
	read add_name_expiration
	if [[ ! -z "$add_name_expiration" ]]
	then
		case $add_name_expiration in
		    ''|*[!0-9]*)
			    echo "wrong expiration number !"
			    exit
		esac
		name_add="${name_add}_${add_name_expiration}"
	fi

	name_add="${name_add}_$(date '+%m-%d_%H-%M-%S')"
	#echo -ne "\n\tnew user account is : $name_add\n"
}

get_password_add(){
	echo -ne "\npassword for ${name_add} (if not randomly generated )\n : "
	read pass_name_add
	if [ -z "$pass_name_add" ]
	then
		pass_name_add="$RANDOM$RANDOM"
	fi
	echo -ne "${name_add}\n\t${pass_name_add}\n" >> "$HOME/.ssh_user_pass_db.txt"
	echo -ne "\npassword for ${name_add} is : \n\n\t$name_add : $pass_name_add\n\npassword stored in ~/.ssh_user_pass_db.txt\n"
}

echo -ne "\nWhich action ?\n\n\
	1) add\n\
	2) remove\n\
	3) lock\n\
	4) unlock\n"
read -p " : " action

case $action in
	1)
		get_name_add
		get_password_add
		if [ -Z $add_name_expiration ]
		then
			sudo useradd -M -s /usr/bin/false $name_add
		else
			sudo useradd -M -e $(date -I -d "+$ days")  -s /usr/bin/false $name_add
		fi
		echo $pass_name_add | sudo passwd --stdin $name_add &> /dev/null
		echo user created successfully
		;;

	2)
		echo 2
		;;
	3)
		echo 3
		;;
	4)
		echo 4
esac
