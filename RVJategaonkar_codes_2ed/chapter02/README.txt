In this directory '/FVSysID2/chapter02/' all programs referred to in the 
    Chapter 2 "Data Gathering" of
    "Flight Vehicle System Identification - A Time Domain Methodology" 
    Second Edition
    Author: Ravindra V. Jategaonkar
    published by AIAA, Reston, VA 20191, USA
are provided.

binomialCoeff.m                    -  Computes the binomial coefficient for given n and k.
Comp_FreqResp_diff.m               -  computes magnitude response H(Omega) of a differentiator
                                      according to equation (2.20)
Comp_FreqResp_filter.m             -  Computes magnitude response H(Omega) of a filter/smoother
                                      according to equation (2.14)
EnergyDblt121.m                    -  Computes power spectra of doublet and 121 input.                      
EnergyDoublet.m                    -  Computes power spectrum of doublet input.
EnergyImpDbltS3211M3211.m          -  Computes power spectra of impulse, doublet, 3-2-1-1,
                                      and modified 3-2-1-1 inputs.
EnergyImpDbltS3211M3211_smallDT.m  -  Same as EnergyImpDbltS3211M3211, but with smaller DT                         
EnergyImpulse.m                    -  Computes power spectrum of impulse input.
EnergySpectrum.m                   -  General function to compute spectrum of an arbitrary 
                                      multistep input signal according to Eq. (2.8)
filter_Sp_Hen_FreqResp.m           -  compute magnitude responses of Spencer, Henderson, and 
                                      ther simple running average filters
filter_Spencer_FreqResp.m          -  compute magnitude responses of Spencer and 
                                      other simple running average filters
FreqCompInput.m                    -  Computes magnitudes of each term with respect to input
                                      for the cases considered in section 2.3.2, see Eq. (2.7)
HendersonCoeff.m                   -  Computes Henderson filter coefficients
InputSigPSD.m                      -  General function to compute power spectral density
                                      of an arbitrary multistep input signal using FFT.
                                      Needs Signal Processing Toolbox.
ndiff_Filter02.m                   -  Numerical differentiation with filter 2nd order
                                      (works on multiple time segments)
ndiff_Filter04.m                   -  Numerical differentiation with filter 4th order
                                      (works on multiple time segments)
ndiff_Filter08.m                   -  Numerical differentiation with filter 8th order
                                      (works on multiple time segments)
ndiff_Filter12.m                   -  Numerical differentiation with filter 12th order
                                      (works on multiple time segments)
nDiff_FreqResp.m                   -  Computes magnitude responses of various differentiator
                                      filters
nDiff_FreqResp2.m                  -  Computes magnitude responses of selected differentiator
                                      filters
ndiff_Lanczos_p2n5                 -  Numerical differentiation with Lanczos formula
                                      using second order polynomial and five data points
                                      Eq. (2.21); works on multiple time segments)                                 
ndiff_Lanczos_p2n9                 -  Numerical differentiation with Lanczos formula
                                      using second order polynomial and nine data points
                                      Eq. (2.22); (works on multiple time segments)
ndiff_PavelH_p2n5.m                -  Smooth noise-robust differentiator by Pavel Holoborodko
                                      with five data points (Eq.  2.23)
ndiff_PavelH_p2n9.m                -  Smooth noise-robust differentiator by Pavel Holoborodko
                                      with nine data points (Eq.  2.23)
ndiff_SGolay_p2n5                  -  Numerical differentiation with Savitzky-Golay digital
                                      filter using second order polynomial and five data points
                                      (works on multiple time segments)
ndiff_SGolay_p2n9                  -  Numerical differentiation with Savitzky-Golay digital
                                      filter using second order polynomial and nine data points
                                      (works on multiple time segments)
ndiffVerify.m                      -  Simple program to verify the various differentiation
                                      functions (with known input - sine wave)
numDiffCoeff.m                     -  Computes coefficients of numerical differentiator
                                      with filter; Eqs. (2.17) to (2.19).
PSDImpDbltS3211M3211.m             -  Computes power spectra of impulse, doublet, 3-2-1-1,
                                      and modified 3-2-1-1 inputs (using InputSigPSD.m)
smooth.m                           -  Filter noisy flight measured data; Eqs. (2.13) and (2.14)
smoothMulTS.m                      -  Filter noisy flight measured data -- Multiple time 
                                      segments; Eqs. (2.13) and (2.14)


It also contains the following additional functions:

BwDbltS3211.m   
BwDbltS3211_smallDT.m   
EnergyS3211.m

which are not referred to in the text, but which may be useful to verify the logic behind
the discussion provided in the text.
