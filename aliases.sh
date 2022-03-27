COMPOSE_FILES="-f docker-compose.yaml -f docker-compose.run-local.yaml"
APP_CONTAINER="docker-all-the-way_app_1"
DB_CONTAINER="docker-all-the-way_db_1"

alias dcup="docker-compose $COMPOSE_FILES up -d"
alias dcdown="docker-compose $COMPOSE_FILES down"

# Login to the db Docker container
alias dbshell="docker exec -it $DB_CONTAINER bash"
# Login to the app Docker container
alias appshell="docker exec -it $APP_CONTAINER bash"

# Run database migrations in the db container
alias runmigrations="docker cp db_migrations/. $DB_CONTAINER:/etc/opt/db/ && docker exec $DB_CONTAINER bash /etc/opt/db/run_migrations.sh"

# Run unit tests in Docker container and retrieve coverage report
alias test="docker exec $APP_CONTAINER coverage run -m unittest"
alias coveragereport="docker exec $APP_CONTAINER coverage report -m"
alias coveragejson="docker exec $APP_CONTAINER coverage json && docker cp $APP_CONTAINER:/opt/coverage.json coverage.json"

# Run poetry commands in Docker container
alias poetry="docker exec $APP_CONTAINER poetry"
