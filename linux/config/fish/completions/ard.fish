set -l ard_commands compile attach upload
set -l arduino_sketchs (ls *.ino | sort)

complete -f -c ard -n "not __fish_seen_subcommand_from $ard_commands" -a "$ard_commands"
complete -f -c ard -n "__fish_seen_subcommand_from compile; and not __fish_seen_subcommand_from $arduino_sketchs" -a "$arduino_sketchs"
complete -f -c ard -n "__fish_seen_subcommand_from upload; and not __fish_seen_subcommand_from $arduino_sketchs" -a "$arduino_sketchs"