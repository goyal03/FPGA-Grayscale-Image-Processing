# FPGA-Based Grayscale Image Processing using VHDL and VGA

This project implements **grayscale conversion of a color image on an FPGA** using **VHDL**, with the output displayed on a **VGA monitor**. The design demonstrates a complete image processing pipeline implemented in hardware, including memory initialization, pixel-level processing, VGA signal generation, and user control via a push button.

The system is implemented on the **Nexys 4 DDR FPGA development board** and focuses on understanding how image data can be processed and displayed in real time using digital hardware.

---

## Project Purpose

The goal of this project is to gain hands-on experience with:

- Hardware-based image processing using VHDL
- Block RAM (BRAM) initialization using `.coe` files
- VGA signal generation and timing
- FPGA-based control logic using push buttons
- End-to-end integration of software preprocessing and hardware execution

This project serves as a foundational step toward more advanced FPGA-based image and video processing systems.

---

## How the Project Works

### Image Preparation
A color image is first processed using a software script to extract RGB pixel values. These values are converted into a binary format and stored in a `.coe` file, which is used to initialize the FPGA’s Block RAM during synthesis.

### Memory Storage
The `.coe` file is loaded into on-chip Block RAM configured as read-only memory. Each memory location corresponds to a pixel’s RGB data.

### Grayscale Conversion
Inside the FPGA, a custom VHDL module reads RGB pixel values from Block RAM and converts them into grayscale. The grayscale value is computed by averaging the red, green, and blue components of each pixel.

### VGA Display
A VGA controller implemented in VHDL generates the required **HSYNC** and **VSYNC** signals according to the 640×480 @60Hz VGA standard. The grayscale pixel values are mapped to the VGA RGB outputs so that the image appears in grayscale on the monitor.

### User Control
A push button on the FPGA board is used to trigger the image display. Button debouncing logic is implemented in hardware to ensure reliable operation.

---

## Implementation Details

- The FPGA operates using a **25 MHz pixel clock**, derived from the onboard 100 MHz clock.
- VGA timing (front porch, sync pulse, back porch, and active video region) is handled using horizontal and vertical counters.
- All logic, including VGA control and button debouncing, is implemented manually in VHDL without relying on external IP cores.
- The system is designed in a modular manner and integrated using a top-level VHDL entity.

---

## Results

- The grayscale version of the original color image is displayed correctly on a VGA monitor.
- VGA output is stable and flicker-free at 640×480 resolution.
- Grayscale conversion produces consistent and accurate results.
- The system responds reliably to user button input.

---

## Applications and Extensions

This project demonstrates key concepts used in:

- FPGA-based image and video processing
- Embedded vision systems
- Hardware acceleration of multimedia tasks

It can be extended to support real-time camera input, more advanced image processing algorithms, or higher-resolution video output.
