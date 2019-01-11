#include "FiveWin.Ch"
#include "Factu.ch" 
#include "Report.ch"

/*
Definici¢n de la base de datos de Existencias----------------------------------
*/

#define _CSEREXT                  (dbfExtAgeT)->( FieldPos( "CSEREXT" ) )
#define _NNUMEXT                  (dbfExtAgeT)->( FieldPos( "NNUMEXT" ) )
#define _CSUFEXT                  (dbfExtAgeT)->( FieldPos( "CSUFEXT" ) )
#define _DFECEXT                  (dbfExtAgeT)->( FieldPos( "DFECEXT" ) )
#define _CCODALM                  (dbfExtAgeT)->( FieldPos( "CCODALM" ) )
#define _CNOMALM                  (dbfExtAgeT)->( FieldPos( "CNOMALM" ) )
#define _CDIRALM                  (dbfExtAgeT)->( FieldPos( "CDIRALM" ) )
#define _CPOBALM                  (dbfExtAgeT)->( FieldPos( "CPOBALM" ) )
#define _CPRVALM                  (dbfExtAgeT)->( FieldPos( "CPRVALM" ) )
#define _CPOSALM                  (dbfExtAgeT)->( FieldPos( "CPOSALM" ) )
#define _LLIQEXT                  (dbfExtAgeT)->( FieldPos( "LLIQEXT" ) )
#define _CCODPGO                  (dbfExtAgeT)->( FieldPos( "CCODPGO" ) )
#define _NBULTOS                  (dbfExtAgeT)->( FieldPos( "NBULTOS" ) )
#define _NPORTES                  (dbfExtAgeT)->( FieldPos( "NPORTES" ) )
#define _CCODTAR                  (dbfExtAgeT)->( FieldPos( "CCODTAR" ) )
#define _CDTOESP                  (dbfExtAgeT)->( FieldPos( "CDTOESP" ) )
#define _NDTOESP                  (dbfExtAgeT)->( FieldPos( "NDTOESP" ) )
#define _CDPP                     (dbfExtAgeT)->( FieldPos( "CDPP"    ) )
#define _NDPP                     (dbfExtAgeT)->( FieldPos( "NDPP"    ) )
#define _NDTOCNT                  (dbfExtAgeT)->( FieldPos( "NDTOCNT" ) )
#define _NDTORAP                  (dbfExtAgeT)->( FieldPos( "NDTORAP" ) )
#define _NDTOPUB                  (dbfExtAgeT)->( FieldPos( "NDTOPUB" ) )
#define _NDTOPGO                  (dbfExtAgeT)->( FieldPos( "NDTOPGO" ) )
#define _NDTOPTF                  (dbfExtAgeT)->( FieldPos( "NDTOPTF" ) )
#define _LRECARGO                 (dbfExtAgeT)->( FieldPos( "LRECARGO") )
#define _CDIVEXT                  (dbfExtAgeT)->( FieldPos( "CDIVEXT" ) )
#define _NVDVEXT                  (dbfExtAgeT)->( FieldPos( "NVDVEXT" ) )
#define _CCODUSR                  (dbfExtAgeT)->( FieldPos( "CCODUSR" ) )
#define _CCODDLG                  (dbfExtAgeT)->( FieldPos( "CCODDLG" ) )

/*
Definici¢n de la base de datos de lineas de detalle
*/

#define _CREF                    (dbfExtAgeL)->( FieldPos( "CREF"     ) )
#define _CDETALLE                (dbfExtAgeL)->( FieldPos( "CDETALLE" ) )
#define _NPREUNIT                (dbfExtAgeL)->( FieldPos( "NPREUNIT" ) )
#define _NDTO                    (dbfExtAgeL)->( FieldPos( "NDTO"     ) )
#define _NDTOPRM                 (dbfExtAgeL)->( FieldPos( "NDTOPRM"  ) )
#define _NIVA                    (dbfExtAgeL)->( FieldPos( "NIVA"     ) )
#define _NCANENT                 (dbfExtAgeL)->( FieldPos( "NCANENT"  ) )
#define _NPESOKG                 (dbfExtAgeL)->( FieldPos( "NPESOKG"  ) )
#define _CUNIDAD                 (dbfExtAgeL)->( FieldPos( "CUNIDAD"  ) )
#define _NUNICAJA                (dbfExtAgeL)->( FieldPos( "NUNICAJA" ) )
#define _DFECHA                  (dbfExtAgeL)->( FieldPos( "DFECHA"   ) )
#define _CTIPMOV                 (dbfExtAgeL)->( FieldPos( "CTIPMOV"  ) )

/*
Definici¢n de Array para impuestos
*/

#define _NBRTIVA1                aTotIva[ 1, 1 ]
#define _NBASIVA1                aTotIva[ 1, 2 ]
#define _NPCTIVA1                aTotIva[ 1, 3 ]
#define _NPCTREQ1                aTotIva[ 1, 4 ]
#define _NBRTIVA2                aTotIva[ 2, 1 ]
#define _NBASIVA2                aTotIva[ 2, 2 ]
#define _NPCTIVA2                aTotIva[ 2, 3 ]
#define _NPCTREQ2                aTotIva[ 2, 4 ]
#define _NBRTIVA3                aTotIva[ 3, 1 ]
#define _NBASIVA3                aTotIva[ 3, 2 ]
#define _NPCTIVA3                aTotIva[ 3, 3 ]
#define _NPCTREQ3                aTotIva[ 3, 4 ]

/*
Definici¢n de Array para objetos impuestos
*/

#define _OBASIVA1						oIva[ 1, 1 ]
#define _OPCTIVA1						oIva[ 1, 2 ]
#define _OIMPIVA1						oIva[ 1, 3 ]
#define _OPCTREQ1						oIva[ 1, 4 ]
#define _OIMPREQ1						oIva[ 1, 5 ]
#define _OBASIVA2						oIva[ 2, 1 ]
#define _OPCTIVA2						oIva[ 2, 2 ]
#define _OIMPIVA2						oIva[ 2, 3 ]
#define _OPCTREQ2						oIva[ 2, 4 ]
#define _OIMPREQ2						oIva[ 2, 5 ]
#define _OBASIVA3						oIva[ 3, 1 ]
#define _OPCTIVA3						oIva[ 3, 2 ]
#define _OIMPIVA3						oIva[ 3, 3 ]
#define _OPCTREQ3						oIva[ 3, 4 ]
#define _OIMPREQ3						oIva[ 3, 5 ]

memvar cDbf
memvar cDbfCol
memvar cIva
memvar cFPago
memvar aTotIva
memvar aIvaUno
memvar aIvaDos
memvar aIvaTre
memvar nTotNet
memvar nTotBrt
memvar nTotDto
memvar nTotDpp
memvar nTotIva
memvar nTotReq
memvar nTotExt
memvar nTotEur
memvar cPinDivExt
memvar cPicEurExt
memvar nDinDivExt
memvar nPagina
memvar lEnd
memvar cPouExtAge

static oWndBrw
static oInf
static dbfExtAgeT
static dbfExtAgeL
static dbfDivisa
static oBandera
static dbfTmp
static cNewFile
static dbfAlmT
static dbfIva
static dbfFPago
static dbfTarPreL
static dbfArticulo
static dbfPromoT
static dbfKit
static dbfTVta
static dbfUsr
static dbfDelega
static dbfDoc
static dbfCount
static dbfEmp
static oGetTotal
static oGetTotEur
static cPinDiv
static cPicEur
static cPicUnd
static cPouEur
static cPouDiv
static nDinDiv
static oGetNet
static oGetIva
static oGetReq
static oBrwIva
static nGetNet 	:= 0
static nGetIva 	:= 0
static nTotalImp	:= 0
static nTotalArt	:= 0
static nTotalAge  := 0
static nGetReq  	:= 0
static bEdit      := { |aTmp, aGet, dbfExtAgeT, oBrw, bWhen, bValid, nMode | EdtRec( aTmp, aGet, dbfExtAgeT, oBrw, bWhen, bValid, nMode ) }
static bEdit2     := { |aTmp, aGet, dbfExtAgeL, oBrw, bWhen, bValid, nMode, aTmpExt | EdtDet( aTmp, aGet, dbfExtAgeL, oBrw, bWhen, bValid, nMode, aTmpExt ) }

//---------------------------------------------------------------------------//

Function aItmExtAge()

   local aItmExtAge := {}

   aAdd( aItmExtAge, { "CSEREXT",   "C",  1, 0, "Serie de las existencias de almacén",                    "",                   "", "( cDbf )"} )
   aAdd( aItmExtAge, { "NNUMEXT",   "N",  9, 0, "Número de las existencias de almacén",                   "'999999999'",        "", "( cDbf )"} )
   aAdd( aItmExtAge, { "CSUFEXT",   "C",  2, 0, "Sufijo de las existencias de almacén",                   "",                   "", "( cDbf )"} )
   aAdd( aItmExtAge, { "DFECEXT",   "D",  8, 0, "Fecha del las existencias",                              "",                   "", "( cDbf )"} )
   aAdd( aItmExtAge, { "CCODALM",   "C", 16, 0, "Código de almacén",                                      "",                   "", "( cDbf )"} )
   aAdd( aItmExtAge, { "CNOMALM",   "C", 35, 0, "Nombre del almacén",                                     "",                   "", "( cDbf )"} )
   aAdd( aItmExtAge, { "CDIRALM",   "C", 35, 0, "Domicilio del almacén",                                  "",                   "", "( cDbf )"} )
   aAdd( aItmExtAge, { "CPOBALM",   "C", 25, 0, "Población del almacén",                                  "",                   "", "( cDbf )"} )
   aAdd( aItmExtAge, { "CPRVALM",   "C", 20, 0, "Provincia del almacén",                                  "",                   "", "( cDbf )"} )
   aAdd( aItmExtAge, { "CPOSALM",   "C",  5, 0, "Código Postal del almacén",                              "",                   "", "( cDbf )"} )
   aAdd( aItmExtAge, { "LLIQEXT",   "L",  1, 0, "Lógico para liquidación",                                "",                   "", "( cDbf )"} )
   aAdd( aItmExtAge, { "CCODPGO",   "C",  2, 0, "Código del tipo de pago",                                "",                   "", "( cDbf )"} )
   aAdd( aItmExtAge, { "NBULTOS",   "N",  3, 0, "Número de bultos",                                       "'999'",              "", "( cDbf )"} )
   aAdd( aItmExtAge, { "NPORTES",   "N", 16, 6, "Importe de los portes",                                  "cPouExtAge",         "", "( cDbf )"} )
   aAdd( aItmExtAge, { "CCODTAR",   "C",  5, 0, "Código de tarifa",                                       "",                   "", "( cDbf )"} )
   aAdd( aItmExtAge, { "CDTOESP",   "C", 50, 0, "Descripción de porcentaje de descuento especial",        "",                   "", "( cDbf )"} )
   aAdd( aItmExtAge, { "NDTOESP",   "N",  5, 2, "Porcentaje de descuento especial",                       "'@EZ 999.99'",       "", "( cDbf )"} )
   aAdd( aItmExtAge, { "CDPP",      "C", 50, 0, "Descripción de porcentaje de descuento por pronto pago", "",                   "", "( cDbf )"} )
   aAdd( aItmExtAge, { "NDPP",      "N",  5, 2, "Porcentaje de descuento por pronto pago",                "'@EZ 999.99'",       "", "( cDbf )"} )
   aAdd( aItmExtAge, { "NDTOCNT",   "N",  5, 2, "Porcentaje de descuento por pago de contado",            "'@EZ 999.99'",       "", "( cDbf )"} )
   aAdd( aItmExtAge, { "NDTORAP",   "N",  5, 2, "Porcentaje de descuento por rappel",                     "'@EZ 999.99'",       "", "( cDbf )"} )
   aAdd( aItmExtAge, { "NDTOPUB",   "N",  5, 2, "Porcentaje de descuento por publicidad",                 "'@EZ 999.99'",       "", "( cDbf )"} )
   aAdd( aItmExtAge, { "NDTOPGO",   "N",  5, 2, "Porcentaje de descuento por pago centralizado",          "'@EZ 999.99'",       "", "( cDbf )"} )
   aAdd( aItmExtAge, { "NDTOPTF",   "N",  7, 2, "Porcentaje de descuento por plataforma",                 "'@EZ 999.99'",       "", "( cDbf )"} )
   aAdd( aItmExtAge, { "LRECARGO",  "L",  1, 0, "Lógico de recargo de equivalencia",                      "",                   "", "( cDbf )"} )
   aAdd( aItmExtAge, { "CDIVEXT",   "C",  3, 0, "Código de divisa",                                       "",                   "", "( cDbf )"} )
   aAdd( aItmExtAge, { "NVDVEXT",   "N", 10, 4, "Valor del cambio de la divisa",                          "'@EZ 999,999.9999'", "", "( cDbf )"} )
   aAdd( aItmExtAge, { "CCODUSR",   "C",  3, 0, "Código de usuario",                                      "",                   "", "( cDbf )"} )
   aAdd( aItmExtAge, { "CCODDLG",   "C",  2, 0, "Código delegación",                                      "",                   "", "( cDbf )"} )

