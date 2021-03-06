      subroutine inmentat
!***********************************************************************
!  Copyright, 1993, 2004,  The  Regents of the University of California.
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
CD1 PURPOSE
CD1
CD1 Read in geometric data generated by mentat mesh generator.
CD1 
C***********************************************************************
CD2
CD2 REVISION HISTORY 
CD2
CD2 Revision                    ECD
CD2 Date         Programmer     Number  Comments
CD2
CD2 21-DEC-93    Z. Dash        22      Initial implementation.
CD2
CD2 $Log:   /pvcs.config/fehm90/src/inmentat.f_a  $
!D2 
!D2    Rev 2.5   06 Jan 2004 10:43:20   pvcs
!D2 FEHM Version 2.21, STN 10086-2.21-00, Qualified October 2003
!D2 
!D2    Rev 2.4   29 Jan 2003 09:09:00   pvcs
!D2 FEHM Version 2.20, STN 10086-2.20-00
!D2 
!D2    Rev 2.3   14 Nov 2001 13:10:16   pvcs
!D2 FEHM Version 2.12, STN 10086-2.12-00
!D2 
!D2    Rev 2.2   06 Jun 2001 13:24:48   pvcs
!D2 FEHM Version 2.11, STN 10086-2.11-00
!D2 
!D2    Rev 2.1   30 Nov 2000 12:03:52   pvcs
!D2 FEHM Version 2.10, STN 10086-2.10-00
!D2 
!D2    Rev 2.0   Fri May 07 14:42:40 1999   pvcs
!D2 FEHM Version 2.0, SC-194 (Fortran 90)
CD2 
CD2    Rev 1.2   Tue Jan 30 12:54:02 1996   hend
CD2 Updated Requirements Traceability
CD2 
CD2    Rev 1.1   03/18/94 16:03:34   gaz
CD2 Added solve_new and cleaned up memory management.
CD2 
CD2    Rev 1.0   01/20/94 10:25:06   pvcs
CD2 original version in process of being certified
CD2 
C***********************************************************************
CD3
CD3 INTERFACES
CD3
CD3 Formal Calling Parameters
CD3
CD3   None
CD3
CD3 Interface Tables
CD3
CD3   None
CD3
CD3 Files
CD3
CD3   Name                     Use  Description
CD3
CD3   iout                     O    File used for general code output
CD3   unit 42                  I    File that contains mentat or patran mesh
CD3                                   generator geometric data
CD3
C***********************************************************************
CD4
CD4 GLOBAL OBJECTS
CD4
CD4 Global Constants
CD4
CD4   None
CD4
CD4 Global Types
CD4
CD4   None
CD4
CD4 Global Variables
CD4
CD4                            COMMON
CD4   Identifier      Type     Block  Description
CD4
CD4   cord            REAL*8   fbs    Contains the coordinates of each node
CD4   iout            INT      faai   Unit number for output file
CD4   nei             INT      faai   Total number of elements in the problem
CD4   nelm            INT      fbb    ?Nodal connectivity information
CD4   neq             INT      faai   Number of nodes
CD4   ns              INT      faai   Number of nodes per element
CD4
CD4
CD4 Global Subprograms
CD4
CD4   Identifier      Type     Description
CD4
CD4
C***********************************************************************
CD5
CD5 LOCAL IDENTIFIERS
CD5
CD5 Local Constants
CD5
CD5   None
CD5
CD5 Local Types
CD5
CD5   None
CD5
CD5 Local variables
CD5
CD5   Identifier      Type     Description
CD5
CD5   cc1             CHAR     Data content flag
CD5   i               INT      Loop index
CD5   itype           INT      ?
CD5   j               INT      ?
CD5   len             INT      ?
CD5   lenm1           INT      ?
CD5   nel             INT      ?
CD5   neref           INT      ?
CD5   node1           INT      ?
CD5   node2           INT      ?
CD5   node3           INT      ?
CD5   node4           INT      ?
CD5
CD5 Local Subprograms
CD5
CD5   Identifier      Type     Description
CD5
CD5
C***********************************************************************
CD6
CD6 FUNCTIONAL DESCRIPTION
CD6
C***********************************************************************
CD7
CD7 ASSUMPTIONS AND LIMITATIONS
CD7
CD7 None
CD7
C***********************************************************************
CD8
CD8 SPECIAL COMMENTS
CD8
CD8  Requirements from SDN: 10086-RD-2.20-00
CD8    SOFTWARE REQUIREMENTS DOCUMENT (RD) for the
CD8    FEHM Application Version 2.20
CD8
C***********************************************************************
CD9
CD9 REQUIREMENTS TRACEABILITY
CD9
CD9 2.6 Provide Input/Output Data Files
CD9 3.0 INPUT AND OUTPUT REQUIREMENTS
CD9
C***********************************************************************
CDA
CDA REFERENCES
CDA
CDA None
CDA
C***********************************************************************
CPS
CPS PSEUDOCODE
CPS
CPS BEGIN  inmentat
CPS 
CPS   
CPS   REPEAT
CPS     read data content flag
CPS   UNTIL connectivity data is found
CPS      
CPS   read element information
CPS   IF 2D elements 
CPS      set number of nodes per element to 4
CPS   ELSE if 3D elements
CPS      set number of nodes per element to 8
CPS   ENDIF
CPS      
CPS   rewind to beginning of last line read
CPS   FOR each element
CPS       read element number, type, and nodal connectivity information
CPS   ENDFOR
CPS   
CPS   IF 2D elements
CPS   
CPS      FOR each element
CPS          check for triangles
CPS          IF triangular elements
CPS             set length between common nodes to zero
CPS          ENDIF
CPS      ENDFOR
CPS         
CPS   ELSE if 3D elements
CPS      
CPS      FOR each element
CPS          reorder nodal connections
CPS          check for prisms
CPS          IF prism elements
CPS             set length between common nodes to zero
CPS          ENDIF
CPS      ENDFOR
CPS      
CPS   ENDIF
CPS      
CPS   REPEAT
CPS     read data content flag
CPS   UNTIL coordinate data is found
CPS      
CPS   set node count to zero
CPS   read data content flag
CPS   
CPS   LOOP
CPS     read data content flag
CPS   EXITIF end of coordinate data  
CPS     rewind to beginning of last line read
CPS     increment node count
CPS     read node number and coordinate (x, y, z) values 
CPS   END LOOP 
CPS   
CPS END  inmentat
CPS
C***********************************************************************

      use combi
      use comdti
      use comai
      implicit none

      integer i, itype, j, len, lenm1, nel, neref
      integer node1, node2, node3, node4

      character*10  cc1

