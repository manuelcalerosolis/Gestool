#include "FiveWin.Ch"
#include "Factu.ch" 
#include "MesDbf.ch"
#include "Xbrowse.ch"

//---------------------------------------------------------------------------//

CLASS TAtipicas FROM TDet

   DATA oDlg
   DATA oFld

   DATA oSayLabels         INIT array( 16 )

   DATA oSayPr1
   DATA oSayPr2
   DATA oSayVp1
   DATA oSayVp2
   DATA cSayPr1
   DATA cSayPr2
   DATA cSayVp1
   DATA cSayVp2

   DATA oCosto
   DATA cCosto

   DATA oSobre
   DATA cSobre             INIT "Precio 1"
   DATA aSobre             INIT { "Precio 1", "Precio 2", "Precio 3", "Precio 4", "Precio 5", "Precio 6" }
   
   DATA oNaturaleza
   DATA cNaturaleza        INIT "Artículo"
   DATA aNaturaleza        INIT { "Artículo", "Familia" }

   DATA oBrwRen

   DATA cPouEmp            INIT cPouDiv( cDivEmp() )
   DATA cPouChg            INIT cPouDiv( cDivChg() )

   DATA cRoundPrice        INIT cPorDiv()
   
   DATA oBtnExpandir

   DATA oBrwAtipica

   METHOD New()

   METHOD DefineFiles()

   // Propiedades del dialogo -------------------------------------------------

   DATA oCodigoArticulo
   DATA cCodigoArticulo

   DATA oCodigoFamilia
   DATA cCodigoFamilia 

   DATA oNombreArticulo 
   DATA cNombreArticulo 

   DATA oNombreFamilia 
   DATA cNombreFamilia 

   METHOD Resource()
   METHOD Start()          INLINE ( MsgStop( "Start" ) )
   METHOD Save()           INLINE ( MsgStop( "Save" ) )
   METHOD PreSaveDetail()  INLINE ( MsgStop( "PreSaveDetail" ) )

   METHOD ButtonAppend( Id, oDialog )
   METHOD ButtonEdit( Id, oDialog )
   METHOD ButtonDel( Id, oDialog )
   METHOD Browse( Id, oDialog )

   METHOD LoadAtipica()

   METHOD ClaculaRentabilidad()   VIRTUAL

END CLASS

//---------------------------------------------------------------------------//

METHOD New( cPath, oParent ) CLASS TAtipicas

   DEFAULT cPath        := cPatEmp()

   ::cPath              := cPath
   ::oParent            := oParent

   ::bOnPreSaveDetail   := {|| ::PreSaveDetails() }

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD DefineFiles( cPath, cVia, lUniqueName, cFileName ) CLASS TAtipicas

   local oDbf

   DEFAULT cPath        := ::cPath
   DEFAULT cVia         := cDriver()
   DEFAULT lUniqueName  := .f.
   DEFAULT cFileName    := "CliAtp"

   if lUniqueName
      cFileName         := cGetNewFileName( cFileName, , , cPath )
   end if

   DEFINE TABLE oDbf FILE ( cFileName ) CLASS ( cFileName ) ALIAS ( cFileName ) PATH ( cPath ) VIA ( cVia ) COMMENT "Atipicas de clientes y grupos"

      FIELD NAME "cCodCli"    TYPE "C" LEN 12  DEC 0 COMMENT "Código del cliente"                           OF oDbf
      FIELD NAME "cCodGrp"    TYPE "C" LEN  4  DEC 0 COMMENT "Código de grupo de cliente"                   OF oDbf
      FIELD NAME "cCodArt"    TYPE "C" LEN 18  DEC 0 COMMENT "Código de artículo en atipicas"               OF oDbf     
      FIELD NAME "cCodFam"    TYPE "C" LEN 16  DEC 0 COMMENT "Código de familias en atipicas"               OF oDbf
      FIELD NAME "nTipAtp"    TYPE "N" LEN  1  DEC 0 COMMENT "Tipo de atípicas"                             OF oDbf
      FIELD NAME "cCodPr1"    TYPE "C" LEN 20  DEC 0 COMMENT "Código propiedad 1"                           OF oDbf
      FIELD NAME "cValPr1"    TYPE "C" LEN 20  DEC 0 COMMENT "Valor propiedad 1"                            OF oDbf
      FIELD NAME "cCodPr2"    TYPE "C" LEN 20  DEC 0 COMMENT "Código propiedad 2"                           OF oDbf
      FIELD NAME "cValPr2"    TYPE "C" LEN 20  DEC 0 COMMENT "Valor propiedad 2"                            OF oDbf
      FIELD NAME "dFecIni"    TYPE "D" LEN  8  DEC 0 COMMENT "Fecha inicio de la situación atipica"         OF oDbf
      FIELD NAME "dFecFin"    TYPE "D" LEN  8  DEC 0 COMMENT "Fecha fin de la situación atipica"            OF oDbf
      FIELD NAME "lPrcCom"    TYPE "L" LEN  1  DEC 0 COMMENT "Lógico para precio de compras personal"       OF oDbf
      FIELD NAME "nPrcCom"    TYPE "N" LEN 16  DEC 6 COMMENT "Precio de coste"                              OF oDbf
      FIELD NAME "nPrcArt"    TYPE "N" LEN 16  DEC 6 COMMENT "Precio de venta 1 del artículo"               OF oDbf
      FIELD NAME "nPrcArt2"   TYPE "N" LEN 16  DEC 6 COMMENT "Precio de venta 2 del artículo"               OF oDbf
      FIELD NAME "nPrcArt3"   TYPE "N" LEN 16  DEC 6 COMMENT "Precio de venta 3 del artículo"               OF oDbf 
      FIELD NAME "nPrcArt4"   TYPE "N" LEN 16  DEC 6 COMMENT "Precio de venta 4 del artículo"               OF oDbf 
      FIELD NAME "nPrcArt5"   TYPE "N" LEN 16  DEC 6 COMMENT "Precio de venta 5 del artículo"               OF oDbf 
      FIELD NAME "nPrcArt6"   TYPE "N" LEN 16  DEC 6 COMMENT "Precio de venta 6 del artículo"               OF oDbf 
      FIELD NAME "nPreIva1"   TYPE "N" LEN 16  DEC 6 COMMENT "Precio de venta 1 con " + cImp()              OF oDbf
      FIELD NAME "nPreIva2"   TYPE "N" LEN 16  DEC 6 COMMENT "Precio de venta 2 con " + cImp()              OF oDbf
      FIELD NAME "nPreIva3"   TYPE "N" LEN 16  DEC 6 COMMENT "Precio de venta 3 con " + cImp()              OF oDbf
      FIELD NAME "nPreIva4"   TYPE "N" LEN 16  DEC 6 COMMENT "Precio de venta 4 con " + cImp()              OF oDbf
      FIELD NAME "nPreIva5"   TYPE "N" LEN 16  DEC 6 COMMENT "Precio de venta 5 con " + cImp()              OF oDbf
      FIELD NAME "nPreIva6"   TYPE "N" LEN 16  DEC 6 COMMENT "Precio de venta 6 con " + cImp()              OF oDbf
      FIELD NAME "nDtoArt"    TYPE "N" LEN  6  DEC 2 COMMENT "Descuento del articulo"                       OF oDbf
      FIELD NAME "nDprArt"    TYPE "N" LEN  6  DEC 2 COMMENT "Descuento promocional del articulo"           OF oDbf
      FIELD NAME "lComAge"    TYPE "L" LEN  1  DEC 0 COMMENT "Lógico para tener en cuenta el porcentaje"    OF oDbf
      FIELD NAME "nComAge"    TYPE "N" LEN  6  DEC 2 COMMENT "Comisión del agente"                          OF oDbf
      FIELD NAME "nDtoDiv"    TYPE "N" LEN 16  DEC 6 COMMENT "Descuento lineal"                             OF oDbf
      FIELD NAME "lAplPre"    TYPE "L" LEN  1  DEC 0 COMMENT "Aplicar en presupuestos"                      OF oDbf
      FIELD NAME "lAplPed"    TYPE "L" LEN  1  DEC 0 COMMENT "Aplicar en pedidos"                           OF oDbf
      FIELD NAME "lAplAlb"    TYPE "L" LEN  1  DEC 0 COMMENT "Aplicar en albaranes"                         OF oDbf
      FIELD NAME "lAplFac"    TYPE "L" LEN  1  DEC 0 COMMENT "Aplicar en facturas"                          OF oDbf
      FIELD NAME "lAplSat"    TYPE "L" LEN  1  DEC 0 COMMENT "Aplicar en S.A.T."                            OF oDbf
      FIELD NAME "nUnvOfe"    TYPE "N" LEN  3  DEC 0 COMMENT "Unidades a vender en la oferta"               OF oDbf
      FIELD NAME "nUncOfe"    TYPE "N" LEN  3  DEC 0 COMMENT "Unidades a cobrar en la oferta"               OF oDbf
      FIELD NAME "nTipXby"    TYPE "N" LEN  1  DEC 0 COMMENT "Tipo de oferta"                               OF oDbf
      FIELD NAME "nDto1"      TYPE "N" LEN  6  DEC 2 COMMENT "Descuento de tarifa de venta 1"               OF oDbf
      FIELD NAME "nDto2"      TYPE "N" LEN  6  DEC 2 COMMENT "Descuento de tarifa de venta 2"               OF oDbf
      FIELD NAME "nDto3"      TYPE "N" LEN  6  DEC 2 COMMENT "Descuento de tarifa de venta 3"               OF oDbf
      FIELD NAME "nDto4"      TYPE "N" LEN  6  DEC 2 COMMENT "Descuento de tarifa de venta 4"               OF oDbf
      FIELD NAME "nDto5"      TYPE "N" LEN  6  DEC 2 COMMENT "Descuento de tarifa de venta 5"               OF oDbf
      FIELD NAME "nDto6"      TYPE "N" LEN  6  DEC 2 COMMENT "Descuento de tarifa de venta 6"               OF oDbf

      INDEX TO ( cFileName ) TAG "cCodCli" ON "cCodCli"                                                     NODELETED   OF oDbf
      INDEX TO ( cFileName ) TAG "cCodGrp" ON "cCodGrp"                                                     NODELETED   OF oDbf
      INDEX TO ( cFileName ) TAG "cCliArt" ON "cCodCli + cCodArt + cCodPr1 + cCodPr2 + cValPr1 + cValPr2"   NODELETED   OF oDbf
      INDEX TO ( cFileName ) TAG "cGrpArt" ON "cCodGrp + cCodArt + cCodPr1 + cCodPr2 + cValPr1 + cValPr2"   NODELETED   OF oDbf
      INDEX TO ( cFileName ) TAG "cCodFam" ON "cCodCli + cCodFam"                                           NODELETED   OF oDbf

   END DATABASE oDbf

