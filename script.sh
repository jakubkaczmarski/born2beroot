#!bin/bash
archit=$(uname -a)
cpuinfo=$(grep "physical id" /proc/cpuinfo | sort | uniq | wc -l)
cpucore=$(grep "^processor" /proc/cpuinfo | wc -l)
memuse=$(free -m | awk '$1 == "Mem:" {print $3}')
memfree=$(free -m | awk '$1 == "Mem:" {print $2}')
procentage=$(free -m | awk '$1 == "Mem:" {printf("%.2f"), $3/$2*100}')
useddisk=$(df -Bm | grep '^/dev/' | grep -v '/boot$' | awk '{ut = ut + $3} END {print ut}')
freedisk=$(df -Bm | grep '^/dev/' | grep -v '/boot$' | awk '{ft = ft + $2} END {print ft}')
procdisk=$(df -Bm | grep '^/dev/' | grep -v '/boot$' | awk '{ut = ut + $3} {ft = ft + $2} END {printf("%d"), ut/ft*100}')
cpuload=$(top -bn1 | grep '^%Cpu' | cut -c 9- | xargs | awk '{printf("%.1f%%"), $1 + $3}')
lastboot=$(who -b | awk '$1 == "system" {printf $3 " " $4} ')
lwmt=$(lsblk | grep "lvm" | wc -l)
lvmusr=$(if [ $lwmt -eq 0 ]; then echo no; else echo yes; fi)
tcpconnects=$(cat /proc/net/sockstat{,6} | awk '$1 == "TCP:" {printf $3}')
userlog=$(users | wc -w)
ipstats=$(hostname -I)
macadress=$(ip link show | awk '$1 == "link/ether" {print $2}')
sudouser=$(journalctl _COMM=sudo | grep COMMAND | wc -l)
wall "#Architecture: $archit
        #CPU psychical: $cpuinfo
        #vCPU: $cpucore
        #Memory Usage: $memfree/${memuse}MB ($procentage%)
        #Disk Usage: $useddisk/${freedisk}GB   ($procdisk%)
        #CPU load: $cpuload
        #Last boot: $lastboot
        #LVM user:  $lvmusr
        #Connexions TCP : $tcpconnects ESTABLISHED
        #User log:  $userlog
        #Network:   $ipstats ($macadress)
        #Sudo:  $sudouser cmd"