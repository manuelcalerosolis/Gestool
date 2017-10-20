#include "FiveWin.Ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS NumerosSeriesView FROM SQLBaseView

   METHOD New()

   METHOD Dialog()

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController )

   ::oController     := oController

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

      REDEFINE GET ::oController:nTotalUnidades ;
         ID       100 ;
         PICTURE  MasUnd() ;
         WHEN     .f. ;
         OF       oDlg

      REDEFINE GET ::oController:cPreFix ;
         ID       110 ;
         OF       oDlg

      REDEFINE GET ::oController:oSerIni VAR ::oController:nSerIni ;
         ID       120 ;
         PICTURE  "99999999999999999999" ;
         SPINNER ;
         OF       oDlg

//         VALID    ( ::oSerFin:cText( ::nSerIni + ::nAbsUnidades() ), .t. ) ;

      REDEFINE GET ::oController:oSerFin VAR ::oController:nSerFin ;
         ID       130 ;
         PICTURE  "99999999999999999999" ;
         WHEN     .f. ;
         OF       oDlg

      REDEFINE GET ::oController:oNumGen VAR ::oController:nNumGen ;
         ID       140 ;
         SPINNER ;
         PICTURE  "99999999999999999999" ;
         OF       oDlg

      REDEFINE BUTTON ;
         ID       500 ;
         OF       oDlg ;
         ACTION   ( ::oController:GenerarSeries() )

      /*::oBrwSer                  := IXBrowse():New( ::oDlg )

      ::oBrwSer:bClrSel          := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      ::oBrwSer:bClrSelFocus     := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      ::oBrwSer:lHScroll         := .f.
      ::oBrwSer:lRecordSelector  := .t.
      ::oBrwSer:lFastEdit        := .t.

      ::oBrwSer:nMarqueeStyle    := MARQSTYLE_HIGHLCELL

      ::oBrwSer:SetArray( ::aNumSer, , , .f. )

      ::oBrwSer:nColSel          := 2

      with object ( ::oBrwSer:addCol() )
         :cHeader             := "N."
         :bStrData            := {|| Trans( ::oBrwSer:nArrayAt, "999999" ) }
         :nWidth              := 60
         :nDataStrAlign       := 1
         :nHeadStrAlign       := 1
      end with

      with object ( ::oBrwSer:addCol() )
         :cHeader             := "Serie"
         :bEditValue          := {|| ::aNumSer[ ::oBrwSer:nArrayAt ] }

         if ::lStockSeries()
            :nWidth           :=  220
            :bOnPostEdit      := {|o,x| ::aNumSer[ ::oBrwSer:nArrayAt ] := x, ::aValSer[ ::oBrwSer:nArrayAt ] := ::oStock:lValidNumeroSerie( ::cCodArt, ::cCodAlm, x ) }
         else
            :nWidth           :=  240
            :bOnPostEdit      := {|o,x| ::aNumSer[ ::oBrwSer:nArrayAt ] := x }
         end if

         if ::nMode != ZOOM_MODE
            :nEditType        := 1
         end if
      end whit

      if ::lStockSeries()

         with object ( ::oBrwSer:addCol() )
            :cHeader          := "Es."
            :nHeadBmpNo       := 4
            :bStrData         := {|| "" }
            :bBmpData         := {|| if( ::aValSer[ ::oBrwSer:nArrayAt ], 3, 1 ) }
            :nWidth           := 20
            :bLDClickData     := {|| ::InfoSeries( ::aNumSer[ ::oBrwSer:nArrayAt ], ::oStock ) }
            :AddResource( "gc_delete_12" )
            :AddResource( "gc_shape_square_12" )
            :AddResource( "gc_check_12" )
            :AddResource( "gc_document_information_16" )
         end with

      end if

      ::oBrwSer:CreateFromResource( 150 )   */

      REDEFINE BUTTON ;
         ID       510 ;
         OF       oDlg ;
         ACTION   ( oDlg:End() )

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