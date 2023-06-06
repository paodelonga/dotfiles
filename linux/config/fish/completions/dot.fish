set -l dotfiles_commands edit path 
set -l edit_commands awesome theme fish alacritty ranger micro
set -l fish_commands config completions variables functions
set -l fish_completions (ls "$HOME/.config/fish/completions")
set -l fish_functions (ls "$HOME/.config/fish/functions")
set -l path_list alacritty awesome btop fish micro nitrogen omf picom ranger rofi sublime-text
set -l micro_commands keybindings settings
set -l awesome_commands config theme
set -l awesome_themes (ls "$HOME/.config/awesome/themes/"| sort)

complete -f -c dot -n "not __fish_seen_subcommand_from edit" -a "edit"
complete -f -c dot -n "not __fish_seen_subcommand_from edit" -a "path"

complete -f -c dot -n "__fish_seen_subcommand_from edit; and not __fish_seen_subcommand_from $edit_commands" -a "$edit_commands"
complete -f -c dot -n "__fish_seen_subcommand_from path; and not __fish_seen_subcommand_from $path_list" -a "$path_list"

complete -f -c dot -n "__fish_seen_subcommand_from fish; and not __fish_seen_subcommand_from $fish_commands" -a "$fish_commands"
complete -f -c dot -n "__fish_seen_subcommand_from completions" -a "$fish_completions"
complete -f -c dot -n "__fish_seen_subcommand_from functions" -a "$fish_functions"
complete -f -c dot -n "__fish_seen_subcommand_from awesome; and not __fish_seen_subcommand_from $awesome_commands" -a "$awesome_commands"
complete -f -c dot -n "__fish_seen_subcommand_from theme; and not __fish_seen_subcommand_from $awesome_themes" -a "$awesome_themes"
complete -f -c dot -n "__fish_seen_subcommand_from micro; and not __fish_seen_subcommand_from $micro_commands" -a "$micro_commands"