#include "FiveWin.Ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS NumerosSeriesView FROM SQLBaseView

   DATA oTotalUnidades
   DATA nTotalUnidades
   DATA cPreFix
   DATA oSerIni
   DATA nSerIni
   DATA oSerFin
   DATA nSerFin
   DATA oNumGen
   DATA nNumGen
   DATA oBrwSer

   METHOD New()

   METHOD getParentControler()                  INLINE ( ::oController:oSenderController )
   METHOD getParentDialogView()                 INLINE ( ::getParentControler():oDialogView )
   METHOD getaBuffer()                          INLINE ( ::oController:getaBuffer() )

   METHOD getValueBuffer( nArrayAt )            INLINE ( ::oController:getValueBuffer( nArrayAt ) )
   METHOD setValueBuffer( nArrayAt, value )     INLINE ( ::oController:setValueBuffer( nArrayAt, value ) )

   METHOD Dialog()

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController )

   ::nSerIni                  := 0
   ::nSerFin                  := 0
   ::nNumGen                  := 0
   ::cPreFix                  := Space( 150 )

   ::oController              := oController

Return ( Self )

//---------------------------------------------------------------------------//

METHOD Dialog()

   local oDlg
   local oBtn
   local oBmpGeneral

   DEFINE DIALOG oDlg RESOURCE "VtaNumSer" TITLE ::lblTitle() + "series de movimientos de almacén"

      REDEFINE BITMAP oBmpGeneral ;
         ID       800 ;
         RESOURCE "gc_odometer_48" ;
         TRANSPARENT ;
         OF       oDlg

      REDEFINE GET ::oTotalUnidades VAR ::nTotalUnidades ;
         ID       100 ;
         PICTURE  MasUnd() ;
         WHEN     .f. ;
         OF       oDlg

      REDEFINE GET ::cPreFix ;
         ID       110 ;
         OF       oDlg

      REDEFINE GET ::oSerIni VAR ::nSerIni ;
         ID       120 ;
         PICTURE  "99999999999999999999" ;
         SPINNER ;
         VALID    ( ::oSerFin:cText( ::nSerIni + ::nTotalUnidades ), .t. ) ;
         OF       oDlg

      REDEFINE GET ::oSerFin VAR ::nSerFin ;
         ID       130 ;
         PICTURE  "99999999999999999999" ;
         WHEN     .f. ;
         OF       oDlg

      REDEFINE GET ::oNumGen VAR ::nNumGen ;
         ID       140 ;
         SPINNER ;
         PICTURE  "99999999999999999999" ;
         OF       oDlg

      REDEFINE BUTTON ;
         ID       500 ;
         OF       oDlg ;
         ACTION   ( ::oController:GenerarSeries() )

      ::oBrwSer                  := IXBrowse():New( oDlg )

      ::oBrwSer:bClrSel          := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      ::oBrwSer:bClrSelFocus     := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      ::oBrwSer:lHScroll         := .f.
      ::oBrwSer:lRecordSelector  := .t.
      ::oBrwSer:lFastEdit        := .t.

      ::oBrwSer:nMarqueeStyle    := MARQSTYLE_HIGHLCELL

      ::oBrwSer:SetArray( ::getaBuffer(), , , .f. )

      ::oBrwSer:nColSel          := 2

      with object ( ::oBrwSer:addCol() )
         :cHeader                := "N."
         :bStrData               := {|| Trans( ::oBrwSer:nArrayAt, "999999" ) }
         :nWidth                 := 60
         :nDataStrAlign          := 1
         :nHeadStrAlign          := 1
      end with

      with object ( ::oBrwSer:addCol() )
         :cHeader                := "Serie"
         :bEditValue             := {|| ::getValueBuffer( ::oBrwSer:nArrayAt ) }
         :nWidth                 :=  240
         :bOnPostEdit            := {|o,x| ::setValueBuffer( ::oBrwSer:nArrayAt, x ) }
         :nEditType              := 1
      end whit

      ::oBrwSer:CreateFromResource( 150 )

      REDEFINE BUTTON ;
         ID       510 ;
         OF       oDlg ;
         ACTION   ( ::oController:EndResource( oDlg ) )

      REDEFINE BUTTON ;
         ID       520 ;
         OF       oDlg ;
         ACTION   ( oDlg:End() )

   ACTIVATE DIALOG oDlg CENTER

   if !Empty( oBmpGeneral )
      oBmpGeneral:End()
   end if

RETURN ( oDlg:nResult == IDOK )

//---------------------------------------------------------------------------//