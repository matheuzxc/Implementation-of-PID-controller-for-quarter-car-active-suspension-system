// DEFINIÇÃO DO SISTEMA G(s) PARA A MASSA SUSPENSA E NÃO SUSPENSA
s = poly(0,'s');
num = 24310000*s + 2378640000;
nunn = 1309000*s^2 + 24310000*s + 2378640000
den = 1260*s^4 + 11400*s^3 + 12502600*s^2 + 24310001*s + 2378640000;

G_s = syslin('c', num, den);


RESPOSTA AO DEGRAU
Tsim = 40;
quais_T = linspace(-1., Tsim, 1e3);
T_mf = quais_T(quais_T >= 0);
degrau = ones(quais_T);
degrau(quais_T < 0) = 0;

scf(2); clf(2);
yout_mf = csim('step', T_mf, G_s);

plot(T_mf, yout_mf, 'k-');
plot(quais_T, degrau, 'r-');
xlabel('Tempo (s)');
ylabel('Amplitude');
title('Resposta ao Degrau com Controlador PID');
legend('Saída Controlada', 'Entrada de Degrau');
set(gca(), 'font_size', 3);
