In this directory all programs referred to in 
    Chapter 5: Filter Error Method,
    "Flight Vehicle System Identification - A Time Domain Methodology" 
    Second Edition
    Author: Ravindra V. Jategaonkar
    published by AIAA, Reston, VA 20191, USA
are provided.


+---------------------------------------------------------------------------------------------+
ml_fem2.m         - Main program;
                    The estimation program 'ml_fem' provides an option to analyze
                    different test cases. Each test is to be uniquely defined by the
                    user. The user interface is through the model definition function
                    mDefCasexx.m, details of which are provided later in this readme.
costfun_fem.m     - Computation of cost function  
fcompn.m          - Compensation of process noise distribution matrix F to compensate
                    for the RI revision
gainmat.m         - Computation of Kalman gain matrix
gainmatPert.m     - Computation of gain matrices for perturbed parameters and gradients of KC 
gradFG.m          - Computation of the information matrix F and gradient vector G
kcle1.m           - Constrained optimization for the diagonal elements of KC <= 1
par_accuracy.m    - Print out final parameters and their standard deviations, correlations
ruku4.m           - Numerical integration by Runge-Kutta 4th order
sysmatA.m         - Linearized state matrix A = df/dx
sysmatC.m         - Linearized observation matrix C = dg/dx


ml_fem2 is slightly modified verison of ml_fem (of first edition). The computational part 
remains the same; some changes done in the convergence check. ml_fem2 is modified in the 
case of local divergence encountered after F-update. If this happens, then ml_fem2 wil give
results whihc may be slightly different from ml_fem. If the convergence is smooth, and local
divergences are not encountered, then the two versions are identical. 

+---------------------------------------------------------------------------------------------+
Following test cases are analyzed applying the program ml_fem. 
They may appear in different chapters.

No.   Short Description
 2    Lateral-directional motion, Nx=2, Ny=5, Nu=3; Simulated data with turbulence

 4    Longitudinal motion (Cl, CD, Cm), Nx=4; Ny=7; Nu=2; test aircraft HFB-320

 8    Unstable aircraft, short period, simulated data, Output Error Method


+---------------------------------------------------------------------------------------------+
The functions for model definition, observation equations, state equations and plotting
estimation results as follows:

      +----------------------------------- Function names ------------------------------------+
Test  Model                           
case  Definition     Observation equations   State equations         Plot programs
 
  2   mDefCase02.m   obs_TC02_dhc2_lat.m     xdot_TC02_dhc2_lat.m    plots_TC02_oem_SimNoise.m 

  4   mDefCase04.m   obs_TC04_hfb_lon.m      xdot_TC04_hfb_lon.m     plots_TC04_oem_hfb.m

  8   mDefCase08.m   obs_TC08_uAC.m          xdot_TC08_uAC.m         plots_TC08_oem_uAC.m

+---------------------------------------------------------------------------------------------+
      Model definition for each test case is to be provided appropriately by the user.
      The following information is necessary and it is to be provided in the
      corresponding model-definition function (mDefCasexx.m)

      state_eq     Function to code right hand sides of state equations       
      obser_eq     Function to code right hand sides of observation equations
      Nx           Number of states 
      Ny           Number of observation variables
      Nu           Number of input (control) variables
      NparSys      Number of system parameters
      Nparam       Total number of system and bias parameters
      iSD          Flag to specify optionally initial R (default; 0) 

      dt           Sampling time
      Ndata        Total number of data points for Nzi time segments
      t            Time vector
      Z            Observation variables: Data array of measured outputs (Ndata,Ny)
      Uinp         Input variables: Data array of measured input (Ndata,Nu)

      param        Initial starting values for unknown parameters (aerodynamic derivatives) 
      parFlag      Flags for free and fixed parameters
      NparID       Total number of parameters to be estimated (free parameters)
      x0           Initial conditions on state variables

      SDyError     standard-deviations of output errors to compute initial covariance matrix R
                   (required only for iSD ~= 0)

+---------------------------------------------------------------------------------------------+
Following is a list of options for the program 'ml_fem2':

par_step      Relative parameter perturbation size for gradient computation by numerical 
              approximation (typically, = 1e-6)
tolR          Termination criterion (convergence limit):
              in terms of relative change in the cost function (typically, = 1e-4)
niter_max     Maximum number of iterations
iterFupR      Iteration count from which F-estimate will be corrected using 
              latest R-estimate (typically, = 3)

+---------------------------------------------------------------------------------------------+
