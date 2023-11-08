# Playbook kali 🐉
The purpose of this script is to easy install all the necessary tools/configurations in a kali machine. The supported installations/configurations in this moment are:
* vscode
* zsh, ohmyz and powerlevel10k
* pyenv and enable virtualenv version on zsh bash
* docker-ce, docker compose plugin
* golang (v1.21.3 x86-64)

<!-- ## Table of contents
    * [General info](#general-info)
    * [Technologies](#technologies)
    * [Setup](#setup) 
-->

## Installation 🔨

```
wget -qO https://raw.githubusercontent.com/Sk3pper/playbook-kali/main/Bash/playbook-kali.sh
chmod 744 ./playbook-kali.sh
./playbook-kali.sh --help
```

<!-- Usage section -->
## Usage 🔫

### Bash 💻
#### Usage
```
playbook-kali.sh [-h] [-v] [--all] [--vscode] [--zsh] [--user] [--pl10k] [--pyenv] [--docker] [--golang] -s stable-debian-version -u zsh-user --log-path-file log-playbook

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
./playbook-kali.sh --all --stable-debian-version bookworm --user kali --log-path-file log

# install vscode
./playbook-kali.sh --vscode --log-path-file log

# install oh-my-zsh and powerlevel10k
./playbook-kali.sh --omz --pl10k --user kali --log-path-file log

# install pyenv
./playbook-kali.sh --pyenv --user kali --log-path-file log

# install docker-ce, docker compose plugin
./playbook-kali.sh --docker --stable-debian-version bookworm --user kali --log-path-file log

# install golang v1.21.3 x86-64
./playbook-kali.sh --golang --log-path-file log
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
