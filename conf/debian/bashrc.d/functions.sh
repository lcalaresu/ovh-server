function swap()
{
    local TMPFILE=tmp.$$
	
    [ $# -ne 2 ] && echo "swap: 2 arguments needed" && return 1
    [ ! -e $1 ] && echo "swap: $1 does not exist" && return 1
    [ ! -e $2 ] && echo "swap: $2 does not exist" && return 1

    mv "$1" $TMPFILE
    mv "$2" "$1"
    mv $TMPFILE "$2"
}

# Find a file with a pattern in name:
function ff() 
{ 
  find . -type f -iname '*'"$*"'*' -ls ; 
}

# Repeat n times command.
function repeat()      
{
    local i max
    max=$1; shift;
    for ((i=1; i <= max ; i++)); do  # --> C-like syntax
        eval "$@";
    done
}


