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
   
   DATA lExpandida         INIT .f.
   DATA oBtnExpandir

   DATA oBrwAtipica
   DATA oBrwRentabilidad

   DATA aRentabilidad      INIT {}

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

   DATA oTextoPrimeraPropiedad 
   DATA cTextoPrimeraPropiedad 

   DATA oCodigoPrimeraPropiedad 

   DATA oValorPrimeraPropiedad 
   DATA cValorPrimeraPropiedad 

   DATA oTextoSegundaPropiedad 
   DATA cTextoSegundaPropiedad 

   DATA oCodigoSegundaPropiedad 

   DATA oValorSegundaPropiedad 
   DATA cValorSegundaPropiedad 

   DATA oPrecioArticulo1   
   DATA oPrecioArticulo2   
   DATA oPrecioArticulo3   
   DATA oPrecioArticulo4   
   DATA oPrecioArticulo5   
   DATA oPrecioArticulo6   

   DATA oIvaArticulo1
   DATA oIvaArticulo2   
   DATA oIvaArticulo3
   DATA oIvaArticulo4
   DATA oIvaArticulo5   
   DATA oIvaArticulo6

   DATA oDescuento1
   DATA oDescuento2
   DATA oDescuento3
   DATA oDescuento4
   DATA oDescuento5
   DATA oDescuento6

   DATA oCodEnvase

   DATA oPrecioCompra
   DATA nPrecioCompra                  INIT 0

   DATA oChangeCostoParticular

   DATA oCostoParticular

   DATA oSayLabels                     INIT array( 16 )

   DATA oDescuentoPorcentualArticulo
   DATA oDescuentoLinealArticulo
   DATA oDescuentoPromocionArticulo

   DATA oComisionAgente

   DATA oOfertaXbY
   DATA oUnidadesVender
   DATa oUnidadesCobrar

   DATA oRentabilidadSobre
   DATA cRentabilidadSobre
   DATA aRentabilidadSobre             INIT { "Precio 1", "Precio 2", "Precio 3", "Precio 4", "Precio 5", "Precio 6" }

   METHOD Resource()
      METHOD StartResource()           INLINE ( MsgStop( "Start" ) )
      METHOD SaveResource()                 
      METHOD PreSaveDetail()           INLINE ( MsgStop( "PreSaveDetail" ) )

      METHOD WhenTipoArticulo()        INLINE ( ::oDbfVir:nTipAtp <= 1 .and. ::nMode != ZOOM_MODE ) 
      METHOD WhenOfertaXbY()           INLINE ( ::oDbfVir:nTipXby <= 1 .and. ::nMode != ZOOM_MODE )
      METHOD WhenTipoArticuloIva()     INLINE ( ::WhenTipoArticulo() .and. !( D():Get( "Articulo", ::View() ) )->lIvaInc ) 
      METHOD WhenTipoArticuloBase()    INLINE ( ::WhenTipoArticulo() .and. ( D():Get( "Articulo", ::View() ) )->lIvaInc ) 

      METHOD ChangeNaturaleza()
      METHOD lChangeCostoParticular()  INLINE ( if( ::oDbfVir:lPrcCom, ( ::oCostoParticular:Show(), ::oPrecioCompra:Hide() ), ( ::oCostoParticular:Hide(), ::oPrecioCompra:Show() ) ) )

      METHOD ShowPrimeraPropiedad()    INLINE ( ::oTextoPrimeraPropiedad:Show(), ::oValorPrimeraPropiedad:Show(), ::oCodigoPrimeraPropiedad:Show() )
      METHOD ShowSegundaPropiedad()    INLINE ( ::oTextoSegundaPropiedad:Show(), ::oValorSegundaPropiedad:Show(), ::oCodigoSegundaPropiedad:Show() )

      METHOD HidePrimeraPropiedad()    INLINE ( ::oTextoPrimeraPropiedad:Hide(), ::oValorPrimeraPropiedad:Hide(), ::oCodigoPrimeraPropiedad:Hide() )
      METHOD HideSegundaPropiedad()    INLINE ( ::oTextoSegundaPropiedad:Hide(), ::oValorSegundaPropiedad:Hide(), ::oCodigoSegundaPropiedad:Hide() )

      METHOD Expandir()

   METHOD ButtonAppend( Id, oDialog )
   METHOD ButtonEdit( Id, oDialog )
   METHOD ButtonDel( Id, oDialog )
   METHOD Browse( Id, oDialog )

   METHOD NombreArticulo()             INLINE ( retfld( ::oDbfVir:cCodArt, D():Get( "Articulo", ::View() ), "Nombre", "Codigo" ) )
   METHOD NombreFamilia()              INLINE ( retfld( ::oDbfVir:cCodFam, D():Get( "Familias", ::View() ), "cNomFam", "cCodFam" ) )

   METHOD LoadAtipica()

   METHOD CalculaRentabilidad()        
      METHOD AlertaRentabilidad()      INLINE ( hHasKey( ::aRentabilidad[ ::oBrwRentabilidad:nArrayAt ], "Alerta" ) .and. hGet( ::aRentabilidad[ ::oBrwRentabilidad:nArrayAt ], "Alerta" ) )
      METHOD NaturalezaRentabilidad()  INLINE ( hGet( ::aRentabilidad[ ::oBrwRentabilidad:nArrayAt ], "Naturaleza" ) )
      METHOD TipoRentabilidad()        INLINE ( hGet( ::aRentabilidad[ ::oBrwRentabilidad:nArrayAt ], "Tipo" ) )
      METHOD ImporteRentabilidad()     INLINE ( if (  hHasKey( ::aRentabilidad[ ::oBrwRentabilidad:nArrayAt ], "Porcentual" ) .and. hGet( ::aRentabilidad[ ::oBrwRentabilidad:nArrayAt ], "Porcentual" ),;
                                                      Trans( hGet( ::aRentabilidad[ ::oBrwRentabilidad:nArrayAt ], "Importe" ), "999.99" ) + " %",;
                                                      Trans( hGet( ::aRentabilidad[ ::oBrwRentabilidad:nArrayAt ], "Importe" ), cPouDiv() ) ) )
   
   METHOD CalculaIva()              
   METHOD CalculaBase()

   METHOD PrecioIva( nTarifa )
   METHOD PrecioBase( nTarifa )

   METHOD SetPrimeraPropiedad( cValue )
   METHOD SetSegundaPropiedad( cValue )

   METHOD View()                       INLINE ( ::oParent:View() )

   METHOD SaveDetails()
   METHOD DeleteDetails()

END CLASS

//---------------------------------------------------------------------------//

METHOD New( cPath, cDriver, oParent ) CLASS TAtipicas

   DEFAULT cPath        := cPatEmp()
   DEFAULT cDriver      := cDriver()

   ::cPath              := cPath
   ::cDriver            := cDriver
   ::oParent            := oParent

   ::bOnPreSaveDetail   := {|| ::SaveDetails() }
   ::bOnPreDelete       := {|| ::DeleteDetails() }

