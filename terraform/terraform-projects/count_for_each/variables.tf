variable "filename" {
  default = [
    "/home/khaleel-unix/DevOPS/terraform/count_for_each/pets.txt",
    "/home/khaleel-unix/DevOPS/terraform/count_for_each/dogs.txt",
    "/home/khaleel-unix/DevOPS/terraform/count_for_each/cat.txt",
    "/home/khaleel-unix/DevOPS/terraform/count_for_each/cows.txt",
    "/home/khaleel-unix/DevOPS/terraform/count_for_each/ducks.txt"
  ]
}

variable "content" {
  default = "This is content of a file"
}