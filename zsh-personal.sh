#!/usr/bin/env zsh

if [[ -e ~/.rgrc ]]; then export RIPGREP_CONFIG_PATH=~/.rgrc
else echo "RIPGREP NOT INSTALLED"; fi


if [[ ! -z $(bpytop -v) ]]; then alias tp='bpytop'
else echo "BPYTOP NOT INSTALLED"; fi

if [[ $PS1 == '%n@%m %1~ %# ' ]]
then
    echo "PS1 has been reset to the out-of-the-box
          value. This likely means you've entered tmux
          and ~/.zshrc.d/005-oh-my-zsh.sh didn't run correctly.
          This can happen after building c3-server (running make or
           ./v8 setup.

           You can reset this by commenting out line 8 of 005-oh-my-zsh.sh:
           [ -z "$ZSH" ] || return 1
           so that we don't enter a early return statement when tmux
           is launched"
fi

# pyenv setup
eval "$(pyenv init -)"

# C3 Specific Configuration
if [[ $(whoami) == "jack" ]]
then
    # root folders
    alias c3root='cd ~/c3'
    alias provroot='c3root && cd provisionLocation'
    alias provroot2='c3root && cd provisionLocation2'
    eval "$(direnv hook zsh)"

    alias clang++='clang++ -std=c++17'
    
    function dockerbash() {
        docker exec -it c3server$1 /bin/bash
        return 0
    }

    function docker-c3-pull-server() {
        V=$1
        echo "Executing"
        echo -e "\tdocker pull ci-artifacts.c3.ai/c3server-noplugins:7.$V.0-stable"
        docker pull ci-artifacts.c3.ai/c3server-noplugins:7.$V.0-stable
    }

    function c3cli() {
        docker run \
               --publish 127.0.0.1:50081:50081/tcp \
               --interactive \
               --tty \
               --rm \
               --entrypoint /bin/bash \
               --name c3-cli \
               --volume ~/c3/ui-workdir/c3repo \
               --workdir /c3repo \
               locked-registry.c3.ai/c3:latest
    }
    

    # Configure python virtualenvwrapper
    # export WORKON_HOME=$HOME/.virtualenvs
    # export VIRTUALENVWRAPPER_PYTHON=/usr/bin/python3
    # export VIRTUALENVWRAPPER_VIRTUALENV
    # source /usr/local/bin/virtualenvwrapper.sh
    
    
    # JAVA configuration per:
    # https://c3energy.atlassian.net/wiki/DOC/pages/1043628424/Installing+c3server+on+your+Mac+using+your+GitHub+clone
    # export JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk1.8.0_281.jdk/Contents/Home
    # NOTE: configuration of JAVA_HOME has been moved to ~/.bash_profile

    function docker-c3-search() {
        function printHelp {
            echo -e "An example of this command is:\n" \
                  "$ docker-c3-search 7.33.\n" \
                  "------------------------------------------------\n" \
                  "NAME                               DESCRIPTION     STARS           OFFICIAL   AUTOMATED\n" \
                  "c3server-noplugins:7.33.0-stable   size = 3.6 GB   1657733116260\n" \
                  "c3server-noplugins:7.33.0-latest   size = 3.6 GB   1657733072184\n" \
                  "c3server-noplugins:7.33.0.372      size = 3.6 GB   1657733069594\n"
            }
        
        if [ -z $1 ]
        then
            echo "You did not enter a c3server version to search
                  An example of this command is:"
            printHelp
            echo "See docker-c3-search --help for more info"
            
            return 0
        elif [[ $1 == "--help" || $1 == "-h" ]]
        then
            echo -e "Usage\tdocker-c3-search VERSION"
            printHelp
            return 0
        fi
        docker search ci-artifacts.c3.ai/c3server-noplugins:$1
    }
fi

# utility command
alias lsa='ls -AlhG'
alias lsd='ls -AlhG -d */'
alias zshconfig='emacs ~/.zshrc.d/zsh-personal.sh -nw'
alias bashconfig='emacs ~/.bashrc.d/bash-personal.sh -nw'

# python configuration
alias python='python3'

# Git shortcuts
alias gdiff-last='git diff --name-only HEAD~1 HEAD'
alias gstat='git status'
alias gdiff='git diff'
alias gbra='git branch -vv'
alias gcheck='git checkout'
alias gfet='git fetch'
alias glog='git log --oneline --graph'
alias gloga='git log --branches --oneline --graph'
alias gadd='git add'
alias gcom='git commit'
alias gstash='git stash'
alias gfet='git fetch'
alias gpush='git push'
alias gpull='git pull'
# alias c3ui='c3 ui -W ~/c3/ui-workdir/ -a ~/c3/provisionLocation/base -e http://so:8080 -c sourcingOptimization -u BA:BA -t so:dev'
# npm start -- -W ~/c3/ui-workdir/ -a ~/c3/provisionLocation/sourcing-optimization -e http://bhso:8080 -c bhSourcingOptimization -u BA:BA -t bsho:dev
# alias c3ui='c3 ui -W ~/c3/ui-workdir/ -e http://shell:8080 -u BA:BA -c shellGhg -a ~/c3/provisionLocation/ -t shell:dev'
# c3 ui -W ~/c3/ui-workdir/ -e http://uidemo:8080 -c uiDemo -u BA:BA -t uidemo:dev --log-dir ~/c3/ui-logs -a ~/c3/provisionLocation
alias c3ui='c3 ui -W ~/c3/ui-workdir/ -e http://smc:8080 -u BA:BA -c smcIntelligenceAnalysis -a ~/c3/provisionLocation -t smc:dev --log-dir ~/c3/ui-logdir/'

# Starting c3 CLI in docker:
# alias c3cli=
# docker run \
# --publish 127.0.0.1:50082:50081/tcp \
# --interactive \
# --tty \
# --rm \
# --entrypoint /bin/bash \
# --name c3-cli \
# --volume ~/ui-working-dir:/ui-work-dir \
# --workdir /ui-work-dir \
# --volume ~/c3/provisionLocation/demo733:/provisionLocation/demo733 --volume ~/c3/provisionLocation/c3smc:/provisionLocation/c3smc \
# --network host \
# locked-registry.c3.ai/c3:latest



function gcv() {
    git tag -l "7.$1*" | sort -V -r | head -n 1 | xargs git checkout
}

alias pip='/usr/local/bin/pip3'
alias tp='bpytop'

alias psa='ps -a -l'

alias gr='grep --color -nHR -I'
alias ff='find . -type f -iname'

function go() {
    case $1 in
        ctb)
            cd /Users/jack/c3/gp-df-container-board
            ;;
	      fis)
	          cd ~/c3/c3fis
	          ;;
	      base)
	          cd ~/c3/c3base
	          ;;
	      server)
	          cd ~/c3/c3server/platform/repo
	          ;;
	      notes)
	          cd ~/Documents/notes
	          ;;
	      aml)
		        cd ~/c3/c3fis/c3fis/c3FisAml
		        ;;
	      cda)
		        cd ~/c3/c3fis/c3fis/c3FisCda
		        ;;
	      c3)
		        cd ~/c3
		        ;;
        tree)
            cd ~/c3/gitTrees_fis
            ;;
        prov)
            cd ~/c3/provisionLocation
            ;;
        prov2)
            cd ~/c3/provisionLocation2
            ;;
        hack)
            cd ~/c3/c3open/open/packageDependecyVisualizer
            ;;
        v8)
            cd ~/c3/c3server-v8
            ;;
        v7)
            cd ~/c3/c3server-v7
            ;;
        open)
            cd ~/c3/c3open
            ;;
        shell|ghg)
            cd ~/c3/c3trial/trial-shell
            ;;
        trial)
            cd ~/c3/c3trial/
            ;;
        ui)
            cd ~/c3/c3ui/
            ;;
        security)
            cd ~/Documents/notes/UIUC/Security
            ;;
        dl4hc)
            cd ~/Documents/notes/UIUC/DL4HC
            ;;
        smc|dc)
            cd ~/c3/c3smc/c3smc
            ;;
        demo)
            cd ~/c3/c3demo
            ;;
        fed)
            cd ~/c3/c3fed
            ;;
        nlp)
            cd ~/Documents/notes/UIUC/NLP
            ;;
        gp)
            cd ~/Documents/notes/DemandForcasting/Koch
            ;;
        ccm)
            cd ~/Documents/notes/DemandForcasting/Carlisle
            ;;
        ccm-df)
            cd /Users/jack/c3/c3carlisle/c3carlisle
            ;;
        sc)
            cd /Users/jack/c3/c3supplychain
            ;;
        tsc)
            cd /Users/jack/c3/c3tractorsupply
            ;;
        *)
            echo Unmapped directory entered: $1
            ;;
    esac
}


