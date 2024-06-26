resource "github_repository" "repo1" {
  name        = "git1"
#   description = "My awesome codebase"
  visibility  = "public"
  auto_init   = true
}

resource "github_repository" "repo2" {
  name        = "git2"
#   description = "My awesome codebase"
  visibility  = "public"
  auto_init   = true
} 

output "repo1-html_url" {
  value = github_repository.repo1.html_url
}