# Verilog 8259 Programmable Interrupt Controller (PIC) Project

## Overview

This project aims to design and implement a Programmable Interrupt Controller (PIC) based on the 8259 architecture using Verilog hardware description language. The 8259 PIC is a crucial component in computer systems responsible for managing and prioritizing interrupt requests, facilitating efficient communication between peripherals and the CPU.

## Key Features

1. **8259 Compatibility:** The Verilog implementation closely emulates the behavior and features of the classic 8259 PIC, ensuring compatibility with existing systems and software.
2. **Programmability:** Support for programming interrupt priorities and modes, allowing users to configure the PIC according to specific requirements using Command Words (ICWs) and Operation Command Words (OCWs).
3. **Cascade Mode:** Implementation of the cascade mode enables multiple PICs to be interconnected to expand the number of available interrupt lines, enhancing scalability.
4. **Interrupt Handling:** Efficient handling of interrupt requests, including prioritization and acknowledgment mechanisms, ensures a timely and accurate response to various events.
5. **Interrupt Masking:** Ability to mask/unmask individual interrupt lines to control which interrupts are currently enabled.
6. **Edge/Level Triggering:** Support for both edge-triggered and level-triggered interrupt modes to accommodate different types of peripherals.
7. **Fully Nested Mode:** Implementation of Fully Nested Mode allows the PIC to automatically set the priority of the CPU to the highest priority interrupt level among the currently serviced interrupts.
8. **Automatic Rotation:** Extension of the priority handling mechanism to support automatic rotation even in scenarios where lower-priority interrupts are being serviced.
9. **EOI Functionality:** Implementation of End of Interrupt (EOI) functionality allows the PIC to signal the end of interrupt processing to the CPU.
10. **AEOI Functionality:** Automatic End of Interrupt (AEOI) functionality enables the PIC to automatically signal the end of interrupt processing to the CPU.
11. **Reading 8259A Status:** Capability to read the status of the 8259A PIC.
12. **Simulation and Testing:** Comprehensive testbench development for simulating and validating the functionality of the Verilog-based 8259 PIC. This includes testing various interrupt scenarios and ensuring proper interaction with other system components.
13. **Documentation:** Thorough documentation detailing the design specifications, module functionalities, and usage guidelines to facilitate understanding and future development.

## Getting Started

To get started with this project, follow these steps:
1. Clone the repository to your local machine.
2. Navigate to the `src/` directory to access the Verilog source files.
3. Use a Verilog simulator to compile and simulate the design. 

## Contributors

- [Rana Mohamad Ahmad](https://github.com/RanaMohamad21).
- [Mennatallah](https://github.com/Mennatallah74).
- [Somaya Ayman](https://github.com/Somaya-Ayman).
- [Sara Ashraf](https://github.com/Saraashrf).
- [Maya](https://github.com/MightyMaya)



