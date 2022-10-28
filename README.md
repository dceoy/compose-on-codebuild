code-to-ecr
===========

Docker Image Builder using AWS CodeBuild

[![Lint](https://github.com/dceoy/code-to-ecr/actions/workflows/lint.yml/badge.svg)](https://github.com/dceoy/code-to-ecr/actions/workflows/lint.yml)

Installation
------------

1.  Install [AWS CLI](https://aws.amazon.com/cli/) and set `~/.aws/config` and `~/.aws/credentials`.

2.  Install [git-remote-codecommit](https://github.com/aws/git-remote-codecommit).

3.  Check out the repository.

    ```sh
    $ git clone git@github.com:dceoy/code-to-ecr.git
    ```


3.  Deploy AWS CloudFormation stacks for AWS CodeBuild.

    ```sh
    $ aws cloudformation create-stack \
        --stack-name backend-of-code-to-ecr \
        --template-body file://code-to-ecr/backend-of-code-to-ecr.cfn.yml
    ```

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
    $ git push "codecommit://default@${IMAGE_REPO_NAME}" main
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
