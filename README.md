# BOOM

## Prerequisites
* Install [Corona-SDK](https://coronalabs.com/).

## Running the game
* Run Corona Simulator.
* Click `Open Project` and open `BOOM/main.lua`.

## Building the game
* Run Corona Simulator.
* Click `Open Project` and open `BOOM/main.lua`.
* Click `File` from the window menu.
* Select target platform from the `Build` menu.
* Configure as required.
* Click `Build`.

## Code Style
WIP, open to suggestions.

## Static Analysis

### Prerequisites
* Install docker and docker-compose (Installation differs per platform).
  * If running older versions of Mac or Windows 10 home or lower, install [Docker-Toolbox](https://docs.docker.com/toolbox/overview/).
* Make sure the repo is checked out in your home/user folder or docker may not work correctly.
* Navigate to the root folder of the BOOM repo in your terminal (same folder as `docker-compose.yaml`).
  * Windows and Mac may have dedicated terminals you need to use.
* Build the image (only needs to be done once):
```
docker-compose build .
```
* Run the container:
```
docker-compose run stylecheck
```
