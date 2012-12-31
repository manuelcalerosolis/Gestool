#ifndef __PDA__
#include "FiveWin.Ch"
#include "Folder.ch"
#include "Report.ch"
#include "Label.ch"
#include "Factu.ch"
#include "MesDbf.ch"
#include "TGraph.ch"
#else
#include "FWCE.ch"
REQUEST DBFCDX
#endif

#ifndef __PDA__
#define IDC_CHART1               111

static dbfDiv
static dbfIva
static dbfAlm
static dbfArticulo

static dbfMovAlm
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
static oFilter     := nil

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

static oTreeImageList
static oTreeDocument
static oTreeCompras
static oTreeVentas
static oTreeStock
static oTreeProduccion

static oStock
static nTotResStk  := 0
static nTotEntStk  := 0
static nTotActStk  := 0
static nStkCom     := 0
static nStkAlm     := 0
static nStkVta     := 0
static nStkPro     := 0
static nStkCon     := 0
static oStkCom
static oStkAlm
static oStkVta
static oStkPro
static oStkCon
static oTotActStk
static oTotResStk
static oTotEntStk
static oStkLibre
static nStkLibre   := 0
static oPesStk
static oVolStk
static oPesUnd
static oVolUnd
static nPesStk     := 0
static nVolStk     := 0
static nPesUnd     := 0
static nVolUnd     := 0

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

#endif

#ifndef __PDA__

//---------------------------------------------------------------------------//
//Funciones del programa
//---------------------------------------------------------------------------//


