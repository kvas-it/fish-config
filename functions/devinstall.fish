# Install Python package from the current directory into active virtualenv
# in development mode.
function devinstall
    if not functions -q deactivate
        echo "No active virtualenv -- refusing to install into global python" >&2
        return 1
    end

    if [ -f setup.py ]
        set -l name (python setup.py --name)
        pip uninstall -yq $name
        python setup.py -q develop
        echo "Activated $env and installed $name in development mode"
    else
        set -gx PYTHONPATH (pwd)
        echo "Activated $env and set PYTHONPATH to $PYTHONPATH"
    end
end

