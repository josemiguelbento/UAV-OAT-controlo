This is a directory for:
    Chapter 03: Model Postulates and Simulation
    "Flight Vehicle System Identification - A Time Domain Methodology" 
    Second Edition
    Author: Ravindra V. Jategaonkar
    published by AIAA, Reston, VA 20191, USA

    
The 2nd, 3rd, and 4th order Runge-Kutta integration formulas elaborated
in Table 3.1 are coded in the following functions:

ruku2.m           - Numerical integration by Runge-Kutta 2nd order
ruku3.m           - Numerical integration by Runge-Kutta 3rd order
ruku4.m           - Numerical integration by Runge-Kutta 4th order

ruku4_aug.m       - Numerical integration by Runge-Kutta 4th order;
                    Specially tailored version for EKF, UKF and EFRLS to integrate 
                    augmented state vector xa=[x param], where the first derivatives
                    of the system states, xa(1:Nx), are computed in the state 
                    equations 'state_eq', and those of the parameters, 
                    xa(Nx+1:Nx+Nparam), being zero.

ruku4_augNoise.m  - Numerical integration by Runge-Kutta 4th order;
                    Specially tailored version for augmented UKF with noise 
                    variables as states, otherwise similar to ruku4_aug.
                    

The functions ruku2, ruku3, and ruku4 are required in the estimation programs
'ml_oem2' and 'ml_fem' described in chapters 4 and 5 respectively.

The functions ruku4_aug is required in the recursive parameter estimation program
mainRPE (EKF, UKF, and EFRLS) described in chapter 7, and ruku4_augNoise is required
in the program UKFaug described in chapter 7.