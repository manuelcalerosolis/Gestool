#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS TInfPrv FROM TInfGen

   DATA  oEstado     AS OBJECT

   METHOD Create()

   METHod lResource( cFld )

   METHOD lGenerate()

END CLASS

//---------------------------------------------------------------------------//

METHOD Create()

   ::AddField( "Cod",       "C",  12, 0, {|| "" },          "Código",                      .t., "Código",                    10, .f. )
   ::AddField( "Titulo",    "C",  50, 0, {|| "" },          "Nombre",                      .t., "Nombre",                    30, .f. )
   ::AddField( "Nif",       "C",  15, 0, {|| "" },          "N.I.F.",                      .f., "N.I.F.",                    12, .f. )
   ::AddField( "Domicilio", "C", 100, 0, {|| "" },          "Domicilio",                   .t., "Domicilio",                 40, .f. )
   ::AddField( "Poblacion", "C",  35, 0, {|| "" },          "Población",                   .t., "Población",                 40, .f. )
   ::AddField( "Provincia", "C",  20, 0, {|| "" },          "Provincia" ,                  .t., "Provincia" ,                15, .f. )
   ::AddField( "CodPostal", "C",   7, 0, {|| "" },          "Cod. pos.",                   .t., "Código postal",              7, .f. )
   ::AddField( "Telefono",  "C",  20, 0, {|| "" },          "Teléfono",                    .t., "Teléfono",                  10, .f. )
   ::AddField( "Fax",       "C",  20, 0, {|| "" },          "Fax" ,                        .f., "Fax" ,                      10, .f. )
   ::AddField( "Fpago",     "C",   2, 0, {|| "" },          "Pg" ,                         .f., "Forma de pago" ,            10, .f. )
   ::AddField( "Diapago",   "N",   2, 0, {|| "" },          "Dia" ,                        .f., "Dia de pago" ,              10, .f. )

   ::AddTmpIndex ( "cCodCod", "Cod" )
   ::AddTmpIndex ( "cCodTit", "Titulo" )
   ::AddTmpIndex ( "cCodPob", "Poblacion" )
   ::AddTmpIndex ( "cCodPrv", "Provincia" )
   ::AddTmpIndex ( "cCodCdp", "CodPostal" )
   ::AddTmpIndex ( "cCodTlf", "Telefono" )

   ::lDefFecInf   := .f.
   ::lDefSerInf   := .f.
   ::lDefDivInf   := .f.

RETURN ( Self )

//---------------------------------------------------------------------------//

METHod lResource( cFld )

   local cEstado  := "Código"

   if !::StdResource( "INF_PRV01" )
      return .f.
   end if

   /*
   Desde hasta proveedor
   */
   ::oDefPrvInf( 110, 120, 130, 140, 600 )

   REDEFINE CHECKBOX ::lSalto ;
      ID       200 ;
      OF       ::oFld:aDialogs[1]

   ::CreateFilter( aItmPrv(), ::oDbfPrv )
   /*
   Damos valor al meter
   */

   ::oMtrInf:SetTotal( ::oDbfPrv:Lastrec() )

   /*
   Ordenado por
   */

   REDEFINE COMBOBOX ::oEstado ;
      VAR      cEstado ;
      ID       218 ;
      ITEMS    { "Código", "Nombre", "Población", "Provincia", "Código postal", "Teléfono" } ;
      OF       ::oFld:aDialogs[1]

RETURN .t.

//---------------------------------------------------------------------------//
/*
Esta funcion crea la base de datos para generar posteriormente el informe
*/

METHOD lGenerate()

   ::oDlg:Disable()
   ::oDbf:Zap()

   ::aHeader      := {  {|| "Fecha       : " + Dtoc( Date() ) },;
                        {|| "Proveedores : " + if( ::lAllPrv, "Todos", AllTrim( ::cPrvOrg ) + " > " + AllTrim( ::cPrvDes ) ) } }

   ::oDbfPrv:GoTop()
   WHILE !::oDbfPrv:Eof()

      if ( ::lAllPrv .or. ( ::oDbfPrv:Cod >= ::cPrvOrg .and. ::oDbfPrv:Cod <= ::cPrvDes ) ) .and. ::EvalFilter()

         ::oDbf:Append()

         ::oDbf:Cod         := ::oDbfPrv:Cod
         ::oDbf:Titulo      := ::oDbfPrv:Titulo
         ::oDbf:Nif         := ::oDbfPrv:Nif
         ::oDbf:Domicilio   := ::oDbfPrv:Domicilio
         ::oDbf:Poblacion   := ::oDbfPrv:Poblacion
         ::oDbf:Provincia   := ::oDbfPrv:Provincia
         ::oDbf:CodPostal   := ::oDbfPrv:CodPostal
         ::oDbf:Telefono    := ::oDbfPrv:Telefono
         ::oDbf:Fax         := ::oDbfPrv:Fax
         ::oDbf:Fpago       := ::oDbfPrv:Fpago
         ::oDbf:Diapago     := ::oDbfPrv:Diapago

         ::oDbf:Save()

      end if

      ::oDbfPrv:Skip()

      ::oMtrInf:AutoInc( ::oDbfPrv:OrdKeyNo() )

   END DO

   ::oMtrInf:AutoInc( ::oDbfPrv:LastRec() )

   ::oDlg:Enable()

   ::oDbf:OrdSetFocus( ::oEstado:nAt )

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//