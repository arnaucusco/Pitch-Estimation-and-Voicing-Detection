function [ frame ] = center_clipping( frame , clipping_thresh)
%   This function remove the signal arround a cental limit arround ordinate
%   axis.
%	clipping_thresh is indicated as % from the maximum value of the signal.
%	Generally it is between 30%-50%

maximum_value=abs(max(frame));
for i=1:length(frame)
    if abs(frame(i)) <= clipping_thresh*maximum_value
        frame(i)=0;
    elseif frame(i) > clipping_thresh*maximum_value
        frame(i)=frame(i) - clipping_thresh*maximum_value;
    else
        frame(i)=frame(i) + clipping_thresh*maximum_value;
    end
end
end

