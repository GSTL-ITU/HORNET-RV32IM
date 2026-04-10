
aes_main.elf:     file format elf32-littleriscv


Disassembly of section .init:

00000000 <_start>:
   0:	00008117          	auipc	sp,0x8
   4:	ffc10113          	addi	sp,sp,-4 # 7ffc <__stack_top>
   8:	00010433          	add	s0,sp,zero
   c:	0040006f          	j	10 <main>

Disassembly of section .text:

00000010 <main>:
  10:	f1010113          	addi	sp,sp,-240
  14:	0e112623          	sw	ra,236(sp)
  18:	0e812423          	sw	s0,232(sp)
  1c:	0e912223          	sw	s1,228(sp)
  20:	0f212023          	sw	s2,224(sp)
  24:	0d312e23          	sw	s3,220(sp)
  28:	0d412c23          	sw	s4,216(sp)
  2c:	0d512a23          	sw	s5,212(sp)
  30:	0d612823          	sw	s6,208(sp)
  34:	0d712623          	sw	s7,204(sp)
  38:	425000ef          	jal	c5c <SET_MTVEC_VECTOR_MODE>
  3c:	30046073          	csrsi	mstatus,8
  40:	00010a37          	lui	s4,0x10
  44:	304a2073          	csrs	mie,s4
  48:	00007b37          	lui	s6,0x7
  4c:	000b0513          	mv	a0,s6
  50:	00007437          	lui	s0,0x7
  54:	100095b7          	lui	a1,0x10009
  58:	00007ab7          	lui	s5,0x7
  5c:	00007937          	lui	s2,0x7
  60:	100084b7          	lui	s1,0x10008
  64:	00042223          	sw	zero,4(s0) # 7004 <count>
  68:	008a8a93          	addi	s5,s5,8 # 7008 <key>
  6c:	33d000ef          	jal	ba8 <uart_init>
  70:	01890913          	addi	s2,s2,24 # 7018 <input_array>
  74:	02048493          	addi	s1,s1,32 # 10008020 <__stack_top+0x10000024>
  78:	01f00993          	li	s3,31
  7c:	00100b93          	li	s7,1
  80:	30046073          	csrsi	mstatus,8
  84:	304a2073          	csrs	mie,s4
  88:	00442783          	lw	a5,4(s0)
  8c:	fef9dee3          	bge	s3,a5,88 <main+0x78>
  90:	000a8593          	mv	a1,s5
  94:	00010513          	mv	a0,sp
  98:	2fd000ef          	jal	b94 <AES_init_ctx>
  9c:	00090593          	mv	a1,s2
  a0:	00010513          	mv	a0,sp
  a4:	01748023          	sb	s7,0(s1)
  a8:	2f1000ef          	jal	b98 <AES_ECB_encrypt>
  ac:	00090593          	mv	a1,s2
  b0:	00048023          	sb	zero,0(s1)
  b4:	000b0513          	mv	a0,s6
  b8:	01000613          	li	a2,16
  bc:	319000ef          	jal	bd4 <uart_transmit_string>
  c0:	00042223          	sw	zero,4(s0)
  c4:	fbdff06f          	j	80 <main+0x70>

000000c8 <mti_handler>:
  c8:	30200073          	mret

000000cc <exc_handler>:
  cc:	30200073          	mret

000000d0 <mei_handler>:
  d0:	30200073          	mret

000000d4 <msi_handler>:
  d4:	30200073          	mret

000000d8 <fast_irq0_handler>:
  d8:	fe010113          	addi	sp,sp,-32
  dc:	00f12623          	sw	a5,12(sp)
  e0:	100097b7          	lui	a5,0x10009
  e4:	00b12e23          	sw	a1,28(sp)
  e8:	00c12c23          	sw	a2,24(sp)
  ec:	00d12a23          	sw	a3,20(sp)
  f0:	00e12823          	sw	a4,16(sp)
  f4:	00878793          	addi	a5,a5,8 # 10009008 <__stack_top+0x1000100c>
  f8:	0007c783          	lbu	a5,0(a5)
  fc:	0017f793          	andi	a5,a5,1
 100:	04078063          	beqz	a5,140 <fast_irq0_handler+0x68>
 104:	000076b7          	lui	a3,0x7
 108:	0046a783          	lw	a5,4(a3) # 7004 <count>
 10c:	10009737          	lui	a4,0x10009
 110:	00074703          	lbu	a4,0(a4) # 10009000 <__stack_top+0x10001004>
 114:	00f00593          	li	a1,15
 118:	0ff7f613          	zext.b	a2,a5
 11c:	04c5e063          	bltu	a1,a2,15c <fast_irq0_handler+0x84>
 120:	00007637          	lui	a2,0x7
 124:	0ff7f793          	zext.b	a5,a5
 128:	01860613          	addi	a2,a2,24 # 7018 <input_array>
 12c:	00f607b3          	add	a5,a2,a5
 130:	00e78023          	sb	a4,0(a5)
 134:	0046a783          	lw	a5,4(a3)
 138:	00178793          	addi	a5,a5,1
 13c:	00f6a223          	sw	a5,4(a3)
 140:	01c12583          	lw	a1,28(sp)
 144:	01812603          	lw	a2,24(sp)
 148:	01412683          	lw	a3,20(sp)
 14c:	01012703          	lw	a4,16(sp)
 150:	00c12783          	lw	a5,12(sp)
 154:	02010113          	addi	sp,sp,32
 158:	30200073          	mret
 15c:	01f00593          	li	a1,31
 160:	00c5ee63          	bltu	a1,a2,17c <fast_irq0_handler+0xa4>
 164:	00007637          	lui	a2,0x7
 168:	0ff7f793          	zext.b	a5,a5
 16c:	00860613          	addi	a2,a2,8 # 7008 <key>
 170:	00f607b3          	add	a5,a2,a5
 174:	fee78823          	sb	a4,-16(a5)
 178:	fbdff06f          	j	134 <fast_irq0_handler+0x5c>
 17c:	30047073          	csrci	mstatus,8
 180:	01c12583          	lw	a1,28(sp)
 184:	01812603          	lw	a2,24(sp)
 188:	01412683          	lw	a3,20(sp)
 18c:	01012703          	lw	a4,16(sp)
 190:	00c12783          	lw	a5,12(sp)
 194:	02010113          	addi	sp,sp,32
 198:	30200073          	mret

