% Cálculo da FFT de um sinal no domínio do tempo.
%	    Sintaxe: [y] = my_fft(t,x,fs)
%             Entradas:
%                 t  = vetor de tempo 
%                 x  = amostras do sinal
%                 fs = frequência de amostragem do sinal.
%             Saídas:
%                 f = vetor de frequências
%                 Y = valores do módulo de X(jW)
function [f,Y]  = generate_normalized_fft(t,x,fs)
    y     = fft(x);
    yaux  = fliplr(y(1,2:end));
    X     = [yaux y];
    faixa = ceil(length(X)/4);

    X(1,1:faixa)=0;
    X(1,3*faixa:end)=0;
    length(X);
    omega = 0:fs/length(y):fs-(fs/length(y));
    waux  = -fliplr(omega(1,2:end));
    
    f     = [waux omega];
    Y     = abs(X/length(t));
    %plot(w,abs(2*X/length(t))); grid on;
    %xlabel('$f$(Hz)','interpreter','latex');
    %ylabel('Magnitude');
    %title('Espectro $|X_{c}(j2\pi f)|$','interpreter','latex');
return