      subroutine read_avs_io(lu)
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
CD1 Read input file and set io flags.
CD1
C***********************************************************************
CD2
CD2 REVISION HISTORY 
CD2
CD2 Revision                    ECD
CD2 Date         Programmer     Number  Comments
CD2
CD2 10-SEP-93    Carl Gable     22      Initial implementation.
CD2
CD2 $Log:   /pvcs.config/fehm90/src/read_avs_io.f_a  $
!D2 
!D2    Rev 2.5   06 Jan 2004 10:43:46   pvcs
!D2 FEHM Version 2.21, STN 10086-2.21-00, Qualified October 2003
!D2 
!D2    Rev 2.4   29 Jan 2003 09:13:14   pvcs
!D2 FEHM Version 2.20, STN 10086-2.20-00
!D2 
!D2    Rev 2.3   14 Nov 2001 13:12:04   pvcs
!D2 FEHM Version 2.12, STN 10086-2.12-00
!D2 
!D2    Rev 2.2   06 Jun 2001 13:26:12   pvcs
!D2 FEHM Version 2.11, STN 10086-2.11-00
!D2 
!D2    Rev 2.1   30 Nov 2000 12:06:40   pvcs
!D2 FEHM Version 2.10, STN 10086-2.10-00
!D2 
!D2    Rev 2.0   Fri May 07 14:44:50 1999   pvcs
!D2 FEHM Version 2.0, SC-194 (Fortran 90)
CD2 
CD2    Rev 1.5   Thu Feb 01 15:43:32 1996   hend
CD2 Updated Requirements Traceability
CD2 
CD2    Rev 1.4   04/12/95 09:11:22   robinson
CD2 Changed keyword dual to dp to eliminate conflict with dual macro
CD2 
CD2    Rev 1.3   04/10/95 14:42:54   robinson
CD2 Changed warning message related to solute output
CD2 
CD2    Rev 1.2   01/28/95 14:20:42   llt
CD2 modified for the revised reactive transport module
CD2 
CD2    Rev 1.1   12/12/94 16:25:56   tam
CD2 list directed read* caused problems on ibm,
CD2 changed to a80 to fix, also changed include statement
CD2 to use " ", for current or defined directory
CD2 
CD2    Rev 1.0   08/23/94 15:37:28   llt
CD2 Original version
CD2
C***********************************************************************
CD3
CD3 INTERFACES
CD3
CD3 Formal Calling Parameters
CD3
CD3   Identifier      Type     Use  Description
CD3
CD3 Interface Tables
CD3
CD3   None
CD3
CD3 Files
CD3
CD3   None
CD3
C***********************************************************************
CD4
CD4 GLOBAL OBJECTS
CD4
CD4 None
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
CD5 Local Subprograms
CD5
CD5   None
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
CPS BEGIN 
CPS   
CPS END 
CPS 
C***********************************************************************

      use avsio
      use comai, only : altc, ihead, ierr, iptty, icnl, istrs
      use combi, only : izonef
      use comco2, only : icarb
      use comdi, only : nsurf, izone_surf, izone_surf_nodes, ifree
      use comdti, only : n0
      use davidi, only : irdof
      implicit none

      character*80 chdum
      character*32 cmsg(4)
      integer lu, nparam 
      integer msg(4),nwds,imsg(4)
      integer i, izone, inode
      real*8 xmsg(4)

c     default format is 2 => formatted;   1 => unformatted
c     begin execution
c     assign defaults
      iomaterial = 0
      ioliquid = 0
      iovapor = 0
      iodual = 0
      iovelocity = 0
      iopressure = 0
      iocapillary = 0
      iotemperature = 0
      iosaturation = 0
      iohead = 0
      ioconcentration = 0
      iodisplacement = 0
      ioformat = 2
      iohyd = 0
      iofw = 0
      iofh = 0
      ioporosity = 0
      iosource = 0
      iodensity = 0
      iogeo = 0
      iocord = 0
      iopermeability = 0
      iozone = 0
      iowt = 0
      ioco2 = 0
      iokd = 0
      ioflx = 0
      iozid = 0
      iodisp = 0
      iostrain = 0
      iostress = 0
