ps lax  | grep sshd | awk '{print $NF}' | sort | uniq -c | sort -r | grep -v priv | sed 's/^ *//'
