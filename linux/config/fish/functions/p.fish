#!usr/bin/env fish

set --local commands "play"
set --append commands "pause"
set --append commands "stop"
set --append commands "pp"
set --append commands "next"
set --append commands "previous"
set --append commands "pos"
set --append commands "position"
set --append commands "vol"
set --append commands "volume"
set --append commands "status"
set --append commands "st"
set --append commands "open"
set --append commands "loop"
set --append commands "shuffle"

complete --no-file --command p --condition "not __fish_seen_subcommand_from $commands" --arguments "$commands"

function player_cmd
    eval playerctl --player (playerctl --list-all | grep "kdeconnect" | sed -n '1p') $argv[..]
end

function p
    if not test -z $argv[1]
        if string match "*play*" $argv[1] -q
            player_cmd "play"
        else if string match "*pause*" $argv[1] -q
            player_cmd "pause"
        else if string match "*stop*" $argv[1] -q
            player_cmd "stop"
        else if string match "*pp*" $argv[1] -q
            player_cmd "play-pause"
        else if string match "*next*" $argv[1] -q
            player_cmd "next"
        else if string match -r ".*prev.*|.*previous.*" $argv[1] -q
            player_cmd "previous"
        else if string match -r ".*pos.*|.*position.*" $argv[1] -q
            player_cmd "position " $argv[2..]
        else if string match -r ".*vol.*|.*volume.*" $argv[1] -q
            player_cmd "volume " $argv[2..]
        else if string match -r ".*st.*|.*status.*" $argv[1] -q
            player_cmd "status"
        else if string match "*open*" $argv[1] -q
            player_cmd "open " $argv[2]
        else if string match "*loop*" $argv[1] -q
            player_cmd "loop"
        else if string match "*shuffle*" $argv[1] -q
            player_cmd "shuffle"
        end
    end
end
