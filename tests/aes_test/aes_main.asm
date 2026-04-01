
aes_main.elf:     file format elf32-littleriscv


Disassembly of section .init:

00000000 <_start>:
   0:	00008117          	auipc	sp,0x8
   4:	ffc10113          	addi	sp,sp,-4 # 7ffc <__stack_top>
   8:	00010433          	add	s0,sp,zero
   c:	0040006f          	j	10 <main>

Disassembly of section .text:

00000010 <main>:
  10:	f2010113          	addi	sp,sp,-224
  14:	0c112e23          	sw	ra,220(sp)
  18:	0c812c23          	sw	s0,216(sp)
  1c:	0c912a23          	sw	s1,212(sp)
  20:	0d212823          	sw	s2,208(sp)
  24:	0d312623          	sw	s3,204(sp)
  28:	0d412423          	sw	s4,200(sp)
  2c:	0d512223          	sw	s5,196(sp)
  30:	0d612023          	sw	s6,192(sp)
  34:	371000ef          	jal	ba4 <SET_MTVEC_VECTOR_MODE>
  38:	30046073          	csrsi	mstatus,8
  3c:	000107b7          	lui	a5,0x10
  40:	3047a073          	csrs	mie,a5
  44:	00007a37          	lui	s4,0x7
  48:	000a0513          	mv	a0,s4
  4c:	00007437          	lui	s0,0x7
  50:	100095b7          	lui	a1,0x10009
  54:	00007ab7          	lui	s5,0x7
  58:	000079b7          	lui	s3,0x7
  5c:	10008937          	lui	s2,0x10008
  60:	00042223          	sw	zero,4(s0) # 7004 <count>
  64:	000a0a13          	mv	s4,s4
  68:	289000ef          	jal	af0 <uart_init>
  6c:	008a8a93          	addi	s5,s5,8 # 7008 <key>
  70:	01898993          	addi	s3,s3,24 # 7018 <input_array>
  74:	02090913          	addi	s2,s2,32 # 10008020 <__stack_top+0x10000024>
  78:	01f00493          	li	s1,31
  7c:	00100b13          	li	s6,1
  80:	00442783          	lw	a5,4(s0)
  84:	fef4dee3          	bge	s1,a5,80 <main+0x70>
  88:	000a8593          	mv	a1,s5
  8c:	00010513          	mv	a0,sp
  90:	24d000ef          	jal	adc <AES_init_ctx>
  94:	00098593          	mv	a1,s3
  98:	01690023          	sb	s6,0(s2)
  9c:	00010513          	mv	a0,sp
  a0:	00042223          	sw	zero,4(s0)
  a4:	23d000ef          	jal	ae0 <AES_ECB_encrypt>
  a8:	00098593          	mv	a1,s3
  ac:	00090023          	sb	zero,0(s2)
  b0:	000a0513          	mv	a0,s4
  b4:	01000613          	li	a2,16
  b8:	265000ef          	jal	b1c <uart_transmit_string>
  bc:	30046073          	csrsi	mstatus,8
  c0:	000107b7          	lui	a5,0x10
  c4:	3047a073          	csrs	mie,a5
  c8:	00042223          	sw	zero,4(s0)
  cc:	fb5ff06f          	j	80 <main+0x70>

000000d0 <mti_handler>:
  d0:	30200073          	mret

000000d4 <exc_handler>:
  d4:	30200073          	mret

000000d8 <mei_handler>:
  d8:	30200073          	mret

000000dc <msi_handler>:
  dc:	30200073          	mret

000000e0 <fast_irq0_handler>:
  e0:	30200073          	mret

000000e4 <fast_irq1_handler>:
  e4:	30200073          	mret