RETURN ( Self )
 
//---------------------------------------------------------------------------//

METHOD DefineFiles( cPath, cDriver, lUniqueName, cFileName ) CLASS TAtipicas

   local oDbf

   DEFAULT cPath        := ::cPath
   DEFAULT cDriver      := ::cDriver
   DEFAULT lUniqueName  := .f.
   DEFAULT cFileName    := "CliAtp"

   if lUniqueName
      cFileName         := cGetNewFileName( cFileName, , , cPath )
   end if

   DEFINE TABLE oDbf FILE ( cFileName ) CLASS ( cFileName ) ALIAS ( cFileName ) PATH ( cPath ) VIA ( cDriver ) COMMENT "Atipicas de clientes y grupos"

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
      FIELD NAME "cCodAge"    TYPE "C" LEN  3  DEC 0 COMMENT "Código del agente"                            OF oDbf
      FIELD NAME "cCodEnv"    TYPE "C" LEN  3  DEC 0 COMMENT "Código del envase"                            OF oDbf

      INDEX TO ( cFileName ) TAG "cCodCli" ON "cCodCli"                                                     NODELETED   OF oDbf
      INDEX TO ( cFileName ) TAG "cCodGrp" ON "cCodGrp"                                                     NODELETED   OF oDbf
      INDEX TO ( cFileName ) TAG "cCliArt" ON "cCodCli + cCodArt + cCodPr1 + cCodPr2 + cValPr1 + cValPr2"   NODELETED   OF oDbf
      INDEX TO ( cFileName ) TAG "cCodFam" ON "cCodCli + cCodFam"                                           NODELETED   OF oDbf
      INDEX TO ( cFileName ) TAG "cGrpArt" ON "cCodGrp + cCodArt + cCodPr1 + cCodPr2 + cValPr1 + cValPr2"   NODELETED   OF oDbf
      INDEX TO ( cFileName ) TAG "cGrpFam" ON "cCodGrp + cCodFam"                                           NODELETED   OF oDbf
      INDEX TO ( cFileName ) TAG "cCodAge" ON "cCodAge"                                                     NODELETED   OF oDbf
      INDEX TO ( cFileName ) TAG "cAgeArt" ON "cCodAge + cCodArt + cCodPr1 + cCodPr2 + cValPr1 + cValPr2"   NODELETED   OF oDbf

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

      ::cNombreArticulo := ""
      ::cNombreFamilia  := ""

   else

      ::cNaturaleza     := Max( Min( ::oDbfVir:nTipAtp, len( ::aNaturaleza ) ), 1 )

      ::cNombreArticulo := ::NombreArticulo()
      ::cNombreFamilia  := ::NombreFamilia()

      if !Empty( ::oDbfVir:cCodPr1 )
         ::cSayPr1      := retProp( ::oDbfVir:cCodPr1 )
         ::cSayVp1      := retValProp( ::oDbfVir:cCodPr1 + ::oDbfVir:cValPr1 )
      end if

      if !Empty( ::oDbfVir:cCodPr2 )
         ::cSayPr2      := retProp( ::oDbfVir:cCodPr2 )
         ::cSayVp2      := retValProp( ::oDbfVir:cCodPr2 + ::oDbfVir:cValPr2 )
      end if

   end if

   DEFINE DIALOG ::oDlg RESOURCE "CLIATP" TITLE LblTitle( nMode ) + "tarifas de clientes"

      REDEFINE FOLDER   ::oFld ;
         ID             100 ;
			OF             ::oDlg ;
         PROMPT         "&General" ,;
                        "A&mbito" ;
         DIALOGS        "CLIATP_0" ,;
                        "CLIATP_1" 

      REDEFINE COMBOBOX ::oNaturaleza ;
         VAR            ::cNaturaleza ;
         ITEMS          ::aNaturaleza ;
         ID             90 ;
         WHEN           ( nMode == APPD_MODE ) ;
			OF             ::oFld:aDialogs[1]

      ::oNaturaleza:bChange      := {|| ::ChangeNaturaleza() }

      REDEFINE GET      ::oCodigoArticulo ;
         VAR            ::oDbfVir:cCodArt ;
			ID             100 ;
         WHEN           ( ::nMode == APPD_MODE );
         BITMAP         "Lupa" ;
			OF             ::oFld:aDialogs[1]

      ::oCodigoArticulo:bHelp    := {|| BrwArticulo( ::oCodigoArticulo, ::oNombreArticulo ) }
      ::oCodigoArticulo:bChange  := {|| ::CalculaRentabilidad() }
      ::oCodigoArticulo:bValid   := {|| ::LoadAtipica() }

      REDEFINE GET      ::oNombreArticulo ;
         VAR            ::cNombreArticulo ;
			ID             110 ;
			WHEN           ( .f. );
         OF             ::oFld:aDialogs[1]

      REDEFINE GET      ::oCodigoFamilia ;
         VAR            ::oDbfVir:cCodFam;
         ID             105 ;
         WHEN           ( ::nMode == APPD_MODE );
         BITMAP         "LUPA" ;
         OF             ::oFld:aDialogs[1]

         ::oCodigoFamilia:bValid := {|| cFamilia( ::oCodigoFamilia, D():Get( "Familias", ::View() ), ::oNombreFamilia ) }
         ::oCodigoFamilia:bHelp  := {|| BrwFamilia( ::oCodigoFamilia, ::oNombreFamilia ) }

      REDEFINE GET      ::oNombreFamilia ;
         VAR            ::cNombreFamilia ;
         ID             106 ;
         WHEN           ( .f. );
         OF             ::oFld:aDialogs[1]

      /*
      Primera propiedad--------------------------------------------------------
      */

      REDEFINE SAY      ::oTextoPrimeraPropiedad ;
         VAR            ::cTextoPrimeraPropiedad ;
         ID             888 ;
         OF             ::oFld:aDialogs[1]

      REDEFINE GET      ::oCodigoPrimeraPropiedad ;
         VAR            ::oDbfVir:cValPr1 ;
         ID             250 ;
         BITMAP         "LUPA" ;
         WHEN           ( ::nMode == APPD_MODE ) ;
         OF             ::oFld:aDialogs[1]

         ::oCodigoPrimeraPropiedad:bHelp     := {|| brwPropiedadActual( ::oCodigoPrimeraPropiedad, ::oTextoPrimeraPropiedad, ::oDbfVir:cCodPr1 ) }
         ::oCodigoPrimeraPropiedad:bValid    := {|| ::LoadAtipica() }

      REDEFINE GET      ::oValorPrimeraPropiedad ;
         VAR            ::cValorPrimeraPropiedad ;
         ID             251 ;
         WHEN           .f. ;
         OF             ::oFld:aDialogs[1]

      /*
      segunda propiedad--------------------------------------------------------
      */

      REDEFINE SAY      ::oTextoSegundaPropiedad ;
         VAR            ::cTextoSegundaPropiedad ;
         ID             999 ;
         OF             ::oFld:aDialogs[1]

      REDEFINE GET      ::oCodigoSegundaPropiedad ;
         VAR            ::oDbfVir:cValPr2 ;
         ID             260 ;
         BITMAP         "LUPA" ;
         WHEN           ( ::nMode == APPD_MODE ) ;
         OF             ::oFld:aDialogs[1]

         ::oCodigoSegundaPropiedad:bHelp     := {|| brwPropiedadActual( ::oCodigoSegundaPropiedad, ::oTextoSegundaPropiedad, ::oDbfVir:cCodPr2 ) }
         ::oCodigoSegundaPropiedad:bValid    := {|| ::LoadAtipica() }

      REDEFINE GET      ::oValorSegundaPropiedad ;
         VAR            ::cValorSegundaPropiedad ;
         ID             261 ;
         WHEN           .f. ;
         OF             ::oFld:aDialogs[1]

      /*
      Precios de costo---------------------------------------------------------
      */

      REDEFINE CHECKBOX ::oChangeCostoParticular ;
         VAR            ::oDbfVir:lPrcCom ;
         ID             122 ;
         ON CHANGE      ( ::lChangeCostoParticular() );
         WHEN           ( ::oDbfVir:nTipAtp <= 1 .and. ::nMode != ZOOM_MODE ) ;
         OF             ::oFld:aDialogs[ 1 ]

      REDEFINE GET      ::oCostoParticular ;
         VAR            ::oDbfVir:nPrcCom ;
         ID             120 ;
         WHEN           ( ::nMode != ZOOM_MODE );
         SPINNER        ;
         PICTURE        cPinDiv() ;
         OF             ::oFld:aDialogs[1]

      ::oCostoParticular:bChange              := {|| ::CalculaRentabilidad() }
      ::oCostoParticular:bValid               := {|| ::CalculaRentabilidad() } 

      REDEFINE GET      ::oPrecioCompra ;
         VAR            ::nPrecioCompra ;
         ID             123 ;
         WHEN           ( .f. );
         SPINNER        ;
         PICTURE        cPinDiv() ;
         OF             ::oFld:aDialogs[ 1 ]

      ::oPrecioCompra:bChange                := {|| ::CalculaRentabilidad() }
      ::oPrecioCompra:bValid                 := {|| ::CalculaRentabilidad() } 

      /*
      Precios de venta---------------------------------------------------------
      */

      REDEFINE GET ::oPrecioArticulo1 ;
         VAR      ::oDbfVir:nPrcArt ;
         ID       121 ;
         SPINNER  ;
         PICTURE  cPouDiv() ;
         WHEN     ( ::WhenTipoArticuloIva() ) ;
         VALID    ( ::CalculaIva( ::oPrecioArticulo1, ::oIvaArticulo1 ) );
         OF       ::oFld:aDialogs[1]

      ::oPrecioArticulo1:bChange             := {|| ::CalculaRentabilidad() } 

      REDEFINE GET ::oPrecioArticulo2 ;
         VAR      ::oDbfVir:nPrcArt2 ;
         ID       124 ;
         SPINNER  ;
         PICTURE  cPouDiv() ;
         WHEN     ( ::WhenTipoArticuloIva() ) ;
         VALID    ( ::CalculaIva( ::oPrecioArticulo2, ::oIvaArticulo2 ) );
         OF       ::oFld:aDialogs[1]

      ::oPrecioArticulo2:bChange             := {|| ::CalculaRentabilidad() } 

      REDEFINE GET ::oPrecioArticulo3 ;
         VAR      ::oDbfVir:nPrcArt3 ;
         ID       125 ;
         SPINNER  ;
         PICTURE  cPouDiv() ;
         WHEN     ( ::WhenTipoArticuloIva() ) ;
         VALID    ( ::CalculaIva( ::oPrecioArticulo3, ::oIvaArticulo3 ) );
         OF       ::oFld:aDialogs[1]

      ::oPrecioArticulo3:bChange             := {|| ::CalculaRentabilidad() } 

      REDEFINE GET ::oPrecioArticulo4 ;
         VAR      ::oDbfVir:nPrcArt4 ;
         ID       126 ;
         SPINNER  ;
         PICTURE  cPouDiv() ;
         WHEN     ( ::WhenTipoArticuloIva() ) ;
         VALID    ( ::CalculaIva( ::oPrecioArticulo4, ::oIvaArticulo4 ) );
         OF       ::oFld:aDialogs[1]

      ::oPrecioArticulo4:bChange             := {|| ::CalculaRentabilidad() } 

      REDEFINE GET ::oPrecioArticulo5 ;
         VAR      ::oDbfVir:nPrcArt5 ;
         ID       127 ;
         SPINNER  ;
         PICTURE  cPouDiv() ;
         WHEN     ( ::WhenTipoArticuloIva() ) ;
         VALID    ( ::CalculaIva( ::oPrecioArticulo5, ::oIvaArticulo5 ) );
         OF       ::oFld:aDialogs[1]

      ::oPrecioArticulo5:bChange             := {|| ::CalculaRentabilidad() } 

      REDEFINE GET ::oPrecioArticulo6 ;
         VAR      ::oDbfVir:nPrcArt6 ;
         ID       128 ;
         SPINNER  ;
         PICTURE  cPouDiv() ;
         WHEN     ( ::WhenTipoArticuloIva() ) ;
         VALID    ( ::CalculaIva( ::oPrecioArticulo6, ::oIvaArticulo6 ) );
         OF       ::oFld:aDialogs[1]

      ::oPrecioArticulo6:bChange             := {|| ::CalculaRentabilidad() } 

      /*
      Precios con impuestos----------------------------------------------------
      */

      REDEFINE GET ::oIvaArticulo1 ; 
         VAR      ::oDbfVir:nPreIva1 ;
         ID       300 ;
         SPINNER ;
         PICTURE  cPouDiv() ;
         WHEN     ( ::WhenTipoArticuloBase() ) ;
         VALID    ( ::CalculaBase( ::oIvaArticulo1, ::oPrecioArticulo1 ) );
         OF       ::oFld:aDialogs[1]

      ::oIvaArticulo1:bChange             := {|| ::CalculaRentabilidad() } 

      REDEFINE GET ::oIvaArticulo2 ; 
         VAR      ::oDbfVir:nPreIva2 ;
         ID       310 ;
         SPINNER ;
         PICTURE  cPouDiv() ;
         WHEN     ( ::WhenTipoArticuloBase() ) ;
         VALID    ( ::CalculaBase( ::oIvaArticulo2, ::oPrecioArticulo2 ) );
         OF       ::oFld:aDialogs[1]

      ::oIvaArticulo2:bChange             := {|| ::CalculaRentabilidad() } 

      REDEFINE GET ::oIvaArticulo3 ; 
         VAR      ::oDbfVir:nPreIva3 ;
         ID       320 ;
         SPINNER ;
         PICTURE  cPouDiv() ;
         WHEN     ( ::WhenTipoArticuloBase() ) ;
         VALID    ( ::CalculaBase( ::oIvaArticulo3, ::oPrecioArticulo3 ) );
         OF       ::oFld:aDialogs[1]

      ::oIvaArticulo3:bChange             := {|| ::CalculaRentabilidad() } 

      REDEFINE GET ::oIvaArticulo4 ; 
         VAR      ::oDbfVir:nPreIva4 ;
         ID       330 ;
         SPINNER ;
         PICTURE  cPouDiv() ;
         WHEN     ( ::WhenTipoArticuloBase() ) ;
         VALID    ( ::CalculaBase( ::oIvaArticulo4, ::oPrecioArticulo4 ) );
         OF       ::oFld:aDialogs[1]

      ::oIvaArticulo4:bChange             := {|| ::CalculaRentabilidad() } 

      REDEFINE GET ::oIvaArticulo5 ; 
         VAR      ::oDbfVir:nPreIva5 ;
         ID       340 ;
         SPINNER ;
         PICTURE  cPouDiv() ;
         WHEN     ( ::WhenTipoArticuloBase() ) ;
         VALID    ( ::CalculaBase( ::oIvaArticulo5, ::oPrecioArticulo5 ) );
         OF       ::oFld:aDialogs[1]

      ::oIvaArticulo5:bChange             := {|| ::CalculaRentabilidad() } 

      REDEFINE GET ::oIvaArticulo6 ; 
         VAR      ::oDbfVir:nPreIva6 ;
         ID       350 ;
         SPINNER ;
         PICTURE  cPouDiv() ;
         WHEN     ( ::WhenTipoArticuloBase() ) ;
         VALID    ( ::CalculaBase( ::oIvaArticulo6, ::oPrecioArticulo6 ) );
         OF       ::oFld:aDialogs[1]

      ::oIvaArticulo6:bChange             := {|| ::CalculaRentabilidad() } 

      /*
      Descuentos---------------------------------------------------------------
      */     

      REDEFINE GET ::oDescuentoPorcentualArticulo;
         VAR      ::oDbfVir:nDtoArt;
			ID 		130 ;
         WHEN     ( ::nMode != ZOOM_MODE );
			SPINNER ;
         VALID    ( ::oDbfVir:nDtoArt >= 0 .and. ::oDbfVir:nDtoArt <= 100 )  ;
         PICTURE  "@E 999.99";
         OF       ::oFld:aDialogs[1]

      ::oDescuentoPorcentualArticulo:bChange    := {|| ::CalculaRentabilidad() }

      REDEFINE GET ::oDescuentoLinealArticulo ;
         VAR      ::oDbfVir:nDtoDiv ;
         ID       135 ;
         SPINNER ;
         WHEN     ( ::nMode != ZOOM_MODE );
         VALID    ( ::CalculaRentabilidad() );
         PICTURE  cPouDiv() ;
         OF       ::oFld:aDialogs[1]

      ::oDescuentoLinealArticulo:bChange    := {|| ::CalculaRentabilidad() }

      REDEFINE GET ::oDescuentoPromocionArticulo ;
         VAR      ::oDbfVir:nDprArt ;
         ID       601 ;
         WHEN     ( ::nMode != ZOOM_MODE );
			SPINNER ;
         VALID    ( ::oDbfVir:nDprArt >= 0 .and. ::oDbfVir:nDprArt <= 100 )  ;
         PICTURE  "@E 999.99";
         OF       ::oFld:aDialogs[1]

      ::oDescuentoPromocionArticulo:bChange  := {|| ::CalculaRentabilidad() }

      REDEFINE CHECKBOX ::oDbfVir:lComAge ;
         ID       151 ;
         ON CHANGE( ::CalculaRentabilidad() );
         WHEN     ( ::nMode != ZOOM_MODE ) ;
         OF       ::oFld:aDialogs[1]

      REDEFINE GET ::oComisionAgente ;
         VAR      ::oDbfVir:nComAge ;
			ID 		150 ;
         WHEN     ( ::nMode != ZOOM_MODE );
			SPINNER ;
         VALID    ( ::oDbfVir:nComAge >= 0 .and. ::oDbfVir:nComAge <= 100 ) ;
         PICTURE  "@E 999.99";
         OF       ::oFld:aDialogs[1]

      ::oComisionAgente:bChange              := {|| ::CalculaRentabilidad() }

      REDEFINE GROUP ::oSayLabels[ 1 ]   ID 700 OF ::oFld:aDialogs[ 1 ] TRANSPARENT
      REDEFINE GROUP ::oSayLabels[ 2 ]   ID 701 OF ::oFld:aDialogs[ 1 ] TRANSPARENT
      REDEFINE GROUP ::oSayLabels[ 3 ]   ID 702 OF ::oFld:aDialogs[ 1 ] TRANSPARENT
      REDEFINE SAY   ::oSayLabels[ 4 ]   ID 703 OF ::oFld:aDialogs[ 1 ]
      REDEFINE SAY   ::oSayLabels[ 5 ]   ID 704 OF ::oFld:aDialogs[ 1 ]
      REDEFINE SAY   ::oSayLabels[ 6 ]   ID 705 OF ::oFld:aDialogs[ 1 ]
      REDEFINE SAY   ::oSayLabels[ 7 ]   ID 706 OF ::oFld:aDialogs[ 1 ]
      REDEFINE SAY   ::oSayLabels[ 8 ]   ID 707 OF ::oFld:aDialogs[ 1 ]
      REDEFINE SAY   ::oSayLabels[ 9 ]   ID 708 OF ::oFld:aDialogs[ 1 ]
      REDEFINE SAY   ::oSayLabels[ 10]   ID 709 OF ::oFld:aDialogs[ 1 ]
      REDEFINE SAY   ::oSayLabels[ 11]   ID 710 OF ::oFld:aDialogs[ 1 ]
      REDEFINE SAY   ::oSayLabels[ 12]   ID 711 OF ::oFld:aDialogs[ 1 ]
      REDEFINE SAY   ::oSayLabels[ 13]   ID 712 OF ::oFld:aDialogs[ 1 ]
      REDEFINE SAY   ::oSayLabels[ 14]   ID 713 OF ::oFld:aDialogs[ 1 ]
      REDEFINE SAY   ::oSayLabels[ 15]   ID 714 OF ::oFld:aDialogs[ 1 ]
      REDEFINE GROUP ::oSayLabels[ 16]   ID 715 OF ::oFld:aDialogs[ 1 ] TRANSPARENT

      REDEFINE GET ::oDescuento1 ;
         VAR      ::oDbfVir:nDto1 ;
         ID       400 ;
         WHEN     ( nMode != ZOOM_MODE );
			SPINNER ;
         VALID    ( ::oDbfVir:nDto1 >= 0 .and. ::oDbfVir:nDto1 <= 100 ) ;
         PICTURE  "@E 999.99";
         OF       ::oFld:aDialogs[1]

      REDEFINE GET ::oDescuento2 ;
         VAR      ::oDbfVir:nDto2 ;
         ID       410 ;
         WHEN     ( nMode != ZOOM_MODE );
         SPINNER ;
         VALID    ( ::oDbfVir:nDto2 >= 0 .and. ::oDbfVir:nDto2 <= 100 ) ;
         PICTURE  "@E 999.99";
         OF       ::oFld:aDialogs[1]

      REDEFINE GET ::oDescuento3 ;
         VAR      ::oDbfVir:nDto3 ;
         ID       420 ;
         WHEN     ( nMode != ZOOM_MODE );
         SPINNER ;
         VALID    ( ::oDbfVir:nDto3 >= 0 .and. ::oDbfVir:nDto3 <= 100 ) ;
         PICTURE  "@E 999.99";
         OF       ::oFld:aDialogs[1]

      REDEFINE GET ::oDescuento4 ;
         VAR      ::oDbfVir:nDto4 ;
         ID       430 ;
         WHEN     ( nMode != ZOOM_MODE );
         SPINNER ;
         VALID    ( ::oDbfVir:nDto4 >= 0 .and. ::oDbfVir:nDto4 <= 100 ) ;
         PICTURE  "@E 999.99";
         OF       ::oFld:aDialogs[1]

      REDEFINE GET ::oDescuento5 ;
         VAR      ::oDbfVir:nDto5 ;
         ID       440 ;
         WHEN     ( nMode != ZOOM_MODE );
         SPINNER ;
         VALID    ( ::oDbfVir:nDto5 >= 0 .and. ::oDbfVir:nDto5 <= 100 ) ;
         PICTURE  "@E 999.99";
         OF       ::oFld:aDialogs[1]

      REDEFINE GET ::oDescuento6 ;
         VAR      ::oDbfVir:nDto6 ;
         ID       450 ;
         WHEN     ( ::nMode != ZOOM_MODE );
         SPINNER ;
         VALID    ( ::oDbfVir:nDto6 >= 0 .and. ::oDbfVir:nDto6 <= 100 ) ;
         PICTURE  "@E 999.99";
         OF       ::oFld:aDialogs[1]

      REDEFINE GET   ::oCodEnvase ;
         VAR      ::oDbfVir:CCODENV ; 
         ID       460 ;
         IDTEXT   461 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         BITMAP   "LUPA" ;
         OF       ::oFld:aDialogs[1]

         ::oCodEnvase:bValid := {|| ::oParent:oEnvases:Existe( ::oCodEnvase, ::oCodEnvase:oHelpText ) }
         ::oCodEnvase:bHelp  := {|| ::oParent:oEnvases:Buscar( ::oCodEnvase ) }

      /*
      Segunda caja de dialogo--------------------------------------------------
      */

      REDEFINE GET ::oDbfVir:dFecIni ;
         ID       160 ;
         WHEN     ( ::nMode != ZOOM_MODE );
         SPINNER ;
         OF       ::oFld:aDialogs[2]

      REDEFINE GET ::oDbfVir:dFecFin ;
         ID       170 ;
         WHEN     ( ::nMode != ZOOM_MODE );
         SPINNER ;
         OF       ::oFld:aDialogs[2]

      REDEFINE CHECKBOX ::oDbfVir:lAplPre ;
         ID       180 ;
         WHEN     ( ::nMode != ZOOM_MODE ) ;
         OF       ::oFld:aDialogs[2]

      REDEFINE CHECKBOX ::oDbfVir:lAplPed ;
         ID       190 ;
         WHEN     ( ::nMode != ZOOM_MODE ) ;
         OF       ::oFld:aDialogs[2]

      REDEFINE CHECKBOX ::oDbfVir:lAplAlb ;
         ID       200 ;
         WHEN     ( ::nMode != ZOOM_MODE ) ;
         OF       ::oFld:aDialogs[2]

      REDEFINE CHECKBOX ::oDbfVir:lAplFac ;
         ID       210 ;
         WHEN     ( ::nMode != ZOOM_MODE ) ;
         OF       ::oFld:aDialogs[2]

      REDEFINE CHECKBOX ::oDbfVir:lAplSat ;
         ID       250 ;
         WHEN     ( ::nMode != ZOOM_MODE ) ;
         OF       ::oFld:aDialogs[2]   

      /*
      Ofertas de X*Y-----------------------------------------------------------
      */

      REDEFINE RADIO ::oOfertaXbY ;
         VAR      ::oDbfVir:nTipXby ;
         WHEN     ( ::WhenTipoArticulo() ) ;
         ID       220, 221 ;
         OF       ::oFld:aDialogs[2]

      ::oOfertaXbY:bChange       := {|| ::CalculaRentabilidad() }

      REDEFINE GET ::oUnidadesVender ;
         VAR      ::oDbfVir:nUnvOfe ;
         ID       230 ;
         PICTURE  "@E 999" ;
         SPINNER ;
         WHEN     ( ::WhenTipoArticulo() ) ;
         VALID    ( isBig( ::oDbfVir:nUnvOfe, ::oDbfVir:nUncOfe ), ::CalculaRentabilidad() ) ;
         OF       ::oFld:aDialogs[2]

      ::oUnidadesVender:bChange  := {|| ::CalculaRentabilidad() }

      REDEFINE GET ::oUnidadesCobrar ;
         VAR      ::oDbfVir:nUncOfe ;
         ID       240 ;
         PICTURE  "@E 999" ;
         SPINNER ;
         WHEN     ( ::WhenTipoArticulo() ) ;
         VALID    ( isBig( ::oDbfVir:nUnvOfe, ::oDbfVir:nUncOfe ), ::CalculaRentabilidad() ) ;
         OF       ::oFld:aDialogs[2]

      ::oUnidadesCobrar:bChange  := {|| ::CalculaRentabilidad() }

      /*
      Estudio rentabilidad ----------------------------------------------------
      */

      REDEFINE COMBOBOX ::oRentabilidadSobre ;
         VAR      ::cRentabilidadSobre ;
         ITEMS    ::aRentabilidadSobre ;
         ID       400 ;
         WHEN     ( ::nMode != ZOOM_MODE ) ;
         OF       ::oDlg

      ::oRentabilidadSobre:bChange        := {|| ::CalculaRentabilidad() }


      ::oBrwRentabilidad                  := IXBrowse():New( ::oDlg )
      ::oBrwRentabilidad:bClrSel          := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      ::oBrwRentabilidad:bClrSelFocus     := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }
      ::oBrwRentabilidad:lVScroll         := .t.
      ::oBrwRentabilidad:lHScroll         := .f.
      ::oBrwRentabilidad:nMarqueeStyle    := 5
      ::oBrwRentabilidad:lFooter          := .f.
      ::oBrwRentabilidad:lRecordSelector  := .t.
   
      ::oBrwRentabilidad:SetArray( ::aRentabilidad, , , .f. )
   
      with object ( ::oBrwRentabilidad:AddCol() )
         :cHeader                         := ""
         :bStrData                        := {|| "" }
         :bEditValue                      := {|| ::AlertaRentabilidad() }
         :nWidth                          := 18
         :SetCheck( { "Alert", "Nil16" } )
      end with

      with object ( ::oBrwRentabilidad:AddCol() )
         :cHeader                         := "Naturaleza"
         :bEditValue                      := {|| ::NaturalezaRentabilidad() }
         :nWidth                          := 96
      end with

      with object ( ::oBrwRentabilidad:AddCol() )
         :cHeader                         := "Tipo"
         :bEditValue                      := {|| ::TipoRentabilidad() }
         :nWidth                          := 48
      end with

      with object ( ::oBrwRentabilidad:AddCol() )
         :cHeader                         := "Importe " + cDivEmp()
         :bEditValue                      := {|| ::ImporteRentabilidad() }
         :nDataStrAlign                   := 1
         :nHeadStrAlign                   := 1
         :nWidth                          := 68
      end with
   
      ::oBrwRentabilidad:CreateFromResource( 450 )

      /*
      Botones comunes de la caja de diálogo------------------------------------
      */

      REDEFINE BUTTON ::oBtnExpandir ;
         ID       600 ;
         OF       ::oDlg ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( ::Expandir( .t. ) ) // lExpandir( oDlg, oBtnRen ), lArrayRen( oSobre:nAt, oBrwRen, aTmp, aTmpCli, aGetCli, cCosto ) )

      REDEFINE BUTTON ;
         ID       IDOK ;
         OF       ::oDlg ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( ::SaveResource() ) // SaveEdtAtp( aGet, aTmp, dbfTmpAtp, oBrw, oDlg, nMode ) )

      REDEFINE BUTTON ;
         ID       IDCANCEL ;
         OF       ::oDlg ;
         CANCEL ;
         ACTION   ( ::oDlg:end() )

   if nMode != ZOOM_MODE
      ::oDlg:AddFastKey( VK_F5, {|| ::SaveResource() } )
   end if

   ::oDlg:bStart  := {|| ::Expandir(), ::CalculaRentabilidad() } 

   ::oDlg:Activate( , , , .t.,,, {|| EdtDetMenu( ::oCodigoArticulo, ::oDlg ) } )

