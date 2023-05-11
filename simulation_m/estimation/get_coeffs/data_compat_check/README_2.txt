11-March-2014:
In this directory all programs are provided those cater to:
Output error method using the unconstrained Gauss-Newton, bounded variable
Gauss-Newton, or Levenberg-Marquardt optimization as described in the:
    Chapter 4 "Output Error Method"
    "Flight Vehicle System Identification - A Time Domain Methodology" 
    Second Edition
    Author: Ravindra V. Jategaonkar
    published by AIAA, Reston, VA 20191, USA.

Compared to the basic software provided with the first edition (published 2006), 
this extended software, which is a part of Second Edition (2014), has been 
significantly modified to enable: 
1) Optimization by Bounded-Variable Gauss-Newton method (BVGN) - Chapter 4, Section 11, 
   BVGN will be applied when lower and bounds are specified for parameters. Any 
   arbitrary combination of keeping parameters fixed or free (i.e.,estimating them)
   is possible. 
2) Estimation of initial conditions X0 for multiple time segments:
   The initial conditons to be estimated are specified through the flags 
   parFlagX0(Nx,Nzi), where Nx is the number of state variables and Nzi is the number
   of time segments. Any arbitrary combination of free and fixed initial conditions
   for any of the time segments is possible.
3) An additonal option of line search option to over come intermediate divergence
   if encouneted with the unconstrained Gauss-Newton method - section 4.10.B, Eq. (4.35),
   This option is invoked by setting the flag LineSrch in the model definition function
   mDefCaseXX.m (=0, No line search, =1, Line search). If it is set to zero, then in the
   case of intermediate divergence the heuristic procedure of parameter halving as 
   described in the section 4.10.A is applied (as was the case in the first edition).
4) Estimation of bias parameters bXpar separatly for each time segment.
5) Estimation of time delays through delay matrix discussed in Section 3.4.

The above modifications results in expanding the scope of the software for output error
method significantly. Minor bugs in minF_quad.m and ndiff_filter08.m were eliminated.

CAVEAT: 
Due to thess extensions, several functions were modified. Furthermore, for better 
understandability, some parts were changed by putting them in a new function. 
Due to these extensions, the interface for model definition had to be changed.
The number and sequence of arguments/parameters being passed to the model definition 
function mDefCaseXX.m  for test cases in the Second Edition is now different compared
to that reported in the First Edition of book published in 2006.
Accordingly, to use this extended version, it is necessary to change/adapt the hitherto
model definition functions for various test cases to include lower/upper bounds 
(param_min/param_max), and the number of such bounds (Nminmax).

The two user functions defining the state and observation equations (i.e., state_eq 
and obser_eq), however, remain unchanged.
        
For unconstrained Guass-Newton optimization (i.e. Nminmax=0, param_min=-Inf and
param_max=Inf), the algorithm yields the same results as those from the basic software 
provided originally with the first edition of the book in 2006.
  
The additions to the existing software/model definitions are marked in the following 
through "==>" in this README.

+-------------------------------------------------------------------------------------+
The programs/functions belong to three main categories: 
    1) graphical demonstration of optimization procedure,
    2) Maximum-likelihood output error method (ml_oem) - the central estimation method, 
    3) utility functions for filtering noisy data and for differentiation

ExNonQuadFun.m    - Example of optimization of a nonquadratic function
ExQuadFun.m       - Example of optimization of a quadratic function

ml_oem2.m         - Main program; includes Gauss-Newton method.
                    The estimation program 'ml_oem2' provides an option to analyze
                    different test cases. Each test is to be uniquely defined by the
                    user. The user interface is through the model definition function
                    mDefCasexx.m, details of which are provided later in this README_2
chk_lub_opt.m     - Check optimality conditions for parameters hitting the lower or
                    upper bounds
chk_update.m      - Active set strategy for bounded-variable GN method.
costfun_oem.m     - Computation of cost function  
delParPurge.m     - Purges the parameter update vector to free parameters only.
gradFG.m          - Computation of the information matrix F and gradient vector G.
gradrespH.m       - Computation of response gradients H, i.e., dy/dTheta
improv.m          - Computation of parameter increments by Gauss-Newton method 
                    (unconstrained or bounded-variable)
LMmethod.m        - Levenberg-Marquardt method 
mDefCHK_oem.m     - Check model defined in mDefCase**.m 
minf_quad.m       - One dimensional line search
par_accuracy.m    - Print out final parameters and of their standard deviations and 
                    correlations
