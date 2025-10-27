close all
% clear all
% clc
%% Загрузка сигнала
file = 'InnerRaceFault_vload_1.mat';
% file = 'baseline_1.mat';
% file = 'OuterRaceFault_2.mat';

% [data, fs, t, BPFI, BPFO] = load_data(file);
freq = BPFI;
data = s_BPFI';
% BPFI
% fs=Fs;
% t
[data_spectrum, ~, ~, ~] = envspectrum(data, fs);


% wave = 'coif5'; lev = 25; sorh = 'h';
wave = 'coif4'; lev = 5; sorh = 'h';
denoised_signal = signal_denoising(data', wave, lev);
filtered_signal = ordinary(data', fs);
[filtered_spectrum, ~, ~, ~] = envspectrum(filtered_signal, fs);
[smoothed_pxx, fxx] = smoothing_Furie(data, fs, wave, lev, sorh);
a_low_dbscan = spectrum_EMD(data);

disp('Сигнал очищенный с помощью вейвлет-разложения');

var = 1;
[MSE, PSNR,correlation, ~] = metriki(data(1:10000), denoised_signal(1, 1:10000)', var);
disp(['Среднеквадратичная ошибка сигнала очищенного вейвлет: ', num2str(MSE)]);
disp(['Пиковое отношение сигнал/шум сигнала очищенного вейвлет: ', num2str(PSNR)]);
disp(['Коэффициент корреляции сигнала очищенного вейвлет: ', num2str(correlation)]);

disp('Сигнал очищенный с помощью полосовой фильтрации');

[MSE, PSNR,correlation, ~] = metriki(data(1:10000), filtered_signal(1, 1:10000)', var);
disp(['Среднеквадратичная ошибка сигнала очищенного вейвлет: ', num2str(MSE)]);
disp(['Пиковое отношение сигнал/шум сигнала очищенного вейвлет: ', num2str(PSNR)]);
disp(['Коэффициент корреляции сигнала очищенного вейвлет: ', num2str(correlation)]);

disp('Сигнал очищенный с помощью сглаживания Фурье-периодограммы');

var = 2;
[MSE, PSNR, spectral_correlation, energy_ratio] = metriki(data_spectrum, smoothed_pxx, var);
disp(['Коэффициент сохранения энергии: ', num2str(MSE)]);
disp(['Отношение сигнал/Шум в частотной области: ', num2str(PSNR), ' dB']);
disp(['Коэффициент корреляции спектров: ', num2str(spectral_correlation)]);
disp(['Коэффициент сохранения энергии: ', num2str(energy_ratio)]);

disp('Сигнал очищенный с помощью полосовой фильтрации');

var = 2;
[MSE, PSNR, spectral_correlation, energy_ratio] = metriki(filtered_spectrum, smoothed_pxx, var);
disp(['Коэффициент сохранения энергии: ', num2str(MSE)]);
disp(['Отношение сигнал/Шум в частотной области: ', num2str(PSNR), ' dB']);
disp(['Коэффициент корреляции спектров: ', num2str(spectral_correlation)]);
disp(['Коэффициент сохранения энергии: ', num2str(energy_ratio)]);


disp('Сигнал очищенный с помощью декомпозиции на эмперические моды');

var = 2;
[EMD_spectrum, ~, ~, ~] = envspectrum(a_low_dbscan, fs);
[MSE, PSNR, spectral_correlation, energy_ratio] = metriki(data_spectrum, EMD_spectrum, var);
disp(['Коэффициент сохранения энергии: ', num2str(MSE)]);
disp(['Отношение сигнал/Шум в частотной области: ', num2str(PSNR), ' dB']);
disp(['Коэффициент корреляции спектров: ', num2str(spectral_correlation)]);
disp(['Коэффициент сохранения энергии: ', num2str(energy_ratio)]);

% fprintf('Стандартное отклонение исходного сигнала: %.4f\n', std(data));
% fprintf('Стандартное отклонение сигнала очищенного вейвлет: %.4f\n', std(denoised_signal));
% fprintf('Стандартное отклонение сигнала с полосовым фильтром: %.4f\n', std(filtered_signal));
% fprintf('Стандартное отклонение сигнала сглаженной фурье-периодограммы: %.4f\n', std(smoothed_pxx));

spectrum_fro_plot(data, [], fs, freq, 0);
title('График спектра огибающей исходного сигнала')
spectrum_fro_plot(denoised_signal, [], fs, freq, 0);
title('График спектра огибающей сигнала очищенного вейвлет')
spectrum_fro_plot(filtered_signal, [], fs, freq, 0);
title('График спектра огибающей сигнала с полосовым фильтром')
spectrum_fro_plot(smoothed_pxx, fxx, fs, freq, 1);
title('График спектра огибающей сигнала сглаженной фурье-периодограммы')
spectrum_fro_plot(a_low_dbscan, [], fs, freq, 0);
title('График спектра огибающей сигнала разложением на ЭМ')

