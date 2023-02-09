package test

import (
	"fmt"
	"strings"
	"testing"

	"github.com/Azure/azure-sdk-for-go/profiles/latest/mysql/mgmt/mysql"
	"github.com/gruntwork-io/terratest/modules/azure"
	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestTerraformAzureMySQLDB(t *testing.T) {
	t.Parallel()

	uniquePostfix := strings.ToLower(random.UniqueId())
	expectedServerSkuName := "GP_Gen5_2"
	expectedServerStoragemMb := "5120"
	expectedDatabaseCharSet := "utf8"
	expectedDatabaseCollation := "utf8_unicode_ci"

	// Configure Terraform setting up a path to Terraform code.
	terraformOptions := &terraform.Options{
		// The path to where our Terraform code is located
		TerraformDir: "../",
		Vars: map[string]interface{}{
			"postfix":                uniquePostfix,
			"mysqlserver_sku_name":   expectedServerSkuName,
			"mysqlserver_storage_mb": expectedServerStoragemMb,
			"mysqldb_charset":        expectedDatabaseCharSet,
		},
	}

	// At the end of the test, run `terraform destroy` to clean up any resources that were created
	defer terraform.Destroy(t, terraformOptions)

	// Run `terraform init` and `terraform apply`. Fail the test if there are any errors.
	terraform.InitAndApply(t, terraformOptions)

	// Run `terraform output` to get the values of output variables
	expectedResourceGroupName := terraform.Output(t, terraformOptions, "resource_group_name")
	expectedMYSQLServerName := terraform.Output(t, terraformOptions, "mysql_server_name")

	expectedMYSQLDBName := terraform.Output(t, terraformOptions, "mysql_database_name")

	// Get mySQL server details and assert them against the terraform output
	actualMYSQLServer := azure.GetMYSQLServer(t, expectedResourceGroupName, expectedMYSQLServerName, "")

	assert.Equal(t, expectedServerSkuName, *actualMYSQLServer.Sku.Name)
	assert.Equal(t, expectedServerStoragemMb, fmt.Sprint(*actualMYSQLServer.ServerProperties.StorageProfile.StorageMB))

	assert.Equal(t, mysql.ServerStateReady, actualMYSQLServer.ServerProperties.UserVisibleState)

	// Get  mySQL server DB details and assert them against the terraform output
	actualDatabase := azure.GetMYSQLDB(t, expectedResourceGroupName, expectedMYSQLServerName, expectedMYSQLDBName, "")

	assert.Equal(t, expectedDatabaseCharSet, *actualDatabase.DatabaseProperties.Charset)
	assert.Equal(t, expectedDatabaseCollation, *actualDatabase.DatabaseProperties.Collation)
}
