sudo passwd -S -a  | grep ' L ' | awk '{print $1}' | sort  | grep vpn
