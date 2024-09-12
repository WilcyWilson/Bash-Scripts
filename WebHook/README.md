### Webhook
Webhook is a lightweight configurable tool written in Go, that allows you to easily create HTTP endpoints (hooks) on your server, which you can use to execute configured commands. 

### Setup
Install on Ubuntu/Debian

```console
orangepi@orangepi3b:~$ sudo apt-get install webhook
```
We need to create webhook.conf to run this as a service.  webhook.conf json file is a configuration file. This file will contain an array of hooks the webhook will serve. 

```console
orangepi@orangepi3b:~$ sudo nano /etc/webhook.conf
```

Create a bash script to run. Also change permission of the file to be executable with "chmod +rwx filename".

/path/to/webhook -hooks hooks.json -verbose in case you need to debug



