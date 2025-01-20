---
layout: post
title: Configure JupyterHub to use AWS Cognito
date: 2021-11-04
categories: [DEVOPS]
tags: [aws, cognito, jupyterhub]
image:
  path: "/assets/img/jupyter-hub.webp"
  alt: 'Configure JupyterHub to use AWS Cognito'
---
There is the official documentation from JupyterHub on how to configure AWS Cognito but whatever I did, ended in Too Many Redirect URL (probably I was not doing something that is expected). Anyhow while reading a lot of documentation and forums I found a way that worked for me so just sharing my setup for anyone out there who might be in the same situation.

# Create Cognito Pool

Follow this link to create AWS Cognito User Pool  
[https://docs.aws.amazon.com/cognito/latest/developerguide/getting-started-with-cognito-user-pools.html](https://docs.aws.amazon.com/cognito/latest/developerguide/getting-started-with-cognito-user-pools.html)

# Update systemd service environment with AWS Cognito Domain

Edit this file /etc/systemd/system/jupyterhub.service and add following to it:

```bash
[Service]  
Environment=AWSCOGNITO_DOMAIN=”<your_cognito_sub_domain>.auth.us-east-1.amazoncognito.com”
```
Then execute the following commands:
```bash
systemctl daemon-reload
systemctl restart jupyterhub
```
# Create awscognito.py configuration

Create this file /opt/tljh/config/jupyterhub_config.d/awscognito.py and add the following piece of code to it:

```python
c.AWSCognitoAuthenticator.client_id = "[your app client ID]"
c.AWSCognitoAuthenticator.client_secret = "[your app client secret]"
c.AWSCognitoAuthenticator.oauth_callback_url = "https://[your-jupyterhub-host]/hub/oauth_callback"
c.AWSCognitoAuthenticator.authorize_url = "https://your-AWSCognito-domain/oauth2/authorize"
c.AWSCognitoAuthenticator.token_url = "https://your-AWSCognito-domain/oauth2/token"
c.AWSCognitoAuthenticator.userdata_url = "https://your-AWSCognito-domain/oauth2/userInfo"
c.AWSCognitoAuthenticator.logout_redirect_url = "https://your-AWSCognito-domain/oauth2/logout"
```

Then reload the jupyterHub config by doing  `tljh-config reload`

After authenticating via Cognito you’re redirected to your notebook tree.

If you see a 403 forbidden error then you need to add your Cognito user to the allowed user list:  `tljh-config add users.allowed <username>`  you can also add user to the admin list:  `tljh-config add users.admin <username>`. 
Finally, do a  `tljh-config reload`.

Hope this helps a greater audience.
