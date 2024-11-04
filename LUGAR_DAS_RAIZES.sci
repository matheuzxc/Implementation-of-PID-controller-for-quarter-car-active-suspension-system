
//LUGAR DAS RAIZES
s = poly(0,'s')
num_massa_suspensa = 24310000*s + 2378640000

num_massa_nao_suspensa = 1309000*s^2 + 24310000*s + 2378640000

den = 1260*s^4 + 11400*s^3 + 12502600*s^2 + 24310001*s + 2378640000

G_s = syslin('c',num_massa_nao_suspensa,den)
disp('G_s= ',G_s)

scf(1);clf(1)
evans(G_s)
    
Gain_margin = 10^(g_margin(G_s)/20)
disp ('K máximo de estabilidade= ',Gain_margin)


//RESPOSTA AO DEGRAU PARA DIFERENTES VALORES DE K (50%;100%;110%;130%)

Tsim = 10; quais_T = linspace(-1.,Tsim,1e3)
T_mf = quais_T(quais_T>=0)
degrau = ones(quais_T)
degrau(quais_T<0) = 0

quais_K = Gain_margin * ([0.5,1.0,1.1,1.3])
for qK = 1:length(quais_K)
    C_s = poly([quais_K(qK)],'s','c')
    G1_s = (C_s*G_s)/(1 + C_s*G_s)
    [z,p,k] = tf2zp(G1_s)
    scf(1)
    
    plot(real(p), imag(p),'rs')
    yout_mf = csim('step', T_mf,G1_s)
    
    scf(2)
    subplot(2,2,qK)
    plot(T_mf,yout_mf,'k-')
    plot(quais_T, degrau, 'r-')
    xlabel('tempo(s)')
    
    disp(strcat(["k=",string(round(quais_K(qK)*100)/100)]))
    lg = legend(strcat(["k=",string(round(quais_K(qK)*100)/100)]))
    set(gca(), 'font_size',3)
    set(lg, 'font_size',3)
end
