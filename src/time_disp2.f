      subroutine time_disp2(pe,y,x)
!***********************************************************************
!  Copyright, 2004,  The  Regents  of the  University of California.
!  This program was prepared by the Regents of the University of 
!  California at Los Alamos National Laboratory (the University) under  
!  contract No. W-7405-ENG-36 with the U.S. Department of Energy (DOE). 
!  All rights in the program are reserved by the DOE and the University. 
!  Permission is granted to the public to copy and use this software 
!  without charge, provided that this Notice and any statement of 
!  authorship are reproduced on all copies. Neither the U.S. Government 
!  nor the University makes any warranty, express or implied, or 
!  assumes any liability or responsibility for the use of this software.
C***********************************************************************
CD1
CD1  PURPOSE
CD1
CD1  This subroutine handles dispersion for particle tracking by
CD1  interpolating between given curves for varying Peclet Number.
CD1
C***********************************************************************
CD2
CD2  REVISION HISTORY
CD2
CD2 $Log:   /pvcs.config/fehm90/src/time_disp2.f_a  $
!D2 
!D2    Rev 2.5   06 Jan 2004 10:44:22   pvcs
!D2 FEHM Version 2.21, STN 10086-2.21-00, Qualified October 2003
!D2 
!D2    Rev 2.4   29 Jan 2003 09:21:34   pvcs
!D2 FEHM Version 2.20, STN 10086-2.20-00
!D2 
!D2    Rev 2.3   14 Nov 2001 13:28:48   pvcs
!D2 FEHM Version 2.12, STN 10086-2.12-00
!D2 
!D2    Rev 2.2   06 Jun 2001 13:28:22   pvcs
!D2 FEHM Version 2.11, STN 10086-2.11-00
!D2 
!D2    Rev 2.1   30 Nov 2000 12:13:02   pvcs
!D2 FEHM Version 2.10, STN 10086-2.10-00
!D2 
!D2    Rev 2.0   Fri May 07 14:47:48 1999   pvcs
!D2 FEHM Version 2.0, SC-194 (Fortran 90)
CD2 
CD2    Rev 1.1   Thu Jan 11 12:04:22 1996   hend
CD2 Added Prolog and Revision Log
CD2
C***********************************************************************
CD3
CD3  REQUIREMENTS TRACEABILITY
CD3
CD3  2.3.5 Cell-based particle-tracking module
CD3
C***********************************************************************
CD4
CD4  SPEICAL COMMENTS AND REFERENCES
CD4
CD4 Requirements from SDN: 10086-RD-2.20-00
CD4   SOFTWARE REQUIREMENTS DOCUMENT (RD) for the 
CD4   FEHM Application Version 2.20
CD4
C***********************************************************************

      implicit none

      real yvals(16),pevals(13),xvals(16,13),slope(15,13)
      real pe,x,leftvalue,rightvalue,lftfrac,y
      integer i, i2

      data yvals / 1e-4,1e-3,.01,.05,.25,.5,.6,.7,.8,.85,.9,.92,.95,
     +     .97,.99,.9999 /
      data pevals / 1,1.5,2,3,4,6,8,12,20,40,100,200,1e3 /
      data xvals / 3.11161e-2,4.2595e-2,6.6614e-2,.107405,0.250613,
     +     0.514230,0.689677,0.952837,
     +     1.39779,1.76636,2.35826,2.71861,3.55260,4.56437,7.05283,10., 
     + 4.53811e-2,6.15569e-2,9.45931e-2,.148596,0.323655,0.611459,
     +     0.788415,1.04000,
     +     1.44034,1.75602,2.24297,2.53066,3.17858,3.94110,5.75267,10., 
     + 5.88942e-2,7.92185e-2,.119841,.184113,0.379723,0.675841,0.848286,
     +     1.08512,1.44789,
     +     1.72536,2.14303,2.38532,2.92208,3.54216,4.98409,10.,
     + 8.3931e-2,.111222,.163800,.242683,0.461145,0.756125,0.916122,
     +     1.12656,1.43421,
     +     1.66097,1.99237,2.18040,2.58870,3.04975,4.09358,8.97668,
     + .106679,.139555,.200999,.289428,0.518238,0.804339,0.952621,
     +     1.14252,1.41237,
     +     1.60684,1.88599,2.04225,2.37739,2.75050,3.58093,7.35310,
     + .146641,.187791,.261146,.360414,0.594514,0.859631,0.989499,
     +     1.15055,1.37170,
     +     1.52681,1.74467,1.86461,2.11798,2.39507,2.99850,5.63265,
     + .180815,.227663,.308264,.412660,0.644191,0.890496,1.00704,
     +     1.14879,1.33947,
     +     1.47101,1.65334,1.75269,1.96060,2.18542,2.66817,4.71889,
     + .236777,.290593,.378646,.486144,0.706665,0.923905,1.02249,
     +     1.13965,1.29340,
     +     1.39738,1.53919,1.61549,1.77330,1.94155,2.29630,3.74865,
     + .317811,.377385,.469227,.574133,0.772311,0.952720,1.03119,
     +     1.12229,1.23888,
     +     1.31613,1.41974,1.47475,1.58711,1.70507,1.94883,2.90406,
     + .437322,.498099,.585648,.678673,0.840086,0.975703,1.03221,
     +     1.09628,1.17621,
     +     1.22805,1.29637,1.33213,1.40420,1.47859,1.62886,2.18744,
     + .589580,.642613,.714273,.785551,0.900295,0.990115,1.02614,
     +     1.06613,
     +     1.11488,1.14589,1.18609,1.20686,1.24817,1.29012,1.37296,
     +     1.66418,
     + .687829,.731736,.789176,.844460,0.930222,0.995029,1.02053,
     +     1.04853,1.08226,
     +     1.10351,1.13081,1.14482,1.17250,1.20035,1.25469,1.43975,
     + .846937,.871021,.901234,.929096,0.970287,1.000000,1.01139,
     +     1.02373,1.03835,
     +     1.04744,1.05898,1.06484,1.07631,1.08772,1.10959,1.18072 /
      data slope / 12.7543, 2.66878, 1.01977,   0.716040,    1.05447,
     +    1.75447,    2.63160,    4.44953,    7.37140,    11.8380,
     +    18.0175,    27.7997,    50.5884,    124.423,    297.695,
     +    17.9731,    3.67069,    1.35007,   0.875295,    1.15122,
     +    1.76956,    2.51585,    4.00340,    6.31360,    9.73901,
     +    14.3845,    21.5974,    38.1259,    90.5786,    429.024,
     +    22.5826,    4.51361,    1.60680,   0.978050,    1.18447,
     +    1.72445,    2.36834,    3.62770,    5.54940,    8.35341,
     +    12.1145,    17.8920,    31.0039,    72.0966,    506.659,
     +    30.3233,    5.84200,    1.97207,    1.09231,    1.17992,
     +    1.59997,    2.10438,    3.07650,    4.53520,    6.62801,
     +    9.40147,    13.6100,    23.0525,    52.1915,    493.244,
     +    36.5289,    6.82711,    2.21072,    1.14405,    1.14440,
     +    1.48282,    1.89899,    2.69850,    3.88940,    5.58301,
     +    7.81298,    11.1713,    18.6555,    41.5215,    381.028,
     +    45.7222,    8.15056,    2.48170,    1.17050,    1.06047,
     +    1.29868,    1.61051,    2.21150,    3.10220,    4.35720,
     +    5.99698,    8.44568,    13.8545,    30.1715,    266.076,
     +    52.0533,    8.95567,    2.60990,    1.15766,   0.985220,
     +    1.16544,    1.41750,    1.90680,    2.63080,    3.64660,
     +    4.96749,    6.93034,    11.2410,    24.1375,    207.144,
     +    59.7956,    9.78367,    2.68745,    1.10260,   0.868960,
     +   0.985850,    1.17160,    1.53750,    2.07960,    2.83620,
     +    3.81499,    5.26034,    8.41248,    17.7375,    146.702,
     +    66.1933,   10.20467,    2.62265,   0.990890,   0.721636,
     +   0.784700,   0.911000,    1.16590,    1.54500,    2.07220,
     +    2.75050,    3.74534,    5.89799,    12.1880,    96.4881,
     +    67.5300,    9.72767,    2.32563,   0.807065,   0.542468,
     +   0.565070,   0.640700,   0.799300,    1.03680,    1.36640,
     +    1.78799,    2.40234,    3.71950,    7.51351,    56.4224,
     +    58.9255,    7.96222,    1.78195,   0.573720,   0.359280,
     +   0.360250,   0.399901,   0.487499,   0.620201,   0.804001,
     +    1.03850,    1.37700,    2.09750,    4.14200,    29.4162,
     +    48.7855,    6.38222,    1.38210,   0.428810,   0.259228,
     +   0.255010,   0.280000,   0.337300,   0.425000,   0.546001,
     +   0.700496,   0.922669,    1.39250,    2.71700,    18.6930,
     +    26.7600,    3.35700,   0.696550,   0.205955,   0.118852,
     +   0.113900,   0.123401,   0.146199,   0.181801,   0.230799,
     +   0.292998,   0.382336,   0.570499,    1.09350,    7.18486 /

      if (pe.lt.1.) pe=1.
      if (pe.gt.1e3) pe=1e3
      do i=2,13
         if (pe.le.pevals(i)) goto 1
      enddo
c want xvals(?,i-1), xvals(?,i)
      
      i=13
 1    if (y.lt.1e-4) then
         lftfrac=(pe-pevals(i-1))/(pevals(i)-pevals(i-1))
         x=xvals(1,i-1)*(1-lftfrac)+xvals(1,i)*lftfrac
         return
      endif

      do i2=2,16
         if (y.le.yvals(i2)) goto 2
      enddo
c btwn yvals(i2) and yvals(i2-1)

      i2=16
c find point on first curve
 2    leftvalue=xvals(i2-1,i-1)+slope(i2-1,i-1)*(y-yvals(i2-1))

c find point on second curve
      rightvalue=xvals(i2-1,i)+slope(i2-1,i)*(y-yvals(i2-1))

c find average weight of two
      lftfrac=(pe-pevals(i-1))/(pevals(i)-pevals(i-1))

      x=leftvalue*(1-lftfrac)+rightvalue*lftfrac

      return
      end