parDecomp.m       - Decompose paramX0 into param and x0                 
parFillup.m       - Expand (fillup) parameter vector param of size Npar_free to 
                    full size of Nparam and then fill up with free x0's
parStepLM.m       - Compute updated system parameters and initial conditions for 
                    given step size of Levenberg-Marquardt method.
parUpdate.m       - Update parameter vector param, initial conditions x0, and 
                    bias parameters bX;    
ruku2.m           - Numerical integration by Runge-Kutta 2nd order
ruku3.m           - Numerical integration by Runge-Kutta 3rd order
ruku4.m           - Numerical integration by Runge-Kutta 4th order
                 

ndiff_Filter08.m  - Differentiate specified measured signal -- Multiple time segments
ndiff_pqr.m       - Generate pdot, qdot, rdot by differentiation of p, q, r       
smoothMulTS.m     - Filter noisy flight measured data -- Multiple time segments
TimeDelay.m       - Time delay the specified signal by tDelay         

+-------------------------------------------------------------------------------------+
Following test cases are analyzed applying the program ml_oem2. 
They may appear in different chapters.

No.   Short Description
 1    Lateral-directional motion, Nx=2, Ny=5, Nu=3; test aircraft ATTAS      
 2    Lateral-directional motion, Nx=2, Ny=5, Nu=3; Simulated data with turbulence
 3    Lateral-directional motion, Nx=2, Ny=2, Nu=3; test aircraft ATTAS
      (similar to test_case=1, but with only 2 observations variables)
 4    Longitudinal motion (Cl, CD, Cm), Nx=4; Ny=7; Nu=2; test aircraft HFB-320
 
 6    Unstable aircraft, short period, simulated data, combined LS/OEM 
 7    Unstable aircraft, short period, simulated data, Equation Decoupling
 8    Unstable aircraft, short period, simulated data, Output Error Method
 9    Unstable aircraft, short period, simulated data, Stabilized Output Error Method
10    Unstable aircraft, short period, simulated data, Eigenvalue Transformation

11    Short period motion, Nx=2, Ny=2, Nu=1, test aircraft ATTAS

22    Flight path reconstruction, ATTAS longitudinal and lateral-directional motion 
      Nx=7, Nu=6, Ny=x; nE=3 (multiple time segments)

23    Aerodynamic model identification by regression, ATTAS longitudinal and lateral-
      directional motion
24    Same as testCase = 23, but nonlinear in CD
27    Attas Regression NL -- Quasi-steady stall (longitudinal mode only)

31    Lateral-directional motion, Nx=2, Ny=5, Nu=3; test aircraft ATTAS  
      Same as Test Case01, but with time delay in yaw rate (for demo purpose)
   
32    Similar to TC22 (Attas FPR), but with BX separtely for each time segment
33    Similar to TC22 (Attas FPR), but with estimation of time delays in alpha, 
      beta, psi
                               
34    Similar to TC01, but with BX separtely for each time segment


+-------------------------------------------------------------------------------------+
The functions for model definition, observation equations, state equations, and 
plotting estimation results are as follows:

