## PARETOS 


## Summary
 This project uses terraform and helm to create and deploy eks cluster containing pgadmin app

## Requirements
* Terraform Cloud Workspace
* Terraform CLI
* AWS CLI
* Helm CLI
* Kubectl CLI


## DEV AND PROD ENVIRONMENTS
  In this project, I used terraform workspace to create 2 seperate similar environments `DEV AND PROD`  because of how terraform uses tfstate to store passwords as a base64encode string,  safely hides my sensitive information from public infacts hides the tfstate file from the public. I also created terraform modules to create the exact infrastructure for both DEV and PROD environment, this will ensure we have confidence that for any app that runs in in this case the DEV environment will perfectly work in the PROD environment


## INFRA
 The infrastructure contains 2 private and 2 public subnets each in a different availability zone. My EKS nodes are in the private subnets together with my postgres instance. Below is the design for the infrastructure
 ![infra_chart](./infra.png?raw=true "Title")  


## PDADMIN
 Below contains visuals to verify that PGADMIN deployed in EKS Cluster was able to interract with postgres instance
 ![pgadmin](./pgadmin.png?raw=true "pgadmin") 
 ![pgadminh](./homepage.png?raw=true "pgadmin") 
 ![pgadminh](./database.png?raw=true "pgadmin")   


## SECURITY
  Eventhough the infrastructure I built is Security resilience because I used proper security groups, subnets, route tables etc but to enhanced security of the environments here is what I would do
  * Amazon RDS encryption
  Data should be always encrypted at rest
  * AWS IAM 
  We should control who should create, update, modify our infrastructure by using the right roles and policies
  * Secure Socket Layer (SSL) or Transport Layer Security (TLS)
  To encrypt connections from our PGADMIN to our RDS Instances
  * API and User Activity Logging with AWS CloudTrail.
  To understand who make api calls and user activity
  * To secure kubernetes however
    * Cluster Authentication and Authorization
      To authenticate and authorize who get accessed to the cluster basically using IAM's webhook tokens
    * Control Plane Monitoring
      Especially for the api server so we get to know api calls
    * Scan the docker containers
      Scan docker containers for any vulnerability
    * Run containers without priviledges
      Run the container as a non root user and configure the pod configuration, because if otherwise and the container was hacked, the hacker, because of the container running with priviledges can access and control the whole cluster easily., but doing this will make the process difficult for the hacker to control the cluster
    * Using network policies
      To control which pod can talk to which other pods, and the pods which they can receive traffic because kubernetes default is letting all pods communicate which each other when an attacker access a pod, he could gain control of all other pods, but this will prevent that

## Manually perfom operations
  * Make sure you have an account with terraform cloud, if no use this link https://cloud.hashicorp.com/products/terraform I used this to    logically seperate the DEV and PROD environments
  * Configure aws cli with proper credentials, this is certainly needed to help us deploy applications in EKS
  * Create an organization named `paretos` and two workspaces within the organization `DEV`, `PROD`
  * in your respective workspaces, create a variable `db_username` and `db_password` give them a value. These are your postgres username and password make sure also to configure `AWS_SECRET_ACCESS_KEY` `AWS_REGION` `AWS_ACCESS_KEY_ID` in the workspace variables
  * To deploy the dev env cd into the dev directory and run `terraform init` and `terraform apply`
  * To deploy the prod env cd into the prod directory and run `terraform init` and `terraform apply`
  * You must update the kubeconfig using `aws eks update-kubeconfig --name eks` `eks` is the name of the cluster to have access to your cluster
  * To deploy helm, cd into the helm directory and then `helm install paretos paretos`
  * I expose the application using a loadbalancer
  * The default username for the pgadmin app is `bashirsuleiman77@gmail.com`, password is `bashirsuleiman` you can change that by editing the `values.yaml` in `helm/paretos` 



