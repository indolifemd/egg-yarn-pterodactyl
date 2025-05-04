#!/bin/bash
cd /home/container

if [ ! -z "$GIT_ADDRESS" ]; then
    echo "Cloning repository..."
    REPO_URL=${GIT_ADDRESS}

    if [[ "$REPO_URL" == *"github.com"* ]] && [ ! -z "$USERNAME" ] && [ ! -z "$ACCESS_TOKEN" ]; then
        REPO_URL=$(echo "$GIT_ADDRESS" | sed -e "s#https://#https://$USERNAME:$ACCESS_TOKEN@#")
    fi

    if [ ! -z "$BRANCH" ]; then
        git clone --branch "$BRANCH" "$REPO_URL" .
    else
        git clone "$REPO_URL" .
    fi
fi

export INTERNAL_IP=$(ip route get 1 | awk '{print $(NF-2);exit}')

echo "Node.js: $(node -v)"
echo "Yarn   : $(yarn -v)"

if [ -f /home/container/package.json ]; then
    echo "Installing dependencies..."
    yarn install
fi

MODIFIED_STARTUP=$(echo -e "${CMD_RUN}" | sed -e 's/{{/${/g' -e 's/}}/}/g')
echo -e ":/home/container$ ${MODIFIED_STARTUP}"
eval ${MODIFIED_STARTUP}