+---------------------------- Function names -----------------------------------------+
Test  Model                           
case  Definition     Observation equations        State equations           Plot programs
 
  1   mDefCase01.m   obs_TC01_attas_lat.m         xdot_TC01_attas_lat.m     plots_TC01_oem_lat.m
  2   mDefCase02.m   obs_TC02_dhc2_lat.m          xdot_TC02_dhc2_lat.m      plots_TC02_oem_SimNoise.m 
  3   mDefCase03.m   obs_TC03_attas_latPR.m       xdot_TC03_attas_latPR.m   plots_TC03_oem_latPR.m
  4   mDefCase04.m   obs_TC04_hfb_lon.m           xdot_TC04_hfb_lon.m       plots_TC04_oem_hfb.m
  
  6   mDefCase06.m   obs_TC06_uAC_RegSt.m         xdot_TC06_uAC_RegSt.m     plots_TC08_oem_uAC.m
  7   mDefCase07.m   obs_TC08_uAC.m               xdot_TC07_uAC_EqDecoup.m  plots_TC08_oem_uAC.m
  8   mDefCase08.m   obs_TC08_uAC.m               xdot_TC08_uAC.m           plots_TC08_oem_uAC.m
  9   mDefCase09.m   obs_TC08_uAC.m               xdot_TC08_uAC.m           plots_TC08_oem_uAC.m
 10   mDefCase10.m   obs_TC08_uAC.m               xdot_TC10_uAC_EigT.m      plots_TC08_oem_uAC.m

 11   mDefCase11.m   obs_TC11_lon_sp.m            xdot_TC11_lon_sp.m        plots_TC11_oem_sp.m

 22   mDefCase22.m   obs_TC22_fpr.m               xdot_TC22_fpr.m           plots_TC22_oem_fpr.m

 23   mDefCase23.m   obs_TC23_attas_regLonLat.m   xdot_attas_reg.m          plots_TC23_attas_regLonLat.m
 24   mDefCase24.m   obs_TC24_attas_regNL.m       xdot_attas_reg.m          plots_TC23_attas_regLonLat.m
 27   mDefCase27.m   obs_TC27_attas_regStall.m    xdot_attas_reg.m          plots_TC27_oem_regQStall.m

      The test cases 23, 24, and 27 need the function umr_reg_attas.m for 
      data pre-processing:
      umr_reg_attas.m:  Compute aerodynamic force and moment coefficients referred
                        to aerodynamic center (moment reference point) from measured
                        accelerations and angular rates; for test aircraft ATTAS.

 31   mDefCase31.m   obs_TC31_attas_lat.m         xdot_TC31_attas_lat.m     plots_TC01_oem_lat.m

      +-------------------------------------------------------------------------------+
      Model definition for each test case is to be provided appropriately by the user.
      The following information is necessary and it is to be provided in the
      corresponding model-definition function (mDefCaseXX.m)

      state_eq     Function to code right hand sides of state equations       
      obser_eq     Function to code right hand sides of observation equations
      Nx           Number of states 
      Ny           Number of observation variables
      Nu           Number of input (control) variables
      NparSys      Number of system parameters
      Nparam       Total number of system and bias parameters
      NparID       total number of parameters to be estimated (free parameters)
==>   Nminmax      Number of lower and upper bounds specified
      dt           Sampling time
      Ndata        Total number of data points for Nzi time segments
      Nzi          Number of time segments (maneuvers) to be analyzed simultaneously
      izhf         cumulative index at which the maneuvers end when concatenated
      t            Time vector
      Z            Observation variables: Data array of measured outputs (Ndata,Ny)
      Uinp         Input variables: Data array of measured input (Ndata,Nu)
      param        Initial starting values for unknown parameters;
                   must be within the specified param_min and param_max bounds 
      parFlag      Flags for free and fixed parameters
==>   param_min    Lower bounds on the parameters
==>   param_max    Upper bounds on the parameters
      x0           Initial conditions on state variables for Nzi time segments
      iArtifStab   Integer flag to invoke artificial stabilization
                   = 0: No artificial stabilization
                   > 0: Artificial stabilization (needs StabMat)
      StabMat      Artificial stabilization matrix; (Nx,Ny); nonzero only for 
                   iArtifStab>0           
==>   LineSrch     Flag for line search option in the Gauss-Newton method
==>   parFlagX0    Flags for free and fixed initial conditions; (1:Nx, 1:Nzi)
==>   NX0ID        Total number of free initial conditions
==>   bXpar        bias parameters for each time segment
==>   parFlagBX    flags for free and fixed bXpar
==>   NbX          number of bias parameter per time segment (includes both fixed and free)
==>   NBXID        total number of free (to be estimated) bias parameters
      For Bounded-Variable Gauss-Newton method, the initial parameter values (param) 
      must be within the specified lower and upper bounds (param_min and param_max).

+-------------------------------------------------------------------------------------+
Following is a list of options for the program 'ml_oem':
iOptim        Integer flag for the choice of optimization method:
              = 1: Gauss-Newton; 
              = 2: Levenberg-Marquardt
integMethod   Choose numerical integration method
              ruku2 = Runge-Kutta 2nd order
              ruku3 = Runge-Kutta 3rd order
              ruku4 = Runge-Kutta 4th order

par_step      Relative parameter perturbation size for gradient computation by  
              numerical approximation (typically, = 1e-6)
tolR          Termination criterion (convergence limit):
              in terms of relative change in the cost function (typically, = 1e-4)
niter_max     Maximum number of iterations
+-------------------------------------------------------------------------------------+
