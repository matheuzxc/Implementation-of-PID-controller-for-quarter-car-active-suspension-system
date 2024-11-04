// DEFINIÇÃO DO SISTEMA G(s) PARA A MASSA SUSPENSA E NÃO SUSPENSA
s = poly(0,'s');
num_massa_suspensa = 24310000*s + 2378640000;
num_massa_nao_suspensa = 1309000*s^2 + 24310000*s + 2378640000
den = 1260*s^4 + 11400*s^3 + 12502600*s^2 + 24310001*s + 2378640000;

G_s = syslin('c', num_massa_nao_suspensa, den);
disp('G_s= ', G_s);

// PARÂMETROS DO CONTROLADOR PID
//MALHA SUSPENSA
//Kcr = 3.24
//Pcr = 0.05
//MALHA NÃO SUSPENSA
Kcr = 6
Pcr = 0.352

Kp = 0.6*Kcr;
Ki = Kp / 0.5*Pcr;  
Kd = Kp * 0.125*Pcr; 


// CONTROLADOR PID
C_s = (Ki + Kp * s + Kd*s^2)/s + 1e-12*s^2;
G_pid_s = (C_s * G_s) / (1 + C_s * G_s);
disp('Controlador PID: ', C_s);

// RESPOSTA AO DEGRAU
Tsim = 40;
quais_T = linspace(-1., Tsim, 1e3);
T_mf = quais_T(quais_T >= 0);
degrau = ones(quais_T);
degrau(quais_T < 0) = 0;

scf(2); clf(2);
yout_mf = csim('step', T_mf, G_pid_s);

plot(T_mf, yout_mf, 'k-');
plot(quais_T, degrau, 'r-');
xlabel('Tempo (s)');
ylabel('Amplitude');
title('Resposta ao Degrau com Controlador PID');
legend('Saída Controlada', 'Entrada de Degrau');
set(gca(), 'font_size', 3);
