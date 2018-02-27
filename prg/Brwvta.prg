#include "FiveWin.Ch" 
#include "Folder.ch"
#include "Report.ch"
#include "Label.ch"
#include "Factu.ch" 
#include "MesDbf.ch"
#include "TGraph.ch"

#define IDC_CHART1               111

#define fldDocumentos            oFld:aDialogs[ 1 ]
#define fldStocks                oFld:aDialogs[ 2 ]
#define fldEstadisticas          oFld:aDialogs[ 3 ]
#define fldGraficos              oFld:aDialogs[ 4 ]
#define fldContadores            oFld:aDialogs[ 5 ]

static nView

static dbfDiv
static dbfIva
static dbfAlm
static dbfArticulo

static dbfArtKit

static dbfPedPrvT
static dbfPedPrvL
static dbfAlbPrvT
static dbfAlbPrvL
static dbfFacPrvT
static dbfFacPrvL
static dbfFacPrvP
static dbfAlbCliT
static dbfAlbCliL
static dbfSatCliT
static dbfSatCliL
static dbfFacCliT
static dbfFacCliL
static dbfFacCliP
static dbfFacRecT
static dbfFacRecL
static dbfPreCliT
static dbfPreCliL
static dbfPedCliT
static dbfPedCliL
static dbfPedCliR
static dbfTikCliT
static dbfTikCliL
static dbfTikCliP
static dbfProducT
static dbfProducL
static dbfProducM
static dbfRctPrvT
static dbfRctPrvL

static oDbfTmp

static oBtnFiltro

static cPouDiv
static cPinDiv
static cPirDiv
static cPorDiv
static nDouDiv
static nDorDiv
static nDinDiv
static nDirDiv
static cPicUnd
static nVdvDiv

static oMenu

static oMeter
static nMeter

static oText
static cText         := ""

static oTreeImageList
static oTreeDocument
static oTreeCompras
static oTreeVentas
static oTreeProduccion

static oStock
static nTotResStk    := 0
static nTotEntStk    := 0
static nTotActStk    := 0
static nStkCom       := 0
static nStkVta       := 0
static nStkPro       := 0
static nStkCon       := 0
static oStkCom
static oStkVta
static oStkPro
static oStkCon
static oTotActStk
static oTotResStk
static oTotEntStk
static oStkLibre
static nStkLibre     := 0
static oPesStk
static oVolStk
static oPesUnd
static oVolUnd
static nPesStk       := 0
static nVolStk       := 0
static nPesUnd       := 0
static nVolUnd       := 0

static oCom
static aCom
static oTotCom
static aTotCom
static oVta
static aVta
static oTotVta
static aTotVta
static aProducido
static aConsumido

static oGraph


#ifndef __PDA__

//---------------------------------------------------------------------------//
//Funciones del programa
//---------------------------------------------------------------------------//


Static Function OpenFiles( cCodArt )

   local oError
   local oBlock
   local lOpenFiles  := .t.

   CursorWait()

   oTotCom           := Array( 5 )
   oCom              := Array( 12, 3 )
   aTotCom           := Afill( Array( 5 ), 0 )
   aCom              := Array( 12, 3 )
   aEval( aCom, {|a| Afill( a, 0 ) } )

   oTotVta           := Array( 4 )
   oVta              := Array( 12, 3 )
   aTotVta           := Afill( Array( 5 ), 0 )
   aVta              := Array( 12, 4 )
   aEval( aVta, {|a| Afill( a, 0 ) } )

   aProducido        := Array( 12, 3 )
   aEval( aProducido, {|a| Afill( a, 0 ) } )

   aConsumido        := Array( 12, 3 )
   aEval( aConsumido, {|a| Afill( a, 0 ) } )

   oBlock            := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   nView             := D():CreateView()

   D():PropiedadesLineas( nView )

   USE ( cPatArt() + "ARTICULO.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ARTICULO", @dbfArticulo ) )
   SET ADSINDEX TO ( cPatArt() + "ARTICULO.CDX" ) ADDITIVE

   USE ( cPatDat() + "DIVISAS.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "DIVISAS", @dbfDiv ) )
   SET ADSINDEX TO ( cPatDat() + "DIVISAS.CDX" ) ADDITIVE

   USE ( cPatDat() + "TIVA.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "TIVA", @dbfIva ) )
   SET ADSINDEX TO ( cPatDat() + "TIVA.CDX" ) ADDITIVE

   USE ( cPatAlm() + "ALMACEN.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ALMACEN", @dbfAlm ) )
   SET ADSINDEX TO ( cPatAlm() + "ALMACEN.CDX" ) ADDITIVE

   USE ( cPatEmp() + "PEDPROVT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PEDPROVT", @dbfPedPrvT ) )
   SET ADSINDEX TO ( cPatEmp() + "PEDPROVT.CDX" ) ADDITIVE

   USE ( cPatEmp() + "PEDPROVL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PEDPROVL", @dbfPedPrvL ) )
   SET ADSINDEX TO ( cPatEmp() + "PEDPROVL.CDX" ) ADDITIVE
   SET TAG TO "CREF"

   USE ( cPatEmp() + "ALBPROVT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ALBPROVT", @dbfAlbPrvT ) )
   SET ADSINDEX TO ( cPatEmp() + "ALBPROVT.CDX" ) ADDITIVE

   USE ( cPatEmp() + "ALBPROVL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ALBPROVL", @dbfAlbPrvL ) )
   SET ADSINDEX TO ( cPatEmp() + "ALBPROVL.CDX" ) ADDITIVE
   SET TAG TO "CREF"

   USE ( cPatEmp() + "FACPRVT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FACPRVT", @dbfFacPrvT ) )
   SET ADSINDEX TO ( cPatEmp() + "FACPRVT.CDX" ) ADDITIVE

   USE ( cPatEmp() + "FACPRVL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FACPRVL", @dbfFacPrvL ) )
   SET ADSINDEX TO ( cPatEmp() + "FACPRVL.CDX" ) ADDITIVE
   SET TAG TO "CREF"

   USE ( cPatEmp() + "FACPRVP.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FACPRVP", @dbfFacPrvP ) )
   SET ADSINDEX TO ( cPatEmp() + "FACPRVP.CDX" ) ADDITIVE

   USE ( cPatEmp() + "RctPrvT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "RctPrvL", @dbfRctPrvT ) )
   SET ADSINDEX TO ( cPatEmp() + "RctPrvT.CDX" ) ADDITIVE

   USE ( cPatEmp() + "RctPrvL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "RctPrvL", @dbfRctPrvL ) )
   SET ADSINDEX TO ( cPatEmp() + "RctPrvL.CDX" ) ADDITIVE
   SET TAG TO "cRef"

   /*
   Documentos relacionados de ventas
   */

   USE ( cPatEmp() + "PRECLIL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PRECLIL", @dbfPreCliL ) )
   SET ADSINDEX TO ( cPatEmp() + "PRECLIL.CDX" ) ADDITIVE
   SET TAG TO "CREF"

   /*
   Documentos relacionados de ventas
   */

   USE ( cPatEmp() + "PEDCLIL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PEDCLIL", @dbfPedCliL ) )
   SET ADSINDEX TO ( cPatEmp() + "PEDCLIL.CDX" ) ADDITIVE
   SET TAG TO "CREF"

   USE ( cPatEmp() + "PEDCLIR.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PEDCLIR", @dbfPedCliR ) )
   SET ADSINDEX TO ( cPatEmp() + "PEDCLIR.CDX" ) ADDITIVE
   SET TAG TO "CREF"

   USE ( cPatEmp() + "SatCliL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "SatCliL", @dbfSatCliL ) )
   SET ADSINDEX TO ( cPatEmp() + "SatCliL.CDX" ) ADDITIVE
   SET TAG TO "cRef"

   USE ( cPatEmp() + "ALBCLIL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ALBCLIL", @dbfAlbCliL ) )
   SET ADSINDEX TO ( cPatEmp() + "ALBCLIL.CDX" ) ADDITIVE
   SET TAG TO "CREF"

   USE ( cPatEmp() + "FACCLIL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FACCLIL", @dbfFacCliL ) )
   SET ADSINDEX TO ( cPatEmp() + "FACCLIL.CDX" ) ADDITIVE
   SET TAG TO "CREF"

   USE ( cPatEmp() + "FACRECT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FACRECT", @dbfFacRecT ) )
   SET ADSINDEX TO ( cPatEmp() + "FACRECT.CDX" ) ADDITIVE

   USE ( cPatEmp() + "FACRECL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FACRECL", @dbfFacRecL ) )
   SET ADSINDEX TO ( cPatEmp() + "FACRECL.CDX" ) ADDITIVE
   SET TAG TO "CREF"

   USE ( cPatEmp() + "TIKET.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "TIKET", @dbfTikCliT ) )
   SET ADSINDEX TO ( cPatEmp() + "TIKET.CDX" ) ADDITIVE

   USE ( cPatEmp() + "TIKEL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "TIKEL", @dbfTikCliL ) )
   SET ADSINDEX TO ( cPatEmp() + "TIKEL.CDX" ) ADDITIVE
   SET TAG TO "CCBATIL"

   USE ( cPatEmp() + "TIKEP.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "TIKEP", @dbfTikCliP ) )
   SET ADSINDEX TO ( cPatEmp() + "TIKEP.CDX" ) ADDITIVE

   USE ( cPatArt() + "ARTKIT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ARTTIK", @dbfArtKit ) )
   SET ADSINDEX TO ( cPatArt() + "ARTKIT.CDX" ) ADDITIVE

   USE ( cPatEmp() + "PROCAB.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PROCAB", @dbfProducT ) )
   SET ADSINDEX TO ( cPatEmp() + "PROCAB.CDX" ) ADDITIVE

   USE ( cPatEmp() + "PROLIN.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PROLIN", @dbfProducL ) )
   SET ADSINDEX TO ( cPatEmp() + "PROLIN.CDX" ) ADDITIVE
   SET TAG TO "CCODART"

   USE ( cPatEmp() + "PROMAT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PROMAT", @dbfProducM ) )
   SET ADSINDEX TO ( cPatEmp() + "PROMAT.CDX" ) ADDITIVE
   SET TAG TO "CCODART"

   if !TDataCenter():OpenSatCliT( @dbfSatCliT )
     lOpenFiles         := .f.
   end if

   if !TDataCenter():OpenPreCliT( @dbfPreCliT )
      lOpenFiles        := .f.
   end if 

   if !TDataCenter():OpenPedCliT( @dbfPedCliT )
      lOpenFiles        := .f.
   end if 

   if !TDataCenter():OpenFacCliT( @dbfFacCliT )
      lOpenFiles        := .f.
   end if

   if !TDataCenter():OpenFacCliP( @dbfFacCliP )
      lOpenFiles        := .f.
   end if

   if !TDataCenter():OpenAlbCliT( @dbfAlbCliT )
      lOpenFiles        := .f.
   end if

   oDbfTmp              := DefineTemporal()
   oDbfTmp:Activate( .f., .f. )

   oStock                                          := TStock():Create( cPatEmp() )
   if oStock:lOpenFiles()
      oStock:lIntegra                              := .f.
      oStock:lCalculateUnidadesPendientesRecibir   := .t.
   else 
      lOpenFiles                                   := .f.
   end if

   RECOVER USING oError

      msgStop( ErrorMessage( oError ), "Imposible abrir las bases de datos" )
      
      lOpenFiles        := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

   CursorWE()

Return ( lOpenFiles )

//---------------------------------------------------------------------------//

Static Function CloseFiles()

   /*
   Quitamos el ImageList-------------------------------------------------------
   */

   if oTreeImageList != nil
      oTreeImageList:End()
   end if

   D():DeleteView( nView )

   ( dbfDiv     )->( dbCloseArea() )
   ( dbfIva     )->( dbCloseArea() )
   ( dbfAlm     )->( dbCloseArea() )
   ( dbfArticulo)->( dbCloseArea() )
   ( dbfPedPrvT )->( dbCloseArea() )
   ( dbfPedPrvL )->( dbCloseArea() )
   ( dbfAlbPrvT )->( dbCloseArea() )
   ( dbfAlbPrvL )->( dbCloseArea() )
   ( dbfFacPrvT )->( dbCloseArea() )
   ( dbfFacPrvL )->( dbCloseArea() )
   ( dbfFacPrvP )->( dbCloseArea() )
   ( dbfPreCliT )->( dbCloseArea() )
   ( dbfPreCliL )->( dbCloseArea() )
   ( dbfPedCliT )->( dbCloseArea() )
   ( dbfPedCliL )->( dbCloseArea() )
   ( dbfPedCliR )->( dbCloseArea() )
   ( dbfAlbCliT )->( dbCloseArea() )
   ( dbfAlbCliL )->( dbCloseArea() )
   ( dbfFacCliT )->( dbCloseArea() )
   ( dbfFacCliL )->( dbCloseArea() )
   ( dbfFacCliP )->( dbCloseArea() )
   ( dbfFacRecT )->( dbCloseArea() )
   ( dbfFacRecL )->( dbCloseArea() )
   ( dbfTikCliT )->( dbCloseArea() )
   ( dbfTikCliL )->( dbCloseArea() )
   ( dbfTikCliP )->( dbCloseArea() )
   ( dbfArtKit  )->( dbCloseArea() )
   ( dbfProducT )->( dbCloseArea() )
   ( dbfProducL )->( dbCloseArea() )
   ( dbfProducM )->( dbCloseArea() )
   ( dbfRctPrvT )->( dbCloseArea() )
   ( dbfRctPrvL )->( dbCloseArea() )
   ( dbfSatCliT )->( dbCloseArea() )
   ( dbfSatCliL )->( dbCloseArea() )

   if !Empty( oStock )
      oStock:End()
   end if

   if !Empty( oDbfTmp )
      oDbfTmp:Close()
      dbfErase( oDbfTmp:cPath + oDbfTmp:cName )
   end if

Return .t.

//---------------------------------------------------------------------------//

