	.file	"dataframe.c"
	.intel_syntax noprefix
 # GNU C23 (Rev8, Built by MSYS2 project) version 15.2.0 (x86_64-w64-mingw32)
 #	compiled by GNU C version 15.2.0, GMP version 6.3.0, MPFR version 4.2.2, MPC version 1.3.1, isl version isl-0.27-GMP

 # GGC heuristics: --param ggc-min-expand=100 --param ggc-min-heapsize=131072
 # options passed: -masm=intel -mtune=generic -march=nocona -O2
	.text
	.p2align 4
	.def	free_fields.part.0;	.scl	3;	.type	32;	.endef
	.seh_proc	free_fields.part.0
free_fields.part.0:
	push	rdi	 #
	.seh_pushreg	rdi
	push	rsi	 #
	.seh_pushreg	rsi
	push	rbx	 #
	.seh_pushreg	rbx
	sub	rsp, 32	 #,
	.seh_stackalloc	32
	.seh_endprologue
 # dataframe.c:19: static void free_fields(char **fields, size_t count) {
	mov	rdi, rcx	 # fields, fields
 # dataframe.c:21:   for (size_t i = 0; i < count; i++) {
	test	rdx, rdx	 # count
	je	.L2	 #,
	mov	rbx, rcx	 # ivtmp.108, fields
	lea	rsi, [rcx+rdx*8]	 # _20,
	.p2align 4
	.p2align 3
.L3:
 # dataframe.c:22:     free(fields[i]);
	mov	rcx, QWORD PTR [rbx]	 # MEM[(char * *)_17], MEM[(char * *)_17]
 # dataframe.c:21:   for (size_t i = 0; i < count; i++) {
	add	rbx, 8	 # ivtmp.108,
 # dataframe.c:22:     free(fields[i]);
	call	free	 #
 # dataframe.c:21:   for (size_t i = 0; i < count; i++) {
	cmp	rbx, rsi	 # ivtmp.108, _20
	jne	.L3	 #,
.L2:
 # dataframe.c:24:   free(fields);
	mov	rcx, rdi	 #, fields
 # dataframe.c:25: }
	add	rsp, 32	 #,
	pop	rbx	 #
	pop	rsi	 #
	pop	rdi	 #
 # dataframe.c:24:   free(fields);
	jmp	free	 #
	.seh_endproc
	.p2align 4
	.def	push_field;	.scl	3;	.type	32;	.endef
	.seh_proc	push_field
push_field:
	push	r14	 #
	.seh_pushreg	r14
	push	r13	 #
	.seh_pushreg	r13
	push	r12	 #
	.seh_pushreg	r12
	push	rbp	 #
	.seh_pushreg	rbp
	push	rdi	 #
	.seh_pushreg	rdi
	push	rsi	 #
	.seh_pushreg	rsi
	push	rbx	 #
	.seh_pushreg	rbx
	sub	rsp, 32	 #,
	.seh_stackalloc	32
	.seh_endprologue
 # dataframe.c:40:                       char **buf, size_t *blen, size_t *bcap) {
	mov	rsi, QWORD PTR 128[rsp]	 # blen, blen
	mov	r14, QWORD PTR 136[rsp]	 # bcap, bcap
 # dataframe.c:28:   if (*len + 1 >= *cap) {
	mov	rax, QWORD PTR [rsi]	 # _38, *blen_20(D)
 # dataframe.c:40:                       char **buf, size_t *blen, size_t *bcap) {
	mov	rbp, r8	 # fcap, fcap
 # dataframe.c:28:   if (*len + 1 >= *cap) {
	mov	r8, QWORD PTR [r14]	 # _40, *bcap_21(D)
 # dataframe.c:40:                       char **buf, size_t *blen, size_t *bcap) {
	mov	rdi, rdx	 # flen, flen
 # dataframe.c:28:   if (*len + 1 >= *cap) {
	lea	rdx, 1[rax]	 # _39,
 # dataframe.c:40:                       char **buf, size_t *blen, size_t *bcap) {
	mov	r12, rcx	 # fields, fields
	mov	rbx, r9	 # buf, buf
 # dataframe.c:30:     char *nbuf = (char *)realloc(*buf, ncap);
	mov	rcx, QWORD PTR [r9]	 # nbuf, *buf_19(D)
 # dataframe.c:28:   if (*len + 1 >= *cap) {
	cmp	rdx, r8	 # _39, _40
	jb	.L10	 #,
 # dataframe.c:29:     size_t ncap = (*cap == 0) ? 16 : (*cap * 2);
	lea	r13, [r8+r8]	 # tmp131,
	test	r8, r8	 # _40
	mov	eax, 16	 # tmp132,
	cmove	r13, rax	 # tmp131,, ncap, tmp132
 # dataframe.c:30:     char *nbuf = (char *)realloc(*buf, ncap);
	mov	rdx, r13	 #, ncap
	call	realloc	 #
	mov	rcx, rax	 # nbuf, nbuf
 # dataframe.c:31:     if (!nbuf) return 0;
	test	rax, rax	 # nbuf
	je	.L13	 #,
 # dataframe.c:32:     *buf = nbuf;
	mov	QWORD PTR [rbx], rax	 # *buf_19(D), nbuf
 # dataframe.c:33:     *cap = ncap;
	mov	QWORD PTR [r14], r13	 # *bcap_21(D), ncap
 # dataframe.c:35:   (*buf)[(*len)++] = ch;
	mov	rax, QWORD PTR [rsi]	 # _38, *blen_20(D)
 # dataframe.c:35:   (*buf)[(*len)++] = ch;
	lea	rdx, 1[rax]	 # _39,
.L10:
	mov	QWORD PTR [rsi], rdx	 # *blen_20(D), _39
 # dataframe.c:35:   (*buf)[(*len)++] = ch;
	mov	BYTE PTR [rcx+rax], 0	 # *_48,
 # dataframe.c:42:   char *s = (char *)malloc(*blen);
	mov	r14, QWORD PTR [rsi]	 # _2, *blen_20(D)
	mov	rcx, r14	 #, _2
	call	malloc	 #
	mov	r13, rax	 # s,
 # dataframe.c:43:   if (!s) return 0;
	test	rax, rax	 # s
	je	.L13	 #,
 # dataframe.c:44:   memcpy(s, *buf, *blen);
	mov	rdx, QWORD PTR [rbx]	 # *buf_19(D), *buf_19(D)
	mov	rcx, rax	 #, s
	mov	r8, r14	 #, _2
	call	memcpy	 #
 # dataframe.c:45:   *blen = 0;
	mov	QWORD PTR [rsi], 0	 # *blen_20(D),
 # dataframe.c:47:   if (*flen >= *fcap) {
	mov	rax, QWORD PTR [rdi]	 # _5, *flen_27(D)
 # dataframe.c:47:   if (*flen >= *fcap) {
	mov	rdx, QWORD PTR 0[rbp]	 # _6, *fcap_28(D)
 # dataframe.c:49:     char **nf = (char **)realloc(*fields, ncap * sizeof(char *));
	mov	rcx, QWORD PTR [r12]	 # nf, *fields_30(D)
 # dataframe.c:47:   if (*flen >= *fcap) {
	cmp	rax, rdx	 # _5, _6
	jnb	.L24	 #,
.L15:
 # dataframe.c:57:   (*fields)[(*flen)++] = s;
	lea	rdx, 1[rax]	 # tmp129,
	mov	QWORD PTR [rdi], rdx	 # *flen_27(D), tmp129
 # dataframe.c:57:   (*fields)[(*flen)++] = s;
	mov	QWORD PTR [rcx+rax*8], r13	 # *_13, s
 # dataframe.c:58:   return 1;
	mov	eax, 1	 # <retval>,
.L9:
 # dataframe.c:59: }
	add	rsp, 32	 #,
	pop	rbx	 #
	pop	rsi	 #
	pop	rdi	 #
	pop	rbp	 #
	pop	r12	 #
	pop	r13	 #
	pop	r14	 #
	ret	
	.p2align 4,,10
	.p2align 3
.L24:
 # dataframe.c:48:     size_t ncap = (*fcap == 0) ? 8 : (*fcap * 2);
	test	rdx, rdx	 # _6
	jne	.L25	 #,
	mov	edx, 64	 # _64,
 # dataframe.c:48:     size_t ncap = (*fcap == 0) ? 8 : (*fcap * 2);
	mov	ebx, 8	 # ncap,
.L16:
 # dataframe.c:49:     char **nf = (char **)realloc(*fields, ncap * sizeof(char *));
	call	realloc	 #
	mov	rcx, rax	 # nf, nf
 # dataframe.c:50:     if (!nf) {
	test	rax, rax	 # nf
	je	.L26	 #,
 # dataframe.c:54:     *fields = nf;
	mov	QWORD PTR [r12], rax	 # *fields_30(D), nf
 # dataframe.c:55:     *fcap = ncap;
	mov	QWORD PTR 0[rbp], rbx	 # *fcap_28(D), ncap
 # dataframe.c:57:   (*fields)[(*flen)++] = s;
	mov	rax, QWORD PTR [rdi]	 # _5, *flen_27(D)
	jmp	.L15	 #
	.p2align 4,,10
	.p2align 3
.L25:
 # dataframe.c:48:     size_t ncap = (*fcap == 0) ? 8 : (*fcap * 2);
	lea	rbx, [rdx+rdx]	 # ncap,
 # dataframe.c:49:     char **nf = (char **)realloc(*fields, ncap * sizeof(char *));
	sal	rdx, 4	 # _64,
	jmp	.L16	 #
.L26:
 # dataframe.c:51:       free(s);
	mov	rcx, r13	 #, s
	call	free	 #
.L13:
 # dataframe.c:41:   if (!append_char(buf, blen, bcap, '\0')) return 0;
	xor	eax, eax	 # <retval>
	jmp	.L9	 #
	.seh_endproc
	.p2align 4
	.def	parse_record.constprop.0;	.scl	3;	.type	32;	.endef
	.seh_proc	parse_record.constprop.0
parse_record.constprop.0:
	push	r15	 #
	.seh_pushreg	r15
	push	r14	 #
	.seh_pushreg	r14
	push	r13	 #
	.seh_pushreg	r13
	push	r12	 #
	.seh_pushreg	r12
	push	rbp	 #
	.seh_pushreg	rbp
	push	rdi	 #
	.seh_pushreg	rdi
	push	rsi	 #
	.seh_pushreg	rsi
	push	rbx	 #
	.seh_pushreg	rbx
	sub	rsp, 136	 #,
	.seh_stackalloc	136
	.seh_endprologue
	mov	QWORD PTR 224[rsp], r8	 # out_fields, out_fields
	mov	rbx, rcx	 # f, f
	mov	r14d, edx	 # delimiter, delimiter
	mov	QWORD PTR 232[rsp], r9	 # out_count, out_count
