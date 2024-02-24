# my_hello_react_app

* This is a simple hello world react app with custom message.
* node js is used in this project. 

## To run this project locally:
* First clone project-> cd to project file in terminal or open in visual code -> terminal.
* run below commands in terminal:
    ```
    npm install
    npm test -- --watchAll=false --coverage --collectCoverageFrom=src/modules/**/*.{js,jsx}
    npm start     

    ```
* Above commands run locally host at: http://localhost:3000/
* Ctrl + C to exit running app locally.

## To build production app:
* run below commands in terminal:
    ```
    npm run build

    ```
* above command will genrate "Buld" file in project folder. This can be used to manual upload to any hosting server like EC2 ubunntu to run app.

## CICD and App hosting:
* CICD Pipeline is used to to run build command of the application.
* terraform is used to deploay AWS resources to host the build app.

### CICD Pipeline:
* Uses Node image to install and run-build-test react app.
* We include terraform template:Terraform.latest.gitlab-ci.yml to run terraform codes in pipeline.
    * This creates resources in AWS in Deploy stage of pipeline.
    * Destroys resources at clean-up stage.

### App Hosting:
* terraform creates S3 bucket and Uploads built artifacts from react app.
* Now the S3 has been made to host static webside using terraform. 
* Thus the bucket hosts static website build by our react app.