RETURN ( oDbf )

//--------------------------------------------------------------------------//

METHOD Resource( nMode ) CLASS TAtipicas

   if ( nMode == APPD_MODE )

      ::cCosto          := 0
      ::oDbfVir:dFecIni := Ctod( "" )
      ::oDbfVir:dFecFin := Ctod( "" )
      ::oDbfVir:lAplPre := .t.
      ::oDbfVir:lAplPed := .t.
      ::oDbfVir:lAplAlb := .t.
      ::oDbfVir:lAplFac := .t.
      ::oDbfVir:lAplSat := .t.
      ::oDbfVir:nTipXby := 2
      ::oDbfVir:nUnvOfe := 1
      ::oDbfVir:nUncOfe := 1

      /*
      if !Empty( ::cAgente )
         if ( cAgente )->( dbSeek( aTmpCli[ _CAGENTE ] ) )
            aTmp[ _aNCOMAGE ]    := ( cAgente )->nCom1
            if ( cAgente )->nCom1 != 0
               aTmp[ _aLCOMAGE ] := .t.
            end if
         end if
      end if
      */

   else

      ::cNaturaleza     := Max( Min( ::oDbfVir:nTipAtp, len( ::aNaturaleza ) ), 1 )

      ::cGetArticulo    := retArticulo( ::oDbfVir:cCodArt )

      if !Empty( ::oDbfVir:cCodPr1 )
         ::cSayPr1      := retProp( ::oDbfVir:cCodPr1 )
         ::cSayVp1      := retValProp( ::oDbfVir:cCodPr1 + ::oDbfVir:cValPr1 )
      end if

      if !Empty( ::oDbfVir:cCodPr2 )
         ::cSayPr2      := retProp( ::oDbfVir:cCodPr2 )
         ::cSayVp2      := retValProp( ::oDbfVir:cCodPr2 + ::oDbfVir:cValPr2 )
      end if

      ::cGetFamilia     := retFld( ::oDbfVir:cCodFam )

   end if

   DEFINE DIALOG ::oDlg RESOURCE "CLIATP" TITLE LblTitle( nMode ) + "tarifas de clientes"

      REDEFINE FOLDER ::oFld ;
         ID       100 ;
			OF 		::oDlg ;
         PROMPT   "&General"  ,;
                  "A&mbito"   ;
         DIALOGS  "CLIATP_0"  ,;
                  "CLIATP_1"  ;

      REDEFINE COMBOBOX ::oNaturaleza ;
         VAR      ::cNaturaleza ;
         ITEMS    ::aNaturaleza ;
         ID       90 ;
         ON CHANGE( ::ChangeNaturaleza() ) ;
         WHEN     ( nMode == APPD_MODE ) ;
			OF 		::oFld:aDialogs[1]

      REDEFINE GET ::oCodigoArticulo ;
         VAR      ::oDbfVir:cCodArt ;
			ID 		100 ;
         WHEN     ( ::nMode == APPD_MODE );
         ON HELP  ( BrwArticulo( ::oCodigoArticulo, ::oNombreArticulo ) );
         BITMAP   "Lupa" ;
         ON CHANGE( ::ClaculaRentabilidad() );
         VALID    ( ::LoadAtipica() ) ;
			OF 		::oFld:aDialogs[1]

      REDEFINE GET ::oNombreArticulo ;
         VAR      ::cNombreArticulo ;
			ID 		110 ;
			WHEN  	( .f. );
         OF       ::oFld:aDialogs[1]

      REDEFINE GET ::oCodigoFamilia ;
         VAR      ::oDbfVir:cCodFam;
         ID       105 ;
         WHEN     ( ::nMode == APPD_MODE );
         BITMAP   "LUPA" ;
         OF       ::oFld:aDialogs[1]

         ::oCodigoFamilia:bValid := {|| cFamilia( ::oCodigoFamilia, TDataCenter():Get( "Familia" ), ::oNombreFamilia ) }
         ::oCodigoFamilia:bHelp  := {|| BrwFamilia( ::oCodigoFamilia, ::oNombreFamilia ) }

      REDEFINE GET ::oNombreFamilia ;
         VAR      ::cNombreFamilia ;
         ID       106 ;
         WHEN     ( .f. );
         OF       ::oFld:aDialogs[1]
