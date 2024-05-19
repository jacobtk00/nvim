#!/usr/bin/env bash

DEFAULT_BASE_DIR=~/Projects

function invalid_option() {
	echo "Invalid option: $1" >&2
	# print_opts
	exit 1
}

function get_session_dir() {
	if [[ $# -eq 1 ]]; then
	  SESSION_DIR=$(find "$1" -mindepth 1 -maxdepth 2 -type d | fzf)
    else
	  SESSION_DIR=$(find ~/Projects -mindepth 1 -maxdepth 2 -type d | fzf)
	  # selected=$(find $HOME/Projects -type d -maxdepth 1 | while read -r p; do zoxide query -l -s "$p/"; done | sort -rnk1 | fzf --no-sort) #| awk '{print $2}')
	fi
	if [[ -z $SESSION_DIR ]]; then
	  echo "Exiting..."
	  exit 1
	fi
}

# Get options, --dir to specify directory
BASE_DIR=""
while getopts ":h-:" OPTCHAR; do
	case ${OPTCHAR} in
		-)
			case ${OPTARG} in
				dir)
					BASE_DIR=${!OPTIND}
					((OPTIND++)) ;;
				fzf)
					FZF=true ;;
				new)
					NEW_PROJECT=true ;;
				*) invalid_option "--${OPTARG}" ;;

			esac ;;
		h) exit 0 ;;
		*) invalid_option "-${OPTARG}" ;;
	esac
done

if [[ -z $BASE_DIR ]]; then
	BASE_DIR=$DEFAULT_BASE_DIR
fi

# Fuzzy find folder
if [[ $FZF ]]; then
	echo "Select a directory: "
	get_session_dir $BASE_DIR
else
	SESSION_DIR=$BASE_DIR
fi

if [[ -z $SESSION_DIR ]]; then
	echo "Exiting..."
	exit 1
fi

echo "$SESSION_DIR"

if [[ $NEW_PROJECT ]]; then
	echo "Name of new Project: "
	read -r PROJECT_NAME
	PROJECT_DIR=$SESSION_DIR/$PROJECT_NAME
	echo "$PROJECT_DIR"
	mkdir -p "$PROJECT_DIR"
	# If mkdir fails or directory doesn't exist
	if [[ $? -ne 0 ]] || [[ ! -d $PROJECT_DIR ]]; then
		echo "Error creating project directory"
		exit 1
	fi

	SESSION_DIR=$PROJECT_DIR
fi

PROJECT_NAME=$(basename "$SESSION_DIR" | tr . _)
PROJECT_DIR=$SESSION_DIR

if [[ -z $TMUX ]] && [[ -z $(pgrep tmux) ]]; then
	tmux new-session -s "$PROJECT_NAME" -c "$PROJECT_DIR"
	exit 0
fi

if $NEW_PROJECT; then
	tmux new-session -ds "$PROJECT_NAME" -c "$PROJECT_DIR"
fi

if ! tmux has-session -t="$PROJECT_NAME" 2>/dev/null; then
	tmux new-session -ds "$PROJECT_NAME" -c "$PROJECT_DIR"
fi

if ! tmux switch-client -t "$PROJECT_NAME" 2>/dev/null; then
	tmux attach-session -t "$PROJECT_NAME"
fi


# echo "Selected: $SESSION_DIR"
# selected_name="$(basename "$SESSION_DIR" | tr . _)"
# echo $selected_name
# tmux_running="$(pgrep tmux)"
# echo $tmux_running
#
#
# if [[ -z $TMUX ]] && [[ -z $tmux_running ]]; then
#   tmux new-session -s $selected_name -c $selected
#   exit 0
# fi
#
# if ! tmux has-session -t=$selected_name 2>/dev/null; then
#   tmux new-session -ds $selected_name -c $selected
# fi
#
# if ! tmux switch-client -t $selected_name 2>/dev/null; then
#   tmux attach-session -t $selected_name
# fi
#
