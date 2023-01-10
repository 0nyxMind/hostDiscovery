#!/bin/bash

#Colours
greenColour="\e[0;32m\033[1m"
endColour="\033[0m\e[0m"
redColour="\e[0;31m\033[1m"
blueColour="\e[0;34m\033[1m"
yellowColour="\e[0;33m\033[1m"
purpleColour="\e[0;35m\033[1m"
turquoiseColour="\e[0;36m\033[1m"
grayColour="\e[0;37m\033[1m"

function ctrl_c(){
  echo -e "\n\n${redColour}[!] Saliendo...${endColour}\n"
  tput cnorm &&  exit 1
}

# Ctrl+C
trap ctrl_c INT


function helpPanel(){
	echo -e " _               _     ____  _                                   \n| |__   ___  ___| |_  |  _ \(_)___  ___ _____   _____ _ __ _   _ \n| '_ \ / _ \/ __| __| | | | | / __|/ __/ _ \ \ / / _ \ '__| | | |\n| | | | (_) \__ \ |_  | |_| | \__ \ (_| (_) \ V /  __/ |  | |_| |\n|_| |_|\___/|___/\__| |____/|_|___/\___\___/ \_/ \___|_|   \__, |\n                                                           |___/ "
	echo -e "\t\t\t${grayColour}By:${endColour}${purpleColour} ONYX${endColour}"
	echo -e "\n${yellowColour}[+]${endColour}${grayColour} Uso:${endColour}"
	echo -e "\t${purpleColour}i)${endColour}${grayColour} Dirección IP${endColour}"
	echo -e "\n${redColour}[!]${endColour}${grayColour} La dirección IP debe contener una x, en la 'x' se reemplazará los numero. Ej: ${endColour}${blueColour}192.168.1.x${endColour}\n"
}

function verifyX(){
	ipAddress="$1"

	if grep -q "^[^x]*x[^x]*$" <<< "$ipAddress"; then
		echo -e "\n${yellowColour}[+]${endColour}${grayColour} Descubriendo hosts activos.${endColour}\n"
		scan $ipAddress
	else
		helpPanel

	fi
}

function scan(){
	ipAddress=$1
	for num in $(seq 1 254); do
		target=$(echo $ipAddress | sed "s/x/$num/g")
		(timeout 1 bash -c "ping -c 1 $target") &>/dev/null && echo -e "${yellowColour}[+]${endColour}${grayColour} Host activo -${endColour} ${blueColour}$target${endColour}" &
		tput civis
		done; wait
		tput cnorm
}

# Indicadores
declare -i parameter_counter=0

while getopts "i:h" arg; do
  case $arg in
    i) ipAddress="$OPTARG"; let parameter_counter+=1;;
    h) ;;
  esac
done

if [ $parameter_counter -eq 1 ]; then
  verifyX $ipAddress
else
  helpPanel
fi

