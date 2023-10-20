ps lax  | grep sshd | awk '{print $NF}' | sort | uniq -c | sort -r | grep -v priv | awk '$1!=1{print}' | sed 's/^ *//' | grep  -v priv | grep -v net