000000e8 <KeyExpansion>:
  e8:	00350793          	addi	a5,a0,3
  ec:	fc010113          	addi	sp,sp,-64
  f0:	40b787b3          	sub	a5,a5,a1
  f4:	02812e23          	sw	s0,60(sp)
  f8:	02912c23          	sw	s1,56(sp)
  fc:	03212a23          	sw	s2,52(sp)
 100:	03312823          	sw	s3,48(sp)
 104:	03412623          	sw	s4,44(sp)
 108:	03512423          	sw	s5,40(sp)
 10c:	03612223          	sw	s6,36(sp)
 110:	03712023          	sw	s7,32(sp)
 114:	01812e23          	sw	s8,28(sp)
 118:	01912c23          	sw	s9,24(sp)
 11c:	01a12a23          	sw	s10,20(sp)
 120:	01b12823          	sw	s11,16(sp)
 124:	0077b793          	sltiu	a5,a5,7
 128:	1c079463          	bnez	a5,2f0 <KeyExpansion+0x208>
 12c:	00b567b3          	or	a5,a0,a1
 130:	0037f793          	andi	a5,a5,3
 134:	1a079e63          	bnez	a5,2f0 <KeyExpansion+0x208>
 138:	0005a783          	lw	a5,0(a1) # 10009000 <__stack_top+0x10001004>
 13c:	00f52023          	sw	a5,0(a0)
 140:	0045a783          	lw	a5,4(a1)
 144:	00f52223          	sw	a5,4(a0)
 148:	0085a783          	lw	a5,8(a1)
 14c:	00f52423          	sw	a5,8(a0)
 150:	00c5a783          	lw	a5,12(a1)
 154:	00f52623          	sw	a5,12(a0)
 158:	000017b7          	lui	a5,0x1
 15c:	00001eb7          	lui	t4,0x1
 160:	bb878793          	addi	a5,a5,-1096 # bb8 <Rcon>
 164:	00354603          	lbu	a2,3(a0)
 168:	00754b83          	lbu	s7,7(a0)
 16c:	00b54b03          	lbu	s6,11(a0)
 170:	00f54383          	lbu	t2,15(a0)
 174:	00254803          	lbu	a6,2(a0)
 178:	00654a83          	lbu	s5,6(a0)
 17c:	00a54a03          	lbu	s4,10(a0)
 180:	00e54283          	lbu	t0,14(a0)
 184:	00154883          	lbu	a7,1(a0)
 188:	00554983          	lbu	s3,5(a0)
 18c:	00954903          	lbu	s2,9(a0)
 190:	00d54f83          	lbu	t6,13(a0)
 194:	00054703          	lbu	a4,0(a0)
 198:	00454c83          	lbu	s9,4(a0)
 19c:	00854c03          	lbu	s8,8(a0)
 1a0:	00c54f03          	lbu	t5,12(a0)
 1a4:	bc4e8e93          	addi	t4,t4,-1084 # bc4 <sbox>
 1a8:	00f12423          	sw	a5,8(sp)
 1ac:	01050313          	addi	t1,a0,16
 1b0:	00400e13          	li	t3,4
 1b4:	09c0006f          	j	250 <KeyExpansion+0x168>
 1b8:	007e86b3          	add	a3,t4,t2
 1bc:	00044783          	lbu	a5,0(s0)
 1c0:	0006c583          	lbu	a1,0(a3)
 1c4:	000dc403          	lbu	s0,0(s11)
 1c8:	01ee86b3          	add	a3,t4,t5
 1cc:	000d4503          	lbu	a0,0(s10)
 1d0:	0006c683          	lbu	a3,0(a3)
 1d4:	0087c7b3          	xor	a5,a5,s0
 1d8:	00f747b3          	xor	a5,a4,a5
 1dc:	01154533          	xor	a0,a0,a7
 1e0:	00b845b3          	xor	a1,a6,a1
 1e4:	00c6c6b3          	xor	a3,a3,a2
 1e8:	0ff7f793          	zext.b	a5,a5
 1ec:	0ff57513          	zext.b	a0,a0
 1f0:	0ff5f593          	zext.b	a1,a1
 1f4:	0ff6f693          	zext.b	a3,a3
 1f8:	00f30023          	sb	a5,0(t1)
 1fc:	00a300a3          	sb	a0,1(t1)
 200:	00b30123          	sb	a1,2(t1)
 204:	00d301a3          	sb	a3,3(t1)
 208:	001e0e13          	addi	t3,t3,1
 20c:	00430313          	addi	t1,t1,4
 210:	000c8713          	mv	a4,s9
 214:	00098893          	mv	a7,s3
 218:	000a8813          	mv	a6,s5
 21c:	000b8613          	mv	a2,s7
 220:	000c0c93          	mv	s9,s8
 224:	00090993          	mv	s3,s2
 228:	000a0a93          	mv	s5,s4
 22c:	000b0b93          	mv	s7,s6
 230:	000f0c13          	mv	s8,t5
 234:	000f8913          	mv	s2,t6
 238:	00028a13          	mv	s4,t0
 23c:	00038b13          	mv	s6,t2
 240:	00078f13          	mv	t5,a5
 244:	00050f93          	mv	t6,a0
 248:	00058293          	mv	t0,a1
 24c:	00068393          	mv	t2,a3
 250:	00812783          	lw	a5,8(sp)
 254:	002e5413          	srli	s0,t3,0x2
 258:	011fc533          	xor	a0,t6,a7
 25c:	00878433          	add	s0,a5,s0
 260:	01ee87b3          	add	a5,t4,t5
 264:	00f12623          	sw	a5,12(sp)
 268:	005845b3          	xor	a1,a6,t0
 26c:	00ef47b3          	xor	a5,t5,a4
 270:	00c3c6b3          	xor	a3,t2,a2
 274:	003e7493          	andi	s1,t3,3
 278:	01fe8db3          	add	s11,t4,t6
 27c:	005e8d33          	add	s10,t4,t0
 280:	0ff7f793          	zext.b	a5,a5
 284:	0ff57513          	zext.b	a0,a0
 288:	0ff5f593          	zext.b	a1,a1
 28c:	0ff6f693          	zext.b	a3,a3
 290:	f20484e3          	beqz	s1,1b8 <KeyExpansion+0xd0>
 294:	00f30023          	sb	a5,0(t1)
 298:	00a300a3          	sb	a0,1(t1)
 29c:	00b30123          	sb	a1,2(t1)
 2a0:	00d301a3          	sb	a3,3(t1)
 2a4:	001e0e13          	addi	t3,t3,1
 2a8:	02c00713          	li	a4,44
 2ac:	00ee0663          	beq	t3,a4,2b8 <KeyExpansion+0x1d0>
 2b0:	00430313          	addi	t1,t1,4
 2b4:	f5dff06f          	j	210 <KeyExpansion+0x128>
 2b8:	03c12403          	lw	s0,60(sp)
 2bc:	03812483          	lw	s1,56(sp)
 2c0:	03412903          	lw	s2,52(sp)
 2c4:	03012983          	lw	s3,48(sp)
 2c8:	02c12a03          	lw	s4,44(sp)
 2cc:	02812a83          	lw	s5,40(sp)
 2d0:	02412b03          	lw	s6,36(sp)
 2d4:	02012b83          	lw	s7,32(sp)
 2d8:	01c12c03          	lw	s8,28(sp)
 2dc:	01812c83          	lw	s9,24(sp)
 2e0:	01412d03          	lw	s10,20(sp)
 2e4:	01012d83          	lw	s11,16(sp)
 2e8:	04010113          	addi	sp,sp,64
 2ec:	00008067          	ret
 2f0:	0005c783          	lbu	a5,0(a1)
 2f4:	00f50023          	sb	a5,0(a0)
 2f8:	0015c783          	lbu	a5,1(a1)
 2fc:	00f500a3          	sb	a5,1(a0)
 300:	0025c783          	lbu	a5,2(a1)
 304:	00f50123          	sb	a5,2(a0)
 308:	0035c783          	lbu	a5,3(a1)
 30c:	00f501a3          	sb	a5,3(a0)
 310:	0045c783          	lbu	a5,4(a1)
 314:	00f50223          	sb	a5,4(a0)
 318:	0055c783          	lbu	a5,5(a1)
 31c:	00f502a3          	sb	a5,5(a0)
 320:	0065c783          	lbu	a5,6(a1)
 324:	00f50323          	sb	a5,6(a0)
 328:	0075c783          	lbu	a5,7(a1)
 32c:	00f503a3          	sb	a5,7(a0)
 330:	0085c783          	lbu	a5,8(a1)
 334:	00f50423          	sb	a5,8(a0)
 338:	0095c783          	lbu	a5,9(a1)
 33c:	00f504a3          	sb	a5,9(a0)
 340:	00a5c783          	lbu	a5,10(a1)
 344:	00f50523          	sb	a5,10(a0)
 348:	00b5c783          	lbu	a5,11(a1)
 34c:	00f505a3          	sb	a5,11(a0)
 350:	00c5c783          	lbu	a5,12(a1)
 354:	00f50623          	sb	a5,12(a0)
 358:	00d5c783          	lbu	a5,13(a1)
 35c:	00f506a3          	sb	a5,13(a0)
 360:	00e5c783          	lbu	a5,14(a1)
 364:	00f50723          	sb	a5,14(a0)
 368:	00f5c783          	lbu	a5,15(a1)
 36c:	00f507a3          	sb	a5,15(a0)
 370:	de9ff06f          	j	158 <KeyExpansion+0x70>

