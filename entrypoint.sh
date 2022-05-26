#!/bin/bash
set -e

# Remove a potentially pre-existing server.pid for Rails.
rm -f ./tmp/pids/server.pid
mkdir -pm 1777 ./tmp

# Set the environment
if [ -z "$RAILS_ENV" ]
then
  export RAILS_ENV=production
fi

if [ -z "API_SERVICE_URL" ]
then
  echo "{'ts': '`date -u +%FT%T.%3NZ`', 'message': {'text: 'You have not specified an API_SERVICE_URL', 'level': 'ERROR'}}" >&2
  exit 1
fi

echo "{'ts': '`date -u +%FT%T.%3NZ`', 'message': {'text: 'Standard Reports starting with API_SERVICE_URL ${API_SERVICE_URL}', 'level': 'INFO'}}"

# Handle secrets based on env
if [ "$RAILS_ENV" == "production" ] && [ -z "$SECRET_KEY_BASE" ]
then
  export SECRET_KEY_BASE=`./bin/rails secret`
fi

export RAILS_RELATIVE_URL_ROOT=${RAILS_RELATIVE_URL_ROOT:-'/app/standard-reports'}
export SCRIPT_NAME=${RAILS_RELATIVE_URL_ROOT}

echo "{'ts': '`date -u +%FT%T.%3NZ`', 'message': {'text: 'Standard reports booting: env=${RAILS_ENV} RAILS_RELATIVE_URL_ROOT=${RAILS_RELATIVE_URL_ROOT}', 'level': 'DEBUG'}}"

exec ./bin/rails server -e ${RAILS_ENV} -b 0.0.0.0
