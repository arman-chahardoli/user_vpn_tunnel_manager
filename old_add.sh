sudo useradd -s /usr/bin/false $@
sudo chpasswd <<< "$@:123"
