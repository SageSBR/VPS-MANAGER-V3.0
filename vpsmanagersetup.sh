#!/bin/bash
rm -rf $HOME/vpsmanagersetup.sh
tput setaf 7 ; tput setab 4 ; tput bold ; printf '%35s%s%-20s\n' "VPS-MANAGER V3.0" ; tput sgr0
tput setaf 3 ; tput bold ; echo "" ; echo "Este script irá:" ; echo ""
echo "● Instale e configure o proxy squid nas portas 80, 3128, 8080 e 8799" ; echo "  para permitir conexiones SSH a este servidor"
echo "● Configure o OpenSSH para rodar nas portas 22 e 443"
echo "● Instale um conjunto de scripts e comandos do sistema para gerenciamento de usuários" ; tput sgr0
echo ""
tput setaf 3 ; tput bold ; read -n 1 -s -p "pressione qualquer tecla para continuar ... " ; echo "" ; echo "" ; tput sgr0
tput setaf 2 ; tput bold ; echo "	Termos de uso" ; tput sgr0
echo ""
echo "Ao usar o 'VPS-MANAGER V3.0 Administrator', você concorda com os seguintes termos de uso:"
echo ""
echo "1. Você pode:"
echo "a. Instale e use o 'VPS-MANAGER V3.0' no servidor ."
echo "b. Crie, gerencie e exclua um número ilimitado de usuários por meio deste conjunto de scripts."
echo ""
tput setaf 3 ; tput bold ; read -n 1 -s -p "Aperte qualquer tecla para continuar..." ; echo "" ; echo "" ; tput sgr0
echo "2. Você não pode:"
echo "a. Editar, modificar, vender ou redistribuir"
echo "este conjunto de scripts sem autorização do desenvolvedor."
echo "b. Modifique ou edite o conjunto de scripts para torná-lo parecido com o programador de scripts."
echo ""
echo "3. O usuário aceita que:"
echo "a. O conjunto de scripts não inclui garantias ou suporte adicional,"
echo ""
tput setaf 3 ; tput bold ; read -n 1 -s -p "Pressione qualquer tecla para continuar..." ; echo "" ; echo "" ; tput sgr0
IP=$(wget -qO- ipv4.icanhazip.com)
read -p "Para continuar confirme o IP deste servidor: " -e -i $IP ipdovps
if [ -z "$ipdovps" ]
then
	tput setaf 7 ; tput setab 1 ; tput bold ; echo "" ; echo "" ; echo " Você não inseriu o endereço IP deste servidor. Tenta de novo. " ; echo "" ; echo "" ; tput sgr0
	exit 1
fi
if [ -f "/root/usuarios.db" ]
then
tput setaf 6 ; tput bold ;	echo ""
	echo "Um banco de dados de usuário foi encontrado ('usuarios.db')!"
	echo "Deseja mantê-lo (preservando o limite de conexões simultâneas dos usuários)"
	echo "ou criar um novo banco de dados?"
	tput setaf 6 ; tput bold ;	echo ""
	echo "[1] Mantenha o banco de dados atualizado"
	echo "[2] Crie um novo banco de dados"
	echo "" ; tput sgr0
	read -p "Opção?: " -e -i 1 optiondb
else
	awk -F : '$3 >= 500 { print $1 " 1" }' /etc/passwd | grep -v '^nobody' > /root/usuarios.db
fi
echo ""
read -p "Você deseja habilitar a compactação SSH (pode aumentar o consumo de RAM)? [s/n]) " -e -i n sshcompression
echo ""
tput setaf 7 ; tput setab 4 ; tput bold ; echo "" ; echo "Aguarde a configuração automática" ; echo "" ; tput sgr0
sleep 3
apt-get update -y
apt-get upgrade -y
rm /bin/criarusuario /bin/expcleaner /bin/sshlimiter /bin/addhost /bin/listar /bin/sshmonitor /bin/vps > /dev/null
rm /root/ExpCleaner.sh /root/CriarUsuario.sh /root/sshlimiter.sh > /dev/null
apt-get install squid3 bc screen nano unzip dos2unix wget -y
killall apache2
apt-get purge apache2 -y
if [ -f "/usr/sbin/ufw" ] ; then
	ufw allow 443/tcp ; ufw allow 80/tcp ; ufw allow 3128/tcp ; ufw allow 8799/tcp ; ufw allow 8080/tcp
