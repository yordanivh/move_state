module "random_pet" {
  source = "../random_pet/"

}

resource "null_resource" "hello" {
  provisioner "local-exec" {
    command = "echo Hello ${module.random_pet.id}"
  }
}

