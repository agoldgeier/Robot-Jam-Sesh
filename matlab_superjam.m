%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DST II - Spring 2016
% Aviv Goldgeier - arg450
% Final Project: MATLAB SUPERJAM
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

loops = dir('loops');
loops = {loops.name};

% Pick a head (starting from 3)
head_num = 5;
[head_audio, sr] = audioget(strcat('loops/',char(loops(head_num))));
[head_audio, tempo, offset, num_beats, overunder] = analyze_loop(head_audio, sr, false);
[loop_audio, num_beats] = loopit(head_audio, sr, num_beats, tempo, overunder);

total_beats = 16;
reps = total_beats/num_beats;
out = loop_audio;
for i = 1:reps-1
    out = [out; loop_audio];
end

% Add some spice
out2 = prepareloop(strcat('loops/',char(loops(7))), sr, tempo, total_beats);
out3 = prepareloop(strcat('loops/',char(loops(4))), sr, tempo, total_beats);
out4 = prepareloop(strcat('loops/',char(loops(6))), sr, tempo, total_beats);
out5 = prepareloop(strcat('loops/',char(loops(3))), sr, tempo, total_beats);
out6 = prepareloop(strcat('loops/',char(loops(8))), sr, tempo, total_beats);
out7 = prepareloop(strcat('loops/',char(loops(10))), sr, tempo, total_beats);

% Put it all together
outout = out+out2+out3+out4+out5+out6+out7;

soundsc(outout, sr);