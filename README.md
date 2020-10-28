# gcp-poc-tf

Project dedicated to TF configuration.

## Create intiale ressources

First, create GCP généric ressources :

```bash
git clone https://github.com/jpbaruteu/gcp-poc-tf.git
git checkout test_multi_env
cd gcp-poc-tf/init
terraform init
terraform plan -var-file=init.env.tfvars
terraform apply -var-file=init.env.tfvars
```

## Create environment ressources

For dev env :

```bash
git clone https://github.com/jpbaruteu/gcp-poc-tf.git
git checkout test_multi_env
cd gcp-poc-tf/dev
terraform init
terraform plan -var-file=dev.env.tfvars
terraform apply -var-file=dev.env.tfvars
```

For review env :

```bash
git clone https://github.com/jpbaruteu/gcp-poc-tf.git
git checkout test_multi_env
cd gcp-poc-tf/review
terraform init
terraform plan -var-file=review.env.tfvars
terraform apply -var-file=review.env.tfvars
```
