read -p "enter username : " u
ps lax | grep $u | grep -v grep | awk '{print $3}' | sudo xargs kill -9
