TEMP_FILE="$HOME/.ssh_user_tmp"
DB_FILE="$HOME/.ssh_user_db"
EDITOR="vi"

echo -ne "\nWhich action ?\n\n\
	1) add\n\
	2) remove\n\
	3) lock\n\
	4) unlock\n\
	5) view connections\n"
read -p " : " action

case $action in
	1)
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

		echo -ne "\npassword for ${name_add} (if not randomly generated )\n : "
		read pass_name_add
		if [ -z "$pass_name_add" ]
		then
			pass_name_add="$RANDOM$RANDOM"
		fi
		echo -ne "${name_add}\n\t${pass_name_add}\n" >> "$DB_FILE"
		echo -ne "\npassword for ${name_add} is : \n\n\t$name_add : $pass_name_add\n\npassword stored in $DB_FILE\n"

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
		echo -ne "\nHow to remove user(s) ?\n\n\
	1) remove a single user\n\
	2) remove list of available users\n\
	3) remove list of locked users\n\
	4) remove list of expired users\n : "
		read remove_action
		case $remove_action in

			1)
				echo 
				echo "list of added users :"
				echo "---------------"
				cat /etc/passwd | grep ..-.._..-..-.. | cut -d":" -f1 | pr -3 -ftJ
				echo "---------------"
				echo -ne "\nEnter account name (enter lists all users)\n : "
				read remove_name
				getent passwd $remove_name &> /dev/null
				if [ $? -eq 0 ]
				then
					sudo userdel -rf $remove_name &> /dev/null
					sed -i "s/$remove_name/DELETED\t&/" "$DB_FILE"
				else
					echo  "ERROR : $remove_name doesn't exist!"
				fi
				;;

			2)
				cat /etc/passwd | grep ..-.._..-..-.. | cut -d":" -f1 > "$TEMP_FILE"
				clear
				echo -ne "\n\nATTENTION !\n\nEvery username exists in editor, will be removed !\nDelete every username from editor to save account\nExisting users in editor will be removed !\n\nBE CAREFULL AFTER SAVING EDITOR !\n\n(press enter, CTRL-c to cancel)"
				read tmp
				$EDITOR "$TEMP_FILE"
				clear
				echo "---------------"
				cat "$TEMP_FILE" | pr -3 -ftJ
				echo "---------------"
				echo -ne "\n\nATTENTION !\n\nUsers above going to be removed !\nType :\n\t\"yes sure\"\n\nto remove them\n : "
				read remove_action_yes
				if [ "$remove_action_yes" == "yes sure" ]
				then
					for remove_name in $(cat "$TEMP_FILE" | xargs) 
					do
						sudo userdel -rf $remove_name &> /dev/null
						sed -i "s/$remove_name/DELETED\t&/" "$DB_FILE"
					done
				else
					echo -ne "\nDid not delete them\n\n"
				fi
				;;

			3)
				rm -f "$TEMP_FILE"
				for remove_name_locked in $(cat /etc/passwd | grep ..-.._..-..-.. | cut -d":" -f1 | xargs)
				do
					sudo passwd -S $remove_name_locked  | grep ' L ' | awk '{print $1}'>> "$TEMP_FILE"
					sudo passwd -S $remove_name_locked  | grep  -i 'locked' | awk '{print $1}' >> "$TEMP_FILE"
				done
				sort -u -o "$TEMP_FILE" "$TEMP_FILE"
				clear
				echo -ne "\n\nATTENTION !\n\nEvery username exists in editor, will be removed !\nDelete every username from editor to save account\nExisting users in editor will be removed !\n\nBE CAREFULL AFTER SAVING EDITOR !\n\n(press enter, CTRL-c to cancel)"
				read tmp
				$EDITOR "$TEMP_FILE"
				clear
				echo "---------------"
				cat "$TEMP_FILE" | pr -3 -ftJ
				echo "---------------"
				echo -ne "\n\nATTENTION !\n\nUsers above going to be removed !\nThey are locked\nType :\n\t\"yes sure\"\n\nto remove them\n : "
				read remove_action_yes
				if [ "$remove_action_yes" == "yes sure" ]
				then
					for remove_name in $(cat "$TEMP_FILE" | xargs) 
					do
						sudo userdel -rf $remove_name &> /dev/null
						sed -i "s/$remove_name/DELETED\t&/" "$DB_FILE"
					done
					rm -f "$TEMP_FILE"
				else
					echo -ne "\nDid not delete them\n\n"
					rm -f "$TEMP_FILE"
				fi
				;;

			4)
				rm -f "$TEMP_FILE"
				for remove_name_expired in $(cat /etc/passwd | grep ..-.._..-..-.. | cut -d":" -f1 | xargs)
				do
					if $(sudo chage -l $remove_name_expired | grep -i '^Account expires' | grep -vq "never$")
					then
						echo $remove_name_expired >> "$TEMP_FILE"
					fi
				done
				sort -u -o "$TEMP_FILE" "$TEMP_FILE"
				clear
				echo -ne "\n\nATTENTION !\n\nEvery username exists in editor, will be removed !\nDelete every username from editor to save account\nExisting users in editor will be removed !\n\nBE CAREFULL AFTER SAVING EDITOR !\n\n(press enter, CTRL-c to cancel)"
				read tmp
				$EDITOR "$TEMP_FILE"
				clear
				echo "---------------"
				cat "$TEMP_FILE" | pr -3 -ftJ
				echo "---------------"
				echo -ne "\n\nATTENTION !\n\nUsers above going to be removed !\nThey are expired\nType :\n\t\"yes sure\"\n\nto remove them\n : "
				read remove_action_yes
				if [ "$remove_action_yes" == "yes sure" ]
				then
					for remove_name in $(cat "$TEMP_FILE" | xargs) 
					do
						sudo userdel -rf $remove_name &> /dev/null
						sed -i "s/$remove_name/DELETED\t&/" "$DB_FILE"
					done
					rm -f "$TEMP_FILE"
				else
					echo -ne "\nDid not delete them\n\n"
					rm -f "$TEMP_FILE"
				fi
				;;

			*)
				echo nn
				;;
		esac

		;;

	3)
		echo 3
		;;
	4)
		echo 4
esac
