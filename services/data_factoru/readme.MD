# How to Execute

'''
cd /Users/Siddu/Documents/D_O_C_S/SourceCode/pinnatum/dps/services/data_factoru

terraform init \
  -backend-config="bucket=terraform-pinnatum-state-bucket" \
  -backend-config="key=dev/data_factory.tfstate" \
  -backend-config="region=eu-west-2"


terraform plan  --var-file=envvars/dev.tfvars

terraform apply  --var-file=envvars/dev.tfvars

'''