# Terraform Web Server with vars example

This folder contains a web server with vars example of a [Terraform](https://www.terraform.io/) file on AWS (Amazon Web Services).

This Terraform file deploys a single web server on AWS (Amazon Web Services). The web server returns "Hello, World" for the URL `/` listening on port 8080, which is defined as a variable.

## Requirements

* You must have [Terraform](https://www.terraform.io/) installed on your computer.
* You must have an [AWS (Amazon Web Services)](http://aws.amazon.com/) account.
* It uses the Terraform AWS Provider that interacts with the many resources supported by AWS through its APIs.
* This code is compatible with Terraform >= 1.2.0.

## Using the code

* Configure your AWS access keys.

  **Important:** For security, it is strongly recommend that you use IAM users instead of the root account for AWS access.

  Setting your credentials for use by Terraform can be done in a number of ways, but here are the recommended approaches:

  * The default credentials file
  
    Set credentials in the AWS credentials profile file on your local system, located at:

    `~/.aws/credentials` on Linux, macOS, or Unix

    `C:\Users\USERNAME\.aws\credentials` on Windows

    This file should contain lines in the following format:

    ```bash
    [default]
    aws_access_key_id = <your_access_key_id>
    aws_secret_access_key = <your_secret_access_key>
    ```
    Substitute your own AWS credentials values for the values `<your_access_key_id>` and `<your_secret_access_key>`.

  * AWS Academy Learner Lab (Temporary Credentials)

    If you are using AWS Academy Learner Lab, copy the credentials from the **AWS Details** button (select **Show** next to AWS CLI).
    
    Paste them into your `~/.aws/credentials` file. Because these are temporary credentials, you must include the session token:

    ```bash
    [default]
    aws_access_key_id = <your_access_key_id>
    aws_secret_access_key = <your_secret_access_key>
    aws_session_token = <your_session_token>
    ```

  * Environment variables `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY`
  
    Set the `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` environment variables.

    To set these variables on Linux, macOS, or Unix, use `export`:

    ```bash
    export AWS_ACCESS_KEY_ID=<your_access_key_id>
    export AWS_SECRET_ACCESS_KEY=<your_secret_access_key>
    # If using temporary credentials (like AWS Academy Learner Lab), also set:
    export AWS_SESSION_TOKEN=<your_session_token>
    ```

    To set these variables on Windows, use `set`:

    ```bash
    set AWS_ACCESS_KEY_ID=<your_access_key_id>
    set AWS_SECRET_ACCESS_KEY=<your_secret_access_key>
    :: If using temporary credentials (like AWS Academy Learner Lab), also set:
    set AWS_SESSION_TOKEN=<your_session_token>
    ```

* Initialize working directory.

  The first command that should be run after writing a new Terraform configuration is the `terraform init` command in order to initialize a working directory containing Terraform configuration files. It is safe to run this command multiple times.

  ```bash
  terraform init
  ```

* Modify server port configuration.

  The web server is listening on port 8080, which is defined as an input variable `server_port` in `vars.tf` file.

  If you want to modify the server port you will be able to do it in several ways:

  * Loading variables from command line flags.

    Run Terraform commands in this way:

    ```bash
    terraform plan -var 'server_port=8080'
    ```

    ```bash
    terraform apply -var 'server_port=8080'
    ```

  * Loading variables from a file.

    When Terraform runs it will look for a file called `terraform.tfvars`. You can populate this file with variable values that will be loaded when Terraform runs. An example for the content of the `terraform.tfvars` file:

    ```bash
    server_port = "8080"
    ```

  * Loading variables from environment variables.

    Terraform will also parse any environment variables that are prefixed with `TF_VAR`. You can create an environment variable `TF_VAR_server_port`:

    ```bash
    TF_VAR_server_port=8080
    ```

  * Variable defaults.

    Change the value of the `default` attribute of `server_port` input variable in `vars.tf` file.

    **Note:** If multiple methods are used, the variable precedence order is: Command line flags > `.tfvars` file > Environment variables > Defaults.

* Plan the deployment.

  You can verify what resources will be created by running:

  ```bash
  terraform plan
  ```

* Deploy the Infrastructure.

  Run command:

  ```bash
  terraform apply
  ```

  (Type `yes` to confirm)

* Test the web server.

  Get the public IP address of the server:

  ```bash
  terraform output public_ip
  ```

  Use the output IP to test the server. (Replace `<server_public_ip>` with the actual address):
  
  * From the command line:

    ```bash
    curl http://<server_public_ip>:8080/
    ```

  * Or using your browser: `http://<server_public_ip>:8080/`

  You should get a `Hello, World` response message.

* Clean up the resources created.

  When you have finished, run command:

  ```bash
  terraform destroy
  ```

  (Type `yes` to confirm)
