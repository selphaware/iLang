	.file	"dataframe.c"
	.intel_syntax noprefix
 # GNU C23 (Rev8, Built by MSYS2 project) version 15.2.0 (x86_64-w64-mingw32)
 #	compiled by GNU C version 15.2.0, GMP version 6.3.0, MPFR version 4.2.2, MPC version 1.3.1, isl version isl-0.27-GMP

 # GGC heuristics: --param ggc-min-expand=100 --param ggc-min-heapsize=131072
 # options passed: -masm=intel -mtune=generic -march=nocona -O2
	.text
	.p2align 4
	.def	free_dataframe;	.scl	3;	.type	32;	.endef
	.seh_proc	free_dataframe
free_dataframe:
	push	rbp	 #
	.seh_pushreg	rbp
	push	rdi	 #
	.seh_pushreg	rdi
	push	rsi	 #
	.seh_pushreg	rsi
	push	rbx	 #
	.seh_pushreg	rbx
	sub	rsp, 40	 #,
	.seh_stackalloc	40
	.seh_endprologue
 # dataframe.c:12: static void free_dataframe(DataFrame *df) {
	mov	rsi, rcx	 # df, df
 # dataframe.c:14:     if (df->col_names) {
	mov	rcx, QWORD PTR 16[rcx]	 # prephitmp_63, df_35(D)->col_names
 # dataframe.c:14:     if (df->col_names) {
	test	rcx, rcx	 # prephitmp_63
	je	.L2	 #,
 # dataframe.c:15:         for (size_t j = 0; j < df->n_cols; ++j) free(df->col_names[j]);
	cmp	QWORD PTR 8[rsi], 0	 # df_35(D)->n_cols,
	je	.L3	 #,
 # dataframe.c:15:         for (size_t j = 0; j < df->n_cols; ++j) free(df->col_names[j]);
	xor	ebx, ebx	 # j
	.p2align 4
	.p2align 3
.L4:
 # dataframe.c:15:         for (size_t j = 0; j < df->n_cols; ++j) free(df->col_names[j]);
	mov	rcx, QWORD PTR [rcx+rbx*8]	 # *_4, *_4
 # dataframe.c:15:         for (size_t j = 0; j < df->n_cols; ++j) free(df->col_names[j]);
	add	rbx, 1	 # j,
 # dataframe.c:15:         for (size_t j = 0; j < df->n_cols; ++j) free(df->col_names[j]);
	call	free	 #
 # dataframe.c:16:         free(df->col_names);
	mov	rcx, QWORD PTR 16[rsi]	 # prephitmp_63, df_35(D)->col_names
 # dataframe.c:15:         for (size_t j = 0; j < df->n_cols; ++j) free(df->col_names[j]);
	cmp	rbx, QWORD PTR 8[rsi]	 # j, df_35(D)->n_cols
	jb	.L4	 #,
.L3:
 # dataframe.c:16:         free(df->col_names);
	call	free	 #
.L2:
 # dataframe.c:18:     if (df->data) {
	mov	rax, QWORD PTR 24[rsi]	 # prephitmp_67, df_35(D)->data
 # dataframe.c:18:     if (df->data) {
	test	rax, rax	 # prephitmp_67
	je	.L5	 #,
 # dataframe.c:19:         for (size_t i = 0; i < df->n_rows; ++i) {
	cmp	QWORD PTR [rsi], 0	 # df_35(D)->n_rows,
	je	.L6	 #,
 # dataframe.c:19:         for (size_t i = 0; i < df->n_rows; ++i) {
	xor	edi, edi	 # i
	jmp	.L10	 #
	.p2align 5
	.p2align 4,,10
	.p2align 3
.L7:
 # dataframe.c:19:         for (size_t i = 0; i < df->n_rows; ++i) {
	add	rdi, 1	 # i,
 # dataframe.c:19:         for (size_t i = 0; i < df->n_rows; ++i) {
	cmp	rdi, QWORD PTR [rsi]	 # i, df_35(D)->n_rows
	jnb	.L6	 #,
.L10:
 # dataframe.c:20:             if (df->data[i]) {
	mov	rcx, QWORD PTR [rax+rdi*8]	 # prephitmp_72, *_11
	lea	rbp, 0[0+rdi*8]	 # _32,
 # dataframe.c:20:             if (df->data[i]) {
	test	rcx, rcx	 # prephitmp_72
	je	.L7	 #,
 # dataframe.c:21:                 for (size_t j = 0; j < df->n_cols; ++j) free(df->data[i][j]);
	cmp	QWORD PTR 8[rsi], 0	 # df_35(D)->n_cols,
	je	.L8	 #,
 # dataframe.c:21:                 for (size_t j = 0; j < df->n_cols; ++j) free(df->data[i][j]);
	xor	ebx, ebx	 # j
	.p2align 4
	.p2align 3
.L9:
 # dataframe.c:21:                 for (size_t j = 0; j < df->n_cols; ++j) free(df->data[i][j]);
	mov	rcx, QWORD PTR [rcx+rbx*8]	 # *_17, *_17
 # dataframe.c:21:                 for (size_t j = 0; j < df->n_cols; ++j) free(df->data[i][j]);
	add	rbx, 1	 # j,
 # dataframe.c:21:                 for (size_t j = 0; j < df->n_cols; ++j) free(df->data[i][j]);
	call	free	 #
 # dataframe.c:22:                 free(df->data[i]);
	mov	rax, QWORD PTR 24[rsi]	 # df_35(D)->data, df_35(D)->data
	mov	rcx, QWORD PTR [rax+rbp]	 # prephitmp_72, *_83
 # dataframe.c:21:                 for (size_t j = 0; j < df->n_cols; ++j) free(df->data[i][j]);
	cmp	rbx, QWORD PTR 8[rsi]	 # j, df_35(D)->n_cols
	jb	.L9	 #,
.L8:
 # dataframe.c:22:                 free(df->data[i]);
	call	free	 #
 # dataframe.c:19:         for (size_t i = 0; i < df->n_rows; ++i) {
	add	rdi, 1	 # i,
	mov	rax, QWORD PTR 24[rsi]	 # prephitmp_67, df_35(D)->data
 # dataframe.c:19:         for (size_t i = 0; i < df->n_rows; ++i) {
	cmp	rdi, QWORD PTR [rsi]	 # i, df_35(D)->n_rows
	jb	.L10	 #,
.L6:
 # dataframe.c:25:         free(df->data);
	mov	rcx, rax	 #, prephitmp_67
	call	free	 #
.L5:
 # dataframe.c:27:     free(df);
	mov	rcx, rsi	 #, df
 # dataframe.c:28: }
	add	rsp, 40	 #,
	pop	rbx	 #
	pop	rsi	 #
	pop	rdi	 #
	pop	rbp	 #
 # dataframe.c:27:     free(df);
	jmp	free	 #
	.seh_endproc
	.p2align 4
	.def	push_field;	.scl	3;	.type	32;	.endef
	.seh_proc	push_field
push_field:
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
	sub	rsp, 40	 #,
	.seh_stackalloc	40
	.seh_endprologue
 # dataframe.c:50: static int push_field(char ****fields, size_t *count, size_t *cap, char *buf, size_t len) {
	mov	rbp, QWORD PTR 128[rsp]	 # len, len
	mov	rbx, rdx	 # count, count
 # dataframe.c:51:     if (*count + 1 > *cap) {
	mov	rdx, QWORD PTR [r8]	 # _3, *cap_21(D)
 # dataframe.c:50: static int push_field(char ****fields, size_t *count, size_t *cap, char *buf, size_t len) {
	mov	rsi, rcx	 # fields, fields
	mov	rdi, r8	 # cap, cap
 # dataframe.c:51:     if (*count + 1 > *cap) {
	mov	rax, QWORD PTR [rbx]	 # tmp138, *count_20(D)
 # dataframe.c:50: static int push_field(char ****fields, size_t *count, size_t *cap, char *buf, size_t len) {
	mov	r12, r9	 # buf, buf
 # dataframe.c:51:     if (*count + 1 > *cap) {
	add	rax, 1	 # _2,
 # dataframe.c:51:     if (*count + 1 > *cap) {
	cmp	rdx, rax	 # _3, _2
	jnb	.L25	 #,
 # dataframe.c:52:         size_t ncap = (*cap == 0 ? 8 : (*cap * 2));
	test	rdx, rdx	 # _3
	jne	.L38	 #,
	mov	edx, 64	 # _38,
 # dataframe.c:52:         size_t ncap = (*cap == 0 ? 8 : (*cap * 2));
	mov	r13d, 8	 # ncap,
.L26:
 # dataframe.c:53:         char ***narr = (char ***)realloc(*fields, ncap * sizeof(char **));
	mov	rcx, QWORD PTR [rsi]	 # *fields_23(D), *fields_23(D)
	call	realloc	 #
 # dataframe.c:54:         if (!narr) return 0;
	test	rax, rax	 # narr
	je	.L29	 #,
 # dataframe.c:55:         *fields = narr;
	mov	QWORD PTR [rsi], rax	 # *fields_23(D), narr
 # dataframe.c:56:         *cap = ncap;
	mov	QWORD PTR [rdi], r13	 # *cap_21(D), ncap
.L25:
 # dataframe.c:58:     char *s = (char *)malloc(len + 1);
	lea	rcx, 1[rbp]	 # _7,
	call	malloc	 #
	mov	rcx, rax	 # s,
 # dataframe.c:59:     if (!s) return 0;
	test	rax, rax	 # s
	je	.L29	 #,
 # dataframe.c:60:     if (len) memcpy(s, buf, len);
	test	rbp, rbp	 # len
	jne	.L39	 #,
