%% plots.m
%% signal_generation.m
% Plot 1: Single Tx
figure(1);
plot(tVectorMicro, real(p), 'b', 'LineWidth', 2);
xlabel('Time (us)');
ylabel('Amplitude');
title('Single Tx');
grid on;
xlim([0, tVectorMicro(end)]);

% Plot 2: Single Rx
figure(2);
plot((0:nPri-1)*tSample*1e6, real(rx(1,:)), 'r', 'LineWidth', 1.5);
xlabel('Time (us)');
ylabel('Amplitude');
title('Received Signal (First Pulse)');
grid on;
xlim([0, pri*1e6]);

% Plot 3: Pulse train Tx
figure(3);
t4Pri = (0:(4*nPri)-1) * tSample * 1e6;
tx4Pri = zeros(1, 4*nPri);
for pulse = 0:3
    startIdx = pulse * nPri + 1;
    endIdx = startIdx + nSample - 1;
    tx4Pri(startIdx:endIdx) = p;
end
plot(t4Pri, real(tx4Pri), 'b', 'LineWidth', 2);
xlabel('Time (us)');
ylabel('Amplitude');
title('Pulse train Tx');
grid on;
xlim([0, 4*pri*1e6])

% Plot 4: Pulse train Rx
figure(4);
t4Pri = (0:(4*nPri)-1) * tSample * 1e6;
rx4Pulses = reshape(rx(1:4,:)', 1, []);
plot(t4Pri, real(rx4Pulses), 'r', 'LineWidth', 1.5);
xlabel('Time (us)');
ylabel('Amplitude');
title('Pulse train Rx');
grid on;
xlim([0, 4*pri*1e6]);

%% range_measurement.m
% Plot 5: FFT range
figure(5);
plot(rPlot, mPlot, 'b', 'LineWidth', 2);
hold on;
if exist('thresholdCFAR', 'var')
    plot(rPlot, thresholdCFAR, 'k--', 'LineWidth', 1.5);
else
    plot([min(rPlot) max(rPlot)], [thresholdValue thresholdValue], 'k--', 'LineWidth', 1);
end
for k = 1:length(range)
    plot([range(k) range(k)], ylim(), 'r--', 'LineWidth', 1);
end
if ~isempty(peaks)
    plot(peakRanges, peaks, 'ro', 'MarkerSize', 8, 'LineWidth', 2);
end
hold off;
xlabel('Range (m)');
ylabel('Amplitude');
title('FFT Range Profile');
grid on;
xlim([0 max(range)*1.5]);

%% velocity_measurements.m
% Plot 6: FFT velocity
figure(6);
hold on;
for targetIdx = 1:length(peakRanges)
    plot(vAxis, dopplerTotalMagnitude(targetIdx, :), 'LineWidth', 2);
    [~, trueIdx] = min(abs(peakRanges(targetIdx) - range));
    trueVel = velocity(trueIdx);
    searchRange = 1;
    searchMask = abs(vAxis - trueVel) < searchRange;
    if any(searchMask)
        maskedDoppler = dopplerTotalMagnitude(targetIdx, searchMask);
        [~, localPeakIdx] = max(maskedDoppler);
        fullIdx = find(searchMask);
        detectedVel = vAxis(fullIdx(localPeakIdx));
        detectedAmp = maskedDoppler(localPeakIdx);
    else
        [detectedAmp, peakIdx] = max(dopplerTotalMagnitude(targetIdx, :));
        detectedVel = vAxis(peakIdx);
    end
    plot([detectedVel detectedVel], [0 detectedAmp], 'r--', 'LineWidth', 1.5);
    plot(detectedVel, detectedAmp, 'ro', 'MarkerSize', 8, 'LineWidth', 2);
end
hold off;
grid on;
xlabel('Velocity (m/s)');
ylabel('Amplitude');
title('Doppler Spectrum');

%% range_doppler.m
% Plot 7: 2D FFT range doppler
figure(7);
imagesc(dopplerAxis, rangeAxis, rangeDopplerDB);
xlabel('Velocity (m/s)');
ylabel('Range (m)');
title('Range-Doppler Map');
colorbar;
axis xy;
xlim([-110 110]);
ylim([0 300]);
hold on;
for targetIdx = 1:length(peakRanges)
    [~, trueIdx] = min(abs(peakRanges(targetIdx) - range));
    trueVel = velocity(trueIdx); 
    detectedRange = peakRanges(targetIdx);
    plot(trueVel, detectedRange, 'ro', 'MarkerSize', 10, 'LineWidth', 2);
end
hold off;

%% Saving plots
%{
for i = 1:7
    figure(i);
    saveas(gcf, sprintf('plots/plot_%d.png', i));
end
%}