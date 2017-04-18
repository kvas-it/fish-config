# Find .tox directory in the current directory or above it. Outputs
# the path to .tox directory or nothing if it was not found.
function find_tox_dir
    set -l base $PWD
    while true
        set -l tox_dir $base'/.tox'
        if [ -d $tox_dir ]
            if count $tox_dir/py* >/dev/null
                echo $base'/.tox'
                return 0
            end
        end
        if [ "$base" = / ]
            return 1
        end
        set base (dirname $base)
    end
    return 1
end

# Print the path to tox-created virtualenv corresponding to a specific
# python version (given as pyXX, optional). If no version was given, pick
# the first available from the list: py36, py35, py27. If a virtualenv
# for specified (or autoselected) version is not available, return 1 and
# print nothing.
function get_toxenv_path -a tox_path py_version
    set -l versions
    if [ -n "$py_version" ]
        set versions $py_version
    else
        set versions py36 py35 py27
    end
    for version in $versions
        if [ -d $tox_path/$version ]
            echo (realpath $tox_path/$version)
            return 0
        end
    end
    return 1
end

# Activate specified (or automatically picked) tox-created virtualenv in
# current directory or higher up the path. Deactivate any currently
# activated virtualenv before doing it but don't deactivate/re-activate
# the same one.
function toxenv -a py_version
    set -l tox_dir
    set -l toxenv_path
    set -l quiet no

    if [ "$py_version" = "-q" ]
        set quiet yes
        if set -q argv[2]
            set py_version $argv[2]
        else
            set py_version ''
        end
    end

    if set tox_dir (find_tox_dir)
        set toxenv_path (get_toxenv_path $tox_dir $py_version)
    end

    if functions -q deactivate
        set -l current_env (realpath (dirname (dirname (which python))))
        if [ -n "$toxenv_path" ]
            if [ "$current_env" = "$toxenv_path" ]
                if [ $quiet = no ]
                    echo "Tox virtualenv at $current_env is already active"
                end
                return 0
            end
        end
        deactivate
    end

    if [ -z "$toxenv_path" ]
        if [ $quiet = no ]
            echo "No tox directory found here or above" >&2
        end
        return 1
    end

    source $toxenv_path/bin/activate.fish
end
