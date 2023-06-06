#!usr/bin/env fish

function expath --description 'exporting path to current enviroment'
	if not test -z $argv[1]
		if test -d $argv[1]
			if string match $argv[1] "." -q
				export PATH="$PATH:$PWD"
			else
				export PATH="$PATH:$argv[1]"
			end
		end
	else
		export PATH="$PATH:$PWD"
		end
end