function BrwVtaComArt( cCodArt, cNomArt )

   local nOrd
   local nRec
   local oDlg
   local oFld
   local oBrwTmp
   local oBrwStk
   local oBrwCom
   local oBrwVta
   local oTree
   local oCmbAnio
   local cCmbAnio          := "Todos"
   local oBmpGeneral
   local oBmpDocumentos
   local oBmpGraficos
   local oBmpStock
   local aPrompts          := {  "&Documentos"        ,;
                                 "Stock"              ,;
                                 "&Estadisticas"      ,;
                                 "Gráfico" }
   local aDialogs          := {  "INFO_1"             ,;
                                 "INFO_3"             ,;
                                 "ART_8"              ,;
                                 "INFO_2"            }


   if Empty( cCodArt )
      Return nil
   end if

   if !OpenFiles( cCodArt )
      Return nil
   end if

   CursorWait()

   nRec                    := ( dbfArticulo )->( Recno() )
   nOrd                    := ( dbfArticulo )->( OrdSetFocus( 1 ) )

   cPouDiv                 := cPouDiv( cDivEmp(), dbfDiv )
   cPinDiv                 := cPinDiv( cDivEmp(), dbfDiv )
   cPirDiv                 := cPirDiv( cDivEmp(), dbfDiv )
   cPorDiv                 := cPorDiv( cDivEmp(), dbfDiv )
   nDouDiv                 := nDouDiv( cDivEmp(), dbfDiv )
   nDorDiv                 := nRouDiv( cDivEmp(), dbfDiv )
   nDinDiv                 := nDinDiv( cDivEmp(), dbfDiv ) // Decimales sin redondeo
   nDirDiv                 := nRinDiv( cDivEmp(), dbfDiv ) // Decimales con redondeo
   cPicUnd                 := MasUnd()                     // Picture de las unidades
   nVdvDiv                 := nChgDiv( cDivEmp(), dbfDiv )
   nPesUnd                 := RetFld( cCodArt, dbfArticulo, "nPesoKg" )
   nVolUnd                 := RetFld( cCodArt, dbfArticulo, "nVolumen" )

   /*
   Codigo de articulo----------------------------------------------------------
   */

   if !( dbfArticulo )->( dbSeek( cCodArt ) )
      msgStop( "Artículo " + alltrim(cCodArt) + " no encontrado." )
      CloseFiles()
      Return nil 
   end if 

   /*
   Montamos el dialogo
   */

   DEFINE DIALOG oDlg RESOURCE "ArtInfo" TITLE "Información del artículo : " + Rtrim( cCodArt ) + " - " + Rtrim( cNomArt )

      oFld           := TFolder():ReDefine( 300, aPrompts, aDialogs, oDlg,,,,, .f. )

      /*
      Compras---------------------------------------------------------------------
      */

      REDEFINE BITMAP oBmpGeneral;
         ID          500 ;
         RESOURCE    "gc_object_cube_48" ;
         TRANSPARENT ;
         OF          fldEstadisticas          

   /*
   Browse de Compras-----------------------------------------------------------
   */

   oBrwCom                       := IXBrowse():New( fldEstadisticas )

   oBrwCom:bClrSel               := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
   oBrwCom:bClrSelFocus          := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

   oBrwCom:SetArray( aCom, , , .f. )

   oBrwCom:lFooter               := .t.
   oBrwCom:lVScroll              := .f.
   oBrwCom:lHScroll              := .f.
   oBrwCom:nMarqueeStyle         := 5
   oBrwCom:nFooterHeight         := 35

   oBrwCom:nFooterLines          := 2
   oBrwCom:cName                 := "Compras en informe de articulos"
   oBrwCom:CreateFromResource( 400 )

   with object ( oBrwCom:AddCol() )
      :cHeader                   := "Mes"
      :nWidth                    := 90
      :bStrData                  := {|| cNombreMes( oBrwCom:nArrayAt ) }
      :bFooter                   := {|| "Totales" + CRLF + "Medias" }
   end with

   with object ( oBrwCom:AddCol() )
      :cHeader                   := cNombreCajas()
      :nWidth                    := 90
      :bEditValue                := {|| aCom[ oBrwCom:nArrayAt, 1] }
      :cEditPicture              := cPicUnd
      :bFooter                   := {|| aTotCom[1] }
      :nDataStrAlign             := 1
      :nHeadStrAlign             := 1
      :nFootStrAlign             := 1
   end with

   with object ( oBrwCom:AddCol() )
      :cHeader                   := cNombreUnidades()
      :nWidth                    := 90
      :bEditValue                := {|| aCom[ oBrwCom:nArrayAt, 2] }
      :cEditPicture              := cPicUnd
      :bFooter                   := {|| aTotCom[2] }
      :nDataStrAlign             := 1
      :nHeadStrAlign             := 1
      :nFootStrAlign             := 1
   end with

   with object ( oBrwCom:AddCol() )
      :cHeader                   := "Total " + cNombreUnidades()
      :nWidth                    := 90
      :bEditValue                := {|| NotCero( aCom[ oBrwCom:nArrayAt, 1] ) + NotCero( aCom[ oBrwCom:nArrayAt, 2] ) }
      :cEditPicture              := cPicUnd
      :bFooter                   := {|| aTotCom[2] }
      :nDataStrAlign             := 1
      :nHeadStrAlign             := 1
      :nFootStrAlign             := 1
      :lHide                     := .t.
   end with

   with object ( oBrwCom:AddCol() )
      :cHeader                   := "Importe"
      :nWidth                    := 100
      :bEditValue                := {|| aCom[ oBrwCom:nArrayAt, 3] }
      :cEditPicture              := cPirDiv
      :bFooter                   := {|| Trans( aTotCom[3], cPirDiv ) + CRLF + Trans( aTotCom[4], cPirDiv ) }
      :nDataStrAlign             := 1
      :nHeadStrAlign             := 1
      :nFootStrAlign             := 1
   end with

   /*
   Browse de ventas------------------------------------------------------------
   */

   oBrwVta                       := IXBrowse():New( fldEstadisticas )

   oBrwVta:bClrSel               := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
   oBrwVta:bClrSelFocus          := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

   oBrwVta:SetArray( aVta, , , .f. )

   oBrwVta:lFooter               := .t.
   oBrwVta:lVScroll              := .f.
   oBrwVta:lHScroll              := .f.
   oBrwVta:nMarqueeStyle         := 5
   oBrwVta:nFooterHeight         := 35
   oBrwVta:nFooterLines          := 2
   oBrwVta:cName                 := "Ventas en informe de articulos"
   oBrwVta:CreateFromResource( 410 )

   with object ( oBrwVta:AddCol() )
      :cHeader                   := cNombreCajas()
      :nWidth                    := 90
      :bEditValue                := {|| aVta[ oBrwVta:nArrayAt, 1] }
      :cEditPicture              := cPicUnd
      :bFooter                   := {|| aTotVta[1] }
      :nDataStrAlign             := 1
      :nHeadStrAlign             := 1
      :nFootStrAlign             := 1
   end with

   with object ( oBrwVta:AddCol() )
      :cHeader                   := cNombreUnidades()
      :nWidth                    := 90
      :bEditValue                := {|| aVta[ oBrwVta:nArrayAt, 2] }
      :cEditPicture              := cPicUnd
      :bFooter                   := {|| aTotVta[2] }
      :nDataStrAlign             := 1
      :nHeadStrAlign             := 1
      :nFootStrAlign             := 1
   end with

   with object ( oBrwVta:AddCol() )
      :cHeader                   := "Total " + cNombreUnidades()
      :nWidth                    := 90
      :bEditValue                := {|| NotCero( aVta[ oBrwVta:nArrayAt, 1] ) + NotCero( aVta[ oBrwVta:nArrayAt, 2] ) }
      :cEditPicture              := cPicUnd
      :bFooter                   := {|| aTotVta[2] }
      :nDataStrAlign             := 1
      :nHeadStrAlign             := 1
      :nFootStrAlign             := 1
      :lHide                     := .t.
   end with

   with object ( oBrwVta:AddCol() )
      :cHeader                   := "Importe"
      :nWidth                    := 110
      :bEditValue                := {|| aVta[ oBrwVta:nArrayAt, 3] }
      :cEditPicture              := cPirDiv
      :bFooter                   := {|| Trans( aTotVta[3], cPirDiv ) + CRLF + Trans( aTotVta[4], cPirDiv ) }
      :nDataStrAlign             := 1
      :nHeadStrAlign             := 1
      :nFootStrAlign             := 1
   end with

   with object ( oBrwVta:AddCol() )
      :cHeader                   := "Rentabilidad"
      :nWidth                    := 110
      :bEditValue                := {|| aVta[ oBrwVta:nArrayAt, 4] }
      :cEditPicture              := cPirDiv
      :bFooter                   := {|| Trans( aTotVta[5], cPirDiv ) + CRLF + Trans( ( aTotVta[5] / aTotVta[2] ), cPirDiv )  }
      :nDataStrAlign             := 1
      :nHeadStrAlign             := 1
      :nFootStrAlign             := 1
   end with

   /*
   Desglose de almacen---------------------------------------------------------
   */

   REDEFINE BITMAP   oBmpStock;
         ID          500 ;
         RESOURCE    "gc_package_48" ;
         TRANSPARENT ;
         OF          fldStocks

   oBrwStk                       := IXBrowse():New( fldStocks )

   oBrwStk:bClrSel               := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
   oBrwStk:bClrSelFocus          := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

   oBrwStk:lFooter               := .t.
   oBrwStk:lVScroll              := .t.
   oBrwStk:lHScroll              := .t.
   oBrwStk:nMarqueeStyle         := 5
   oBrwStk:cName                 := "Stocks en informe de articulos"

   with object ( oBrwStk:AddCol() )
      :cHeader                   := "Prop. 1"
      :nWidth                    := 50
      :bStrData                  := {|| getTreeValue( oBrwStk, "cValorPropiedad1" ) }
      :lHide                     := .t.
   end with

   with object ( oBrwStk:AddCol() )
      :cHeader                   := "Prop. 2"
      :nWidth                    := 50
      :bStrData                  := {|| getTreeValue( oBrwStk, "cValorPropiedad2" ) }
      :lHide                     := .t.
   end with

   with object ( oBrwStk:AddCol() )
      :cHeader                   := "Nombre propiedad 1"
      :bEditValue                := {|| nombrePropiedad( getTreeValue( oBrwStk, "cCodigoPropiedad1" ), getTreeValue( oBrwStk, "cValorPropiedad1" ), nView ) }
      :nWidth                    := 60
      :lHide                     := .t.
   end with

   with object ( oBrwStk:AddCol() )
      :cHeader                   := "Nombre propiedad 2"
      :bEditValue                := {|| nombrePropiedad( getTreeValue( oBrwStk, "cCodigoPropiedad2" ), getTreeValue( oBrwStk, "cValorPropiedad2" ), nView ) }
      :nWidth                    := 60
      :lHide                     := .t.
   end with

   with object ( oBrwStk:AddCol() )
      :cHeader                   := "Lote"
      :nWidth                    := 70
      :bEditValue                := {|| getTreeValue( oBrwStk, "cLote" ) }
      :lHide                     := .t.
   end with

   with object ( oBrwStk:AddCol() )
      :cHeader                   := "Unidades"
      :nWidth                    := 70
      :bEditValue                := {|| getTreeValue( oBrwStk, "nUnidades" ) }
      :bFooter                   := {|| nFooterTree( oBrwStk, "nUnidades" ) }
      :cEditPicture              := MasUnd()
   end with

   with object ( oBrwStk:AddCol() )
      :cHeader                   := "Pdt. recibir"
      :nWidth                    := 70
      :bEditValue                := {|| getTreeValue( oBrwStk, "nPendientesRecibir" ) }
      :bFooter                   := {|| nFooterTree( oBrwStk, "nPendientesRecibir" ) }
      :cEditPicture              := MasUnd()
   end with

   with object ( oBrwStk:AddCol() )
      :cHeader                   := "Pdt. entregar"
      :nWidth                    := 70
      :bEditValue                := {|| getTreeValue( oBrwStk, "nPendientesEntregar" ) }
      :bFooter                   := {|| nFooterTree( oBrwStk, "nPendientesEntregar" ) }
      :cEditPicture              := MasUnd()
   end with

   with object ( oBrwStk:AddCol() )
      :cHeader                   := "Peso stock"
      :nWidth                    := 70
      :bEditValue                := {|| getTreeValue( oBrwStk, "nUnidades" ) * nPesUnd }
      :bFooter                   := {|| nFooterTree( oBrwStk, "nUnidades" ) * nPesUnd }
      :cEditPicture              := MasUnd()
   end with

   with object ( oBrwStk:AddCol() )
      :cHeader                   := "Volumen stock"
      :nWidth                    := 80
      :bEditValue                := {|| getTreeValue( oBrwStk, "nUnidades" ) * nVolUnd }
      :bFooter                   := {|| nFooterTree( oBrwStk, "nUnidades" ) * nVolUnd }
      :cEditPicture              := MasUnd()
   end with

   with object ( oBrwStk:AddCol() )
      :cHeader                   := "Consolidación"
      :nWidth                    := 70
      :bStrData                  := {|| getTreeValue( oBrwStk, "dConsolidacion" ) }
      :lHide                     := .t.
   end with

   oBrwStk:CreateFromResource( 300 )
   
   /*
   Documentos------------------------------------------------------------------
   */

   REDEFINE BITMAP oBmpDocumentos ID 500 RESOURCE "gc_document_text_pencil_48" TRANSPARENT OF fldDocumentos

   oTree             := TTreeView():Redefine( 310, fldDocumentos  )
   oTree:bChanged    := {|| TreeChanged( oTree, oBrwTmp ) }

   /*
   Barra de botones y datos----------------------------------------------------
   */

   REDEFINE BUTTON ;
      ID       301 ;
      OF       fldDocumentos ;
      ACTION   ( EditDocument( oBrwTmp ), LoadDatos( cCodArt, cCmbAnio, oDlg, oBrwStk, oBrwTmp, oGraph, oBrwCom, oBrwVta ) )

   REDEFINE BUTTON ;
      ID       302 ;
      OF       fldDocumentos ;
      ACTION   ( ZoomDocument( oBrwTmp ) )

   REDEFINE BUTTON ;
      ID       303 ;
      OF       fldDocumentos ;
      ACTION   ( DeleteDocument( oBrwTmp ), LoadDatos( cCodArt, cCmbAnio, oDlg, oBrwStk, oBrwTmp, oGraph, oBrwCom, oBrwVta ) )

   REDEFINE BUTTON ;
      ID       304 ;
      OF       fldDocumentos ;
      ACTION   ( VisualizaDocument( oBrwTmp ) )

   REDEFINE BUTTON ;
      ID       305 ;
      OF       fldDocumentos ;
      ACTION   ( PrintDocument( oBrwTmp ) )

   REDEFINE BUTTON oBtnFiltro ;
      ID       306 ;
      OF       fldDocumentos ;
      ACTION   ( Filtro( oBrwTmp ) )

   REDEFINE BUTTON ;
      ID       307 ;
      OF       fldDocumentos ;
      ACTION   ( TInfLArt():New( "Informe detallado de documentos", , , , , , { oDbfTmp, cCmbAnio } ):Play() )

   oBrwTmp                       := IXBrowse():New( fldDocumentos )

   oBrwTmp:bClrSel               := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
   oBrwTmp:bClrSelFocus          := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

   oDbfTmp:SetBrowse( oBrwTmp )

   oBrwTmp:nMarqueeStyle         := 5
   oBrwTmp:lFooter               := .t.

   oBrwTmp:cName                 := "Docs info articulo"

   oBrwTmp:CreateFromResource( 300 )

   with object ( oBrwTmp:addCol() )
      :cHeader       := "Dc. Documento"
      :bStrData      := {|| cTextDocument() }
      :bBmpData      := {|| TreeImagen() }
      :nWidth        := 20
      :AddResource( "gc_clipboard_empty_businessman_16" )
      :AddResource( "gc_document_empty_businessman_16" )
      :AddResource( "gc_document_text_businessman_16" )
      :AddResource( "gc_pencil_package_16" )
      :AddResource( "gc_notebook_user_16" )
      :AddResource( "gc_clipboard_empty_user_16" )
      :AddResource( "gc_document_empty_16" )
      :AddResource( "gc_document_text_businessman_16" )
      :AddResource( "gc_cash_register_user_16" )
      :AddResource( "gc_document_text_delete2_16" )
      :AddResource( "gc_document_text_worker_16" )
      :AddResource( "gc_document_text_delete2_16" )
      :AddResource( "gc_power_drill_sat_user_16" )
   end with

   with object ( oBrwTmp:addCol() )
      :cHeader       := "Estado"
      :bEditValue    := {|| oDbfTmp:cEstDoc }
      :nWidth        := 70
   end with

   with object ( oBrwTmp:addCol() )
      :cHeader       := "Número"
      :bEditValue    := {|| cMaskNumDoc( oDbfTmp ) }
      :cSortOrder    := "cNumDoc"
      :nWidth        := 80
   end with

   with object ( oBrwTmp:addCol() )
      :cHeader       := "Delegación"
      :bEditValue    := {|| oDbfTmp:cSufDoc }
      :cSortOrder    := "cSufDoc"
      :nWidth        := 40
   end with

   with object ( oBrwTmp:addCol() )
      :cHeader       := "Fecha"
      :bEditValue    := {|| Dtoc( oDbfTmp:dFecDoc ) }
      :cSortOrder    := "dFecDoc"
      :nWidth        := 70
   end with

   with object ( oBrwTmp:addCol() )
      :cHeader       := "Hora"
      :bEditValue    := {|| oDbfTmp:tFecDoc }
      :cEditPicture  := "@R 99:99:99"
      :cSortOrder    := "tFecDoc"
      :nWidth        := 60
   end with

   with object ( oBrwTmp:addCol() )
      :cHeader       := "Código"
      :bEditValue    := {|| oDbfTmp:cCodDoc }
      :cSortOrder    := "cCodDoc"
      :nWidth        := 50
   end with

   with object ( oBrwTmp:addCol() )
      :cHeader       := "Nombre"
      :bEditValue    := {|| oDbfTmp:cNomDoc }
      :cSortOrder    := "cNomDoc"
      :nWidth        := 155
   end with

   with object ( oBrwTmp:addCol() )
      :cHeader       := "Prop. 1"
      :bEditValue    := {|| oDbfTmp:cValPr1 }
      :nWidth        := 40
      :lHide         := .t.
   end with

   with object ( oBrwTmp:addCol() )
      :cHeader       := "Prop. 2"
      :bEditValue    := {|| oDbfTmp:cValPr2 }
      :nWidth        := 40
      :lHide         := .t.
   end with

   with object ( oBrwTmp:addCol() )
      :cHeader       := "Nombre propiedad 1"
      :bEditValue    := {|| nombrePropiedad( oDbfTmp:cCodPr1, oDbfTmp:cValPr1, nView ) }
      :nWidth        := 40
      :lHide         := .t.
   end with

   with object ( oBrwTmp:addCol() )
      :cHeader       := "Nombre propiedad 2"
      :bEditValue    := {|| nombrePropiedad( oDbfTmp:cCodPr2, oDbfTmp:cValPr2, nView ) }
      :nWidth        := 40
      :lHide         := .t.
   end with

   with object ( oBrwTmp:addCol() )
      :cHeader       := "Lote"
      :bEditValue    := {|| oDbfTmp:cLote }
      :cSortOrder    := "cLote"
      :nWidth        := 80
      :lHide         := .t.
   end with

   with object ( oBrwTmp:addCol() )
      :cHeader       := "Unidades"
      :bEditValue    := {|| oDbfTmp:nUndDoc }
      :cSortOrder    := "nNundDoc"
      :cEditPicture  := cPicUnd
      :bFooter       := {|| nTotUnd( oDbfTmp ) }
      :nWidth        := 70
      :nDataStrAlign := 1
      :nHeadStrAlign := 1
      :nFootStrAlign := 1
   end with

   with object ( oBrwTmp:addCol() )
      :cHeader       := "Factor"
      :bEditValue    := {|| oDbfTmp:nFacCnv }
      :cSortOrder    := "nFactor"
      :cEditPicture  := "@E 999,999.999999"
      :nWidth        := 90
      :nDataStrAlign := 1
      :nHeadStrAlign := 1
      :nFootStrAlign := 1
      :lHide         := .t.
   end with


   with object ( oBrwTmp:addCol() )
      :cHeader       := "Importe"
      :bEditValue    := {|| oDbfTmp:nImpDoc }
      :cSortOrder    := "nImpDoc"
      :cEditPicture  := cPouDiv
      :nWidth        := 70
      :nDataStrAlign := 1
      :nHeadStrAlign := 1
   end with

   with object ( oBrwTmp:addCol() )
      :cHeader       := "Total"
      :bEditValue    := {|| oDbfTmp:nTotDoc }
      :cSortOrder    := "nTotDoc"
      :cEditPicture  := cPouDiv
      :bFooter       := {|| nTotImp( oDbfTmp ) }
      :nWidth        := 70
      :nDataStrAlign := 1
      :nHeadStrAlign := 1
      :nFootStrAlign := 1
   end with

   with object ( oBrwTmp:addCol() )
      :cHeader       := "%Dto."
      :bEditValue    := {|| oDbfTmp:nDtoDoc }
      :cEditPicture  := "@E 999.99"
      :nWidth        := 40
      :nDataStrAlign := 1
      :nHeadStrAlign := 1
      :lHide         := .t.
   end with

   with object ( oBrwTmp:addCol() )
      :cHeader       := "Almacén destino"
      :cSortOrder    := "cAlmDoc"
      :bEditValue    := {|| oDbfTmp:cAlmDoc }
      :nWidth        := 40
      :lHide         := .t.
   end with

   with object ( oBrwTmp:addCol() )
      :cHeader       := "Almacén origen"
      :cSortOrder    := "cAlmOrg"
      :bEditValue    := {|| oDbfTmp:cAlmOrg }
      :nWidth        := 40
      :lHide         := .t.
   end with


   oBrwTmp:bLDblClick   := {|| ZoomDocument( oBrwTmp ) }

   /*
   Graph start setting---------------------------------------------------------
   */

   REDEFINE BITMAP oBmpGraficos ID 500 RESOURCE "gc_chart_column_48" TRANSPARENT OF fldGraficos

   REDEFINE BTNBMP ;
      ID       101 ;
      OF       fldGraficos ;
      RESOURCE "gc_chart_column_16" ;
      NOBORDER ;
      TOOLTIP  "Gráfico de barras" ;
      ACTION   ( oGraph:SetType( GRAPH_TYPE_BAR ) )

   REDEFINE BTNBMP ;
      ID       102 ;
      OF       fldGraficos ;
      RESOURCE "gc_chart_line_16" ;
      NOBORDER ;
      TOOLTIP  "Gráfico de lineas" ;
      ACTION   ( oGraph:SetType( GRAPH_TYPE_LINE ) )

   REDEFINE BTNBMP ;
      ID       103 ;
      OF       fldGraficos ;
      RESOURCE "gc_chart_dot_16" ;
      NOBORDER ;
      TOOLTIP  "Gráfico de puntos" ;
      ACTION   ( oGraph:SetType( GRAPH_TYPE_POINT ) )

   REDEFINE BTNBMP ;
      ID       104 ;
      OF       fldGraficos ;
      RESOURCE "gc_chart_area_16" ;
      NOBORDER ;
      TOOLTIP  "Gráfico combinado" ;
      ACTION   ( oGraph:SetType( GRAPH_TYPE_PIE ) )

   REDEFINE BTNBMP ;
      ID       105 ;
      OF       fldGraficos ;
      RESOURCE "gc_chart_pie_16" ;
      NOBORDER ;
      TOOLTIP  "Gráfico combinado" ;
      ACTION   ( oGraph:SetType( GRAPH_TYPE_ALL ) )

   REDEFINE BTNBMP ;
      ID       106 ;
      OF       fldGraficos ;
      RESOURCE "gc_3d_glasses_16" ;
      NOBORDER ;
      TOOLTIP  "Gráficos en tres dimensiones" ;
      ACTION   ( oGraph:l3D :=!oGraph:l3D, oGraph:Refresh() )

   REDEFINE BTNBMP ;
      ID       107 ;
      OF       fldGraficos ;
      RESOURCE "gc_copy_16" ;
      NOBORDER ;
      TOOLTIP  "Copiar el gráfico en el portapapeles" ;
      ACTION   ( oGraph:Copy2ClipBoard() )

   REDEFINE BTNBMP ;
      ID       108 ;
      OF       fldGraficos ;
      RESOURCE "gc_printer2_16" ;
      NOBORDER ;
      TOOLTIP  "Imprimir el gráfico" ;
      ACTION   ( GetPrtCoors( oGraph ) )

   REDEFINE BTNBMP ;
      ID       109 ;
      OF       fldGraficos ;
      RESOURCE "gc_clipboard_checks_16" ;
      NOBORDER ;
      TOOLTIP  "Propiedades del gráfico" ;
      ACTION   ( GraphPropierties( oGraph ) )

   oGraph      := TGraph():ReDefine( 300, fldGraficos )

   /*
   Anno del ejecicio, por defecto lleva el anno actual-------------------------
   */

   REDEFINE COMBOBOX oCmbAnio VAR cCmbAnio ;
      ITEMS    { "Todos", "2000", "2001", "2002", "2003", "2004", "2005", "2006", "2007", "2008", "2009", "2010", "2011", "2012", "2013", "2014", "2015", "2016", "2017", "2018", "2019", "2020" } ;
      ID       310 ;
      ON CHANGE( LoadDatos( cCodArt, cCmbAnio, oDlg, oBrwStk, oBrwTmp, oGraph, oBrwCom, oBrwVta ) ); 
      OF       oDlg

   /*
   Botones comunes a la caja de dialogo----------------------------------------
   */

   REDEFINE SAY oText VAR cText ;
      ID       400 ;
      OF       oDlg

   oMeter      := TApoloMeter():ReDefine( 200, { | u | if( pCount() == 0, nMeter, nMeter := u ) }, 10, oDlg, .f., , , .t., Rgb( 255,255,255 ), , Rgb( 128,255,0 ) )

   REDEFINE BUTTON ;
      ID       306 ;
      OF       oDlg ;
      ACTION   ( LoadDatos( cCodArt, cCmbAnio, oDlg, oBrwStk, oBrwTmp, oGraph, oBrwCom, oBrwVta ) )

   REDEFINE BUTTON ;
      ID       501 ;
      OF       oDlg ;
      ACTION   ( oDlg:End() )

   oFld:aDialogs[ 3 ]:AddFastKey( VK_F3, {|| EditDocument( oBrwTmp ),     LoadDatos( cCodArt, cCmbAnio, oDlg, oBrwStk, oBrwTmp, oGraph, oBrwCom, oBrwVta ) } )
   oFld:aDialogs[ 3 ]:AddFastKey( VK_F4, {|| DeleteDocument( oBrwTmp ),   LoadDatos( cCodArt, cCmbAnio, oDlg, oBrwStk, oBrwTmp, oGraph, oBrwCom, oBrwVta ) } )

   oDlg:bStart := {|| LoadDatos( cCodArt, cCmbAnio, oDlg, oBrwStk, oBrwTmp, oGraph, oBrwCom, oBrwVta ), oBrwStk:Load(), oBrwCom:Load(), oBrwVta:Load(), oBrwTmp:Load() }

   ACTIVATE DIALOG oDlg ;
         ON INIT  ( InitBrwVtaCli( cCodArt, oTree, dbfDiv, dbfArticulo, oBrwStk, oBrwTmp, oDlg, cCmbAnio, oGraph, oBrwCom, oBrwVta ), SysRefresh() ) ;
         VALID    ( CloseFiles( oBrwTmp, oBrwStk ) ) ;
         CENTER ;

   oBrwCom:CloseData()
   oBrwVta:CloseData()

   if !Empty( oBmpGeneral )
      oBmpGeneral:End()
   end if

   if !Empty( oBmpDocumentos )
      oBmpDocumentos:End()
   end if

   if !Empty( oBmpGraficos )
      oBmpGraficos:End()
   end if

   if !Empty( oBmpStock )
      oBmpStock:End()
   end if

   oMenu:End()

