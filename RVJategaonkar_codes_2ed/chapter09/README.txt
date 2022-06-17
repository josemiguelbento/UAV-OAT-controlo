This is a directory for:
    Chapter 09: Unstable Aircraft Identification
    "Flight Vehicle System Identification - A Time Domain Methodology"
    Second Edition
    Author: Ravindra V. Jategaonkar
    published by AIAA, Reston, VA 20191, USA


eig_uAC_ID.m     - Compute eigenvalues of system matrix estimated applying different
                   methods; Unstable aircraft - simulated data

uAC_regLS.m      - Least squares estimates solving Normal equation;
                   Unstable aircraft (simulated data), short period motion
uAC_regTLS.m     - Total Least squares estimates;
                   Unstable aircraft (simulated data), short period motion

LS_Stat          - Computation of model output, the standard deviations of estimates, 
                   the relative standard deviations, and the R-square statistics of 
                   LS/TLS etsimates
ndiff_Filter08.m - Differentiate specified measured signal -- Multiple time segments


Note:
The test cases 6, 7, 8, 9, 10 applying 'ml_oem2' are run from /FVsysID2/chapter04/.
The test case  8 applying 'ml_fem' is run from /FVsysID/chapter05/.
The test case  8 applying 'mainRPE' is run from /FVsysID/chapter07/.
In each of these cases the flag test_case is to be set appropriately.