.L28:
 # dataframe.c:67:     int c = fgetc(f);
	mov	rcx, rbx	 #, f
	call	fgetc	 #
 # dataframe.c:68:     if (c == EOF) return 0;
	cmp	eax, -1	 # c,
	je	.L109	 #,
 # dataframe.c:69:     if (c == '\r') {
	cmp	eax, 13	 # c,
	je	.L208	 #,
 # dataframe.c:74:     if (c == '\n') continue;
	cmp	eax, 10	 # c,
	je	.L28	 #,
 # dataframe.c:75:     ungetc(c, f);
	mov	rdx, rbx	 #, f
	mov	ecx, eax	 #, c
	call	ungetc	 #
 # dataframe.c:89:     int c = fgetc(f);
	mov	rcx, rbx	 #, f
 # dataframe.c:79:   char **fields = NULL;
	mov	QWORD PTR 80[rsp], 0	 # fields,
 # dataframe.c:80:   size_t fields_len = 0, fields_cap = 0;
	mov	QWORD PTR 88[rsp], 0	 # fields_len,
 # dataframe.c:80:   size_t fields_len = 0, fields_cap = 0;
	mov	QWORD PTR 96[rsp], 0	 # fields_cap,
 # dataframe.c:82:   char *buf = NULL;
	mov	QWORD PTR 104[rsp], 0	 # buf,
 # dataframe.c:83:   size_t buf_len = 0, buf_cap = 0;
	mov	QWORD PTR 112[rsp], 0	 # buf_len,
 # dataframe.c:83:   size_t buf_len = 0, buf_cap = 0;
	mov	QWORD PTR 120[rsp], 0	 # buf_cap,
 # dataframe.c:89:     int c = fgetc(f);
	call	fgetc	 #
	mov	r10d, eax	 # c, c
 # dataframe.c:90:     if (c == EOF) {
	cmp	eax, -1	 # c,
	je	.L207	 #,
.L34:
	movzx	edi, r14b	 # _69, delimiter
 # dataframe.c:168:       if (start_of_field && c == '"') {
	cmp	r10d, 34	 # c,
	jne	.L83	 #,
.L202:
 # dataframe.c:89:     int c = fgetc(f);
	mov	rcx, rbx	 #, f
	call	fgetc	 #
	mov	esi, eax	 # c, c
 # dataframe.c:90:     if (c == EOF) {
	cmp	eax, -1	 # c,
	je	.L77	 #,
 # dataframe.c:108:       if (c == '"') {
	cmp	esi, 34	 # c,
	je	.L209	 #,
 # dataframe.c:28:   if (*len + 1 >= *cap) {
	mov	r9, QWORD PTR 112[rsp]	 # _222, buf_len
 # dataframe.c:28:   if (*len + 1 >= *cap) {
	mov	rax, QWORD PTR 120[rsp]	 # _224, buf_cap
 # dataframe.c:93:         free(buf);
	mov	rdi, QWORD PTR 104[rsp]	 # pretmp_203, buf
 # dataframe.c:28:   if (*len + 1 >= *cap) {
	lea	r10, 1[r9]	 # _223,
 # dataframe.c:28:   if (*len + 1 >= *cap) {
	cmp	r10, rax	 # _223, _224
	jb	.L74	 #,
 # dataframe.c:29:     size_t ncap = (*cap == 0) ? 16 : (*cap * 2);
	test	rax, rax	 # _224
	lea	rdx, [rax+rax]	 # tmp313,
	mov	eax, 16	 # tmp354,
 # dataframe.c:30:     char *nbuf = (char *)realloc(*buf, ncap);
	mov	rcx, rdi	 #, pretmp_203
 # dataframe.c:29:     size_t ncap = (*cap == 0) ? 16 : (*cap * 2);
	cmove	rdx, rax	 # tmp313,, ncap, tmp354
	mov	QWORD PTR 64[rsp], r10	 # %sfp, _223
	mov	QWORD PTR 56[rsp], r9	 # %sfp, _222
 # dataframe.c:30:     char *nbuf = (char *)realloc(*buf, ncap);
	mov	QWORD PTR 48[rsp], rdx	 # %sfp, ncap
	call	realloc	 #
 # dataframe.c:31:     if (!nbuf) return 0;
	test	rax, rax	 # nbuf
	je	.L76	 #,
 # dataframe.c:33:     *cap = ncap;
	mov	rdx, QWORD PTR 48[rsp]	 # ncap, %sfp
 # dataframe.c:32:     *buf = nbuf;
	mov	QWORD PTR 104[rsp], rax	 # buf, nbuf
 # dataframe.c:33:     *cap = ncap;
	mov	rdi, rax	 # pretmp_203, nbuf
	mov	r10, QWORD PTR 64[rsp]	 # _223, %sfp
	mov	r9, QWORD PTR 56[rsp]	 # _222, %sfp
	mov	QWORD PTR 120[rsp], rdx	 # buf_cap, ncap
.L74:
 # dataframe.c:35:   (*buf)[(*len)++] = ch;
	mov	QWORD PTR 112[rsp], r10	 # buf_len, _223
 # dataframe.c:159:         if (!append_char(&buf, &buf_len, &buf_cap, (char)c)) {
	mov	BYTE PTR [rdi+r9], sil	 # *_232, c
	jmp	.L202	 #
	.p2align 4,,10
	.p2align 3
.L211:
 # dataframe.c:29:     size_t ncap = (*cap == 0) ? 16 : (*cap * 2);
	test	rax, rax	 # _252
	lea	rdx, [rax+rax]	 # tmp315,
	mov	eax, 16	 # tmp362,
 # dataframe.c:30:     char *nbuf = (char *)realloc(*buf, ncap);
	mov	rcx, rsi	 #, prephitmp_273
 # dataframe.c:29:     size_t ncap = (*cap == 0) ? 16 : (*cap * 2);
	cmove	rdx, rax	 # tmp315,, ncap, tmp362
	mov	QWORD PTR 72[rsp], r9	 # %sfp, _251
	mov	QWORD PTR 64[rsp], r8	 # %sfp, _250
	mov	DWORD PTR 56[rsp], r10d	 # %sfp, c
 # dataframe.c:30:     char *nbuf = (char *)realloc(*buf, ncap);
	mov	QWORD PTR 48[rsp], rdx	 # %sfp, ncap
	call	realloc	 #
 # dataframe.c:31:     if (!nbuf) return 0;
	test	rax, rax	 # nbuf
	je	.L101	 #,
 # dataframe.c:33:     *cap = ncap;
	mov	rdx, QWORD PTR 48[rsp]	 # ncap, %sfp
 # dataframe.c:32:     *buf = nbuf;
	mov	QWORD PTR 104[rsp], rax	 # buf, nbuf
 # dataframe.c:33:     *cap = ncap;
	mov	rsi, rax	 # prephitmp_273, nbuf
	mov	r9, QWORD PTR 72[rsp]	 # _251, %sfp
	mov	r8, QWORD PTR 64[rsp]	 # _250, %sfp
	mov	QWORD PTR 120[rsp], rdx	 # buf_cap, ncap
	mov	r10d, DWORD PTR 56[rsp]	 # c, %sfp
.L99:
 # dataframe.c:197:       if (!append_char(&buf, &buf_len, &buf_cap, (char)c)) {
	mov	BYTE PTR [rsi+r8], r10b	 # *_260, c
 # dataframe.c:89:     int c = fgetc(f);
	mov	rcx, rbx	 #, f
 # dataframe.c:35:   (*buf)[(*len)++] = ch;
	mov	QWORD PTR 112[rsp], r9	 # buf_len, _251
 # dataframe.c:89:     int c = fgetc(f);
	call	fgetc	 #
	mov	r10d, eax	 # c, c
 # dataframe.c:90:     if (c == EOF) {
	cmp	eax, -1	 # c,
	je	.L207	 #,
.L83:
 # dataframe.c:173:       if (c == (unsigned char)delimiter) {
	cmp	edi, r10d	 # _69, c
	je	.L210	 #,
 # dataframe.c:182:       if (c == '\r' || c == '\n') {
	cmp	r10d, 13	 # c,
	je	.L113	 #,
	cmp	r10d, 10	 # c,
	je	.L113	 #,
 # dataframe.c:28:   if (*len + 1 >= *cap) {
	mov	r8, QWORD PTR 112[rsp]	 # _250, buf_len
 # dataframe.c:28:   if (*len + 1 >= *cap) {
	mov	rax, QWORD PTR 120[rsp]	 # _252, buf_cap
 # dataframe.c:93:         free(buf);
	mov	rsi, QWORD PTR 104[rsp]	 # prephitmp_273, buf
 # dataframe.c:28:   if (*len + 1 >= *cap) {
	lea	r9, 1[r8]	 # _251,
 # dataframe.c:28:   if (*len + 1 >= *cap) {
	cmp	r9, rax	 # _251, _252
	jb	.L99	 #,
	jmp	.L211	 #
	.p2align 4,,10
	.p2align 3
.L209:
 # dataframe.c:109:         int next = fgetc(f);
	mov	rcx, rbx	 #, f
	call	fgetc	 #
	mov	r10d, eax	 # next, next
 # dataframe.c:110:         if (next == '"') {
	cmp	eax, 34	 # next,
	jne	.L205	 #,
	jmp	.L46	 #
	.p2align 4,,10
	.p2align 3
.L47:
 # dataframe.c:120:             next = fgetc(f);
	mov	rcx, rbx	 #, f
	call	fgetc	 #
	mov	r10d, eax	 # next, next
.L205:
 # dataframe.c:119:           while (next == ' ') {
	cmp	r10d, 32	 # next,
	je	.L47	 #,
 # dataframe.c:122:           if (next == (unsigned char)delimiter) {
	movzx	edi, r14b	 # _69, delimiter
 # dataframe.c:122:           if (next == (unsigned char)delimiter) {
	cmp	edi, r10d	 # _69, next
	jne	.L57	 #,
 # dataframe.c:123:             if (!push_field(&fields, &fields_len, &fields_cap, &buf, &buf_len, &buf_cap)) {
	lea	rdi, 120[rsp]	 # tmp310,
	lea	rsi, 112[rsp]	 # tmp309,
	mov	QWORD PTR 40[rsp], rdi	 #, tmp310
	lea	r9, 104[rsp]	 # tmp308,
	lea	r8, 96[rsp]	 # tmp306,
	mov	QWORD PTR 32[rsp], rsi	 #, tmp309
	lea	rdx, 88[rsp]	 # tmp305,
	mov	r13, r9	 # tmp308, tmp308
	mov	r12, r8	 # tmp306, tmp306
	lea	rcx, 80[rsp]	 #,
	mov	rbp, rdx	 # tmp305, tmp305
	lea	r15, 80[rsp]	 # tmp304,
	call	push_field	 #
 # dataframe.c:123:             if (!push_field(&fields, &fields_len, &fields_cap, &buf, &buf_len, &buf_cap)) {
	test	eax, eax	 # _34
	jne	.L58	 #,
 # dataframe.c:124:               free_fields(fields, fields_len);
	mov	rdi, QWORD PTR 80[rsp]	 # fields.60_36, fields
 # dataframe.c:20:   if (!fields) return;
	test	rdi, rdi	 # fields.60_36
	je	.L36	 #,
 # dataframe.c:124:               free_fields(fields, fields_len);
	mov	rax, QWORD PTR 88[rsp]	 # fields_len.59_35, fields_len
	mov	rbx, rdi	 # ivtmp.141, fields.60_36
	lea	rsi, [rdi+rax*8]	 # _22,
 # dataframe.c:21:   for (size_t i = 0; i < count; i++) {
	test	rax, rax	 # fields_len.59_35
	je	.L88	 #,
	.p2align 4
	.p2align 3
