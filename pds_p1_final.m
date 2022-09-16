%% Limpeza de variáveis
clc;
clear;
close all;

%% Casos de teste sugeridos

% fc = 500 => Marca aparece parada piscando a cada dois ciclos
% fc = 900 => Marca anda lentamente no sentido horário
% fc = 1000 => Marca permanece parada piscando a cada ciclo
% fc = 1200 => Marca anda lentamente no sentido anti-horário
% fc = 1500 => Três marcas paradas
% fc = 1800 => Duas marcas andando em sentido horário
% fc = 2000 => Duas marcas paradas
% fc = 2200 => Duas marcas andando em sentido anti horário
% fc = 2400 => Uma marca andando em sentido horário
% fc = 3000 => Três marcas paradas (simétricas)
% fc = 4000 => Quatro marcas paradas (simétricas)

%% Dados constantes utilizados
cycles_quantity = 20; % quantidade de ciclos do sinal de entrada exibidos no gráfico
duty_cycle = 15; % Proporção do ciclo de trabalho da onda quadrada
signal_frequency = 1000; % Frequência do sinal de entrada em 1kHz
signal_period = 1/signal_frequency; % Período do sinal de entrada

%% Capturando a taxa de amostragem
fprintf('Frequência do sinal de entrada -> %dHz \n', signal_frequency)
fc = input('Digite a taxa de amostragem (Hz):');

%% Geração da onda senoidal de entrada e do trem de pulsos

% Definição da frequência de amostragem para geração dos sinais
fs = 1000*signal_frequency;
ts = 1/fs;

% Domínio do tempo 
t = 0:ts:cycles_quantity/signal_frequency;
% Geração do sinal senoidal de entrada
m = sin(2*pi*signal_frequency*t);
% Geração do trem de pulsos para amostragem
c = 0.5*square(2*pi*fc*t, duty_cycle) + 0.5;

%% Amostragem do sinal de entrada com base no trem de pulsos
mo = m.*c;

%% Geração das FTs

[f_signal, ft_signal] = generate_normalized_fft(t,m,fs);
[f_square, ft_square] = generate_normalized_fft(t,c,fs);
[f_pam, ft_pam] = generate_normalized_fft(t,mo,fs);

%% Gráficos no domínio do tempo
figure;
plot_signal(1, m, 'Onda Senoidal', t);
plot_signal(2, c, 'Sinal de Amostragem', t);
plot_signal(3, mo, 'Sinal Amostrado (Natural)', t);
plot_signal(4, m, 'Sinal Amostrado (Natural) x Sinal de Entrada', t, mo);

%% Gráficos no Domínio da Frequência
figure;
plot_fft_signal(1, ft_signal, 'Espectro do Sinal Senoidal', f_signal);
plot_fft_signal(2, ft_square, 'Espectro do Sinal de Amostragem', f_square);
plot_fft_signal(3, ft_pam, 'Espectro do Sinal Amostrado (Natural)', f_pam);
plot_fft_signal(4, ft_signal, 'Espectro do Sinal Senoidal e do Sinal Amostrado', f_signal, f_pam, ft_pam);

%% Visualização da marca no ciclo do ventilador

plot_fan(signal_frequency, cycles_quantity, fc, t, m)
subplot(2,1,2);
plot_overlap(t,m,mo)
%% Funções para plotagem dos gráficos
function plot_signal(pos, signal, caption, t, final)
    subplot(4,1,pos);
    if nargin < 5
        plot(t,signal, 'LineWidth', 1);
    else
        plot_overlap(t,signal,final)
    end
  
    title(caption);
    grid on;
    time_plot_axes()
end

function plot_overlap(t, signal, final)
    hold on
    plot(t,signal, '--', t,final,'r', 'LineWidth', 1);
    b = bar(t,final);
    b.ShowBaseLine='off';
    hold off
    time_plot_axes()
    grid on;
end

function time_plot_axes()
    xlabel('Tempo (s)');
    ylabel('Amplitude');
end

function plot_fft_signal(pos, spectrum1, caption, f1, f2, spectrum2)
    subplot(2,2,pos);
    if nargin < 5
        plot(f1, spectrum1)
        %stem(f1, spectrum1, '.');
    else
        plot(f1, spectrum1, 'blue')
        %stem(f2, spectrum1, '.', 'blue');
        hold on;
        plot(f2, spectrum2, 'red')
        %stem(f2, spectrum1, '.', 'red');
        hold off;
    end

    grid on;
    axis([-60000 60000 0 (max(spectrum1) * 1.1)]);
    xlabel("\it f (Hz)" , 'Interpreter','LaTex');
    ylabel('$\arrowvert$X(\it f)$\arrowvert$', 'Interpreter','LaTex');
    title(caption)
end

function plot_fan(signal_frequency, cycles_quantity, fc, t_sin, signal_sin)
    tc = 1/fc;
    t_square = (0 : tc : cycles_quantity/signal_frequency);
    N = length(t_square);
    n = (0:1:N-1);
    d=2*pi*signal_frequency/fc;
    sinal_sample = sin(d.*n);
    
    figure;
    subplot(2,1,1);
    plot(t_sin,signal_sin, 'LineWidth', 1);
    hold on;
    plot(t_square,sinal_sample, 'o', 'LineWidth',1);
    hold off;
    grid on;
    time_plot_axes()
end