function [ tempo ] = get_tempo( filename )
%GET_TEMPO Finds the tempo in a filename.
% Specific to Loopmasters Sample library, in which all tempos are the first instance of the
% pattern "_###?" in the filename.
%
%   Input:
%   filename - string
%
%   Output:
%   tempo - number as found in filename

    expression = '_\d{2,3}';
    matches = char(regexp(filename,expression,'match'));
    matchStr = matches(1,:);
    tempo = str2double(matchStr(2:end));
end

