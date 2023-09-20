#!/bin/bash

ops='host:,port:,gh-org:,gh-repo:,datadir:,data-indexes:'
USAGE="\nUsage: $0 [--host hostname] [--port port-number] [--gh-org github-organization] [--gh-repo github repository] [--datadir data-directory] [--data-indexes data-indexes-separated-by-spaces]\n"
OPTIONS=$(getopt --options '' --longoptions ${ops} --name "$0" -- "$@")
[[ "$?" != 0 ]]  && exit 3
eval set -- "${OPTIONS}"

HOST_NAME=localhost
HOST_PORT=9200
GH_ORG=opencybersecurityalliance
GH_REPO=data-bucket-kestrel
DATA_DIR="${HOME}"/fedsearchtest/data/opensearch
DATA_INDEXES="linux-91-sysflow-bh22-20220727 win-111-winlogbeat-bh22-20220727 win-112-winlogbeat-bh22-20220727"

while true
do
    case "${1}" in
    --host)
        HOST_NAME="$2"
        shift 2
        ;;
    --port)
        HOST_PORT="$2"
        shift 2
        ;;
    --gh-org)
        GH_ORG="$2"
        shift 2
        ;;
    --gh-repo)
        GH_REPO="$2"
        shift 2
        ;;
    --datadir)
        DATA_DIR="$2"
        shift 2
        ;;
    --data-indexes)
        DATA_INDEXES="$2"
        shift 2
        ;;
    --)
        shift
        break
        ;;
    *)
        echo -e "\n\nUndefined options given!"
        echo "$*"
        echo -e "${USAGE}"
        exit 3
        ;;
    esac
done

pip install requests
OS_USER=$(cat "${HOME}"/.opensearch/.os_user)
OS_PWD=$(cat "${HOME}"/.opensearch/.os_pwd)
mkdir -p "${DATA_DIR}"
dataindexes=(${DATA_INDEXES// / })
for dataindex in "${dataindexes[@]}" 
do
    echo "Running python federated-search-core/setup/opensearch/import_data.py ${dataindex} --directory ${DATA_DIR} --organization ${GH_ORG} --repository ${GH_REPO}"
    python federated-search-core/setup/opensearch/import_data.py "${dataindex}" --directory "${DATA_DIR}" --organization "${GH_ORG}" --repository "${GH_REPO}"
    echo "Index ${dataindex} ready for uploading into opensearch instance"
    sudo docker run --rm --net=host -e NODE_TLS_REJECT_UNAUTHORIZED=0 -v "${DATA_DIR}":/tmp elasticdump/elasticsearch-dump \
    --output=https://"admin:admin@${HOST_NAME}:${HOST_PORT}/${dataindex}" \
    --input=/tmp/"${dataindex}".mapping.json --type=mapping
    echo "Uploaded ${dataindex} mappings in elasticsearch"
    sudo docker run --rm --net=host -e NODE_TLS_REJECT_UNAUTHORIZED=0 -v "${DATA_DIR}":/tmp elasticdump/elasticsearch-dump \
    --output=https://"admin:admin@${HOST_NAME}:${HOST_PORT}/${dataindex}" \
    --input=/tmp/"${dataindex}".json  --limit 25000  --type=data
    echo "Uploaded ${dataindex} in elasticsearch"
done
