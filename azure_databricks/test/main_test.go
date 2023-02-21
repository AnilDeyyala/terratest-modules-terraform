package test

import (
	"encoding/json"
	"fmt"
	"os/exec"
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestAzureDataFactory(t *testing.T) {

	// Specify the Terraform module to test and the input variables
	terraformOptions := &terraform.Options{
		TerraformDir: "../",
	}

	// Cleanup resources when tests are done
	defer terraform.Destroy(t, terraformOptions)

	// Deploy the Terraform module
	terraform.InitAndApply(t, terraformOptions)

	// Get the actual Azure Data Factory name using Terraform output
	expectedDBName := terraform.Output(t, terraformOptions, "data_bricks_name")
	expecctedRGName := terraform.Output(t, terraformOptions, "resource_group_name")

	exec.Command("az", "extension", "add", "--name", "databricks", "workspace").Run()
	// Verify if the Data Factory exists in Azure using the az CLI
	cmd := exec.Command("az", "databricks", "workspace", "show", "--name", expectedDBName, "--resource-group", expecctedRGName)
	out, err := cmd.CombinedOutput()
	outputStrings := string(out)
	fmt.Println(outputStrings)

	// Check if there was an error running the command
	assert.NoError(t, err)

	// Declare a map variable named `data` with keys of type `string` and values of type `interface{}`
	// Unmarshal a JSON string stored in the `outputStrings` variable into the `data` map using the `json.Unmarshal()` function
	// If an error occurs during the unmarshaling process, the program will panic
	var data map[string]interface{}
	errr := json.Unmarshal([]byte(outputStrings), &data)
	if errr != nil {
		panic(errr)
	}

	actualName := data["name"]
	// Check if the Data Factory name is correct
	assert.Equal(t, expectedDBName, actualName)
	actualRGName := data["resourceGroup"]
	assert.Equal(t, expecctedRGName, actualRGName)
}
