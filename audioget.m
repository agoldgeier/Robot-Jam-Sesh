function [ audio, sr ] = audioget( filename, target_sr )
%AUDIOGET Audioread w/ extra processing
%
%   Inputs:
%   filename - string; filename for audio to read
%   target_sr - int; optional sample rate to resample to
%
%   Outputs:
%   audio - 1xN; mono audio, potentially resampled
%   sr - int; sample rate of audio. Equal to target_sr if supplied

    [audio, sr] = audioread(filename);
    audio = mean(audio, 2);
    
    if nargin == 2
        % resample to target
        audio = resample(audio, target_sr, sr);
        sr = target_sr;
    end
    
end

