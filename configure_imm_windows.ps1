#DESCARGA

$cwd = $pwd
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12 # FIX ERROR SSL

New-Item -Path "." -Name "asu_output" -ItemType "directory" -ErrorAction SilentlyContinue
$TMP_DIR="$pwd\asu_output"

echo "Descargando..."
Invoke-WebRequest -Uri "https://github.com/wnpower/IBM_IMM/raw/master/bin/windows/ibm_utl_asu_asut86h-9.64_windows_x86-64.exe" -OutFile "$TMP_DIR\ibm_utl_asu_asut86h-9.64_windows_x86-64.exe"

echo "Descomprimiendo..."
Set-ExecutionPolicy RemoteSigned -Force
cd $TMP_DIR
.\ibm_utl_asu_asut86h-9.64_windows_x86-64.exe

cd $cwd

# INICIO

$DEFAULT_LOAD = Read-Host -Prompt "¿Cargar defaults IMM? (Recomendado si se está configurando por primera vez) [y/n]"

if($DEFAULT_LOAD -eq "y") {
	echo "Cargando defaults IMM..."
	& $TMP_DIR\asu64.exe loaddefault --kcs
}

# IP
$IP = Read-Host -Prompt "IP (XXX.XXX.XXX.XXX o n para no cambiar)"
echo ""
if($IP -eq "n") {
	echo "No se setea"
} else {
	& $TMP_DIR\asu64.exe set IMM.HostIPAddress1 $IP --kcs
}

# MASK
$MASK = Read-Host -Prompt "MASK (XXX.XXX.XXX.XXX o n para no cambiar)"
echo ""
if($MASK -eq "n") {
	echo "No se setea"
} else {
	& $TMP_DIR\asu64.exe set IMM.HostIPSubnet1 $MASK --kcs
}

# GW
$GW = Read-Host -Prompt "GATEWAY (XXX.XXX.XXX.XXX o n para no cambiar)"
echo ""
if($GW -eq "n") {
	echo "No se setea"
} else {
	& $TMP_DIR\asu64.exe set IMM.GatewayIPAddress1 $GW --kcs
}

# PUERTOS
$DEFAULT_PORTS = Read-Host -Prompt "¿Cambiar puertos por default HTTP y SSH? (Recomendado) [y/n]"

if($DEFAULT_PORTS -eq "y") {
	$HTTP_PORT = Read-Host -Prompt "HTTP Port (Recomendado: 43576 o n para no cambiar)"
	echo ""
	if($HTTP_PORT -eq "n") {
		echo "No se setea"
	} else {
		& $TMP_DIR\asu64.exe set IMM.HTTPPort $HTTP_PORT --kcs
	}
	
	$SSH_PORT = Read-Host -Prompt "SSH Port (Recomendado: 43578 o n para no cambiar)"
	echo ""
	if($SSH_PORT -eq "n") {
		echo "No se setea"
	} else {
		& $TMP_DIR\asu64.exe set IMM.SSHPort $SSH_PORT --kcs
	}
}

# PASSWORD
$CHANGE_PASSWD = Read-Host -Prompt "¿Cambiar password usuario principal? (USERID) [y/n]"

if($CHANGE_PASSWD -eq "y") {
	$PASSWD = Read-Host -Prompt "Password (Alfanumérico con minúculas, mayúsculas, números y caracteres especiales)"
	echo ""
	& $TMP_DIR\asu64.exe set IMM.password.1 "$PASSWD" --kcs
	echo "Listo!, Password del usuario USERID: $PASSWD"
}

echo ""

echo "Reiniciando IMM..."
& $TMP_DIR\asu64.exe rebootimm --kcs

echo "Listo!"
