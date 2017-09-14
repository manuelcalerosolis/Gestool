#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

FUNCTION TRutCli()

   local oInf
   local aCol  := {}
   local aIdx  := {}

   aAdd( aCol, { "CCODRUT", "C",  4, 0, {|| "@!" },          "Ruta",      .f., "Codigo ruta",                4} )
   aAdd( aCol, { "CCODCLI", "C", 12, 0, {|| "@!" },          "Cli.",      .f., "Codigo cliente",             9} )
   aAdd( aCol, { "CCODFAM", "C", 16, 0, {|| "@!" },          "Fam.",      .t., "Codigo familia",             5} )
   aAdd( aCol, { "CNOMFAM", "C", 30, 0, {|| "@!" },          "Nom. Fam.", .t., "Nombre familia",            30} )
   aAdd( aCol, { "CNOMCLI", "C", 50, 0, {|| "@!" },          "Nombre",    .f., "Nombre cliente",            35} )
   aAdd( aCol, { "DFECMOV", "D",  8, 0, {|| "@!" },          "Fecha",     .f., "Fecha",                      8} )
   aAdd( aCol, { "NIMPART", "N", 16, 6, {|| oInf:cPicOut  }, "Imp.",      .t., "Importe",                    8} )
   aAdd( aCol, { "NNUMCAJ", "N", 16, 6, {|| MasUnd() },      "Caj.",      .f., "Cajas",                      8} )
   aAdd( aCol, { "NNUMUND", "N", 16, 6, {|| MasUnd() },      "Und.",      .f., "Unidades",                   8} )
   aAdd( aCol, { "NUNDCAJ", "N", 16, 6, {|| MasUnd() },      "Tot. und.", .t., "Unidades por caja",          8} )
   aAdd( aCol, { "NCOMAGE", "N", 16, 6, {|| oInf:cPicOut  }, "Com. age.", .f., "Comisión agente",            8} )
   aAdd( aCol, { "NACUIMP", "N", 16, 6, {|| oInf:cPicOut  }, "Imp. acu.", .f., "Importe acumulado",          8} )
   aAdd( aCol, { "NACUCAJ", "N", 16, 6, {|| MasUnd() },      "Caj. acu.", .f., "Cajas acumuladas" ,          8} )
   aAdd( aCol, { "NACUUND", "N", 16, 6, {|| MasUnd() },      "Und. acu.", .f., "Unidades acumuladas" ,       8} )
   aAdd( aCol, { "NACUUXC", "N", 16, 6, {|| MasUnd() },      "Tot. und. acu.", .t., "Acumulado Cajas x Unidades", 8} )
   aAdd( aCol, { "NTOTMOV", "N", 16, 6, {|| oInf:cPicOut },  "Total",     .t., "Total" ,                    10} )

   aAdd( aIdx, { "CCODRUT", "CCODRUT + CCODCLI + CCODFAM" } )

   oInf  := TRutCliInf():New( "Familias en factutas de clientes por rutas", aCol, aIdx, "01049" )

   oInf:AddGroup( {|| oInf:oDbf:cCodRut },                     {|| "Ruta  : " + Rtrim( oInf:oDbf:cCodRut ) + "-" + oRetFld( oInf:oDbf:cCodRut, oInf:oDbfRut ) } , {|| "Total Ruta... "   } )
   oInf:AddGroup( {|| oInf:oDbf:cCodRut + oInf:oDbf:cCodCli }, {|| "Cliente : " + Rtrim( oInf:oDbf:cCodCli ) + "-" + oRetFld( oInf:oDbf:cCodCli, oInf:oDbfCli ) }, {|| "Total Cliente... " } )

   oInf:Resource()
   oInf:Activate()

   oInf:End()
   oInf  := nil

RETURN NIL

//---------------------------------------------------------------------------//

CLASS TRutCliInf FROM TInfGen

   DATA  lResumen    AS LOGIC    INIT .f.
   DATA  lExcCero    AS LOGIC    INIT .f.
   DATA  oEstado     AS OBJECT
   DATA  oAlbCliT    AS OBJECT
   DATA  oAlbCliL    AS OBJECT
    
   DATA  aEstado     AS ARRAY    INIT  { "No Facturado", "Facturado", "Todos" } ;

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHOD Resource( cFld )

   METHOD lGenerate()

END CLASS

//---------------------------------------------------------------------------//

