# Implementação de Controlador PID para Sistema de Suspensão Ativa Quarter-Car

Este projeto apresenta a implementação de um controlador PID em um sistema de suspensão ativa usando o modelo simplificado *quarter-car*. O objetivo do projeto é desenvolver um controlador que otimize a resposta transitória e a estabilidade do sistema, proporcionando maior conforto e estabilidade em veículos.

## Sobre o Projeto

Este projeto utiliza um controlador PID (Proporcional-Integral-Derivativo) para controlar as oscilações de um sistema de suspensão ativa. O modelo escolhido é o *quarter-car*, uma representação simplificada de suspensão veicular, que considera apenas um quarto da massa e da suspensão do veículo, facilitando a análise e o controle.

O projeto abrange a modelagem matemática do sistema de suspensão ativa, a análise de estabilidade e a sintonização do controlador PID. A implementação é realizada em Scilab, com suporte para análise de estabilidade usando o critério de Routh-Hurwitz e análise do lugar das raízes.


## Estrutura de Diretórios

- **`src/`**: Contém os códigos principais utilizados na implementação e análise do controlador PID.
- **`data/`**: Parâmetros do sistema e dados de simulação.
- **`docs/`**: Documentação detalhada sobre o modelo e o controlador.

## Pré-requisitos

- **Scilab**: O software utilizado para a implementação dos códigos, análise de estabilidade e simulação de resposta do sistema.
- **Bibliotecas do Scilab**: As bibliotecas `routh_t` e `evans` são usadas para análise de estabilidade e do lugar das raízes, respectivamente.

## Implementação

Abaixo está uma descrição das principais implementações e códigos utilizados no projeto.

### Modelagem Matemática

A modelagem do sistema de suspensão ativa foi realizada utilizando o modelo *quarter-car*, conforme descrito na literatura. As equações de movimento do sistema são derivadas e convertidas para o domínio de Laplace para facilitar a análise de estabilidade e a resposta do sistema a entradas em degrau.

