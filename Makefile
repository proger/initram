ROOT?=	/mnt/img
# src/linux/usr/gen_init_cpio.c
GEN_INIT_CPIO?=	gen_init_cpio

initram:
	env ROOT=${ROOT} ./genfiles.sh < initram.files.in \
		| ${GEN_INIT_CPIO} /dev/stdin | gzip > ${ROOT}/initram