0000019c <fast_irq1_handler>:
 19c:	30200073          	mret

000001a0 <KeyExpansion>:
 1a0:	00350793          	addi	a5,a0,3
 1a4:	fc010113          	addi	sp,sp,-64
 1a8:	40b787b3          	sub	a5,a5,a1
 1ac:	02812e23          	sw	s0,60(sp)
 1b0:	02912c23          	sw	s1,56(sp)
 1b4:	03212a23          	sw	s2,52(sp)
 1b8:	03312823          	sw	s3,48(sp)
 1bc:	03412623          	sw	s4,44(sp)
 1c0:	03512423          	sw	s5,40(sp)
 1c4:	03612223          	sw	s6,36(sp)
 1c8:	03712023          	sw	s7,32(sp)
 1cc:	01812e23          	sw	s8,28(sp)
 1d0:	01912c23          	sw	s9,24(sp)
 1d4:	01a12a23          	sw	s10,20(sp)
 1d8:	01b12823          	sw	s11,16(sp)
 1dc:	0077b793          	sltiu	a5,a5,7
 1e0:	1c079463          	bnez	a5,3a8 <KeyExpansion+0x208>
 1e4:	00b567b3          	or	a5,a0,a1
 1e8:	0037f793          	andi	a5,a5,3
 1ec:	1a079e63          	bnez	a5,3a8 <KeyExpansion+0x208>
 1f0:	0005a783          	lw	a5,0(a1) # 10009000 <__stack_top+0x10001004>
 1f4:	00f52023          	sw	a5,0(a0)
 1f8:	0045a783          	lw	a5,4(a1)
 1fc:	00f52223          	sw	a5,4(a0)
 200:	0085a783          	lw	a5,8(a1)
 204:	00f52423          	sw	a5,8(a0)
 208:	00c5a783          	lw	a5,12(a1)
 20c:	00f52623          	sw	a5,12(a0)
 210:	000017b7          	lui	a5,0x1
 214:	00001eb7          	lui	t4,0x1
 218:	c7078793          	addi	a5,a5,-912 # c70 <Rcon>
 21c:	00354603          	lbu	a2,3(a0)
 220:	00754b83          	lbu	s7,7(a0)
 224:	00b54b03          	lbu	s6,11(a0)
 228:	00f54383          	lbu	t2,15(a0)
 22c:	00254803          	lbu	a6,2(a0)
 230:	00654a83          	lbu	s5,6(a0)
 234:	00a54a03          	lbu	s4,10(a0)
 238:	00e54283          	lbu	t0,14(a0)
 23c:	00154883          	lbu	a7,1(a0)
 240:	00554983          	lbu	s3,5(a0)
 244:	00954903          	lbu	s2,9(a0)
 248:	00d54f83          	lbu	t6,13(a0)
 24c:	00054703          	lbu	a4,0(a0)
 250:	00454c83          	lbu	s9,4(a0)
 254:	00854c03          	lbu	s8,8(a0)
 258:	00c54f03          	lbu	t5,12(a0)
 25c:	c7ce8e93          	addi	t4,t4,-900 # c7c <sbox>
 260:	00f12423          	sw	a5,8(sp)
 264:	01050313          	addi	t1,a0,16
 268:	00400e13          	li	t3,4
 26c:	09c0006f          	j	308 <KeyExpansion+0x168>
 270:	007e86b3          	add	a3,t4,t2
 274:	00044783          	lbu	a5,0(s0)
 278:	0006c583          	lbu	a1,0(a3)
 27c:	000dc403          	lbu	s0,0(s11)
 280:	01ee86b3          	add	a3,t4,t5
 284:	000d4503          	lbu	a0,0(s10)
 288:	0006c683          	lbu	a3,0(a3)
 28c:	0087c7b3          	xor	a5,a5,s0
 290:	00f747b3          	xor	a5,a4,a5
 294:	01154533          	xor	a0,a0,a7
 298:	00b845b3          	xor	a1,a6,a1
 29c:	00c6c6b3          	xor	a3,a3,a2
 2a0:	0ff7f793          	zext.b	a5,a5
 2a4:	0ff57513          	zext.b	a0,a0
 2a8:	0ff5f593          	zext.b	a1,a1
 2ac:	0ff6f693          	zext.b	a3,a3
 2b0:	00f30023          	sb	a5,0(t1)
 2b4:	00a300a3          	sb	a0,1(t1)
 2b8:	00b30123          	sb	a1,2(t1)
 2bc:	00d301a3          	sb	a3,3(t1)
 2c0:	001e0e13          	addi	t3,t3,1
 2c4:	00430313          	addi	t1,t1,4
 2c8:	000c8713          	mv	a4,s9
 2cc:	00098893          	mv	a7,s3
 2d0:	000a8813          	mv	a6,s5
 2d4:	000b8613          	mv	a2,s7
 2d8:	000c0c93          	mv	s9,s8
 2dc:	00090993          	mv	s3,s2
 2e0:	000a0a93          	mv	s5,s4
 2e4:	000b0b93          	mv	s7,s6
 2e8:	000f0c13          	mv	s8,t5
 2ec:	000f8913          	mv	s2,t6
 2f0:	00028a13          	mv	s4,t0
 2f4:	00038b13          	mv	s6,t2
 2f8:	00078f13          	mv	t5,a5
 2fc:	00050f93          	mv	t6,a0
 300:	00058293          	mv	t0,a1
 304:	00068393          	mv	t2,a3
 308:	00812783          	lw	a5,8(sp)
 30c:	002e5413          	srli	s0,t3,0x2
 310:	011fc533          	xor	a0,t6,a7
 314:	00878433          	add	s0,a5,s0
 318:	01ee87b3          	add	a5,t4,t5
 31c:	00f12623          	sw	a5,12(sp)
 320:	005845b3          	xor	a1,a6,t0
 324:	00ef47b3          	xor	a5,t5,a4
 328:	00c3c6b3          	xor	a3,t2,a2
 32c:	003e7493          	andi	s1,t3,3
 330:	01fe8db3          	add	s11,t4,t6
 334:	005e8d33          	add	s10,t4,t0
 338:	0ff7f793          	zext.b	a5,a5
 33c:	0ff57513          	zext.b	a0,a0
 340:	0ff5f593          	zext.b	a1,a1
 344:	0ff6f693          	zext.b	a3,a3
 348:	f20484e3          	beqz	s1,270 <KeyExpansion+0xd0>
 34c:	00f30023          	sb	a5,0(t1)
 350:	00a300a3          	sb	a0,1(t1)
 354:	00b30123          	sb	a1,2(t1)
 358:	00d301a3          	sb	a3,3(t1)
 35c:	001e0e13          	addi	t3,t3,1
 360:	02c00713          	li	a4,44
 364:	00ee0663          	beq	t3,a4,370 <KeyExpansion+0x1d0>
 368:	00430313          	addi	t1,t1,4
 36c:	f5dff06f          	j	2c8 <KeyExpansion+0x128>
 370:	03c12403          	lw	s0,60(sp)
 374:	03812483          	lw	s1,56(sp)
 378:	03412903          	lw	s2,52(sp)
 37c:	03012983          	lw	s3,48(sp)
 380:	02c12a03          	lw	s4,44(sp)
 384:	02812a83          	lw	s5,40(sp)
 388:	02412b03          	lw	s6,36(sp)
 38c:	02012b83          	lw	s7,32(sp)
 390:	01c12c03          	lw	s8,28(sp)
 394:	01812c83          	lw	s9,24(sp)
 398:	01412d03          	lw	s10,20(sp)
 39c:	01012d83          	lw	s11,16(sp)
 3a0:	04010113          	addi	sp,sp,64
 3a4:	00008067          	ret
 3a8:	0005c783          	lbu	a5,0(a1)
 3ac:	00f50023          	sb	a5,0(a0)
 3b0:	0015c783          	lbu	a5,1(a1)
 3b4:	00f500a3          	sb	a5,1(a0)
 3b8:	0025c783          	lbu	a5,2(a1)
 3bc:	00f50123          	sb	a5,2(a0)
 3c0:	0035c783          	lbu	a5,3(a1)
 3c4:	00f501a3          	sb	a5,3(a0)
 3c8:	0045c783          	lbu	a5,4(a1)
 3cc:	00f50223          	sb	a5,4(a0)
 3d0:	0055c783          	lbu	a5,5(a1)
 3d4:	00f502a3          	sb	a5,5(a0)
 3d8:	0065c783          	lbu	a5,6(a1)
 3dc:	00f50323          	sb	a5,6(a0)
 3e0:	0075c783          	lbu	a5,7(a1)
 3e4:	00f503a3          	sb	a5,7(a0)
 3e8:	0085c783          	lbu	a5,8(a1)
 3ec:	00f50423          	sb	a5,8(a0)
 3f0:	0095c783          	lbu	a5,9(a1)
 3f4:	00f504a3          	sb	a5,9(a0)
 3f8:	00a5c783          	lbu	a5,10(a1)
 3fc:	00f50523          	sb	a5,10(a0)
 400:	00b5c783          	lbu	a5,11(a1)
 404:	00f505a3          	sb	a5,11(a0)
 408:	00c5c783          	lbu	a5,12(a1)
 40c:	00f50623          	sb	a5,12(a0)
 410:	00d5c783          	lbu	a5,13(a1)
 414:	00f506a3          	sb	a5,13(a0)
 418:	00e5c783          	lbu	a5,14(a1)
 41c:	00f50723          	sb	a5,14(a0)
 420:	00f5c783          	lbu	a5,15(a1)
 424:	00f507a3          	sb	a5,15(a0)
 428:	de9ff06f          	j	210 <KeyExpansion+0x70>

