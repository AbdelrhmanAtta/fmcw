%% range_doppler.m
%% 2D FFT
rangeDoppler = fft2(signalMatrix, nFft, nFftDoppler);
rangeDoppler = fftshift(rangeDoppler, 2);
rangeDopplerMag = abs(rangeDoppler);
rangeDopplerDB = 20*log10(rangeDopplerMag + eps); % Convert magnitude to dB for visualization

%% Axes
rangeAxis = (0:nFft-1) * c/(2*slope) * (fSample/nFft);
dopplerAxis = (-nFftDoppler/2:nFftDoppler/2-1) * prf/nFftDoppler * wavelength/2;
dopplerAxis = -dopplerAxis;
