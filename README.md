# Java App - Docker Image Update & deployment Pipeline

In This project a simple *"Hello World!"* Java app is updated using a *GitHub Actions* workflow for re-building, testing, and deploying a Docker image of the updated app.
The pipeline is triggered on push events and runs jobs of build, test and deployment as container running on *EC2*.

## Features

- Pipeline is defined in a yaml config file *".github/workflows/maven.yml"*.

- The Pipeline uses *Maven* to build and test the Java app.

- The pipline updates a *Docker* image of the app using an included *Dockerfile*.

- A *Python* script increments the app version on each pipeline run. The version is stored as a text file in *S3* and updated in the *"pom.xml"* file.

- The pipeline pushes updates the *Docker* image in a *DockerHub* registry with a *<version>* and a *"latest"* tags.

- The pipeline runs a *Terraform* module that deploys the app on *EC2* and creates a suitable security group. *EC2* is pre-configured to run the latest *Docker* image.

- The app execution can be viewed in a terminal using *"AWS EC2 Instance Connect"* platform.


## How to Setup the pipeline, trigger it and view the results:

1. **Fork and pull this repo:**
    - In the main menu of this repo click *"Fork"* to copy to your *GitHub* account.
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
      * DOCKER_USERNAME - *Dockerhub user for creating a registry.*
      * DOCKER_PASSWORD - *Dockerhub password.*
      * VPC_ID - *ID of a target VPC where the app will run.*
      * SUBNET_ID - *ID of a target public subnet with auto-assign public-ip.*

3. **Create Terraform remote backend and app version file:**
    - Log in to your AWS account.
    - Navigate to *S3* and create a bucket named *"javaapp-terraform-backend"*.
    - Create the folder path *"global/s3/"* for the *Terraform* remote state file.
    - Create file *"/global/java_app_version.txt"* with the text *"Java App Version: 1.0.0"*.

4. **Create DynamoDB table for state locking:**
    - Navigate to *DynamoDB* service dashboard.
    - Create a new table named *"terraform-lock"* with partition key *"LockID"*.

5. **Make some changes to repo, commit and push:**
   ``` bash
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
    - Locate your new deployed EC2 named *Java-App-<version>*.
    - Navigate to *"Connect"*, choose *"EC2 instance connect"* and click *"Connect"*.
    - Run the following command:
      ``` bash
      sudo docker logs $(sudo docker ps -aq)

      ```
    - Check the log output: Should return the *"Hello World!"* message.

* Pipeline is currently hard-coded for AWS region **"us-east-1"**.
  **Make sure your target VPC is in this region.** This can be changed manually in the Terraform *"providers.tf"* file.


## Workflow Jobs:

1. **Build and test with Maven:**
   - Builds and tests the new java app update using *Maven*.

2. **Docker image build and push**
   - Updates the version file in *S3* with new version tag.
   - Builds a new updated *Docker* image.
   - Pushes the new image to *DockerHub* with *<version>* and *"latest"* tags.

3. **Deployment to EC2**
   - Logs into *AWS-cli* using your *GitHub Actions Secrets*.
   - Deploys *EC2* and security group using *Terraform*.
   - The new *EC2* pulls and runs the updated image as a *Docker* container on startup.
   This is done using a *"user-data"* script given by *Terraform*.
