In this directory /FVSysID/flt_data/ all flight data files referred to in the 
    "Flight Vehicle System Identification - A Time Domain Methodology" 
    Author: Ravindra V. Jategaonkar
    published by AIAA, Reston, VA 20191, USA
are provided.

+---------------------------------------------------------------------------------------+
The following is the list of flight data files analyzed in the various test cases in 
Chapters 4 through 12:

fAttasAil1.mat               Aileron input (bank to bank) maneuver, test aircraft ATTAS

fAttasAilRud1.mat            Aileron input maneuver followed by a rudder input (1), 
                             test aircraft ATTAS
fAttasAilRud2.mat            Aileron input maneuver followed by a rudder input (2, repeat), 
                             test aircraft ATTAS

fAttasElv1.mat               Elevator input maneuver 1, test aircraft ATTAS
fAttasElv2.mat               Elevator input maneuver 2 (repeat), test aircraft ATTAS

fAttasRud1.mat               Rudder input maneuver, test aircraft ATTAS

fAttas_qst01.asc             Quasi steady stall maneuver (1), test aircraft ATTAS
fAttas_qst01_withHeader.asc  Same as "fAttas_qst01.asc", but with header information

fAttas_qst02.asc             Quasi steady stall maneuver (2, repeat), test aircraft ATTAS

hfb320_1_10.asc              Elevator 3-2-1-1 input followed by pulse input: longitudinal
                             motion, test aircraft HFB-320
hfb320_1_10_withHeader.asc   Same as "hfb320_1_10.asc", but with header information

unStabAC_sim.asc             Simulated unstable aircraft responses - short period motion
unStabAC_sim_header.asc      Same as "unStabAC_sim.asc", but with header information

y13aus_da1.asc               Simulated aircraft responses with process noise - lateral
                             directional motion with aileron and rudder inputs.
                             
The flight data files contain time histories of the inputs and the corresponding 
measured (simulated) aircraft responses. The data files are either in the Matlab
specific binary format (*.mat files) or in the ascii format (*.asc files).
These files are loaded in the model definition functions (mDefCaseTC**.m) 
appropriately for the test cases analyzed.

Since these files originate from different sources, they have different numbers
of channels and the their sequence may differ. Furthermore, the engineering units
of the variables may also be different from file to file. While loading the data 
and assigning the arrays Z(Ndata,Ny) and Uinp(Ndata,Nu) this needs to be kept in 
mind, where Ndata is the number of data points, Ny the number of outputs, and Nu 
the number of input. This has been taken care of for the test cases presented in
this book in the respective model definition functions (mDefCaseTC**.m).


Following is the list of recorded channels, giving variables names, units and
a short description of each recorded variable.

Test aircraft ATTAS: 
Data files: fAttas*.*

No.  Name     units      Short description             
1    T        s          time
2    AXCG     M/S**2     longitudinal acceleration at CG       
3    AYCG     M/S**2     lateral acceleration at CG
4    AZCG     M/S**2     vertical acceleration at CG
5    AYCKP    M/S**2     lateral acceleration in the cockpit  
6    AZCKP    M/S**2     vertical acceleration in the cockpit    
7    PRGX     DEG/S      roll rate      
8    QRGY     DEG/S      pitch rate
9    RRGZ     DEG/S      yaw rate   
10   PHI      DEG        bank angle
11   THE      DEG        pitch attitude
12   PSI      DEG        true heading
13   ALCG     DEG        angle of attack at CG
14   BECG     DEG        angle of sideslip at CG
15   VTASCG   M/S        true airspeed at CG
16   HQNH     ft         pressure altitude
17   PDOT     DEG/S2     roll acceleration
18   QDOT     DEG/S2     pitch acceleration 
19   RDOT     DEG/S2     yaw acceleration
20   HRADIO   M          radio altitude (above ground)
21   VCAS     M/S        calibrated airspeed     
22   DELV     DEG        elevator deflection
23   IHTRM    DEG        horizontal-tail trim angle
24   N1T1L    %          N1 engine rpm, left engine     
25   N1T2R    %          N1 engine rpm, right engine
26   DLC_L    DEG        equivalent direct-lift flaps deflection, left   
27   DLC_R    DEG        equivalent direct-lift flaps deflection, right      
28   DAIL_L   DEG        aileron deflection, left       
29   DAIL_R   DEG        aileron deflection, right       
30   DRUD     DEG        rudder deflection  
31   MACH     -          Mach number       
32   SAT      °K         static air temperature
33   PSTAT    hPa        static pressure       
34   RHO      Kg/m3      density of air   
35   PHLAT    DEG        latitude     
36   LALON    DEG        longitude
37   FN_L     N          engine thrust, left engine
38   FN_R     N          engine thrust, right engine
39   FUELUS   KG         fuel consumed
40   BEDOT    DEG/S      rate of change of angle of sideslip    
41   FW       -          landing gear position
42   ALDOT    DEG/S      rate of change of angle of attack
43   FLAP     DEG        landing flap position
44   DSPL_L   DEG        spoiler position, left
45   DSPL_R   DEG        spoiler position, right

