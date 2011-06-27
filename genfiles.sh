#!/bin/sh

ROOT=${ROOT:-/mnt/img}

while read line; do
	set -- $line
	[ $1 = file ] && {
		realpath=$(eval echo $3)
		ldd $realpath > /dev/null 2>&1
		[ $? -eq 0 ] && {
			ldd $realpath | awk -v root=$ROOT '
				/ld-linux/ {
					printf("file %s %s%s 755 0 0\n",
					    $1, root, $1);
				}
				/=>/ {
					if (index($3, "(0x") == 1) { # skip vdso
						next;
					}

					if (system("test -f \""$3"\"") == 0) {
						printf("file /lib/%s %s 755 0 0\n",
						    $1, $3);
					} else {
						printf("library %s missing", $3) >> /dev/stderr;
					}
				}
				'
		}
		echo $1 $2 $realpath $4 $5 $6
	} || echo $line	
done | sort -u
