output printit {
	value="${join("-->",var.users)}"
}

output helloworld {
	value = "${upper(var.users[0])"}
}
