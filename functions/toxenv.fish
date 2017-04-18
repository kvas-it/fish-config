function toxenv
    set -l env $argv[1]
    if [ "$env" = "" -a -d .tox/py35 ]
        set env py35
    end
    if [ "$env" = "" -a -d .tox/py27 ]
        set env py27
    end
    if [ ! -d .tox/$env ]
        echo "No virtualenv found at .tox/$env"
        return 1
    end
    source .tox/$env/bin/activate.fish
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