.L30:
 # dataframe.c:62:     (*fields)[(*count)++] = (char **)s; // temporarily store as char**-typed slot; cast back later
	mov	rax, QWORD PTR [rbx]	 # _10, *count_20(D)
 # dataframe.c:62:     (*fields)[(*count)++] = (char **)s; // temporarily store as char**-typed slot; cast back later
	mov	rdx, QWORD PTR [rsi]	 # _9, *fields_23(D)
 # dataframe.c:61:     s[len] = '\0';
	mov	BYTE PTR [rcx+rbp], 0	 # *_8,
 # dataframe.c:62:     (*fields)[(*count)++] = (char **)s; // temporarily store as char**-typed slot; cast back later
	lea	r8, 1[rax]	 # tmp129,
	mov	QWORD PTR [rbx], r8	 # *count_20(D), tmp129
 # dataframe.c:62:     (*fields)[(*count)++] = (char **)s; // temporarily store as char**-typed slot; cast back later
	mov	QWORD PTR [rdx+rax*8], rcx	 # *_13, s
 # dataframe.c:63:     return 1;
	mov	eax, 1	 # <retval>,
.L24:
 # dataframe.c:64: }
	add	rsp, 40	 #,
	pop	rbx	 #
	pop	rsi	 #
	pop	rdi	 #
	pop	rbp	 #
	pop	r12	 #
	pop	r13	 #
	ret	
	.p2align 4,,10
	.p2align 3
.L38:
 # dataframe.c:52:         size_t ncap = (*cap == 0 ? 8 : (*cap * 2));
	lea	r13, [rdx+rdx]	 # ncap,
 # dataframe.c:53:         char ***narr = (char ***)realloc(*fields, ncap * sizeof(char **));
	sal	rdx, 4	 # _38,
	jmp	.L26	 #
	.p2align 4,,10
	.p2align 3
.L39:
 # dataframe.c:60:     if (len) memcpy(s, buf, len);
	mov	r8, rbp	 #, len
	mov	rdx, r12	 #, buf
	call	memcpy	 #
	mov	rcx, rax	 # s,
	jmp	.L30	 #
.L29:
 # dataframe.c:54:         if (!narr) return 0;
	xor	eax, eax	 # <retval>
	jmp	.L24	 #
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
	sub	rsp, 120	 #,
	.seh_stackalloc	120
	.seh_endprologue
 # dataframe.c:68: static int parse_record(FILE *f, char delimiter, char ***out_fields, size_t *out_count) {
	mov	QWORD PTR 208[rsp], r8	 # out_fields, out_fields
	mov	rsi, rcx	 # f, f
	mov	r12d, edx	 # delimiter, delimiter
	mov	QWORD PTR 216[rsp], r9	 # out_count, out_count
 # dataframe.c:72:     char ***fields_tmp = NULL; // store strings in this array, but typed as char***
	mov	QWORD PTR 88[rsp], 0	 # fields_tmp,
 # dataframe.c:73:     size_t fcount = 0, fcap = 0;
	mov	QWORD PTR 96[rsp], 0	 # fcount,
 # dataframe.c:73:     size_t fcount = 0, fcap = 0;
	mov	QWORD PTR 104[rsp], 0	 # fcap,
 # dataframe.c:79:         int ch = fgetc(f);
	call	fgetc	 #
 # dataframe.c:80:         if (ch == EOF) {
	cmp	eax, -1	 # ch,
	je	.L93	 #,
	xor	ebx, ebx	 # ncap
	xor	r14d, r14d	 # blen
	xor	ebp, ebp	 # nbuf
	xor	edi, edi	 # started
	movsx	r12d, r12b	 # _17, delimiter
.L42:
 # dataframe.c:93:             if (ch == delimiter) {
	cmp	r12d, eax	 # _17, ch
	je	.L155	 #,
.L50:
 # dataframe.c:106:                 if (!started && blen == 0 && fcount == 0) {
	test	r14, r14	 # blen
	sete	r13b	 #, _105
 # dataframe.c:99:             if (ch == '\r' || ch == '\n') {
	cmp	eax, 13	 # ch,
	je	.L54	 #,
	cmp	eax, 10	 # ch,
	je	.L156	 #,
 # dataframe.c:112:             if (ch == '"' && blen == 0 && !started) {
	cmp	eax, 34	 # ch,
	jne	.L59	 #,
	test	r13b, r13b	 # _105
	je	.L59	 #,
 # dataframe.c:112:             if (ch == '"' && blen == 0 && !started) {
	test	edi, edi	 # started
	je	.L60	 #,
 # dataframe.c:39:     if (*len + 1 >= *cap) {
	mov	edi, 1	 # _218,
 # dataframe.c:119:             if (!append_char(&buf, &blen, &bcap, (char)ch)) { free(buf); free(fields_tmp); return -1; }
	mov	r13d, 34	 # _65,
 # dataframe.c:39:     if (*len + 1 >= *cap) {
	cmp	rbx, 1	 # ncap,
	ja	.L62	 #,
 # dataframe.c:40:         size_t ncap = (*cap == 0 ? 64 : (*cap * 2));
	mov	ebx, 64	 # ncap,
.L61:
 # dataframe.c:41:         char *nbuf = (char *)realloc(*buf, ncap);
	mov	rdx, rbx	 #, ncap
	mov	rcx, rbp	 #, nbuf
	call	realloc	 #
 # dataframe.c:42:         if (!nbuf) return 0;
	test	rax, rax	 # nbuf
	je	.L63	 #,
 # dataframe.c:43:         *buf = nbuf;
	mov	rbp, rax	 # nbuf, nbuf
.L62:
 # dataframe.c:46:     (*buf)[(*len)++] = c;
	mov	BYTE PTR 0[rbp+r14], r13b	 # *_189, _65
 # dataframe.c:79:         int ch = fgetc(f);
	mov	rcx, rsi	 #, f
	call	fgetc	 #
 # dataframe.c:80:         if (ch == EOF) {
	cmp	eax, -1	 # ch,
	je	.L151	 #,
 # dataframe.c:46:     (*buf)[(*len)++] = c;
	mov	r14, rdi	 # blen, _218
 # dataframe.c:96:                 started = 1;
	mov	edi, 1	 # started,
 # dataframe.c:93:             if (ch == delimiter) {
	cmp	r12d, eax	 # _17, ch
	jne	.L50	 #,
.L155:
 # dataframe.c:94:                 if (!push_field(&fields_tmp, &fcount, &fcap, buf, blen)) { free(buf); free(fields_tmp); return -1; }
	mov	QWORD PTR 32[rsp], r14	 #, blen
	lea	rax, 88[rsp]	 # tmp222,
	lea	r8, 104[rsp]	 # tmp224,
	mov	r9, rbp	 #, nbuf
	lea	rdx, 96[rsp]	 # tmp223,
	mov	rcx, rax	 #, tmp222
	mov	QWORD PTR 72[rsp], r8	 # %sfp, tmp224
	mov	QWORD PTR 64[rsp], rdx	 # %sfp, tmp223
	mov	QWORD PTR 56[rsp], rax	 # %sfp, tmp222
	call	push_field	 #
	mov	edi, eax	 # started, started
 # dataframe.c:94:                 if (!push_field(&fields_tmp, &fcount, &fcap, buf, blen)) { free(buf); free(fields_tmp); return -1; }
	test	eax, eax	 # started
	je	.L63	 #,
 # dataframe.c:79:         int ch = fgetc(f);
	mov	rcx, rsi	 #, f
	call	fgetc	 #
 # dataframe.c:80:         if (ch == EOF) {
	cmp	eax, -1	 # ch,
	je	.L44	 #,
.L147:
 # dataframe.c:135:                             blen = 0;
	xor	r14d, r14d	 # blen
	jmp	.L42	 #
	.p2align 4,,10
	.p2align 3
.L60:
 # dataframe.c:79:         int ch = fgetc(f);
	mov	rcx, rsi	 #, f
	call	fgetc	 #
	mov	r14d, eax	 # ch, ch
 # dataframe.c:80:         if (ch == EOF) {
	cmp	eax, -1	 # ch,
	je	.L157	 #,
	mov	r13, rbp	 # buf, nbuf
	xor	r15d, r15d	 # blen
 # dataframe.c:40:         size_t ncap = (*cap == 0 ? 64 : (*cap * 2));
	mov	ebp, 64	 # tmp233,
 # dataframe.c:123:             if (ch == '"') {
	cmp	r14d, 34	 # ch,
	je	.L158	 #,
	.p2align 4
	.p2align 3
.L64:
 # dataframe.c:39:     if (*len + 1 >= *cap) {
	lea	rdi, 1[r15]	 # _218,
 # dataframe.c:39:     if (*len + 1 >= *cap) {
	cmp	rdi, rbx	 # _218, ncap
	jb	.L82	 #,
 # dataframe.c:40:         size_t ncap = (*cap == 0 ? 64 : (*cap * 2));
	test	rbx, rbx	 # ncap
	lea	rax, [rbx+rbx]	 # tmp231,
 # dataframe.c:41:         char *nbuf = (char *)realloc(*buf, ncap);
	mov	rcx, r13	 #, buf
 # dataframe.c:40:         size_t ncap = (*cap == 0 ? 64 : (*cap * 2));
	cmove	rax, rbp	 # tmp231,, tmp231, tmp233
 # dataframe.c:41:         char *nbuf = (char *)realloc(*buf, ncap);
	mov	rdx, rax	 #, ncap
 # dataframe.c:40:         size_t ncap = (*cap == 0 ? 64 : (*cap * 2));
	mov	rbx, rax	 # ncap, tmp231
 # dataframe.c:41:         char *nbuf = (char *)realloc(*buf, ncap);
	call	realloc	 #
 # dataframe.c:42:         if (!nbuf) return 0;
	test	rax, rax	 # nbuf
	je	.L84	 #,
 # dataframe.c:43:         *buf = nbuf;
	mov	r13, rax	 # buf, nbuf
