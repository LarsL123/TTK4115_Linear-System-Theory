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
J_p = 2*m_p*l_p^2;
K_1 = L_1/J_p;

%Pole placement
lambda_1 = -10;
lambda_2 = -10;
K_pp = (lambda_1*lambda_2)/K_1;
K_pd = -(lambda_1+lambda_2)/K_1;
