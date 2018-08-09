# Implementation-of-SDRAM-interface-with-a-parallel-bus-in-Verilog
## Introduction
Following picture shows the data-path and the controller of the SDRAM bus interface. Prior to operating SDRAM, each ten-bit
wide bus interface register containing the precharge (tPRE), CAS (tCAS ), burst (tBURST), latency (tLAT), and wait (tWAIT)
periods must be programmed through a 10-bit program bus.
To implement this diagram, we divided this whole diagram into 4 parts: the Addr module handles address logic; the Delay
module performs the down-counter; Control module is the bus interface; and SDRAM module provides data read and write
media.
## Implementation
### Test module
This module is used for initializing all data. Specificlly, it initializes the Status = 1, Write = 1, clock signal, ProgramData,
Addr 32, WData and Burst.
For more details, please refer to our implementation code Test.v.
![truth table](https://user-images.githubusercontent.com/27938420/43930421-2029d9ae-9bee-11e8-9687-9682be684da3.png)
## Target Output
### For read
![read cycle](https://user-images.githubusercontent.com/27938420/43930887-aab32862-9bf0-11e8-8822-a4341b759f3e.png)
![state diagram for read](https://user-images.githubusercontent.com/27938420/43930947-efc1ce9a-9bf0-11e8-8199-fb972160e22b.png)
### For write
![write cycle](https://user-images.githubusercontent.com/27938420/43930986-13cb02fc-9bf1-11e8-850e-a7842dba2949.png)
![state diagram for write](https://user-images.githubusercontent.com/27938420/43930966-ff8ee3bc-9bf0-11e8-8329-47c166cbaf46.png)
