#!/bin/bash

if [ $(id -u) -eq 0 ]
then
	clear
else
	if echo $(id) |grep sudo > /dev/null
	then
	clear
	echo "Voce não é root"
	echo "Seu usuario esta no grupo sudo"
	echo -e "Para virar root execute \033[1;31msudo su\033[0m"
	exit
	else
	clear
	echo -e "Vc nao esta como usuario root, nem com seus direitos (sudo)\nPara virar root execute \033[1;31msu\033[0m e digite sua senha root"
	exit
	fi
fi
if [ -d /etc/VPS-MANAGER ]
then
echo ""
else
mkdir /etc/VPS-MANAGER
fi

if [ -d /etc/VPS-MANAGER/clave ]
then
echo ""
else
mkdir /etc/VPS-MANAGER/clave
fi

if [ -d /etc/VPS-MANAGER/limite ]
then
echo ""
else
mkdir /etc/VPS-MANAGER/limite
fi
if [ "$1" = "" ]; then
clear
echo -e "\033[1;34m ===================================\033[0m"
echo -e "\033[1;31m ∆ \033[1;37mOFICIAL VPS-SERVER\033[0m"
echo -e "\033[1;31m √ \033[1;37mVPS-MANAGER V3.0\033[0m"
echo -e "\033[1;34m ===================================\033[0m"
sso=$(cat -n /etc/issue |grep 1 |cut -d' ' -f6,7,8 |sed 's/1//' |sed 's/      //')
echo -e "\033[1;31m ° \033[1;37m SU SISTEMA \033[1;31m$sso"
echo -e "\033[1;34m ===================================\033[0m"
echo -e "\033[1;31m ∆ \033[1;33m¡BIENVENIDO AL MENÚ!\033[0m"
echo -e "\033[1;34m ===================================\033[0m"
echo -e "\033[1;31m |1|• \033[1;37mCREAR USUARIOS\033[01;37m"
echo -e "\033[1;31m |2|• \033[1;37mALTERAR PASSWD USUARIOS\033[01;37m"
echo -e "\033[1;31m |3|• \033[1;37mMODIFICAR FECHA USUARIOS\033[01;37m"
echo -e "\033[1;31m |4|• \033[1;37mALTERAR LIMITE USUARIOS\033[01;37m"
echo -e "\033[1;31m |5|• \033[1;37mELIMINAR USUARIOS\033[01;37m"
echo -e "\033[1;31m |6|• \033[1;37mELIMINAR USUARIOS VENCIDOS\033[01;37m"
echo -e "\033[1;31m |7|• \033[1;37mVERIFICAR USUARIOS ONLINE\033[01;37m"
echo -e "\033[1;31m |8|• \033[1;37mKILL MULTILOGUIN\033[01;37m"
echo -e "\033[1;31m |9|• \033[1;37mAGREGAR HOST\033[01;37m"
echo -e "\033[1;31m |10|• \033[1;37mELIMINAR HOST\033[01;37m"
echo -e "\033[1;31m |11|• \033[1;37mBADVPN UDP\033[01;37m"
echo -e "\033[1;31m |12|• \033[1;37mBACKUP USUARIOS\033[01;37m"
echo -e "\033[1;31m |13|• \033[1;37mTESTAR VELOCIDAD\033[01;37m"
echo -e "\033[1;31m |14|• \033[1;37mTCP SPEED\033[01;37m"
echo -e "\033[1;31m |15|• \033[1;37mOPENVPN TCP/UDP\033[01;37m"
echo -e "\033[1;34m ===================================\033[0m"
echo -e "\033[1;35m Opción\033[0m"
read -p " : " op
else
op="$1"
fi
case $op in
0 | 00 )
/bin/squid
;;
1 | 01 )
/bin/crearusuario
;;
2 | 02 )
/bin/alterarclaveusuario
;;
3 | 03 )
/bin/mudardata
;;
4 | 04 )
/bin/alterarlimite
;;
5 | 05 )
/bin/remover
;;
6 | 06 )
/bin/expcleaner
;;
7 | 07 )
/bin/sshmonitor
;;
8 | 08 )clear
/bin/sshlimiter
exit
;;
9)
/bin/addhost
exit
;;
10)
/bin/delhost
exit
;;
11)
/bin/badvpnsetup
exit
;;
12)
/bin/userbackup
exit
;;
13)
/bin/speedtest.py
exit
;;
14)
/bin/tcptweaker
exit
;;
15)
/bin/openvpn-install
exit
;;
*)
tput setaf 7 ; tput setab 4 ; tput bold ; printf '%44s%s%-20s\n' "OPCIÓN INVÁLIDA..." ; tput sgr0
sleep 1
vps
exit
;;
esac
exit

