#! /usr/bin/env bash

CATEGORIES=(
	"STOP"
	"WASTED"
	"RESERCH"
	"WORKFLOW"
	"PROGRAMMING"
)

selected=$(printf "%s\n" "${CATEGORIES[@]}" | fzf --margin 10% --color="bw")

if [[ "$selected" == "STOP" ]]; then
	timew stop
	export CURRENT="No mode"
else
	timew start "$selected"
	export CURRENT="$selected"
fi
