### An implementation of a Single precision floating point Add/Sub operation with 4-Stage pipelining 

### Stage 1 : Comparing the floating points and extraction of sign , exponent and mantisa's <br>

### Stage 2 : Alligning the mantisa's by right shift and incrementing the smaller exponent till it reaches the bigger one<br>

### Stage 3 : Adding the mantisa's<br>

### Stage 4 : Normalization of the sum result based on IEEE 754 Floating point<br>

A website to check the results <br>
https://www.h-schmidt.net/FloatConverter/IEEE754.html
