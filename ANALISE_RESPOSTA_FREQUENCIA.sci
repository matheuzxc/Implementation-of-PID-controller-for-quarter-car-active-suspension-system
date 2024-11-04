// Definição do sistema G(s)
s = poly(0,'s');
num_massa_suspensa = 24310000*s + 2378640000;
num_massa_nao_suspensa = 1309000*s^2 + 24310000*s + 2378640000;
den = 1260*s^4 + 11400*s^3 + 12502600*s^2 + 24310001*s + 2378640000;

//G_s = syslin('c', num_massa_suspensa, den);
G_s = syslin('c', num_massa_nao_suspensa, den);
disp('G_s= ', G_s);

//PARÂMETROS DO CONTROLADOR PID
Kcr = 6.31;
Pcr = 0.35;
//Kcr = 3.24
//Pcr = 0.05
Kp = 0.6 * Kcr;
Ki = Kp / (0.5 * Pcr); 
Kd = Kp * (0.125 * Pcr);
C_s = (Ki + Kp * s + Kd*s^2)/s + 1e-12*s^2;
G_pid_s = (C_s * G_s) / (1 + C_s * G_s);
// DIAGRAMA DE BODE PARA ÁNALISE DA RESPOSTA EM FREQUÊNCIA
clf(1);
bode(G_pid_s);
title('Diagrama de Bode');

