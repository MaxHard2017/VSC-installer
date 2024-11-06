#!/bin/bash
clear
# ===== Global =====
# Destination folders for installation

# app home folsers
INSTALLDIR="$HOME/Coding"   # /path/to/installation/directory/ for all programms
VSCHOME="VSC"
MINGWHOME="MinGWx86_64-8.1.0"
PYTHONHOME="Python"
JDKHOME="Java"       # jdk-22
MAVENHOME="Java"
GITHOME="PortableGit"
LOG4JHOME=""

# Source folsers
SRC_DOTNET="dotNet"
SRC_C="MinGW_GCC"
SRC_PYTHON="Python"
SRC_VSC="VSC"
SRC_GIT="Git"
SRC_7ZIP="7z"
SRC_DOCS="Docs"
SRC_JDK="Jdk" # jdk-22
SRC_MAVEN="Maven"
# fille with anonimous (instead of personal) git e-mail for using in commits
SRC_GITMAIL="gitmail.txt"

TEMP_PATH=""
DEV_PATH_WIN=""         # collects PATH variable for executables while installing in windows format
DEV_PATH_LNX=""         # collects PATH variable for executables while installing in linux format
ENVIRONMENT_VARS_WIN=""        # collacts string for environment variables needed in windows format
ENVIRONMENT_VARS_LNX=""        # collacts string for environment variables needed in linux format

# ========== Annatation ==========
echo "------------------------------------------------------------------------------"
echo "  Portable installation enables all data created and maintained by VS Code "
echo "  to live near itself, so it can be moved around across environments, for"
echo "  example, on a USB drive."
echo "------------------------------------------------------------------------------"
echo ""
echo "  Content: "
echo ""
echo -e "  - \e[32mVisual Studio Code Win x86 64 bit\e[0m - source:"
echo "       https://code.visualstudio.com/download#"
echo -e "    Visual Studio Code site: \e[37;1mhttps://code.visualstudio.com/\e[0m"
echo "" 
echo -e "  - \e[32mMinGW_GCC x86 64 bit v 8.1.0\e[0m - sourse: https://sourceforge.net/projects"
echo "       /mingw-w64/files/Toolchains%20targetting%20Win64/Personal%20Builds"
echo "       /mingw-builds/8.1.0/threads-win32/seh"
echo "       /x86_64-8.1.0-release-win32-seh-rt_v6-rev0.7z/download "
echo -e "    MinGW site: \e[37;1mhttp://mingw-w64.org/doku.php\e[0m"
echo "" 
echo -e "  - \e[32mpython-3.12.4\e[0m - source:" 
echo "       https://www.python.org/ftp/python/3.12.4/python-3.12.4-embed-amd64.zip"
echo "    For additional information about using Python on Windows, see at"
echo -e "    Python.org \e[37;1mhttps://docs.python.org/3.9/using/windows.html\e[0m"
echo ""
echo -e "  - \e[32mPython3\e[0m Windows help file - source:" 
echo "       https://www.python.org/ftp/python/3.10.1/python3101.chm "
echo "------------------------------------------------------------------------------"
echo ""
read -p "  Enter to continue"


# Instalation variants
fullinstall() {
    echo ""
    echo "Full installation..."
    path_set
    git_install
    vsc_install
    dotnet_check
    jdk_install
    maven_install
    mingw_install
    python_install
    make_uninstall_bat
    set_variables_cmd
    toolchain_test
}
gitinstall() {
    echo ""
    echo "Git installation..."
    path_set
    git_install
}

custominstall() {
    echo "Custom install ..."
    echo "Under construction"
}

autoinstall() {
    echo "Autoinstall ..."
    echo "Under construction"
}

# ========== Functions section ==========
# Set installation location
path_set() {
    local name=" "
        
    while :
    do
        clear
        echo "------------------------------------------------------------------------------"
        echo "  Tools installation path/:"
        echo -e "  \e[32m$INSTALLDIR\e[0m"
        echo "" 
        read -p "  Set new path it or press [Enter] to continue: " name

        if [ -z "$name" ]; then
            break
        else
            INSTALLDIR=$name
        fi
    done
}

