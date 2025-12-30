%% velocity_measurement.m
%% Signal matrix for Doppler processing
% Initialize matrix to store the fast-time samples at each pulse (slow-time axis)
signalMatrix = zeros(nWindow, nDoppler);

% Dechirp the received signal by mixing with the transmitted signal
mix = tx .* conj(rx(:, 1:nSample));

% FFT length for Doppler processing (slow-time FFT)
nFftDoppler = zeroPad * nDoppler;

% Extract the relevant fast-time slice from each pulse and store in signalMatrix
for m = 1:nDoppler
    % Only use the part of the signal corresponding to the selected slice (from RTT_max to T_chirp)
    signalMatrix(:, m) = mix(m, nSlice+1:nSample).';
end

%% Process targets
% Initialize matrix to store Doppler magnitude for each detected target
dopplerTotalMagnitude = zeros(length(peakRanges), nFftDoppler);

for targetIdx = 1:length(peakRanges)
    % Map the detected range of the target to the corresponding fast-time sample index
    rangeBin = round(2*peakRanges(targetIdx)/c * fSample) - nSlice + 1;
    rangeBin = max(1, min(rangeBin, nWindow));
    dopplerSignal = signalMatrix(rangeBin, :);

    % Perform FFT across pulses to compute Doppler spectrum
    dopplerFft = fft(dopplerSignal, nFftDoppler);
    dopplerFft = fftshift(dopplerFft);

    % Compute magnitude of Doppler spectrum
    dopplerMag = abs(dopplerFft);

    % Store Doppler magnitude for this target
    dopplerTotalMagnitude(targetIdx, :) = dopplerMag;
end

%% Axes
% Doppler frequency resolution
fStepDoppler = prf / nFftDoppler;

% Create Doppler frequency axis (centered at zero)
fAxisDoppler = (-prf/2 : fStepDoppler : prf/2 - fStepDoppler);

% Convert Doppler frequency to velocity
vAxis = -fAxisDoppler * wavelength / 2;