c     default output, time in days (for tecplot)
      timec_flag = 2
      net_flux = .false.
      vol_flux = .false.
      dit_flag = .false.
      
      if (iptty .ne. 0) then
         write(iptty, 100)
         write(iptty, *) 'You have chosen ', altc, ' output format'
         write(iptty, *) 'The following io parameters have been set '
      end if

      do
         
         read(lu,'(a80)', err=99, end=9999) chdum
         
         if((chdum(1:1) .eq. 'u').or.(chdum(1:1) .eq. 'U'))then
c     unformatted output, keyword: unformatted
            ioformat = 1

         elseif((chdum(1:2) .eq. 'fo').or.(chdum(1:2) .eq. 'FO'))then
c     formatted output, keyword: formatted
            ioformat = 2

         elseif((chdum(1:2) .eq. 'no').or.(chdum(1:2) .eq. 'NO'))then
c     no output at dits, keyword: nodit
            dit_flag = .TRUE.

c Add time unit option for tecplot output
         elseif((chdum(1:3) .eq. 'yea').or.(chdum(1:3) .eq. 'YEA').or.
     &           (chdum(1:3) .eq. 'yrs').or.(chdum(1:3) .eq. 'YRS'))
     &           then
            timec_flag = 1
         elseif((chdum(1:3) .eq. 'day').or.(chdum(1:3) .eq. 'DAY'))then
            timec_flag = 2
         elseif((chdum(1:3) .eq. 'sec').or.(chdum(1:3) .eq. 'SEC'))then
            timec_flag = 3
         elseif((chdum(1:3) .eq. 'hou').or.(chdum(1:3) .eq. 'HOU').or.
     &           (chdum(1:3) .eq. 'hrs').or.(chdum(1:3) .eq. 'HRS'))
     &           then
            timec_flag = 4
c End of time unit options

         elseif((chdum(1:1) .eq. 'm').or.(chdum(1:1) .eq. 'M'))then
c     output grid material properties, keyword: material
            iomaterial = 1
            if (iptty .ne. 0) 
     &           write(iptty, *) ' iomaterial      ', iomaterial

         elseif((chdum(1:1) .eq. 'l').or.(chdum(1:1) .eq. 'L'))then
c     output liquid quantities, keyword: liquid
            ioliquid = 1
            if (iptty .ne. 0) 
     &           write(iptty, *) ' ioliquid        ', ioliquid

         elseif((chdum(1:2) .eq. 'va').or.(chdum(1:2) .eq. 'VA'))then
c     output vapor quantities, keyword: vapor
            iovapor = 1
            if (iptty .ne. 0) 
     &           write(iptty, *) ' iovapor         ', iovapor
  
         elseif((chdum(1:1) .eq. 'd').or.(chdum(1:1) .eq. 'D'))then
            if((chdum(2:2) .eq. 'p').or.
     1           (chdum(2:2) .eq. 'P'))then
c     output dual perm. quantities, keyword: dpdp
               iodual = 1
               if (iptty .ne. 0) 
     &              write(iptty, *) ' iodual          ', iodual

            else if ((chdum(2:2) .eq. 'e').or.
     1           (chdum(2:2) .eq. 'E'))then
c     output densities, keyword: density
               iodensity = 1
               if (iptty .ne. 0) 
     &              write(iptty, *) ' iodensity       ', iodensity
               
            else if ((chdum(2:2) .eq. 'i').or.
     1           (chdum(2:2) .eq. 'I'))then
c     output displacements, keyword: displacement
               iodisp = 1
               if (iptty .ne. 0) 
     &              write(iptty, *) ' iodisp          ', iodisp   
            else
               goto 99
            end if
            
         elseif((chdum(1:1) .eq. 'p').or.(chdum(1:1) .eq. 'P'))then
            if ((chdum(2:2) .eq. 'o').or.(chdum(2:2) .eq. 'O'))then
