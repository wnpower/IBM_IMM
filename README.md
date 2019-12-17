# IBM IMM
Scripts para configuración de módulo IMM de IBM.
Realiza:

 - Cambio/seteo de IP
 - Cambio de puertos SSH y HTTP
 - Cambio de Password de usuario principal (USERID)

Servidores compatibles (algunos pueden requerir una Key especial, ej: X3250 M4): [https://www.ibm.com/support/pages/ibm-advanced-settings-utility-asu](https://www.ibm.com/support/pages/ibm-advanced-settings-utility-asu)

## Instalación

### Linux
	wget https://raw.githubusercontent.com/wnpower/IBM_IMM/master/configure_imm_linux.sh -O configure_imm_linux.sh && bash configure_imm_linux.sh

### Windows

	Invoke-WebRequest -Uri "https://raw.githubusercontent.com/wnpower/IBM_IMM/master/configure_imm_windows.ps1" -OutFile "$pwd/configure_imm_windows.ps1"; Set-ExecutionPolicy RemoteSigned -Force; & "$pwd/configure_imm_windows.ps1"; Remove-Item "$pwd/configure_imm_windows.ps1"
