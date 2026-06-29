# Simplified RC4 Stream Cipher v2 (Decryption)
## Hardware and Embedded Security Course - Master's Degree in Cybersecurity @ University of Pisa

## General Description and Objectives
This project implements a simplified version of the RC4 stream cipher specifically designed for the decryption of ciphertext. The implementation targets an FPGA device and is developed as part of the Hardware and Embedded Security course.

The objective was to design a hardware module capable of performing the two main phases of the RC4 algorithm:
1. **Key-Scheduling Algorithm (KSA):** Initializes a permutation table based on a symmetric key.
2. **Pseudo-Random Generation Algorithm (PRGA):** Generates a keystream that is XORed with the ciphertext to retrieve the original plaintext.

In this simplified version, the key length is fixed at **32 bytes (256 bits)**.

## Project Structure
- `db/`: Contains the SystemVerilog RTL design files.
- `tb/`: Contains the SystemVerilog testbenches.
- `model/`: Contains the Python high-level model.
- `modelsim/`: ModelSim project scripts, test vectors (`tv/`), and waveforms (`wave/`).
- `quartus/`: Quartus project scripts and constraints (`constr/`).
- `doc/`: Project documentation and reports.

## System Architecture

### RTL Design
The system is implemented as a single top-level module `rc4_dec_module` in SystemVerilog. The architecture is driven by a Finite State Machine (FSM) to manage the transition between the initialization and decryption phases.

#### Internal Components
- **State Memory (`S_mem`):** A 256-byte array used as a permutation table.
- **FSM States:**
    - **State 0:** Initializes the `S_mem` array with values from 0 to 255.
    - **State 1:** Performs the KSA step of computing the index `j` using the input key.
    - **State 2:** Executes the swap operation between `S_mem[i]` and `S_mem[j]`. Once $i=255$, the module transitions to the PRGA phase.
    - **State 3:** Performs the initial PRGA swap and computes the first keystream index.
    - **State 4:** The main decryption loop. When `din_valid` is asserted, it XORs the input ciphertext byte with the value from `S_mem` to produce the plaintext byte, then updates the internal state for the next byte.

#### Interface Specification
| Signal Name | Direction | Width | Description |
| :--- | :--- | :--- | :--- |
| `clk` | Input | 1 bit | System clock |
| `rst_n` | Input | 1 bit | Asynchronous active-low reset |
| `key` | Input | 32 x 8 bits | 32-byte symmetric key |
| `din` | Input | 8 bits | Ciphertext byte input |
| `din_valid` | Input | 1 bit | Flag indicating valid input data |
| `dout` | Output | 8 bits | Decrypted plaintext byte output |
| `dout_ready` | Output | 1 bit | Flag indicating valid output data |
| `init_done` | Output | 1 bit | Indicates completion of KSA |

### High-Level Model
A high-level model was implemented in Python (`model/high_level_model.py`). This model serves two purposes:
1. Validating the RC4 algorithm logic.
2. Generating test vectors (keys, plaintexts, and ciphertexts) stored in `modelsim/tv/` for use in the RTL verification process.

## Installation and Execution

### Prerequisites
- **Quartus Prime** (Version 20.1.1 recommended)
- **ModelSim**
- **Python 3.x**

### Functional Verification (ModelSim)
To set up and run the simulation:
1. Navigate to the `modelsim/` directory.
2. Execute the build script to automatically create the project and add all RTL and testbench files:
   ```bash
   python build.py
   ```
3. Open ModelSim and run the testbenches located in the `tb/` directory to verify the decryption accuracy.

### FPGA Implementation (Quartus)
To synthesize and implement the design on the **Cyclone V (5CGXFC9D6F27C7)** FPGA:
1. Navigate to the `quartus/` directory.
2. Execute the build script:
   ```bash
   python build.py
   ```
3. When prompted for the top-level module, enter: `rc4_dec_module`.
4. The script will handle the project creation and apply the timing constraints specified in `quartus/constr/time_constr.sdc`.