fi
if [ -d "/etc/squid3/" ]
then
	wget https://raw.githubusercontent.com/SageSBR/VPS-MANAGER-V3.0/master/squid1.txt -O /tmp/sqd1
	echo "acl url3 dstdomain -i $ipdovps" > /tmp/sqd2
	wget https://raw.githubusercontent.com/SageSBR/VPS-MANAGER-V3.0/master/squid2.txt -O /tmp/sqd3
	cat /tmp/sqd1 /tmp/sqd2 /tmp/sqd3 > /etc/squid3/squid.conf
	wget https://raw.githubusercontent.com/SageSBR/VPS-MANAGER-V3.0/master/payload.txt -O /etc/squid3/payload.txt
	echo " " >> /etc/squid3/payload.txt
	grep -v "^Port 35556" /etc/ssh/sshd_config > /tmp/ssh && mv /tmp/ssh /etc/ssh/sshd_config
	echo "Port 35556" >> /etc/ssh/sshd_config
	grep -v "^PasswordAuthentication yes" /etc/ssh/sshd_config > /tmp/passlogin && mv /tmp/passlogin /etc/ssh/sshd_config
	echo "PasswordAuthentication yes" >> /etc/ssh/sshd_config
	wget https://raw.githubusercontent.com/SageSBR/VPS-MANAGER-V3.0/master/scripts/addhost.sh -O /bin/addhost
	chmod +x /bin/addhost
	wget https://raw.githubusercontent.com/SageSBR/VPS-MANAGER-V3.0/master/scripts/alterarclaveusuario.sh -O /bin/alterarclaveusuario
	chmod +x /bin/alterarclaveusuario
	wget https://raw.githubusercontent.com/SageSBR/VPS-MANAGER-V3.0/master/scripts/socks.sh -O /bin/socked
	chmod +x /bin/socked
	wget https://raw.githubusercontent.com/SageSBR/VPS-MANAGER-V3.0/master/scripts/shadowsocks.sh -O /bin/shadowsocks
	chmod +x /bin/shadowsocks
	wget https://raw.githubusercontent.com/SageSBR/VPS-MANAGER-V3.0/master/scripts/crearusuario2.sh -O /bin/crearusuario
	chmod +x /bin/crearusuario
	wget https://raw.githubusercontent.com/SageSBR/VPS-MANAGER-V3.0/master/scripts/delhost.sh -O /bin/delhost
	chmod +x /bin/delhost
	wget https://raw.githubusercontent.com/SageSBR/VPS-MANAGER-V3.0/master/scripts/expcleaner2.sh -O /bin/expcleaner
	chmod +x /bin/expcleaner
	wget https://raw.githubusercontent.com/SageSBR/VPS-MANAGER-V3.0/master/scripts/mudardata.sh -O /bin/mudardata
	chmod +x /bin/mudardata
	wget https://raw.githubusercontent.com/SageSBR/VPS-MANAGER-V3.0/master/scripts/remover.sh -O /bin/remover
	chmod +x /bin/remover
	wget https://raw.githubusercontent.com/SageSBR/VPS-MANAGER-V3.0/master/scripts/sshlimiter2.sh -O /bin/sshlimiter
	chmod +x /bin/sshlimiter
	wget https://raw.githubusercontent.com/SageSBR/VPS-MANAGER-V3.0/master/scripts/alterarlimite.sh -O /bin/alterarlimite
	chmod +x /bin/alterarlimite
	wget https://raw.githubusercontent.com/SageSBR/VPS-MANAGER-V3.0/master/scripts/vps.sh -O /bin/vps
	chmod +x /bin/vps
	wget https://raw.githubusercontent.com/SageSBR/VPS-MANAGER-V3.0/master/scripts/sshmonitor2.sh -O /bin/sshmonitor
	chmod +x /bin/sshmonitor
	wget https://raw.githubusercontent.com/SageSBR/VPS-MANAGER-V3.0/master/scripts/extra/speedtest.py -O /bin/speedtest.py
	chmod +x /bin/speedtest.py
	wget https://raw.githubusercontent.com/SageSBR/VPS-MANAGER-V3.0/master/scripts/extra/badvpnsetup.sh -O /bin/badvpnsetup
	chmod +x /bin/badvpnsetup
	wget https://raw.githubusercontent.com/SageSBR/VPS-MANAGER-V3.0/master/scripts/extra/userbackup.sh -O /bin/userbackup
	chmod +x /bin/userbackup
	wget https://raw.githubusercontent.com/SageSBR/VPS-MANAGER-V3.0/master/scripts/extra/openvpn-install.sh -O /bin/openvpn-install
	chmod +x /bin/openvpn-install
	wget https://raw.githubusercontent.com/SageSBR/VPS-MANAGER-V3.0/master/scripts/extra/tcptweaker.sh -O /bin/tcptweaker
	chmod +x /bin/tcptweaker
	if [ ! -f "/etc/init.d/squid3" ]
	then
		service squid3 reload > /dev/null
	else
		/etc/init.d/squid3 reload > /dev/null
	fi
	if [ ! -f "/etc/init.d/ssh" ]
	then
		service ssh reload > /dev/null
	else
		/etc/init.d/ssh reload > /dev/null
	fi