.L61:
 # dataframe.c:22:     free(fields[i]);
	mov	rcx, QWORD PTR [rbx]	 # MEM[(char * *)_198], MEM[(char * *)_198]
 # dataframe.c:21:   for (size_t i = 0; i < count; i++) {
	add	rbx, 8	 # ivtmp.141,
 # dataframe.c:22:     free(fields[i]);
	call	free	 #
 # dataframe.c:21:   for (size_t i = 0; i < count; i++) {
	cmp	rsi, rbx	 # _22, ivtmp.141
	jne	.L61	 #,
.L88:
 # dataframe.c:24:   free(fields);
	mov	rcx, rdi	 #, fields.79_72
	call	free	 #
.L36:
 # dataframe.c:93:         free(buf);
	mov	rcx, QWORD PTR 104[rsp]	 #, buf
	call	free	 #
.L43:
 # dataframe.c:63:   if (!out_fields || !out_count) return -1;
	mov	eax, -1	 # <retval>,
.L27:
 # dataframe.c:205: }
	add	rsp, 136	 #,
	pop	rbx	 #
	pop	rsi	 #
	pop	rdi	 #
	pop	rbp	 #
	pop	r12	 #
	pop	r13	 #
	pop	r14	 #
	pop	r15	 #
	ret	
	.p2align 4,,10
	.p2align 3
.L58:
 # dataframe.c:89:     int c = fgetc(f);
	mov	rcx, rbx	 #, f
	call	fgetc	 #
	mov	r10d, eax	 # c, c
 # dataframe.c:90:     if (c == EOF) {
	cmp	eax, -1	 # c,
	jne	.L34	 #,
	jmp	.L33	 #
	.p2align 4,,10
	.p2align 3
.L46:
 # dataframe.c:28:   if (*len + 1 >= *cap) {
	mov	rsi, QWORD PTR 112[rsp]	 # _194, buf_len
 # dataframe.c:28:   if (*len + 1 >= *cap) {
	mov	rax, QWORD PTR 120[rsp]	 # _196, buf_cap
 # dataframe.c:93:         free(buf);
	mov	rdi, QWORD PTR 104[rsp]	 # prephitmp_107, buf
 # dataframe.c:28:   if (*len + 1 >= *cap) {
	lea	r9, 1[rsi]	 # _195,
 # dataframe.c:28:   if (*len + 1 >= *cap) {
	cmp	r9, rax	 # _195, _196
	jb	.L49	 #,
 # dataframe.c:29:     size_t ncap = (*cap == 0) ? 16 : (*cap * 2);
	test	rax, rax	 # _196
	lea	rdx, [rax+rax]	 # tmp311,
	mov	eax, 16	 # tmp312,
 # dataframe.c:30:     char *nbuf = (char *)realloc(*buf, ncap);
	mov	rcx, rdi	 #, prephitmp_107
 # dataframe.c:29:     size_t ncap = (*cap == 0) ? 16 : (*cap * 2);
	cmove	rdx, rax	 # tmp311,, ncap, tmp312
	mov	QWORD PTR 56[rsp], r9	 # %sfp, _195
 # dataframe.c:30:     char *nbuf = (char *)realloc(*buf, ncap);
	mov	QWORD PTR 48[rsp], rdx	 # %sfp, ncap
	call	realloc	 #
 # dataframe.c:31:     if (!nbuf) return 0;
	mov	rdx, QWORD PTR 48[rsp]	 # ncap, %sfp
	mov	r9, QWORD PTR 56[rsp]	 # _195, %sfp
	test	rax, rax	 # nbuf
	je	.L212	 #,
 # dataframe.c:32:     *buf = nbuf;
	mov	QWORD PTR 104[rsp], rax	 # buf, nbuf
 # dataframe.c:33:     *cap = ncap;
	mov	rdi, rax	 # prephitmp_107, nbuf
	mov	QWORD PTR 120[rsp], rdx	 # buf_cap, ncap
.L49:
 # dataframe.c:35:   (*buf)[(*len)++] = ch;
	mov	QWORD PTR 112[rsp], r9	 # buf_len, _195
 # dataframe.c:35:   (*buf)[(*len)++] = ch;
	mov	BYTE PTR [rdi+rsi], 34	 # *_204,
	jmp	.L202	 #
	.p2align 4,,10
	.p2align 3
.L210:
 # dataframe.c:174:         if (!push_field(&fields, &fields_len, &fields_cap, &buf, &buf_len, &buf_cap)) {
	lea	rdi, 120[rsp]	 # tmp310,
	lea	rsi, 112[rsp]	 # tmp309,
	mov	QWORD PTR 40[rsp], rdi	 #, tmp310
	lea	r9, 104[rsp]	 # tmp308,
	lea	r8, 96[rsp]	 # tmp306,
	mov	QWORD PTR 32[rsp], rsi	 #, tmp309
	lea	rdx, 88[rsp]	 # tmp305,
	mov	r13, r9	 # tmp308, tmp308
	mov	r12, r8	 # tmp306, tmp306
	lea	rcx, 80[rsp]	 #,
	mov	rbp, rdx	 # tmp305, tmp305
	lea	r15, 80[rsp]	 # tmp304,
	call	push_field	 #
 # dataframe.c:174:         if (!push_field(&fields, &fields_len, &fields_cap, &buf, &buf_len, &buf_cap)) {
	test	eax, eax	 # _70
	jne	.L58	 #,
 # dataframe.c:175:           free_fields(fields, fields_len);
	mov	rdi, QWORD PTR 80[rsp]	 # fields.79_72, fields
 # dataframe.c:20:   if (!fields) return;
	test	rdi, rdi	 # fields.79_72
	je	.L36	 #,
 # dataframe.c:175:           free_fields(fields, fields_len);
	mov	rax, QWORD PTR 88[rsp]	 # fields_len.78_71, fields_len
	mov	rbx, rdi	 # ivtmp.153, fields.79_72
	lea	rsi, [rdi+rax*8]	 # _352,
 # dataframe.c:21:   for (size_t i = 0; i < count; i++) {
	test	rax, rax	 # fields_len.78_71
	je	.L88	 #,
	.p2align 4
	.p2align 3
.L87:
 # dataframe.c:22:     free(fields[i]);
	mov	rcx, QWORD PTR [rbx]	 # MEM[(char * *)_349], MEM[(char * *)_349]
 # dataframe.c:21:   for (size_t i = 0; i < count; i++) {
	add	rbx, 8	 # ivtmp.153,
 # dataframe.c:22:     free(fields[i]);
	call	free	 #
 # dataframe.c:21:   for (size_t i = 0; i < count; i++) {
	cmp	rbx, rsi	 # ivtmp.153, _352
	jne	.L87	 #,
	jmp	.L88	 #
	.p2align 4,,10
	.p2align 3
.L208:
 # dataframe.c:70:       int d = fgetc(f);
	mov	rcx, rbx	 #, f
	call	fgetc	 #
 # dataframe.c:71:       if (d != '\n' && d != EOF) ungetc(d, f);
	cmp	eax, 10	 # d,
	je	.L28	 #,
	cmp	eax, -1	 # d,
	je	.L28	 #,
 # dataframe.c:71:       if (d != '\n' && d != EOF) ungetc(d, f);
	mov	rdx, rbx	 #, f
	mov	ecx, eax	 #, d
	call	ungetc	 #
	jmp	.L28	 #
	.p2align 4,,10
	.p2align 3
.L109:
 # dataframe.c:68:     if (c == EOF) return 0;
	xor	eax, eax	 # <retval>
	jmp	.L27	 #
.L207:
	lea	r13, 104[rsp]	 # tmp308,
	lea	r12, 96[rsp]	 # tmp306,
	lea	rbp, 88[rsp]	 # tmp305,
	lea	r15, 80[rsp]	 # tmp304,
	lea	rdi, 120[rsp]	 # tmp310,
	lea	rsi, 112[rsp]	 # tmp309,
.L33:
 # dataframe.c:96:       if (!push_field(&fields, &fields_len, &fields_cap, &buf, &buf_len, &buf_cap)) {
	mov	QWORD PTR 32[rsp], rsi	 #, tmp309
	mov	r8, r12	 #, tmp306
	mov	rcx, r15	 #, tmp304
	mov	r9, r13	 #, tmp308
	mov	QWORD PTR 40[rsp], rdi	 #, tmp310
	mov	rdx, rbp	 #, tmp305
	call	push_field	 #
 # dataframe.c:98:         free(buf);
	mov	r15, QWORD PTR 104[rsp]	 # pretmp_30, buf
 # dataframe.c:97:         free_fields(fields, fields_len);
	mov	rsi, QWORD PTR 80[rsp]	 # _101, fields
	mov	r8, QWORD PTR 88[rsp]	 # _66, fields_len
 # dataframe.c:96:       if (!push_field(&fields, &fields_len, &fields_cap, &buf, &buf_len, &buf_cap)) {
	test	eax, eax	 # _17
	jne	.L213	 #,
 # dataframe.c:20:   if (!fields) return;
	test	rsi, rsi	 # _101
	je	.L39	 #,
	mov	rbx, rsi	 # ivtmp.133, _101
	lea	rdi, [rsi+r8*8]	 # _184,
 # dataframe.c:21:   for (size_t i = 0; i < count; i++) {
	test	r8, r8	 # _66
	je	.L42	 #,
	.p2align 4
	.p2align 3
.L41:
 # dataframe.c:22:     free(fields[i]);
	mov	rcx, QWORD PTR [rbx]	 # MEM[(char * *)_221], MEM[(char * *)_221]
 # dataframe.c:21:   for (size_t i = 0; i < count; i++) {
	add	rbx, 8	 # ivtmp.133,
 # dataframe.c:22:     free(fields[i]);
	call	free	 #
 # dataframe.c:21:   for (size_t i = 0; i < count; i++) {
	cmp	rbx, rdi	 # ivtmp.133, _184
	jne	.L41	 #,
.L42:
 # dataframe.c:24:   free(fields);
	mov	rcx, rsi	 #, _101
	call	free	 #
.L39:
 # dataframe.c:98:         free(buf);
	mov	rcx, r15	 #, pretmp_30
	call	free	 #
 # dataframe.c:99:         return -1;
	jmp	.L43	 #
.L77:
 # dataframe.c:92:         free_fields(fields, fields_len);
	mov	rdi, QWORD PTR 80[rsp]	 # fields.47_15, fields
 # dataframe.c:20:   if (!fields) return;
	test	rdi, rdi	 # fields.47_15
	je	.L36	 #,
 # dataframe.c:92:         free_fields(fields, fields_len);
	mov	rax, QWORD PTR 88[rsp]	 # fields_len.46_14, fields_len
	mov	rbx, rdi	 # ivtmp.129, fields.47_15
	lea	rsi, [rdi+rax*8]	 # _226,
 # dataframe.c:21:   for (size_t i = 0; i < count; i++) {
	test	rax, rax	 # fields_len.46_14
	je	.L88	 #,
	.p2align 4
	.p2align 3
.L37:
 # dataframe.c:22:     free(fields[i]);
	mov	rcx, QWORD PTR [rbx]	 # MEM[(char * *)_78], MEM[(char * *)_78]
 # dataframe.c:21:   for (size_t i = 0; i < count; i++) {
	add	rbx, 8	 # ivtmp.129,
 # dataframe.c:22:     free(fields[i]);
	call	free	 #
 # dataframe.c:21:   for (size_t i = 0; i < count; i++) {
	cmp	rbx, rsi	 # ivtmp.129, _226
	jne	.L37	 #,
	jmp	.L88	 #