0000042c <Cipher>:
 42c:	00350793          	addi	a5,a0,3
 430:	fd010113          	addi	sp,sp,-48
 434:	40b787b3          	sub	a5,a5,a1
 438:	02812623          	sw	s0,44(sp)
 43c:	02912423          	sw	s1,40(sp)
 440:	03212223          	sw	s2,36(sp)
 444:	03312023          	sw	s3,32(sp)
 448:	01412e23          	sw	s4,28(sp)
 44c:	01512c23          	sw	s5,24(sp)
 450:	01612a23          	sw	s6,20(sp)
 454:	01712823          	sw	s7,16(sp)
 458:	01812623          	sw	s8,12(sp)
 45c:	01912423          	sw	s9,8(sp)
 460:	01a12223          	sw	s10,4(sp)
 464:	01b12023          	sw	s11,0(sp)
 468:	0077b793          	sltiu	a5,a5,7
 46c:	00058413          	mv	s0,a1
 470:	54079e63          	bnez	a5,9cc <Cipher+0x5a0>
 474:	00a5e7b3          	or	a5,a1,a0
 478:	0037f793          	andi	a5,a5,3
 47c:	54079863          	bnez	a5,9cc <Cipher+0x5a0>
 480:	0005a603          	lw	a2,0(a1)
 484:	00052783          	lw	a5,0(a0)
 488:	00452683          	lw	a3,4(a0)
 48c:	00852703          	lw	a4,8(a0)
 490:	00c7c7b3          	xor	a5,a5,a2
 494:	00f52023          	sw	a5,0(a0)
 498:	0045a603          	lw	a2,4(a1)
 49c:	00c52783          	lw	a5,12(a0)
 4a0:	00c6c6b3          	xor	a3,a3,a2
 4a4:	00d52223          	sw	a3,4(a0)
 4a8:	0085a683          	lw	a3,8(a1)
 4ac:	00d74733          	xor	a4,a4,a3
 4b0:	00e52423          	sw	a4,8(a0)
 4b4:	00c5a703          	lw	a4,12(a1)
 4b8:	00e7c7b3          	xor	a5,a5,a4
 4bc:	00f52623          	sw	a5,12(a0)
 4c0:	000015b7          	lui	a1,0x1
 4c4:	00054a83          	lbu	s5,0(a0)
 4c8:	00454283          	lbu	t0,4(a0)
 4cc:	00854983          	lbu	s3,8(a0)
 4d0:	00c54483          	lbu	s1,12(a0)
 4d4:	00154683          	lbu	a3,1(a0)
 4d8:	00554603          	lbu	a2,5(a0)
 4dc:	00954383          	lbu	t2,9(a0)
 4e0:	00d54f83          	lbu	t6,13(a0)
 4e4:	00254703          	lbu	a4,2(a0)
 4e8:	00654f03          	lbu	t5,6(a0)
 4ec:	00a54e83          	lbu	t4,10(a0)
 4f0:	00e54e03          	lbu	t3,14(a0)
 4f4:	00354303          	lbu	t1,3(a0)
 4f8:	00754883          	lbu	a7,7(a0)
 4fc:	00b54803          	lbu	a6,11(a0)
 500:	00f54a03          	lbu	s4,15(a0)
 504:	c7c58593          	addi	a1,a1,-900 # c7c <sbox>
 508:	01040793          	addi	a5,s0,16
 50c:	0a040d13          	addi	s10,s0,160
 510:	3540006f          	j	864 <Cipher+0x438>
 514:	01374833          	xor	a6,a4,s3
 518:	00785613          	srli	a2,a6,0x7
 51c:	0076c8b3          	xor	a7,a3,t2
 520:	40c00633          	neg	a2,a2
 524:	00181313          	slli	t1,a6,0x1
 528:	01b67613          	andi	a2,a2,27
 52c:	0108c833          	xor	a6,a7,a6
 530:	00664633          	xor	a2,a2,t1
 534:	00e84333          	xor	t1,a6,a4
 538:	00774733          	xor	a4,a4,t2
 53c:	00664633          	xor	a2,a2,t1
 540:	00775313          	srli	t1,a4,0x7
 544:	40600333          	neg	t1,t1
 548:	00171713          	slli	a4,a4,0x1
 54c:	01b37313          	andi	t1,t1,27
 550:	00e34333          	xor	t1,t1,a4
 554:	0078d713          	srli	a4,a7,0x7
 558:	40e00733          	neg	a4,a4
 55c:	007843b3          	xor	t2,a6,t2
 560:	00189893          	slli	a7,a7,0x1
 564:	01b77713          	andi	a4,a4,27
 568:	00734333          	xor	t1,t1,t2
 56c:	01174733          	xor	a4,a4,a7
 570:	00d9c3b3          	xor	t2,s3,a3
 574:	00d846b3          	xor	a3,a6,a3
 578:	00d74733          	xor	a4,a4,a3
 57c:	0073d693          	srli	a3,t2,0x7
 580:	40d006b3          	neg	a3,a3
 584:	009ec8b3          	xor	a7,t4,s1
 588:	00139393          	slli	t2,t2,0x1
 58c:	01b6f693          	andi	a3,a3,27
 590:	0076c6b3          	xor	a3,a3,t2
 594:	0078d393          	srli	t2,a7,0x7
 598:	016bcc33          	xor	s8,s7,s6
 59c:	01384833          	xor	a6,a6,s3
 5a0:	407003b3          	neg	t2,t2
 5a4:	0106c6b3          	xor	a3,a3,a6
 5a8:	00189993          	slli	s3,a7,0x1
 5ac:	0188c833          	xor	a6,a7,s8
 5b0:	01b3f393          	andi	t2,t2,27
 5b4:	01d848b3          	xor	a7,a6,t4
 5b8:	0133c3b3          	xor	t2,t2,s3
 5bc:	016eceb3          	xor	t4,t4,s6
 5c0:	0113c3b3          	xor	t2,t2,a7
 5c4:	007ed893          	srli	a7,t4,0x7
 5c8:	411008b3          	neg	a7,a7
 5cc:	001e9e93          	slli	t4,t4,0x1
 5d0:	01b8f893          	andi	a7,a7,27
 5d4:	01684b33          	xor	s6,a6,s6
 5d8:	01d8c8b3          	xor	a7,a7,t4
 5dc:	0168c8b3          	xor	a7,a7,s6
 5e0:	007c5b13          	srli	s6,s8,0x7
 5e4:	41600b33          	neg	s6,s6
 5e8:	001c1c13          	slli	s8,s8,0x1
 5ec:	01bb7b13          	andi	s6,s6,27
 5f0:	0174c9b3          	xor	s3,s1,s7
 5f4:	018b4b33          	xor	s6,s6,s8
 5f8:	01784bb3          	xor	s7,a6,s7
 5fc:	017b4b33          	xor	s6,s6,s7
 600:	0079db93          	srli	s7,s3,0x7
 604:	41700bb3          	neg	s7,s7
 608:	00594eb3          	xor	t4,s2,t0
 60c:	00199993          	slli	s3,s3,0x1
 610:	01bbfb93          	andi	s7,s7,27
 614:	013bcbb3          	xor	s7,s7,s3
 618:	007ed993          	srli	s3,t4,0x7
 61c:	019fcc33          	xor	s8,t6,s9
 620:	00984833          	xor	a6,a6,s1
 624:	413009b3          	neg	s3,s3
 628:	01dc44b3          	xor	s1,s8,t4
 62c:	010bcbb3          	xor	s7,s7,a6
 630:	01b9f993          	andi	s3,s3,27
 634:	001e9813          	slli	a6,t4,0x1
 638:	0109c9b3          	xor	s3,s3,a6
 63c:	0124c833          	xor	a6,s1,s2
 640:	01994933          	xor	s2,s2,s9
 644:	0109c9b3          	xor	s3,s3,a6
 648:	00795813          	srli	a6,s2,0x7
 64c:	41000833          	neg	a6,a6
 650:	00191913          	slli	s2,s2,0x1
 654:	01b87813          	andi	a6,a6,27
 658:	01284833          	xor	a6,a6,s2
 65c:	01f2c933          	xor	s2,t0,t6
 660:	0194ccb3          	xor	s9,s1,s9
 664:	01f4cfb3          	xor	t6,s1,t6
 668:	0054c2b3          	xor	t0,s1,t0
 66c:	00795493          	srli	s1,s2,0x7
 670:	409004b3          	neg	s1,s1
 674:	01984833          	xor	a6,a6,s9
 678:	007c5e93          	srli	t4,s8,0x7
 67c:	015a4cb3          	xor	s9,s4,s5
 680:	00191913          	slli	s2,s2,0x1
 684:	01b4f493          	andi	s1,s1,27
 688:	0124c4b3          	xor	s1,s1,s2
 68c:	41d00eb3          	neg	t4,t4
 690:	007cd913          	srli	s2,s9,0x7
 694:	001c1c13          	slli	s8,s8,0x1
 698:	01befe93          	andi	t4,t4,27
 69c:	41200933          	neg	s2,s2
 6a0:	0054c4b3          	xor	s1,s1,t0
 6a4:	018eceb3          	xor	t4,t4,s8
 6a8:	001c9293          	slli	t0,s9,0x1
 6ac:	01cf4c33          	xor	s8,t5,t3
 6b0:	01b97913          	andi	s2,s2,27
 6b4:	01feceb3          	xor	t4,t4,t6
 6b8:	00594933          	xor	s2,s2,t0
 6bc:	019c4fb3          	xor	t6,s8,s9
 6c0:	01ca42b3          	xor	t0,s4,t3
 6c4:	014fcdb3          	xor	s11,t6,s4
 6c8:	0072da13          	srli	s4,t0,0x7
 6cc:	41400a33          	neg	s4,s4
 6d0:	00129293          	slli	t0,t0,0x1
 6d4:	01ba7a13          	andi	s4,s4,27
 6d8:	005a4a33          	xor	s4,s4,t0
 6dc:	01eac2b3          	xor	t0,s5,t5
 6e0:	01cfccb3          	xor	s9,t6,t3
 6e4:	01efcf33          	xor	t5,t6,t5
 6e8:	015fcab3          	xor	s5,t6,s5
 6ec:	007c5e13          	srli	t3,s8,0x7
 6f0:	0072df93          	srli	t6,t0,0x7
 6f4:	41c00e33          	neg	t3,t3
 6f8:	41f00fb3          	neg	t6,t6
 6fc:	00129293          	slli	t0,t0,0x1
 700:	01be7e13          	andi	t3,t3,27
 704:	001c1c13          	slli	s8,s8,0x1
 708:	01bfff93          	andi	t6,t6,27
 70c:	005fcfb3          	xor	t6,t6,t0
 710:	018e4e33          	xor	t3,t3,s8
 714:	01b94933          	xor	s2,s2,s11
 718:	01ee4e33          	xor	t3,t3,t5
 71c:	015fcfb3          	xor	t6,t6,s5
 720:	019a4a33          	xor	s4,s4,s9
 724:	00c50023          	sb	a2,0(a0)
 728:	006501a3          	sb	t1,3(a0)
 72c:	00e50123          	sb	a4,2(a0)
 730:	00d500a3          	sb	a3,1(a0)
 734:	011503a3          	sb	a7,7(a0)
 738:	00750223          	sb	t2,4(a0)
 73c:	01650323          	sb	s6,6(a0)
 740:	017502a3          	sb	s7,5(a0)
 744:	01350423          	sb	s3,8(a0)
 748:	010505a3          	sb	a6,11(a0)
 74c:	01d50523          	sb	t4,10(a0)
 750:	009504a3          	sb	s1,9(a0)
 754:	01250623          	sb	s2,12(a0)
 758:	014507a3          	sb	s4,15(a0)
 75c:	01c50723          	sb	t3,14(a0)
 760:	01f506a3          	sb	t6,13(a0)
 764:	0007cf03          	lbu	t5,0(a5)
 768:	01078793          	addi	a5,a5,16
 76c:	01e64633          	xor	a2,a2,t5
 770:	0ff67a93          	zext.b	s5,a2
 774:	01550023          	sb	s5,0(a0)
 778:	ff17c603          	lbu	a2,-15(a5)
 77c:	00c6c6b3          	xor	a3,a3,a2
 780:	0ff6f693          	zext.b	a3,a3
 784:	00d500a3          	sb	a3,1(a0)
 788:	ff27c603          	lbu	a2,-14(a5)
 78c:	00c74733          	xor	a4,a4,a2
 790:	0ff77713          	zext.b	a4,a4
 794:	00e50123          	sb	a4,2(a0)
 798:	ff37c603          	lbu	a2,-13(a5)
 79c:	00c34333          	xor	t1,t1,a2
 7a0:	0ff37313          	zext.b	t1,t1
 7a4:	006501a3          	sb	t1,3(a0)
 7a8:	ff47c603          	lbu	a2,-12(a5)
 7ac:	00c3c2b3          	xor	t0,t2,a2
 7b0:	0ff2f293          	zext.b	t0,t0
 7b4:	00550223          	sb	t0,4(a0)
 7b8:	ff57c603          	lbu	a2,-11(a5)
 7bc:	00cbc633          	xor	a2,s7,a2
 7c0:	0ff67613          	zext.b	a2,a2
 7c4:	00c502a3          	sb	a2,5(a0)
 7c8:	ff67cf03          	lbu	t5,-10(a5)
 7cc:	01eb4f33          	xor	t5,s6,t5
 7d0:	0fff7f13          	zext.b	t5,t5
 7d4:	01e50323          	sb	t5,6(a0)
 7d8:	ff77c383          	lbu	t2,-9(a5)
 7dc:	0078c8b3          	xor	a7,a7,t2
 7e0:	0ff8f893          	zext.b	a7,a7
 7e4:	011503a3          	sb	a7,7(a0)
 7e8:	ff87c383          	lbu	t2,-8(a5)
 7ec:	0079c9b3          	xor	s3,s3,t2
 7f0:	0ff9f993          	zext.b	s3,s3
 7f4:	01350423          	sb	s3,8(a0)
 7f8:	ff97c383          	lbu	t2,-7(a5)
 7fc:	0074c3b3          	xor	t2,s1,t2
 800:	0ff3f393          	zext.b	t2,t2
 804:	007504a3          	sb	t2,9(a0)
 808:	ffa7c483          	lbu	s1,-6(a5)
 80c:	009eceb3          	xor	t4,t4,s1
 810:	0ffefe93          	zext.b	t4,t4
 814:	01d50523          	sb	t4,10(a0)
 818:	ffb7c483          	lbu	s1,-5(a5)
 81c:	00984833          	xor	a6,a6,s1
 820:	0ff87813          	zext.b	a6,a6
 824:	010505a3          	sb	a6,11(a0)
 828:	ffc7c483          	lbu	s1,-4(a5)
 82c:	009944b3          	xor	s1,s2,s1
 830:	0ff4f493          	zext.b	s1,s1
 834:	00950623          	sb	s1,12(a0)
 838:	ffd7c903          	lbu	s2,-3(a5)
 83c:	012fcfb3          	xor	t6,t6,s2
 840:	0fffff93          	zext.b	t6,t6
 844:	01f506a3          	sb	t6,13(a0)
 848:	ffe7c903          	lbu	s2,-2(a5)
 84c:	012e4e33          	xor	t3,t3,s2
 850:	0ffe7e13          	zext.b	t3,t3
 854:	01c50723          	sb	t3,14(a0)
 858:	fff7c903          	lbu	s2,-1(a5)
 85c:	012a4a33          	xor	s4,s4,s2
 860:	0ffa7a13          	zext.b	s4,s4
 864:	00d58bb3          	add	s7,a1,a3
 868:	01d58b33          	add	s6,a1,t4
 86c:	01f586b3          	add	a3,a1,t6
 870:	01558ab3          	add	s5,a1,s5
 874:	005582b3          	add	t0,a1,t0
 878:	013589b3          	add	s3,a1,s3
 87c:	009584b3          	add	s1,a1,s1
 880:	007583b3          	add	t2,a1,t2
 884:	00e58fb3          	add	t6,a1,a4
 888:	01c58e33          	add	t3,a1,t3
 88c:	01458c33          	add	s8,a1,s4
 890:	00c58633          	add	a2,a1,a2
 894:	01e58f33          	add	t5,a1,t5
 898:	00658333          	add	t1,a1,t1
 89c:	011588b3          	add	a7,a1,a7
 8a0:	01058833          	add	a6,a1,a6
 8a4:	000ac703          	lbu	a4,0(s5)
 8a8:	0002ce83          	lbu	t4,0(t0)
 8ac:	0009c903          	lbu	s2,0(s3)
 8b0:	0004ca03          	lbu	s4,0(s1)
 8b4:	000bca83          	lbu	s5,0(s7)
 8b8:	0003c483          	lbu	s1,0(t2)
 8bc:	0006c283          	lbu	t0,0(a3)
 8c0:	000e4b83          	lbu	s7,0(t3)
 8c4:	000b4683          	lbu	a3,0(s6) # 7000 <uart0>
 8c8:	00064983          	lbu	s3,0(a2)
 8cc:	000fcf83          	lbu	t6,0(t6)
 8d0:	000f4f03          	lbu	t5,0(t5)
 8d4:	00034b03          	lbu	s6,0(t1)
 8d8:	0008cc83          	lbu	s9,0(a7)
 8dc:	00084e03          	lbu	t3,0(a6)
 8e0:	000c4383          	lbu	t2,0(s8)
 8e4:	00e50023          	sb	a4,0(a0)
 8e8:	01d50223          	sb	t4,4(a0)
 8ec:	01250423          	sb	s2,8(a0)
 8f0:	01450623          	sb	s4,12(a0)
 8f4:	015506a3          	sb	s5,13(a0)
 8f8:	013500a3          	sb	s3,1(a0)
 8fc:	009502a3          	sb	s1,5(a0)
 900:	005504a3          	sb	t0,9(a0)
 904:	01f50523          	sb	t6,10(a0)
 908:	01e50723          	sb	t5,14(a0)
 90c:	00d50123          	sb	a3,2(a0)
 910:	01750323          	sb	s7,6(a0)
 914:	016503a3          	sb	s6,7(a0)
 918:	019505a3          	sb	s9,11(a0)
 91c:	01c507a3          	sb	t3,15(a0)
 920:	007501a3          	sb	t2,3(a0)
 924:	befd18e3          	bne	s10,a5,514 <Cipher+0xe8>
 928:	00450793          	addi	a5,a0,4
 92c:	0a440613          	addi	a2,s0,164
 930:	00fd37b3          	sltu	a5,s10,a5
 934:	00c53633          	sltu	a2,a0,a2
 938:	0017b793          	seqz	a5,a5
 93c:	00163613          	seqz	a2,a2
 940:	00c7e7b3          	or	a5,a5,a2
 944:	18078663          	beqz	a5,ad0 <Cipher+0x6a4>
 948:	00ad67b3          	or	a5,s10,a0
 94c:	0037f793          	andi	a5,a5,3
 950:	18079063          	bnez	a5,ad0 <Cipher+0x6a4>
 954:	0a042603          	lw	a2,160(s0)
 958:	00052783          	lw	a5,0(a0)
 95c:	00452683          	lw	a3,4(a0)
 960:	00852703          	lw	a4,8(a0)
 964:	00c7c7b3          	xor	a5,a5,a2
 968:	00f52023          	sw	a5,0(a0)
 96c:	0a442603          	lw	a2,164(s0)
 970:	00c52783          	lw	a5,12(a0)
 974:	00c6c6b3          	xor	a3,a3,a2
 978:	00d52223          	sw	a3,4(a0)
 97c:	0a842683          	lw	a3,168(s0)
 980:	00d74733          	xor	a4,a4,a3
 984:	00e52423          	sw	a4,8(a0)
 988:	0ac42703          	lw	a4,172(s0)
 98c:	00e7c7b3          	xor	a5,a5,a4
 990:	00f52623          	sw	a5,12(a0)
 994:	02c12403          	lw	s0,44(sp)
 998:	02812483          	lw	s1,40(sp)
 99c:	02412903          	lw	s2,36(sp)
 9a0:	02012983          	lw	s3,32(sp)
 9a4:	01c12a03          	lw	s4,28(sp)
 9a8:	01812a83          	lw	s5,24(sp)
 9ac:	01412b03          	lw	s6,20(sp)
 9b0:	01012b83          	lw	s7,16(sp)
 9b4:	00c12c03          	lw	s8,12(sp)
 9b8:	00812c83          	lw	s9,8(sp)
 9bc:	00412d03          	lw	s10,4(sp)
 9c0:	00012d83          	lw	s11,0(sp)
 9c4:	03010113          	addi	sp,sp,48
 9c8:	00008067          	ret
 9cc:	00044783          	lbu	a5,0(s0)
 9d0:	00054703          	lbu	a4,0(a0)
 9d4:	00154603          	lbu	a2,1(a0)
 9d8:	00254683          	lbu	a3,2(a0)
 9dc:	00e7c7b3          	xor	a5,a5,a4
 9e0:	00f50023          	sb	a5,0(a0)
 9e4:	00144783          	lbu	a5,1(s0)
 9e8:	00354703          	lbu	a4,3(a0)
 9ec:	00454303          	lbu	t1,4(a0)
 9f0:	00c7c7b3          	xor	a5,a5,a2
 9f4:	00f500a3          	sb	a5,1(a0)
 9f8:	00244783          	lbu	a5,2(s0)
 9fc:	00554883          	lbu	a7,5(a0)
 a00:	00654803          	lbu	a6,6(a0)
 a04:	00d7c7b3          	xor	a5,a5,a3
 a08:	00f50123          	sb	a5,2(a0)
 a0c:	00344783          	lbu	a5,3(s0)
 a10:	00754583          	lbu	a1,7(a0)
 a14:	00854603          	lbu	a2,8(a0)
 a18:	00e7c7b3          	xor	a5,a5,a4
 a1c:	00f501a3          	sb	a5,3(a0)
 a20:	00444783          	lbu	a5,4(s0)
 a24:	00954683          	lbu	a3,9(a0)
 a28:	00a54703          	lbu	a4,10(a0)
 a2c:	0067c7b3          	xor	a5,a5,t1
 a30:	00f50223          	sb	a5,4(a0)
 a34:	00544783          	lbu	a5,5(s0)
 a38:	0117c7b3          	xor	a5,a5,a7
 a3c:	00f502a3          	sb	a5,5(a0)
 a40:	00644783          	lbu	a5,6(s0)
 a44:	0107c7b3          	xor	a5,a5,a6
 a48:	00f50323          	sb	a5,6(a0)
 a4c:	00744783          	lbu	a5,7(s0)
 a50:	00b7c7b3          	xor	a5,a5,a1
 a54:	00f503a3          	sb	a5,7(a0)
 a58:	00844783          	lbu	a5,8(s0)
 a5c:	00c7c7b3          	xor	a5,a5,a2
 a60:	00f50423          	sb	a5,8(a0)
 a64:	00944783          	lbu	a5,9(s0)
 a68:	00d7c7b3          	xor	a5,a5,a3
 a6c:	00f504a3          	sb	a5,9(a0)
 a70:	00a44783          	lbu	a5,10(s0)
 a74:	00e7c7b3          	xor	a5,a5,a4
 a78:	00f50523          	sb	a5,10(a0)
 a7c:	00b44703          	lbu	a4,11(s0)
 a80:	00b54783          	lbu	a5,11(a0)
 a84:	00c54583          	lbu	a1,12(a0)
 a88:	00d54603          	lbu	a2,13(a0)
 a8c:	00e7c7b3          	xor	a5,a5,a4
 a90:	00f505a3          	sb	a5,11(a0)
 a94:	00c44783          	lbu	a5,12(s0)
 a98:	00e54683          	lbu	a3,14(a0)
 a9c:	00f54703          	lbu	a4,15(a0)
 aa0:	00b7c7b3          	xor	a5,a5,a1
 aa4:	00f50623          	sb	a5,12(a0)
 aa8:	00d44783          	lbu	a5,13(s0)
 aac:	00c7c7b3          	xor	a5,a5,a2
 ab0:	00f506a3          	sb	a5,13(a0)
 ab4:	00e44783          	lbu	a5,14(s0)
 ab8:	00d7c7b3          	xor	a5,a5,a3
 abc:	00f50723          	sb	a5,14(a0)
 ac0:	00f44783          	lbu	a5,15(s0)
 ac4:	00e7c7b3          	xor	a5,a5,a4
 ac8:	00f507a3          	sb	a5,15(a0)
 acc:	9f5ff06f          	j	4c0 <Cipher+0x94>
 ad0:	0a044783          	lbu	a5,160(s0)
 ad4:	00f74733          	xor	a4,a4,a5
 ad8:	00e50023          	sb	a4,0(a0)
 adc:	0a144783          	lbu	a5,161(s0)
 ae0:	00f9c9b3          	xor	s3,s3,a5
 ae4:	013500a3          	sb	s3,1(a0)
 ae8:	0a244783          	lbu	a5,162(s0)
 aec:	00f6c6b3          	xor	a3,a3,a5
 af0:	00d50123          	sb	a3,2(a0)
 af4:	0a344783          	lbu	a5,163(s0)
 af8:	00f3c3b3          	xor	t2,t2,a5
 afc:	007501a3          	sb	t2,3(a0)
 b00:	0a444783          	lbu	a5,164(s0)
 b04:	00feceb3          	xor	t4,t4,a5
 b08:	01d50223          	sb	t4,4(a0)
 b0c:	0a544783          	lbu	a5,165(s0)
 b10:	00f4c4b3          	xor	s1,s1,a5
 b14:	009502a3          	sb	s1,5(a0)
 b18:	0a644783          	lbu	a5,166(s0)
 b1c:	00fbcbb3          	xor	s7,s7,a5
 b20:	01750323          	sb	s7,6(a0)
 b24:	0a744783          	lbu	a5,167(s0)
 b28:	00fb4b33          	xor	s6,s6,a5
 b2c:	016503a3          	sb	s6,7(a0)
 b30:	0a844783          	lbu	a5,168(s0)
 b34:	00f94933          	xor	s2,s2,a5
 b38:	01250423          	sb	s2,8(a0)
 b3c:	0a944783          	lbu	a5,169(s0)
 b40:	00f2c2b3          	xor	t0,t0,a5
 b44:	005504a3          	sb	t0,9(a0)
 b48:	0aa44783          	lbu	a5,170(s0)
 b4c:	00ffcfb3          	xor	t6,t6,a5
 b50:	01f50523          	sb	t6,10(a0)
 b54:	0ab44783          	lbu	a5,171(s0)
 b58:	00fcccb3          	xor	s9,s9,a5
 b5c:	019505a3          	sb	s9,11(a0)
 b60:	0ac44783          	lbu	a5,172(s0)
 b64:	00fa4a33          	xor	s4,s4,a5
 b68:	01450623          	sb	s4,12(a0)
 b6c:	0ad44783          	lbu	a5,173(s0)
 b70:	00facab3          	xor	s5,s5,a5
 b74:	015506a3          	sb	s5,13(a0)
 b78:	0ae44783          	lbu	a5,174(s0)
 b7c:	00ff4f33          	xor	t5,t5,a5
 b80:	01e50723          	sb	t5,14(a0)
 b84:	0af44783          	lbu	a5,175(s0)
 b88:	00fe4e33          	xor	t3,t3,a5
 b8c:	01c507a3          	sb	t3,15(a0)
 b90:	e05ff06f          	j	994 <Cipher+0x568>

