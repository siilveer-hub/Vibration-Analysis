function [a_low_dbscan] = spectrum_EMD(signal)
    %% Разложение на ЭМ
    dim = 15; % желаемая размерность разложения
    [imf,~] = emd(signal,'MaxNumIMF',dim,'Display',0);
    dim = size(imf,2); % действительная размерность разложения
    
    %% Визуально первая комоненты - шум, последняя компонента - тренд
    m = 1; n = dim; % начало и конец выборки массива разложения 
    [ST, a] = classific(m, n, imf, signal);
    
    %% Вводим количество кластеров
    k = 2;
    %% DBSCAN
    ST_dbscan(:,1)=ST; ST_dbscan(:,2)=ST;
    kD = pdist2(ST_dbscan,ST_dbscan,'euc','Smallest', size(ST_dbscan,2)+1);
    
%     figure('Name','Определение параметра epsilon','NumberTitle', 'off')
%     plot(sort(kD(end,:)));
%     title('k-distance graph')
%     xlabel('Points sorted with 50th nearest distances')
%     ylabel('50th nearest distances')
%     grid
    
    epsilon = 0.295;
    
    idx_dbscan = DBSCAN(ST_dbscan, epsilon, 0.05);
    [noise_dbscan, a_low_dbscan] = low_comp(idx_dbscan, a, n, m);
end