#include "FiveWin.Ch"
#include "Report.ch"
#include "Xbrowse.ch"
#include "MesDbf.ch"
#include "Factu.ch"
#include "FastRepH.ch"

#define IDFOUND            3
#define _MENUITEM_         "01050"

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS TDetMovimientos FROM TDet

   DATA  cOldCodArt        INIT  ""
   DATA  cOldLote          INIT  ""
   DATA  cOldValPr1        INIT  ""
   DATA  cOldValPr2        INIT  ""
   DATA  cOldAliMov        INIT  ""

   DATA  nStockActual      INIT  0
   DATA  aStockActual

   DATA  oRefMov
   DATA  oValPr1
   DATA  oValPr2
   DATA  oSayVp1
   DATA  cSayVp1           INIT  ""
   DATA  oSayVp2
   DATA  cSayVp2           INIT  ""
   DATA  oSayPr1
   DATA  cSayPr1           INIT  ""
   DATA  oSayPr2
   DATA  cSayPr2           INIT  ""
   DATA  oSayCaj
   DATA  cSayCaj           INIT  ""
   DATA  oSayUnd
   DATA  cSayUnd           INIT  ""
   DATA  cAliMov
   DATA  oSayLote
   DATA  oGetLote
   DATA  oGetDetalle
   DATA  cGetDetalle       INIT  ""
   DATA  oFechaCaducidad

   DATA  cRefMov
   DATA  cNomMov
   DATA  dFecMov
   DATA  cTimMov
   DATA  nTipMov
   DATA  cCodMov
   DATA  nPreDiv
   DATA  nCajMov

   DATA  oCajMov
   DATA  oUndMov

   DATA  oGetBultos  
   DATA  oSayBultos
   DATA  oGetFormato

   DATA  oGetStockOrigen
   DATA  oGetStockDestino

   DATA  oGetAlmacenOrigen
   DATA  oGetAlmacenDestino

   DATA  oTxtAlmacenOrigen
   DATA  oTxtAlmacenDestino

   DATA  cTxtAlmacenOrigen
   DATA  cTxtAlmacenDestino

   DATA  oPreDiv

   DATA  oBrwPrp
   DATA  oBrwStock

   DATA  oBtnSerie

   DATA  oMenu

   DATA  lNumeroSerieIntroducido
   DATA  lNumeroSerieNecesario            

   METHOD DefineFiles()

   METHOD OpenFiles( lExclusive )
   METHOD CloseFiles()

   MESSAGE OpenService( lExclusive )               METHOD OpenFiles( lExclusive )

   METHOD Reindexa()

   METHOD AppendDetail()

   METHOD Resource( nMode, lLiteral )
      METHOD ValidResource( nMode, oDlg, oBtn )
      METHOD MenuResource( oDlg )

   METHOD RollBack()

   METHOD loadArticulo( lValidDetalle, nMode )
      METHOD getPrecioCosto() 

   METHOD Save()
   METHOD Asigna()

   METHOD AppendKit()
   METHOD ActualizaKit( nMode )

   METHOD nStockActualAlmacen( cCodAlm )

   METHOD SetDlgMode( nMode )

   METHOD aStkArticulo()

   METHOD nTotRemVir( lPic )
   METHOD nTotUnidadesVir( lPic )
   METHOD nTotVolumenVir( lPic )
   METHOD nTotPesoVir( lPic )

   METHOD recalcularPrecios()

   METHOD putFieldValues()
   METHOD isKeyFieldValues()
   METHOD accumulatesFieldValues()   

   METHOD isNumeroSerieNecesario()

   METHOD accumulatesStoreMovement()

   METHOD alertControlStockUnderMin()

   METHOD setPropertiesData()

   METHOD processPropertiesGrid()

   METHOD refreshDetail()                          INLINE ( if( !empty( ::oParent:oBrwDet ), ::oParent:oBrwDet:Refresh(), ) )

END CLASS

//--------------------------------------------------------------------------//

METHOD DefineFiles( cPath, cDriver, lUniqueName, cFileName ) CLASS TDetMovimientos

   local oDbf

   DEFAULT cPath        := ::cPath
   DEFAULT cDriver      := ::cDriver
   DEFAULT lUniqueName  := .f.
   DEFAULT cFileName    := "HisMov"

   if lUniqueName
      cFileName         := cGetNewFileName( cFileName, , , cPatTmp() )
   end if

   DEFINE TABLE oDbf FILE ( cFileName ) CLASS "HisMov" ALIAS ( cFileName ) PATH ( cPath ) VIA ( cDriver )

      FIELD NAME "dFecMov"    TYPE "D" LEN   8 DEC 0 COMMENT "Fecha movimiento"                    OF oDbf
      FIELD NAME "cTimMov"    TYPE "C" LEN   6 DEC 0 COMMENT "Hora movimiento"                     OF oDbf
      FIELD NAME "nTipMov"    TYPE "N" LEN   1 DEC 0 COMMENT "Tipo movimiento"                     OF oDbf
      FIELD NAME "cAliMov"    TYPE "C" LEN  16 DEC 0 COMMENT "Alm. ent."                           OF oDbf
      FIELD NAME "cAloMov"    TYPE "C" LEN  16 DEC 0 COMMENT "Alm. sal."                           OF oDbf
      FIELD NAME "cRefMov"    TYPE "C" LEN  18 DEC 0 COMMENT "Código"                              OF oDbf
      FIELD NAME "cNomMov"    TYPE "C" LEN  50 DEC 0 COMMENT "Nombre"                              OF oDbf
      FIELD NAME "cCodMov"    TYPE "C" LEN   2 DEC 0 COMMENT "TM"                                  OF oDbf
      FIELD NAME "cCodPr1"    TYPE "C" LEN  20 DEC 0 COMMENT "Código propiedad 1"                  OF oDbf
      FIELD NAME "cCodPr2"    TYPE "C" LEN  20 DEC 0 COMMENT "Código propiedad 2"                  OF oDbf
      FIELD NAME "cValPr1"    TYPE "C" LEN  20 DEC 0 COMMENT "Valor propiedad 1"                   OF oDbf
      FIELD NAME "cValPr2"    TYPE "C" LEN  20 DEC 0 COMMENT "Valor propiedad 2"                   OF oDbf
      FIELD NAME "dFecCad"    TYPE "D" LEN   8 DEC 0 COMMENT "Fecha caducidad"                     OF oDbf
      FIELD NAME "cCodUsr"    TYPE "C" LEN   3 DEC 0 COMMENT "Código usuario"                      OF oDbf
      FIELD NAME "cCodDlg"    TYPE "C" LEN   2 DEC 0 COMMENT "Código delegación"                   OF oDbf
      FIELD NAME "lLote"      TYPE "L" LEN   1 DEC 0 COMMENT "Lógico lote"                         OF oDbf
      FIELD NAME "nLote"      TYPE "N" LEN   9 DEC 0 COMMENT "Número de lote"                      OF oDbf
      FIELD NAME "cLote"      TYPE "C" LEN  14 DEC 0 COMMENT "Lote"                                OF oDbf
      FIELD NAME "nCajMov"    TYPE "N" LEN  19 DEC 6 PICTURE {|| MasUnd() } COMMENT "Caj."         OF oDbf
      FIELD NAME "nUndMov"    TYPE "N" LEN  19 DEC 6 PICTURE {|| MasUnd() } COMMENT "Und."         OF oDbf
      FIELD NAME "nCajAnt"    TYPE "N" LEN  19 DEC 6 COMMENT "Caj. ant."                           OF oDbf
      FIELD NAME "nUndAnt"    TYPE "N" LEN  19 DEC 6 COMMENT "Und. ant."                           OF oDbf
      FIELD NAME "nPreDiv"    TYPE "N" LEN  19 DEC 6 PICTURE {|| PicOut() } COMMENT "Precio"       OF oDbf
      FIELD NAME "lSndDoc"    TYPE "L" LEN   1 DEC 0 COMMENT "Lógico enviar"                       OF oDbf
      FIELD NAME "nNumRem"    TYPE "N" LEN   9 DEC 0 COMMENT "Número remesa"                       OF oDbf
      FIELD NAME "cSufRem"    TYPE "C" LEN   2 DEC 0 COMMENT "Sufijo remesa"                       OF oDbf
      FIELD NAME "lSelDoc"    TYPE "L" LEN   1 DEC 0 COMMENT "Lógico selecionar"                   OF oDbf
      FIELD NAME "lNoStk"     TYPE "L" LEN   1 DEC 0 COMMENT "Lógico no stock"                     OF oDbf
      FIELD NAME "lKitArt"    TYPE "L" LEN   1 DEC 0 COMMENT "Línea con escandallo"                OF oDbf
      FIELD NAME "lKitEsc"    TYPE "L" LEN   1 DEC 0 COMMENT "Línea perteneciente a escandallo"    OF oDbf
      FIELD NAME "lImpLin"    TYPE "L" LEN   1 DEC 0 COMMENT "Lógico imprimir linea"               OF oDbf
      FIELD NAME "lKitPrc"    TYPE "L" LEN   1 DEC 0 COMMENT "Lógico precio escandallo"            OF oDbf
      FIELD NAME "nNumLin"    TYPE "N" LEN   9 DEC 0 COMMENT "Número de linea"                     OF oDbf
      FIELD NAME "mNumSer"    TYPE "M" LEN  10 DEC 0 COMMENT "Numeros de serie"                    OF oDbf
      FIELD NAME "nVolumen"   TYPE "N" LEN  16 DEC 6 COMMENT "Volumen del producto"                OF oDbf
      FIELD NAME "cVolumen"   TYPE "C" LEN   2 DEC 0 COMMENT "Unidad del volumen"                  OF oDbf
      FIELD NAME "nPesoKg"    TYPE "N" LEN  16 DEC 6 COMMENT "Peso del producto"                   OF oDbf
      FIELD NAME "cPesoKg"    TYPE "C" LEN   2 DEC 0 COMMENT "Unidad de peso del producto"         OF oDbf
      FIELD NAME "nBultos"    TYPE "N" LEN  16 DEC 0 COMMENT "Número de bultos en líneas"          OF oDbf
      FIELD NAME "cFormato"   TYPE "C" LEN 100 DEC 0 COMMENT "Formato de compra/venta"             OF oDbf
      FIELD NAME "lLabel"     TYPE "L" LEN   1 DEC 0 COMMENT "Lógico para imprimir etiqueta"       OF oDbf
      FIELD NAME "nLabel"     TYPE "N" LEN  16 DEC 6 COMMENT "Número de etiquetas a imprimir"      OF oDbf
      FIELD NAME "lWait"      TYPE "L" LEN   1 DEC 0 COMMENT "Lógico para documento no finalizado" OF oDbf
      FIELD NAME "cGuid"      TYPE "C" LEN  40 DEC 0 COMMENT "cGuid de las lineas"                 OF oDbf
      FIELD NAME "cGuidPar"   TYPE "C" LEN  40 DEC 0 COMMENT "cGuid de la cabecera"                OF oDbf

      INDEX TO ( cFileName ) TAG "nNumRem"      ON "str( nNumRem ) + cSufRem"               NODELETED                     OF oDbf
      INDEX TO ( cFileName ) TAG "dFecMov"      ON "Dtoc( dFecMov ) + cTimMov"              NODELETED                     OF oDbf
      INDEX TO ( cFileName ) TAG "nNumRef"      ON "str( nNumRem ) + cSufRem + cRefMov + cValPr1 + cValPr2 + cLote "      NODELETED                     OF oDbf
      INDEX TO ( cFileName ) TAG "cRefMov"      ON "UPPER( cRefMov ) + cValPr1 + cValPr2 + cLote"                         NODELETED                     OF oDbf
      INDEX TO ( cFileName ) TAG "cNomMov"      ON "UPPER( cNomMov )"                       NODELETED                     OF oDbf 
      INDEX TO ( cFileName ) TAG "cAloMov"      ON "cAloMov"                                NODELETED                     OF oDbf 
      INDEX TO ( cFileName ) TAG "cAliMov"      ON "cAliMov"                                NODELETED                     OF oDbf
      INDEX TO ( cFileName ) TAG "cRefAlm"      ON "cRefMov + cValPr1 + cValPr2 + cAliMov"  NODELETED                     OF oDbf
      INDEX TO ( cFileName ) TAG "cLote"        ON "cLote"                                  NODELETED                     OF oDbf
      INDEX TO ( cFileName ) TAG "nNumLin"      ON "str( nNumLin )"                         NODELETED                     OF oDbf
      INDEX TO ( cFileName ) TAG "lSndDoc"      ON "lSndDoc"                                NODELETED                              FOR "lSndDoc"      OF oDbf
      INDEX TO ( cFileName ) TAG "nTipMov"      ON "cRefMov + Dtos( dFecMov )"              NODELETED                              FOR "nTipMov == 4" OF oDbf
      INDEX TO ( cFileName ) TAG "cStock"       ON "cRefMov + cAliMov + cValPr1 + cValPr2 + cLote"  NODELETED                      FOR "nTipMov == 4" OF oDbf
      INDEX TO ( cFileName ) TAG "cStkFastIn"   ON "cRefMov + cAliMov + cCodPr1 + cCodPr2 + cValPr1 + cValPr2 + cLote + dtos( dFecMov )"  NODELETED                     OF oDbf
      INDEX TO ( cFileName ) TAG "cStkFastOu"   ON "cRefMov + cAloMov + cCodPr1 + cCodPr2 + cValPr1 + cValPr2 + cLote + dtos( dFecMov )"  NODELETED                     OF oDbf
      INDEX TO ( cFileName ) TAG "cRef"         ON "cRefMov"                                NODELETED                     OF oDbf
      INDEX TO ( cFileName ) TAG "cRefFec"      ON "cRefMov + cLote + dTos( dFecMov )"      NODELETED                     OF oDbf
      INDEX TO ( cFileName ) TAG "cRemLin"      ON "str( nNumRem ) + cSufRem + Str( nNumLin )"      NODELETED             OF oDbf

   END DATABASE oDbf

