#ifndef __PDA__
#include "FiveWin.Ch"
#include "Report.ch"
#else
#include "FWCE.ch"
REQUEST DBFCDX
#endif
#include "Factu.ch" 


/*
Definici¢n de la base de datos de Depositos de Almacen
*/

#define _CSERDEP                  ( dbfDepAgeT )->( FieldPos( "CSERDEP" ) )
#define _NNUMDEP                  ( dbfDepAgeT )->( FieldPos( "NNUMDEP" ) )
#define _CSUFDEP                  ( dbfDepAgeT )->( FieldPos( "CSUFDEP" ) )
#define _DFECDEP                  ( dbfDepAgeT )->( FieldPos( "DFECDEP" ) )
#define _CCODALM                  ( dbfDepAgeT )->( FieldPos( "CCODALM" ) )
#define _CNOMALM                  ( dbfDepAgeT )->( FieldPos( "CNOMALM" ) )
#define _CDIRALM                  ( dbfDepAgeT )->( FieldPos( "CDIRALM" ) )
#define _CPOBALM                  ( dbfDepAgeT )->( FieldPos( "CPOBALM" ) )
#define _CPRVALM                  ( dbfDepAgeT )->( FieldPos( "CPRVALM" ) )
#define _CPOSALM                  ( dbfDepAgeT )->( FieldPos( "CPOSALM" ) )
#define _CCODALI                  ( dbfDepAgeT )->( FieldPos( "CCODALI" ) )
#define _LLIQDEP                  ( dbfDepAgeT )->( FieldPos( "LLIQDEP" ) )
#define _CCODPGO                  ( dbfDepAgeT )->( FieldPos( "CCODPGO" ) )
#define _NBULTOS                  ( dbfDepAgeT )->( FieldPos( "NBULTOS" ) )
#define _NPORTES                  ( dbfDepAgeT )->( FieldPos( "NPORTES" ) )
#define _CCODTAR                  ( dbfDepAgeT )->( FieldPos( "CCODTAR" ) )
#define _CDTOESP                  ( dbfDepAgeT )->( FieldPos( "CDTOESP" ) )
#define _NDTOESP                  ( dbfDepAgeT )->( FieldPos( "NDTOESP" ) )
#define _CDPP                     ( dbfDepAgeT )->( FieldPos( "CDPP"    ) )
#define _NDPP                     ( dbfDepAgeT )->( FieldPos( "NDPP"    ) )
#define _CDTOUNO                  ( dbfDepAgeT )->( FieldPos( "CDTOUNO" ) )
#define _NDTOUNO                  ( dbfDepAgeT )->( FieldPos( "NDTOUNO" ) )
#define _CDTODOS                  ( dbfDepAgeT )->( FieldPos( "CDTODOS" ) )
#define _NDTODOS                  ( dbfDepAgeT )->( FieldPos( "NDTODOS" ) )
#define _NDTOPTF                  ( dbfDepAgeT )->( FieldPos( "NDTOPTF" ) )
#define _LRECARGO                 ( dbfDepAgeT )->( FieldPos( "LRECARGO") )
#define _CDIVDEP                  ( dbfDepAgeT )->( FieldPos( "CDIVDEP" ) )
#define _NVDVDEP                  ( dbfDepAgeT )->( FieldPos( "NVDVDEP" ) )
#define _CCODUSR                  ( dbfDepAgeT )->( FieldPos( "CCODUSR" ) )
#define _CCODDLG                  ( dbfDepAgeT )->( FieldPos( "CCODDLG" ) )

/*
Definici¢n de la base de datos de lineas de detalle
*/

#define _CREF                    ( dbfDepAgeL )->( FieldPos( "CREF"     ) )
#define _CDETALLE                ( dbfDepAgeL )->( FieldPos( "CDETALLE" ) )
#define _NPREUNIT                ( dbfDepAgeL )->( FieldPos( "NPREUNIT" ) )
#define _NDTO                    ( dbfDepAgeL )->( FieldPos( "NDTO"     ) )
#define _NDTOPRM                 ( dbfDepAgeL )->( FieldPos( "NDTOPRM"  ) )
#define _NIVA                    ( dbfDepAgeL )->( FieldPos( "NIVA"     ) )
#define _NCANENT                 ( dbfDepAgeL )->( FieldPos( "NCANENT"  ) )
#define _NPESOKG                 ( dbfDepAgeL )->( FieldPos( "NPESOKG"  ) )
#define _CUNIDAD                 ( dbfDepAgeL )->( FieldPos( "CUNIDAD"  ) )
#define _NUNICAJA                ( dbfDepAgeL )->( FieldPos( "NUNICAJA" ) )
#define _DFECHA                  ( dbfDepAgeL )->( FieldPos( "DFECHA"   ) )
#define _CTIPMOV                 ( dbfDepAgeL )->( FieldPos( "CTIPMOV"  ) )
#define _LLOTE                   ( dbfDepAgeL )->( FieldPos( "LLOTE"    ) )
#define _NLOTE                   ( dbfDepAgeL )->( FieldPos( "NLOTE"    ) )
#define _CLOTE                   ( dbfDepAgeL )->( FieldPos( "cLote"    ) )
#define _LMSGVTA                 ( dbfDepAgeL )->( FieldPos( "LMSGVTA"  ) )
#define _LNOTVTA                 ( dbfDepAgeL )->( FieldPos( "LNOTVTA"  ) )
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

memvar cDbfCol
memvar nTotArt
memvar nTotCaj
memvar cDbf
memvar cDetalle
memvar cIva
memvar cFPago
memvar nTotNet
memvar aTotIva
memvar aIvaUno
memvar aIvaDos
memvar aIvaTre
memvar nTotBrt
memvar nTotDto
memvar nTotDpp
memvar nTotCnt
memvar nTotRap
memvar nTotPub
memvar nTotPgo
memvar nTotPtf
memvar nTotIva
memvar nTotReq
memvar nTotDep
memvar nTotEur
memvar nPagina
memvar lEnd
memvar cDbfVta
memvar cPouDivDep
memvar cPorDivDep
memvar nDouDivDep
memvar nDorDivDep
memvar cDbfAlm

static nView

static oWndBrw
static oInf
static dbfDepAgeT
static dbfDepAgeL
static dbfDiv
static oBandera
static dbfTmp
static cNewFile
static dbfAlmT
static dbfIva
static dbfFPago
static dbfTarPreL
static dbfArticulo
static dbfKit
static dbfPromoT
static dbfUsr
static dbfDelega
static dbfDoc
static dbfCount
static dbfEmp
static oStock
static oGetTotal
static oGetTotEur
static dbfTVta
static oBrwIva
static cPicUnd
static cPouDiv
static cPorDiv
static nDouDiv
static nDorDiv
static cPpvDiv
static nDpvDiv
static oGetNet
static oGetIva
static oGetReq
static nGetNet 	:= 0
static nGetIva 	:= 0
static nTotalImp	:= 0
static nTotalArt	:= 0
static nGetReq  	:= 0
static nNumArt    := 0
static nNumCaj    := 0
static bEdit      := { |aTmp, aGet, dbfDepAgeT, oBrw, bWhen, bValid, nMode | EdtRec( aTmp, aGet, dbfDepAgeT, oBrw, bWhen, bValid, nMode ) }
static bEdit2  	:= { |aTmp, aGet, dbfDepAgeL, oBrw, bWhen, bValid, nMode, aTmpDep | EdtDet( aTmp, aGet, dbfDepAgeL, oBrw, bWhen, bValid, nMode, aTmpDep ) }

#ifndef __PDA__

//---------------------------------------------------------------------------//
//Funciones del programa
//---------------------------------------------------------------------------//

function aItmDepAge()

   local aItmDepAge  := {}

   aAdd( aItmDepAge, { "CSERDEP"   ,"C",  1, 0, "Serie del deposito a almacén",                             "",                   "", "( cDbf )"} )
   aAdd( aItmDepAge, { "NNUMDEP"   ,"N",  9, 0, "Número del deposito a almacén",                            "",                   "", "( cDbf )"} )
   aAdd( aItmDepAge, { "CSUFDEP"   ,"C",  2, 0, "Sufijo del deposito a almacén",                            "",                   "", "( cDbf )"} )
   aAdd( aItmDepAge, { "DFECDEP"   ,"D",  8, 0, "Fecha del pedido",                                         "",                   "", "( cDbf )"} )
   aAdd( aItmDepAge, { "CCODALM"   ,"C", 16, 0, "Código de almacén de entrada",                             "",                   "", "( cDbf )"} )
   aAdd( aItmDepAge, { "CNOMALM"   ,"C", 35, 0, "Nombre del almacén de entrada",                            "",                   "", "( cDbf )"} )
   aAdd( aItmDepAge, { "CDIRALM"   ,"C", 35, 0, "Domicilio del almacén de entrada",                         "",                   "", "( cDbf )"} )
   aAdd( aItmDepAge, { "CPOBALM"   ,"C", 25, 0, "Población del almacén de entrada",                         "",                   "", "( cDbf )"} )
   aAdd( aItmDepAge, { "CPRVALM"   ,"C", 20, 0, "Provincia del almacén de entrada",                         "",                   "", "( cDbf )"} )
   aAdd( aItmDepAge, { "CPOSALM"   ,"C",  5, 0, "Código postal del almacén de entrada",                     "",                   "", "( cDbf )"} )
   aAdd( aItmDepAge, { "CCODALI"   ,"C", 16, 0, "Código de almacén de salida",                              "",                   "", "( cDbf )"} )
   aAdd( aItmDepAge, { "LLIQDEP"   ,"L",  1, 0, "Lógico para liquidación",                                  "",                   "", "( cDbf )"} )
   aAdd( aItmDepAge, { "CCODPGO"   ,"C",  2, 0, "Código del tipo de pago",                                  "",                   "", "( cDbf )"} )
   aAdd( aItmDepAge, { "NBULTOS"   ,"N",  3, 0, "Número de bultos",                                         "",                   "", "( cDbf )"} )
   aAdd( aItmDepAge, { "NPORTES"   ,"N",  6, 0, "Importe de los portes",                                    "",                   "", "( cDbf )"} )
   aAdd( aItmDepAge, { "CCODTAR"   ,"C",  5, 0, "Código de tarifa",                                         "",                   "", "( cDbf )"} )
   aAdd( aItmDepAge, { "CDTOESP"   ,"C", 50, 0, "Descripción de porcentaje de descuento especial",          "",                   "", "( cDbf )"} )
   aAdd( aItmDepAge, { "NDTOESP"   ,"N",  5, 2, "Porcentaje de descuento especial",                         "",                   "", "( cDbf )"} )
   aAdd( aItmDepAge, { "CDPP"      ,"C", 50, 0, "Descripción de porcentaje de descuento por pronto pago",   "",                   "", "( cDbf )"} )
   aAdd( aItmDepAge, { "NDPP"      ,"N",  5, 2, "Porcentaje de descuento por pronto pago",                  "",                   "", "( cDbf )"} )
   aAdd( aItmDepAge, { "cDtoUno"   ,"C", 25, 2, "Descripción de primer dto. definido",                      "",                   "", "( cDbf )"} )
   aAdd( aItmDepAge, { "nDtoUno"   ,"N",  5, 2, "Porcentaje de primer dto. definido",                       "",                   "", "( cDbf )"} )
   aAdd( aItmDepAge, { "cDtoDos"   ,"C", 25, 2, "Descripción segundo dto. definido",                        "",                   "", "( cDbf )"} )
   aAdd( aItmDepAge, { "nDtoDos"   ,"N",  5, 2, "Porcentaje de segundo dto. definido",                      "",                   "", "( cDbf )"} )
   aAdd( aItmDepAge, { "LRECARGO"  ,"L",  1, 0, "Lógico de recargo de equivalencia",                        "",                   "", "( cDbf )"} )
   aAdd( aItmDepAge, { "CDIVDEP"   ,"C",  3, 0, "Código de divisa",                                         "",                   "", "( cDbf )"} )
   aAdd( aItmDepAge, { "NVDVDEP"   ,"N", 10, 4, "Valor del cambio de la divisa",                            "",                   "", "( cDbf )"} )
   aAdd( aItmDepAge, { "CCODUSR"   ,"C",  3, 0, "Código de usuario",                                        "",                   "", "( cDbf )"} )
   aAdd( aItmDepAge, { "CCODDLG"   ,"C",  2, 0, "Código delegación",                                        "",                   "", "( cDbf )"} )

