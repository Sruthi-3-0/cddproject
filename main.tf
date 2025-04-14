provider "local" {}

resource "local_file" "test" {
  filename = "${path.module}/hello.txt"
  content  = "Terraform setup is successful!"
}
