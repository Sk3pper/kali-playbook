#!/usr/bin/env bash

# The purpose of this script is to easy install all the necessary tools/configurations in a kali machine. The supported installations/configurations in this moment are:
#   vscode
#   zsh, ohmyz and powerlevel10k
#   pyenv and enable virtualenv version on zsh bash (if present)
#   docker-ce, docker compose plugin
#   golang


# fail fast
set -Eeuo pipefail

# at the end of the script (normal or caused by an error or an external signal) the cleanup() function will be executed.
trap cleanup SIGINT SIGTERM ERR EXIT

# get script location
script_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd -P)

usage() {
msg "${NOFORMAT}"
cat << EOF # remove the space between << and EOF, this is due to web plugin issue
Usage: $(basename "${BASH_SOURCE[0]}") [-h] [-v] [--all] [--vscode] [--zsh] [--zsh-user] [--pl10k] [--pyenv] [--docker] [--golang] -s stable-debian-version -u zsh-user

Available options:
-h, --help                  Print this help and exit
-v, --verbose               Print script debug info
-a, --all                   Install all the tools listed above
-c, --vscode                Install vscode
-z, --omz                  Install zsh and oh-my-zsh
-u, --zsh-user              Specify the user to enable zsh
-k, --pl10k                 Install powerlevel10k template on zsh
-p, --pyenv                 Install pyenv
-d, --docker                Install docker and docker compose
-g, --golang                Install golang
-s, --stable-debian-version Specify debian stable version to install the right versions of the component (eg: bookworm)

Example:
    - ./playbook-kali.sh --all --stable-debian-version bookworm --zsh-user kali
    - ./playbook-kali.sh --omz --pl10k --zsh-user kali
    - ./playbook-kali.sh --pyenv
    - ./playbook-kali.sh --docker --stable-debian-version bookworm
    - ./playbook-kali.sh --pyenv --omz --pl10k
EOF
exit
}

cleanup() {
    trap - SIGINT SIGTERM ERR EXIT
    # script cleanup here
}

setup_colors() {
    if [[ -t 2 ]] && [[ -z "${NO_COLOR-}" ]] && [[ "${TERM-}" != "dumb" ]]; then
        NOFORMAT='\033[0m' RED='\033[0;31m' GREEN='\033[0;32m' ORANGE='\033[0;33m' BLUE='\033[0;34m' PURPLE='\033[0;35m' CYAN='\033[0;36m' YELLOW='\033[1;33m'
    else
        NOFORMAT='' RED='' GREEN='' ORANGE='' BLUE='' PURPLE='' CYAN='' YELLOW=''
    fi
}

msg() {
    echo >&2 -e "${1-}"
}

die() {
    local msg=$1
    local code=${2-1} # default exit status 1
    msg "$msg"
    exit "$code"
}

parse_params() {
    # default values of variables set from params
    all=0
    vscode=0
    zsh=0
    pl10k=0
    pyenv=0
    docker=0
    golang=0
    stable_debian_version=""
    user=""

    while :; do
        case "${1-}" in
        # flags
        -h | --help) usage ;;
        -v | --verbose) set -x ;;
        --no-color) NO_COLOR=1 ;;
        -a | --all) all=1 ;; 
        -c | --vscode) vscode=1 ;;

        # zsh
        -z | --omz) zsh=1 ;;
        # named parameter
        -u | --zsh-user) 
        user="${2-}"
        shift ;;

        -k | --pl10k) pl10k=1 ;;
        -p | --pyenv) pyenv=1 ;;
        -g | --golang) golang=1;;
        
        # docker
        -d | --docker) docker=1 ;;
        # named parameter
        -s | --stable-debian-version) 
        stable_debian_version="${2-}"
        shift ;;

        -?*) die "Unknown option: $1" ;;
        *) break ;;
        esac
        # shifts the command-line arguments to the left to prepare for processing the next argument. This effectively removes the processed argument and its value from consideration.
        shift
    done

    # at the end the remaing information (after n*shift) will be the script arguments
    args=("$@")

    # check required params and arguments
    # [[ -z "${param-}" ]] && die "Missing required parameter: param"
    # [[ ${#args[@]} -eq 0 ]] && die "Missing script arguments"

    return 0
}

install_all(){
    msg "\n${GREEN}******** Installing all the components ******"
    install_zsh_omz
    install_pl10k
    install_pyenv
    install_docker
    install_golang
    msg "${GREEN}****************************************************"
}

install_vscode(){
    msg "\n${YELLOW}******** Installing vscode ******"

    sudo apt-get install wget gpg
    wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
    sudo install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
    sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
    rm -f packages.microsoft.gpg

    sudo apt install apt-transport-https
    sudo apt update
    sudo apt install code # or code-insiders

    msg "${YELLOW}****************************************************"
}