RETURN ( oDbf )

//--------------------------------------------------------------------------//

METHOD OpenFiles( lExclusive) CLASS TDetMovimientos

   local lOpen             := .t.
   local oBlock

   DEFAULT  lExclusive     := .f.

   oBlock                  := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      if empty( ::oDbf )
         ::oDbf            := ::defineFiles()
      end if

      ::oDbf:Activate( .f., !lExclusive )

  RECOVER

     msgstop( "Imposible abrir todas las bases de datos movimientos de almacen" )
     lOpen                := .f.

  END SEQUENCE

  ErrorBlock( oBlock )

   if !lOpen
      ::CloseFiles()
   end if

RETURN ( lOpen )

//--------------------------------------------------------------------------//

METHOD CloseFiles() CLASS TDetMovimientos

   if ::oDbf != nil .and. ::oDbf:Used()
      ::oDbf:End()
   end if

   ::oDbf         := nil

RETURN .t.

//---------------------------------------------------------------------------//

METHOD Reindexa() CLASS TDetMovimientos

   if empty( ::oDbf )
      ::oDbf   := ::DefineFiles()
   end if

   ::oDbf:IdxFDel()

   if ::OpenService( .t. )
      ::oDbf:IdxFCheck()
      ::oDbf:Pack()
   end if

   ::CloseFiles()

RETURN ( Self )

//---------------------------------------------------------------------------//
/*
Edita las lineas de Detalle
*/

