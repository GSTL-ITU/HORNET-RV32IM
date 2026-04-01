
led.elf:     file format elf32-littleriscv


Disassembly of section .init:

00000000 <_start>:
   0:	00008117          	auipc	sp,0x8
   4:	ffc10113          	addi	sp,sp,-4 # 7ffc <__stack_top>
   8:	00010433          	add	s0,sp,zero
   c:	0040006f          	j	10 <main>

Disassembly of section .text:

00000010 <main>:
  10:	fa010113          	addi	sp,sp,-96
  14:	05212823          	sw	s2,80(sp)
  18:	746f7737          	lui	a4,0x746f7
  1c:	00007937          	lui	s2,0x7
  20:	0d4b57b7          	lui	a5,0xd4b5
  24:	f4270713          	addi	a4,a4,-190 # 746f6f42 <__stack_top+0x746eef46>
  28:	f2078793          	addi	a5,a5,-224 # d4b4f20 <__stack_top+0xd4acf24>
  2c:	05412423          	sw	s4,72(sp)
  30:	00090513          	mv	a0,s2
  34:	100095b7          	lui	a1,0x10009
  38:	00a00a13          	li	s4,10
  3c:	04112e23          	sw	ra,92(sp)
  40:	04812c23          	sw	s0,88(sp)
  44:	04912a23          	sw	s1,84(sp)
  48:	05312623          	sw	s3,76(sp)
  4c:	05512223          	sw	s5,68(sp)
  50:	05612023          	sw	s6,64(sp)
  54:	03712e23          	sw	s7,60(sp)
  58:	03812c23          	sw	s8,56(sp)
  5c:	00e12023          	sw	a4,0(sp)
  60:	00f12223          	sw	a5,4(sp)
  64:	10008c37          	lui	s8,0x10008
  68:	01411423          	sh	s4,8(sp)
  6c:	388000ef          	jal	3f4 <uart_init>
  70:	00010593          	mv	a1,sp
  74:	00090513          	mv	a0,s2
  78:	00900613          	li	a2,9
  7c:	020c0c13          	addi	s8,s8,32 # 10008020 <__stack_top+0x10000024>
  80:	00100993          	li	s3,1
  84:	3a726437          	lui	s0,0x3a726
  88:	6e7574b7          	lui	s1,0x6e757
  8c:	ccccdb37          	lui	s6,0xccccd
  90:	374000ef          	jal	404 <uart_transmit_string>
  94:	f4348493          	addi	s1,s1,-189 # 6e756f43 <__stack_top+0x6e74ef47>
  98:	013c2023          	sw	s3,0(s8)
  9c:	57440413          	addi	s0,s0,1396 # 3a726574 <__stack_top+0x3a71e578>
  a0:	ccdb0b13          	addi	s6,s6,-819 # cccccccd <__stack_top+0xcccc4cd1>
  a4:	00000b93          	li	s7,0
  a8:	02000a93          	li	s5,32
  ac:	001b8b93          	addi	s7,s7,1
  b0:	036bb7b3          	mulhu	a5,s7,s6
  b4:	013c2023          	sw	s3,0(s8)
  b8:	00912c23          	sw	s1,24(sp)
  bc:	00812e23          	sw	s0,28(sp)
  c0:	03510023          	sb	s5,32(sp)
  c4:	0037d793          	srli	a5,a5,0x3
  c8:	00279713          	slli	a4,a5,0x2
  cc:	00f70733          	add	a4,a4,a5
  d0:	00171713          	slli	a4,a4,0x1
  d4:	40eb8733          	sub	a4,s7,a4
  d8:	03070713          	addi	a4,a4,48
  dc:	00e10623          	sb	a4,12(sp)
  e0:	20078a63          	beqz	a5,2f4 <main+0x2e4>
  e4:	0367b733          	mulhu	a4,a5,s6
  e8:	00375713          	srli	a4,a4,0x3
  ec:	00271693          	slli	a3,a4,0x2
  f0:	00e686b3          	add	a3,a3,a4
  f4:	00169693          	slli	a3,a3,0x1
  f8:	40d787b3          	sub	a5,a5,a3
  fc:	03078793          	addi	a5,a5,48
 100:	00f106a3          	sb	a5,13(sp)
 104:	1e070e63          	beqz	a4,300 <main+0x2f0>
 108:	036736b3          	mulhu	a3,a4,s6
 10c:	0036d693          	srli	a3,a3,0x3
 110:	00269793          	slli	a5,a3,0x2
 114:	00d787b3          	add	a5,a5,a3
 118:	00179793          	slli	a5,a5,0x1
 11c:	40f707b3          	sub	a5,a4,a5
 120:	03078793          	addi	a5,a5,48
 124:	00f10723          	sb	a5,14(sp)
 128:	1e068663          	beqz	a3,314 <main+0x304>
 12c:	0366b733          	mulhu	a4,a3,s6
 130:	00375713          	srli	a4,a4,0x3
 134:	00271793          	slli	a5,a4,0x2
 138:	00e787b3          	add	a5,a5,a4
 13c:	00179793          	slli	a5,a5,0x1
 140:	40f687b3          	sub	a5,a3,a5
 144:	03078793          	addi	a5,a5,48
 148:	00f107a3          	sb	a5,15(sp)
 14c:	1e070863          	beqz	a4,33c <main+0x32c>
 150:	036736b3          	mulhu	a3,a4,s6
 154:	0036d693          	srli	a3,a3,0x3
 158:	00269793          	slli	a5,a3,0x2
 15c:	00d787b3          	add	a5,a5,a3
 160:	00179793          	slli	a5,a5,0x1
 164:	40f707b3          	sub	a5,a4,a5
 168:	03078793          	addi	a5,a5,48
 16c:	00f10823          	sb	a5,16(sp)
 170:	1e068663          	beqz	a3,35c <main+0x34c>
 174:	0366b733          	mulhu	a4,a3,s6
 178:	00375713          	srli	a4,a4,0x3
 17c:	00271793          	slli	a5,a4,0x2
 180:	00e787b3          	add	a5,a5,a4
 184:	00179793          	slli	a5,a5,0x1
 188:	40f687b3          	sub	a5,a3,a5
 18c:	03078793          	addi	a5,a5,48
 190:	00f108a3          	sb	a5,17(sp)
 194:	1e070463          	beqz	a4,37c <main+0x36c>
 198:	036736b3          	mulhu	a3,a4,s6
 19c:	0036d693          	srli	a3,a3,0x3
 1a0:	00269793          	slli	a5,a3,0x2
 1a4:	00d787b3          	add	a5,a5,a3
 1a8:	00179793          	slli	a5,a5,0x1
 1ac:	40f707b3          	sub	a5,a4,a5
 1b0:	03078793          	addi	a5,a5,48
 1b4:	00f10923          	sb	a5,18(sp)
 1b8:	1c068e63          	beqz	a3,394 <main+0x384>
 1bc:	0366b733          	mulhu	a4,a3,s6
 1c0:	00375713          	srli	a4,a4,0x3
 1c4:	00271793          	slli	a5,a4,0x2
 1c8:	00e787b3          	add	a5,a5,a4
 1cc:	00179793          	slli	a5,a5,0x1
 1d0:	40f687b3          	sub	a5,a3,a5
 1d4:	03078793          	addi	a5,a5,48
 1d8:	00f109a3          	sb	a5,19(sp)
 1dc:	1c070863          	beqz	a4,3ac <main+0x39c>
 1e0:	036736b3          	mulhu	a3,a4,s6
 1e4:	0036d693          	srli	a3,a3,0x3
 1e8:	00269793          	slli	a5,a3,0x2
 1ec:	00d787b3          	add	a5,a5,a3
 1f0:	00179793          	slli	a5,a5,0x1
 1f4:	40f707b3          	sub	a5,a4,a5
 1f8:	03078793          	addi	a5,a5,48
 1fc:	00f10a23          	sb	a5,20(sp)
 200:	1c068a63          	beqz	a3,3d4 <main+0x3c4>
 204:	01314703          	lbu	a4,19(sp)
 208:	03068693          	addi	a3,a3,48
 20c:	02f10123          	sb	a5,34(sp)
 210:	02d100a3          	sb	a3,33(sp)
 214:	00a00793          	li	a5,10
 218:	002786b3          	add	a3,a5,sp
 21c:	0086c683          	lbu	a3,8(a3)
 220:	02e101a3          	sb	a4,35(sp)
 224:	ffc78713          	addi	a4,a5,-4
 228:	02d10223          	sb	a3,36(sp)
 22c:	10070463          	beqz	a4,334 <main+0x324>
 230:	002786b3          	add	a3,a5,sp
 234:	0076c683          	lbu	a3,7(a3)
 238:	ffb78713          	addi	a4,a5,-5
 23c:	02d102a3          	sb	a3,37(sp)
 240:	10070a63          	beqz	a4,354 <main+0x344>
 244:	002786b3          	add	a3,a5,sp
 248:	0066c683          	lbu	a3,6(a3)
 24c:	ffa78713          	addi	a4,a5,-6
 250:	02d10323          	sb	a3,38(sp)
 254:	12070063          	beqz	a4,374 <main+0x364>
 258:	002786b3          	add	a3,a5,sp
 25c:	0056c683          	lbu	a3,5(a3)
 260:	ff978713          	addi	a4,a5,-7
 264:	02d103a3          	sb	a3,39(sp)
 268:	16070263          	beqz	a4,3cc <main+0x3bc>
 26c:	002786b3          	add	a3,a5,sp
 270:	0046c683          	lbu	a3,4(a3)
 274:	ff878713          	addi	a4,a5,-8
 278:	02d10423          	sb	a3,40(sp)
 27c:	14070463          	beqz	a4,3c4 <main+0x3b4>
 280:	00078713          	mv	a4,a5
 284:	00270733          	add	a4,a4,sp
 288:	00374703          	lbu	a4,3(a4)
 28c:	ff778793          	addi	a5,a5,-9
 290:	02e104a3          	sb	a4,41(sp)
 294:	14078c63          	beqz	a5,3ec <main+0x3dc>
 298:	00c14783          	lbu	a5,12(sp)
 29c:	00a00613          	li	a2,10
 2a0:	02f10523          	sb	a5,42(sp)
 2a4:	002607b3          	add	a5,a2,sp
 2a8:	00d00713          	li	a4,13
 2ac:	03478123          	sb	s4,34(a5)
 2b0:	02e780a3          	sb	a4,33(a5)
 2b4:	00b60613          	addi	a2,a2,11
 2b8:	01810593          	addi	a1,sp,24
 2bc:	00090513          	mv	a0,s2
 2c0:	144000ef          	jal	404 <uart_transmit_string>
 2c4:	000f47b7          	lui	a5,0xf4
 2c8:	24078793          	addi	a5,a5,576 # f4240 <__stack_top+0xec244>
 2cc:	00000013          	nop
 2d0:	fff78793          	addi	a5,a5,-1
 2d4:	fe079ce3          	bnez	a5,2cc <main+0x2bc>
 2d8:	000f47b7          	lui	a5,0xf4
 2dc:	000c2023          	sw	zero,0(s8)
 2e0:	24078793          	addi	a5,a5,576 # f4240 <__stack_top+0xec244>
 2e4:	00000013          	nop
 2e8:	fff78793          	addi	a5,a5,-1
 2ec:	fe079ce3          	bnez	a5,2e4 <main+0x2d4>
 2f0:	dbdff06f          	j	ac <main+0x9c>
 2f4:	02e100a3          	sb	a4,33(sp)
 2f8:	00100613          	li	a2,1
 2fc:	fa9ff06f          	j	2a4 <main+0x294>
 300:	00c14703          	lbu	a4,12(sp)
 304:	02f100a3          	sb	a5,33(sp)
 308:	00200613          	li	a2,2
 30c:	02e10123          	sb	a4,34(sp)
 310:	f95ff06f          	j	2a4 <main+0x294>
 314:	02f100a3          	sb	a5,33(sp)
 318:	00c15783          	lhu	a5,12(sp)
 31c:	00300613          	li	a2,3
 320:	0087d713          	srli	a4,a5,0x8
 324:	00879793          	slli	a5,a5,0x8
 328:	00f707b3          	add	a5,a4,a5
 32c:	02f11123          	sh	a5,34(sp)
 330:	f75ff06f          	j	2a4 <main+0x294>
 334:	00400613          	li	a2,4
 338:	f6dff06f          	j	2a4 <main+0x294>
 33c:	00e14683          	lbu	a3,14(sp)
 340:	02f100a3          	sb	a5,33(sp)
 344:	00d14703          	lbu	a4,13(sp)
 348:	00400793          	li	a5,4
 34c:	02d10123          	sb	a3,34(sp)
 350:	ec9ff06f          	j	218 <main+0x208>
 354:	00500613          	li	a2,5
 358:	f4dff06f          	j	2a4 <main+0x294>
 35c:	00f14683          	lbu	a3,15(sp)
 360:	02f100a3          	sb	a5,33(sp)
 364:	00e14703          	lbu	a4,14(sp)
 368:	00500793          	li	a5,5
 36c:	02d10123          	sb	a3,34(sp)
 370:	ea9ff06f          	j	218 <main+0x208>
 374:	00600613          	li	a2,6
 378:	f2dff06f          	j	2a4 <main+0x294>
 37c:	01014683          	lbu	a3,16(sp)
 380:	02f100a3          	sb	a5,33(sp)
 384:	00f14703          	lbu	a4,15(sp)
 388:	00600793          	li	a5,6
 38c:	02d10123          	sb	a3,34(sp)
 390:	e89ff06f          	j	218 <main+0x208>
 394:	01114683          	lbu	a3,17(sp)
 398:	02f100a3          	sb	a5,33(sp)
 39c:	01014703          	lbu	a4,16(sp)
 3a0:	00700793          	li	a5,7
 3a4:	02d10123          	sb	a3,34(sp)
 3a8:	e71ff06f          	j	218 <main+0x208>
 3ac:	01214683          	lbu	a3,18(sp)
 3b0:	02f100a3          	sb	a5,33(sp)
 3b4:	01114703          	lbu	a4,17(sp)
 3b8:	00800793          	li	a5,8
 3bc:	02d10123          	sb	a3,34(sp)
 3c0:	e59ff06f          	j	218 <main+0x208>
 3c4:	00800613          	li	a2,8
 3c8:	eddff06f          	j	2a4 <main+0x294>
 3cc:	00700613          	li	a2,7
 3d0:	ed5ff06f          	j	2a4 <main+0x294>
 3d4:	01314683          	lbu	a3,19(sp)
 3d8:	02f100a3          	sb	a5,33(sp)
 3dc:	01214703          	lbu	a4,18(sp)
 3e0:	00900793          	li	a5,9
 3e4:	02d10123          	sb	a3,34(sp)
 3e8:	e31ff06f          	j	218 <main+0x208>
 3ec:	00900613          	li	a2,9
 3f0:	eb5ff06f          	j	2a4 <main+0x294>

