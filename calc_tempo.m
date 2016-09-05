function [ predicted ] = calc_tempo( filename )
%CALC_TEMPO Predicts the tempo of a piece of audio using both naive and
%loop-aware ACF
%   Input:
%   filename - string
%
%   Output:
%   predicted - 2-length array; Predicted(1) is the result from naive ACF.
%   Predicted(2) is from loop-aware ACF.

    filename
    [audio, sr] = audioget(strcat('test_loops/',filename));

    % Method 1: Vanilla ACF
    max_tempo = 200;
    min_tempo = 60;
    min_lag = floor(240*sr/max_tempo);
    max_lag = ceil(240*sr/min_tempo);

    % If length is less than max lag, rep
    while length(audio) < max_lag+1
        audio = [audio; audio];
    end
    
    tempos = min_tempo:max_tempo;
    lags = 240*sr./tempos;
    acf = zeros(1, length(lags));
    for i = 1:length(acf)
        l = lags(i);
        acf(i) = audio(1:l+1)'*audio(end-l:end);
    end
    
    
    % Method 2: Loop-aware ACF
    [pks, locs] = findpeaks(acf);
    sorted_abonimation = flipud(sortrows([pks;locs]'))';
    score = 0;
    for i = 1:5
        this_tempo = tempos(sorted_abonimation(2,i));
        this_num_beats = length(audio)/(60*sr/this_tempo);
        inv_remainder = rem(log2(this_num_beats),1);
        if inv_remainder < 0.5
            inv_remainder = 1-inv_remainder; % there's definitely a more clever way of doing this
        end
        % Weight by original acf
        weighted_remainder = inv_remainder*sorted_abonimation(1,i);
        if weighted_remainder > score
            score = weighted_remainder;
            tempo2 = this_tempo;
        end
    end
    
    
    predicted = [0,0];
    predicted(1) = tempos(sorted_abonimation(2,1));
    predicted(2) = tempo2;

    

end