.L113:
 # dataframe.c:183:         if (!push_field(&fields, &fields_len, &fields_cap, &buf, &buf_len, &buf_cap)) {
	lea	rax, 120[rsp]	 # tmp285,
	lea	r8, 96[rsp]	 #,
	mov	DWORD PTR 48[rsp], r10d	 # %sfp, c
	mov	QWORD PTR 40[rsp], rax	 #, tmp285
	lea	rax, 112[rsp]	 # tmp286,
	lea	rdx, 88[rsp]	 # tmp283,
	mov	QWORD PTR 32[rsp], rax	 #, tmp286
	lea	rcx, 80[rsp]	 # tmp284,
	lea	r9, 104[rsp]	 #,
	call	push_field	 #
 # dataframe.c:97:         free_fields(fields, fields_len);
	mov	rsi, QWORD PTR 80[rsp]	 # _101, fields
	mov	r8, QWORD PTR 88[rsp]	 # _66, fields_len
 # dataframe.c:183:         if (!push_field(&fields, &fields_len, &fields_cap, &buf, &buf_len, &buf_cap)) {
	test	eax, eax	 # _77
	jne	.L91	 #,
 # dataframe.c:20:   if (!fields) return;
	test	rsi, rsi	 # _101
	je	.L36	 #,
	mov	rbx, rsi	 # ivtmp.157, _101
	lea	rdi, [rsi+r8*8]	 # _359,
 # dataframe.c:21:   for (size_t i = 0; i < count; i++) {
	test	r8, r8	 # _66
	je	.L95	 #,
	.p2align 4
	.p2align 3
.L94:
 # dataframe.c:22:     free(fields[i]);
	mov	rcx, QWORD PTR [rbx]	 # MEM[(char * *)_356], MEM[(char * *)_356]
 # dataframe.c:21:   for (size_t i = 0; i < count; i++) {
	add	rbx, 8	 # ivtmp.157,
 # dataframe.c:22:     free(fields[i]);
	call	free	 #
 # dataframe.c:21:   for (size_t i = 0; i < count; i++) {
	cmp	rbx, rdi	 # ivtmp.157, _359
	jne	.L94	 #,
.L95:
 # dataframe.c:24:   free(fields);
	mov	rcx, rsi	 #, _101
	call	free	 #
	jmp	.L36	 #
.L213:
 # dataframe.c:101:       free(buf);
	mov	rcx, r15	 #, pretmp_30
	mov	QWORD PTR 48[rsp], r8	 # %sfp, _66
	call	free	 #
 # dataframe.c:104:       return 1;
	mov	r8, QWORD PTR 48[rsp]	 # _66, %sfp
.L44:
 # dataframe.c:143:               *out_fields = fields;
	mov	rax, QWORD PTR 224[rsp]	 # tmp370, out_fields
	mov	QWORD PTR [rax], rsi	 # *out_fields_1(D), _101
 # dataframe.c:144:               *out_count = fields_len;
	mov	rax, QWORD PTR 232[rsp]	 # tmp371, out_count
	mov	QWORD PTR [rax], r8	 # *out_count_3(D), _66
 # dataframe.c:104:       return 1;
	mov	eax, 1	 # <retval>,
	jmp	.L27	 #
.L91:
 # dataframe.c:188:         if (c == '\r') {
	cmp	DWORD PTR 48[rsp], 13	 # %sfp,
	je	.L214	 #,
.L97:
 # dataframe.c:192:         free(buf);
	mov	rcx, QWORD PTR 104[rsp]	 #, buf
	mov	QWORD PTR 48[rsp], r8	 # %sfp, _66
	call	free	 #
 # dataframe.c:195:         return 1;
	mov	r8, QWORD PTR 48[rsp]	 # _66, %sfp
	jmp	.L44	 #
.L57:
	lea	eax, 1[r10]	 # _258,
	cmp	eax, 14	 # _258,
	ja	.L63	 #,
	mov	edx, 18433	 # tmp250,
	bt	rdx, rax	 # tmp250, _258
	jnc	.L63	 #,
 # dataframe.c:132:             if (!push_field(&fields, &fields_len, &fields_cap, &buf, &buf_len, &buf_cap)) {
	lea	rax, 120[rsp]	 # tmp256,
	lea	r8, 96[rsp]	 #,
	mov	DWORD PTR 48[rsp], r10d	 # %sfp, next
	mov	QWORD PTR 40[rsp], rax	 #, tmp256
	lea	rax, 112[rsp]	 # tmp257,
	lea	rdx, 88[rsp]	 # tmp254,
	mov	QWORD PTR 32[rsp], rax	 #, tmp257
	lea	rcx, 80[rsp]	 # tmp255,
	lea	r9, 104[rsp]	 #,
	call	push_field	 #
 # dataframe.c:125:               free(buf);
	mov	rdi, QWORD PTR 104[rsp]	 # pretmp_202, buf
 # dataframe.c:124:               free_fields(fields, fields_len);
	mov	rsi, QWORD PTR 80[rsp]	 # _101, fields
 # dataframe.c:132:             if (!push_field(&fields, &fields_len, &fields_cap, &buf, &buf_len, &buf_cap)) {
	test	eax, eax	 # _41
 # dataframe.c:124:               free_fields(fields, fields_len);
	mov	r8, QWORD PTR 88[rsp]	 # _66, fields_len
 # dataframe.c:132:             if (!push_field(&fields, &fields_len, &fields_cap, &buf, &buf_len, &buf_cap)) {
	mov	r10d, DWORD PTR 48[rsp]	 # next, %sfp
	je	.L215	 #,
 # dataframe.c:137:             if (next == '\r') {
	cmp	r10d, 13	 # next,
	je	.L216	 #,
.L68:
 # dataframe.c:147:             free(buf);
	mov	rcx, rdi	 #, pretmp_202
	mov	QWORD PTR 48[rsp], r8	 # %sfp, _66
	call	free	 #
 # dataframe.c:150:             return 1;
	mov	r8, QWORD PTR 48[rsp]	 # _66, %sfp
	jmp	.L44	 #
.L63:
 # dataframe.c:153:             free_fields(fields, fields_len);
	mov	rdi, QWORD PTR 80[rsp]	 # fields.72_56, fields
 # dataframe.c:20:   if (!fields) return;
	test	rdi, rdi	 # fields.72_56
	je	.L36	 #,
 # dataframe.c:153:             free_fields(fields, fields_len);
	mov	rax, QWORD PTR 88[rsp]	 # fields_len.71_55, fields_len
	mov	rbx, rdi	 # ivtmp.145, fields.72_56
	lea	rsi, [rdi+rax*8]	 # _338,
 # dataframe.c:21:   for (size_t i = 0; i < count; i++) {
	test	rax, rax	 # fields_len.71_55
	je	.L88	 #,
.L72:
 # dataframe.c:22:     free(fields[i]);
	mov	rcx, QWORD PTR [rbx]	 # MEM[(char * *)_20], MEM[(char * *)_20]
 # dataframe.c:21:   for (size_t i = 0; i < count; i++) {
	add	rbx, 8	 # ivtmp.145,
 # dataframe.c:22:     free(fields[i]);
	call	free	 #
 # dataframe.c:21:   for (size_t i = 0; i < count; i++) {
	cmp	rbx, rsi	 # ivtmp.145, _338
	jne	.L72	 #,
	jmp	.L88	 #
.L214:
 # dataframe.c:189:           int d = fgetc(f);
	mov	rcx, rbx	 #, f
	mov	QWORD PTR 48[rsp], r8	 # %sfp, _66
	call	fgetc	 #
 # dataframe.c:190:           if (d != '\n' && d != EOF) ungetc(d, f);
	mov	r8, QWORD PTR 48[rsp]	 # _66, %sfp
	cmp	eax, 10	 # d,
	je	.L97	 #,
	cmp	eax, -1	 # d,
	je	.L97	 #,
 # dataframe.c:190:           if (d != '\n' && d != EOF) ungetc(d, f);
	mov	rdx, rbx	 #, f
	mov	ecx, eax	 #, d
	call	ungetc	 #
	mov	r8, QWORD PTR 48[rsp]	 # _66, %sfp
	jmp	.L97	 #
.L215:
 # dataframe.c:20:   if (!fields) return;
	test	rsi, rsi	 # _101
	je	.L79	 #,
	mov	rdx, r8	 #, _66
	mov	rcx, rsi	 #, _101
	call	free_fields.part.0	 #
	.p2align 4
	.p2align 3
.L79:
 # dataframe.c:161:           free(buf);
	mov	rcx, rdi	 #, pretmp_203
	call	free	 #
 # dataframe.c:162:           return -1;
	jmp	.L43	 #
.L76:
 # dataframe.c:160:           free_fields(fields, fields_len);
	mov	rax, QWORD PTR 80[rsp]	 # fields.75_62, fields
	mov	r15, rax	 # fields.75_62, fields.75_62
 # dataframe.c:20:   if (!fields) return;
	test	rax, rax	 # fields.75_62
	je	.L79	 #,
 # dataframe.c:160:           free_fields(fields, fields_len);
	mov	rax, QWORD PTR 88[rsp]	 # fields_len.74_61, fields_len
 # dataframe.c:21:   for (size_t i = 0; i < count; i++) {
	test	rax, rax	 # fields_len.74_61
	je	.L82	 #,
	mov	rbx, r15	 # ivtmp.149, fields.75_62
	lea	rsi, [r15+rax*8]	 # _345,
	.p2align 4
	.p2align 3
.L81:
 # dataframe.c:22:     free(fields[i]);
	mov	rcx, QWORD PTR [rbx]	 # MEM[(char * *)_342], MEM[(char * *)_342]
 # dataframe.c:21:   for (size_t i = 0; i < count; i++) {
	add	rbx, 8	 # ivtmp.149,
 # dataframe.c:22:     free(fields[i]);
	call	free	 #
 # dataframe.c:21:   for (size_t i = 0; i < count; i++) {
	cmp	rbx, rsi	 # ivtmp.149, _345
	jne	.L81	 #,
.L82:
 # dataframe.c:24:   free(fields);
	mov	rcx, r15	 #, fields.75_62
	call	free	 #
	jmp	.L79	 #
.L216:
 # dataframe.c:138:               int nn = fgetc(f);
	mov	rcx, rbx	 #, f
	mov	QWORD PTR 48[rsp], r8	 # %sfp, _66
	call	fgetc	 #
 # dataframe.c:139:               if (nn != '\n' && nn != EOF) ungetc(nn, f);
	mov	r8, QWORD PTR 48[rsp]	 # _66, %sfp
	cmp	eax, 10	 # nn,
	je	.L68	 #,
	cmp	eax, -1	 # nn,
	je	.L68	 #,
 # dataframe.c:139:               if (nn != '\n' && nn != EOF) ungetc(nn, f);
	mov	rdx, rbx	 #, f
	mov	ecx, eax	 #, nn
	call	ungetc	 #
	mov	r8, QWORD PTR 48[rsp]	 # _66, %sfp
	jmp	.L68	 #
.L101:
 # dataframe.c:198:         free_fields(fields, fields_len);
	mov	rax, QWORD PTR 80[rsp]	 # fields.88_92, fields
	mov	r15, rax	 # fields.88_92, fields.88_92
 # dataframe.c:20:   if (!fields) return;
	test	rax, rax	 # fields.88_92
	je	.L102	 #,
 # dataframe.c:198:         free_fields(fields, fields_len);
	mov	rax, QWORD PTR 88[rsp]	 # fields_len.87_91, fields_len
 # dataframe.c:21:   for (size_t i = 0; i < count; i++) {
	test	rax, rax	 # fields_len.87_91
	je	.L105	 #,
	mov	rbx, r15	 # ivtmp.161, fields.88_92
	lea	rdi, [r15+rax*8]	 # _366,
	.p2align 4
	.p2align 3