00000b94 <AES_init_ctx>:
 b94:	e0cff06f          	j	1a0 <KeyExpansion>

00000b98 <AES_ECB_encrypt>:
 b98:	00050793          	mv	a5,a0
 b9c:	00058513          	mv	a0,a1
 ba0:	00078593          	mv	a1,a5
 ba4:	889ff06f          	j	42c <Cipher>

00000ba8 <uart_init>:
 ba8:	100097b7          	lui	a5,0x10009
 bac:	00b52023          	sw	a1,0(a0)
 bb0:	00c78793          	addi	a5,a5,12 # 1000900c <__stack_top+0x10001010>
 bb4:	00300713          	li	a4,3
 bb8:	00e7a023          	sw	a4,0(a5)
 bbc:	00000013          	nop
 bc0:	00000013          	nop
 bc4:	0007a703          	lw	a4,0(a5)
 bc8:	01076713          	ori	a4,a4,16
 bcc:	00e7a023          	sw	a4,0(a5)
 bd0:	00008067          	ret

00000bd4 <uart_transmit_string>:
 bd4:	02060e63          	beqz	a2,c10 <uart_transmit_string+0x3c>
 bd8:	10009737          	lui	a4,0x10009
 bdc:	10009537          	lui	a0,0x10009
 be0:	00c58633          	add	a2,a1,a2
 be4:	00870713          	addi	a4,a4,8 # 10009008 <__stack_top+0x1000100c>
 be8:	00450513          	addi	a0,a0,4 # 10009004 <__stack_top+0x10001008>
 bec:	00000013          	nop
 bf0:	00000013          	nop
 bf4:	0005c683          	lbu	a3,0(a1)
 bf8:	00072783          	lw	a5,0(a4)
 bfc:	0087f793          	andi	a5,a5,8
 c00:	fe079ce3          	bnez	a5,bf8 <uart_transmit_string+0x24>
 c04:	00d52023          	sw	a3,0(a0)
 c08:	00158593          	addi	a1,a1,1
 c0c:	fec590e3          	bne	a1,a2,bec <uart_transmit_string+0x18>
 c10:	00008067          	ret

