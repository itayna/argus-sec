# argus-sec
DevOps Interview Home Assignment 

# AWS CI/CD Pipeline

This project demonstrates a basic CI/CD pipeline using Jenkins and AWS services such as ECR and S3.

## Overview

The pipeline consists of two stages:

1. **Build & Deploy**: Triggered by a webhook on every pull request change, this stage builds a Docker image, executes a Python script inside the container to generate an artifact, uploads the artifact to an S3 bucket, and pushes the Docker image to ECR.

2. **Pull & Test**: Running on a periodic basis (e.g., every day at 17:00), this stage pulls the latest artifact from S3 and performs a simple test to check if the artifact is empty.

## Prerequisites

- Jenkins server with the necessary plugins installed (Docker Pipeline, AWS Steps, etc.)
- AWS configured with the required credentials on Jenkins server

## Setup and Changes

1. Clone this repository to your local machine.

2. Create an S3 bucket and an ECR repository in your AWS account.

3. Update the `Jenkinsfile` with your AWS region, S3 bucket name, ECR repository name, and other vars.

4. Create a new Jenkins pipeline job and configure it to use the `Jenkinsfile` from this repository.

5. Set up a webhook in your version control system to trigger the pipeline on pull request changes.


## Files

- `Jenkinsfile`: Contains the pipeline definition and stages. (inside `jenkins` folder)
- `Dockerfile`: Defines the Docker image used for building and running the Python script. (inside `scripts` folder)
- `task.py`: Python script that generates the artifact file. (inside `scripts` folder)

## AWS Services Used

- Amazon S3: Used to store the generated artifact.

- Amazon ECR: Used to store the Docker image.

## Jenkins Plugins Used

- Docker Pipeline: Allows building and running Docker containers in Jenkins pipelines.
- AWS Steps: Provides Jenkins pipeline steps for interacting with AWS services.

## Running Pipeline In Jenkins

- Please choose what to run:
 1. Build & Deploy 
 2. Pull & Test
 3. Manually (run both stages)
- Press On Build button to start the pipeline