.L82:
 # dataframe.c:158:                 if (!append_char(&buf, &blen, &bcap, (char)ch)) { free(buf); free(fields_tmp); return -1; }
	mov	BYTE PTR 0[r13+r15], r14b	 # *_227, ch
.L154:
 # dataframe.c:79:         int ch = fgetc(f);
	mov	rcx, rsi	 #, f
	call	fgetc	 #
	mov	r14d, eax	 # ch, ch
 # dataframe.c:80:         if (ch == EOF) {
	cmp	eax, -1	 # ch,
	je	.L150	 #,
 # dataframe.c:119:             if (!append_char(&buf, &blen, &bcap, (char)ch)) { free(buf); free(fields_tmp); return -1; }
	mov	r15, rdi	 # blen, _218
 # dataframe.c:123:             if (ch == '"') {
	cmp	r14d, 34	 # ch,
	jne	.L64	 #,
.L158:
 # dataframe.c:124:                 int c2 = fgetc(f);
	mov	rcx, rsi	 #, f
	call	fgetc	 #
	mov	edi, eax	 # c2,
 # dataframe.c:125:                 if (c2 == '"') {
	cmp	eax, 34	 # c2,
	je	.L159	 #,
 # dataframe.c:131:                     if (c2 != EOF) {
	cmp	eax, -1	 # c2,
	je	.L70	 #,
 # dataframe.c:133:                         if (c2 == delimiter) {
	cmp	r12d, eax	 # _17, c2
	je	.L160	 #,
 # dataframe.c:138:                         } else if (c2 == '\r' || c2 == '\n') {
	cmp	eax, 13	 # c2,
	je	.L75	 #,
	cmp	eax, 10	 # c2,
	je	.L161	 #,
 # dataframe.c:39:     if (*len + 1 >= *cap) {
	lea	r14, 1[r15]	 # blen,
 # dataframe.c:39:     if (*len + 1 >= *cap) {
	cmp	r14, rbx	 # blen, ncap
	jb	.L99	 #,
 # dataframe.c:40:         size_t ncap = (*cap == 0 ? 64 : (*cap * 2));
	lea	rax, [rbx+rbx]	 # tmp229,
	test	rbx, rbx	 # ncap
	mov	ebx, 64	 # tmp230,
 # dataframe.c:41:         char *nbuf = (char *)realloc(*buf, ncap);
	mov	rcx, r13	 #, buf
 # dataframe.c:40:         size_t ncap = (*cap == 0 ? 64 : (*cap * 2));
	cmovne	rbx, rax	 # tmp229,, ncap
 # dataframe.c:41:         char *nbuf = (char *)realloc(*buf, ncap);
	mov	rdx, rbx	 #, ncap
	call	realloc	 #
	mov	rbp, rax	 # nbuf, nbuf
 # dataframe.c:42:         if (!nbuf) return 0;
	test	rax, rax	 # nbuf
	je	.L84	 #,
.L79:
 # dataframe.c:147:                             if (!append_char(&buf, &blen, &bcap, (char)c2)) { free(buf); free(fields_tmp); return -1; }
	mov	BYTE PTR 0[rbp+r15], dil	 # *_214, c2
 # dataframe.c:79:         int ch = fgetc(f);
	mov	rcx, rsi	 #, f
	call	fgetc	 #
 # dataframe.c:80:         if (ch == EOF) {
	cmp	eax, -1	 # ch,
	je	.L101	 #,
 # dataframe.c:96:                 started = 1;
	mov	edi, 1	 # started,
	jmp	.L42	 #
	.p2align 4,,10
	.p2align 3
.L156:
 # dataframe.c:101:                 if (ch == '\r') {
	cmp	eax, 13	 # ch,
	je	.L54	 #,
.L55:
 # dataframe.c:106:                 if (!started && blen == 0 && fcount == 0) {
	and	edi, 1	 # started,
	jne	.L57	 #,
	test	r13b, r13b	 # _105
	je	.L57	 #,
 # dataframe.c:106:                 if (!started && blen == 0 && fcount == 0) {
	mov	r14, QWORD PTR 96[rsp]	 # blen, fcount
 # dataframe.c:106:                 if (!started && blen == 0 && fcount == 0) {
	test	r14, r14	 # blen
	je	.L58	 #,
	xor	r14d, r14d	 # blen
.L57:
 # dataframe.c:109:                 if (!push_field(&fields_tmp, &fcount, &fcap, buf, blen)) { free(buf); free(fields_tmp); return -1; }
	mov	QWORD PTR 32[rsp], r14	 #, blen
	lea	rdx, 96[rsp]	 # tmp191,
	lea	rcx, 88[rsp]	 # tmp192,
	mov	r9, rbp	 #, nbuf
	lea	r8, 104[rsp]	 #,
	call	push_field	 #
 # dataframe.c:109:                 if (!push_field(&fields_tmp, &fcount, &fcap, buf, blen)) { free(buf); free(fields_tmp); return -1; }
	test	eax, eax	 # _37
	je	.L148	 #,
.L48:
 # dataframe.c:163:     free(buf);
	mov	rcx, rbp	 #, nbuf
	call	free	 #
 # dataframe.c:166:     char **fields = (char **)malloc(fcount * sizeof(char *));
	mov	rbx, QWORD PTR 96[rsp]	 # fcount.77_83, fcount
 # dataframe.c:166:     char **fields = (char **)malloc(fcount * sizeof(char *));
	lea	rbp, 0[0+rbx*8]	 # _84,
 # dataframe.c:166:     char **fields = (char **)malloc(fcount * sizeof(char *));
	mov	rcx, rbp	 #, _84
	call	malloc	 #
 # dataframe.c:175:     free(fields_tmp);
	mov	rdi, QWORD PTR 88[rsp]	 # pretmp_308, fields_tmp
 # dataframe.c:166:     char **fields = (char **)malloc(fcount * sizeof(char *));
	mov	rsi, rax	 # fields,
 # dataframe.c:167:     if (!fields) { // free all strings
	test	rax, rax	 # fields
	je	.L85	 #,
 # dataframe.c:172:     for (size_t i = 0; i < fcount; ++i) {
	xor	eax, eax	 # i
 # dataframe.c:172:     for (size_t i = 0; i < fcount; ++i) {
	test	rbx, rbx	 # fcount.77_83
	je	.L90	 #,
	.p2align 5
	.p2align 4
	.p2align 3
.L86:
 # dataframe.c:173:         fields[i] = (char *)fields_tmp[i];
	mov	rdx, QWORD PTR [rdi+rax*8]	 # MEM[(char * * *)pretmp_308 + i_224 * 8], MEM[(char * * *)pretmp_308 + i_224 * 8]
	mov	QWORD PTR [rsi+rax*8], rdx	 # MEM[(char * *)fields_85 + i_224 * 8], MEM[(char * * *)pretmp_308 + i_224 * 8]
 # dataframe.c:172:     for (size_t i = 0; i < fcount; ++i) {
	add	rax, 1	 # i,
 # dataframe.c:172:     for (size_t i = 0; i < fcount; ++i) {
	cmp	rbx, rax	 # fcount.77_83, i
	jne	.L86	 #,
.L90:
 # dataframe.c:175:     free(fields_tmp);
	mov	rcx, rdi	 #, pretmp_308
	call	free	 #
 # dataframe.c:177:     *out_fields = fields;
	mov	rax, QWORD PTR 208[rsp]	 # tmp278, out_fields
	mov	QWORD PTR [rax], rsi	 # *out_fields_101(D), fields
 # dataframe.c:178:     *out_count = fcount;
	mov	rax, QWORD PTR 216[rsp]	 # tmp279, out_count
	mov	QWORD PTR [rax], rbx	 # *out_count_102(D), fcount.77_83
 # dataframe.c:179:     return 1;
	mov	eax, 1	 # <retval>,
.L40:
 # dataframe.c:180: }
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
	.p2align 4,,10
	.p2align 3
.L59:
 # dataframe.c:39:     if (*len + 1 >= *cap) {
	lea	rdi, 1[r14]	 # _218,
 # dataframe.c:119:             if (!append_char(&buf, &blen, &bcap, (char)ch)) { free(buf); free(fields_tmp); return -1; }
	mov	r13d, eax	 # _65, ch
 # dataframe.c:39:     if (*len + 1 >= *cap) {
	cmp	rdi, rbx	 # _218, ncap
	jb	.L62	 #,
 # dataframe.c:40:         size_t ncap = (*cap == 0 ? 64 : (*cap * 2));
	lea	rax, [rbx+rbx]	 # tmp225,
	test	rbx, rbx	 # ncap
	mov	ebx, 64	 # tmp226,
	cmovne	rbx, rax	 # tmp225,, ncap
	jmp	.L61	 #
	.p2align 4,,10
	.p2align 3
.L58:
 # dataframe.c:79:         int ch = fgetc(f);
	mov	rcx, rsi	 #, f
	call	fgetc	 #
 # dataframe.c:80:         if (ch == EOF) {
	cmp	eax, -1	 # ch,
	je	.L41	 #,
	xor	edi, edi	 # started
	jmp	.L42	 #
	.p2align 4,,10
	.p2align 3
.L99:
	mov	rbp, r13	 # nbuf, buf
	jmp	.L79	 #
	.p2align 4,,10
	.p2align 3