function prov() {
    currentDir=$(pwd)
    provisionLocation=~/c3/provisionLocation
    package=$1
    packageName=
    tenantName=
    case $package in
        aml)
            packageName="c3FisAml"
            tenantName="fisAml"
            ;;
        cda)
            packageName="c3FisCda"
            tenantName="fisCda"
            ;;
        uidemo)
            packageName="uiDemo"
            tenantName="uidemo"
            ;;
        hack)
            packageName="packageDependecyVisualizer"
            tenantName="hackathon"
            ;;
        so)
            packageName="sourcingOptimization"
            tenantName="so"
            ;;
        bhso)
            packageName="bhSourcingOptimization"
            tenantName="bhso"
            ;;
        shell|ghg)
            packageName="shellGhg"
            tenantName="shell"
            ;;
        smc)
            packageName="smcIntelligenceAnalysis"
            tenantName="smc"
            ;;
        repro)
            packageName="ReproPackage"
            tenantName="repro"
            ;;
        
        *)
            echo "Error in package name '$package' not recognized"
            echo "exiting"
            cd $currentDir
            return 1
            ;;
    esac

    shift

    testFlag=
    resetFlag=
    url="http://localhost:8080"
    while [[ $# -gt 0 ]]; do
        key="$1"
        case $key in
            -t|--test)
                echo "- running with tests"
                testFlag=-E
                shift
                ;;
            -g|--gittree)
                echo "- running from git trees location"
                provisionLocation=~/c3/provisionLocation2
                shift
                ;;
            -r|--reset)
                echo "- running with reset flag"
                resetFlag=-r
                shift
                ;;
            -p|--port)
                echo "- provisioning to local port 8081"
                url="http://localhost:8081"
                shift
                ;;
            *)
                echo "Unrecognized flag '$key' - returning with error code 1"
                cd $currentDir
                return 1
                ;;
        esac
    done
    cd $provisionLocation
    echo "###########################################################################"
    echo "# Provisioning from:                                                      #"
    echo -e "# \t$provisionLocation"
    echo -e "# Provision command:                                                      #"
    echo -e "# \tc3 prov tag -t $tenantName:dev -c $packageName -u BA:BA -e $url $testFlag $resetFlag"
    echo "###########################################################################"
    c3 prov tag -t $tenantName:dev -c $packageName -u BA:BA -e $url $testFlag $resetFlag
    tput bel
    cd $currentDir
    return $?
}

