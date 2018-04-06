#!/bin/sh
set -e

if [ -n "${AQUARIUS_SERVICE_PASSWORD_PATH}" ]; then
  aquariusServicePassword=$(cat ${AQUARIUS_SERVICE_PASSWORD_PATH})
fi

java -Djava.security.egd=file:/dev/./urandom -DkeystorePassword=$keystorePassword -DaquariusServicePassword=$aquariusServicePassword -jar app.jar $@

exec env "$@"
