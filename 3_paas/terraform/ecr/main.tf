resource "random_pet" "app" {

}

resource "aws_ecr_repository" "app" {
  name = random_pet.app.id

  force_delete = true
}

output "app_name" {
  value = random_pet.app.id
}

output "ecr_repository_url" {
  value = aws_ecr_repository.app.repository_url
}