return nil

//---------------------------------------------------------------------------//

Static Function InitBrwVtaCli( cCodArt, oTree, dbfDiv, dbfArticulo, oBrwStk, oBrwTmp, oDlg, nYear, oGraph, oBrwCom, oBrwVta )

   oTreeImageList := TImageList():New( 16, 16 )

   oTreeImageList:AddMasked( TBitmap():Define( "gc_object_cube_16" ),                  Rgb( 255, 0, 255 ) )

   oTreeImageList:AddMasked( TBitmap():Define( "gc_clipboard_empty_businessman_16" ),  Rgb( 255, 0, 255 ) )
   oTreeImageList:AddMasked( TBitmap():Define( "gc_document_empty_businessman_16" ),   Rgb( 255, 0, 255 ) )
   oTreeImageList:AddMasked( TBitmap():Define( "gc_document_text_businessman_16" ),         Rgb( 255, 0, 255 ) )

   oTreeImageList:AddMasked( TBitmap():Define( "gc_notebook_user_16" ),               Rgb( 255, 0, 255 ) )
   oTreeImageList:AddMasked( TBitmap():Define( "gc_clipboard_empty_user_16" ),        Rgb( 255, 0, 255 ) )
   oTreeImageList:AddMasked( TBitmap():Define( "gc_document_empty_16" ),         Rgb( 255, 0, 255 ) )
   oTreeImageList:AddMasked( TBitmap():Define( "gc_document_text_businessman_16" ),               Rgb( 255, 0, 255 ) )
   oTreeImageList:AddMasked( TBitmap():Define( "gc_document_text_delete2_16" ),              Rgb( 255, 0, 255 ) )
   oTreeImageList:AddMasked( TBitmap():Define( "gc_cash_register_user_16" ),                Rgb( 255, 0, 255 ) )
   oTreeImageList:AddMasked( TBitmap():Define( "gc_money2_16" ),                        Rgb( 255, 0, 255 ) )
   oTreeImageList:AddMasked( TBitmap():Define( "gc_small_truck_16" ),                    Rgb( 255, 0, 255 ) )
   oTreeImageList:AddMasked( TBitmap():Define( "gc_package_16" ),                      Rgb( 255, 0, 255 ) )
   oTreeImageList:AddMasked( TBitmap():Define( "gc_document_text_worker_16" ),             Rgb( 255, 0, 255 ) )
   oTreeImageList:AddMasked( TBitmap():Define( "gc_document_text_delete2_16" ),      Rgb( 255, 0, 255 ) )

   oTreeImageList:AddMasked( TBitmap():Define( "gc_power_drill_sat_user_16" ),            Rgb( 255, 0, 255 ) )

   oTree:SetImageList( oTreeImageList )

   oTreeDocument     := oTree:Add( "Todos los documentos", 0 )

   oTreeCompras      := oTreeDocument:Add( "Compras", 11 )

   oTreeDocument:Add( cTextDocument( MOV_ALM ), 12 )

   oTreeProduccion   := oTreeDocument:Add( "Producción", 13 )

   oTreeVentas       := oTreeDocument:Add( "Ventas", 10 )

      oTreeCompras:Add( cTextDocument( PED_PRV ), 1 )
      oTreeCompras:Add( cTextDocument( ALB_PRV ), 2 )
      oTreeCompras:Add( cTextDocument( FAC_PRV ), 3 )
      oTreeCompras:Add( cTextDocument( RCT_PRV ), 14 )

      oTreeProduccion:Add( cTextDocument( PRO_LIN ), 13 )
      oTreeProduccion:Add( cTextDocument( PRO_MAT ), 13 )

      oTreeVentas:Add( cTextDocument( SAT_CLI ), 15 )
      oTreeVentas:Add( cTextDocument( PRE_CLI ), 4 )
      oTreeVentas:Add( cTextDocument( PED_CLI ), 5 )
      oTreeVentas:Add( cTextDocument( ALB_CLI ), 6 )
      oTreeVentas:Add( cTextDocument( FAC_CLI ), 7 )
      oTreeVentas:Add( cTextDocument( FAC_REC ), 8 )
      oTreeVentas:Add( cTextDocument( TIK_CLI ), 9 )
      oTreeVentas:Add( cTextDocument( DEV_CLI ), 9 )
      oTreeVentas:Add( cTextDocument( VAL_CLI ), 9 )
      oTreeVentas:Add( cTextDocument( APT_CLI ), 9 )

   oTreeDocument:Expand()
   oTreeCompras:Expand()
   oTreeVentas:Expand()
   oTreeProduccion:Expand()

   MENU oMenu

      MENUITEM    "&1. Rotor"

         MENU

         MENUITEM    "&1. Añadir pedido a proveedor";
            MESSAGE  "Añade un pedido a proveedor" ;
            RESOURCE "gc_clipboard_empty_businessman_16";
            ACTION   ( AppPedPrv( "", cCodArt, .f. ), LoadDatos( cCodArt, nYear, oDlg, oBrwStk, oBrwTmp, oGraph, oBrwCom, oBrwVta ) )

            MENUITEM "&2. Añadir albarán de proveedor";
            MESSAGE  "Añade un albarán de proveedor" ;
            RESOURCE "gc_document_empty_businessman_16";
            ACTION   ( AppAlbPrv( "", cCodArt, .f. ), LoadDatos( cCodArt, nYear, oDlg, oBrwStk, oBrwTmp, oGraph, oBrwCom, oBrwVta ) )

            MENUITEM "&3. Añadir factura de proveedor";
            MESSAGE  "Añade una factura de proveedor" ;
            RESOURCE "gc_document_text_businessman_16";
            ACTION   ( AppFacPrv( "", cCodArt, .f. ), LoadDatos( cCodArt, nYear, oDlg, oBrwStk, oBrwTmp, oGraph, oBrwCom, oBrwVta ) )

            SEPARATOR

            MENUITEM "&4. Añadir presupuesto de cliente";
            MESSAGE  "Añade un presupuesto de cliente" ;
            RESOURCE "gc_notebook_user_16";
            ACTION   ( AppPreCli( "", cCodArt, .f. ), LoadDatos( cCodArt, nYear, oDlg, oBrwStk, oBrwTmp, oGraph, oBrwCom, oBrwVta ) )

            MENUITEM "&5. Añadir pedido de cliente";
            MESSAGE  "Añade un pedido de cliente" ;
            RESOURCE "gc_clipboard_empty_user_16";
            ACTION   ( AppPedCli( "", cCodArt, .f. ), LoadDatos( cCodArt, nYear, oDlg, oBrwStk, oBrwTmp, oGraph, oBrwCom, oBrwVta ) )

            MENUITEM "&6. Añadir albarán de cliente";
            MESSAGE  "Añade un albarán de cliente" ;
            RESOURCE "gc_document_empty_16";
            ACTION   ( AppAlbCli( { "Artículo" => cCodArt }, .f. ), LoadDatos( cCodArt, nYear, oDlg, oBrwStk, oBrwTmp, oGraph, oBrwCom, oBrwVta ) )

            MENUITEM "&7. Añadir factura de cliente";
            MESSAGE  "Añade una factura de cliente" ;
            RESOURCE "gc_document_text_user_16";
            ACTION   ( AppFacCli( "", cCodArt, .f. ), LoadDatos( cCodArt, nYear, oDlg, oBrwStk, oBrwTmp, oGraph, oBrwCom, oBrwVta ) )

            MENUITEM "&8. Añadir factura rectificativa de cliente";
            MESSAGE  "Añade una factura rectificativa de cliente" ;
            RESOURCE "gc_document_text_delete2_16";
            ACTION   ( AppFacRec( "", cCodArt, .f. ), LoadDatos( cCodArt, nYear, oDlg, oBrwStk, oBrwTmp, oGraph, oBrwCom, oBrwVta ) )

            MENUITEM "&9. Añadir tiket de cliente";
            MESSAGE  "Añade un tiket de cliente" ;
            RESOURCE "gc_cash_register_user_16";
            ACTION   ( AppTikCli( "", cCodArt, .f. ), LoadDatos( cCodArt, nYear, oDlg, oBrwStk, oBrwTmp, oGraph, oBrwCom, oBrwVta ) )

         ENDMENU

   ENDMENU

   oDlg:SetMenu( oMenu )

Return nil

//---------------------------------------------------------------------------//

Static Function LoadDatos( cCodArt, nYear, oDlg, oBrwStk, oBrwTmp, oGraph, oBrwCom, oBrwVta )

   local n
   local aStk
   local oError
   local oBlock
   local nActStk        := 0
   local nResStk        := 0
   local nEntStk        := 0
   local nStkLib        := 0
   local nTotStkPro     := 0
   local nTotStkCon     := 0

   oDlg:Disable()

   CursorWait()
   
   oBlock               := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   oMeter:Show()
   oMeter:SetTotal( 18 )

   /*
   Calculamos el stock---------------------------------------------------------
   */

   oStock:oTreeStocks( cCodArt )

   if empty( oBrwStk:oTree )
      oBrwStk:SetTree( oStock:oTree, { "gc_navigate_minus_16", "gc_navigate_plus_16", "Nil16" } ) 
   else 
      oBrwStk:oTree     := oStock:oTree
      oBrwStk:oTreeItem := oStock:oTree:oFirst
   end if 

   if Len( oBrwStk:aCols() ) > 0
      oBrwStk:aCols[1]:nWidth    := 500
   end if

   /*
   Calculos de compras---------------------------------------------------------
   */

   oText:SetText( "Calculando compras mensuales" )

   aTotCom[1]           := 0
   aTotCom[2]           := 0
   aTotCom[3]           := 0
   aTotCom[4]           := 0
   aTotCom[5]           := 0

   nCompras( cCodArt, dbfAlbPrvT, dbfAlbPrvL, dbfFacPrvT, dbfFacPrvL, if( nYear == "Todos", nil, Val( nYear ) ) )

   oMeter:AutoInc()

   for n := 1 to 12
      aTotCom[1]        += aCom[n,1]
      aTotCom[2]        += aCom[n,2]
      aTotCom[3]        += aCom[n,3]
   next

   /*
   Calculos producción---------------------------------------------------------
   */

   oText:SetText( "Calculando produccion mensual" )

   nProduccion( cCodArt, dbfProducT, dbfProducL, dbfProducM, if( nYear == "Todos", nil, Val( nYear ) ) )

   oMeter:AutoInc()

   for n := 1 to 12
      nTotStkPro        += aProducido[ n, 2 ]
      nTotStkCon        += aConsumido[ n, 2 ]
   next

   /*
   Calculos de ventas----------------------------------------------------------
   */

   oText:SetText( "Calculando ventas mensuales" )

   aTotVta[1]        := 0
   aTotVta[2]        := 0
   aTotVta[3]        := 0
   aTotVta[4]        := 0
   aTotVta[5]        := 0

   nVentas( cCodArt, dbfAlbCliT, dbfAlbCliL, dbfFacCliT, dbfFacCliL, dbfFacRecT, dbfFacRecL, dbfTikCliT, dbfTikCliL, if( nYear == "Todos", nil, Val( nYear ) ) )

   oMeter:AutoInc()

   for n := 1 to 12

      aTotVta[1]     += aVta[n,1]
      aTotVta[2]     += aVta[n,2]
      aTotVta[3]     += aVta[n,3]
      aTotVta[5]     += aVta[n,4]

   next

   oText:SetText( "Calculando media de compras" )

   if aTotCom[2] != 0
      aTotCom[4]     := aTotCom[3] / aTotCom[2]
   end if

   oMeter:AutoInc()

   oText:SetText( "Calculando media de ventas" )

   if aTotVta[2] != 0
      aTotVta[4]     := aTotVta[3] / aTotVta[2]
   end if

   oMeter:AutoInc()

   oText:SetText( "Calculando rentabilidad" )
   aTotCom[ 5 ]      := ( aTotVta[ 3 ] ) - ( aTotVta[ 2 ] * aTotCom[ 4 ] )

   oMeter:AutoInc()

   /*
   Cargamos los datos en la temporal-------------------------------------------
   */

   oDbfTmp:Zap()

   oText:SetText( "Cargando pedidos a proveedor" )

   LoadPedidoProveedor( cCodArt, if( nYear == "Todos", nil, Val( nYear ) ) )
   oMeter:AutoInc()

   oText:SetText( "Cargando albaranes a proveedor" )

   LoadAlbaranProveedor( cCodArt, if( nYear == "Todos", nil, Val( nYear ) ) )
   oMeter:AutoInc()

   oText:SetText( "Cargando facturas a proveedor" )

   LoadFacturaProveedor( cCodArt, if( nYear == "Todos", nil, Val( nYear ) ) )
   oMeter:AutoInc()

   oText:SetText( "Cargando facturas rectificativas a proveedor" )

   LoadRectificativaProveedor( cCodArt, if( nYear == "Todos", nil, Val( nYear ) ) )
   oMeter:AutoInc()

   oText:SetText( "Cargando SAT a clientes" )

   LoadSATCliente( cCodArt, if( nYear == "Todos", nil, Val( nYear ) ) )
   oMeter:AutoInc()

   oText:SetText( "Cargando presupuestos a clientes" )

   LoadPresupuestoCliente( cCodArt, if( nYear == "Todos", nil, Val( nYear ) ) )
   oMeter:AutoInc()

   oText:SetText( "Cargando pedidos a clientes" )

   LoadPedidosCliente( cCodArt, if( nYear == "Todos", nil, Val( nYear ) ) )
   oMeter:AutoInc()

   oText:SetText( "Cargando albaranes a clientes" )

   LoadAlbaranesCliente( cCodArt, if( nYear == "Todos", nil, Val( nYear ) ) )
   oMeter:AutoInc()

   oText:SetText( "Cargando facturas a clientes" )

   LoadFacturasCliente( cCodArt, if( nYear == "Todos", nil, Val( nYear ) ) )
   oMeter:AutoInc()

   oText:SetText( "Cargando facturas rectificativas a clientes" )

   LoadFacturasRectificativas( cCodArt, if( nYear == "Todos", nil, Val( nYear ) ) )
   oMeter:AutoInc()

   oText:SetText( "Cargando tickets a clientes" )

   LoadTiketsCliente( cCodArt, if( nYear == "Todos", nil, Val( nYear ) ) )
   oMeter:AutoInc()

   oText:SetText( "Cargando movimientos de almacen" )

   LoadMovimientosAlmacen( cCodArt, if( nYear == "Todos", nil, Val( nYear ) ) )
   oMeter:AutoInc()

   oText:SetText( "Cargando producción" )

   LoadProduccion( cCodArt, if( nYear == "Todos", nil, Val( nYear ) ) )
   oMeter:AutoInc()

   oDbfTmp:GoTop()

   oBrwTmp:lFooter   := .f.

   oBrwTmp:Refresh()
   oBrwTmp:RefreshFooters()

   oBrwCom:Refresh()
   oBrwCom:RefreshFooters()

   oBrwVta:Refresh()
   oBrwVta:RefreshFooters()

   /*
   Generamos el grafico--------------------------------------------------------
   */

   oGraph:aSeries    := {}
   oGraph:aData      := {}
   oGraph:aSTemp     := {}
   oGraph:aDTemp     := {}

   oGraph:AddSerie( { aVta[1,3], aVta[2,3], aVta[3,3], aVta[4,3], aVta[5,3], aVta[6,3], aVta[7,3], aVta[8,3], aVta[9,3], aVta[10,3], aVta[11,3], aVta[12,3] }, "Ventas",  Rgb( 253, 186,  40 ) )
   oGraph:AddSerie( { aCom[1,3], aCom[2,3], aCom[3,3], aCom[4,3], aCom[5,3], aCom[6,3], aCom[7,3], aCom[8,3], aCom[9,3], aCom[10,3], aCom[11,3], aCom[12,3] }, "Compras", Rgb(  63, 167, 236 ) )
   oGraph:AddSerie( { aProducido[1,3], aProducido[2,3], aProducido[3,3], aProducido[4,3], aProducido[5,3], aProducido[6,3], aProducido[7,3], aProducido[8,3], aProducido[9,3], aProducido[10,3], aProducido[11,3], aProducido[12,3] }, "Producido", Rgb( 255, 0, 0 ) )
   oGraph:AddSerie( { aConsumido[1,3], aConsumido[2,3], aConsumido[3,3], aConsumido[4,3], aConsumido[5,3], aConsumido[6,3], aConsumido[7,3], aConsumido[8,3], aConsumido[9,3], aConsumido[10,3], aConsumido[11,3], aConsumido[12,3] }, "Consumido", Rgb( 0, 255, 0 ) )
   oGraph:SetYVals( { "Ene", "Feb", "Mar", "Abr", "May", "Jun", "Jul", "Ago", "Sep", "Oct", "Nov", "Dic" } )

   oGraph:cTitle     := "Evolución anual"
   oGraph:lcTitle    := .f.
   oGraph:nClrT      := Rgb( 55, 55, 55)
   oGraph:nClrX      := CLR_BLUE
   oGraph:nClrY      := CLR_RED
   oGraph:cPicture   := cPorDiv + Space( 1 ) + cSimDiv()

   oGraph:Refresh()

   oText:SetText()

   oMeter:Hide()

   RECOVER USING oError
      msgStop( "Imposible cargar datos" + CRLF + ErrorMessage( oError ) )
   END SEQUENCE
   ErrorBlock( oBlock )

   CursorWE()

   oDlg:Enable()

return nil

//---------------------------------------------------------------------------//
/*
Calculamos cajas, unidades e importe de compras del mes
*/

Static function nCompras( cCodArt, dbfAlbPrvT, dbfAlbPrvL, dbfFacPrvT, dbfFacPrvL, nYear )

   local cCodEmp
   local dbfAlbEmpT
   local dbfAlbEmpL
   local dbfFacEmpT
   local dbfFacEmpL
   local dbfRctEmpT
   local dbfRctEmpL

   aEval( aCom, {|a| Afill( a, 0 ) } )

   nTotAlbCom( cCodArt, dbfAlbPrvT, dbfAlbPrvL, nYear )

   nTotFacCom( cCodArt, dbfFacPrvT, dbfFacPrvL, nYear )

   nTotRctCom( cCodArt, dbfRctPrvT, dbfRctPrvL, nYear )

Return ( nil )

//---------------------------------------------------------------------------//
/*Calculamos cajas, unidades e importe de albarán de proveedor del mes*/

static function nTotAlbCom( cCodArt, dbfAlbPrvT, dbfAlbPrvL, nYear )

   local nPos
   local nMes

   if ( dbfAlbPrvL )->( dbSeek( cCodArt ) )

      while ( dbfAlbPrvL )->cRef == cCodArt .and. !( dbfAlbPrvL )->( Eof() )

         if ( dbfAlbPrvT )->( dbSeek( ( dbfAlbPrvL )->cSerAlb + Str( ( dbfAlbPrvL )->nNumAlb ) + ( dbfAlbPrvL )->cSufAlb ) )

            if ( Empty( nYear ) .or. Year( ( dbfAlbPrvT )->dFecAlb ) == nYear ) .and. !( dbfAlbPrvT )->lFacturado

               nMes              := Min( Max( Month( ( dbfAlbPrvT )->dFecAlb ), 1 ), 12 )

               aCom[ nMes, 1 ]   += ( dbfAlbPrvL )->nCanEnt          // Cajas
               aCom[ nMes, 2 ]   += nTotNAlbPrv( dbfAlbPrvL )        // Unidades
               aCom[ nMes, 3 ]   += nImpLAlbPrv( dbfAlbPrvT, dbfAlbPrvL, nDinDiv, nDirDiv )

            end if

         end if

         SysRefresh()

         ( dbfAlbPrvL )->( dbSkip() )

      end do

   end if

Return ( nil )

//---------------------------------------------------------------------------//
/*Calculamos cajas, unidades e importe de factura de proveedor del mes*/

static function nTotFacCom( cCodArt, dbfFacPrvT, dbfFacPrvL, nYear )

   local nPos
   local nMes

   if ( dbfFacPrvL )->( dbSeek( cCodArt ) )

      while ( dbfFacPrvL )->cRef == cCodArt .and. !( dbfFacPrvL )->( Eof() )

         if ( dbfFacPrvT )->( dbSeek( ( dbfFacPrvL )->cSerFac + Str( ( dbfFacPrvL )->nNumFac ) + ( dbfFacPrvL )->cSufFac ) )

            if Empty( nYear ) .or. Year( ( dbfFacPrvT )->dFecFac ) == nYear

               nMes              := Min( Max( Month( ( dbfFacPrvT )->dFecFac ), 1 ), 12 )

               aCom[ nMes, 1 ]   += ( dbfFacPrvL )->nCanEnt          // Cajas
               aCom[ nMes, 2 ]   += nTotNFacPrv( dbfFacPrvL )        // Unidades
               aCom[ nMes, 3 ]   += nImpLFacPrv( dbfFacPrvT, dbfFacPrvL, nDinDiv, nDirDiv )

            end if

         end if

         SysRefresh()

         ( dbfFacPrvL )->( dbSkip() )

      end do

   end if

