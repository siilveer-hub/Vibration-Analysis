function spectrum_fro_plot(signal, f, fs, freq, var)
    switch var
        case 1
            figure;
            plot(f, signal);
            xlim([0 1000])
            ncomb = 10;
            helperPlotCombs(ncomb, freq)
            xlabel('Частота (Гц)')
            ylabel('Энергенический спектр (dB)')
        otherwise
            envelope = abs(hilbert(abs(signal)));
            nfft = length(envelope);
            frequencies = (0:nfft-1)*(fs/nfft);
            spectrum = abs(fft(envelope));
            figure;
            plot(frequencies(4:floor(nfft/2)), spectrum(4:floor(nfft/2)));
            xlim([0 1000])
            ncomb = 10;
            helperPlotCombs(ncomb, freq)
            xlabel('Частота (Гц)')
            ylabel('Энергенический спектр (dB)')
            [peaks, locations] = findpeaks(spectrum(2:floor(nfft/2)), 'MinPeakHeight', 0.1); % Настройте MinPeakHeight по необходимости
            hold on;
            plot(frequencies(locations), peaks, 'ro');
            legend('Спектр', 'Пики');
            
            % Анализ пиков для определения неисправностей
            % Например, если пик находится на частоте, соответствующей повреждению внешнего кольца
            fault_frequency = 100; % Пример частоты неисправности (замените на реальное значение)
            tolerance = 5; % Допуск для поиска пика
            fault_indices = find(abs(frequencies(locations) - fault_frequency) < tolerance, 1);
            
            if ~isempty(fault_indices)
                disp('Обнаружена неисправность подшипника!');
            else
                disp('Неисправностей не обнаружено.');
            end
    end
end