METHOD AppendDetail() CLASS TDetMovimientos

   local nResult

   while .t.

      ::oDbfVir:Blank()

      nResult        := ::Resource( APPD_MODE )

      if nResult == IDOK

         if empty( ::oBrwPrp:Cargo )

            if ::accumulatesStoreMovement()
               ::oDbfVir:Cancel()
            else 
               ::oDbfVir:Insert()
               ::appendKit()
            end if

         else 

            ::setPropertiesData()

            ::oDbfVir:Cancel()

            ::processPropertiesGrid()

         end if

         ::refreshDetail()

            // hay q ver esto
            // ::actualizaKit( nMode )

         if lEntCon()
            loop
         else
            exit
         end if

      else 

         ::oDbfVir:Cancel()

         exit

      end if

   end while

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD Resource( nMode ) CLASS TDetMovimientos

   local oDlg
   local oBtn
   local oSayPre
   local nStockOrigen      := 0
   local nStockDestino     := 0
   local oTotUnd
   local cSayLote          := 'Lote'
   local oBtnSer
   local oSayTotal
   local cCodArt

   if nMode == APPD_MODE
      ::oDbfVir:nNumLin    := nLastNum( ::oDbfVir:cAlias )
   end if

   ::cOldCodArt            := ::oDbfVir:cRefMov
   ::cOldValPr1            := ::oDbfVir:cValPr1
   ::cOldValPr2            := ::oDbfVir:cValPr2
   ::cOldLote              := ::oDbfVir:cLote

   cCodArt                 := Padr( ::oDbfVir:cRefMov, 128 )

   ::cGetDetalle           := oRetFld( ::oDbfVir:cRefMov, ::oParent:oArt, "Nombre" )

   ::aStockActual          := { { "", "", "", "", "", 0, 0, 0 } }

   ::cTxtAlmacenOrigen     := oRetFld( ::oParent:oDbf:cAlmOrg, ::oParent:oAlmacenOrigen )
   ::cTxtAlmacenDestino    := oRetFld( ::oParent:oDbf:cAlmDes, ::oParent:oAlmacenDestino )

   DEFINE DIALOG oDlg RESOURCE "LMovAlm" TITLE lblTitle( nMode ) + "lineas de movimientos de almacén"

      REDEFINE GET ::oRefMov VAR cCodArt ;
         ID       100 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         BITMAP   "LUPA" ;
         OF       oDlg

      ::oRefMov:bValid     := {|| if( !empty( cCodArt ), ::loadArticulo( cCodArt, nMode ), .t. ) }
      ::oRefMov:bHelp      := {|| BrwArticulo( ::oRefMov, ::oGetDetalle , , , , ::oGetLote, ::oDbfVir:cCodPr1, ::oDbfVir:cCodPr2, ::oValPr1, ::oValPr2  ) }

      REDEFINE GET ::oGetDetalle VAR ::oDbfVir:cNomMov ;
         ID       110 ;
         WHEN     ( .f. ) ;
         OF       oDlg

      // Lote------------------------------------------------------------------

      REDEFINE SAY ::oSayLote VAR cSayLote ;
         ID       154;
         OF       oDlg

      REDEFINE GET ::oGetLote VAR ::oDbfVir:cLote ;
         ID       155 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oDlg

      ::oGetLote:bValid          := {|| if( !empty( ::oDbfVir:cLote ), ::loadArticulo( cCodArt, nMode ), .t. ) }

      // Browse de propiedades-------------------------------------------------

      ::oBrwPrp                  := IXBrowse():New( oDlg )

      ::oBrwPrp:nDataType        := DATATYPE_ARRAY

      ::oBrwPrp:bClrSel          := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      ::oBrwPrp:bClrSelFocus     := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      ::oBrwPrp:lHScroll         := .t.
      ::oBrwPrp:lVScroll         := .t.

      ::oBrwPrp:nMarqueeStyle    := 3
      ::oBrwPrp:nFreeze          := 1

      ::oBrwPrp:lRecordSelector  := .f.
      ::oBrwPrp:lFastEdit        := .t.
      ::oBrwPrp:lFooter          := .t.

      ::oBrwPrp:SetArray( {}, .f., 0, .f. )

      ::oBrwPrp:MakeTotals()

      ::oBrwPrp:CreateFromResource( 600 )

      // Valor de primera propiedad--------------------------------------------

      REDEFINE GET ::oValPr1 VAR ::oDbfVir:cValPr1;
         ID       120 ;
         BITMAP   "LUPA" ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oDlg

      ::oValPr1:bValid     := {|| if( lPrpAct( ::oValPr1, ::oSayVp1, ::oDbfVir:cCodPr1, ::oParent:oTblPro:cAlias ), ::loadArticulo( cCodArt, nMode ), .f. ) }
      ::oValPr1:bHelp      := {|| brwPropiedadActual( ::oValPr1, ::oSayVp1, ::oDbfVir:cCodPr1 ) }

      REDEFINE GET ::oSayVp1 VAR ::cSayVp1;
         ID       121 ;
         WHEN     .f. ;
         OF       oDlg

      REDEFINE SAY ::oSayPr1 PROMPT "Propiedad 1";
         ID       122 ;
         OF       oDlg

      // Valor de segunda propiedad--------------------------------------------

      REDEFINE GET ::oValPr2 VAR ::oDbfVir:cValPr2;
         ID       130 ;
         BITMAP   "LUPA" ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oDlg

      ::oValPr2:bValid     := {|| if( lPrpAct( ::oValPr2, ::oSayVp2, ::oDbfVir:cCodPr2, ::oParent:oTblPro:cAlias ), ::loadArticulo( cCodArt, nMode ), .f. ) }
      ::oValPr2:bHelp      := {|| brwPropiedadActual( ::oValPr2, ::oSayVp2, ::oDbfVir:cCodPr2 ) }

      REDEFINE GET ::oSayVp2 VAR ::cSayVp2 ;
         ID       131 ;
         WHEN     .f. ;
         OF       oDlg

      REDEFINE SAY ::oSayPr2 PROMPT "Propiedad 2";
         ID       132 ;
         OF       oDlg

      REDEFINE GET ::oFechaCaducidad VAR ::oDbfVir:dFecCad ;
         ID       340 ;
         IDSAY    341 ;
         SPINNER ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oDlg

      REDEFINE GET ::oGetBultos VAR ::oDbfVir:nBultos;
         ID       430 ;
         SPINNER  ;
         WHEN     ( uFieldEmpresa( "lUseBultos" ) .AND. nMode != ZOOM_MODE ) ;
         PICTURE  ::oParent:cPicUnd;
         OF       oDlg

      REDEFINE SAY ::oSayBultos PROMPT uFieldempresa( "cNbrBultos" );
         ID       431;
         OF       oDlg

      REDEFINE GET ::oCajMov VAR ::oDbfVir:nCajMov;
         ID       140;
         SPINNER ;
         WHEN     ( lUseCaj() .and. nMode != ZOOM_MODE ) ;
         ON CHANGE( oTotUnd:Refresh(), oSayPre:Refresh() );
         VALID    ( oTotUnd:Refresh(), oSayPre:Refresh(), .t. );
         PICTURE  ::oParent:cPicUnd ;
         OF       oDlg

      REDEFINE SAY ::oSayCaj PROMPT cNombreCajas(); 
         ID       142 ;
         OF       oDlg

      REDEFINE GET ::oUndMov VAR ::oDbfVir:nUndMov ;
         ID       150;
         SPINNER ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ON CHANGE( oTotUnd:Refresh(), oSayPre:Refresh() );
         VALID    ( oTotUnd:Refresh(), oSayPre:Refresh(), .t. );
         PICTURE  ::oParent:cPicUnd ;
         OF       oDlg

      REDEFINE SAY ::oSayUnd PROMPT cNombreUnidades() ;
         ID       152 ;
         OF       oDlg

      REDEFINE SAY oTotUnd PROMPT nTotNMovAlm( ::oDbfVir ) ;
         ID       160;
         PICTURE  ::oParent:cPicUnd ;
         OF       oDlg

      REDEFINE GET ::oPreDiv ;
         VAR      ::oDbfVir:nPreDiv ;
         ID       180 ;
         IDSAY    181 ;
         SPINNER ;
         ON CHANGE( oSayPre:Refresh() ) ;
         VALID    ( oSayPre:Refresh(), .t. ) ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         PICTURE  ::oParent:cPinDiv ;
         OF       oDlg

      REDEFINE SAY oSayTotal ;
         ID       191 ;
         OF       oDlg

      REDEFINE SAY oSayPre PROMPT nTotLMovAlm( ::oDbfVir ) ;
         ID       190 ;
         PICTURE  ::oParent:cPirDiv ;
         OF       oDlg
     
      /*
      Almacen origen-----------------------------------------------------------
      */

      REDEFINE GET ::oGetAlmacenOrigen VAR ::oParent:oDbf:cAlmOrg ;
         ID       400 ;
         IDSAY    403 ;
         WHEN     ( .f. ) ;
         BITMAP   "Lupa" ;
         OF       oDlg

      REDEFINE GET ::oTxtAlmacenOrigen VAR ::cTxtAlmacenOrigen ;
         ID       401 ;
         WHEN     ( .f. ) ;
         OF       oDlg

      REDEFINE GET ::oGetStockOrigen VAR nStockOrigen ;
         WHEN     ( .f. ) ;
         PICTURE  ::oParent:cPicUnd ;
         ID       402 ;
         IDSAY    404 ;
         OF       oDlg

      /*
      Almacen destino-----------------------------------------------------------
      */

      REDEFINE GET ::oGetAlmacenDestino VAR ::oParent:oDbf:cAlmDes ;
         ID       410 ;
         WHEN     ( .f. ) ;
         BITMAP   "Lupa" ;
         OF       oDlg

      REDEFINE GET ::oTxtAlmacenDestino VAR ::cTxtAlmacenDestino ;
         ID       411 ;
         WHEN     ( .f. ) ;
         OF       oDlg

      REDEFINE GET ::oGetStockDestino VAR nStockDestino ;
         WHEN     ( .f. ) ;
         PICTURE  ::oParent:cPicUnd ;
         ID       412 ;
         OF       oDlg

      /*
      Peso y volumen-----------------------------------------------------------
      */

      REDEFINE GET ::oDbfVir:nPesoKg ;
         ID       200 ;
         WHEN     ( .f. ) ;
         PICTURE  "@E 999.99";
         OF       oDlg

      REDEFINE GET ::oDbfVir:cPesoKg ;
         ID       210 ;
         WHEN     ( .f. ) ;
         OF       oDlg

      REDEFINE GET ::oDbfVir:nVolumen ;
         ID       220 ;
         WHEN     ( .f. ) ;
         PICTURE  "@E 999.99";
         OF       oDlg

      REDEFINE GET ::oDbfVir:cVolumen ;
         ID       230 ;
         WHEN     ( .f. ) ;
         OF       oDlg

      REDEFINE GET ::oGetFormato VAR ::oDbfVir:cFormato;
         ID       440;
         OF       oDlg

      REDEFINE BUTTON ::oBtnSerie ;
         ID       500 ;
         OF       oDlg ;
         ACTION   ( nil )

      ::oBtnSerie:bAction     := {|| ::oParent:oDetSeriesMovimientos:Resource( nMode ) }

      REDEFINE BUTTON oBtn;
         ID       510 ;
         OF       oDlg ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( ::ValidResource( nMode, oDlg, oBtn ) )

      REDEFINE BUTTON ;
         ID       520 ;
         OF       oDlg ;
         ACTION   ( oDlg:end() )

      if nMode != ZOOM_MODE

         if uFieldEmpresa( "lGetLot")
            oDlg:AddFastKey( VK_RETURN, {|| ::oRefMov:lValid(), oBtn:SetFocus(), oBtn:Click() } )
         end if 

         oDlg:AddFastKey( VK_F5, {|| oBtn:Click() } )

         oDlg:AddFastKey( VK_F6, {|| ::oBtnSerie:Click() } )
         
      end if

      oDlg:bStart             := {|| ::SetDlgMode( nMode, oSayTotal, oSayPre ) }

   oDlg:Activate( , , , .t., , , {|| ::MenuResource( oDlg ) } )

   // Salida del dialogo----------------------------------------------------------

   ::oMenu:end()

   ::cOldCodArt            := ""
   ::cOldValPr1            := ""
   ::cOldValPr2            := ""
   ::cOldLote              := ""

RETURN ( oDlg:nResult )

//--------------------------------------------------------------------------//

METHOD MenuResource( oDlg ) CLASS TDetMovimientos

   MENU ::oMenu

      MENUITEM    "&1. Rotor"

         MENU

            MENUITEM    "&1. Modificar de artículo";
               MESSAGE  "Modificar la ficha del artículo" ;
               RESOURCE "gc_object_cube_16";
               ACTION   ( EdtArticulo( ::oRefMov:VarGet() ) );

            MENUITEM    "&2. Informe de artículo";
               MESSAGE  "Abrir el informe del artículo" ;
               RESOURCE "Info16";
               ACTION   ( InfArticulo( ::oRefMov:VarGet() ) );

         ENDMENU

   ENDMENU

   oDlg:SetMenu( ::oMenu )

Return ( ::oMenu )

//---------------------------------------------------------------------------//

METHOD ValidResource( nMode, oDlg, oBtn ) CLASS TDetMovimientos

   oBtn:SetFocus()

   if empty( ::oDbfVir:cRefMov )
      msgstop( "Código de artículo vacío." )
      ::oRefMov:SetFocus()
      Return .f.
   end if

   if empty( ::oBrwPrp:Cargo )
      if !::alertControlStockUnderMin()
         ::oRefMov:SetFocus()
         Return .f.
      end if
   end if

   // Control para numeros de serie--------------------------------------------

   if ( ::isNumeroSerieNecesario( nMode ) )
      Return .f.
   end if

   oDlg:end( IDOK )

