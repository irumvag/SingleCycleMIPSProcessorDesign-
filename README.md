# MIPS Processor Project — CE80665 Computer Architecture

**University of Rwanda — College of Science and Technology**
Group: Gad Anaclet Irumva, Sandrine, Billy

A two-part lab project implementing a 32-bit MIPS ALU (Part I) and a complete single-cycle MIPS processor (Part II) in SystemVerilog, targeting the Altera Cyclone IV E FPGA (EP4CE115F29C7) in Quartus II 13.1.

---

## Project Structure

```
MIPS_Project/
├── Part1_Components/          # Part I — ALU and support components
│   ├── full_adder_32.sv       # 32-bit ripple-carry adder (structural)
│   ├── alu_32.sv              # 32-bit MIPS ALU (AND/OR/ADD/SUB/SLT/NOR)
│   ├── alu_control.sv         # ALU control: ALUOp + funct → alu_ctrl
│   ├── mux4to1_32.sv          # 4-to-1, 32-bit multiplexer
│   ├── mips_components_top.sv # Top-level wrapper for joint synthesis
│   └── tb_alu_32.sv           # ALU testbench (7 vectors, PASS/FAIL output)
│
├── Part2_Processor/           # Part II — Single-cycle MIPS processor
│   ├── mips_top.sv            # Top-level datapath
│   ├── control_unit.sv        # Main control unit (R-type/addi/lw/sw/beq)
│   ├── register_file.sv       # 32×32 register file ($0 hardwired to 0)
│   ├── instr_memory.sv        # 64-word ROM (10-instruction test program)
│   ├── data_memory.sv         # Synchronous data memory
│   ├── sign_extend.sv         # 16→32 sign extender
│   ├── mux2to1_32.sv          # 2-to-1, 32-bit multiplexer
│   ├── mux2to1_5.sv           # 2-to-1, 5-bit multiplexer (register select)
│   └── tb_mips_top.sv         # Processor testbench (PASS/FAIL per cycle)
│
├── MIPS_Part1_Components/     # Quartus II project — Part I
│   ├── MIPS_Part1_Components.qpf
│   └── MIPS_Part1_Components.qsf
│
├── MIPS_Part2_Processor/      # Quartus II project — Part II
│   ├── MIPS_Part2_Processor.qpf
│   └── MIPS_Part2_Processor.qsf
│
├── simulation/modelsim/
│   ├── run_sim.do             # ModelSim script — Part I simulation
│   └── run_mips.do            # ModelSim script — Part II simulation
│
├── generate_report.py         # Generates Part I Word report
├── generate_report_part2.py   # Generates Part II Word report
├── combine_reports.py         # Combines both reports into final document
│
├── MIPS_Project_Report_CE80665.docx       # Part I report
├── MIPS_Project_Report_Part2_CE80665.docx # Part II report
└── MIPS_Project_FINAL_CE80665.docx        # Final combined submission
```

---

## Prerequisites

| Tool | Version | Purpose |
|------|---------|---------|
| Quartus II | 13.1 (64-bit, Web Edition) | FPGA synthesis and compilation |
| ModelSim-Altera | Bundled with Quartus 13.1 | Functional simulation |
| Python | 3.9+ | Report generation scripts |
| python-docx | `pip install python-docx` | Word document creation |
| docxcompose | `pip install docxcompose` | Merging Word documents |

Quartus II 13.1 is assumed installed at `C:\altera\13.1\` (default path). If your install path differs, update the `PATH` in `run_sim.do` and `run_mips.do` accordingly.

---

## Quick Start

### 1 — Open the Quartus Projects

**Part I:**
```
File → Open Project → MIPS_Part1_Components/MIPS_Part1_Components.qpf
```

**Part II:**
```
File → Open Project → MIPS_Part2_Processor/MIPS_Part2_Processor.qpf
```

Both projects are pre-configured for device **EP4CE115F29C7** (Cyclone IV E, 115K LEs).

### 2 — Compile

Click **Processing → Start Compilation** (or press Ctrl+L).

Expected results after compilation:

| Metric | Part I (ALU only) | Part II (Full Processor) |
|--------|-------------------|--------------------------|
| Logic Elements | ~100 LEs | ~3,491 LEs |
| Registers | 0 | ~2,590 |
| Fmax | N/A (combinational) | ~61 MHz |

### 3 — View RTL and Technology Map

After compilation:
- **RTL Viewer:** Tools → Netlist Viewers → RTL Viewer
- **Technology Map:** Tools → Netlist Viewers → Technology Map Viewer (Post-Mapping)

### 4 — Run Simulation in ModelSim

Open a terminal in the `simulation/modelsim/` directory and launch ModelSim:

```bash
# Part I — ALU testbench
vsim -do run_sim.do