function docker-server-restart() {
    serverName="7.20.0-stable"
    echo "Which server version would you like to restart? (7.20/7.23) Default is '7.20'"
    local serverVersionLong
    local prefix
    read serverVersion
    if [[ $serverVersion == "7.20" ]];
    then
        echo "Starting container with server 7.20"
        serverVersionLong="7.20.0-stable"
        prefix="20"
    elif [[ $serverVersion == "7.23" ]];
    then
        serverVersionLong="7.23.0-stable"
        prefix="23"
        echo "Starting container with server 7.23"
    elif [[ $serverVersion == "7.28" ]];
    then
        serverVersionLong="7.28.0-stable"
        prefix="28"
        echo "Starting container with server 7.28"
    elif [[ $serverVersion == "" ]];
    then
        echo "No server version specified... defaulting to 7.20"
        prefix="20"
        serverVersionLong="7.20.0-stable"
    elif [[ $serverVersion == "7.27" ]];
    then
        serverVersionLong="7.27.0-stable"
        prefix="27"
        echo "Starting container with server 7.27"
    else
        echo "Unable to start with server version $serverVersionLong"
        echo "Please download with the command 'docker pull ci-artifacts.c3.ai/c3server-noplugins:7.XX.0-stable'"
        return 1
    fi
    echo "serverVersion = $serverVersionLong"
    dockerImageNumber=$(docker image ls | grep $serverVersionLong | cut -d ' ' -f 7)
    echo "docker image = $dockerImageNumber"
    export C3_SERVER_VERSION=$serverVersionLong
    export C3_SERVER_CONTAINER_NAME=c3server$prefix
    export VM_MIN_MEM=15G
    export VM_MAX_MEM=25G
    export VM_NEW_RATIO=2
    echo "###########################################################################"
    echo "# Running docker like"
    echo "# docker run -d --name $C3_SERVER_CONTAINER_NAME"
    echo -e "#\t--env VM_MIN_MEM " 
    echo -e  "#\t--env VM_MAX_MEM " 
    echo -e "#\t--env VM_NEW_RATIO "
    echo -e "#\t-it -p 8080:8080 " 
    echo -e "#\t$dockerImageNumber"
    echo "###########################################################################"
    docker run -d --name $C3_SERVER_CONTAINER_NAME \
           --env VM_MIN_MEM \
           --env VM_MAX_MEM \ 
           --env VM_NEW_RATIO \
           -it -p 8080:8080 \
           $dockerImageNumber
}