/*
      REDEFINE SAY oSayPr1 VAR cSayPr1;
         ID       888 ;
         OF       ::oFld:aDialogs[1]

      REDEFINE GET aGet[ _acValPr1 ] VAR aTmp[ _acValPr1 ];
         ID       250 ;
         BITMAP   "LUPA" ;
         WHEN     ( nMode == APPD_MODE ) ;
         ON HELP  ( brwPrpAct( aGet[ _acValPr1 ], oSayVp1, aTmp[ _acCodPr1 ] ) ) ;
         VALID    ( if( lPrpAct( aGet[ _acValPr1 ], oSayVp1, aTmp[ _acCodPr1 ], dbfProL ),;
                    IsCliAtp( aGet, aTmp, oGetArticulo, dbfCliAtp, nMode, oSayPr1, oSayPr2, oSayVp1, oSayVp2, oCosto ),;
                    .f. ) ) ;
         OF       ::oFld:aDialogs[1]

      REDEFINE GET oSayVp1 VAR cSayVp1;
         ID       251 ;
         WHEN     .f. ;
         OF       ::oFld:aDialogs[1]

      REDEFINE SAY oSayPr2 VAR cSayPr2;
         ID       999 ;
         OF       ::oFld:aDialogs[1]

      REDEFINE GET aGet[ _acValPr2 ] VAR aTmp[ _acValPr2 ];
         ID       260 ;
         BITMAP   "LUPA" ;
         WHEN     ( nMode == APPD_MODE ) ;
         ON HELP  ( brwPrpAct( aGet[ _acValPr2 ], oSayVp2, aTmp[ _acCodPr2 ] ) ) ;
         VALID    ( if( lPrpAct( aGet[ _acValPr2 ], oSayVp2, aTmp[ _acCodPr2 ], dbfProL ),;
                    IsCliAtp( aGet, aTmp, oGetArticulo, dbfCliAtp, nMode, oSayPr1, oSayPr2, oSayVp1, oSayVp2, oCosto ),;
                    .f. ) ) ;
         OF       ::oFld:aDialogs[1]

      REDEFINE GET oSayVp2 VAR cSayVp2;
         ID       261 ;
         WHEN     .f. ;
         OF       ::oFld:aDialogs[1]

      REDEFINE GET aGet[ _aNPRCCOM ] VAR aTmp[ _aNPRCCOM ];
         ID       120 ;
         WHEN     ( aTmp[ _aNTIPATP ] <= 1 .and. nMode != ZOOM_MODE );
         ON CHANGE( lArrayRen( oSobre:nAt, oBrwRen, aTmp, aTmpCli, aGetCli, cCosto ) );
         VALID    ( lArrayRen( oSobre:nAt, oBrwRen, aTmp, aTmpCli, aGetCli, cCosto ) );
         SPINNER  ;
         PICTURE  cPinDiv ;
         OF       ::oFld:aDialogs[1]

      REDEFINE CHECKBOX aGet[ _aLPRCCOM ] VAR aTmp[ _aLPRCCOM ] ;
         ID       122 ;
         ON CHANGE( lChangeCostoParticular( aGet, aTmp, oCosto, nMode ) );
         WHEN     ( aTmp[ _aNTIPATP ] <= 1 .and. nMode != ZOOM_MODE ) ;
         OF       ::oFld:aDialogs[ 1 ]

      REDEFINE GET oCosto VAR cCosto;
         ID       123 ;
         WHEN     ( .f. );
         SPINNER  ;
         PICTURE  cPinDiv ;
         OF       ::oFld:aDialogs[ 1 ]

      REDEFINE GET aGet[ _aNPRCART ] VAR aTmp[ _aNPRCART ];
         ID       121 ;
         SPINNER  ;
         PICTURE  cPouDiv ;
         WHEN     ( aTmp[ _aNTIPATP ] <= 1 .and. nMode != ZOOM_MODE .and. !( dbfArticulo )->lIvaInc );
         VALID    ( CalIva( aTmp[ _aNPRCART ], ( dbfArticulo )->lIvaInc, ( dbfArticulo )->TipoIva, ( dbfArticulo )->cCodImp, aGet[ _aNPREIVA1 ] ), lArrayRen( oSobre:nAt, oBrwRen, aTmp, aTmpCli, aGetCli, cCosto ) );
         ON CHANGE( lArrayRen( oSobre:nAt, oBrwRen, aTmp, aTmpCli, aGetCli, cCosto ) );
         OF       ::oFld:aDialogs[1]

      REDEFINE GET aGet[ _aNPRCART2 ] VAR aTmp[ _aNPRCART2 ];
         ID       124 ;
         SPINNER  ;
         PICTURE  cPouDiv ;
         WHEN     ( aTmp[ _aNTIPATP ] <= 1 .and. nMode != ZOOM_MODE .and. !( dbfArticulo )->lIvaInc );
         VALID    ( CalIva( aTmp[ _aNPRCART2 ], ( dbfArticulo )->lIvaInc, ( dbfArticulo )->TipoIva, ( dbfArticulo )->cCodImp, aGet[ _aNPREIVA2 ] ), lArrayRen( oSobre:nAt, oBrwRen, aTmp, aTmpCli, aGetCli, cCosto ) );
         ON CHANGE( lArrayRen( oSobre:nAt, oBrwRen, aTmp, aTmpCli, aGetCli, cCosto ) );
         OF       ::oFld:aDialogs[1]

      REDEFINE GET aGet[ _aNPRCART3 ] VAR aTmp[ _aNPRCART3 ];
         ID       125 ;
         SPINNER  ;
         PICTURE  cPouDiv ;
         WHEN     ( aTmp[ _aNTIPATP ] <= 1 .and. nMode != ZOOM_MODE .and. !( dbfArticulo )->lIvaInc );
         VALID    ( CalIva( aTmp[ _aNPRCART3 ], ( dbfArticulo )->lIvaInc, ( dbfArticulo )->TipoIva, ( dbfArticulo )->cCodImp, aGet[ _aNPREIVA3 ] ), lArrayRen( oSobre:nAt, oBrwRen, aTmp, aTmpCli, aGetCli, cCosto ) );
         ON CHANGE( lArrayRen( oSobre:nAt, oBrwRen, aTmp, aTmpCli, aGetCli, cCosto ) );
         OF       ::oFld:aDialogs[1]

      REDEFINE GET aGet[ _aNPRCART4 ] VAR aTmp[ _aNPRCART4 ];
         ID       126 ;
         SPINNER  ;
         PICTURE  cPouDiv ;
         WHEN     ( aTmp[ _aNTIPATP ] <= 1 .and. nMode != ZOOM_MODE .and. !( dbfArticulo )->lIvaInc );
         VALID    ( CalIva( aTmp[ _aNPRCART4 ], ( dbfArticulo )->lIvaInc, ( dbfArticulo )->TipoIva, ( dbfArticulo )->cCodImp, aGet[ _aNPREIVA4 ] ), lArrayRen( oSobre:nAt, oBrwRen, aTmp, aTmpCli, aGetCli, cCosto ) );
         ON CHANGE( lArrayRen( oSobre:nAt, oBrwRen, aTmp, aTmpCli, aGetCli, cCosto ) );
         OF       ::oFld:aDialogs[1]

      REDEFINE GET aGet[ _aNPRCART5 ] VAR aTmp[ _aNPRCART5 ];
         ID       127 ;
         SPINNER  ;
         PICTURE  cPouDiv ;
         WHEN     ( aTmp[ _aNTIPATP ] <= 1 .and. nMode != ZOOM_MODE .and. !( dbfArticulo )->lIvaInc );
         VALID    ( CalIva( aTmp[ _aNPRCART5 ], ( dbfArticulo )->lIvaInc, ( dbfArticulo )->TipoIva, ( dbfArticulo )->cCodImp, aGet[ _aNPREIVA5 ] ), lArrayRen( oSobre:nAt, oBrwRen, aTmp, aTmpCli, aGetCli, cCosto ) );
         ON CHANGE( lArrayRen( oSobre:nAt, oBrwRen, aTmp, aTmpCli, aGetCli, cCosto ) );
         OF       ::oFld:aDialogs[1]

      REDEFINE GET aGet[ _aNPRCART6 ] VAR aTmp[ _aNPRCART6 ];
         ID       128 ;
         SPINNER  ;
         PICTURE  cPouDiv ;
         WHEN     ( aTmp[ _aNTIPATP ] <= 1 .and. nMode != ZOOM_MODE .and. !( dbfArticulo )->lIvaInc );
         VALID    ( CalIva( aTmp[ _aNPRCART6 ], ( dbfArticulo )->lIvaInc, ( dbfArticulo )->TipoIva, ( dbfArticulo )->cCodImp, aGet[ _aNPREIVA6 ] ),lArrayRen( oSobre:nAt, oBrwRen, aTmp, aTmpCli, aGetCli, cCosto ) );
         ON CHANGE( lArrayRen( oSobre:nAt, oBrwRen, aTmp, aTmpCli, aGetCli, cCosto ) );
         OF       ::oFld:aDialogs[1]
*/
      /*
      Precios con impuestos
      */
