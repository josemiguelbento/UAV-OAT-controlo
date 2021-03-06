function G = compute_tf_model(x_trim,u_trim,P)

    G.Va_trim = sqrt(sum(x_trim(4:6).^2));
    G.theta_trim = x_trim(8);
%     chi_trim = x_trim(9); % No wind chi = psi (trim condition)
    alpha_trim = atan(x_trim(6)/x_trim(4));
    
    delta_e_trim = u_trim(1);
    delta_t_trim = u_trim(4);

    G.a_phi1 = -0.5*P.rho*G.Va_trim^2*P.S_wing*P.b^2*P.C_p_p/(2*G.Va_trim);
    G.a_phi2 = 0.5*P.rho*G.Va_trim^2*P.S_wing*P.b*P.C_p_delta_a;
    
    G.a_theta1 = -P.rho*G.Va_trim*P.c^2*P.S_wing*P.C_m_q/(4*P.Jy);
    G.a_theta2 = -P.rho*G.Va_trim^2*P.c^2*P.S_wing*P.C_m_alpha/(2*P.Jy);
    G.a_theta3 = P.rho*G.Va_trim^2*P.c^2*P.S_wing*P.C_m_delta_e/(2*P.Jy);
    
    G.a_beta1 = -P.rho*G.Va_trim*P.S_wing*P.C_Y_beta/(2*P.mass);
    G.a_beta2 = P.rho*G.Va_trim*P.S_wing*P.C_Y_delta_r/(2*P.mass);
    
    G.a_V1 = P.rho*G.Va_trim*P.S_wing*(P.C_D_0 + P.C_D_alpha*alpha_trim + ...
                                P.C_D_delta_e*delta_e_trim)/P.mass + ...
                                P.rho*P.S_prop*P.C_prop*G.Va_trim/P.mass;
                
    G.a_V2 = P.rho*P.S_prop*P.C_prop*P.k_motor^2*delta_t_trim/P.mass;
   
    %G.a_V3 = P.gravity*cos(theta_trim - chi_trim);
    G.a_V3 = P.gravity;
    

    % transfer functions
    
%     T_phi_delta_a   = tf(G.a_phi2,[1,G.a_phi1,0]);
%     T_p_delta_a   = tf(G.a_phi2,[1,G.a_phi1]);
%     T_chi_phi       = tf(P.gravity/G.Va_trim,[1,0]);
%     T_theta_delta_e = tf(G.a_theta3,[1,G.a_theta1,G.a_theta2]);
%     T_theta_dot_delta_e = tf([G.a_theta3 0],[1,G.a_theta1,G.a_theta2]);
%     T_h_theta       = tf(G.Va_trim,[1,0]);
%     T_h_Va          = tf(theta_trim,[1,0]);
%     T_Va_delta_t    = tf(G.a_V2,[1,G.a_V1]);
%     T_Va_theta      = tf(-G.a_V3,[1,G.a_V1]);
%     T_Va_theta      = tf(-G.a_V3,[1,G.a_V1]);
%     T_Va            = tf(1,[1,G.a_V1]);
%     T_v_delta_r     = tf(G.a_beta2,[1,G.a_beta1]);
    
end

