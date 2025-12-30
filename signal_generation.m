%% signal_generation.m
%% Transmitted signal generation
p = exp(1j * 2*pi*(bpFmin*tVector + 0.5*slope*(tVector.^2)));

%% Generate Tx
% Repeat the chirp nDoppler times to form the transmitted matrix
tx = repmat(p, nDoppler, 1);

%% Generate Rx
% Initialize received signal matrix
rx = zeros(nDoppler, nPri);

% Loop over each pulse (slow-time axis)
for m = 0:nDoppler-1
    % Loop over each target
    for k = 1:length(range)
        % Compute instantaneous target range considering velocity
        currentRange = range(k) + velocity(k) * m * pri;

        % Compute amplitude
        rangeAmplitude = amplitude(k);

        % Time delay of the echo (two-way propagation)
        tau = 2*currentRange/c;

        % Convert time delay to sample index
        samplesDelay = round(tau * fSample);

        % Doppler frequency for moving target
        fDoppler = 2*velocity(k)/wavelength;

        % Phase term due to Doppler, includes both slow-time (m*pri) and fast-time (tVector)
        phase = exp(1j*2*pi*fDoppler*m*pri) .* exp(1j*2*pi*fDoppler*tVector);

        % Determine start and end indices of the received chirp in Rx
        startIdx = samplesDelay + 1;
        endIdx = startIdx + nSample - 1;

        % Add target contribution to Rx only if it fits in the current pulse
        if endIdx <= nPri
            availableLength = nPri - startIdx + 1;
            chirpToAdd = p(1:min(nSample, availableLength));
            phaseToAdd = phase(1:min(nSample, availableLength));

            % Add scaled and Doppler-shifted chirp to Rx
            rx(m+1, startIdx:startIdx+length(chirpToAdd)-1) = ...
                rx(m+1, startIdx:startIdx+length(chirpToAdd)-1) + ...
                rangeAmplitude * chirpToAdd .* phaseToAdd;
        end
    end
end

%% Add noise
% Compute average signal power
signalPower = mean(abs(rx(:)).^2);

% Compute noise power based on desired SNR
noisePower = signalPower / (10^(snr/10));

% Generate complex Gaussian noise
noise = sqrt(noisePower/2) * (randn(size(rx)) + 1j*randn(size(rx)));

% Add noise to received signal
rx = rx + noise;
