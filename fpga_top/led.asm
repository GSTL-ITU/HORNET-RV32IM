
led.elf:     file format elf32-littleriscv


Disassembly of section .init:

00000000 <_start>:
   0:	00008117          	auipc	sp,0x8
   4:	ffc10113          	addi	sp,sp,-4 # 7ffc <__stack_top>
   8:	00010433          	add	s0,sp,zero
   c:	0040006f          	j	10 <main>

Disassembly of section .text:

00000010 <main>:
  10:	10008737          	lui	a4,0x10008
  14:	02070713          	addi	a4,a4,32 # 10008020 <__stack_top+0x10000024>
  18:	00100693          	li	a3,1
  1c:	000f47b7          	lui	a5,0xf4
  20:	00d72023          	sw	a3,0(a4)
  24:	24078793          	addi	a5,a5,576 # f4240 <__stack_top+0xec244>
  28:	00000013          	nop
  2c:	fff78793          	addi	a5,a5,-1
  30:	fe079ce3          	bnez	a5,28 <main+0x18>
  34:	000f47b7          	lui	a5,0xf4
  38:	00072023          	sw	zero,0(a4)
  3c:	24078793          	addi	a5,a5,576 # f4240 <__stack_top+0xec244>
  40:	00000013          	nop
  44:	fff78793          	addi	a5,a5,-1
  48:	fe079ce3          	bnez	a5,40 <main+0x30>
  4c:	fd1ff06f          	j	1c <main+0xc>
