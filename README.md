# Vacks Gaming project.

This Project is my personal gaming AWS VPC. Where I'll be hosting my personal dedicated servers


## Server Folder

This folder will contain steps/scripts per dedicated server.

### Valheim Server

As of now the only server hosted by me it's called Dante's Server - which map name is genesis.

### Worlds location: 

``` $HOMEDIR/.config/unity3d/IronGate/Valheim/worlds ```

### Docker Build 

``` docker build -t {tagName} --build-arg A_SERVER_NAME="My Server name"  --build-arg A_WORLD_NAME="myworld" --build-arg A_PASSWORD="secret" ```

If you want to run it locally 

``` docker run -d --name valheim -v my/target/worlds/folder:/home/steam/.config/unity3d/IronGate/Valheim/worlds {tagName} ```

Running example: 

``` docker run -d --name valheim -v /home/ngel/valheim:/home/steam/.config/unity3d/IronGate/Valheim/worlds -p 2456:2456/udp -p 2456:2456/tcp valheim:latest ```

## Infrastructure folder 

This folder will contain terraform (IaC) templates to build the VPC from scratch in an AWS account.


### Authors
Angel Castro - bitbucket username:  angel_castro_basurto
