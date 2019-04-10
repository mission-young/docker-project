# data-analysis-software-hub

## Contents

1. python3
2. jupyter
3. root6
4. qt5
5. geant4

and other useful software such as qt-creator, tmux and so on.

## Usage

### for macOS
1. download [docker](https://www.docker.com/get-started) software
2. download docker image by following command 
```bash
docker pull yfs2018/jupyroot
```
3. install pre-requirement software packages.
```bash
brew cask install xquartz
brew install socat
```
4. forward x11 socket
```bash
# only run once
socat TCP-LISTEN:6000,reuseaddr,fork UNIX-CLIENT:\"$DISPLAY\"
```
5. get macOS's ip for display
```bash
# en0 maybe replaced by other network card name 
export MAC_IP=$(ifconfig en0 | grep inet | awk '$1=="inet" {print $2}')
```
6. add X11 authority
```bash
# [] means that you can ignore this parameter
xhost + [$MAC_IP]
```