.L54:
 # dataframe.c:102:                     int c2 = fgetc(f);
	mov	rcx, rsi	 #, f
	call	fgetc	 #
 # dataframe.c:103:                     if (c2 != '\n' && c2 != EOF) ungetc(c2, f);
	cmp	eax, 10	 # c2,
	je	.L55	 #,
	cmp	eax, -1	 # c2,
	je	.L55	 #,
 # dataframe.c:103:                     if (c2 != '\n' && c2 != EOF) ungetc(c2, f);
	mov	rdx, rsi	 #, f
	mov	ecx, eax	 #, c2
	call	ungetc	 #
	jmp	.L55	 #
	.p2align 4,,10
	.p2align 3
.L159:
 # dataframe.c:39:     if (*len + 1 >= *cap) {
	lea	rdi, 1[r15]	 # _218,
 # dataframe.c:39:     if (*len + 1 >= *cap) {
	cmp	rdi, rbx	 # _218, ncap
	jb	.L66	 #,
 # dataframe.c:40:         size_t ncap = (*cap == 0 ? 64 : (*cap * 2));
	test	rbx, rbx	 # ncap
	lea	rax, [rbx+rbx]	 # tmp227,
	mov	ebx, 64	 # tmp228,
 # dataframe.c:41:         char *nbuf = (char *)realloc(*buf, ncap);
	mov	rcx, r13	 #, buf
 # dataframe.c:40:         size_t ncap = (*cap == 0 ? 64 : (*cap * 2));
	cmovne	rbx, rax	 # tmp227,, ncap
 # dataframe.c:41:         char *nbuf = (char *)realloc(*buf, ncap);
	mov	rdx, rbx	 #, ncap
	call	realloc	 #
 # dataframe.c:42:         if (!nbuf) return 0;
	test	rax, rax	 # nbuf
	je	.L84	 #,
 # dataframe.c:43:         *buf = nbuf;
	mov	r13, rax	 # buf, nbuf
.L66:
 # dataframe.c:46:     (*buf)[(*len)++] = c;
	mov	BYTE PTR 0[r13+r15], 34	 # *_201,
	jmp	.L154	 #
	.p2align 4,,10
	.p2align 3
.L63:
 # dataframe.c:119:             if (!append_char(&buf, &blen, &bcap, (char)ch)) { free(buf); free(fields_tmp); return -1; }
	mov	rcx, rbp	 #, nbuf
	call	free	 #
 # dataframe.c:119:             if (!append_char(&buf, &blen, &bcap, (char)ch)) { free(buf); free(fields_tmp); return -1; }
	mov	rcx, QWORD PTR 88[rsp]	 #, fields_tmp
	call	free	 #
.L49:
 # dataframe.c:88:             if (!push_field(&fields_tmp, &fcount, &fcap, buf, blen)) { free(buf); free(fields_tmp); return -1; }
	mov	eax, -1	 # <retval>,
	jmp	.L40	 #
.L93:
	xor	ebp, ebp	 # nbuf
.L41:
 # dataframe.c:81:             if (!started && blen == 0 && fcount == 0) {
	cmp	QWORD PTR 96[rsp], 0	 # fcount,
	je	.L91	 #,
	lea	rax, 104[rsp]	 # tmp224,
	xor	edi, edi	 # _218
	mov	QWORD PTR 72[rsp], rax	 # %sfp, tmp224
	lea	rax, 96[rsp]	 # tmp223,
	mov	QWORD PTR 64[rsp], rax	 # %sfp, tmp223
	lea	rax, 88[rsp]	 # tmp222,
	mov	QWORD PTR 56[rsp], rax	 # %sfp, tmp222
.L92:
 # dataframe.c:88:             if (!push_field(&fields_tmp, &fcount, &fcap, buf, blen)) { free(buf); free(fields_tmp); return -1; }
	mov	QWORD PTR 32[rsp], rdi	 #, _218
	mov	r8, QWORD PTR 72[rsp]	 #, %sfp
	mov	r9, rbp	 #, nbuf
	mov	rdx, QWORD PTR 64[rsp]	 #, %sfp
	mov	rcx, QWORD PTR 56[rsp]	 #, %sfp
	call	push_field	 #
 # dataframe.c:88:             if (!push_field(&fields_tmp, &fcount, &fcap, buf, blen)) { free(buf); free(fields_tmp); return -1; }
	test	eax, eax	 # _13
	jne	.L48	 #,
	.p2align 4
	.p2align 3
.L148:
 # dataframe.c:109:                 if (!push_field(&fields_tmp, &fcount, &fcap, buf, blen)) { free(buf); free(fields_tmp); return -1; }
	mov	rbx, QWORD PTR 88[rsp]	 # pretmp_80, fields_tmp
 # dataframe.c:109:                 if (!push_field(&fields_tmp, &fcount, &fcap, buf, blen)) { free(buf); free(fields_tmp); return -1; }
	mov	rcx, rbp	 #, nbuf
	call	free	 #
 # dataframe.c:109:                 if (!push_field(&fields_tmp, &fcount, &fcap, buf, blen)) { free(buf); free(fields_tmp); return -1; }
	mov	rcx, rbx	 #, pretmp_80
	call	free	 #
 # dataframe.c:109:                 if (!push_field(&fields_tmp, &fcount, &fcap, buf, blen)) { free(buf); free(fields_tmp); return -1; }
	jmp	.L49	 #
	.p2align 4,,10
	.p2align 3
.L160:
 # dataframe.c:134:                             if (!push_field(&fields_tmp, &fcount, &fcap, buf, blen)) { free(buf); free(fields_tmp); return -1; }
	mov	QWORD PTR 32[rsp], r15	 #, blen
	lea	rax, 88[rsp]	 # tmp222,
	lea	r8, 104[rsp]	 # tmp224,
	mov	r9, r13	 #, buf
	lea	rdx, 96[rsp]	 # tmp223,
	mov	rcx, rax	 #, tmp222
	mov	QWORD PTR 72[rsp], r8	 # %sfp, tmp224
	mov	QWORD PTR 64[rsp], rdx	 # %sfp, tmp223
	mov	QWORD PTR 56[rsp], rax	 # %sfp, tmp222
	call	push_field	 #
	mov	edi, eax	 # started, started
 # dataframe.c:134:                             if (!push_field(&fields_tmp, &fcount, &fcap, buf, blen)) { free(buf); free(fields_tmp); return -1; }
	test	eax, eax	 # started
	je	.L84	 #,
 # dataframe.c:79:         int ch = fgetc(f);
	mov	rcx, rsi	 #, f
	call	fgetc	 #
 # dataframe.c:80:         if (ch == EOF) {
	cmp	eax, -1	 # ch,
	je	.L94	 #,
	mov	rbp, r13	 # nbuf, buf
	jmp	.L147	 #
.L101:
 # dataframe.c:46:     (*buf)[(*len)++] = c;
	mov	rdi, r14	 # _218, blen
.L151:
 # dataframe.c:80:         if (ch == EOF) {
	mov	r13, rbp	 # buf, nbuf
.L150:
	lea	rax, 104[rsp]	 # tmp224,
	mov	QWORD PTR 72[rsp], rax	 # %sfp, tmp224
	lea	rax, 96[rsp]	 # tmp223,
	mov	QWORD PTR 64[rsp], rax	 # %sfp, tmp223
	lea	rax, 88[rsp]	 # tmp222,
	mov	QWORD PTR 56[rsp], rax	 # %sfp, tmp222
.L46:
	mov	rbp, r13	 # nbuf, buf
	jmp	.L92	 #
.L157:
	lea	rax, 104[rsp]	 # tmp224,
	mov	QWORD PTR 72[rsp], rax	 # %sfp, tmp224
	lea	rax, 96[rsp]	 # tmp223,
	mov	QWORD PTR 64[rsp], rax	 # %sfp, tmp223
	lea	rax, 88[rsp]	 # tmp222,
	mov	QWORD PTR 56[rsp], rax	 # %sfp, tmp222
.L44:
	mov	r13, rbp	 # buf, nbuf
 # dataframe.c:95:                 blen = 0;
	xor	edi, edi	 # _218
	jmp	.L46	 #
	.p2align 4,,10
	.p2align 3
.L84:
 # dataframe.c:158:                 if (!append_char(&buf, &blen, &bcap, (char)ch)) { free(buf); free(fields_tmp); return -1; }
	mov	rcx, r13	 #, buf
	call	free	 #
 # dataframe.c:158:                 if (!append_char(&buf, &blen, &bcap, (char)ch)) { free(buf); free(fields_tmp); return -1; }
	mov	rcx, QWORD PTR 88[rsp]	 #, fields_tmp
	call	free	 #
 # dataframe.c:158:                 if (!append_char(&buf, &blen, &bcap, (char)ch)) { free(buf); free(fields_tmp); return -1; }
	jmp	.L49	 #
.L161:
 # dataframe.c:139:                             if (c2 == '\r') {
	cmp	eax, 13	 # c2,
	jne	.L70	 #,
.L75:
 # dataframe.c:140:                                 int c3 = fgetc(f);
	mov	rcx, rsi	 #, f
	call	fgetc	 #
 # dataframe.c:141:                                 if (c3 != '\n' && c3 != EOF) ungetc(c3, f);
	cmp	eax, 10	 # c3,
	je	.L70	 #,
	cmp	eax, -1	 # c3,
	je	.L70	 #,
 # dataframe.c:141:                                 if (c3 != '\n' && c3 != EOF) ungetc(c3, f);
	mov	rdx, rsi	 #, f
	mov	ecx, eax	 #, c3
	call	ungetc	 #
