resource "local_file" "pet" {
  # filename = var.filename[count.index] # count
  # count    = length((var.filename)) # count

  filename = each.value   # for_each
  for_each = var.filename # for_each
  
  # content
  content = var.content
}

output "pets" {
  value = local_file.pet
  sensitive = true
}