c     output porosities, keyword: porosity
               ioporosity = 1
               if (iptty .ne. 0) 
     &              write(iptty, *) ' ioporosity      ', ioporosity

            else if ((chdum(2:2) .eq. 'e').or.(chdum(2:2) .eq. 'E'))then
c     output permeabilities, keyword: permeability
               iopermeability = 1
               if (iptty .ne. 0) 
     &              write(iptty, *) ' iopermeability  ', iopermeability
    
            else
c     output pressures, keyword: pressure 
               iopressure = 1
               if (iptty .ne. 0) 
     &              write(iptty, *) ' iopressure      ', iopressure

            end if

         elseif((chdum(1:2) .eq. 'he').or.(chdum(1:2) .eq. 'HE'))then
c     output hydraulic head, keyword: head
            iohead = 1
            if (iptty .ne. 0) 
     &           write(iptty, *) ' iohead          ', iohead

         elseif((chdum(1:2) .eq. 'wt').or.(chdum(1:2) .eq. 'WT'))then
c     output water table elevation, keyword: wt
            iowt = 1
            if (iptty .ne. 0) 
     &           write(iptty, *) ' iowt            ', iowt

         elseif((chdum(1:1) .eq. 't').or.(chdum(1:1) .eq. 'T'))then
c     output temperature, keyword: temperature 
            iotemperature = 1
            if (iptty .ne. 0) 
     &           write(iptty, *) ' iotemperature   ', iotemperature

         elseif((chdum(1:1) .eq. 's').or.(chdum(1:1) .eq. 'S'))then
            if ((chdum(2:2) .eq. 'o').or.(chdum(2:2) .eq. 'O'))then
c     output source, keyword: source
               iosource = 1
               if (iptty .ne. 0) 
     &              write(iptty, *) ' iosource        ', iosource
            else if ((chdum(2:4).eq.'tra').or.(chdum(2:4).eq.'TRA'))then
c     output source, keyword: strain
               iostrain = 1
               if (iptty .ne. 0) 
     &              write(iptty, *) ' iostrain        ', iostrain
            else if ((chdum(2:4).eq.'tre').or.(chdum(2:4).eq.'TRE'))then
c     output source, keyword: stress
               iostress = 1
               if (iptty .ne. 0) 
     &              write(iptty, *) ' iostress        ', iostress
            else
c     output saturation, keyword: saturation 
               iosaturation = 1
               if (iptty .ne. 0) 
     &              write(iptty, *) ' iosaturation    ', iosaturation
  
            end if

         elseif((chdum(1:1) .eq. 'z').or.(chdum(1:1) .eq. 'Z'))then
            if ((chdum(2:2) .eq. 'o').or.(chdum(2:2) .eq. 'O'))then
c     output by zones, keyword: zone
               iozone = 1
               read(lu, *) nsurf
               if(.not.allocated(izone_surf)) then
                  allocate(izone_surf(max(1,nsurf)))
                  allocate(izone_surf_nodes(n0))   
               end if
               read(lu,*) (izone_surf(i),i=1,nsurf)
c     Loop over each zone for determining izone_surf array
               izone_surf_nodes = 0
               do izone = 1, nsurf
                  do inode = 1, n0
                     if(izonef(inode).eq.izone_surf(izone)) then
                        izone_surf_nodes(inode) = izone_surf(izone)
                     end if
                  end do
               end do
               iozone = nsurf
               if (iptty .ne. 0) 
     &              write(iptty, *) ' iozone          ', iozone
            else if((chdum(2:2) .eq. 'i').or.(chdum(2:2) .eq. 'i'))then
               iozid = 1
               if (iptty .ne. 0) 
     &              write(iptty, *) ' iozid           ', iozid         
            end if
         elseif((chdum(1:1) .eq. 'c').or.(chdum(1:1) .eq. 'C'))then
            if ((chdum(2:2) .eq. 'a').or.(chdum(2:2) .eq. 'A'))then
