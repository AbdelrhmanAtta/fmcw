%% radar_specs.m
%% Constants
c = 3e8;  % Speed of light in m/s

%% Radar specifications
fCarrier = 76.5e9;                  % Carrier frequency (Hz)
wavelength = c / fCarrier;          % Radar wavelength (m)
pri = 8.4e-6;                       % Pulse Repetition Interval (s)
prf = 1/pri;                        % Pulse Repetition Frequency (Hz)
tChirp = 2.1e-6;                     % Chirp duration (s)
bw = 1e9;                            % Chirp bandwidth (Hz)
maxRange = 250;                      % Maximum detection range (m)
rttMax = 2*maxRange/c;               % Maximum round-trip time for the furthest target
maxSpeed = 100;                       % Maximum target speed (m/s)
rangeResolution = 0.75;              % Desired range resolution (m)
tSample = 0.4e-9;                     % ADC sampling interval (s)
fSample = 1/tSample;                  % Sampling frequency (Hz)
nDoppler = 512;                       % Number of pulses for Doppler processing
snr = 5;                              % Signal-to-noise ratio (dB)
zeroPad = 4;                          % Zero-padding factor for FFT

%% Derived params
nSample = round(tChirp * fSample);    % Number of fast-time samples per chirp
nPri = round(pri * fSample);          % Total samples per PRI
nIdle = nPri - nSample;               % Idle samples (between chirps)
tVector = (0:nSample-1)*tSample;     % Fast-time vector
slope = bw / tChirp;                  % Chirp slope (Hz/s)
bpFmin = -bw/2;                       % Minimum bandpass frequency (Hz)
bpFmax = bw/2;                        % Maximum bandpass frequency (Hz)
tVectorMicro = tVector * 1e6;        % Fast-time vector in microseconds
nSlice = round(rttMax * fSample);     % Slice index for maximum round-trip time
nWindow = nSample - nSlice;           % Number of valid samples for processing

% Maximum unambiguous measurements
maxUnambRange = c * pri / 2;          % Maximum unambiguous range (m)
maxUnambVel = wavelength * prf / 4;   % Maximum unambiguous velocity (m/s)