fi
if [ -d "/etc/squid/" ]
then
	wget https://raw.githubusercontent.com/SageSBR/VPS-MANAGER-V3.0/master/squid1.txt -O /tmp/sqd1
	echo "acl url3 dstdomain -i $ipdovps" > /tmp/sqd2
	wget https://raw.githubusercontent.com/SageSBR/VPS-MANAGER-V3.0/master/squid.txt -O /tmp/sqd3
	cat /tmp/sqd1 /tmp/sqd2 /tmp/sqd3 > /etc/squid/squid.conf
	wget https://raw.githubusercontent.com/SageSBR/VPS-MANAGER-V3.0/master/payload.txt -O /etc/squid/payload.txt
	echo " " >> /etc/squid/payload.txt
	wget https://raw.githubusercontent.com/SageSBR/VPS-MANAGER-V3.0/master/scripts/socks.sh -O /bin/socked
	chmod +x /bin/socked
	wget https://raw.githubusercontent.com/SageSBR/VPS-MANAGER-V3.0/master/scripts/shadowsocks.sh -O /bin/shadowsocks
	chmod +x /bin/shadowsocks
	wget https://raw.githubusercontent.com/SageSBR/VPS-MANAGER-V3.0/master/scripts/2/addhost.sh -O /bin/addhost
	chmod +x /bin/addhost
	wget https://raw.githubusercontent.com/SageSBR/VPS-MANAGER-V3.0/master/scripts/alterarclaveusuario.sh -O /bin/alterarclaveusuario
	chmod +x /bin/alterarclaveusuario
	wget https://raw.githubusercontent.com/SageSBR/VPS-MANAGER-V3.0/master/scripts/crearusuario2.sh -O /bin/crearusuario
	chmod +x /bin/crearusuario
	wget https://raw.githubusercontent.com/SageSBR/VPS-MANAGER-V3.0/master/scripts/2/delhost.sh -O /bin/delhost
	chmod +x /bin/delhost
	wget https://raw.githubusercontent.com/SageSBR/VPS-MANAGER-V3.0/master/scripts/expcleaner2.sh -O /bin/expcleaner
	chmod +x /bin/expcleaner
	wget https://raw.githubusercontent.com/SageSBR/VPS-MANAGER-V3.0/master/scripts/mudardata.sh -O /bin/mudardata
	chmod +x /bin/mudardata
	wget https://raw.githubusercontent.com/SageSBR/VPS-MANAGER-V3.0/master/scripts/remover.sh -O /bin/remover
	chmod +x /bin/remover
	wget https://raw.githubusercontent.com/SageSBR/VPS-MANAGER-V3.0/master/scripts/sshlimiter2.sh -O /bin/sshlimiter
	chmod +x /bin/sshlimiter
	wget https://raw.githubusercontent.com/SageSBR/VPS-MANAGER-V3.0/master/scripts/alterarlimite.sh -O /bin/alterarlimite
	chmod +x /bin/alterarlimite
	wget https://raw.githubusercontent.com/SageSBR/VPS-MANAGER-V3.0/master/scripts/vps.sh -O /bin/vps
	chmod +x /bin/vps
	wget https://raw.githubusercontent.com/SageSBR/VPS-MANAGER-V3.0/master/scripts/sshmonitor2.sh -O /bin/sshmonitor
	chmod +x /bin/sshmonitor
	wget https://raw.githubusercontent.com/SageSBR/VPS-MANAGER-V3.0/master/scripts/extra/speedtest.py -O /bin/speedtest.py
	chmod +x /bin/speedtest.py
	wget https://raw.githubusercontent.com/SageSBR/VPS-MANAGER-V3.0/master/scripts/extra/badvpnsetup.sh -O /bin/badvpnsetup
	chmod +x /bin/badvpnsetup
	wget https://raw.githubusercontent.com/SageSBR/VPS-MANAGER-V3.0/master/scripts/extra/userbackup.sh -O /bin/userbackup
	chmod +x /bin/userbackup
	wget https://raw.githubusercontent.com/SageSBR/VPS-MANAGER-V3.0/master/scripts/extra/openvpn-install.sh -O /bin/openvpn-install
	chmod +x /bin/openvpn-install
	wget https://raw.githubusercontent.com/SageSBR/VPS-MANAGER-V3.0/master/scripts/extra/tcptweaker.sh -O /bin/tcptweaker
	chmod +x /bin/tcptweaker
	if [ ! -f "/etc/init.d/squid" ]
	then
		service squid restart > /dev/null
	else
		/etc/init.d/squid restart > /dev/null
	fi
	if [ ! -f "/etc/init.d/ssh" ]
	then
		service ssh restart > /dev/null
	else
		/etc/init.d/ssh restart > /dev/null
	fi