RETURN ( .t. )

//--------------------------------------------------------------------------//

METHOD RollBack() CLASS TDetMovimientos

   local cStm

   ::oParent:GetFirstKey()
   if ::oParent:cFirstKey != nil

      if ::oDbf:Seek( ::oParent:cFirstKey )
         while !( ::oDbf:eof() )
            ::oParent:TComercio:appendProductsToUpadateStocks( ::oDbf:cRefMov, ::oParent:nView )
            ::oDbf:skip()
         end while
      end if 

      if lAIS()

         cStm        := "DELETE FROM " + cPatEmp() + "HisMov" + " WHERE nNumRem = " + alltrim( str( ::oParent:oDbf:nNumRem ) ) + " AND cSufRem = '" + ::oParent:oDbf:cSufRem + "'"
         TDataCenter():ExecuteSqlStatement( cStm, "RollBackDetMovimientos" )

      else 

         while ::oDbf:Seek( ::oParent:cFirstKey )
            ::oDbf:Delete()
            if !empty( ::oParent ) .and. !empty( ::oParent:oMeter )
               ::oParent:oMeter:AutoInc()
            end if
         end while

      end if 

   end if

Return .t.

//---------------------------------------------------------------------------//

METHOD loadArticulo( cCodArt, nMode, lSilenceMode ) CLASS TDetMovimientos

   local a
   local nPos
   local nPreMed
   local cValPr1           := ""
   local cValPr2           := ""
   local lChgCodArt        := .f.
   local hHas128
   local cLote
   local dFechaCaducidad
   local nUnidades         := 0

   DEFAULT lSilenceMode    := .f.

   if empty( cCodArt )
      if !empty( ::oBrwPrp )
         ::oBrwPrp:Hide()
      end if
      Return .t.
   end if

   // Detectamos si hay cambios en los codigos y propiedades-------------------

   lChgCodArt              := ( rtrim( ::cOldCodArt ) != rtrim( cCodArt ) .or. ::cOldLote != ::oDbfVir:cLote .or. ::cOldValPr1 != ::oDbfVir:cValPr1 .or. ::cOldValPr2 != ::oDbfVir:cValPr2 )

   /*
   Buscamos codificacion GS1-128--------------------------------------------
   */

   if Len( Alltrim( cCodArt ) ) > 18

      hHas128              := ReadHashCodeGS128( cCodArt )

      if !empty( hHas128 )
         
         cCodArt           := uGetCodigo( hHas128, "00" )

         if Empty( cCodArt )
            cCodArt        := uGetCodigo( hHas128, "01" )
         end if
         
         cLote             := Upper( uGetCodigo( hHas128, "10" ) )
         
         dFechaCaducidad   := uGetCodigo( hHas128, "15" )     
         
      end if 

   end if

   // Conversión a codigo interno-------------------------------------------------

   cCodArt                 := cSeekCodebar( cCodArt, ::oParent:oDbfBar:cAlias, ::oParent:oArt:cAlias )

   // Articulos con numeros de serie no podemos pasarlo en regularizacion por objetivos

   if ( ::oParent:oDbf:nTipMov == 3 ) .and. ( retFld( cCodArt, ::oParent:oArt:cAlias, "lNumSer" ) )
      msgstop( "Artículos con números de serie no pueden incluirse regularizaciones por objetivo." )
      Return .f.
   end if

   // Ahora buscamos por el codigo interno----------------------------------------

   if aSeekProp( @cCodArt, @cValPr1, @cValPr2, ::oParent:oArt:cAlias, ::oParent:oTblPro:cAlias ) // ::oArt:Seek( xVal ) .OR. ::oArt:Seek( Upper( xVal ) )

      CursorWait()

      if ( lChgCodArt )

         if !empty(::oRefMov )
            ::oRefMov:cText( ::oParent:oArt:Codigo )
         end if 
            
         ::oDbfVir:cRefMov    := ::oParent:oArt:Codigo
         
         if !empty(::oGetDetalle)
            ::oGetDetalle:cText( ::oParent:oArt:Nombre )
         else 
            ::oDbfVir:cNomMov    := ::oParent:oArt:Nombre 
         end if 

         // Propiedades--------------------------------------------------------

         if !empty( cValPr1 ) 
            if !empty( ::oValPr1 )
               ::oValPr1:cText( cValPr1 )
            else 
               ::oDbfVir:cValPr1    := cValPr1
            end if
         end if 

         if !empty( cValPr2 )
            if !empty( ::oValPr2 )
               ::oValPr2:cText( cValPr2 )
            else 
               ::oDbfVir:cValPr2    := cValPr2
            end if
         end if 

         // Dejamos pasar a los productos de tipo kit-----------------------

         if ::oParent:oArt:lKitArt
            ::oDbfVir:lNoStk     := !lStockCompuestos( ::oParent:oArt:Codigo, ::oParent:oArt:cAlias )
            ::oDbfVir:lKitArt    := .t.
            ::oDbfVir:lKitEsc    := .f.
            ::oDbfVir:lImpLin    := lImprimirCompuesto( ::oParent:oArt:Codigo, ::oParent:oArt:cAlias )
            ::oDbfVir:lKitPrc    := !lPreciosCompuestos( ::oParent:oArt:Codigo, ::oParent:oArt:cAlias )
         else
            ::oDbfVir:lNoStk     := ( ::oParent:oArt:nCtlStock > 1 )
            ::oDbfVir:lKitArt    := .f.
            ::oDbfVir:lKitEsc    := .f.
            ::oDbfVir:lImpLin    := .f.
            ::oDbfVir:lKitPrc    := .f.
         end if

         if ::oParent:oArt:nCajEnt != 0 .and. ::oDbfVir:nCajMov == 0
            if !empty(::oCajMov)
               ::oCajMov:cText( ::oParent:oArt:nCajEnt )
            else
               ::oDbfVir:nCajMov := ::oParent:oArt:nCajEnt
            end if 
         end if

         if ::oDbfVir:nUndMov == 0
            if !empty(::oUndMov)
               ::oUndMov:cText( max( ::oParent:oArt:nUniCaja, 1 ) )
            else
               ::oDbfVir:nUndMov := max( ::oParent:oArt:nUniCaja, 1 )
            end if
         end if

         // Peso y Volumen--------------------------------------------------------

         ::oDbfVir:nVolumen      := ::oParent:oArt:nVolumen
         ::oDbfVir:cVolumen      := ::oParent:oArt:cVolumen
         ::oDbfVir:nPesoKg       := ::oParent:oArt:nPesoKg
         ::oDbfVir:cPesoKg       := ::oParent:oArt:cUndDim

         // Lotes-----------------------------------------------------------------

         ::oDbfVir:lLote         := ::oParent:oArt:lLote

         if Empty( ::oDbfVir:cLote )
            if Empty( cLote )
               ::oDbfVir:cLote         := ::oParent:oArt:cLote
            else
               ::oDbfVir:cLote         := cLote
            end if
         end if

         if ::oParent:oArt:lLote
            if !empty(::oSayLote)
               ::oSayLote:Show()
            end if 
            if !empty(::oGetLote)
               ::oGetLote:Show()
            end if 
            if !empty(::oFechaCaducidad)
               ::oFechaCaducidad:Show()
            end if 
         else
            if !empty(::oSayLote)
               ::oSayLote:Hide()
            end if 
            if !empty(::oGetLote)
               ::oGetLote:Hide()
            end if 
            if !empty(::oFechaCaducidad)
               ::oFechaCaducidad:Hide()
            end if 
         end if

         // Propiedades--------------------------------------------------------------

         ::oDbfVir:cCodPr1       := ::oParent:oArt:cCodPrp1
         ::oDbfVir:cCodPr2       := ::oParent:oArt:cCodPrp2

         if ( !empty( ::oDbfVir:cCodPr1 ) .or. !empty( ::oDbfVir:cCodPr2 ) )     .and.;
            ( !lemptyProp( ::oDbfVir:cCodPr1, ::oParent:oTblPro:cAlias ) .or. !lemptyProp( ::oDbfVir:cCodPr2, ::oParent:oTblPro:cAlias ) ) .and.;
            ( empty( ::oDbfVir:cValPr1 ) .or. empty( ::oDbfVir:cValPr2 ) )       .and.;
            ( uFieldEmpresa( "lUseTbl" )                                         .and.;
            ( nMode == APPD_MODE ) )

            if( !empty(::oValPr1),  ::oValPr1:Hide(),    )
            if( !empty(::oSayPr1),  ::oSayPr1:Hide(),    )
            if( !empty(::oSayVp1),  ::oSayVp1:Hide(),    )
            if( !empty(::oValPr2),  ::oValPr2:Hide(),    )
            if( !empty(::oSayPr2),  ::oSayPr2:Hide(),    )
            if( !empty(::oSayVp2),  ::oSayVp2:Hide(),    )
            if( !empty(::oSayLote), ::oSayLote:Hide(),   )
            if( !empty(::oGetLote), ::oGetLote:Hide(),   )
            if( !empty(::oFechaCaducidad), ::oFechaCaducidad:Hide(), )

            setPropertiesTable( ::oParent:oArt:Codigo, ::oDbfVir:cCodPr1, ::oDbfVir:cCodPr2, 0, ::oUndMov, ::oBrwPrp, ::oParent:nView )

         else

            hidePropertiesTable( ::oBrwPrp )

            if !empty( ::oDbfVir:cCodPr1 )
               if( !empty(::oValPr1), ::oValPr1:show(), )
               if( !empty(::oSayPr1), ::oSayPr1:show(), )
               if( !empty(::oSayPr1), ::oSayPr1:setText( retProp( ::oDbfVir:cCodPr1 ) ), )
               if( !empty(::oSayVp1), ::oSayVp1:show(), )
            else
               if( !empty(::oValPr1), ::oValPr1:Hide(), )
               if( !empty(::oSayPr1), ::oSayPr1:Hide(), )
               if( !empty(::oSayVp1), ::oSayVp1:Hide(), )
            end if

            if !empty( ::oDbfVir:cCodPr2 )
               if( !empty(::oValPr2), ::oValPr2:show(), )
               if( !empty(::oSayPr2), ::oSayPr2:show(), )
               if( !empty(::oSayPr2), ::oSayPr2:setText( retProp( ::oDbfVir:cCodPr2 ) ), )
               if( !empty(::oSayVp2), ::oSayVp2:show(), )
            else
               if( !empty(::oValPr2), ::oValPr2:Hide(), )
               if( !empty(::oSayPr2), ::oSayPr2:Hide(), )
               if( !empty(::oSayVp2), ::oSayVp2:Hide(), )
            end if

            // Posicionar el foco----------------------------------------------------

            do case
               case !empty( ::oDbfVir:cCodPr1 ) .and. empty( ::oDbfVir:cValPr1 )
                  if( !empty(::oValPr1), ::oValPr1:SetFocus(), )

               case !empty( ::oDbfVir:cCodPr2 ) .and. empty( ::oDbfVir:cValPr2 )
                  if( !empty(::oValPr2), ::oValPr2:SetFocus(), )

               case ::oDbfVir:lLote
                  if( !empty(::oGetLote), ::oGetLote:SetFocus(), )

               otherwise
                  if( !empty(::oUndMov), ::oUndMov:SetFocus(), )

            end case

         end if

         // fecha de caducidad-------------------------------------------------

         if Empty( dFechaCaducidad )

            if !empty( ::oFechaCaducidad )
               ::oFechaCaducidad:cText( dFechaCaducidadLote( ::oDbfVir:cRefMov, ::oDbfVir:cValPr1, ::oDbfVir:cValPr2, ::oDbfVir:cLote, ::oParent:oAlbPrvL:cAlias, ::oParent:oFacPrvL:cAlias, ::oParent:oDbfProLin:cAlias ) )
            else
               ::oDbfVir:dFecCad    := dFechaCaducidadLote( ::oDbfVir:cRefMov, ::oDbfVir:cValPr1, ::oDbfVir:cValPr2, ::oDbfVir:cLote, ::oParent:oAlbPrvL:cAlias, ::oParent:oFacPrvL:cAlias, ::oParent:oDbfProLin:cAlias )
            end if 

         else

            if !empty( ::oFechaCaducidad )
               ::oFechaCaducidad:cText( dFechaCaducidad )
            else
               ::oDbfVir:dFecCad    := dFechaCaducidad
            end if             

         end if
        
         // Precios de costo---------------------------------------------------

         if !empty(::oPreDiv)
            ::oPreDiv:cText( ::getPrecioCosto() )
         else
            ::oDbfVir:nPreDiv    := ::getPrecioCosto()
         end if 

         // Stock actual-------------------------------------------------------

         if !empty( ::oGetStockOrigen )
            ::oParent:oStock:lPutStockActual( ::oDbfVir:cRefMov, ::oParent:oDbf:cAlmOrg, ::oDbfVir:cValPr1, ::oDbfVir:cValPr2, ::oDbfVir:cLote, .f., ::oParent:oArt:nCtlStock, ::oGetStockOrigen )
         end if 

         if !empty( ::oGetStockDestino )
            ::oParent:oStock:lPutStockActual( ::oDbfVir:cRefMov, ::oParent:oDbf:cAlmDes, ::oDbfVir:cValPr1, ::oDbfVir:cValPr2, ::oDbfVir:cLote, .f., ::oParent:oArt:nCtlStock, ::oGetStockDestino )
         end if 

         // Guardamos el stock anterior----------------------------------------

         SysRefresh()

         nPos                 := aScan( ::oParent:oStock:aStocks, {|o| o:cCodigo == ::oParent:oArt:Codigo .and. o:cCodigoAlmacen == ::oParent:oDbf:cAlmDes .and. o:cValorPropiedad1 == ::oDbfVir:cValPr1 .and. o:cValorPropiedad2 == ::oDbfVir:cValPr2 .and. o:cLote == ::oDbfVir:cLote .and. o:cNumeroSerie == ::oDbfVir:mNumSer } )
         if ( nPos != 0 ) .and. ( isNum( ::oParent:oStock:aStocks[ nPos ]:nUnidades ) )
            ::oDbfVir:nUndAnt := ::oParent:oStock:aStocks[ nPos ]:nUnidades
         end if

      end if

      // Variables para no volver a ejecutar--------------------------------

      ::cOldLote              := ::oDbfVir:cLote
      ::cOldCodArt            := ::oDbfVir:cRefMov
      ::cOldValPr1            := ::oDbfVir:cValPr1
      ::cOldValPr2            := ::oDbfVir:cValPr2

      CursorWE()

   else

      if !lSilenceMode
         msgstop( "Artículo no encontrado." )
      end if 

      Return .f.

   end if

