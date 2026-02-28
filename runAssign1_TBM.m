% Assignment_1
%  Group X, AA2021-2022
%
%  TBM (To Be Modified): Modify & Add where needed

%% Pricing parameters
% All parameters should be put here, in the script and passed to the
% fuctions of interest (generally in a struct)
S0=1;
K=1.1;
r=0.025;
TTM=1/3; 
sigma=0.212;
flag=1; % flag:  1 call, -1 put
d=0.02;

%% Quantity of interest
B=exp(-r*TTM); % Discount

%% Pricing A
F0=S0*exp(-d*TTM)/B;     % Forward in G&C Model

%TBM: Modify with a cicle
pricingMode = 1; % 1 ClosedFormula, 2 CRR, 3 Monte Carlo
M=10000; % M = simulations for MC, steps for CRR;
OptionPrice = EuropeanOptionPrice(F0,K,B,TTM,sigma,pricingMode,M,flag)

%% Errors Rescaling B-C

% plot Errors for CRR varing number of steps
% Note: both functions plot also the Errors of interest as side-effect 
[nCRR,errCRR]=PlotErrorCRR(F0,K,B,TTM,sigma);

% plot Errors for MC varing number of simulations N 
[nMC,stdEstim]=PlotErrorMC(F0,K,B,TTM,sigma); 

%% KO Option D
%non funziona molto bene sta cosa qui
KO=1.4;
Call_KO_True = EuropeanKOCall_ClosedFormula(F0, K, KO, B, TTM, sigma)
Call_KO_CRR= EuropeanOptionKOCRR(F0, K, KO, B, TTM, sigma, M)
Call_KO_MS=EuropeanOptionKOMC(F0,K,KO,B,TTM,sigma,M)
%% KO Option Vega E
S0_vector = 0.65 : 0.01 : 1.45;
F0_vector = S0_vector' .* exp(-d*TTM)/B;
vega=zeros(length(F0_vector));
M=100;
figure();
for j=1:3
    flagNum=j;
    for i=1:length(F0_vector)
            vega(i) = VegaKO(F0_vector(i), K, KO, B, TTM, sigma, M, flagNum);
    end
    plot(S0_vector, vega);
    hold on
end
%% American Barrier F
figure();
Call_American_KO_CRR = EuropeanOptionAmericanBarrier(F0, K, KO, B, TTM, sigma, d, M);
% Comparation with Euro Barrier

% Analyze Delta
Eur_delta= zeros(length(F0_vector),1);
American_delta= zeros(length(F0_vector),1);

for i=1:length(F0_vector)
    Eur_delta(i) = DeltaKO(F0_vector(i), K, KO, B, TTM, sigma, d);
    American_delta(i) = DeltaAmericanKO(F0_vector(i), K, KO, B, TTM, sigma, d, M);
end
title('Delta Eur VS American Barrier');
plot(S0_vector, Eur_delta);
hold on
plot(S0_vector, American_delta);
title('Delta Eur VS American Barrier');
legend('Delta Eur', 'Delta American');


% Analyze Vega
Eur_vega= zeros(length(F0_vector),1);
American_vega= zeros(length(F0_vector),1);
figure();
for i=1:length(F0_vector)
    Eur_vega(i) = VegaKO(F0_vector(i), K, KO, B, TTM, sigma, M, 1);
    American_vega(i) = VegaAmericanKO(F0_vector(i), K, KO, B, TTM, sigma, d, M);
end
title('Delta Eur VS American Barrier');
plot(S0_vector, Eur_vega);
hold on
plot(S0_vector, American_vega);
title('Vega Eur VS American Barrier');
legend('Vega Eur', 'Vega American');

%% Antithetic Variables
M=100;
m=M/2;
[M_vec, stdEstim] = PlotErrorMC(F0, K, B, TTM, sigma);
hold on 
[M_vec, stdEstim] = PlotErrorMC_half(F0, K, B, TTM, sigma);


%% Bermudan H
Bermudan = BermudanOptionPrice(F0, K, TTM, sigma, B, d, M);