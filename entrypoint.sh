#!/usr/bin/env bash

set -eo pipefail

if [[ -z $STK_USERNAME ]] || [[ -z $STK_PASSWORD ]]; then
	echo "must supply \$STK_USERNAME and \$STK_PASSWORD"
	exit 1
fi

if ! supertuxkart \
	--init-user \
	--login="$STK_USERNAME" \
	--password="$STK_PASSWORD" | grep -q "Logged in from command-line."; then
	echo "failed to login, please run the login command manually to confirm it works"
	echo "supertuxkart --init-user --login=\"\$STK_USERNAME\" --password=\"\$STK_PASSWORD\""
	exit 1
fi

exec "$@"
