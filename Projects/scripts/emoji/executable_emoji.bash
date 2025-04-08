# Dependencies: `uni`, `kitty`, `wtype` or `xdotool`, `fzf`, `wl-clipboard` or `xclip`
# `uni` project: https://github.com/arp242/uni

# Usage: `chmod a+x emoji.bash`, then run the script whenever you need to pick emojis

# Determine the script's directory
SCRIPT_DIR=$(dirname "$(realpath "$0")")
export EMOJI_CHAR_PATH="/tmp/unicode_result-$USER.txt"
touch "$EMOJI_CHAR_PATH"

# Detect the display server and set commands appropriately
if [ -n "$WAYLAND_DISPLAY" ]; then
    clipboard_cmd="wl-copy"
    input_cmd="wtype"
elif [ -n "$DISPLAY" ]; then
    clipboard_cmd="xclip"
    input_cmd="xdotool type"
else
    echo "Display server not recognized."
    exit 1
fi

function _unicode_search {
    local type=$1
    local char
    local args

    args=(
        -format '%(emoji l:auto) %(name)'
        -compact
        emoji all
    )
    
    char=$(uni "${args[@]}" | fzf | cut -d' ' -f1)
    echo -n "$char" >"$EMOJI_CHAR_PATH"
    echo -n "$char"
}

function unicode_search {
    local type=$1
    local char && char=$(_unicode_search "$type")
    if [ "$clipboard_cmd" = "xclip" ]; then
        echo -n "$char" | $clipboard_cmd -selection clipboard
    else
        echo -n "$char" | $clipboard_cmd --trim-newline
    fi
    echo "Copied $char to clipboard"
}

function emoji_picker {
    kitty \
        --title "Emoji Picker" \
        -o "remember_window_size=no" \
        -o "initial_window_width=45c" \
        -o "initial_window_height=15c" \
        -o "font_size=20" \
        bash -c \
        "$SCRIPT_DIR/emoji.bash _unicode_search"

    char_to_type=$(cat "$EMOJI_CHAR_PATH")

    $input_cmd "$char_to_type"
}

subcommand=${1:-emoji_picker}
"$subcommand"