![image](https://github.com/user-attachments/assets/9bf0fd15-be2c-45a3-8fa7-50d974c061bb)

- **m₂** = massa suspensa do carro.
- **m₁** = massa não suspensa (massa da roda).
- **y** = deslocamento da massa suspensa.
- **x** = deslocamento da massa não suspensa.
- **u** = deslocamento em relação ao solo.
- **k₂** = rigidez da mola suspensa.
- **k₁** = rigidez do pneu.
- **b** = amortecimento do amortecedor da suspensão.


### Códigos

1. **Verificação de Estabilidade Sem Ganho \( K_p \)**

    Este código realiza a verificação de estabilidade utilizando o critério de Routh-Hurwitz, que permite determinar se o sistema é estável com a planta definida inicialmente.

    ```scilab
    // Definição do sistema para massa suspensa e não suspensa
    s = poly(0, 's');
    num = 24310000 * s + 2378640000;
    den = 1260 * s^4 + 11400 * s^3 + 12502600 * s^2 + 24310001 * s + 2378640000;
    G_s = syslin('c', num, den);
    disp('G_s=', G_s);

    // Critério de Routh-Hurwitz para verificar estabilidade
    k = 1;
    tab_routh = routh_t(G_s, k);
    disp('Tabela de Routh:', tab_routh);
    ```

2. **Análise do Lugar das Raízes**

    Este código examina a estabilidade do sistema ao variar o ganho \( K_p \). A análise do lugar das raízes permite visualizar como as raízes do sistema se movem no plano complexo, ajudando a identificar os valores de \( K_p \) que tornam o sistema estável.

    ```scilab
    // Definindo o sistema para análise do lugar das raízes
    s = poly(0, 's');
    num = 24310000 * s + 2378640000;
    den = 1260 * s^4 + 11400 * s^3 + 12502600 * s^2 + 24310001 * s + 2378640000;
    G_s = syslin('c', num, den);
    
    // Gerando gráfico do lugar das raízes
    scf(1); clf(1);
    evans(G_s);
    ```

3. **Análise de Resposta ao Degrau com e sem Controlador PID**

    Os códigos a seguir testam o sistema aplicando uma entrada em degrau com e sem o controlador PID. Isso permite observar a eficácia do controlador PID em reduzir as oscilações e ajustar a resposta do sistema para uma estabilidade mais rápida e menos oscilatória.

    - **Sem Controlador PID**:

      ```scilab
      // Resposta ao degrau sem controlador PID
      Tsim = 40;
      T_mf = linspace(0, Tsim, 1000);
      degrau = ones(T_mf);

      scf(2); clf(2);
      yout_mf = csim('step', T_mf, G_s);
      plot(T_mf, yout_mf, 'k-');
      plot(T_mf, degrau, 'r-');
      ```

    - **Com Controlador PID**:

      ```scilab
      // Parâmetros do controlador PID
      Kp = 77.76;
      Ki = 1.94;
      Kd = 0.012;
      C_s = (Ki + Kp * s + Kd * s^2) / s + 1e-12 * s^2;

      // Definindo sistema em malha fechada com controlador PID
      G_pid_s = (C_s * G_s) / (1 + C_s * G_s);

      // Resposta ao degrau com controlador PID
      yout_mf = csim('step', T_mf, G_pid_s);
      plot(T_mf, yout_mf, 'k-');
      plot(T_mf, degrau, 'r-');
      ```

4. **Sintonização do Controlador PID**

    A sintonização foi realizada pelo segundo método de Ziegler-Nichols, onde os valores de \( K_p \), \( T_i \), e \( T_d \) foram definidos com base em experimentos com o ganho crítico e o período crítico do sistema.

    O método consiste em:

    - Determinar o ganho crítico \( K_{cr} \), o valor máximo do ganho \( K_p \) para o qual o sistema começa a oscilar de forma estável.
    - Determinar o período crítico \( P_{cr} \), que é o período das oscilações contínuas no valor \( K_{cr} \).
    - Calcular os parâmetros do controlador PID:

      ```math
      Kp = 0.6 * K_{cr};
      Ki = \frac{Kp}{0.5 * P_{cr}};
      Kd = Kp * 0.125 * P_{cr};
      ```

      **Exemplo de cálculo**:

      - Para o sistema de massa suspensa:
        - \( K_{cr} = 3.24 \)
        - \( P_{cr} = 0.05 \)
      - Para o sistema de massa não suspensa:
        - \( K_{cr} = 6.31 \)
        - \( P_{cr} = 0.35 \)

## Resultados

Os resultados obtidos indicam que o controlador PID ajustado pelo método de Ziegler-Nichols proporcionou uma melhoria significativa na estabilidade do sistema, reduzindo as oscilações e atingindo a estabilidade mais rapidamente.

### Gráficos de Resposta ao Degrau

- **Com Controlador PID**: Mostra uma resposta mais estável e controlada.

![image](https://github.com/user-attachments/assets/9f286838-b6fa-4a16-adb2-23ffea84b20b)


- **Sem Controlador PID**: Evidencia oscilações mais amplas e estabilidade demorada.

![image](https://github.com/user-attachments/assets/d0f8a1a0-5762-41ee-b78c-57be0b4edefc)


Os gráficos comparativos entre as respostas com e sem controlador mostram uma redução significativa na amplitude das oscilações, especialmente para a massa não suspensa, indicando um comportamento mais controlado e estável.

## Conclusão

Este projeto demonstrou a eficácia de um controlador PID ajustado para um sistema de suspensão ativa modelo *quarter-car*. O uso do critério de Routh e a análise do lugar das raízes permitiram determinar os valores de ganho apropriados para alcançar uma resposta estável. A sintonização utilizando o método de Ziegler-Nichols mostrou-se adequada, melhorando substancialmente a resposta do sistema a perturbações.

A análise da resposta ao degrau com o controlador PID indica uma melhoria na estabilidade do sistema e uma resposta mais rápida, tornando-o mais adequado para aplicações em veículos onde o conforto e a estabilidade são essenciais.

## Referências

- Ogata, K. _Engenharia de Controle Moderno_, 5ª Ed., São Paulo: Pearson Prentice Hall, 2010.
- Neto, F. R. F. "Modelagem mecânica de um sistema de suspensão com o método Quarter-Car." Universidade Estadual do Maranhão, 2013.