RETURN ( ::oDlg:nResult == IDOK )

//---------------------------------------------------------------------------//

METHOD SaveResource()

   if empty( ::oDbfVir:cCodArt ) .and. empty( ::oDbfVir:cCodFam )
      MsgStop( "La tarifa debe contener un código de artículo o de familia." )
      RETURN( Self )
   end if 

   ::oDbfVir:nTipAtp := ::oNaturaleza:nAt 

   ::oDlg:end( IDOK )
   
RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD SaveDetails()

   ::oDbfVir:cCodGrp    := ::oParent:oDbf:cCodGrp

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD DeleteDetails()

RETURN ( Self )

//--------------------------------------------------------------------------//

METHOD ChangeNaturaleza()

   if ( ::nMode == APPD_MODE )

      ::oCodigoArticulo:cText( space( 18 ) )
      ::oNombreArticulo:cText( "" )
      
      ::oCodigoFamilia:cText( space( 5 ) )
      ::oNombreFamilia:cText( "" )

      ::oCostoParticular:cText( 0 )
      ::oPrecioCompra:cText( 0 )

      ::oPrecioArticulo1:cText( 0 )
      ::oPrecioArticulo2:cText( 0 )
      ::oPrecioArticulo3:cText( 0 )
      ::oPrecioArticulo4:cText( 0 )
      ::oPrecioArticulo5:cText( 0 )
      ::oPrecioArticulo6:cText( 0 )

      ::oIvaArticulo1:cText( 0 )
      ::oIvaArticulo2:cText( 0 )
      ::oIvaArticulo3:cText( 0 )
      ::oIvaArticulo4:cText( 0 )
      ::oIvaArticulo5:cText( 0 )
      ::oIvaArticulo6:cText( 0 )

      ::oTextoPrimeraPropiedad:SetText( "" )
      ::oTextoSegundaPropiedad:SetText( "" )

      ::oValorPrimeraPropiedad:cText( "" )
      ::oValorSegundaPropiedad:cText( "" )

      ::oCodigoPrimeraPropiedad:cText( space( 20 ) )
      ::oCodigoSegundaPropiedad:cText( space( 20 ) )

   end if

   if ( ::oNaturaleza:nAt <= 1 )

      ::oCodigoArticulo:Show()
      ::oNombreArticulo:Show()

      ::oCodigoFamilia:Hide()
      ::oNombreFamilia:Hide()

      ::oChangeCostoParticular:Show()

      ::oCostoParticular:Show()
      ::oPrecioCompra:Show()
      ::oCostoParticular:Show()

      ::oPrecioArticulo1:Show()
      ::oPrecioArticulo2:Show()
      ::oPrecioArticulo3:Show()
      ::oPrecioArticulo4:Show()
      ::oPrecioArticulo5:Show()
      ::oPrecioArticulo6:Show()

      ::oIvaArticulo1:Show()
      ::oIvaArticulo2:Show()
      ::oIvaArticulo3:Show()
      ::oIvaArticulo4:Show()
      ::oIvaArticulo5:Show()
      ::oIvaArticulo6:Show()

      ::oDescuento1:Show()
      ::oDescuento2:Show()
      ::oDescuento3:Show()
      ::oDescuento4:Show()
      ::oDescuento5:Show()
      ::oDescuento6:Show()

      aEval( ::oSayLabels, {|o| o:Show() } )

   else

      ::oCodigoArticulo:Hide()
      ::oNombreArticulo:Hide()

      ::oCodigoFamilia:Show()
      ::oNombreFamilia:Show()

      ::oChangeCostoParticular:Hide()

      ::oCostoParticular:Hide()
      ::oPrecioCompra:Hide()

      ::oPrecioArticulo1:Hide()
      ::oPrecioArticulo2:Hide()
      ::oPrecioArticulo3:Hide()
      ::oPrecioArticulo4:Hide()
      ::oPrecioArticulo5:Hide()
      ::oPrecioArticulo6:Hide()

      ::oIvaArticulo1:Hide()
      ::oIvaArticulo2:Hide()
      ::oIvaArticulo3:Hide()
      ::oIvaArticulo4:Hide()
      ::oIvaArticulo5:Hide()
      ::oIvaArticulo6:Hide()

      ::oDescuento1:Hide()
      ::oDescuento2:Hide()
      ::oDescuento3:Hide()
      ::oDescuento4:Hide()
      ::oDescuento5:Hide()
      ::oDescuento6:Hide()

      aEval( ::oSayLabels, {|o| o:Hide() } )

   end if

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD Expandir( lSet )

   local oRect       := ::oDlg:GetRect()

   DEFAULT lSet      := .f.

   if lSet
      ::lExpandida   := !::lExpandida
   end if 

   if ::lExpandida
      SetWindowText( ::oBtnExpandir:hWnd, "Retabilidad <" )
      ::oDlg:Move( oRect:nTop, oRect:nLeft, 800, 550, .t. )
   else
      SetWindowText( ::oBtnExpandir:hWnd, "Retabilidad >" )
      ::oDlg:Move( oRect:nTop, oRect:nLeft, 463, 550, .t. )
   end if

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD ButtonAppend( Id, oDialog )

   REDEFINE BUTTON  ;
      ID       ( Id ) ;
      OF       ( oDialog ) ;
      WHEN     ( ( SQLAjustableModel():getRolCambiarPrecios( Auth():rolUuid() ) ) ) ;
      ACTION   ( ::Append( ::oBrwAtipica ) )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD ButtonEdit( Id, oDialog )

   REDEFINE BUTTON  ;
      ID       ( Id ) ;
      OF       ( oDialog ) ;
      WHEN     ( ( SQLAjustableModel():getRolCambiarPrecios( Auth():rolUuid() ) ) ) ;
      ACTION   ( ::Edit( ::oBrwAtipica ) )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD ButtonDel( Id, oDialog )

   REDEFINE BUTTON  ;
      ID       ( Id ) ;
      OF       ( oDialog ) ;
      WHEN     ( ( SQLAjustableModel():getRolCambiarPrecios( Auth():rolUuid() ) ) ) ;
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
      :bEditValue       := {|| if( ::oDbfVir:nTipAtp <= 1, ::NombreArticulo(), ::NombreFamilia() ) }
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

   if ( SQLAjustableModel():getRolCambiarPrecios( Auth():rolUuid() ) ) 
      ::oBrwAtipica:bLDblClick   := {|| ::Edit( ::oBrwAtipica ) }
   end if

   ::oBrwAtipica:bRClicked       := {| nRow, nCol, nFlags | ::oBrwAtipica:RButtonDown( nRow, nCol, nFlags ) }

   ::oBrwAtipica:CreateFromResource( Id )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD LoadAtipica()

   local nPrecio

   if Empty( ::oDbfVir:cCodArt )
      ::oNombreArticulo:cText( "" )
      Return ( .t. )
   end if

   if ( D():Get( "Articulo", ::View() ) )->( dbSeek( ::oDbfVir:cCodArt ) )

      ::oNombreArticulo:cText( ( D():Get( "Articulo", ::View() ) )->Nombre )

      ::oDbfVir:cCodPr1    := ( D():Get( "Articulo", ::View() ) )->cCodPrp1
      ::oDbfVir:cCodPr2    := ( D():Get( "Articulo", ::View() ) )->cCodPrp2

      ::SetPrimeraPropiedad( ::oDbfVir:cCodPr1, ( D():Get( "Articulo", ::View() ) )->cValPrp1 )

      ::SetSegundaPropiedad( ::oDbfVir:cCodPr2, ( D():Get( "Articulo", ::View() ) )->cValPrp2 )

      /*
      Precio de costo----------------------------------------------------------
      */

      ::oPrecioCompra:cText( nCosto( nil, D():Get( "Articulo", ::View() ), D():Get( "Artkit", ::View() ) ) )

      /*
      Primer precio de venta---------------------------------------------------
      */

      ::oPrecioArticulo1:cText( ::PrecioBase( 1 ) )
      ::oPrecioArticulo2:cText( ::PrecioBase( 2 ) )
      ::oPrecioArticulo3:cText( ::PrecioBase( 3 ) )
      ::oPrecioArticulo4:cText( ::PrecioBase( 4 ) )
      ::oPrecioArticulo5:cText( ::PrecioBase( 5 ) )
      ::oPrecioArticulo6:cText( ::PrecioBase( 6 ) )

      /*
      Primer precio de venta impuestos incluido--------------------------------
      */

      ::oIvaArticulo1:cText( ::PrecioIva( 1 ) )
      ::oIvaArticulo2:cText( ::PrecioIva( 2 ) )
      ::oIvaArticulo3:cText( ::PrecioIva( 3 ) )
      ::oIvaArticulo4:cText( ::PrecioIva( 4 ) )
      ::oIvaArticulo5:cText( ::PrecioIva( 5 ) )
      ::oIvaArticulo6:cText( ::PrecioIva( 6 ) )

   else

      Return ( .f. )

   end if

