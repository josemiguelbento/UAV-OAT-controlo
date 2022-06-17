In this directory all programs referred to in 
    Chapter 7: Recursive Parameter Estimation
    "Flight Vehicle System Identification - A Time Domain Methodology" 
    Second Edition
    Author: Ravindra V. Jategaonkar
    published by AIAA, Reston, VA 20191, USA
are provided.

+---------------------------------------------------------------------------------------------+
attas_regLS_RLS    - least squares and recursive least squares method applied to 
                     estimate aerodynamic parameters of force and moment coefficients
                     CD, CY, CL, Cl, Cm, Cn. This is the equivalent of the test_case 23 
                     analyzed using /FVSysID/chapter04/ml_oem.

mainRPE.m          - Main program for recursive parameter estimation;
efrls.m            - State estimator without knowledge of noise covariances
                     Extended forgetting factor Recursive Least Squares (RLS) method 
                     for parameter estimation:
ekf_mod.m          - Extended Kalman Filter (EKF), 
                     with state augmentation for parameter estimation
ftr_mod.m          - Frequency Transform Regression (FTR) function for parameter estimation
LS_Stat            - Computation of model output, the standard deviations and the relative
                      standard deviations of estimates, and the R-square statistics of the
                      LS/TLS estimates
mDefCase**         - Definition of model, flight data, initial values etc. for test case **
mDefCHK            - Check model defined in mDefCase**
ndiff_Filter08.m   - Differentiate specified measured signal -- Multiple time segments
obs_TC**_**        - Observation equations for test case **
plots_**           - plot time histories and parameter estimates for test case **
prnt_par_std.m     - Print out final parameters and their standard deviations
RLSff              - Recursive least squares method with forgetting factor:
                     Section 7.2.1 and 7.2.2 
ruku4_aug.m        - Numerical integration of augmented states by Runge-Kutta 4th order
ruku4_augNoise     - Numerical integration of augmented states by Runge-Kutta 4th order,
                     extended version of ruku4_aug with noise variables as states
sysmatA.m          - Linearized state matrix A = df/dx
sysmatC.m          - Linearized observation matrix C = dg/dx
ukf_mod            - Unscented Kalman filter for state and parameter estimation:
                     Simplified case of additive noise.
ukf_mod_augmented  - Unscented Kalman filter for state and parameter estimation:
                     General case of noise entering nonlinearly in the system; needs
                     additionally state augmentation through process and measurement noise.
umr_reg_attas.m    - Compute aerodynamic force and moment coefficients referred to
                     aerodynamic center (moment reference point) from measured
                     accelerations and angular rates; for test aircraft ATTAS.
weightFun_Lamda    - Exponential weighting function with forgetting factor for RLS (Figure 7.1)
smoothMulTS.m      - Filter noisy flight measured data -- Multiple time segments
xdot_TC**_**       - State equations for test case **

+---------------------------------------------------------------------------------------------+
Following test cases are analyzed applying the program ml_fem. 
They may appear in different chapters.

No.   Short Description
 3    Lateral-directional motion, Nx=2, Ny=2, Nu=3; test aircraft ATTAS

 4    Longitudinal motion (Cl, CD, Cm), Nx=4; Ny=7; Nu=2; test aircraft HFB-320

 8    Unstable aircraft, short period, simulated data, Output Error Method

11    Short period motion, Nx=2, Ny=2, Nu=1, test aircraft ATTAS

+---------------------------------------------------------------------------------------------+
test_case	integer flag for the test case

method	    flag to choose the RPE method
		    EKF:    Extended Kalman Filter
		    UKF:    Unscented Kalman Filter (simplified case of additive process and 
			        measurement noise)
		    UKFaug: Augmented Unscented Kalman Filter (general case of state augmentation
			        through process and measurement noise)
		    EFRLS:	State estimator without knowledge of noise covariances
		    FTR:    Fourier Transform Regression
		    ALL:    Sequential application of EKF, UKF, UKFaug, EFRLS,and FTR


+---------------------------------------------------------------------------------------------+
The functions for model definition, observation equations, state equations and plotting
estimation results as follows:

      +----------------------------------- Function names ------------------------------------+
Test  Model                           
case  Definition     Observation equations   State equations           Plot programs
 
  3   mDefCase03.m   obs_TC03_attas_latPR.m  xdot_TC03_attas_latPR.m   plots_TC03_oem_latPR.m

  4   mDefCase04.m   obs_TC04_hfb_lon.m      xdot_TC04_hfb_lon.m       plots_TC04_oem_hfb.m

  8   mDefCase08.m   obs_TC08_uAC.m          xdot_TC08_uAC.m           plots_TC08_oem_uAC.m

 11   mDefCase11.m   obs_TC11_lon_sp.m       xdot_TC11_lon_sp.m        plots_TC11_oem_sp.m

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
      Nxp          Total number of states (=system states + parameters, i.e. Nx + NparID)

      dt           Sampling time
      Ndata        Total number of data points for Nzi time segments
      t            Time vector
      Z            Observation variables: Data array of measured outputs (Ndata,Ny)
      Uinp         Input variables: Data array of measured input (Ndata,Nu)

      param        Initial starting values for unknown parameters (aerodynamic derivatives) 
      parFlag      Flags for free and fixed parameters
      NparID       Total number of parameters to be estimated (free parameters)
      xa0          Starting values for the augmented state vector (system states + parameters)
      delxa        Perturbations to compute approximations of system matrices 

      rr           Measurement noise covariance matrix - R0(Ny): only diagonal terms
      qq           Process noise covariance matrix - Only diagonal terms qq(Nxp)
                   (The qq-elements (1:Nx) corresponding to the Nx system states should 
                    reflect process noise (turbulence) level. On the other hand, those for 
                    the parameters (Nx+1:Nxp), they should reflect the uncertainty in the
                    expected parameters estimates or variations in the parameters.
                    Accordingly, if system parameters remain constant, then qq((Nx+1:Nxp)
                    should be small, whereas if parameters vary significantly due to any
                    reason whatsoever, then the corresponding qq should be large to
                    allow tracking of the variations).

      p0           Initial State propagation error covariance matrix - pcov(Nxp): 
                   Only diagonal terms
      
+---------------------------------------------------------------------------------------------+
Following is a list of options for the program 'ml_fem':

EFRLS method:
lamda          Forgetting factor (typically, = 0.998)

FTR method:
Uprate         update rate for FFT (typically, = 1)   
OmegaHz        Range of frequency in Hz (typically, = 0.2 to 1.5 for longitudinal motion) 

UKF and UKF_aug (typical values for the scaling parameters)
alpha = 0.5000;
beta  = 2;
kappa = 3 - Nxp;


+---------------------------------------------------------------------------------------------+
