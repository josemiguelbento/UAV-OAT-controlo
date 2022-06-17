Chapter 8: Artificial Neural Networks
"Flight Vehicle System Identification - A Time Domain Methodology"
Second Edition
Author: Ravindra V. Jategaonkar
Published by AIAA, Reston, VA 20191, USA

The program "mainFFNN" caters to modeling using feed forward neural network.

It has been currently developed for FFNN with a single hidden layer, which is
found adequate for the test cases.

The structure of 'mainFFNN' is somewhat similar to that of other main programs
such as ml_oem, ml_fem, and mainRPE.

It is required to define a test_case to be analyzed.
Once this is done, the input/output subspace to be modeled using FFNN needs to
be defined in the function 'mDefCasexx.m'.

The number of neurons (nodes) in the hidden layer are to be inputted interactively;
the number of nodes in the input and output layers are automatically fixed through
the definition of input/output space.

The training of the FFNN is performed iteratively over the Ndata samples using
the back propagation algorithm. 

The number of samples (Ndata) is fixed by the definition of the input/output space.

The number of iterations is specified interactively (a fairly large number is usually
required for good predictive capability, say 400 to 600).

Data scaling is usually recommended for best training performnace.
The data is de-scaled after training and prediction for plotting purposes.

The mainFFNN has tested OK for three test cases
test_case =  4  (HFB-320, Longitudinal motion - data with turbulence)
test_case = 23  (ATTAS, Lateral-directional motion)
test_case = 27  (ATTAS, Quasi-steady stall longitudinal mode only)

In each case the default values of gain factors, step size and momentum term factor
lamda1 = 0.1;  lamda2 = 0.1;  mu = 0.8;  mmu = 0.5; 
were found adequate. 
These values may have to be adapted from case to case.