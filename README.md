# gcp-poc-tf

Project dedicated to TF configuration.  
This project create GCP ressources for 3 environments (prod, dev and review):
- Cloud Run
- Clourd Build
- Cloud SQL
- Service account

You will be able to automatically trigger a cloud build after each commit and deploy your application on Cloud Run.

## Create intiale ressources

First, create GCP Prod env :

```bash
git clone https://github.com/jpbaruteu/gcp-poc-tf.git
cd fr-gcp-pov-ubaldi2-repository/prod
terraform init
terraform plan -var-file=prod.env.tfvars
terraform apply -var-file=prod.env.tfvars
```

## Create environment ressources

For dev env :

```bash
cd fr-gcp-pov-ubaldi2-repository/dev
terraform init
terraform plan -var-file=dev.env.tfvars
terraform apply -var-file=dev.env.tfvars
```

For review env :

```bash
cd fr-gcp-pov-ubaldi2-repository/review
terraform init
terraform plan -var-file=review.env.tfvars
terraform apply -var-file=review.env.tfvars
```

## Create a new environment

Duplicate dev directory and rename `dev.env.tfvars` into `<env>.env.tfvars`. Update the content :

```
environment = "<env>"
```

Deploy <env> into GCP:

```bash
git clone https://github.com/jpbaruteu/gcp-poc-tf.git
git checkout test_multi_env
cd gcp-poc-tf/<env>
terraform init
terraform plan -var-file=<env>.env.tfvars
terraform apply -var-file=<env>.env.tfvars
```
