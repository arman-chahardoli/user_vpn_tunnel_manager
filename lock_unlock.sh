read -p "(L) lock / (U) unlock ? " a
read -p "which username ? " u
sudo usermod -$a  $u