install_zsh_omz(){
    msg "\n${BLUE}******** Installing zsh and h My Zsh! ******"
    # install ZSH
    msg "\n${BLUE}sudo apt -y install zsh requires the password"
    sudo apt -y install zsh

    # install oh-my-zsh via curl
    # RUNZSH - 'no' means the installer will not run zsh after the install (default: yes)
    export RUNZSH="no"
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" &> /dev/null

    # install zsh-autosuggestions 
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions &> /dev/null

    # zsh-syntax-highlighting 
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting &> /dev/null

    # switch from BASH to ZSH
    sudo chsh -s /bin/zsh "$user" 1> /dev/null

    # check if $user has set properly
    check=$(sudo cat /etc/passwd | grep "$user")

    if [[ "$check" != *"/bin/zsh"* ]]; then
        die "switch from old to ZSH bash it didn't work out"
    fi

    # enable zsh-autosuggestions and zsh-syntax-highlighting
    sed -i 's/plugins=(git)/plugins=(git zsh-autosuggestions zsh-syntax-highlighting)/' /home/"${user}"/.zshrc &> /dev/null

    msg "${BLUE}****************************************************"
}

install_pl10k(){
    # check if .oh-my-zsh is installed
    if [ ! -d "/home/${user}/.oh-my-zsh" ];
    then
        die "${RED} Install oh-my-zsh first (./playbook-kali.sh --omz --zsh-user <username>)"
    fi

    msg "\n${CYAN}******** Installing powerlevel10k ******"

    # download powerlevel10k theme
    if [ ! -d "/home/${user}/.oh-my-zsh/custom/themes/powerlevel10k" ];
    then
        git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k &> /dev/null
    else
        msg "\n${CYAN}powerlevel10k theme is alredy present, enabling it"
    fi

    # enable powerlevel10k theme
    sed -i 's/ZSH_THEME="robbyrussell"/ ZSH_THEME="powerlevel10k\/powerlevel10k"/' /home/"${user}"/.zshrc &> /dev/null

    # edit .zshrc file adding in the head of file
    text_to_add="# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r \"\${XDG_CACHE_HOME:-\$HOME/.cache}/p10k-instant-prompt-\${(%):-%n}.zsh\" ]]; then
source \"\${XDG_CACHE_HOME:-\$HOME/.cache}/p10k-instant-prompt-\${(%):-%n}.zsh\"
fi\n"
    zsrc=$(cat "/home/${user}/.zshrc")
    echo -e "$text_to_add" > /home/"${user}"/.zshrc
    echo "$zsrc" >> /home/"${user}"/.zshrc

    # edit .zshrc file adding in the tail
    echo -e "\n# To customize prompt, run \`p10k configure\` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh" >>  /home/"${user}"/.zshrc

    # download customize p10k.zsh config file under /home/"${user}"/.p10k.zsh path
    wget -O /home/"${user}"/.p10k.zsh https://raw.githubusercontent.com/Sk3pper/playbook-kali/main/Bash/config/p10k.zsh &> /dev/null

    wget -O /home/"${user}"/.cache/p10k-instant-prompt-kali.zsh https://raw.githubusercontent.com/Sk3pper/playbook-kali/main/Bash/config/p10k-instant-prompt-kali.zsh &> /dev/null
    chmod 700 /home/"${user}"/.cache/p10k-instant-prompt-kali.zsh

    wget -O /home/"${user}"/.cache/p10k-instant-prompt-kali.zsh.zwc https://raw.githubusercontent.com/Sk3pper/playbook-kali/main/Bash/config/p10k-instant-prompt-kali.zsh.zwc &> /dev/null
    chmod 444 /home/"${user}"/.cache/p10k-instant-prompt-kali.zsh.zwc

    msg "${CYAN} To customize prompt, open new terminal and run \`p10k configure\` or edit ~/.p10k.zsh."

    # idea: copia e incolla il mio file di configurazione (~/.p10k.zsh), e scrivi che se non piace di runnare "p10k configure"
    msg "${CYAN}****************************************************"
}

# ./Desktop/playbook-kali.sh --omz --pl10k --zsh-user kali --pyenv
# ./Desktop/playbook-kali.sh --pyenv --zsh-user kali
install_pyenv(){
    msg "\n${PURPLE}******** Installing pyenv ******"

    # Install pyenv
    curl -L https://raw.githubusercontent.com/pyenv/pyenv-installer/master/bin/pyenv-installer | bash

    # Load pyenv automatically by appendind to .zshrc
    msg "\n${PURPLE}Adding 'pyenv' to the load path."
    echo -e "# ======= pyenv load path config =======
export PYENV_ROOT=\"\$HOME/.pyenv\"
export PATH=\"\$PYENV_ROOT/bin:\$PATH\"
if command -v pyenv 1>/dev/null 2>&1; then
eval \"\$(pyenv init --path)\"
fi
eval \"\$(pyenv virtualenv-init -)\"" >> /home/"${user}"/.zshrc

    msg "${PURPLE}****************************************************\n"
}

enable_virtual_enviroment_on_bash(){
    # if powerlevel10k is present, enable virtualenv version on bash
    if [ ! -f ~/.p10k.zsh ];
    then
        die "${RED} Install oh-my-zsh and powerlevel10k theme first (./playbook-kali.sh --omz --pl10k --zsh-user <username>)"
    fi

    if grep -q "ZSH_THEME=\"powerlevel10k\/powerlevel10k\"" /home/"${user}"/.p10k.zsh;
    then
        sed -i 's/typeset -g POWERLEVEL9K_VIRTUALENV_SHOW_WITH_PYENV=false/typeset -g POWERLEVEL9K_VIRTUALENV_SHOW_WITH_PYENV=true/' /home/"${user}"/.p10k.zsh
    fi
}

