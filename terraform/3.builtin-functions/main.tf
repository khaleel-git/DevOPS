output builtinfunction {
	value="${join("-->",var.users)}"
}

output upperoutput {
	value = "${upper(var.users[0])}"
}

output loweroutput {
	value = "${lower(var.users[1])}"
}

output titleoutput {
	value = "${title(var.users[2])}"
}