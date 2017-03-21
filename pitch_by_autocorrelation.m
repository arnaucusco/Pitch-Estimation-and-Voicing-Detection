function [ f0 ] = pitch_by_autocorrelation( frame , sample_rate )

    frame = frame - mean(frame);
    autocorr=xcorr(frame,frame);
    %autocorr is symetric for real signals
    autocorr=autocorr(ceil(length(autocorr)/2):end);
    [peaks,peaks_pos] = findpeaks(autocorr,'MinPeakheight',0.1*autocorr(1));
    if length(peaks_pos)<1
        f0=0;
    else
        [~,peaks_indices]=sort(peaks,'descend');
        f0=sample_rate/(peaks_pos(peaks_indices(1))-1);
    end
end