Return ( nil )

//---------------------------------------------------------------------------//
/*Calculamos cajas, unidades e importe de factura de proveedor del mes*/

static function nTotRctCom( cCodArt, dbfRctPrvT, dbfRctPrvL, nYear )

   local nPos
   local nMes

   if ( dbfRctPrvL )->( dbSeek( cCodArt ) )

      while ( dbfRctPrvL )->cRef == cCodArt .and. !( dbfRctPrvL )->( Eof() )

         if ( dbfRctPrvT )->( dbSeek( ( dbfRctPrvL )->cSerFac + Str( ( dbfRctPrvL )->nNumFac ) + ( dbfRctPrvL )->cSufFac ) )

            if Empty( nYear ) .or. Year( ( dbfRctPrvT )->dFecFac ) == nYear

               nMes              := Min( Max( Month( ( dbfRctPrvT )->dFecFac ), 1 ), 12 )

               aCom[ nMes, 1 ]   += ( dbfRctPrvL )->nCanEnt          // Cajas
               aCom[ nMes, 2 ]   += nTotNRctPrv( dbfRctPrvL )        // Unidades
               aCom[ nMes, 3 ]   += nImpLRctPrv( dbfRctPrvT, dbfRctPrvL, nDinDiv, nDirDiv )

            end if

         end if

         SysRefresh()

         ( dbfRctPrvL )->( dbSkip() )

      end do

   end if

Return ( nil )

//---------------------------------------------------------------------------//

static function nProduccion( cCodArt, dbfProducT, dbfProducL, dbfProducM, nYear )

   local nPos
   local nMes

   local cCodEmp
   local dbfProEmpT
   local dbfProEmpL
   local dbfProEmpM

   aEval( aProducido, {|a| Afill( a, 0 ) } )
   aEval( aConsumido, {|a| Afill( a, 0 ) } )

   if Len( aEmpGrp() ) != 0

      for each cCodEmp in aEmpGrp()

         if cCodEmp == cCodEmp()

            nProducido( cCodArt, dbfProducT, dbfProducL, nYear )
            nConsumido( cCodArt, dbfProducT, dbfProducM, nYear )

         else

            USE ( cPatStk( cCodEmp ) + "PROCAB.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PROCAB", @dbfProEmpT ) )
            SET ADSINDEX TO ( cPatStk( cCodEmp ) + "PROCAB.CDX" ) ADDITIVE

            USE ( cPatStk( cCodEmp ) + "PROLIN.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PROLIN", @dbfProEmpL ) )
            SET ADSINDEX TO ( cPatStk( cCodEmp ) + "PROLIN.CDX" ) ADDITIVE
            SET TAG TO "CCODART"

            USE ( cPatStk( cCodEmp ) + "PROMAT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PROMAT", @dbfProEmpM ) )
            SET ADSINDEX TO ( cPatStk( cCodEmp ) + "PROMAT.CDX" ) ADDITIVE
            SET TAG TO "CCODART"

            nProducido( cCodArt, dbfProEmpT, dbfProEmpL, nYear )
            nConsumido( cCodArt, dbfProEmpT, dbfProEmpM, nYear )

            CLOSE( dbfProEmpT )
            CLOSE( dbfProEmpL )
            CLOSE( dbfProEmpM )

         end if

      next

   end if

return nil

//---------------------------------------------------------------------------//

static function nProducido( cCodArt, dbfProducT, dbfProducL, nYear )

   local nMes
   local nPos

   ( dbfProducT )->( dbGoTop() )
   ( dbfProducL )->( dbGoTop() )

   if ( dbfProducL )->( dbSeek( cCodArt ) )

      while ( dbfProducL )->cCodArt == cCodArt .and. !( dbfProducL )->( Eof() )

         if ( dbfProducT )->( dbSeek( ( dbfProducL )->cSerOrd + Str( ( dbfProducL )->nNumOrd ) + ( dbfProducL )->cSufOrd ) )

            if ( nYear == nil .or. Year( ( dbfProducT )->dFecFin ) == nYear )

               nMes              := Min( Max( Month( ( dbfProducT )->dFecFin ), 1 ), 12 )

               aProducido[ nMes, 1 ]   += ( dbfProducL )->nCajOrd
               aProducido[ nMes, 2 ]   += NotCaja( ( dbfProducL )->nCajOrd ) * ( dbfProducL )->nUndOrd
               aProducido[ nMes, 3 ]   += ( NotCaja( ( dbfProducL )->nCajOrd ) * ( dbfProducL )->nUndOrd ) * ( dbfProducL )->nImpOrd

            end if

         end if

         SysRefresh()

         ( dbfProducL )->( dbSkip() )

      end do

   end if

return nil

//---------------------------------------------------------------------------//

static function nConsumido( cCodArt, dbfProducT, dbfProducM, nYear )

   local nMes
   local nPos

   ( dbfProducT )->( dbGoTop() )
   ( dbfProducM )->( dbGoTop() )

   if dbSeekInOrd( cCodArt, "cCodArt", dbfProducM )

      while ( dbfProducM )->cCodArt == cCodArt .and. !( dbfProducM )->( Eof() )

         if dbSeekInOrd( ( dbfProducM )->cSerOrd + Str( ( dbfProducM )->nNumOrd ) + ( dbfProducM )->cSufOrd, "cNumOrd", dbfProducT )

            if ( nYear == nil .or. Year( ( dbfProducT )->dFecFin ) == nYear )

               nMes              := Min( Max( Month( ( dbfProducT )->dFecFin ), 1 ), 12 )

               aConsumido[ nMes, 1 ]   += ( dbfProducM )->nCajOrd
               aConsumido[ nMes, 2 ]   += NotCaja( ( dbfProducM )->nCajOrd ) * ( dbfProducM )->nUndOrd
               aConsumido[ nMes, 3 ]   += ( NotCaja( ( dbfProducM )->nCajOrd ) * ( dbfProducM )->nUndOrd ) * ( dbfProducM )->nImpOrd

            end if

         end if

         SysRefresh()

         ( dbfProducM )->( dbSkip() )

      end do

   end if

return nil

//---------------------------------------------------------------------------//

/*
Calculamos cajas, unidades e importe de ventas del mes
*/

Static Function nVentas( cCodArt, dbfAlbCliT, dbfAlbCliL, dbfFacCliT, dbfFacCliL, dbfFacRecT, dbfFacRecL, dbfTikCliT, dbfTikCliL, nYear )

   aEval( aVta, {|a| Afill( a, 0 ) } )

   nTotAlbVta( cCodArt, dbfAlbCliT, dbfAlbCliL, nYear )
   nTotFacVta( cCodArt, dbfFacCliT, dbfFacCliL, nYear )
   nTotRecVta( cCodArt, dbfFacRecT, dbfFacRecL, nYear )
   nTotTikVta( cCodArt, dbfTikCliT, dbfTikCliL, nYear )

Return ( nil )

//---------------------------------------------------------------------------//
/*
Calculamos cajas, unidades e importe de albarán de cliente del mes
*/

static function nTotAlbVta( cCodArt, dbfAlbCliT, dbfAlbCliL, nYear )

   local nPos
   local nMes

   if ( dbfAlbCliL )->( dbSeek( cCodArt ) )

      while ( dbfAlbCliL )->cRef == cCodArt .and. !( dbfAlbCliL )->( Eof() )

         if ( dbfAlbCliT )->( dbSeek( ( dbfAlbCliL )->cSerAlb + Str( ( dbfAlbCliL )->nNumAlb ) + ( dbfAlbCliL )->cSufAlb ) )

            if !lFacturado( dbfAlbCliT ) .and. ( nYear == nil .or. Year( ( dbfAlbCliT )->dFecAlb ) == nYear )

               nMes              := Min( Max( Month( ( dbfAlbCliT )->dFecAlb ), 1 ), 12 )

               aVta[ nMes, 1 ]   += ( dbfAlbCliL )->nCanEnt
               aVta[ nMes, 2 ]   += nTotVAlbCli( dbfAlbCliL )
               aVta[ nMes, 3 ]   += nImpLAlbCli( dbfAlbCliT, dbfAlbCliL, nDouDiv, nDorDiv )
               aVta[ nMes, 4 ]   += nImpLAlbCli( dbfAlbCliT, dbfAlbCliL, nDouDiv, nDorDiv ) - ( nTotNAlbCli( dbfAlbCliL ) * ( dbfAlbCliL )->nCosDiv )

            end if

         end if

         SysRefresh()

         ( dbfAlbCliL )->( dbSkip() )

      end do

   end if

Return ( nil )

//---------------------------------------------------------------------------//
/*
Calculamos cajas, unidades e importe de factura de cliente del mes
*/

static function nTotFacVta( cCodArt, dbfFacCliT, dbfFacCliL, nYear )

   local nPos
   local nMes
   local pruebas  := 0

   ( dbfFacCliL )->( dbGoTop() )

   if ( dbfFacCliL )->( dbSeek( cCodArt ) )

      while ( dbfFacCliL )->cRef == cCodArt .and. !( dbfFacCliL )->( Eof() )

         if ( dbfFacCliT )->( dbSeek( ( dbfFacCliL )->cSerie + Str( ( dbfFacCliL )->nNumFac ) + ( dbfFacCliL )->cSufFac ) )

            if ( nYear == nil .or. Year( ( dbfFacCliT )->dFecFac ) == nYear ) .and. ( dbfFacCliL )->nCtlStk < 2

               nMes              := Min( Max( Month( ( dbfFacCliT )->dFecFac ), 1 ), 12 )

               aVta[ nMes, 1 ]   += ( dbfFacCliL )->nCanEnt
               aVta[ nMes, 2 ]   += nTotVFacCli( dbfFacCliL )
               aVta[ nMes, 3 ]   += nImpLFacCli( dbfFacCliT, dbfFacCliL, nDouDiv, nDorDiv )
               aVta[ nMes, 4 ]   += nImpLFacCli( dbfFacCliT, dbfFacCliL, nDouDiv, nDorDiv ) - ( nTotNFacCli( dbfFacCliL ) * ( dbfFacCliL )->nCosDiv )

            end if

         end if

         SysRefresh()

         ( dbfFacCliL )->( dbSkip() )

      end do

   end if

Return ( nil )

//---------------------------------------------------------------------------//
/*Calculamos cajas, unidades e importe de factura rectificativa de cliente del mes*/

static function nTotRecVta( cCodArt, dbfFacRecT, dbfFacRecL, nYear )

   local nPos
   local nMes

   if ( dbfFacRecL )->( dbSeek( cCodArt ) )

      while ( dbfFacRecL )->cRef == cCodArt .and. !( dbfFacRecL )->( Eof() )

         if ( dbfFacRecT )->( dbSeek( ( dbfFacRecL )->cSerie + Str( ( dbfFacRecL )->nNumFac ) + ( dbfFacRecL )->cSufFac ) )

            if ( nYear == nil .or. Year( ( dbfFacRecT )->dFecFac ) == nYear )

               nMes              := Min( Max( Month( ( dbfFacRecT )->dFecFac ), 1 ), 12 )

               aVta[ nMes, 1 ]   += ( dbfFacRecL )->nCanEnt
               aVta[ nMes, 2 ]   += nTotVFacRec( dbfFacRecL )
               aVta[ nMes, 3 ]   += nImpLFacRec( dbfFacRecT, dbfFacRecL, nDouDiv, nDorDiv )
               aVta[ nMes, 4 ]   += nImpLFacRec( dbfFacRecT, dbfFacRecL, nDouDiv, nDorDiv ) - ( nTotNFacRec( dbfFacRecL ) * ( dbfFacRecL )->nCosDiv )

            end if

         end if

         SysRefresh()

         ( dbfFacRecL )->( dbSkip() )

      end do

   end if

Return ( nil )

//---------------------------------------------------------------------------//
/*Calculamos cajas, unidades e importe de tikets de cliente del mes*/

static function nTotTikVta( cCodArt, dbfTikCliT, dbfTikCliL, nYear )

   local nPos
   local nMes

   /*
   Tikets no combinados
   */

   if ( dbfTikCliL )->( dbSeek( cCodArt ) )

      while ( dbfTikCliL )->cCbaTil == cCodArt .and. !( dbfTikCliL )->( Eof() )

         if ( dbfTikCliT )->( dbSeek( ( dbfTikCliL )->cSerTil + ( dbfTikCliL )->cNumTil + ( dbfTikCliL )->cSufTil ) )

            if ( nYear == nil .or. Year( ( dbfTikCliT )->dFecTik ) == nYear )

               nMes  := Min( Max( Month( ( dbfTikCliT )->dFecTik ), 1 ), 12 )

               if ( dbfTikCliL )->cTipTil == SAVTIK .or. ( dbfTikCliL )->cTipTil == SAVAPT

                  aVta[ nMes, 2 ]   += ( dbfTikCliL )->nUntTil
                  aVta[ nMes, 3 ]   += nImpLTpv( dbfTikCliT, dbfTikCliL, nDouDiv, nDorDiv )
                  aVta[ nMes, 4 ]   += nImpLTpv( dbfTikCliT, dbfTikCliL, nDouDiv, nDorDiv ) - ( ( dbfTikCliL )->nUntTil * ( dbfTikCliL )->nCosDiv )

               end if

               if ( dbfTikCliL )->cTipTil == SAVDEV .or. ( dbfTikCliL )->cTipTil == SAVVAL

                  aVta[ nMes, 2 ]   -= ( dbfTikCliL )->nUntTil
                  aVta[ nMes, 3 ]   -= nImpLTpv( dbfTikCliT, dbfTikCliL, nDouDiv, nDorDiv )

               end if

            end if

         end if

         SysRefresh()

         ( dbfTikCliL )->( dbSkip() )

      end do

   end if

   /*
   Tikets combinados
   */

   ( dbfTikCliL )->( ordSetFocus( "cComTil" ) )

   if ( dbfTikCliL )->( dbSeek( cCodArt ) )

      while ( dbfTikCliL )->cComTil == cCodArt .and. !( dbfTikCliL )->( Eof() )

         if ( dbfTikCliT )->( dbSeek( ( dbfTikCliL )->cSerTil + ( dbfTikCliL )->cNumTil + ( dbfTikCliL )->cSufTil ) )

            if ( nYear == nil .or. Year( ( dbfTikCliT )->dFecTik ) == nYear )

               nMes  := Min( Max( Month( ( dbfTikCliT )->dFecTik ), 1 ), 12 )

               aVta[ nMes, 2 ]   += ( dbfTikCliL )->nUntTil
               aVta[ nMes, 3 ]   += nImpLTpv( dbfTikCliT, dbfTikCliL, nDouDiv, nDorDiv )

            end if

         end if

         SysRefresh()

         ( dbfTikCliL )->( dbSkip() )

      end do

   end if

   ( dbfTikCliL )->( ordSetFocus( "cCbaTil" ) )

Return ( nil )

//---------------------------------------------------------------------------//
/*Carga los pedidos a proveedor*/

Static Function LoadPedidoProveedor( cCodArt, nYear )

   local aEstadoPedido  := { "Pendiente", "Parcialmente", "Recibido" }

   if ( dbfPedPrvL )->( dbSeek( cCodArt ) )
      while ( dbfPedPrvL )->cRef == cCodArt .and. !( dbfPedPrvL )->( eof() )

         if Empty( nYear ) .or. Year( dFecPedPrv( ( dbfPedPrvL )->cSerPed + Str( ( dbfPedPrvL )->nNumPed ) + ( dbfPedPrvL )->cSufPed, dbfPedPrvT ) ) == nYear

            oDbfTmp:Append()
            oDbfTmp:nTypDoc   := PED_PRV
            oDbfTmp:cNumDoc   := ( dbfPedPrvL )->cSerPed + Str( ( dbfPedPrvL )->nNumPed ) + ( dbfPedPrvL )->cSufPed
            oDbfTmp:cSufDoc   := ( dbfPedPrvL )->cSufPed
            oDbfTmp:cEstDoc   := aEstadoPedido[ Max( RetFld( ( dbfPedPrvL )->cSerPed + Str( ( dbfPedPrvL )->nNumPed ) + ( dbfPedPrvL )->cSufPed, dbfPedPrvT, "nEstado" ), 1 ) ]
            oDbfTmp:dFecDoc   := dFecPedPrv( ( dbfPedPrvL )->cSerPed + Str( ( dbfPedPrvL )->nNumPed ) + ( dbfPedPrvL )->cSufPed, dbfPedPrvT )
            oDbfTmp:tFecDoc   := ""
            oDbfTmp:cCodDoc   := RetFld( ( dbfPedPrvL )->cSerPed + Str( ( dbfPedPrvL )->nNumPed ) + ( dbfPedPrvL )->cSufPed, dbfPedPrvT, "cCodPrv" )
            oDbfTmp:cNomDoc   := cNbrPedPrv( ( dbfPedPrvL )->cSerPed + Str( ( dbfPedPrvL )->nNumPed ) + ( dbfPedPrvL )->cSufPed, dbfPedPrvT )
            oDbfTmp:cRef      := ( dbfPedPrvL )->cRef
            oDbfTmp:cCodPr1   := ( dbfPedPrvL )->cCodPr1
            oDbfTmp:cCodPr2   := ( dbfPedPrvL )->cCodPr2
            oDbfTmp:cValPr1   := ( dbfPedPrvL )->cValPr1
            oDbfTmp:cValPr2   := ( dbfPedPrvL )->cValPr2
            oDbfTmp:cLote     := ( dbfPedPrvL )->cLote
            oDbfTmp:cAlmDoc   := ( dbfPedPrvL )->cAlmLin
            oDbfTmp:nUndDoc   := nTotNPedPrv( dbfPedPrvL )
            oDbfTmp:nFacCnv   := ( dbfPedPrvL )->nFacCnv
            oDbfTmp:nImpDoc   := nTotUPedPrv( dbfPedPrvL, nDinDiv )
            oDbfTmp:nDtoDoc   := ( dbfPedPrvL )->nDtoLin
            oDbfTmp:nTotDoc   := nTotLPedPrv( dbfPedPrvL )
            oDbfTmp:Save()

         end if

         SysRefresh()
         ( dbfPedPrvL )->( dbSkip() )

      end while
   end if

Return nil

//---------------------------------------------------------------------------//
/*
Carga los albaranes de proveedor
*/

Static Function LoadAlbaranProveedor( cCodArt, nYear )

   if ( dbfAlbPrvL )->( dbSeek( cCodArt ) )
      while ( dbfAlbPrvL )->cRef == cCodArt .and. !( dbfAlbPrvL )->( eof() )

         if nYear == nil .or. Year( dFecAlbPrv( ( dbfAlbPrvL )->cSerAlb + Str( ( dbfAlbPrvL )->nNumAlb ) + ( dbfAlbPrvL )->cSufAlb, dbfAlbPrvT ) ) == nYear

            oDbfTmp:Append()
            oDbfTmp:nTypDoc   := ALB_PRV
            oDbfTmp:cNumDoc   := ( dbfAlbPrvL )->cSerAlb + Str( ( dbfAlbPrvL )->nNumAlb ) + ( dbfAlbPrvL )->cSufAlb
            oDbfTmp:cSufDoc   := ( dbfAlbPrvL )->cSufAlb
            oDbfTmp:cEstDoc   := if( RetFld( ( dbfAlbPrvL )->cSerAlb + Str( ( dbfAlbPrvL )->nNumAlb ) + ( dbfAlbPrvL )->cSufAlb, dbfAlbPrvT, "lFacturado" ), "Facturado", "No facturado" )
            oDbfTmp:dFecDoc   := dFecAlbPrv( ( dbfAlbPrvL )->cSerAlb + Str( ( dbfAlbPrvL )->nNumAlb ) + ( dbfAlbPrvL )->cSufAlb, dbfAlbPrvT )
            oDbfTmp:tFecDoc   := tFecAlbPrv( ( dbfAlbPrvL )->cSerAlb + Str( ( dbfAlbPrvL )->nNumAlb ) + ( dbfAlbPrvL )->cSufAlb, dbfAlbPrvT )
            oDbfTmp:cCodDoc   := RetFld( ( dbfAlbPrvL )->cSerAlb + Str( ( dbfAlbPrvL )->nNumAlb ) + ( dbfAlbPrvL )->cSufAlb, dbfAlbPrvT, "cCodPrv" )
            oDbfTmp:cNomDoc   := cNbrAlbPrv( ( dbfAlbPrvL )->cSerAlb + Str( ( dbfAlbPrvL )->nNumAlb ) + ( dbfAlbPrvL )->cSufAlb, dbfAlbPrvT )
            oDbfTmp:lFacturado:= RetFld( ( dbfAlbPrvL )->cSerAlb + Str( ( dbfAlbPrvL )->nNumAlb ) + ( dbfAlbPrvL )->cSufAlb, dbfAlbPrvT, "lFacturado" )
            oDbfTmp:cRef      := ( dbfAlbPrvL )->cRef
            oDbfTmp:cCodPr1   := ( dbfAlbPrvL )->cCodPr1
            oDbfTmp:cCodPr2   := ( dbfAlbPrvL )->cCodPr2
            oDbfTmp:cValPr1   := ( dbfAlbPrvL )->cValPr1
            oDbfTmp:cValPr2   := ( dbfAlbPrvL )->cValPr2
            oDbfTmp:cLote     := ( dbfAlbPrvL )->cLote
            oDbfTmp:cAlmDoc   := ( dbfAlbPrvL )->cAlmLin
            oDbfTmp:cAlmOrg   := ( dbfAlbPrvL )->cAlmOrigen
            oDbfTmp:nUndDoc   := nTotNAlbPrv( dbfAlbPrvL )
            oDbfTmp:nFacCnv   := ( dbfAlbPrvL )->nFacCnv
            oDbfTmp:nImpDoc   := nTotUAlbPrv( dbfAlbPrvL, nDinDiv )
            oDbfTmp:nDtoDoc   := ( dbfAlbPrvL )->nDtoLin
            oDbfTmp:nTotDoc   := nTotLAlbPrv( dbfAlbPrvL )
            oDbfTmp:Save()

         end if

         SysRefresh()
         ( dbfAlbPrvL )->( dbSkip() )

      end while
   end if

