<#
    .SYNOPSIS
    Helper commands to work with the docker-all-the-way demo project

    .EXAMPLE
    PS> . .\aliases.ps1
#>

Set-Variable -Name APP_CONTAINER -Value "docker-all-the-way-app"
Set-Variable -Name DB_CONTAINER -Value "docker-all-the-way-db"

Function Invoke-DockerComposeForDevelopment { 
    <#
        .SYNOPSIS
        Shortcut to run docker compose commands with the files required for development

        .EXAMPLE
        PS> dcdev up -d

        .EXAMPLE
        PS> dcdev ps
    #>
    docker-compose -f docker-compose.yaml -f docker-compose.dev.yaml $args 
}
Set-Alias -Name dcdev -Value Invoke-DockerComposeForDevelopment

Function Start-ComposeStack { Invoke-DockerComposeForDevelopment up -d $args }
Set-Alias -Name dcup -Value Start-ComposeStack

Function Stop-ComposeStack { Invoke-DockerComposeForDevelopment down }
Set-Alias -Name dcdown -Value Stop-ComposeStack

Function Invoke-Poetry {
    <#
        .SYNOPSIS
        Invokes Poetry commands inside the app service container

        .EXAMPLE
        PS> poetry add pytest

        .EXAMPLE
        PS> poetry install --dev
    #>
    docker exec $APP_CONTAINER poetry $args 
}
Set-Alias -Name poetry -Value Invoke-Poetry

Function Start-AppContainerShell {
    <#
        .SYNOPSIS
        Start a shell inside the app service container

        .NOTES
        - The app service container has to be running
    #>
    docker exec -it $APP_CONTAINER bash
}
Set-Alias -Name appshell -Value Start-AppContainerShell

Function Start-DbContainerShell { 
    <#
        .SYNOPSIS
        Start a shell inside the db service container

        .NOTES
        - The db service container has to be running
    #>
    docker exec -it $DB_CONTAINER bash 
}
Set-Alias -Name dbshell -Value Start-DbContainerShell

Function Invoke-Tests { 
    <#
        .SYNOPSIS
        Invoke the unit tests inside the app service container

        .EXAMPLE
        PS> test
        
        .EXAMPLE
        PS> test tests.app.main
    #>
    docker exec $APP_CONTAINER coverage run -m unittest $args 
}
Set-Alias -Name test -Value Invoke-Tests

Function Get-CoverageReport {
    <#
        .SYNOPSIS
        Creates the test coverage report inside the app service container and copies it to the current working directory
    #>
    docker exec $APP_CONTAINER coverage report -m;
    docker cp ${APP_CONTAINER}:/opt/coverage.json $(Get-Location)/coverage.json;
}
Set-Alias -Name coveragereport -Value Get-CoverageReport

Function Invoke-Migrations {
    <#
        .SYNOPSIS
        Copies all files from ./db_migrations to the db service container and invokes run_migrations.sh
    #>
    docker cp db_migrations/. ${DB_CONTAINER}:/etc/opt/db/;
    docker exec $DB_CONTAINER bash /etc/opt/db/run_migrations.sh;
}
Set-Alias -Name runmigrations -Value Run-Migrations

Function Build-ProductionImage {
    <#
        .SYNOPSIS
        Builds the Docker image for production use
    #>
    docker build -t docker-all-the-way/app-run-production:1.0.0 --target production --progress plain --pull .
}
Set-Alias -Name buildprod -Value Build-ProductionImage
