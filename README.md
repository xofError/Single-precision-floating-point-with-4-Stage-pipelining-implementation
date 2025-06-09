# Single-Precision Floating Point Add/Sub Operation with 4-Stage Pipelining

This project implements a **single-precision floating-point addition and subtraction** operation based on the IEEE 754 standard. The design uses a **4-stage pipelined architecture** for efficient computation.

---

## 🚀 Features
- **IEEE 754 Compliance**: Handles normalized and denormalized numbers.
- **4-Stage Pipelining**: Optimized for high-speed operations.
- **Addition and Subtraction**: Supports both operations with proper sign handling.
- **Testbench Included**: Simulates various test cases for verification.

---

## 🛠️ Pipeline Stages

### 1️⃣ **Stage 1: Comparison and Extraction**
- Extracts the **sign**, **exponent**, and **mantissa** from the input floating-point numbers.
- Computes the **exponent difference** and determines the larger number.


---

### 1.5️⃣ **Stage 1.5: Special Case Handling**
- **Purpose**: Handles special cases like NaN, infinity, and zero to ensure compliance with the IEEE 754 standard.
- **Implemented in**: [`FloatingDetection.v`](folder/FloatingDetection.v)
- **Key Features**:
  - **NaN Handling**:
    - If either input is NaN, the result is a **quiet NaN**.
    - The payload (mantissa) of the first NaN encountered is propagated.
  - **Infinity Handling**:
    - **∞ + ∞** (same signs): Result is `+∞` or `-∞` depending on the sign.
    - **∞ - ∞** (different signs): Result is **NaN**.
    - If only one input is infinity, the result is that infinity.
  - **Zero Handling**:
    - **0 + 0**: Result is signed zero (`+0` or `-0` depending on the operation).
    - **0 + X**: Result is the non-zero input.
  - **Pass-Through**:
    - If no special case is detected, the inputs are passed to the next stage for further processing.

#### Example Scenarios:
| **Condition**       | **Inputs**                  | **Result**                     |
|----------------------|-----------------------------|---------------------------------|
| NaN                 | A or B is NaN               | Quiet NaN                      |
| ∞ + ∞ (same signs)  | A = +∞, B = +∞              | +∞                             |
| ∞ - ∞ (different)   | A = +∞, B = -∞              | Quiet NaN                      |
| ∞ + X               | A = +∞, B = finite          | +∞                             |
| 0 + 0               | A = +0, B = -0              | Signed zero (`+0` or `-0`)     |
| 0 + X               | A = 0, B = finite           | Non-zero input (`B`)           |
| No special case     | Normal inputs               | Pass to next stage             |

REFRENCE (Digital Design and Computer Architecture : David Money Harris)

![image](https://github.com/user-attachments/assets/8bc0ac94-0052-475b-86ec-c0ce2a2a0cd8)
---

### 2️⃣ **Stage 2: Mantissa Alignment**
- Aligns the mantissas by **right-shifting** the smaller mantissa.
- Adjusts the smaller exponent to match the larger one.

---

### 3️⃣ **Stage 3: Mantissa Addition/Subtraction**
- Adds or subtracts the aligned mantissas based on the signs of the inputs.
- Handles overflow and underflow during the operation.

---

### 4️⃣ **Stage 4: Normalization**
- Normalizes the result to ensure compliance with the IEEE 754 format.
- Adjusts the exponent and mantissa to represent the result correctly.

---

---

## 🧪 Test Cases

The testbench (`tb_PipelinedFAdd.v`) includes the following test cases:

| **Test** | **Input A** | **Input B** | **Operation** | **Expected Result** |
|----------|-------------|-------------|---------------|----------------------|
| Test 1   | 13.65       | 10.2555     | Add (`+`)     | 23.9055             |
| Test 2   | 13.65       | 10.2555     | Sub (`-`)     | 3.3945              |
| Test 3   | -13.65      | 10.2555     | Add (`+`)     | -3.3945             |
| Test 4   | -13.65      | 10.2555     | Sub (`-`)     | -23.9055            |

---

## 🔗 Useful Resources

- [IEEE 754 Floating Point Converter](https://www.h-schmidt.net/FloatConverter/IEEE754.html)

---

## 📜 How to Run

1. **Compile the Verilog files**:
   ```bash
   chmod +x
   ./run.sh
   #you can uncomment the gtkwave section in run.sh to get a waveform


### Key Improvements:

2. **Features Section**: Highlighted the key features of the project.
3. **Pipeline Stages**: Clearly explained each stage with numbered headers.
4. **Test Cases Table**: Organized test cases in a table for clarity.
5. **How to Run**: Added step-by-step instructions for running the project.
6. **References**: Included links to relevant resources for further reading.

