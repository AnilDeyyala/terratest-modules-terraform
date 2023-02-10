package test

import (
	"strings"
	"testing"

	"github.com/gruntwork-io/terratest/modules/azure"
	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestTerraformAzureSQLDBExample(t *testing.T) {
	t.Parallel()

	uniquePostfix := strings.ToLower(random.UniqueId())

	// Configure Terraform setting up a path to Terraform code.
	terraformOptions := &terraform.Options{
		// The path to where our Terraform code is located
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
	expectedSQLServerID := terraform.Output(t, terraformOptions, "sql_server_id")
	expectedSQLServerName := terraform.Output(t, terraformOptions, "sql_server_name")

	expectedSQLServerFullDomainName := terraform.Output(t, terraformOptions, "sql_server_full_domain_name")
	expectedSQLDBName := terraform.Output(t, terraformOptions, "sql_database_name")

	expectedSQLDBID := terraform.Output(t, terraformOptions, "sql_database_id")
	expectedResourceGroupName := terraform.Output(t, terraformOptions, "resource_group_name")
	expectedSQLDBStatus := "Online"

	// Get the SQL server details and assert them against the terraform output
	actualSQLServer := azure.GetSQLServer(t, expectedResourceGroupName, expectedSQLServerName, "")

	assert.Equal(t, expectedSQLServerID, *actualSQLServer.ID)
	assert.Equal(t, expectedSQLServerFullDomainName, *actualSQLServer.FullyQualifiedDomainName)
	// assert.Equal(t, sql.ServerStateReady, actualSQLServer.State)

	// Get the SQL server DB details and assert them against the terraform output
	actualSQLDatabase := azure.GetSQLDatabase(t, expectedResourceGroupName, expectedSQLServerName, expectedSQLDBName, "")

	assert.Equal(t, expectedSQLDBID, *actualSQLDatabase.ID)
	assert.Equal(t, expectedSQLDBStatus, *actualSQLDatabase.Status)
}
