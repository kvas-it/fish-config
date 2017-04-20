# Configuration for Fish (see https://fishshell.com/)

# Path
# set -gx PATH ~/bin ~/opt/bin $PATH

# MacOS X locale fix.
set -gx LC_ALL en_US.UTF-8
set -gx LC_CTYPE en_US.UTF-8
set -gx LANG en_US.UTF-8

# Event handlers:
#   list directory when we change into it.
function ls_dir --on-variable PWD
    set -l count (ls | wc -l)
    print_color grey '#004' '--> '$PWD':'
    if [ $count -gt 30 ]
        echo '...too many files to list'
    else if [ $count -gt 10 ]
        ls
    else
        ls -l
    end
end

#   automatically activate tox virtualenvs.
# function auto_toxenv --on-variable PWD
#     toxenv -q
# end

#   show current user@host:dir before the prompt.
function pre_prompt_status --on-event fish_prompt
    set prev_status $status
    if [ $prev_status -ne 0 ]
        print_color '#f44' black "exit code: $prev_status"
    end
    echo
    set -g fish_prompt_pwd_dir_length 0
    set -l top_prompt "[ $USER@"(prompt_hostname):(prompt_pwd)" ]"
    set -g fish_prompt_pwd_dir_length 1
    if [ (string length $top_prompt) -gt $COLUMNS ]
        set top_prompt " $USER@"(prompt_hostname):(prompt_pwd)" "
    end
    if [ $COLUMNS -gt 78 ]
        set top_prompt (printf '%-78s' $top_prompt)
    end

    print_color white '#048' $top_prompt
end

# Helper functions.
function print_color -a fg bg message
    echo (set_color $fg -b $bg)$message(set_color normal)
end

