## Purpose

Project dedicated to TF configuration.  
This project create GCP ressources for 3 environments (prod, dev and review):
- Cloud Run
- Cloud Build
- Cloud SQL
- Service account

You will be able to automatically trigger a cloud build after each commit and deploy your application on Cloud Run.

## Create intiale ressources

First, create GCP Prod env :

```bash
git clone https://github.com/jpbaruteu/gcp-poc-tf.git
cd gcp-poc-tf/prod
terraform init
terraform plan -var-file=prod.env.tfvars
terraform apply -var-file=prod.env.tfvars
```

## Create specific environment ressources

For dev env :

```bash
cd gcp-poc-tf/dev
terraform init
terraform plan -var-file=dev.env.tfvars
terraform apply -var-file=dev.env.tfvars
```

For review env :

```bash
cd gcp-poc-tf/review
terraform init
terraform plan -var-file=review.env.tfvars
terraform apply -var-file=review.env.tfvars
```

## Deploy application into GCP

Now, environments are created into GCP.  
You can get source of a test application from the following repository and deploy it on each env : `https://github.com/jpbaruteu/gcp-poc.git`

Each cloud build is mapped to a branch with the same name (cloud build "dev" <> branch "dev").

To deploy the application :
- Create each branches (dev, review, prod) into your GCP repository created juste before
- Push test application code on `dev` branch. This inital commit will deploy application on dev env.
- Merge `dev` branch into `review` branch and `review` into `prod` to deploy on review and then on prod.

Each commit on a branch automatically trigger a build and deploy application on the corresponding environment.

## Create a new environment

Duplicate dev directory and rename `dev.env.tfvars` into `<env>.env.tfvars`. Update the content :

```
environment = "<env>"
```

Deploy <env> into GCP:

```bash
git clone https://github.com/jpbaruteu/gcp-poc-tf.git
cd gcp-poc-tf/<env>
terraform init
terraform plan -var-file=<env>.env.tfvars
terraform apply -var-file=<env>.env.tfvars
```

Create `<env>` branch into GCP repository.
