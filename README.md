An implementation of a Single precision floating point Add/Sub operation with 4-Stage pipelining 

Stage 1 : Comparing the floating points and extraction of sign , exponent and mantisa's
Stage 2 : Alligning the mantisa's by right shift and incrementing the smaller exponent till it reaches the bigger one
Stage 3 : Adding the mantisa's
Stage 4 : Normalization of the sum result based on IEEE 754 Floating point
