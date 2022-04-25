#!/bin/bash
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
CWD="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
TMP_DIR="$CWD/asu_output"

function check_IP() {
	if (!(echo "$1" | grep -E '^\b((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)(\.|$)){4}\b$' > /dev/null) && !(echo "$1" | grep -E '^(([0-9a-fA-F]{1,4}:){7,7}[0-9a-fA-F]{1,4}|([0-9a-fA-F]{1,4}:){1,7}:|([0-9a-fA-F]{1,4}:){1,6}:[0-9a-fA-F]{1,4}|([0-9a-fA-F]{1,4}:){1,5}(:[0-9a-fA-F]{1,4}){1,2}|([0-9a-fA-F]{1,4}:){1,4}(:[0-9a-fA-F]{1,4}){1,3}|([0-9a-fA-F]{1,4}:){1,3}(:[0-9a-fA-F]{1,4}){1,4}|([0-9a-fA-F]{1,4}:){1,2}(:[0-9a-fA-F]{1,4}){1,5}|[0-9a-fA-F]{1,4}:((:[0-9a-fA-F]{1,4}){1,6})|:((:[0-9a-fA-F]{1,4}){1,7}|:)|fe80:(:[0-9a-fA-F]{0,4}){0,4}%[0-9a-zA-Z]{1,}|::(ffff(:0{1,4}){0,1}:){0,1}((25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])\.){3,3}(25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])|([0-9a-fA-F]{1,4}:){1,4}:((25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])\.){3,3}(25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9]))$' > /dev/null)); then
		return 1
	else
		return 0
	fi
}

mkdir -p $TMP_DIR 2>/dev/null

echo "Descargando ASU..."

wget https://raw.githubusercontent.com/wnpower/IBM_IMM/master/bin/linux/ibm_utl_asu_asut86h-9.64_linux_x86-64.tgz -O $TMP_DIR/ibm_utl_asu_asut86h-9.64_linux_x86-64.tgz
cd $TMP_DIR && tar xvfz ibm_utl_asu_asut86h-9.64_linux_x86-64.tgz

echo ""
echo -n "¿Cargar defaults IMM? (Recomendado si se está configurando por primera vez) [y/n]: "
read DEFAULT_LOAD

if [ "$DEFAULT_LOAD" = "y" ]; then
	echo "Cargando defaults IMM..."
	$TMP_DIR/asu64 loaddefault
fi

echo ""
echo -n "IP (XXX.XXX.XXX.XXX o n para no cambiar): "
read IP
if ! check_IP $IP; then
	echo "$IP no es una IP válida, no se setea"
else
	$TMP_DIR/asu64 set IMM.HostIPAddress1 $IP --kcs
fi

echo ""
echo -n "MASK (XXX.XXX.XXX.XXX o n para no cambiar): "
read MASK
if ! check_IP $MASK; then
        echo "$MASK no es una IP válida, abortando"
else
	$TMP_DIR/asu64 set IMM.HostIPSubnet1 $MASK --kcs
fi

echo ""
echo -n "GATEWAY (XXX.XXX.XXX.XXX o n para no cambiar): "
read GATEWAY
if ! check_IP $GATEWAY; then
        echo "$GATEWAY no es una IP válida, abortando"
else
	$TMP_DIR/asu64 set IMM.GatewayIPAddress1 $GATEWAY --kcs
fi

echo ""
echo -n "¿Cambiar puertos por default HTTP y SSH? (Recomendado) [y/n]: "
read DEFAULT_PORTS

if [ "$DEFAULT_PORTS" = "y" ]; then
        echo -n "HTTP Port (Recomendado: 43576): "
	read HTTP_PORT
	$TMP_DIR/asu64 set IMM.HTTPPort $HTTP_PORT --kcs

	echo ""
        echo -n "SSH Port (Recomendado: 43578): "
        read SSH_PORT
        $TMP_DIR/asu64 set IMM.SSHPort $SSH_PORT --kcs
fi

echo ""
echo -n "¿Cambiar password usuario principal? (USERID) [y/n]: "
read CHANGE_PASSWD

if [ "$CHANGE_PASSWD" = "y" ]; then
	echo -n "Password (Alfanumérico con minúculas, mayúsculas, números y caracteres especiales): "
	read PASSWD
	$TMP_DIR/asu64 set IMM.password.1 "$PASSWD"
fi

echo "Desactivando Telnet..."
$TMP_DIR/asu64 set IMM.TelnetSessions disable --kcs

echo ""
$TMP_DIR/asu64 rebootimm --kcs

echo ""
echo "Listo!"