# Part II — Processor testbench
vsim -do run_mips.do
```

Each script automatically:
1. Compiles all SystemVerilog source files
2. Starts the simulation
3. Adds all signals to the Wave window with labeled dividers
4. Runs for the full test duration (200 ns / 300 ns)
5. Zooms the waveform to fit

**Expected Part I output (transcript window):**
```
PASS: AND  result=00000004, zero=0
PASS: OR   result=0000000D, zero=0
PASS: ADD  result=00000011, zero=0
PASS: SUB  result=00000007, zero=0
PASS: SLT  result=00000001, zero=0
PASS: NOR  result=FFFFFFF2, zero=0
PASS: SUB  result=00000000, zero=1  ← zero flag test
```

**Expected Part II output (transcript window):**
```
PASS Cycle1 addi $t0=5
PASS Cycle2 addi $t1=12
PASS Cycle3 add  $t2=17
PASS Cycle4 sub  $t3=7
PASS Cycle5 and  $t4=4
PASS Cycle6 or   $t5=13
PASS Cycle7 slt  $t6=1
INFO Cycle8 sw   Mem[0]=$t2
INFO Cycle9 lw   $t7=Mem[0]
PASS Cycle10 beq zero=1 (branch taken)
```

---

## Instruction Set Supported (Part II)

| Instruction | Format | Opcode | Operation |
|-------------|--------|--------|-----------|
| `add`  | R-type | 000000 / funct 100000 | rd = rs + rt |
| `sub`  | R-type | 000000 / funct 100010 | rd = rs − rt |
| `and`  | R-type | 000000 / funct 100100 | rd = rs & rt |
| `or`   | R-type | 000000 / funct 100101 | rd = rs \| rt |
| `slt`  | R-type | 000000 / funct 101010 | rd = (rs < rt) ? 1 : 0 |
| `addi` | I-type | 001000 | rt = rs + SignExt(imm) |
| `lw`   | I-type | 100011 | rt = Mem[rs + SignExt(imm)] |
| `sw`   | I-type | 101011 | Mem[rs + SignExt(imm)] = rt |
| `beq`  | I-type | 000100 | if (rs==rt) PC = PC+4+offset<<2 |

---

## Test Program (Instruction Memory)

The ROM in `instr_memory.sv` contains a fixed 10-instruction sequence for verification:

```asm
addi $t0, $0,  5      # $t0 = 5
addi $t1, $0,  12     # $t1 = 12
add  $t2, $t0, $t1    # $t2 = 17
sub  $t3, $t1, $t0    # $t3 = 7
and  $t4, $t0, $t1    # $t4 = 4  (5 & 12)
or   $t5, $t0, $t1    # $t5 = 13 (5 | 12)
slt  $t6, $t0, $t1    # $t6 = 1  (5 < 12)
sw   $t2, 0($0)       # Mem[0] = 17
lw   $t7, 0($0)       # $t7 = Mem[0] = 17
beq  $t0, $t0, -1     # branch to self (infinite loop)
```

To use a different program, edit the `initial` block in `instr_memory.sv` with your own 32-bit machine code words.

---

## Modifying the Design

### Adding a new instruction

1. **Add the opcode case** in `control_unit.sv` with the correct signal values.
2. **Add funct decoding** in `alu_control.sv` if it is a new R-type variant.
3. **Encode the instruction** in `instr_memory.sv` to test it.
4. **Add a check** in `tb_mips_top.sv` for the expected result.

### Changing the target device

In Quartus: Assignments → Device → select a new device.
Update the device line in the `.qsf` file:
```
set_global_assignment -name DEVICE <NEW_DEVICE_CODE>
```

---

## Regenerating the Reports

The Python scripts rebuild the Word documents from scratch (they do **not** embed screenshots automatically — screenshots must be inserted manually after generation):

```bash
# Part I report
python generate_report.py

# Part II report
python generate_report_part2.py

# Combine into one final document
python combine_reports.py
```

Output files:
- `MIPS_Project_Report_CE80665.docx` — Part I
- `MIPS_Project_Report_Part2_CE80665.docx` — Part II
- `MIPS_Project_FINAL_CE80665.docx` — Final combined submission

> **Note:** After regenerating, re-insert all screenshots captured from RTL Viewer, Technology Map Viewer, TimeQuest, and ModelSim into the placeholder figure locations in the document.

---

## Known Issues and Notes

- **addi support:** The original P&H single-cycle design does not include `addi` in the control truth table. This implementation adds it explicitly in `control_unit.sv` (opcode `001000`, ALUOp=`00`, ALUSrc=1, RegWrite=1).
- **Quartus Web Edition limits:** The free Web Edition caps device size; EP4CE115F29C7 fits within the free tier.
- **ModelSim netlist simulation:** Direct `quartus_eda` netlist export for Cyclone IV E requires ModelSim-Altera bundled edition. Run the `.do` scripts from the ModelSim-Altera console, not a standalone ModelSim installation.
- **Page numbers in Word:** The footer uses a `{ PAGE }` field inserted via python-docx OxmlElement — it renders correctly when the document is opened in Microsoft Word, not in LibreOffice.

---

## References

- Patterson, D. A. & Hennessy, J. L. *Computer Organization and Design*, 5th ed. — Appendix B (single-cycle MIPS datapath and control)
- Altera Cyclone IV E Device Handbook
- Intel Quartus II 13.1 Handbook
