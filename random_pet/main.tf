resource "random_pet" "name" {
  length    = "4"
  separator = "-"
}

output "id" {
  value = random_pet.name.id
}