Return nil

//---------------------------------------------------------------------------//
/*Carga las facturas de proveedor*/

Static Function LoadFacturaProveedor( cCodArt, nYear )

   local aEstadoFactura    := { "Pagada", "Parcialmente", "Pendiente" }

   if ( dbfFacPrvL )->( dbSeek( cCodArt ) )
      while ( dbfFacPrvL )->cRef == cCodArt .and. !( dbfFacPrvL )->( eof() )

         if nYear == nil .or. Year( dFecFacPrv( ( dbfFacPrvL )->cSerFac + Str( ( dbfFacPrvL )->nNumFac ) + ( dbfFacPrvL )->cSufFac, dbfFacPrvT ) ) == nYear

            oDbfTmp:Append()
            oDbfTmp:nTypDoc   := FAC_PRV
            oDbfTmp:cNumDoc   := ( dbfFacPrvL )->cSerFac + Str( ( dbfFacPrvL )->nNumFac ) + ( dbfFacPrvL )->cSufFac
            oDbfTmp:cSufDoc   := ( dbfFacPrvL )->cSufFac
            oDbfTmp:cEstDoc   := aEstadoFactura[ nEstFacPrv( ( dbfFacPrvL )->cSerFac + Str( ( dbfFacPrvL )->nNumFac ) + ( dbfFacPrvL )->cSufFac, dbfFacPrvT, dbfFacPrvP ) ]
            oDbfTmp:dFecDoc   := dFecFacPrv( ( dbfFacPrvL )->cSerFac + Str( ( dbfFacPrvL )->nNumFac ) + ( dbfFacPrvL )->cSufFac, dbfFacPrvT )
            oDbfTmp:tFecDoc   := tFecFacPrv( ( dbfFacPrvL )->cSerFac + Str( ( dbfFacPrvL )->nNumFac ) + ( dbfFacPrvL )->cSufFac, dbfFacPrvT )
            oDbfTmp:cCodDoc   := RetFld( ( dbfFacPrvL )->cSerFac + Str( ( dbfFacPrvL )->nNumFac ) + ( dbfFacPrvL )->cSufFac, dbfFacPrvT, "cCodPrv" )
            oDbfTmp:cNomDoc   := cNbrFacPrv( ( dbfFacPrvL )->cSerFac + Str( ( dbfFacPrvL )->nNumFac ) + ( dbfFacPrvL )->cSufFac, dbfFacPrvT )
            oDbfTmp:lFacturado:= .f.
            oDbfTmp:cRef      := ( dbfFacPrvL )->cRef
            oDbfTmp:cCodPr1   := ( dbfFacPrvL )->cCodPr1
            oDbfTmp:cCodPr2   := ( dbfFacPrvL )->cCodPr2
            oDbfTmp:cValPr1   := ( dbfFacPrvL )->cValPr1
            oDbfTmp:cValPr2   := ( dbfFacPrvL )->cValPr2
            oDbfTmp:cLote     := ( dbfFacPrvL )->cLote
            oDbfTmp:cAlmDoc   := ( dbfFacPrvL )->cAlmLin
            oDbfTmp:cAlmOrg   := ( dbfFacPrvL )->cAlmOrigen
            oDbfTmp:nUndDoc   := nTotNFacPrv( dbfFacPrvL )
            oDbfTmp:nFacCnv   := ( dbfFacPrvL )->nFacCnv
            oDbfTmp:nImpDoc   := nTotUFacPrv( dbfFacPrvL, nDinDiv )
            oDbfTmp:nDtoDoc   := ( dbfFacPrvL )->nDtoLin
            oDbfTmp:nTotDoc   := nTotLFacPrv( dbfFacPrvL )
            oDbfTmp:Save()

         end if

         SysRefresh()
         ( dbfFacPrvL )->( dbSkip() )

      end while
   end if

Return nil

//---------------------------------------------------------------------------//

Static Function LoadRectificativaProveedor( cCodArt, nYear )

   local aEstadoFactura    := { "Pagada", "Parcialmente", "Pendiente" }

   if ( dbfRctPrvL )->( dbSeek( cCodArt ) )
      
      while ( dbfRctPrvL )->cRef == cCodArt .and. !( dbfRctPrvL )->( eof() )

         if nYear == nil .or. Year( dFecRctPrv( ( dbfRctPrvL )->cSerFac + Str( ( dbfRctPrvL )->nNumFac ) + ( dbfRctPrvL )->cSufFac, dbfRctPrvT ) ) == nYear

            oDbfTmp:Append()
            oDbfTmp:nTypDoc   := RCT_PRV
            oDbfTmp:cNumDoc   := ( dbfRctPrvL )->cSerFac + Str( ( dbfRctPrvL )->nNumFac ) + ( dbfRctPrvL )->cSufFac
            oDbfTmp:cSufDoc   := ( dbfRctPrvL )->cSufFac
            oDbfTmp:cEstDoc   := aEstadoFactura[ nEstRctPrv( ( dbfRctPrvL )->cSerFac + Str( ( dbfRctPrvL )->nNumFac ) + ( dbfRctPrvL )->cSufFac, dbfRctPrvT, dbfFacPrvP ) ]
            oDbfTmp:dFecDoc   := dFecRctPrv( ( dbfRctPrvL )->cSerFac + Str( ( dbfRctPrvL )->nNumFac ) + ( dbfRctPrvL )->cSufFac, dbfRctPrvT )
            oDbfTmp:tFecDoc   := tFecRctPrv( ( dbfRctPrvL )->cSerFac + Str( ( dbfRctPrvL )->nNumFac ) + ( dbfRctPrvL )->cSufFac, dbfRctPrvT )
            oDbfTmp:cCodDoc   := RetFld( ( dbfRctPrvL )->cSerFac + Str( ( dbfRctPrvL )->nNumFac ) + ( dbfRctPrvL )->cSufFac, dbfRctPrvT, "cCodPrv" )
            oDbfTmp:cNomDoc   := cNbrRctPrv( ( dbfRctPrvL )->cSerFac + Str( ( dbfRctPrvL )->nNumFac ) + ( dbfRctPrvL )->cSufFac, dbfRctPrvT )
            oDbfTmp:lFacturado:= .f.
            oDbfTmp:cRef      := ( dbfRctPrvL )->cRef
            oDbfTmp:cCodPr1   := ( dbfRctPrvL )->cCodPr1
            oDbfTmp:cValPr1   := ( dbfRctPrvL )->cValPr1
            oDbfTmp:cValPr2   := ( dbfRctPrvL )->cValPr2
            oDbfTmp:cLote     := ( dbfRctPrvL )->cLote
            oDbfTmp:cAlmDoc   := ( dbfRctPrvL )->cAlmLin
            oDbfTmp:cAlmOrg   := ( dbfRctPrvL )->cAlmOrigen
            oDbfTmp:nUndDoc   := nTotNRctPrv( dbfRctPrvL )
            oDbfTmp:nFacCnv   := ( dbfRctPrvL )->nFacCnv
            oDbfTmp:nImpDoc   := nTotURctPrv( dbfRctPrvL, nDinDiv )
            oDbfTmp:nDtoDoc   := ( dbfRctPrvL )->nDtoLin
            oDbfTmp:nTotDoc   := nTotLRctPrv( dbfRctPrvL )
            oDbfTmp:Save()

         end if

         SysRefresh()
         ( dbfRctPrvL )->( dbSkip() )

      end while
   end if

Return nil

//---------------------------------------------------------------------------//
/*
Carga los SAT de clientes a la temporal
*/

Static Function LoadSATCliente( cCodArt, nYear )

   if ( dbfSatCliL )->( dbSeek( cCodArt ) )
      while ( dbfSatCliL )->cRef == cCodArt .and. !( dbfSatCliL )->( eof() )

         if nYear == nil .or. Year( dFecSatCli( ( dbfSatCliL )->cSerSat + Str( ( dbfSatCliL )->nNumSat ) + ( dbfSatCliL )->cSufSat, dbfSatCliT ) ) == nYear

            oDbfTmp:Append() 
            oDbfTmp:nTypDoc   := SAT_CLI
            oDbfTmp:cNumDoc   := ( dbfSatCliL )->cSerSat + Str( ( dbfSatCliL )->nNumSat ) + ( dbfSatCliL )->cSufSat
            oDbfTmp:cSufDoc   := ( dbfSatCliL )->cSufSat
            oDbfTmp:cEstDoc   := if( RetFld( ( dbfSatCliL )->cSerSat + Str( ( dbfSatCliL )->nNumSat ) + ( dbfSatCliL )->cSufSat, dbfSatCliT, "lEstado" ), "Aprobado", "Pendiente" )
            oDbfTmp:dFecDoc   := dFecSatCli( ( dbfSatCliL )->cSerSat + Str( ( dbfSatCliL )->nNumSat ) + ( dbfSatCliL )->cSufSat, dbfSatCliT )
            oDbfTmp:tFecDoc   := ""
            oDbfTmp:cCodDoc   := RetFld( ( dbfSatCliL )->cSerSat + Str( ( dbfSatCliL )->nNumSat ) + ( dbfSatCliL )->cSufSat, dbfSatCliT, "cCodCli" )
            oDbfTmp:cNomDoc   := RetFld( ( dbfSatCliL )->cSerSat + Str( ( dbfSatCliL )->nNumSat ) + ( dbfSatCliL )->cSufSat, dbfSatCliT, "cNomCli" )
            oDbfTmp:cRef      := ( dbfSatCliL )->cRef
            oDbfTmp:cCodPr1   := ( dbfSatCliL )->cCodPr1
            oDbfTmp:cCodPr2   := ( dbfSatCliL )->cCodPr2
            oDbfTmp:cValPr1   := ( dbfSatCliL )->cValPr1
            oDbfTmp:cValPr2   := ( dbfSatCliL )->cValPr2
            oDbfTmp:cLote     := ( dbfSatCliL )->cLote
            oDbfTmp:cAlmDoc   := ( dbfSatCliL )->cAlmLin
            oDbfTmp:nUndDoc   := nTotNSatCli( dbfSatCliL )
            oDbfTmp:nFacCnv   := ( dbfSatCliL )->nFacCnv
            oDbfTmp:nImpDoc   := nTotUSatCli( dbfSatCliL, nDouDiv )
            oDbfTmp:nDtoDoc   := ( dbfSatCliL )->nDto
            oDbfTmp:nTotDoc   := nTotLSatCli( dbfSatCliL )
            oDbfTmp:Save()

         end if

         SysRefresh()

         ( dbfSatCliL )->( dbSkip() )

      end while
   end if

Return nil

//---------------------------------------------------------------------------//
/*
Carga los SAT de clientes a la temporal
*/

Static Function LoadPresupuestoCliente( cCodArt, nYear )

   if ( dbfPreCliL )->( dbSeek( cCodArt ) )
      while ( dbfPreCliL )->cRef == cCodArt .and. !( dbfPreCliL )->( eof() )

         if nYear == nil .or. Year( dFecPreCli( ( dbfPreCliL )->cSerPre + Str( ( dbfPreCliL )->nNumPre ) + ( dbfPreCliL )->cSufPre, dbfPreCliT ) ) == nYear

            oDbfTmp:Append() 
            oDbfTmp:nTypDoc   := PRE_CLI
            oDbfTmp:cNumDoc   := ( dbfPreCliL )->cSerPre + Str( ( dbfPreCliL )->nNumPre ) + ( dbfPreCliL )->cSufPre
            oDbfTmp:cSufDoc   := ( dbfPreCliL )->cSufPre
            oDbfTmp:cEstDoc   := if( RetFld( ( dbfPreCliL )->cSerPre + Str( ( dbfPreCliL )->nNumPre ) + ( dbfPreCliL )->cSufPre, dbfPreCliT, "lEstado" ), "Aprobado", "Pendiente" )
            oDbfTmp:dFecDoc   := dFecPreCli( ( dbfPreCliL )->cSerPre + Str( ( dbfPreCliL )->nNumPre ) + ( dbfPreCliL )->cSufPre, dbfPreCliT )
            oDbfTmp:tFecDoc   := ""
            oDbfTmp:cCodDoc   := RetFld( ( dbfPreCliL )->cSerPre + Str( ( dbfPreCliL )->nNumPre ) + ( dbfPreCliL )->cSufPre, dbfPreCliT, "cCodCli" )
            oDbfTmp:cNomDoc   := RetFld( ( dbfPreCliL )->cSerPre + Str( ( dbfPreCliL )->nNumPre ) + ( dbfPreCliL )->cSufPre, dbfPreCliT, "cNomCli" )
            oDbfTmp:cRef      := ( dbfPreCliL )->cRef
            oDbfTmp:cCodPr1   := ( dbfPreCliL )->cCodPr1
            oDbfTmp:cCodPr2   := ( dbfPreCliL )->cCodPr2
            oDbfTmp:cValPr1   := ( dbfPreCliL )->cValPr1
            oDbfTmp:cValPr2   := ( dbfPreCliL )->cValPr2
            oDbfTmp:cLote     := ( dbfPreCliL )->cLote
            oDbfTmp:cAlmDoc   := ( dbfPreCliL )->cAlmLin
            oDbfTmp:nUndDoc   := nTotNPreCli( dbfPreCliL )
            oDbfTmp:nFacCnv   := ( dbfPreCliL )->nFacCnv
            oDbfTmp:nImpDoc   := nTotUPreCli( dbfPreCliL, nDouDiv )
            oDbfTmp:nDtoDoc   := ( dbfPreCliL )->nDto
            oDbfTmp:nTotDoc   := nTotLPreCli( dbfPreCliL )
            oDbfTmp:Save()

         end if

         SysRefresh()

         ( dbfPreCliL )->( dbSkip() )

      end while
   end if

Return nil

//---------------------------------------------------------------------------//
/*
Carga los pedidos de clientes a la temporal
*/

Static Function LoadPedidosCliente( cCodArt, nYear )

   local aEstadoPedido  := { "Pendiente", "Parcialmente", "Entregado" }

   if ( dbfPedCliL )->( dbSeek( cCodArt ) )
      while ( dbfPedCliL )->cRef == cCodArt .and. !( dbfPedCliL )->( eof() )

         if nYear == nil .or. Year( dFecPedCli( ( dbfPedCliL )->cSerPed + Str( ( dbfPedCliL )->nNumPed ) + ( dbfPedCliL )->cSufPed, dbfPedCliT ) ) == nYear

            oDbfTmp:Append()
            oDbfTmp:nTypDoc   := PED_CLI
            oDbfTmp:cNumDoc   := ( dbfPedCliL )->cSerPed + Str( ( dbfPedCliL )->nNumPed ) + ( dbfPedCliL )->cSufPed
            oDbfTmp:cSufDoc   := ( dbfPedCliL )->cSufPed

            if retFld( ( dbfPedCliL )->cSerPed + Str( ( dbfPedCliL )->nNumPed ) + ( dbfPedCliL )->cSufPed, dbfPedCliT, "lCancel" )
            oDbfTmp:cEstDoc   := "Cancelado"
            else
            oDbfTmp:cEstDoc   := aEstadoPedido[ Max( RetFld( ( dbfPedCliL )->cSerPed + Str( ( dbfPedCliL )->nNumPed ) + ( dbfPedCliL )->cSufPed, dbfPedCliT, "nEstado" ), 1 ) ]
            end if 

            oDbfTmp:dFecDoc   := dFecPedCli( ( dbfPedCliL )->cSerPed + Str( ( dbfPedCliL )->nNumPed ) + ( dbfPedCliL )->cSufPed, dbfPedCliT )
            oDbfTmp:tFecDoc   := ""
            oDbfTmp:cCodDoc   := RetFld( ( dbfPedCliL )->cSerPed + Str( ( dbfPedCliL )->nNumPed ) + ( dbfPedCliL )->cSufPed, dbfPedCliT, "cCodCli" )
            oDbfTmp:cNomDoc   := cNbrPedCli( ( dbfPedCliL )->cSerPed + Str( ( dbfPedCliL )->nNumPed ) + ( dbfPedCliL )->cSufPed, dbfPedCliT )
            oDbfTmp:cRef      := ( dbfPedCliL )->cRef
            oDbfTmp:cCodPr1   := ( dbfPedCliL )->cCodPr1
            oDbfTmp:cCodPr2   := ( dbfPedCliL )->cCodPr2
            oDbfTmp:cValPr1   := ( dbfPedCliL )->cValPr1
            oDbfTmp:cValPr2   := ( dbfPedCliL )->cValPr2
            oDbfTmp:cLote     := ( dbfPedCliL )->cLote
            oDbfTmp:cAlmDoc   := ( dbfPedCliL )->cAlmLin
            oDbfTmp:nUndDoc   := nTotNPedCli( dbfPedCliL )
            oDbfTmp:nFacCnv   := ( dbfPedCliL )->nFacCnv
            oDbfTmp:nImpDoc   := nTotUPedCli( dbfPedCliL, nDouDiv )
            oDbfTmp:nDtoDoc   := ( dbfPedCliL )->nDto
            oDbfTmp:nTotDoc   := nTotLPedCli( dbfPedCliL )
            oDbfTmp:Save()

         end if

         SysRefresh()

         ( dbfPedCliL )->( dbSkip() )

      end while
   end if

Return nil

//---------------------------------------------------------------------------//
/*Carga los albaranes de clientes a la temporal*/

Static Function LoadAlbaranesCliente( cCodArt, nYear )

   if ( dbfAlbCliL )->( dbSeek( cCodArt ) )
      while ( dbfAlbCliL )->cRef == cCodArt .and. !( dbfAlbCliL )->( eof() )

         if nYear == nil .or. Year( dFecAlbCli( ( dbfAlbCliL )->cSerAlb + Str( ( dbfAlbCliL )->nNumAlb ) + ( dbfAlbCliL )->cSufAlb, dbfAlbCliT ) ) == nYear

            oDbfTmp:Append()
            oDbfTmp:nTypDoc   := ALB_CLI
            oDbfTmp:cNumDoc   := ( dbfAlbCliL )->cSerAlb + Str( ( dbfAlbCliL )->nNumAlb ) + ( dbfAlbCliL )->cSufAlb
            oDbfTmp:cSufDoc   := ( dbfAlbCliL )->cSufAlb
            oDbfTmp:cEstDoc   := if( RetFld( ( dbfAlbCliL )->cSerAlb + Str( ( dbfAlbCliL )->nNumAlb ) + ( dbfAlbCliL )->cSufAlb, dbfAlbCliT, "lFacturado" ), "Facturado", "No facturado" )
            oDbfTmp:dFecDoc   := dFecAlbCli( ( dbfAlbCliL )->cSerAlb + Str( ( dbfAlbCliL )->nNumAlb ) + ( dbfAlbCliL )->cSufAlb, dbfAlbCliT )
            oDbfTmp:tFecDoc   := tFecAlbCli( ( dbfAlbCliL )->cSerAlb + Str( ( dbfAlbCliL )->nNumAlb ) + ( dbfAlbCliL )->cSufAlb, dbfAlbCliT )
            oDbfTmp:cCodDoc   := RetFld( ( dbfAlbCliL )->cSerAlb + Str( ( dbfAlbCliL )->nNumAlb ) + ( dbfAlbCliL )->cSufAlb, dbfAlbCliT, "cCodCli" )
            oDbfTmp:cNomDoc   := RetFld( ( dbfAlbCliL )->cSerAlb + Str( ( dbfAlbCliL )->nNumAlb ) + ( dbfAlbCliL )->cSufAlb, dbfAlbCliT, "cNomCli" )
            oDbfTmp:lFacturado:= RetFld( ( dbfAlbCliL )->cSerAlb + Str( ( dbfAlbCliL )->nNumAlb ) + ( dbfAlbCliL )->cSufAlb, dbfAlbCliT, "lFacturado" )
            oDbfTmp:cRef      := ( dbfAlbCliL )->cRef
            oDbfTmp:cCodPr1   := ( dbfAlbCliL )->cCodPr1
            oDbfTmp:cCodPr2   := ( dbfAlbCliL )->cCodPr2
            oDbfTmp:cValPr1   := ( dbfAlbCliL )->cValPr1
            oDbfTmp:cValPr2   := ( dbfAlbCliL )->cValPr2
            oDbfTmp:cLote     := ( dbfAlbCliL )->cLote
            oDbfTmp:cAlmDoc   := ( dbfAlbCliL )->cAlmLin
            oDbfTmp:nUndDoc   := nTotNAlbCli( dbfAlbCliL )
            oDbfTmp:nFacCnv   := ( dbfAlbCliL )->nFacCnv
            oDbfTmp:nImpDoc   := nTotUAlbCli( dbfAlbCliL, nDouDiv )
            oDbfTmp:nDtoDoc   := ( dbfAlbCliL )->nDto
            oDbfTmp:nTotDoc   := nTotLAlbCli( dbfAlbCliL )
            oDbfTmp:Save()

         end if

         SysRefresh()

         ( dbfAlbCliL )->( dbSkip() )

      end while
   end if