/*
      REDEFINE GET aGet[ _aNPREIVA1 ] VAR aTmp[ _aNPREIVA1 ] ;
         ID       300 ;
         SPINNER ;
         PICTURE  cPouDiv ;
         WHEN     ( aTmp[ _aNTIPATP ] <= 1 .AND. nMode != ZOOM_MODE .and. ( dbfArticulo )->lIvaInc ) ;
         VALID    ( CalBas( aTmp[ _aNPREIVA1 ], ( dbfArticulo )->lIvaInc, ( dbfArticulo )->TipoIva, ( dbfArticulo )->cCodImp, aGet[ _aNPRCART ] ), lArrayRen( oSobre:nAt, oBrwRen, aTmp, aTmpCli, aGetCli, cCosto ) );
         ON CHANGE( lArrayRen( oSobre:nAt, oBrwRen, aTmp, aTmpCli, aGetCli, cCosto ) );
         OF       ::oFld:aDialogs[1]

      REDEFINE GET aGet[ _aNPREIVA2 ] VAR aTmp[ _aNPREIVA2 ] ;
         ID       310 ;
         PICTURE  cPouDiv ;
         SPINNER ;
         WHEN     ( aTmp[ _aNTIPATP ] <= 1 .AND. nMode != ZOOM_MODE .and. ( dbfArticulo )->lIvaInc ) ;
         VALID    ( CalBas( aTmp[ _aNPREIVA2 ], ( dbfArticulo )->lIvaInc, ( dbfArticulo )->TipoIva, ( dbfArticulo )->cCodImp, aGet[ _aNPRCART2 ] ), lArrayRen( oSobre:nAt, oBrwRen, aTmp, aTmpCli, aGetCli, cCosto ) );
         ON CHANGE( lArrayRen( oSobre:nAt, oBrwRen, aTmp, aTmpCli, aGetCli, cCosto ) );
         OF       ::oFld:aDialogs[1]

      REDEFINE GET aGet[ _aNPREIVA3 ] VAR aTmp[ _aNPREIVA3 ] ;
         ID       320 ;
         SPINNER ;
         PICTURE  cPouDiv ;
         WHEN     ( aTmp[ _aNTIPATP ] <= 1 .AND. nMode != ZOOM_MODE .and. ( dbfArticulo )->lIvaInc ) ;
         VALID    ( CalBas( aTmp[ _aNPREIVA3 ], ( dbfArticulo )->lIvaInc, ( dbfArticulo )->TipoIva, ( dbfArticulo )->cCodImp, aGet[ _aNPRCART3 ] ), lArrayRen( oSobre:nAt, oBrwRen, aTmp, aTmpCli, aGetCli, cCosto ) );
         ON CHANGE( lArrayRen( oSobre:nAt, oBrwRen, aTmp, aTmpCli, aGetCli, cCosto ) );
         OF       ::oFld:aDialogs[1]

      REDEFINE GET aGet[ _aNPREIVA4 ] VAR aTmp[ _aNPREIVA4 ] ;
         ID       330 ;
         SPINNER ;
         PICTURE  cPouDiv ;
         WHEN     ( aTmp[ _aNTIPATP ] <= 1 .AND. nMode != ZOOM_MODE .and. ( dbfArticulo )->lIvaInc ) ;
         VALID    ( CalBas( aTmp[ _aNPREIVA4 ], ( dbfArticulo )->lIvaInc, ( dbfArticulo )->TipoIva, ( dbfArticulo )->cCodImp, aGet[ _aNPRCART4 ] ), lArrayRen( oSobre:nAt, oBrwRen, aTmp, aTmpCli, aGetCli, cCosto ) );
         ON CHANGE( lArrayRen( oSobre:nAt, oBrwRen, aTmp, aTmpCli, aGetCli, cCosto ) );
         OF       ::oFld:aDialogs[1]

      REDEFINE GET aGet[ _aNPREIVA5 ] VAR aTmp[ _aNPREIVA5 ] ;
         ID       340 ;
         SPINNER ;
         PICTURE  cPouDiv ;
         WHEN     ( aTmp[ _aNTIPATP ] <= 1 .AND. nMode != ZOOM_MODE .and. ( dbfArticulo )->lIvaInc ) ;
         VALID    ( CalBas( aTmp[ _aNPREIVA5 ], ( dbfArticulo )->lIvaInc, ( dbfArticulo )->TipoIva, ( dbfArticulo )->cCodImp, aGet[ _aNPRCART5 ] ), lArrayRen( oSobre:nAt, oBrwRen, aTmp, aTmpCli, aGetCli, cCosto ) );
         ON CHANGE( lArrayRen( oSobre:nAt, oBrwRen, aTmp, aTmpCli, aGetCli, cCosto ) );
         OF       ::oFld:aDialogs[1]

      REDEFINE GET aGet[ _aNPREIVA6 ] VAR aTmp[ _aNPREIVA6 ] ;
         ID       350 ;
         SPINNER ;
         PICTURE  cPouDiv ;
         WHEN     ( aTmp[ _aNTIPATP ] <= 1 .AND. nMode != ZOOM_MODE .and. ( dbfArticulo )->lIvaInc ) ;
         VALID    ( CalBas( aTmp[ _aNPREIVA6 ], ( dbfArticulo )->lIvaInc, ( dbfArticulo )->TipoIva, ( dbfArticulo )->cCodImp, aGet[ _aNPRCART6 ] ), lArrayRen( oSobre:nAt, oBrwRen, aTmp, aTmpCli, aGetCli, cCosto ) );
         ON CHANGE( lArrayRen( oSobre:nAt, oBrwRen, aTmp, aTmpCli, aGetCli, cCosto ) );
         OF       ::oFld:aDialogs[1]

      REDEFINE GET aGet[ _aNDTOART ] VAR aTmp[ _aNDTOART ];
			ID 		130 ;
         WHEN     ( nMode != ZOOM_MODE );
			SPINNER ;
         VALID    ( ( aTmp[_aNDTOART] >= 0 .AND. aTmp[_aNDTOART] <= 100 ), lArrayRen( oSobre:nAt, oBrwRen, aTmp, aTmpCli, aGetCli, cCosto ))  ;
         ON CHANGE( lArrayRen( oSobre:nAt, oBrwRen, aTmp, aTmpCli, aGetCli, cCosto ) );
         PICTURE  "@E 999.99";
         OF       ::oFld:aDialogs[1]

      REDEFINE GET aGet[ _aNDTODIV ] VAR aTmp[ _aNDTODIV ];
         ID       135 ;
         WHEN     ( nMode != ZOOM_MODE );
         SPINNER ;
         ON CHANGE( lArrayRen( oSobre:nAt, oBrwRen, aTmp, aTmpCli, aGetCli, cCosto ) );
         VALID    ( lArrayRen( oSobre:nAt, oBrwRen, aTmp, aTmpCli, aGetCli, cCosto ) );
         PICTURE  cPouDiv ;
         OF       ::oFld:aDialogs[1]

      REDEFINE GET aGet[_aNDPRART] VAR aTmp[_aNDPRART];
         ID       601 ;
         WHEN     ( nMode != ZOOM_MODE );
			SPINNER ;
         VALID    ( ( aTmp[_aNDPRART] >= 0 .AND. aTmp[_aNDPRART] <= 100 ), lArrayRen( oSobre:nAt, oBrwRen, aTmp, aTmpCli, aGetCli, cCosto ) ) ;
         ON CHANGE( lArrayRen( oSobre:nAt, oBrwRen, aTmp, aTmpCli, aGetCli, cCosto ) );
         PICTURE  "@E 999.99";
         OF       ::oFld:aDialogs[1]

      REDEFINE CHECKBOX aTmp[ _aLCOMAGE ] ;
         ID       151 ;
         ON CHANGE( lArrayRen( oSobre:nAt, oBrwRen, aTmp, aTmpCli, aGetCli, cCosto ) );
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       ::oFld:aDialogs[1]

      REDEFINE GET aGet[ _aNCOMAGE ] VAR aTmp[ _aNCOMAGE ];
			ID 		150 ;
         WHEN     ( nMode != ZOOM_MODE );
			SPINNER ;
         VALID    ( ( aTmp[_aNCOMAGE] >= 0 .AND. aTmp[_aNCOMAGE] <= 100 ), lArrayRen( oSobre:nAt, oBrwRen, aTmp, aTmpCli, aGetCli, cCosto ) ) ;
         ON CHANGE( lArrayRen( oSobre:nAt, oBrwRen, aTmp, aTmpCli, aGetCli, cCosto ) );
         PICTURE  "@E 999.99";
         OF       ::oFld:aDialogs[1]

      REDEFINE GROUP oSayLabels[ 1 ]   ID 700 OF ::oFld:aDialogs[ 1 ] TRANSPARENT
      REDEFINE GROUP oSayLabels[ 2 ]   ID 701 OF ::oFld:aDialogs[ 1 ] TRANSPARENT
      REDEFINE GROUP oSayLabels[ 3 ]   ID 702 OF ::oFld:aDialogs[ 1 ] TRANSPARENT
      REDEFINE SAY   oSayLabels[ 4 ]   ID 703 OF ::oFld:aDialogs[ 1 ]
      REDEFINE SAY   oSayLabels[ 5 ]   ID 704 OF ::oFld:aDialogs[ 1 ]
      REDEFINE SAY   oSayLabels[ 6 ]   ID 705 OF ::oFld:aDialogs[ 1 ]
      REDEFINE SAY   oSayLabels[ 7 ]   ID 706 OF ::oFld:aDialogs[ 1 ]
      REDEFINE SAY   oSayLabels[ 8 ]   ID 707 OF ::oFld:aDialogs[ 1 ]
      REDEFINE SAY   oSayLabels[ 9 ]   ID 708 OF ::oFld:aDialogs[ 1 ]
      REDEFINE SAY   oSayLabels[ 10]   ID 709 OF ::oFld:aDialogs[ 1 ]
      REDEFINE SAY   oSayLabels[ 11]   ID 710 OF ::oFld:aDialogs[ 1 ]
      REDEFINE SAY   oSayLabels[ 12]   ID 711 OF ::oFld:aDialogs[ 1 ]
      REDEFINE SAY   oSayLabels[ 13]   ID 712 OF ::oFld:aDialogs[ 1 ]
      REDEFINE SAY   oSayLabels[ 14]   ID 713 OF ::oFld:aDialogs[ 1 ]
      REDEFINE SAY   oSayLabels[ 15]   ID 714 OF ::oFld:aDialogs[ 1 ]
      REDEFINE GROUP oSayLabels[ 16]   ID 715 OF ::oFld:aDialogs[ 1 ] TRANSPARENT

      REDEFINE GET aGet[ _aNDTO1 ] VAR aTmp[ _aNDTO1 ];
         ID       400 ;
         WHEN     ( nMode != ZOOM_MODE );
			SPINNER ;
         VALID    ( ( aTmp[ _aNDTO1 ] >= 0 .AND. aTmp[ _aNDTO1 ] <= 100 ) ) ;
         PICTURE  "@E 999.99";
         OF       ::oFld:aDialogs[1]

      REDEFINE GET aGet[ _aNDTO2 ] VAR aTmp[ _aNDTO2 ];
         ID       410 ;
         WHEN     ( nMode != ZOOM_MODE );
			SPINNER ;
         VALID    ( ( aTmp[ _aNDTO2 ] >= 0 .AND. aTmp[ _aNDTO2 ] <= 100 ) ) ;
         PICTURE  "@E 999.99";
         OF       ::oFld:aDialogs[1]

      REDEFINE GET aGet[ _aNDTO3 ] VAR aTmp[ _aNDTO3 ];
         ID       420 ;
         WHEN     ( nMode != ZOOM_MODE );
			SPINNER ;
         VALID    ( ( aTmp[ _aNDTO3 ] >= 0 .AND. aTmp[ _aNDTO3 ] <= 100 ) ) ;
         PICTURE  "@E 999.99";
         OF       ::oFld:aDialogs[1]

      REDEFINE GET aGet[ _aNDTO4 ] VAR aTmp[ _aNDTO4 ];
         ID       430 ;
         WHEN     ( nMode != ZOOM_MODE );
			SPINNER ;
         VALID    ( ( aTmp[ _aNDTO4 ] >= 0 .AND. aTmp[ _aNDTO4 ] <= 100 ) ) ;
         PICTURE  "@E 999.99";
         OF       ::oFld:aDialogs[1]

      REDEFINE GET aGet[ _aNDTO5 ] VAR aTmp[ _aNDTO5 ];
         ID       440 ;
         WHEN     ( nMode != ZOOM_MODE );
			SPINNER ;
         VALID    ( ( aTmp[ _aNDTO5 ] >= 0 .AND. aTmp[ _aNDTO5 ] <= 100 ) ) ;
         PICTURE  "@E 999.99";
         OF       ::oFld:aDialogs[1]

      REDEFINE GET aGet[ _aNDTO6 ] VAR aTmp[ _aNDTO6 ];
         ID       450 ;
         WHEN     ( nMode != ZOOM_MODE );
			SPINNER ;
         VALID    ( ( aTmp[ _aNDTO6 ] >= 0 .AND. aTmp[ _aNDTO6 ] <= 100 ) ) ;
         PICTURE  "@E 999.99";
         OF       ::oFld:aDialogs[1]
*/
      /*
      Segunda caja de dialogo--------------------------------------------------
      */
