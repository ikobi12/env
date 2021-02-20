# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# ssh
#eval ssh-agent $SHELL
#ssh-add ~/.ssh/gitlab_ivan
#ssh-add ~/.ssh/github

# theme
ZSH_THEME="spaceship"
SPACESHIP_BATTERY_SHOW=false

# plugins
plugins=(git zsh-autosuggestions)

source $ZSH/oh-my-zsh.sh

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='vim'
# fi

# Aliases
# For a full list of active aliases, run `alias`.

# nvim
alias v="nvim"
alias vv="v ."
alias vcfg="v ~/.config/nvim/init.vim"
function update_nvim () {
    cd ~
    sudo rm -r neovim
    git clone https://github.com/neovim/neovim
    cd neovim
    sudo make CMAKE_BUILD_TYPE=Release install
    cd ~
    sudo rm -r neovim
}

# Utility aliases
function sync_env () {
    echo "Copying nvim config"
    cp ~/.config/nvim/init.vim ~/env/nvim/
    echo "Copying zsh config"
    cp ~/.zshrc ~/env/zsh/
    cd ~/env && gaa && gcm "sync_env `uname`" && gp && cd -
}
alias zshconfig="v ~/.zshrc"
function mkcd () {
    if [ $# -lt 1 ]
    then
        echo "Directory name not specified!"
    else
        mkdir $1 && cd $1
    fi
}
# wsl specific
alias sync_time="sudo ntpdate pool.ntp.org"
alias e="explorer.exe ."
# docker
alias dob="docker build"
alias dor="docker run"
alias dcb="docker-compose build"
alias dcu="docker-compose up"
# git
alias gcm="git commit -m"
alias gc="git checkout"
alias gcma="git checkout master"
alias gcd="git checkout development"

# Python 
export PIP_REQUIRE_VIRTUALENV=true
alias senv="source venv/bin/activate"
alias jenv="senv && jupyter lab"
alias denv="deactivate"
alias dcd="cd .. && denv"
function sv () {
    if [ $# -lt 1 ]
    then
        senv && v .
    else
        senv && v $1
    fi
}
function mkenv_empty { 
    python3 -m venv venv 
    source venv/bin/activate
    pip install -U pip 
    pip install wheel 
    pip install python-language-server flake8 mypy  # lang. server for autocomplete, linters for ALE
}
function mkenv () {
    echo "Creating virtual environment..."
    if [ $# -lt 1 ]
    then
        mkenv_empty
    elif [ $1 = "r" ]
    then
        mkenv_empty
        requirements=`ls | grep "requirements.txt"`
        if [ -z "$requirements" ]; then
            echo "No requirements found. Environment empty."
        else
            ls | grep "requirements.txt" | xargs -n1 pip install -r
        fi
    else
        echo "Packages specified: $@"
        mkenv_empty
        for package in "$@"
        do
            pip install $package
        done
    fi
}

# work related 
alias pycharm="sh /usr/local/bin/pycharm-community-2020.2.3/bin/pycharm.sh"
alias cdw="cd ~/work"
function pull_project () {
    project=$1
    git clone git@gitlab.rgnservices.com:grp-data-engineering/$project.git
    cd $project
    mkenv r
}
function getgiphy () {
    if [ $# -lt 2 ]
    then
        echo "What am I supposed to download? Give me a link and the name under which to save it, dumbass!"
    else
        curl $1 --output /mnt/c/Users/ib01152/Desktop/memes/$2.gif
    fi
}


# XServer for WSL
export DISPLAY=$(cat /etc/resolv.conf | grep nameserver | awk '{print $2}'):0
export LIBGL_ALWAYS_INDIRECT=1