.L104:
 # dataframe.c:22:     free(fields[i]);
	mov	rcx, QWORD PTR [rbx]	 # MEM[(char * *)_363], MEM[(char * *)_363]
 # dataframe.c:21:   for (size_t i = 0; i < count; i++) {
	add	rbx, 8	 # ivtmp.161,
 # dataframe.c:22:     free(fields[i]);
	call	free	 #
 # dataframe.c:21:   for (size_t i = 0; i < count; i++) {
	cmp	rbx, rdi	 # ivtmp.161, _366
	jne	.L104	 #,
.L105:
 # dataframe.c:24:   free(fields);
	mov	rcx, r15	 #, fields.88_92
	call	free	 #
.L102:
 # dataframe.c:199:         free(buf);
	mov	rcx, rsi	 #, prephitmp_273
	call	free	 #
 # dataframe.c:200:         return -1;
	jmp	.L43	 #
.L212:
 # dataframe.c:112:             free_fields(fields, fields_len);
	mov	rax, QWORD PTR 80[rsp]	 # fields.56_27, fields
	mov	r15, rax	 # fields.56_27, fields.56_27
 # dataframe.c:20:   if (!fields) return;
	test	rax, rax	 # fields.56_27
	je	.L79	 #,
 # dataframe.c:112:             free_fields(fields, fields_len);
	mov	rax, QWORD PTR 88[rsp]	 # fields_len.55_26, fields_len
 # dataframe.c:21:   for (size_t i = 0; i < count; i++) {
	test	rax, rax	 # fields_len.55_26
	je	.L82	 #,
	mov	rbx, r15	 # ivtmp.137, fields.56_27
	lea	rsi, [r15+rax*8]	 # _42,
	.p2align 4
	.p2align 3
.L55:
 # dataframe.c:22:     free(fields[i]);
	mov	rcx, QWORD PTR [rbx]	 # MEM[(char * *)_52], MEM[(char * *)_52]
 # dataframe.c:21:   for (size_t i = 0; i < count; i++) {
	add	rbx, 8	 # ivtmp.137,
 # dataframe.c:22:     free(fields[i]);
	call	free	 #
 # dataframe.c:21:   for (size_t i = 0; i < count; i++) {
	cmp	rsi, rbx	 # _42, ivtmp.137
	jne	.L55	 #,
	jmp	.L82	 #
	.seh_endproc
	.section .rdata,"dr"
.LC0:
	.ascii "rb\0"
	.text
	.p2align 4
	.globl	read_csv
	.def	read_csv;	.scl	2;	.type	32;	.endef
	.seh_proc	read_csv
read_csv:
	push	r15	 #
	.seh_pushreg	r15
	push	r14	 #
	.seh_pushreg	r14
	push	r13	 #
	.seh_pushreg	r13
	push	r12	 #
	.seh_pushreg	r12
	push	rbp	 #
	.seh_pushreg	rbp
	push	rdi	 #
	.seh_pushreg	rdi
	push	rsi	 #
	.seh_pushreg	rsi
	push	rbx	 #
	.seh_pushreg	rbx
	sub	rsp, 120	 #,
	.seh_stackalloc	120
	.seh_endprologue
 # dataframe.c:217: DataFrame *read_csv(const char *filename, char delimiter) {
	mov	ebx, edx	 # delimiter, delimiter
 # dataframe.c:218:   FILE *f = fopen(filename, "rb");
	lea	rdx, .LC0[rip]	 #,
	call	fopen	 #
	mov	r15, rax	 # f,
 # dataframe.c:219:   if (!f) return NULL;
	test	rax, rax	 # f
	je	.L219	 #,
 # dataframe.c:223:   int pr = parse_record(f, delimiter, &headers, &hcount);
	movsx	eax, bl	 # _1, delimiter
	lea	r9, 88[rsp]	 #,
	lea	r8, 80[rsp]	 #,
	mov	rcx, r15	 #, f
	mov	edx, eax	 #, _1
	mov	DWORD PTR 48[rsp], eax	 # %sfp, _1
 # dataframe.c:221:   char **headers = NULL;
	mov	QWORD PTR 80[rsp], 0	 # headers,
 # dataframe.c:222:   size_t hcount = 0;
	mov	QWORD PTR 88[rsp], 0	 # hcount,
 # dataframe.c:223:   int pr = parse_record(f, delimiter, &headers, &hcount);
	call	parse_record.constprop.0	 #
 # dataframe.c:226:     if (headers) free_fields(headers, hcount);
	mov	rdx, QWORD PTR 80[rsp]	 # pretmp_224, headers
	mov	QWORD PTR 72[rsp], rdx	 # %sfp, pretmp_224
 # dataframe.c:224:   if (pr != 1) {
	cmp	eax, 1	 # pr,
	jne	.L361	 #,
 # dataframe.c:230:   if (hcount > 0) {
	mov	rsi, QWORD PTR 88[rsp]	 # hcount.3_5, hcount
 # dataframe.c:230:   if (hcount > 0) {
	test	rsi, rsi	 # hcount.3_5
	jne	.L362	 #,
.L226:
 # dataframe.c:282:       char **shrunk = (char **)realloc(fields, hcount * sizeof(char *));
	lea	rax, 0[0+rsi*8]	 # _34,
	xor	ebx, ebx	 # ivtmp.253
	xor	r13d, r13d	 # rows_cap
	xor	r12d, r12d	 # rows
	mov	QWORD PTR 40[rsp], rax	 # %sfp, _34
	lea	rax, 104[rsp]	 # tmp243,
	mov	QWORD PTR 64[rsp], rax	 # %sfp, tmp243
	lea	rax, 96[rsp]	 # tmp242,
	mov	QWORD PTR 56[rsp], rax	 # %sfp, tmp242
	jmp	.L280	 #
	.p2align 4,,10
	.p2align 3
.L269:
 # dataframe.c:303:     rows[rows_len++] = fields;
	mov	QWORD PTR [r12+rbx*8], rbp	 # *_45, prephitmp_60
 # dataframe.c:237:   for (;;) {
	add	rbx, 1	 # ivtmp.253,
.L280:
 # dataframe.c:240:     pr = parse_record(f, delimiter, &fields, &count);
	mov	r9, QWORD PTR 64[rsp]	 #, %sfp
	mov	r8, QWORD PTR 56[rsp]	 #, %sfp
	mov	rcx, r15	 #, f
 # dataframe.c:238:     char **fields = NULL;
	mov	QWORD PTR 96[rsp], 0	 # fields,
 # dataframe.c:239:     size_t count = 0;
	mov	QWORD PTR 104[rsp], 0	 # count,
 # dataframe.c:240:     pr = parse_record(f, delimiter, &fields, &count);
	mov	edx, DWORD PTR 48[rsp]	 #, %sfp
	call	parse_record.constprop.0	 #
 # dataframe.c:241:     if (pr == 0) break;         // EOF
	test	eax, eax	 # pr
	je	.L227	 #,
 # dataframe.c:242:     if (pr == -1) {             // parse error
	cmp	eax, -1	 # pr,
	je	.L363	 #,
 # dataframe.c:252:     if (count < hcount) {
	mov	rdi, QWORD PTR 104[rsp]	 # count.8_13, count
 # dataframe.c:253:       char **nf = (char **)realloc(fields, hcount * sizeof(char *));
	mov	rbp, QWORD PTR 96[rsp]	 # prephitmp_60, fields
 # dataframe.c:252:     if (count < hcount) {
	cmp	rdi, rsi	 # count.8_13, hcount.3_5
	jb	.L364	 #,
 # dataframe.c:280:     } else if (count > hcount) {
	cmp	rsi, rdi	 # hcount.3_5, count.8_13
	jb	.L365	 #,
.L266:
 # dataframe.c:287:     if (rows_len == rows_cap) {
	cmp	r13, rbx	 # rows_cap, ivtmp.253
	jne	.L269	 #,
 # dataframe.c:288:       size_t ncap = rows_cap ? (rows_cap * 2) : 8;
	test	r13, r13	 # rows_cap
	je	.L288	 #,
 # dataframe.c:289:       char ***nr = (char ***)realloc(rows, ncap * sizeof(char **));
	mov	rdx, r13	 # _266, rows_cap
 # dataframe.c:288:       size_t ncap = rows_cap ? (rows_cap * 2) : 8;
	add	r13, r13	 # rows_cap, rows_cap
 # dataframe.c:289:       char ***nr = (char ***)realloc(rows, ncap * sizeof(char **));
	sal	rdx, 4	 # _266,
.L270:
 # dataframe.c:289:       char ***nr = (char ***)realloc(rows, ncap * sizeof(char **));
	mov	rcx, r12	 #, rows
	call	realloc	 #
 # dataframe.c:290:       if (!nr) {
	test	rax, rax	 # nr
	je	.L366	 #,
 # dataframe.c:300:       rows = nr;
	mov	r12, rax	 # rows, nr
	jmp	.L269	 #
	.p2align 4,,10
	.p2align 3
.L365:
	mov	rax, QWORD PTR 40[rsp]	 # _34, %sfp
	lea	rdi, 0[rbp+rdi*8]	 # _379,
	lea	r14, [rax+rbp]	 # ivtmp.251,
	.p2align 4
	.p2align 3
.L267:
 # dataframe.c:281:       for (size_t j = hcount; j < count; j++) free(fields[j]);
	mov	rcx, QWORD PTR [r14]	 # MEM[(char * *)_376], MEM[(char * *)_376]
 # dataframe.c:281:       for (size_t j = hcount; j < count; j++) free(fields[j]);
	add	r14, 8	 # ivtmp.251,
 # dataframe.c:281:       for (size_t j = hcount; j < count; j++) free(fields[j]);
	call	free	 #
 # dataframe.c:281:       for (size_t j = hcount; j < count; j++) free(fields[j]);
	cmp	r14, rdi	 # ivtmp.251, _379
	jne	.L267	 #,
 # dataframe.c:282:       char **shrunk = (char **)realloc(fields, hcount * sizeof(char *));
	mov	rdx, QWORD PTR 40[rsp]	 #, %sfp
	mov	rcx, rbp	 #, prephitmp_60
	call	realloc	 #
 # dataframe.c:284:       count = hcount;
	mov	QWORD PTR 104[rsp], rsi	 # count, hcount.3_5
 # dataframe.c:283:       if (shrunk) fields = shrunk;
	test	rax, rax	 # shrunk
 # dataframe.c:284:       count = hcount;
	cmovne	rbp, rax	 # shrunk,, prephitmp_60
	jmp	.L266	 #
	.p2align 4,,10
	.p2align 3
.L288:
	mov	edx, 64	 # _266,
 # dataframe.c:288:       size_t ncap = rows_cap ? (rows_cap * 2) : 8;
	mov	r13d, 8	 # rows_cap,
	jmp	.L270	 #
	.p2align 4,,10
	.p2align 3
