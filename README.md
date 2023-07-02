# Easy Buggy Java Application

## **Overview of the project**
EasyBuggy is a broken web application to understand the behavior of bugs and vulnerabilities. This repository is created to experience CI/CD knowledge and gain a good understanding of security tools.

> **_NOTE:_**  **Java code** used in this project was cloned from [k-tamura](https://github.com/k-tamura/easybuggy), all thanks to [k-tamura](https://github.com/k-tamura/easybuggy). <br> </br>

**Table of contents**
=================

* [Easy Buggy Java Application](#easy-buggy-java-application)
    * [Overview of the project](#overview-of-the-project)
    * [Table of Contents](#table-of-contents)
    * [Project structure](#project-structure)
* [Tools used](#tools-used)
* [Installation and project setup](#installation-and-project-setup)
    * [Pre installation](#pre-installation)
    * [Installation and setup](#installation-and-setup)
        * [Jenkins tools](#jenkins-tools)
        * [Jenkins plugins](#jenkins-plugins)
        * [Credentials](#credentials)
    * [Project](#project)

## **Project structure**
```
.
├── JenkinsServerSetup
│   ├── ec2
│   │   ├── get_server_ip.sh
│   │   ├── iam.tf
│   │   ├── locals.tf
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   ├── templates
│   │   │   ├── JenkinsAccessPolicy.json
│   │   │   └── JenkinsAssumepolicy.json
│   │   ├── terraform.tfstate
│   │   ├── terraform.tfstate.backup
│   │   ├── terraform.tfvars
│   │   └── variables.tf
│   ├── inventory.txt
│   └── playbook.yaml
├── Jenkinsfile-ci-cd
├── LICENSE
├── README.md
├── dockerfile
├── k8s-manifest-files
│   ├── application-manifest.yaml.tpl
│   └── ecr-credentials.yaml
├── pom.xml
└── src
    └── Java code
```

Some explanations regarding structure:
- `JenkinsServerSetup/ec2` folder is for bootstrapping and configuring the Jenkins server.
- `jenkinsfile-ci-cd` file is for defining the continuous integration / continues deployment process.
- `dockerfile` is used by the Jenkins pipeline to build images with the source code build artifact.

## **Tools used**
- [Git](https://git-scm.com/docs)
- [Jenkins (CI/CD)](https://www.jenkins.io/doc/book/pipeline/)
- [Ansible (Configuration)](https://docs.ansible.com/ansible/latest/index.html)
- [Maven (Build Java artifacts)](https://maven.apache.org/guides/getting-started/maven-in-five-minutes.html)
- [SonarQube - SonarCloud (Source code analysis)](https://sonarcloud.io/explore/projects)
- [Snyk (Source composition analysis)](https://snyk.io/)
- [Docker (Build images)](https://docs.docker.com/engine/reference/commandline/docker/)
- [Kubernetes (Container orchestration)](https://kubernetes.io/docs/reference/kubectl/cheatsheet/)

## **Installation and project setup**

### **Pre installation**
- Install [Git](https://git-scm.com/download/linux), [python](https://www.python.org/downloads/source/), [Ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html), [Terraform](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli) & [AWS CLI V2](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html) in your local workspace machine and configure the settings accordingly.
```
sudo yum install git yum-utils python pip -y && \ 
sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo && \
sudo yum -y install terraform && \
python3 -m pip install --user ansible
```
**NOTE**: AWS CLI V2 is NOT required if you are running from Amazon Linux Machines. We would get that installed by default. It is recommanded to use EC2 an instance to deploy infrastructure on AWS to take advantage of [ROLES](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles.html).

- Setup a [SonarCloud](https://sonarcloud.io/explore/projects), [Snyk](https://snyk.io/) account.
- Configure AWS credentials through IAM users or roles.
- Setup your SSH key in your local workspace at location `~/.ssh/id_rsa`

### **Installation and setup**
Clone the source repository to the local workspace.
```
Git clone https://github.com/SubrahmanyamRaparti/easy-buggy-application.git && cd easy-buggy-application/JenkinsServerSetup/ec2
```
Execute the command so terraform would Initialize the backend, download / install modules & provider plugins.
```
terraform init
```
Execute `terraform plan` command to get a quick glimpse of what resources would get deployed on to AWS and the output gets stored in the infra.tfplan file.
```
terraform plan -out infra.tfplan
```
Apply the changes. This would launch a Linux server and install tools and software like Java, Jenkins, Docker, EKSCTL, KUBECTL & ZAP.
```
terraform apply -auto-approve infra.tfplan
```
SSH onto the Jenkins server and fetch the initial password and follow the steps provided by Jenkins.
```
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
```
**NOTE** Setup a Kubernetes environment. Use [Script](https://gist.github.com/4635760a1266a34c258b3615b050326e.git) to install the kubernetes using the Kuberadm way onto an Amazon linux server.

Once the setup is complete. install the below tools & plugins.

## **Jenkins tools**
Configure the below tools in Jenkins under `Dashboard/Manage Jenkins/Tools` section.
- Maven
- snyk

## **Jenkins plugins**
Install the below plugins
- Docker plugin
- Docker Pipeline
- Snyk Security

## **Credentials**
- Sonar Cloud credentials id `sonar_credentials`. Use the username and password kind to provide the credentials. Username should be project key and create a token for password.
- Snyk credentials id `snyk_api`. Use the Snyk API token kind to provide the snyk API token.
- Confiure kubernetes

## **Project**
- Use a multibrach pipeline item to configure the project.
- Provide the repository URL under `Branch Sources` configuration section.
- Click on `Scan Multibranch Pipeline Now` to run the pipeline.