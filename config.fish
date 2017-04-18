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
    print_bluebg ' changed to '$PWD
    if [ $count -gt 30 ]
        echo '...too many files to list'
    else if [ $count -gt 10 ]
        ls
    else
        ls -l
    end
end

#   automatically activate tox virtualenvs.
function auto_toxenv --on-variable PWD
    if functions -q exit_auto_toxenv
        exit_auto_toxenv
    end
    if [ -d .tox ]
        toxenv
        if functions -q deactivate
            function exit_auto_toxenv
                deactivate
                functions -e exit_auto_toxenv
            end
        end
    end
end

#   show current user@host:dir before the prompt.
function pre_prompt_status --on-event fish_prompt
    set prev_status $status
    if [ $prev_status -ne 0 ]
        echo (set_color '#f44')"exit code: $prev_status"(set_color normal)
    end
    set -l top_prompt " $USER@"(prompt_hostname):(pwd)" "
    if [ (string length $top_prompt) -gt $COLUMNS ]
        set top_prompt " $USER@"(prompt_hostname):(prompt_pwd)" "
    end
    print_bluebg $top_prompt
end

# Helper functions.
function print_bluebg
    echo (set_color -b '#004')$argv[1](set_color normal)
end

