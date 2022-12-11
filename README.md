## Exploring automation with Terraform and Github

This is a small project for learning purposes. The idea is to automate deploying two-stage 
environment (production and staging) in AWS with Terraform. I rely on the directory structure
to work with multiple environments. 
There is `s3_backend` directory which enables to autoconfigure external S3 backend for Terraform.

Project structure:
* `global` - common resources and data
* `production` - production environment, Route53 routes to base address, e.g. `marcinbyra.com`
* `staging` - staging environment, Route53 routes to staging address, e.g. `staging.marcinbyra.com`
* `s3_backend` - useful for automatic creation of AWS resources for Terraform S3 Backend

### Architecture:
![](./web-app-module/architecture.png)


### Notes
* if you already have a hosted zone, change resource to data in `global`

### TODO
* HTTP server not accessible on instances, check user data or vpc config
* work with github automation (in .github directory)