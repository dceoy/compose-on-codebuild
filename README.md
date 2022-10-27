code-to-ecr
===========

Docker Image Builder using AWS CodeBuild

[![Lint](https://github.com/dceoy/code-to-ecr/actions/workflows/lint.yml/badge.svg)](https://github.com/dceoy/code-to-ecr/actions/workflows/lint.yml)

Installation
------------

1.  Check out the repository.

    ```sh
    $ git clone git@github.com:dceoy/code-to-ecr.git
    $ cd code-to-ecr
    ```

2.  Install [Rain](https://github.com/aws-cloudformation/rain) and set `~/.aws/config` and `~/.aws/credentials`.

3.  Deploy AWS CloudFormation stacks for AWS CodeBuild.

    ```sh
    $ rain deploy backend-of-code-to-ecr.cfn.yml backend-of-code-to-ecr
    ```

4.  Install [AWS CLI](https://aws.amazon.com/cli/).

Usage
-----

1.  Create a repository on AWS CodeCommit.

    ```sh
    $ IMAGE_REPO_NAME=<your_image_name>
    $ aws codecommit create-repository --repository-name "${IMAGE_REPO_NAME}"
    ```

2.  Push a Git repository including Dockerfile to the CodeCommit repository.

    ```sh
    $ cd your_dockerfile_git_dir
    $ aws codecommit get-repository --repository-name "${IMAGE_REPO_NAME}" \
      | jq -r .repositoryMetadata.cloneUrlHttp \
      | xargs -I{} git push {} main
    ```

3.  Create a repository on Amazon ECR.

    ```sh
    $ aws ecr create-repository --repository-name "${IMAGE_REPO_NAME}"
    ```

4.  Start build on CodeBuild.

    ```sh
    $ aws codecommit get-repository --repository-name "${IMAGE_REPO_NAME}" \
      | jq -r .repositoryMetadata.cloneUrlHttp \
      | xargs -I{} aws codebuild start-build \
        --project-name code-to-ecr \
        --environment-variables-override "name=IMAGE_REPO_NAME,value=${IMAGE_REPO_NAME}" \
        --source-type-override CODECOMMIT \
        --source-location-override '{}'
    ```