Return nil

//---------------------------------------------------------------------------//
/*Carga las facturas de clientes a la temporal*/

Static Function LoadFacturasCliente( cCodArt, nYear )

   local aEstadoFactura    := { "Cobrada", "Parcialmente", "Pendiente" }

   if ( dbfFacCliL )->( dbSeek( cCodArt ) )
      while ( dbfFacCliL )->cRef == cCodArt .and. !( dbfFacCliL )->( eof() )

         if nYear == nil .or. Year( dFecFacCli( ( dbfFacCliL )->cSerie + Str( ( dbfFacCliL )->nNumFac ) + ( dbfFacCliL )->cSufFac, dbfFacCliT ) ) == nYear

            oDbfTmp:Append()
            oDbfTmp:nTypDoc   := FAC_CLI
            oDbfTmp:cNumDoc   := ( dbfFacCliL )->cSerie + Str( ( dbfFacCliL )->nNumFac ) + ( dbfFacCliL )->cSufFac
            oDbfTmp:cSufDoc   := ( dbfFacCliL )->cSufFac
            oDbfTmp:cEstDoc   := aEstadoFactura[ nChkPagFacCli( ( dbfFacCliL )->cSerie + Str( ( dbfFacCliL )->nNumFac ) + ( dbfFacCliL )->cSufFac, dbfFacCliT, dbfFacCliP ) ]
            oDbfTmp:dFecDoc   := dFecFacCli( ( dbfFacCliL )->cSerie + Str( ( dbfFacCliL )->nNumFac ) + ( dbfFacCliL )->cSufFac, dbfFacCliT )
            oDbfTmp:tFecDoc   := tFecFacCli( ( dbfFacCliL )->cSerie + Str( ( dbfFacCliL )->nNumFac ) + ( dbfFacCliL )->cSufFac, dbfFacCliT )
            oDbfTmp:cCodDoc   := RetFld( ( dbfFacCliL )->cSerie + Str( ( dbfFacCliL )->nNumFac ) + ( dbfFacCliL )->cSufFac, dbfFacCliT, "cCodCli" )
            oDbfTmp:cNomDoc   := RetFld( ( dbfFacCliL )->cSerie + Str( ( dbfFacCliL )->nNumFac ) + ( dbfFacCliL )->cSufFac, dbfFacCliT, "cNomCli" )
            oDbfTmp:lFacturado:= .f.
            oDbfTmp:cRef      := ( dbfFacCliL )->cRef
            oDbfTmp:cCodPr1   := ( dbfFacCliL )->cCodPr1
            oDbfTmp:cCodPr2   := ( dbfFacCliL )->cCodPr2
            oDbfTmp:cValPr1   := ( dbfFacCliL )->cValPr1
            oDbfTmp:cValPr2   := ( dbfFacCliL )->cValPr2
            oDbfTmp:cLote     := ( dbfFacCliL )->cLote
            oDbfTmp:cAlmDoc   := ( dbfFacCliL )->cAlmLin
            oDbfTmp:nFacCnv   := ( dbfFacCliL )->nFacCnv
            oDbfTmp:nDtoDoc   := ( dbfFacCliL )->nDto
            oDbfTmp:nUndDoc   := nTotNFacCli( dbfFacCliL )
            oDbfTmp:nImpDoc   := nImpUFacCli( dbfFacCliT, dbfFacCliL, nDouDiv )
            oDbfTmp:nTotDoc   := nTotLFacCli( dbfFacCliL )
            oDbfTmp:Save()

         end if

         SysRefresh()

         ( dbfFacCliL )->( dbSkip() )

      end while
   end if

Return nil

//---------------------------------------------------------------------------//
/*Carga las facturas rectificativas de clientes a la temporal*/

Static Function LoadFacturasRectificativas( cCodArt, nYear )

   if ( dbfFacRecL )->( dbSeek( cCodArt ) )
      while ( dbfFacRecL )->cRef == cCodArt .and. !( dbfFacRecL )->( eof() )

         if nYear == nil .or. Year( dFecFacRec( ( dbfFacRecL )->cSerie + Str( ( dbfFacRecL )->nNumFac ) + ( dbfFacRecL )->cSufFac, dbfFacRecT ) ) == nYear

            oDbfTmp:Append()
            oDbfTmp:nTypDoc   := FAC_REC
            oDbfTmp:cNumDoc   := ( dbfFacRecL )->cSerie + Str( ( dbfFacRecL )->nNumFac ) + ( dbfFacRecL )->cSufFac
            oDbfTmp:cSufDoc   := ( dbfFacRecL )->cSufFac
            oDbfTmp:cEstDoc   := ""
            //msgStop(dFecFacRec( ( dbfFacRecL )->cSerie + Str( ( dbfFacRecL )->nNumFac ) + ( dbfFacRecL )->cSufFac, dbfFacRecT ), "LoadFacRec date")
            //msgStop(tFecFacRec( ( dbfFacRecL )->cSerie + Str( ( dbfFacRecL )->nNumFac ) + ( dbfFacRecL )->cSufFac, dbfFacRecT ), "LoadFacRec time")
            oDbfTmp:dFecDoc   := dFecFacRec( ( dbfFacRecL )->cSerie + Str( ( dbfFacRecL )->nNumFac ) + ( dbfFacRecL )->cSufFac, dbfFacRecT )
            oDbfTmp:tFecDoc   := tFecFacRec( ( dbfFacRecL )->cSerie + Str( ( dbfFacRecL )->nNumFac ) + ( dbfFacRecL )->cSufFac, dbfFacRecT )
            oDbfTmp:cCodDoc   := RetFld( ( dbfFacRecL )->cSerie + Str( ( dbfFacRecL )->nNumFac ) + ( dbfFacRecL )->cSufFac, dbfFacRecT, "cCodCli" )
            oDbfTmp:cNomDoc   := cNbrFacRec( ( dbfFacRecL )->cSerie + Str( ( dbfFacRecL )->nNumFac ) + ( dbfFacRecL )->cSufFac, dbfFacRecT )
            oDbfTmp:cRef      := ( dbfFacRecL )->cRef
            oDbfTmp:cCodPr1   := ( dbfFacRecL )->cCodPr1
            oDbfTmp:cCodPr2   := ( dbfFacRecL )->cCodPr2
            oDbfTmp:cValPr1   := ( dbfFacRecL )->cValPr1
            oDbfTmp:cValPr2   := ( dbfFacRecL )->cValPr2
            oDbfTmp:cLote     := ( dbfFacRecL )->cLote
            oDbfTmp:cAlmDoc   := ( dbfFacRecL )->cAlmLin
            oDbfTmp:nUndDoc   := nTotNFacRec( dbfFacRecL )
            oDbfTmp:nFacCnv   := ( dbfFacRecL )->nFacCnv
            oDbfTmp:nImpDoc   := nImpUFacRec( dbfFacRecT, dbfFacRecL, nDouDiv )
            oDbfTmp:nDtoDoc   := ( dbfFacRecL )->nDto
            oDbfTmp:nTotDoc   := nTotLFacRec( dbfFacRecL )
            oDbfTmp:Save()

         end if

         SysRefresh()

         ( dbfFacRecL )->( dbSkip() )

      end while
   end if

Return nil

//---------------------------------------------------------------------------//
/*
Carga los tikets de clientes a la temporal
*/

Static Function LoadTiketsCliente( cCodArt, nYear )

   local cTipTik

   if ( dbfTikCliL )->( dbSeek( cCodArt ) )
      while ( dbfTikCliL )->cCbaTil == cCodArt .and. !( dbfTikCliL )->( eof() )

         if nYear == nil .or. Year( dFecTik( (dbfTikCliL)->cSerTil + (dbfTikCliL)->cNumTil + (dbfTikCliL)->cSufTil, dbfTikCliT ) ) == nYear

            cTipTik                    := cTipTik( ( dbfTikCliL )->cSerTil + ( dbfTikCliL )->cNumTil + ( dbfTikCliL )->cSufTil, dbfTikCliT )

            if ( cTipTik == SAVTIK .or. cTipTik == SAVDEV .or. cTipTik == SAVAPT .or. cTipTik == SAVVAL )

               oDbfTmp:Append()

               do case
               case( dbfTikCliT )->cTipTik == SAVTIK

                  oDbfTmp:nTypDoc      := TIK_CLI
                  oDbfTmp:cEstDoc      := if( ( dbfTikCliT )->lPgdTik, "Cobrado", "No cobrado" )
                  oDbfTmp:nUndDoc      := nTotNTikTpv( dbfTikCliL )
                  oDbfTmp:nFacCnv      := ( dbfTikCliL )->nFacCnv

               case ( dbfTikCliT )->cTipTik == SAVDEV

                  oDbfTmp:nTypDoc      := DEV_CLI
                  oDbfTmp:cEstDoc      := "Devolución"
                  oDbfTmp:nUndDoc      := nTotNTikTpv( dbfTikCliL )
                  oDbfTmp:nFacCnv      := ( dbfTikCliL )->nFacCnv

               case ( dbfTikCliT )->cTipTik == SAVVAL

                  oDbfTmp:nTypDoc      := VAL_CLI
                  oDbfTmp:cEstDoc      := if( ( dbfTikCliT )->lLiqTik, "Vale liquidado", "Vale pdte. liquidar" )
                  oDbfTmp:nUndDoc      := nTotNTikTpv( dbfTikCliL )
                  oDbfTmp:nFacCnv      := ( dbfTikCliL )->nFacCnv

               case ( dbfTikCliT )->cTipTik == SAVAPT

                  oDbfTmp:nTypDoc      := APT_CLI
                  oDbfTmp:cEstDoc      := "Apartado"
                  oDbfTmp:nUndDoc      := nTotNTikTpv( dbfTikCliL )
                  oDbfTmp:nFacCnv      := ( dbfTikCliL )->nFacCnv

               end case

               oDbfTmp:cNumDoc         := ( dbfTikCliL )->cSerTil + ( dbfTikCliL )->cNumTil + ( dbfTikCliL )->cSufTil
               oDbfTmp:cSufDoc         := ( dbfTikCliL )->cSufTil
               oDbfTmp:dFecDoc         := dFecTik( (dbfTikCliL)->cSerTil + (dbfTikCliL)->cNumTil + (dbfTikCliL)->cSufTil, dbfTikCliT )
               oDbfTmp:tFecDoc         := tFecTik( (dbfTikCliL)->cSerTil + (dbfTikCliL)->cNumTil + (dbfTikCliL)->cSufTil, dbfTikCliT )
               oDbfTmp:cCodDoc         := RetFld( ( dbfTikCliL )->cSerTil + ( dbfTikCliL )->cNumTil + ( dbfTikCliL )->cSufTil, dbfTikCliT, "cCliTik" )
               oDbfTmp:cNomDoc         := RetFld( ( dbfTikCliL )->cSerTil + ( dbfTikCliL )->cNumTil + ( dbfTikCliL )->cSufTil, dbfTikCliT, "cNomTik" )
               oDbfTmp:cRef            := ( dbfTikCliL )->cCbaTil
               oDbfTmp:cCodPr1         := ( dbfTikCliL )->cCodPr1
               oDbfTmp:cCodPr2         := ( dbfTikCliL )->cCodPr2
               oDbfTmp:cValPr1         := ( dbfTikCliL )->cValPr1
               oDbfTmp:cValPr2         := ( dbfTikCliL )->cValPr2
               oDbfTmp:cLote           := ( dbfTikCliL )->cLote
               oDbfTmp:cAlmDoc         := ( dbfTikCliL )->cAlmLin
               oDbfTmp:nDtoDoc         := ( dbfTikCliL )->nDtoLin
               oDbfTmp:nImpDoc         := nImpUTpv( dbfTikCliT, dbfTikCliL, nDouDiv )
               oDbfTmp:nTotDoc         := oDbfTmp:nUndDoc * oDbfTmp:nImpDoc

               oDbfTmp:Save()

            end if

         end if

         SysRefresh()

         ( dbfTikCliL )->( dbSkip() )

      end while
   end if

   ( dbfTikCliL )->( OrdSetFocus( "cComTil" ) )

   if ( dbfTikCliL )->( dbSeek( cCodArt ) )
      while ( dbfTikCliL )->cComTil == cCodArt .and. !( dbfTikCliL )->( eof() )

         if nYear == nil .or. Year( dFecTik( (dbfTikCliL)->cSerTil + (dbfTikCliL)->cNumTil + (dbfTikCliL)->cSufTil, dbfTikCliT ) ) == nYear

            cTipTik  := cTipTik( ( dbfTikCliL )->cSerTil + ( dbfTikCliL )->cNumTil + ( dbfTikCliL )->cSufTil, dbfTikCliT )

            if cTipTik == SAVTIK .or. cTipTik == SAVDEV .or. cTipTik == SAVAPT .or. cTipTik == SAVVAL

               oDbfTmp:Append()

               if ( dbfTikCliT )->cTipTik == SAVTIK
                  oDbfTmp:nTypDoc   := TIK_CLI
               elseif ( dbfTikCliT )->cTipTik == SAVDEV
                  oDbfTmp:nTypDoc   := DEV_CLI
               end if

               oDbfTmp:cNumDoc      := ( dbfTikCliL )->cSerTil + ( dbfTikCliL )->cNumTil + ( dbfTikCliL )->cSufTil
               oDbfTmp:cSufDoc      := ( dbfTikCliL )->cSufTil
               oDbfTmp:cEstDoc      := ""
               oDbfTmp:dFecDoc      := dFecTik( (dbfTikCliL)->cSerTil + (dbfTikCliL)->cNumTil + (dbfTikCliL)->cSufTil, dbfTikCliT )
               oDbfTmp:tFecDoc      := tFecTik( (dbfTikCliL)->cSerTil + (dbfTikCliL)->cNumTil + (dbfTikCliL)->cSufTil, dbfTikCliT )
               oDbfTmp:cCodDoc      := RetFld( ( dbfTikCliL )->cSerTil + ( dbfTikCliL )->cNumTil + ( dbfTikCliL )->cSufTil, dbfTikCliT, "cCliTik" )
               oDbfTmp:cNomDoc      := RetFld( ( dbfTikCliL )->cSerTil + ( dbfTikCliL )->cNumTil + ( dbfTikCliL )->cSufTil, dbfTikCliT, "cNomTik" )
               oDbfTmp:cRef         := ( dbfTikCliL )->cComTil
               oDbfTmp:cCodPr1      := ( dbfTikCliL )->cCodPr1
               oDbfTmp:cCodPr2      := ( dbfTikCliL )->cCodPr2
               oDbfTmp:cValPr1      := ( dbfTikCliL )->cValPr1
               oDbfTmp:cValPr2      := ( dbfTikCliL )->cValPr2
               oDbfTmp:cLote        := ( dbfTikCliL )->cLote
               oDbfTmp:cAlmDoc      := ( dbfTikCliL )->cAlmLin
               oDbfTmp:nUndDoc      := nTotNTikTpv( dbfTikCliL )
               oDbfTmp:nFacCnv      := ( dbfTikCliL )->nFacCnv
               oDbfTmp:nImpDoc      := ( dbfTikCliL )->nPcmTil
               oDbfTmp:nDtoDoc      := ( dbfTikCliL )->nDtoLin
               oDbfTmp:nTotDoc      := oDbfTmp:nUndDoc * oDbfTmp:nImpDoc
               oDbfTmp:Save()

            end if

         end if

         SysRefresh()

         ( dbfTikCliL )->( dbSkip() )

      end while
   end if

   ( dbfTikCliL )->( OrdSetFocus( "cCbaTil" ) )

Return nil

//---------------------------------------------------------------------------//
/*
Cargamos los movimientos de almacén a la temporal
*/

Static Function LoadMovimientosAlmacen( cCodArt, nYear )

   local oRowSet  := MovimientosAlmacenLineasRepository();
                        :getRowSetMovimientosForArticulo( { "codigo_articulo" => cCodArt,;
                                                            "year" => nYear } )

   oRowSet:goTop()

   while !( oRowSet:Eof() )

      oDbfTmp:Append()
      oDbfTmp:nTypDoc   := MOV_ALM
      oDbfTmp:cNumDoc   := AllTrim( oRowSet:fieldget( 'numero' ) )
      oDbfTmp:cSufDoc   := oRowSet:fieldget( 'delegacion' )
      oDbfTmp:cEstDoc   := "Movimiento"
      oDbfTmp:dFecDoc   := oRowSet:fieldget( 'fecha' )
      oDbfTmp:tFecDoc   := StrTran( oRowSet:fieldget( 'hora' ), ":", "" )
      oDbfTmp:cNomDoc   := oRowSet:fieldget( 'nombre_movimiento' )
      oDbfTmp:cRef      := oRowSet:fieldget( 'codigo_articulo' )
      oDbfTmp:cCodPr1   := oRowSet:fieldget( 'codigo_primera_propiedad' )
      oDbfTmp:cCodPr2   := oRowSet:fieldget( 'codigo_segunda_propiedad' )
      oDbfTmp:cValPr1   := oRowSet:fieldget( 'valor_primera_propiedad' )
      oDbfTmp:cValPr2   := oRowSet:fieldget( 'valor_segunda_propiedad' )
      oDbfTmp:cLote     := oRowSet:fieldget( 'lote' )
      oDbfTmp:cAlmDoc   := oRowSet:fieldget( 'almacen_destino' )
      oDbfTmp:cAlmOrg   := oRowSet:fieldget( 'almacen_origen' )
      oDbfTmp:nUndDoc   := oRowSet:fieldget( 'total_unidades' )
      oDbfTmp:nImpDoc   := oRowSet:fieldget( 'precio_articulo' )
      oDbfTmp:nTotDoc   := oDbfTmp:nUndDoc * oDbfTmp:nImpDoc
      oDbfTmp:nDtoDoc   := 0
      oDbfTmp:nIdSql    := oRowSet:fieldget( 'id' )
      oDbfTmp:Save()

      oRowSet:skip()

   end while

Return nil

//---------------------------------------------------------------------------//