# Visual Studio Code installation
vsc_install() {
    echo ""
    echo "------------------------------------------------------------------------------"
    echo -e "Installing VSC to $INSTALLDIR/$VSCHOME..."
    mkdir -p $INSTALLDIR/$VSCHOME/data/user-data
    mkdir -p $INSTALLDIR/$VSCHOME/data/extensions
    mkdir -p $INSTALLDIR/$VSCHOME/data/tmp
    $SRC_7ZIP/7za.exe x $SRC_VSC/*.zip -o"$INSTALLDIR/$VSCHOME"
    DEV_PATH_WIN="$DEV_PATH_WIN%~dp0..\..\\$VSCHOME\bin;"
    DEV_PATH_LNX="$DEV_PATH_LNX./../../$VSCHOME/bin:"
    material_icon_extension
    # Set up user settings
    cat  "$SRC_VSC/_user_settings.json" >> "$INSTALLDIR/$VSCHOME/data/user-data/User/settings.json"
}

# Checking installed version of dotNET Framework
dotnet_check() {
    echo ""
    echo "------------------------------------------------------------------------------"
    echo -e "  DotNET Framework \e[33m4.5.2 or higher\e[0m is required for VSC.  Check your"
    echo -e "  DotNET Framework version under \e[33;1mVersion  REG_SZ\e[0m key:"
    reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\NET Framework Setup\NDP\v4\full"
    echo ""

    local choise1=""
    while :
    do
        echo -e "  Do you want to \e[32minstall .Net 4.8\e[0m?"
        read -p "  (y) - install, (n) - do not install: " -n 1 -t 20 choise1
        case "$choise1" in
            y)
                dotnet_install           
                break
                ;;
            n)
                echo "  .Net 4.8 is not installed"
                break
                ;;                      
            *)
                echo -e "\n\e[33m  Invalid choice.\e[0m Please try again."
                ;;
        esac
    done
}
 
# Installing dotNET Framework 4.8 for Win
dotnet_install () {
    echo ""
    echo "------------------------------------------------------------------------------"
    echo "  .Net installing...."
    "$SRC_DOTNET/ndp48-x86-x64-allos-enu.exe"
    echo ""
    echo -e "  Run \e[32minstall.ssh\e[0m intsallation sctipt on behalf of admin "
    echo -e "  in case of \e[33m\"Permission denied\"\e[0m error"
    read -p "  Press Enter to continue..."
}

# MinGW installation
mingw_install() {
    echo ""
    echo "------------------------------------------------------------------------------"
    echo "Installing MinGW to directory: $INSTALLDIR/$MINGWHOME..."
    mkdir -p $INSTALLDIR/$MINGWHOME
    $SRC_7ZIP/7za.exe x $SRC_C/* -o"$INSTALLDIR/$MINGWHOME"
    DEV_PATH_WIN="$DEV_PATH_WIN%~dp0..\..\\$MINGWHOME\mingw64\bin;"
    DEV_PATH_LNX="$DEV_PATH_LNX./../../$MINGWHOME/mingw64/bin:"
    c_extension
}

# Python installation
python_install() {
    echo ""
    echo "------------------------------------------------------------------------------"
    echo "Installing Python to directory: $INSTALLDIR/$PYTHONHOME..."
    $SRC_7ZIP/7za.exe x $SRC_PYTHON/* -o"$INSTALLDIR/$PYTHONHOME"
    echo ""
    echo "Installing documentation to $INSTALLDIR/$PYTHONHOME/docs..."
    mkdir -p $INSTALLDIR/$PYTHONHOME/docs
    cp $SRC_DOCS/Python/* $INSTALLDIR/$PYTHONHOME/docs
    DEV_PATH_WIN="$DEV_PATH_WIN%~dp0..\..\\$PYTHONHOME;"
    DEV_PATH_LNX="$DEV_PATH_LNX./../../$PYTHONHOME:"
    py_extension
}

# JDK installation
jdk_install() {
    echo ""
    echo "------------------------------------------------------------------------------"
    echo "Installing JDK to directory: $INSTALLDIR/$JDKHOME..."
    $SRC_7ZIP/7za.exe x $SRC_JDK/* -o"$INSTALLDIR/$JDKHOME"

    ENVIRONMENT_VARS_WIN+="set JAVA_HOME=%~dp0..\..\\$JDKHOME\jdk-22"
    ENVIRONMENT_VARS_WIN+=$'\n'

    ENVIRONMENT_VARS_LNX+="JAVA_HOME=./../../$JDKHOME/jdk-22"
    ENVIRONMENT_VARS_LNX+=$'\n'

    DEV_PATH_WIN+="%JAVA_HOME%\bin;"
    DEV_PATH_LNX+="./../../$JDKHOME/jdk-22/bin:"
}

# Appache Maven installation
maven_install() {
    echo ""
    echo "------------------------------------------------------------------------------"
    echo "Installing Appache Maven to directory: $INSTALLDIR/$MAVENHOME..."
    $SRC_7ZIP/7za.exe x $SRC_MAVEN/*.zip -o"$INSTALLDIR/$MAVENHOME"
    echo ""
    DEV_PATH_WIN+="%~dp0..\..\\$MAVENHOME\apache-maven-3.9.8\bin;"
    DEV_PATH_LNX+="./../../$MAVENHOME/apache-maven-3.9.8/bin:"
}

# git installation
git_install() {
    echo ""
    echo "------------------------------------------------------------------------------"
    echo -e "Installing \e[32m git\e[0m to directory: \e[37m$INSTALLDIR/$GITHOME...\e[0m"
    echo ""
    
    # check if git-bash already installed at target location
    if [ ! -d "$INSTALLDIR/$GITHOME" ]; then
	    mkdir -p $INSTALLDIR/$GITHOME
    fi

    # file list - "ls -A" command is an empty string
    if [ $(ls -A  $INSTALLDIR/$GITHOME | wc -l) -eq 0 ]; then
        $SRC_7ZIP/7za.exe x $SRC_GIT/*.exe -o"$INSTALLDIR/$GITHOME"
        # execute post-install.bat  script through git-bash for compleating
        $INSTALLDIR/$GITHOME/git-bash.exe --no-needs-console --hide --no-cd --command=post-install.bat
    fi
    
    local input_str=""
    echo ""
    echo "------------------------------------------------------------------------------"
    echo "  You can set new HOME environment tempory variable "
    echo "  (It would be for the current session only)"
    echo "  Git-bash will track it as it\`s new HOME \"~/\" for storing configuration files."
    echo ""

    local choise2=""s
    while :
    do
        echo -e "  git-bash HOME variable = \e[32m$HOME\e[0m"
	echo "  Do you want to change it?"
        read -p "  (y) - change, (n) - do not change, (i) - cahge to INSTALLDIR: " -n 1 -t 20 choise2
        case "$choise2" in
            y)
                echo ""
		        read -p "  Enter new HOME var: " input_str
                HOME=$input_str
                ;;
            n)
                echo ""
                break
                ;;
            i)
                HOME=$INSTALLDIR
                echo ""
            ;;
            
            *)
                echo -e "\n\e[33m  Invalid choice.\e[0m Please try again."
                ;;
        esac
    done

    ENVIRONMENT_VARS_WIN+="set GITDIR=%~dp0..\..\\$GITHOME"
    ENVIRONMENT_VARS_WIN+=$'\n'

    #ENVIRONMENT_VARS_WIN+="%GITDIR%\git-bash.exe --cd-to-home"
    #ENVIRONMENT_VARS_WIN+=$'\n'

    ENVIRONMENT_VARS_LNX+="GITDIR=./../../$GITHOME"
    ENVIRONMENT_VARS_LNX+=$'\n'

    DEV_PATH_WIN+="%GITDIR%\cmd;"
    DEV_PATH_LNX+="./../../$GITHOME/cmd:"
    
    echo "  Configuring git..."
    local user_name
    local user_email
    read -p "  Enter git user name: " user_name
    
    # read e-mail from file to user_email variable
    file=$SRC_GITMAIL
    if [ -e $file ]; then 
        read -r user_email < $file
    fi
        
    echo "  user e-mail will be: $user_email"

    "$INSTALLDIR/$GITHOME"/cmd/git config --global user.name $user_name
    "$INSTALLDIR/$GITHOME"/cmd/git config --global user.email $user_email

    local choise3=""


        while :
        do
        read -p "  Do you want to sep up SSH? y / n: " -n 1 -t 20 choise3
        case "$choise3" in
            y)
                #Setting ssh agent for git-bash
                echo ""               
                mkdir -p "$HOME/.ssh"
                ssh-keygen -t ed25519 -C $user_email -f "$HOME/.ssh/git_id_ed25519"

                echo ""               
                echo "launching ssh agent..."
                eval "$(ssh-agent -s)"

                echo "adding ssh key to agent..."
                ssh-add "$HOME/.ssh/git_id_ed25519"
                cat $SRC_GIT/._bashrc >> $HOME/.bashrc
                cat $SRC_GIT/._bash_profile >> $HOME/.bash_profile

                touch $HOME/gt.bat
                echo "set HOME=%cd%" > $HOME/gt.bat
                echo "start \"\" %cd%\%GITHOME%\git-bash.exe" >> $HOME/gt.bat # launch git with new HOME

                ##Setting ssh agent for windows - VSC
                #cd $INSTALLDIR/$GITHOME
                ## execute bat script through git-bash 
                #./git-bash.exe --no-needs-console --hide --no-cd --command="$HOME/ssh_agent_win.bat"
                #cd -

                ENVIRONMENT_VARS_WIN+="echo \"Starting ssh agent...\" "
                ENVIRONMENT_VARS_WIN+=$'\n'
                ENVIRONMENT_VARS_WIN+="net start ssh-agent"
                ENVIRONMENT_VARS_WIN+=$'\n'
                ENVIRONMENT_VARS_WIN+="ssh-add %cd%\.ssh\git_id_ed25519"

		        echo ""
                echo "  SSH setup complete"
                echo "  Add the SSH public key to your account on GitHub. For more information,"
                echo "  see: https://docs.github.com/en/authentication/connecting-to-github-with-ssh/adding-a-new-ssh-key-to-your-github-account"
                ;;
            n)
                break 
                ;;
            
            *)
                echo -e "\n\e[33m  Invalid choice.\e[0m Please try again."
                ;;
        esac
        done
}


# ========== Extensions for VSC ===========
# Material icons VSC extension installation

material_icon_extension () {
    echo ""
    echo "------------------------------------------------------------------------------"
    "$INSTALLDIR/$VSCHOME/bin/code" --install-extension pkief.material-icon-theme
}

# C/C++  VSC extension installation
c_extension() {
    echo ""
    echo "------------------------------------------------------------------------------"
    echo "Installing C/C++ ms-vscode.cpptools extension for VSC..."
    "$INSTALLDIR/$VSCHOME/bin/code" --install-extension ms-vscode.cpptools
}

# Python extension installation
py_extension() {
    echo ""
    echo "------------------------------------------------------------------------------"
    echo "Installing Python ms-python.python extension for VSC..."
    "$INSTALLDIR/$VSCHOME/bin/code" --install-extension ms-python.python
}

# Setting temporary PATH variable in  $INSTALLDIR$VSCHOME/bin/code.cmd
# for working in Visual Sorce Code with all installed
set_variables_cmd() {
    echo 
    if [ -f "$INSTALLDIR/$VSCHOME/bin/code.cmd" ]; then
        cp "$INSTALLDIR/$VSCHOME/bin/code.cmd" "$INSTALLDIR/$VSCHOME/bin/code.old_cmd"
    fi
    
    if [ -f "$INSTALLDIR/$VSCHOME/bin/code" ]; then
        cp "$INSTALLDIR/$VSCHOME/bin/code" "$INSTALLDIR/$VSCHOME/bin/code_old"
    fi

    echo '@ECHO OFF' > "$INSTALLDIR/$VSCHOME/bin/code.cmd"

    # INSTALLDIR:~2 - INSTALLDIR variable string without 2 first letters, i.e. without drive letters (C: - for instance)
    # It gives us the opportunity to set the correct drive letter in PATH variable, even if we will use installation on a USB drive with an assigned random drive letter
    # WRITE_PATH uses extra "%" for correct writing PATH to code.cmd - %~d0% but not its value (c: - for instance)
    # %~d0 shows the current drive letter where <code.cmd> is evoked

    # set path in cmd startup script
    echo "$ENVIRONMENT_VARS_WIN" >> "$INSTALLDIR/$VSCHOME/bin/code.cmd"

    echo "set PATH="$DEV_PATH_WIN"%PATH%" >> "$INSTALLDIR/$VSCHOME/bin/code.cmd"
    echo "@ECHO Current PATH: = %PATH%" >> "$INSTALLDIR/$VSCHOME/bin/code.cmd"
    cat "$INSTALLDIR/$VSCHOME/bin/code.old_cmd" >> "$INSTALLDIR/$VSCHOME/bin/code.cmd"
    
    # set path in sh startup script
    echo "PATH=$DEV_PATH_LNX:$PATH" >> "$INSTALLDIR/$VSCHOME/bin/code"


    # for control
    #echo "DEV_PATH_WIN -- $DEV_PATH_WIN"
    #echo "DEV_PATH_LNX -- $DEV_PATH_LNX"
    #echo ""
    #echo "PATH --- $PATH"
    #read -p "Press any key to continue..."
}

toolchain_test() {
    # Checking toolchain availability through the 'PATH' variable
    echo "------------------------------------------------------------------------------"
    
    cd "$INSTALLDIR/$VSCHOME/bin"
    echo -e "Current toolchain path: $DEV_PATH_LNX\n"
    JAVA_HOME="./../../$JDKHOME/jdk-22"
    PATH="$DEV_PATH_LNX:$PATH"

    #echo "PATH = $PATH"
    echo ""
    echo "------------------------------------------------------------------------------"
    echo "VSC test"
    code --version
    echo ""
    echo "gcc test"
    gcc --version
    echo ""
    echo "g++ test"
    g++ --version
    echo ""
    echo "gdb test"
    gdb --version
    echo ""
    echo "Python test"
    python --version
    echo ""
    echo "java test"
    java --version
    echo ""
    echo "maven test"
    mvn --version
    echo ""
    echo "git test"
    git --version
    read -p  "  Press any key"
    # returning to the working folder
    cd $OLDPWDd
}


# Making Uninstall.sh file
make_uninstall_bat() {
    touch $INSTALLDIR/uninstall.sh
    echo "#!/bin/bash" >> $INSTALLDIR/uninstall.sh
    echo "VSCHOME=$VSCHOME" >> $INSTALLDIR/uninstall.sh
    echo "MINGWHOME=$MINGWHOME" >> $INSTALLDIR/uninstall.sh
    echo "PYTHONHOME=$PYTHONHOME" >> $INSTALLDIR/uninstall.sh
    echo "JDKHOME=$JDKHOME" >> $INSTALLDIR/uninstall.sh
    echo "INSTALLDIR=$INSTALLDIR" >> $INSTALLDIR/uninstall.sh
    cat uninstall._sh >> $INSTALLDIR/uninstall.sh

    echo "******************************************************"
    echo "*            Uninstall script complete               *"
    echo "******************************************************"
    read -p "Press any key to continue..."

}


# --------- main 
clear
echo "  Choose install option:"
echo -e "   '\e[32mf\e[0m' - for a full installation with castomization,"
#echo "   'a' - for auto quick installation,"
echo -e "   '\e[32mg\e[0m' - for Git installation,"
echo -e "   '\e[32md\e[0m' - for .Net 4.8 installation only,"
echo -e "   '\e[32mq\e[0m' - for quit"
while :
do
read -p "  Enter choice: " -n 1 -t 20 choice
echo ""
    case "$choice" in
        a)
	        autoinstall
 	        exit 0
            ;;
        g)
            path_set
            git_install
 	        exit 0
            ;;
        f)
            fullinstall
 	        exit 0
            ;;
        d)
	        dotnet_check
 	        exit 0
            ;;
        q)
            echo "\n  Quitting instalation"
            exit 0
            ;;
        *)
                echo -e "  \e[33mInvalid choice.\e[0m Please try again."
            ;;
    esac
done
exit 0

# ======================
# Useful add-ons for VSC
# ======================
#
# Debug Visualizer - UId:hediet.debug-visualize
# Material Icon Theme - иконки UId:pkief.material-icon-theme
# http://code.visualstudio.com
# http://vscode.dev
# http://vscodium.com
# http://open-vsx.org
# http://emmet.io
# http://github.com/tonsky/FiraCode
# Community Material Theme
# Bracket-Pair-Colorizer & Bracket-Pair-Colorizer-2
# Better Comments
# Indent-rainbow
# Path Intellisense
# Live Server
# Prettier
# PHP Intelephense
# GitLens — Git supercharged
# ESLint
# Quokka.js
# Code Runner
# Duckly: Pair Programming with any IDE
# pair-programming-timer ???