00000c14 <exc>:
 c14:	cb8ff06f          	j	cc <exc_handler>

00000c18 <ssi>:
 c18:	00000013          	nop

00000c1c <hsi>:
 c1c:	00000013          	nop

00000c20 <msi>:
 c20:	cb4ff06f          	j	d4 <msi_handler>

00000c24 <uti>:
 c24:	00000013          	nop

00000c28 <sti>:
 c28:	00000013          	nop

00000c2c <hti>:
 c2c:	00000013          	nop

00000c30 <mti>:
 c30:	c98ff06f          	j	c8 <mti_handler>

00000c34 <uei>:
 c34:	00000013          	nop

00000c38 <sei>:
 c38:	00000013          	nop

00000c3c <hei>:
 c3c:	00000013          	nop

00000c40 <mei>:
 c40:	c90ff06f          	j	d0 <mei_handler>
 c44:	00000013          	nop
 c48:	00000013          	nop
 c4c:	00000013          	nop
 c50:	00000013          	nop

00000c54 <fast_irq0>:
 c54:	c84ff06f          	j	d8 <fast_irq0_handler>

00000c58 <fast_irq1>:
 c58:	d44ff06f          	j	19c <fast_irq1_handler>

00000c5c <SET_MTVEC_VECTOR_MODE>:
 c5c:	00000797          	auipc	a5,0x0
 c60:	fb878793          	addi	a5,a5,-72 # c14 <exc>
 c64:	0017e793          	ori	a5,a5,1
 c68:	30579073          	csrw	mtvec,a5
 c6c:	00008067          	ret