Return ( aItmExtAge )

//---------------------------------------------------------------------------//

Function aColExtAge()

   local aColExtAge := {}

   aAdd( aColExtAge, { "CSEREXT",   "C",  1, 0, "Serie de las existencias de almacén",  "",                   "", "( cDbfCol )"} )
   aAdd( aColExtAge, { "NNUMEXT",   "N",  9, 0, "Número de las existencias de almacén", "'999999999'",        "", "( cDbfCol )"} )
   aAdd( aColExtAge, { "CSUFEXT",   "C",  2, 0, "Sufijo de las existencias de almacén", "",                   "", "( cDbfCol )"} )
   aAdd( aColExtAge, { "CREF",      "C", 18, 0, "Referencia de artículo",               "",                   "", "( cDbfCol )"} )
   aAdd( aColExtAge, { "CDETALLE",  "C",100, 0, "Detalle de artículo",                  "",                   "", "( cDbfCol )"} )
   aAdd( aColExtAge, { "NPREUNIT",  "N", 16, 6, "Precio artículo",                      "cPouExtAge",         "", "( cDbfCol )"} )
   aAdd( aColExtAge, { "NDTO",      "N",  6, 2, "Descuento de artículo",                "'@E 999.9'",         "", "( cDbfCol )"} )
   aAdd( aColExtAge, { "NDTOPRM",   "N",  6, 2, "Descuento de promoción",               "'@E 999.9'",         "", "( cDbfCol )"} )
   aAdd( aColExtAge, { "NIVA",      "N",  4, 1, cImp() + " del artículo",                     "'@E 99'",            "", "( cDbfCol )"} )
   aAdd( aColExtAge, { "NCANENT",   "N", 16, 6, "Cantidad entrada",                     "MasUnd()",           "", "( cDbfCol )"} )
   aAdd( aColExtAge, { "NPESOKG",   "N", 16, 6, "Peso en Kg. del producto",             "'@E 9,999.99'",      "", "( cDbfCol )"} )
   aAdd( aColExtAge, { "CUNIDAD",   "C",  2, 0, "Unidades",                             "",                   "", "( cDbfCol )"} )
   aAdd( aColExtAge, { "NUNICAJA",  "N",  6, 2, "Unidades por caja",                    "MasUnd()",           "", "( cDbfCol )"} )
   aAdd( aColExtAge, { "DFECHA",    "D",  8, 0, "Fecha de linea",                       "",                   "", "( cDbfCol )"} )
   aAdd( aColExtAge, { "CTIPMOV",   "C",  2, 0, "Tipo de movimiento",                   "",                   "", "( cDbfCol )"} )

Return ( aColExtAge )

//----------------------------------------------------------------------------//

FUNCTION aDocExtAge()

   local aDoc  := {}

   aAdd( aDoc, { "Empresa",         "EM" } )
   aAdd( aDoc, { "Existencias",     "EX" } )
   aAdd( aDoc, { "Almacén",         "AL" } )
   aAdd( aDoc, { "Divisas",         "DV" } )
   aAdd( aDoc, { "Formas de pago",  "PG" } )

RETURN ( aDoc )

//----------------------------------------------------------------------------//