/*
      REDEFINE GET aGet[ _aDFECINI ] VAR aTmp[ _aDFECINI ];
         ID       160 ;
         WHEN     ( nMode != ZOOM_MODE );
         SPINNER ;
         OF       ::oFld:aDialogs[2]

      REDEFINE GET aGet[ _aDFECFIN ] VAR aTmp[ _aDFECFIN ];
         ID       170 ;
         WHEN     ( nMode != ZOOM_MODE );
         SPINNER ;
         OF       ::oFld:aDialogs[2]

      REDEFINE CHECKBOX aTmp[ _aLAPLPRE ] ;
         ID       180 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       ::oFld:aDialogs[2]

      REDEFINE CHECKBOX aTmp[ _aLAPLPED ] ;
         ID       190 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       ::oFld:aDialogs[2]

      REDEFINE CHECKBOX aTmp[ _aLAPLALB ] ;
         ID       200 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       ::oFld:aDialogs[2]

      REDEFINE CHECKBOX aTmp[ _aLAPLFAC ] ;
         ID       210 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       ::oFld:aDialogs[2]

      REDEFINE CHECKBOX aTmp[ _aLAPLSAT ] ;
         ID       250 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       ::oFld:aDialogs[2]   
*/
      /*
      Ofertas de X*Y
      */
