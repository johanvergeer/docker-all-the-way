# Docker All The Way

This is the demo code for my talk called "Docker All The Way".

This project contains a PowerShell script with all the commands to run the app, run tests and perform other actions on the images and containers.

This README contains doesn't contain very much information, which is by design. 
(README files aren't maintained very well since they don't break when something changes).
Instead, `activate.ps1` should give a decent understanding of how to get the app up and running.

## Prerequisites

1. [mkcert](https://github.com/FiloSottile/mkcert) must be installed

## Run the app

1. Source the PowerShell script

    ```powershell
    PS> . ./activate.ps1
    ```

2. Run the app

    ```powershell
    PS> dcup
    ```

3. Watch the app in all its glory at http://localhost:8080

## Run the tests

1. The tests use the database, so first run the migrations

    ```powershell
    PS> runmigrations
    ```
   
2. Run the tests

    ```powershell
    PS> test
    ```
   
## Contribute

Feel free to create an issue or pull request when you would like to contribute.