--------------------------------------------------------------------------
Test aircraft HFB-320: 
Data file: hfb320_1_10.asc

1    T        S          time          
2    DELV     RAD        elevator deflection
3    PDYN     PA         dynamic pressure
4    THRUST   N          thrust     
5    TASCG    M/S        true airspeed at CG
6    ALFCG    RAD        angle of attack at CG
7    THE      RAD        pitch attitude
8    Q        RAD/S      pitch rate
9    QDOT     RAD/S2     pitch acceleration
10   AXCG     M/S2       longitudinal acceleration at CG
11   AZCG     M/S2       lateral acceleration at CG
12   AYCG     M/S2       vertical acceleration at CG
13   P        RAD/S      roll rate
14   R        RAD/S      yaw rate
15   PDOT     RAD/S2     roll acceleration
16   RDOT     RAD/S2     yaw acceleration
17   BETCG    RAD        angle of sideslip at CG
18   PHI      RAD        bank angle
19   DAIL     RAD        aileron deflection
20   DRUD     RAD        rudder deflection
                                 
--------------------------------------------------------------------------
Simulated unstable aircraft: 
Data file: unSatbAC_sim.asc

1    T        S          time       
2    DPlt     RAD        pilot command      
3    W        M/S        vertical velocity component     
4    Q        RAD/S      pitch rate      
5    DE       RAD        elevator deflection    
6    AZ       M/S2       vertical acceleration
                                                          
--------------------------------------------------------------------------
Simulated aircraft responses with process noise (turbulence): 
Data file: y13aus_da1.asc

 1       T      SEC                       
 2   PDOT2   RAD/S2   roll acceleration (measured)
 3   RDOT2   RAD/S2   yaw acceleration (measured)
 4     AY2     M/S2   lateral acceleration (measured)
 5      P2    RAD/S   roll rate (measured)
 6      R2    RAD/S   yaw rate (measured)
 7     DA2      RAD   aileron deflection (measured)
 8     DR2      RAD   rudder deflection (measured)
 9     VK2      M/S   lateral-velocity component (measured/derived)
10      P2    RAD/S   roll rate (measured state variable)
11      R2    RAD/S   yaw rate (measured state variable)
12   PDOT2   RAD/S2   roll acceleration (simulated)
13   RDOT2   RAD/S2   yaw acceleration (simulated)
14     AY2     M/S2   lateral acceleration (simulated)
15      P2    RAD/S   roll rate (simulated)
16      R2    RAD/S   yaw rate (simulated)
17     DA2      RAD   aileron deflection (measured)
18     DR2      RAD   rudder deflection (measured)
19     VK2      M/S   lateral-velocity component (measured/derived)
20      P2    RAD/S   roll rate (computed state variable)
21      R2    RAD/S   yaw rate (computed state variable)
22       -        -   Process noise
23       -        -   Process noise
24       -        -   measurement noise       
25       -        -   measurement noise       
26       -        -   measurement noise       
27       -        -   measurement noise      
28       -        -   measurement noise       

--------------------------------------------------------------------------
