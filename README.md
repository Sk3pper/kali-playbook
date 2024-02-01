# Playbook kali 🐉
The purpose of this script is to easy install all the necessary tools/configurations in a kali machine. The supported installations/configurations in this moment are:
* vscode
* zsh, ohmyz and powerlevel10k
* pyenv and enable virtualenv version on zsh bash
* docker-ce, docker compose plugin
* golang (v1.21.3 x86-64)
  
https://github.com/Sk3pper/kali-playbook/assets/13051136/e5e88f73-4010-4b61-86bd-78fcc01ae4d2


<!-- ## Table of contents
    * [General info](#general-info)
    * [Technologies](#technologies)
    * [Setup](#setup) 
-->

## Installation 🔨

```
wget -qO https://raw.githubusercontent.com/Sk3pper/kali-playbook/main/Bash/kali-playbook.sh
chmod 744 ./kali-playbook.sh
./kali-playbook.sh --help
```

<!-- Usage section -->
## Usage 🔫

### Bash 💻
#### Usage
```
kali-playbook.sh [-h] [-v] [--all] [--vscode] [--zsh] [--user] [--pl10k] [--pyenv] [--docker] [--golang] -s stable-debian-version -u zsh-user --log-path-file log-playbook

Available options:
-h, --help                  Print this help and exit
-v, --verbose               Print script debug info
-l, --log-path-file         log path file (if not specified only default messages are printed on the terminal)               
-a, --all                   Install all the tools listed above
-c, --vscode                Install vscode
-z, --omz                   Install zsh and oh-my-zsh
-u, --user                  Specify the user to install components
-k, --pl10k                 Install powerlevel10k template on zsh
-p, --pyenv                 Install pyenv
-d, --docker                Install docker-ce and docker-compose-plugin
-g, --golang                Install golang 1.21.3 x86-64
-s, --stable-debian-version Specify debian stable version to install the right versions of the component (eg: bookworm)
```

#### Examples
```
# install all components
./kali-playbook.sh --all --stable-debian-version bookworm --user kali --log-path-file log

# install vscode
./kali-playbook.sh --vscode --log-path-file log

# install oh-my-zsh and powerlevel10k
./kali-playbook.sh --omz --pl10k --user kali --log-path-file log

# install pyenv
./kali-playbook.sh --pyenv --user kali --log-path-file log

# install docker-ce, docker compose plugin
./kali-playbook.sh --docker --stable-debian-version bookworm --user kali --log-path-file log

# install golang v1.21.3 x86-64
./kali-playbook.sh --golang --log-path-file log
```
<!-- add gift/video -->

<!-- 
    ### Python 🐍
    Required python
    ```
    #todo
    ```

    ### Golang 🐹
    Required Golang
    ```
    #todo
``` 
-->

<!-- Technologies section -->

## Technologies
<!-- I implemented it in three different ways: bash, python and golang. -->

### Bash 💻
Template bash script template is taken from [script-template.sh](https://gist.github.com/m-radzikowski/53e0b39e9a59a1518990e76c2bff8038). In this following [link](https://betterdev.blog/minimal-safe-bash-script-template/) you can find the full article. I added the source code template under /Bash folder with mine useful comments.

<!-- ### Python 🐍
#Todo

### Golang 🐹
#Todo -->

<!-- Enviroment where it was tested -->

## Tests
Tested on
- [x] kali-linux-2023.3-vmware-amd64 version (```SHA256sum cda701776d4e17c24845c0b2d57e40f4fecab5c7de22d88ddc7bdaef671b0838```)
