# Path to Oh My Fish install.
set -q XDG_DATA_HOME
  and set -gx OMF_PATH "$XDG_DATA_HOME/omf"
  or set -gx OMF_PATH "$HOME/.local/share/omf"

# Load Oh My Fish configuration.
source $OMF_PATH/init.fish

# # Read current theme
# test -f $OMF_CONFIG/theme
  # and read -l theme < $OMF_CONFIG/theme
  # or set -l bira