00000374 <Cipher>:
 374:	00350793          	addi	a5,a0,3
 378:	fd010113          	addi	sp,sp,-48
 37c:	40b787b3          	sub	a5,a5,a1
 380:	02812623          	sw	s0,44(sp)
 384:	02912423          	sw	s1,40(sp)
 388:	03212223          	sw	s2,36(sp)
 38c:	03312023          	sw	s3,32(sp)
 390:	01412e23          	sw	s4,28(sp)
 394:	01512c23          	sw	s5,24(sp)
 398:	01612a23          	sw	s6,20(sp)
 39c:	01712823          	sw	s7,16(sp)
 3a0:	01812623          	sw	s8,12(sp)
 3a4:	01912423          	sw	s9,8(sp)
 3a8:	01a12223          	sw	s10,4(sp)
 3ac:	01b12023          	sw	s11,0(sp)
 3b0:	0077b793          	sltiu	a5,a5,7
 3b4:	00058413          	mv	s0,a1
 3b8:	54079e63          	bnez	a5,914 <Cipher+0x5a0>
 3bc:	00a5e7b3          	or	a5,a1,a0
 3c0:	0037f793          	andi	a5,a5,3
 3c4:	54079863          	bnez	a5,914 <Cipher+0x5a0>
 3c8:	0005a603          	lw	a2,0(a1)
 3cc:	00052783          	lw	a5,0(a0)
 3d0:	00452683          	lw	a3,4(a0)
 3d4:	00852703          	lw	a4,8(a0)
 3d8:	00c7c7b3          	xor	a5,a5,a2
 3dc:	00f52023          	sw	a5,0(a0)
 3e0:	0045a603          	lw	a2,4(a1)
 3e4:	00c52783          	lw	a5,12(a0)
 3e8:	00c6c6b3          	xor	a3,a3,a2
 3ec:	00d52223          	sw	a3,4(a0)
 3f0:	0085a683          	lw	a3,8(a1)
 3f4:	00d74733          	xor	a4,a4,a3
 3f8:	00e52423          	sw	a4,8(a0)
 3fc:	00c5a703          	lw	a4,12(a1)
 400:	00e7c7b3          	xor	a5,a5,a4
 404:	00f52623          	sw	a5,12(a0)
 408:	000015b7          	lui	a1,0x1
 40c:	00054a83          	lbu	s5,0(a0)
 410:	00454283          	lbu	t0,4(a0)
 414:	00854983          	lbu	s3,8(a0)
 418:	00c54483          	lbu	s1,12(a0)
 41c:	00154683          	lbu	a3,1(a0)
 420:	00554603          	lbu	a2,5(a0)
 424:	00954383          	lbu	t2,9(a0)
 428:	00d54f83          	lbu	t6,13(a0)
 42c:	00254703          	lbu	a4,2(a0)
 430:	00654f03          	lbu	t5,6(a0)
 434:	00a54e83          	lbu	t4,10(a0)
 438:	00e54e03          	lbu	t3,14(a0)
 43c:	00354303          	lbu	t1,3(a0)
 440:	00754883          	lbu	a7,7(a0)
 444:	00b54803          	lbu	a6,11(a0)
 448:	00f54a03          	lbu	s4,15(a0)
 44c:	bc458593          	addi	a1,a1,-1084 # bc4 <sbox>
 450:	01040793          	addi	a5,s0,16
 454:	0a040d13          	addi	s10,s0,160
 458:	3540006f          	j	7ac <Cipher+0x438>
 45c:	01374833          	xor	a6,a4,s3
 460:	00785613          	srli	a2,a6,0x7
 464:	0076c8b3          	xor	a7,a3,t2
 468:	40c00633          	neg	a2,a2
 46c:	00181313          	slli	t1,a6,0x1
 470:	01b67613          	andi	a2,a2,27
 474:	0108c833          	xor	a6,a7,a6
 478:	00664633          	xor	a2,a2,t1
 47c:	00e84333          	xor	t1,a6,a4
 480:	00774733          	xor	a4,a4,t2
 484:	00664633          	xor	a2,a2,t1
 488:	00775313          	srli	t1,a4,0x7
 48c:	40600333          	neg	t1,t1
 490:	00171713          	slli	a4,a4,0x1
 494:	01b37313          	andi	t1,t1,27
 498:	00e34333          	xor	t1,t1,a4
 49c:	0078d713          	srli	a4,a7,0x7
 4a0:	40e00733          	neg	a4,a4
 4a4:	007843b3          	xor	t2,a6,t2
 4a8:	00189893          	slli	a7,a7,0x1
 4ac:	01b77713          	andi	a4,a4,27
 4b0:	00734333          	xor	t1,t1,t2
 4b4:	01174733          	xor	a4,a4,a7
 4b8:	00d9c3b3          	xor	t2,s3,a3
 4bc:	00d846b3          	xor	a3,a6,a3
 4c0:	00d74733          	xor	a4,a4,a3
 4c4:	0073d693          	srli	a3,t2,0x7
 4c8:	40d006b3          	neg	a3,a3
 4cc:	009ec8b3          	xor	a7,t4,s1
 4d0:	00139393          	slli	t2,t2,0x1
 4d4:	01b6f693          	andi	a3,a3,27
 4d8:	0076c6b3          	xor	a3,a3,t2
 4dc:	0078d393          	srli	t2,a7,0x7
 4e0:	016bcc33          	xor	s8,s7,s6
 4e4:	01384833          	xor	a6,a6,s3
 4e8:	407003b3          	neg	t2,t2
 4ec:	0106c6b3          	xor	a3,a3,a6
 4f0:	00189993          	slli	s3,a7,0x1
 4f4:	0188c833          	xor	a6,a7,s8
 4f8:	01b3f393          	andi	t2,t2,27
 4fc:	01d848b3          	xor	a7,a6,t4
 500:	0133c3b3          	xor	t2,t2,s3
 504:	016eceb3          	xor	t4,t4,s6
 508:	0113c3b3          	xor	t2,t2,a7
 50c:	007ed893          	srli	a7,t4,0x7
 510:	411008b3          	neg	a7,a7
 514:	001e9e93          	slli	t4,t4,0x1
 518:	01b8f893          	andi	a7,a7,27
 51c:	01684b33          	xor	s6,a6,s6
 520:	01d8c8b3          	xor	a7,a7,t4
 524:	0168c8b3          	xor	a7,a7,s6
 528:	007c5b13          	srli	s6,s8,0x7
 52c:	41600b33          	neg	s6,s6
 530:	001c1c13          	slli	s8,s8,0x1
 534:	01bb7b13          	andi	s6,s6,27
 538:	0174c9b3          	xor	s3,s1,s7
 53c:	018b4b33          	xor	s6,s6,s8
 540:	01784bb3          	xor	s7,a6,s7
 544:	017b4b33          	xor	s6,s6,s7
 548:	0079db93          	srli	s7,s3,0x7
 54c:	41700bb3          	neg	s7,s7
 550:	00594eb3          	xor	t4,s2,t0
 554:	00199993          	slli	s3,s3,0x1
 558:	01bbfb93          	andi	s7,s7,27
 55c:	013bcbb3          	xor	s7,s7,s3
 560:	007ed993          	srli	s3,t4,0x7
 564:	019fcc33          	xor	s8,t6,s9
 568:	00984833          	xor	a6,a6,s1
 56c:	413009b3          	neg	s3,s3
 570:	01dc44b3          	xor	s1,s8,t4
 574:	010bcbb3          	xor	s7,s7,a6
 578:	01b9f993          	andi	s3,s3,27
 57c:	001e9813          	slli	a6,t4,0x1
 580:	0109c9b3          	xor	s3,s3,a6
 584:	0124c833          	xor	a6,s1,s2
 588:	01994933          	xor	s2,s2,s9
 58c:	0109c9b3          	xor	s3,s3,a6
 590:	00795813          	srli	a6,s2,0x7
 594:	41000833          	neg	a6,a6
 598:	00191913          	slli	s2,s2,0x1
 59c:	01b87813          	andi	a6,a6,27
 5a0:	01284833          	xor	a6,a6,s2
 5a4:	01f2c933          	xor	s2,t0,t6
 5a8:	0194ccb3          	xor	s9,s1,s9
 5ac:	01f4cfb3          	xor	t6,s1,t6
 5b0:	0054c2b3          	xor	t0,s1,t0
 5b4:	00795493          	srli	s1,s2,0x7
 5b8:	409004b3          	neg	s1,s1
 5bc:	01984833          	xor	a6,a6,s9
 5c0:	007c5e93          	srli	t4,s8,0x7
 5c4:	015a4cb3          	xor	s9,s4,s5
 5c8:	00191913          	slli	s2,s2,0x1
 5cc:	01b4f493          	andi	s1,s1,27
 5d0:	0124c4b3          	xor	s1,s1,s2
 5d4:	41d00eb3          	neg	t4,t4
 5d8:	007cd913          	srli	s2,s9,0x7
 5dc:	001c1c13          	slli	s8,s8,0x1
 5e0:	01befe93          	andi	t4,t4,27
 5e4:	41200933          	neg	s2,s2
 5e8:	0054c4b3          	xor	s1,s1,t0
 5ec:	018eceb3          	xor	t4,t4,s8
 5f0:	001c9293          	slli	t0,s9,0x1
 5f4:	01cf4c33          	xor	s8,t5,t3
 5f8:	01b97913          	andi	s2,s2,27
 5fc:	01feceb3          	xor	t4,t4,t6
 600:	00594933          	xor	s2,s2,t0
 604:	019c4fb3          	xor	t6,s8,s9
 608:	01ca42b3          	xor	t0,s4,t3
 60c:	014fcdb3          	xor	s11,t6,s4
 610:	0072da13          	srli	s4,t0,0x7
 614:	41400a33          	neg	s4,s4
 618:	00129293          	slli	t0,t0,0x1
 61c:	01ba7a13          	andi	s4,s4,27
 620:	005a4a33          	xor	s4,s4,t0
 624:	01eac2b3          	xor	t0,s5,t5
 628:	01cfccb3          	xor	s9,t6,t3
 62c:	01efcf33          	xor	t5,t6,t5
 630:	015fcab3          	xor	s5,t6,s5
 634:	007c5e13          	srli	t3,s8,0x7
 638:	0072df93          	srli	t6,t0,0x7
 63c:	41c00e33          	neg	t3,t3
 640:	41f00fb3          	neg	t6,t6
 644:	00129293          	slli	t0,t0,0x1
 648:	01be7e13          	andi	t3,t3,27
 64c:	001c1c13          	slli	s8,s8,0x1
 650:	01bfff93          	andi	t6,t6,27
 654:	005fcfb3          	xor	t6,t6,t0
 658:	018e4e33          	xor	t3,t3,s8
 65c:	01b94933          	xor	s2,s2,s11
 660:	01ee4e33          	xor	t3,t3,t5
 664:	015fcfb3          	xor	t6,t6,s5
 668:	019a4a33          	xor	s4,s4,s9
 66c:	00c50023          	sb	a2,0(a0)
 670:	006501a3          	sb	t1,3(a0)
 674:	00e50123          	sb	a4,2(a0)
 678:	00d500a3          	sb	a3,1(a0)
 67c:	011503a3          	sb	a7,7(a0)
 680:	00750223          	sb	t2,4(a0)
 684:	01650323          	sb	s6,6(a0)
 688:	017502a3          	sb	s7,5(a0)
 68c:	01350423          	sb	s3,8(a0)
 690:	010505a3          	sb	a6,11(a0)
 694:	01d50523          	sb	t4,10(a0)
 698:	009504a3          	sb	s1,9(a0)
 69c:	01250623          	sb	s2,12(a0)
 6a0:	014507a3          	sb	s4,15(a0)
 6a4:	01c50723          	sb	t3,14(a0)
 6a8:	01f506a3          	sb	t6,13(a0)
 6ac:	0007cf03          	lbu	t5,0(a5)
 6b0:	01078793          	addi	a5,a5,16
 6b4:	01e64633          	xor	a2,a2,t5
 6b8:	0ff67a93          	zext.b	s5,a2
 6bc:	01550023          	sb	s5,0(a0)
 6c0:	ff17c603          	lbu	a2,-15(a5)
 6c4:	00c6c6b3          	xor	a3,a3,a2
 6c8:	0ff6f693          	zext.b	a3,a3
 6cc:	00d500a3          	sb	a3,1(a0)
 6d0:	ff27c603          	lbu	a2,-14(a5)
 6d4:	00c74733          	xor	a4,a4,a2
 6d8:	0ff77713          	zext.b	a4,a4
 6dc:	00e50123          	sb	a4,2(a0)
 6e0:	ff37c603          	lbu	a2,-13(a5)
 6e4:	00c34333          	xor	t1,t1,a2
 6e8:	0ff37313          	zext.b	t1,t1
 6ec:	006501a3          	sb	t1,3(a0)
 6f0:	ff47c603          	lbu	a2,-12(a5)
 6f4:	00c3c2b3          	xor	t0,t2,a2
 6f8:	0ff2f293          	zext.b	t0,t0
 6fc:	00550223          	sb	t0,4(a0)
 700:	ff57c603          	lbu	a2,-11(a5)
 704:	00cbc633          	xor	a2,s7,a2
 708:	0ff67613          	zext.b	a2,a2
 70c:	00c502a3          	sb	a2,5(a0)
 710:	ff67cf03          	lbu	t5,-10(a5)
 714:	01eb4f33          	xor	t5,s6,t5
 718:	0fff7f13          	zext.b	t5,t5
 71c:	01e50323          	sb	t5,6(a0)
 720:	ff77c383          	lbu	t2,-9(a5)
 724:	0078c8b3          	xor	a7,a7,t2
 728:	0ff8f893          	zext.b	a7,a7
 72c:	011503a3          	sb	a7,7(a0)
 730:	ff87c383          	lbu	t2,-8(a5)
 734:	0079c9b3          	xor	s3,s3,t2
 738:	0ff9f993          	zext.b	s3,s3
 73c:	01350423          	sb	s3,8(a0)
 740:	ff97c383          	lbu	t2,-7(a5)
 744:	0074c3b3          	xor	t2,s1,t2
 748:	0ff3f393          	zext.b	t2,t2
 74c:	007504a3          	sb	t2,9(a0)
 750:	ffa7c483          	lbu	s1,-6(a5)
 754:	009eceb3          	xor	t4,t4,s1
 758:	0ffefe93          	zext.b	t4,t4
 75c:	01d50523          	sb	t4,10(a0)
 760:	ffb7c483          	lbu	s1,-5(a5)
 764:	00984833          	xor	a6,a6,s1
 768:	0ff87813          	zext.b	a6,a6
 76c:	010505a3          	sb	a6,11(a0)
 770:	ffc7c483          	lbu	s1,-4(a5)
 774:	009944b3          	xor	s1,s2,s1
 778:	0ff4f493          	zext.b	s1,s1
 77c:	00950623          	sb	s1,12(a0)
 780:	ffd7c903          	lbu	s2,-3(a5)
 784:	012fcfb3          	xor	t6,t6,s2
 788:	0fffff93          	zext.b	t6,t6
 78c:	01f506a3          	sb	t6,13(a0)
 790:	ffe7c903          	lbu	s2,-2(a5)
 794:	012e4e33          	xor	t3,t3,s2
 798:	0ffe7e13          	zext.b	t3,t3
 79c:	01c50723          	sb	t3,14(a0)
 7a0:	fff7c903          	lbu	s2,-1(a5)
 7a4:	012a4a33          	xor	s4,s4,s2
 7a8:	0ffa7a13          	zext.b	s4,s4
 7ac:	00d58bb3          	add	s7,a1,a3
 7b0:	01d58b33          	add	s6,a1,t4
 7b4:	01f586b3          	add	a3,a1,t6
 7b8:	01558ab3          	add	s5,a1,s5
 7bc:	005582b3          	add	t0,a1,t0
 7c0:	013589b3          	add	s3,a1,s3
 7c4:	009584b3          	add	s1,a1,s1
 7c8:	007583b3          	add	t2,a1,t2
 7cc:	00e58fb3          	add	t6,a1,a4
 7d0:	01c58e33          	add	t3,a1,t3
 7d4:	01458c33          	add	s8,a1,s4
 7d8:	00c58633          	add	a2,a1,a2
 7dc:	01e58f33          	add	t5,a1,t5
 7e0:	00658333          	add	t1,a1,t1
 7e4:	011588b3          	add	a7,a1,a7
 7e8:	01058833          	add	a6,a1,a6
 7ec:	000ac703          	lbu	a4,0(s5)
 7f0:	0002ce83          	lbu	t4,0(t0)
 7f4:	0009c903          	lbu	s2,0(s3)
 7f8:	0004ca03          	lbu	s4,0(s1)
 7fc:	000bca83          	lbu	s5,0(s7)
 800:	0003c483          	lbu	s1,0(t2)
 804:	0006c283          	lbu	t0,0(a3)
 808:	000e4b83          	lbu	s7,0(t3)
 80c:	000b4683          	lbu	a3,0(s6)
 810:	00064983          	lbu	s3,0(a2)
 814:	000fcf83          	lbu	t6,0(t6)
 818:	000f4f03          	lbu	t5,0(t5)
 81c:	00034b03          	lbu	s6,0(t1)
 820:	0008cc83          	lbu	s9,0(a7)
 824:	00084e03          	lbu	t3,0(a6)
 828:	000c4383          	lbu	t2,0(s8)
 82c:	00e50023          	sb	a4,0(a0)
 830:	01d50223          	sb	t4,4(a0)
 834:	01250423          	sb	s2,8(a0)
 838:	01450623          	sb	s4,12(a0)
 83c:	015506a3          	sb	s5,13(a0)
 840:	013500a3          	sb	s3,1(a0)
 844:	009502a3          	sb	s1,5(a0)
 848:	005504a3          	sb	t0,9(a0)
 84c:	01f50523          	sb	t6,10(a0)
 850:	01e50723          	sb	t5,14(a0)
 854:	00d50123          	sb	a3,2(a0)
 858:	01750323          	sb	s7,6(a0)
 85c:	016503a3          	sb	s6,7(a0)
 860:	019505a3          	sb	s9,11(a0)
 864:	01c507a3          	sb	t3,15(a0)
 868:	007501a3          	sb	t2,3(a0)
 86c:	befd18e3          	bne	s10,a5,45c <Cipher+0xe8>
 870:	00450793          	addi	a5,a0,4
 874:	0a440613          	addi	a2,s0,164
 878:	00fd37b3          	sltu	a5,s10,a5
 87c:	00c53633          	sltu	a2,a0,a2
 880:	0017b793          	seqz	a5,a5
 884:	00163613          	seqz	a2,a2
 888:	00c7e7b3          	or	a5,a5,a2
 88c:	18078663          	beqz	a5,a18 <Cipher+0x6a4>
 890:	00ad67b3          	or	a5,s10,a0
 894:	0037f793          	andi	a5,a5,3
 898:	18079063          	bnez	a5,a18 <Cipher+0x6a4>
 89c:	0a042603          	lw	a2,160(s0)
 8a0:	00052783          	lw	a5,0(a0)
 8a4:	00452683          	lw	a3,4(a0)
 8a8:	00852703          	lw	a4,8(a0)
 8ac:	00c7c7b3          	xor	a5,a5,a2
 8b0:	00f52023          	sw	a5,0(a0)
 8b4:	0a442603          	lw	a2,164(s0)
 8b8:	00c52783          	lw	a5,12(a0)
 8bc:	00c6c6b3          	xor	a3,a3,a2
 8c0:	00d52223          	sw	a3,4(a0)
 8c4:	0a842683          	lw	a3,168(s0)
 8c8:	00d74733          	xor	a4,a4,a3
 8cc:	00e52423          	sw	a4,8(a0)
 8d0:	0ac42703          	lw	a4,172(s0)
 8d4:	00e7c7b3          	xor	a5,a5,a4
 8d8:	00f52623          	sw	a5,12(a0)
 8dc:	02c12403          	lw	s0,44(sp)
 8e0:	02812483          	lw	s1,40(sp)
 8e4:	02412903          	lw	s2,36(sp)
 8e8:	02012983          	lw	s3,32(sp)
 8ec:	01c12a03          	lw	s4,28(sp)
 8f0:	01812a83          	lw	s5,24(sp)
 8f4:	01412b03          	lw	s6,20(sp)
 8f8:	01012b83          	lw	s7,16(sp)
 8fc:	00c12c03          	lw	s8,12(sp)
 900:	00812c83          	lw	s9,8(sp)
 904:	00412d03          	lw	s10,4(sp)
 908:	00012d83          	lw	s11,0(sp)
 90c:	03010113          	addi	sp,sp,48
 910:	00008067          	ret
 914:	00044783          	lbu	a5,0(s0)
 918:	00054703          	lbu	a4,0(a0)
 91c:	00154603          	lbu	a2,1(a0)
 920:	00254683          	lbu	a3,2(a0)
 924:	00e7c7b3          	xor	a5,a5,a4
 928:	00f50023          	sb	a5,0(a0)
 92c:	00144783          	lbu	a5,1(s0)
 930:	00354703          	lbu	a4,3(a0)
 934:	00454303          	lbu	t1,4(a0)
 938:	00c7c7b3          	xor	a5,a5,a2
 93c:	00f500a3          	sb	a5,1(a0)
 940:	00244783          	lbu	a5,2(s0)
 944:	00554883          	lbu	a7,5(a0)
 948:	00654803          	lbu	a6,6(a0)
 94c:	00d7c7b3          	xor	a5,a5,a3
 950:	00f50123          	sb	a5,2(a0)
 954:	00344783          	lbu	a5,3(s0)
 958:	00754583          	lbu	a1,7(a0)
 95c:	00854603          	lbu	a2,8(a0)
 960:	00e7c7b3          	xor	a5,a5,a4
 964:	00f501a3          	sb	a5,3(a0)
 968:	00444783          	lbu	a5,4(s0)
 96c:	00954683          	lbu	a3,9(a0)
 970:	00a54703          	lbu	a4,10(a0)
 974:	0067c7b3          	xor	a5,a5,t1
 978:	00f50223          	sb	a5,4(a0)
 97c:	00544783          	lbu	a5,5(s0)
 980:	0117c7b3          	xor	a5,a5,a7
 984:	00f502a3          	sb	a5,5(a0)
 988:	00644783          	lbu	a5,6(s0)
 98c:	0107c7b3          	xor	a5,a5,a6
 990:	00f50323          	sb	a5,6(a0)
 994:	00744783          	lbu	a5,7(s0)
 998:	00b7c7b3          	xor	a5,a5,a1
 99c:	00f503a3          	sb	a5,7(a0)
 9a0:	00844783          	lbu	a5,8(s0)
 9a4:	00c7c7b3          	xor	a5,a5,a2
 9a8:	00f50423          	sb	a5,8(a0)
 9ac:	00944783          	lbu	a5,9(s0)
 9b0:	00d7c7b3          	xor	a5,a5,a3
 9b4:	00f504a3          	sb	a5,9(a0)
 9b8:	00a44783          	lbu	a5,10(s0)
 9bc:	00e7c7b3          	xor	a5,a5,a4
 9c0:	00f50523          	sb	a5,10(a0)
 9c4:	00b44703          	lbu	a4,11(s0)
 9c8:	00b54783          	lbu	a5,11(a0)
 9cc:	00c54583          	lbu	a1,12(a0)
 9d0:	00d54603          	lbu	a2,13(a0)
 9d4:	00e7c7b3          	xor	a5,a5,a4
 9d8:	00f505a3          	sb	a5,11(a0)
 9dc:	00c44783          	lbu	a5,12(s0)
 9e0:	00e54683          	lbu	a3,14(a0)
 9e4:	00f54703          	lbu	a4,15(a0)
 9e8:	00b7c7b3          	xor	a5,a5,a1
 9ec:	00f50623          	sb	a5,12(a0)
 9f0:	00d44783          	lbu	a5,13(s0)
 9f4:	00c7c7b3          	xor	a5,a5,a2
 9f8:	00f506a3          	sb	a5,13(a0)
 9fc:	00e44783          	lbu	a5,14(s0)
 a00:	00d7c7b3          	xor	a5,a5,a3
 a04:	00f50723          	sb	a5,14(a0)
 a08:	00f44783          	lbu	a5,15(s0)
 a0c:	00e7c7b3          	xor	a5,a5,a4
 a10:	00f507a3          	sb	a5,15(a0)
 a14:	9f5ff06f          	j	408 <Cipher+0x94>
 a18:	0a044783          	lbu	a5,160(s0)
 a1c:	00f74733          	xor	a4,a4,a5
 a20:	00e50023          	sb	a4,0(a0)
 a24:	0a144783          	lbu	a5,161(s0)
 a28:	00f9c9b3          	xor	s3,s3,a5
 a2c:	013500a3          	sb	s3,1(a0)
 a30:	0a244783          	lbu	a5,162(s0)
 a34:	00f6c6b3          	xor	a3,a3,a5
 a38:	00d50123          	sb	a3,2(a0)
 a3c:	0a344783          	lbu	a5,163(s0)
 a40:	00f3c3b3          	xor	t2,t2,a5
 a44:	007501a3          	sb	t2,3(a0)
 a48:	0a444783          	lbu	a5,164(s0)
 a4c:	00feceb3          	xor	t4,t4,a5
 a50:	01d50223          	sb	t4,4(a0)
 a54:	0a544783          	lbu	a5,165(s0)
 a58:	00f4c4b3          	xor	s1,s1,a5
 a5c:	009502a3          	sb	s1,5(a0)
 a60:	0a644783          	lbu	a5,166(s0)
 a64:	00fbcbb3          	xor	s7,s7,a5
 a68:	01750323          	sb	s7,6(a0)
 a6c:	0a744783          	lbu	a5,167(s0)
 a70:	00fb4b33          	xor	s6,s6,a5
 a74:	016503a3          	sb	s6,7(a0)
 a78:	0a844783          	lbu	a5,168(s0)
 a7c:	00f94933          	xor	s2,s2,a5
 a80:	01250423          	sb	s2,8(a0)
 a84:	0a944783          	lbu	a5,169(s0)
 a88:	00f2c2b3          	xor	t0,t0,a5
 a8c:	005504a3          	sb	t0,9(a0)
 a90:	0aa44783          	lbu	a5,170(s0)
 a94:	00ffcfb3          	xor	t6,t6,a5
 a98:	01f50523          	sb	t6,10(a0)
 a9c:	0ab44783          	lbu	a5,171(s0)
 aa0:	00fcccb3          	xor	s9,s9,a5
 aa4:	019505a3          	sb	s9,11(a0)
 aa8:	0ac44783          	lbu	a5,172(s0)
 aac:	00fa4a33          	xor	s4,s4,a5
 ab0:	01450623          	sb	s4,12(a0)
 ab4:	0ad44783          	lbu	a5,173(s0)
 ab8:	00facab3          	xor	s5,s5,a5
 abc:	015506a3          	sb	s5,13(a0)
 ac0:	0ae44783          	lbu	a5,174(s0)
 ac4:	00ff4f33          	xor	t5,t5,a5
 ac8:	01e50723          	sb	t5,14(a0)
 acc:	0af44783          	lbu	a5,175(s0)
 ad0:	00fe4e33          	xor	t3,t3,a5
 ad4:	01c507a3          	sb	t3,15(a0)
 ad8:	e05ff06f          	j	8dc <Cipher+0x568>