Return .t.

//--------------------------------------------------------------------------//

METHOD getPrecioCosto() CLASS TDetMovimientos

   local nPrecioCosto   := 0

   if !uFieldEmpresa( "lCosAct" )
      if ( ::oParent:oDbf:nTipMov == 1 )
         nPrecioCosto   := ::oParent:oStock:nCostoMedio( ::oDbfVir:cRefMov, ::oParent:oDbf:cAlmOrg, ::oDbfVir:cCodPr1, ::oDbfVir:cCodPr2, ::oDbfVir:cValPr1, ::oDbfVir:cValPr2, ::oDbfVir:cLote )
      else
         nPrecioCosto   := ::oParent:oStock:nCostoMedio( ::oDbfVir:cRefMov, ::oParent:oDbf:cAlmDes, ::oDbfVir:cCodPr1, ::oDbfVir:cCodPr2, ::oDbfVir:cValPr1, ::oDbfVir:cValPr2, ::oDbfVir:cLote )
      end if
   end if 

   if ( nPrecioCosto == 0 )
      nPrecioCosto      := nCosto( ::oDbfVir:cRefMov, ::oParent:oArt:cAlias, ::oParent:oArtKit:cAlias )
   end if

Return ( nPrecioCosto )

//--------------------------------------------------------------------------//

METHOD nStockActualAlmacen( cCodAlm ) CLASS TDetMovimientos

   local aStock      := {}
   local nTotStock   := 0

   MsgInfo( hb_valtoExp( ::aStockActual ), "aStockActual" )

   for each aStock in ::aStockActual

      if aStock[ 1 ] == cCodAlm
         nTotStock   += aStock[ 6 ]
      end if

   next

RETURN nTotStock

//---------------------------------------------------------------------------//

