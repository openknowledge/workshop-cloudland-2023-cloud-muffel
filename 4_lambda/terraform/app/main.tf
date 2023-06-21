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

        runtime_environment_variables = {
          CLOUD_MUFFEL_DYNAMODB_TABLE = aws_dynamodb_table.app.name
        }
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

resource "aws_dynamodb_table" "app" {
  name = data.terraform_remote_state.ecr.outputs.app_name

  billing_mode = "PROVISIONED"

  read_capacity  = 5
  write_capacity = 5

  hash_key  = "pk"
  range_key = "sk"

  attribute {
    name = "pk"
    type = "S"
  }

  attribute {
    name = "sk"
    type = "S"
  }

  stream_enabled = true
}

data "aws_iam_role" "lambda" {
  name = "Lambda"
}

data "archive_file" "lambda" {
  type        = "zip"
  output_path = "${path.module}/lambda.zip"
  source {
    content  = <<EOF
export const handler = async (event) => {
  console.log(event);
};
EOF
    filename = "index.js"
  }
}

resource "aws_lambda_function" "app" {
  filename = "${path.module}/lambda.zip"

  function_name = data.terraform_remote_state.ecr.outputs.app_name

  role = data.aws_iam_role.lambda.arn

  handler = "index.handler"

  source_code_hash = data.archive_file.lambda.output_base64sha256

  runtime = "nodejs18.x"
}

resource "aws_lambda_event_source_mapping" "example" {
  event_source_arn = aws_dynamodb_table.app.stream_arn

  function_name = aws_lambda_function.app.arn

  starting_position = "LATEST"
}
