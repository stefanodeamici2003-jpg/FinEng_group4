function price = EuropeanBarrierClosed(F0, K, KO, B, T, sigma)
    % European Up-and-Out Call (European Barrier checked only at T)
    % price = VanillaCall(K) - VanillaCall(KO) - (KO - K) * DigitalCall(KO)
    
    % --- Standard d1, d2 for strike K ---
    d1_K = (log(F0/K) + 0.5 * sigma^2 * T) / (sigma * sqrt(T));
    d2_K = d1_K - sigma * sqrt(T);
    
    % --- Standard d1, d2 for strike KO ---
    d1_B = (log(F0/KO) + 0.5 * sigma^2 * T) / (sigma * sqrt(T));
    d2_B = d1_B - sigma * sqrt(T);
    
    % 1. Price of Vanilla Call with strike K
    Call_K = B * (F0 * normcdf(d1_K) - K * normcdf(d2_K));
    
    % 2. Price of Vanilla Call with strike KO
    Call_B = B * (F0 * normcdf(d1_B) - KO * normcdf(d2_B));
    
    % 3. Price of Cash-or-nothing Digital Call with strike KO
    % This pays (KO - K) if F_T > KO
    Digital_B = B * (KO - K) * normcdf(d2_B);
    
    % Final Price: The vanilla call minus the parts where FT > KO
    price = Call_K - Call_B - Digital_B;
    
    % Safety check: if the Forward is already above the barrier, 
    % the formula handles it, but prices must be non-negative.
    price = max(price, 0);
end