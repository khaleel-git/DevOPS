variable "userage" {
  type = map
  default = {
    khaleel = 23
    Ahmad = 43
    subhan = 43
  }
}

variable "username" {
  type = string
}

# erraform plan -var 'usersage={ "gaurav":"23","saurav":"22","men":"25" }'