c**** input to read mesh file from mentat mesh generator ****

 10   continue
      read (42, '(a10)')  cc1
      if (cc1 .ne. 'connectivi')  go  to  10

c**** read element information ****

      read (42, *)   nei
      read (42, *)   nel, itype

      if (itype .eq. 11)  then
c**** 2-d elements ****
         ns     =  4
      else
c**** 3-d elements ****
         ns     =  8
      end if

      backspace  42

c**** read in element ****

      do   i = 1, nei
         read (42, *) nel, itype, 
     *        (nelm((nel - 1) * ns + j), j = 1, ns)
      end do

c**** check for triangles or prisms ****

      if (ns .eq. 4)  then
         do i = 1, nei
            len    =  (i - 1) * ns + ns
            lenm1  =  len - 1
            if (nelm(len) .eq. nelm(lenm1))  nelm(len) =  0
         end do
      else
         if (ns .eq. 8) then
            do i = 1, nei
               neref         =  (i - 1) * ns
               node1         =  nelm(neref + 1)
               node2         =  nelm(neref + 2)
               node3         =  nelm(neref + 3)
               node4         =  nelm(neref + 4)
               nelm(neref + 1) =  nelm(neref + 5)
               nelm(neref + 2) =  nelm(neref + 6)
               nelm(neref + 3) =  nelm(neref + 7)
               nelm(neref + 4) =  nelm(neref + 8)
               nelm(neref + 5) =  node1
               nelm(neref + 6) =  node2
               nelm(neref + 7) =  node3
               nelm(neref + 8) =  node4
               len   = (i - 1) * ns + ns
               lenm1 = (len - 1)
               if (nelm(len) .eq. nelm(lenm1)) then
                  nelm(len )  =  0
                  nelm(lenm1) =  0
               end if
            end do
         end if
      end if

c**** read in coordinates ****

 40   continue
      read (42, '(a10)')  cc1
      if (cc1 .ne. 'coordinate')  go  to  40

      neq    =  0
      read (42, '(a10)')  cc1
 
 41   continue
      read (42, '(a10)')  cc1
      if ((cc1 .eq. 'property  ') .or. (cc1 .eq. 'end option')) then
         go to 12
      end if
      backspace  42
      neq  =  neq + 1
      read (42, *)  j, cord(j, 1), cord(j, 2), cord(j, 3)
      go  to  41

 12   continue

      end