METHOD SetDlgMode( nMode, oSayTotal, oSayPre ) CLASS TDetMovimientos

   ::oBrwPrp:Hide()

   if ( ::oParent:oDbf:nTipMov == 3 )
      ::oBtnSerie:Hide()
   end if

   if nMode == APPD_MODE

      ::oSayLote:Hide()
      ::oGetLote:Hide()

      ::oFechaCaducidad:Hide()

      ::oValPr1:Hide()
      ::oSayPr1:Hide()
      ::oSayVp1:Hide()

      ::oValPr2:Hide()
      ::oSayPr2:Hide()
      ::oSayVp2:Hide()

      if !uFieldEmpresa( "lUseBultos" )
         ::oGetBultos:Hide()
         ::oSayBultos:Hide()
      end if 

      if !lUseCaj()
         ::oCajMov:Hide()
         ::oSayCaj:Hide()
      end if

   else

      if ::oDbfVir:lLote
         ::oGetLote:Show()
         ::oSayLote:Show()
         ::oFechaCaducidad:Show()
      else
         ::oGetLote:Hide()
         ::oSayLote:Hide()
         ::oFechaCaducidad:Hide()
      end if

      if !empty( ::oDbfVir:cValPr1 )
         ::oSayPr1:Show()
         ::oSayVp1:Show()
         ::oValPr1:Show()
         ::oSayPr1:SetText( retProp( ::oDbfVir:cCodPr1 ) )
         lPrpAct( ::oDbfVir:cValPr1, ::oSayVp1, ::oDbfVir:cCodPr1, ::oParent:oTblPro:cAlias )
      else
         ::oValPr1:Hide()
         ::oSayPr1:Hide()
         ::oSayVp1:Hide()
      end if

      if !empty( ::oDbfVir:cValPr2 )
         ::oSayPr2:Show()
         ::oSayVp2:Show()
         ::oValPr2:Show()
         ::oSayPr2:SetText( retProp( ::oDbfVir:cCodPr2 ) )
         lPrpAct( ::oDbfVir:cValPr2, ::oSayVp2, ::oDbfVir:cCodPr2, ::oParent:oTblPro:cAlias )
      else
         ::oValPr2:Hide()
         ::oSayPr2:Hide()
         ::oSayVp2:Hide()
      end if

      if !uFieldempresa( "lUseBultos" )
         ::oGetBultos:Hide()
         ::oSayBultos:Hide()
      end if

      if !lUseCaj()
         ::oCajMov:Hide()
         ::oSayCaj:Hide()
         ::oSayUnd:SetText( "Unidades" )
      end if

   end if

   /*
   Ocultamos el costo si el usuario no tiene permisos para verlo---------------
   */

   if !empty( ::oPreDiv ) .and. oUser():lNotCostos()
      ::oPreDiv:Hide()
   end if

   if !empty( oSayTotal ) .and. oUser():lNotCostos()
      oSayTotal:Hide()
   end if

   if !empty( oSayPre ) .and. oUser():lNotCostos()
      oSayPre:Hide()
   end if

   /*
   Cargamos la configuracion de columnas---------------------------------------
   */

   if empty( ::oParent:oDbf:cAlmOrg )
      ::oGetAlmacenOrigen:Hide()
      ::oTxtAlmacenOrigen:Hide()
      ::oGetStockOrigen:Hide()
   end if

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD AppendKit() CLASS TDetMovimientos

   local nRec     := ::oDbfVir:Recno()
   local nNumLin  := ::oDbfVir:nNumLin
   local cCodArt  := ::oDbfVir:cRefMov
   local nTipMov  := ::oDbfVir:nTipMov
   local cCodMov  := ::oDbfVir:cCodMov
   local nCajMov  := ::oDbfVir:nCajMov
   local nUndMov  := ::oDbfVir:nUndMov
   local nNumRem  := ::oDbfVir:nNumRem
   local cSufRem  := ::oDbfVir:cSufRem
   local cCodUsr  := ::oDbfVir:cCodUsr
   local cCodDlg  := ::oDbfVir:cCodDlg
   local nTotUnd  := 0
   local nStkAct  := 0
   local nMinimo  := 0
   local cAliMov  := ::oParent:oDbf:cAlmDes
   local cAloMov  := ::oParent:oDbf:cAlmOrg

   if ::oParent:oArtKit:SeekInOrd( cCodArt, "cCodKit" )

      while ( ::oParent:oArtKit:cCodKit == cCodArt ) .and. !( ::oParent:oArtKit:Eof() )

         if ::oParent:oArt:SeekInOrd( ::oParent:oArtKit:cRefKit, "Codigo" ) .and. lStockComponentes( cCodArt, ::oParent:oArt:cAlias )

            nStkAct              := ::oParent:oStock:nStockAlmacen( ::oParent:oArtKit:cRefKit, cAloMov )

            ::oDbfVir:Append()

            ::oDbfVir:dFecMov    := getSysDate()
            ::oDbfVir:cTimMov    := getSysTime()
            ::oDbfVir:nTipMov    := nTipMov
            ::oDbfVir:cAliMov    := cAliMov
            ::oDbfVir:cAloMov    := cAloMov
            ::oDbfVir:cRefMov    := ::oParent:oArtKit:cRefKit
            ::oDbfVir:cNomMov    := ::oParent:oArtKit:cDesKit
            ::oDbfVir:cCodMov    := cCodMov
            ::oDbfVir:cCodPr1    := Space( 20 )
            ::oDbfVir:cCodPr2    := Space( 20 )
            ::oDbfVir:cValPr1    := Space( 20 )
            ::oDbfVir:cValPr2    := Space( 20 )
            ::oDbfVir:cCodUsr    := cCodUsr
            ::oDbfVir:cCodDlg    := cCodDlg
            ::oDbfVir:lLote      := ::oParent:oArt:lLote
            ::oDbfVir:nLote      := ::oParent:oArt:nLote
            ::oDbfVir:cLote      := ::oParent:oArt:cLote
            ::oDbfVir:nCajMov    := nCajMov
            ::oDbfVir:nUndMov    := ::oParent:oArtKit:nUndKit * nUndMov

            if nTipMov == 3
               ::oDbfVir:nCajAnt := 0
               ::oDbfVir:nUndAnt := nStkAct
            end if

            ::oDbfVir:nPreDiv    := ::oParent:oArt:pCosto
            ::oDbfVir:lSndDoc    := .t.
            ::oDbfVir:nNumRem    := nNumRem
            ::oDbfVir:cSufRem    := cSufRem
            ::oDbfVir:lSelDoc    := .t.

            ::oDbfVir:lKitArt    := .f.
            ::oDbfVir:lNoStk     := .f.
            ::oDbfVir:lImpLin    := lImprimirComponente( cCodArt, ::oParent:oArt:cAlias )
            ::oDbfVir:lKitPrc    := !lPreciosComponentes( cCodArt, ::oParent:oArt:cAlias )

            if lKitAsociado( cCodArt, ::oParent:oArt:cAlias )
               ::oDbfVir:nNumLin := nLastNum( ::oDbfVir:cAlias )
               ::oDbfVir:lKitEsc := .f.
            else
               ::oDbfVir:nNumLin := nNumLin
               ::oDbfVir:lKitEsc := .t.
            end if

            /*
            Avisamos en movimientos con stock bajo minimo-------------------------------
            */

            nTotUnd              := NotCaja( ::oDbfVir:nCajMov ) * ::oDbfVir:nUndMov
            nMinimo              := oRetFld( ::oDbfVir:cRefMov, ::oParent:oArt, "nMinimo" )

            if nTotUnd != 0 .and. oRetFld( ::oDbfVir:cRefMov, ::oParent:oArt, "lMsgMov" )

               if ( ( nStkAct - nTotUnd ) < nMinimo )

                  msgstop( "El stock del componente " + AllTrim( ::oDbfVir:cRefMov ) + " - " + AllTrim( oRetFld( ::oDbfVir:cRefMov, ::oParent:oArt, "Nombre" ) ) + CRLF + ;
                           "está bajo minimo." + CRLF + ;
                           "Unidades a vender : " + AllTrim( Trans( nTotUnd, MasUnd() ) ) + CRLF + ;
                           "Stock actual : " + AllTrim( Trans( nStkAct, MasUnd() ) )      + CRLF + ;
                           "Stock minimo : " + AllTrim( Trans( nMinimo, MasUnd() ) ),;
                           "¡Atención!" )

               end if

            end if

            ::oDbfVir:Save()

         end if

         ::oParent:oArtKit:Skip()

      end while

   end if

   /*
   Volvemos al registro en el que estabamos y refrescamos el browse------------
   */

   ::oDbfVir:GoTo( nRec )

   ::refreshDetail()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD aStkArticulo() CLASS TDetMovimientos

   ::nStockActual       := 0

   if !empty( ::oDbfVir:cRefMov ) .and. oRetFld( ::oDbfVir:cRefMov, ::oParent:oArt, "nCtlStock" ) <= 1

      ::oParent:oStock:aStockArticulo( ::oDbfVir:cRefMov, , ::oBrwStock )

      aEval( ::oBrwStock:aArrayData, {|o| ::nStockActual += o:nUnidades } )

      ::oBrwStock:Show()

   else

      ::oBrwStock:Hide()

   end if

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD ActualizaKit( nMode ) CLASS TDetMovimientos

   local nRec     := ::oDbfVir:Recno()
   local nOrdAnt  := ::oDbfVir:OrdSetFocus( "nNumLin" )
   local cRefMov  := ::oDbfVir:cRefMov
   local nNumLin  := ::oDbfVir:FieldGetName( "nNumLin" )
   local nCajMov
   local nUndMov

   do case
      case nMode == APPD_MODE
         nCajMov  := ::oDbfVir:FieldGetName( "nCajMov" )
         nUndMov  := ::oDbfVir:FieldGetName( "nUndMov" )

      case nMode == EDIT_MODE
         nCajMov  := ::oDbfVir:nCajMov
         nUndMov  := ::oDbfVir:nUndMov

   end if

   ::oDbfVir:GoTop()

   while !::oDbfVir:Eof()

      if ::oDbfVir:FieldGetName( "nNumLin" ) == nNumLin        .and.;
         ::oDbfVir:FieldGetName( "lKitEsc" )                   .and.;
         ::oParent:oArtKit:SeekInOrd( cRefMov + ::oDbfVir:FieldGetName( "cRefMov" ), "cCodRef" )

         ::oDbfVir:FieldPutByName( "nCajMov", nCajMov )
         ::oDbfVir:FieldPutByName( "nUndMov", ( nUndMov * ::oParent:oArtKit:nUndKit ) )

      end if

      ::oDbfVir:Skip()

   end while

   ::oDbfVir:OrdSetFocus( nOrdAnt )

   ::oDbfVir:GoTo( nRec )

RETURN ( Self )

//---------------------------------------------------------------------------//
/*
Guardamos todo de manera definitiva--------------------------------------------
*/

METHOD Save() CLASS TDetMovimientos

   local nSec
   local oWaitMeter
   local nKeyCount   := ::oDbfVir:ordKeyCount()

   oWaitMeter        := TWaitMeter():New( "Guardando movimientos de almacén", "Espere por favor..." )
   oWaitMeter:Run()
   oWaitMeter:setTotal( nKeyCount )

   cursorWait()

   ::oDbfVir:KillFilter()

   ::oDbfVir:GetStatus()
   ::oDbfVir:OrdSetFocus( 0 )

   do case
   case ::oParent:oDbf:nTipMov == 1

      ::oDbfVir:GoTop()
      while !::oDbfVir:Eof()

         ::Asigna()

         ::oParent:TComercio:appendProductsToUpadateStocks( ::oDbfVir:cRefMov, ::oParent:nView )

         ::oDbf:AppendFromObject( ::oDbfVir )

         ::oDbfVir:Skip()

         oWaitMeter:setMessage( "Guardando movimiento " + alltrim( str( ::oDbfVir:OrdKeyNo() ) ) + " de " + alltrim( str( nKeyCount ) ) )
         oWaitMeter:AutoInc()

      end while

   case ::oParent:oDbf:nTipMov == 2

      ::oDbfVir:GoTop()
      while !::oDbfVir:Eof()

         ::Asigna()

         ::oParent:TComercio:appendProductsToUpadateStocks( ::oDbfVir:cRefMov, ::oParent:nView )

         ::oDbf:AppendFromObject( ::oDbfVir )

         ::oDbfVir:Skip()

         oWaitMeter:setMessage( "Guardando movimiento " + alltrim( str( ::oDbfVir:OrdKeyNo() ) ) + " de " + alltrim( str( nKeyCount ) ) )
         oWaitMeter:AutoInc()

      end while

   case ::oParent:oDbf:nTipMov == 3

      ::oDbfVir:GoTop()
      while !::oDbfVir:Eof()

         ::oParent:TComercio:appendProductsToUpadateStocks( ::oDbfVir:cRefMov, ::oParent:nView )