00000adc <AES_init_ctx>:
 adc:	e0cff06f          	j	e8 <KeyExpansion>

00000ae0 <AES_ECB_encrypt>:
 ae0:	00050793          	mv	a5,a0
 ae4:	00058513          	mv	a0,a1
 ae8:	00078593          	mv	a1,a5
 aec:	889ff06f          	j	374 <Cipher>

00000af0 <uart_init>:
 af0:	100097b7          	lui	a5,0x10009
 af4:	00b52023          	sw	a1,0(a0)
 af8:	00c78793          	addi	a5,a5,12 # 1000900c <__stack_top+0x10001010>
 afc:	00300713          	li	a4,3
 b00:	00e7a023          	sw	a4,0(a5)
 b04:	00000013          	nop
 b08:	00000013          	nop
 b0c:	0007a703          	lw	a4,0(a5)
 b10:	01076713          	ori	a4,a4,16
 b14:	00e7a023          	sw	a4,0(a5)
 b18:	00008067          	ret

00000b1c <uart_transmit_string>:
 b1c:	02060e63          	beqz	a2,b58 <uart_transmit_string+0x3c>
 b20:	10009737          	lui	a4,0x10009
 b24:	10009537          	lui	a0,0x10009
 b28:	00c58633          	add	a2,a1,a2
 b2c:	00870713          	addi	a4,a4,8 # 10009008 <__stack_top+0x1000100c>
 b30:	00450513          	addi	a0,a0,4 # 10009004 <__stack_top+0x10001008>
 b34:	00000013          	nop
 b38:	00000013          	nop
 b3c:	0005c683          	lbu	a3,0(a1)
 b40:	00072783          	lw	a5,0(a4)
 b44:	0087f793          	andi	a5,a5,8
 b48:	fe079ce3          	bnez	a5,b40 <uart_transmit_string+0x24>
 b4c:	00d52023          	sw	a3,0(a0)
 b50:	00158593          	addi	a1,a1,1
 b54:	fec590e3          	bne	a1,a2,b34 <uart_transmit_string+0x18>
 b58:	00008067          	ret

