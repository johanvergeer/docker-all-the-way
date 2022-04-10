<#
    .SYNOPSIS
    Helper commands to work with the docker-all-the-way demo project

    .EXAMPLE
    PS> . .\aliases.ps1
#>

Set-Variable -Name PROJECT_SLUG -Value "docker-all-the-way"
Set-Variable -Name APP_CONTAINER -Value "${PROJECT_SLUG}-app"
Set-Variable -Name DB_CONTAINER -Value "${PROJECT_SLUG}-db"
Set-Variable -Name SSL_CERTIFICATE_DIRECTORY -Value "./nginx/certs/"
Set-Variable -Name SSL_CERTIFICATE_PATH -Value "${SSL_CERTIFICATE_DIRECTORY}localhost+2.pem"
Set-variable -Name POSTGRES_PASSWORD_PATH -Value "./secrets/postgres_password.txt"
Set-variable -Name POSTGRES_USER_PATH -Value "./secrets/postgres_user.txt"

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

Function Start-ComposeStack {
    Publish-RequiredFiles

    Invoke-DockerComposeForDevelopment up -d $args
}
Set-Alias -Name dcup -Value Start-ComposeStack

Function Stop-ComposeStack { Invoke-DockerComposeForDevelopment down }
Set-Alias -Name dcdown -Value Stop-ComposeStack

Function Clear-DockerResources {
    <#
        .SYNOPSIS
        Stop the compose stack and clear all Docker resources associated with this project
     #>

    if ($(Read-Host -Prompt "Are you sure you want to stop the Compose stack and remove all associated resources? (y/n)?") -eq "y")
    {
        Stop-ComposeStack

        # Clear all images of which the repository name contains PROJECT_SLUG
        docker image rm $(docker images --format "{{.Repository}}:{{.Tag}}" | grep ${PROJECT_SLUG})

        # Clear all volumes of which the name contains PROJECT_SLUG
        docker volume rm $(docker volume ls --format "{{.Name}}" | grep ${PROJECT_SLUG})

        # Clear all networks of which the name contains PROJECT_SLUG
        docker network rm $(docker network ls --format "{{.Name}}" | grep ${PROJECT_SLUG})
    }
    else {
        Write-Output "Aborted"
    }
}

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
Set-Alias -Name runmigrations -Value Invoke-Migrations

Function Build-ProductionImage {
    <#
        .SYNOPSIS
        Builds the Docker image for production use
    #>
    docker build -t ${PROJECT_SLUG}/app-run-production:1.0.0 --target production --progress plain --pull .
}
Set-Alias -Name buildprod -Value Build-ProductionImage

Function Publish-RequiredFiles {
    <#
        .SYNOPSIS
        Publishes all files that are required to run the application with `dcup`
    #>

    if (-not(Test-Path -Path ${SSL_CERTIFICATE_PATH})) {
        New-SslCertificate
    }

    if (-not(Test-Path -Path ${POSTGRES_PASSWORD_PATH})) {
        Set-Content ${POSTGRES_PASSWORD_PATH} $(New-RandomPassword -Length 20 -ExcludeSpecialCharacters)
    }

    if (-not(Test-Path -Path ${POSTGRES_USER_PATH})) {
        Set-Content ${POSTGRES_USER_PATH} "appuser"
    }
}

Function New-SslCertificate {
    try {
        mkcert -install
        Start-Process -FilePath mkcert -ArgumentList "localhost", "0.0.0.0", "127.0.0.1" -WorkingDirectory ${SSL_CERTIFICATE_DIRECTORY}
    }
    catch {
        Write-Output "mkcert not found. See https://github.com/FiloSottile/mkcert for installation instructions."
    }
}

Function New-RandomPassword {
    <#
        .Synopsis
        This will generate a new password in Powershell using Special, Uppercase, Lowercase and Numbers.  The max number of characters are currently set to 79.
        For updated help and examples refer to -Online version.


        .NOTES
        Name: New-RandomPassword
        Author: theSysadminChannel
        Version: 1.0
        DateCreated: 2019-Feb-23


        .LINK
        https://thesysadminchannel.com/generate-strong-random-passwords-using-powershell/ -

        .EXAMPLE
        For updated help and examples refer to -Online version.
    #>

    [CmdletBinding()]
    param(
        [Parameter(
            Position = 0,
            Mandatory = $false
        )]
        [ValidateRange(5, 79)]
        [int]    $Length = 16,

        [switch] $ExcludeSpecialCharacters
    )

    BEGIN {
        $SpecialCharacters = @((33, 35) + (36..38) + (42..44) + (60..64) + (91..94))
    }

    PROCESS {
        try {
            if (-not $ExcludeSpecialCharacters) {
                $Password = -join ((48..57) + (65..90) + (97..122) + $SpecialCharacters | Get-Random -Count $Length | ForEach-Object { [char]$_ })
            }
            else {
                $Password = -join ((48..57) + (65..90) + (97..122) | Get-Random -Count $Length | ForEach-Object { [char]$_ })
            }
        }
        catch {
            Write-Error $_.Exception.Message
        }
    }

    END {
        Write-Output $Password
    }
}
