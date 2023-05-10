clear all;
clc;

% Define the folder containing the CSV files
folder_path = '/Users/a.hari/Downloads/new plots/dataset/'; 

% Get a list of all the CSV files in the folder
file_list = dir([folder_path '*.csv']);

% Create an empty matrix to store the power-law fit parameters of each file
pl_params = [];

% Loop through each file and extract the data
for i = 1:length(file_list)
    % Read in the CSV file
    file_path = [folder_path file_list(i).name];
    
    tbl = readtable(file_path, 'Delimiter', ',', 'HeaderLines', 1, 'Format', '%{dd/MM/yy HH:mm}D%f%f');
    tbl.Properties.VariableNames = {'DateTime', 'X_total', 'Z_total'};
    addpath(pwd);
    % Extract the x and z data
    x = tbl.X_total;

    % Remove zeros in x
    x = x(x ~= 0);   
    % Define the bins for the histogram
    bin_size = 13;
    bins = 0:bin_size:max(x) + bin_size;
    
    % Create the histogram
    image_dir_path = [folder_path 'histogram/' file_list(i).name];
    image_dir_path = strrep(image_dir_path, '.csv', '');  % remove the .csv from the file image path
    figure(1);
    hh = histogram(x,'Normalization','count');

    % Set the x-axis label
    xlabel('X_{Total} (counts per time bin)', 'FontSize', 18);

    % Set the y-axis label
    ylabel('Frequency', 'FontSize', 18)
    saveas(hh, [image_dir_path '_histogram.png'])
    
    % Show the plot
    edges = hh.BinEdges;
    counts = hh.BinCounts;
    values = hh.Values;

    % Extract the frequency values
    [frequencies, edges] = histcounts(x, bins);

    % Write frequencies to CSV file
    x_total_dir_path = [folder_path 'x_total/' file_list(i).name];
    x_total_dir_path = strrep(x_total_dir_path, '.csv', ''); % remove the .csv from the file image path
    csvwrite([x_total_dir_path  '_X_Total.csv' ], x);
    
    % combine folder_path, frequency/ and file_list to get the path to save the frequency
    file_dir_path = [folder_path 'frequency/' file_list(i).name];
    file_dir_path = strrep(file_dir_path, '.csv', ''); % remove the .csv from the file image path
    csvwrite([file_dir_path  '_frequency.csv' ], frequencies');
   
     % Fit power law
    [alpha, xmin, L] = plfit(x);
    disp(['Estimated alpha = ' num2str(alpha)]);
    
    % Generate power-law plot
    h = plplot(x, xmin, alpha);
    
    % Perform Anderson-Darling test
    [ad_stat, ad_critical_vals, ad_significance] = adtest(x, 'Distribution', 'exponential');
    
    % Display the Anderson-Darling test statistic, critical values, and significance level
    disp(['Anderson-Darling test statistic: ' num2str(ad_stat)]);
    disp(['Anderson-Darling critical values: ' num2str(ad_critical_vals)]);
    disp(['Anderson-Darling significance level: ' num2str(ad_significance)]);
    
    % Create the powerlaw path
    powerlaw_dir_path = [folder_path 'powerlaw/' file_list(i).name];
    powerlaw_dir_path = strrep(powerlaw_dir_path, '.csv', '');  % remove the .csv from the file image path
    saveas(h(1), [powerlaw_dir_path '_power_law.png']);
    
    clf; % clear previous image
    
    % Plot power-law fit alongside histogram
    figure(2);
    hp = histogram(x, 'Normalization', 'count');
    x_fit = xmin:bin_size:max(x) + bin_size;
    y_fit = L*x_fit.^(-alpha);
    hold on;
    plot(x_fit, y_fit, 'r--', 'LineWidth', 2);
    hold off;
    
    % Set the x-axis label
    xlabel('X_{Total} (counts per time bin)', 'FontSize', 18);

    % Set the y-axis label
    ylabel('Frequency', 'FontSize', 18);
    
    % Save the plot
    saveas(hp, [powerlaw_dir_path '_power_law_fit.png']);
    
    % Write the power-law fit parameters and Anderson-Darling test results to a CSV file
    plfit_params_dir_path = [folder_path 'plfit_params/'];
    if ~exist(plfit_params_dir_path, 'dir')
        mkdir(plfit_params_dir_path);
    end
    plfit_params_path = [plfit_params_dir_path file_list(i).name];
    plfit_params_path = strrep(plfit_params_path, '.csv', ''); % remove the .csv from the file path
    result_data = [alpha, xmin, L, ad_stat, ad_critical_vals, ad_significance];
    csvwrite([plfit_params_path  '_power_law_fit_params.csv'], result_data);
    
    % Print the values of the fitted linear lines
    disp(['xmin: ' num2str(xmin)]);
    disp(['L: ' num2str(L)]);

end