Static Function OpenFiles()

   local lOpen       := .f.
   local oError
   local oBlock

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

   /*
   Documentos relacionados de compras------------------------------------------
   */

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

   USE ( cPatEmp() + "PRECLIT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PRECLIT", @dbfPreCliT ) )
   SET ADSINDEX TO ( cPatEmp() + "PRECLIT.CDX" ) ADDITIVE

   USE ( cPatEmp() + "PRECLIL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PRECLIL", @dbfPreCliL ) )
   SET ADSINDEX TO ( cPatEmp() + "PRECLIL.CDX" ) ADDITIVE
   SET TAG TO "CREF"

   /*
   Documentos relacionados de ventas
   */

   USE ( cPatEmp() + "PEDCLIT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PEDCLIT", @dbfPedCliT ) )
   SET ADSINDEX TO ( cPatEmp() + "PEDCLIT.CDX" ) ADDITIVE

   USE ( cPatEmp() + "PEDCLIL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PEDCLIL", @dbfPedCliL ) )
   SET ADSINDEX TO ( cPatEmp() + "PEDCLIL.CDX" ) ADDITIVE
   SET TAG TO "CREF"

   USE ( cPatEmp() + "PEDCLIR.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PEDCLIR", @dbfPedCliR ) )
   SET ADSINDEX TO ( cPatEmp() + "PEDCLIR.CDX" ) ADDITIVE
   SET TAG TO "CREF"

   USE ( cPatEmp() + "ALBCLIT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ALBCLIT", @dbfAlbCliT ) )
   SET ADSINDEX TO ( cPatEmp() + "ALBCLIT.CDX" ) ADDITIVE

   USE ( cPatEmp() + "ALBCLIL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ALBCLIL", @dbfAlbCliL ) )
   SET ADSINDEX TO ( cPatEmp() + "ALBCLIL.CDX" ) ADDITIVE
   SET TAG TO "CREF"

   USE ( cPatEmp() + "FACCLIT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FACCLIT", @dbfFacCliT ) )
   SET ADSINDEX TO ( cPatEmp() + "FACCLIT.CDX" ) ADDITIVE

   USE ( cPatEmp() + "FACCLIL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FACCLIL", @dbfFacCliL ) )
   SET ADSINDEX TO ( cPatEmp() + "FACCLIL.CDX" ) ADDITIVE
   SET TAG TO "CREF"

   USE ( cPatEmp() + "FACCLIP.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FACCLIP", @dbfFacCliP ) )
   SET ADSINDEX TO ( cPatEmp() + "FACCLIP.CDX" ) ADDITIVE

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

   USE ( cPatEmp() + "HISMOV.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "HISMOV", @dbfMovAlm ) )
   SET ADSINDEX TO ( cPatEmp() + "HISMOV.CDX" ) ADDITIVE
   SET TAG TO "CREFMOV"

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

   oDbfTmp              := DefineTemporal()
   oDbfTmp:Activate( .f., .f. )

   oStock               := TStock():Create( cPatGrp() )
   if oStock:lOpenFiles()

      oStock:cPedCliT   := dbfPedCliT
      oStock:cPedCliL   := dbfPedCliL
      oStock:cPedCliR   := dbfPedCliR
      oStock:cAlbCliT   := dbfAlbCliT
      oStock:cAlbCliL   := dbfAlbCliL
      oStock:cFacCliT   := dbfFacCliT
      oStock:cFacCliL   := dbfFacCliL
      oStock:cFacRecT   := dbfFacRecT
      oStock:cFacRecL   := dbfFacRecL
      oStock:cTikT      := dbfTikCliT
      oStock:cTikL      := dbfTikCliL

      oStock:cKit       := dbfArtKit

      oStock:cPedPrvL   := dbfPedPrvL
      oStock:cAlbPrvT   := dbfAlbPrvT
      oStock:cAlbPrvL   := dbfAlbPrvL
      oStock:cFacPrvT   := dbfFacPrvT
      oStock:cFacPrvL   := dbfFacPrvL
      oStock:cRctPrvT   := dbfRctPrvT
      oStock:cRctPrvL   := dbfRctPrvL

      oStock:cProducT   := dbfProducT
      oStock:cProducL   := dbfProducL
      oStock:cProducM   := dbfProducM
      oStock:cHisMov    := dbfMovAlm

   end if

   lOpen             := .t.

   RECOVER USING oError

      msgStop( ErrorMessage( oError ), "Imposible abrir las bases de datos" )
      lOpen          := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

   CursorWE()

Return ( lOpen )

//---------------------------------------------------------------------------//

Static Function CloseFiles()

   /*
   Quitamos el ImageList-------------------------------------------------------
   */

   if oTreeImageList != nil
      oTreeImageList:End()
   end if

   (dbfPedPrvT)->( dbCloseArea() )
   (dbfPedPrvL)->( dbCloseArea() )
   (dbfAlbPrvT)->( dbCloseArea() )
   (dbfAlbPrvL)->( dbCloseArea() )
   (dbfFacPrvT)->( dbCloseArea() )
   (dbfFacPrvL)->( dbCloseArea() )
   (dbfFacPrvP)->( dbCloseArea() )
   (dbfPreCliT)->( dbCloseArea() )
   (dbfPreCliL)->( dbCloseArea() )
   (dbfPedCliT)->( dbCloseArea() )
   (dbfPedCliL)->( dbCloseArea() )
   (dbfPedCliR)->( dbCloseArea() )
   (dbfAlbCliT)->( dbCloseArea() )
   (dbfAlbCliL)->( dbCloseArea() )
   (dbfFacCliT)->( dbCloseArea() )
   (dbfFacCliL)->( dbCloseArea() )
   (dbfFacCliP)->( dbCloseArea() )
   (dbfFacRecT)->( dbCloseArea() )
   (dbfFacRecL)->( dbCloseArea() )
   (dbfTikCliT)->( dbCloseArea() )
   (dbfTikCliL)->( dbCloseArea() )
   (dbfTikCliP)->( dbCloseArea() )
   (dbfMovAlm )->( dbCloseArea() )
   (dbfArtKit )->( dbCloseArea() )
   (dbfProducT)->( dbCloseArea() )
   (dbfProducL)->( dbCloseArea() )
   (dbfProducM)->( dbCloseArea() )
   (dbfRctPrvT)->( dbCloseArea() )
   (dbfRctPrvL)->( dbCloseArea() )

   if !Empty( oStock )
      oStock:End()
   end if

   if !Empty( oDbfTmp )
      oDbfTmp:Close()
      dbfErase( oDbfTmp:cPath + oDbfTmp:cName )
   end if

Return .t.

//---------------------------------------------------------------------------//

function BrwVtaComArt( cCodArt, cNomArt, cDiv, cIva, cAlm, cArticulo )

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
   local cCmbAnio          := "Todos" //Str( Year( GetSysDate() ) )
   local oBmpGeneral
   local oBmpDocumentos
   local oBmpGraficos

   if Empty( cCodArt )
      Return nil
   end if

   dbfDiv                  := cDiv
   dbfIva                  := cIva
   dbfAlm                  := cAlm
   dbfArticulo             := cArticulo

   if !OpenFiles()
      Return nil
   end if

   CursorWait()

   nRec                    := ( dbfArticulo )->( Recno() )
   nOrd                    := ( dbfArticulo )->( OrdSetFocus( 1 ) )

   oFilter                 := TDlgFlt():Create( oDbfTmp, , .f. )
   oFilter:bOnAplyFilter   := {|| oDbfTmp:SetFilter( oFilter:cExpFilter ), oBrwTmp:Refresh() }
   oFilter:bOnKillFilter   := {|| oDbfTmp:SetFilter(), oBrwTmp:Refresh() }

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

   oDbfTmp:Cargo           := cCodArt

   /*
   Montamos el dialogo
   */

   DEFINE DIALOG oDlg RESOURCE "ARTINFO" TITLE "Información del artículo : " + Rtrim( cCodArt ) + " - " + Rtrim( cNomArt )

   REDEFINE FOLDER oFld ;
			ID 		300 ;
			OF 		oDlg ;
         PROMPT   "&Estadisticas"      ,;
                  "&Documentos"        ,;
                  "Gráfico"            ;
         DIALOGS  "ART_8"              ,;
                  "INFO_1"             ,;
                  "INFO_2"

   /*
   Compras---------------------------------------------------------------------
   */

   // Cajas

   REDEFINE BITMAP oBmpGeneral;
         ID       500 ;
         RESOURCE "Cube_Yellow_Alpha_48" ;
         TRANSPARENT ;
         OF       oFld:aDialogs[ 1 ]

   /*
   Browse de Compras-----------------------------------------------------------
   */

   oBrwCom                       := IXBrowse():New( oFld:aDialogs[ 1 ] )

   oBrwCom:bClrSel               := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
   oBrwCom:bClrSelFocus          := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

   oBrwCom:SetArray( aCom, , , .f. )

   oBrwCom:lFooter            := .t.
   oBrwCom:lVScroll           := .f.
   oBrwCom:lHScroll           := .f.
   oBrwCom:nMarqueeStyle      := 5
   oBrwCom:nFooterHeight      := 35

   oBrwCom:nFooterLines       := 2
   oBrwCom:cName              := "Compras en informe de articulos"
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

   oBrwVta                       := IXBrowse():New( oFld:aDialogs[ 1 ] )

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

   REDEFINE BITMAP oBmpDocumentos ID 500 RESOURCE "Document_Text_Alpha_48" TRANSPARENT OF oFld:aDialogs[ 2 ]

   oBrwStk                       := IXBrowse():New( oFld:aDialogs[ 1 ] )

   oBrwStk:bClrSel               := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
   oBrwStk:bClrSelFocus          := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

   oBrwStk:SetArray( oStock:aStocks, , , .f. )

   oBrwStk:lFooter               := .t.
   oBrwStk:lVScroll              := .t.
   oBrwStk:lHScroll              := .t.
   oBrwStk:nMarqueeStyle         := 5
   oBrwStk:cName                 := "Stocks en informe de articulos"
   oBrwStk:CreateFromResource( 300 )

   with object ( oBrwStk:AddCol() )
      :cHeader                   := "Almacén"
      :nWidth                    := 280
      :bStrData                  := {|| if( !Empty( oBrwStk:aArrayData ), oBrwStk:aArrayData[ oBrwStk:nArrayAt ]:cCodigoAlmacen + Space( 1 ) + RetAlmacen( oBrwStk:aArrayData[ oBrwStk:nArrayAt ]:cCodigoAlmacen, dbfAlm ), "" ) }
      :bFooter                   := {|| "Total almacenes" }
   end with

   with object ( oBrwStk:AddCol() )
      :cHeader                   := "Prop. 1"
      :nWidth                    := 50
      :bStrData                  := {|| if( !Empty( oBrwStk:aArrayData ), oBrwStk:aArrayData[ oBrwStk:nArrayAt ]:cValorPropiedad1, "" ) }
      :lHide                     := .t.
   end with

   with object ( oBrwStk:AddCol() )
      :cHeader                   := "Prop. 2"
      :nWidth                    := 50
      :bStrData                  := {|| if( !Empty( oBrwStk:aArrayData ), oBrwStk:aArrayData[ oBrwStk:nArrayAt ]:cValorPropiedad2, "" ) }
      :lHide                     := .t.
   end with

   with object ( oBrwStk:AddCol() )
      :cHeader                   := "Lote"
      :nWidth                    := 70
      :bStrData                  := {|| if( !Empty( oBrwStk:aArrayData ), oBrwStk:aArrayData[ oBrwStk:nArrayAt ]:cLote, "" ) }
      :lHide                     := .t.
   end with

   with object ( oBrwStk:AddCol() )
      :cHeader                   := "Num. serie"
      :nWidth                    := 70
      :bStrData                  := {|| if( !Empty( oBrwStk:aArrayData ), oBrwStk:aArrayData[ oBrwStk:nArrayAt ]:cNumeroSerie, "" ) }
      :lHide                     := .t.
   end with

   with object ( oBrwStk:AddCol() )
      :cHeader                   := "Unidades"
      :nWidth                    := 110
      :bEditValue                := {|| if( !Empty( oBrwStk:aArrayData ), oBrwStk:aArrayData[ oBrwStk:nArrayAt ]:nUnidades, 0 ) }
      :bFooter                   := {|| nStockUnidades( oBrwStk ) }
      :cEditPicture              := MasUnd()
   end with

   with object ( oBrwStk:AddCol() )
      :cHeader                   := "Pdt. recibir"
      :nWidth                    := 110
      :bEditValue                := {|| if( !Empty( oBrwStk:aArrayData ), oBrwStk:aArrayData[ oBrwStk:nArrayAt ]:nPendientesRecibir, 0 ) }
      :bFooter                   := {|| nStockPendiente( oBrwStk ) }
      :cEditPicture              := MasUnd()
   end with

   with object ( oBrwStk:AddCol() )
      :cHeader                   := "Pdt. entregar"
      :nWidth                    := 110
      :bEditValue                := {|| if( !Empty( oBrwStk:aArrayData ), oBrwStk:aArrayData[ oBrwStk:nArrayAt ]:nPendientesEntregar, 0 ) }
      :bFooter                   := {|| nStockEntregar( oBrwStk ) }
      :cEditPicture              := MasUnd()
   end with

   with object ( oBrwStk:AddCol() )
      :cHeader                   := "Peso stock"
      :nWidth                    := 110
      :bEditValue                := {|| if( !Empty( oBrwStk:aArrayData ), oBrwStk:aArrayData[ oBrwStk:nArrayAt ]:nUnidades * nPesUnd, 0 ) }
      :bFooter                   := {|| nStockUnidades( oBrwStk ) * nPesUnd }
      :cEditPicture              := MasUnd()
   end with

   with object ( oBrwStk:AddCol() )
      :cHeader                   := "Volumen stock"
      :nWidth                    := 110
      :bEditValue                := {|| if( !Empty( oBrwStk:aArrayData ), oBrwStk:aArrayData[ oBrwStk:nArrayAt ]:nUnidades * nVolUnd, 0 ) }
      :bFooter                   := {|| nStockUnidades( oBrwStk ) * nVolUnd }
      :cEditPicture              := MasUnd()
   end with

   with object ( oBrwStk:AddCol() )
      :cHeader                   := "Consolidación"
      :nWidth                    := 110
      :bStrData                  := {|| if( !Empty( oBrwStk:aArrayData ), Dtoc( oBrwStk:aArrayData[ oBrwStk:nArrayAt ]:dConsolidacion ), "" ) }
      :lHide                     := .t.
   end with

   /*
   Documentos------------------------------------------------------------------
   */

   oTree             := TTreeView():Redefine( 310, oFld:aDialogs[2]  )
   oTree:bChanged    := {|| TreeChanged( oTree, oBrwTmp ) }

   /*
   Barra de botones y datos----------------------------------------------------
   */

   REDEFINE BUTTON ;
      ID       301 ;
      OF       oFld:aDialogs[2] ;
      ACTION   ( EditDocument( oBrwTmp ), LoadDatos( cCodArt, cCmbAnio, oDlg, oBrwStk, oBrwTmp, oGraph, oBrwCom, oBrwVta ) )

   REDEFINE BUTTON ;
      ID       302 ;
      OF       oFld:aDialogs[2] ;
      ACTION   ( ZoomDocument( oBrwTmp ) )

   REDEFINE BUTTON ;
      ID       303 ;
      OF       oFld:aDialogs[2] ;
      ACTION   ( DeleteDocument( oBrwTmp ), LoadDatos( cCodArt, cCmbAnio, oDlg, oBrwStk, oBrwTmp, oGraph, oBrwCom, oBrwVta ) )

   REDEFINE BUTTON ;
      ID       304 ;
      OF       oFld:aDialogs[2] ;
      ACTION   ( VisualizaDocument( oBrwTmp ) )

   REDEFINE BUTTON ;
      ID       305 ;
      OF       oFld:aDialogs[2] ;
      ACTION   ( PrintDocument( oBrwTmp ) )

   REDEFINE BUTTON oBtnFiltro ;
      ID       600 ;
      OF       oFld:aDialogs[2] ;
      ACTION   ( Filtro(), oBrwTmp:Refresh() )

   oBrwTmp                       := IXBrowse():New( oFld:aDialogs[ 2 ] )

   oBrwTmp:bClrSel               := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
   oBrwTmp:bClrSelFocus          := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

   oDbfTmp:SetBrowse( oBrwTmp )

   oBrwTmp:nMarqueeStyle         := 5
   oBrwTmp:lFooter               := .t.

   oBrwTmp:cName                 := "Documentos en informe de articulos"

   oBrwTmp:CreateFromResource( 300 )

   with object ( oBrwTmp:addCol() )
      :cHeader       := "Dc. Documento"
      :bStrData      := {|| cTextDocument() }
      :bBmpData      := {|| TreeImagen() }
      :nWidth        := 20
      :AddResource( "Clipboard_empty_businessman_16" )
      :AddResource( "Document_plain_businessman_16" )
      :AddResource( "Document_businessman_16" )
      :AddResource( "Pencil_Package_16" )
      :AddResource( "Notebook_user1_16" )
      :AddResource( "Clipboard_empty_user1_16" )
      :AddResource( "Document_plain_user1_16" )
      :AddResource( "Document_user1_16" )
      :AddResource( "Cashier_user1_16" )
      :AddResource( "Document_Delete_16" )
      :AddResource( "Worker2_Form_Red_16" )
      :AddResource( "Document_navigate_cross_16" )
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
      :cHeader       := "Fecha"
      :bEditValue    := {|| Dtoc( oDbfTmp:dFecDoc ) }
      :cSortOrder    := "dFecDoc"
      :nWidth        := 70
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
      :nWidth        := 175
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
      :cEditPicture  := "@E 999,99"
      :nWidth        := 40
      :nDataStrAlign := 1
      :nHeadStrAlign := 1
      :lHide         := .t.
   end with

   with object ( oBrwTmp:addCol() )
      :cHeader       := "Almacén"
      :cSortOrder    := "cAlmDoc"
      :bEditValue    := {|| oDbfTmp:cAlmDoc }
      :nWidth        := 40
      :lHide         := .t.
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
      :cHeader       := "Lote"
      :bEditValue    := {|| oDbfTmp:cLote }
      :cSortOrder    := "cLote"
      :nWidth        := 80
      :lHide         := .t.
   end with

   oBrwTmp:bLDblClick   := {|| ZoomDocument( oBrwTmp ) }

   /*
   Graph start setting---------------------------------------------------------
   */

   REDEFINE BITMAP oBmpGraficos ID 500 RESOURCE "Chart_area_48_alpha" TRANSPARENT OF oFld:aDialogs[ 3 ]

   REDEFINE BTNBMP ;
      ID       101 ;
      OF       oFld:aDialogs[ 3 ] ;
      RESOURCE "ColumnChart16" ;
      NOBORDER ;
      TOOLTIP  "Gráfico de barras" ;
      ACTION   ( oGraph:SetType( GRAPH_TYPE_BAR ) )

   REDEFINE BTNBMP ;
      ID       102 ;
      OF       oFld:aDialogs[ 3 ] ;
      RESOURCE "LineChart16" ;
      NOBORDER ;
      TOOLTIP  "Gráfico de lineas" ;
      ACTION   ( oGraph:SetType( GRAPH_TYPE_LINE ) )

   REDEFINE BTNBMP ;
      ID       103 ;
      OF       oFld:aDialogs[ 3 ] ;
      RESOURCE "DotChart16" ;
      NOBORDER ;
      TOOLTIP  "Gráfico de puntos" ;
      ACTION   ( oGraph:SetType( GRAPH_TYPE_POINT ) )

   REDEFINE BTNBMP ;
      ID       104 ;
      OF       oFld:aDialogs[ 3 ] ;
      RESOURCE "PieChart16" ;
      NOBORDER ;
      TOOLTIP  "Gráfico combinado" ;
      ACTION   ( oGraph:SetType( GRAPH_TYPE_PIE ) )

   REDEFINE BTNBMP ;
      ID       105 ;
      OF       oFld:aDialogs[ 3 ] ;
      RESOURCE "Chart16" ;
      NOBORDER ;
      TOOLTIP  "Gráfico combinado" ;
      ACTION   ( oGraph:SetType( GRAPH_TYPE_ALL ) )

   REDEFINE BTNBMP ;
      ID       106 ;
      OF       oFld:aDialogs[ 3 ] ;
      RESOURCE "Text3d16" ;
      NOBORDER ;
      TOOLTIP  "Gráficos en tres dimensiones" ;
      ACTION   ( oGraph:l3D :=!oGraph:l3D, oGraph:Refresh() )

   REDEFINE BTNBMP ;
      ID       107 ;
      OF       oFld:aDialogs[ 3 ] ;
      RESOURCE "Copy16" ;
      NOBORDER ;
      TOOLTIP  "Copiar el gráfico en el portapapeles" ;
      ACTION   ( oGraph:Copy2ClipBoard() )

   REDEFINE BTNBMP ;
      ID       108 ;
      OF       oFld:aDialogs[ 3 ] ;
      RESOURCE "Imp16" ;
      NOBORDER ;
      TOOLTIP  "Imprimir el gráfico" ;
      ACTION   ( GetPrtCoors( oGraph ) )

   REDEFINE BTNBMP ;
      ID       109 ;
      OF       oFld:aDialogs[ 3 ] ;
      RESOURCE "Preferences16" ;
      NOBORDER ;
      TOOLTIP  "Propiedades del gráfico" ;
      ACTION   ( GraphPropierties( oGraph ) )

   oGraph      := TGraph():ReDefine( 300, oFld:aDialogs[3] )

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

   REDEFINE BUTTON ;
      ID       306 ;
      OF       oDlg ;
      ACTION   ( LoadDatos( cCodArt, cCmbAnio, oDlg, oBrwStk, oBrwTmp, oGraph, oBrwCom, oBrwVta ) )

#ifndef __TACTIL__

   REDEFINE BUTTON ;
      ID       500 ;
      OF       oDlg ;
      ACTION   ( TInfLArt():New( "Informe detallado de documentos", , , , , , { oDbfTmp, cCmbAnio } ):Play() )

#endif

   REDEFINE BUTTON ;
      ID       501 ;
      OF       oDlg ;
      ACTION   ( oDlg:End() )

   oFld:aDialogs[2]:AddFastKey( VK_F3, {|| EditDocument( oBrwTmp ),     LoadDatos( cCodArt, cCmbAnio, oDlg, oBrwStk, oBrwTmp, oGraph, oBrwCom, oBrwVta ) } )
   oFld:aDialogs[2]:AddFastKey( VK_F4, {|| DeleteDocument( oBrwTmp ),   LoadDatos( cCodArt, cCmbAnio, oDlg, oBrwStk, oBrwTmp, oGraph, oBrwCom, oBrwVta ) } )

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

   oMenu:End()

   ( dbfArticulo )->( OrdSetFocus( nOrd ) )
   ( dbfArticulo )->( dbGoTo( nRec ) )

return nil

//---------------------------------------------------------------------------//

Static Function InitBrwVtaCli( cCodArt, oTree, dbfDiv, dbfArticulo, oBrwStk, oBrwTmp, oDlg, nYear, oGraph, oBrwCom, oBrwVta )

   oTreeImageList := TImageList():New( 16, 16 )

   oTreeImageList:AddMasked( TBitmap():Define( "Cube_yellow_16" ),                  Rgb( 255, 0, 255 ) )
   oTreeImageList:AddMasked( TBitmap():Define( "Clipboard_empty_businessman_16" ),  Rgb( 255, 0, 255 ) )
   oTreeImageList:AddMasked( TBitmap():Define( "Document_plain_businessman_16" ),   Rgb( 255, 0, 255 ) )
   oTreeImageList:AddMasked( TBitmap():Define( "Document_businessman_16" ),         Rgb( 255, 0, 255 ) )
   oTreeImageList:AddMasked( TBitmap():Define( "Notebook_user1_16" ),               Rgb( 255, 0, 255 ) )
   oTreeImageList:AddMasked( TBitmap():Define( "Clipboard_empty_user1_16" ),        Rgb( 255, 0, 255 ) )
   oTreeImageList:AddMasked( TBitmap():Define( "Document_plain_user1_16" ),         Rgb( 255, 0, 255 ) )
   oTreeImageList:AddMasked( TBitmap():Define( "Document_user1_16" ),               Rgb( 255, 0, 255 ) )
   oTreeImageList:AddMasked( TBitmap():Define( "Document_delete_16" ),              Rgb( 255, 0, 255 ) )
   oTreeImageList:AddMasked( TBitmap():Define( "Cashier_user1_16" ),                Rgb( 255, 0, 255 ) )
   oTreeImageList:AddMasked( TBitmap():Define( "ChgPre16" ),                        Rgb( 255, 0, 255 ) )
   oTreeImageList:AddMasked( TBitmap():Define( "Truck_red_16" ),                    Rgb( 255, 0, 255 ) )
   oTreeImageList:AddMasked( TBitmap():Define( "Package_16" ),                      Rgb( 255, 0, 255 ) )
   oTreeImageList:AddMasked( TBitmap():Define( "Worker2_Form_Red_16" ),             Rgb( 255, 0, 255 ) )
   oTreeImageList:AddMasked( TBitmap():Define( "Document_navigate_cross_16" ),      Rgb( 255, 0, 255 ) )

   oTree:SetImageList( oTreeImageList )

   oTreeDocument     := oTree:Add( "Todos los documentos", 0 )

   oTreeCompras      := oTreeDocument:Add( "Compras", 11 )

   oTreeDocument:Add( cTextDocument( MOV_ALM ), 12 )

   oTreeProduccion   := oTreeDocument:Add( "Producción", 13 )

   oTreeVentas       := oTreeDocument:Add( "Ventas", 10 )

   oTreeStock        := oTreeDocument:Add( "Stock", 12 )

      oTreeCompras:Add( cTextDocument( PED_PRV ), 1 )
      oTreeCompras:Add( cTextDocument( ALB_PRV ), 2 )
      oTreeCompras:Add( cTextDocument( FAC_PRV ), 3 )
      oTreeCompras:Add( cTextDocument( RCT_PRV ), 14 )

      oTreeProduccion:Add( cTextDocument( PRO_LIN ), 13 )
      oTreeProduccion:Add( cTextDocument( PRO_MAT ), 13 )

      oTreeVentas:Add( cTextDocument( PRE_CLI ), 4 )
      oTreeVentas:Add( cTextDocument( PED_CLI ), 5 )
      oTreeVentas:Add( cTextDocument( ALB_CLI ), 6 )
      oTreeVentas:Add( cTextDocument( FAC_CLI ), 7 )
      oTreeVentas:Add( cTextDocument( FAC_REC ), 8 )
      oTreeVentas:Add( cTextDocument( TIK_CLI ), 9 )
      oTreeVentas:Add( cTextDocument( DEV_CLI ), 9 )
      oTreeVentas:Add( cTextDocument( VAL_CLI ), 9 )
      oTreeVentas:Add( cTextDocument( APT_CLI ), 9 )

      oTreeStock:Add( "Compras ", 11 )
      oTreeStock:Add( "Movimientos ", 12 )
      oTreeStock:Add( "Ventas ", 10 )
      oTreeStock:Add( "Producción ", 13 )

   oTreeDocument:Expand()
   oTreeCompras:Expand()
   oTreeVentas:Expand()
   oTreeStock:Expand()
   oTreeProduccion:Expand()

   MENU oMenu

      MENUITEM    "&1. Rotor"

         MENU

         MENUITEM    "&1. Añadir pedido a proveedor";
            MESSAGE  "Añade un pedido a proveedor" ;
            RESOURCE "Clipboard_empty_businessman_16";
            ACTION   ( AppPedPrv( "", cCodArt, .f. ), LoadDatos( cCodArt, nYear, oDlg, oBrwStk, oBrwTmp, oGraph, oBrwCom, oBrwVta ) )

            MENUITEM "&2. Añadir albarán de proveedor";
            MESSAGE  "Añade un albarán de proveedor" ;
            RESOURCE "Document_plain_businessman_16";
            ACTION   ( AppAlbPrv( "", cCodArt, .f. ), LoadDatos( cCodArt, nYear, oDlg, oBrwStk, oBrwTmp, oGraph, oBrwCom, oBrwVta ) )

            MENUITEM "&3. Añadir factura de proveedor";
            MESSAGE  "Añade una factura de proveedor" ;
            RESOURCE "Document_businessman_16";
            ACTION   ( AppFacPrv( "", cCodArt, .f. ), LoadDatos( cCodArt, nYear, oDlg, oBrwStk, oBrwTmp, oGraph, oBrwCom, oBrwVta ) )

            SEPARATOR

            MENUITEM "&4. Añadir presupuesto de cliente";
            MESSAGE  "Añade un presupuesto de cliente" ;
            RESOURCE "Notebook_user1_16";
            ACTION   ( AppPreCli( "", cCodArt, .f. ), LoadDatos( cCodArt, nYear, oDlg, oBrwStk, oBrwTmp, oGraph, oBrwCom, oBrwVta ) )

            MENUITEM "&5. Añadir pedido de cliente";
            MESSAGE  "Añade un pedido de cliente" ;
            RESOURCE "Clipboard_empty_user1_16";
            ACTION   ( AppPedCli( "", cCodArt, .f. ), LoadDatos( cCodArt, nYear, oDlg, oBrwStk, oBrwTmp, oGraph, oBrwCom, oBrwVta ) )

            MENUITEM "&6. Añadir albarán de cliente";
            MESSAGE  "Añade un albarán de cliente" ;
            RESOURCE "Document_plain_user1_16";
            ACTION   ( AppAlbCli( "", cCodArt, .f. ), LoadDatos( cCodArt, nYear, oDlg, oBrwStk, oBrwTmp, oGraph, oBrwCom, oBrwVta ) )

            MENUITEM "&7. Añadir factura de cliente";
            MESSAGE  "Añade una factura de cliente" ;
            RESOURCE "Document_user1_16";
            ACTION   ( AppFacCli( "", cCodArt, .f. ), LoadDatos( cCodArt, nYear, oDlg, oBrwStk, oBrwTmp, oGraph, oBrwCom, oBrwVta ) )

            MENUITEM "&8. Añadir factura rectificativa de cliente";
            MESSAGE  "Añade una factura rectificativa de cliente" ;
            RESOURCE "Document_Delete_16";
            ACTION   ( AppFacRec( "", cCodArt, .f. ), LoadDatos( cCodArt, nYear, oDlg, oBrwStk, oBrwTmp, oGraph, oBrwCom, oBrwVta ) )

            MENUITEM "&9. Añadir tiket de cliente";
            MESSAGE  "Añade un tiket de cliente" ;
            RESOURCE "Cashier_user1_16";
            ACTION   ( AppTikCli( "", cCodArt, .f. ), LoadDatos( cCodArt, nYear, oDlg, oBrwStk, oBrwTmp, oGraph, oBrwCom, oBrwVta ) )

            SEPARATOR

            MENUITEM "&A. Añadir movimiento entre almacenes";
            MESSAGE  "Realizar un nuevo movimiento entre almacenes" ;
            RESOURCE "Pencil_Package_16";
            ACTION   ( AppMovAlm( cCodArt, 1 ), LoadDatos( cCodArt, nYear, oDlg, oBrwStk, oBrwTmp, oGraph, oBrwCom, oBrwVta ) );

            MENUITEM "&B. Añadir movimiento de regularización de almacenes simple";
            MESSAGE  "Realizar un nuevo movimiento de regularización de almacenes simple" ;
            RESOURCE "Pencil_Package_16";
            ACTION   ( AppMovAlm( cCodArt, 2 ), LoadDatos( cCodArt, nYear, oDlg, oBrwStk, oBrwTmp, oGraph, oBrwCom, oBrwVta ) );

            MENUITEM "&C. Añadir movimiento de regularización de almacenes por objetivo";
            MESSAGE  "Realizar un nuevo movimiento de regularización de almacenes por objetivo" ;
            RESOURCE "Pencil_Package_16";
            ACTION   ( AppMovAlm( cCodArt, 3 ), LoadDatos( cCodArt, nYear, oDlg, oBrwStk, oBrwTmp, oGraph, oBrwCom, oBrwVta ) );

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
   local nActStk     := 0
   local nResStk     := 0
   local nEntStk     := 0
   local nStkLib     := 0
   local nTotStkPro  := 0
   local nTotStkCon  := 0

   nStkAlm           := 0

   oDlg:Disable()

   CursorWait()
   /*
   oBlock            := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE
   */
   /*
   Calculamos el stock---------------------------------------------------------
   */

   oStock:aStockArticulo( cCodArt, , oBrwStk )

   oMsgProgress()
   oMsgProgress():SetRange( 0, 17 )

   /*
   Calculos de compras---------------------------------------------------------
   */

   oMsgText( "Calculando compras mensuales" )

   aTotCom[1]        := 0
   aTotCom[2]        := 0
   aTotCom[3]        := 0
   aTotCom[4]        := 0
   aTotCom[5]        := 0

   nCompras( cCodArt, dbfAlbPrvT, dbfAlbPrvL, dbfFacPrvT, dbfFacPrvL, if( nYear == "Todos", nil, Val( nYear ) ) )

   oMsgProgress():Deltapos(1)

   for n := 1 to 12

      aTotCom[1]     += aCom[n,1]
      aTotCom[2]     += aCom[n,2]
      aTotCom[3]     += aCom[n,3]

   next

   /*
   Calculos producción---------------------------------------------------------
   */

   oMsgText( "Calculando produccion mensual" )

   nProduccion( cCodArt, dbfProducT, dbfProducL, dbfProducM, if( nYear == "Todos", nil, Val( nYear ) ) )

   oMsgProgress():Deltapos(1)

   for n := 1 to 12
      nTotStkPro     += aProducido[ n, 2 ]
      nTotStkCon     += aConsumido[ n, 2 ]
   next

   /*
   Calculos de ventas----------------------------------------------------------
   */

   oMsgText( "Calculando ventas mensuales" )

   aTotVta[1]        := 0
   aTotVta[2]        := 0
   aTotVta[3]        := 0
   aTotVta[4]        := 0
   aTotVta[5]        := 0

   nVentas( cCodArt, dbfAlbCliT, dbfAlbCliL, dbfFacCliT, dbfFacCliL, dbfFacRecT, dbfFacRecL, dbfTikCliT, dbfTikCliL, if( nYear == "Todos", nil, Val( nYear ) ) )

   oMsgProgress():Deltapos(1)

   for n := 1 to 12

      aTotVta[1]     += aVta[n,1]
      aTotVta[2]     += aVta[n,2]
      aTotVta[3]     += aVta[n,3]
      aTotVta[5]     += aVta[n,4]

   next

   oMsgText( "Calculando media de compras" )

   if aTotCom[2] != 0
      aTotCom[4]     := aTotCom[3] / aTotCom[2]
   end if

   oMsgProgress():Deltapos(1)

   oMsgText( "Calculando media de ventas" )

   if aTotVta[2] != 0
      aTotVta[4]     := aTotVta[3] / aTotVta[2]
   end if

   oMsgProgress():Deltapos(1)

   oMsgText( "Calculando rentabilidad" )
   aTotCom[ 5 ]      := ( aTotVta[ 3 ] ) - ( aTotVta[ 2 ] * aTotCom[ 4 ] )

   oMsgProgress():Deltapos( 1 )

   /*
   Cargamos los datos en la temporal-------------------------------------------
   */

   oDbfTmp:Zap()

   oMsgText( "Cargando los documentos" )

   LoadPedidoProveedor( cCodArt, if( nYear == "Todos", nil, Val( nYear ) ) )
   oMsgProgress():Deltapos(1)

   LoadAlbaranProveedor( cCodArt, if( nYear == "Todos", nil, Val( nYear ) ) )
   oMsgProgress():Deltapos(1)

   LoadFacturaProveedor( cCodArt, if( nYear == "Todos", nil, Val( nYear ) ) )
   oMsgProgress():Deltapos(1)

   LoadRectificativaProveedor( cCodArt, if( nYear == "Todos", nil, Val( nYear ) ) )
   oMsgProgress():Deltapos(1)

   LoadPresupuestoCliente( cCodArt, if( nYear == "Todos", nil, Val( nYear ) ) )
   oMsgProgress():Deltapos(1)

   LoadPedidosCliente( cCodArt, if( nYear == "Todos", nil, Val( nYear ) ) )
   oMsgProgress():Deltapos(1)

   LoadAlbaranesCliente( cCodArt, if( nYear == "Todos", nil, Val( nYear ) ) )
   oMsgProgress():Deltapos(1)

   LoadFacturasCliente( cCodArt, if( nYear == "Todos", nil, Val( nYear ) ) )
   oMsgProgress():Deltapos(1)

   LoadFacturasRectificativas( cCodArt, if( nYear == "Todos", nil, Val( nYear ) ) )
   oMsgProgress():Deltapos(1)

   LoadTiketsCliente( cCodArt, if( nYear == "Todos", nil, Val( nYear ) ) )
   oMsgProgress():Deltapos(1)

   LoadMovimientosAlmacen( cCodArt, if( nYear == "Todos", nil, Val( nYear ) ) )
   oMsgProgress():Deltapos(1)

   LoadProduccion( cCodArt, if( nYear == "Todos", nil, Val( nYear ) ) )
   oMsgProgress():Deltapos(1)

   oDbfTmp:GoTop()

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

   oGraph:cTitle     := "Evolución anual de ventas"
   oGraph:lcTitle    := .f.
   oGraph:nClrT      := Rgb( 55, 55, 55)
   oGraph:nClrX      := CLR_BLUE
   oGraph:nClrY      := CLR_RED
   oGraph:cPicture   := cPorDiv

   oGraph:Refresh()

   oMsgText()

   EndProgress()
   /*
   RECOVER USING oError

      msgStop( "Imposible cargar datos" + CRLF + ErrorMessage( oError ) )

   END SEQUENCE
   ErrorBlock( oBlock )
   */
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

   if Len( aEmpGrp() ) != 0

      for each cCodEmp in aEmpGrp()

         if cCodEmp == cCodEmp()

            nTotAlbCom( cCodArt, dbfAlbPrvT, dbfAlbPrvL, nYear )

            nTotFacCom( cCodArt, dbfFacPrvT, dbfFacPrvL, nYear )

            nTotRctCom( cCodArt, dbfRctPrvT, dbfRctPrvL, nYear )

         else

            USE ( cPatStk( cCodEmp ) + "ALBPROVT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ALBPROVT", @dbfAlbEmpT ) )
            SET ADSINDEX TO ( cPatStk( cCodEmp ) + "ALBPROVT.CDX" ) ADDITIVE

            USE ( cPatStk( cCodEmp ) + "ALBPROVL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ALBPROVL", @dbfAlbEmpL ) )
            SET ADSINDEX TO ( cPatStk( cCodEmp ) + "ALBPROVL.CDX" ) ADDITIVE
            SET TAG TO "CREF"

            USE ( cPatStk( cCodEmp ) + "FACPRVT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FACPRVT", @dbfFacEmpT ) )
            SET ADSINDEX TO ( cPatStk( cCodEmp ) + "FACPRVT.CDX" ) ADDITIVE

            USE ( cPatStk( cCodEmp ) + "FACPRVL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FACPRVL", @dbfFacEmpL ) )
            SET ADSINDEX TO ( cPatStk( cCodEmp ) + "FACPRVL.CDX" ) ADDITIVE
            SET TAG TO "CREF"

            USE ( cPatStk( cCodEmp ) + "RctPrvT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "RctPrvL", @dbfRctEmpT ) )
            SET ADSINDEX TO ( cPatStk( cCodEmp ) + "RctPrvT.CDX" ) ADDITIVE

            USE ( cPatStk( cCodEmp ) + "RctPrvL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "RctPrvL", @dbfRctEmpL ) )
            SET ADSINDEX TO ( cPatStk( cCodEmp ) + "RctPrvL.CDX" ) ADDITIVE
            SET TAG TO "cRef"

            nTotAlbCom( cCodArt, dbfAlbEmpT, dbfAlbEmpL, nYear )

            nTotFacCom( cCodArt, dbfFacEmpT, dbfFacEmpL, nYear )

            nTotRctCom( cCodArt, dbfRctEmpT, dbfRctEmpL, nYear )

            CLOSE( dbfAlbEmpT )
            CLOSE( dbfAlbEmpL )
            CLOSE( dbfFacEmpT )
            CLOSE( dbfFacEmpL )
            CLOSE( dbfRctEmpT )
            CLOSE( dbfRctEmpL )

         end if

      next

   end if

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

static function nVentas( cCodArt, dbfAlbCliT, dbfAlbCliL, dbfFacCliT, dbfFacCliL, dbfFacRecT, dbfFacRecL, dbfTikCliT, dbfTikCliL, nYear )

   local cCodEmp
   local dbfAlbEmpT
   local dbfAlbEmpL
   local dbfFacEmpT
   local dbfFacEmpL
   local dbfTikEmpT
   local dbfTikEmpL
   local dbfFacRecEmpT
   local dbfFacRecEmpL

   aEval( aVta, {|a| Afill( a, 0 ) } )

   if Len( aEmpGrp() ) != 0

      for each cCodEmp in aEmpGrp()

         if cCodEmp == cCodEmp()

            nTotAlbVta( cCodArt, dbfAlbCliT, dbfAlbCliL, nYear )
            nTotFacVta( cCodArt, dbfFacCliT, dbfFacCliL, nYear )
            nTotRecVta( cCodArt, dbfFacRecT, dbfFacRecL, nYear )
            nTotTikVta( cCodArt, dbfTikCliT, dbfTikCliL, nYear )

         else

            USE ( cPatStk( cCodEmp ) + "ALBCLIT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ALBCLIT", @dbfAlbEmpT ) )
            SET ADSINDEX TO ( cPatStk( cCodEmp ) + "ALBCLIT.CDX" ) ADDITIVE

            USE ( cPatStk( cCodEmp ) + "ALBCLIL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ALBCLIL", @dbfAlbEmpL ) )
            SET ADSINDEX TO ( cPatStk( cCodEmp ) + "ALBCLIL.CDX" ) ADDITIVE
            SET TAG TO "CREF"

            USE ( cPatStk( cCodEmp ) + "FACCLIT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FACCLIT", @dbfFacEmpT ) )
            SET ADSINDEX TO ( cPatStk( cCodEmp ) + "FACCLIT.CDX" ) ADDITIVE

            USE ( cPatStk( cCodEmp ) + "FACCLIL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FACCLIL", @dbfFacEmpL ) )
            SET ADSINDEX TO ( cPatStk( cCodEmp ) + "FACCLIL.CDX" ) ADDITIVE
            SET TAG TO "CREF"

            USE ( cPatStk( cCodEmp ) + "FACRECT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FACRECT", @dbfFacRecEmpT ) )
            SET ADSINDEX TO ( cPatStk( cCodEmp ) + "FACRECT.CDX" ) ADDITIVE

            USE ( cPatStk( cCodEmp ) + "FACRECL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FACRECL", @dbfFacRecEmpL ) )
            SET ADSINDEX TO ( cPatStk( cCodEmp ) + "FACRECL.CDX" ) ADDITIVE
            SET TAG TO "CREF"

            USE ( cPatStk( cCodEmp ) + "TIKET.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "TIKET", @dbfTikEmpT ) )
            SET ADSINDEX TO ( cPatStk( cCodEmp ) + "TIKET.CDX" ) ADDITIVE

            USE ( cPatStk( cCodEmp ) + "TIKEL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "TIKEL", @dbfTikEmpL ) )
            SET ADSINDEX TO ( cPatStk( cCodEmp ) + "TIKEL.CDX" ) ADDITIVE
            SET TAG TO "CCBATIL"

            nTotAlbVta( cCodArt, dbfAlbEmpT, dbfAlbEmpL, nYear )
            nTotFacVta( cCodArt, dbfFacEmpT, dbfFacEmpL, nYear )
            nTotRecVta( cCodArt, dbfFacRecEmpT, dbfFacRecEmpL, nYear )
            nTotTikVta( cCodArt, dbfTikEmpT, dbfTikEmpL, nYear )

            CLOSE( dbfAlbEmpT )
            CLOSE( dbfAlbEmpL )
            CLOSE( dbfFacEmpT )
            CLOSE( dbfFacEmpL )
            CLOSE( dbfFacRecEmpT )
            CLOSE( dbfFacRecEmpL )
            CLOSE( dbfTikEmpT )
            CLOSE( dbfTikEmpL )

         end if

      next

   end if

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

            if !( dbfAlbCliT )->lFacturado .and. ( nYear == nil .or. Year( ( dbfAlbCliT )->dFecAlb ) == nYear )

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
/*
Total unidades del movimiento de almacén
*/

static function nStkAlm( cCodArt, dbfMovAlm, nYear )

   local nPos
   local nUndAlm  := 0

   /*
   Movimientos de almacén
   */

   if ( dbfMovAlm )->( dbSeek( cCodArt ) )

      while ( dbfMovAlm )->cRefMov == cCodArt .and. !( dbfMovAlm )->( eof() )

         if nYear == nil .or. Year( ( dbfMovAlm )->dFecMov ) == nYear

            if !Empty( ( dbfMovAlm )->cAliMov ) .and. !( dbfMovAlm )->lNoStk

               nUndAlm   += nTotNMovAlm( dbfMovAlm )

            end if

            if !Empty( ( dbfMovAlm )->cAloMov ) .and. !( dbfMovAlm )->lNoStk

               nUndAlm   -= nTotNMovAlm( dbfMovAlm )

            end if

         end if

         SysRefresh()

         ( dbfMovAlm )->( dbSkip() )

      end while

   end if

return nUndAlm

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
            oDbfTmp:cEstDoc   := aEstadoPedido[ Max( RetFld( ( dbfPedPrvL )->cSerPed + Str( ( dbfPedPrvL )->nNumPed ) + ( dbfPedPrvL )->cSufPed, dbfPedPrvT, "nEstado" ), 1 ) ]
            oDbfTmp:dFecDoc   := dFecPedPrv( ( dbfPedPrvL )->cSerPed + Str( ( dbfPedPrvL )->nNumPed ) + ( dbfPedPrvL )->cSufPed, dbfPedPrvT )
            oDbfTmp:cCodDoc   := RetFld( ( dbfPedPrvL )->cSerPed + Str( ( dbfPedPrvL )->nNumPed ) + ( dbfPedPrvL )->cSufPed, dbfPedPrvT, "cCodPrv" )
            oDbfTmp:cNomDoc   := cNbrPedPrv( ( dbfPedPrvL )->cSerPed + Str( ( dbfPedPrvL )->nNumPed ) + ( dbfPedPrvL )->cSufPed, dbfPedPrvT )
            oDbfTmp:cRef      := ( dbfPedPrvL )->cRef
            oDbfTmp:cValPr1   := ( dbfPedPrvL )->cValPr1
            oDbfTmp:cValPr2   := ( dbfPedPrvL )->cValPr2
            oDbfTmp:cLote     := ( dbfPedPrvL )->cLote
            oDbfTmp:cAlmDoc   := ( dbfPedPrvL )->cAlmLin
            oDbfTmp:nUndDoc   := nTotNPedPrv( dbfPedPrvL )
            oDbfTmp:nFacCnv   := ( dbfPedPrvL )->nFacCnv
            oDbfTmp:nImpDoc   := nTotUPedPrv( dbfPedPrvL, nDinDiv )
            oDbfTmp:nDtoDoc   := ( dbfPedPrvL )->nDtoLin
            oDbfTmp:nTotDoc   := nTotLPedPrv( dbfPedPrvL, nDinDiv, nDirDiv )
            oDbfTmp:Save()

         end if

         SysRefresh()
         ( dbfPedPrvL )->( dbSkip() )

      end while
   end if

Return nil

//---------------------------------------------------------------------------//
/*Carga los albaranes de proveedor*/

Static Function LoadAlbaranProveedor( cCodArt, nYear )

   if ( dbfAlbPrvL )->( dbSeek( cCodArt ) )
      while ( dbfAlbPrvL )->cRef == cCodArt .and. !( dbfAlbPrvL )->( eof() )

         if nYear == nil .or. Year( dFecAlbPrv( ( dbfAlbPrvL )->cSerAlb + Str( ( dbfAlbPrvL )->nNumAlb ) + ( dbfAlbPrvL )->cSufAlb, dbfAlbPrvT ) ) == nYear

            oDbfTmp:Append()
            oDbfTmp:nTypDoc   := ALB_PRV
            oDbfTmp:cNumDoc   := ( dbfAlbPrvL )->cSerAlb + Str( ( dbfAlbPrvL )->nNumAlb ) + ( dbfAlbPrvL )->cSufAlb
            oDbfTmp:cEstDoc   := if( RetFld( ( dbfAlbPrvL )->cSerAlb + Str( ( dbfAlbPrvL )->nNumAlb ) + ( dbfAlbPrvL )->cSufAlb, dbfAlbPrvT, "lFacturado" ), "Facturado", "No facturado" )
            oDbfTmp:dFecDoc   := dFecAlbPrv( ( dbfAlbPrvL )->cSerAlb + Str( ( dbfAlbPrvL )->nNumAlb ) + ( dbfAlbPrvL )->cSufAlb, dbfAlbPrvT )
            oDbfTmp:cCodDoc   := RetFld( ( dbfAlbPrvL )->cSerAlb + Str( ( dbfAlbPrvL )->nNumAlb ) + ( dbfAlbPrvL )->cSufAlb, dbfAlbPrvT, "cCodPrv" )
            oDbfTmp:cNomDoc   := cNbrAlbPrv( ( dbfAlbPrvL )->cSerAlb + Str( ( dbfAlbPrvL )->nNumAlb ) + ( dbfAlbPrvL )->cSufAlb, dbfAlbPrvT )
            oDbfTmp:lFacturado:= RetFld( ( dbfAlbPrvL )->cSerAlb + Str( ( dbfAlbPrvL )->nNumAlb ) + ( dbfAlbPrvL )->cSufAlb, dbfAlbPrvT, "lFacturado" )
            oDbfTmp:cRef      := ( dbfAlbPrvL )->cRef
            oDbfTmp:cValPr1   := ( dbfAlbPrvL )->cValPr1
            oDbfTmp:cValPr2   := ( dbfAlbPrvL )->cValPr2
            oDbfTmp:cLote     := ( dbfAlbPrvL )->cLote
            oDbfTmp:cAlmDoc   := ( dbfAlbPrvL )->cAlmLin
            oDbfTmp:nUndDoc   := nTotNAlbPrv( dbfAlbPrvL )
            oDbfTmp:nFacCnv   := ( dbfAlbPrvL )->nFacCnv
            oDbfTmp:nImpDoc   := nTotUAlbPrv( dbfAlbPrvL, nDinDiv )
            oDbfTmp:nDtoDoc   := ( dbfAlbPrvL )->nDtoLin
            oDbfTmp:nTotDoc   := nTotLAlbPrv( dbfAlbPrvL, nDinDiv, nDirDiv )
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
            oDbfTmp:cEstDoc   := aEstadoFactura[ nEstFacPrv( ( dbfFacPrvL )->cSerFac + Str( ( dbfFacPrvL )->nNumFac ) + ( dbfFacPrvL )->cSufFac, dbfFacPrvT, dbfFacPrvP ) ]
            oDbfTmp:dFecDoc   := dFecFacPrv( ( dbfFacPrvL )->cSerFac + Str( ( dbfFacPrvL )->nNumFac ) + ( dbfFacPrvL )->cSufFac, dbfFacPrvT )
            oDbfTmp:cCodDoc   := RetFld( ( dbfFacPrvL )->cSerFac + Str( ( dbfFacPrvL )->nNumFac ) + ( dbfFacPrvL )->cSufFac, dbfFacPrvT, "cCodPrv" )
            oDbfTmp:cNomDoc   := cNbrFacPrv( ( dbfFacPrvL )->cSerFac + Str( ( dbfFacPrvL )->nNumFac ) + ( dbfFacPrvL )->cSufFac, dbfFacPrvT )
            oDbfTmp:lFacturado:= .f.
            oDbfTmp:cRef      := ( dbfFacPrvL )->cRef
            oDbfTmp:cValPr1   := ( dbfFacPrvL )->cValPr1
            oDbfTmp:cValPr2   := ( dbfFacPrvL )->cValPr2
            oDbfTmp:cLote     := ( dbfFacPrvL )->cLote
            oDbfTmp:cAlmDoc   := ( dbfFacPrvL )->cAlmLin
            oDbfTmp:nUndDoc   := nTotNFacPrv( dbfFacPrvL )
            oDbfTmp:nFacCnv   := ( dbfFacPrvL )->nFacCnv
            oDbfTmp:nImpDoc   := nTotUFacPrv( dbfFacPrvL, nDinDiv )
            oDbfTmp:nDtoDoc   := ( dbfFacPrvL )->nDtoLin
            oDbfTmp:nTotDoc   := nTotLFacPrv( dbfFacPrvL, nDinDiv, nDirDiv )
            oDbfTmp:Save()

         end if

         SysRefresh()
         ( dbfFacPrvL )->( dbSkip() )

      end while
   end if

Return nil

//---------------------------------------------------------------------------//

Static Function LoadrectificativaProveedor( cCodArt, nYear )

   local aEstadoFactura    := { "Pagada", "Parcialmente", "Pendiente" }

   if ( dbfRctPrvL )->( dbSeek( cCodArt ) )
      while ( dbfRctPrvL )->cRef == cCodArt .and. !( dbfRctPrvL )->( eof() )

         if nYear == nil .or. Year( dFecRctPrv( ( dbfRctPrvL )->cSerFac + Str( ( dbfRctPrvL )->nNumFac ) + ( dbfRctPrvL )->cSufFac, dbfRctPrvT ) ) == nYear

            oDbfTmp:Append()
            oDbfTmp:nTypDoc   := RCT_PRV
            oDbfTmp:cNumDoc   := ( dbfRctPrvL )->cSerFac + Str( ( dbfRctPrvL )->nNumFac ) + ( dbfRctPrvL )->cSufFac
            oDbfTmp:cEstDoc   := aEstadoFactura[ nEstRctPrv( ( dbfRctPrvL )->cSerFac + Str( ( dbfRctPrvL )->nNumFac ) + ( dbfRctPrvL )->cSufFac, dbfRctPrvT, dbfFacPrvP ) ]
            oDbfTmp:dFecDoc   := dFecRctPrv( ( dbfRctPrvL )->cSerFac + Str( ( dbfRctPrvL )->nNumFac ) + ( dbfRctPrvL )->cSufFac, dbfRctPrvT )
            oDbfTmp:cCodDoc   := RetFld( ( dbfRctPrvL )->cSerFac + Str( ( dbfRctPrvL )->nNumFac ) + ( dbfRctPrvL )->cSufFac, dbfRctPrvT, "cCodPrv" )
            oDbfTmp:cNomDoc   := cNbrRctPrv( ( dbfRctPrvL )->cSerFac + Str( ( dbfRctPrvL )->nNumFac ) + ( dbfRctPrvL )->cSufFac, dbfRctPrvT )
            oDbfTmp:lFacturado:= .f.
            oDbfTmp:cRef      := ( dbfRctPrvL )->cRef
            oDbfTmp:cValPr1   := ( dbfRctPrvL )->cValPr1
            oDbfTmp:cValPr2   := ( dbfRctPrvL )->cValPr2
            oDbfTmp:cLote     := ( dbfRctPrvL )->cLote
            oDbfTmp:cAlmDoc   := ( dbfRctPrvL )->cAlmLin
            oDbfTmp:nUndDoc   := nTotNRctPrv( dbfRctPrvL )
            oDbfTmp:nFacCnv   := ( dbfRctPrvL )->nFacCnv
            oDbfTmp:nImpDoc   := nTotURctPrv( dbfRctPrvL, nDinDiv )
            oDbfTmp:nDtoDoc   := ( dbfRctPrvL )->nDtoLin
            oDbfTmp:nTotDoc   := nTotLRctPrv( dbfRctPrvL, nDinDiv, nDirDiv )
            oDbfTmp:Save()

         end if

         SysRefresh()
         ( dbfRctPrvL )->( dbSkip() )

      end while
   end if

Return nil

//---------------------------------------------------------------------------//
/*
Carga los presupuestos de clientes a la temporal
*/

Static Function LoadPresupuestoCliente( cCodArt, nYear )

   if ( dbfPreCliL )->( dbSeek( cCodArt ) )
      while ( dbfPreCliL )->cRef == cCodArt .and. !( dbfPreCliL )->( eof() )

         if nYear == nil .or. Year( dFecPreCli( ( dbfPreCliL )->cSerPre + Str( ( dbfPreCliL )->nNumPre ) + ( dbfPreCliL )->cSufPre, dbfPreCliT ) ) == nYear

            oDbfTmp:Append()
            oDbfTmp:nTypDoc   := PRE_CLI
            oDbfTmp:cNumDoc   := ( dbfPreCliL )->cSerPre + Str( ( dbfPreCliL )->nNumPre ) + ( dbfPreCliL )->cSufPre
            oDbfTmp:cEstDoc   := if( RetFld( ( dbfPreCliL )->cSerPre + Str( ( dbfPreCliL )->nNumPre ) + ( dbfPreCliL )->cSufPre, dbfPreCliT, "lEstado" ), "Aprobado", "Pendiente" )
            oDbfTmp:dFecDoc   := dFecPreCli( ( dbfPreCliL )->cSerPre + Str( ( dbfPreCliL )->nNumPre ) + ( dbfPreCliL )->cSufPre, dbfPreCliT )
            oDbfTmp:cCodDoc   := RetFld( ( dbfPreCliL )->cSerPre + Str( ( dbfPreCliL )->nNumPre ) + ( dbfPreCliL )->cSufPre, dbfPreCliT, "cCodCli" )
            oDbfTmp:cNomDoc   := cNbrPreCli( ( dbfPreCliL )->cSerPre + Str( ( dbfPreCliL )->nNumPre ) + ( dbfPreCliL )->cSufPre, dbfPreCliT )
            oDbfTmp:cRef      := ( dbfPreCliL )->cRef
            oDbfTmp:cValPr1   := ( dbfPreCliL )->cValPr1
            oDbfTmp:cValPr2   := ( dbfPreCliL )->cValPr2
            oDbfTmp:cLote     := ( dbfPreCliL )->cLote
            oDbfTmp:cAlmDoc   := ( dbfPreCliL )->cAlmLin
            oDbfTmp:nUndDoc   := - nTotNPreCli( dbfPreCliL )
            oDbfTmp:nFacCnv   := ( dbfPreCliL )->nFacCnv
            oDbfTmp:nImpDoc   := nTotUPreCli( dbfPreCliL, nDouDiv )
            oDbfTmp:nDtoDoc   := ( dbfPreCliL )->nDto
            oDbfTmp:nTotDoc   := nTotLPreCli( dbfPreCliT, dbfPreCliL, nDouDiv, nDorDiv )
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
            oDbfTmp:cEstDoc   := aEstadoPedido[ Max( RetFld( ( dbfPedCliL )->cSerPed + Str( ( dbfPedCliL )->nNumPed ) + ( dbfPedCliL )->cSufPed, dbfPedCliT, "nEstado" ), 1 ) ]
            oDbfTmp:dFecDoc   := dFecPedCli( ( dbfPedCliL )->cSerPed + Str( ( dbfPedCliL )->nNumPed ) + ( dbfPedCliL )->cSufPed, dbfPedCliT )
            oDbfTmp:cCodDoc   := RetFld( ( dbfPedCliL )->cSerPed + Str( ( dbfPedCliL )->nNumPed ) + ( dbfPedCliL )->cSufPed, dbfPedCliT, "cCodCli" )
            oDbfTmp:cNomDoc   := cNbrPedCli( ( dbfPedCliL )->cSerPed + Str( ( dbfPedCliL )->nNumPed ) + ( dbfPedCliL )->cSufPed, dbfPedCliT )
            oDbfTmp:cRef      := ( dbfPedCliL )->cRef
            oDbfTmp:cValPr1   := ( dbfPedCliL )->cValPr1
            oDbfTmp:cValPr2   := ( dbfPedCliL )->cValPr2
            oDbfTmp:cLote     := ( dbfPedCliL )->cLote
            oDbfTmp:cAlmDoc   := ( dbfPedCliL )->cAlmLin
            oDbfTmp:nUndDoc   := - nTotNPedCli( dbfPedCliL )
            oDbfTmp:nFacCnv   := ( dbfPedCliL )->nFacCnv
            oDbfTmp:nImpDoc   := nTotUPedCli( dbfPedCliL, nDouDiv )
            oDbfTmp:nDtoDoc   := ( dbfPedCliL )->nDto
            oDbfTmp:nTotDoc   := nTotLPedCli( dbfPedCliL, nDouDiv, nDorDiv )
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
            oDbfTmp:cEstDoc   := if( RetFld( ( dbfAlbCliL )->cSerAlb + Str( ( dbfAlbCliL )->nNumAlb ) + ( dbfAlbCliL )->cSufAlb, dbfAlbCliT, "lFacturado" ), "Facturado", "No facturado" )
            oDbfTmp:dFecDoc   := dFecAlbCli( ( dbfAlbCliL )->cSerAlb + Str( ( dbfAlbCliL )->nNumAlb ) + ( dbfAlbCliL )->cSufAlb, dbfAlbCliT )
            oDbfTmp:cCodDoc   := RetFld( ( dbfAlbCliL )->cSerAlb + Str( ( dbfAlbCliL )->nNumAlb ) + ( dbfAlbCliL )->cSufAlb, dbfAlbCliT, "cCodCli" )
            oDbfTmp:cNomDoc   := RetFld( ( dbfAlbCliL )->cSerAlb + Str( ( dbfAlbCliL )->nNumAlb ) + ( dbfAlbCliL )->cSufAlb, dbfAlbCliT, "cNomCli" )
            oDbfTmp:lFacturado:= RetFld( ( dbfAlbCliL )->cSerAlb + Str( ( dbfAlbCliL )->nNumAlb ) + ( dbfAlbCliL )->cSufAlb, dbfAlbCliT, "lFacturado" )
            oDbfTmp:cRef      := ( dbfAlbCliL )->cRef
            oDbfTmp:cValPr1   := ( dbfAlbCliL )->cValPr1
            oDbfTmp:cValPr2   := ( dbfAlbCliL )->cValPr2
            oDbfTmp:cLote     := ( dbfAlbCliL )->cLote
            oDbfTmp:cAlmDoc   := ( dbfAlbCliL )->cAlmLin
            oDbfTmp:nUndDoc   := - nTotNAlbCli( dbfAlbCliL )
            oDbfTmp:nFacCnv   := ( dbfAlbCliL )->nFacCnv
            oDbfTmp:nImpDoc   := nTotUAlbCli( dbfAlbCliL, nDouDiv )
            oDbfTmp:nDtoDoc   := ( dbfAlbCliL )->nDto
            oDbfTmp:nTotDoc   := nTotLAlbCli( dbfAlbCliL, nDouDiv, nDorDiv )
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
            oDbfTmp:cEstDoc   := aEstadoFactura[ nChkPagFacCli( ( dbfFacCliL )->cSerie + Str( ( dbfFacCliL )->nNumFac ) + ( dbfFacCliL )->cSufFac, dbfFacCliT, dbfFacCliP ) ]
            oDbfTmp:dFecDoc   := dFecFacCli( ( dbfFacCliL )->cSerie + Str( ( dbfFacCliL )->nNumFac ) + ( dbfFacCliL )->cSufFac, dbfFacCliT )
            oDbfTmp:cCodDoc   := RetFld( ( dbfFacCliL )->cSerie + Str( ( dbfFacCliL )->nNumFac ) + ( dbfFacCliL )->cSufFac, dbfFacCliT, "cCodCli" )
            oDbfTmp:cNomDoc   := RetFld( ( dbfFacCliL )->cSerie + Str( ( dbfFacCliL )->nNumFac ) + ( dbfFacCliL )->cSufFac, dbfFacCliT, "cNomCli" )
            oDbfTmp:lFacturado:= .f.
            oDbfTmp:cRef      := ( dbfFacCliL )->cRef
            oDbfTmp:cValPr1   := ( dbfFacCliL )->cValPr1
            oDbfTmp:cValPr2   := ( dbfFacCliL )->cValPr2
            oDbfTmp:cLote     := ( dbfFacCliL )->cLote
            oDbfTmp:cAlmDoc   := ( dbfFacCliL )->cAlmLin
            oDbfTmp:nUndDoc   := - nTotNFacCli( dbfFacCliL )
            oDbfTmp:nFacCnv   := ( dbfFacCliL )->nFacCnv
            oDbfTmp:nImpDoc   := nImpUFacCli( dbfFacCliT, dbfFacCliL, nDouDiv )
            oDbfTmp:nDtoDoc   := ( dbfFacCliL )->nDto
            oDbfTmp:nTotDoc   := nTotLFacCli( dbfFacCliL, nDouDiv, nDorDiv )
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
            oDbfTmp:cEstDoc   := ""
            oDbfTmp:dFecDoc   := dFecFacRec( ( dbfFacRecL )->cSerie + Str( ( dbfFacRecL )->nNumFac ) + ( dbfFacRecL )->cSufFac, dbfFacRecT )
            oDbfTmp:cCodDoc   := RetFld( ( dbfFacRecL )->cSerie + Str( ( dbfFacRecL )->nNumFac ) + ( dbfFacRecL )->cSufFac, dbfFacRecT, "cCodCli" )
            oDbfTmp:cNomDoc   := cNbrFacRec( ( dbfFacRecL )->cSerie + Str( ( dbfFacRecL )->nNumFac ) + ( dbfFacRecL )->cSufFac, dbfFacRecT )
            oDbfTmp:cRef      := ( dbfFacRecL )->cRef
            oDbfTmp:cValPr1   := ( dbfFacRecL )->cValPr1
            oDbfTmp:cValPr2   := ( dbfFacRecL )->cValPr2
            oDbfTmp:cLote     := ( dbfFacRecL )->cLote
            oDbfTmp:cAlmDoc   := ( dbfFacRecL )->cAlmLin
            oDbfTmp:nUndDoc   := - nTotNFacRec( dbfFacRecL )
            oDbfTmp:nFacCnv   := ( dbfFacRecL )->nFacCnv
            oDbfTmp:nImpDoc   := nImpUFacRec( dbfFacRecT, dbfFacRecL, nDouDiv )
            oDbfTmp:nDtoDoc   := ( dbfFacRecL )->nDto
            oDbfTmp:nTotDoc   := nTotLFacRec( dbfFacRecL, nDouDiv, nDorDiv )
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
                  oDbfTmp:nUndDoc      := - nTotNTikTpv( dbfTikCliL )
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
                  oDbfTmp:nUndDoc      := - nTotNTikTpv( dbfTikCliL )
                  oDbfTmp:nFacCnv      := ( dbfTikCliL )->nFacCnv

               end case

               oDbfTmp:cNumDoc         := ( dbfTikCliL )->cSerTil + ( dbfTikCliL )->cNumTil + ( dbfTikCliL )->cSufTil
               oDbfTmp:dFecDoc         := dFecTik( (dbfTikCliL)->cSerTil + (dbfTikCliL)->cNumTil + (dbfTikCliL)->cSufTil, dbfTikCliT )
               oDbfTmp:cCodDoc         := RetFld( ( dbfTikCliL )->cSerTil + ( dbfTikCliL )->cNumTil + ( dbfTikCliL )->cSufTil, dbfTikCliT, "cCliTik" )
               oDbfTmp:cNomDoc         := RetFld( ( dbfTikCliL )->cSerTil + ( dbfTikCliL )->cNumTil + ( dbfTikCliL )->cSufTil, dbfTikCliT, "cNomTik" )
               oDbfTmp:cRef            := ( dbfTikCliL )->cCbaTil
               oDbfTmp:cValPr1         := ( dbfTikCliL )->cValPr1
               oDbfTmp:cValPr2         := ( dbfTikCliL )->cValPr2
               oDbfTmp:cLote           := ( dbfTikCliL )->cLote
               oDbfTmp:cAlmDoc         := ( dbfTikCliL )->cAlmLin
               oDbfTmp:nDtoDoc         := ( dbfTikCliL )->nDtoLin
               oDbfTmp:nImpDoc         := nImpUTpv( dbfTikCliT, dbfTikCliL, nDouDiv )
               oDbfTmp:nTotDoc         := nNetLTpv( dbfTikCliL, nDouDiv )

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
               oDbfTmp:cEstDoc      := ""
               oDbfTmp:dFecDoc      := dFecTik( (dbfTikCliL)->cSerTil + (dbfTikCliL)->cNumTil + (dbfTikCliL)->cSufTil, dbfTikCliT )
               oDbfTmp:cCodDoc      := RetFld( ( dbfTikCliL )->cSerTil + ( dbfTikCliL )->cNumTil + ( dbfTikCliL )->cSufTil, dbfTikCliT, "cCliTik" )
               oDbfTmp:cNomDoc      := RetFld( ( dbfTikCliL )->cSerTil + ( dbfTikCliL )->cNumTil + ( dbfTikCliL )->cSufTil, dbfTikCliT, "cNomTik" )
               oDbfTmp:cRef         := ( dbfTikCliL )->cComTil
               oDbfTmp:cValPr1      := ( dbfTikCliL )->cValPr1
               oDbfTmp:cValPr2      := ( dbfTikCliL )->cValPr2
               oDbfTmp:cLote        := ( dbfTikCliL )->cLote
               oDbfTmp:cAlmDoc      := ( dbfTikCliL )->cAlmLin
               oDbfTmp:nUndDoc      := - nTotNTikTpv( dbfTikCliL )
               oDbfTmp:nFacCnv      := ( dbfTikCliL )->nFacCnv
               oDbfTmp:nImpDoc      := ( dbfTikCliL )->nPcmTil
               oDbfTmp:nDtoDoc      := ( dbfTikCliL )->nDtoLin
               oDbfTmp:nTotDoc      := nTotLDos( dbfTikCliL, nDouDiv, nDorDiv )
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

   if ( dbfMovAlm )->( dbSeek( cCodArt ) )

      while ( dbfMovAlm )->cRefMov == cCodArt .and. !( dbfMovAlm )->( eof() )

         if nYear == nil .or. Year( ( dbfMovAlm )->dFecMov ) == nYear

            if !Empty( ( dbfMovAlm )->cAliMov )
               oDbfTmp:Append()
               oDbfTmp:nTypDoc   := MOV_ALM
               oDbfTmp:cNumDoc   := Str( ( dbfMovAlm )->nNumRem ) + ( dbfMovAlm )->cSufRem
               oDbfTmp:cEstDoc   := "Movimiento"
               oDbfTmp:dFecDoc   := ( dbfMovAlm )->dFecMov
               oDbfTmp:cNomDoc   := if( ( dbfMovAlm )->nTipMov == 1, "Entre almacenes", "Regularización" )
               oDbfTmp:cRef      := ( dbfMovAlm )->cRefMov
               oDbfTmp:cValPr1   := ( dbfMovAlm )->cValPr1
               oDbfTmp:cValPr2   := ( dbfMovAlm )->cValPr2
               oDbfTmp:cLote     := ( dbfMovAlm )->cLote
               oDbfTmp:cAlmDoc   := ( dbfMovAlm )->cAliMov
               oDbfTmp:nUndDoc   := nTotNMovAlm( dbfMovAlm )
               oDbfTmp:nImpDoc   := ( dbfMovAlm )->nPreDiv
               oDbfTmp:nTotDoc   := nTotLMovAlm( dbfMovAlm )
               oDbfTmp:nDtoDoc   := 0 //( dbfMovAlm )->( Recno() )    // Lo usamos como referencia al registro
               oDbfTmp:Save()
            end if

            if !Empty( ( dbfMovAlm )->cAloMov )
               oDbfTmp:Append()
               oDbfTmp:nTypDoc   := MOV_ALM
               oDbfTmp:cEstDoc   := "Movimiento"
               oDbfTmp:cNumDoc   := Str( ( dbfMovAlm )->nNumRem ) + ( dbfMovAlm )->cSufRem
               oDbfTmp:dFecDoc   := ( dbfMovAlm )->dFecMov
               oDbfTmp:cNomDoc   := if( ( dbfMovAlm )->nTipMov == 1, "Entre almacenes", "Regularización" )
               oDbfTmp:cRef      := ( dbfMovAlm )->cRefMov
               oDbfTmp:cValPr1   := ( dbfMovAlm )->cValPr1
               oDbfTmp:cValPr2   := ( dbfMovAlm )->cValPr2
               oDbfTmp:cLote     := ( dbfMovAlm )->cLote
               oDbfTmp:cAlmDoc   := ( dbfMovAlm )->cAloMov
               oDbfTmp:nUndDoc   := - nTotNMovAlm( dbfMovAlm )
               oDbfTmp:nImpDoc   := ( dbfMovAlm )->nPreDiv
               oDbfTmp:nTotDoc   := - nTotLMovAlm( dbfMovAlm )
               oDbfTmp:nDtoDoc   := 0 //( dbfMovAlm )->( Recno() )       // Lo usamos como referencia al registro
               oDbfTmp:Save()
            end if

         end if

         SysRefresh()

         ( dbfMovAlm )->( dbSkip() )

      end while

   end if

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
               oDbfTmp:cEstDoc   := Space(1)
               oDbfTmp:dFecDoc   := ( dbfProducT )->dFecFin
               oDbfTmp:cNomDoc   := "Material"
               oDbfTmp:cRef      := ( dbfProducL )->cCodArt
               oDbfTmp:cValPr1   := ( dbfProducL )->cValPr1
               oDbfTmp:cValPr2   := ( dbfProducL )->cValPr2
               oDbfTmp:cLote     := ( dbfProducL )->cLote
               oDbfTmp:cAlmDoc   := ( dbfProducL )->cAlmOrd
               oDbfTmp:nUndDoc   := NotCaja( ( dbfProducL )->nCajOrd ) * ( dbfProducL )->nUndOrd
               oDbfTmp:nImpDoc   := ( dbfProducL )->nImpOrd
               oDbfTmp:nTotDoc   := ( NotCaja( ( dbfProducL )->nCajOrd ) * ( dbfProducL )->nUndOrd ) * ( dbfProducL )->nImpOrd
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
               oDbfTmp:cEstDoc   := Space(1)
               oDbfTmp:dFecDoc   := ( dbfProducT )->dFecFin
               oDbfTmp:cNomDoc   := "Materias primas"
               oDbfTmp:cRef      := ( dbfProducM )->cCodArt
               oDbfTmp:cValPr1   := ( dbfProducM )->cValPr1
               oDbfTmp:cValPr2   := ( dbfProducM )->cValPr2
               oDbfTmp:cLote     := ( dbfProducM )->cLote
               oDbfTmp:cAlmDoc   := ( dbfProducM )->cAlmOrd
               oDbfTmp:nUndDoc   := NotCaja( ( dbfProducM )->nCajOrd ) * ( dbfProducM )->nUndOrd
               oDbfTmp:nImpDoc   := ( dbfProducM )->nImpOrd
               oDbfTmp:nTotDoc   := ( NotCaja( ( dbfProducM )->nCajOrd ) * ( dbfProducM )->nUndOrd ) * ( dbfProducM )->nImpOrd
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

   local nTotRStk := 0
   local nOrdAnt  := ( dbfPedCliR )->( OrdSetFocus( "cRef" ) )

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
               nTotRes  := nTotRPedCli( ( dbfPedCliR )->cSerPed + Str( ( dbfPedCliR )->nNumPed ) + ( dbfPedCliR )->cSufPed, ( dbfPedCliR )->cRef, , , dbfPedCliR )
               nTotAlb  := nUnidadesRecibidasAlbCli( ( dbfPedCliR )->cSerPed + Str( ( dbfPedCliR )->nNumPed ) + ( dbfPedCliR )->cSufPed, ( dbfPedCliR )->cRef, , , , , dbfAlbCliL )
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
      return ( Left( oDbfTmp:cNumDoc, 1 ) + "/" + Alltrim( SubStr( oDbfTmp:cNumDoc, 2, 10 ) ) + "/" + Right( oDbfTmp:cNumDoc, 2 ) )
   case oDbfTmp:nTypDoc == MOV_ALM
      if Val( oDbfTmp:cNumDoc ) == 0
         return ""
      else
         return ( Alltrim( Left( oDbfTmp:cNumDoc, 9 ) ) + "/" + Alltrim( SubStr( oDbfTmp:cNumDoc, 10, 2 ) ) )
      end if
   case oDbfTmp:nTypDoc == ENT_PED .or. oDbfTmp:nTypDoc == ENT_ALB .or. oDbfTmp:nTypDoc == REC_CLI .or. oDbfTmp:nTypDoc == REC_PRV
      return ( Left( oDbfTmp:cNumDoc, 1 ) + "/" + Alltrim( SubStr( oDbfTmp:cNumDoc, 2, 9 ) ) + "/" + Right( oDbfTmp:cNumDoc, 3 ) + "-" + Alltrim( Str( oDbfTmp:nNumRec ) ) )
   end case

return ( Left( oDbfTmp:cNumDoc, 1 ) + "/" + Alltrim( SubStr( oDbfTmp:cNumDoc, 2, 9 ) ) + "/" + Right( oDbfTmp:cNumDoc, 3 ) )

//---------------------------------------------------------------------------//
/*Al movernos por el arbol cambiamos el orden de la temporal y le hacemos un scope*/

Static Function TreeChanged( oTree, oBrwTmp )

   local cText    := oTree:GetSelText()
   local cFilter

   do case
      case cText == "Compras"
         cFilter  := "( nTypDoc >= '" + PED_PRV + "' .and. nTypDoc <= '" + FAC_PRV + "' ) .or. nTypDoc == '" + RCT_PRV + "'"

      case cText == "Movimientos"
         cFilter  := "nTypDoc == '" + MOV_ALM + "'"

      case cText == "Ventas"
         cFilter  := "( nTypDoc >= '" + PRE_CLI + "' .and. nTypDoc <= '" + REC_CLI + "' )"

      case cText == "Producción"
         cFilter  := "( nTypDoc == '" + PRO_LIN + "' .or. nTypDoc == '" + PRO_MAT + "' )"

      case cText == "Stock"
         cFilter  := "!lFacturado .and. ( nTypDoc =='" + ALB_PRV + "' .or. nTypDoc == '" + FAC_PRV + "' .or. nTypDoc == '" + MOV_ALM + "' .or. nTypDoc == '" + ALB_CLI + "' .or. nTypDoc == '" + FAC_CLI + "' .or. nTypDoc == '" + TIK_CLI + "'.or. nTypDoc == '" + FAC_REC + "' .or. nTypDoc == '" + DEV_CLI + "' .or. nTypDoc == '" + VAL_CLI + "' .or. nTypDoc == '" + PRO_LIN + "' .or. nTypDoc == '" + PRO_MAT + "' .or. nTypDoc == '" + RCT_PRV + "' )"

      case cText == cTextDocument( PED_PRV )
         cFilter  := "( nTypDoc == '" + PED_PRV + "' )"

      case cText == cTextDocument( ALB_PRV )
         cFilter  := "( nTypDoc == '" + ALB_PRV + "' )"

      case cText == cTextDocument( FAC_PRV )
         cFilter  := "( nTypDoc == '" + FAC_PRV + "' )"

      case cText == cTextDocument( RCT_PRV )
         cFilter  := "( nTypDoc == '" + RCT_PRV + "' )"

      case cText == cTextDocument( PRE_CLI )
         cFilter  := "( nTypDoc == '" + PRE_CLI + "' )"

      case cText == cTextDocument( PED_CLI )
         cFilter  := "( nTypDoc == '" + PED_CLI + "' )"

      case cText == cTextDocument( ALB_CLI )
         cFilter  := "( nTypDoc == '" + ALB_CLI + "' )"

      case cText == cTextDocument( FAC_CLI )
         cFilter  := "( nTypDoc == '" + FAC_CLI + "' )"

      case cText == cTextDocument( FAC_REC )
         cFilter  := "( nTypDoc == '" + FAC_REC + "' )"

      case cText == cTextDocument( TIK_CLI )
         cFilter  := "( nTypDoc == '" + TIK_CLI + "' )"

      case cText == cTextDocument( DEV_CLI )
         cFilter  := "( nTypDoc == '" + DEV_CLI + "' )"

      case cText == cTextDocument( MOV_ALM )
         cFilter  := "( nTypDoc == '" + MOV_ALM + "' )"

      case cText == cTextDocument( VAL_CLI )
         cFilter  := "( nTypDoc == '" + VAL_CLI + "' )"

      case cText == cTextDocument( APT_CLI )
         cFilter  := "( nTypDoc == '" + APT_CLI + "' )"

      case cText == cTextDocument( PRO_LIN )
         cFilter  := "( nTypDoc == '" + PRO_LIN + "' )"

      case cText == cTextDocument( PRO_MAT )
         cFilter  := "( nTypDoc == '" + PRO_MAT + "' )"

      otherwise
         cFilter  := nil

   end case

   oDbfTmp:SetFilter( ( cFilter ) )
   oDbfTmp:GoTop()

   oBrwTmp:Refresh()

Return nil

//---------------------------------------------------------------------------//
/*Funcion que elige la imagen de cada documento*/

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

         EditMovimientosAlmacen( oDbfTmp:cNumDoc, oBrwTmp )

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

         ZoomMovimientosAlmacen( oDbfTmp:cNumDoc, oBrwTmp )

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

         DelMovimientosAlmacen( oDbfTmp:cNumDoc, oBrwTmp )

      case oDbfTmp:nTypDoc == PRO_LIN .or.;
           oDbfTmp:nTypDoc == PRO_MAT

         DelProduccion( oBrwTmp )

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

         VisMovimientosAlmacen( oDbfTmp:cNumDoc, oBrwTmp )

      case oDbfTmp:nTypDoc == PRO_LIN .or.;
           oDbfTmp:nTypDoc == PRO_MAT

         VisProduccion( oDbfTmp:cNumDoc )

   end case

Return nil

//---------------------------------------------------------------------------//
/*Funcion para imprimir los documentos*/

Static Function PrintDocument( oBrwTmp )

   do case
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
         PrnAlbCli( oDbfTmp:cNumDoc )

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
      FIELD NAME "lFacturado" TYPE "L" LEN  1 DEC 0 COMMENT "Documento facturado"            OF oDbf
      FIELD NAME "cCodDoc"    TYPE "C" LEN 12 DEC 0 COMMENT "Código cliente/proveedor"       OF oDbf
      FIELD NAME "cNomDoc"    TYPE "C" LEN 50 DEC 0 COMMENT "Nombre cliente/proveedor"       OF oDbf
      FIELD NAME "cRef"       TYPE "C" LEN 18 DEC 0 COMMENT "Referencia artículo"            OF oDbf
      FIELD NAME "cValPr1"    TYPE "C" LEN 10 DEC 0 COMMENT "Valor de la primera propiedad"  OF oDbf
      FIELD NAME "cValPr2"    TYPE "C" LEN 10 DEC 0 COMMENT "Valor de la segunda propiedad"  OF oDbf
      FIELD NAME "cLote"      TYPE "C" LEN 12 DEC 0 COMMENT "Número de lote"                 OF oDbf
      FIELD NAME "cAlmDoc"    TYPE "C" LEN  3 DEC 0 COMMENT "Almacén"                        OF oDbf
      FIELD NAME "nUndDoc"    TYPE "N" LEN 16 DEC 6 COMMENT "Unidades vendidas"              OF oDbf
      FIELD NAME "nFacCnv"    TYPE "N" LEN 16 DEC 6 COMMENT "Factor de conversión"           OF oDbf
      FIELD NAME "nDtoDoc"    TYPE "N" LEN 16 DEC 6 COMMENT "Descuento porcentual"           OF oDbf
      FIELD NAME "nImpDoc"    TYPE "N" LEN 16 DEC 6 COMMENT "Importe unidad"                 OF oDbf
      FIELD NAME "nTotDoc"    TYPE "N" LEN 16 DEC 6 COMMENT "Total documento"                OF oDbf

      INDEX TO ( cFileName ) TAG "nTypDoc" ON "nTypDoc + Dtos( dFecDoc )"                    OF oDbf
      INDEX TO ( cFileName ) TAG "cEstDoc" ON "cEstDoc + Dtos( dFecDoc )"                    OF oDbf
      INDEX TO ( cFileName ) TAG "dFecDoc" ON "Dtos( dFecDoc )"                              OF oDbf
      INDEX TO ( cFileName ) TAG "cNumDoc" ON "cNumDoc + Dtos( dFecDoc )"                    OF oDbf
      INDEX TO ( cFileName ) TAG "cNomDoc" ON "cNomDoc + Dtos( dFecDoc )"                    OF oDbf
      INDEX TO ( cFileName ) TAG "cCodDoc" ON "cCodDoc + Dtos( dFecDoc )"                    OF oDbf
      INDEX TO ( cFileName ) TAG "cLote"   ON "cLote + Dtos( dFecDoc )"                      OF oDbf
      INDEX TO ( cFileName ) TAG "cAlmDoc" ON "cAlmDoc + Dtos( dFecDoc )"                    OF oDbf
      INDEX TO ( cFileName ) TAG "nUndDoc" ON "nUndDoc"                                      OF oDbf
      INDEX TO ( cFileName ) TAG "nFacCnv" ON "nFacCnv"                                      OF oDbf
      INDEX TO ( cFileName ) TAG "nImpDoc" ON "nImpDoc"                                      OF oDbf
      INDEX TO ( cFileName ) TAG "nTotDoc" ON "nTotDoc"                                      OF oDbf

   END DATABASE oDbf

Return ( oDbf )

//---------------------------------------------------------------------------//
/*Texto del tipo de documento*/

Function cTextDocument( nTypDoc )

   local cTextDocument  := ""

   DEFAULT nTypDoc      := oDbfTmp:nTypDoc

   if !isChar( nTypDoc )
      Return ( cTextDocument )
   end if

   do case
      case nTypDoc == PED_PRV
         cTextDocument  := "Pedidos"
      case nTypDoc == ALB_PRV
         cTextDocument  := "Albaranes"
      case nTypDoc == FAC_PRV
         cTextDocument  := "Facturas"
      case nTypDoc == RCT_PRV
         cTextDocument  := "Rectificativas"
      case nTypDoc == PRE_CLI
         cTextDocument  := "Presupuestos "
      case nTypDoc == PED_CLI
         cTextDocument  := "Pedidos "
      case nTypDoc == ALB_CLI
         cTextDocument  := "Albaranes "
      case nTypDoc == FAC_CLI
         cTextDocument  := "Facturas "
      case nTypDoc == FAC_REC
         cTextDocument  := "Rectificativas"
      case nTypDoc == TIK_CLI
         cTextDocument  := "Tickets"
      case nTypDoc == DEV_CLI
         cTextDocument  := "Devoluciones"
      case nTypDoc == VAL_CLI
         cTextDocument  := "Vale"
      case nTypDoc == APT_CLI
         cTextDocument  := "Apartado"
      case nTypDoc == MOV_ALM
         cTextDocument  := "Movimientos"
      case nTypDoc == PRO_LIN
         cTextDocument  := "Material"
      case nTypDoc == PRO_MAT
         cTextDocument  := "Materia prima"
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

            MENUITEM    "&1. Modificar de artículo";
               MESSAGE  "Modificar la ficha del artículo" ;
               RESOURCE "Cube_Yellow_16";
               ACTION   ( EdtArticulo( oCodArt:VarGet() ) );

            MENUITEM    "&2. Modificar codigos de barras";
               MESSAGE  "Modificar los codigos de barras del articulo" ;
               RESOURCE "Remotecontrol_16";
               ACTION   ( EdtArtCodeBar( oCodArt:VarGet() ) );

            MENUITEM    "&3. Informe de artículo";
               MESSAGE  "Abrir el informe del artículo" ;
               RESOURCE "Info16";
               ACTION   ( if( oUser():lNotCostos(), msgStop( "No tiene permiso para ver los precios de costo" ), InfArticulo( oCodArt:VarGet() ) ) );

            SEPARATOR

            MENUITEM    "&4. Añadir movimiento entre almacenes";
               MESSAGE  "Realizar un nuevo movimiento entre almacenes" ;
               RESOURCE "Pencil_Package_16";
               ACTION   ( if( !Empty( oCodArt:VarGet() ), AppMovAlm( oCodArt:VarGet(), 1 ), MsgStop( "No se encuentra artículo" ) ) );

            MENUITEM    "&5. Añadir movimiento de regularización de almacenes simple";
               MESSAGE  "Realizar un nuevo movimiento de regularización de almacenes simple" ;
               RESOURCE "Pencil_Package_16";
               ACTION   ( if( !Empty( oCodArt:VarGet() ), AppMovAlm( oCodArt:VarGet(), 2 ), MsgStop( "No se encuentra artículo" ) ) );

            MENUITEM    "&6. Añadir movimiento de regularización de almacenes por objetivo";
               MESSAGE  "Realizar un nuevo movimiento de regularización de almacenes por objetivo" ;
               RESOURCE "Pencil_Package_16";
               ACTION   ( if( !Empty( oCodArt:VarGet() ), AppMovAlm( oCodArt:VarGet(), 3 ), MsgStop( "No se encuentra artículo" ) ) );

         ENDMENU

      if lOferta

         MENUITEM    "&2. Artículo en oferta  ";
            MESSAGE  "Modificar la ficha del artículo" ;
            RESOURCE "Sel16";
            ACTION   ( EdtArticulo( oCodArt:VarGet() ) );

      end if

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

function nStockCalculado( cCodArt )

   local oBlock
   local oError
   local nUndVta     := 0
   local nUndAlm     := 0
   local nUndCom     := 0
   local nTotActStk  := 0

   CursorWait()

   /*
   Documentos relacionados de compras
   */

   oBlock            := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

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

   /*
   Documentos relacionados de ventas
   */

   USE ( cPatEmp() + "PRECLIT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PRECLIT", @dbfPreCliT ) )
   SET ADSINDEX TO ( cPatEmp() + "PRECLIT.CDX" ) ADDITIVE

   USE ( cPatEmp() + "PRECLIL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PRECLIL", @dbfPreCliL ) )
   SET ADSINDEX TO ( cPatEmp() + "PRECLIL.CDX" ) ADDITIVE
   SET TAG TO "CREF"

   /*
   Documentos relacionados de ventas
   */

   USE ( cPatEmp() + "PEDCLIT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PEDCLIT", @dbfPedCliT ) )
   SET ADSINDEX TO ( cPatEmp() + "PEDCLIT.CDX" ) ADDITIVE

   USE ( cPatEmp() + "PEDCLIL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PEDCLIL", @dbfPedCliL ) )
   SET ADSINDEX TO ( cPatEmp() + "PEDCLIL.CDX" ) ADDITIVE
   SET TAG TO "CREF"

   USE ( cPatEmp() + "PEDCLIR.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PEDCLIR", @dbfPedCliR ) )
   SET ADSINDEX TO ( cPatEmp() + "PEDCLIR.CDX" ) ADDITIVE
   SET TAG TO "CREF"

   USE ( cPatEmp() + "ALBCLIT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ALBCLIT", @dbfAlbCliT ) )
   SET ADSINDEX TO ( cPatEmp() + "ALBCLIT.CDX" ) ADDITIVE

   USE ( cPatEmp() + "ALBCLIL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ALBCLIL", @dbfAlbCliL ) )
   SET ADSINDEX TO ( cPatEmp() + "ALBCLIL.CDX" ) ADDITIVE
   SET TAG TO "CREF"

   USE ( cPatEmp() + "FACCLIT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FACCLIT", @dbfFacCliT ) )
   SET ADSINDEX TO ( cPatEmp() + "FACCLIT.CDX" ) ADDITIVE

   USE ( cPatEmp() + "FACCLIL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FACCLIL", @dbfFacCliL ) )
   SET ADSINDEX TO ( cPatEmp() + "FACCLIL.CDX" ) ADDITIVE
   SET TAG TO "CREF"

   USE ( cPatEmp() + "FACRECT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FACRECT", @dbfFacRecT ) )
   SET ADSINDEX TO ( cPatEmp() + "FACRECT.CDX" ) ADDITIVE

   USE ( cPatEmp() + "FACRECL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FACRECL", @dbfFacRecL ) )
   SET ADSINDEX TO ( cPatEmp() + "FACRECL.CDX" ) ADDITIVE
   SET TAG TO "CREF"

   USE ( cPatEmp() + "FACCLIP.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FACCLIP", @dbfFacCliP ) )
   SET ADSINDEX TO ( cPatEmp() + "FACCLIP.CDX" ) ADDITIVE

   USE ( cPatEmp() + "TIKET.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "TIKET", @dbfTikCliT ) )
   SET ADSINDEX TO ( cPatEmp() + "TIKET.CDX" ) ADDITIVE

   USE ( cPatEmp() + "TIKEL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "TIKEL", @dbfTikCliL ) )
   SET ADSINDEX TO ( cPatEmp() + "TIKEL.CDX" ) ADDITIVE
   SET TAG TO "CCBATIL"

   USE ( cPatEmp() + "TIKEP.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "TIKEP", @dbfTikCliP ) )
   SET ADSINDEX TO ( cPatEmp() + "TIKEP.CDX" ) ADDITIVE

   USE ( cPatEmp() + "HISMOV.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "HISMOV", @dbfMovAlm ) )
   SET ADSINDEX TO ( cPatEmp() + "HISMOV.CDX" ) ADDITIVE
   SET TAG TO "CREFMOV"

   /*
   Calculo de compras----------------------------------------------------------
   */

   if ( dbfAlbPrvL )->( dbSeek( cCodArt ) )
      while ( dbfAlbPrvL )->cRef == cCodArt .and. !( dbfAlbPrvL )->( Eof() )
         if ( dbfAlbPrvT )->( dbSeek( ( dbfAlbPrvL )->CSERALB + Str( ( dbfAlbPrvL )->NNUMALB ) + (dbfAlbPrvL)->CSUFALB ) )
            if !( dbfAlbPrvT )->lFacturado
               nUndCom  += nTotNAlbPrv( dbfAlbPrvL )
            end if
         end if
         SysRefresh()
         ( dbfAlbPrvL )->( dbSkip() )
      end do
   end if

   if ( dbfFacPrvL )->( dbSeek( cCodArt ) )
      while ( dbfFacPrvL )->cRef == cCodArt .and. !( dbfFacPrvL )->( Eof() )
         if ( dbfFacPrvT )->( dbSeek( ( dbfFacPrvL )->CSERFAC + Str( ( dbfFacPrvL )->NNUMFAC ) + (dbfFacPrvL)->CSUFFAC ) )
            nUndCom     += nTotNFacPrv( dbfFacPrvL )
         end if
         SysRefresh()
         ( dbfFacPrvL )->( dbSkip() )
      end while
   end if

   /*
   Calculo de ventas-----------------------------------------------------------
   */

   if ( dbfAlbCliL )->( dbSeek( cCodArt ) )
      while ( dbfAlbCliL )->cRef == cCodArt .and. !( dbfAlbCliL )->( Eof() )
         if ( dbfAlbCliT )->( dbSeek( ( dbfAlbCliL )->CSERALB + Str( ( dbfAlbCliL )->NNUMALB ) + (dbfAlbCliL)->CSUFALB ) )
            if !( dbfAlbCliT )->lFacturado
            nUndVta  += nTotNAlbCli( dbfAlbCliL )
            end if
         end if
         SysRefresh()
         ( dbfAlbCliL )->( dbSkip() )
      end do
   end if

   if ( dbfFacCliL )->( dbSeek( cCodArt ) )
      while ( dbfFacCliL )->CREF == cCodArt .and. !( dbfFacCliL )->( Eof() )
         if ( dbfFacCliT )->( dbSeek( ( dbfFacCliL )->CSERIE + Str( ( dbfFacCliL )->NNUMFAC ) + (dbfFacCliL)->CSUFFAC ) )
            nUndVta  += nTotNFacCli( dbfFacCliL )
         end if
         SysRefresh()
         ( dbfFacCliL )->( dbSkip() )
      end do
   end if

   if ( dbfFacRecL )->( dbSeek( cCodArt ) )
      while ( dbfFacRecL )->cRef == cCodArt .and. !( dbfFacRecL )->( Eof() )
         if ( dbfFacRecT )->( dbSeek( ( dbfFacRecL )->cSerie + Str( ( dbfFacRecL )->nNumFac ) + (dbfFacRecL)->cSufFac ) )
            nUndVta  += nTotNFacRec( dbfFacRecL )
         end if
         SysRefresh()
         ( dbfFacRecL )->( dbSkip() )
      end do
   end if

   /*
   Tikets----------------------------------------------------------------------
   */

   if ( dbfTikCliL )->( dbSeek( cCodArt ) )
   while ( dbfTikCliL )->cCbaTil == cCodArt .and. !( dbfTikCliL )->( Eof() )
      if ( dbfTikCliT )->( dbSeek( ( dbfTikCliL )->cSerTil + ( dbfTikCliL )->cNumTil + (dbfTikCliL)->cSufTil ) )
         if ( dbfTikCliT )->cTipTik == "1" .or. ( dbfTikCliT )->cTipTik == "5"
            nUndVta  += ( dbfTikCliL )->nUntTil
         elseif ( dbfTikCliT )->cTipTik == "4"
            nUndVta  -= ( dbfTikCliL )->nUntTil
         end if
         SysRefresh()
      end if
      ( dbfTikCliL )->( dbSkip() )
   end do
   end if

   /*
   Combinados------------------------------------------------------------------
   */

   ( dbfTikCliL )->( ordSetFocus( "cComTil" ) )
   if ( dbfTikCliL )->( dbSeek( cCodArt ) )
   while ( dbfTikCliL )->cComTil == cCodArt .and. !( dbfTikCliL )->( Eof() )
      if ( dbfTikCliT )->( dbSeek( ( dbfTikCliL )->cSerTil + ( dbfTikCliL )->cNumTil + (dbfTikCliL)->cSufTil ) )
         if ( dbfTikCliT )->cTipTik == "1" .or. ( dbfTikCliT )->cTipTik == "5"
            nUndVta  += ( dbfTikCliL )->nUntTil
         elseif ( dbfTikCliT )->cTipTik == "4"
            nUndVta  -= ( dbfTikCliL )->nUntTil
         end if
      end if
      SysRefresh()
      ( dbfTikCliL )->( dbSkip() )
   end do
   end if

   ( dbfTikCliL )->( ordSetFocus( "cCbaTil" ) )

   /*
   Calculo de almacen----------------------------------------------------------
   */

   if ( dbfMovAlm )->( dbSeek( cCodArt ) )
      while ( dbfMovAlm )->cRefMov == cCodArt .and. !( dbfMovAlm )->( eof() )
         if !Empty( ( dbfMovAlm )->cAliMov ) .and.;
            !( dbfMovAlm )->lNoStk
            nUndAlm  += nTotNMovAlm( dbfMovAlm )
         end if
         if !Empty( ( dbfMovAlm )->cAloMov ) .and.;
            !( dbfMovAlm )->lNoStk
            nUndAlm  -= nTotNMovAlm( dbfMovAlm )
         end if
         SysRefresh()
         ( dbfMovAlm )->( dbSkip() )
      end while
   end if

   nTotActStk  := nUndCom + nUndAlm - nUndVta

   (dbfPedPrvT)->( dbCloseArea() )
   (dbfPedPrvL)->( dbCloseArea() )
   (dbfAlbPrvT)->( dbCloseArea() )
   (dbfAlbPrvL)->( dbCloseArea() )
   (dbfFacPrvT)->( dbCloseArea() )
   (dbfFacPrvL)->( dbCloseArea() )
   (dbfPreCliT)->( dbCloseArea() )
   (dbfPreCliL)->( dbCloseArea() )
   (dbfPedCliT)->( dbCloseArea() )
   (dbfPedCliL)->( dbCloseArea() )
   (dbfPedCliR)->( dbCloseArea() )
   (dbfAlbCliT)->( dbCloseArea() )
   (dbfAlbCliL)->( dbCloseArea() )
   (dbfFacCliT)->( dbCloseArea() )
   (dbfFacCliL)->( dbCloseArea() )
   (dbfFacCliP)->( dbCloseArea() )
   (dbfFacRecT)->( dbCloseArea() )
   (dbfFacRecL)->( dbCloseArea() )
   (dbfTikCliT)->( dbCloseArea() )
   (dbfTikCliL)->( dbCloseArea() )
   (dbfTikCliP)->( dbCloseArea() )
   (dbfMovAlm )->( dbCloseArea() )

   RECOVER USING oError

      msgStop( "Imposible abrir todas las bases de datos" + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

return ( nTotActStk )

//---------------------------------------------------------------------------//

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

Static Function Filtro()

   if oFilter != nil

      oFilter:Resource()

      if oFilter:cExpFilter != nil
         SetWindowText( oBtnFiltro:hWnd, "Filtro activo" )
      else
         SetWindowText( oBtnFiltro:hWnd, "Filtrar" )
      end if

   end if

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