function c3server() {
    if [ -z $1 ]
    then
        echo "You did not enter a c3server version to launch"
        echo "See c3server --help for more info"
        return 0
    elif [ $1 = "--help" ]
    then
        echo "Usage:  c3server VERSION [COMMAND]\n"
        echo -e "Commands:\n start\tStart the docker container titled c3server<VERSION>"
        echo -e " stop\tStop the docker container titled c3server<VERSION>"
        return 0
    fi

    docker_search_string=$(docker container ls -a | grep "c3server$1\>")
    if [[ -z $docker_search_string ]]
    then
        echo "The server version you entered is not installed locally"
        echo "Please pull server version and try again"
        return 0
    fi

    
    C3SERVERDOCKERCONTAINER="c3server$1"

    if [ -z $2 ] || [ $2 = start ]
    then
        echo "Launching $C3SERVERDOCKERCONTAINER"
        docker container start $C3SERVERDOCKERCONTAINER    
    elif [ $2 = stop ]
    then
         echo "Stopping $C3SERVERDOCKERCONTAINER"
         docker container stop $C3SERVERDOCKERCONTAINER
    else
        echo -e "Invalid command '$2'\nDid you mean 'start'\'stop'?"
    fi
}

function dockerNewServer(){

    serverName=
    portNumber=8080
    imageId=
    while [[ $# -gt 0 ]]; do
        case $1 in
            -h|--help)
                echo "dockerNewServer [-i <image_id>] [-n <container_name>] [-p [8080/8081]]"
                return 0
                ;;
            -p)
                portNumber=$2
                shift
                shift
                ;;
            -n)
                serverName=$2
                shift
                shift
                ;;
            -i)
                imageId=$2
                shift
                shift
                ;;
            *)
                echo "Unrecognized flag $1"
                return 0
                ;;
        esac
    done

    export VM_MIN_MEM=15G
    export VM_MAX_MEM=25G
    export VM_NEW_RATIO=2
    echo "###########################################################################"
    echo "# Running docker like"
    echo "# docker run -d --name $serverName"
    echo "#\t--env VM_MIN_MEM " 
    echo "#\t--env VM_MAX_MEM " 
    echo "#\t--env VM_NEW_RATIO "
    echo "#\t-it -p $portNumber:8080 " 
    echo "#\t$imageId"
    echo "###########################################################################"

    docker run -d --name $serverName \
           --env VM_MIN_MEM \
           --env VM_MAX_MEM \
           --env VM_NEW_RATIO \
           -it -p $portNumber:8080 \
           $imageId
}

function piconnect() {
    ssh -Y pi@192.168.1.93
}


function swaptrees() {
    go cda
    CHANGES1=$(git diff --name-only)
    BRANCH1=$(git branch --show-current)
    if [ ! -z $CHANGES1 ]
    then
        echo "Unstaged changes in ~/c3/c3fis/"
        return 0
    fi
    go tree
    CHANGES1=$(git diff --name-only)
    BRANCH2=$(git branch --show-current)
    if [ ! -z $CHANGES1 ]
    then
        echo "Unstaged changes in ~/c3/gitTrees_fis/"
        return 0
    fi

    TMPBRANCH=$(git branch | grep -v $BRANCH1 | grep -m1 -v $BRANCH2)
    TMPBRANCH=${TMPBRANCH%%()}
    TMPBRANCH=${TMPBRANCH##()}
    if [ ! -z $TMPBRANCH ]
    then
        echo "No temporary branch available = $TMPBRANCH"
        return 0
    fi

    git checkout $TMPBRANCH
    go cda
    git checkout $BRANCH2
    go tree
    git checkout $BRANCH1
}


function resource(){
    source ~/.zshrc
}

function glint(){
    curDir=$(pwd)
    rootDir=$(git rev-parse --show-toplevel)
    branch="HEAD"
    if [ -z $1 ]
    then
        branch=$1
    fi
    cd $rootDir
    filesToLint=$(git diff --name-only $branch)
    if [ -z filesToLint ]
    then
        echo "No files to lint"
        cd $curDir
        return 0
    fi

    echo "Linting files..."
    while read n;
    do
        echo "linting $n...."
        npx eslint --fix $n
    done <<< $filesToLint
    cd $curDir
}


# url='https://gpnonprod.kochanalytics.cloud/dfctbdev/ctbdemandforecasting/file/'
# baseUrl='s3://572524204836--gpnonprod/dfctbdev/ctbdemandforecasting/dl/Canonical'
# while read canonicalFile;
# do
#     echo "Curling up $canonicalFile"
#     echo ""
#     
#     canonical=$(echo $canonicalFile | cut -d "." -f 1)
#     echo "Canonical name = $canonical"
#     targetlocation="$url/$baseUrl/$canonical/$canonicalFile"
#     echo "Target Location = $targetlocation"
#     curl -v -H "Content-Type: text/csv" -H -X PUT --data-binary  \
#          @./$canonicalFile \
#          "$targetlocation" \
#          -H 'Authorization: $authtoken'
# done <<< $canonicals
