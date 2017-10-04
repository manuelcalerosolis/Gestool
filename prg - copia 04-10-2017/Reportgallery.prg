#include "FiveWin.Ch"
#include "Font.ch"
#include "Report.ch"
#include "Factu.ch" 

//----------------------------------------------------------------------------//

FUNCTION ReportGallery()

   local oDlg
   local oLstTipoGaleria
   local oImgTipoGaleria
   local oImgArbolGaleria
   local oTrvArbolGaleria

   DEFINE DIALOG oDlg RESOURCE "ReportGalery" TITLE __GSTROTOR__ + Space( 1 ) + __GSTVERSION__ + " - Galeria de informes : " // + cCodEmp() + " - " + cNbrEmp()

   oImgTipoGaleria   := TImageList():New( 32, 32 )

   oImgTipoGaleria:AddIcon( "gc_money2_32" )
   oImgTipoGaleria:AddIcon( "gc_small_truck_32" )
   oImgTipoGaleria:AddIcon( "gc_package_32" )
   oImgTipoGaleria:AddIcon( "gc_worker2_32" )

   oLstTipoGaleria   := TListView():Redefine( 100, oDlg, {|| msginfo() } ) // {| nOption | SelectReportGalery( nOption, oTrvArbolGaleria ) }

   oImgArbolGaleria  := TImageList():New()

   oTrvArbolGaleria              := TTreeView():Redefine( 110, oDlg  )
   oTrvArbolGaleria:bLDblClick   := {|| ExecuteReportGalery( oTrvArbolGaleria ) }

   REDEFINE BUTTON ;
      ID       1 ;
      OF       oDlg ;
      ACTION   ( ExecuteReportGalery( oTrvArbolGaleria ) )

   REDEFINE BUTTON ;
      ID       2 ;
      OF       oDlg ;
      ACTION   oDlg:End()

    REDEFINE BUTTON ;
      ID       998 ;
      OF       oDlg ;
      ACTION   ( ChmHelp( "GaleriadeInformes" ) )

      oDlg:AddFastKey( VK_F1, {|| ChmHelp( "GaleriadeInformes" ) } )
      oDlg:AddFastKey( VK_F5, {|| ExecuteReportGalery( oTrvArbolGaleria ) } )

   ACTIVATE DIALOG oDlg CENTERED ;
      ON INIT  ( OnInitReportGalery( oLstTipoGaleria, oImgTipoGaleria, oImgArbolGaleria, oTrvArbolGaleria ) )

Return nil

//----------------------------------------------------------------------------//

Static Function OnInitReportGalery( oLstTipoGaleria, oImgTipoGaleria, oImgArbolGaleria, oTrvArbolGaleria )

   oLstTipoGaleria:SetImageList( oImgTipoGaleria )

   oLstTipoGaleria:InsertItem( 0, "Ventas" )
   oLstTipoGaleria:InsertItem( 1, "Compras" )
   oLstTipoGaleria:InsertItem( 2, "Existencias" )
   oLstTipoGaleria:InsertItem( 3, "Producción" )

   oLstTipoGaleria:nOption       := 1

   CreateProduccionReportGalery( oTrvArbolGaleria )

Return nil

//----------------------------------------------------------------------------//

Static Function SelectReportGalery( nOption, oTrvArbolGaleria )

   oTrvArbolGaleria:DeleteAll()

   do case
      case nOption == 1
         CreateProduccionReportGalery( oTrvArbolGaleria )

      case nOption == 2
         CreateProduccionReportGalery( oTrvArbolGaleria )

      case nOption == 3
         CreateProduccionReportGalery( oTrvArbolGaleria )

      case nOption == 4
         CreateProduccionReportGalery( oTrvArbolGaleria )

   end case

Return nil

//----------------------------------------------------------------------------//

Static Function ExecuteReportGalery( oTrvArbolGaleria )

   local oTreeInforme   := oTrvArbolGaleria:GetItem()

   if !Empty( oTreeInforme ) .and. !Empty( oTreeInforme:bAction )
      Eval( oTreeInforme:bAction )
   end if

Return nil

//---------------------------------------------------------------------------//

Static Function CreateProduccionReportGalery( oTrvArbolGaleria )

   local oTrvTipo
   local oTrvDocumento

   oTrvTipo             := oTrvArbolGaleria:Add( "Diarios" )

      oTrvDocumento     := oTrvTipo:Add( "Producción" )

         oTrvDocumento:Add( "Diario de producción", 0, {|| PInfMateriales():New( "Informe de materiales producidos" ):Play() }  )

Return nil

//---------------------------------------------------------------------------//