install_docker(){
    msg "\n${ORANGE}******** Installing docker ******"
    # # Run the following command to uninstall all conflicting packages:
    # for pkg in docker.io docker-doc docker-compose podman-docker containerd runc; do sudo apt-get remove $pkg; done

    # # docker-ce can be installed from Docker repository. One thing to bear in mind, Kali Linux is based on Debian, so we need to use Debian’s current stable version (even though Kali Linux is a rolling distribution). At the time of writing (Oct. 2023), its "bookworm" (https://www.debian.org/releases/stable/index.en.html)

    # #     ** Attenzione alla versione di debian **
    # printf '%s\n' "deb https://download.docker.com/linux/debian bookworm stable" | sudo tee /etc/apt/sources.list.d/docker-ce.list
    # curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/trusted.gpg.d/docker-ce-archive-keyring.gpg
    # sudo apt update
    # sudo apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

    # # add yourself to the docker group to use docker without sudo:
    # sudo usermod -aG docker $USER
    msg "${ORANGE}****************************************************\n"
}

install_golang(){ 
    msg "\n${YELLOW}******** Installing golang ******"
    # Remove any previous Go installation by deleting the /usr/local/go folder (if it exists), then extract the archive you just downloaded into /usr/local, creating a fresh Go tree in /usr/local/go:
        # $ rm -rf /usr/local/go && tar -C /usr/local -xzf go1.21.3.linux-amd64.tar.gz

    # (You may need to run the command as root or through sudo).
    #  Do not untar the archive into an existing /usr/local/go tree. This is known to produce broken Go installations.

    # Add /usr/local/go/bin to the PATH environment variable.
    # You can do this by adding the following line to your $HOME/.profile or /etc/profile (for a system-wide installation):

    # export PATH=$PATH:/usr/local/go/bin

    # Note: Changes made to a profile file may not apply until the next time you log into your computer. To apply the changes immediately, just run the shell commands directly or execute them from the profile using a command such as source $HOME/.profile.

    # Verify that you've installed Go by opening a command prompt and typing the following command:
    # $ go version

    # Confirm that the command prints the installed version of Go.
    msg "${YELLOW}****************************************************\n"
}

# start script
setup_colors
parse_params "$@"

# fail if all and the other flags are set
if [ $all -eq 1 ] && { [ $vscode -eq 1 ] || [ $zsh -eq 1 ] || [ $pl10k -eq 1 ] || [ $pyenv -eq 1 ] || [ $docker -eq 1 ] || [ $golang -eq 1 ]; };
then
    msg "${RED}It is not possible to proceed. Specify to install all OR specifics components (1)"
    usage
fi

# fail if all and the other flags are not set
if [ $all -eq 0 ] && { [ $vscode -eq 0 ] && [ $zsh -eq 0 ] && [ $pl10k -eq 0 ] && [ $pyenv -eq 0 ] && [ $docker -eq 0 ] && [ $golang -eq 0 ]; };
then
    msg "${RED}It is not possible to proceed. Specify to install all OR specifics components (2)"
    usage
fi

# check if the all flag is set
if [ $all -eq 1 ]  &&  { [ -z "$stable_debian_version" ] || [ -z "$user" ]; } ;
then
    msg "${RED}It is not possible to proceed. Specify
    - stable debian version used in this moment (eg: bookworm)
    - the user to enable zsh (eg: kali)"
    usage
elif [ $all -eq 1 ] &&  { [ ! -z "$stable_debian_version" ] || [ ! -z "$user" ]; } ;
then
    install_all
    cleanup
fi

# === vscode ====
if [ $vscode -eq 1 ];
then
    install_vscode
fi

# === zsh, oh-my-zsh, powerlevel10k  ===
if [ $zsh -eq 1 ] && [ -z "$user" ] ;
then
    msg "${RED}It is not possible to proceed. Specify the user to enable zsh (eg: kali)"
    usage
elif [ $zsh -eq 1 ] &&  [ ! -z "$user" ] ;
then
    install_zsh_omz
fi

if [ $pl10k -eq 1 ] && [ -z "$user" ] ;
then
    msg "${RED}It is not possible to proceed. Specify the user to install powerlevel10k template (eg: kali)"
    usage
elif [ $pl10k -eq 1 ] &&  [ ! -z "$user" ] ;
then
    install_pl10k
fi

# === pyenv ===
if [ $pyenv -eq 1 ] && [ -z "$user" ] ;
then
    msg "${RED}It is not possible to proceed. Specify the user to enable pyenv automatically in the user terminal (eg: kali)"
    usage
elif [ $pyenv -eq 1 ] &&  [ ! -z "$user" ] ;
then
    install_pyenv
fi

# if [ $docker -eq 1 ];
# then
#     install_docker
# fi

# if [ $golang -eq 1 ];
# then
#     install_golang
# fi

cleanup