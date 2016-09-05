function [ out ] = timeshift( audio, in_tempo, out_tempo )
%TIMESHIFT Stretches or compresses audio without affecting pitch.
%
%   Inputs:
%   audio - vector with time series data
%   in_tempo - number. original tempo of audio
%   out_tempo - number. desired tempo of audio
%
%   Output:
%   out - vector containing time-streched audio data

    time_ratio = in_tempo/out_tempo;
    buf_len = 1024;     % samples
    hop_len = 256;      % samples
    audio_len = length(audio);
    out_len = ceil(time_ratio*audio_len) + 2*buf_len;
    out = zeros(out_len, 1);
    ham = hamming(buf_len);

    a = 0.1;    % randomization constant

    % Can't use built-in MatLab buffer. Let's wing it.
    i = 1;
    while 1   % <-- some high quality code right there
        % analysis
        base_i = hop_len*(i-1)+1;
        start_i = max(ceil(base_i + 2*a*(rand(1)-0.5)*buf_len),1);
        end_i = start_i + buf_len-1;
        buf = audio(start_i:end_i) .* ham;

        % synthesis
        syn_base_i = hop_len*time_ratio*(i-1)+1;
        syn_start_i = max(ceil(syn_base_i + 2*a*(rand(1)-0.5)*buf_len),1);
        syn_end_i = syn_start_i + buf_len-1;
        out(syn_start_i:syn_end_i) = out(syn_start_i:syn_end_i) +...
            buf;

        i = i + 1;
        % figure out terminating condition
        if hop_len*(i)+buf_len+1 > audio_len
            break;
        end
    end
    
    % Get back to original length
    out = out(1:ceil(time_ratio*audio_len));

end

