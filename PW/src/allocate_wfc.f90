!
! Copyright (C) 2001-2008 PWSCF group
! This file is distributed under the terms of the
! GNU General Public License. See the file `License'
! in the root directory of the present distribution,
! or http://www.gnu.org/copyleft/gpl.txt .
!
!
!----------------------------------------------------------------------------
SUBROUTINE allocate_wfc()
  !----------------------------------------------------------------------------
  !! Dynamical allocation of arrays: wavefunctions.  
  !! Requires dimensions: npwx, nbnd, npol, natomwfc, nwfcU
  !
  USE io_global,           ONLY : stdout
  USE wvfct,               ONLY : npwx, nbnd
  USE basis,               ONLY : natomwfc, swfcatom
  USE fixed_occ,           ONLY : one_atom_occupations
  USE ldaU,                ONLY : wfcU, nwfcU, lda_plus_u, U_projection
  USE noncollin_module,    ONLY : npol
  USE wavefunctions,       ONLY : evc
  USE wannier_new,         ONLY : use_wannier
  !
  IMPLICIT NONE
  !
  !
  ALLOCATE( evc(npwx*npol,nbnd) )
  IF ( one_atom_occupations .OR. use_wannier ) &
     ALLOCATE( swfcatom(npwx*npol,natomwfc) )
  IF ( lda_plus_u .AND. (U_projection.NE.'pseudo') ) &
       ALLOCATE( wfcU(npwx*npol,nwfcU) )
  !
  RETURN
  !
END SUBROUTINE allocate_wfc
!
!
!----------------------------------------------------------------------------
SUBROUTINE allocate_wfc_k()
  !----------------------------------------------------------------------------
  !! Dynamical allocation of k-point-dependent arrays: wavefunctions, betas
  !! kinetic energy, k+G indices. Computes max no. of plane waves npwx and
  !! k+G indices igk_k (needs G-vectors and cutoff gcutw).  
  !! Requires dimensions nbnd, npol, natomwfc, nwfcU.  
  !! Requires that k-points are set up and distributed (if parallelized).
  !
  USE wvfct,            ONLY : npwx, g2kin
  USE uspp,             ONLY : vkb, nkb
  USE gvecw,            ONLY : gcutw
  USE gvect,            ONLY : ngm, g
  USE klist,            ONLY : xk, nks, init_igk
  !
  IMPLICIT NONE
  !
  INTEGER, EXTERNAL :: n_plane_waves
  !
  !   calculate number of PWs for all kpoints
  !
  npwx = n_plane_waves( gcutw, nks, xk, g, ngm )
  !
  !   compute indices j=igk(i) such that (k+G)_i = k+G_j, for all k
  !   compute number of plane waves ngk(ik) as well
  !
  CALL init_igk( npwx, ngm, g, gcutw )
  !
  CALL allocate_wfc()
  !
  !   beta functions
  !
  ALLOCATE( vkb(npwx,nkb) )
  !
  !   g2kin contains the kinetic energy \hbar^2(k+G)^2/2m
  !
  ALLOCATE( g2kin(npwx) )
  !
  RETURN
  !
END SUBROUTINE allocate_wfc_k
