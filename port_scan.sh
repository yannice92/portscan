#!/bin/sh
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        alias aecho="echo -e"
        hostip=$(hostname -i)
elif [[ "$OSTYPE" == "darwin"* ]]; then
        alias aecho="echo"
        hostip=$(ifconfig -l | xargs -n1 ipconfig getifaddr)
fi


RED='\033[0;31m'
GREEN='\033[1;32m'
YELLOW='\033[0;33m'
WHITE='\033[1;37m'
PURPLE='\033[0;35m'
NC='\033[0m' # No Color
while IFS=" " read -r _ip _port
do
#echo $i
#nc -zvw3 $_ip $_port
#timeout 3 nc -v -z  22 &> /dev/null && echo "Online" || echo "Timedout"

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        #ubuntu/debian/rhel
        timeout 5 nc -zv $_ip $_port &> /dev/null;
elif [[ "$OSTYPE" == "darwin"* ]]; then
        #mac
        gtimeout 5 nc -zv $_ip $_port &> /dev/null;
fi

result1=$?

if [ "$result1" = 0 ]; then
  aecho "${PURPLE}$hostip${NC},$_ip,$_port,${GREEN}Connected${NC}"
  #exit 1
elif [ "$result1" = 1 ]; then
  aecho "${PURPLE}$hostip${NC},$_ip,$_port,${RED}Refused${NC}"
  #exit 0
elif [ "$result1" = 124 ]; then
  aecho "${PURPLE}$hostip${NC},$_ip,$_port,${YELLOW}Timeout${NC}"
else
  aecho ""
fi

done < "server_list.txt"
