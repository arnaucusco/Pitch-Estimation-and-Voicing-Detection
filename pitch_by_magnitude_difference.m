function [ f0 ] = pitch_by_magnitude_difference( frame , sample_rate )

    frame = frame - mean(frame);
    mag_diff=zeros(1,length(frame)+1);
    %It is simetric
    for i=1:length(frame)+1
        mag_diff(i)=sum(abs([frame ; zeros(i-1,1)]-[zeros(i-1,1) ; frame(1:end)]));
    end
    [peaks,peaks_pos] = findpeaks(mag_diff*-1);
    if length(peaks_pos)<1
        f0=0;
    else
        [~,peaks_indices]=sort(peaks,'descend');
        f0=sample_rate/(peaks_pos(peaks_indices(1))-1);
    end
end