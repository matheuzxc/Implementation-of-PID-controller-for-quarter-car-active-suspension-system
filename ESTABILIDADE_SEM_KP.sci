s = poly(0,'s')
num = 24310000*s + 2378640000

den = 1260*s^4 + 11400*s^3 + 12502600*s^2 + 24310001*s + 2378640000

G_s = syslin('c',num,den)
disp('G_s= ',G_s)

k = 1
disp('Estabilidade por criterio de Routh')
tab_routh = routh_t(G_s,k)
disp('Tab_routh', tab_routh)
