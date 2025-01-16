---
layout: post
title: CI/CD using Gitlab, AWS, EKS, Kubernetes, and ECR
date: "2020-01-07"
categories: [DEVOPS]
tags: [gitlab, aws, ecr, eks, kubernetes, k8s, devops]
image:
  path: "/assets/img/gitlab-aws.webp"
  alt: 'CI/CD using Gitlab, AWS, EKS, Kubernetes, and ECR'
---
Introduction: We recently deployed an EKS Cluster for our Streaming App. And we have been using GitLab for quite some time. We were using Ansible roles to deploy our applications in staging and production environments. But we wanted to try something native to Gitlab CI/CD.

## Assumptions:  
_1. You have a basic understanding of all technologies included in the title of this article.  
2. You have already deployed applications in your Kubernetes cluster as deployment and they are working fine.  
3. CI/CD will be triggered only if your commit is_ [_tagged_](https://git-scm.com/book/en/v2/Git-Basics-Tagging) _with a version number._

## Gitlab Kubernetes Integration
Okay so let’s start first configure GitLab integration with Kubernetes Cluster. I simply followed this documentation:  [https://docs.gitlab.com/ee/user/project/clusters/add_remove_clusters.html#existing-eks-cluster](https://docs.gitlab.com/ee/user/project/clusters/add_remove_clusters.html#existing-eks-cluster)

Install  **Helm Tiller**  and  **GitLab Runner**  from the same screen.

_Remember we added this cluster at_ **_Group Level_**_. You can choose to add at the_ **_Project Level_** _as well._

## IAM User
Create an IAM user in AWS for accessing ECR. Let’s say  `gitlab`  this user will have only `Programmatic access`. While creating user we will also create a group in the process. This group will have the following permissions:
```
AmazonEKSWorkerNodePolicy  
AmazonEC2ContainerRegistryFullAccess  
AmazonEC2ContainerRegistryReadOnly  
AmazonEC2ContainerServiceFullAccess  
AmazonEKS_CNI_Policy
```
At the end of the above process, we will be provided with a credentials CSV file which we will use later on in creating group-level variables for AWS authentication. This authentication will include authentication to ECR and EKS Cluster.

## Variables
Once we are done with this we can proceed to add variable at group-level.  
Following two variables need to be added for AWS Authentication:
```
AWS_ACCESS_KEY_ID  
AWS_SECRET_ACCESS_KEY
```
![](https://miro.medium.com/v2/resize:fit:1400/1*St5U6lyczohh-PmB5r_Flg.png)

## K8S Access
Configure K8S to allow deployments from  `gitlab`  user which we created above. We will need to modify our  `aws-auth`  `ConfigMap`  defined in  `kube-system`  namespace. We will need to add  `mapUsers:`  section to this file.

```bash
kubectl -n kube-system edit cm aws-auth# Add following sectionmapUsers: |- userarn: arn:aws:iam::<your-aws-accoun-id>:user/gitlabusername: gitlabgroups:- system:masters
```
The sample aws-auth file is  [here](https://raw.githubusercontent.com/sulemanhasib43/docker-awscli-kubectl/master/aws-auth-cm.yml).

## CI/CD
Now we will get to a project where we want to configure our CI/CD.  
Create a gitlab-ci.yml you may follow this  [template](https://raw.githubusercontent.com/sulemanhasib43/docker-awscli-kubectl/master/gitlab-ci.yml).
```yaml
stages:
  - build
  - staging
  - production

variables:
  DEPLOYMENT_NAME: <your-project-name>
  DOCKER_REGISTRY: <your-ecr-registty>/$DEPLOYMENT_NAME

build:
  stage: build
  image: docker:19.03.1
  variables:
    DOCKER_DRIVER: overlay
    DOCKER_HOST: tcp://localhost:2375
    DOCKER_TLS_CERTDIR: ""
  services:
    - docker:19.03.1-dind
  before_script:
    - docker info
    - apk add --no-cache curl jq python py-pip
    - pip install awscli
  script:
    - $(aws ecr get-login --no-include-email --region <your-aws-region>)
    - docker build -t $DOCKER_REGISTRY:$CI_COMMIT_TAG .
    - docker push $DOCKER_REGISTRY:$CI_COMMIT_TAG
  only:
    - tags

.kubectl_config: &kubectl_config
  - aws eks --region <your-aws-region> update-kubeconfig --name <your-aws-cluster-name>

staging:
  image: docker.io/sulemanhasib43/eks:latest
  stage: staging
  variables:
    K8S_NAMESPACE: <your-desired-k8s-namespace>
  before_script: *kubectl_config
  script:
    - kubectl version
    - kubectl -n $K8S_NAMESPACE patch deployment $DEPLOYMENT_NAME -p '{"spec":{"template":{"spec":{"containers":[{"name":"'"$DEPLOYMENT_NAME"'","image":"'"$DOCKER_REGISTRY:$CI_COMMIT_TAG"'"}]}}}}'
  only:
    - tags
```
Finally, as soon we push/update the file`gitlab-ci.yml`  in our git repo, Build and subsequent deployment to staging will be triggered. You can configure production deployment as well with same configuration just change the environment variables.

Hope this helps. Happy DevOps. :)
