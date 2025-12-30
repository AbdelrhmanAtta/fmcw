%% reports.m
%% unambigus
fprintf('Maximum unambiguous range: %.1f m\n', maxUnambRange);
fprintf('Maximum unambiguous velocity: %.1f m/s\n', maxUnambVel);

%% range_measurement.m
fprintf('Detected ranges: \n');
for i = 1:length(peaks)
    fprintf('Peak %d: %.1f m\n', i, peakRanges(i));
end

fprintf('\nTarget ranges: \n');
for k = 1:length(range)
    fprintf('Target %d: %.1f m\n', k, range(k));
end

fprintf('\nProcess time: %.4f s\n', processingTime);
fprintf('======================\n');

%% velocity_measurement.m
fprintf('\nDetected velocities:\n');
for targetIdx = 1:length(peakRanges)
    [~, trueIdx] = min(abs(peakRanges(targetIdx) - range));
    trueVel = velocity(trueIdx);
    searchRange = 1;
    searchMask = abs(vAxis - trueVel) < searchRange;
    if any(searchMask)
        [localMax, localIdx] = max(dopplerTotalMagnitude(targetIdx, searchMask));
        fullIdx = find(searchMask);
        detectedVel = vAxis(fullIdx(localIdx));
    else
        [~, peakIdx] = max(dopplerTotalMagnitude(targetIdx, :));
        detectedVel = vAxis(peakIdx);
    end
    fprintf('  Target %d: %.1f m/s\n', targetIdx, detectedVel);
end

fprintf('\nTrue velocities:\n');
for targetIdx = 1:length(range)
    fprintf('  Target %d: %.1f m/s\n', targetIdx, velocity(targetIdx));
end

fprintf('\nVelocity errors:\n');
for targetIdx = 1:length(peakRanges)
    [~, trueIdx] = min(abs(peakRanges(targetIdx) - range));
    trueVel = velocity(trueIdx);
    searchRange = 0.5;
    searchMask = abs(vAxis - trueVel) < searchRange;
    if any(searchMask)
        [~, localIdx] = max(dopplerTotalMagnitude(targetIdx, searchMask));
        fullIdx = find(searchMask);
        detectedVel = vAxis(fullIdx(localIdx));
    else
        [~, peakIdx] = max(dopplerTotalMagnitude(targetIdx, :));
        detectedVel = vAxis(peakIdx);
    end
    errorVel = detectedVel - trueVel;
    fprintf('  Target %d: %.1f m/s\n', targetIdx, errorVel);
end

fprintf('\nDirection classification:\n');
for targetIdx = 1:length(range)
    if velocity(targetIdx) > 0
        fprintf('  Target %d: APPROACHING\n', targetIdx);
    elseif velocity(targetIdx) < 0
        fprintf('  Target %d: RECEDING\n', targetIdx);
    else
        fprintf('  Target %d: STATIONARY\n', targetIdx);
    end
end
fprintf('======================\n');