//         if ( ::oParent:lTargetCalculate ) 
//
//            ::Asigna()
//
//            ::oDbfVir:fieldPutByName( "lSelDoc", .f. )
//            ::oDbfVir:fieldPutByName( "nUndMov", ( nTotNMovAlm( ::oDbfVir ) - nTotNMovOld( ::oDbfVir ) ) / NotCero( ::oDbfVir:nCajMov ) )
//
//            ::oDbf:AppendFromObject( ::oDbfVir )
//
//         else
            
            ::Asigna()

            ::oDbf:AppendFromObject( ::oDbfVir )

//         end if

         ::oDbfVir:Skip()

         oWaitMeter:setMessage( "Guardando movimiento " + alltrim( str( ::oDbfVir:OrdKeyNo() ) ) + " de " + alltrim( str( nKeyCount ) ) )
         oWaitMeter:AutoInc()

      end while

   case ::oParent:oDbf:nTipMov == 4

      ::oDbfVir:GoTop()
      while !::oDbfVir:Eof()

         ::Asigna()

         ::oParent:TComercio:appendProductsToUpadateStocks( ::oDbfVir:cRefMov, ::oParent:nView )

         ::oDbf:AppendFromObject( ::oDbfVir )

         ::oDbfVir:Skip()

         oWaitMeter:setMessage( "Guardando movimiento " + alltrim( str( ::oDbfVir:OrdKeyNo() ) ) + " de " + alltrim( str( nKeyCount ) ) )
         oWaitMeter:AutoInc()

      end while

   end case

   ::oDbfVir:SetStatus()

   oWaitMeter:end()

   cursorWE()

Return .t.

//---------------------------------------------------------------------------//

METHOD Asigna() CLASS TDetMovimientos

   ::oDbfVir:fieldPutByName( "nNumRem",   ::oParent:oDbf:nNumRem )
   ::oDbfVir:fieldPutByName( "cSufRem",   ::oParent:oDbf:cSufRem )
   ::oDbfVir:fieldPutByName( "dFecMov",   ::oParent:oDbf:dFecRem )
   ::oDbfVir:fieldPutByName( "cTimMov",   ::oParent:oDbf:cTimRem )
   ::oDbfVir:fieldPutByName( "nTipMov",   ::oParent:oDbf:nTipMov )
   ::oDbfVir:fieldPutByName( "cCodMov",   ::oParent:oDbf:cCodMov )
   ::oDbfVir:fieldPutByName( "cAliMov",   ::oParent:oDbf:cAlmDes )
   ::oDbfVir:fieldPutByName( "cAloMov",   ::oParent:oDbf:cAlmOrg )
   ::oDbfVir:fieldPutByName( "cCodUsr",   ::oParent:oDbf:cCodUsr )
   ::oDbfVir:fieldPutByName( "cCodDlg",   ::oParent:oDbf:cCodDlg )
   ::oDbfVir:fieldPutByName( "lWait",     ::oParent:oDbf:lWait   )
   ::oDbfVir:fieldPutByName( "lSndDoc",   .t. )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD nTotRemVir( lPic ) CLASS TDetMovimientos

   local nTot     := 0

   DEFAULT lPic   := .f.

   if ::oDbfVir != nil .and. ::oDbfVir:Used()

      ::oDbfVir:GetStatus()
      ::oDbfVir:GoTop()

      while !::oDbfVir:eof()
         nTot     += nTotLMovAlm( ::oDbfVir )
         ::oDbfVir:Skip()
      end while

      ::oDbfVir:SetStatus()

   end if

RETURN ( if( lPic, Trans( nTot, ::oParent:cPirDiv ), nTot ) )

//---------------------------------------------------------------------------//

METHOD nTotUnidadesVir( lPic ) CLASS TDetMovimientos

   local nTot     := 0

   DEFAULT lPic   := .f.

   if ::oDbfVir != nil .and. ::oDbfVir:Used()

      ::oDbfVir:GetStatus()
      ::oDbfVir:GoTop()

      while !::oDbfVir:eof()
         nTot     += nTotNMovAlm( ::oDbfVir )
         ::oDbfVir:Skip()
      end while

      ::oDbfVir:SetStatus()

   end if

RETURN ( if( lPic, Trans( nTot, ::oParent:cPicUnd ), nTot ) )

//---------------------------------------------------------------------------//

METHOD nTotPesoVir( lPic ) CLASS TDetMovimientos

   local nPeso    := 0

   DEFAULT lPic   := .f.

   if ::oDbfVir != nil .and. ::oDbfVir:Used()

      ::oDbfVir:GetStatus()
      ::oDbfVir:GoTop()

      while !::oDbfVir:Eof()
         nPeso    += ( NotCaja( ::oDbfVir:nCajMov ) * ::oDbfVir:nUndMov ) * ::oDbfVir:nPesoKg
         ::oDbfVir:Skip()
      end while

      ::oDbfVir:SetStatus()

   end if

RETURN ( if( lPic, Trans( nPeso, MasUnd() ), nPeso ) )

//---------------------------------------------------------------------------//

METHOD nTotVolumenVir( lPic ) CLASS TDetMovimientos

   local nVolumen    := 0

   DEFAULT lPic      := .f.

   if ::oDbfVir != nil .and. ::oDbfVir:Used()

      ::oDbfVir:GetStatus()
      ::oDbfVir:GoTop()

      while !::oDbfVir:Eof()
         nVolumen    += ( NotCaja( ::oDbfVir:nCajMov ) * ::oDbfVir:nUndMov ) * ::oDbfVir:nVolumen
         ::oDbfVir:Skip()
      end while

      ::oDbfVir:SetStatus()

   end if

RETURN ( if( lPic, Trans( nVolumen, MasUnd() ), nVolumen ) )

//---------------------------------------------------------------------------//

METHOD RecalcularPrecios() CLASS TDetMovimientos

   local nKeyCount
   local oWaitMeter

   if !msgYesNo( "¿Desea recalcular los precios de costo y el stock actual?", "Confirme")
      Return .f.
   end if 

   ::cOldCodArt      := ""
   ::cOldAliMov      := ""
   ::cOldValPr1      := ""
   ::cOldValPr2      := ""

   ::oDbfVir:getStatus()
   ::oDbfVir:ordsetfocus( "cRefAlm" )

   nKeyCount         := ::oDbfVir:ordKeyCount()

   oWaitMeter        := TWaitMeter():New( "Recalculando precios y stock", "Espere por favor..." )
   oWaitMeter:Run()
   oWaitMeter:setTotal( nKeyCount )

   CursorWait()

   // acumulacion de lineas----------------------------------------------------

   ::oDbfVir:GoTop()
   while !( ::oDbfVir:eof() )

      if ::isKeyFieldValues()
         ::accumulatesFieldValues()
      end if 

      ::putFieldValues()

      ::oDbfVir:Skip()

   end while

   // recalculo de precios ----------------------------------------------------

   ::oDbfVir:GoTop()
   while !( ::oDbfVir:eof() )

      ::oDbfVir:FieldPutByName( "nPreDiv", ::getPrecioCosto() )

      ::oDbfVir:fieldPutByName( "nUndAnt", ::oParent:oStock:nStockAlmacen( ::oDbfVir:cRefMov, ::oDbfVir:cAliMov, ::oDbfVir:cValPr1, ::oDbfVir:cValPr2, , , ::oParent:oDbf:dFecRem ) )

      oWaitMeter:setMessage( "Recalculando precios y stock " + alltrim( str( ::oDbfVir:OrdKeyNo() ) ) + " de " + alltrim( str( nKeyCount ) ) )
      oWaitMeter:AutoInc()

      ::oDbfVir:Skip()

   end while

   ::oDbfVir:getStatus()

   oWaitMeter:end()

   CursorWE()

Return ( .t. )

//---------------------------------------------------------------------------//

METHOD putFieldValues() CLASS TDetMovimientos

   ::cOldCodArt        := ::oDbfVir:fieldGetByName( "cRefMov" )
   ::cOldAliMov        := ::oDbfVir:fieldGetByName( "cAliMov" )
   ::cOldValPr1        := ::oDbfVir:fieldGetByName( "cValPr1" )
   ::cOldValPr2        := ::oDbfVir:fieldGetByName( "cValPr2" )

Return ( self )

//---------------------------------------------------------------------------//

METHOD isKeyFieldValues() CLASS TDetMovimientos

Return ( ::oDbfVir:fieldGetByName( "cRefMov" ) == ::cOldCodArt .and. ; 
         ::oDbfVir:fieldGetByName( "cAliMov" ) == ::cOldAliMov .and. ; 
         ::oDbfVir:fieldGetByName( "cValPr1" ) == ::cOldValPr1 .and. ;
         ::oDbfVir:fieldGetByName( "cValPr2" ) == ::cOldValPr2 )

//---------------------------------------------------------------------------//

METHOD accumulatesFieldValues() CLASS TDetMovimientos

   local recno                := ::oDbfVir:recno() 
   local cajasMovimiento      := ::oDbfVir:fieldGetByName( "nCajMov" )
   local unidadesMovimiento   := ::oDbfVir:fieldGetByName( "nUndMov" )

   ::oDbfVir:skip( -1 )

   cajasMovimiento            += ::oDbfVir:fieldGetByName( "nCajMov" )
   unidadesMovimiento         += ::oDbfVir:fieldGetByName( "nUndMov" )

   ::oDbfVir:fieldPutByName( "nCajMov", cajasMovimiento )
   ::oDbfVir:fieldPutByName( "nUndMov", unidadesMovimiento )

   ::oDbfVir:skip( 1 )

   ::oDbfVir:delete()

   ::oDbfVir:goto( recno ) 

