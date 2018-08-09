# Implementation-of-SDRAM-interface-with-a-parallel-bus-in-Verilog
## Introduction
Following picture shows the data-path and the controller of the SDRAM bus interface. Prior to operating SDRAM, each ten-bit
wide bus interface register containing the precharge (tPRE), CAS (tCAS ), burst (tBURST), latency (tLAT), and wait (tWAIT)
periods must be programmed through a 10-bit program bus.
![sdram bus interface block diagram](https://user-images.githubusercontent.com/27938420/43930237-3723f5fa-9bed-11e8-9242-63502583c7a6.png)
To implement this diagram, we divided this whole diagram into 4 parts: the Addr module handles address logic; the Delay
module performs the down-counter; Control module is the bus interface; and SDRAM module provides data read and write
media.
## Implementation
### Test module
This module is used for initializing all data. Specificlly, it initializes the Status = 1, Write = 1, clock signal, ProgramData,
Addr 32, WData and Burst.
For more details, please refer to our implementation code Test.v.
![truth table](https://user-images.githubusercontent.com/27938420/43930421-2029d9ae-9bee-11e8-9687-9682be684da3.png)
