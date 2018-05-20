---
layout: post
title:  "How to properly set up node-red with nginx"
date:   2016-06-17 13:00:00 +0200
---
{::comment}
vim: set fo=aw2tq, tw=120, spelllang=en
{:/comment}

[node-red](http://nodered.org/) is a great visual tool for wiring workflows.
There are [tons](http://flows.nodered.org/) of *nodes* that you can install to
make it do all kinds of things.

Installation for testing purposes is also easy:

1. node-red is based on node.js. Therefore [install
   node.js](https://nodejs.org/en/download/package-manager/) if you
   haven’t already. Currently, you should use version 4.x for node-red to work
   properly. Installing node.js also installs its `npm` package manager.
2. Run `sudo npm install -g node-red`
3. Start node-red it by running `node-red`. Now you can access the interface at
   [http://localhost:1880/](http://localhost:1880/).

Done. Right? Well, read on if you want to properly set it up beyond testing
purposes. First of all, you may want to [set up an admin
password](http://nodered.org/docs/security), as there is no security whatsoever
by default.

## Setting up HTTPS

When you start node-red for the first time, it creates a default configuration
file for you, `~/.node-red/settings.js`. In there, you will find settings to
enable HTTPS by itself - ignore those. By using the built-in mechanism for
HTTPS, you have to choose between running node-red as root (so that it can read
your certificate and private key) or making the private key readable for
non-root users. We want to do neither.

We will solve this problem by setting up [nginx](https://www.nginx.com/) as a
proxy that will handle HTTPS for us. It will forward all requests to node-red,
which will run on a non-privileged port using HTTP, that is only locally
reachable.

1. Get a SSL/TLS certificate. If you don’t have one, you can get one using
[Let's Encrypt](https://letsencrypt.org/). For the sake of the example, we’ll
assume you have a Let’s encrypt certificate from here on.
2. Configure node-red to only accept requests from localhost. Edit
`~/.node-red/settings.js` and enable the option `uiHost: "127.0.0.1"`.
3. Install nginx if you haven’t already, and add a server block, for example in
the default site file `/etc/nginx/sites-available/default`. Replace
*yourhostname.com* with your host name.
{% highlight nginx linenos %}
server {
  listen 443 ssl;
  ssl on;
  ssl_certificate /etc/letsencrypt/live/yourhostname.com/fullchain.pem;
  ssl_certificate_key /etc/letsencrypt/live/yourhostname.com/privkey.pem;
  ssl_verify_depth 3;
  ssl_protocols TLSv1.1 TLSv1.2;
  ssl_ciphers "ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-SHA384:ECDHE-RSA-AES256-SHA384:ECDHE-ECDSA-AES128-SHA256:ECDHE-RSA-AES128-SHA256";

  location / {
    proxy_pass http://localhost:1880;
    proxy_set_header X-Real-IP $remote_addr;

    proxy_http_version 1.1;
    proxy_set_header Upgrade $http_upgrade;
    proxy_set_header Connection "upgrade";
  }
}
{% endhighlight %}

(Re-)start node-red and nginx (e.g., `service nginx start`).

Let’s quickly explain what that all means. In lines 2-3 we instruct nginx to
open the HTTPS port. Lines 4-5 configure the certificate. Lines 6-8 instruct
nginx to only use the modern protocols and cypher suites, see [Mozilla’s
Security/Server Side TLS](https://wiki.mozilla.org/Security/Server_Side_TLS)
page for more information. In short, we value security higher than
compatibility with older clients. Lines 10-17 set up the proxy that will
forward the traffic to node-red. Lines 14-16 enable WebSocket upgrade requests.
Without theses three lines, node-red will work for a few seconds an then
display an error message like *Lost connection to server*.

Note that we have not configured forwarding or rewriting from HTTP to HTTPS,
i.e., you now need to explicitly open `https://yourhostname.com`.

<div><hr/></div>

Please go [here](https://github.com/atextor/atextor.github.com/issues/2) to
comment this article.
