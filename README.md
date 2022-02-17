<h1 align="center">Welcome to hashcloud 👋</h1>
<p>
  <img alt="Version" src="https://img.shields.io/badge/version-1.0.0-blue.svg?cacheSeconds=2592000" />
  <a href="https://github.com/theirsecurity/venomcheat" target="_blank">
    <img alt="Documentation" src="https://img.shields.io/badge/documentation-yes-brightgreen.svg" />
  </a>
</p>

> This script uses MSFVenom and Pentest Monkey's Reverese PHP shell to automatically generate a set of reverse shells based on the options you choose.

### 🏠 [Homepage](https://github.com/theirsecurity/hashcloud)

## Install

```sh
git clone https://github.com/theirsecurity/VenomCheat
```

## Sequential Port Numbering

In Version 1.0.0 all reverse shells will be generated using the same Local Port. In the next version it will include an option so that each payload has a different local port.

## Guided Mode

If you want to use the guided mode start with ./VenomCheat.sh -g y
This will let you specify what you want to be generated

## Usage

```sh
Once downloaded use the command chmod +x VenomCheat.sh
Then to see the help section use ./VenomCheat.sh -h

To use the defaults omit the operator from the command line
-i  This sets the local host of your payloads                       Default:BLANK
-p  This will set the local port for your payloads                  Default:BLANK
-o  This allows you to specify one target OS                        Default:all
-n  This allows you to set if port will be static or sequential     Default:Static
-a  This allows you to specify x86,x64 or all                       Default:all
-e  This allows you to choose encoding and iterations               Default:8
-s  This sets whether or not the MSF command will autostart         Default:Yes

The following options are used with -o, If you want them all omit -o
-o win    This will generate only windows payloads
-o lin    This will generate only linux payloads
-o mac    This will generate only mac payloads
-o web    This will generate only web payloads
-o raw    This will generate txt files with raw commands

The following options are used to set the archetecture, if you want them all omit -a
-a x86    This will only generate 32bit payloads
-a x64    This will only generate 64bit payloads

The following are used with -e. The number you set is the iterations it will use (Applies only to Windows)
-e 0      This will skip generation of encoded payloads
-e 8      This will generate encoded payloads with 8 iterations (It will use the number you set)

The following are used with -s
-s y      This will add the auto start to the generated msf command in the output
-s n      If you use the generated msf command, you will need to start this yourself

Once the script has run it will create a readme.md in the Venom Directory
This will show the options used, everything it created, each files location and a command to start metasploit



```

## Author

👤 **Marc@theirsecurity.com**

* Website: https://theirsecurity.com
* Github: [@theirsecurity](https://github.com/theirsecurity)
