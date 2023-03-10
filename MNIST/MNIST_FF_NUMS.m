% MNIST feedforward neural network (FNN), MNIST Numbers, 
% MNIST from scratch, visual representation of the results.
clear; clc; close all force
load(full('MNIST_NUMS_DATABASE'))
% Из базы данных MNIST_NUMS_DATABASE.mat загружаются уже готовые данные для вычислений.
% Ярлык 0 в базе приравнян к 10, для работы функции vec2ind
% nums - обучающий набор изображений чисел,labels - обучающие ярлыки,  
% test_labels - тестовые ярлыки, test_nums - тестовые картинки цифр
nums = nums(:,1:20000); % Ограничение обучающей выборки картинок и ярлыков до 20к
labels = labels(:,1:20000);

% Параметры нейросети: входной слой, скрытый и выходной, метод обучения сопряженных градиентов
% 784 * 1/3 = 258
net = newff(nums,labels,[784 310],{'logsig','logsig'},'trainscg');
    net.trainParam.epochs=160; % количество эпох обучения
net.performFcn = 'mse'; % Функция оценки производительности нейросети mse - среднеквадратичная ошибка
[net,tr] = train(net,nums,labels); % задание функции обучения нейросети
y = net(nums); % результаты обучения
netsim = sim(net,test_nums); % задание симуляции работы обученной нейросети для тестового набора чисел

% Отрисовка таблицы распознанных каритнок с ярлыками
figure('Name','Цифры'); hold on;
% Построение матрицы картинок с числами. 
% Тестовая выборка чисел к результатам обучения нейросети по предсказанию ярлыков 
for i = 1:20 % Первые 20 обрацов
    subplot(4,5,i); % Матрица размером 4 на 5
    digit = reshape(test_nums(:,i), [28,28]); % Выдача чисел из тестовой выборки
    imshow(digit) % Показ картинок
    title(full(vec2ind(netsim(:,i))))
     % Применение функции vec2ind для преобразования результатов обучения 
     % и выдачи к какому из 10 классов относится изображение
end
 sgtitle({'Распознавание цифр нейросетью', ...
     'Ярлык отвечающий за ноль (0) в выбоке приравнен к 10'})
 
% % Выбор числа вручную из базы от 1 до 10000 
% k = input('Число: ');
%     digit_k = reshape(test_nums(:, k), [28,28]); % Выдача тестовой картинки цифры
%     n_title = vec2ind(netsim(:, k)); % Результат работы нейросети
%     t_title = vec2ind(test_labels(:, k)); % Сравнение с тестовой выборкой ярлыков
% % Сравнение на одном листе
%     figure('Name','Сравнение ярлыков')
%     subplot(1,2,1);
%     imshow(digit_k)
%     title(sprintf('Нейросеть: %d',n_title))
%     subplot(1,2,2);
%     imshow(digit_k)
%     title(sprintf('Тестовая выборка: %d',t_title))
%     sgtitle({'Распознавание цифр нейросетью и сравнение с тестовой выборкой', ...
%         'Ярлык отвечающий за ноль (0) в выбоке приравнен к 10'})

% Сравнение со своей базой нарисованной в Paint
load('database_paint')
paint_sim = sim(net,database_paint);
figure('Name','База данных из Paint');
for i = 1:10
    subplot(2,5,i); 
    paint = reshape(database_paint(:,i), [28,28]); % Выдача чисел из БД
    imshow(paint) % Показ картинок
    title(full(vec2ind(paint_sim(:,i))))
end
sgtitle({'Ярлык отвечающий за ноль (0) приравнен к 10'})

% Матрица конфузов для основной базы
figure
[~, trueLabels] = max(test_labels, [], 1);
[~,predictedLabels] = max(netsim);
confusionchart(trueLabels,predictedLabels)

