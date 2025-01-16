---
layout: post
title: 'GitLab Automation: Initial Root Password & Token Generation'
date: 2025-01-16 10:53 +0500
categories: [DEVOPS]
tags: [gitlab, docker, cloudformation, automation, bash]
image:
  path: "/assets/img/gitlab-ci-cd-pipeline.webp"
  alt: 'gitlab initial root password in CI/CD Pipelines'
---

So when automating infrastructure one of the core infra component is CI/CD. We all know GitLab is a champion in many areas e.g VCS, CI/CD Pipelines to name a few. I was building a Cloud Formation Template for one of the DataOps solutions that my company offers and for that we wanted to automate the Gitlab Installation process as part of the CloudFormation template.

We are using an EC2 Instance where we are provisioning these instances using userData. And GitLab is launched as a docker container.

> The challenge for me was to automate the initial root password and generate a token for that user so it can be used later on in uploading DataOps repos/pipelines to GitLab Instance.

## **Tech Stack**

GitLab Version: 13.12.1

Docker Client:  
Version: 20.10.4  
API version: 1.41  
Go version: go1.15.8  
Git commit: d3cb89e  
Built: Mon Mar 29 18:54:36 2021  
OS/Arch: linux/amd64  
Context: default  
Experimental: true

Docker Server:  
Engine:  
Version: 20.10.4  
API version: 1.41 (minimum version 1.12)  
Go version: go1.15.8  
Git commit: 363e9a8  
Built: Mon Mar 29 18:55:03 2021  
OS/Arch: linux/amd64  
Experimental: false  
containerd:  
Version: 1.4.4  
GitCommit: 05f951a3781f4f2c1911b05e61c160e9c30eaa8e  
runc:  
Version: 1.0.0-rc93  
GitCommit: 12644e614e25b05da6fd08a38ffa0cfe1903fdec  
docker-init:  
Version: 0.19.0  
GitCommit: de40ad0

## Initial Root Password

I tried (No luck):
```bash
docker exec gitlab gitlab-rails runner "user = User.where(id:1).first; user.password = 'gitlab_root_password'; user.password_confirmation = 'gitlab_root_password'; user.save!"
```

Then I tried (again No luck):

```bash
echo "external_url 'https://my.domain.com/'" > gitlab.rb  
echo "gitlab_rails['initial_root_password'] = 'gitlab_root_password'" >> gitlab.rb
```

Created  `gitlab.rb`  with the above content and mounted it to GitLab at the first start no luck there as well. BUT.

**Finally, this worked:**

```bash
docker run -d  \-v $GITLAB_HOME/config:/etc/gitlab \-v $GITLAB_HOME/logs:/var/log/gitlab \-v $GITLAB_HOME/data:/var/opt/gitlab \--hostname example.com \-p 443:443 -p 80:80 -p 2222:22 \-e GITLAB_ROOT_EMAIL="root@local" -e GITLAB_ROOT_PASSWORD="gitlab_root_password" -e EXTERNAL_URL="http://example.com" \--name gitlab --restart unless-stopped gitlab/gitlab-ce:latest
```
Now you won't’ be asked to set up a root password. This helps a lot when automating infra solutions.

## Token Generation

For a token generation, I simply used the following  `docker exec`  command in conjunction with  `gitlab-rails runner`  :

docker exec gitlab gitlab-rails runner "token = User.find_by_username('root').personal_access_tokens.create(scopes: [:api, :sudo], name: 'Automation Token'); token.set_token('TwentyCharacterToken.'); token.save"

I used  `root`  as user name and  `api and sudo`  as scopes. I also named token as  `Automation Token`  and finally set a  `TwentyCharacterToken`  which we can use later on in our git operations.

I hope this helps a lot of people.
