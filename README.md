# SuperMario Deployment on AWS EKS

![SuperMario](https://drive.google.com/uc?export=view&id=1904etXwpjhbty7Fhc5mIzF2-_QWJb4_8)

This repository is about deploying Super Mario game on Amazon's Elastic Kubernete Service (EKS) using an infrastructure as a code language Terraform.
The deployment utilize AWS resources like:
- aws_instance
* aws_iam_role
- AWS CLI
It also uses Terraform and Kubectl.

The AWS instance was set up to meet the requirements needed to install the game.
A git repository https://github.com/Aj7Ay/k8s-mario.git with the k8s code was cloned.
The game was finally deployed using the CLI.
