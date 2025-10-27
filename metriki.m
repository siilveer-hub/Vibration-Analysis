function [Metr_1, Metr_2, Metr_3, Metr_4] = metriki(original_signal, denoised_signal, var)
switch var
    case 1
        % Оценка MSE (среднеквадратичной ошибки) между зашумленным и очищенным сигналами
        Metr_1 = mean((original_signal - denoised_signal).^2);
        % Пиковое отношение сигнал/шум (PSNR)
        max_val = max(original_signal); % Максимальное значение исходного сигнала
        Metr_2 = 10 * log10((max_val^2) / Metr_1); % Формула для PSNR
        % Коэффициент корреляции
        Metr_3 = corr(original_signal, denoised_signal);
        Metr_4 = [];
    case 2
        
        % Оценка MSE (среднеквадратичной ошибки) между зашумленным и очищенным сигналами
        Metr_1 = mean((original_signal - denoised_signal).^2);
        
        % Пиковое отношение сигнал/шум (PSNR)
        max_val = max(original_signal); % Максимальное значение исходного сигнала
        Metr_2 = 10 * log10((max_val^2) / Metr_1); % Формула для PSNR
        
        % 3. Спектральное сходство (Коэффициент корреляции спектров)
        Metr_3 = corr(original_signal(:), denoised_signal(:));

        % Коэффициент сохранения энергии
        energy_noisy = sum(original_signal.^2);  % Энергия зашумленного сигнала
        energy_clean = sum(denoised_signal.^2);  % Энергия очищенного сигнала
        Metr_4 = energy_clean / energy_noisy;  % Коэффициент сохранения энергии
        

end 