function [ out, num_beats ] = loopit( audio, sr, num_beats, tempo, overunder )
%LOOPIT Truncates partial beats or pads rest of beat at end of loop to make
% a smoover loop
%
%   Inputs:
%   audio - vector; contains time series information
%   sr - int; sample rate of audio
%   num_beats - float; number of beats in audio
%   tempo - int; tempo of audio
%   overunder - bool; determines whether to pad or truncate audio
%
%   Outputs:
%   out - vector; padded or truncated audio
%   num_beats - int; new number of beats

    base_num_samples = floor(sr*60*4/(tempo));

    if overunder == 1
    % Over case: truncate
        reps = floor(num_beats)/4;
        num_samples = reps*base_num_samples;
        out = audio(1:num_samples);
        num_beats = floor(num_beats);
    else
    % Under case: pad
        reps = ceil(num_beats)/4;
        num_samples = reps*base_num_samples;
        rem_samples = num_samples-length(audio);
        if (rem_samples < 0)    % weird corner case
            out = audio(1:num_samples);
        else                    % should go here most of the time
            out = [audio; zeros(rem_samples,1)];  
        end
        num_beats = ceil(num_beats);
    end
    
end

