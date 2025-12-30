%% range_measurement.m
%% FFT
tic;
% Dechirp received signal by mixing transmitted and received signals
mix = tx .* conj(rx(:, 1:nSample));

% Select first pulse for range estimation (fast-time processing)
firstPulse = mix(1, nSlice+1:nSample);

% Zero padding to increase FFT resolution
nFft = zeroPad*length(firstPulse);

% Perform FFT on dechirped signal
fftX = fft(firstPulse, nFft);
fftX = fftshift(fftX);

% Magnitude of FFT result
fftMag = abs(fftX);

% Measure processing time
processingTime = toc;

%% Axes
% Frequency resolution
fStep = fSample/nFft;

% Frequency axis centered around zero
fAxis = (-fSample/2 : fStep : fSample/2-fStep);

% Convert beat frequency to range
rAxis = fAxis * c/(2*slope);

% Keep only positive range values
positiveIdx = rAxis >= 0;
rPlot = rAxis(positiveIdx);
mPlot = fftMag(positiveIdx);

%% CFAR detection
% Number of guard cells
nGuard = 4;

% Number of training cells
nTrain = 32;

% Probability of false alarm
pfa = 1e-2;

% Create CFAR detector
cfarDetector = phased.CFARDetector('NumGuardCells', nGuard, 'NumTrainingCells', nTrain, ...
'ProbabilityFalseAlarm', pfa, 'Method', 'CA', 'ThresholdOutputPort', true);

% Apply CFAR detector to range profile
detections = step(cfarDetector, mPlot', 1:length(mPlot));

% Mask non-detected cells
thresholdCFAR = mPlot;
thresholdCFAR(~detections) = NaN;

% Find peaks corresponding to detected targets
[peaks, locs] = findpeaks(thresholdCFAR, 'MinPeakDistance', 3);

% Convert detected peak indices to range values
peakRanges = rPlot(locs);
