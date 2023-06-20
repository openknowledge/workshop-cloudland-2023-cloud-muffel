data "terraform_remote_state" "ecr" {
  backend = "local"

  config = {
    path = "../ecr/terraform.tfstate"
  }
}

resource "aws_apprunner_service" "app" {
  service_name = data.terraform_remote_state.ecr.outputs.app_name

  source_configuration {
    authentication_configuration {
      access_role_arn = data.aws_iam_role.app_runner_ecr_access.arn
    }

    image_repository {
      image_configuration {
        port = 8080
      }

      image_repository_type = "ECR"
      image_identifier      = "${data.terraform_remote_state.ecr.outputs.ecr_repository_url}:latest"
    }


    auto_deployments_enabled = true
  }

  instance_configuration {
    instance_role_arn = data.aws_iam_role.app_runner.arn
  }
}

data "aws_iam_role" "app_runner_ecr_access" {
  name = "AppRunnerECRAccessRole"
}


data "aws_iam_role" "app_runner" {
  name = "AppRunner"
}
