#!/usr/bin/env bash
#

function usage() {
  echo "Generate host file"
  echo "Usage: $0 -f <fqhn> -u <username> -v <vpn> -t <trusted_cert>"
  echo "-f <fqhn>: fully qualified hostname"
  echo "-u <username>: owner of the laptop"
  echo "-v <vpn>: vpn address"
  echo "-t <trusted_cert>: owner of the laptop"
}

# Process options
while getopts "f:u:v:t:h" opt; do
   case ${opt} in
        f )
          FQHN="${OPTARG}"
          ;;
        u )
          USERNAME="${OPTARG}"
          ;;
        v )
          VPN_ADDRESS="${OPTARG}"
          ;;
        t )
          TRUSTED_CERT="${OPTARG}"
          ;;
        \? )
          echo "Invalid Option: -$OPTARG" 1>&2
          usage
          exit 1
          ;;
        : )
          echo "Invalid Option: -$OPTARG requires an argument" 1>&2
          usage
          exit 1
          ;;
        h )
          usage
          exit 1
          ;;
   esac
done
shift $((OPTIND -1))
if [[ -z "${FQHN}" || -z "${USERNAME}" ]]; then
	usage
	exit -1
fi
readarray -d . -t arr <<< "${FQHN}"
HOSTNAME=${arr[0]}

cat <<EOF > hosts
[fedora:vars]
ansible_user= ${USERNAME}
vpn_address=${VPN_ADDRESS}
trusted_cert=${TRUSTED_CERT}
user_home=/home/${USERNAME}
user_download=/home/${USERNAME}/Downloads
user_driver_dir=/home/${USERNAME}/GIT/laptop
user_forti_config=/home/${USERNAME}/vpn-forti/config

[fedora]
${HOSTNAME} ansible_host=${FQHN} ansible_connection=local

[common]
${HOSTNAME}

[update]
${HOSTNAME}

[tools]
${HOSTNAME}
EOF
