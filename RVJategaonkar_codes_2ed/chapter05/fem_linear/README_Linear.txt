In this directory all programs referred to in 
    Chapter 5: Filter Error Method (for linear systems)
    "Flight Vehicle System Identification - A Time Domain Methodology" 
    Second Edition
    Author: Ravindra V. Jategaonkar
    published by AIAA, Reston, VA 20191, USA
are provided.

+---------------------------------------------------------------------------------------------+
ml_fem_lin2.m     - Main program;
                    The estimation program 'ml_fem_lin' provides an option to analyze
                    different test cases. Each test is to be uniquely defined by the
                    user. The user interface is through the model definition function
                    mDefCasexx.m, details of which are provided later in this readme.
axpxat.m          - Solve the matrix (Lyapunov) equation AX + XA' = B, where A is symmetric
costfun_fem_lin.m - Computation of cost function  
fcompn_lin.m      - Compensation of process noise distribution matrix F to compensate
                    for the R revision
gainmat_lin.m     - Computation of Kalman gain matrix
gradFG_lin.m      - Compute the sensitivity matrix gradY(i,j)=dy(i)/dTheta(j); as well as
                    the information matrix F = gradY'*RI*gradY and gradient G = gradY'*RI*(z-y)
gradK.m           - Compute the gradients of the Kalman gain matrix 
gradxy_lin.m      - Compute the gradients of the state variables graXT(i,j)=dxtilde(i)/dtheta(j)
kcle1_lin.m       - Constrained optimization for the diagonal elements of KC <= 1
lyapun.m          - Compute gradients of covariance matrix P:
                    This requires solution of the Lyapunov equations, once for each parameter
                    to be estimated
mod_sysmat        - Build up system matrices A, B, C, D, and bias vectors BX, BY from
                    model defined in mDefCasexx.m at the start
par2sysmat.m      - Construct system matrices and bias vectors from estimated parameters
                    in the iterative loop
par_accuracy.m    - Print out final parameters and their standard deviations, correlations
sgl7.m            - Compute the gradients of the state variables gradXT(i,j)=dxtilde(i)/dtheta(j)
sgx7.m            - Compute the state sensitivity matrix d(xhat)/d(theta)

+---------------------------------------------------------------------------------------------+
Following test cases are analyzed applying the program ml_fem. 

No.   Short Description
 2    Lateral-directional motion, Nx=2, Ny=5, Nu=3; Simulated data with turbulence


+---------------------------------------------------------------------------------------------+
The functions for model definition and plotting estimation results are as follows:

Test  Model                           
case  Definition         Plot programs
 
  2   mDefCase02_lin.m   plots_TC02_oem_SimNoise.m 


      +---------------------------------------------------------------------------------------+
      Model definition for each test case is to be provided appropriately by the user.
      The following information is necessary and it is to be provided in the
      corresponding model-definition function (mDefCasexx.m)

      param.names   Alphanumerical names of all the parameters appearing in the system
                    matrices A, B, C, D and of the bias parameters BX and BY.
      param.values  Numerical values of all the parameters appearing in the system
                    matrices A, B, C, D and of the  bias parameters BX and BY.
      param.flags   Integer flag for all the system and bias parameters to keep it free
                    (to be estimated) or fixed at pre-defined starting value
                    = 0 -> fixed; = 1 -> free (to be estimated)

      Anames        Define system state matrix A using alphanumeric names defined in param.names 
      Bnames        Define system input matrix B using alphanumeric names defined in param.names
      Cnames        Define state output matrix C using alphanumeric names defined in param.names
      Dnames        Define input output matrix D using alphanumeric names defined in param.names
      Fnames        Define process noise distribution matrix F using alphanumeric names defined
                    in param.names
      BXnames       Define state bias vector BX using alphanumeric names defined in param.names
      BYnames       Define output bias vector BX using alphanumeric names defined in param.names


      The model size is automatically fixed through the definition of system matrices and bias 
      parameters:
      Nx            Number of state variables  (= size(Anames,1))
      Nu            Number of input variables  (= size(Bnames,2))
      Ny            Number of output variables (= size(Cnames,1))
      
      dt            Sampling time
      Ndata         Total number of data points for Nzi time segments
      t             Time vector
      Z             Observation variables: Data array of measured outputs (Ndata,Ny)
      Uinp          Input variables: Data array of measured input (Ndata,Nu)
      
      x0            Initial conditions on state variables
      
      iSD           Flag to specify optionally initial R (default; 0) 
      SDyError      standard-deviations of output errors to compute initial covariance matrix R
                    (required only for iSD ~= 0)

+---------------------------------------------------------------------------------------------+
Following is a list of options for the program 'ml_fem':

tolR          Termination criterion (convergence limit):
              in terms of relative change in the cost function (typically, = 1e-4)
niter_max     Maximum number of iterations
iterFupR      Iteration count from which F-estimate will be corrected using 
              latest R-estimate (typically, = 3)

+---------------------------------------------------------------------------------------------+