00000b5c <exc>:
 b5c:	d78ff06f          	j	d4 <exc_handler>

00000b60 <ssi>:
 b60:	00000013          	nop

00000b64 <hsi>:
 b64:	00000013          	nop

00000b68 <msi>:
 b68:	d74ff06f          	j	dc <msi_handler>

00000b6c <uti>:
 b6c:	00000013          	nop

00000b70 <sti>:
 b70:	00000013          	nop

00000b74 <hti>:
 b74:	00000013          	nop

00000b78 <mti>:
 b78:	d58ff06f          	j	d0 <mti_handler>

00000b7c <uei>:
 b7c:	00000013          	nop

00000b80 <sei>:
 b80:	00000013          	nop

00000b84 <hei>:
 b84:	00000013          	nop

00000b88 <mei>:
 b88:	d50ff06f          	j	d8 <mei_handler>
 b8c:	00000013          	nop
 b90:	00000013          	nop
 b94:	00000013          	nop
 b98:	00000013          	nop

00000b9c <fast_irq0>:
 b9c:	d44ff06f          	j	e0 <fast_irq0_handler>

00000ba0 <fast_irq1>:
 ba0:	d44ff06f          	j	e4 <fast_irq1_handler>

00000ba4 <SET_MTVEC_VECTOR_MODE>:
 ba4:	00000797          	auipc	a5,0x0
 ba8:	fb878793          	addi	a5,a5,-72 # b5c <exc>
 bac:	0017e793          	ori	a5,a5,1
 bb0:	30579073          	csrw	mtvec,a5
 bb4:	00008067          	ret
