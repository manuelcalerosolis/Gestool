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

   DATA oDialog

   METHOD New()

   METHOD getParentControler()                     INLINE ( ::oController:oSenderController )
   METHOD getParentDialogView()                    INLINE ( ::getParentControler():oDialogView )
   METHOD getaBuffer()                             INLINE ( ::oController:getaBuffer() )

   METHOD getValueBuffer( nArrayAt, key )          INLINE ( ::oController:getValueBuffer( nArrayAt, key ) )
   METHOD setValueBuffer( nArrayAt, key, value )   INLINE ( ::oController:setValueBuffer( nArrayAt, key, value ) )

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

   local oBtn
   local oBmpGeneral

   ::nSerIni                  := 0
   ::nSerFin                  := 0
   ::nNumGen                  := 0
   ::cPreFix                  := Space( 150 )

   DEFINE DIALOG ::oDialog RESOURCE "VtaNumSer" TITLE ::lblTitle() + "series de movimientos de almacén"

      REDEFINE BITMAP oBmpGeneral ;
         ID       800 ;
         RESOURCE "gc_odometer_48" ;
         TRANSPARENT ;
         OF       ::oDialog

      REDEFINE GET ::oTotalUnidades VAR ::nTotalUnidades ;
         ID       100 ;
         PICTURE  MasUnd() ;
         WHEN     .f. ;
         OF       ::oDialog

      REDEFINE GET ::cPreFix ;
         ID       110 ;
         OF       ::oDialog

      REDEFINE GET ::oSerIni VAR ::nSerIni ;
         ID       120 ;
         PICTURE  "99999999999999999999" ;
         SPINNER ;
         VALID    ( ::oSerFin:cText( ::nSerIni + ::nTotalUnidades ), .t. ) ;
         OF       ::oDialog

      REDEFINE GET ::oSerFin VAR ::nSerFin ;
         ID       130 ;
         PICTURE  "99999999999999999999" ;
         WHEN     .f. ;
         OF       ::oDialog

      REDEFINE GET ::oNumGen VAR ::nNumGen ;
         ID       140 ;
         SPINNER ;
         PICTURE  "99999999999999999999" ;
         OF       ::oDialog

      REDEFINE BUTTON ;
         ID       500 ;
         OF       ::oDialog ;
         ACTION   ( ::oController:GenerarSeries() )

      ::oBrwSer                  := IXBrowse():New( ::oDialog )

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
         :bEditValue             := {|| Padr( ::getValueBuffer( ::oBrwSer:nArrayAt, "numero_serie" ), 30 ) }
         :nWidth                 :=  240
         :bOnPostEdit            := {|o,x| ::setValueBuffer( ::oBrwSer:nArrayAt, "numero_serie", x ) }
         :nEditType              := 1
      end whit

      ::oBrwSer:CreateFromResource( 150 )

      REDEFINE BUTTON ;
         ID       510 ;
         OF       ::oDialog ;
         ACTION   ( ::oController:EndResource( ::oDialog ) )

      REDEFINE BUTTON ;
         ID       520 ;
         OF       ::oDialog ;
         ACTION   ( ::oDialog:End() )

   ACTIVATE DIALOG ::oDialog CENTER

   if !Empty( oBmpGeneral )
      oBmpGeneral:End()
   end if

RETURN ( ::oDialog:nResult == IDOK )

//---------------------------------------------------------------------------//