RETURN ( .t. )

//--------------------------------------------------------------------------//

METHOD SetPrimeraPropiedad( cCodigoPropiedad, cValorPropiedad )

   if !empty( cCodigoPropiedad )
      ::oCodigoPrimeraPropiedad:cText( cCodigoPropiedad )
      ::oTextoPrimeraPropiedad:SetText( cValorPropiedad ) 
      ::ShowPrimeraPropiedad()
   else 
      ::HidePrimeraPropiedad()
   end if 

RETURN ( Self )

//--------------------------------------------------------------------------//

METHOD SetSegundaPropiedad( cCodigoPropiedad, cValorPropiedad )

   if !empty( cCodigoPropiedad )
      ::oCodigoSegundaPropiedad:cText( cCodigoPropiedad )
      ::oTextoSegundaPropiedad:SetText( cValorPropiedad ) 
      ::ShowSegundaPropiedad()
   else 
      ::HideSegundaPropiedad()
   end if 

RETURN ( Self )

//--------------------------------------------------------------------------//

METHOD CalculaRentabilidad()        

   local nCosto      := 0
   local nDtoAtpico  := 0
   local nNetoBase   := 0
   local nResultado  := 0

   CursorWait()

   ::aRentabilidad   := {}

   // Costo -------------------------------------------------------------------

   if ::oDbfVir:lPrcCom
      nCosto         := ::nCostoParticular
   else
      nCosto         := ::oDbfVir:nPrcCom 
   end if

   aAdd( ::aRentabilidad, { "Naturaleza" => "Costo",     "Tipo" => "", "Importe" => nCosto } )   

   // Base --------------------------------------------------------------------

   switch ::oRentabilidadSobre:nAt
      case 1
         nNetoBase   := ::oDbf:nPrcArt
      case 2
         nNetoBase   := ::oDbf:nPrcArt2
      case 3
         nNetoBase   := ::oDbf:nPrcArt3
      case 4
         nNetoBase   := ::oDbf:nPrcArt4
      case 5
         nNetoBase   := ::oDbf:nPrcArt5
      case 6
         nNetoBase   := ::oDbf:nPrcArt6
   end 

   aAdd( ::aRentabilidad, { "Naturaleza" => "Neto base", "Tipo" => "", "Importe" => nNetoBase } )

   // Dto X*Y*-----------------------------------------------------------------

   if ( ::oDbfVir:nUncOfe > 1 .and. ::oDbfVir:nUnvOfe >= 1 )

      nResultado     := nNetoBase - ( Div( ( nNetoBase * ::oDbf:nUncOfe ), ::oDbfVir:nUnvOfe ) )

      aAdd( ::aRentabilidad, { "Naturaleza" => Space( 3 ) + "Dto. X*Y", "Tipo" => alltrim( str( ::oDbfVir:nUnvOfe ) ) + " * " + alltrim( str( ::oDbfVir:nUncOfe ) ), "Importe" => - ( nResultado ) } )

      nNetoBase      -= nResultado

   end if

   // Dto Art------------------------------------------------------------------

   if ::oDbfVir:nDtoArt != 0

      nResultado     := ( ( nNetoBase * ::oDbfVir:nDtoArt ) / 100 )

      aAdd( ::aRentabilidad, { "Naturaleza" => space(3) + "Dto. art.", "Tipo" => alltrim( str( ::oDbfVir:nDtoArt  ) ) + " %", "Importe" => - ( nResultado ) } )

      nNetoBase      -= nResultado

   end if

   // Dto Lin------------------------------------------------------------------

   if ::oDbfVir:nDtoDiv != 0

      aAdd( ::aRentabilidad, { "Naturaleza" => space(3) + "Dto. lineal", "Tipo" => Trans( ::oDbfVir:nDtoDiv, cPouDiv( cDivEmp() ) ), "Importe" => - ( ::oDbfVir:nDtoDiv ) } )

      nNetoBase      -= ::oDbfVir:nDtoDiv

   end if

   // Dto Promo ---------------------------------------------------------------

   if ::oDbfVir:nDprArt != 0

      nResultado     := ( ( nNetoBase * ::oDbfVir:nDprArt ) / 100 )

      aAdd( ::aRentabilidad, { "Naturaleza" => space(3) + "Dto. promo.", "Tipo" => alltrim( str( ::oDbfVir:nDprArt ) ) + " %", "Importe" => - ( nResultado ) } )

      nNetoBase      -= nResultado

   end if

   // Comisión agente----------------------------------------------------------

   if ::oDbfVir:nComAge != 0

      nResultado     := ( ( nNetoBase * ::oDbfVir:nComAge ) / 100 )

      if ::oDbfVir:lComAge
         aAdd( ::aRentabilidad, { "Naturaleza" => space(3) + "Com. agente", "Tipo" => AllTrim( Str( ::oDbfVir:nComAge ) ) + " %", "Importe" => - ( nResultado ) } )
         nNetoBase   -= nResultado
      else
         aAdd( ::aRentabilidad, { "Naturaleza" => space(3) + "Com. agente", "Tipo" => AllTrim( Str( ::oDbfVir:nComAge ) ) + " %", "Importe" => nResultado } )
      end if

   end if

   CursorWE()

   ::oBrwRentabilidad:SetArray( ::aRentabilidad )
   ::oBrwRentabilidad:Refresh()