METHOD OpenFiles()

   /*
   Ficheros necesarios
   */

   ::oAlbCliT := TDataCenter():oAlbCliT()
   ::oAlbCliT:SetOrder( "CCODCLI" )

   DATABASE NEW ::oAlbCliL PATH ( cPatEmp() ) FILE "ALBCLIL.DBF" VIA ( cDriver() ) SHARED INDEX "ALBCLIL.CDX"

   DATABASE NEW ::oDbfArt PATH ( cPatArt() ) FILE "ARTICULO.DBF" VIA ( cDriver() ) SHARED INDEX "ARTICULO.CDX"

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD CloseFiles()

   ::oAlbCliT:End()
   ::oAlbCliL:End()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD Resource( cFld )

   local cEstado := "Todos"

   if !::StdResource( "INF_GEN21" )
      return .f.
   end if

   /*
   Monta las rutas de manera automatica
   */

   ::oDefRutInf( 70, 80, 90, 100 )

   /*
   Monta los clientes de manera automatica
   */

   ::oDefCliInf( 110, 120, 130, 140 )

   /*
   Monta las familias de manera automatica
   */

   ::lDefFamInf( 150, 160, 170, 180 )

   /*
   Damos valor al meter
   */

   ::oMtrInf:SetTotal( ::oDbfCli:Lastrec() )

   //::oDefExcInf()

   ::oDefResInf()

   REDEFINE COMBOBOX ::oEstado ;
      VAR      cEstado ;
      ID       218 ;
      ITEMS    ::aEstado ;
      OF       ::oFld:aDialogs[1]

RETURN ( Self )

//---------------------------------------------------------------------------//
/*
Esta funcion crea la base de datos para generar posteriormente el informe
*/

METHOD lGenerate()

   local bValid   := {|| .t. }
   local lExcCero := .f.

   ::oDlg:Disable()

   ::oDbf:Zap()
   ::oDbfCli:GoTop()

   do case
      case ::oEstado:nAt == 1
         bValid   := {|| !lFacturado( ::oAlbCliT ) }
      case ::oEstado:nAt == 2
         bValid   := {|| lFacturado( ::oAlbCliT ) }
      case ::oEstado:nAt == 3
         bValid   := {|| .t. }
   end case

   ::aHeader   := {  {|| "Fecha   : " + Dtoc( Date() ) },;
                     {|| "Periodo : " + Dtoc( ::dIniInf ) + " > " + Dtoc( ::dFinInf ) },;
                     {|| "Rutas   : " + ::cRutOrg         + " > " + ::cRutDes },;
                     {|| "Clientes: " + ::cCliOrg         + " > " + ::cCliDes },;
                     {|| "Familias: " + ::cFamOrg       + " > " + ::cFamDes },;
                     {|| "Estado  : " + ::aEstado[ ::oEstado:nAt ] } }

/*
Nos movemos por los clientes porque tefesa quiere que le digamos aquellos que no consumen
*/

while !::oDbfCli:Eof()

