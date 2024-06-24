#!/bin/zsh
echo "All outputs are commented"
: '
This is
multiline comment
in shellscript
'

# this is a single line comment

: <<'END_COMMENT'
This is another
multiline comment
in shellscript
END_COMMENT