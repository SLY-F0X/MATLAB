% MNIST feedforward neural network (FNN), MNIST FASHION,
% MNIST from scratch, visual representation of the results.
clear; clc; close all force
%load('nn_mnist1.mat') %Для загрузки переменных из файла
images = loadMNISTImages('train-images-idx3-ubyte'); % Тренировочные картинки
labels = loadMNISTLabels('train-labels-idx1-ubyte'); % Тренировочные ярлыки
test_images = loadMNISTImages('t10k-images-idx3-ubyte'); % Тестовые картинки
test_labels = loadMNISTLabels('t10k-labels-idx1-ubyte'); % Тестовые ярлыки
images = images(:,1:50000); % Ограничение обучающей выборки картинок до 50к
labels = labels(1:50000,1); % Ограничение обучающих ярлыков до 50к
labels(labels==0)=10; % Приравнивание 0 к 10 для работы команды dummyvar
test_labels(test_labels==0)=10; 
lbl = full(dummyvar(labels))';% Полное преобразование списка ярлыков из матрицы 1*x к виду 10*x для получения 10 выходов нейросети с транспонированием
test_lbls = full(dummyvar(test_labels))';
net = newff(images,lbl,[128 128],{'tansig','tansig'},'trainscg');  % Параметры нейросети два скрытых слоя по 128 нейронов, метод обучения сопряженных градиентов
    net.trainParam.epochs=150; %к оличество эпох обучения
net.performFcn = 'mse'; % Функция оценки производительности нейросети mse - среднеквадратичная ошибка
net.divideFcn = 'dividerand'; % Разделение данных случайным образом
net.divideMode = 'sample';  % Разделение каждого образеца из обучающей выборки
net.divideParam.trainRatio = 70/100; % 70 процентов от общего количества выборки отдано под обучение 
net.divideParam.valRatio = 20/100; % 20 процентов для валидации модели
net.divideParam.testRatio = 10/100; % 10 процентов для тестирования
net.plotFcns = {'plotperform','plotregression'}; % построение графиков процесса обучения и регресии
[net,tr] = train(net,images,lbl); % задание функции обучения нейросети
y = net(images); % результаты обучения
result = sim(net,test_images); % задание симуляции работы обученной нейросети для тестового набора картинок
figure('Name','Распознавание одежды'); hold on; % Вызов окна для отображения одежды и его удерживание
% Построение матрицы картинок. Тестовая выборка картинок к результатам обучения нейросети по предсказанию ярлыков 
for i = 1:20 % Первые 20 обрацов
    subplot(4,5,i); % Матрица размером 4 на 5
    digit = reshape(test_images(:,i), [28,28]); % Выдача картинок из тестовой выборки
    imshow(digit) % Показ картинок
    title(full(vec2ind(result(:,i)))) % Применение функции vec2ind для преобразования результатов обучения и выдачи к какому из 10 классов относится изображение
end
 sgtitle({'1 Брюки 2 Пуловер 3 Платье 4 Пальто 5 Сандалии ', ...
    '6 Рубашка 7 Кроссовки 8 Сумка 9 Ботильоны 10 Футболка/топ'})
%%
% Секция для выдачи результатов с указанием числа от 1 до 10000 по
%  количеству изображений в тестовой выборке
k = input('Число: ');
%     figure('Name','Результат опознования нейросетью')
%     digit_k = reshape(test_images(:, k), [28,28]);
%     imshow(digit_k)
%     title(vec2ind(result(:, k)))
%     sgtitle({'1 Брюки 2 Пуловер 3 Платье 4 Пальто 5 Сандалии ', ...
%     '6 Рубашка 7 Кроссовки 8 Сумка 9 Ботильоны 10 Футболка/топ'})
% Вызов картинки и ярлыка из тестовой базы
%     figure('Name','Вызов картинки и ярлыка из базы тестирования')
%     imshow(digit_k)
%     title(vec2ind(test_lbls(:, k)))
%     sgtitle({'1 Брюки 2 Пуловер 3 Платье 4 Пальто 5 Сандалии ', ...
%     '6 Рубашка 7 Кроссовки 8 Сумка 9 Ботильоны 10 Футболка/топ'})
% Сравнение на одном листе
    figure('Name','Сравнение ярлыков_v2')
    subplot(1,2,1);
    imshow(digit_k)
    n_title = vec2ind(result(:, k));
    title(sprintf('Нейросеть: %d',n_title))
    subplot(1,2,2);
    imshow(digit_k)
    t_title = vec2ind(test_lbls(:, k));
    title(sprintf('Тестовая выборка: %d',t_title))
    sgtitle({'1 Брюки 2 Пуловер 3 Платье 4 Пальто 5 Сандалии ', ...
    '6 Рубашка 7 Кроссовки 8 Сумка 9 Ботильоны 10 Футболка/топ'})
