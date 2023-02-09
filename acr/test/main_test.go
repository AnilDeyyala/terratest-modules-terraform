package test

import (
	"strings"

	"testing"

	"github.com/gruntwork-io/terratest/modules/azure"
	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestTerraformAzureACRExample(t *testing.T) {
	t.Parallel()

	uniquePostfix := strings.ToLower(random.UniqueId())
	acrSKU := "Premium"

	// Configure Terraform setting up a path to Terraform code.
	terraformOptions := &terraform.Options{
		TerraformDir: "../",
		Vars: map[string]interface{}{
			"postfix": uniquePostfix,
			"sku":     acrSKU,
		},
	}

	// At the end of the test, run `terraform destroy` to clean up any resources that were created
	defer terraform.Destroy(t, terraformOptions)

	// Run `terraform init` and `terraform apply`. Fail the test if there are any errors.
	terraform.InitAndApply(t, terraformOptions)

	//  Run `terraform output` to get the values of output variables
	resourceGroupName := terraform.Output(t, terraformOptions, "resource_group_name")
	acrName := terraform.Output(t, terraformOptions, "container_registry_name")
	loginServer := terraform.Output(t, terraformOptions, "login_server")

	// Assert
	assert.True(t, azure.ContainerRegistryExists(t, acrName, resourceGroupName, ""))

	actualACR := azure.GetContainerRegistry(t, acrName, resourceGroupName, "")

	assert.Equal(t, loginServer, *actualACR.LoginServer)
	assert.True(t, *actualACR.AdminUserEnabled)
	assert.Equal(t, acrSKU, string(actualACR.Sku.Name))
}