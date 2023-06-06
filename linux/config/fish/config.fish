if status is-interactive
    # Commands to run in interactive sessions can go here

    # Exports
    export GIT_DISCOVERY_ACROSS_FILESYSTEM=1

    # Exporting pyenv
    export PYENV_ROOT="$HOME/.pyenv"
    command -v pyenv >/dev/null or export PATH="$PYENV_ROOT/bin:$PATH"

    # Exporting new paths
    export PATH="$PATH:$HOME/.config/awesome/scripts/"
    export PATH="$PATH:$HOME/.config/awesome/binaries/"
    export PATH="$PATH:$ANDROID_PLATFORM_TOOLS"
    export PATH="$PATH:$ANDROID_TOOLS"
    export PATH="$PATH:$HOME/.spicetify"
    export PATH="$PATH:$HOME/.platformio/penv/bin"

    # Import secrets, like an .env file
    fish "$HOME/.fish_credentials"
    fish "$HOME/.fish_env"

    # Functions
    function ricefetch
        clear
        for x in (seq 30)
            echo -e
        end
        neofetch --source $HOME/.config/neofetch/ascii
        # cpufetch --color 135,230,250:0,0,0:0,0,0:139,250,205:245,205,210
        for x in (seq 30)
            echo -e
        end
    end


    function readme --description "a preguiça me levou a isso"
        set --local readme_template '''
<!--
   ⢰⣧⣼⣯⠄⣸⣠⣶⣶⣦⣾⠄⠄⠄⠄⡀⠄⢀⣿⣿⠄⠄⠄⢸⡇⠄⠄
   ⣾⣿⠿⠿⠶⠿⢿⣿⣿⣿⣿⣦⣤⣄⢀⡅⢠⣾⣛⡉⠄⠄⠄⠸⢀⣿⠄
  ⢀⡋⣡⣴⣶⣶⡀⠄⠄⠙⢿⣿⣿⣿⣿⣿⣴⣿⣿⣿⢃⣤⣄⣀⣥⣿⣿⠄
  ⢸⣇⠻⣿⣿⣿⣧⣀⢀⣠⡌⢻⣿⣿⣿⣿⣿⣿⣿⣿⣿⠿⠿⠿⣿⣿⣿⠄
 ⢀⢸⣿⣷⣤⣤⣤⣬⣙⣛⢿⣿⣿⣿⣿⣿⣿⡿⣿⣿⡍⠄⠄⢀⣤⣄⠉⠋⣰
 ⣼⣖⣿⣿⣿⣿⣿⣿⣿⣿⣿⢿⣿⣿⣿⣿⣿⢇⣿⣿⡷⠶⠶⢿⣿⣿⠇⢀⣤
⠘⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣽⣿⣿⣿⡇⣿⣿⣿⣿⣿⣿⣷⣶⣥⣴⣿⡗
⢀⠈⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡟
⢸⣿⣦⣌⣛⣻⣿⣿⣧⠙⠛⠛⡭⠅⠒⠦⠭⣭⡻⣿⣿⣿⣿⣿⣿⣿⣿⡿⠃
⠘⣿⣿⣿⣿⣿⣿⣿⣿⡆⠄⠄⠄⠄⠄⠄⠄⠄⠹⠈⢋⣽⣿⣿⣿⣿⣵⣾⠃
 ⠘⣿⣿⣿⣿⣿⣿⣿⣿⠄⣴⣿⣶⣄⠄⣴⣶⠄⢀⣾⣿⣿⣿⣿⣿⣿⠃
  ⠈⠻⣿⣿⣿⣿⣿⣿⡄⢻⣿⣿⣿⠄⣿⣿⡀⣾⣿⣿⣿⣿⣛⠛⠁
    ⠈⠛⢿⣿⣿⣿⠁⠞⢿⣿⣿⡄⢿⣿⡇⣸⣿⣿⠿⠛
       ⠉⠻⣿⣿⣾⣦⡙⠻⣷⣾⣿⠃⠿⠋⠁
          ⠻⡿⣿⣿⡆⣿⡿⠃
-->

![Image](./project_banner.png)

# Project
Something about project or wth

---

### Table of contents
- [Project Name](#project-name)
    - [Overview](#overview)
    - [Dependencies](#dependencies)
    - [Requirements](#requirements)
    - [Installation](#installation)
    - [Implementation](#implementation)
    - [Configuration](#configuration)
    - [Usage](#usage)
    - [Contributors](#contributors)
    - [Credits](#credits)
    - [License](#license)

---

### Overview
A overview about project

---

### Dependencies
Dependencies of the project

| Name | Description |
| :--: | :---------: |
| Name | Description |

---

### Requirements
Requirements to run the project

---

### Installation
A guide how to install the project

---

### Implementation
A guide how to implement the project

---

### Configuration
A guide how to configure the project

---

### Usage
A usage guide of the project

---

### Contributors
Page to contributors of this repository

<a href="https://github.com/username/repository_name/graphs/contributors">
  <img src="https://contrib.rocks/image?repo=username/repository_name"/>
</a>

---

### Credits
Credits of this project

---

### License
This repository/project has a license based on [LICENSE](./LICENSE)
		'''

        if not test -z $argv[1]
            for arg in $argv
                if not test -e $arg
                    echo $readme_template >>$arg
                end
            end
            micro $argv
        else
            if not test -e "README.md"
                echo $readme_template >>"README.md"
            end
            micro "README.md"
        end

    end

    function dot
        if string match "*edit*" "$argv[1]" -q
            if string match "*awesome*" "$argv[2]" -q
                if string match "*theme*" "$argv[3]" -q
                    set -l theme "$HOME/.config/awesome/themes/$argv[4]/theme.lua"
                    if test -e $theme
                        $EDITOR $theme
                    else
                        $EDITOR "$AWESOME_THEME_CONFIG"
                    end
                else if string match "*config*" "$argv[3]" -q
                    $EDITOR "$HOME/.config/awesome/rc.lua"
                end
            else if string match "*fish*" "$argv[2]" -q
                if string match "*config*" "$argv[3]" -q
                    $EDITOR "$HOME/.config/fish/config.fish"
                    omf reload
                else if string match "*completions*" "$argv[3]" -q
                    if not test -z $argv[4]
                        for arg in $argv[4..]
                            $EDITOR "$HOME/.config/fish/completions/$arg"
                        end
                    end
                else if string match "*variables*" "$argv[3]" -q
                    $EDITOR "$HOME/.config/fish/fish_variables"
                else if string match "*functions*" "$argv[3]" -q
                    if not test -z $argv[4]
                        for arg in $argv[4..]
                            $EDITOR "$HOME/.config/fish/functions/$arg"
                        end
                    end
                end
            else if string match "*alacritty*" "$argv[2]" -q
                $EDITOR "$HOME/.config/alacritty/alacritty.yml"
            else if string match "*ranger*" "$argv[2]" -q
                $EDITOR "$HOME/.config/ranger/rc.conf"
            else if string match "*micro*" "$argv[2]" -q
                if string match "*settings*" "$argv[3]" -q
                    $EDITOR "$HOME/.config/micro/settings.json"
                else
                    if string match "*keybindings*" "$argv[3]" -q
                        $EDITOR "$HOME/.config/micro/bindings.json"
                    else
                        $EDITOR "$HOME/.config/micro/settings.json"
                    end
                end
            end
        else if string match "*path*" "$argv[1]" -q
            if test -d "$HOME/.config/$argv[2]"
                cd "$HOME/.config/$argv[2]"
            else
                if test -z "$argv[2]"
                    cd "$HOME/.config"
                end
            end
        else
            cd "$REPOS_PATH/dotfiles/"
        end
    end

    function ard
        if string match "*compile*" "$argv[1]" -q
            sudo arduino-cli compile -b arduino:avr:uno --warnings all $argv[2]
        else if string match "*attach*" "$argv[1]" -q
            sudo arduino-cli board attach -p /dev/ttyACM0 -b arduino:avr:uno
        else if string match "*upload*" "$argv[1]" -q
            sudo arduino-cli compile --upload --verify --warnings all $argv[2]
        else if string match "*monitor*" "$argv[1]" -q
            arduino-cli compile --upload --verify --warnings all $argv[2]
            sudo arduino-cli monitor -p /dev/ttyACM0
        end
    end

    function cs
        cht.sh $argv
    end

    function reload
        omf reload $argv
    end

    function gadd
        git add $argv
    end

    function gdf
        git diff $argv
    end

    function gst
        git status $argv
    end

    function gcm
        if not test -z $argv[1]
            git commit -S -m $argv
        end
        if test -z $argv[1]
            git commit -S
        end
    end

    function gft
        git fetch --all --prune $argv
    end

    function gps
        git push $argv
    end

    function gpl
        git pull $argv
    end

    function glog
        if string match "*all*" "$argv[1]" -q
            if string match "*line*" "$argv[2]" -q
                git log --all --graph --oneline $argv[3..-1]
            else
                git log --all --graph $argv[2..-1]
            end
        else if string match "*line*" "$argv[1]" -q
            if string match "*all*" "$argv[2]" -q
                git log --graph --oneline --all $argv[3..-1]
            else
                git log --graph --oneline $argv[2..-1]
            end
        else
            git log --graph --oneline $argv[1..-1]
        end
    end

    function lsr
        if not test -z "$argv[1]"
            ls $argv | sort
        else
            ls "." | sort
        end
    end

    function gls
        if string match "*global*" "$argv[1]" -q
            echo '[GLOBAL]'
            if not test -z "$argv[2]"
                git config --global --get-all "$argv[2]"
            else
                git config --global --list
            end
        else if string match "*local*" "$argv[1]" -q
            echo '[LOCAL]'
            if not test -z "$argv[2]"
                git config --local --get-all "$argv[2]"
            else
                git config --local --list
            end
        else
            echo '[GLOBAL]'
            git config --global --list
            echo
            echo '[LOCAL]'
            git config --local --list
        end
    end

    function gconf
        git config --global init.defaultBranch main
        
        git config --global gpg.program gpg
        
        git config --global user.name "$GITHUB_USER_USERNAME"
        git config --global user.email "$GITHUB_USER_EMAIL"
        git config --global user.signingkey "$GITHUB_SIGNING_KEY"

        git config --global commit.gpgsign true

        git config --global core.editor 'micro '
        git config --global core.excludesFile "$HOME/.gitignore_global"
        git config --global core.fileMode false
        git config --global core.safeDirectory *

        git config --global "url.https://api:$GIT_TOKEN@github.com/.insteadOf" 'https://github.com/'
        git config --global "url.https://ssh:$GIT_TOKEN@github.com/.insteadOf" 'ssh://git@github.com/'
        git config --global "url.https://git:$GIT_TOKEN@github.com/.insteadOf" 'git@github.com:'

        echo -e "Gitting as \033[3m\033[1;35m$GITHUB_USER_USERNAME\033[0;0m"
    end

    function repos
        if not test -d "$REPOS_PATH/$argv[1]"
            mkdir --parents "$REPOS_PATH/$argv[1]"
            cd "$REPOS_PATH/$argv[1]"
            cp "$HOME/.editorconfig" "$REPOS_PATH/$argv[1]"
            git init
        else
            cd "$REPOS_PATH/$argv[1]"
        end
    end

    function hd
        cd "/media/paodelonga/Hd External/$argv[1]"
    end

    function SY
        set --local files
        set --append files ".config/alacritty"
        set --append files "snap/btop/current/.config/btop"
        set --append files ".config/fish"
        set --append files ".config/micro"
        set --append files ".config/htop"
        set --append files ".config/sublime-text"
        set --append files ".config/omf"
        set --append files ".config/ranger"
        set --append files ".fish_env"
        set --append files ".fish_credentials"

        for item in $files
            echo -e "[SYNC] syncing $item"
            if sudo test -e "/root/$item"
                sudo rm -rf "/root/$item"
            end
            if sudo test -e "$HOME/$item"
                sudo cp -r "$HOME/$item" "/root/$item"
            end
        end
        echo -e "[SYNC] finished task!"
    end

    function BK
        set --local files

        set --append files ".bashrc"
        set --append files ".fish_credentials.template"
        set --append files ".fish_env"
        set --append files ".gtkrc-2.0"
        set --append files ".profile"
        set --append files ".xinitrc"

        set --append files (echo $HOME/snap/firefox/common/.mozilla/firefox/*.default/chrome)

        set --append files ".config/autostart"
        set --append files ".config/alacritty"
        set --append files ".config/awesome"
        set --append files "snap/btop/current/.config/btop"
        set --append files ".config/fish"
        set --append files ".config/gtk-3.0"
        set --append files ".config/htop"
        set --append files ".config/micro"
        set --append files ".config/ncspot"
        set --append files ".config/fontconfig"
        set --append files ".config/neofetch"
        set --append files ".config/nitrogen"
        set --append files ".config/sublime-text/Installed Packages"
        set --append files ".config/sublime-text/Packages/User"
        set --append files ".config/omf"
        set --append files ".config/picom"
        set --append files ".config/ranger"
        set --append files ".config/rofi"
        set --append files ".config/spicetify"
        set --append files ".config/vlc"
        set --append files ".config/digikamrc"

        set --local media_path "/media/$USERNAME/Hd External/Setup/Linux/Backup/"
        set --local home_path "/home/paodelonga/.Setup/Linux/"
        set --local backup_datetime ''(date '+%Y.%m.%d_%H-%M-%S')''

        if sudo test -d $media_path
            set backup_target $media_path
        else
            if sudo test -d $home_path
                set backup_target $home_path
            else
                mkdir -p $home_path
                set backup_target $home_path
            end
        end

        if test -z $backup_target
            echo -e "[BACKUP] error! variable backup_target is not set"
            exit
        end

        if not test -z $backup_target
            for item in $files
                echo -e "[BACKUP] backuping $item"
                if sudo test -e "$HOME/$item"
                    zip -qr "$backup_target$backup_datetime.zip" "$HOME/$item"
                end
            end
            echo -e "[BACKUP] backup storage in $backup_target"
        end
    end

    function md
        marker $argv
    end

    function IP
        echo 'PUBLIC: '(curl -s ipecho.net/plain)''
        echo 'PRIVATE: '(hostname -I | awk '{print $1}')''
    end

    function ROUTES
        route -nNvee
    end

    function pkl
        if not test -z $argv[1]
            echo -e "DPKG PACKAGES"
            for item in $argv
                dpkg -l | grep $item
            end
            echo -e "FLATPAK PACKAGES"
            for item in $argv
                flatpak list | grep $item
            end
            echo -e "SNAP PACKAGES"
            for item in $argv
                snap list | grep $item
            end
        end
    end

    function copyeditor
        cp "$HOME/.editorconfig" "$PWD/.editorconfig"
        echo "Updated editorconfig in : $PWD/.editorconfig"
    end

    function sorted
        if not test -z $argv[1]
            if test -d $argv[1]
                set -l files (ls --sort=size $argv[1] | sort | sed -e 's/.git//g')
                set -l ID
                mkdir "$PWD/Moved"
                if not test -z $argv[2]
                    set countPattern $argv[2]
                end
                echo $countPattern
                for ID in (seq 1 (count $files))
                    if test -z $argv[2]
                        set new_file_name (printf "%03d.%s" $ID $new_file_prefix)
                    end
                    if not test -z $argv[2]
                        set new_file_name (printf "%03d.%s" (math $countPattern - $ID) $new_file_prefix)
                    end
                    set new_file_prefix (echo -e $files[$ID] | rev | cut -d '.' -f 1 | rev)
                    mv "$PWD/$files[$ID]" "$PWD/Moved/$new_file_name"
                end
                for file in (ls "$PWD/Moved/")
                    mv "$PWD/Moved/$file" "$PWD/"
                end
                rmdir "$PWD/Moved"
            end
        end
    end
end
