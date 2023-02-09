# terratest-modules-terraform

## Getting Started
Before you begin, you need to have an Azure account and a valid subscription.

### Prerequisites
- Terraform
- Go
- Azure CLI
### Clone the Repository
To clone this repository, run the following command in your terminal:

```bash
git clone https://github.com/AnilDeyyala/terratest-modules-terraform.git
```

### Authenticate with Azure
To authenticate with Azure, you need to set the following environment variables:


```bash
export ARM_CLIENT_ID=<your_client_id>
export ARM_CLIENT_SECRET=<your_client_secret>
export ARM_SUBSCRIPTION_ID=<your_subscription_id>
export ARM_TENANT_ID=<your_tenant_id>
```

You can then run the following command to log in to Azure:

```bash
az login
```

### Running the Tests
To run the tests in the test folder, follow these steps:

1. Navigate to the test folder:
```bash
cd module_name/test
```


2. Initialize the Go module:
```bash
go mod init test
go mod tidy
```


3. Run the tests:
```bash
go test -v
```
