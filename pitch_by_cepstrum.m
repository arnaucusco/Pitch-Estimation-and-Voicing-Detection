function [ f0 ] = pitch_by_cepstrum( frame , sample_rate )

    window=hamming(length(frame));
    frame=frame.*window;
    cepstrum=ifft(log(abs(fft(frame))));
    %cepstrum is symmetric
    cepstrum=cepstrum(1:length(cepstrum)/2);
    %liftering
    liftering_window=zeros(length(cepstrum),1);
    liftering_window(ceil(sample_rate/600):end)=1;
    [~,a]=max(cepstrum.*liftering_window);
    f0=sample_rate/a;
end