RETURN ( .t. )   

//--------------------------------------------------------------------------//

METHOD CalculaBase( oPrecioIva, oPrecioBase )

   local nBase          := 0
   local nPorcentajeIVA := 0
   local cTipoIVA       := retfld( ::oDbfVir:cCodArt, D():Get( "Articulo", ::View() ), "TipoIva", "Codigo" )

   if !empty( cTipoIVA )
      nPorcentajeIVA    := nIva( D():Get( "TIva", ::View() ), cTipoIva )
   end if 

   /*
   Primero es quitar el impuestos----------------------------------------------
   */

   nBase                := Div( oPrecioIva:varGet(), ( 1 + nPorcentajeIVA / 100 ) )

   /*
   Actualizamos la base--------------------------------------------------------
   */

   oPrecioBase:cText( nBase )

RETURN ( .t. )   

//--------------------------------------------------------------------------//

METHOD CalculaIva( oPrecioBase, oPrecioIva )

   local nPrecio        := oPrecioBase:varGet()
   local nPorcentajeIVA := 0
   local cTipoIVA       := retfld( ::oDbfVir:cCodArt, D():Get( "Articulo", ::View() ), "TipoIva", "Codigo" )

   if !empty( cTipoIVA )
      nPorcentajeIVA    := nIva( D():Get( "TIva", ::View() ), cTipoIva )
   end if 

   /*
   Sumar impuestos-------------------------------------------------------------
   */

   nPrecio              += ( nPrecio * nPorcentajeIVA / 100 )

   /*
   Actualizamos----------------------------------------------------------------
   */

   oPrecioIva:cText( nPrecio )