000003f4 <uart_init>:
 3f4:	00b52023          	sw	a1,0(a0)
 3f8:	00300793          	li	a5,3
 3fc:	02f5a823          	sw	a5,48(a1) # 10009030 <__stack_top+0x10001034>
 400:	00008067          	ret

00000404 <uart_transmit_string>:
 404:	02060e63          	beqz	a2,440 <uart_transmit_string+0x3c>
 408:	10009737          	lui	a4,0x10009
 40c:	10009537          	lui	a0,0x10009
 410:	00c58633          	add	a2,a1,a2
 414:	00870713          	addi	a4,a4,8 # 10009008 <__stack_top+0x1000100c>
 418:	00450513          	addi	a0,a0,4 # 10009004 <__stack_top+0x10001008>
 41c:	00000013          	nop
 420:	00000013          	nop
 424:	0005c683          	lbu	a3,0(a1)
 428:	00072783          	lw	a5,0(a4)
 42c:	0087f793          	andi	a5,a5,8
 430:	fe079ce3          	bnez	a5,428 <uart_transmit_string+0x24>
 434:	00d52023          	sw	a3,0(a0)
 438:	00158593          	addi	a1,a1,1
 43c:	fec590e3          	bne	a1,a2,41c <uart_transmit_string+0x18>
 440:	00008067          	ret
