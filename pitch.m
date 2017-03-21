%Input parameters
windowlength=32; %in ms
data_directory='./data/';
%Import filelist (a file with the list of files to process without the .wav extension)
x=1;%Diferent frame positions will be taken depending on the filelist
if x>0
    filelist_id = fopen( 'pda_ue.gui', 'r' ); %test frame shift = 15 ms sampling rate = 20KHz
    frameshift=15;
else
    filelist_id = fopen( 'ptdb_tug.gui', 'r' ); %train frame shift = 10 ms sampling rate = 48KHz
    frameshift=10;
end
filenames = textscan( filelist_id, '%s', 'Delimiter', '\n' );
filenames=filenames{1,1};
[~] = fclose( filelist_id );

% For each file
for nfile=1:length(filenames)
    %Read audio
    [samples,sample_rate] = audioread(strcat(data_directory,filenames{nfile},'.wav'));
    ns_windowlength = round(windowlength * sample_rate / 1000);
    ns_framelength = round(frameshift * sample_rate / 1000);
    %Create output file
    file_id=fopen(strcat(data_directory,filenames{nfile},'.f0'),'w');
    %Decide frames
    if x>0
        frame_center = 1:ns_framelength:length(samples);
        frame_start=frame_center-floor(ns_windowlength/2);
    else
        frame_start = 1 : ns_framelength : length(samples)-ns_framelength+1;
    end
    
    %for each frame
    for i=1:length(frame_start)
        frame_end=frame_start(i)+ns_windowlength-1;
        if frame_start(i)<=0
            frame=[zeros(1-frame_start(i),1);samples(1:frame_end)];
        elseif frame_end>length(samples)-ns_windowlength/2;
            frame=[samples(frame_start(i):length(samples));zeros(frame_end-length(samples),1)];
        else
            frame=samples(frame_start(i):frame_end);
        end
        %Preprocessing
        power=sum(frame.*frame)/length(frame)/sample_rate;
%         zcd = dsp.ZeroCrossingDetector;
%         frame_zero_crossings=step(zcd,frame);
        if power<1.6e-09
            f0=0;
        else
            frame  = center_clipping( frame , 0.3);
            %Time domain
            f0  = pitch_by_autocorrelation( frame , sample_rate );
%             f0 = pitch_by_magnitude_difference( frame , sample_rate );
            %Frequency domain
%             f0 = pitch_by_cepstrum( frame , sample_rate );
%             f0 = pitch_by_power_spectrum( frame , sample_rate );
            %Postprocessing
            if f0 < 50 || f0 > 550
                f0=0;
            end
        end
        %Write result
        fprintf(file_id,'%.6g\n',f0);
    end
    fclose(file_id);
end