/*
      REDEFINE RADIO aGet[ _aNTIPXBY ] VAR aTmp[ _aNTIPXBY ] ;
         WHEN     ( aTmp[ _aNTIPATP ] <= 1 .and. nMode != ZOOM_MODE ) ;
         ON CHANGE( lArrayRen( oSobre:nAt, oBrwRen, aTmp, aTmpCli, aGetCli, cCosto ) );
         ID       220, 221 ;
         OF       ::oFld:aDialogs[2]

      REDEFINE GET aGet[ _aNUNVOFE ] VAR aTmp[ _aNUNVOFE ] ;
         ID       230 ;
         PICTURE  "@E 999" ;
         SPINNER ;
         WHEN     ( aTmp[ _aNTIPATP ] <= 1 .and. nMode != ZOOM_MODE ) ;
         VALID    ( isBig( aTmp[ _aNUNVOFE ], aTmp[ _aNUNCOFE ] ), lArrayRen( oSobre:nAt, oBrwRen, aTmp, aTmpCli, aGetCli, cCosto ) ) ;
         ON CHANGE( lArrayRen( oSobre:nAt, oBrwRen, aTmp, aTmpCli, aGetCli, cCosto ) );
         OF       ::oFld:aDialogs[2]

      REDEFINE GET aGet[ _aNUNCOFE ] VAR aTmp[ _aNUNCOFE ] ;
         ID       240 ;
         PICTURE  "@E 999" ;
         SPINNER ;
         WHEN     ( aTmp[ _aNTIPATP ] <= 1 .and.  nMode != ZOOM_MODE ) ;
         VALID    ( isBig( aTmp[ _aNUNVOFE ], aTmp[ _aNUNCOFE ] ), lArrayRen( oSobre:nAt, oBrwRen, aTmp, aTmpCli, aGetCli, cCosto ) ) ;
         ON CHANGE( lArrayRen( oSobre:nAt, oBrwRen, aTmp, aTmpCli, aGetCli, cCosto ) );
         OF       ::oFld:aDialogs[2]
*/
      /*
      Estudio rentabilidad - segunda pestaña-----------------------------------
      */
