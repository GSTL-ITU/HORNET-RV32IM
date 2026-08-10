## PQC Hardware Cycle Analysis (`HORNET-RV32IM`)

| Algorithm | Operation | Unoptimized (`-O0`) Cycles | Optimized (`-O3`) Cycles |
| :--- | :--- | ---: | ---: |
| **Kyber** <br>*(ML-KEM)* | Keypair Generation | 4,916,388 | 1,628,037 |
| | Encapsulation | 5,757,020 | 1,876,904 |
| | Decapsulation | 6,791,572 | 2,197,007 |
| **Dilithium** <br>*(ML-DSA)* | Keypair Generation | 9,327,292 | 3,252,472 |
| | Signing | 58,159,031 | 20,718,384 |
| | Verification | 10,200,050 | 3,570,390 |
| **SPHINCS+** <br>*(SLH-DSA)* | Keypair Generation | - | - |
| | Signing | - | - |
| | Verification | - | - |
| **Falcon** <br>*(FN-DSA)* | Keypair Generation | 807,708,626 | 163,514,576 |
| | Signing | 339,688,097 | 65,339,248 |
| | Verification | 2,450,860 | 592,241 |