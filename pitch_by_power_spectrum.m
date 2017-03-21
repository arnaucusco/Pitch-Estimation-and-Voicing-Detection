function [ f0 ] = pitch_by_power_spectrum( frame , sample_rate )

    window=hamming(length(frame));
    frame=frame.*window;
    pow_spec=abs(fft(frame)).^2;
    %It is simetric
    pow_spec=pow_spec(1:length(pow_spec)/2);
    pow_spec_autocorr=xcorr(pow_spec,pow_spec);
    %It is simetric
    pow_spec_autocorr=pow_spec_autocorr(ceil(length(pow_spec_autocorr)/2):end);
    [peaks,peaks_pos] = findpeaks(pow_spec_autocorr,'MinPeakheight',0.3*pow_spec_autocorr(1));
    if length(peaks_pos)<1
        f0=0;
    else
        [~,peaks_indices]=sort(peaks,'descend');
        f0=(peaks_pos(peaks_indices(1))-1)*sample_rate/length(frame);
        
    end
end