.L70:
 # dataframe.c:152:                         if (!push_field(&fields_tmp, &fcount, &fcap, buf, blen)) { free(buf); free(fields_tmp); return -1; }
	mov	QWORD PTR 32[rsp], r15	 #, blen
	lea	rdx, 96[rsp]	 # tmp214,
	mov	r9, r13	 #, buf
 # dataframe.c:43:         *buf = nbuf;
	mov	rbp, r13	 # nbuf, buf
 # dataframe.c:152:                         if (!push_field(&fields_tmp, &fcount, &fcap, buf, blen)) { free(buf); free(fields_tmp); return -1; }
	lea	rcx, 88[rsp]	 # tmp215,
	lea	r8, 104[rsp]	 #,
	call	push_field	 #
 # dataframe.c:152:                         if (!push_field(&fields_tmp, &fcount, &fcap, buf, blen)) { free(buf); free(fields_tmp); return -1; }
	test	eax, eax	 # _75
	jne	.L48	 #,
 # dataframe.c:134:                             if (!push_field(&fields_tmp, &fcount, &fcap, buf, blen)) { free(buf); free(fields_tmp); return -1; }
	mov	rbx, QWORD PTR 88[rsp]	 # pretmp_188, fields_tmp
 # dataframe.c:152:                         if (!push_field(&fields_tmp, &fcount, &fcap, buf, blen)) { free(buf); free(fields_tmp); return -1; }
	mov	rcx, r13	 #, buf
	call	free	 #
 # dataframe.c:152:                         if (!push_field(&fields_tmp, &fcount, &fcap, buf, blen)) { free(buf); free(fields_tmp); return -1; }
	mov	rcx, rbx	 #, pretmp_188
	call	free	 #
 # dataframe.c:152:                         if (!push_field(&fields_tmp, &fcount, &fcap, buf, blen)) { free(buf); free(fields_tmp); return -1; }
	jmp	.L49	 #
.L91:
 # dataframe.c:83:                 free(buf);
	mov	rcx, rbp	 #, nbuf
	call	free	 #
 # dataframe.c:84:                 free(fields_tmp);
	mov	rcx, QWORD PTR 88[rsp]	 #, fields_tmp
	call	free	 #
 # dataframe.c:85:                 return 0;
	xor	eax, eax	 # <retval>
	jmp	.L40	 #
.L94:
 # dataframe.c:135:                             blen = 0;
	xor	edi, edi	 # _218
	jmp	.L46	 #
.L85:
	mov	rsi, rdi	 # ivtmp.122, pretmp_308
	add	rbp, rdi	 # _219, pretmp_308
 # dataframe.c:168:         for (size_t i = 0; i < fcount; ++i) free((char *)fields_tmp[i]);
	test	rbx, rbx	 # fcount.77_83
	je	.L89	 #,
.L88:
 # dataframe.c:168:         for (size_t i = 0; i < fcount; ++i) free((char *)fields_tmp[i]);
	mov	rcx, QWORD PTR [rsi]	 # MEM[(char * * *)_304], MEM[(char * * *)_304]
 # dataframe.c:168:         for (size_t i = 0; i < fcount; ++i) free((char *)fields_tmp[i]);
	add	rsi, 8	 # ivtmp.122,
 # dataframe.c:168:         for (size_t i = 0; i < fcount; ++i) free((char *)fields_tmp[i]);
	call	free	 #
 # dataframe.c:168:         for (size_t i = 0; i < fcount; ++i) free((char *)fields_tmp[i]);
	cmp	rsi, rbp	 # ivtmp.122, _219
	jne	.L88	 #,
.L89:
 # dataframe.c:169:         free(fields_tmp);
	mov	rcx, rdi	 #, pretmp_308
	call	free	 #
 # dataframe.c:170:         return -1;
	jmp	.L49	 #
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
	sub	rsp, 136	 #,
	.seh_stackalloc	136
	.seh_endprologue
 # dataframe.c:197: DataFrame *read_csv(const char *filename, char delimiter) {
	mov	ebx, edx	 # delimiter, delimiter
 # dataframe.c:198:     FILE *f = fopen(filename, "rb");
	lea	rdx, .LC0[rip]	 #,
	call	fopen	 #
	mov	QWORD PTR 40[rsp], rax	 # %sfp, f
	mov	rcx, rax	 # f,
 # dataframe.c:199:     if (!f) return NULL;
	test	rax, rax	 # f
	je	.L163	 #,
 # dataframe.c:204:     int rc = parse_record(f, delimiter, &header, &n_cols);
	movsx	eax, bl	 # _1, delimiter
	lea	r9, 104[rsp]	 #,
	lea	r8, 96[rsp]	 #,
 # dataframe.c:202:     char **header = NULL;
	mov	QWORD PTR 96[rsp], 0	 # header,
 # dataframe.c:204:     int rc = parse_record(f, delimiter, &header, &n_cols);
	mov	edx, eax	 #, _1
	mov	DWORD PTR 60[rsp], eax	 # %sfp, _1
 # dataframe.c:203:     size_t n_cols = 0;
	mov	QWORD PTR 104[rsp], 0	 # n_cols,
 # dataframe.c:204:     int rc = parse_record(f, delimiter, &header, &n_cols);
	call	parse_record.constprop.0	 #
 # dataframe.c:205:     if (rc <= 0 || n_cols == 0) { // no header or error
	cmp	eax, 1	 # rc,
	jne	.L164	 #,
 # dataframe.c:205:     if (rc <= 0 || n_cols == 0) { // no header or error
	mov	rsi, QWORD PTR 104[rsp]	 # n_cols.0_2, n_cols
 # dataframe.c:208:             free(header);
	mov	rbx, QWORD PTR 96[rsp]	 # pretmp_216, header
 # dataframe.c:205:     if (rc <= 0 || n_cols == 0) { // no header or error
	test	rsi, rsi	 # n_cols.0_2
	je	.L222	 #,
 # dataframe.c:214:     if (n_cols > 0) strip_utf8_bom(header[0]);
	mov	rdi, QWORD PTR [rbx]	 # _6, *pretmp_216
 # dataframe.c:183:     if (!s) return;
	test	rdi, rdi	 # _6
	je	.L167	 #,
 # dataframe.c:185:     if (u[0] == 0xEF && u[1] == 0xBB && u[2] == 0xBF) {
	cmp	BYTE PTR [rdi], -17	 # MEM[(unsigned char *)_6],
	je	.L224	 #,
.L167:
 # dataframe.c:217:     DataFrame *df = (DataFrame *)calloc(1, sizeof(DataFrame));
	mov	edx, 32	 #,
	mov	ecx, 1	 #,
	call	calloc	 #
	mov	rdi, rax	 # <retval>, <retval>
 # dataframe.c:218:     if (!df) { for (size_t i = 0; i < n_cols; ++i) free(header[i]); free(header); fclose(f); return NULL; }
	test	rax, rax	 # <retval>
	je	.L225	 #,
 # dataframe.c:219:     df->n_cols = n_cols;
	mov	QWORD PTR 8[rax], rsi	 # df_120->n_cols, n_cols.0_2
 # dataframe.c:220:     df->col_names = (char **)malloc(n_cols * sizeof(char *));
	lea	rax, 0[0+rsi*8]	 # _12,
 # dataframe.c:220:     df->col_names = (char **)malloc(n_cols * sizeof(char *));
	mov	rcx, rax	 #, _12
 # dataframe.c:220:     df->col_names = (char **)malloc(n_cols * sizeof(char *));
	mov	QWORD PTR 48[rsp], rax	 # %sfp, _12
 # dataframe.c:220:     df->col_names = (char **)malloc(n_cols * sizeof(char *));
	call	malloc	 #
 # dataframe.c:220:     df->col_names = (char **)malloc(n_cols * sizeof(char *));
	mov	QWORD PTR 16[rdi], rax	 # df_120->col_names, _13
 # dataframe.c:220:     df->col_names = (char **)malloc(n_cols * sizeof(char *));
	mov	rcx, rax	 # _13,
 # dataframe.c:221:     if (!df->col_names) { free_dataframe(df); for (size_t i = 0; i < n_cols; ++i) free(header[i]); free(header); fclose(f); return NULL; }
	test	rax, rax	 # _13
	je	.L226	 #,
 # dataframe.c:222:     for (size_t j = 0; j < n_cols; ++j) {
	xor	eax, eax	 # j
	.p2align 5
	.p2align 4
	.p2align 3
.L170:
 # dataframe.c:223:         df->col_names[j] = header[j]; // take ownership
	mov	rdx, QWORD PTR [rbx+rax*8]	 # MEM[(char * *)pretmp_216 + j_224 * 8], MEM[(char * *)pretmp_216 + j_224 * 8]
	mov	QWORD PTR [rcx+rax*8], rdx	 # MEM[(char * *)_13 + j_224 * 8], MEM[(char * *)pretmp_216 + j_224 * 8]
 # dataframe.c:222:     for (size_t j = 0; j < n_cols; ++j) {
	add	rax, 1	 # j,
 # dataframe.c:222:     for (size_t j = 0; j < n_cols; ++j) {
	cmp	rsi, rax	 # n_cols.0_2, j
	jne	.L170	 #,
 # dataframe.c:225:     free(header);
	mov	rcx, rbx	 #, pretmp_216
 # dataframe.c:228:     size_t rows_cap = 0;
	xor	r13d, r13d	 # rows_cap
 # dataframe.c:225:     free(header);
	call	free	 #
	lea	rax, 120[rsp]	 # tmp199,
 # dataframe.c:229:     df->data = NULL;
	mov	QWORD PTR 24[rdi], 0	 # df_120->data,
	mov	QWORD PTR 88[rsp], rax	 # %sfp, tmp199
	lea	rax, 112[rsp]	 # tmp198,
 # dataframe.c:230:     df->n_rows = 0;
	mov	QWORD PTR [rdi], 0	 # df_120->n_rows,
	mov	QWORD PTR 80[rsp], rax	 # %sfp, tmp198
