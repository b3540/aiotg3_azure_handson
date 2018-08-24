# from https://github.com/Azure/iotedge/blob/master/edge-modules/ble/ble_edge_module.sh

ARCH=$(uname -m)
BLE_CONFIG_FILE=
DOCKER_REGISTRY=

check_arch()
{
    if [ "$ARCH" == "x86_64" ]; then
        ARCH="x64"
    elif [ "$ARCH" == "armv7l" ]; then
        ARCH="armv7hf"
    else
        echo "Unsupported Architecture"
        exit 1
    fi
}

get_abs_filename()
{
    name="$1"
    if [ -d "$(dirname "$name")" ]; then
        pushd . > /dev/null
        cd $(dirname "$name") > /dev/null
        file_name=$(pwd)
        file_name+="/"
        file_name+=$(basename $name)
        popd  > /dev/null
    else
        echo "Invalid Filename Provided."
        exit 1
    fi
    echo "$file_name"
}

usage()
{
    echo "$SCRIPT_NAME [options]"
    echo "Note: Depending on the options you might have to run this as root or sudo."
    echo ""
    echo "options"
    echo " -r, --registry               Docker registry required to build, tag and run the module"
    echo " --ble_config_file            BLE config file required when running the BLE module."
    exit 1;
}

print_help_and_exit()
{
    echo "Run $SCRIPT_NAME --help for more information."
    exit 1
}

process_args()
{
    save_next_arg=0
    for arg in $@
    do
        if [ $save_next_arg -eq 1 ]; then
            DOCKER_REGISTRY="$arg"
            save_next_arg=0
        elif [ $save_next_arg -eq 2 ]; then
            BLE_CONFIG_FILE=$(get_abs_filename "$arg")
            save_next_arg=0
        else
            case "$arg" in
                "-h" | "--help" ) usage;;
                "-r" | "--registry" ) save_next_arg=1;;
                "--ble_config_file" ) save_next_arg=2;;
                * ) usage;;
            esac
        fi
    done

    if [[ -z ${DOCKER_REGISTRY} ]]; then
        echo "Registry Not Provided"
        print_help_and_exit
    fi

    if [[ -z ${BLE_CONFIG_FILE} ]]; then
        echo "BLE Config File Not Provided"
        print_help_and_exit
    fi
}



run_edge_ble_docker_container()
{
    docker_run_cmd="docker run "
    docker_run_cmd+="-v /var/run/dbus:/var/run/dbus "
    docker_run_cmd+="-v ${BLE_CONFIG_FILE}:/app/ble_config/config.json:ro "
    docker_run_cmd+="${DOCKER_REGISTRY}/azedge-ble-aiotg3-${ARCH} "
    echo "Running Command: $docker_run_cmd"
    $docker_run_cmd &
    if [ $? -ne 0 ]; then
        echo "Docker Run Failed With Exit Code $?"
        exit $?
    fi
}

########
# Main
########
check_arch
process_args $@

run_edge_ble_docker_container

[ $? -eq 0 ] || exit $?
