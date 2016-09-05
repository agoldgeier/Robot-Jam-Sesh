% Script that quantitatively measures the effectiveness of various tempo detection
% methods

% Load dataset
test_loops = dir('test_loops');
test_loops = {test_loops.name};

num_test_loops = length(test_loops)-2; % Removing '.' and '..'
results = zeros(num_test_loops, 3); % label + 3 cols of pred

for i = 1:num_test_loops
    filename = char(test_loops(i+2));
    label = get_tempo(filename);    % Read tempo as written in filename
    predicted = calc_tempo(filename);
    results(i, :) = [label predicted]; % Can add more columns
end
%%

% Calculate stats
stats1 = get_stats(results(:,1),results(:,2));
stats2 = get_stats(results(:,1),results(:,3));

%%

% Scatterplot of predicted vs labels
hold off
hold
plot(60:200,60:200,'black');
plot(120:200,60:0.5:100,'black');
plot(60:100,120:2:200,'black');
scatter(results(:,1),results(:,2),50,'blue')
scatter(results(:,1),results(:,3),50,'red','d')
xlabel('Actual Tempo (BPM)');
ylabel('Predicted Tempo (BPM)');
title('Predicted vs. Actual Tempos');

%%

% Histogram of log(predicted/labels)
log_diff1 = log2(results(:,2)./results(:,1));
log_diff2 = log2(results(:,3)./results(:,1));
hist([log_diff1 log_diff2],50);
h = findobj(gca,'Type','patch');