/*
      REDEFINE COMBOBOX oSobre VAR cSobre ;
         ITEMS    aSobre ;
         ID       400 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         COLOR    CLR_GET ;
         OF       oDlg

      oSobre:bChange := {|| lArrayRen( oSobre:nAt, oBrwRen, aTmp, aTmpCli, aGetCli, cCosto ) }

      REDEFINE LISTBOX oBrwRen ;
			FIELDS ;
                  if( aRentabilidad[ oBrwRen:nAt, 5 ], LoadBitmap( GetResources(), "BALERT" ), "" ) ,;
                  aRentabilidad[ oBrwRen:nAt, 1 ],;
                  aRentabilidad[ oBrwRen:nAt, 2 ],;
                  if( !aRentabilidad[ oBrwRen:nAt, 4 ], Trans( aRentabilidad[ oBrwRen:nAt, 3 ], cPouEmp ), Trans( aRentabilidad[ oBrwRen:nAt, 3 ], "999.99" ) + " %" ),;
                  if( !aRentabilidad[ oBrwRen:nAt, 4 ], Trans( nCnv2Div( aRentabilidad[ oBrwRen:nAt, 3 ], cDivEmp(), cDivChg(), dbfDiv ), cPouChg ), "" ),;
                  "";
         HEAD ;
                  "",;
                  "Naturaleza",;
                  "Tipo",;
                  "Importe " + cDivEmp(),;
                  "Importe " + cDivChg(),;
                  "";
			FIELDSIZES;
                  16,;
                  97,;
                  48,;
                  70,;
                  70,;
                  10;
         ID       450 ;
         OF       oDlg

         oBrwRen:SetArray( aRentabilidad )
         oBrwRen:nClrText       := { || if( aRentabilidad[ oBrwRen:nAt, 3 ] < 0 , CLR_HRED, CLR_BLACK ) }
         oBrwRen:aJustify       := { .f., .f., .t., .t., .t., .f. }
*/
      /*
      Botones comunes de la caja de diálogo
      */

      REDEFINE BUTTON ::oBtnExpandir ;
         ID       600 ;
         OF       ::oDlg ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( ::Expandir() ) // lExpandir( oDlg, oBtnRen ), lArrayRen( oSobre:nAt, oBrwRen, aTmp, aTmpCli, aGetCli, cCosto ) )

      REDEFINE BUTTON ;
         ID       500 ;
         OF       ::oDlg ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( ::Save() ) // SaveEdtAtp( aGet, aTmp, dbfTmpAtp, oBrw, oDlg, nMode ) )

      REDEFINE BUTTON ;
         ID       550 ;
         OF       ::oDlg ;
         CANCEL ;
         ACTION   ( ::oDlg:end() )

   if nMode != ZOOM_MODE
      ::oDlg:AddFastKey( VK_F5, {|| ::Save() } )
   end if

   ::oDlg:bStart    := {|| ::Start() } //  StartEdtAtp( aTmp, aGet, nMode, oSayPr1, oSayPr2, oSayVp1, oSayVp2, oGetArticulo, oGetFamilia, oSayLabels, oCosto, oBtnRen ) }

   ACTIVATE DIALOG ::oDlg CENTER ;
         //ON INIT  ( lExpandir( oDlg, oBtnRen, .f. ), if( nMode != APPD_MODE, aGet[ _acCodArt ]:lValid(), ), EdtDetMenu( aGet[ _acCodArt ], oDlg, lArticuloEnOferta( aTmp[ _acCodArt ], aTmpCli[ _COD ], aTmpCli[ _CCODGRP ] ) ) )

RETURN ( ::oDlg:nResult == IDOK )

//---------------------------------------------------------------------------//

