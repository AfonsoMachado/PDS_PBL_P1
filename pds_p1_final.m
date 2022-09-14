%% Limpeza de variáveis
clc;
clear;
close all;

%% Casos de teste sugeridos

%% Dados constantes utilizados
cycles_quantity = 10; % quantidade de ciclos do sinal de entrada exibidos no gráfico
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
plot_fft_signal(1, ft_signal, 'FFT do Sinal Senoidal', f_signal);
plot_fft_signal(2, ft_square, 'FFT do Sinal de Amostragem', f_square);
plot_fft_signal(3, ft_pam, 'FFT do Sinal Amostrado (Natural)', f_pam);
plot_fft_signal(4, ft_signal, 'FFT do Sinal Senoidal e do Sinal Amostrado', f_signal, f_pam, ft_pam);

%% Funções para plotagem dos gráficos
function plot_signal(pos, signal, caption, t, final)
    subplot(4,1,pos);
    if nargin < 5
        plot(t,signal, 'LineWidth', 1);
    else
        hold on
        plot(t,signal, '--', t,final,'r', 'LineWidth', 1);
        b = bar(t,final);
        b.ShowBaseLine='off';
        hold off
    end
   
    xlabel('Tempo (s)');
    ylabel('Amplitude');
    title(caption);
    grid on;
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
    xlabel('Frequência (Hz)');
    ylabel('Amplitude');
    title(caption)
end