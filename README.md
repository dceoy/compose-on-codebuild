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
    $ rain deploy code-to-ecr.cfn.yml code-to-ecr
    ```