.L364:
 # dataframe.c:253:       char **nf = (char **)realloc(fields, hcount * sizeof(char *));
	mov	rdx, QWORD PTR 40[rsp]	 #, %sfp
	mov	rcx, rbp	 #, prephitmp_60
	call	realloc	 #
	mov	r14, rax	 # nf,
 # dataframe.c:254:       if (!nf) {
	test	rax, rax	 # nf
	je	.L367	 #,
 # dataframe.c:265:       for (size_t j = count; j < hcount; j++) {
	mov	rbp, rdi	 # j, count.8_13
	.p2align 4
	.p2align 3
.L242:
 # dataframe.c:13:   char *p = (char *)malloc(len + 1);
	mov	ecx, 1	 #,
	call	malloc	 #
 # dataframe.c:14:   if (!p) return NULL;
	test	rax, rax	 # tmp253
	je	.L368	 #,
 # dataframe.c:15:   memcpy(p, s, len + 1);
	mov	BYTE PTR [rax], 0	 # MEM <char[1:1]> [(void *)p_199],
 # dataframe.c:266:         fields[j] = xstrdup("");
	mov	QWORD PTR [r14+rbp*8], rax	 # MEM[(char * *)nf_104 + j_197 * 8], tmp253
 # dataframe.c:265:       for (size_t j = count; j < hcount; j++) {
	add	rbp, 1	 # j,
 # dataframe.c:265:       for (size_t j = count; j < hcount; j++) {
	cmp	rbp, rsi	 # j, hcount.3_5
	jb	.L242	 #,
 # dataframe.c:279:       count = hcount;
	mov	QWORD PTR 104[rsp], rsi	 # count, hcount.3_5
	mov	rbp, r14	 # prephitmp_60, nf
	jmp	.L266	 #
.L363:
 # dataframe.c:20:   if (!fields) return;
	mov	rax, QWORD PTR 72[rsp]	 # pretmp_224, %sfp
	test	rax, rax	 # pretmp_224
	je	.L229	 #,
	mov	rdx, QWORD PTR 40[rsp]	 # _34, %sfp
	mov	rdi, rax	 # ivtmp.203, pretmp_224
	lea	rbp, [rdx+rax]	 # _276,
 # dataframe.c:21:   for (size_t i = 0; i < count; i++) {
	test	rsi, rsi	 # hcount.3_5
	je	.L232	 #,
	.p2align 4
	.p2align 3
.L231:
 # dataframe.c:22:     free(fields[i]);
	mov	rcx, QWORD PTR [rdi]	 # MEM[(char * *)_47], MEM[(char * *)_47]
 # dataframe.c:21:   for (size_t i = 0; i < count; i++) {
	add	rdi, 8	 # ivtmp.203,
 # dataframe.c:22:     free(fields[i]);
	call	free	 #
 # dataframe.c:21:   for (size_t i = 0; i < count; i++) {
	cmp	rdi, rbp	 # ivtmp.203, _276
	jne	.L231	 #,
.L232:
 # dataframe.c:24:   free(fields);
	mov	rcx, QWORD PTR 72[rsp]	 #, %sfp
	call	free	 #
.L229:
	mov	rdi, r12	 # ivtmp.199, rows
	lea	rbp, [r12+rbx*8]	 # _40,
 # dataframe.c:244:       for (size_t r = 0; r < rows_len; r++) {
	test	rbx, rbx	 # ivtmp.253
	je	.L279	 #,
	.p2align 4
	.p2align 3
.L239:
 # dataframe.c:245:         free_fields(rows[r], hcount);
	mov	r13, QWORD PTR [rdi]	 # _12, MEM[(char * * *)_16]
 # dataframe.c:20:   if (!fields) return;
	test	r13, r13	 # _12
	je	.L235	 #,
	mov	rax, QWORD PTR 40[rsp]	 # _34, %sfp
	mov	r14, r13	 # ivtmp.195, _12
	lea	rbx, [rax+r13]	 # _30,
 # dataframe.c:21:   for (size_t i = 0; i < count; i++) {
	test	rsi, rsi	 # hcount.3_5
	je	.L238	 #,
	.p2align 4
	.p2align 3
.L237:
 # dataframe.c:22:     free(fields[i]);
	mov	rcx, QWORD PTR [r14]	 # MEM[(char * *)_74], MEM[(char * *)_74]
 # dataframe.c:21:   for (size_t i = 0; i < count; i++) {
	add	r14, 8	 # ivtmp.195,
 # dataframe.c:22:     free(fields[i]);
	call	free	 #
 # dataframe.c:21:   for (size_t i = 0; i < count; i++) {
	cmp	r14, rbx	 # ivtmp.195, _30
	jne	.L237	 #,
.L238:
 # dataframe.c:24:   free(fields);
	mov	rcx, r13	 #, _12
	call	free	 #
.L235:
 # dataframe.c:244:       for (size_t r = 0; r < rows_len; r++) {
	add	rdi, 8	 # ivtmp.199,
	cmp	rdi, rbp	 # ivtmp.199, _40
	jne	.L239	 #,
.L279:
 # dataframe.c:296:         free(rows);
	mov	rcx, r12	 #, rows
	call	free	 #
 # dataframe.c:297:         fclose(f);
	mov	rcx, r15	 #, f
	call	fclose	 #
.L219:
 # dataframe.c:219:   if (!f) return NULL;
	xor	eax, eax	 # <retval>
.L217:
 # dataframe.c:323: }
	add	rsp, 120	 #,
	pop	rbx	 #
	pop	rsi	 #
	pop	rdi	 #
	pop	rbp	 #
	pop	r12	 #
	pop	r13	 #
	pop	r14	 #
	pop	r15	 #
	ret	
.L362:
 # dataframe.c:231:     strip_bom(headers[0]);
	mov	rax, QWORD PTR 72[rsp]	 # pretmp_224, %sfp
	mov	rbx, QWORD PTR [rax]	 # _7, *pretmp_224
 # dataframe.c:208:   if (!s) return;
	test	rbx, rbx	 # _7
	je	.L226	 #,
 # dataframe.c:209:   if ((unsigned char)s[0] == 0xEF &&
	cmp	BYTE PTR [rbx], -17	 # *_7,
	jne	.L226	 #,
 # dataframe.c:209:   if ((unsigned char)s[0] == 0xEF &&
	cmp	BYTE PTR 1[rbx], -69	 # MEM[(char *)_7 + 1B],
	jne	.L226	 #,
 # dataframe.c:210:       (unsigned char)s[1] == 0xBB &&
	cmp	BYTE PTR 2[rbx], -65	 # MEM[(char *)_7 + 2B],
	jne	.L226	 #,
 # dataframe.c:212:     size_t len = strlen(s);
	mov	rcx, rbx	 #, _7
	call	strlen	 #
 # dataframe.c:213:     memmove(s, s + 3, len - 2);
	lea	rdx, 3[rbx]	 # _181,
 # dataframe.c:213:     memmove(s, s + 3, len - 2);
	mov	rcx, rbx	 #, _7
	lea	r8, -2[rax]	 #,
	call	memmove	 #
	jmp	.L226	 #
	.p2align 4,,10
	.p2align 3
.L361:
 # dataframe.c:225:     fclose(f);
	mov	rcx, r15	 #, f
	call	fclose	 #
 # dataframe.c:226:     if (headers) free_fields(headers, hcount);
	mov	rdx, QWORD PTR 72[rsp]	 # pretmp_224, %sfp
	test	rdx, rdx	 # pretmp_224
	je	.L219	 #,
 # dataframe.c:226:     if (headers) free_fields(headers, hcount);
	mov	rax, QWORD PTR 88[rsp]	 # hcount.1_3, hcount
	mov	rbx, rdx	 # ivtmp.187, pretmp_224
	lea	rsi, [rdx+rax*8]	 # _6,
 # dataframe.c:21:   for (size_t i = 0; i < count; i++) {
	test	rax, rax	 # hcount.1_3
	je	.L225	 #,
	.p2align 4
	.p2align 3
.L224:
 # dataframe.c:22:     free(fields[i]);
	mov	rcx, QWORD PTR [rbx]	 # MEM[(char * *)_138], MEM[(char * *)_138]
 # dataframe.c:21:   for (size_t i = 0; i < count; i++) {
	add	rbx, 8	 # ivtmp.187,
 # dataframe.c:22:     free(fields[i]);
	call	free	 #
 # dataframe.c:21:   for (size_t i = 0; i < count; i++) {
	cmp	rsi, rbx	 # _6, ivtmp.187
	jne	.L224	 #,
.L225:
 # dataframe.c:24:   free(fields);
	mov	rcx, QWORD PTR 72[rsp]	 #, %sfp
	call	free	 #
	jmp	.L219	 #
.L227:
 # dataframe.c:306:   fclose(f);
	mov	rcx, r15	 #, f
	call	fclose	 #
 # dataframe.c:308:   DataFrame *df = (DataFrame *)malloc(sizeof(DataFrame));
	mov	ecx, 32	 #,
	call	malloc	 #
 # dataframe.c:309:   if (!df) {
	test	rax, rax	 # <retval>
	je	.L369	 #,
 # dataframe.c:318:   df->n_rows = rows_len;
	movq	xmm0, rbx	 # _155, ivtmp.253
	movq	xmm1, rsi	 # hcount.3_5, hcount.3_5
 # dataframe.c:320:   df->col_names = headers;
	movq	xmm2, r12	 # rows, rows
 # dataframe.c:318:   df->n_rows = rows_len;
	punpcklqdq	xmm0, xmm1	 # _155, hcount.3_5
	movups	XMMWORD PTR [rax], xmm0	 # MEM <vector(2) long long unsigned int> [(long long unsigned int *)df_137], _155
 # dataframe.c:320:   df->col_names = headers;
	movq	xmm0, QWORD PTR 72[rsp]	 # _65, %sfp
	punpcklqdq	xmm0, xmm2	 # _65, rows
	movups	XMMWORD PTR 16[rax], xmm0	 # MEM <vector(2) long long unsigned int> [(void *)df_137 + 16B], _65
 # dataframe.c:322:   return df;
	jmp	.L217	 #
.L368:
	lea	rax, [r14+rbp*8]	 # _370,
	mov	rsi, r14	 # ivtmp.227, nf
	lea	r13, [r14+rdi*8]	 # ivtmp.232,
	mov	QWORD PTR 48[rsp], rax	 # %sfp, _370
 # dataframe.c:266:         fields[j] = xstrdup("");
	mov	QWORD PTR [rax], 0	 # *_21,
 # dataframe.c:268:           for (size_t k = count; k < j; k++) free(fields[k]);
	cmp	rdi, rbp	 # count.8_13, j
	jnb	.L256	 #,
	.p2align 4
	.p2align 3
.L255:
 # dataframe.c:268:           for (size_t k = count; k < j; k++) free(fields[k]);
	mov	rcx, QWORD PTR 0[r13]	 # MEM[(char * *)_350], MEM[(char * *)_350]
 # dataframe.c:268:           for (size_t k = count; k < j; k++) free(fields[k]);
	add	r13, 8	 # ivtmp.232,
 # dataframe.c:268:           for (size_t k = count; k < j; k++) free(fields[k]);
	call	free	 #
 # dataframe.c:268:           for (size_t k = count; k < j; k++) free(fields[k]);
	cmp	r13, QWORD PTR 48[rsp]	 # ivtmp.232, %sfp
	jne	.L255	 #,
.L256:
	lea	rbp, [r14+rdi*8]	 # _344,
 # dataframe.c:21:   for (size_t i = 0; i < count; i++) {
	test	rdi, rdi	 # count.8_13
	je	.L253	 #,
	.p2align 4
	.p2align 3