Static Function LoadProduccion( cCodArt, nYear )

   /*
   Materiales producidos-------------------------------------------------------
   */

   ( dbfProducT )->( dbGoTop() )

   if ( dbfProducL )->( dbSeek( cCodArt ) )

      while ( dbfProducL )->cCodArt == cCodArt .and. !( dbfProducL )->( eof() )

         if dbSeekInOrd( ( dbfProducL )->cSerOrd + Str( ( dbfProducL )->nNumOrd ) + ( dbfProducL )->cSufOrd, "cNumOrd", dbfProducT )

            if nYear == nil .or. Year( ( dbfProducT )->dFecFin ) == nYear

               oDbfTmp:Append()
               oDbfTmp:nTypDoc   := PRO_LIN
               oDbfTmp:cNumDoc   := ( dbfProducL )->cSerOrd + Str( ( dbfProducL )->nNumOrd ) + ( dbfProducL )->cSufOrd
               oDbfTmp:cSufDoc   := ( dbfProducL )->cSufOrd
               oDbfTmp:cEstDoc   := Space(1)
               oDbfTmp:dFecDoc   := ( dbfProducT )->dFecOrd
               oDbfTmp:tFecDoc   := ( dbfProducT )->cHorIni
               oDbfTmp:cNomDoc   := "Material"
               oDbfTmp:cRef      := ( dbfProducL )->cCodArt
               oDbfTmp:cCodPr1   := ( dbfProducL )->cCodPr1
               oDbfTmp:cCodPr2   := ( dbfProducL )->cCodPr2
               oDbfTmp:cValPr1   := ( dbfProducL )->cValPr1
               oDbfTmp:cValPr2   := ( dbfProducL )->cValPr2
               oDbfTmp:cLote     := ( dbfProducL )->cLote
               oDbfTmp:cAlmDoc   := ( dbfProducL )->cAlmOrd
               oDbfTmp:nUndDoc   := NotCaja( ( dbfProducL )->nCajOrd ) * ( dbfProducL )->nUndOrd
               oDbfTmp:nImpDoc   := ( dbfProducL )->nImpOrd
               oDbfTmp:nTotDoc   := oDbfTmp:nUndDoc * oDbfTmp:nImpDoc
               oDbfTmp:Save()

            end if

         end if

         SysRefresh()

         ( dbfProducL )->( dbSkip() )

      end while

   end if

   /*
   Materias primas-------------------------------------------------------------
   */

   ( dbfProducT )->( dbGoTop() )

   if ( dbfProducM )->( dbSeek( cCodArt ) )

      while ( dbfProducM )->cCodArt == cCodArt .and. !( dbfProducM )->( eof() )

         if dbSeekInOrd( ( dbfProducM )->cSerOrd + Str( ( dbfProducM )->nNumOrd ) + ( dbfProducM )->cSufOrd, "cNumOrd", dbfProducT )

            if nYear == nil .or. Year( ( dbfProducT )->dFecFin ) == nYear

               oDbfTmp:Append()
               oDbfTmp:nTypDoc   := PRO_MAT
               oDbfTmp:cNumDoc   := ( dbfProducM )->cSerOrd + Str( ( dbfProducM )->nNumOrd ) + ( dbfProducM )->cSufOrd
               oDbfTmp:cSufDoc   := ( dbfProducM )->cSufOrd
               oDbfTmp:cEstDoc   := Space(1)
               oDbfTmp:dFecDoc   := ( dbfProducT )->dFecOrd
               oDbfTmp:tFecDoc   := ( dbfProducT )->cHorIni
               oDbfTmp:cNomDoc   := "Materias primas"
               oDbfTmp:cRef      := ( dbfProducM )->cCodArt
               oDbfTmp:cCodPr1   := ( dbfProducM )->cCodPr1
               oDbfTmp:cCodPr2   := ( dbfProducM )->cCodPr2
               oDbfTmp:cValPr1   := ( dbfProducM )->cValPr1
               oDbfTmp:cValPr2   := ( dbfProducM )->cValPr2
               oDbfTmp:cLote     := ( dbfProducM )->cLote
               oDbfTmp:cAlmDoc   := ( dbfProducM )->cAlmOrd
               oDbfTmp:nUndDoc   := NotCaja( ( dbfProducM )->nCajOrd ) * ( dbfProducM )->nUndOrd
               oDbfTmp:nImpDoc   := ( dbfProducM )->nImpOrd
               oDbfTmp:nTotDoc   := oDbfTmp:nUndDoc * oDbfTmp:nImpDoc
               oDbfTmp:Save()

            end if

         end if

         SysRefresh()

         ( dbfProducM )->( dbSkip() )

      end while

   end if

Return nil

//---------------------------------------------------------------------------//

static function nReservado( cCodArt, dbfPedCliT, dbfPedCliR, dbfAlbCliT, dbfAlbCliL, nYear )

   local nReservado  := 0
   local cCodEmp
   local dbfPedEmpT
   local dbfPedEmpR
   local dbfAlbEmpT
   local dbfAlbEmpL

   if Len( aEmpGrp() ) != 0

      for each cCodEmp in aEmpGrp()

         if cCodEmp == cCodEmp()

            nReservado    += nTotRStk( cCodArt, dbfPedCliT, dbfPedCliR, dbfAlbCliT, dbfAlbCliL, nYear )

         else

            USE ( cPatStk( cCodEmp ) + "PEDCLIT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PEDCLIT", @dbfPedEmpT ) )
            SET ADSINDEX TO ( cPatStk( cCodEmp ) + "PEDCLIT.CDX" ) ADDITIVE

            USE ( cPatStk( cCodEmp ) + "PEDCLIR.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PEDCLIR", @dbfPedEmpR ) )
            SET ADSINDEX TO ( cPatStk( cCodEmp ) + "PEDCLIR.CDX" ) ADDITIVE
            SET TAG TO "CREF"

            USE ( cPatStk( cCodEmp ) + "ALBCLIT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ALBCLIT", @dbfAlbEmpT ) )
            SET ADSINDEX TO ( cPatStk( cCodEmp ) + "ALBCLIT.CDX" ) ADDITIVE

            USE ( cPatStk( cCodEmp ) + "ALBCLIL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ALBCLIL", @dbfAlbEmpL ) )
            SET ADSINDEX TO ( cPatStk( cCodEmp ) + "ALBCLIL.CDX" ) ADDITIVE
            SET TAG TO "CREF"

            nReservado    += nTotRStk( cCodArt, dbfPedEmpT, dbfPedEmpR, dbfAlbEmpT, dbfAlbEmpL, nYear )

            CLOSE( dbfPedEmpT )
            CLOSE( dbfPedEmpR )
            CLOSE( dbfAlbEmpT )
            CLOSE( dbfAlbEmpL )

         end if

      next

   end if

return nReservado

//---------------------------------------------------------------------------//
/*
Calcula el stock reservado
*/

function nTotRStk( cCodArt, dbfPedCliT, dbfPedCliR, dbfAlbCliT, dbfAlbCliL, nYear )

   local nTotRStk    := 0
   local nOrdAnt     := ( dbfPedCliR )->( OrdSetFocus( "cRef" ) )

   if ( dbfPedCliR )->( dbSeek( cCodArt ) )
      
      while cCodArt == ( dbfPedCliR )->cRef .and. !( dbfPedCliR )->( Eof() )

         if nYear == nil .or. Year( ( dbfPedCliR )->dFecRes ) == nYear
            nTotRStk += nTotNResCli( dbfPedCliR ) * NotCero( ( dbfAlbCliL )->nFacCnv )
         end if

         ( dbfPedCliR )->( dbSkip() )

      end while

   end if

   ( dbfPedCliR )->( OrdSetFocus( nOrdAnt ) )

return ( nTotRStk )

//---------------------------------------------------------------------------//

static function nEntregado( cCodArt, dbfPedCliT, dbfPedCliR, dbfAlbCliT, dbfAlbCliL, nYear )

   local nEntregado  := 0
   local cCodEmp
   local dbfPedEmpT
   local dbfPedEmpR
   local dbfAlbEmpT
   local dbfAlbEmpL

   if Len( aEmpGrp() ) != 0

      for each cCodEmp in aEmpGrp()

         if cCodEmp == cCodEmp()

            nEntregado    += nTotEStk( cCodArt, dbfPedCliT, dbfPedCliR, dbfAlbCliT, dbfAlbCliL, nYear )

         else

            USE ( cPatStk( cCodEmp ) + "PEDCLIT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PEDCLIT", @dbfPedEmpT ) )
            SET ADSINDEX TO ( cPatStk( cCodEmp ) + "PEDCLIT.CDX" ) ADDITIVE

            USE ( cPatStk( cCodEmp ) + "PEDCLIR.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PEDCLIR", @dbfPedEmpR ) )
            SET ADSINDEX TO ( cPatStk( cCodEmp ) + "PEDCLIR.CDX" ) ADDITIVE
            SET TAG TO "CREF"

            USE ( cPatStk( cCodEmp ) + "ALBCLIT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ALBCLIT", @dbfAlbEmpT ) )
            SET ADSINDEX TO ( cPatStk( cCodEmp ) + "ALBCLIT.CDX" ) ADDITIVE

            USE ( cPatStk( cCodEmp ) + "ALBCLIL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ALBCLIL", @dbfAlbEmpL ) )
            SET ADSINDEX TO ( cPatStk( cCodEmp ) + "ALBCLIL.CDX" ) ADDITIVE
            SET TAG TO "CREF"

            nEntregado    += nTotEStk( cCodArt, dbfPedCliT, dbfPedCliR, dbfAlbCliT, dbfAlbCliL, nYear )

            CLOSE( dbfPedEmpT )
            CLOSE( dbfPedEmpR )
            CLOSE( dbfAlbEmpT )
            CLOSE( dbfAlbEmpL )

         end if

      next

   end if

return nEntregado

//---------------------------------------------------------------------------//
/*
Calcula el stock entregado
*/

Function nTotEStk( cCodArt, dbfPedCliT, dbfPedCliR, dbfAlbCliT, dbfAlbCliL, nYear )

   local dFecRes  := ctod( "" )
   local aNumPed  := {}
   local nTotRes  := 0
   local nTotAlb  := 0
   local nTotEnt  := 0
   local nOrdAnt  := ( dbfPedCliR )->( OrdSetFocus( "cRef" ) )

   if ( dbfPedCliR )->( dbSeek( cCodArt ) )

      while cCodArt == ( dbfPedCliR )->cRef .and. !( dbfPedCliR )->( Eof() )

         if nYear == nil .or. Year( ( dbfPedCliR )->dFecRes ) == nYear

            if aScan( aNumPed, {|cNumPed| cNumPed == ( dbfPedCliR )->cSerPed + Str( ( dbfPedCliR )->nNumPed ) + ( dbfPedCliR )->cSufPed } ) == 0

               aAdd( aNumPed, ( dbfPedCliR )->cSerPed + Str( ( dbfPedCliR )->nNumPed ) + ( dbfPedCliR )->cSufPed )
            
               dFecRes  := ( dbfPedCliR )->dFecRes
               nTotRes  := nUnidadesReservadasEnPedidosCliente( ( dbfPedCliR )->cSerPed + Str( ( dbfPedCliR )->nNumPed ) + ( dbfPedCliR )->cSufPed, ( dbfPedCliR )->cRef, space( 20 ), space( 20 ), dbfPedCliR )
               nTotAlb  := nUnidadesRecibidasAlbaranesClientes( ( dbfPedCliR )->cSerPed + Str( ( dbfPedCliR )->nNumPed ) + ( dbfPedCliR )->cSufPed, ( dbfPedCliR )->cRef, space( 20 ), space( 20 ), dbfAlbCliL )
               nTotEnt  += Min( nTotRes, nTotAlb )
            
            end if

         end if

         SysRefresh()
         ( dbfPedCliR )->( dbSkip() )

      end while

   end if

   ( dbfPedCliR )->( OrdSetFocus( nOrdAnt ) )

return ( nTotEnt )

//---------------------------------------------------------------------------//
/*Pone las mascaras al número de los documentos*/

Function cMaskNumDoc( oDbfTmp )

   do case
   case oDbfTmp:nTypDoc == TIK_CLI .or. oDbfTmp:nTypDoc == DEV_CLI .or. oDbfTmp:nTypDoc == VAL_CLI
      return ( Left( oDbfTmp:cNumDoc, 1 ) + "/" + Alltrim( SubStr( oDbfTmp:cNumDoc, 2, 10 ) ) )
   
   case oDbfTmp:nTypDoc == MOV_ALM
      if Val( oDbfTmp:cNumDoc ) == 0
         return ""
      else
         return ( Alltrim( Left( oDbfTmp:cNumDoc, 9 ) ) )
      end if
   
   case oDbfTmp:nTypDoc == ENT_PED .or. oDbfTmp:nTypDoc == ENT_ALB .or. oDbfTmp:nTypDoc == REC_CLI .or. oDbfTmp:nTypDoc == REC_PRV
      return ( Left( oDbfTmp:cNumDoc, 1 ) + "/" + Alltrim( SubStr( oDbfTmp:cNumDoc, 2, 9 ) ) + "-" + Alltrim( Str( oDbfTmp:nNumRec ) ) )
   
   end case

return ( Left( oDbfTmp:cNumDoc, 1 ) + "/" + Alltrim( SubStr( oDbfTmp:cNumDoc, 2, 9 ) ) )

//---------------------------------------------------------------------------//

/*
Al movernos por el arbol cambiamos el orden de la temporal y le hacemos un scope
*/

Static Function TreeChanged( oTree, oBrwTmp )

   local cText             := oTree:GetSelText()
   local cFilter

   do case
      case cText == "Compras"
         cFilter           := "( nTypDoc >= '" + PED_PRV + "' .and. nTypDoc <= '" + FAC_PRV + "' ) .or. nTypDoc == '" + RCT_PRV + "'"
         oBrwTmp:lFooter   := .f.

      case cText == "Movimientos"
         cFilter           := "nTypDoc == '" + MOV_ALM + "'"
         oBrwTmp:lFooter   := .f.

      case cText == "Ventas"
         cFilter           := "( nTypDoc == '" + SAT_CLI + "' ) .or. ( nTypDoc >= '" + PRE_CLI + "' .and. nTypDoc <= '" + REC_CLI + "' )"
         oBrwTmp:lFooter   := .f.

      case cText == "Producción"
         cFilter           := "( nTypDoc == '" + PRO_LIN + "' .or. nTypDoc == '" + PRO_MAT + "' )"
         oBrwTmp:lFooter   := .f.

      case cText == cTextDocument( PED_PRV )
         cFilter           := "( nTypDoc == '" + PED_PRV + "' )"
         oBrwTmp:lFooter   := .t.

      case cText == cTextDocument( ALB_PRV )
         cFilter           := "( nTypDoc == '" + ALB_PRV + "' )"
         oBrwTmp:lFooter   := .t.

      case cText == cTextDocument( FAC_PRV )
         cFilter           := "( nTypDoc == '" + FAC_PRV + "' )"
         oBrwTmp:lFooter   := .t.

      case cText == cTextDocument( RCT_PRV )
         cFilter           := "( nTypDoc == '" + RCT_PRV + "' )"
         oBrwTmp:lFooter   := .t.

      case cText == cTextDocument( SAT_CLI )
         cFilter           := "( nTypDoc == '" + SAT_CLI + "' )"
         oBrwTmp:lFooter   := .t.

      case cText == cTextDocument( PRE_CLI )
         cFilter           := "( nTypDoc == '" + PRE_CLI + "' )"
         oBrwTmp:lFooter   := .t.

      case cText == cTextDocument( PED_CLI )
         cFilter           := "( nTypDoc == '" + PED_CLI + "' )"
         oBrwTmp:lFooter   := .t.

      case cText == cTextDocument( ALB_CLI )
         cFilter           := "( nTypDoc == '" + ALB_CLI + "' )"
         oBrwTmp:lFooter   := .t.

      case cText == cTextDocument( FAC_CLI )
         cFilter           := "( nTypDoc == '" + FAC_CLI + "' )"
         oBrwTmp:lFooter   := .t.

      case cText == cTextDocument( FAC_REC )
         cFilter           := "( nTypDoc == '" + FAC_REC + "' )"
         oBrwTmp:lFooter   := .t.

      case cText == cTextDocument( TIK_CLI )
         cFilter           := "( nTypDoc == '" + TIK_CLI + "' )"
         oBrwTmp:lFooter   := .t.

      case cText == cTextDocument( DEV_CLI )
         cFilter           := "( nTypDoc == '" + DEV_CLI + "' )"
         oBrwTmp:lFooter   := .t.

      case cText == cTextDocument( MOV_ALM )
         cFilter           := "( nTypDoc == '" + MOV_ALM + "' )"
         oBrwTmp:lFooter   := .t.

      case cText == cTextDocument( VAL_CLI )
         cFilter           := "( nTypDoc == '" + VAL_CLI + "' )"
         oBrwTmp:lFooter   := .t.

      case cText == cTextDocument( APT_CLI )
         cFilter           := "( nTypDoc == '" + APT_CLI + "' )"
         oBrwTmp:lFooter   := .t.

      case cText == cTextDocument( PRO_LIN )
         cFilter           := "( nTypDoc == '" + PRO_LIN + "' )"
         oBrwTmp:lFooter   := .t.

      case cText == cTextDocument( PRO_MAT )
         cFilter           := "( nTypDoc == '" + PRO_MAT + "' )"
         oBrwTmp:lFooter   := .t.

      otherwise
         cFilter           := nil
         oBrwTmp:lFooter   := .f.

   end case

   oDbfTmp:SetFilter( ( cFilter ) )
   oDbfTmp:GoTop()

   oBrwTmp:Refresh()

Return nil

//---------------------------------------------------------------------------//
/*
Funcion que elige la imagen de cada documento
*/

Static Function TreeImagen()

   do case
      case oDbfTmp:nTypDoc == PED_PRV
         Return ( 1 )

      case oDbfTmp:nTypDoc == ALB_PRV
         Return ( 2 )

      case oDbfTmp:nTypDoc == FAC_PRV
         Return ( 3 )

      case oDbfTmp:nTypDoc == RCT_PRV
         Return ( 12 )

      case oDbfTmp:nTypDoc == MOV_ALM
         Return ( 4 )

      case oDbfTmp:nTypDoc == PRE_CLI
         Return ( 5 )

      case oDbfTmp:nTypDoc == PED_CLI
         Return ( 6 )

      case oDbfTmp:nTypDoc == ALB_CLI
         Return ( 7 )

      case oDbfTmp:nTypDoc == FAC_CLI
         Return ( 8 )

      case oDbfTmp:nTypDoc == TIK_CLI
         Return ( 9 )

      case oDbfTmp:nTypDoc == DEV_CLI
         Return ( 9 )

      case oDbfTmp:nTypDoc == VAL_CLI
         Return ( 9 )

      case oDbfTmp:nTypDoc == APT_CLI
         Return ( 9 )

      case oDbfTmp:nTypDoc == FAC_REC
         Return ( 10 )

      case oDbfTmp:nTypDoc == PRO_LIN
         Return ( 11 )

      case oDbfTmp:nTypDoc == PRO_MAT
         Return ( 11 )

      case oDbfTmp:nTypDoc == SAT_CLI
         Return ( 13 )

   end case

Return ( 1 )

//---------------------------------------------------------------------------//
/*funcion que edita los documentos*/

Static Function EditDocument( oBrwTmp )

   do case
      case oDbfTmp:nTypDoc == PED_PRV
         EdtPedPrv( oDbfTmp:cNumDoc )

      case oDbfTmp:nTypDoc == ALB_PRV
         EdtAlbPrv( oDbfTmp:cNumDoc )

      case oDbfTmp:nTypDoc == FAC_PRV
         EdtFacPrv( oDbfTmp:cNumDoc )

      case oDbfTmp:nTypDoc == RCT_PRV
         EdtRctPrv( oDbfTmp:cNumDoc )

      case oDbfTmp:nTypDoc == PRE_CLI
         EdtPreCli( oDbfTmp:cNumDoc )

      case oDbfTmp:nTypDoc == PED_CLI
         EdtPedCli( oDbfTmp:cNumDoc )

      case oDbfTmp:nTypDoc == ALB_CLI
         EdtAlbCli( oDbfTmp:cNumDoc )

      case oDbfTmp:nTypDoc == FAC_CLI
         EdtFacCli( oDbfTmp:cNumDoc )

      case oDbfTmp:nTypDoc == FAC_REC
         EdtFacRec( oDbfTmp:cNumDoc )

      case oDbfTmp:nTypDoc == TIK_CLI .or.;
           oDbfTmp:nTypDoc == DEV_CLI .or.;
           oDbfTmp:nTypDoc == APT_CLI .or.;
           oDbfTmp:nTypDoc == VAL_CLI

         EdtTikCli( oDbfTmp:cNumDoc )

      case oDbfTmp:nTypDoc == MOV_ALM

         //EditMovimientosAlmacen( oDbfTmp:cNumDoc, oBrwTmp )

      case oDbfTmp:nTypDoc == PRO_LIN .or.;
           oDbfTmp:nTypDoc == PRO_MAT

         EditProduccion( oDbfTmp:cNumDoc, oBrwTmp )

   end case

Return nil

//---------------------------------------------------------------------------//
/*funcion que hace un soom a los documentos*/

Static Function ZoomDocument( oBrwTmp )

   do case
      case oDbfTmp:nTypDoc == PED_PRV
         ZooPedPrv( oDbfTmp:cNumDoc )

      case oDbfTmp:nTypDoc == ALB_PRV
         ZooAlbPrv( oDbfTmp:cNumDoc )

      case oDbfTmp:nTypDoc == FAC_PRV
         ZooFacPrv( oDbfTmp:cNumDoc )

      case oDbfTmp:nTypDoc == RCT_PRV
         ZooRctPrv( oDbfTmp:cNumDoc )

      case oDbfTmp:nTypDoc == PRE_CLI
         ZooPreCli( oDbfTmp:cNumDoc )

      case oDbfTmp:nTypDoc == PED_CLI
         ZooPedCli( oDbfTmp:cNumDoc )

      case oDbfTmp:nTypDoc == ALB_CLI
         ZooAlbCli( oDbfTmp:cNumDoc )

      case oDbfTmp:nTypDoc == FAC_CLI
         ZooFacCli( oDbfTmp:cNumDoc )

      case oDbfTmp:nTypDoc == FAC_REC
         ZooFacRec( oDbfTmp:cNumDoc )

      case oDbfTmp:nTypDoc == TIK_CLI .or.;
           oDbfTmp:nTypDoc == DEV_CLI .or.;
           oDbfTmp:nTypDoc == APT_CLI .or.;
           oDbfTmp:nTypDoc == VAL_CLI
         ZooTikCli( oDbfTmp:cNumDoc )

      case oDbfTmp:nTypDoc == MOV_ALM

         MovimientosAlmacenController():New():Zoom( oDbfTmp:nIdSql )

      case oDbfTmp:nTypDoc == PRO_LIN .or.;
           oDbfTmp:nTypDoc == PRO_MAT

         ZoomProduccion( oDbfTmp:cNumDoc, oBrwTmp )

   end case

