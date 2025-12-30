%% main.m
%  author: A.Atta
%  date: 14/12/2025
%  brief: FMCW radar simulation with idle time for range and velocity estimation
%  description: This script simulates an FMCW radar system with idle time
%               between chirps, generates signals with multiple moving targets,
%               processes the data using 2D FFT for range-velocity estimation,
%               and visualizes the detection results.
%  key features:
%    - FMCW with idle time (pulsed FMCW)
%    - Range and velocity estimation via range-Doppler processing
%    - Multiple target detection and tracking
%    - Performance metrics and visualization

%%
close all;
clc;
clear;

%% Modules
% Radar info, required specifications
radar_specs;
% Target definition
targets_definition;
% RX and TX signal generation
signal_generation;
% Range measurement via FFT
range_measurement;
% Velocity measurement via doppler analysis
velocity_measurement;
% 2D range-doppler map
range_doppler;
% All needed plots
plots;
% All needed printable reports
reports;