.L259:
 # dataframe.c:22:     free(fields[i]);
	mov	rcx, QWORD PTR [rsi]	 # MEM[(char * *)_341], MEM[(char * *)_341]
 # dataframe.c:21:   for (size_t i = 0; i < count; i++) {
	add	rsi, 8	 # ivtmp.227,
 # dataframe.c:22:     free(fields[i]);
	call	free	 #
 # dataframe.c:21:   for (size_t i = 0; i < count; i++) {
	cmp	rsi, rbp	 # ivtmp.227, _344
	jne	.L259	 #,
.L253:
 # dataframe.c:24:   free(fields);
	mov	rcx, r14	 #, nf
	call	free	 #
 # dataframe.c:20:   if (!fields) return;
	cmp	QWORD PTR 72[rsp], 0	 # %sfp,
	je	.L257	 #,
	mov	rax, QWORD PTR 72[rsp]	 # pretmp_224, %sfp
	mov	rdx, QWORD PTR 40[rsp]	 # _34, %sfp
	mov	rsi, rax	 # ivtmp.223, pretmp_224
	lea	rdi, [rdx+rax]	 # _337,
	.p2align 4
	.p2align 3
.L260:
 # dataframe.c:22:     free(fields[i]);
	mov	rcx, QWORD PTR [rsi]	 # MEM[(char * *)_334], MEM[(char * *)_334]
 # dataframe.c:21:   for (size_t i = 0; i < count; i++) {
	add	rsi, 8	 # ivtmp.223,
 # dataframe.c:22:     free(fields[i]);
	call	free	 #
 # dataframe.c:21:   for (size_t i = 0; i < count; i++) {
	cmp	rsi, rdi	 # ivtmp.223, _337
	jne	.L260	 #,
 # dataframe.c:24:   free(fields);
	mov	rcx, QWORD PTR 72[rsp]	 #, %sfp
	call	free	 #
.L257:
	mov	rdi, r12	 # ivtmp.219, rows
	lea	rbp, [r12+rbx*8]	 # _330,
 # dataframe.c:271:           for (size_t r = 0; r < rows_len; r++) {
	test	rbx, rbx	 # ivtmp.253
	je	.L279	 #,
	.p2align 4
	.p2align 3
.L264:
 # dataframe.c:272:             free_fields(rows[r], hcount);
	mov	r13, QWORD PTR [rdi]	 # _29, MEM[(char * * *)_327]
 # dataframe.c:20:   if (!fields) return;
	test	r13, r13	 # _29
	je	.L262	 #,
	mov	rax, QWORD PTR 40[rsp]	 # _34, %sfp
	mov	rbx, r13	 # ivtmp.215, _29
	lea	rsi, [rax+r13]	 # _323,
	.p2align 4
	.p2align 3
.L263:
 # dataframe.c:22:     free(fields[i]);
	mov	rcx, QWORD PTR [rbx]	 # MEM[(char * *)_320], MEM[(char * *)_320]
 # dataframe.c:21:   for (size_t i = 0; i < count; i++) {
	add	rbx, 8	 # ivtmp.215,
 # dataframe.c:22:     free(fields[i]);
	call	free	 #
 # dataframe.c:21:   for (size_t i = 0; i < count; i++) {
	cmp	rbx, rsi	 # ivtmp.215, _323
	jne	.L263	 #,
 # dataframe.c:24:   free(fields);
	mov	rcx, r13	 #, _29
	call	free	 #
.L262:
 # dataframe.c:271:           for (size_t r = 0; r < rows_len; r++) {
	add	rdi, 8	 # ivtmp.219,
	cmp	rdi, rbp	 # ivtmp.219, _330
	jne	.L264	 #,
	jmp	.L279	 #
.L369:
 # dataframe.c:20:   if (!fields) return;
	mov	rax, QWORD PTR 72[rsp]	 # pretmp_224, %sfp
	test	rax, rax	 # pretmp_224
	je	.L283	 #,
	mov	rdx, rsi	 #, hcount.3_5
	mov	rcx, rax	 #, pretmp_224
	call	free_fields.part.0	 #
.L283:
 # dataframe.c:300:       rows = nr;
	xor	edi, edi	 # r
	jmp	.L284	 #
.L286:
 # dataframe.c:312:       free_fields(rows[r], hcount);
	mov	rcx, QWORD PTR [r12+rdi*8]	 # _51, MEM[(char * * *)rows_53 + r_66 * 8]
 # dataframe.c:20:   if (!fields) return;
	test	rcx, rcx	 # _51
	je	.L285	 #,
	mov	rdx, rsi	 #, hcount.3_5
	call	free_fields.part.0	 #
.L285:
 # dataframe.c:311:     for (size_t r = 0; r < rows_len; r++) {
	add	rdi, 1	 # r,
.L284:
 # dataframe.c:311:     for (size_t r = 0; r < rows_len; r++) {
	cmp	rdi, rbx	 # r, ivtmp.253
	jne	.L286	 #,
 # dataframe.c:314:     free(rows);
	mov	rcx, r12	 #, rows
	call	free	 #
 # dataframe.c:315:     return NULL;
	jmp	.L219	 #
.L367:
 # dataframe.c:20:   if (!fields) return;
	test	rbp, rbp	 # prephitmp_60
	je	.L243	 #,
	mov	rdx, rdi	 #, count.8_13
	mov	rcx, rbp	 #, prephitmp_60
	call	free_fields.part.0	 #
.L243:
	mov	rax, QWORD PTR 72[rsp]	 # pretmp_224, %sfp
	test	rax, rax	 # pretmp_224
	je	.L244	 #,
	mov	rdx, rsi	 #, hcount.3_5
	mov	rcx, rax	 #, pretmp_224
	call	free_fields.part.0	 #
.L244:
 # dataframe.c:257:         for (size_t r = 0; r < rows_len; r++) {
	test	rbx, rbx	 # ivtmp.253
	je	.L279	 #,
	mov	rsi, r12	 # ivtmp.211, rows
	lea	rbp, [r12+rbx*8]	 # _316,
.L248:
 # dataframe.c:258:           free_fields(rows[r], hcount);
	mov	rbx, QWORD PTR [rsi]	 # _19, MEM[(char * * *)_158]
 # dataframe.c:20:   if (!fields) return;
	test	rbx, rbx	 # _19
	je	.L246	 #,
	mov	rax, QWORD PTR 40[rsp]	 # _34, %sfp
	mov	rdi, rbx	 # ivtmp.207, _19
	lea	r13, [rax+rbx]	 # _272,
.L247:
 # dataframe.c:22:     free(fields[i]);
	mov	rcx, QWORD PTR [rdi]	 # MEM[(char * *)_165], MEM[(char * *)_165]
 # dataframe.c:21:   for (size_t i = 0; i < count; i++) {
	add	rdi, 8	 # ivtmp.207,
 # dataframe.c:22:     free(fields[i]);
	call	free	 #
 # dataframe.c:21:   for (size_t i = 0; i < count; i++) {
	cmp	rdi, r13	 # ivtmp.207, _272
	jne	.L247	 #,
 # dataframe.c:24:   free(fields);
	mov	rcx, rbx	 #, _19
	call	free	 #
.L246:
 # dataframe.c:257:         for (size_t r = 0; r < rows_len; r++) {
	add	rsi, 8	 # ivtmp.211,
	cmp	rsi, rbp	 # ivtmp.211, _316
	jne	.L248	 #,
	jmp	.L279	 #
.L366:
 # dataframe.c:20:   if (!fields) return;
	test	rbp, rbp	 # prephitmp_60
	je	.L271	 #,
	mov	rdx, QWORD PTR 104[rsp]	 #, count
	mov	rcx, rbp	 #, prephitmp_60
	call	free_fields.part.0	 #
.L271:
	mov	rax, QWORD PTR 72[rsp]	 # pretmp_224, %sfp
	test	rax, rax	 # pretmp_224
	je	.L272	 #,
	mov	rdx, rsi	 #, hcount.3_5
	mov	rcx, rax	 #, pretmp_224
	call	free_fields.part.0	 #
.L272:
 # dataframe.c:293:         for (size_t r = 0; r < rows_len; r++) {
	test	rbx, rbx	 # ivtmp.253
	je	.L279	 #,
	mov	rdi, r12	 # ivtmp.240, rows
	lea	r13, [r12+rbx*8]	 # _367,
.L278:
 # dataframe.c:294:           free_fields(rows[r], hcount);
	mov	rbx, QWORD PTR [rdi]	 # _43, MEM[(char * * *)_364]
 # dataframe.c:20:   if (!fields) return;
	test	rbx, rbx	 # _43
	je	.L274	 #,
	mov	rax, QWORD PTR 40[rsp]	 # _34, %sfp
	mov	rbp, rbx	 # ivtmp.236, _43
	lea	r14, [rax+rbx]	 # _360,
 # dataframe.c:21:   for (size_t i = 0; i < count; i++) {
	test	rsi, rsi	 # hcount.3_5
	je	.L277	 #,
.L276:
 # dataframe.c:22:     free(fields[i]);
	mov	rcx, QWORD PTR 0[rbp]	 # MEM[(char * *)_357], MEM[(char * *)_357]
 # dataframe.c:21:   for (size_t i = 0; i < count; i++) {
	add	rbp, 8	 # ivtmp.236,
 # dataframe.c:22:     free(fields[i]);
	call	free	 #
 # dataframe.c:21:   for (size_t i = 0; i < count; i++) {
	cmp	rbp, r14	 # ivtmp.236, _360
	jne	.L276	 #,
.L277:
 # dataframe.c:24:   free(fields);
	mov	rcx, rbx	 #, _43
	call	free	 #
.L274:
 # dataframe.c:293:         for (size_t r = 0; r < rows_len; r++) {
	add	rdi, 8	 # ivtmp.240,
	cmp	rdi, r13	 # ivtmp.240, _367
	jne	.L278	 #,
	jmp	.L279	 #
	.seh_endproc
	.section .rdata,"dr"
.LC1:
	.ascii "prog\0"
.LC2:
	.ascii "\0"
.LC3:
	.ascii "Usage: %s <csv_filename>\12\0"
.LC4:
	.ascii "Failed to read CSV\0"
.LC5:
	.ascii "File: %s\12\0"
.LC6:
	.ascii "Rows: %zu, Cols: %zu\12\0"
.LC7:
	.ascii "Headers:\0"
.LC8:
	.ascii "  [%zu] %s\12\0"
.LC9:
	.ascii "Data:\0"
.LC10:
	.ascii "%s\0"
.LC11:
	.ascii ", \0"
	.section	.text.startup,"x"
	.p2align 4
	.globl	main
	.def	main;	.scl	2;	.type	32;	.endef
	.seh_proc	main
