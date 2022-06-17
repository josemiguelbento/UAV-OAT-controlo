In this directory programs referred to in 
    Chapter 6: Equation Error Methods,
    "Flight Vehicle System Identification - A Time Domain Methodology" 
    Second Edition
    Author: Ravindra V. Jategaonkar
    published by AIAA, Reston, VA 20191, USA
are provided.

+---------------------------------------------------------------------------------------------+
attas_regLS.m  - Least squares method - classical Normal equation;
                 Estimation of aerodynamic parameters of force and moment coefficients
                 CD, CY, CL, Cl, Cm, Cn. This is the equivalent of the test_case 23 
                 analyzed using /FVSysID/chapter04/ml_oem.
attas_regTLS.m - Total least squares method  
                 Estimation of aerodynamic parameters of force and moment coefficients
                 CD, CY, CL, Cl, Cm, Cn. This is the equivalent of the test_case 23 
                 analyzed using /FVSysID/chapter04/ml_oem.
LS_Stat.m      - Computation of model output, the standard deviations of estimates, the
                 relative standard deviations, and the R-square statistics of LS/TLS etsimates


Besides above programs, the following programs are provided to demonstarte the 
multivariate LS/TLS method applied to multiple outputs:
attasLat_multivariateLS  - multivariate linear regression applied to multiple outputs (i.e,
                           dependent variables): Lateral-directional motion (CY, Cl, Cn).
attasLat_multivariateTLS - multivariate total least squares method applied to multiple outputs
                           (i.e, dependent variables): Lateral-directional motion (CY, Cl, Cn).
attasLon_multivariateLS  - multivariate linear regression applied to multiple outputs (i.e,
                           dependent variables): Longitudinal motion (CD, CL,  Cm).
attasLon_multivariateTLS - multivariate total least squares method applied to multiple outputs
                           (i.e, multipledependent variables): Longitudinal motion (CD, CL, Cm).
attasLonLat_mV_LS        - multivariate linear regression applied to multiple outputs (i.e, 
                           multiple dependent variables): Longitudinal and lateral-directional
                           motion (CD, CL, Cm, CY, Cl, Cn).
attasLonLat_mV_TLS       - multivariate total least squares method applied to multiple outputs 
                           (i.e, multiple dependent variables): Longitudinal and 
                           lateral-directional motion (CD, CL, Cm, CY, Cl, Cn).
                        

The above programs need the following function for data pre-processing:
umr_reg_attas.m  - Compute aerodynamic force and moment coefficients referred to
                   aerodynamic center (moment reference point) from measured
                   accelerations and angular rates; for test aircraft ATTAS.

ndiff_Filter08.m - Differentiate specified measured signal -- Multiple time segments
smoothMulTS.m    - Filter noisy flight measured data -- Multiple time segments

