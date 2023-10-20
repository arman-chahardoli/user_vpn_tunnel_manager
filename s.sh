get_name_add(){
	echo -ne "\ntype a name (user)\n\n : "
	read add_name
	echo -ne "\nchoose a suffix or type\n\n\
	0) no suffix
	1) Android\n\
	2) Iphone\n\
	3) MAC\n\
	4) Windows\n\
	5) Linux\n\n
	or type what you want\n\n : "
	read add_name_suffix
	case $add_name_suffix in
		1)
			add_name_suffix="android"
			;;
		2)
			add_name_suffix="iphone"
			;;
		3)	
			add_name_suffix="mac"
			;;
		4)
			add_name_suffix="windows"
			;;
		5)
			add_name_suffix="linux"
			;;
	esac
	echo -ne "\nexpiration day number (0 for no expiration, 30 for one month)\n\n : "
	read add_name_expiration
	case $add_name_expiration in
		0)
			echo zzz
			;;
		*)
			case $add_name_expiration in
			    ''|*[!0-9]*)
				    echo "wrong expiration number !"
				    exit
			esac
			;;
	esac
}
echo -ne "\nWhich action ?\n\n\
	1) add\n\
	2) remove\n\
	3) lock\n\
	4) unlock\n\n"
read -p " : " action

case $action in
	1)
		get_name_add
		echo 1
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
