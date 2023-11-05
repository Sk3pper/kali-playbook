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
### Run via curl
```
sh -c "$(curl -fsSL https://raw.githubusercontent.com/Sk3pper/playbook-kali/main/Bash/playbook-kali.sh) --help"
```

### Run via wget
```
sh -c "$(wget -qO- https://raw.githubusercontent.com/Sk3pper/playbook-kali/main/Bash/playbook-kali.sh) --help"
```

### Run via fetch
```
sh -c "$(fetch -o - https://raw.githubusercontent.com/Sk3pper/playbook-kali/main/Bash/playbook-kali.sh) --help"
```

#

<!-- Usage section -->
## Usage 🔫

### Bash 💻
```
# install all components
./playbook-kali.sh --all --stable-debian-version bookworm --user kali

# install vscode
./playbook-kali.sh --vscode

# install oh-my-zsh and powerlevel10k
./playbook-kali.sh --omz --pl10k --user kali

# install pyenv
./playbook-kali.sh --pyenv --user kali

# install docker-ce, docker compose plugin
./playbook-kali.sh --docker --stable-debian-version bookworm --user kali

# install golang v1.21.3 x86-64
./playbook-kali.sh --golang
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
