function [ stats ] = get_stats( label, predicted )
%GET_STATS Helper function to evaluate method
%   
%   Inputs:
%   label - MxN array; annotations
%   predicted - MxN array; predictions
%
%   Output:
%   stats - 3x1 array; [# correct answers, # half- and double-tempo errors,
%   # off by one errors]
    num_correct = sum(label==predicted);
    num_mult = sum(label==predicted/2 | label==predicted*2);
    num_off = sum(abs(label-predicted) < 2 | abs(label-2*predicted) < 2 | abs(2*label-predicted<2))-num_mult-num_correct;
    stats = [num_correct num_mult num_off];
end