.L172:
 # dataframe.c:235:         int rr = parse_record(f, delimiter, &fields, &fcount);
	mov	r9, QWORD PTR 88[rsp]	 #, %sfp
	mov	r8, QWORD PTR 80[rsp]	 #, %sfp
 # dataframe.c:233:         char **fields = NULL;
	mov	QWORD PTR 112[rsp], 0	 # fields,
 # dataframe.c:235:         int rr = parse_record(f, delimiter, &fields, &fcount);
	mov	edx, DWORD PTR 60[rsp]	 #, %sfp
	mov	rcx, QWORD PTR 40[rsp]	 #, %sfp
 # dataframe.c:234:         size_t fcount = 0;
	mov	QWORD PTR 120[rsp], 0	 # fcount,
 # dataframe.c:235:         int rr = parse_record(f, delimiter, &fields, &fcount);
	call	parse_record.constprop.0	 #
 # dataframe.c:236:         if (rr == 0) break;          // EOF
	test	eax, eax	 # rr
	je	.L173	 #,
 # dataframe.c:237:         if (rr < 0) { free_dataframe(df); fclose(f); return NULL; }
	cmp	eax, -1	 # rr,
	je	.L223	 #,
 # dataframe.c:241:         for (size_t i = 0; i < fcount; ++i) {
	mov	r15, QWORD PTR 120[rsp]	 # fcount.18_214, fcount
 # dataframe.c:246:             free(fields);
	mov	r14, QWORD PTR 112[rsp]	 # pretmp_246, fields
 # dataframe.c:241:         for (size_t i = 0; i < fcount; ++i) {
	xor	eax, eax	 # i
 # dataframe.c:241:         for (size_t i = 0; i < fcount; ++i) {
	test	r15, r15	 # fcount.18_214
	jne	.L175	 #,
	jmp	.L181	 #
	.p2align 5
	.p2align 4,,10
	.p2align 3
.L228:
 # dataframe.c:241:         for (size_t i = 0; i < fcount; ++i) {
	add	rax, 1	 # i,
 # dataframe.c:241:         for (size_t i = 0; i < fcount; ++i) {
	cmp	rax, r15	 # i, fcount.18_214
	je	.L227	 #,
.L175:
 # dataframe.c:242:             if (fields[i][0] != '\0') { all_empty = 0; break; }
	mov	rdx, QWORD PTR [r14+rax*8]	 # MEM[(char * *)pretmp_246 + i_225 * 8], MEM[(char * *)pretmp_246 + i_225 * 8]
 # dataframe.c:242:             if (fields[i][0] != '\0') { all_empty = 0; break; }
	cmp	BYTE PTR [rdx], 0	 # *_29,
	je	.L228	 #,
 # dataframe.c:250:         if (df->n_rows + 1 > rows_cap) {
	mov	rax, QWORD PTR [rdi]	 # _37, df_120->n_rows
	mov	QWORD PTR 64[rsp], rax	 # %sfp, _37
 # dataframe.c:250:         if (df->n_rows + 1 > rows_cap) {
	add	rax, 1	 # _38,
	mov	QWORD PTR 72[rsp], rax	 # %sfp, _38
 # dataframe.c:250:         if (df->n_rows + 1 > rows_cap) {
	cmp	r13, rax	 # rows_cap, _38
	jnb	.L196	 #,
 # dataframe.c:251:             size_t ncap = (rows_cap == 0 ? 64 : rows_cap * 2);
	test	r13, r13	 # rows_cap
	je	.L199	 #,
 # dataframe.c:252:             char ***ndata = (char ***)realloc(df->data, ncap * sizeof(char **));
	mov	rdx, r13	 # prephitmp_11, rows_cap
 # dataframe.c:251:             size_t ncap = (rows_cap == 0 ? 64 : rows_cap * 2);
	add	r13, r13	 # rows_cap, rows_cap
 # dataframe.c:252:             char ***ndata = (char ***)realloc(df->data, ncap * sizeof(char **));
	sal	rdx, 4	 # prephitmp_11,
.L182:
 # dataframe.c:252:             char ***ndata = (char ***)realloc(df->data, ncap * sizeof(char **));
	mov	rcx, QWORD PTR 24[rdi]	 # df_120->data, df_120->data
	call	realloc	 #
 # dataframe.c:253:             if (!ndata) {
	test	rax, rax	 # ndata
	je	.L229	 #,
 # dataframe.c:260:             df->data = ndata;
	mov	QWORD PTR 24[rdi], rax	 # df_120->data, ndata
.L196:
 # dataframe.c:264:         char **row = (char **)malloc(df->n_cols * sizeof(char *));
	mov	rcx, QWORD PTR 48[rsp]	 #, %sfp
	call	malloc	 #
	mov	rbx, rax	 # row,
 # dataframe.c:265:         if (!row) {
	test	rax, rax	 # row
	je	.L186	 #,
 # dataframe.c:274:         for (size_t j = 0; j < df->n_cols; ++j) {
	xor	ebp, ebp	 # j
	jmp	.L185	 #
	.p2align 5
	.p2align 4,,10
	.p2align 3
.L231:
 # dataframe.c:276:                 row[j] = fields[j]; // take ownership
	mov	rax, QWORD PTR [r14+rbp*8]	 # p, MEM[(char * *)pretmp_246 + j_229 * 8]
 # dataframe.c:276:                 row[j] = fields[j]; // take ownership
	mov	QWORD PTR [rbx+rbp*8], rax	 # MEM[(char * *)row_142 + j_229 * 8], p
 # dataframe.c:274:         for (size_t j = 0; j < df->n_cols; ++j) {
	add	rbp, 1	 # j,
 # dataframe.c:274:         for (size_t j = 0; j < df->n_cols; ++j) {
	cmp	rbp, rsi	 # j, n_cols.0_2
	jnb	.L230	 #,
.L185:
 # dataframe.c:275:             if (j < fcount) {
	cmp	rbp, r15	 # j, fcount.18_214
	jb	.L231	 #,
 # dataframe.c:192:     char *p = (char *)malloc(1);
	mov	ecx, 1	 #,
	call	malloc	 #
 # dataframe.c:193:     if (p) p[0] = '\0';
	test	rax, rax	 # p
	je	.L232	 #,
 # dataframe.c:276:                 row[j] = fields[j]; // take ownership
	mov	QWORD PTR [rbx+rbp*8], rax	 # MEM[(char * *)row_142 + j_229 * 8], p
 # dataframe.c:274:         for (size_t j = 0; j < df->n_cols; ++j) {
	add	rbp, 1	 # j,
 # dataframe.c:193:     if (p) p[0] = '\0';
	mov	BYTE PTR [rax], 0	 # *p_201,
 # dataframe.c:274:         for (size_t j = 0; j < df->n_cols; ++j) {
	cmp	rbp, rsi	 # j, n_cols.0_2
	jb	.L185	 #,
.L230:
	mov	rax, QWORD PTR 48[rsp]	 # _12, %sfp
	lea	rbp, [r14+r15*8]	 # _78,
	lea	r12, [rax+r14]	 # ivtmp.175,
 # dataframe.c:291:         for (size_t j = df->n_cols; j < fcount; ++j) free(fields[j]);
	cmp	rsi, r15	 # n_cols.0_2, fcount.18_214
	jnb	.L194	 #,
	.p2align 4
	.p2align 3
.L193:
 # dataframe.c:291:         for (size_t j = df->n_cols; j < fcount; ++j) free(fields[j]);
	mov	rcx, QWORD PTR [r12]	 # MEM[(char * *)_83], MEM[(char * *)_83]
 # dataframe.c:291:         for (size_t j = df->n_cols; j < fcount; ++j) free(fields[j]);
	add	r12, 8	 # ivtmp.175,
 # dataframe.c:291:         for (size_t j = df->n_cols; j < fcount; ++j) free(fields[j]);
	call	free	 #
 # dataframe.c:291:         for (size_t j = df->n_cols; j < fcount; ++j) free(fields[j]);
	cmp	rbp, r12	 # _78, ivtmp.175
	jne	.L193	 #,
.L194:
 # dataframe.c:292:         free(fields);
	mov	rcx, r14	 #, pretmp_246
	call	free	 #
 # dataframe.c:294:         df->data[df->n_rows++] = row;
	mov	rdx, QWORD PTR 72[rsp]	 # _38, %sfp
 # dataframe.c:294:         df->data[df->n_rows++] = row;
	mov	rax, QWORD PTR 24[rdi]	 # _73, df_120->data
 # dataframe.c:294:         df->data[df->n_rows++] = row;
	mov	QWORD PTR [rdi], rdx	 # df_120->n_rows, _38
 # dataframe.c:294:         df->data[df->n_rows++] = row;
	mov	rdx, QWORD PTR 64[rsp]	 # _37, %sfp
	mov	QWORD PTR [rax+rdx*8], rbx	 # *_75, row
	jmp	.L172	 #
	.p2align 4,,10
	.p2align 3
.L227:
	mov	rbp, r14	 # ivtmp.170, pretmp_246
	lea	rbx, [r14+rax*8]	 # _7,
	.p2align 4
	.p2align 3
.L180:
 # dataframe.c:245:             for (size_t i = 0; i < fcount; ++i) free(fields[i]);
	mov	rcx, QWORD PTR 0[rbp]	 # MEM[(char * *)_25], MEM[(char * *)_25]
 # dataframe.c:245:             for (size_t i = 0; i < fcount; ++i) free(fields[i]);
	add	rbp, 8	 # ivtmp.170,
 # dataframe.c:245:             for (size_t i = 0; i < fcount; ++i) free(fields[i]);
	call	free	 #
 # dataframe.c:245:             for (size_t i = 0; i < fcount; ++i) free(fields[i]);
	cmp	rbx, rbp	 # _7, ivtmp.170
	jne	.L180	 #,
