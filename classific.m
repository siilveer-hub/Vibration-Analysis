function [ST_END, a] = classific(m, n, imf, acceleration)
dim = size(imf,2);

% Выделение шумовой части
err =  zeros(); 
for i = 1:m
    err = err + imf(:,i);
end

% Вычисление сигнальной части
for i = m:n
    a(:,i-m+1)  = imf(:,i);
end

%% Вычисление классификационной статистики
betta_skor = inv(a'*a)*a'*acceleration; % оценка весовых коэффициентов
p = .95; % вероятность для определение распределения Стьюдента
nu = size(acceleration,1)-dim-1; % количество степеней свободы для распределения Стьюдента
ti = tinv (p, nu); % обратная укмулятивная функция распределения Стьюдента

temp = ti.*diag(sqrt(inv(cov(a))));
for i = 1:n-m+1
    betta_max(i) = betta_skor(i,:)+var(a(:,i))*temp((n-m+1)+1-i);
    betta_min(i) = betta_skor(i,:)-var(a(:,i))*temp((n-m+1)+1-i);
end

% Вводим классификационную статистику
for i = 1:n-m+1
    V=diag(inv(cov(a(:,i))));
    ST(i) = abs(betta_skor(i))^2/(V(end)*std(err').^2); 
end
ST_END = ST(ST>0);
end
