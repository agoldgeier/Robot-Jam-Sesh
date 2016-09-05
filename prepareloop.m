function [ out ] = prepareloop( filename, sr, tempo, total_beats )
%PREPARELOOP Performs entire pipeline of detecting tempo, shifting to new
%tempo, and looping to a desired number of beats
%   
%   Inputs:
%   filename - string
%   sr - int; sample rate of audio
%   tempo - int
%   total_beats - int; number of desired beats for final audio output
%
%   Output:
%   out - vector containing final looped audio

    [audio, ~] = audioget(filename, sr);
    [audio, this_tempo, this_offset, this_num_beats, overunder] = analyze_loop(audio, sr, false);
    shifted = timeshift( audio, this_tempo, tempo );
    % TRUNCATE TO INT NUMBER OF BEATS FO MO BETTA LOOPING
    [loop_audio, this_num_beats] = loopit(shifted, sr, this_num_beats, tempo, overunder);
    
    reps = total_beats/this_num_beats;
    out = loop_audio;
    for i = 1:reps-1
        out = [out; loop_audio];
    end

end

