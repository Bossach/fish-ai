##
## This section contains the keybindings for fish-ai. If you want to change the
## default keybindings, edit the key binding escape sequences below according to
## your needs. You can get the key binding escape sequence for a keyboard shortcut
## using the command `fish_key_reader`.
##
bind \cp _fish_ai_codify_or_explain
bind -k nul _fish_ai_autocomplete_or_fix

##
## This section contains functionality for setting and clearing the status shown
## in the right prompt.
##
bind \r 'clear_status; commandline -f execute'
bind \cc 'clear_status; commandline -f repaint; commandline -f cancel-commandline'

function clear_status
    set -e status_emoji
end

##
## This section contains the plugin lifecycle hooks invoked by the fisher package
## manager.
##
function _fish_ai_install --on-event fish_ai_install
    echo "🥡 Setting up a virtual environment..."
    python3 -m venv ~/.fish-ai
    echo "🍬 Installing dependencies. This may take a few seconds..."
    ~/.fish-ai/bin/pip install -qq "$(get_installation_url)"
end

function _fish_ai_update --on-event fish_ai_update
    echo "🍬 Upgrading dependencies. This may take a few seconds..."
    ~/.fish-ai/bin/pip install -qq --upgrade "$(get_installation_url)"
end

function __fish_ai_uninstall --on-event fish_ai_uninstall
    echo "💣 Nuking the virtual environment..."
    rm -r ~/.fish-ai
end

function get_installation_url
    set plugin (fisher list "fish-ai")
    if string sub -q --start 1 --length 1 "$plugin" = /
        # Install from local folder
        echo -n "$plugin"
    else
        # Install from git
        echo -n "pip@git+https://github.com/$plugin"
    end
end