fi
echo ""
tput setaf 7 ; tput setab 4 ; tput bold ; echo "Proxy Squid instalado e rodando nas portas: 80, 3128, 8080 e 8799" ; tput sgr0
tput setaf 7 ; tput setab 4 ; tput bold ; echo "OpenSSH é executado em portas 22 e 443" ; tput sgr0
tput setaf 7 ; tput setab 4 ; tput bold ; echo "scripts para gerenciar usuários instalados" ; tput sgr0
tput setaf 7 ; tput setab 4 ; tput bold ; echo "Leia a documentação para evitar perguntas e problemas!" ; tput sgr0
tput setaf 7 ; tput setab 4 ; tput bold ; echo "Para ver os comandos disponíveis, use o comando: vps" ; tput sgr0
echo ""
if [[ "$optiondb" = '2' ]]; then
	awk -F : '$3 >= 500 { print $1 " 1" }' /etc/passwd | grep -v '^nobody' > /root/usuarios.db
fi
if [[ "$sshcompression" = 's' ]]; then
	grep -v "^Compression yes" /etc/ssh/sshd_config > /tmp/sshcp && mv /tmp/sshcp /etc/ssh/sshd_config
	echo "Compression yes" >> /etc/ssh/sshd_config
fi
if [[ "$sshcompression" = 'n' ]]; then
	grep -v "^Compression yes" /etc/ssh/sshd_config > /tmp/sshcp && mv /tmp/sshcp /etc/ssh/sshd_config
fi
exit 1
rm -rf $HOME/vpsmanagersetup.sh
