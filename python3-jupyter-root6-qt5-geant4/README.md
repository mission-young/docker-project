# data-analysis-software-hub

## TODO:
- Write Dockerfile

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
7. run docker
```bash
# the default port of jupyter-notebook webserver is 8888, so $(docker_server_port) can be replaced by 8888, 
# $(host_port) can be any allow port of your host. Notice that in macOS, $(host_path) should be set in docker
# software(GUI) first in case of error like permission.
docker run -it -v $(host_path):$(docker_path) -p $(host_port):$(docker_server_port)  -e DISPLAY=$MAC_IP:0 yfs2018/jupyroot
```
8. something to say

you can visit jupyter-notebook webserver on you host pc by type `localhost:$(host_port)` or `127.0.0.1:$(host_port)` or `$(MAC_IP):$(host_port)`, moreover, visiting the serve by `$(MAC_IP):$(host_port)` on other pc is allowed. By the way, it's necessary to metion that the password of jupyter-server is `data2018`. If you want to save any change of \*.ipynb, please move the file into $(docker_server_port), otherwise all changes will disapper once the docker is closed.

## Unexpected && Solutions
### Xquartz can't lanuch or exit automaticly
When we run x11 apps in host or remote server, it's expected that the x11 server lanuch automaticly. However, in some special occasion, it doesn't work, which drive us to lanch it manually. Besides, it prohibits poweroff or reboot. 

To solve that, just remove it by deleting the app or using `CleanmyMac` or typing `brew uninstall` in terminal, removing  `~/.Xauthrity` directory.

It doesn't seem redundant that run following scripts
```bash
launchctl unload /Library/LaunchAgents/org.macosforge.xquartz.startx.plist
sudo launchctl unload /Library/LaunchDaemons/org.macosforge.xquartz.privileged_startx.plist
sudo rm -rf /opt/X11* /Library/Launch*/org.macosforge.xquartz.* /Applications/Utilities/XQuartz.app /etc/*paths.d/*XQuartz
sudo pkgutil --forget org.macosforge.xquartz.pkg
```
And then, relogin, reinstall xquartz by homebrew, and relogin again.

### port 6000 already in use.
When try to lauch socat server, error like this appears.
```bash
2019/04/03 18:25:55 socat[3029] E bind(5, {LEN=0 AF=2 0.0.0.0:6000}, 16): Address already in use
```
Make sure Xquartz is exited. Check the pid of socat process and kill it.

### Geant4 Opengl error
Opengl is associated with graph driver. It seems no effective solution for now. Maybe nvidia-docker can solve it. However, it's still on the way for exploration.

## Other Questions
### what's DISPLAY? Need I set it in `~/.bash_profile`
Once xquartz installed, DISPLAY was set.
`/private/tmp/com.apple.launchd.xIbRPiCrcx/org.macosforge.xquartz:0`
Therefore, no need for setting `export DISPLAY=localhost:0.0` in `~/.bash_profile`
