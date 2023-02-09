package test

import (
	"strings"

	"testing"

	"github.com/gruntwork-io/terratest/modules/azure"
	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestTerraformAzureACIExample(t *testing.T) {
	t.Parallel()

	uniquePostfix := strings.ToLower(random.UniqueId())

	// Configure Terraform setting up a path to Terraform code.
	terraformOptions := &terraform.Options{
		TerraformDir: "../",
		Vars: map[string]interface{}{
			"postfix": uniquePostfix,
		},
	}

	// At the end of the test, run `terraform destroy` to clean up any resources that were created
	defer terraform.Destroy(t, terraformOptions)

	// Run `terraform init` and `terraform apply`. Fail the test if there are any errors.
	terraform.InitAndApply(t, terraformOptions)

	// Run `terraform output` to get the values of output variables
	resourceGroupName := terraform.Output(t, terraformOptions, "resource_group_name")
	aciName := terraform.Output(t, terraformOptions, "container_instance_name")
	ipAddress := terraform.Output(t, terraformOptions, "ip_address")
	fqdn := terraform.Output(t, terraformOptions, "fqdn")

	// Assert
	assert.True(t, azure.ContainerInstanceExists(t, aciName, resourceGroupName, ""))

	actualInstance := azure.GetContainerInstance(t, aciName, resourceGroupName, "")

	assert.Equal(t, ipAddress, *actualInstance.ContainerGroupProperties.IPAddress.IP)
	assert.Equal(t, fqdn, *actualInstance.ContainerGroupProperties.IPAddress.Fqdn)
}