STATIC FUNCTION OpenFiles()

   local lOpen    := .t.
   local oError
   local oBlock   := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

   USE ( cPatEmp() + "EXTAGET.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "EXTAGET", @dbfExtAgeT ) )
   SET ADSINDEX TO ( cPatEmp() + "EXTAGET.CDX" ) ADDITIVE

   USE ( cPatEmp() + "EXTAGEL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "EXTAGEL", @dbfExtAgeL ) )
   SET ADSINDEX TO ( cPatEmp() + "EXTAGEL.CDX" ) ADDITIVE

   USE ( cPatDat() + "TIVA.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "TIVA", @dbfIva ) )
   SET ADSINDEX TO ( cPatDat() + "TIVA.CDX" ) ADDITIVE

   USE ( cPatGrp() + "FPAGO.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FPAGO", @dbfFPago ) )
   SET ADSINDEX TO ( cPatGrp() + "FPAGO.CDX" ) ADDITIVE

   USE ( cPatAlm() + "ALMACEN.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ALMACEN", @dbfAlmT ) )
   SET ADSINDEX TO ( cPatAlm() + "ALMACEN.CDX" ) ADDITIVE

   USE ( cPatArt() + "TARPREL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "TARPREL", @dbfTarPreL ) )
   SET ADSINDEX TO ( cPatArt() + "TARPREL.CDX" ) ADDITIVE

   USE ( cPatArt() + "PROMOT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PROMOT", @dbfPromoT ) )
   SET ADSINDEX TO ( cPatArt() + "PROMOT.CDX" ) ADDITIVE

   USE ( cPatArt() + "ARTICULO.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ARTICULO", @dbfArticulo ) )
   SET ADSINDEX TO ( cPatArt() + "ARTICULO.CDX" ) ADDITIVE

   USE ( cPatArt() + "ARTKIT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ARTTIK", @dbfKit ) )
   SET ADSINDEX TO ( cPatArt() + "ARTKIT.CDX" ) ADDITIVE

   USE ( cPatDat() + "DIVISAS.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "DIVISAS", @dbfDivisa ) )
   SET ADSINDEX TO ( cPatDat() + "DIVISAS.CDX" ) ADDITIVE

   USE ( cPatDat() + "TVTA.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "TVTA", @dbfTVta ) )
   SET ADSINDEX TO ( cPatDat() + "TVTA.CDX" ) ADDITIVE

   USE ( cPatDat() + "USERS.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "USERS", @dbfUsr ) )
   SET ADSINDEX TO ( cPatDat() + "USERS.CDX" ) ADDITIVE

   USE ( cPatDat() + "DELEGA.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "DELEGA", @dbfDelega ) )
   SET ADSINDEX TO ( cPatDat() + "DELEGA.CDX" ) ADDITIVE

   USE ( cPatEmp() + "NCOUNT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "NCOUNT", @dbfCount ) )
   SET ADSINDEX TO ( cPatEmp() + "NCOUNT.CDX" ) ADDITIVE

   USE ( cPatEmp() + "RDOCUMEN.DBF" ) NEW SHARED VIA ( cDriver() )ALIAS ( cCheckArea( "RDOCUMEN", @dbfDoc ) )
   SET ADSINDEX TO ( cPatEmp() + "RDOCUMEN.CDX" ) ADDITIVE
   SET TAG TO "CTIPO"

   USE ( cPatDat() + "EMPRESA.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "EMPRESA", @dbfEmp ) )
   SET ADSINDEX TO ( cPatDat() + "EMPRESA.CDX" ) ADDITIVE

   oBandera             := TBandera():New()

   RECOVER USING oError

      lOpen             := .f.
      msgStop( "Imposible abrir todas las bases de datos" + CRLF + ErrorMessage( oError ) )

   END SEQUENCE
   ErrorBlock( oBlock )

   if !lOpen
      CloseFiles()
   end if

RETURN ( lOpen )

//----------------------------------------------------------------------------//

STATIC FUNCTION CloseFiles()

   if !Empty( dbfExtAgeT )
      ( dbfExtAgeT )->( dbCloseArea() )
   end if

   if !Empty( dbfExtAgeL )
      ( dbfExtAgeL )->( dbCloseArea() )
   end if
   if !Empty( dbfIva )
      ( dbfIva )->( dbCloseArea() )
   end if
   if !Empty( dbfFPago )
      ( dbfFPago )->( dbCloseArea() )
   end if
   if !Empty( dbfAlmT )
      ( dbfAlmT )->( dbCloseArea() )
   end if
   if !Empty( dbfTarPreL )
      ( dbfTarPreL )->( dbCloseArea() )
   end if
   if !Empty( dbfPromoT  )
      ( dbfPromoT )->( dbCloseArea() )
   end if
   if !Empty( dbfArticulo)
      ( dbfArticulo)->( dbCloseArea() )
   end if
   if !Empty( dbfKit )
      ( dbfKit )->( dbCloseArea() )
   end if
   if !Empty( dbfDivisa )
      ( dbfDivisa )->( dbCloseArea() )
   end if
   if !Empty( dbfTVta )
      ( dbfTVta )->( dbCloseArea() )
   end if
   if !Empty( dbfUsr )
      ( dbfUsr )->( dbCloseArea() )
   end if
   if !Empty( dbfDelega )
      ( dbfDelega )->( dbCloseArea() )
   end if
   if !Empty( dbfDoc )
      ( dbfDoc )->( dbCloseArea() )
   end if
   if !Empty( dbfCount )
      ( dbfCount )->( dbCloseArea() )
   end if

   if !Empty( dbfEmp )
      ( dbfEmp )->( dbCloseArea() )
   end if

   dbfExtAgeT  := nil
   dbfExtAgeL  := nil
   dbfIva      := nil
   dbfFPago    := nil
   dbfAlmT     := nil
   dbfTarPreL  := nil
   dbfPromoT   := nil
   dbfArticulo := nil
   dbfDivisa   := nil
   dbfTVta     := nil
   oBandera    := nil
   dbfUsr      := nil
   dbfDelega   := nil
   dbfDoc      := nil
   dbfCount    := nil
   dbfEmp      := nil

   if oWndBrw != nil
      oWndBrw  := nil
   end if

Return .t.

//----------------------------------------------------------------------------//

FUNCTION ExtAge( oMenuItem, oWnd )

   local oImp
   local oPrv
   local nLevel
   local oBtnEur
   local lEuro          := .f.

   DEFAULT  oMenuItem   := "01029"
   DEFAULT  oWnd        := oWnd()

	IF oWndBrw == NIL

      /*
      Obtenemos el nivel de acceso
      */

      nLevel      := nLevelUsr( oMenuItem )
      if nAnd( nLevel, 1 ) != 0
         msgStop( "Acceso no permitido." )
         return nil
      end if

      /*
      Cerramos todas las ventanas
      */

      if oWnd != nil
         SysRefresh(); oWnd:CloseAll(); SysRefresh()
      end if

      if !OpenFiles()
         return nil
      end if

      /*
      Anotamos el movimiento para el navegador
      */

      AddMnuNext( "Estado depósitos", ProcName() )

      cPouEur     := cPouDiv( "EUR", dbfDivisa )            // Picture del euro
      cPicUnd     := MasUnd()                               // Picture de las unidades

      DEFINE SHELL oWndBrw FROM 0, 0 TO 22, 80 ;
         TITLE    "Estado depósitos" ;
         PROMPTS  "Número",;
						"Fecha",;
                  "Almacén";
         MRU      "Package_ok_16";
         BITMAP   Rgb( 128, 57, 123 ) ;
         ALIAS    ( dbfExtAgeT );
         APPEND   ( WinAppRec( oWndBrw:oBrw, bEdit, dbfExtAgeT ) );
         DUPLICAT ( WinDupRec( oWndBrw:oBrw, bEdit, dbfExtAgeT ) );
         EDIT     ( WinEdtRec( oWndBrw:oBrw, bEdit, dbfExtAgeT ) );
         DELETE   ( dbDelRec(  oWndBrw:oBrw, dbfExtAgeT, {|| delDetalle( (dbfExtAgeT)->CSEREXT + Str( (dbfExtAgeT)->NNUMEXT ) + (dbfExtAgeT)->CSUFEXT ) } ) ) ;
         LEVEL    nLevel ;
         OF       oWnd

         oWndBrw:lAutoSeek := .f.

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Liquidado"
         :nHeadBmpNo       := 3
         :bStrData         := {|| "" }
         :bEditValue       := {|| ( dbfExtAgeT )->lLiqExt }
         :nWidth           := 20
         :SetCheck( { "Sel16", "Nil16" } )
         :AddResource( "ChgPre16" )
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Número"
         :cSortOrder       := "nNumExt"
         :bEditValue       := {|| ( dbfExtAgeT )->cSerExt + "/" + Alltrim( Str( ( dbfExtAgeT )->nNumExt ) ) + "/" + ( dbfExtAgeT )->cSufExt }
         :nWidth           := 80
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Delegación"
         :bEditValue       := {|| ( dbfExtAgeT )->cCodDlg }
         :nWidth           := 40
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Fecha"
         :cSortOrder       := "dFecDep"
         :bEditValue       := {|| Dtoc( ( dbfExtAgeT )->dFecExt ) }
         :nWidth           := 80
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Almacén"
         :cSortOrder       := "cCodAlm"
         :bEditValue       := {|| ( dbfExtAgeT )->cCodAlm + Space( 1 ) + RetAlmacen( ( dbfExtAgeT )->cCodAlm, dbfAlmT ) }
         :nWidth           := 180
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Total"
         :bEditValue       := {|| nTotExtAge( ( dbfExtAgeT )->cSerExt + Str( ( dbfExtAgeT )->nNumExt ) + ( dbfExtAgeT )->cSufExt, dbfExtAgeT, dbfExtAgeL, dbfIva, dbfDivisa, nil, lEuro ) }
         :nWidth           := 80
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Div"
         :bEditValue       := {|| cSimDiv( ( dbfExtAgeT )->cDivExt, dbfDivisa ) }
         :nWidth           := 40
      end with

      oWndBrw:CreateXFromCode()

      DEFINE BTNSHELL RESOURCE "BUS" OF oWndBrw ;
			NOBORDER ;
         ACTION   ( oWndBrw:SearchSetFocus() ) ;
         TOOLTIP  "(B)uscar";
			HOTKEY 	"B"

      oWndBrw:AddSeaBar()

		DEFINE BTNSHELL RESOURCE "NEW" OF oWndBrw ;
			NOBORDER ;
			ACTION 	( oWndBrw:RecAdd() );
			ON DROP	( oWndBrw:RecDup() );
			TOOLTIP 	"(A)ñadir";
         HOTKEY   "A";
         BEGIN GROUP ;
         LEVEL    ACC_APPD

		DEFINE BTNSHELL RESOURCE "DUP" OF oWndBrw ;
			NOBORDER ;
			ACTION 	( oWndBrw:RecDup() );
			TOOLTIP 	"(D)uplicar";
         HOTKEY   "D";
         LEVEL    ACC_APPD

		DEFINE BTNSHELL RESOURCE "EDIT" OF oWndBrw ;
			NOBORDER ;
			ACTION  	( oWndBrw:RecEdit() );
         TOOLTIP  "(M)odificar";
         HOTKEY   "M";
         LEVEL    ACC_EDIT

		DEFINE BTNSHELL RESOURCE "ZOOM" OF oWndBrw ;
			NOBORDER ;
         ACTION   ( WinZooRec( oWndBrw:oBrw, bEdit, dbfExtAgeT ) );
			TOOLTIP 	"(Z)oom";
         HOTKEY   "Z";
         LEVEL    ACC_ZOOM

		DEFINE BTNSHELL RESOURCE "DEL" OF oWndBrw ;
			NOBORDER ;
			ACTION 	( oWndBrw:RecDel() );
			TOOLTIP 	"(E)liminar";
         HOTKEY   "E";
         LEVEL    ACC_DELE

      DEFINE BTNSHELL oImp RESOURCE "IMP" GROUP OF oWndBrw ;
			NOBORDER ;
         ACTION   ( nGenExtAge( .t. ) ) ;
			TOOLTIP 	"(I)mprimir";
         HOTKEY   "I";
         LEVEL    ACC_ZOOM

      lGenExtAge( oWndBrw:oBrw, oImp, .t. )

      DEFINE BTNSHELL oPrv RESOURCE "PREV1" OF oWndBrw ;
			NOBORDER ;
         ACTION   ( GenExtAge( .f. ) ) ;
			TOOLTIP 	"(P)revisualizar";
         HOTKEY   "P";
         LEVEL    ACC_ZOOM

      lGenExtAge( oWndBrw:oBrw, oPrv, .f. )

      DEFINE BTNSHELL RESOURCE "CHGSTATE" OF oWndBrw ;
			NOBORDER ;
			ACTION 	( ChgState( oWndBrw:oBrw ) ) ;
			TOOLTIP 	"Cambiar Es(t)ado" ;
         HOTKEY   "T";
         LEVEL    ACC_EDIT

		DEFINE BTNSHELL oBtnEur RESOURCE "BAL_EURO" OF oWndBrw ;
			NOBORDER ;
         ACTION   ( lEuro := !lEuro, oWndBrw:Refresh() ) ;
         TOOLTIP  "M(o)neda";
         HOTKEY   "O";
         LEVEL    ACC_ZOOM

      DEFINE BTNSHELL RESOURCE "END"  GROUP OF oWndBrw;
			NOBORDER ;
			ACTION 	( oWndBrw:End() ) ;
			TOOLTIP 	"Salir" ;
			HOTKEY 	"S"

		ACTIVATE WINDOW oWndBrw VALID ( CloseFiles() )

	ELSE

		oWndBrw:setFocus()

	END IF

RETURN NIL

//----------------------------------------------------------------------------//

STATIC FUNCTION EdtRec( aTmp, aGet, dbfExtAgeT, oBrw, bWhen, bValid, nMode )

	local oDlg
	local oBrw2
   local oSay2, oSay4, oSay5, oSay6
   local cSay2, cSay4, cSay5, cSay6
   local oBmpDiv
   local oFont          := TFont():New( "Arial", 8, 26, .F., .T. )
   local oBmpGeneral

   if nMode == APPD_MODE
      aTmp[ _CSEREXT ]  := "A"
      aTmp[ _CCODALM ]  := oUser():cAlmacen()
      aTmp[ _CDIVEXT ]  := cDivEmp()
      aTmp[ _CCODPGO ]  := cDefFpg()
      aTmp[ _NVDVEXT ]  := nChgDiv( aTmp[ _CDIVEXT ], dbfDivisa )
      aTmp[ _CCODUSR ]  := cCurUsr()
      aTmp[ _CCODDLG ]  := oUser():cDelegacion()
   end if

   cSay5                := RetFld( aTmp[ _CCODUSR ], dbfUsr, "cNbrUse" )
   cSay6                := RetFld( cCodEmp() + aTmp[ _CCODDLG ], dbfDelega, "cNomDlg" )

   if Empty( aTmp[ _CDTOESP ] )
      aTmp[ _CDTOESP ]  := Padr( "General", 50 )
   end if

   if Empty( aTmp[ _CDPP ] )
      aTmp[ _CDPP ]     := Padr( "Pronto pago", 50 )
   end if

	BeginTrans( aTmp )

   cPouDiv              := cPouDiv( aTmp[ _CDIVEXT ], dbfDivisa ) // Picture de la divisa
   cPicEur              := cPinDiv( "EUR", dbfDivisa )            // Picture del euro
   cPicUnd              := MasUnd()
   nDinDiv              := nDinDiv( aTmp[ _CDIVEXT ], dbfDivisa )

   DEFINE DIALOG oDlg RESOURCE "EXTAGE" TITLE LblTitle( nMode ) + "existencias de almacenes"

      REDEFINE BITMAP oBmpGeneral ;
         ID       990 ;
         RESOURCE "estado_depositos_48_alpha" ;
         TRANSPARENT ;
         OF       oDlg

      REDEFINE GET aGet[_NNUMEXT] VAR aTmp[_NNUMEXT] ;
			ID 		100 ;
			PICTURE 	"999999999" ;
			WHEN  	( .F. ) ;
			OF 		oDlg

      REDEFINE GET aGet[ _DFECEXT ] VAR aTmp[ _DFECEXT ];
			ID 		110 ;
			SPINNER ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			COLOR 	CLR_GET ;
			OF 		oDlg

      REDEFINE GET aGet[ _CCODUSR ] VAR aTmp[ _CCODUSR ];
         ID       115 ;
         WHEN     ( .f. ) ;
         VALID    ( SetUsuario( aGet[ _CCODUSR ], oSay5, nil, dbfUsr ) );
         OF       oDlg

      REDEFINE GET oSay5 VAR cSay5 ;
         ID       116 ;
         WHEN     ( .f. ) ;
         OF       oDlg

      REDEFINE GET aGet[ _CCODDLG ] VAR aTmp[ _CCODDLG ] ;
         ID       300 ;
         WHEN     ( .f. ) ;
         OF       oDlg

      REDEFINE GET oSay6 VAR cSay6 ;
         ID       301 ;
         WHEN     ( .f. ) ;
         OF       oDlg

      REDEFINE CHECKBOX aGet[_LLIQEXT] VAR aTmp[_LLIQEXT] ;
         ID       400 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         OF       oDlg

      REDEFINE GET aGet[ _CCODALM ] VAR aTmp[ _CCODALM ] ;
			ID 		130 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    ( LoadAlm( aGet, aTmp ) ) ;
         BITMAP   "LUPA" ;
         ON HELP  ( BrwAlmacen( aGet[ _CCODALM ] ) ) ;
			COLOR 	CLR_GET ;
			OF 		oDlg

      REDEFINE GET aGet[ _CNOMALM ] VAR aTmp[ _CNOMALM ] ;
         WHEN     ( nMode != ZOOM_MODE ) ;
			ID 		131 ;
			OF 		oDlg

      REDEFINE GET aGet[ _CDIRALM ] VAR aTmp[ _CDIRALM ] ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ID       132 ;
         OF       oDlg

      REDEFINE GET aGet[ _CPOSALM ] VAR aTmp[ _CPOSALM ] ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ID       133 ;
         OF       oDlg

      REDEFINE GET aGet[ _CPOBALM ] VAR aTmp[ _CPOBALM ] ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ID       134 ;
         OF       oDlg

      REDEFINE GET aGet[ _CPRVALM ] VAR aTmp[ _CPRVALM ] ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ID       135 ;
         OF       oDlg

      REDEFINE GET aGet[ _CCODPGO ] VAR aTmp[ _CCODPGO ] ;
			ID 		140 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			COLOR 	CLR_GET ;
			PICTURE  "@!" ;
         BITMAP   "LUPA" ;
			VALID 	( cFPago( aGet[_CCODPGO], dbfFPago, oSay2 ) ) ;
         ON HELP  ( BrwFPago( aGet[_CCODPGO], oSay2 ) ) ;
			OF 		oDlg

		REDEFINE GET oSay2 VAR cSay2 ;
			ID 		141 ;
			WHEN 		.F. ;
			COLOR 	CLR_GET ;
			OF 		oDlg

		REDEFINE GET aGet[_CCODTAR] VAR aTmp[_CCODTAR] ;
			ID 		150 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			VALID 	( cTarifa( aGet[_CCODTAR], oSay4 ) ) ;
         BITMAP   "LUPA" ;
			ON HELP 	( BrwTarifa( aGet[_CCODTAR], oSay4 ) ) ;
			COLOR 	CLR_GET ;
			OF 		oDlg

		REDEFINE GET oSay4 VAR cSay4 ;
			WHEN 		.F. ;
			ID 		151 ;
			OF 		oDlg

		/*
		Moneda__________________________________________________________________
		*/

      REDEFINE GET aGet[ _CDIVEXT ] VAR aTmp[ _CDIVEXT ];
			WHEN 		( 	nMode == APPD_MODE ) ;
         BITMAP   "LUPA" ;
         VALID    (  cDiv( aGet[ _CDIVEXT ], oBmpDiv, aGet[ _NVDVEXT ], @cPinDiv, @nDinDiv, dbfDivisa, oBandera ),;
                     nTotExtAge( nil, dbfExtAgeT, dbfTmp, dbfIva, dbfDivisa, aTmp ),;
							.t. );
			PICTURE	"@!";
			ID 		170 ;
			COLOR 	CLR_GET ;
         ON HELP  BrwDiv( aGet[ _CDIVEXT ], oBmpDiv, aGet[ _NVDVEXT ], dbfDivisa, oBandera ) ;
			OF 		oDlg

		REDEFINE BITMAP oBmpDiv ;
         RESOURCE "BAN_EURO" ;
			ID 		171;
			OF 		oDlg

		/*
		Detalle________________________________________________________________
		*/

      oBrw2                   := IXBrowse():New( oDlg )

      oBrw2:bClrSel           := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      oBrw2:bClrSelFocus      := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      oBrw2:cAlias            := dbfTmp

      oBrw2:nMarqueeStyle     := 6
      oBrw2:cName             := "Existencias de almacén detalle"

      oBrw2:CreateFromResource( 200 )

      with object ( oBrw2:AddCol() )
         :cHeader             := "Código"
         :bEditValue          := {|| ( dbfTmp )->cRef }
         :nWidth              := 70
      end with

      with object ( oBrw2:AddCol() )
         :cHeader             := "Descripción"
         :bEditValue          := {|| ( dbfTmp )->cDetalle }
         :nWidth              := 360
      end with

      with object ( oBrw2:AddCol() )
         :cHeader             := "Unidades"
         :bEditValue          := {|| nUnitEnt( dbfTmp ) }
         :cEditPicture        := MasUnd()
         :nWidth              := 70
         :nDataStrAlign       := 1
         :nHeadStrAlign       := 1
      end with

      with object ( oBrw2:AddCol() )
         :cHeader             := "Precio U."
         :bEditValue          := {|| ( dbfTmp )->NPREUNIT }
         :cEditPicture        := cPouDiv
         :nWidth              := 70
         :nDataStrAlign       := 1
         :nHeadStrAlign       := 1
      end with

      with object ( oBrw2:AddCol() )
         :cHeader             := "Dto.%"
         :bEditValue          := {|| ( dbfTmp )->nDto }
         :cEditPicture        := "@E 99.99"
         :nWidth              := 50
         :nDataStrAlign       := 1
         :nHeadStrAlign       := 1
      end with

      with object ( oBrw2:AddCol() )
         :cHeader             := "Dto.P.%"
         :bEditValue          := {|| ( dbfTmp )->nDtoPrm }
         :cEditPicture        := "@E 99.99"
         :nWidth              := 60
         :nDataStrAlign       := 1
         :nHeadStrAlign       := 1
      end with

      with object ( oBrw2:AddCol() )
         :cHeader             := cImp()
         :bEditValue          := {|| ( dbfTmp )->nIva }
         :cEditPicture        := "@E 99.9"
         :nWidth              := 50
         :nDataStrAlign       := 1
         :nHeadStrAlign       := 1
      end with

      with object ( oBrw2:AddCol() )
         :cHeader             := "Importe"
         :bEditValue          := {|| nTotLExtAge( dbfTmp ) }
         :cEditPicture        := cPouDiv
         :nWidth              := 80
         :nDataStrAlign       := 1
         :nHeadStrAlign       := 1
      end with

      if nMode != ZOOM_MODE
            oBrw2:bLDblClick  := {|| EdtDeta( oBrw2, bEdit2, aTmp ) }
      end if

		/*
      Cajas para el desglose________________________________________________
		*/

      REDEFINE GET aGet[ _CDTOESP ] VAR aTmp[ _CDTOESP ] ;
         ID       209 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         OF       oDlg

      REDEFINE GET aGet[_NDTOESP ] VAR aTmp[ _NDTOESP ] ;
			ID 		210 ;
			PICTURE 	"@E 99.99" ;
			COLOR 	CLR_GET ;
			VALID		( nRecTotal( dbfTmp, aTmp ) );
			WHEN 		( nMode != ZOOM_MODE ) ;
			OF 		oDlg

      REDEFINE GET aGet[ _CDPP ] VAR aTmp[ _CDPP ] ;
         ID       219 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         OF       oDlg

      REDEFINE GET aGet[ _NDPP ] VAR aTmp[ _NDPP ];
			ID 		220 ;
			PICTURE 	"@E 99.99" ;
			COLOR 	CLR_GET ;
			VALID		( nRecTotal( dbfTmp, aTmp ) );
			WHEN 		( nMode != ZOOM_MODE ) ;
			OF 		oDlg

      /*
      Cajas Bases de los impuestosS____________________________________________________________
		*/

      oBrwIva                        := IXBrowse():New( oDlg )

      oBrwIva:bClrSel                := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      oBrwIva:bClrSelFocus           := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      oBrwIva:SetArray( aTotIva, , , .f. )

      oBrwIva:nMarqueeStyle          := 5
      oBrwIva:lRecordSelector        := .f.
      oBrwIva:lHScroll               := .f.

      oBrwIva:CreateFromResource( 310 )

      with object ( oBrwIva:AddCol() )
         :cHeader          := "Base"
         :bStrData         := {|| if( aTotIva[ oBrwIva:nArrayAt, 3 ] != nil, Trans( aTotIva[ oBrwIva:nArrayAt, 2 ], cPouDiv ), "" ) }
         :nWidth           := 115
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
      end with

      with object ( oBrwIva:AddCol() )
         :cHeader          := "% " + cImp()
         :bStrData         := {|| if( aTotIva[ oBrwIva:nArrayAt, 3 ] != nil, Trans( aTotIva[ oBrwIva:nArrayAt, 3 ], "@E 99.9"), "" ) }
         :nWidth           := 70
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
         :nEditType        := 1
      end with

      with object ( oBrwIva:AddCol() )
         :cHeader          := cImp()
         :bStrData         := {|| if( aTotIva[ oBrwIva:nArrayAt, 3 ] != nil, Trans( aTotIva[ oBrwIva:nArrayAt, 3 ] * aTotIva[ oBrwIva:nArrayAt, 2 ] / 100, cPouDiv ), "" ) }
         :nWidth           := 75
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
      end with

      with object ( oBrwIva:AddCol() )
         :cHeader          := "% R.E."
         :bStrData         := {|| if( aTotIva[ oBrwIva:nArrayAt, 3 ] != nil, Trans( aTotIva[ oBrwIva:nArrayAt, 4 ], "@E 99.9"), "" ) }
         :nWidth           := 60
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
      end with

      with object ( oBrwIva:AddCol() )
         :cHeader          := "R.E."
         :bStrData         := {|| if( aTotIva[ oBrwIva:nArrayAt, 3 ] != nil, Trans( aTotIva[ oBrwIva:nArrayAt, 4 ] * aTotIva[ oBrwIva:nArrayAt, 2 ] / 100, cPouDiv ), "" ) }
         :nWidth           := 65
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
      end with

		/*
		Cajas de Totales
		------------------------------------------------------------------------
		*/

		REDEFINE SAY oGetNet VAR nGetNet ;
			ID 		420 ;
			PICTURE	cPinDiv ;
			OF 		oDlg

		REDEFINE SAY oGetIva VAR nGetIva ;
			ID 		430 ;
			PICTURE	cPinDiv ;
			OF 		oDlg

		REDEFINE SAY oGetReq VAR nGetReq ;
			ID 		440 ;
			PICTURE	cPinDiv ;
			OF 		oDlg

		REDEFINE CHECKBOX aGet[_LRECARGO] VAR aTmp[_LRECARGO] ;
			ID 		450 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         ON CHANGE( nRecTotal( dbfTmp, aTmp ) );
			OF 		oDlg

      REDEFINE SAY oGetTotal VAR nTotExt;
			ID 		460 ;
			PICTURE 	cPinDiv ;
			FONT 		oFont ;
			OF 		oDlg

		REDEFINE BUTTON ;
			ID 		500 ;
			OF 		oDlg ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			ACTION 	( AppDeta( oBrw2, bEdit2, aTmp ) )

		REDEFINE BUTTON ;
			ID 		501 ;
			OF 		oDlg ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			ACTION 	( EdtDeta( oBrw2, bEdit2, aTmp ) )

		REDEFINE BUTTON ;
			ID 		502 ;
			OF 		oDlg ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			ACTION 	( DelDeta( oBrw2, aTmp ) )

		REDEFINE BUTTON ;
			ID 		503 ;
			OF 		oDlg ;
			ACTION 	( EdtZoom( oBrw2, bEdit2, aTmp ) )

		REDEFINE BUTTON ;
			ID 		524 ;
			OF 		oDlg ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			ACTION 	( DbSwapUp( dbfTmp, oBrw2 ) )

		REDEFINE BUTTON ;
			ID 		525 ;
			OF 		oDlg ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			ACTION 	( DbSwapDown( dbfTmp, oBrw2 ) )

      REDEFINE BUTTON ;
			ID 		511 ;
			OF 		oDlg ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			ACTION 	( EndTrans( aTmp, oBrw2, nMode ),;
                  WinGather( aTmp, , dbfExtAgeT, oBrw, @nMode ),;
                  oDlg:end( IDOK ) )

		REDEFINE BUTTON ;
			ID 		510 ;
			OF 		oDlg ;
         CANCEL ;
         ACTION   ( If( ExitNoSave( nMode, dbfTmp ), oDlg:end(), ) )

      REDEFINE BUTTON ;
         ID       998 ;
			OF 		oDlg ;
         ACTION   ( ChmHelp ("Existencias_Almacen") )

   if nMode != ZOOM_MODE
      oDlg:AddFastKey( VK_F2, {|| AppDeta( oBrw2, bEdit2, aTmp ) } )
      oDlg:AddFastKey( VK_F3, {|| EdtDeta( oBrw2, bEdit2, aTmp ) } )
      oDlg:AddFastKey( VK_F4, {|| DelDeta( oBrw2, aTmp ) } )
      oDlg:AddFastKey( VK_F5, {|| EndTrans( aTmp, oBrw2, nMode ), WinGather( aTmp, , dbfExtAgeT, oBrw, @nMode ), oDlg:end( IDOK ) } )
   end if

   oDlg:AddFastKey ( VK_F1, {|| ChmHelp ("Existencias_Almacen") } )

   oDlg:bStart := { || aGet[_CCODALM]:SetFocus(), oBrw2:Load() }

	ACTIVATE DIALOG oDlg	;
		ON PAINT 	( EvalGet( aGet, nMode ) );
		ON INIT		( nRecTotal( dbfTmp, aTmp ) );
      CENTER

   KillTrans()

   oFont:end()
   oBmpGeneral:End()

RETURN ( oDlg:nResult == IDOK )

//--------------------------------------------------------------------------//

/*
Edita las lineas de Detalle
*/

STATIC FUNCTION EdtDet( aTmp, aGet, dbfExtAgeL, oBrw, bWhen, bValid, nMode, aTmpExT )

   local oBtn
	local oDlg2
   local oGet2
   local cGet2
	local oTotal
	local nTotal 			:= 0
   local oSayCaja

	IF nMode	== APPD_MODE
      aTmp[_CSEREXT ]  := aTmpExt[_CSEREXT]
      aTmp[_NNUMEXT ]  := aTmpExt[_NNUMEXT]
      aTmp[_CSUFEXT ]  := aTmpExt[_CSUFEXT]
      aTmp[_NCANENT ]  := 1
		aTmp[_NUNICAJA]  := 1
      aTmp[_DFECHA  ]  := Date()
      aTmp[_CTIPMOV ]  := "01"
   END CASE

   DEFINE DIALOG oDlg2 RESOURCE "LDEPAGE" TITLE lblTitle( nMode ) + "lineas de estado depósitos de almacén"

		REDEFINE GET aGet[_CREF] VAR aTmp[_CREF];
			ID 		100 ;
			WHEN 		( nMode == APPD_MODE ) ;
         VALID    ( LoadArt( aGet, aTmpExt ) ) ;
			ON HELP 	( BrwArticulo( aGet[_CREF], aGet[_CDETALLE] ) );
         BITMAP   "LUPA" ;
         COLOR    CLR_GET ;
			OF 		oDlg2

		REDEFINE GET aGet[_CDETALLE] VAR aTmp[_CDETALLE] ;
			ID 		110 ;
         WHEN     ( lModDes() .AND. nMode != ZOOM_MODE ) ;
			COLOR 	CLR_GET ;
			OF 		oDlg2

		REDEFINE GET aGet[_NIVA] VAR aTmp[_NIVA] ;
			ID 		120 ;
			COLOR 	CLR_GET ;
			PICTURE 	"@E 99.9" ;
         WHEN     ( lModIva() .AND. nMode != ZOOM_MODE ) ;
			VALID 	( lTiva( dbfIva, aTmp[_NIVA] ) );
         ON HELP  ( BrwIva( aGet[_NIVA], dbfIva, , .t. ) ) ;
         BITMAP   "LUPA" ;
			OF 		oDlg2

      REDEFINE SAY oSayCaja;
         ID       129;
         OF       oDlg2

		REDEFINE GET aGet[_NCANENT] VAR aTmp[_NCANENT];
			ID 		130;
			SPINNER ;
         WHEN     ( lUseCaj() .AND. nMode != ZOOM_MODE ) ;
			COLOR 	CLR_GET ;
         PICTURE  cPicUnd ;
			ON CHANGE( lCalcDeta( aTmp, oTotal ) );
			OF 		oDlg2

		REDEFINE GET aGet[_NUNICAJA] VAR aTmp[_NUNICAJA] ;
			ID 		140;
			SPINNER ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			COLOR 	CLR_GET ;
			ON CHANGE( lCalcDeta( aTmp, oTotal ) );
         PICTURE  cPicUnd ;
			OF 		oDlg2

		REDEFINE GET aGet[_NPESOKG] VAR aTmp[_NPESOKG] ;
			ID 		145 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         PICTURE  "@E 999,999.999999";
         OF       oDlg2

		REDEFINE GET aGet[_CUNIDAD] VAR aTmp[_CUNIDAD] ;
			ID 		150;
			WHEN 		( nMode != ZOOM_MODE ) ;
			COLOR 	CLR_GET ;
			OF 		oDlg2

		REDEFINE GET aGet[_NPREUNIT] VAR aTmp[_NPREUNIT];
			ID 		160 ;
			SPINNER ;
			COLOR 	CLR_GET ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			ON CHANGE( lCalcDeta( aTmp, oTotal ) );
         PICTURE  cPinDiv ;
			OF 		oDlg2

		REDEFINE GET aGet[_NDTO] VAR aTmp[_NDTO] ;
			ID 		170 ;
			SPINNER ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			COLOR 	CLR_GET ;
			PICTURE 	"@E 999.9";
			ON CHANGE( lCalcDeta( aTmp, oTotal ) );
			OF 		oDlg2

		REDEFINE GET aGet[_NDTOPRM] VAR aTmp[_NDTOPRM] ;
			ID 		175 ;
			SPINNER ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			COLOR 	CLR_GET ;
			PICTURE 	"@E 999.9";
			ON CHANGE( lCalcDeta( aTmp, oTotal ) );
			OF 		oDlg2

		REDEFINE GET aGet[_DFECHA] VAR aTmp[_DFECHA] ;
			ID 		180 ;
			SPINNER ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			COLOR 	CLR_GET ;
			OF 		oDlg2

      REDEFINE GET aGet[_CTIPMOV] VAR aTmp[ _CTIPMOV ] ;
         WHEN     ( nMode != ZOOM_MODE  ) ;
         VALID    ( cTVta( aGet[_CTIPMOV], dbfTVta, oGet2 ) ) ;
         BITMAP   "LUPA" ;
         ON HELP  ( BrwTVta( aGet[_CTIPMOV], dbfTVta, oGet2 ) ) ;
         ID       290 ;
         OF       oDlg2

		REDEFINE GET oGet2 VAR cGet2 ;
         ID       291 ;
			WHEN 		( .F. ) ;
			COLOR 	CLR_GET ;
         OF       oDlg2

      REDEFINE GET oTotal VAR nTotal ;
			ID 		190 ;
         PICTURE  cPinDiv ;
			WHEN 		.F. ;
			OF 		oDlg2

      REDEFINE BUTTON oBtn ;
         ID       IDOK ;
			OF 		oDlg2 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         ACTION   SaveDeta( aTmp, aGet, oBrw, oDlg2, nMode, oTotal, oBtn )

		REDEFINE BUTTON ;
         ID       IDCANCEL ;
			OF 		oDlg2 ;
			ACTION 	( oDlg2:end() )

      REDEFINE BUTTON ;
         ID       9 ;
			OF 		oDlg2 ;
         ACTION   ( ChmHelp ("Añadir_linea_existencias") )

   if nMode != ZOOM_MODE
      oDlg2:AddFastKey( VK_F5, {|| SaveDeta( aTmp, aGet, oBrw, oDlg2, nMode, oTotal, oBtn ) } )
   end if

   oDlg2:AddFastKey ( VK_F1, {|| ChmHelp ("Añadir_linea_existencias") } )

   oDlg2:bStart := {|| if( !lUseCaj(), ( aGet[_NCANENT]:hide(), oSayCaja:hide() ),  ) }

   ACTIVATE DIALOG oDlg2 CENTER ON PAINT ( lCalcDeta( aTmp, oTotal ) )

RETURN ( oDlg2:nResult == IDOK )

//--------------------------------------------------------------------------//

/*
Funcion Auxiliar para A¤adir lineas de detalle a un albaran
*/

STATIC FUNCTION AppDeta(oBrw2, bEdit2, aTmp)

	WinAppRec( oBrw2, bEdit2, dbfTmp, , , aTmp )

RETURN ( nTotExtAge( nil, nil, dbfTmp, dbfIva, dbfDivisa, aTmp ) )

//--------------------------------------------------------------------------//
/*
Funcion Auxiliar para la Edici¢n de Lineas de Detalle en un albaran
*/

STATIC FUNCTION EdtDeta(oBrw2, bEdit2, aTmp )

	WinEdtRec( oBrw2, bEdit2, dbfTmp, , , aTmp )

RETURN ( nTotExtAge( nil, nil, dbfTmp, dbfIva, dbfDivisa, aTmp ) )

//--------------------------------------------------------------------------//

/*
Funcion Auxiliar para borrar las Lineas de Detalle en un albaran
*/

STATIC FUNCTION DelDeta( oBrw2, aTmp )

	dbDelRec( oBrw2, dbfTmp )

RETURN ( nTotExtAge( nil, nil, dbfTmp, dbfIva, dbfDivisa, aTmp ) )

//--------------------------------------------------------------------------//

/*
Funcion Auxiliar para la Visualizaci¢n de Lineas de Detalle en una Abono
*/

STATIC FUNCTION EdtZoom( oBrw2, bEdit2, aTmp )

	WinZooRec( oBrw2, bEdit2, dbfTmp )

RETURN NIL

//--------------------------------------------------------------------------//

STATIC FUNCTION SaveDeta( aTmp, aGet, oBrw, oDlg2, nMode, oTotal, oBtn )

   oBtn:SetFocus()

	WinGather( aTmp, aGet, dbfTmp, oBrw, nMode )

   if nMode == APPD_MODE .AND. lEntCon()
		aGet[_NCANENT]:cText( 1 )
      aGet[_CREF   ]:setFocus()
		oTotal:cText( 0 )
   else
      oDlg2:end( IDOK )
   end if

RETURN NIL

//--------------------------------------------------------------------------//

STATIC FUNCTION PrnSerie()

	local oDlg
   local oDocIni
	local oDocFin
   local oSerIni
   local oSerFin
   local oSufIni
	local oBtnOk
	local oBtnCancel
   local nRecno   := (dbfExtAgeT)->(RecNo())
   local nOrdAnt  := (dbfExtAgeT)->(OrdSetFocus(1))
   local cSerIni  := (dbfExtAgeT)->cSerExt
   local cSerFin  := (dbfExtAgeT)->cSerExt
   local nDocIni  := (dbfExtAgeT)->nNumExt
   local nDocFin  := (dbfExtAgeT)->nNumExt
   local cSufIni  := (dbfExtAgeT)->cSufExt
   local cSufFin  := (dbfExtAgeT)->cSufExt

   DEFINE DIALOG oDlg RESOURCE "PRNSERIES" TITLE "Imprimir series de existencias"

   REDEFINE GET oSerIni VAR cSerIni;
      ID       90 ;
      PICTURE  "@!" ;
      SPINNER  ;
      ON UP    ( UpSerie( oSerIni ) );
      ON DOWN  ( DwSerie( oSerIni ) );
      VALID    ( cSerIni >= "A" .AND. cSerIni <= "Z"  );
      OF       oDlg

   REDEFINE GET oDocIni VAR nDocIni ;
		ID 		110 ;
		PICTURE 	"999999999" ;
      SPINNER  ;
      OF       oDlg

   REDEFINE GET oSufIni VAR cSufIni ;
      ID       120 ;
      WHEN     .f. ;
      OF       oDlg

   REDEFINE GET oSerFin VAR cSerFin ;
      ID       100 ;
      PICTURE  "@!" ;
      SPINNER  ;
      ON UP    ( UpSerie( oSerFin ) );
      ON DOWN  ( DwSerie( oSerFin ) );
      VALID    ( cSerFin >= "A" .AND. cSerFin <= "Z"  );
      OF       oDlg

	REDEFINE GET oDocFin VAR nDocFin;
      ID       130 ;
		PICTURE 	"999999999" ;
      SPINNER  ;
      OF       oDlg

   REDEFINE GET oSufIni VAR cSufIni ;
      ID       140 ;
      WHEN     .f. ;
      OF       oDlg

	REDEFINE BUTTON oBtnOk ;
		ID 		505 ;
		OF 		oDlg ;
      ACTION   ( StartPrint( cSerIni + Str( nDocIni, 9 ) + cSufIni, cSerFin + Str( nDocFin, 9 ) + cSufFin, oBtnOk, oBtnCancel ), oDlg:end( IDOK ) )

	REDEFINE BUTTON oBtnCancel ;
      ID       IDCANCEL ;
		OF 		oDlg ;
		ACTION 	( oDlg:end() )

   oDlg:AddFastKey( VK_F5, {|| StartPrint( cSerIni + Str( nDocIni, 9 ) + cSufIni, cSerFin + Str( nDocFin, 9 ) + cSufFin, oBtnOk, oBtnCancel ), oDlg:end( IDOK ) } )

   oDlg:bStart := { || oSerIni:SetFocus() }

	ACTIVATE DIALOG oDlg CENTER

   ( dbfExtAgeT )->( dbGoTo( nRecNo ) )
   ( dbfExtAgeT )->( ordSetFocus( nOrdAnt ) )


	oWndBrw:refresh()

RETURN NIL

//--------------------------------------------------------------------------//

STATIC FUNCTION StartPrint( cDocIni, cDocFin, oBtnOk, oBtnCancel )

	oBtnOk:disable()
	oBtnCancel:disable()

   ( dbfExtAgeT )->( dbSeek( cDocIni, .t. ) )

   while ( dbfExtAgeT )->cSerExt + Str( ( dbfExtAgeT )->nNumExt ) + ( dbfExtAgeT )->cSufExt >= cDocIni .and.;
         ( dbfExtAgeT )->cSerExt + Str( ( dbfExtAgeT )->nNumExt ) + ( dbfExtAgeT )->cSufExt <= cDocFin

      GenExtAge( .T., "Imprimiendo documento : " + ( dbfExtAgeT )->cSerExt + Str( ( dbfExtAgeT )->nNumExt ) + ( dbfExtAgeT )->cSufExt )
      ( dbfExtAgeT )->(DbSkip(1))

   end while

	oBtnOk:enable()
	oBtnCancel:enable()

RETURN NIL

//--------------------------------------------------------------------------//
/*
Calcula el Total de la existencia
*/

FUNCTION nTotExtAge( nNumExt, dbfMaster, dbfLine, cDbfIva, cDbfDivisa, aTmp, lEuro )

	local nRecno
	local bCondition
	local cCodDiv
   local aTotalDto      := { 0, 0, 0 }
   local aTotalDPP      := { 0, 0, 0 }
   local lRecargo
   local nDtoEsp
   local nDtoPP

   DEFAULT lEuro        := .f.
   DEFAULT dbfMaster    := dbfExtAgeT
   DEFAULT dbfLine      := dbfExtAgeL
   DEFAULT cDbfIva      := dbfIva
   DEFAULT cDbfDivisa   := dbfDivisa
   DEFAULT nNumExt      := ( dbfExtAgeT )->cSerExt + Str( ( dbfExtAgeT )->nNumExt ) + ( dbfExtAgeT )->cSufExt

   public nTotNet       := 0
   public nTotBrt       := 0
   public nTotDto       := 0
   public nTotDpp       := 0
   public nTotIva       := 0
   public nTotReq       := 0
   public nTotExt       := 0
   public nTotEur       := 0
   public aTotIva       := { { 0,0,nil,0 }, { 0,0,nil,0 }, { 0,0,nil,0 } }
   public aIvaUno       := aTotIva[ 1 ]
   public aIvaDos       := aTotIva[ 2 ]
   public aIvaTre       := aTotIva[ 3 ]

   nTotalAge            := 0
   nRecno               := (dbfLine)->(RecNo())

   if aTmp != NIL
		lRecargo			:= aTmp[ _LRECARGO]
		nDtoEsp			:= aTmp[ _NDTOESP ]
		nDtoPP			:= aTmp[ _NDPP    ]
      cCodDiv        := aTmp[ _CDIVEXT ]
      bCondition     := {|| !(dbfLine)->(eof() ) }
      ( dbfLine )->( dbGoTop() )
   else
		lRecargo			:= (dbfMaster)->LRECARGO
		nDtoEsp			:= (dbfMaster)->NDTOESP
		nDtoPP			:= (dbfMaster)->NDPP
      cCodDiv        := (dbfMaster)->CDIVEXT
      bCondition     := {|| (dbfLine)->CSEREXT + Str( (dbfLine)->NNUMEXT ) + (dbfLine)->CSUFEXT == nNumExt .AND. !(dbfLine)->( eof() ) }
      ( dbfLine )->( dbSeek( nNumExt ) )
   end if

   cPinDiv           := cPinDiv( cCodDiv, dbfDivisa )
   nDinDiv           := nDinDiv( cCodDiv, dbfDivisa )

   while Eval( bCondition )

      nTotalArt      := nTotLExtAge( dbfLine )

      /*
      Estudio de impuestos
      */

      do case
      case _NPCTIVA1 == nil .or. _NPCTIVA1 == (dbfLine)->NIVA
         _NPCTIVA1   := (dbfLine)->nIva
			_NBRTIVA1 	+= nTotalArt
      case _NPCTIVA2 == nil .or. _NPCTIVA2 == (dbfLine)->NIVA
         _NPCTIVA2   := (dbfLine)->NIVA
			_NBRTIVA2 	+= nTotalArt
      case _NPCTIVA3 == nil .or. _NPCTIVA3 == (dbfLine)->NIVA
         _NPCTIVA3   := (dbfLine)->NIVA
         _NBRTIVA3   += nTotalArt
      end case

		(dbfLine)->(DbSkip())

   end while

   ( dbfLine )->( dbGoto( nRecno ) )

   /*Ordenamos los impuestosS de menor a mayor*/

   aTotIva        := aSort( aTotIva,,, {|x,y| if( x[3] != nil, x[3], -1 ) > if( y[3] != nil, y[3], -1 )  } )

   _NBASIVA1      := Round( _NBRTIVA1, nDinDiv )
   _NBASIVA2      := Round( _NBRTIVA2, nDinDiv )
   _NBASIVA3      := Round( _NBRTIVA3, nDinDiv )

   /*
   Guardamos el bruto
   */

   nTotBrt        := _NBRTIVA1 + _NBRTIVA2 + _NBRTIVA3

   /*
   Descuentos Especiales
   */

   if nDtoEsp  != 0

      aTotalDto[1]   := Round( _NBASIVA1 * nDtoEsp / 100, nDinDiv )
      aTotalDto[2]   := Round( _NBASIVA2 * nDtoEsp / 100, nDinDiv )
      aTotalDto[3]   := Round( _NBASIVA3 * nDtoEsp / 100, nDinDiv )

      nTotDto        := aTotalDto[1] + aTotalDto[2] + aTotalDto[3]

      _NBASIVA1      -= aTotalDto[1]
      _NBASIVA2      -= aTotalDto[2]
      _NBASIVA3      -= aTotalDto[3]

   end if

   /*
   Descuentos por Pronto Pago estos son los buenos
   */

   if nDtoPP   != 0

      aTotalDPP[1]   := Round( _NBASIVA1 * nDtoPP / 100, nDinDiv )
      aTotalDPP[2]   := Round( _NBASIVA2 * nDtoPP / 100, nDinDiv )
      aTotalDPP[3]   := Round( _NBASIVA3 * nDtoPP / 100, nDinDiv )

      nTotDPP        := aTotalDPP[1] + aTotalDPP[2] + aTotalDPP[3]

      _NBASIVA1      -= aTotalDPP[1]
      _NBASIVA2      -= aTotalDPP[2]
      _NBASIVA3      -= aTotalDPP[3]

   end if

   /*
   Guardamos la base
   */

   nTotNet           := _NBASIVA1 + _NBASIVA2 + _NBASIVA3

   /*
   Calculos de impuestos
   */

   nTotIva           := if( _NPCTIVA1 != nil, Round( _NBASIVA1 * _NPCTIVA1 / 100, nDinDiv ), 0 )
   nTotIva           += if( _NPCTIVA2 != nil, Round( _NBASIVA2 * _NPCTIVA2 / 100, nDinDiv ), 0 )
   nTotIva           += if( _NPCTIVA3 != nil, Round( _NBASIVA3 * _NPCTIVA3 / 100, nDinDiv ), 0 )

   /*
   Total de impuestos
   */

   nTotalImp         := nTotIva + nTotReq

   /*
   Total existencia
   */

   nTotExt           := nTotNet + nTotalImp

   /*
   Guardamos el valor en euros
   */

   nTotEur           := nTotExt / nChgDiv( cCodDiv, dbfDivisa )

   /*
   Nos lo piden en otra moneda
   */

   if lEuro
      nTotExt        := nCnv2Div( nTotExt, cCodDiv, cDivChg(), dbfDivisa )
   end if

RETURN ( Trans( nTotExt, cPinDiv ) )

//--------------------------------------------------------------------------//

STATIC FUNCTION nRecTotal( dbfLine, aTmp )

   nTotExtAge( nil, nil, dbfLine, dbfIva, dbfDivisa, aTmp )

   if oBrwIva != NIL
      oBrwIva:Refresh()
   end if

   if oGetNet != NIL
      oGetNet:SetText( nTotNet )
   end if

   if oGetIva != NIL
      oGetIva:SetText( nTotIva )
   end if

   if oGetReq != NIL
      oGetReq:SetText( nTotReq )
   end if

   if oGetTotal != NIL
      oGetTotal:SetText( nTotExt )
   end if

   if oGetTotEur != NIL
      oGetTotEur:SetText( nTotEur )
   end if

RETURN ( .T. )

//--------------------------------------------------------------------------//

/*
Borra todas las lineas de detalle de un Albaran
*/

STATIC FUNCTION DelDetalle( cNumExt )

   CursorWait()

   while ( dbfExtAgeL )->( dbSeek( cNumExt ) )
      if dbLock( dbfExtAgeL )
         ( dbfExtAgeL )->( dbDelete() )
         ( dbfExtAgeL )->( dbUnLock() )
      end if 
   end while      

   CursorWe()

RETURN NIL

//--------------------------------------------------------------------------//
/*
Calcula totales en las lineas de Detalle
*/

STATIC FUNCTION lCalcDeta( aTmp, oTotal )

	local nCalculo := aTmp[_NPREUNIT] * aTmp[_NUNICAJA]

   IF lCalCaj()
		nCalculo *= If( aTmp[_NCANENT] != 0, aTmp[_NCANENT], 1 )
	END IF

	IF aTmp[_NDTO] != 0
		nCalculo -= nCalculo * aTmp[_NDTO] / 100
	END IF

	IF aTmp[_NDTOPRM] != 0
		nCalculo -= nCalculo * aTmp[_NDTOPRM] / 100
	END IF

	IF oTotal != NIL
		oTotal:varPut( nCalculo )
		oTotal:refresh()
	END IF

RETURN .T.

//--------------------------------------------------------------------------//

STATIC FUNCTION LoadAlm( aGet, aTmp, nMode )

	local cAreaAnt := Alias()
	local lValid 	:= .F.
	local xValor 	:= aGet[_CCODALM]:varGet()

	IF Empty( Rtrim( xValor ) )
		RETURN .T.
	END IF

	IF (dbfAlmT)->( DbSeek( xValor ) )

		/*
		Si estamos a¤adiendo cargamos todos los datos del Agente
		*/

		aGet[_CCODALM]:cText( (dbfAlmT)->CCODALM )
		aGet[_CNOMALM]:cText( (dbfAlmT)->CNOMALM )
      aGet[_CDIRALM]:cText( (dbfAlmT)->CDIRALM )
      aGet[_CPOBALM]:cText( (dbfAlmT)->CPOBALM )
      aGet[_CPRVALM]:cText( (dbfAlmT)->CPROALM )
      aGet[_CPOSALM]:cText( (dbfAlmT)->CPOSALM )

		lValid	:= .T.

	ELSE

      msgStop( "Almacén no encontrado." )

	END IF

	IF ( cAreaAnt != "",	SELECT( cAreaAnt ), )

RETURN lValid

//----------------------------------------------------------------------------//

STATIC FUNCTION LoadArt( aGet, aTmpExt )

	local cAreaAnt := Alias()
	local lValid   := .F.
	local xValor   := aGet[_CREF]:varGet()

	IF Empty( xValor )

		aGet[_NIVA]:varPut( 0 )
		aGet[_NIVA]:bWhen		:= {|| .T. }
		aGet[_NIVA]:refresh()

		aGet[_CDETALLE]:varPut( Space( 50 ) )
		aGet[_CDETALLE]:bWhen	:= {|| .T. }
		aGet[_CDETALLE]:refresh()

		RETURN .T.

	END IF

	IF (dbfArticulo)->( DbSeek( xValor ) )

		aGet[_CREF]:cText( (dbfArticulo)->CODIGO )
		aGet[_NUNICAJA]:cText( (dbfArticulo)->NUNICAJA )
		aGet[_CUNIDAD]:cText( (dbfArticulo)->CUNIDAD )

		/*
		Chequeamos situaciones especiales y comprobamos las fechas
		*/

      IF !Empty( aTmpExt[ _CCODTAR ] ) .and. RetPrcTar( ( dbfArticulo )->Codigo, aTmpExt[ _CCODTAR ], Space(5), Space(5), Space(5), Space(5), dbfTarPreL ) != 0
         aGet[_NPREUNIT]:cText( RetPrcTar( ( dbfArticulo )->Codigo, aTmpExt[_CCODTAR], Space(5), Space(5), Space(5), Space(5), dbfTarPreL ) )
         aGet[_NDTO    ]:cText( RetPctTar( ( dbfArticulo )->Codigo, ( dbfArticulo )->Familia, aTmpExt[ _CCODTAR ], Space(5), Space(5), Space(5), Space(5), dbfTarPreL ) )
         aGet[_NDTOPRM ]:cText( RetDtoPrm( xValor, aTmpExt[ _CCODTAR ], Space(5), Space(5), Space(5), Space(5), aTmpExt[ _DFECEXT ], dbfPromoT ) )
		ELSE
			aGet[_NPREUNIT]:cText( (dbfArticulo)->PVENTA1 )
		END IF

		aGet[_CDETALLE]:cText( (dbfArticulo)->NOMBRE )
		aGet[_CDETALLE]:bWhen	:= {|| .F. }

		IF aGet[_NIVA] != NIL
			aGet[_NIVA]:cText( nIva( dbfIva, (dbfArticulo)->TIPOIVA ) )
			aGet[_NIVA]:bWhen	:= {|| .F. }
		END IF

		lValid	:= .T.

	ELSE

		MsgStop( "Articulo no encontrado" )
		lValid := .F.

	END IF

	IF cAreaAnt != ""
		SELECT( cAreaAnt )
	END IF

RETURN lValid

//--------------------------------------------------------------------------//

STATIC FUNCTION EPage( cCodDoc, oInf )

	private nPagina		:= oInf:nPage
	private lEnd			:= oInf:lFinish

   PrintItems( cCodDoc, oInf )

RETURN NIL

//--------------------------------------------------------------------------//

FUNCTION nTotLExtAge( dbfLine )

   local nCalculo

   DEFAULT dbfLine   := dbfExtAgeL

   nCalculo          := (dbfLine)->NUNICAJA * (dbfLine)->NPREUNIT

   IF lCalCaj()
      nCalculo       *= If( (dbfLine)->NCANENT != 0, (dbfLine)->NCANENT, 1 )
	END IF

	IF (dbfLine)->NDTO != 0
      nCalculo       -= nCalculo * (dbfLine)->NDTO / 100
	END IF

	IF (dbfLine)->NDTOPRM != 0
      nCalculo       -= nCalculo * (dbfLine)->NDTOPRM / 100
   END IF

RETURN ( nCalculo )

//---------------------------------------------------------------------------//

FUNCTION mkExtAge( cPath, lAppend, cPathOld, oMeter )

   local dbfExtAgeT

   DEFAULT lAppend   := .f.

	IF oMeter != NIL
		oMeter:cText	:= "Generando Bases"
		sysrefresh()
	END IF

	CreateFiles( cPath )

   if lAppend .and. lIsDir( cPathOld )

      dbUseArea( .t., cDriver(), cPath + "ExtAgeT.DBF", cCheckArea( "ExtAgeT", @dbfExtAgeT ), .f. )
      if !( dbfExtAgeT )->( neterr() )
         ( dbfExtAgeT )->( __dbApp( cPathOld + "ExtAgeT.DBF" ) )
         ( dbfExtAgeT )->( dbCloseArea() )
      end if

      dbUseArea( .t., cDriver(), cPath + "ExtAgeL.DBF", cCheckArea( "ExtAgeL", @dbfExtAgeT ), .f. )
      if !( dbfExtAgeT )->( neterr() )
         ( dbfExtAgeT )->( __dbApp( cPathOld + "ExtAgeL.DBF" ) )
         ( dbfExtAgeT )->( dbCloseArea() )
      end if

   end if

   rxExtAge( cPath, oMeter )

RETURN NIL

//---------------------------------------------------------------------------//

FUNCTION rxExtAge( cPath, oMeter )

   local dbfExtAgeT

   DEFAULT cPath  := cPatEmp()

   if !lExistTable( cPath + "EXTAGET.DBF" ) .OR. !lExistTable( cPath + "EXTAGEL.DBF" )
		CreateFiles( cPath )
   end if

   fEraseIndex( cPath + "ExtAgeT.CDX" )
   fEraseIndex( cPath + "ExtAgeL.CDX" )

   dbUseArea( .t., cDriver(), cPath + "EXTAGET.DBF", cCheckArea( "EXTAGET", @dbfExtAgeT ), .f. )
   if !( dbfExtAgeT )->( neterr() )
      ( dbfExtAgeT)->( __dbPack() )

      ( dbfExtAgeT)->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( dbfExtAgeT)->( ordCreate( cPath + "EXTAGET.CDX", "NNUMEXT", "CSEREXT + Str( NNUMEXT ) + CSUFEXT", {|| Field->CSEREXT + Str( Field->NNUMEXT ) + Field->CSUFEXT } ) )

      ( dbfExtAgeT)->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( dbfExtAgeT)->( ordCreate( cPath + "EXTAGET.CDX", "DFECEXT", "DFECEXT", {|| Field->DFECEXT } ) )

      ( dbfExtAgeT)->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( dbfExtAgeT)->( ordCreate( cPath + "EXTAGET.CDX", "CCODALM", "CCODALM", {|| Field->CCODALM } ) )

      ( dbfExtAgeT )->( dbCloseArea() )
   else
      msgStop( "Imposible abrir en modo exclusivo la tabla de existencias" )
   end if

   dbUseArea( .t., cDriver(), cPath + "EXTAGEL.DBF", cCheckArea( "EXTAGEL", @dbfExtAgeL ), .f. )
   if !( dbfExtAgeL )->( neterr() )
      ( dbfExtAgeL)->( __dbPack() )

      ( dbfExtAgeL )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( dbfExtAgeL )->( ordCreate( cPath + "EXTAGEL.CDX", "NNUMEXT", "CSEREXT + Str( NNUMEXT ) + CSUFEXT", {|| Field->CSEREXT + Str( Field->NNUMEXT ) + Field->CSUFEXT } ) )

      ( dbfExtAgeL )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( dbfExtAgeL )->( ordCreate( cPath + "EXTAGEL.CDX", "CREF", "CREF", {|| Field->CREF } ) )

      ( dbfExtAgeL )->( dbCloseArea() )
   else
      msgStop( "Imposible abrir en modo exclusivo la tabla de existencias" )
   end if

RETURN NIL

//--------------------------------------------------------------------------//

STATIC FUNCTION BeginTrans( aTmp )

   local cDbf     := "EAgeL"
   local cExt     := aTmp[ _CSEREXT ] + Str( aTmp[ _NNUMEXT ] ) + aTmp[ _CSUFEXT ]

   cNewFile       := cGetNewFileName( cPatTmp() + cDbf )

	/*
	Primero Crear la base de datos local
	*/

   dbCreate( cNewFile, aSqlStruct( aColExtAge() ), cLocalDriver() )

   dbUseArea( .t., cLocalDriver(), cNewFile, cCheckArea( cDbf, @dbfTmp ), .f. )
   if !( dbfTmp )->( neterr() )

      ( dbfTmp )->( OrdCondSet( "!Deleted()", {||!Deleted() } ) )
      ( dbfTmp )->( OrdCreate( cNewFile, "Recno", "Str( Recno() )", {|| Str( Recno() ) } ) )

      /*
      A¤adimos desde el fichero de lineas
      */

      if ( dbfExtAgeL )->( dbSeek( cExt ) )

         while ( ( dbfExtAgeL )->CSEREXT + Str( ( dbfExtAgeL )->NNUMEXT ) + ( dbfExtAgeL )->CSUFEXT == cExt .AND. !( dbfExtAgeL )->( Eof() ) )

            dbPass( dbfExtAgeL, dbfTmp, .t. )
            ( dbfExtAgeL )->( dbSkip() )

         end while

      end if

      ( dbfTmp )->( dbGoTop() )

   end if

RETURN NIL

//-----------------------------------------------------------------------//

STATIC FUNCTION EndTrans( aTmp, oBrw, nMode )

   local oError
   local oBlock
   local aTabla
   local cExt     := aTmp[ _CSEREXT ] + Str( aTmp[ _NNUMEXT ] ) + aTmp[ _CSUFEXT ]

   /*
	Primero hacer el RollBack
	*/

   oBlock         := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      BeginTransaction()

      oMsgProgress():SetRange( 0, ( dbfTmp )->( LastRec() ) )

      do case
      case nMode == EDIT_MODE 

         delDetalle( cExt )

      case nMode == APPD_MODE .or. nMode == DUPL_MODE

         aTmp[ _CSEREXT ]  := "A"
         aTmp[ _NNUMEXT ]  := nNewDoc( "A", dbfExtAgeT, "NEXTAGE", , dbfCount )
         aTmp[ _CSUFEXT ]  := RetSufEmp()

      end case

      ( dbfTmp )->( DbGoTop() )
      while ( dbfTmp )->( !Eof() )

         aTabla               := DBScatter( dbfTmp )
         aTabla[ _CSEREXT ]   := aTmp[_CSEREXT]
         aTabla[ _NNUMEXT ]   := aTmp[_NNUMEXT]
         aTabla[ _CSUFEXT ]   := aTmp[_CSUFEXT]

         dbGather( aTabla, dbfExtAgeL, .t. )

         ( dbfTmp )->( dbSkip() )

         oMsgProgress():Deltapos(1)

      end while

      /*
      Escribe los datos pendientes------------------------------------------------
      */

      dbCommitAll()

      CommitTransaction()

   RECOVER USING oError

      RollBackTransaction()
      msgStop( "Imposible almacenar documento" + CRLF + ErrorMessage( oError ) )

   END SEQUENCE
   ErrorBlock( oBlock )

	/*
   Borramos los ficheros-------------------------------------------------------
	*/

   dbfErase( cNewFile )

   EndProgress()

Return .t.

//---------------------------------------------------------------------------//

STATIC FUNCTION KillTrans()

	/*
	Borramos los ficheros
	*/

	( dbfTmp )->( dbCloseArea() )

   dbfErase( cNewFile )

RETURN NIL

//------------------------------------------------------------------------//

STATIC FUNCTION CreateFiles( cPath )

   if !lExistTable( cPath + "EXTAGET.DBF" )
      dbCreate( cPath + "EXTAGET.DBF", aSqlStruct( aItmExtAge() ), cDriver() )
   end if

   if !lExistTable( cPath + "EXTAGEL.DBF" )
      dbCreate( cPath + "EXTAGEL.DBF", aSqlStruct( aColExtAge() ), cDriver() )
   end if

RETURN NIL

//--------------------------------------------------------------------//

/*
Devuelve en numero de articulos en una linea de detalle
*/

STATIC FUNCTION nTotLNumArt( dbfDetalle )

	local nCalculo := 0

   if lCalCaj() .and. ( dbfDetalle )->NCANENT != 0 .and. ( dbfDetalle )->NPREUNIT != 0
      nCalculo    := ( dbfDetalle )->NCANENT
   end if

RETURN ( nCalculo )

//---------------------------------------------------------------------------//

STATIC FUNCTION GenExtAge( lPrinter, cCaption, cCodDoc, nCopies )

   local nNumExt        := ( dbfExtAgeT )->CSEREXT + Str( ( dbfExtAgeT )->NNUMEXT ) + ( dbfExtAgeT )->CSUFEXT
   local nCodAlm        := ( dbfExtAgeT )->CCODALM
   local nOldRecno      := ( dbfExtAgeL )->( recno() )

   DEFAULT lPrinter     := .f.
   DEFAULT cCaption     := "Imprimiendo existencias"
   DEFAULT cCodDoc      := cFormatoDocumento( ( dbfExtAgeT )->cSerExt, "nExtAge", dbfCount )
   DEFAULT nCopies      := nCopiasDocumento( ( dbfExtAgeT )->cSerExt, "nExtAge", dbfCount )

   private cDbf         := dbfExtAgeT
   private cDbfCol      := dbfExtAgeL
	private cIva			:= dbfIva
	private cFPago			:= dbfFPago
   private cPinDivExt   := cPinDiv
   private cPicEurExt   := cPicEur
   private nDinDivExt   := nDinDiv
   private cPouExtAge   := cPouDiv

   if Empty( cCodDoc )
      cCodDoc           := if( ( dbfExtAgeT )->cSerExt == "A", "EX1", "EX2" )
   end if

   if !lExisteDocumento( cCodDoc, dbfDoc )
      return nil
   end if

   if lVisualDocumento( cCodDoc, dbfDoc )

      PrintReportExtAge( if( lPrinter, IS_PRINTER, IS_SCREEN ), nCopies, nil, dbfDoc )

   else

      ( dbfAlmT    )->( dbSeek( nCodAlm ) )
      ( dbfExtAgeL )->( dbSeek( nNumExt ) )

      if lPrinter
         REPORT oInf CAPTION cCaption TO PRINTER
      else
         REPORT oInf CAPTION cCaption PREVIEW
      end if

      if !Empty( oInf ) .and. oInf:lCreated

         oInf:lFinish            := .f.
         oInf:lNoCancel          := .t.
         oInf:bSkip              := {|| ( dbfExtAgeL )->( dbSkip() ) }

         oInf:oDevice:lPrvModal  := .t.

         SetMargin( cCodDoc, oInf )
         PrintColum( cCodDoc, oInf )

      end if

      END REPORT

      ACTIVATE REPORT oInf ;
         WHILE       ( ( dbfExtAgeL )->cSerExt + Str( ( dbfExtAgeL )->nNumExt ) + ( dbfExtAgeL )->cSufExt == nNumExt );
         ON ENDPAGE  Epage( cCodDoc, oInf )

      ( dbfExtAgeL )->( dbGoto( nOldRecno ) )

   end if

RETURN NIL

//---------------------------------------------------------------------------//

static function nGenExtAge( lImp, cTitle, cCodDoc, cPrinter, nCopy )

   local nImpYet  := 1

   DEFAULT lImp   := .t.

   nCopy          := Max( nCopy, 1 )

   while nImpYet <= nCopy
      GenExtAge( lImp, cTitle, cCodDoc )
      nImpYet++
   end while

return nil

//---------------------------------------------------------------------------//

function lGenExtAge( oBrw, oBtn, lImp )

   local bAction

   DEFAULT lImp   := .f.

   if !( dbfDoc )->( dbSeek( "EX" ) )

      DEFINE BTNSHELL RESOURCE "DOCUMENT" OF oWndBrw ;
         NOBORDER ;
         ACTION   ( msgStop( "No hay documentos predefinidos" ) );
         TOOLTIP  "No hay documentos" ;
         HOTKEY   "N";
         FROM     oBtn ;
         CLOSED ;
         LEVEL    ACC_EDIT

   else

      while ( dbfDoc )->CTIPO == "EX" .AND. !( dbfDoc )->( eof() )

         bAction  := bGenExtAge( lImp, "Imprimiendo existencias", ( dbfDoc )->CODIGO )

         oWndBrw:NewAt( "Document", , , bAction, Rtrim( ( dbfDoc )->cDescrip ) , , , , , oBtn )

         ( dbfDoc )->( dbSkip() )

      end do

   end if

return nil

//---------------------------------------------------------------------------//

static function bGenExtAge( lImprimir, cTitle, cCodDoc )

   local bGen
   local lImp  := by( lImprimir )
   local cTit  := by( cTitle    )
   local cCod  := by( cCodDoc   )

   if lImp
      bGen     := {|| nGenExtAge( lImp, cTit, cCod ) }
   else
      bGen     := {|| GenExtAge( lImp, cTit, cCod ) }
   end if

return ( bGen )

//---------------------------------------------------------------------------//

STATIC FUNCTION ChgState( oBrw )

   if dbLock( dbfExtAgeT )
      ( dbfExtAgeT )->lLiqExt := ! ( dbfExtAgeT )->lLiqExt
      ( dbfExtAgeT )->( dbUnlock() )
   end if

   oBrw:DrawSelect()

RETURN NIL

//--------------------------------------------------------------------------//

#include "FastRepH.ch"

Static Function DataReport( oFr )

   /*
   Zona de datos------------------------------------------------------------
   */

   oFr:ClearDataSets()

   oFr:SetWorkArea(     "Existencia", ( dbfExtAgeT )->( Select() ), .f., { FR_RB_CURRENT, FR_RB_CURRENT, 0 } )
   oFr:SetFieldAliases( "Existencia", cItemsToReport( aItmExtAge() ) )

   oFr:SetWorkArea(     "Lineas de existencias", ( dbfExtAgeL )->( Select() ) )
   oFr:SetFieldAliases( "Lineas de existencias", cItemsToReport( aColExtAge() ) )

   oFr:SetWorkArea(     "Empresa", ( dbfEmp )->( Select() ) )
   oFr:SetFieldAliases( "Empresa", cItemsToReport( aItmEmp() ) )

   oFr:SetWorkArea(     "Almacenes", ( dbfAlmT )->( Select() ) )
   oFr:SetFieldAliases( "Almacenes", cItemsToReport( aItmAlm() ) )

   oFr:SetWorkArea(     "Formas de pago", ( dbfFpago )->( Select() ) )
   oFr:SetFieldAliases( "Formas de pago", cItemsToReport( aItmFPago() ) )

   oFr:SetMasterDetail( "Existencia", "Lineas de existencias",   {|| ( dbfExtAgeT )->cSerExt + Str( ( dbfExtAgeT )->nNumExt ) + ( dbfExtAgeT )->cSufExt } )
   oFr:SetMasterDetail( "Existencia", "Empresa",                 {|| cCodigoEmpresaEnUso() } )
   oFr:SetMasterDetail( "Existencia", "Almacenes",               {|| ( dbfExtAgeT )->cCodAlm } )
   oFr:SetMasterDetail( "Existencia", "Formas de pago",          {|| ( dbfExtAgeT )->cCodPgo } )

   oFr:SetResyncPair(   "Existencia", "Lineas de existencias" )
   oFr:SetResyncPair(   "Existencia", "Empresa" )
   oFr:SetResyncPair(   "Existencia", "Almacenes" )
   oFr:SetResyncPair(   "Existencia", "Formas de pago" )

Return nil

//---------------------------------------------------------------------------//

Static Function VariableReport( oFr )

   oFr:DeleteCategory(  "Existencia" )
   oFr:DeleteCategory(  "Lineas de existencias" )

   /*
   Creación de variables----------------------------------------------------
   */

   oFr:AddVariable(     "Existencia",             "Total existencia",                     "GetHbVar('nTotExt')" )
   oFr:AddVariable(     "Existencia",             "Total descuento",                      "GetHbVar('nTotDto')" )
   oFr:AddVariable(     "Existencia",             "Total descuento pronto pago",          "GetHbVar('nTotDpp')" )
   oFr:AddVariable(     "Existencia",             "Total bruto",                          "GetHbVar('nTotBrt')" )
   oFr:AddVariable(     "Existencia",             "Total neto",                           "GetHbVar('nTotNet')" )
   oFr:AddVariable(     "Existencia",             "Total " + cImp(),                      "GetHbVar('nTotIva')" )
   oFr:AddVariable(     "Existencia",             "Total RE",                             "GetHbVar('nTotReq')" )
   oFr:AddVariable(     "Existencia",             "Bruto primer tipo de " + cImp(),       "GetHbArrayVar('aIvaUno',1)" )
   oFr:AddVariable(     "Existencia",             "Bruto segundo tipo de " + cImp(),      "GetHbArrayVar('aIvaDos',1)" )
   oFr:AddVariable(     "Existencia",             "Bruto tercer tipo de " + cImp(),       "GetHbArrayVar('aIvaTre',1)" )
   oFr:AddVariable(     "Existencia",             "Base primer tipo de " + cImp(),        "GetHbArrayVar('aIvaUno',2)" )
   oFr:AddVariable(     "Existencia",             "Base segundo tipo de " + cImp(),       "GetHbArrayVar('aIvaDos',2)" )
   oFr:AddVariable(     "Existencia",             "Base tercer tipo de " + cImp(),        "GetHbArrayVar('aIvaTre',2)" )
   oFr:AddVariable(     "Existencia",             "Porcentaje primer tipo " + cImp(),     "GetHbArrayVar('aIvaUno',3)" )
   oFr:AddVariable(     "Existencia",             "Porcentaje segundo tipo " + cImp(),    "GetHbArrayVar('aIvaDos',3)" )
   oFr:AddVariable(     "Existencia",             "Porcentaje tercer tipo " + cImp(),     "GetHbArrayVar('aIvaTre',3)" )
   oFr:AddVariable(     "Existencia",             "Porcentaje primer tipo RE",            "GetHbArrayVar('aIvaUno',4)" )
   oFr:AddVariable(     "Existencia",             "Porcentaje segundo tipo RE",           "GetHbArrayVar('aIvaDos',4)" )
   oFr:AddVariable(     "Existencia",             "Porcentaje tercer tipo RE",            "GetHbArrayVar('aIvaTre',4)" )

   oFr:AddVariable(     "Lineas de existencias",  "Total linea existencia",               "CallHbFunc('nTotLExtAge')" )
   oFr:AddVariable(     "Lineas de existencias",  "Total unidades artículo",              "CallHbFunc('nTotNExtAge')" )

Return nil

//---------------------------------------------------------------------------//

Function DesignReportExtAge( oFr, dbfDoc )

   if OpenFiles()

      /*
      Zona de datos------------------------------------------------------------
      */

      DataReport( oFr )

      /*
      Paginas y bandas---------------------------------------------------------
      */

      if !Empty( ( dbfDoc )->mReport )

         oFr:LoadFromBlob( ( dbfDoc )->( Select() ), "mReport")

      else

         oFr:SetProperty(     "Report",            "ScriptLanguage", "PascalScript" )
         oFr:SetProperty(     "Report.ScriptText", "Text",;
                                                   + ;
                                                   "procedure DetalleOnMasterDetail(Sender: TfrxComponent);"   + Chr(13) + Chr(10) + ;
                                                   "begin"                                                     + Chr(13) + Chr(10) + ;
                                                   "CallHbFunc('nTotExtAge');"                                 + Chr(13) + Chr(10) + ;
                                                   "end;"                                                      + Chr(13) + Chr(10) + ;
                                                   "begin"                                                     + Chr(13) + Chr(10) + ;
                                                   "end." )

         oFr:AddPage(         "MainPage" )

         oFr:AddBand(         "CabeceraDocumento", "MainPage", frxPageHeader )
         oFr:SetProperty(     "CabeceraDocumento", "Top", 0 )
         oFr:SetProperty(     "CabeceraDocumento", "Height", 200 )

         oFr:AddBand(         "MasterData",  "MainPage", frxMasterData )
         oFr:SetProperty(     "MasterData",  "Top", 200 )
         oFr:SetProperty(     "MasterData",  "Height", 0 )
         oFr:SetProperty(     "MasterData",  "StartNewPage", .t. )
         oFr:SetObjProperty(  "MasterData",  "DataSet", "Existencia" )

         oFr:AddBand(         "DetalleColumnas",   "MainPage", frxDetailData  )
         oFr:SetProperty(     "DetalleColumnas",   "Top", 230 )
         oFr:SetProperty(     "DetalleColumnas",   "Height", 28 )
         oFr:SetObjProperty(  "DetalleColumnas",   "DataSet", "Lineas de existencias" )
         oFr:SetProperty(     "DetalleColumnas",   "OnMasterDetail", "DetalleOnMasterDetail" )

         oFr:AddBand(         "PieDocumento",      "MainPage", frxPageFooter )
         oFr:SetProperty(     "PieDocumento",      "Top", 930 )
         oFr:SetProperty(     "PieDocumento",      "Height", 110 )

      end if

      /*
      Zona de variables--------------------------------------------------------
      */

      VariableReport( oFr )

      /*
      Diseño de report---------------------------------------------------------
      */

      oFr:DesignReport()

      /*
      Destruye el diseñador----------------------------------------------------
      */

      oFr:DestroyFr()

      /*
      Cierra ficheros----------------------------------------------------------
      */

      CloseFiles()

   else

      Return .f.

   end if

Return .t.

//---------------------------------------------------------------------------//

Function PrintReportExtAge( nDevice, nCopies, cPrinter, dbfDoc )

   local oFr

   DEFAULT nDevice      := IS_SCREEN
   DEFAULT nCopies      := 1
   DEFAULT cPrinter     := PrnGetName()

   SysRefresh()

   oFr                  := frReportManager():New()

   oFr:LoadLangRes(     "Spanish.Xml" )

   oFr:SetIcon( 1 )

   oFr:SetTitle(        "Diseñador de documentos" )

   /*
   Manejador de eventos--------------------------------------------------------
   */

   oFr:SetEventHandler( "Designer", "OnSaveReport", {|| oFr:SaveToBlob( ( dbfDoc )->( Select() ), "mReport" ) } )

   /*
   Zona de datos------------------------------------------------------------
   */

   DataReport( oFr )

   /*
   Cargar el informe-----------------------------------------------------------
   */

   if !Empty( ( dbfDoc )->mReport )

      oFr:LoadFromBlob( ( dbfDoc )->( Select() ), "mReport")

      /*
      Zona de variables--------------------------------------------------------
      */

      VariableReport( oFr )

      /*
      Preparar el report-------------------------------------------------------
      */

      oFr:PrepareReport()

      /*
      Imprimir el informe------------------------------------------------------
      */

      do case
         case nDevice == IS_SCREEN
            oFr:ShowPreparedReport()

         case nDevice == IS_PRINTER
            oFr:PrintOptions:SetPrinter( cPrinter )
            oFr:PrintOptions:SetCopies( nCopies )
            oFr:PrintOptions:SetShowDialog( .f. )
            oFr:Print()

         case nDevice == IS_PDF
            oFr:SetProperty(  "PDFExport", "EmbeddedFonts",    .t. )
            oFr:SetProperty(  "PDFExport", "PrintOptimized",   .t. )
            oFr:SetProperty(  "PDFExport", "Outline",          .t. )
            oFr:DoExport(     "PDFExport" )

      end case

   end if

   /*
   Destruye el diseñador-------------------------------------------------------
   */

   oFr:DestroyFr()

Return .t.

//---------------------------------------------------------------------------//

FUNCTION nTotNExtAge( uDbf )

   local nTotUnd

   DEFAULT uDbf   := dbfExtAgeL

   do case
      case ValType( uDbf ) == "A"

      nTotUnd  := NotCaja( uDbf[ _NCANENT ] )
      nTotUnd  *= uDbf[ _NUNICAJA ]

      case ValType( uDbf ) == "C"

      nTotUnd  := NotCaja( ( uDbf )->nCanEnt )
      nTotUnd  *=( uDbf )->nUniCaja

      otherwise

      nTotUnd  := NotCaja( uDbf:nCanEnt )
      nTotUnd  *= uDbf:nUniCaja

   end case

Return ( nTotUnd )

//---------------------------------------------------------------------------//