/*
Buscamos el cliente en las cabeceras - si lo encontramos . . .
*/

   if ::oAlbCliT:Seek( ::oDbfCli:Cod )

      /*
      Comprobamos que cumple las condiciones
      */

      if ::oAlbCliT:cCodRut >= ::cRutOrg .and. ::oAlbCliT:cCodRut <= ::cRutDes .and.;
         ::oAlbCliT:cCodCli >= ::cCliOrg .and. ::oAlbCliT:cCodCli <= ::cCliDes .and.;
         lChkSer( ::oAlbCliT:CSERALB, ::aSer )                                 .and.;
         Eval( bValid )

         /*
         Nos posicionamos en las líneas del documento para ver las unidades de los artículos
         */

         if ::oAlbCliL:Seek( ::oAlbCliT:cSerAlb + Str( ::oAlbCliT:nNumAlb ) + ::oAlbCliT:cSufAlb )

            /*
            Comprobamos condiciones de fechas para el acumulado
            */

            if ::oAlbCliT:dFecAlb >= ::dIniInf .and. ::oAlbCliT:dFecAlb <= ::dFinInf

               while ::oAlbCliL:cSerAlb + Str( ::oAlbCliL:nNumAlb ) + ::oAlbCliL:cSufAlb == ::oAlbCliT:cSerAlb + Str( ::oAlbCliT:nNumAlb ) + ::oAlbCliT:cSufAlb .and. !::oAlbCliL:eof()

                  if cCodFam( ::oAlbCliL:cRef, ::oDbfArt ) >= ::cFamOrg .and. cCodFam( ::oAlbCliL:cRef, ::oDbfArt ) <= ::cFamDes

                     /*
                     Cumple todas y añadimos
                     */

                     if !::oDbf:Seek( ::oAlbCliT:cCodRut + ::oAlbCliT:cCodCli + cCodFam( ::oAlbCliL:cRef, ::oDbfArt ) )

                        ::oDbf:Append()

                        ::oDbf:cCodRut := ::oAlbCliT:cCodRut
                        ::oDbf:cCodCli := ::oAlbCliT:cCodCli
                        ::oDbf:cCodFam := cCodFam( ::oAlbCliL:cRef, ::oDbfArt )
                        ::oDbf:cNomCli := ::oAlbCliT:cNomcli
                        ::oDbf:dFecMov := ::oAlbCliT:dFecAlb
                        ::oDbf:nImpArt := ::oAlbCliL:nPreUnit
                        ::oDbf:nNumCaj := ::oAlbCliL:nCanEnt
                        ::oDbf:nNumUnd := ::oAlbCliL:nUniCaja
                        ::oDbf:nUndCaj := NotCaja( ::oAlbCliL:nCanEnt ) * ::oAlbCliL:nUniCaja
                        ::oDbf:nComAge := ( NotCaja( ::oAlbCliL:nCanEnt ) * ::oAlbCliL:nUniCaja ) * ::oAlbCliL:nComAge
                        ::oDbf:nAcuImp += ::oAlbCliL:nPreUnit
                        ::oDbf:nAcuCaj += ::oAlbCliL:nCanEnt
                        ::oDbf:nAcuUnd += ::oAlbCliL:nUniCaja
                        ::oDbf:nAcuUxc += NotCaja( ::oAlbCliL:nCanEnt ) * ::oAlbCliL:nUniCaja
                        ::oDbf:nTotMov := nImpLAlbCli( ::oAlbCliT:cAlias, ::oAlbCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )

                        ::oDbf:Save()

                     else

                        ::oDbf:Load()

                        ::oDbf:nImpArt += ::oAlbCliL:nPreUnit
                        ::oDbf:nNumCaj += ::oAlbCliL:nCanEnt
                        ::oDbf:nNumUnd += ::oAlbCliL:nUniCaja
                        ::oDbf:nUndCaj += NotCaja( ::oAlbCliL:nCanEnt ) * ::oAlbCliL:nUniCaja
                        ::oDbf:nComAge += ( NotCaja( ::oAlbCliL:nCanEnt ) * ::oAlbCliL:nUniCaja ) * ::oAlbCliL:nComAge
                        ::oDbf:nAcuImp += ::oAlbCliL:nPreUnit
                        ::oDbf:nAcuCaj += ::oAlbCliL:nCanEnt
                        ::oDbf:nAcuUnd += ::oAlbCliL:nUniCaja
                        ::oDbf:nAcuUxc += NotCaja( ::oAlbCliL:nCanEnt ) * ::oAlbCliL:nUniCaja

                        ::oDbf:Save()

                     end if

                 end if

                 ::oAlbCliL:Skip()

                end while

            else

               /*
               no cumple fechas, sólo acumulamos
               */

               if !::oDbf:Seek( ::oAlbCliT:cCodRut + ::oAlbCliT:cCodCli + cCodFam( ::oAlbCliL:cRef, ::oDbfArt ) )

                  ::oDbf:Append()

                  ::oDbf:cCodRut := ::oAlbCliT:cCodRut
                  ::oDbf:cCodCli := ::oAlbCliT:cCodCli
                  ::oDbf:cCodFam := cCodFam( ::oAlbCliL:cRef, ::oDbfArt )
                  ::oDbf:cNomCli := ::oAlbCliT:cNomcli
                  ::oDbf:dFecMov := ::oAlbCliT:dFecAlb
                  ::oDbf:nImpArt := 0
                  ::oDbf:nNumCaj := 0
                  ::oDbf:nNumUnd := 0
                  ::oDbf:nUndCaj := 0
                  ::oDbf:nComAge := 0
                  ::oDbf:nAcuImp += ::oAlbCliL:nPreUnit
                  ::oDbf:nAcuCaj += ::oAlbCliL:nCanEnt
                  ::oDbf:nAcuUnd += ::oAlbCliL:nUniCaja
                  ::oDbf:nAcuUxc += NotCaja( ::oAlbCliL:nCanEnt ) * ::oAlbCliL:nUniCaja
                  ::oDbf:nTotMov := nImpLAlbCli( ::oAlbCliT:cAlias, ::oAlbCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )

                  ::oDbf:Save()

               else

                  ::oDbf:Load()

                  ::oDbf:nAcuImp += ::oAlbCliL:nPreUnit
                  ::oDbf:nAcuCaj += ::oAlbCliL:nCanEnt
                  ::oDbf:nAcuUnd += ::oAlbCliL:nUniCaja
                  ::oDbf:nAcuUxc += NotCaja( ::oAlbCliL:nCanEnt ) * ::oAlbCliL:nUniCaja

                  ::oDbf:Save()

               end if

           end if

         end if

      end if

   end if

   ::oDbfCli:Skip()

   ::oMtrInf:AutoInc( ::oDbfCli:OrdKeyNo() )

end while

::oDlg:Enable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//