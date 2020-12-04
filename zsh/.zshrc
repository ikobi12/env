# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="spaceship"
SPACESHIP_BATTERY_SHOW=false

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
# DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git zsh-autosuggestions)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='vim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.

# nvim
alias v="nvim.appimage"
alias vv="v ."
alias vcfg="v ~/.config/nvim/init.vim"

# Utility aliases
function sync_env () {
    echo "Copying nvim config"
    cp ~/.config/nvim/init.vim ~/env/nvim/
    echo "Copying zsh config"
    cp ~/.zshrc ~/env/zsh/
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
alias sync_time="sudo ntpdate pool.ntp.org"
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
alias denv="deactivate"
alias dcd="denv && cd .."
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

# randstad work related 
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

# Nix
if [ -e /home/ivan/.nix-profile/etc/profile.d/nix.sh ]; then . /home/ivan/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer

# XServer
export DISPLAY=$(cat /etc/resolv.conf | grep nameserver | awk '{print $2}'):0
export LIBGL_ALWAYS_INDIRECT=1