c     output capillary pressusre
               iocapillary = 1
               if (iptty .ne. 0) 
     &              write(iptty, *) ' iocapillary     ', iocapillary
            else if((chdum(1:3) .eq. 'co2').or.(chdum(1:3) .eq. 'CO2'))
     &              then
c     output co2 related saturations
               ioco2 = 1
               if (iptty .ne. 0) 
     &              write(iptty, *) ' ioco2           ', ioco2
            else
c     output concentration, keyword: concentration 
               ioconcentration = 1
               if (iptty .ne. 0) 
     &              write(iptty, *) ' ioconcentration ', ioconcentration
            endif

         elseif((chdum(1:2) .eq. 'kd').or.(chdum(1:1) .eq. 'KD'))then
c     output concentration, keyword: concentration 
            iokd = 1
            if (iptty .ne. 0) 
     &           write(iptty, *) ' iokd            ', iokd

         elseif((chdum(1:1) .eq. 'g').or.(chdum(1:1) .eq. 'G'))then
c     output avs geometry file, keyword: geo
            iogeo = 1
            if (iptty .ne. 0) 
     &           write(iptty, *) ' iogeo           ', iogeo

         elseif((chdum(1:1) .eq. 'x').or.(chdum(1:1) .eq. 'X'))then
c     output coordinates, keyword: xyz
            if (icnl .eq. 0) then
               iocord = 3
            else
               iocord = 2
            end if
            if (iptty .ne. 0) 
     &           write(iptty, *) ' iocord          ', iocord

         elseif((chdum(1:2) .eq. 've').or.(chdum(1:2) .eq. 'VE'))then
c     output velocities , keyword: velocity 
            iovelocity = 1
            if (iptty .ne. 0) 
     &           write(iptty, *) ' iovelocity      ', iovelocity
  
         elseif((chdum(1:2) .eq. 'fl').or.(chdum(1:2) .eq. 'FL'))then
c     output node flux, keyword: flux
            ioflx = 1
            if (iptty .ne. 0) 
     &           write(iptty, *) ' ioflx           ', ioflx
            call parse_string(chdum,imsg,msg,xmsg,cmsg,nwds)
            if (nwds .gt. 1) then
               if (cmsg(2) .eq. 'net' .or. cmsg(2) .eq. 'NET') then
                  net_flux = .true.
c     volume weighted net flux
               else if (cmsg(2) .eq. 'vol' .or. cmsg(2) .eq. 'VOL') then
                  net_flux = .true.
                  vol_flux = .true.
c     volume weighted boundary flux
               else if (cmsg(2) .eq. 'vwg' .or. cmsg(2) .eq. 'VWG') then
                  vol_flux = .true.
               end if
            end if
         elseif((chdum(1:2) .eq. 'hy').or.(chdum(1:2) .eq. 'HY'))then
c     output hydrate quantities, keyword: hydrate
            iohyd = 1
            if (iptty .ne. 0) 
     &           write(iptty, *) ' iohyd           ', iohyd
  
         elseif((chdum(1:2) .eq. 'fw').or.(chdum(1:2) .eq. 'FW'))then
c     output water fraction, keyword: fwater
            iofw = 1
            if (iptty .ne. 0) 
     &           write(iptty, *) ' iofw            ', iofw

         elseif((chdum(1:2) .eq. 'fh').or.(chdum(1:2) .eq. 'FH'))then
c     output hydrate fraction, keyword: fhydrate
            iofh = 1
            if (iptty .ne. 0) 
     &           write(iptty, *) ' iofh            ', iofh
        
         elseif((chdum(1:1) .eq. 'e').or.(chdum(1:1) .eq. 'E'))then
c     end of avs input, keyword: endavs
c     looking for end END endavs ENDAVS
            exit

         else
