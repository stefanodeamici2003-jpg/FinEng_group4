function optionPrice = EuropeanOptionAmericanBarrier(F0, K, KO, B, T, sigma, q, N)
    % INPUT:
    % F0:    forward price
    % B:     discount factor
    % K:     strike
    % T:     time-to-maturity
    % sigma: volatility
    % N:     either number of time steps (knots for CRR tree)
    %        or number of simulations in MC   
    % flag:  1 call, -1 put

    % 1 Initial Parameters
    dt = T / N;                  % size of the single time step
    u = exp(sigma * sqrt(dt));   % up factor
    d = 1 / u;                   % down factor
    p = (1 - d) / (u - d);       % risk-neutral probability
    r = -log(B)/T;
    
    % Payoff calculation at maturity (Time T, Step N)
    FN = F0 * u.^(0:N) .* d.^(N:-1:0);
    V = max(FN-K, 0);
    
    % Check V before entering the loop
    V(FN >= KO) = 0;

    % Backward Induction
   for step = (N-1) : -1 : 0

        % Continuation Value
        V = p * V(2:end) + (1 - p) * V(1:end-1);

        % Time in the induction
        t_step = step * dt;
        
        % Forward prices in t
        F_t = F0 * (u.^(0:step)) .* (d.^(step:-1:0));
        
        % Calculation of S_t from F_t
        S_t = F_t * exp(-(r - q) * (T - t_step));
        
        % whenever the stok value gets over the KO barrier then we set the
        % continuation value to 0
        V(S_t >= KO) = 0;

       
        
    end
    
    % Discounting to time zero
    optionPrice = B * V(1);
end