Return ( self )

//---------------------------------------------------------------------------//

METHOD isNumeroSerieNecesario( nMode, lMessage ) CLASS TDetMovimientos

   if ( nMode != APPD_MODE )
      Return .f.
   end if 

   if ( ::oParent:oDbf:nTipMov == 3 )
      Return .f.
   end if 
   
   DEFAULT lMessage                 := .t.

   ::lNumeroSerieNecesario          := retfld( ::oDbfVir:cRefMov, ::oParent:oArt:cAlias, "lNumSer" )
   ::lNumeroSerieIntroducido        := ::oParent:oDetSeriesMovimientos:oDbfVir:SeekInOrd( Str( ::oDbfVir:nNumLin, 4 ) + ::oDbfVir:cRefMov, "nNumLin" )

   if ( ::lNumeroSerieNecesario ) .and. ( !::lNumeroSerieIntroducido )

      if lMessage
         msgstop( "Tiene que introducir números de serie para este artículo." )
      end if 

      if !empty( ::oBtnSerie )
         ::oBtnSerie:Click()
      end if 

      Return .t.

   end if

Return ( .f. )

//---------------------------------------------------------------------------//

METHOD alertControlStockUnderMin( nStock ) CLASS TDetMovimientos

   local nTotUnd
   local nStkAct
   local lReturn     := .t.
   local cText       := ""

   if ( ::oDbf:nTipMov > 1 )
      Return ( lReturn )
   end if 

   if empty( ::oDbfVir )
      Return ( lReturn )
   end if 

   if !empty( nStock )
      nStkAct        := nStock
   else
      nStkAct        := ::oGetStockOrigen:VarGet()
   end if

   nTotUnd           := nTotNRemMov( ::oDbfVir )

   if nTotUnd != 0 .and. oRetFld( ::oDbfVir:cRefMov, ::oParent:oArt, "lMsgMov" )

      if ( nStkAct - nTotUnd ) < oRetFld( ::oDbfVir:cRefMov, ::oParent:oArt, "nMinimo" )

         cText       := " ( propiedad 1: " + AllTrim( ::oDbfVir:cValPr1 )
         cText       += " propiedad 2: " + AllTrim( ::oDbfVir:cValPr2 ) + " )" + CRLF
         cText       += " Stock actual: " + AllTrim( Trans( nStkAct, MasUnd() ) ) + CRLF
         cText       += " Unidades a mover: " + AllTrim( Trans( nTotUnd, MasUnd() ) )
   
         if !ApoloMsgNoYes( "El stock está por debajo del minimo." + CRLF + cText, "¿Desea continuar?" )
            
            lReturn  := .f.
         
         end if

      end if

   end if

Return ( lReturn )

//---------------------------------------------------------------------------//

METHOD setPropertiesData() CLASS TDetMovimientos

   ::cRefMov   := ::oDbfVir:cRefMov
   ::cNomMov   := ::oDbfVir:cNomMov
   ::dFecMov   := ::oDbfVir:dFecMov
   ::cTimMov   := ::oDbfVir:cTimMov
   ::nTipMov   := ::oDbfVir:nTipMov
   ::cCodMov   := ::oDbfVir:cCodMov
   ::nPreDiv   := ::oDbfVir:nPreDiv
   ::nCajMov   := ::oDbfVir:nCajMov

Return ( .f. )

//---------------------------------------------------------------------------//

METHOD processPropertiesGrid() CLASS TDetMovimientos

   local n
   local i
   local cAliMov  
   local cAloMov  

   if empty( ::oDbfVir )
      Return nil
   end if

   if empty( ::oParent )
      Return nil
   end if 

   cAliMov                       := ::oParent:oDbf:cAlmDes
   cAloMov                       := ::oParent:oDbf:cAlmOrg

   // Metemos las lineas por propiedades---------------------------------------

   for n := 1 to len( ::oBrwPrp:Cargo )

      for i := 1 to len( ::oBrwPrp:Cargo[ n ] )

         if isNum( ::oBrwPrp:Cargo[ n, i ]:Value ) .and. ( ::oBrwPrp:Cargo[ n, i ]:Value != 0 )

            ::oDbfVir:Blank()

            ::oDbfVir:cRefMov    := ::cRefMov
            ::oDbfVir:cNomMov    := ::cNomMov 
            ::oDbfVir:dFecMov    := ::dFecMov
            ::oDbfVir:cTimMov    := ::cTimMov
            ::oDbfVir:nTipMov    := ::nTipMov
            ::oDbfVir:cCodMov    := ::cCodMov
            ::oDbfVir:nCajMov    := ::nCajMov

            ::oDbfVir:cAliMov    := cAliMov
            ::oDbfVir:cAloMov    := cAloMov

            ::oDbfVir:cCodPr1    := ::oBrwPrp:Cargo[ n, i ]:cCodigoPropiedad1
            ::oDbfVir:cCodPr2    := ::oBrwPrp:Cargo[ n, i ]:cCodigoPropiedad2
            ::oDbfVir:cValPr1    := ::oBrwPrp:Cargo[ n, i ]:cValorPropiedad1
            ::oDbfVir:cValPr2    := ::oBrwPrp:Cargo[ n, i ]:cValorPropiedad2
            ::oDbfVir:nUndMov    := ::oBrwPrp:Cargo[ n, i ]:Value
            ::oDbfVir:cCodUsr    := cCurUsr()
            ::oDbfVir:cCodDlg    := oRetFld( cCurUsr(), ::oParent:oUsr, "cCodDlg" )
            ::oDbfVir:lSelDoc    := .t.
            ::oDbfVir:lSndDoc    := .t.
            ::oDbfVir:nNumLin    := nLastNum( ::oDbfVir:cAlias )
            ::oDbfVir:nVolumen   := oRetFld( ::cRefMov, ::oParent:oArt, "" )
            ::oDbfVir:cVolumen   := oRetFld( ::cRefMov, ::oParent:oArt, "" )
            ::oDbfVir:nPesoKg    := oRetFld( ::cRefMov, ::oParent:oArt, "" )
            ::oDbfVir:cPesoKg    := oRetFld( ::cRefMov, ::oParent:oArt, "" )

            if ( ::oBrwPrp:Cargo[ n, i ]:nPrecioCompra != 0 )
               ::oDbfVir:nPreDiv := ::oBrwPrp:Cargo[ n, i ]:nPrecioCompra
            else
               ::oDbfVir:nPreDiv := ::nPreDiv 
            end if 

//            ::oDbfVir:nUndAnt    := ::oParent:oStock:nStockAlmacen( ::cRefMov, ::cAliMov, ::oDbfVir:cValPr1, ::oDbfVir:cValPr2 )

//            if ::alertControlStockUnderMin( ::oParent:oStock:nStockAlmacen( ::oDbfVir:cRefMov, ::oDbfVir:cAloMov, ::oDbfVir:cValPr1, ::oDbfVir:cValPr2 ) )

//               if ::accumulatesStoreMovement()
//                  ::oDbfVir:Cancel()
//               else 
                  ::oDbfVir:Insert()
//               end if

//            end if

         end if

      next

   next

Return ( nil )

//---------------------------------------------------------------------------//

METHOD accumulatesStoreMovement() CLASS TDetMovimientos

   local lFound         := .f.

   if empty( ::oDbfVir )
      Return ( lFound )
   end if 

   if !( ::oDbfVir:getBuffer() )
      Return ( lFound )
   end if 

   ::oDbfVir:GetStatus()

   ::oDbfVir:GoTop()
   while !( ::oDbfVir:eof() )
      
      if alltrim( ::oDbfVir:fieldGetName( "cRefMov" ) ) == alltrim( ::oDbfVir:fieldGetBuffer( "cRefMov" ) ) .and. ;
         alltrim( ::oDbfVir:fieldGetName( "cLote"   ) ) == alltrim( ::oDbfVir:fieldGetBuffer( "cLote"   ) ) .and. ;
         alltrim( ::oDbfVir:fieldGetName( "cCodPr1" ) ) == alltrim( ::oDbfVir:fieldGetBuffer( "cCodPr1" ) ) .and. ;
         alltrim( ::oDbfVir:fieldGetName( "cCodPr2" ) ) == alltrim( ::oDbfVir:fieldGetBuffer( "cCodPr2" ) ) .and. ;
         alltrim( ::oDbfVir:fieldGetName( "cValPr1" ) ) == alltrim( ::oDbfVir:fieldGetBuffer( "cValPr1" ) ) .and. ;
         alltrim( ::oDbfVir:fieldGetName( "cValPr2" ) ) == alltrim( ::oDbfVir:fieldGetBuffer( "cValPr2" ) ) .and. ;
         ::oDbfVir:fieldGetName( "nCajMov" ) == ::oDbfVir:fieldGetBuffer( "nCajMov" )                       .and. ;
         ::oDbfVir:fieldGetName( "nPrediv" ) == ::oDbfVir:fieldGetBuffer( "nPreDiv" )

         ::oDbfVir:fieldPutByName( "nCajMov", ( ::oDbfVir:fieldGetName( "nCajMov" ) + ::oDbfVir:fieldGetBuffer( "nCajMov" ) ) )
         ::oDbfVir:fieldPutByName( "nUndMov", ( ::oDbfVir:fieldGetName( "nUndMov" ) + ::oDbfVir:fieldGetBuffer( "nUndMov" ) ) )
         ::oDbfVir:fieldPutByName( "lSelDoc", .t. )

         if ::oDbfVir:fieldGetName( "lKitArt" )
            ::actualizaKit( APPD_MODE )
         end if

         lFound         := .t.

         exit

      end if

      ::oDbfVir:Skip()

   end while

   ::oDbfVir:SetStatus()

Return ( lFound )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//