c     illegal character found
            goto 99
         endif
      enddo

 100  format (1x,'-----------------------------------------------')
 110  format (1x,'WARNING: ', a)
 120  format (1x,'There will be no AVS output for ', a)
      

 9999 if (ioformat .eq. 1) then
         ioformat = 2
         write(ierr, 100)
         write(ierr, 110) 'UNformatted output no longer supported'
         write(ierr, 110) 'Output will be formatted'
         write(ierr, 100)
         if (iptty .ne. 0) then
            write(iptty, 100)
            write(iptty, 110) 'UNformatted output no longer supported'
            write(iptty, 110) 'Output will be formatted'
            write(iptty, 100)
         end if           
      end if

      if (iogeo .eq. 1 .and. iozone .ne. 0 ) then
         write(ierr, 100)
         write(ierr, 110) 'Geometry option cannot be used with zones'
         write(ierr, 110) 'Geometry output will not be written'
         write(ierr, 100) 
         iogeo = 0
         if (iptty .ne. 0) then
            write(iptty, 100)
            write(iptty, 110)'Geometry option cannot be used with zones'
            write(iptty, 110) 'Geometry output will not be written'
            write(iptty, 100)
         end if                    
      end if 
          
      if (altc(1:3) .eq. 'tec' .and. iogeo .eq. 1) then
         if (iocord .eq. 0) then
            write(ierr, 100)
            write(ierr, 110) 'Geometry output specified'
            write(ierr, 110) 'coordinates will be written'
            write(ierr, 100)
            if (icnl .eq. 0) then
               iocord = 3
            else
               iocord = 2
            end if
            if (iptty .ne. 0) then
               write(iptty, 100)
               write(iptty, 110) 'Geometry output specified'
               write(iptty, 110) 'coordinates will be written'
               write(iptty, *) ' iocord          ', iocord
               write(iptty, 100)
         end if                    
         end if
      end if 
          
      if (iptty .ne. 0) then
         write(iptty, *) ' format        ', 'formatted'
         write(iptty, *) ' header        ', altc
         write(iptty, 100) 
      end if
        
      if(iopressure .ne. 0 .or. iovelocity .ne. 0 .or. ioflx .ne. 0) 
     &     then
         if((ioliquid .eq. 0) .and. (iovapor .eq. 0)) then
            write(ierr, 100)
            if (iptty .ne. 0) write(iptty, 100)
            if (iopressure .ne. 0) then
               write(ierr, 110) 
     &           'Pressure defined, but not Vapor or Liquid'
               write(ierr, 120) 'scalar pressure'
               if (iptty .ne. 0) then
                  write(iptty, 110) 
     &                 'Pressure defined, but not Vapor or Liquid'
                  write(iptty, 120) 'scalar pressure'
               end if
               iopressure = 0
            end if
            if (iovelocity .ne. 0) then
               write(ierr, 110)
     &              'Velocity defined, but not Vapor or Liquid'
               write(ierr, 120) 'velocity' 
               if (iptty .ne. 0) then
                  write(iptty, 110)
     &                 'Velocity defined, but not Vapor or Liquid'
                  write(iptty, 120) 'velocity' 
               end if
               iovelocity = 0
            end if
            if (ioflx .ne. 0) then
               write(ierr, 110)
     &              'Flux defined, but not Vapor or Liquid'
               write(ierr, 120) 'flux' 
               if (iptty .ne. 0) then
                  write(iptty, 110)
     &                 'Flux defined, but not Vapor or Liquid'
                  write(iptty, 120) 'flux' 
               end if
               ioflx = 0
            end if
            write(ierr, 100)
            if (iptty .ne. 0) write(iptty, 100)
         end if
      else
         if((ioliquid .ne. 0) .or. (iovapor .ne. 0)) then
            write(ierr, 100)
            if (iptty .ne. 0) write(iptty, 100)
            if(iovapor .ne. 0) then
               write(ierr, 110)
     &              'Vapor defined, but not pressure, velocity or flux'
               if (iptty .ne. 0) write(iptty, 110)
     &              'Vapor defined, but not pressure, velocity or flux'
               iovapor = 0
            endif
            if(ioliquid .ne. 0) then
               write(ierr, 110)
     &              'Liquid defined, but not pressure, velocity or flux'
               if (iptty .ne. 0) write(iptty, 110)
     &              'Liquid defined, but not pressure, velocity or flux'
               ioliquid = 0
            endif
            write(ierr, 120) 'scalar pressure or velocity or flux'
            write(ierr, 100)
            if (iptty .ne. 0) then
               write(iptty, 120) 'scalar pressure or velocity or flux'
               write(iptty, 100)
            end if
         end if
      end if
      
      if (iocapillary .ne. 0) then
