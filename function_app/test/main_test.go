package test

import (
	"strings"
	"testing"

	"github.com/gruntwork-io/terratest/modules/azure"
	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestTerraformAzureStorageExample(t *testing.T) {
	t.Parallel()

	// subscriptionID is overridden by the environment variable "ARM_SUBSCRIPTION_ID"
	subscriptionID := "71ae4048-2e46-4255-8eca-c47663aa8f0c"
	uniquePostfix := random.UniqueId()

	// Configure Terraform setting up a path to Terraform code.
	terraformOptions := &terraform.Options{
		// The path to where our Terraform code is located
		TerraformDir: "../",

		// Variables to pass to our Terraform code using -var options
		Vars: map[string]interface{}{
			"postfix": strings.ToLower(uniquePostfix),
		},
	}

	// At the end of the test, run `terraform destroy` to clean up any resources that were created
	defer terraform.Destroy(t, terraformOptions)

	//  Run `terraform init` and `terraform apply`. Fail the test if there are any errors.
	terraform.InitAndApply(t, terraformOptions)

	//  Run `terraform output` to get the values of output variables
	resourceGroupName := terraform.Output(t, terraformOptions, "resource_group_name")
	appName := terraform.Output(t, terraformOptions, "function_app_name")
	appId := terraform.Output(t, terraformOptions, "function_app_id")
	appDefaultHostName := terraform.Output(t, terraformOptions, "default_hostname")
	appKind := terraform.Output(t, terraformOptions, "function_app_kind")

	app := azure.GetAppService(t, appName, resourceGroupName, subscriptionID)
	actualappId := *app.ID
	actualappDefaultHostName := *app.DefaultHostName
	actualappKind := *app.Kind

	AppExists := azure.AppExists(t, appName, resourceGroupName, subscriptionID)
	assert.True(t, AppExists, "App does not exist")
	assert.Equal(t, appId, actualappId)
	assert.Equal(t, appDefaultHostName, actualappDefaultHostName)
	assert.Equal(t, appKind, actualappKind)

}