METHOD ButtonAppend( Id, oDialog )

   REDEFINE BUTTON  ;
      ID       ( Id ) ;
      OF       ( oDialog ) ;
      WHEN     ( oUser():lCambiarPrecio() ) ;
      ACTION   ( ::Append( ::oBrwAtipica ) )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD ButtonEdit( Id, oDialog )

   REDEFINE BUTTON  ;
      ID       ( Id ) ;
      OF       ( oDialog ) ;
      WHEN     ( oUser():lCambiarPrecio() ) ;
      ACTION   ( ::Edit( ::oBrwAtipica ) )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD ButtonDel( Id, oDialog )

   REDEFINE BUTTON  ;
      ID       ( Id ) ;
      OF       ( oDialog ) ;
      WHEN     ( oUser():lCambiarPrecio() ) ;
      ACTION   ( ::Del( ::oBrwAtipica ) )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD Browse( Id, oDialog )

   ::oBrwAtipica                 := IXBrowse():New( oDialog )

   ::oBrwAtipica:bClrSel         := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
   ::oBrwAtipica:bClrSelFocus    := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }
   
   ::oBrwAtipica:nMarqueeStyle   := 6
   ::oBrwAtipica:cName           := "Clientes.Atipicas"

   ::oDbfVir:SetBrowse( ::oBrwAtipica )

   with object ( ::oBrwAtipica:AddCol() )
      :cHeader          := "Tipo"
      :bEditValue       := {|| if( ::oDbfVir:nTipAtp <= 1, "Artículo", "Familia" ) }
      :nWidth           := 60
   end with

   with object ( ::oBrwAtipica:AddCol() )
      :cHeader          := "Of. Artículo en oferta"
      :bEditValue       := {|| ::oDbfVir:nTipAtp <= 1 } // .and. lArticuloEnOferta( ::oDbfVir:cCodArt, ( dbfClient )->Cod, ( dbfClient )->cCodGrp ) }
      :nWidth           := 20
      :SetCheck( { "Sel16", "Nil16" } )
   end with

   with object ( ::oBrwAtipica:AddCol() )
      :cHeader          := "Código"
      :bEditValue       := {|| if( ::oDbfVir:nTipAtp <= 1, ::oDbfVir:cCodArt, ::oDbfVir:cCodFam ) }
      :nWidth           := 80
   end with

   with object ( ::oBrwAtipica:AddCol() )
      :cHeader          := "Nombre"
      :bEditValue       := {|| if( ::oDbfVir:nTipAtp <= 1, retArticulo( ::oDbfVir:cCodArt, TDataCenter():Get( "Articulo" ) ), retFamilia( ::oDbfVir:cCodFam, TDataCenter():Get( "Familia" ) ) ) }
      :nWidth           := 160
   end with
   
   with object ( ::oBrwAtipica:AddCol() )
      :cHeader          := "Prop.1"
      :bEditValue       := {|| ::oDbfVir:cValPr1 }
      :nWidth           := 40
      :lHide            := .t.
   end with
   
   with object ( ::oBrwAtipica:AddCol() )
      :cHeader          := "Prop.2"
      :bEditValue       := {|| ::oDbfVir:cValPr2 }
      :nWidth           := 40
      :lHide            := .t.
   end with
   
   with object ( ::oBrwAtipica:AddCol() )
      :cHeader          := uFieldEmpresa( "cTxtTar1", "Precio 1" )
      :bEditValue       := {|| ::oDbfVir:nPrcArt }
      :cEditPicture     := ::cRoundPrice
      :nWidth           := 80
      :nDataStrAlign    := AL_RIGHT
      :nHeadStrAlign    := AL_RIGHT
   end with
   
   with object ( ::oBrwAtipica:AddCol() )
      :cHeader          := uFieldEmpresa( "cTxtTar2", "Precio 2" )
      :bEditValue       := {|| ::oDbfVir:nPrcArt2 }
      :cEditPicture     := ::cRoundPrice
      :nWidth           := 80
      :nDataStrAlign    := AL_RIGHT
      :nHeadStrAlign    := AL_RIGHT
   end with

   with object ( ::oBrwAtipica:AddCol() )
      :cHeader          := uFieldEmpresa( "cTxtTar3", "Precio 3" )
      :bEditValue       := {|| ::oDbfVir:nPrcArt3 }
      :cEditPicture     := ::cRoundPrice
      :nWidth           := 80
      :nDataStrAlign    := AL_RIGHT
      :nHeadStrAlign    := AL_RIGHT
   end with
   
   with object ( ::oBrwAtipica:AddCol() )
      :cHeader          := uFieldEmpresa( "cTxtTar4", "Precio 4" )
      :bEditValue       := {|| ::oDbfVir:nPrcArt4 }
      :cEditPicture     := ::cRoundPrice
      :nWidth           := 80
      :nDataStrAlign    := AL_RIGHT
      :nHeadStrAlign    := AL_RIGHT
   end with
   
   with object ( ::oBrwAtipica:AddCol() )
      :cHeader          := uFieldEmpresa( "cTxtTar5", "Precio 5" )
      :bEditValue       := {|| ::oDbfVir:nPrcArt5 }
      :cEditPicture     := ::cRoundPrice
      :nWidth           := 80
      :nDataStrAlign    := AL_RIGHT
      :nHeadStrAlign    := AL_RIGHT
   end with
   
   with object ( ::oBrwAtipica:AddCol() )
      :cHeader          := uFieldEmpresa( "cTxtTar6", "Precio 6" )
      :bEditValue       := {|| ::oDbfVir:nPrcArt6 }
      :cEditPicture     := ::cRoundPrice
      :nWidth           := 80
      :nDataStrAlign    := AL_RIGHT
      :nHeadStrAlign    := AL_RIGHT
   end with
   
   with object ( ::oBrwAtipica:AddCol() )
      :cHeader          := "% Descuento"
      :bEditValue       := {|| ::oDbfVir:nDtoArt }
      :cEditPicture     := "@E 999.99"
      :nWidth           := 80
      :nDataStrAlign    := AL_RIGHT
      :nHeadStrAlign    := AL_RIGHT
   end with
   
   with object ( ::oBrwAtipica:AddCol() )
      :cHeader          := "Descuento lineal"
      :bEditValue       := {|| ::oDbfVir:nDtoDiv }
      :cEditPicture     := ::cRoundPrice
      :nWidth           := 80
      :nDataStrAlign    := AL_RIGHT
      :nHeadStrAlign    := AL_RIGHT
   end with
   
   with object ( ::oBrwAtipica:AddCol() )
      :cHeader          := "% Agente"
      :bEditValue       := {|| ::oDbfVir:nComAge }
      :cEditPicture     := "@E 999.99"
      :nWidth           := 80
      :nDataStrAlign    := AL_RIGHT
      :nHeadStrAlign    := AL_RIGHT
   end with
   
   with object ( ::oBrwAtipica:AddCol() )
      :cHeader          := "Inicio"
      :bEditValue       := {|| ::oDbfVir:dFecIni }
      :nWidth           := 80
   end with
   
   with object ( ::oBrwAtipica:AddCol() )
      :cHeader          := "Fin"
      :bEditValue       := {|| ::oDbfVir:dFecFin }
      :nWidth           := 80
   end with

   if oUser():lCambiarPrecio() 
      ::oBrwAtipica:bLDblClick   := {|| MsgStop( "Edicion de atipicas" ) }
   end if

   ::oBrwAtipica:bRClicked       := {| nRow, nCol, nFlags | ::oBrwAtipica:RButtonDown( nRow, nCol, nFlags ) }

   ::oBrwAtipica:CreateFromResource( Id )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD LoadAtipica()

   if Empty( ::cCodigoArticulo )
      ::oNombreArticulo:cText( "" )
      Return ( .t. )
   end if

   if ::nMode == APPD_MODE

      if ( TDataCenter():Get( "Articulo" ) )->( dbSeek( ::cCodigoArticulo ) )

         ::oNombreArticulo:cText( ( TDataCenter():Get( "Articulo" ) )->Nombre )

      else

         Return ( .f. )

      end if

   end if

RETURN ( .t. )

//--------------------------------------------------------------------------//

