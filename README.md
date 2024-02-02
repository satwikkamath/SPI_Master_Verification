# SPI Master Verification Testbench

This repository contains a SystemVerilog verification testbench for an SPI (Serial Peripheral Interface) Master module. The testbench is designed to verify the functionality of the SPI Master by generating stimuli, driving transactions, monitoring the bus, and comparing results using a scoreboard.

## Table of Contents

- [Modules](#modules)
- [Testbench Execution](#testbench-execution)
- [Simulation](#simulation)

## Modules

### 1. `spi` Module

The SPI module is the DUT (Device Under Test) and implements the SPI Master functionality. It includes an FSM (Finite State Machine) for handling different states such as idle and send. The module generates the clock (sclk), chip select (cs), and MOSI (mosi) signals.

### 2. `driver` Class

The driver class is responsible for driving transactions into the SPI module. It includes tasks for resetting the driver and running transactions. The driver communicates with the SPI module through the virtual interface (vif).

### 3. `generator` Class

The generator class generates random transactions and sends them to the driver for execution. It includes tasks for running the generator and utilizes mailboxes for communication between components.

### 4. `monitor` Class

The monitor class monitors the SPI bus, capturing data on the MOSI line during transactions. It communicates with the scoreboard through a mailbox.

### 5. `scoreboard` Class

The environment class orchestrates the entire verification environment. It instantiates the generator, driver, monitor, and scoreboard, connecting them through mailboxes. The class includes tasks for pre-test setup, running the test, and post-test actions.

### 6. `environment` Class

The environment class orchestrates the entire verification environment. It instantiates the generator, driver, monitor, and scoreboard, connecting them through mailboxes. The class includes tasks for pre-test setup, running the test, and post-test actions.

### 7. `spi_if` Class

The virtual interface (spi_if) defines the signals used for communication between the testbench components and the SPI module.

### 8. `transaction ` Class

The transaction class defines the data structure representing SPI transactions. It includes fields for newd (new data), din (data in), cs (chip select), and mosi (Master Out Slave In). The class also includes display and copy functions.

## Testbench Execution

1. Initialize the virtual interface signals (`vif`).
2. Instantiate the SPI module (`spi`).
3. Instantiate the environment class (`environment`).
4. Configure the test parameters, such as the number of transactions, in the testbench.
5. Run the testbench, which will execute the SPI transactions and perform verification.

## Simulation

The testbench is designed for simulation using SystemVerilog simulation tools. The testbench produces a VCD (Value Change Dump) file for waveform analysis.

https://github.com/satwikkamath/SPI_Master_Verification/assets/107809929/63676325-e40a-4d04-9960-1810fede2663

