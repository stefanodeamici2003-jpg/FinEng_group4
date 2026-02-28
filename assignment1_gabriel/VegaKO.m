function vega=VegaKO(F0,K,KO,B,T,sigma,N,flagNum)
%Vega of the European Barrier option 
%
%INPUT
% F0:    forward price
% B:     discount factor
% K:     strike
% T:     time-to-maturity
% sigma: volatility
% flagNum:  1 CRR, 2 MC, 3 Exact
% KO:    threshold

h = 1e-8;

    switch flagNum

        %% CRR (deterministic model)
        case 1
            Up   = EuropeanOptionKOCRR(F0,K,KO,B,T,sigma+h,N);
            Down = EuropeanOptionKOCRR(F0,K,KO,B,T,sigma-h,N);
            vega = (Up - Down)/(2*h);

        %% Monte Carlo
        case 2
            Z = randn(N,1);  % common random numbers to avoid statistical noise

            % sigma + h
            FT_up = F0 * exp(-0.5*(sigma+h)^2*T + (sigma+h)*sqrt(T).*Z);
            payoff_up = max(FT_up - K,0);
            payoff_up(FT_up >= KO) = 0;
            Price_up = B*mean(payoff_up);

            % sigma - h
            FT_dn = F0 * exp(-0.5*(sigma-h)^2*T + (sigma-h)*sqrt(T).*Z);
            payoff_dn = max(FT_dn - K,0);
            payoff_dn(FT_dn >= KO) = 0;
            Price_dn = B*mean(payoff_dn);

            vega = (Price_up - Price_dn)/(2*h);

        %% Exact
        case 3
        % Controllo logico: se lo strike è oltre la barriera, l'opzione vale 0 (quindi Vega = 0)
            if K >= KO
                vega = 0;
                return;
            end
            
            % Calcolo di d1 e d2 (nota l'uso di 'log' e degli operatori element-wise './')
            d1_K = (log(F0 ./ K) + sigma^2 * T / 2) ./ (sigma * sqrt(T));
            d1_KO = (log(F0 ./ KO) + sigma^2 * T / 2) ./ (sigma * sqrt(T));
            d2_KO = d1_KO - sigma * sqrt(T);
            
            % Calcolo del Vega (nota l'uso spinto di '.*' e './' per i vettori)
            vega = F0 .* B .* sqrt(T) .* (normpdf(d1_K) - normpdf(d1_KO)) ...
                    + (KO - K) .* B .* normpdf(d2_KO) .* d1_KO ./ sigma;
        otherwise
            error('flagNum must be 1, 2 or 3');
    end
end