.L181:
 # dataframe.c:246:             free(fields);
	mov	rcx, r14	 #, pretmp_246
	call	free	 #
	jmp	.L172	 #
.L232:
 # dataframe.c:278:                 row[j] = empty_strdup();
	mov	QWORD PTR [rbx+rbp*8], 0	 # *_248,
 # dataframe.c:280:                     for (size_t k = 0; k < j; ++k) free(row[k]);
	xor	esi, esi	 # k
	.p2align 4
	.p2align 3
.L190:
 # dataframe.c:280:                     for (size_t k = 0; k < j; ++k) free(row[k]);
	mov	rcx, QWORD PTR [rbx+rsi*8]	 # MEM[(char * *)row_142 + k_230 * 8], MEM[(char * *)row_142 + k_230 * 8]
 # dataframe.c:280:                     for (size_t k = 0; k < j; ++k) free(row[k]);
	add	rsi, 1	 # k,
 # dataframe.c:280:                     for (size_t k = 0; k < j; ++k) free(row[k]);
	call	free	 #
 # dataframe.c:280:                     for (size_t k = 0; k < j; ++k) free(row[k]);
	cmp	rsi, rbp	 # k, j
	jb	.L190	 #,
 # dataframe.c:281:                     free(row);
	mov	rcx, rbx	 #, row
 # dataframe.c:282:                     for (size_t i = 0; i < fcount; ++i) free(fields[i]);
	xor	ebx, ebx	 # i
 # dataframe.c:281:                     free(row);
	call	free	 #
	.p2align 4
	.p2align 3
.L191:
 # dataframe.c:282:                     for (size_t i = 0; i < fcount; ++i) free(fields[i]);
	mov	rcx, QWORD PTR [r14+rbx*8]	 # MEM[(char * *)pretmp_246 + i_231 * 8], MEM[(char * *)pretmp_246 + i_231 * 8]
 # dataframe.c:282:                     for (size_t i = 0; i < fcount; ++i) free(fields[i]);
	add	rbx, 1	 # i,
 # dataframe.c:282:                     for (size_t i = 0; i < fcount; ++i) free(fields[i]);
	call	free	 #
 # dataframe.c:282:                     for (size_t i = 0; i < fcount; ++i) free(fields[i]);
	cmp	rbx, r15	 # i, fcount.18_214
	jb	.L191	 #,
.L221:
 # dataframe.c:283:                     free(fields);
	mov	rcx, r14	 #, pretmp_246
	call	free	 #
.L223:
 # dataframe.c:284:                     free_dataframe(df);
	mov	rcx, rdi	 #, <retval>
	call	free_dataframe	 #
 # dataframe.c:285:                     fclose(f);
	mov	rcx, QWORD PTR 40[rsp]	 #, %sfp
	call	fclose	 #
.L163:
 # dataframe.c:199:     if (!f) return NULL;
	xor	edi, edi	 # <retval>
.L162:
 # dataframe.c:299: }
	mov	rax, rdi	 #, <retval>
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
.L199:
	mov	edx, 512	 # prephitmp_11,
 # dataframe.c:251:             size_t ncap = (rows_cap == 0 ? 64 : rows_cap * 2);
	mov	r13d, 64	 # rows_cap,
	jmp	.L182	 #
.L225:
	mov	rdi, rbx	 # ivtmp.146, pretmp_216
	lea	rsi, [rbx+rsi*8]	 # _39,
.L169:
 # dataframe.c:218:     if (!df) { for (size_t i = 0; i < n_cols; ++i) free(header[i]); free(header); fclose(f); return NULL; }
	mov	rcx, QWORD PTR [rdi]	 # MEM[(char * *)_45], MEM[(char * *)_45]
 # dataframe.c:218:     if (!df) { for (size_t i = 0; i < n_cols; ++i) free(header[i]); free(header); fclose(f); return NULL; }
	add	rdi, 8	 # ivtmp.146,
 # dataframe.c:218:     if (!df) { for (size_t i = 0; i < n_cols; ++i) free(header[i]); free(header); fclose(f); return NULL; }
	call	free	 #
 # dataframe.c:218:     if (!df) { for (size_t i = 0; i < n_cols; ++i) free(header[i]); free(header); fclose(f); return NULL; }
	cmp	rdi, rsi	 # ivtmp.146, _39
	jne	.L169	 #,
.L222:
 # dataframe.c:208:             free(header);
	mov	rcx, rbx	 #, pretmp_216
	call	free	 #
.L164:
 # dataframe.c:210:         fclose(f);
	mov	rcx, QWORD PTR 40[rsp]	 #, %sfp
	call	fclose	 #
 # dataframe.c:211:         return NULL;
	jmp	.L163	 #
.L224:
 # dataframe.c:185:     if (u[0] == 0xEF && u[1] == 0xBB && u[2] == 0xBF) {
	cmp	BYTE PTR 1[rdi], -69	 # MEM[(unsigned char *)_6 + 1B],
	jne	.L167	 #,
 # dataframe.c:185:     if (u[0] == 0xEF && u[1] == 0xBB && u[2] == 0xBF) {
	cmp	BYTE PTR 2[rdi], -65	 # MEM[(unsigned char *)_6 + 2B],
	jne	.L167	 #,
 # dataframe.c:186:         size_t n = strlen(s + 3);
	lea	rbp, 3[rdi]	 # _198,
 # dataframe.c:186:         size_t n = strlen(s + 3);
	mov	rcx, rbp	 #, _198
	call	strlen	 #
 # dataframe.c:187:         memmove(s, s + 3, n + 1);
	mov	rdx, rbp	 #, _198
	mov	rcx, rdi	 #, _6
	lea	r8, 1[rax]	 #,
	call	memmove	 #
	jmp	.L167	 #
.L173:
 # dataframe.c:297:     fclose(f);
	mov	rcx, QWORD PTR 40[rsp]	 #, %sfp
	call	fclose	 #
 # dataframe.c:298:     return df;
	jmp	.L162	 #
.L186:
 # dataframe.c:266:             for (size_t i = 0; i < fcount; ++i) free(fields[i]);
	mov	rcx, QWORD PTR [r14+rbx*8]	 # MEM[(char * *)pretmp_246 + i_228 * 8], MEM[(char * *)pretmp_246 + i_228 * 8]
 # dataframe.c:266:             for (size_t i = 0; i < fcount; ++i) free(fields[i]);
	add	rbx, 1	 # i,
 # dataframe.c:266:             for (size_t i = 0; i < fcount; ++i) free(fields[i]);
	call	free	 #
 # dataframe.c:266:             for (size_t i = 0; i < fcount; ++i) free(fields[i]);
	cmp	rbx, r15	 # i, fcount.18_214
	jb	.L186	 #,
	jmp	.L221	 #
.L229:
 # dataframe.c:254:                 for (size_t i = 0; i < fcount; ++i) free(fields[i]);
	xor	ebx, ebx	 # i
.L184:
 # dataframe.c:254:                 for (size_t i = 0; i < fcount; ++i) free(fields[i]);
	mov	rcx, QWORD PTR [r14+rbx*8]	 # MEM[(char * *)pretmp_246 + i_227 * 8], MEM[(char * *)pretmp_246 + i_227 * 8]
 # dataframe.c:254:                 for (size_t i = 0; i < fcount; ++i) free(fields[i]);
	add	rbx, 1	 # i,
 # dataframe.c:254:                 for (size_t i = 0; i < fcount; ++i) free(fields[i]);
	call	free	 #
 # dataframe.c:254:                 for (size_t i = 0; i < fcount; ++i) free(fields[i]);
	cmp	rbx, r15	 # i, fcount.18_214
	jb	.L184	 #,
	jmp	.L221	 #
.L226:
 # dataframe.c:221:     if (!df->col_names) { free_dataframe(df); for (size_t i = 0; i < n_cols; ++i) free(header[i]); free(header); fclose(f); return NULL; }
	mov	rcx, rdi	 #, <retval>
	mov	rsi, rbx	 # ivtmp.150, pretmp_216
	call	free_dataframe	 #
	mov	rdi, QWORD PTR 48[rsp]	 # _12, %sfp
	add	rdi, rbx	 # _12, pretmp_216
.L171:
 # dataframe.c:221:     if (!df->col_names) { free_dataframe(df); for (size_t i = 0; i < n_cols; ++i) free(header[i]); free(header); fclose(f); return NULL; }
	mov	rcx, QWORD PTR [rsi]	 # MEM[(char * *)_54], MEM[(char * *)_54]
 # dataframe.c:221:     if (!df->col_names) { free_dataframe(df); for (size_t i = 0; i < n_cols; ++i) free(header[i]); free(header); fclose(f); return NULL; }
	add	rsi, 8	 # ivtmp.150,
 # dataframe.c:221:     if (!df->col_names) { free_dataframe(df); for (size_t i = 0; i < n_cols; ++i) free(header[i]); free(header); fclose(f); return NULL; }
	call	free	 #
 # dataframe.c:221:     if (!df->col_names) { free_dataframe(df); for (size_t i = 0; i < n_cols; ++i) free(header[i]); free(header); fclose(f); return NULL; }
	cmp	rdi, rsi	 # _36, ivtmp.150
	jne	.L171	 #,
	jmp	.L222	 #
	.seh_endproc
	.section .rdata,"dr"
.LC1:
	.ascii "Usage: %s <csv_filename>\12\0"
.LC2:
	.ascii "Failed to read CSV: %s\12\0"
.LC3:
	.ascii "File: %s\12\0"
.LC4:
	.ascii "Rows: %zu, Cols: %zu\12\0"
.LC5:
	.ascii "Headers:\0"
.LC6:
	.ascii "Data:\0"
