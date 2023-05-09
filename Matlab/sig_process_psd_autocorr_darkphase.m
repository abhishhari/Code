% Compute the PSD and autocorrelation for a csv file

clear all;
clc;

% Define the folder containing the CSV files
folder_path = '/Users/a.hari/Desktop/Project/Matlab/new /Darkphase/';

% Get a list of all the CSV files in the folder
file_list = dir([folder_path '*.csv']);

% Initialize arrays for PSD and autocorrelation data
psd_data = [];
autocorr_data = [];
peak_autocorr_data = [];
% Loop through each file and extract the data
for i = 1:length(file_list)
    % Read in the CSV file
    file_path = [folder_path file_list(i).name];
    % combine folder_path, image/ and file_list to get the path to save the image
    image_dir_path = [folder_path 'image/' file_list(i).name];
    image_dir_path = strrep(image_dir_path, '.csv', ''); % remove the .csv from the file image path

    image_dir_path = strrep(image_dir_path, '.csv', '');

    tbl = readtable(file_path, 'Delimiter', ',', 'HeaderLines', 1, 'Format', '%{dd/MM/yy HH:mm}D%f%f');
    tbl.Properties.VariableNames = {'DateTime', 'X_total', 'Z_total'};

    % Extract the x and z data
    X_total = tbl.X_total;
    Z_total = tbl.Z_total;
    Fs = 1/600

    % Compute the PSD
    [pxx, f] = pwelch(X_total, [], [], [], Fs);
    [pxz, f] = pwelch(Z_total, [], [], [], Fs);

    % Compute the autocorrelation
    [axx, lags] = xcorr(X_total, 'coeff');
    [axz, lags] = xcorr(Z_total, 'coeff');

    % Add the data to the arrays
    psd_data = [psd_data; pxx];
    autocorr_data = [autocorr_data; axx];

   % Plot the PSD
figure(1);
plot(f, pxx, 'color', [0, 0.5, 0]); % dark green line for X
hold on;
plot(f, pxz, 'color', [0.5, 0, 0.5]); % purple line for Z
xlabel('Frequency (Hz)');
ylabel(['PSD (' char(215) ' ' '(crossings/sec)^2/Hz)']); % PSD unit with subscript;
legend('X_{Total}', 'Z_{Total}');
% title('Power Spectral Density');

% Plot the autocorrelation
figure(2);
plot(lags, axx, 'color', [0, 0.5, 0]); % dark green line for X
hold on;
plot(lags, axz, 'color', [0.5, 0, 0.5]); % purple line for Z
xlabel('Time (s)');
ylabel('Autocorrelation');
legend('X_{Total}', 'Z_{Total}');
% title('Autocorrelation');

% Plot the PSD and autocorrelation
figure(3);
subplot(2, 1, 1);
plot(f, pxx, 'color', [0, 0.5, 0]); % dark green line for X
hold on;
plot(f, pxz, 'color', [0.5, 0, 0.5]); % purple line for Z
xlabel('Frequency (Hz)');
% ylabel('PSD');
ylabel(['PSD (' char(215) ' ' '(crossings/sec)^2/Hz)']); % PSD unit with subscript
legend('X_{Total}', 'Z_{Total}');
% title('Power Spectral Density');
subplot(2, 1, 2);
plot(lags, axx, 'color', [0, 0.5, 0]); % dark green line for X
hold on;
plot(lags, axz, 'color', [0.5, 0, 0.5]); % purple line for Z
xlabel('Time (s)');
ylabel('Autocorrelation');
legend('X_{Total}', 'Z_{Total}');
% title('Autocorrelation');

% save the plots as png files
saveas(figure(1), [image_dir_path '_psd.png']);
saveas(figure(2), [image_dir_path '_autocorr.png']);
saveas(figure(3), [image_dir_path '_psd_autocorr.png']);

% clear the figures
clf(figure(1));
clf(figure(2));
clf(figure(3));

    
end
% Save the data to CSV files
% csvwrite('psd_data.csv', psd_data);
% csvwrite('autocorr_data.csv', autocorr_data);
% csvwrite('peak_autocorr_data.csv', peak_autocorr_data);
% csvwrite('second_peak_autocorr_data.csv', second_peak_autocorr_data);