Return nil

//---------------------------------------------------------------------------//
/*Function para eliminar los documentos*/

Static Function DeleteDocument( oBrwTmp )

   do case
      case oDbfTmp:nTypDoc == PED_PRV
         DelPedPrv( oDbfTmp:cNumDoc )

      case oDbfTmp:nTypDoc == ALB_PRV
         DelAlbPrv( oDbfTmp:cNumDoc )

      case oDbfTmp:nTypDoc == FAC_PRV
         DelFacPrv( oDbfTmp:cNumDoc )

      case oDbfTmp:nTypDoc == RCT_PRV
         DelRctPrv( oDbfTmp:cNumDoc )

      case oDbfTmp:nTypDoc == PRE_CLI
         DelPreCli( oDbfTmp:cNumDoc )

      case oDbfTmp:nTypDoc == PED_CLI
         DelPedCli( oDbfTmp:cNumDoc )

      case oDbfTmp:nTypDoc == ALB_CLI
         DelAlbCli( oDbfTmp:cNumDoc )

      case oDbfTmp:nTypDoc == FAC_CLI
         DelFacCli( oDbfTmp:cNumDoc )

      case oDbfTmp:nTypDoc == FAC_REC
         DelFacRec( oDbfTmp:cNumDoc )

      case oDbfTmp:nTypDoc == TIK_CLI .or.;
           oDbfTmp:nTypDoc == DEV_CLI .or.;
           oDbfTmp:nTypDoc == APT_CLI .or.;
           oDbfTmp:nTypDoc == VAL_CLI
         DelTikCli( oDbfTmp:cNumDoc )

      case oDbfTmp:nTypDoc == MOV_ALM

         //DelMovimientosAlmacen( oDbfTmp:cNumDoc, oBrwTmp )

      case oDbfTmp:nTypDoc == PRO_LIN .or.;
           oDbfTmp:nTypDoc == PRO_MAT

         DelProduccion( oDbfTmp:cNumDoc, oBrwTmp )

   end case

Return nil

//---------------------------------------------------------------------------//
/*Funcion para visualizar los documentos*/

Static Function VisualizaDocument( oBrwTmp )

   do case
      case oDbfTmp:nTypDoc == PED_PRV
         VisPedPrv( oDbfTmp:cNumDoc )

      case oDbfTmp:nTypDoc == ALB_PRV
         VisAlbPrv( oDbfTmp:cNumDoc )

      case oDbfTmp:nTypDoc == FAC_PRV
         VisFacPrv( oDbfTmp:cNumDoc )

      case oDbfTmp:nTypDoc == RCT_PRV
         VisRctPrv( oDbfTmp:cNumDoc )

      case oDbfTmp:nTypDoc == SAT_CLI
         VisSatCli( oDbfTmp:cNumDoc )

      case oDbfTmp:nTypDoc == PRE_CLI
         VisPreCli( oDbfTmp:cNumDoc )

      case oDbfTmp:nTypDoc == PED_CLI
         VisPedCli( oDbfTmp:cNumDoc )

      case oDbfTmp:nTypDoc == ALB_CLI
         VisAlbCli( oDbfTmp:cNumDoc )

      case oDbfTmp:nTypDoc == FAC_CLI
         VisFacCli( oDbfTmp:cNumDoc )

      case oDbfTmp:nTypDoc == FAC_REC
         VisFacRec( oDbfTmp:cNumDoc )

      case oDbfTmp:nTypDoc == TIK_CLI .or.;
           oDbfTmp:nTypDoc == DEV_CLI .or.;
           oDbfTmp:nTypDoc == APT_CLI .or.;
           oDbfTmp:nTypDoc == VAL_CLI
         VisTikCli( oDbfTmp:cNumDoc )

      case oDbfTmp:nTypDoc == MOV_ALM

         //VisMovimientosAlmacen( oDbfTmp:cNumDoc, oBrwTmp )

      case oDbfTmp:nTypDoc == PRO_LIN .or.;
           oDbfTmp:nTypDoc == PRO_MAT

         VisProduccion( oDbfTmp:cNumDoc )

   end case

Return nil

//---------------------------------------------------------------------------//
/*Funcion para imprimir los documentos*/

Static Function PrintDocument( oBrwTmp )

   do case
      case oDbfTmp:nTypDoc == SAT_CLI
         PrnSatCli( oDbfTmp:cNumDoc )

      case oDbfTmp:nTypDoc == PED_PRV
         PrnPedPrv( oDbfTmp:cNumDoc )

      case oDbfTmp:nTypDoc == ALB_PRV
         PrnAlbPrv( oDbfTmp:cNumDoc )

      case oDbfTmp:nTypDoc == FAC_PRV
         PrnFacPrv( oDbfTmp:cNumDoc )

      case oDbfTmp:nTypDoc == RCT_PRV
         PrnRctPrv( oDbfTmp:cNumDoc )

      case oDbfTmp:nTypDoc == PRE_CLI
         PrnPreCli( oDbfTmp:cNumDoc )

      case oDbfTmp:nTypDoc == PED_CLI
         PrnPedCli( oDbfTmp:cNumDoc )

      case oDbfTmp:nTypDoc == ALB_CLI
         PrnSerieAlbCli( oDbfTmp:cNumDoc )

      case oDbfTmp:nTypDoc == FAC_CLI
         PrnFacCli( oDbfTmp:cNumDoc )

      case oDbfTmp:nTypDoc == FAC_REC
         PrnFacRec( oDbfTmp:cNumDoc )

      case oDbfTmp:nTypDoc == TIK_CLI .or.;
           oDbfTmp:nTypDoc == DEV_CLI .or.;
           oDbfTmp:nTypDoc == APT_CLI .or.;
           oDbfTmp:nTypDoc == VAL_CLI
         PrnTikCli( oDbfTmp:cNumDoc )

      case oDbfTmp:nTypDoc == MOV_ALM

         PrnProduccion( oDbfTmp:cNumDoc )

      case oDbfTmp:nTypDoc == PRO_LIN .or.;
           oDbfTmp:nTypDoc == PRO_MAT

         PrnProduccion( oDbfTmp:cNumDoc )

   end case

Return nil

//---------------------------------------------------------------------------//
/*
Define la base de datos temporal
*/

Static Function DefineTemporal( cPath, lUniqueName, cFileName )

   local oDbf

   DEFAULT cPath        := cPatTmp()
   DEFAULT lUniqueName  := .t.
   DEFAULT cFileName    := "InfArt"

   if lUniqueName
      cFileName         := cGetNewFileName( cFileName, , , cPatTmp() )
   end if

   DEFINE TABLE oDbf FILE ( cFileName ) CLASS "InfArt" ALIAS ( cFileName ) PATH ( cPath ) VIA ( cLocalDriver() )

      FIELD NAME "nTypDoc"    TYPE "C" LEN  2 DEC 0 COMMENT "Tipo de documento"              OF oDbf
      FIELD NAME "cEstDoc"    TYPE "C" LEN 20 DEC 0 COMMENT "Estado del documento"           OF oDbf
      FIELD NAME "dFecDoc"    TYPE "D" LEN  8 DEC 0 COMMENT "Fecha del documento"            OF oDbf
      FIELD NAME "cNumDoc"    TYPE "C" LEN 13 DEC 0 COMMENT "Número del documento"           OF oDbf
      FIELD NAME "cSufDoc"    TYPE "C" LEN  2 DEC 0 COMMENT ""                               OF oDbf
      FIELD NAME "lFacturado" TYPE "L" LEN  1 DEC 0 COMMENT "Documento facturado"            OF oDbf
      FIELD NAME "cCodDoc"    TYPE "C" LEN 12 DEC 0 COMMENT "Código cliente/proveedor"       OF oDbf
      FIELD NAME "cNomDoc"    TYPE "C" LEN 50 DEC 0 COMMENT "Nombre cliente/proveedor"       OF oDbf
      FIELD NAME "cRef"       TYPE "C" LEN 18 DEC 0 COMMENT "Referencia artículo"            OF oDbf
      FIELD NAME "cCodPr1"    TYPE "C" LEN 20 DEC 0 COMMENT "Código de la primera propiedad" OF oDbf
      FIELD NAME "cCodPr2"    TYPE "C" LEN 20 DEC 0 COMMENT "Código de la segunda propiedad" OF oDbf
      FIELD NAME "cValPr1"    TYPE "C" LEN 20 DEC 0 COMMENT "Valor de la primera propiedad"  OF oDbf
      FIELD NAME "cValPr2"    TYPE "C" LEN 20 DEC 0 COMMENT "Valor de la segunda propiedad"  OF oDbf
      FIELD NAME "cLote"      TYPE "C" LEN 14 DEC 0 COMMENT "Número de lote"                 OF oDbf
      FIELD NAME "cAlmDoc"    TYPE "C" LEN 16 DEC 0 COMMENT "Almacén destino"                OF oDbf
      FIELD NAME "cAlmOrg"    TYPE "C" LEN 16 DEC 0 COMMENT "Almacén origen"                 OF oDbf
      FIELD NAME "nUndDoc"    TYPE "N" LEN 16 DEC 6 COMMENT "Unidades vendidas"              OF oDbf
      FIELD NAME "nFacCnv"    TYPE "N" LEN 16 DEC 6 COMMENT "Factor de conversión"           OF oDbf
      FIELD NAME "nDtoDoc"    TYPE "N" LEN 16 DEC 6 COMMENT "Descuento porcentual"           OF oDbf
      FIELD NAME "nImpDoc"    TYPE "N" LEN 16 DEC 6 COMMENT "Importe unidad"                 OF oDbf
      FIELD NAME "nTotDoc"    TYPE "N" LEN 16 DEC 6 COMMENT "Total documento"                OF oDbf
      FIELD NAME "tFecDoc"    TYPE "C" LEN  6 DEC 0 COMMENT "Hora del documento"             OF oDbf
      FIELD NAME "nidSql"     TYPE "N" LEN 16 DEC 0 COMMENT "id de mysql"                    OF oDbf

      INDEX TO ( cFileName ) TAG "nTypDoc" ON "nTypDoc + Dtos( dFecDoc )"                    OF oDbf
      INDEX TO ( cFileName ) TAG "cEstDoc" ON "cEstDoc + Dtos( dFecDoc )"                    OF oDbf
      INDEX TO ( cFileName ) TAG "dFecDoc" ON "Dtos( dFecDoc ) + tFecDoc"                    OF oDbf
      INDEX TO ( cFileName ) TAG "cNumDoc" ON "cNumDoc + Dtos( dFecDoc )"                    OF oDbf
      INDEX TO ( cFileName ) TAG "cSufDoc" ON "cSufDoc"                                      OF oDbf
      INDEX TO ( cFileName ) TAG "cNomDoc" ON "cNomDoc + Dtos( dFecDoc )"                    OF oDbf
      INDEX TO ( cFileName ) TAG "cCodDoc" ON "cCodDoc + Dtos( dFecDoc )"                    OF oDbf
      INDEX TO ( cFileName ) TAG "cLote"   ON "cLote + Dtos( dFecDoc )"                      OF oDbf
      INDEX TO ( cFileName ) TAG "cAlmDoc" ON "cAlmDoc + Dtos( dFecDoc )"                    OF oDbf
      INDEX TO ( cFileName ) TAG "cAlmOrg" ON "cAlmOrg + Dtos( dFecDoc )"                    OF oDbf
      INDEX TO ( cFileName ) TAG "nUndDoc" ON "nUndDoc"                                      OF oDbf
      INDEX TO ( cFileName ) TAG "nFacCnv" ON "nFacCnv"                                      OF oDbf
      INDEX TO ( cFileName ) TAG "nImpDoc" ON "nImpDoc"                                      OF oDbf
      INDEX TO ( cFileName ) TAG "nTotDoc" ON "nTotDoc"                                      OF oDbf

   END DATABASE oDbf

Return ( oDbf )

//---------------------------------------------------------------------------//
/*
Texto del tipo de documento
*/

Function cTextDocument( nTypDoc )

   local cTextDocument  := ""

   DEFAULT nTypDoc      := oDbfTmp:nTypDoc

   if !isChar( nTypDoc )
      Return ( cTextDocument )
   end if

   do case
      case nTypDoc == PED_PRV
         cTextDocument  := "Pedidos proveedor"
      case nTypDoc == ALB_PRV
         cTextDocument  := "Albaranes proveedor"
      case nTypDoc == FAC_PRV
         cTextDocument  := "Facturas proveedor"
      case nTypDoc == RCT_PRV
         cTextDocument  := "Rectificativas proveedor"
      case nTypDoc == PRE_CLI
         cTextDocument  := "Presupuestos cliente"
      case nTypDoc == PED_CLI
         cTextDocument  := "Pedidos cliente"
      case nTypDoc == ALB_CLI
         cTextDocument  := "Albaranes cliente"
      case nTypDoc == FAC_CLI
         cTextDocument  := "Facturas cliente"
      case nTypDoc == FAC_REC
         cTextDocument  := "Rectificativas cliente"
      case nTypDoc == TIK_CLI
         cTextDocument  := "Tickets cliente"
      case nTypDoc == DEV_CLI
         cTextDocument  := "Devoluciones cliente"
      case nTypDoc == VAL_CLI
         cTextDocument  := "Vale cliente"
      case nTypDoc == APT_CLI
         cTextDocument  := "Apartado cliente"
      case nTypDoc == MOV_ALM
         cTextDocument  := "Movimientos almacen"
      case nTypDoc == PRO_LIN
         cTextDocument  := "Material producido"
      case nTypDoc == PRO_MAT
         cTextDocument  := "Materia prima"
      case nTypDoc == SAT_CLI
         cTextDocument  := "S.A.T. cliente"
   end case

Return ( cTextDocument )

//---------------------------------------------------------------------------//
/*Rotor que se usa para los detalles de todos los documentos*/

Function EdtDetMenu( oCodArt, oDlg, lOferta )

   DEFAULT lOferta      := .f.

   MENU oMenu


      MENUITEM    "&1. Rotor  " ;
         RESOURCE "Rotor16"

         MENU

            MENUITEM    "&1. Modificar artículo";
               MESSAGE  "Modificar la ficha del artículo" ;
               RESOURCE "gc_object_cube_16";
               ACTION   ( EdtArticulo( oCodArt:VarGet() ) );

            MENUITEM    "&2. Informe de artículo";
               MESSAGE  "Abrir el informe del artículo" ;
               RESOURCE "Info16";
               ACTION   ( if( oUser():lNotCostos(), msgStop( "No tiene permiso para ver los precios de costo" ), InfArticulo( oCodArt:VarGet() ) ) );

         ENDMENU

      /*if lOferta

         MENUITEM    "&2. Artículo en oferta  ";
            MESSAGE  "Modificar la ficha del artículo" ;
            RESOURCE "Sel16";
            ACTION   ( EdtArticulo( oCodArt:VarGet() ) );

      end if*/

   ENDMENU

   oDlg:SetMenu( oMenu )

Return ( oMenu )

//---------------------------------------------------------------------------//
/*Termina el menu del rotor de las lineas de los documentos*/

function EndDetMenu()

return oMenu:End()

//---------------------------------------------------------------------------//
/*
Calculo de stock se usa en stock.prg
*/

Static Function nTotUnd( oDbfTmp )

   local nRec     := oDbfTmp:Recno()
   local nTotImp  := 0

   oDbfTmp:GoTop()
   while !oDbfTmp:Eof()

      nTotImp     += oDbfTmp:nUndDoc

      oDbfTmp:Skip()

   end while

   oDbfTmp:GoTo( nRec )

Return ( nTotImp )

//---------------------------------------------------------------------------//

Static Function nTotImp( oDbfTmp )

   local nRec     := oDbfTmp:Recno()
   local nTotImp  := 0

   oDbfTmp:GoTop()
   while !oDbfTmp:Eof()

      nTotImp     += oDbfTmp:nTotDoc

      oDbfTmp:Skip()

   end while

   oDbfTmp:GoTo( nRec )

Return ( nTotImp )

//---------------------------------------------------------------------------//

Static Function Filtro( oBrwTmp )

   local oFilter  := TFilterCreator():Init() 
   
   oFilter:SetDatabase( oDbfTmp )  
   oFilter:Dialog()

   if !Empty( oFilter:cExpresionFilter )
      oDbfTmp:SetFilter( oFilter:cExpresionFilter )
      SetWindowText( oBtnFiltro:hWnd, "Filtro activo" )
   else 
      oDbfTmp:SetFilter()
      SetWindowText( oBtnFiltro:hWnd, "Filtrar" )
   end if 

   oBrwTmp:Refresh()

Return( .t. )

//---------------------------------------------------------------------------//
//Funciones para programa y pda
//---------------------------------------------------------------------------//

#endif

//---------------------------------------------------------------------------//

Function nTotNResCli( dbfPedCliR )

Return ( NotCaja( ( dbfPedCliR )->nCajRes ) * ( dbfPedCliR )->nUndRes )

//---------------------------------------------------------------------------//

function cNombreMes( nMes )

   do case
      case nMes == 1
         Return ( "Enero" )
      case nMes == 2
         Return ( "Febrero" )
      case nMes == 3
         Return ( "Marzo" )
      case nMes == 4
         Return ( "Abril" )
      case nMes == 5
         Return ( "Mayo" )
      case nMes == 6
         Return ( "Junio" )
      case nMes == 7
         Return ( "Julio" )
      case nMes == 8
         Return ( "Agosto" )
      case nMes == 9
         Return ( "Septiembre" )
      case nMes == 10
         Return ( "Octubre" )
      case nMes == 11
         Return ( "Noviembre" )
      case nMes == 12
         Return ( "Diciembre" )
   end case

Return ""

//---------------------------------------------------------------------------//

Function cValueTree( oBrwStk, cData )

   local oItem
   local uValue
   local nUnidades            := 0

   DEFAULT cData              := "nUnidades"

   if !Empty( oBrwStk:oTreeItem ) 

      if !IsNil( oBrwStk:oTreeItem:oTree )

         oItem                := oBrwStk:oTreeItem:oTree:oFirst 

         while !IsNil( oItem )


            if !Empty( oItem:Cargo )

               uValue         := oSend( oItem:Cargo, cData ) 
               
               if isNum( uValue )
                  nUnidades   += oSend( oItem:Cargo, cData ) 
               else
                  nUnidades   := oSend( oItem:Cargo, cData ) 
               end if 

            end if 

            if ( oItem:oNext != nil .and. oItem:oNext:nLevel == oItem:nLevel )
               oItem          := oItem:oNext
            else
               oItem          := nil 
            end if 

         end while

      else 

         if !Empty( oBrwStk:oTreeItem:Cargo )
            nUnidades         := oSend( oBrwStk:oTreeItem:Cargo, cData ) 
         end if 

      end if

   end if 

Return ( nUnidades )

//---------------------------------------------------------------------------//

Function getTreeValue( oBrwStk, cData )

   local oItem
   local uValue
   local nUnidades            := 0

   DEFAULT cData              := "nUnidades"

   if !empty( oBrwStk:oTreeItem ) 

      if !isnil( oBrwStk:oTreeItem:oTree )

         oItem                := oBrwStk:oTreeItem:oTree:oFirst 

         while !isnil( oItem )

            if !empty( oItem:Cargo )

               uValue         := oSend( oItem:Cargo, cData ) 
               
               if isNum( uValue )
                  nUnidades   += uValue
               else
                  nUnidades   := uValue
               end if 

            end if 

            if ( oItem:oNext != nil .and. oItem:oNext:nLevel == oItem:nLevel )
               oItem          := oItem:oNext
            else
               oItem          := nil 
            end if 

         end while

      else 

         if !Empty( oBrwStk:oTreeItem:Cargo )
            nUnidades         := oSend( oBrwStk:oTreeItem:Cargo, cData )
         end if 

      end if

   end if 

Return ( nUnidades )

//---------------------------------------------------------------------------//

Function nFooterTree( oBrwStk, cData )

   local oItem
   local oNode
   local nUnidades            := 0

   DEFAULT cData              := "nUnidades"

   if !Empty( oBrwStk:oTree ) 

      oItem                   := oBrwStk:oTree:oFirst 
      
      while !IsNil( oItem )

         if !IsNil( oItem:oTree )   

            oNode             := oItem:oTree:oFirst 

            while !IsNil( oNode )

               if !Empty( oNode:Cargo )
                  nUnidades   += oSend( oNode:Cargo, cData ) 
               end if 

               if ( oNode:oNext != nil .and. oNode:oNext:nLevel == oNode:nLevel )
                  oNode       := oNode:oNext
               else
                  oNode       := nil 
               end if 

            end while

         end if

         oItem                := oItem:GetNext()

      end while 

   end if 

Return ( nUnidades )

//---------------------------------------------------------------------------//