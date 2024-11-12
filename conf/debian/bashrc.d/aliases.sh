# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# some more ls aliases
alias ll="ls -lv --group-directories-first"
alias la='ls -A'

# -> Prevents accidentally clobbering files.
alias mkdir='mkdir -p'

alias h='history'
alias j='jobs -l'
alias which='type -a'
alias ..='cd ..'

# Pretty-print of some PATH variables:
alias path='echo -e ${PATH//:/\\n}'
alias libpath='echo -e ${LD_LIBRARY_PATH//:/\\n}'

alias du='du -kh'    # Makes a more readable output.
alias df='df -kTh'
