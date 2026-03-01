function delta = DeltaAmericanKO(F0, K, KO, B, T, sigma, q, N)
% Let's program the functino in the same style as we did for Vega

h = F0/100;
% Just use the closed formula since we can
up_value = EuropeanOptionAmericanBarrier(F0+h, K, KO, B, T, sigma, q, N);
down_value = EuropeanOptionAmericanBarrier(F0-h, K, KO, B, T, sigma, q, N);
% Using centered differences we get a much better convergence
delta = (up_value - down_value)/(2*h);
return