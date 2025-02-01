# Azure Entra ID Groups membership visualization

This project provides a visualization tool for the Azure Entra ID Groups membership .

The solution consists of an automation running in one Azure Function App that retrieves the 
Users and Groups from Azure Entra ID using a Service Principal Account (App Registration), 
and stores the data as CSV files in one Storage Account.
One React application configured with the React-Sigma library, retrives the data from the Storage 
Account and visualize the Users and the Groups membership. The application is packaged in 
one Docker image and runs in one Azure App Service. 

## Configuration

- Assign the RBAC roles "Contributor", "User Access Administrator", "Key Vault Secrets Officer", "AcrPush" to the User account on the Subscription level.
- Create the file `terraform.tfvars` with the values for the Terraform variables.

```sh
location                  = "<azure_region>" # e.g. "westeurope"
location_abbreviation     = "<azure_region_abbreviation>" # e.g. "weu"
environment               = "<environment_name>" # e.g. "test"
subscription_id           = "<azure_subscription_id>"
tenant_id                 = "<azure_tenant_id>"
allowed_ip_address_ranges = [<list_of_allowed_ip_address_ranges>] # Public IP Address ranges allowed to access the Azure resources e.g. "1.2.3.4/32"
allowed_ip_addresses      = [<list_of_allowed_ip_addresses>] # Public IP Addresses allowed to access the Azure resources  e.g. "1.2.3.4"
tags                      = {}
```

- Create one App Registration in Azure Entra ID.
- Grant the API Permissions Microsoft Grath "User.Read" and "Group.Read" to the App Registration.
- Create the file `secret/main.json` with the following content:

```sh
{
  "service_principal_account_name": "<application_id>",
  "service_principal_account_secret": "<secret>"
}
```

Before proceeding with the next sections, open a terminal and login in Azure with Azure CLI using the User account.

## Terraform Project Initialization

```sh
terraform init -reconfigure
```

## Verify the Updates in the Terraform Code

```sh
terraform plan -var-file="./secret/main.json"
```

## Apply the Updates from the Terraform Code

```sh
terraform apply -var-file="./secret/main.json" -auto-approve
```

## Format Terraform Code

```sh
find . -not -path "*/.terraform/*" -not -path "*/function/*" -type f -name '*.tf' -print | uniq | xargs -n1 terraform fmt
```