main:
	push	r12	 #
	.seh_pushreg	r12
	push	rbp	 #
	.seh_pushreg	rbp
	push	rdi	 #
	.seh_pushreg	rdi
	push	rsi	 #
	.seh_pushreg	rsi
	push	rbx	 #
	.seh_pushreg	rbx
	sub	rsp, 32	 #,
	.seh_stackalloc	32
	.seh_endprologue
 # dataframe.c:341: int main(int argc, char *argv[]) {
	mov	esi, ecx	 # argc, argc
	mov	rbx, rdx	 # argv, argv
	call	__main	 #
 # dataframe.c:342:   if (argc < 2) {
	cmp	esi, 1	 # argc,
	jle	.L404	 #,
 # dataframe.c:347:   DataFrame *df = read_csv(argv[1], ',');
	mov	rcx, QWORD PTR 8[rbx]	 # MEM[(char * *)argv_35(D) + 8B], MEM[(char * *)argv_35(D) + 8B]
	mov	edx, 44	 #,
	call	read_csv	 #
	mov	rsi, rax	 # df,
 # dataframe.c:348:   if (!df) {
	test	rax, rax	 # df
	je	.L405	 #,
 # dataframe.c:353:   printf("File: %s\n", argv[1]);
	mov	rdx, QWORD PTR 8[rbx]	 # MEM[(char * *)argv_35(D) + 8B], MEM[(char * *)argv_35(D) + 8B]
	lea	rcx, .LC5[rip]	 #,
	call	printf	 #
 # dataframe.c:354:   printf("Rows: %zu, Cols: %zu\n", df->n_rows, df->n_cols);
	mov	r8, QWORD PTR 8[rsi]	 #, df_38->n_cols
	mov	rdx, QWORD PTR [rsi]	 #, df_38->n_rows
	lea	rcx, .LC6[rip]	 #,
	call	printf	 #
 # dataframe.c:356:   printf("Headers:\n");
	lea	rcx, .LC7[rip]	 #,
	call	puts	 #
 # dataframe.c:357:   for (size_t i = 0; i < df->n_cols; i++) {
	cmp	QWORD PTR 8[rsi], 0	 # df_38->n_cols,
	je	.L376	 #,
 # dataframe.c:357:   for (size_t i = 0; i < df->n_cols; i++) {
	xor	ebx, ebx	 # i
 # dataframe.c:358:     printf("  [%zu] %s\n", i, df->col_names[i] ? df->col_names[i] : "");
	lea	rdi, .LC2[rip]	 # tmp163,
	.p2align 4
	.p2align 3
.L378:
 # dataframe.c:358:     printf("  [%zu] %s\n", i, df->col_names[i] ? df->col_names[i] : "");
	mov	rax, QWORD PTR 16[rsi]	 # df_38->col_names, df_38->col_names
 # dataframe.c:358:     printf("  [%zu] %s\n", i, df->col_names[i] ? df->col_names[i] : "");
	mov	rdx, rbx	 #, i
	lea	rcx, .LC8[rip]	 #,
 # dataframe.c:358:     printf("  [%zu] %s\n", i, df->col_names[i] ? df->col_names[i] : "");
	mov	r8, QWORD PTR [rax+rbx*8]	 # _8, *_7
 # dataframe.c:358:     printf("  [%zu] %s\n", i, df->col_names[i] ? df->col_names[i] : "");
	test	r8, r8	 # _8
 # dataframe.c:358:     printf("  [%zu] %s\n", i, df->col_names[i] ? df->col_names[i] : "");
	cmove	r8, rdi	 # _8,,, tmp163
 # dataframe.c:357:   for (size_t i = 0; i < df->n_cols; i++) {
	add	rbx, 1	 # i,
 # dataframe.c:358:     printf("  [%zu] %s\n", i, df->col_names[i] ? df->col_names[i] : "");
	call	printf	 #
 # dataframe.c:357:   for (size_t i = 0; i < df->n_cols; i++) {
	cmp	rbx, QWORD PTR 8[rsi]	 # i, df_38->n_cols
	jb	.L378	 #,
.L376:
 # dataframe.c:361:   printf("Data:\n");
	lea	rcx, .LC9[rip]	 #,
 # dataframe.c:362:   for (size_t r = 0; r < df->n_rows; r++) {
	xor	edi, edi	 # r
 # dataframe.c:361:   printf("Data:\n");
	call	puts	 #
 # dataframe.c:362:   for (size_t r = 0; r < df->n_rows; r++) {
	cmp	QWORD PTR [rsi], 0	 # df_38->n_rows,
	je	.L380	 #,
 # dataframe.c:364:       printf("%s", df->data[r][c] ? df->data[r][c] : "");
	lea	r12, .LC2[rip]	 # tmp167,
	jmp	.L379	 #
	.p2align 4,,10
	.p2align 3
.L382:
 # dataframe.c:367:     printf("\n");
	mov	ecx, 10	 #,
 # dataframe.c:362:   for (size_t r = 0; r < df->n_rows; r++) {
	add	rdi, 1	 # r,
 # dataframe.c:367:     printf("\n");
	call	putchar	 #
 # dataframe.c:362:   for (size_t r = 0; r < df->n_rows; r++) {
	cmp	rdi, QWORD PTR [rsi]	 # r, df_38->n_rows
	jnb	.L380	 #,
.L379:
	lea	rbp, 0[0+rdi*8]	 # _95,
 # dataframe.c:363:     for (size_t c = 0; c < df->n_cols; c++) {
	xor	ebx, ebx	 # c
 # dataframe.c:363:     for (size_t c = 0; c < df->n_cols; c++) {
	cmp	QWORD PTR 8[rsi], 0	 # df_38->n_cols,
	je	.L382	 #,
	.p2align 4
	.p2align 3
.L383:
 # dataframe.c:364:       printf("%s", df->data[r][c] ? df->data[r][c] : "");
	mov	rax, QWORD PTR 24[rsi]	 # df_38->data, df_38->data
 # dataframe.c:364:       printf("%s", df->data[r][c] ? df->data[r][c] : "");
	lea	rcx, .LC10[rip]	 #,
 # dataframe.c:364:       printf("%s", df->data[r][c] ? df->data[r][c] : "");
	mov	rax, QWORD PTR [rax+rbp]	 # *_12, *_12
	mov	rdx, QWORD PTR [rax+rbx*8]	 # _16, *_15
 # dataframe.c:364:       printf("%s", df->data[r][c] ? df->data[r][c] : "");
	test	rdx, rdx	 # _16
	cmove	rdx, r12	 # _16,, _16, tmp167
 # dataframe.c:365:       if (c + 1 < df->n_cols) printf(", ");
	add	rbx, 1	 # c,
 # dataframe.c:364:       printf("%s", df->data[r][c] ? df->data[r][c] : "");
	call	printf	 #
 # dataframe.c:365:       if (c + 1 < df->n_cols) printf(", ");
	cmp	rbx, QWORD PTR 8[rsi]	 # c, df_38->n_cols
	jnb	.L382	 #,
 # dataframe.c:365:       if (c + 1 < df->n_cols) printf(", ");
	lea	rcx, .LC11[rip]	 #,
	call	printf	 #
 # dataframe.c:363:     for (size_t c = 0; c < df->n_cols; c++) {
	cmp	rbx, QWORD PTR 8[rsi]	 # c, df_38->n_cols
	jb	.L383	 #,
	jmp	.L382	 #
.L380:
 # dataframe.c:327:   if (df->col_names) {
	mov	rcx, QWORD PTR 16[rsi]	 # _53, df_38->col_names
 # dataframe.c:327:   if (df->col_names) {
	test	rcx, rcx	 # _53
	je	.L385	 #,
	mov	rdx, QWORD PTR 8[rsi]	 # df_38->n_cols, df_38->n_cols
	call	free_fields.part.0	 #
.L385:
 # dataframe.c:330:   if (df->data) {
	cmp	QWORD PTR 24[rsi], 0	 # df_38->data,
	je	.L386	 #,
 # dataframe.c:331:     for (size_t r = 0; r < df->n_rows; r++) {
	cmp	QWORD PTR [rsi], 0	 # df_38->n_rows,
	je	.L406	 #,
	mov	rax, QWORD PTR 24[rsi]	 # df_38->data, df_38->data
 # dataframe.c:331:     for (size_t r = 0; r < df->n_rows; r++) {
	xor	ebx, ebx	 # r
	.p2align 4
	.p2align 3
.L389:
 # dataframe.c:332:       if (df->data[r]) {
	mov	rcx, QWORD PTR [rax+rbx*8]	 # _60, *_59
 # dataframe.c:332:       if (df->data[r]) {
	test	rcx, rcx	 # _60
	je	.L388	 #,
	mov	rdx, QWORD PTR 8[rsi]	 # df_38->n_cols, df_38->n_cols
	call	free_fields.part.0	 #
	mov	rax, QWORD PTR 24[rsi]	 # df_38->data, df_38->data
.L388:
 # dataframe.c:331:     for (size_t r = 0; r < df->n_rows; r++) {
	add	rbx, 1	 # r,
 # dataframe.c:331:     for (size_t r = 0; r < df->n_rows; r++) {
	cmp	rbx, QWORD PTR [rsi]	 # r, df_38->n_rows
	jb	.L389	 #,
.L387:
 # dataframe.c:336:     free(df->data);
	mov	rcx, rax	 #, df_38->data
	call	free	 #
.L386:
 # dataframe.c:338:   free(df);
	mov	rcx, rsi	 #, df
	call	free	 #
 # dataframe.c:371:   return 0;
	xor	eax, eax	 # <retval>
.L370:
 # dataframe.c:372: }
	add	rsp, 32	 #,
	pop	rbx	 #
	pop	rsi	 #
	pop	rdi	 #
	pop	rbp	 #
	pop	r12	 #
	ret	
.L404:
 # dataframe.c:343:     printf("Usage: %s <csv_filename>\n", argc > 0 ? argv[0] : "prog");
	lea	rdx, .LC1[rip]	 # iftmp.90_26,
 # dataframe.c:343:     printf("Usage: %s <csv_filename>\n", argc > 0 ? argv[0] : "prog");
	jne	.L372	 #,
 # dataframe.c:343:     printf("Usage: %s <csv_filename>\n", argc > 0 ? argv[0] : "prog");
	mov	rdx, QWORD PTR [rbx]	 # iftmp.90_26, *argv_35(D)
.L372:
 # dataframe.c:343:     printf("Usage: %s <csv_filename>\n", argc > 0 ? argv[0] : "prog");
	lea	rcx, .LC3[rip]	 #,
	call	printf	 #
.L373:
 # dataframe.c:344:     return 1;
	mov	eax, 1	 # <retval>,
	jmp	.L370	 #
.L405:
 # dataframe.c:349:     printf("Failed to read CSV\n");
	lea	rcx, .LC4[rip]	 #,
	call	puts	 #
 # dataframe.c:350:     return 1;
	jmp	.L373	 #
.L406:
	mov	rax, QWORD PTR 24[rsi]	 # df_38->data, df_38->data
	jmp	.L387	 #
	.seh_endproc
	.def	__main;	.scl	2;	.type	32;	.endef
	.ident	"GCC: (Rev8, Built by MSYS2 project) 15.2.0"
	.def	free;	.scl	2;	.type	32;	.endef
	.def	realloc;	.scl	2;	.type	32;	.endef
	.def	malloc;	.scl	2;	.type	32;	.endef
	.def	memcpy;	.scl	2;	.type	32;	.endef
	.def	fgetc;	.scl	2;	.type	32;	.endef
	.def	ungetc;	.scl	2;	.type	32;	.endef
	.def	fopen;	.scl	2;	.type	32;	.endef
	.def	fclose;	.scl	2;	.type	32;	.endef
	.def	strlen;	.scl	2;	.type	32;	.endef
	.def	memmove;	.scl	2;	.type	32;	.endef
	.def	printf;	.scl	2;	.type	32;	.endef
	.def	puts;	.scl	2;	.type	32;	.endef
	.def	putchar;	.scl	2;	.type	32;	.endef
