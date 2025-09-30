% FOR HELICOPTER NR 3-10
% This file contains the initialization for the helicopter assignment in
% the course TTK4115. Run this file before you execute QuaRC_ -> Build 
% to build the file heli_q8.mdl.

% Oppdatert høsten 2006 av Jostein Bakkeheim
% Oppdatert høsten 2008 av Arnfinn Aas Eielsen
% Oppdatert høsten 2009 av Jonathan Ronen
% Updated fall 2010, Dominik Breu
% Updated fall 2013, Mark Haring
% Updated spring 2015, Mark Haring


%%%%%%%%%%% Calibration of the encoder and the hardware for the specific
%%%%%%%%%%% helicopter
Joystick_gain_x = 1;
Joystick_gain_y = -1;


%%%%%%%%%%% Physical constants
g = 9.81; % gravitational constant [m/s^2]
l_c = 0.46; % distance elevation axis to counterweight [m]
l_h = 0.66; % distance elevation axis to helicopter head [m]
l_p = 0.175; % distance pitch axis to motor [m]
m_c = 1.92; % Counterweight mass [kg]
m_p = 0.72; % Motor mass [kg]

%Using v_s0 to find motor force constant K_f
v_s0 = 7.2;
K_f = (2*m_p*l_h*g - m_c*l_c*g)/(v_s0*l_h);


%Defining system constants
L_1 = l_p*K_f;
L_2 = l_c*m_c*g-2*m_p*g*l_h;
L_3 = K_f*l_h;
L_4 = l_h*K_f;
J_p = 2*m_p*l_p^2;
J_e = m_c*l_c^2 + 2*m_p*l_h^2;
J_lambda = m_c*l_c^2+2*m_p*(l_h^2+l_p^2);
K_1 = L_1/J_p;
K_2 = L_3/J_e;
K_3 = -(L_2*L_4)/(L_3*J_lambda);

%Pole placement
lambda_1 = -1;
lambda_2 = -1;
K_pp = (lambda_1*lambda_2)/K_1;
K_pd = -(lambda_1+lambda_2)/K_1;

q_11 = 10;
q_22 = 10;
q_33 = 10;
q_44 = 10;
q_55 = 10;

r_11 = 1;
r_22 = 1;

%Lqr cost matrices:
Q_lqr = diag([q_11 q_22 q_33 q_44 q_55]);
R_lqr = diag([r_11 r_22]);

%Defining system matrices:
A = [0 1 0 0 0; 0 0 0 0 0; 0 0 0 0 0; -1 0 0 0 0; 0 0 -1 0 0];
B = [ 0 0; 0 K_1; K_2 0; 0 0; 0 0];
G = [0 0;0 0;0 0;1 0; 0 1];
K = lqr(A,B,Q_lqr,R_lqr);
%F = [K(1,1) K(1,3); K(2,1) K(2,3)];
C = [1 0 0 0 0; 0 0 1 0 0];
F = [K(1,1) K(1,3); K(2,1) K(2,3)];

poles_plant = eig(A-B*K)

%Defining observer matrices
A_obs = [0 1 0 0 0;
        0 0 0 0 0;
        0 0 0 1 0;
        0 0 0 0 0;
        K_3 0 0 0 0];
B_obs = [ 0 0;
        0 K_1;
        0 0;
        K_2 0;
        0 0];

C_obs = eye(5);


luenberger_poles = [-2,-3,-2,-1.5,-3]
L_obs =place(A_obs', C_obs',luenberger_poles)'

poles_L = eig(L_obs) %snakke om i rapporten sjef??


PORT = 10;
