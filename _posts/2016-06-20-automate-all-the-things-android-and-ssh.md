---
layout: post
title:  "Automate All The Things: Android and SSH"
date:   2016-06-20 17:30:00 +0200
---
{::comment}
vim: set fo=aw2tq, tw=120, spelllang=en
{:/comment}

This post will describe how you can set up the automation app 
[Tasker](https://play.google.com/store/apps/details?id=net.dinglisch.android.tasker) on android to 
run a command on a remote host via SSH, without the need to enter a password. We will discuss two 
options: The first one will just run a command, the second one can additionally return a value, but 
will require a paid plug-in.

## Option 1: Run a remote command via ConnectBot

1. Install the free SSH client 
[ConnectBot](https://play.google.com/store/apps/details?id=org.connectbot&hl=en). 
2. We need to set up key-based authentication with ConnectBot, and there are already tutorials on 
that, for example [this one](http://michaelchelen.net/0f3e/android-connectbot-ssh-key-auth-howto/). 
3. When you have set up the connection, long-press the connection in ConnectBot’s host list and 
select `Edit host`. Change the name to some nickname, e.g., *myconnection*. 
4. Configure the post-login automation. Enter the command or script you’d like to run followed by a 
semicolon, *exit* and enter, e.g.: `/home/me/somescript.sh; exit ↩`. This is to make sure ConnectBot 
just runs the command and returns. 
5. Now let’s use it in Tasker. Create a Task, select `+`, *System*, *Send Intent*. Configure the 
action as follows: 
* Action: `android.intent.action.VIEW`
* Cat: None
* Data: `ssh://user@host:port#myconnection`
* Target: Activity 

When you run the Task, the remote command should execute. Note that for every different command you 
want to run on the host, you need to create a separate profile in ConnectBot, with different 
nicknames.

## Option 2: Run a remote command and return its output to Tasker

This option requires the [SSH Tasker 
Plugin](https://play.google.com/store/apps/details?id=com.laptopfreek0.sshplugin.paid&hl=en). Note 
that there is also a [Lite 
Version](https://play.google.com/store/apps/details?id=com.laptopfreek0.sshplugin) of the plug-in, 
but that one doesn’t execute arbitrary commands.

1. The SSH Plugin can not reuse ConnectBot’s key file format, so we need to create key pair on the 
target host. Log in to the host and run `ssh-keygen -t rsa`. The command will ask where to save the 
file, select one that you will recognize for usage in tasker, e.g., `/home/me/.ssh/id_rsa-tasker`.
When asked for a passphrase, enter a good passphrase.
2. Authorize the key: `cat ~/.ssh/id_rsa-tasker.pub >> ~/.ssh/authorized_keys`
3. Copy the file `~/.ssh/id_rsa-tasker` to you android device somehow. One method is via the free 
[ES File Explorer](https://play.google.com/store/apps/details?id=com.estrongs.android.pop) that also 
allows to copy files via SSH.
4. In Tasker, create a Task, select `+`, *Plugin*, *SSH Plugin Paid*.
5. Configure the Action:
* Enter username and host
* For Keypair File Location, select the `id_rsa-tasker` file that you copied to your device
* For Encrypted Keyfile Password, enter the passphrase you selected during `ssh-keygen`
* Enter the remote command followed by a semicolon
* Switch on “Return Output”
* In the last field, enter the name of a Tasker variable to bind to, e.g., `%result`.
6. Now you can use the local `%result` variable in subsequent actions of the task. The following 
steps are only required, if the executed command returns a line of text, and you need to get rid of 
the trailing newline.
7. After the SSH Plugin action, add a *Variable Set* action, set its name to `%newline` and in its 
value field, enter a literal line break, i.e., press ↩.
8. Add a *Variable Split* action, set its name to `%result` and splitter to `%newline`.
9. Now you will have the result of the command without its trailing newline bound to the variable 
`%result1`.

