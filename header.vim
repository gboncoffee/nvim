let cursor = line('.')

call append(cursor,     "author Gabriel G. de Brito gabrielgbrito@icloud.com")
call append(cursor + 1, "version 0.0.0")
call append(cursor + 2, "since ")
call append(cursor + 3, "")

normal 3j$
r ! date +'\%b \%d, \%Y'
normal kJj0