! water only and not wtsi problem
         if (irdof .eq. 13 .and. ifree .eq. 0) then
            write(ierr, 110) 
     &           'capillary pressure defined for non-capillary problem'
            write(ierr, 120) 'capillary pressure'
            write(ierr, 100)
            if (iptty .ne. 0) then
               write(iptty, 110) 
     &            'capillary pressure defined for non-capillary problem'
               write(iptty, 120) 'capillary pressure'
               write(iptty, 100)
               iocapillary = 0
            end if
         end if
      end if

      if (ioco2 .ne. 0 .and. icarb .eq. 0) then
         write(ierr, 100)
         write(ierr, 110) 'co2 defined for non-co2 problem'
         write(ierr, 120) 'co2'
         write(ierr, 100)
         if (iptty .ne. 0) then
            write(iptty, 100)
            write(iptty, 110) 'co2 defined for non-co2 problem'
            write(iptty, 120) 'co2'
            write(iptty, 100)
         end if
         ioco2 = 0   
      end if

      if (ihead .ne. 1 .and. iohead .eq. 1 ) then
         write(ierr, 100)
         write(ierr, 110) 'head defined for non-head problem'
         write(ierr, 120) 'head'
         write(ierr, 100)
         if (iptty .ne. 0) then
            write(iptty, 100)
            write(iptty, 110) 'head defined for non-head problem'
            write(iptty, 120) 'head'
            write(iptty, 100)
         end if
         iohead = 0
      end if

      if(irdof.eq.13 .and. iovapor .ne. 0) then
         iovapor=0
         write(ierr, 100)
         write(ierr, 110) 'Vapor defined for water only problem'
         write(ierr, 120) 'vapor phase'
         if (iptty .ne. 0) then
            write(iptty, 100)
            write(iptty, 110) 'Vapor defined for water only problem'
            write(iptty, 120) 'vapor phase'
            write(iptty, 100)
         end if
      endif

      if ((irdof .eq. 13 .and. ifree .eq. 0) .and. iowt .eq. 1) then
         iowt = 0
         write(ierr, 100)
         write(ierr, 110) 'WT defined for water only problem'
         write(ierr, 120) 'WT'
         write(ierr, 100)
         if (iptty .ne. 0) then
            write(iptty, 100)
            write(iptty, 110) 'WT defined for water only problem'
            write(iptty, 120) 'WT'
            write(iptty, 100)
         end if
      end if
      if ((istrs .eq. 0) .and. iodisp .eq. 1) then
         iodisp = 0
         write(ierr, 100)
         write(ierr, 110) 'disp requested for non stress proplem'
         write(ierr, 120) 'disp'
         write(ierr, 100)
         if (iptty .ne. 0) then
            write(iptty, 100)
            write(iptty, 110) 'disp requested for non stress problem'
            write(iptty, 120) 'disp'
            write(iptty, 100)
         end if
      endif
      if ((istrs .eq. 0) .and. iostrain .eq. 1) then
         iostrain = 0
         write(ierr, 100)
         write(ierr, 110) 'strain requested for non stress problem'
         write(ierr, 120) 'strain'
         write(ierr, 100)
         if (iptty .ne. 0) then
            write(iptty, 100)
            write(iptty, 110) 'strain requested for non stress problem'
            write(iptty, 120) 'strain'
            write(iptty, 100)
         end if
      end if
      if ((istrs .eq. 0) .and. iostress .eq. 1) then
         iostress = 0
         write(ierr, 100)
         write(ierr, 110) 'stress requested for non stress problem'
         write(ierr, 120) 'stress'
         write(ierr, 100)
         if (iptty .ne. 0) then
            write(iptty, 100)
            write(iptty, 110) 'stress requested for non stress problem'
            write(iptty, 120) 'stress'
            write(iptty, 100)
         end if
      end if      
      if(iovapor.eq.1.and.ioliquid.eq.1.and.ioconcentration.eq.1) then
         chdum = 'Cannot output both liquid and vapor concentrations'
     &        // 'of the same solute.'
         write(ierr, 100)
         write(ierr, 110) chdum
         write(ierr, 130) 'Liquid', 'liquid'
         write(ierr, 130) 'Vapor', 'vapor'
         write(ierr, 130) 'Henry', 'liquid'
         write(ierr, 100)
         if( iptty .ne. 0 ) then
            write(iptty, 100)
            write(iptty, 110) chdum
            write(iptty, 130) 'Liquid', 'liquid'
            write(iptty, 130) 'Vapor', 'vapor'
            write(iptty, 130) 'Henry', 'liquid'
            write(iptty, 100)
         end if
      endif
 130  format (1x, a, ' solute: ', a, 'concentrations will be written')
      return

 99   write (ierr, 999) chdum
      if (iptty .ne. 0) write (iptty, 999) chdum
      stop
      
 999  format (/, 'ERROR:READ_AVS_IO'
     .  , /, 'unexpected character string (terminate program execution)'
     .     , /, 'Valid options are shown:'
     .     , /, ' String in ( ) is required; the rest is optional'
     .     , /, ' (m)aterial      or (M)ATERIAL  '
     .     , /, ' (l)iquid        or (L)IQUID '
     .     , /, ' (va)por         or (VA)POR  '
     .     , /, ' (ve)locity      or (VE)LOCITY  '
     .     , /, ' (dp)            or (DP) - note: do not use dual!'
     .     , /, ' (di)splacement  or (DI)SPLACEMENT'
     .     , /, ' (stre)ss        or (STRE)SS'     
     .     , /, ' (stra)in        or (STRA)IN'
     .     , /, ' (ca)pillary     or (CA)PILLARY '
     .     , /, ' (he)ad          or (HE)AD  '
     .     , /, ' (t)emperature   or (T)EMPERATURE   '
     .     , /, ' (s)aturation    or (S)ATURATION  '
     .     , /, ' (po)rosity      or (PO)ROSITY  '
     .     , /, ' (so)urce        or (SO)URCE  '
     .     , /, ' (de)nsity       or (DE)NSITY  '
     .     , /, ' (pe)rmeability  or (PE)RMEABILITY '
     .     , /, ' (x)yz           or (X)YZ  '
     .     , /, ' (c)oncentration or (C)ONCENTRATION  '
     .     , /, ' (co2)           or (CO2) '
     .     , /, ' (hy)drate       or (HY)DRATE  '
     .     , /, ' (fw)ater        or (FW)ATER  '
     .     , /, ' (fh)ydrate      or (FH)YDRATE  '
     .     , /, ' (zi)d           or (ZI)D  '
     .     , /, ' (zo)ne          or (ZO)NE  '
     .     , /, ' (fo)rmatted     or (FO)RMATTED  '
     .     , /, ' (u)nformatted   or (U)NFORMATTED  '
     .     , /, ' (e)ndavs        or (E)NDAVS  '
     .  , /, 'Input file should look something like this:', /, '      ',
     .     /, 'cont', /, 'material', /, 'liquid', /, 'pressure', 
     .     /, 'temperature', /, 'formatted', /, 'endavs', /, '      '
     .     , /, 'The invalid string was:',/,a72)
      
      end