RETURN ( .t. )   

//--------------------------------------------------------------------------//

METHOD PrecioBase( nTarifa )

   local nPrecio     := 0

   DEFAULT nTarifa   := 1

   nPrecio           := nPrePro( ::oDbfVir:cCodArt, ::oDbfVir:cCodPr1, ::oDbfVir:cValPr1, ::oDbfVir:cCodPr2, ::oDbfVir:cValPr2, nTarifa, .f., D():Get( "Artdiv", ::View() ) )
   if nPrecio == 0
      nPrecio        := ( D():Get( "Articulo", ::View() ) )->( FieldGet( FieldPos( "pVenta" + alltrim(str( nTarifa ) ) ) ) ) 
   end if

RETURN ( nPrecio )

//--------------------------------------------------------------------------//

METHOD PrecioIva( nTarifa )

   local nPrecio     := 0

   DEFAULT nTarifa   := 1

   nPrecio           := nPrePro( ::oDbfVir:cCodArt, ::oDbfVir:cCodPr1, ::oDbfVir:cValPr1, ::oDbfVir:cCodPr2, ::oDbfVir:cValPr2, nTarifa, .t., D():Get( "Artdiv", ::View() ) )
   if nPrecio == 0
      nPrecio        := ( D():Get( "Articulo", ::View() ) )->( FieldGet( FieldPos( "pVtaIva" + alltrim(str( nTarifa ) ) ) ) ) 
   end if

RETURN ( nPrecio )

//--------------------------------------------------------------------------//

