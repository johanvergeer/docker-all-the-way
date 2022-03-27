Set-Variable -Name COMPOSE_FILES -Value "-f docker-compose.yaml -f docker-compose.dev.yaml"
Set-Variable -Name APP_CONTAINER -Value "docker-all-the-way_app_1"
Set-Variable -Name DB_CONTAINER -Value "docker-all-the-way_db_1"

Function Start-Compose { docker-compose -f docker-compose.yaml -f docker-compose.dev.yaml up -d }

Set-Alias -Name dcup -Value Start-Compose

Function Stop-Compose { docker-compose -f docker-compose.yaml -f docker-compose.dev.yaml down }

Set-Alias dcdown -Value Stop-Compose

Function Start-DbContainerShell { docker exec -it $DB_CONTAINER bash }

Set-Alias dbshell -Value Start-DbContainerShell

Function Start-AppContainerShell { docker exec -it $APP_CONTAINER bash }

Set-Alias appshell -Value Start-AppContainerShell

Function Run-Migrations {
    docker cp db_migrations/. ${DB_CONTAINER}:/etc/opt/db/;
    docker exec $DB_CONTAINER bash /etc/opt/db/run_migrations.sh;
}

Set-Alias runmigrations -Value Run-Migrations

Function Run-Tests {
    docker exec $APP_CONTAINER coverage run -m unittest $args
}

Set-Alias test -Value Run-Tests

Function Get-CoverageReport {
    docker exec $APP_CONTAINER coverage report -m
}

Set-Alias coveragereport -Value Get-CoverageReportJson

Function Get-CoverageReportJSON{
    docker exec $APP_CONTAINER coverage json;
    docker cp ${APP_CONTAINER}:/opt/coverage.json coverage.json;
}

Set-Alias coveragejson -Value Get-CoverageReportJSON

Function Run-Poetry { docker exec $APP_CONTAINER poetry $args }

Set-Alias poetry -Value Run-Poetry

Function Build-ProductionImage {
    docker build -t docker-all-the-way/app-run-production:1.0.0 --target production --progress plain --pull .
}

Set-Alias buildprod -Value Build-ProductionImage
