# Java App - Docker Image Update & deployment Pipeline

In This project a simple *"Hello World!"* Java app managed using a *GitHub Actions* workflow for re-building, testing, and deploying a Docker image of the updated app.
The pipeline is triggered on push events and runs jobs of build, test and deployment as a container running on *EC2*.

## Features

- Pipeline is defined in GitHub Actions Workflow yaml file in - *".github/workflows/java_maven_build.yml"*.

- The Pipeline uses *Maven* to build and test the Java app.

- The pipline updates a *Docker* image of the app using the included *Dockerfile* in the *java_app* directory.

- A *Python* script increments the app version on each pipeline run. The version is stored in *java_app_version* file and also updated in the *"pom.xml"* file. Updated version file is then pushed back to the repo from inside the pipeline.

- The pipeline pushes and updates the *Docker* image in a *DockerHub* registry with a *"version"* and a *"latest"* tags.

- The pipeline runs a *Terraform* module that deploys a full VPC staging environment with the updated app running on an *EC2*. It also creates a suitable security group for connecting via SSH using the *EC2 Instance Connect* service. The security group is defined with the right I.P according to the specified AWS region. *EC2* is pre-configured with *user-data* to run the latest *Docker* image.

**A Terraform Remote Backend will be configured from inside the pipeline to allow remote management of the deployed Infrastructure from your local machine. This includes an S3 bucket for the remote state file and a DynamoDB table that acts as a state lock mechanism.**

- The app execution can be viewed in a terminal using *"AWS EC2 Instance Connect"* servive from the AWS console.


## How to Setup the pipeline, trigger it and view the results:

1. **Fork and pull this repo:**
    - In the main menu of this repo click *"Fork"* to make a copy in your *GitHub* account.
    - On your local machine initialize git and pull your new repo.

    ``` bash
    git init
    git pull <url of your new repo> #enter credentials...

    ```

2. **Add GitHub Actions secrets:**
    - Go to *settings --> security --> Secrets and variables --> Actions*.
    - Add the following secrets using these exact names:
      * AWS_ACCESS_KEY_ID - *From your AWS account credentials.*
      * AWS_SECRET_ACCESS_KEY - *From your AWS account credentials.*
      * AWS_REGION - *The AWS region in which to deploy the environment.*
      * DOCKER_USERNAME - *Dockerhub user for creating a registry.*
      * DOCKER_PASSWORD - *Dockerhub password.*

5. **Make some changes to repo, commit and push:**
   ``` bash
   git pull origin master
   #make some changes...
   git add .
   git commit -m "My changes commit"
   git push origin master

   ```

6. **View pipeline workflow in GitHub Actions:**

    Click the *"Actions"* tab to follow the pipeline workflow of your last commit.

7. **Review update in DockerHub registry**
    - Connect to your *DockerHub* account and locate the *java-app* registry.
    - Check for updates of the *"latest"* and current version tags.

8. **Connect and review deployed EC2:**
    - In the *EC2* service dashboard navigate to *"Instances"*.
    - Locate your new deployed EC2 named *Java-App-version*.
    - Navigate to *"Connect"*, choose *"EC2 instance connect"* and click *"Connect"*.
    - Run the following command:
      ``` bash
      sudo docker logs $(sudo docker ps -aq)

      ```
    - Check the log output: Should return the *"Hello World!"* message.


## Workflow Jobs:

1. **Build and test with Maven:**
   - Builds and tests the new java app update using *Maven*.

2. **Docker image build and push**
   - Increments the version in the file file and in the *pom.xml* file.
   - Performs a git push to the repo to update the version file. (Pipeline is not triggered by this).
   - Builds a new updated *Docker* image.
   - Pushes the new image to *DockerHub* with *"version"* and *"latest"* tags.

3. **Deployment to EC2**
   - Logs into *AWS-cli* using your *GitHub Actions Secrets*.
   - Deploys S3 bucket and DynamoDB table for the Terraform remote Backend.
   - Deploys *EC2* and security group using *Terraform*.
   - The new *EC2* pulls and runs the updated image as a *Docker* container on startup.
   This is done using a *"user-data"* script given by *Terraform*.

4. **Tear-Down**
    In order to tear-down this environment:

    - Init Terraform in the App IaC folder:
    ``` bash
      cd IaC_app
      Terraform init
      ```
    - Destroy environment (approve when prompted):
     ``` bash
      Terraform destroy
      ```