.LC7:
	.ascii "  [%zu] %s\12\0"
.LC8:
	.ascii "Row %zu: \0"
.LC9:
	.ascii "%s\0"
.LC10:
	.ascii ", \0"
	.section	.text.startup,"x"
	.p2align 4
	.globl	main
	.def	main;	.scl	2;	.type	32;	.endef
	.seh_proc	main
main:
	push	rbp	 #
	.seh_pushreg	rbp
	push	rdi	 #
	.seh_pushreg	rdi
	push	rsi	 #
	.seh_pushreg	rsi
	push	rbx	 #
	.seh_pushreg	rbx
	sub	rsp, 40	 #,
	.seh_stackalloc	40
	.seh_endprologue
 # dataframe.c:303: int main(int argc, char *argv[]) {
	mov	ebx, ecx	 # argc, argc
	mov	rsi, rdx	 # argv, argv
	call	__main	 #
 # dataframe.c:304:     if (argc < 2) {
	cmp	ebx, 1	 # argc,
	jle	.L251	 #,
 # dataframe.c:309:     const char *filename = argv[1];
	mov	rbx, QWORD PTR 8[rsi]	 # filename, MEM[(char * *)argv_33(D) + 8B]
 # dataframe.c:310:     DataFrame *df = read_csv(filename, ',');
	mov	edx, 44	 #,
	mov	rcx, rbx	 #, filename
	call	read_csv	 #
	mov	rsi, rax	 # df,
 # dataframe.c:311:     if (!df) {
	test	rax, rax	 # df
	je	.L252	 #,
 # dataframe.c:316:     printf("File: %s\n", filename);
	mov	rdx, rbx	 #, filename
	lea	rcx, .LC3[rip]	 #,
 # dataframe.c:321:     for (size_t j = 0; j < df->n_cols; ++j)
	xor	ebx, ebx	 # j
 # dataframe.c:316:     printf("File: %s\n", filename);
	call	printf	 #
 # dataframe.c:317:     printf("Rows: %zu, Cols: %zu\n", df->n_rows, df->n_cols);
	mov	r8, QWORD PTR 8[rsi]	 #, df_36->n_cols
	mov	rdx, QWORD PTR [rsi]	 #, df_36->n_rows
	lea	rcx, .LC4[rip]	 #,
	call	printf	 #
 # dataframe.c:320:     printf("Headers:\n");
	lea	rcx, .LC5[rip]	 #,
	call	puts	 #
 # dataframe.c:321:     for (size_t j = 0; j < df->n_cols; ++j)
	cmp	QWORD PTR 8[rsi], 0	 # df_36->n_cols,
	je	.L240	 #,
	.p2align 4
	.p2align 3
.L237:
 # dataframe.c:322:         printf("  [%zu] %s\n", j, df->col_names[j]);
	mov	rax, QWORD PTR 16[rsi]	 # df_36->col_names, df_36->col_names
	mov	rdx, rbx	 #, j
	lea	rcx, .LC7[rip]	 #,
	mov	r8, QWORD PTR [rax+rbx*8]	 #, *_8
 # dataframe.c:321:     for (size_t j = 0; j < df->n_cols; ++j)
	add	rbx, 1	 # j,
 # dataframe.c:322:         printf("  [%zu] %s\n", j, df->col_names[j]);
	call	printf	 #
 # dataframe.c:321:     for (size_t j = 0; j < df->n_cols; ++j)
	cmp	rbx, QWORD PTR 8[rsi]	 # j, df_36->n_cols
	jb	.L237	 #,
.L240:
 # dataframe.c:323:     printf("\n");
	mov	ecx, 10	 #,
 # dataframe.c:327:     for (size_t i = 0; i < df->n_rows; ++i) {
	xor	ebp, ebp	 # i
 # dataframe.c:323:     printf("\n");
	call	putchar	 #
 # dataframe.c:326:     printf("Data:\n");
	lea	rcx, .LC6[rip]	 #,
	call	puts	 #
 # dataframe.c:327:     for (size_t i = 0; i < df->n_rows; ++i) {
	cmp	QWORD PTR [rsi], 0	 # df_36->n_rows,
	je	.L239	 #,
	.p2align 4
	.p2align 3
.L238:
 # dataframe.c:328:         printf("Row %zu: ", i);
	mov	rdx, rbp	 #, i
	lea	rcx, .LC8[rip]	 #,
	lea	rdi, 0[0+rbp*8]	 # _59,
 # dataframe.c:329:         for (size_t j = 0; j < df->n_cols; ++j) {
	xor	ebx, ebx	 # j
 # dataframe.c:328:         printf("Row %zu: ", i);
	call	printf	 #
 # dataframe.c:329:         for (size_t j = 0; j < df->n_cols; ++j) {
	cmp	QWORD PTR 8[rsi], 0	 # df_36->n_cols,
	jne	.L244	 #,
	jmp	.L245	 #
	.p2align 4,,10
	.p2align 3
.L243:
 # dataframe.c:329:         for (size_t j = 0; j < df->n_cols; ++j) {
	add	rbx, 1	 # j,
 # dataframe.c:329:         for (size_t j = 0; j < df->n_cols; ++j) {
	cmp	rbx, rax	 # j, _18
	jnb	.L245	 #,
.L244:
 # dataframe.c:330:             printf("%s", df->data[i][j]);
	mov	rax, QWORD PTR 24[rsi]	 # df_36->data, df_36->data
 # dataframe.c:330:             printf("%s", df->data[i][j]);
	lea	rcx, .LC9[rip]	 #,
	mov	rax, QWORD PTR [rax+rdi]	 # *_13, *_13
	mov	rdx, QWORD PTR [rax+rbx*8]	 # *_16, *_16
	call	printf	 #
 # dataframe.c:331:             if (j < df->n_cols - 1) printf(", ");
	mov	rax, QWORD PTR 8[rsi]	 # _18, df_36->n_cols
 # dataframe.c:331:             if (j < df->n_cols - 1) printf(", ");
	lea	rdx, -1[rax]	 # _19,
 # dataframe.c:331:             if (j < df->n_cols - 1) printf(", ");
	cmp	rbx, rdx	 # j, _19
	jnb	.L243	 #,
 # dataframe.c:331:             if (j < df->n_cols - 1) printf(", ");
	lea	rcx, .LC10[rip]	 #,
 # dataframe.c:329:         for (size_t j = 0; j < df->n_cols; ++j) {
	add	rbx, 1	 # j,
 # dataframe.c:331:             if (j < df->n_cols - 1) printf(", ");
	call	printf	 #
 # dataframe.c:329:         for (size_t j = 0; j < df->n_cols; ++j) {
	mov	rax, QWORD PTR 8[rsi]	 # _18, df_36->n_cols
 # dataframe.c:329:         for (size_t j = 0; j < df->n_cols; ++j) {
	cmp	rbx, rax	 # j, _18
	jb	.L244	 #,
.L245:
 # dataframe.c:333:         printf("\n");
	mov	ecx, 10	 #,
 # dataframe.c:327:     for (size_t i = 0; i < df->n_rows; ++i) {
	add	rbp, 1	 # i,
 # dataframe.c:333:         printf("\n");
	call	putchar	 #
 # dataframe.c:327:     for (size_t i = 0; i < df->n_rows; ++i) {
	cmp	rbp, QWORD PTR [rsi]	 # i, df_36->n_rows
	jb	.L238	 #,
.L239:
 # dataframe.c:336:     free_dataframe(df);
	mov	rcx, rsi	 #, df
	call	free_dataframe	 #
 # dataframe.c:337:     return 0;
	xor	eax, eax	 # <retval>
.L233:
 # dataframe.c:338: }
	add	rsp, 40	 #,
	pop	rbx	 #
	pop	rsi	 #
	pop	rdi	 #
	pop	rbp	 #
	ret	
.L251:
 # dataframe.c:305:         fprintf(stderr, "Usage: %s <csv_filename>\n", argv[0]);
	mov	rbx, QWORD PTR [rsi]	 # _1, *argv_33(D)
 # dataframe.c:305:         fprintf(stderr, "Usage: %s <csv_filename>\n", argv[0]);
	mov	ecx, 2	 #,
	call	[QWORD PTR __imp___acrt_iob_func[rip]]	 #
 # dataframe.c:305:         fprintf(stderr, "Usage: %s <csv_filename>\n", argv[0]);
	lea	rdx, .LC1[rip]	 #,
	mov	r8, rbx	 #, _1
	mov	rcx, rax	 #, _2
	call	fprintf	 #
.L235:
 # dataframe.c:306:         return 1;
	mov	eax, 1	 # <retval>,
	jmp	.L233	 #
.L252:
 # dataframe.c:312:         fprintf(stderr, "Failed to read CSV: %s\n", filename);
	mov	ecx, 2	 #,
	call	[QWORD PTR __imp___acrt_iob_func[rip]]	 #
 # dataframe.c:312:         fprintf(stderr, "Failed to read CSV: %s\n", filename);
	mov	r8, rbx	 #, filename
	lea	rdx, .LC2[rip]	 #,
	mov	rcx, rax	 #, _3
	call	fprintf	 #
 # dataframe.c:313:         return 1;
	jmp	.L235	 #
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
	.def	calloc;	.scl	2;	.type	32;	.endef
	.def	fclose;	.scl	2;	.type	32;	.endef
	.def	strlen;	.scl	2;	.type	32;	.endef
	.def	memmove;	.scl	2;	.type	32;	.endef
	.def	printf;	.scl	2;	.type	32;	.endef
	.def	puts;	.scl	2;	.type	32;	.endef
	.def	putchar;	.scl	2;	.type	32;	.endef
	.def	fprintf;	.scl	2;	.type	32;	.endef
