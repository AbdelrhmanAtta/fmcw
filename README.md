# FMCW Radar Simulation with Idle Time

A MATLAB-based simulation of a **pulsed FMCW radar** system. This project implements the full signal processing chain—from waveform generation to 2D Range-Doppler processing—to estimate the position and radial velocity of multiple moving targets in the presence of noise.



## Features
* **Pulsed FMCW Waveform:** Includes configurable idle time between linear frequency ramps (chirps).
* **Multi-Target Environment:** Simulates multiple moving targets with distinct ranges, velocities, and Radar Cross Sections (RCS).
* **Range Estimation:** High-resolution range processing using 1D FFT and **CA-CFAR** (Cell Averaging Constant False Alarm Rate) for robust detection.
* **Velocity Estimation:** Doppler FFT across the slow-time dimension to resolve target radial speed.
* **2D Range-Doppler Map:** Full visualization of the target environment in the Range-Velocity plane.
* **Noise Modeling:** Realistic AWGN (Additive White Gaussian Noise) integration and SNR control.
* **Performance Reporting:** Automatic calculation of estimation errors, processing time, and motion classification.

---

## Repository Structure

| File | Description |
| :--- | :--- |
| `main.m` | The entry point script that orchestrates the entire simulation. |
| `radar_specs.m` | Defines radar hardware parameters (Frequency, BW, Idle Time). |
| `targets_definition.m` | Configures target initial positions, velocities, and RCS. |
| `signal_generation.m` | Generates the transmitted and received (IF/beat) signals. |
| `range_measurement.m` | Performs the first FFT and CFAR detection logic. |
| `velocity_measurement.m` | Processes the Doppler shift to extract target velocities. |
| `range_doppler.m` | Computes the 2D Range-Doppler FFT matrix. |
| `plots.m` | Handles all visualization (Time domain, FFT, 2D Maps). |
| `reports.m` | Prints metrics and errors to the MATLAB Command Window. |

---

## Radar Parameters (Summary)

The simulation defaults to parameters typical for **77GHz Automotive Radar**:

* **Carrier Frequency:** 76.5 GHz
* **Bandwidth:** 1 GHz
* **Chirp Duration ($T_{chirp}$):** 2.1 µs
* **Pulse Repetition Interval (PRI):** 8.4 µs (includes Idle Time)
* **Range Resolution:** 0.15 m
* **Max Range:** 250 m
* **Number of Chirps:** 512
* **SNR:** 5 dB

---

## Processing Pipeline



1.  **Signal Generation:** The beat signal is created by mixing the transmitted signal with the delayed, Doppler-shifted reflections.
2.  **Range FFT:** An FFT is performed across each chirp (fast-time) to identify frequency peaks corresponding to range.
3.  **CA-CFAR Detection:** A sliding window detector adaptively sets a noise threshold to identify targets while maintaining a constant false alarm rate.
4.  **Doppler FFT:** A second FFT is performed across the chirps (slow-time) for each range bin to resolve velocity.
5.  **Reporting:** Extraction of final estimates and comparison against ground truth.

---

## How to Run

1.  Open **MATLAB**.
2.  Navigate to the project folder.
3.  Execute the main script:
    ```matlab
    main
    ```
4.  **Outputs:** All figures will be generated automatically, and a summary report will be printed in the Command Window.

---

## Notes
* **Algorithm Validation:** Designed for testing signal processing logic and CFAR performance.
* **No Antenna Array:** This version assumes a single TX/RX antenna; angle estimation (AoA) is not included.
* **Zero-Padding:** Applied during FFT stages to improve visualization resolution.

**Author:** A. Atta  
**Date:** Dec 2025