RETURN ( aItmDepAge )

//---------------------------------------------------------------------------//

function aColDepAge()

   local aColDepAge  := {}

   aAdd( aColDepAge, { "CSERDEP"   ,"C",  1, 0, "Serie del deposito a almacén",     "" ,           "",                            "( cDbfCol )"} )
   aAdd( aColDepAge, { "NNUMDEP"   ,"N",  9, 0, "Número del deposito a almacén",    "" ,           "",                            "( cDbfCol )"} )
   aAdd( aColDepAge, { "CSUFDEP"   ,"C",  2, 0, "Sufijo del deposito a almacén",    "" ,           "",                            "( cDbfCol )"} )
   aAdd( aColDepAge, { "CREF",      "C", 18, 0, "Referencia de artículo",           "" ,           "",                            "( cDbfCol )"} )
   aAdd( aColDepAge, { "CDETALLE",  "C",100, 0, "Detalle de artículo",              "" ,           "",                            "( cDbfCol )"} )
   aAdd( aColDepAge, { "NPREUNIT",  "N", 16, 6, "Precio artículo",                  "" ,           "",                            "( cDbfCol )"} )
   aAdd( aColDepAge, { "NDTO",      "N",  6, 2, "Descuento de artículo",            "" ,           "",                            "( cDbfCol )"} )
   aAdd( aColDepAge, { "NDTOPRM",   "N",  6, 2, "Descuento de promoción",           "" ,           "",                            "( cDbfCol )"} )
   aAdd( aColDepAge, { "NIVA",      "N",  4, 1, cImp() + " del artículo",           "" ,           "",                            "( cDbfCol )"} )
   aAdd( aColDepAge, { "NCANENT",   "N", 16, 6, "Cantidad entrada",                 "" ,           "",                            "( cDbfCol )"} )
   aAdd( aColDepAge, { "NPESOKG",   "N", 16, 6, "Peso en kg. del producto",         "" ,           "",                            "( cDbfCol )"} )
   aAdd( aColDepAge, { "CUNIDAD",   "C",  2, 0, "Unidades",                         "" ,           "",                            "( cDbfCol )"} )
   aAdd( aColDepAge, { "NUNICAJA",  "N", 16, 6, "Unidades por caja",                "" ,           "",                            "( cDbfCol )"} )
   aAdd( aColDepAge, { "DFECHA",    "D",  8, 0, "Fecha de línea",                   "" ,           "",                            "( cDbfCol )"} )
   aAdd( aColDepAge, { "CTIPMOV",   "C",  2, 0, "Tipo de movimiento",               "" ,           "",                            "( cDbfCol )"} )
   aAdd( aColDepAge, { "LLOTE",     "L",  1, 0, "Lógico para lote",                 "" ,           "",                            "( cDbfCol )"} )
   aAdd( aColDepAge, { "NLOTE",     "N",  9, 0, "",                                 "" ,           "",                            "( cDbfCol )"} )
   aAdd( aColDepAge, { "cLote",     "C", 14, 0, "Número de lote",                   "" ,           "",                            "( cDbfCol )"} )
   aAdd( aColDepAge, { "LMSGVTA",   "L",  1, 0, "Avisar depósito sin stocks",       "" ,           "",                            "( cDbfCol )"} )
   aAdd( aColDepAge, { "LNOTVTA",   "L",  1, 0, "No permitir depósito sin stocks",  "" ,           "",                            "( cDbfCol )"} )
   aAdd( aColDepAge, { "NFACCNV",   "N", 16, 6, "",                                 "",            "",                            "( cDbfCol )"} )

return ( aColDepAge )


//---------------------------------------------------------------------------//

function aCalDepAge()

   local aCalDepAge  := {}

   aAdd( aCalDepAge, { "nTotNet",   "N", 16,  6, "Total neto",                  "cPorDivDep",  "!Empty( nTotNet ) .and. lEnd" } )
   aAdd( aCalDepAge, { "nTotIva",   "N", 16,  6, "Total " + cImp(),                "cPorDivDep",  "!Empty( nTotIva ) .and. lEnd" } )
   aAdd( aCalDepAge, { "nTotReq",   "N", 16,  6, "Total R.E.",                  "cPorDivDep",  "!Empty( nTotReq ) .and. lEnd" } )
   aAdd( aCalDepAge, { "nTotDep",   "N", 16,  6, "Total Depósito",              "cPorDivDep",  "!Empty( nTotDep ) .and. lEnd" } )
   aAdd( aCalDepAge, { "nPagina",   "N",  2,  0, "Número de página",            "'99'",         "" }                            )
   aAdd( aCalDepAge, { "lEnd",      "L",  1,  0, "Fin del documento",           "",             "" }                            )

return ( aCalDepAge )

//----------------------------------------------------------------------------//

function aCocDepAge()

   local aCocDepAge  := {}

   aAdd( aCocDepAge, {"( Descrip( cDbfCol ) )",                                 "C", 50, 0, "Detalle del artículo",              "",               "Descripción",    "" } )
   aAdd( aCocDepAge, {"( nTotLDepAge( cDbfCol ) )",                             "N", 16, 6, "Total línea de depósito",           "cPorDivDep",     "Total",       "" } )

return ( aCocDepAge )

//----------------------------------------------------------------------------//

