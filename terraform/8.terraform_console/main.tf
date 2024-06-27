resource "github_repository" "repo1" {
  name = "git1"
  #   description = "My awesome codebase"
  visibility = "public"
  auto_init  = true
}

resource "github_repository" "repo2" {
  name = "git2"
  #   description = "My awesome codebase"
  visibility = "public"
  auto_init  = true
}

output "repo1-html_url" {
  value = github_repository.repo1.html_url
}

# ❯ terraform console
# > var.username
# "khaleel"
# > var.token
# > var.github_repository.repo1.html_url
# "https://github.com/khaleel-git/git1"