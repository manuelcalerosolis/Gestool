#include "FiveWin.Ch"
#include "Factu.Ch"

//------------------------------------------------------------------------//

CLASS ImportadorMovimientosAlmacenLineasView FROM SQLBaseView 

   DATA lFamilia                    INIT .t.
   DATA oFamiliaInicio
   DATA cFamiliaInicio              INIT space( 16 )
   DATA oFamiliaFin
   DATA cFamiliaFin                 INIT replicate( 'Z', 16 )

   DATA lTipoArticulo               INIT .t.
   DATA oTipoArticuloInicio
   DATA cTipoArticuloInicio         INIT space( 4 )
   DATA oTipoArticuloFin
   DATA cTipoArticuloFin            INIT replicate( 'Z', 4 )

   DATA lArticulo                   INIT .t.
   DATA oArticuloInicio
   DATA cArticuloInicio             INIT space( 18 )
   DATA oArticuloFin
   DATA cArticuloFin                INIT replicate( 'Z', 18 )

   DATA oMtrStock
   DATA nMtrStock

   METHOD New( oController )

   METHOD Activate()

   METHOD getRange()                INLINE   (  {  "FamiliaInicio"      => ::cFamiliaInicio,;
                                                   "FamiliaFin"         => ::cFamiliaFin,;
                                                   "TipoArticuloInicio" => ::cTipoArticuloInicio,;
                                                   "TipoArticuloFin"    => ::cTipoArticuloFin,;
                                                   "ArticuloInicio"     => ::cArticuloInicio,;
                                                   "ArticuloFin"        => ::cArticuloFin } )

ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( oController )

   ::oController           := oController

RETURN ( self )

//----------------------------------------------------------------------------//

METHOD Activate()

   local oDialog

   DEFINE DIALOG oDialog RESOURCE "Importar_Almacen" 

      REDEFINE CHECKBOX ::lFamilia ;
         ID       200 ;
         OF       oDialog ;

      REDEFINE GET ::oFamiliaInicio VAR ::cFamiliaInicio ;
         ID       210 ;
         IDTEXT   220 ;
         BITMAP   "LUPA" ;
         WHEN     ( !::lFamilia ) ;
         OF       oDialog ;

      ::oFamiliaInicio:bValid    := {|| ::oController:validate( "codigo_familia_inicio", ::cFamiliaInicio ) }
      ::oFamiliaInicio:bHelp     := {|| brwFamilia( ::oFamiliaInicio, ::oFamiliaInicio:oHelpText ) }

      REDEFINE GET ::oFamiliaFin VAR ::cFamiliaFin ;
         ID       230 ;
         IDTEXT   240 ;
         BITMAP   "LUPA" ;
         WHEN     ( !::lFamilia ) ;
         OF       oDialog ;

      ::oFamiliaFin:bValid       := {|| ::oController:validate( "codigo_familia_fin", ::cFamiliaFin ) }
      ::oFamiliaFin:bHelp        := {|| brwFamilia( ::oFamiliaFin, ::oFamiliaFin:oHelpText ) }

      REDEFINE CHECKBOX ::lTipoArticulo ;
         ID       370 ;
         OF       oDialog ;

      REDEFINE GET ::oTipoArticuloInicio VAR ::cTipoArticuloInicio ;
         ID       350 ;
         IDTEXT   351 ;
         BITMAP   "LUPA" ;
         WHEN     ( !::lTipoArticulo ) ;
         OF       oDialog ;

      ::oTipoArticuloInicio:bValid    := {|| ::oController:validate( "codigo_tipo_articulo_inicio", ::cTipoArticuloInicio ) }
      ::oTipoArticuloInicio:bHelp     := {|| TTipArt():Buscar( ::oTipoArticuloInicio, "cCodTip", ::oTipoArticuloInicio:oHelpText ) }

      REDEFINE GET ::oTipoArticuloFin VAR ::cTipoArticuloFin ;
         ID       360 ;
         IDTEXT   361 ;
         BITMAP   "LUPA" ;
         WHEN     ( !::lTipoArticulo ) ;
         OF       oDialog ;

      ::oTipoArticuloFin:bValid        := {|| ::oController:validate( "codigo_tipo_articulo_fin", ::cTipoArticuloFin ) }
      ::oTipoArticuloFin:bHelp         := {|| TTipArt():Buscar( ::oTipoArticuloFin, "cCodTip", ::oTipoArticuloFin:oHelpText ) }

      REDEFINE CHECKBOX ::lArticulo ;
         ID       300 ;
         OF       oDialog ;

      REDEFINE GET ::oArticuloInicio VAR ::cArticuloInicio ;
         ID       310 ;
         IDTEXT   320 ;
         BITMAP   "LUPA" ;
         WHEN     ( !::lArticulo ) ;
         OF       oDialog ;

      ::oArticuloInicio:bValid         := {|| ::oController:validate( "codigo_articulo_inicio", ::cArticuloInicio ) }
      ::oArticuloInicio:bHelp          := {|| brwArticulo( ::oArticuloInicio, ::oArticuloInicio:oHelpText ) }

      REDEFINE GET ::oArticuloFin VAR ::cArticuloFin ;
         ID       330 ;
         IDTEXT   340 ;
         BITMAP   "LUPA" ;
         WHEN     ( !::lArticulo ) ;
         OF       oDialog ;

      ::oArticuloFin:bValid            := {|| ::oController:validate( "codigo_articulo_fin", ::cArticuloFin ) }
      ::oArticuloFin:bHelp             := {|| brwArticulo( ::oArticuloFin, ::oArticuloFin:oHelpText ) }

      REDEFINE APOLOMETER ::oMtrStock ;
         VAR      ::nMtrStock ;
         PROMPT   "" ;
         ID       400 ;
         OF       oDialog

      REDEFINE BUTTON ;
         ID       IDOK ;
         OF       oDialog ;
         ACTION   ( ::oController:importarAlmacen() )

      REDEFINE BUTTON ;
         ID       IDCANCEL ;
         OF       oDialog ;
         ACTION   ( oDialog:End() )

      oDialog:AddFastKey( VK_F5, {|| oDialog:end( IDOK ) } )

   ACTIVATE DIALOG oDialog CENTER

RETURN ( self )

//----------------------------------------------------------------------------//
