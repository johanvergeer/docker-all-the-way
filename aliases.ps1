Set-Variable -Name APP_CONTAINER -Value "docker-all-the-way_app_1"
Set-Variable -Name DB_CONTAINER -Value "docker-all-the-way_db_1"

Function Run-DockerCompose
{
    <#
        .SYNOPSIS
        Run docker-compose with the compose files for development
    #>
    docker-compose -f docker-compose.yaml -f docker-compose.dev.yaml $args
}

Set-Alias -Name dcdev -Value Run-DockerCompose

Function Start-Compose
{
    Run-DockerCompose up -d
}

Set-Alias -Name dcup -Value Start-Compose

Function Stop-Compose
{
    Run-DockerCompose down
}

Set-Alias -Name dcdown -Value Stop-Compose

Function Start-DbContainerShell
{
    docker exec -it $DB_CONTAINER bash
}

Set-Alias -Name dbshell -Value Start-DbContainerShell

Function Start-AppContainerShell
{
    docker exec -it $APP_CONTAINER bash
}

Set-Alias -Name appshell -Value Start-AppContainerShell

Function Run-Migrations
{
    docker cp db_migrations/. ${DB_CONTAINER}:/etc/opt/db/;
    docker exec $DB_CONTAINER bash /etc/opt/db/run_migrations.sh;
}

Set-Alias -Name runmigrations -Value Run-Migrations

Function Run-Tests
{
    docker exec $APP_CONTAINER coverage run -m unittest $args
}

Set-Alias -Name test -Value Run-Tests

Function Get-CoverageReport
{
    docker exec $APP_CONTAINER coverage report -m
}

Set-Alias -Name coveragereport -Value Get-CoverageReportJson

Function Get-CoverageReportJSON
{
    docker exec $APP_CONTAINER coverage json;
    docker cp ${APP_CONTAINER}:/opt/coverage.json coverage.json;
}

Set-Alias -Name coveragejson -Value Get-CoverageReportJSON

Function Run-Poetry
{
    docker exec $APP_CONTAINER poetry $args
}

Set-Alias -Name poetry -Value Run-Poetry

Function Build-ProductionImage
{
    docker build -t docker-all-the-way/app-run-production:1.0.0 --target production --progress plain --pull .
}

Set-Alias -Name buildprod -Value Build-ProductionImage