STATIC FUNCTION OpenFiles( cPath )

   local lOpen    := .t.
   local oError
   local oBlock

   DEFAULT cPath  := cPatEmp()

   oBlock         := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   nView               := D():CreateView()

   D():ArticuloStockAlmacenes( nView )     


   USE ( cPath + "DEPAGET.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "DEPAGET", @dbfDepAgeT ) )
   SET ADSINDEX TO ( cPath + "DEPAGET.CDX" ) ADDITIVE

   USE ( cPath + "DEPAGEL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "DEPAGEL", @dbfDepAgeL ) )
   SET ADSINDEX TO ( cPath + "DEPAGEL.CDX" ) ADDITIVE

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

   USE ( cPatDat() + "DIVISAS.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "DIVISAS", @dbfDiv ) )
   SET ADSINDEX TO ( cPatDat() + "DIVISAS.CDX" ) ADDITIVE

   USE ( cPatDat() + "TVTA.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "TVTA", @dbfTVta ) )
   SET ADSINDEX TO ( cPatDat() + "TVTA.CDX" ) ADDITIVE

   USE ( cPatArt() + "ARTKIT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ARTTIK", @dbfKit ) )
   SET ADSINDEX TO ( cPatArt() + "ARTKIT.CDX" ) ADDITIVE

   USE ( cPatDat() + "USERS.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "USERS", @dbfUsr ) )
   SET ADSINDEX TO ( cPatDat() + "USERS.CDX" ) ADDITIVE

   USE ( cPatDat() + "DELEGA.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "DELEGA", @dbfDelega ) )
   SET ADSINDEX TO ( cPatDat() + "DELEGA.CDX" ) ADDITIVE

   USE ( cPath + "NCOUNT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "NCOUNT", @dbfCount ) )
   SET ADSINDEX TO ( cPath + "NCOUNT.CDX" ) ADDITIVE

   USE ( cPath + "RDOCUMEN.DBF" ) NEW SHARED VIA ( cDriver() )ALIAS ( cCheckArea( "RDOCUMEN", @dbfDoc ) )
   SET ADSINDEX TO ( cPath + "RDOCUMEN.CDX" ) ADDITIVE
   SET TAG TO "CTIPO"

   USE ( cPatDat() + "EMPRESA.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "EMPRESA", @dbfEmp ) )
   SET ADSINDEX TO ( cPatDat() + "EMPRESA.CDX" ) ADDITIVE

   oBandera             := TBandera():New()

   oStock               := TStock():Create( cPatGrp() )
   if !oStock:lOpenFiles()
      lOpen             := .f.
   end if

   RECOVER USING oError

      lOpen             := .f.

      msgStop( "Imposible abrir las bases de datos de depositos." + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

   if !lOpen
      CloseFiles()
   end if

RETURN ( lOpen )

//----------------------------------------------------------------------------//

STATIC FUNCTION CloseFiles()

   ( dbfDepAgeT   )->( dbCloseArea() )
   ( dbfDepAgeL   )->( dbCloseArea() )
   ( dbfIva       )->( dbCloseArea() )
   ( dbfFPago     )->( dbCloseArea() )
   ( dbfAlmT      )->( dbCloseArea() )
   ( dbfTarPreL   )->( dbCloseArea() )
   ( dbfPromoT    )->( dbCloseArea() )
   ( dbfArticulo  )->( dbCloseArea() )
   ( dbfDiv       )->( dbCloseArea() )
   ( dbfTVta      )->( dbCloseArea() )
   ( dbfKit       )->( dbCloseArea() )
   ( dbfUsr       )->( dbCloseArea() )
   ( dbfDelega    )->( dbCloseArea() )
   ( dbfDoc       )->( dbCloseArea() )
   ( dbfCount     )->( dbCloseArea() )
   ( dbfEmp       )->( dbCloseArea() )

   if oStock != nil
      oStock:end()
   end if

   D():DeleteView( nView )

   dbfDepAgeT     := nil
   dbfDepAgeL     := nil
   dbfIva         := nil
   dbfFPago       := nil
   dbfAlmT        := nil
   dbfTarPreL     := nil
   dbfPromoT      := nil
   dbfArticulo    := nil
   dbfDiv         := nil
   dbfKit         := nil
   oBandera       := nil
   oStock         := nil
   dbfTVta        := nil
   dbfUsr         := nil
   dbfDelega      := nil
   dbfDoc         := nil
   dbfCount       := nil
   dbfEmp         := nil

   if oWndBrw != nil
      oWndBrw     := nil
   end if

RETURN .T.

//----------------------------------------------------------------------------//

FUNCTION DepAge( oMenuItem, oWnd )

   local oBtnEur
   local nLevel
	local lEuro		:= .f.
   local oImp
   local oPrv
   local aDbfBmp  := {  LoadBitmap( GetResources(), "bGreen" ),;
                        LoadBitmap( GetResources(), "bRed" ) }

   DEFAULT  oMenuItem   := "01028"
   DEFAULT  oWnd        := oWnd()

	IF oWndBrw == NIL

      /*
      Obtenemos el nivel de acceso
      */

      nLevel            := nLevelUsr( oMenuItem )
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

      AddMnuNext( "Introducción de depósitos", ProcName() )

      DEFINE SHELL oWndBrw FROM 0, 0 TO 22, 80 ;
         TITLE    "Introducción de depósitos" ;
         PROMPTS  "Número",;
						"Fecha",;
                  "Almacén entrada";
         MRU      "Package_add_16";
         BITMAP   Rgb( 128, 57, 123 ) ;
			ALIAS 	( dbfDepAgeT );
			APPEND	( WinAppRec( oWndBrw:oBrw, bEdit, dbfDepAgeT ) );
			DUPLICAT	( WinDupRec( oWndBrw:oBrw, bEdit, dbfDepAgeT ) );
			EDIT 		( WinEdtRec( oWndBrw:oBrw, bEdit, dbfDepAgeT ) );
         DELETE   ( dbDelRec(  oWndBrw:oBrw, dbfDepAgeT, {|| DelDetalle( (dbfDepAgeT)->CSERDEP + Str( (dbfDepAgeT)->NNUMDEP ) + (dbfDepAgeT)->CSUFDEP ) } ) ) ;
         LEVEL    nLevel ;
			OF 		oWnd

         oWndBrw:lAutoSeek := .f.

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Liquidado"
         :nHeadBmpNo       := 3
         :bStrData         := {|| "" }
         :bEditValue       := {|| ( dbfDepAgeT )->lLiqDep }
         :nWidth           := 20
         :SetCheck( { "Sel16", "Nil16" } )
         :AddResource( "ChgPre16" )
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Número"
         :cSortOrder       := "nNumDep"
         :bEditValue       := {|| ( dbfDepAgeT )->CSERDEP + "/" + Alltrim( Str( ( dbfDepAgeT )->NNUMDEP ) ) + "/" + ( dbfDepAgeT )->CSUFDEP }
         :nWidth           := 80
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Delegación"
         :bEditValue       := {|| ( dbfDepAgeT )->cCodDlg }
         :nWidth           := 40
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Fecha"
         :bEditValue       := {|| Dtoc( ( dbfDepAgeT )->dFecDep ) }
         :nWidth           := 80
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Almacén entrada"
         :cSortOrder       := "cCodAlm"
         :bEditValue       := {|| ( dbfDepAgeT )->cCodAlm + Space( 1 ) + RetAlmacen( ( dbfDepAgeT )->cCodAlm, dbfAlmT ) }
         :nWidth           := 180
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Almacén salida"
         :bEditValue       := {|| ( dbfDepAgeT )->cCodAli + Space( 1 ) + RetAlmacen( ( dbfDepAgeT )->cCodAli, dbfAlmT ) }
         :nWidth           := 180
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Total"
         :bEditValue       := {|| nTotDepAge( ( dbfDepAgeT )->CSERDEP + Str( ( dbfDepAgeT )->NNUMDEP ) + ( dbfDepAgeT )->CSUFDEP, dbfDepAgeT, dbfDepAgeL, dbfIva, dbfDiv, nil, if( lEuro, cDivChg(), cDivEmp() ) ) }
         :nWidth           := 80
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Div"
         :bEditValue       := {|| cSimDiv( ( dbfDepAgeT )->cDivDep, dbfDiv ) }
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
			TOOLTIP 	"(M)odificar";
         HOTKEY   "M";
         LEVEL    ACC_EDIT

		DEFINE BTNSHELL RESOURCE "ZOOM" OF oWndBrw ;
			NOBORDER ;
			ACTION  	( WinZooRec( oWndBrw:oBrw, bEdit, dbfDepAgeT ) );
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
         ACTION   ( nGenDeposito( .t. ) ) ;
			TOOLTIP 	"(I)mprimir";
         HOTKEY   "I";
         LEVEL    ACC_IMPR

      lGenDepAge( oWndBrw:oBrw, oImp, .t. ) ;

      DEFINE BTNSHELL oPrv RESOURCE "PREV1" OF oWndBrw ;
			NOBORDER ;
         ACTION   ( GenDeposito( .f. ) ) ;
			TOOLTIP 	"(P)revisualizar";
         HOTKEY   "P";
         LEVEL    ACC_IMPR

      lGenDepAge( oWndBrw:oBrw, oPrv, .f. ) ;

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
         HOTKEY   "O"

      DEFINE BTNSHELL RESOURCE "END"  GROUP OF oWndBrw;
			NOBORDER ;
			ACTION 	( oWndBrw:End() ) ;
         TOOLTIP  "(S)alir" ;
			HOTKEY 	"S"

		ACTIVATE WINDOW oWndBrw VALID ( CloseFiles() )

	ELSE

		oWndBrw:setFocus()

	END IF

RETURN NIL

//----------------------------------------------------------------------------//

STATIC FUNCTION SetDlgMode( aGet, aTmp, oSayLote, nMode, oSayCaja )

   if !lUseCaj()
      oSayCaja:hide()
      aGet[_NCANENT]:hide()
   end if

   aGet[ _CTIPMOV ]:lValid()

   DO CASE
	CASE nMode == APPD_MODE
      aGet[_CLOTE   ]:hide()
      oSayLote:hide()
   CASE ( nMode == EDIT_MODE .OR. nMode == ZOOM_MODE )
      IF aTmp[_LLOTE]
         aGet[_CLOTE   ]:Show()
         oSayLote:Show()
      ELSE
         aGet[_CLOTE   ]:Hide()
         oSayLote:Hide()
      END IF
   END CASE

RETURN NIL

//--------------------------------------------------------------------------//

/*
Funcion Auxiliar para A¤adir lineas de detalle a un albaran
*/

STATIC FUNCTION AppDeta(oBrw2, bEdit2, aTmp)

	WinAppRec( oBrw2, bEdit2, dbfTmp, , , aTmp )

RETURN ( nTotDepAge( 0, nil, dbfTmp, dbfIva, dbfDiv, aTmp ) )

//--------------------------------------------------------------------------//
/*
Funcion Auxiliar para la Edici¢n de Lineas de Detalle en un albaran
*/

STATIC FUNCTION EdtDeta(oBrw2, bEdit2, aTmp )

	WinEdtRec( oBrw2, bEdit2, dbfTmp, , , aTmp )

RETURN ( nTotDepAge( 0, nil, dbfTmp, dbfIva, dbfDiv, aTmp ) )

//--------------------------------------------------------------------------//

/*
Funcion Auxiliar para borrar las Lineas de Detalle en un albaran
*/

STATIC FUNCTION DelDeta( oBrw2, aTmp )

	dbDelRec( oBrw2, dbfTmp )

RETURN ( nTotDepAge( nil, nil, dbfTmp, dbfIva, dbfDiv, aTmp ) )

//--------------------------------------------------------------------------//

/*
Funcion Auxiliar para la Visualizaci¢n de Lineas de Detalle en una Abono
*/

STATIC FUNCTION EdtZoom( oBrw2, bEdit2, aTmp )

	WinZooRec( oBrw2, bEdit2, dbfTmp )

RETURN NIL

//--------------------------------------------------------------------------//

STATIC FUNCTION SaveDeta( aTmp, aGet, oBrw, oDlg2, nMode, oTotal, aTmpDep, oBtn )

   local nTotUnd     := 0
   local nStkAct     := 0

   oBtn:SetFocus()

   /*
   Control de stok por lotes
   */

   if !Empty( aTmp[ _CREF ] ) .and. ( aTmp[ _LNOTVTA ] .or. aTmp[ _LMSGVTA ] )

      nTotUnd        := NotCaja( aTmp[ _NCANENT ]  ) * aTmp[ _NUNICAJA ]
      nStkAct        := oStock:nStockActual( aTmp[ _CREF ], aTmpDep[ _CCODALI ], , , aTmp[ _CLOTE ] )

      if nTotUnd != 0

         do case
            case nStkAct - nTotUnd < 0

               if oUser():lNotAllowSales( aTmp[ _LNOTVTA ] )
                  MsgStop( "No hay stock suficiente." )
                  return nil
               end if

               if aTmp[ _LMSGVTA ]
                  if !ApoloMsgNoYes( "No hay stock suficiente.", "¿Desea continuar?" )
                     return nil
                  end if
               end if

            case nStkAct - nTotUnd < RetFld( aTmp[ _CREF ], dbfArticulo, "nMinimo"  )

               if aTmp[ _LMSGVTA ]
                  if !ApoloMsgNoYes( "El stock está por debajo del minimo.", "¿Desea continuar?" )
                     return nil
                  end if
               end if

         end case

      end if

   end if

   WinGather( aTmp, aGet, dbfTmp, oBrw, nMode )

   IF nMode == APPD_MODE .AND. lEntCon()
		aGet[_NCANENT]:cText( 1 )
      aGet[_CREF   ]:setFocus()
      aGet[_CTIPMOV ]:cText( cDefVta() )
		oTotal:cText( 0 )
	ELSE
      oDlg2:end( IDOK )
	END IF

RETURN NIL

//--------------------------------------------------------------------------//

STATIC FUNCTION PrnSerie()

	local oDlg
	local oDocIni
	local oDocFin
	local oBtnOk
	local oBtnCancel
	local nRecno	:= (dbfDepAgeT)->(RecNo())
	local nOrdAnt	:= (dbfDepAgeT)->(OrdSetFocus(1))
	local nDocIni	:= (dbfDepAgeT)->NNUMDEP
	local nDocFin	:= (dbfDepAgeT)->NNUMDEP

   DEFINE DIALOG oDlg RESOURCE "PRNSERIES" TITLE "Imprimir series de depósitos"

	REDEFINE GET oDocIni VAR nDocIni;
		ID 		110 ;
		PICTURE 	"999999999" ;
      OF       oDlg

	REDEFINE GET oDocFin VAR nDocFin;
		ID 		120 ;
		PICTURE 	"999999999" ;
      OF       oDlg

	REDEFINE BUTTON oBtnOk ;
		ID 		505 ;
		OF 		oDlg ;
      ACTION   ( StartPrint( nDocIni, nDocFin, oBtnOk, oBtnCancel ), oDlg:end( IDOK ) )

	REDEFINE BUTTON oBtnCancel ;
      ID       IDCANCEL ;
		OF 		oDlg ;
		ACTION 	( oDlg:end() )

	ACTIVATE DIALOG oDlg CENTER

	( dbfDepAgeT )->( dbGoTo( nRecNo ) )
	( dbfDepAgeT )->( ordSetFocus( nOrdAnt ) )

	oWndBrw:refresh()

RETURN NIL

//--------------------------------------------------------------------------//

STATIC FUNCTION StartPrint( nDocIni, nDocFin, oBtnOk, oBtnCancel )

	oBtnOk:disable()
	oBtnCancel:disable()

   ( dbfDepAgeT )->( dbSeek( nDocIni, .t. ) )

   WHILE (dbfDepAgeT)->CSERDEP + Str( (dbfDepAgeT)->NNUMDEP ) + (dbfDepAgeT)->CSUFDEP >= nDocIni .AND.;
         (dbfDepAgeT)->CSERDEP + Str( (dbfDepAgeT)->NNUMDEP ) + (dbfDepAgeT)->CSUFDEP <= nDocFin

      GenDeposito( .t., "Imprimiendo documento : " + (dbfDepAgeT)->CSERDEP + Str( (dbfDepAgeT)->NNUMDEP ) + (dbfDepAgeT)->CSUFDEP )
      ( dbfDepAgeT )->( dbSkip() )

	END WHILE

	oBtnOk:enable()
	oBtnCancel:enable()

RETURN NIL

//--------------------------------------------------------------------------//

STATIC FUNCTION GenDeposito( lPrinter, cCaption, cCodDoc, nCopies )

   local cDeposito      := (dbfDepAgeT)->CSERDEP + Str( (dbfDepAgeT)->NNUMDEP ) + (dbfDepAgeT)->CSUFDEP
   local cCodAlm        := (dbfDepAgeT)->CCODALM

   if ( dbfDepAgeT )->( Lastrec() ) == 0
      return nil
   end if

   DEFAULT lPrinter     := .f.
   DEFAULT cCaption     := "Imprimiendo depósitos de almacén"
   DEFAULT cCodDoc      := cFormatoDocumento( ( dbfDepAgeT )->cSerDep, "nDepAge", dbfCount )
   DEFAULT nCopies      := nCopiasDocumento( ( dbfDepAgeT )->cSerDep, "nDepAge", dbfCount )

   if Empty( cCodDoc )
      cCodDoc           := if( ( dbfDepAgeT )->cSerDep == "A", "DA1", "DA2" )
   end if

   if !lExisteDocumento( cCodDoc, dbfDoc )
      return nil
   end if

   if lVisualDocumento( cCodDoc, dbfDoc )

      PrintReportDepAge( if( lPrinter, IS_PRINTER, IS_SCREEN ), nCopies, nil, dbfDoc )

   else

      nTotDepAge( cDeposito, dbfDepAgeT, dbfDepAgeL, dbfIva, dbfDiv )

      private cDbf         := dbfDepAgeT
      private cDetalle     := dbfDepAgeL
      private cDbfCol      := dbfDepAgeL
      private cIva         := dbfIva
      private cFPago       := dbfFPago
      private cDbfVta      := dbfTVta
      private cPouDivDep   := cPouDiv
      private cPorDivDep   := cPorDiv
      private nDouDivDep   := nDouDiv
      private nDorDivDep   := nDorDiv
      private nTotArt      := nNumArt
      private nTotCaj      := nNumCaj
      private cDbfAlm      := dbfAlmT

      /*
      Buscamos el primer registro
      */

      (dbfDepAgeL)->( dbSeek( cDeposito ) )
      (dbfAlmT   )->( dbSeek( cCodAlm ) )

      IF lPrinter
         REPORT oInf CAPTION cCaption TO PRINTER
      ELSE
         REPORT oInf CAPTION cCaption PREVIEW
      END IF

      if !Empty( oInf ) .and. oInf:lCreated
         oInf:lFinish            := .f.
         oInf:lNoCancel          := .t.
         oInf:bSkip              := {|| ( dbfDepAgeL )->( dbSkip() ) }

         oInf:oDevice:lPrvModal  := .t.

         SetMargin( cCodDoc, oInf )
         PrintColum( cCodDoc, oInf )

      end if

      END REPORT

      ACTIVATE REPORT   oInf ;
         WHILE          ( (dbfDepAgeL)->CSERDEP + Str( (dbfDepAgeL)->NNUMDEP ) + (dbfDepAgeL)->CSUFDEP == cDeposito .AND. !(dbfDepAgeL)->( Eof() ) ) ;
         ON STARTPAGE   EPage( oInf, cCodDoc )

   end if

RETURN NIL

//---------------------------------------------------------------------------//

static function nGenDeposito( lImp, cTitle, cCodDoc, nCopy )

   local nImpYet  := 1

   DEFAULT lImp   := .t.
   DEFAULT nCopy  := 1

   nCopy          := Max( nCopy, 1 )

   while nImpYet <= nCopy
      GenDeposito( lImp, cTitle, cCodDoc )
      nImpYet++
   end while

return nil

//---------------------------------------------------------------------------//

/*
Calcula el Total del albaran
*/

FUNCTION nTotDepAge( nNumDep, dbfMaster, dbfLine, cDbfIva, cDbfDiv, aTmp, cDivRet )

   local nRecno
	local bCondition
	local cCodDiv
   local lRecargo    := 0
   local nDtoEsp     := 0
   local nDtoPP      := 0
   local nDtoUno     := 0
   local nDtoDos     := 0
	local aTotalDto	:= { 0, 0, 0 }
	local aTotalDPP	:= { 0, 0, 0 }
   local aTotalUno   := { 0, 0, 0 }
   local aTotalDos   := { 0, 0, 0 }

	DEFAULT dbfMaster	:= dbfDepAgeT
	DEFAULT dbfLine	:= dbfDepAgeL
   DEFAULT cDbfIva   := dbfIva
   DEFAULT cDbfDiv   := dbfDiv
   DEFAULT nNumDep   := ( dbfDepAgeT )->cSerDep + Str( ( dbfDepAgeT )->nNumDep ) + ( dbfDepAgeT )->cSufDep

   public nTotNet    := 0
   public nTotBrt    := 0
   public nTotDto    := 0
   public nTotDpp    := 0
   public nTotIva    := 0
   public nTotReq    := 0
   public nTotDep    := 0
   public nTotEur    := 0
   public aTotIva    := { { 0, 0, nil, 0 }, { 0, 0, nil, 0 }, { 0, 0, nil, 0 } }
   public aIvaUno    := aTotIva[ 1 ]
   public aIvaDos    := aTotIva[ 2 ]
   public aIvaTre    := aTotIva[ 3 ]

   nNumArt           := 0
   nNumCaj           := 0
   nRecno            := ( dbfLine )->(RecNo())

   if aTmp != NIL
		lRecargo			:= aTmp[ _LRECARGO]
		nDtoEsp			:= aTmp[ _NDTOESP ]
		nDtoPP			:= aTmp[ _NDPP    ]
      nDtoUno        := aTmp[ _NDTOUNO ]
      nDtoDos        := aTmp[ _NDTODOS ]
		cCodDiv			:= aTmp[ _CDIVDEP ]
      bCondition     := {|| ( dbfLine )->(!eof() ) }
      ( dbfLine )->( dbGoTop() )
   else
      lRecargo       := ( dbfMaster )->lRecargo
      nDtoEsp        := ( dbfMaster )->nDtoEsp
      nDtoPP         := ( dbfMaster )->nDpp
      nDtoUno        := ( dbfMaster )->nDtoUno
      nDtoDos        := ( dbfMaster )->nDtoDos
      cCodDiv        := ( dbfMaster )->cDivDep
      bCondition     := {|| ( dbfDepAgeL )->CSERDEP + Str( ( dbfDepAgeL )->NNUMDEP ) + ( dbfDepAgeL )->CSUFDEP = nNumDep .AND. ( dbfLine )->( !eof() ) }
      ( dbfLine )->( dbSeek( nNumDep ) )
   end if

   cPicUnd           := MasUnd()                            // Picture de las unidades
   cPouDiv           := cPouDiv( cCodDiv, cDbfDiv )          // Picture de la divisa
   cPorDiv           := cPorDiv( cCodDiv, cDbfDiv )          // Picture de la divisa redondeada
   nDouDiv           := nDouDiv( cCodDiv, cDbfDiv )          // Decimales de la divisa
   nDorDiv           := nRouDiv( cCodDiv, cDbfDiv )          // Decimales de la divisa redondeada
   cPpvDiv           := cPpvDiv( cCodDiv, cDbfDiv )          // Picture del punto verde
   nDpvDiv           := nDpvDiv( cCodDiv, cDbfDiv )          // Decimales de redondeo del punto verde

	WHILE Eval( bCondition )

		nTotalArt 		:= nTotLDepAge( dbfLine )
		nNumArt			+= nTotLNumArt( dbfLine )
      nNumCaj        += ( dbfLine )->nCanEnt

		/*
      Estudio de impuestos
		*/

		DO CASE
      CASE _NPCTIVA1 == nil .OR. _NPCTIVA1 == ( dbfLine )->NIVA
         _NPCTIVA1   := ( dbfLine )->nIva
			_NPCTREQ1 	:= If ( lRecargo, nPReq( dbfIva, _NPCTIVA1 ), 0 )
			_NBRTIVA1 	+= nTotalArt

      CASE _NPCTIVA2 == nil .OR. _NPCTIVA2 == ( dbfLine )->NIVA
         _NPCTIVA2   := ( dbfLine )->nIva
			_NPCTREQ2 	:= If ( lRecargo, nPReq( dbfIva, _NPCTIVA2 ), 0 )
			_NBRTIVA2 	+= nTotalArt

      CASE _NPCTIVA3 == nil .OR. _NPCTIVA3 == ( dbfLine )->NIVA
         _NPCTIVA3   := ( dbfLine )->nIva
			_NPCTREQ3 	:= If ( lRecargo, nPReq( dbfIva, _NPCTIVA3 ), 0 )
			_NBRTIVA3 	+= nTotalArt

		END CASE

      ( dbfLine )->(DbSkip())

	END WHILE

	( dbfLine )->( DbGoto( nRecno ) )

	/*
   Ordenamos los impuestosS de menor a mayor
	*/

   aTotIva           := aSort( aTotIva,,, {|x,y| abs( x[1] ) > abs( y[1] ) } )
   nTotBrt           := _NBRTIVA1 + _NBRTIVA2 + _NBRTIVA3

   _NBASIVA1         := _NBRTIVA1
   _NBASIVA2         := _NBRTIVA2
   _NBASIVA3         := _NBRTIVA3

	/*
	Descuentos Especiales
	*/

   IF nDtoEsp  != 0
      aTotalDto[1]   := Round( _NBASIVA1 * nDtoEsp / 100, nDorDiv )
      aTotalDto[2]   := Round( _NBASIVA2 * nDtoEsp / 100, nDorDiv )
      aTotalDto[3]   := Round( _NBASIVA3 * nDtoEsp / 100, nDorDiv )

      nTotDto      := aTotalDto[1] + aTotalDto[2] + aTotalDto[3]

		_NBASIVA1		-= aTotalDto[1]
		_NBASIVA2		-= aTotalDto[2]
		_NBASIVA3		-= aTotalDto[3]
	END IF

	/*
	Descuentos por Pronto Pago estos son los buenos
	*/

	IF nDtoPP	!= 0
      aTotalDPP[1]   := Round( _NBASIVA1 * nDtoPP / 100, nDorDiv )
      aTotalDPP[2]   := Round( _NBASIVA2 * nDtoPP / 100, nDorDiv )
      aTotalDPP[3]   := Round( _NBASIVA3 * nDtoPP / 100, nDorDiv )

      nTotDPP        := aTotalDPP[1] + aTotalDPP[2] + aTotalDPP[3]

		_NBASIVA1		-= aTotalDPP[1]
		_NBASIVA2		-= aTotalDPP[2]
		_NBASIVA3		-= aTotalDPP[3]
	END IF

   IF nDtoUno  != 0
      aTotalUno[1]   := Round( _NBASIVA1 * nDtoUno / 100, nDorDiv )
      aTotalUno[2]   := Round( _NBASIVA2 * nDtoUno / 100, nDorDiv )
      aTotalUno[3]   := Round( _NBASIVA3 * nDtoUno / 100, nDorDiv )

      nTotDto        := aTotalUno[1] + aTotalUno[2] + aTotalUno[3]

      _NBASIVA1      -= aTotalUno[1]
      _NBASIVA2      -= aTotalUno[2]
      _NBASIVA3      -= aTotalUno[3]
	END IF

   IF nDtoDos  != 0
      aTotalDos[1]   := Round( _NBASIVA1 * nDtoDos / 100, nDorDiv )
      aTotalDos[2]   := Round( _NBASIVA2 * nDtoDos / 100, nDorDiv )
      aTotalDos[3]   := Round( _NBASIVA3 * nDtoDos / 100, nDorDiv )

      nTotDto      := aTotalDos[1] + aTotalDos[2] + aTotalDos[3]

      _NBASIVA1      -= aTotalDos[1]
      _NBASIVA2      -= aTotalDos[2]
      _NBASIVA3      -= aTotalDos[3]
	END IF

   nTotNet         := _NBASIVA1 + _NBASIVA2 + _NBASIVA3

	/*
   Calculos de impuestos
	*/

   nTotIva         := 0

   if _NPCTIVA1 != nil
      nTotIva      += Round( _NBASIVA1 * _NPCTIVA1 / 100, nDorDiv )
   end if

   if _NPCTIVA2 != nil
      nTotIva      += Round( _NBASIVA2 * _NPCTIVA2 / 100, nDorDiv )
   end if

   if _NPCTIVA3 != nil
      nTotIva      += Round( _NBASIVA3 * _NPCTIVA3 / 100, nDorDiv )
   end if

	/*
	Calculo de recargo
	*/

   nTotReq         := Round( _NBASIVA1 * _NPCTREQ1 / 100, nDorDiv )
   nTotReq         += Round( _NBASIVA2 * _NPCTREQ2 / 100, nDorDiv )
   nTotReq         += Round( _NBASIVA3 * _NPCTREQ3 / 100, nDorDiv )

	/*
	Total de impuestos
	*/

   nTotalImp         := nTotIva + nTotReq

	/*
	Total facturas
	*/

   nTotDep         := nTotNet + nTotalImp

   if cDivRet != nil .and. cDivRet != cCodDiv
      nTotDep   := nCnv2Div( nTotDep, cCodDiv, cDivRet )
      cPorDiv     := cPorDiv( cDivRet, cDbfDiv )
   end if

RETURN ( Trans( nTotDep, cPorDiv ) )

//--------------------------------------------------------------------------//

STATIC FUNCTION nRecTotal( dbfLine, aTmp )

   DEFAULT dbfLine   := dbfDepAgeL

   nTotDepAge( 0, nil, dbfLine, dbfIva, dbfDiv, aTmp )

   if oBrwIva != nil
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
      oGetTotal:SetText( nTotDep )
   end if

   if oGetTotEur != NIL
      oGetTotEur:SetText( nTotEur )
   end if

RETURN ( .t. )

//--------------------------------------------------------------------------//

/*
Borra todas las lineas de detalle de un Albaran
*/

STATIC FUNCTION delDetalle( nNumDep )

   CursorWait()

   while ( dbfDepAgeL )->( dbSeek( nNumDep ) )
      if dbLock( dbfDepAgeL )
         ( dbfDepAgeL )->( dbDelete() )
         ( dbfDepAgeL )->( dbUnLock() )
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

      aGet[_CCODALM]:cText( ( dbfAlmT )->CCODALM )
      aGet[_CNOMALM]:cText( ( dbfAlmT )->CNOMALM )
      aGet[_CDIRALM]:cText( ( dbfAlmT )->CDIRALM )
      aGet[_CPOBALM]:cText( ( dbfAlmT )->CPOBALM )
      aGet[_CPRVALM]:cText( ( dbfAlmT )->CPROALM )
      aGet[_CPOSALM]:cText( ( dbfAlmT )->CPOSALM )

		lValid	:= .T.

	ELSE

      msgStop( "Almacén no encontrado" )

	END IF

	IF ( cAreaAnt != "",	SELECT( cAreaAnt ), )

RETURN lValid

//----------------------------------------------------------------------------//

STATIC FUNCTION LoaArt( aGet, aTmp, aTmpDep, oSayLote )

   local lValid   := .f.
	local xValor   := aGet[_CREF]:varGet()
   local cCodFam

   if Empty( xValor )

		aGet[_NIVA]:varPut( 0 )
      aGet[_NIVA]:bWhen       := {|| .T. }
		aGet[_NIVA]:refresh()

		aGet[_CDETALLE]:varPut( Space( 50 ) )
		aGet[_CDETALLE]:bWhen	:= {|| .T. }
		aGet[_CDETALLE]:refresh()

      return .t.

   end if

   if ( dbfArticulo )->( dbSeek( xValor ) )

      aGet[_CREF    ]:cText( (dbfArticulo)->Codigo )
      aGet[_NUNICAJA]:cText( (dbfArticulo)->nUniCaja )
      aGet[_CUNIDAD ]:cText( (dbfArticulo)->cUnidad )

      cCodFam     := ( dbfArticulo )->Familia

      /*
      Lotes
      ---------------------------------------------------------------------
      */

      if ( dbfArticulo )->lLote
         oSayLote:Show()
         aGet[ _CLOTE ]:show()
      else
         oSayLote:hide()
         aGet[ _CLOTE ]:hide()
      end if

      aTmp[ _LLOTE ]       := ( dbfArticulo )->lLote

      aTmp[ _LMSGVTA ]     := ( dbfArticulo )->lMsgVta
      aTmp[ _LNOTVTA ]     := ( dbfArticulo )->lNotVta

      aGet[ _CLOTE ]:cText(  ( dbfArticulo )->cLote )

		/*
		Chequeamos situaciones especiales y comprobamos las fechas
		*/

      if !Empty( aTmpDep[_CCODTAR] )
         aGet[_NPREUNIT]:cText( RetPrcTar( ( dbfArticulo )->Codigo, aTmpDep[ _CCODTAR ], Space(5), Space(5), Space(5), Space(5), dbfTarPreL ) )
         aGet[_NDTO    ]:cText( RetPctTar( ( dbfArticulo )->Codigo, cCodFam, aTmpDep[ _CCODTAR ], Space(5), Space(5), Space(5), Space(5), dbfTarPreL ) )
         aGet[_NDTOPRM ]:cText( RetDtoPrm( ( dbfArticulo )->Codigo, cCodFam, aTmpDep[ _CCODTAR ], Space(5), Space(5), Space(5), Space(5), aTmpDep[ _DFECDEP ], dbfTarPreL ) )
      else
         aGet[_NPREUNIT]:cText( ( dbfArticulo )->pVenta1 )
      end if

      aGet[_CDETALLE]:cText( ( dbfArticulo )->Nombre )
      aGet[_CDETALLE]:bWhen   := {|| .f. }

      if aGet[_NIVA] != nil
         aGet[_NIVA]:cText( nIva( dbfIva, ( dbfArticulo )->TipoIva ) )
         aGet[_NIVA]:bWhen    := {|| .f. }
      end if

      lValid   := .t.

   else

      MsgStop( "Artículo no encontrado" )
      lValid   := .f.

   end if

Return lValid

//--------------------------------------------------------------------------//

STATIC FUNCTION EPage( oInf, cCodDoc )

   private nPagina      := oInf:nPage
	private lEnd			:= oInf:lFinish

	/*
	Ahora montamos los Items
	*/

   PrintItems( cCodDoc, oInf )

RETURN NIL

//--------------------------------------------------------------------------//

FUNCTION mkDepAge( cPath, lAppend, cPathOld, oMeter )

   DEFAULT cPath     := cPatEmp()
   DEFAULT lAppend   := .f.

	IF oMeter != NIL
		oMeter:cText	:= "Generando Bases"
		sysrefresh()
	END IF

   if !lExistTable( cPath + "DepAgeT.Dbf" )
      dbCreate( cPath + "DEPAGET.DBF", aSqlStruct( aItmDepAge() ), cDriver() )
   end if 

   if !lExistTable( cPath + "DepAgeL.Dbf" )
      dbCreate( cPath + "DEPAGEL.DBF", aSqlStruct( aColDepAge() ), cDriver() )
   end if

   rxDepAge( cPath, oMeter )

	IF lAppend .and. lIsDir( cPathOld )
      AppDbf( cPathOld, cPath, "DEPAGET" )
      AppDbf( cPathOld, cPath, "DEPAGEL" )
	END IF

RETURN NIL

//---------------------------------------------------------------------------//

FUNCTION rxDepAge( cPath, oMeter )

	local dbfDepAgeT

   DEFAULT cPath  := cPatEmp()

   fEraseIndex( cPath + "DEPAGET.CDX" )
   fEraseIndex( cPath + "DEPAGEL.CDX" )

   dbUseArea( .t., cDriver(), cPath + "DEPAGET.DBF", cCheckArea( "DEPAGET", @dbfDepAgeT ), .f. )

   if !( dbfDepAgeT )->( neterr() )
      ( dbfDepAgeT)->( __dbPack() )

      ( dbfDepAgeT)->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( dbfDepAgeT)->( ordCreate( cPath + "DEPAGET.CDX", "NNUMDEP", "CSERDEP + Str( NNUMDEP ) + CSUFDEP", {|| Field->CSERDEP + Str( Field->NNUMDEP ) + Field->CSUFDEP } ) )

      ( dbfDepAgeT)->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( dbfDepAgeT)->( ordCreate( cPath + "DEPAGET.CDX", "DFECDEP", "DFECDEP", {|| Field->DFECDEP } ) )

      ( dbfDepAgeT)->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( dbfDepAgeT)->( ordCreate( cPath + "DEPAGET.CDX", "CCODALM", "CCODALM", {|| Field->CCODALM } ) )

      ( dbfDepAgeT )->( dbCloseArea() )
   else
      msgStop( "Imposible abrir en modo exclusivo la tabla de depósitos de almacén" )
   end if

   dbUseArea( .t., cDriver(), cPath + "DEPAGEL.DBF", cCheckArea( "DEPAGEL", @dbfDepAgeL ), .f. )

   if !( dbfDepAgeL )->( neterr() )
      ( dbfDepAgeL)->( __dbPack() )

      ( dbfDepAgeL)->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( dbfDepAgeL)->( ordCreate( cPath + "DEPAGEL.CDX", "nNumDep", "cSerDep + Str( nNumDep ) + cSufDep", {|| Field->cSerDep + Str( Field->nNumDep ) + Field->CSUFDEP } ) )

      ( dbfDepAgeL)->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( dbfDepAgeL)->( ordCreate( cPath + "DEPAGEL.CDX", "CREF", "CREF", {|| Field->CREF } ) )

      ( dbfDepAgeL )->( dbCloseArea() )
   else
      msgStop( "Imposible abrir en modo exclusivo la tabla de depósitos de almacén" )
   end if

RETURN NIL

//--------------------------------------------------------------------------//

STATIC FUNCTION BeginTrans( aTmp )

   local oBlock
   local oError
   local cDbf     := "DAgeL"
   local cDeposito:= aTmp[ _CSERDEP ] + Str( aTmp[ _NNUMDEP ] ) + aTmp[ _CSUFDEP ]

   cNewFile       := cGetNewFileName( cPatTmp() + cDbf )

	/*
	Primero Crear la base de datos local
	*/

   oBlock         := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   dbCreate( cNewFile, aSqlStruct( aColDepAge() ), cLocalDriver() )

   dbUseArea( .t., cLocalDriver(), cNewFile, cCheckArea( cDbf, @dbfTmp ), .f. )
   if !( dbfTmp )->( NetErr() )

      ( dbfTmp )->( OrdCondSet( "!Deleted()", {||!Deleted() } ) )
      ( dbfTmp )->( OrdCreate( cNewFile, "Recno", "Str( Recno() )", {|| Str( Recno() ) } ) )

      /*
      A¤adimos desde el fichero de lineas--------------------------------------
      */

      if ( dbfDepAgeL )->( dbSeek( cDeposito ) )

         while ( ( dbfDepAgeL )->cSerDep + Str( ( dbfDepAgeL )->nNumDep ) + ( dbfDepAgeL )->cSufDep == cDeposito .AND. !( dbfDepAgeL )->( Eof() ) )

            dbPass( dbfDepAgeL, dbfTmp, .t. )

            ( dbfDepAgeL )->( dbSkip() )

         end while

      end if

   end if

   RECOVER USING oError

      msgStop( "Imposible abrir todas las bases de datos " + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

	( dbfTmp )->( dbGoTop() )

RETURN NIL

//---------------------------------------------------------------------------//

Static Function EndTrans( aTmp, oBrw, oDlg, nMode )

   local oError
   local oBlock
	local aTabla

   if Empty( aTmp[ _CCODALM ] )
      MsgStop( "Código almacén de entrada no puede estar vacío" )
      Return .f.
   end if

   if Empty( aTmp[ _CCODALI ] )
      MsgStop( "Código almacén de salida no puede estar vacío" )
      Return .f.
   end if

   if aTmp[ _CCODALM ] == aTmp[ _CCODALI ]
      MsgStop( "Almacenes de entrada y salida no pueden ser el mismo" )
      Return .f.
   end if

   /*oBlock      := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE*/

   BeginTransaction()

	/*
   Primero hacer el RollBack---------------------------------------------------
	*/

   oMsgProgress():SetRange( 0, ( dbfTmp )->( LastRec() ) )

   do case
   case nMode == EDIT_MODE

      delDetalle( aTmp[ _CSERDEP ] + Str( aTmp[ _NNUMDEP ] ) + aTmp[ _CSUFDEP ] )

   case nMode == APPD_MODE .or. nMode == DUPL_MODE

      aTmp[ _CSERDEP ]     := "A"
      aTmp[ _NNUMDEP ]     := nNewDoc( "A", dbfDepAgeT, "nDepAge", , dbfCount )
      aTmp[ _CSUFDEP ]     := RetSufEmp()

   end case

   ( dbfTmp )->( dbGoTop() )
   do while !( dbfTmp )->( eof() )

      aTabla               := dbScatter( dbfTmp )
      aTabla[ _CSERDEP ]   := aTmp[ _CSERDEP ]
      aTabla[ _NNUMDEP ]   := aTmp[ _NNUMDEP ]
      aTabla[ _CSUFDEP ]   := aTmp[ _CSUFDEP ]
      dbGather( aTabla, dbfDepAgeL, .t. )

      ( dbfTmp )->( dbSkip() )

      oMsgProgress():Deltapos(1)

   end while

	/*
   Cerramos y borramos los ficheros-------------------------------------------------------
	*/

   ( dbfTmp )->( dbCloseArea() )

   dbfErase( cNewFile )

   /*
   Grabamos el registro--------------------------------------------------------
	*/

   WinGather( aTmp, , dbfDepAgeT, oBrw, nMode )

   /*
   Escribe los datos pendientes------------------------------------------------
   */

   dbCommitAll()

   CommitTransaction()

   /*RECOVER USING oError

      RollBackTransaction()

      msgStop( "Imposible guadar cambios" + CRLF + ErrorMessage( oError ) )

   END SEQUENCE
   ErrorBlock( oBlock )*/

   /*
   Cerramos el meter-----------------------------------------------------------
   */

   EndProgress()

   oDlg:End( IDOK )

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

/*
Devuelve en numero de articulos en una linea de detalle
*/

STATIC FUNCTION nTotLNumArt( dbfDetalle )

	local nCalculo := 0

   IF lCalCaj() .and. ( dbfDetalle )->nCanEnt != 0 .and. ( dbfDetalle )->nPreUnit != 0
      nCalculo    := ( dbfDetalle )->nCanEnt
	END IF

RETURN ( nCalculo )

//---------------------------------------------------------------------------//

STATIC FUNCTION GenDepAge( lPrinter, cCaption, cDiv, nVdv )

   local nNumDep     := ( dbfDepAgeT )->CSERDEP + Str( ( dbfDepAgeT )->NNUMDEP ) + ( dbfDepAgeT )->CSUFDEP
	local nCodAlm		:= ( dbfDepAgeT )->CCODALM
	local nOldRecno	:= ( dbfDepAgeL )->( recno() )

	DEFAULT lPrinter 	:= .F.
   DEFAULT cCaption  := "Imprimiendo deposito"

	private cDbfCol	:= dbfDepAgeL

   ( dbfAlmT    )->( dbSeek( nCodAlm ) )
	( dbfDepAgeL )->( dbSeek( nNumDep ) )

	IF lPrinter

		REPORT oInf ;
			CAPTION cCaption ;
         TO PRINTER

	ELSE

		REPORT oInf ;
			CAPTION cCaption ;
			PREVIEW

	END IF

	IF oInf:lCreated

		oInf:lFinish	:= .F.
		oInf:bSkip 		:= {|| ( dbfDepAgeL )->( DbSkip() ) }
		SetMargin(  "DA1", oInf )
		PrintColum( "DA1", oInf )

	END IF

	END REPORT

	ACTIVATE REPORT oInf ;
		WHILE ( ( dbfDepAgeL )->NNUMDEP == nNumDep );
		ON ENDPAGE EPage( oInf )

	( dbfDepAgeL )->( dbGoto( nOldRecno ) )

RETURN NIL

//--------------------------------------------------------------------------//

STATIC FUNCTION ChgState( oBrw )

   dbDialogLock( dbfDepAgeT )
   ( dbfDepAgeT )->lLiqDep := ! (dbfDepAgeT)->lLiqDep
   ( dbfDepAgeT )->( dbUnlock() )

   oBrw:DrawSelect()

RETURN NIL

//--------------------------------------------------------------------------//

FUNCTION aDocDepAge()

   local aDoc  := {}

   /*
   Itmes-----------------------------------------------------------------------
   */

   aAdd( aDoc, { "Empresa",         "EM" } )
   aAdd( aDoc, { "Depositos",       "DA" } )
   aAdd( aDoc, { "Almacen",         "AL" } )
   aAdd( aDoc, { "Agentes",         "AG" } )
   aAdd( aDoc, { "Divisas",         "DV" } )
   aAdd( aDoc, { "Formas de pago",  "PG" } )

RETURN ( aDoc )

//--------------------------------------------------------------------------//

Static Function lGenDepAge( oBrw, oBtn, lImp )

   local bAction

   DEFAULT lImp   := .f.

   if !( dbfDoc )->( dbSeek( "DA" ) )

      DEFINE BTNSHELL RESOURCE "DOCUMENT" OF oWndBrw ;
         NOBORDER ;
         ACTION   ( msgStop( "No hay documentos predefinidos" ) );
         TOOLTIP  "No hay documentos" ;
         HOTKEY   "N";
         FROM     oBtn ;
         CLOSED ;
         LEVEL    ACC_EDIT

   else

      while ( dbfDoc )->CTIPO == "DA" .AND. !( dbfDoc )->( eof() )

         bAction  := bGenDepAge( lImp, "Imprimiendo albaranes de clientes", ( dbfDoc )->CODIGO )

         oWndBrw:NewAt( "Document", , , bAction, Rtrim( ( dbfDoc )->cDescrip ) , , , , , oBtn )

         ( dbfDoc )->( dbSkip() )

      end do

   end if

return nil

//--------------------------------------------------------------------------//

static function bGenDepAge( lImprimir, cTitle, cCodDoc )

   local bGen
   local lImp  := by( lImprimir )
   local cTit  := by( cTitle    )
   local cCod  := by( cCodDoc   )

   if lImp
      bGen     := {|| nGenDeposito( lImp, cTit, cCod ) }
   else
      bGen     := {|| GenDeposito( lImp, cTit, cCod ) }
   end if

return ( bGen )

//--------------------------------------------------------------------------//

function SynDepAge( cPath )

   DEFAULT cPath  := cPatEmp()

   if OpenFiles( cPath )

      while !( dbfDepAgeL )->( eof() )

         if ( dbfDepAgeT )->( dbSeek( ( dbfDepAgeL )->cSerDep + Str( ( dbfDepAgeL )->nNumDep ) + ( dbfDepAgeL )->cSufDep ) )

            if Empty( ( dbfDepAgeL )->cLote ) .and. !Empty( ( dbfDepAgeL )->nLote )

               if dbLock( dbfDepAgeL )

                  ( dbfDepAgeL )->cLote   := AllTrim( Str( ( dbfDepAgeL )->nLote ) )

                  ( dbfDepAgeL )->( dbUnLock() )

               end if

            end if

         end if

         ( dbfDepAgeL )->( dbSkip() )

         SysRefresh()

      end while

   CloseFiles()

   end if

return nil

//------------------------------------------------------------------------//










#include "FastRepH.ch"

Static Function DataReport( oFr )

   /*
   Zona de datos------------------------------------------------------------
   */

   oFr:ClearDataSets()

   oFr:SetWorkArea(     "Depósitos", ( dbfDepAgeT )->( Select() ), .f., { FR_RB_CURRENT, FR_RB_CURRENT, 0 } )
   oFr:SetFieldAliases( "Depósitos", cItemsToReport( aItmDepAge() ) )

   oFr:SetWorkArea(     "Lineas de depósitos", ( dbfDepAgeL )->( Select() ) )
   oFr:SetFieldAliases( "Lineas de depósitos", cItemsToReport( aColDepAge() ) )

   oFr:SetWorkArea(     "Empresa", ( dbfEmp )->( Select() ) )
   oFr:SetFieldAliases( "Empresa", cItemsToReport( aItmEmp() ) )

   oFr:SetWorkArea(     "Almacenes", ( dbfAlmT )->( Select() ) )
   oFr:SetFieldAliases( "Almacenes", cItemsToReport( aItmAlm() ) )

   oFr:SetWorkArea(     "Formas de pago", ( dbfFPago )->( Select() ) )
   oFr:SetFieldAliases( "Formas de pago", cItemsToReport( aItmFPago() ) )

   oFr:SetWorkArea(     "Tipo de venta", ( dbfTVta )->( Select() ) )
   oFr:SetFieldAliases( "Tipo de venta", cItemsToReport( aItmTVta() ) )

   oFr:SetMasterDetail( "Depósitos", "Lineas de depósitos",     {|| ( dbfDepAgeT )->cSerDep + Str( ( dbfDepAgeT )->nNumDep ) + ( dbfDepAgeT )->cSufDep } )
   oFr:SetMasterDetail( "Depósitos", "Empresa",                 {|| cCodigoEmpresaEnUso() } )
   oFr:SetMasterDetail( "Depósitos", "Almacenes",               {|| ( dbfDepAgeT )->cCodAlm } )
   oFr:SetMasterDetail( "Depósitos", "Formas de pago",          {|| ( dbfDepAgeT )->cCodPgo } )

   oFr:SetMasterDetail( "Lineas de depósitos", "Tipo de venta", {|| ( dbfDepAgeL )->cTipMov } )

   oFr:SetResyncPair(   "Depósitos", "Lineas de depósitos" )
   oFr:SetResyncPair(   "Depósitos", "Empresa" )
   oFr:SetResyncPair(   "Depósitos", "Almacenes" )
   oFr:SetResyncPair(   "Depósitos", "Formas de pago" )
   oFr:SetResyncPair(   "Lineas de depósitos", "Tipo de venta" )

Return nil

//---------------------------------------------------------------------------//

Static Function VariableReport( oFr )

   oFr:DeleteCategory(  "Depósitos" )
   oFr:DeleteCategory(  "Lineas de depósitos" )

   /*
   Creación de variables----------------------------------------------------
   */

   oFr:AddVariable( "Depósitos",            "Total bruto",                         "GetHbVar('nTotBrt')" )
   oFr:AddVariable( "Depósitos",            "Total neto",                          "GetHbVar('nTotNet')" )
   oFr:AddVariable( "Depósitos",            "Total " + cImp(),                           "GetHbVar('nTotIva')" )
   oFr:AddVariable( "Depósitos",            "Total RE",                            "GetHbVar('nTotReq')" )
   oFr:AddVariable( "Depósitos",            "Total descuento",                     "GetHbVar('nTotDto')" )
   oFr:AddVariable( "Depósitos",            "Total descuento pronto pago",         "GetHbVar('nTotDpp')" )
   oFr:AddVariable( "Depósitos",            "Total depósito",                      "GetHbVar('nTotDep')" )
   oFr:AddVariable( "Depósitos",            "Bruto primer tipo de " + cImp(),            "GetHbArrayVar('aIvaUno',1)" )
   oFr:AddVariable( "Depósitos",            "Bruto segundo tipo de " + cImp(),           "GetHbArrayVar('aIvaDos',1)" )
   oFr:AddVariable( "Depósitos",            "Bruto tercer tipo de " + cImp(),            "GetHbArrayVar('aIvaTre',1)" )
   oFr:AddVariable( "Depósitos",            "Base primer tipo de " + cImp(),             "GetHbArrayVar('aIvaUno',2)" )
   oFr:AddVariable( "Depósitos",            "Base segundo tipo de " + cImp(),            "GetHbArrayVar('aIvaDos',2)" )
   oFr:AddVariable( "Depósitos",            "Base tercer tipo de " + cImp(),             "GetHbArrayVar('aIvaTre',2)" )
   oFr:AddVariable( "Depósitos",            "Porcentaje primer tipo " + cImp(),          "GetHbArrayVar('aIvaUno',3)" )
   oFr:AddVariable( "Depósitos",            "Porcentaje segundo tipo " + cImp(),         "GetHbArrayVar('aIvaDos',3)" )
   oFr:AddVariable( "Depósitos",            "Porcentaje tercer tipo " + cImp(),          "GetHbArrayVar('aIvaTre',3)" )
   oFr:AddVariable( "Depósitos",            "Porcentaje primer tipo RE",           "GetHbArrayVar('aIvaUno',4)" )
   oFr:AddVariable( "Depósitos",            "Porcentaje segundo tipo RE",          "GetHbArrayVar('aIvaDos',4)" )
   oFr:AddVariable( "Depósitos",            "Porcentaje tercer tipo RE",           "GetHbArrayVar('aIvaTre',4)" )

   oFr:AddVariable( "Lineas de depósitos",  "Total unidades artículo",             "CallHbFunc('nTotNDepAge')" )
   oFr:AddVariable( "Lineas de depósitos",  "Total línea depósito",                "CallHbFunc('nTotLDepAge')" )
   oFr:AddVariable( "Lineas de depósitos",  "Fecha en juliano 6 meses",            "CallHbFunc('dJulianoDepAge')" )
   oFr:AddVariable( "Lineas de depósitos",  "Fecha en juliano 8 meses",            "CallHbFunc('dJulianoDepAnio')" )

Return nil

//---------------------------------------------------------------------------//

Function DesignReportDepAge( oFr, dbfDoc )

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
                                                   "CallHbFunc('nTotDepAge');"                                 + Chr(13) + Chr(10) + ;
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
         oFr:SetObjProperty(  "MasterData",  "DataSet", "Depósitos" )

         oFr:AddBand(         "DetalleColumnas",   "MainPage", frxDetailData  )
         oFr:SetProperty(     "DetalleColumnas",   "Top", 230 )
         oFr:SetProperty(     "DetalleColumnas",   "Height", 28 )
         oFr:SetObjProperty(  "DetalleColumnas",   "DataSet", "Lineas de depósitos" )
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

Function PrintReportDepAge( nDevice, nCopies, cPrinter, dbfDoc )

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

FUNCTION nTotNDepAge( uDbf )

   local nTotUnd

   DEFAULT uDbf   := dbfDepAgeL

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

#endif

//---------------------------------------------------------------------------//
//Funciones comunes del programa y pda
//---------------------------------------------------------------------------//

FUNCTION nTotLDepAge( dbfLine )

   local nCalculo    := 0

   DEFAULT dbfLine   := dbfDepAgeL

   nCalculo          := ( dbfLine )->nUniCaja * ( dbfLine )->nPreUnit

   if lCalCaj()
      nCalculo       *= if( ( dbfLine )->NCANENT != 0, ( dbfLine )->NCANENT, 1 )
   end if

   if ( dbfLine )->NDTO != 0
      nCalculo       -= nCalculo * ( dbfLine )->NDTO / 100
   end if

   if ( dbfLine )->NDTOPRM != 0
      nCalculo       -= nCalculo * ( dbfLine )->NDTOPRM / 100
   end if

RETURN ( nCalculo )

//---------------------------------------------------------------------------//

STATIC FUNCTION EdtRec( aTmp, aGet, dbfDepAgeT, oBrw, bWhen, bValid, nMode )

	local oDlg
	local oBrw2
   local oSay1, oSay2, oSay4, oSay5, oSay6
   local cSay1, cSay2, cSay4, cSay5, cSay6
   local oBmpDiv
   local oFont          := TFont():New( "Arial", 8, 26, .F., .T. )
   local oBmpGeneral

	IF nMode == APPD_MODE
      aTmp[ _CSERDEP ]  := "A"
      aTmp[ _CCODALI ]  := cDefAlm()
      aTmp[ _CCODPGO ]  := cDefFpg()
      aTmp[ _CDIVDEP ]  := cDivEmp()
      aTmp[ _NVDVDEP ]  := nChgDiv( aTmp[ _CDIVDEP ], dbfDiv )
      aTmp[ _CCODUSR ]  := cCurUsr()
      aTmp[ _CCODDLG ]  := oUser():cDelegacion()
	END

   cSay5                := RetFld( aTmp[ _CCODUSR ], dbfUsr, "cNbrUse" )
   cSay6                := RetFld( cCodEmp() + aTmp[ _CCODDLG ], dbfDelega, "cNomDlg" )

   if Empty( aTmp[ _CDTOESP ] )
      aTmp[ _CDTOESP ]  := Padr( "General", 50 )
   end if

   if Empty( aTmp[ _CDPP ] )
      aTmp[ _CDPP ]     := Padr( "Pronto pago", 50 )
   end if

	BeginTrans( aTmp )

   cPicUnd              := MasUnd()                            // Picture de las unidades
   cPouDiv              := cPouDiv( aTmp[ _CDIVDEP ], dbfDiv ) // Picture de la divisa
   cPorDiv              := cPorDiv( aTmp[ _CDIVDEP ], dbfDiv ) // Picture de la divisa redondeada
   nDouDiv              := nDouDiv( aTmp[ _CDIVDEP ], dbfDiv ) // Decimales de la divisa
   nDorDiv              := nRouDiv( aTmp[ _CDIVDEP ], dbfDiv ) // Decimales de la divisa redondeada
   cPpvDiv              := cPpvDiv( aTmp[ _CDIVDEP ], dbfDiv ) // Picture del punto verde
   nDpvDiv              := nDpvDiv( aTmp[ _CDIVDEP ], dbfDiv ) // Decimales de redondeo del punto verde

   DEFINE DIALOG oDlg RESOURCE "DEPAGE" TITLE LblTitle( nMode ) + "depósitos a almacenes"

      REDEFINE BITMAP oBmpGeneral ;
         ID       990 ;
         RESOURCE "package_add_48_alpha" ;
         TRANSPARENT ;
         OF       oDlg

      REDEFINE GET aGet[ _NNUMDEP ] VAR aTmp[ _NNUMDEP ] ;
			ID 		100 ;
			PICTURE 	"999999999" ;
			WHEN  	( .F. ) ;
			OF 		oDlg

      REDEFINE GET aGet[ _DFECDEP ] VAR aTmp[ _DFECDEP ];
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

      REDEFINE CHECKBOX aGet[_LLIQDEP] VAR aTmp[_LLIQDEP] ;
         ID       400 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         OF       oDlg

      REDEFINE GET aGet[ _CCODALM ] VAR aTmp[ _CCODALM ] ;
			ID 		130 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         VALID    ( LoadAlm( aGet, aTmp ) ) ;
         BITMAP   "LUPA" ;
         ON HELP  ( BrwAlmacen( aGet[ _CCODALM ] ) ) ;
			COLOR 	CLR_GET ;
			OF 		oDlg

      REDEFINE GET aGet[ _CNOMALM ] VAR aTmp[ _CNOMALM ] ;
			ID 		131 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
			OF 		oDlg

      REDEFINE GET aGet[ _CDIRALM ] VAR aTmp[ _CDIRALM ] ;
         ID       132 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
			OF 		oDlg

      REDEFINE GET aGet[ _CPOSALM ] VAR aTmp[ _CPOSALM ] ;
         ID       133 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
			OF 		oDlg

      REDEFINE GET aGet[ _CPOBALM ] VAR aTmp[ _CPOBALM ] ;
         ID       134 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
			OF 		oDlg

      REDEFINE GET aGet[ _CPRVALM ] VAR aTmp[ _CPRVALM ] ;
         ID       135 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
			OF 		oDlg

      /*
      Codigo de almacen________________________________________________________________
		*/

      REDEFINE GET aGet[ _CCODALI ] VAR aTmp[ _CCODALI ] ;
         ID       160 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         VALID    ( cAlmacen( aGet[ _CCODALI ], , oSay1 ) ) ;
         BITMAP   "LUPA" ;
         ON HELP  ( brwAlmacen( aGet[ _CCODALI ], oSay1 ) ) ;
         OF       oDlg

      REDEFINE GET oSay1 VAR cSay1 ;
         WHEN     .f. ;
         ID       161 ;
         OF       oDlg

      REDEFINE GET aGet[ _CCODPGO ] VAR aTmp[ _CCODPGO ] ;
			ID 		140 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			PICTURE  "@!" ;
         BITMAP   "LUPA" ;
         VALID    ( cFPago( aGet[ _CCODPGO ], dbfFPago, oSay2 ) ) ;
         ON HELP  ( BrwFPago( aGet[ _CCODPGO ], oSay2 ) ) ;
			OF 		oDlg

		REDEFINE GET oSay2 VAR cSay2 ;
			ID 		141 ;
			WHEN 		.F. ;
			COLOR 	CLR_GET ;
			OF 		oDlg

      REDEFINE GET aGet[ _CCODTAR ] VAR aTmp[ _CCODTAR ] ;
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

		REDEFINE GET aGet[ _CDIVDEP ] VAR aTmp[ _CDIVDEP ];
			WHEN 		( 	nMode == APPD_MODE ) ;
         BITMAP   "LUPA" ;
         VALID    ( cDivOut( aGet[ _CDIVDEP ], oBmpDiv, aTmp[ _NVDVDEP ], @cPouDiv, @nDouDiv, @cPorDiv, @nDorDiv, @cPpvDiv, @nDpvDiv, nil, dbfDiv, oBandera ) );
			PICTURE	"@!";
			ID 		170 ;
         ON HELP  BrwDiv( aGet[ _CDIVDEP ], oBmpDiv, aTmp[ _NVDVDEP ], dbfDiv, oBandera ) ;
			OF 		oDlg

		REDEFINE BITMAP oBmpDiv ;
         RESOURCE cBmpDiv( aTmp[ _CDIVDEP ], dbfDiv ) ;
			ID 		171;
			OF 		oDlg

      /*
      Detalle------------------------------------------------------------------
      */

      oBrw2                   := IXBrowse():New( oDlg )

      oBrw2:bClrSel           := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      oBrw2:bClrSelFocus      := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      oBrw2:cAlias            := dbfTmp

      oBrw2:nMarqueeStyle     := 6
      oBrw2:cName             := "Depósitos a almacén detalle"

      oBrw2:CreateFromResource( 200 )

      with object ( oBrw2:AddCol() )
         :cHeader             := "Código"
         :bEditValue          := {|| ( dbfTmp )->cRef }
         :nWidth              := 70
      end with

      with object ( oBrw2:AddCol() )
         :cHeader             := "Descripción"
         :bEditValue          := {|| ( dbfTmp )->cDetalle }
         :nWidth              := 362
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
         :bEditValue          := {|| (dbfTmp)->NPREUNIT }
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
         :bEditValue          := {|| nTotLDepAge( dbfTmp ) }
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
			OF 		oDlg

		REDEFINE GET aGet[_NDTOESP ] VAR aTmp[ _NDTOESP ] ;
			ID 		210 ;
			PICTURE 	"@E 99.99" ;
         SPINNER ;
         VALID    ( nRecTotal( dbfTmp, aTmp ) );
			WHEN 		( nMode != ZOOM_MODE ) ;
			OF 		oDlg

      REDEFINE GET aGet[ _CDPP ] VAR aTmp[ _CDPP ] ;
         ID       219 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			OF 		oDlg

		REDEFINE GET aGet[ _NDPP ] VAR aTmp[ _NDPP ];
			ID 		220 ;
			PICTURE 	"@E 99.99" ;
         SPINNER ;
         VALID    ( nRecTotal( dbfTmp, aTmp ) );
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
         :bStrData         := {|| if( aTotIva[ oBrwIva:nArrayAt, 3 ] != nil, Trans( aTotIva[ oBrwIva:nArrayAt, 2 ], cPorDiv ), "" ) }
         :nWidth           := 120
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
      end with

      with object ( oBrwIva:AddCol() )
         :cHeader          := "% " + cImp()
         :bStrData         := {|| if( aTotIva[ oBrwIva:nArrayAt, 3 ] != nil, Trans( aTotIva[ oBrwIva:nArrayAt, 3 ], "@E 99.9"), "" ) }
         :nWidth           := 65
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
         :nEditType        := 1
      end with

      with object ( oBrwIva:AddCol() )
         :cHeader          := cImp()
         :bStrData         := {|| if( aTotIva[ oBrwIva:nArrayAt, 3 ] != nil, Trans( aTotIva[ oBrwIva:nArrayAt, 3 ] * aTotIva[ oBrwIva:nArrayAt, 2 ] / 100, cPorDiv ), "" ) }
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
         :bStrData         := {|| if( aTotIva[ oBrwIva:nArrayAt, 3 ] != nil, Trans( aTotIva[ oBrwIva:nArrayAt, 4 ] * aTotIva[ oBrwIva:nArrayAt, 2 ] / 100, cPorDiv ), "" ) }
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
         PICTURE  cPorDiv ;
			OF 		oDlg

		REDEFINE SAY oGetIva VAR nGetIva ;
			ID 		430 ;
         PICTURE  cPorDiv ;
			OF 		oDlg

		REDEFINE SAY oGetReq VAR nGetReq ;
			ID 		440 ;
         PICTURE  cPorDiv ;
			OF 		oDlg

		REDEFINE CHECKBOX aGet[_LRECARGO] VAR aTmp[_LRECARGO] ;
			ID 		450 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         ON CHANGE( nRecTotal( dbfTmp, aTmp ) );
			OF 		oDlg

      REDEFINE SAY oGetTotal VAR nTotDep;
			ID 		460 ;
         PICTURE  cPorDiv ;
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
         ACTION   ( EndTrans( aTmp, oBrw2, oDlg, nMode ) )

		REDEFINE BUTTON ;
			ID 		510 ;
			OF 		oDlg ;
         CANCEL ;
         ACTION   ( If( ExitNoSave( nMode, dbfTmp ), oDlg:end(), ) )

   if nMode != ZOOM_MODE
      oDlg:AddFastKey( VK_F2, {|| AppDeta( oBrw2, bEdit2, aTmp ) } )
      oDlg:AddFastKey( VK_F3, {|| EdtDeta( oBrw2, bEdit2, aTmp ) } )
      oDlg:AddFastKey( VK_F4, {|| DelDeta( oBrw2, aTmp ) } )
      oDlg:AddFastKey( VK_F5, {|| EndTrans( aTmp, oBrw2, oDlg, nMode ) } )
   end if

   oDlg:bStart    := { || aGet[_CCODALM]:SetFocus(), oBrw2:Load() }

   ACTIVATE DIALOG oDlg ;
      ON PAINT    ( EvalGet( aGet, nMode ), nRecTotal( dbfTmp, aTmp ) );
		ON INIT		( nRecTotal( dbfTmp, aTmp ) );
      VALID       ( oFont:end(), .T. );
		CENTER

   oBmpGeneral:End()

   if !Empty( oBrw2 )
      oBrw2:CloseData()
      oBrw2:End()
   end if

   KillTrans()

RETURN ( oDlg:nResult == IDOK )

//--------------------------------------------------------------------------//

/*
Edita las lineas de Detalle
*/

STATIC FUNCTION EdtDet( aTmp, aGet, dbfDepAgeL, oBrw, bWhen, bValid, nMode, aTmpDep )

   local oBtn
   local oGet2
   local cGet2
   local oDlg2
	local oTotal
   local nTotal         := 0
   local oSayLote
   local oSayCaja

	IF nMode	== APPD_MODE
      aTmp[_CSERDEP ]   := aTmpDep[_CSERDEP]
      aTmp[_NNUMDEP ]   := aTmpDep[_NNUMDEP]
      aTmp[_CSUFDEP ]   := aTmpDep[_CSUFDEP]
      aTmp[_NCANENT ]   := 1
      aTmp[_NUNICAJA]   := 1
      aTmp[_DFECHA  ]   := Date()
      aTmp[_CTIPMOV ]   := cDefVta()
	END CASE

   DEFINE DIALOG oDlg2 RESOURCE "LDEPAGE" TITLE lblTitle( nMode ) + "lineas de depósitos a almacén"

		REDEFINE GET aGet[_CREF] VAR aTmp[_CREF];
			ID 		100 ;
			WHEN 		( nMode == APPD_MODE ) ;
         VALID    ( LoaArt( aGet, aTmp, aTmpDep, oSayLote ) ) ;
         ON HELP  ( BrwArticulo( aGet[_CREF], aGet[_CDETALLE] ) );
         BITMAP   "LUPA" ;
         COLOR    CLR_GET ;
			OF 		oDlg2

		REDEFINE GET aGet[_CDETALLE] VAR aTmp[_CDETALLE] ;
			ID 		110 ;
         WHEN     ( lModDes() .AND. nMode != ZOOM_MODE ) ;
			COLOR 	CLR_GET ;
			OF 		oDlg2

      /*
      Lotes
      -------------------------------------------------------------------------
      */

      REDEFINE SAY oSayLote;
         ID       113;
         OF       oDlg2

      REDEFINE GET aGet[_CLOTE] VAR aTmp[_CLOTE];
         ID       112 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         COLOR    CLR_GET ;
         OF       oDlg2

      /*
      Lotes
      -------------------------------------------------------------------------
      */

      REDEFINE GET aGet[_NIVA] VAR aTmp[_NIVA] ;
			ID 		120 ;
			COLOR 	CLR_GET ;
			PICTURE 	"@E 99.9" ;
         WHEN     ( lModIva() .AND. nMode != ZOOM_MODE ) ;
			VALID 	( lTiva( dbfIva, aTmp[_NIVA] ) );
         ON HELP  ( BrwIva( aGet[ _NIVA ], dbfIva, , .t. ) ) ;
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
         PICTURE  cPouDiv ;
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
         PICTURE  cPorDiv ;
			WHEN 		.F. ;
			OF 		oDlg2

      REDEFINE BUTTON oBtn;
         ID       IDOK ;
			OF 		oDlg2 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         ACTION   SaveDeta( aTmp, aGet, oBrw, oDlg2, nMode, oTotal, aTmpDep, oBtn )

		REDEFINE BUTTON ;
         ID       IDCANCEL ;
			OF 		oDlg2 ;
			ACTION 	( oDlg2:end() )

      REDEFINE BUTTON ;
         ID       9 ;
			OF 		oDlg2 ;
         ACTION   ( ChmHelp ("Añadir_linea_deposito") )

   if nMode != ZOOM_MODE
      oDlg2:AddFastKey( VK_F5, {|| SaveDeta( aTmp, aGet, oBrw, oDlg2, nMode, oTotal, aTmpDep, oBtn ) } )
   end if

   oDlg2:AddFastKey( VK_F1, {|| ChmHelp ("Añadir_linea_deposito") } )

   oDlg2:bStart := {|| SetDlgMode( aGet, aTmp, oSayLote, nMode, oSayCaja ) }

   ACTIVATE DIALOG oDlg2 CENTER ON PAINT ( lCalcDeta( aTmp, oTotal ) )

RETURN ( oDlg2:nResult == IDOK )

//--------------------------------------------------------------------------//

Function dJulianoDepAge( cDepAgeL )

   DEFAULT cDepAgeL  := dbfDepAgeL

RETURN ( AddMonth( JulianoToDate( , Val( ( cDepAgeL )->cLote ) ), 6 ) )

//---------------------------------------------------------------------------//

Function dJulianoDepAnio( cDepAgeL )

   DEFAULT cDepAgeL  := dbfDepAgeL

RETURN ( AddMonth( JulianoToDate( , Val( ( cDepAgeL )->cLote ) ), 8 ) )

//---------------------------------------------------------------------------//