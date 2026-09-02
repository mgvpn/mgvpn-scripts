#!/bin/bash
clear && clear
rm -rf /etc/localtime &>/dev/null
ln -s /usr/share/zoneinfo/America/Mexico_City /etc/localtime &>/dev/null

os_system() {
  system=$(cat -n /etc/issue | grep 1 | cut -d ' ' -f6,7,8 | sed 's/1//' | sed 's/      //')
  distro=$(echo "$system" | awk '{print $1}')
  case $distro in
  Debian) vercion=$(echo $system | awk '{print $3}' | cut -d '.' -f1) ;;
  Ubuntu) vercion=$(echo $system | awk '{print $2}' | cut -d '.' -f1,2) ;;
  esac
}

repo() {
  link="https://raw.githubusercontent.com/NetVPS/Multi-Script/main/Source-List/$1.list"
  case $1 in
  8 | 9 | 10 | 11 | 16.04 | 18.04 | 20.04 | 20.10 | 21.04 | 21.10 | 22.04) wget -O /etc/apt/sources.list ${link} &>/dev/null ;;
  esac
}

dependencias() {
  soft="sudo bsdmainutils zip unzip ufw curl python python3 python3-pip openssl screen cron iptables lsof pv boxes nano at mlocate gawk grep bc jq curl npm nodejs socat netcat netcat-traditional net-tools cowsay figlet lolcat apache2"
  for i in $soft; do
    apt install $i -y &>/dev/null
  done
}

install_ADMRufu() {
  clear && clear
  echo -ne "Digite su slogan/reseller: " && read slogan
  echo -e "$slogan"
  mkdir /etc/ADMRufu >/dev/null 2>&1
  cd /etc
  wget https://raw.githubusercontent.com/NetVPS/Multi-Script/main/R9/ADMRufu.tar.xz >/dev/null 2>&1
  tar -xf ADMRufu.tar.xz >/dev/null 2>&1
  chmod +x ADMRufu.tar.xz >/dev/null 2>&1
  rm -rf ADMRufu.tar.xz
  cd
  chmod -R 755 /etc/ADMRufu

  # --- Rebranding del panel ---
  sed -i 's/ADMRufu <<<<=====/MG VPN MANAGER <<<<=====/' /etc/ADMRufu/menu

  ADMRufu="/etc/ADMRufu" && [[ ! -d ${ADMRufu} ]] && mkdir ${ADMRufu}
  ADM_inst="${ADMRufu}/install" && [[ ! -d ${ADM_inst} ]] && mkdir ${ADM_inst}
  rm -rf /usr/bin/menu
  rm -rf /usr/bin/adm
  rm -rf /usr/bin/ADMRufu
  mkdir -p /etc/ADMRufu/tmp
  echo "$slogan" >/etc/ADMRufu/tmp/message.txt
  echo "${ADMRufu}/menu" >/usr/bin/menu && chmod +x /usr/bin/menu
  echo "${ADMRufu}/menu" >/usr/bin/adm && chmod +x /usr/bin/adm
  echo "${ADMRufu}/menu" >/usr/bin/ADMRufu && chmod +x /usr/bin/ADMRufu
  [[ -z $(echo $PATH | grep "/usr/games") ]] && echo 'if [[ $(echo $PATH|grep "/usr/games") = "" ]]; then PATH=$PATH:/usr/games; fi' >>/etc/bash.bashrc
  echo '[[ $UID = 0 ]] && screen -dmS up /etc/ADMRufu/chekup.sh' >>/etc/bash.bashrc
  echo 'v=$(cat /etc/ADMRufu/vercion)' >>/etc/bash.bashrc
  echo '[[ -e /etc/ADMRufu/new_vercion ]] && up=$(cat /etc/ADMRufu/new_vercion) || up=$v' >>/etc/bash.bashrc
  echo -e "[[ \$(date '+%s' -d \$up) -gt \$(date '+%s' -d \$(cat /etc/ADMRufu/vercion)) ]] && v2=\"Nueva Version disponible: \$v >>> \$up\" || v2=\"Version: \$v\"" >>/etc/bash.bashrc
  echo '[[ -e "/etc/ADMRufu/tmp/message.txt" ]] && mess1="$(less /etc/ADMRufu/tmp/message.txt)"' >>/etc/bash.bashrc
  echo '[[ -z "$mess1" ]] && mess1="MG VPN"' >>/etc/bash.bashrc
  echo 'clear && echo -e "\n$(figlet -f big.flf "MG VPN")\n        RESELLER : $mess1 \n\n   Para iniciar el panel escriba:  menu \n\n   $v2\n\n"|lolcat' >>/etc/bash.bashrc
  update-locale LANG=en_US.UTF-8 LANGUAGE=en
  clear && clear
  echo -e "\e[1;92m             >> INSTALACION COMPLETADA <<"
  echo -e "      COMANDO PRINCIPAL PARA ENTRAR AL PANEL "
  echo -e "                      \033[1;41m  menu  \033[0;37m"
}

echo -ne "Actualizar sistema antes de instalar? [S/N]: "
read opcion
if [[ "$opcion" == @(s|S) ]]; then
  os_system
  repo "${vercion}"
  apt update -y
  apt upgrade -y
fi

os_system
echo "Instalando dependencias..."
dependencias

install_ADMRufu
