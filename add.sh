echo -e "which device ?\n\t1 - android\n\t2 - iphone\n"
read -p "device type : " device
echo -e "which seller ?\n\t1 - mmd\n\t2 - mrtz\n\t3 - blfzl\n\t4 - frmn\n"
read -p "seller number : " seller
read -p "expire day : " exptime

case $seller in
        1)
                seller=mmd
                ;;
        2)
                seller=mrtz
                ;;
        3)
                seller=blfzl
                ;;
        4)
                seller=frmn
                ;;
esac

case $device in
        1)
                device=android
                ;;
        2)
                device=iphone
                ;;
esac

u="vpn_"$seller"_"$device"_$(date '+%m%d_%H%M%S')"

echo -e "user :\n\t$u\n\texpire day : $exptime\ncreated"

sudo useradd -M -e $(date -I -d "+$exptime days")  -s /usr/bin/false $u
sudo chpasswd <<< "$u:123"
