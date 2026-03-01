function price = EuropeanKOCall_ClosedFormula(F0, K, KO, B, T, sigma)
    % EuropeanKOCall_ClosedFormula calcola il prezzo esatto di una 
    % Up-and-Out Call con MONITORAGGIO EUROPEO (barriera attiva solo a scadenza).
    % Utilizza la replica statica: Call(K) - Call(KO) - (KO - K)*Digitale(KO)
    %
    % INPUT:
    % F0    : Prezzo Forward iniziale
    % K     : Strike price
    % KO    : Livello della Barriera (Knock-Out level)
    % B     : Fattore di sconto
    % T     : Tempo a scadenza (TTM)
    % sigma : Volatilità

    % Controllo logico: se lo strike è già oltre la barriera, l'opzione vale 0
    if K >= KO
        price = 0;
        return;
    end

    % --- 1. Mattoncino 1: Call Vanilla con strike K ---
    d1_K = (log(F0 / K) + 0.5 * sigma^2 * T) / (sigma * sqrt(T));
    d2_K = d1_K - sigma * sqrt(T);
    Call_K = B * (F0 * normcdf(d1_K) - K * normcdf(d2_K));

    % --- 2. Mattoncino 2: Call Vanilla con strike KO ---
    d1_KO = (log(F0 / KO) + 0.5 * sigma^2 * T) / (sigma * sqrt(T));
    d2_KO = d1_KO - sigma * sqrt(T);
    Call_KO = B * (F0 * normcdf(d1_KO) - KO * normcdf(d2_KO));

    % --- 3. Mattoncino 3: Opzione Digitale (Cash-or-Nothing) in KO ---
    % Un'opzione che paga esattamente 1€ se a scadenza il prezzo supera KO.
    % Il suo valore attuale matematico è semplicemente B * N(d2_KO)
    Digital_KO = B * normcdf(d2_KO);

    % --- 4. Prezzo Finale (Portafoglio di Replica Statica) ---
    % Sottraiamo la Call(KO) per bloccare i guadagni oltre la barriera (Bull Spread)
    % Sottraiamo la Digitale moltiplicata per il guadagno residuo (KO - K) per azzerarli
    price = Call_K - Call_KO - (KO - K) * Digital_KO;
    
end