function [ audio, tempo, offset, num_beats, overunder ] = analyze_loop( audio, sr, harmonic )
%ANALYZE_LOOP Get qualities of a loop
%   Inputs:
%   audio - 1xN array; the audio to analyze
%   sr - int; sample rate
%   harmonic - boolean; whether or not to look for harmonic information
%
%   Outputs:
%   audio - 1xN* array; the audio, potentially repeated
%   tempo - int; detected tempo
%   offset - int; number of seconds at which loop starts. Assumed to be
%   zero.
%   num_beats - int; the number of beats in the output audio
%   overunder - bool; determines padding method when looping

    %%% Do autocorrelation to determine tempo
    
    % Determine range of samples: 60-200 BPM should be sufficient, assume
    % 4/4. 
    % 1 bar = 4 beats = 4/(BPM) min = 240/BPM s = 240*sr/BPM samples
    max_tempo = 200;
    min_tempo = 60;
    min_lag = floor(240*sr/max_tempo);
    max_lag = ceil(240*sr/min_tempo);

    % If length is less than max lag, rep
    if length(audio) < max_lag
        audio = [audio; audio];
    end
    
    tempos = min_tempo:max_tempo;
    lags = 240*sr./tempos;
    acf = zeros(1, length(lags));
    for i = 1:length(acf)
        l = lags(i);
        acf(i) = audio(1:l+1)'*audio(end-l:end);
    end
    
    % To find tempo, we want the highest acf that also divides the loop 
    % into a number of beats that is a power of 2. Check just top 5.
    % Details: the score is the acf*(1-(distance from an integer remainder))
    [pks, locs] = findpeaks(acf);
    sorted_abonimation = flipud(sortrows([pks;locs]'))';
    score = 0;
    for i = 1:5
        this_tempo = tempos(sorted_abonimation(2,i));
        this_num_beats = length(audio)/(60*sr/this_tempo);
        inv_remainder = rem(log2(this_num_beats),1);
        if inv_remainder < 0.5
            this_overunder = 1;
            inv_remainder = 1-inv_remainder; % there's definitely a more clever way of doing this
        else
            this_overunder = -1;
        end
        % Weight by original acf
        weighted_remainder = inv_remainder*sorted_abonimation(1,i);
        if weighted_remainder > score
            score = weighted_remainder;
            tempo = this_tempo;
            num_beats = this_num_beats;
            overunder = this_overunder;
        end
    end

    offset = 0;
    
end

