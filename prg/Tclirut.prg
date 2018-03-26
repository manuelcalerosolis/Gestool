#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

FUNCTION TCliRut()

   local oInf
   local aCol  := {}
   local aIdx  := {}


   aAdd( aCol, { "CCODRUT", "C",  4, 0, {|| "@!" },         "Ruta",                  .f., "Codigo Ruta"            } )
   aAdd( aCol, { "CCODCLI", "C", 12, 0, {|| "@!" },         "Cod Cli",               .f., "Codigo Cliente"         } )
   aAdd( aCol, { "CCODFAM", "C", 16, 0, {|| "@!" },         "Cod Fam",               .f., "Codigo Familia"         } )
   aAdd( aCol, { "CNOMCLI", "C", 30, 0, {|| "@!" },         "Cliente",               .t., "Nombre Cliente"         } )
   aAdd( aCol, { "DFECMOV", "D",  8, 0, {|| "@!" },         "Fecha",                 .f., "Fecha"                  } )
   aAdd( aCol, { "NIMPART", "N", 16, 6, {|| oInf:cPicOut }, "Imp",                   .t., "Importe"                } )
   aAdd( aCol, { "NNUMCAJ", "N", 16, 6, {|| MasUnd() },     "Cajas",                 .f., "Unidades x Caja"        } )
   aAdd( aCol, { "NNUMUND", "N", 16, 6, {|| MasUnd() },     "Unidades",              .t., "Unidades"               } )
   aAdd( aCol, { "NCOMAGE", "N", 16, 6, {|| oInf:cPicOut }, "Com Age",               .f., "Comisión Agente"        } )
   aAdd( aCol, { "NACUIMP", "N", 16, 6, {|| oInf:cPicOut }, "Imp Acu",               .t., "Importe Acumulado"      } )
   aAdd( aCol, { "NACUCAJ", "N", 16, 6, {|| MasUnd() },     "Caj Acu",               .t., "Cajas Acumulada"        } )
   aAdd( aCol, { "NACUUND", "N", 16, 6, {|| MasUnd() },     "Und Acu",               .t., "Unidades Acumuladas"    } )
   aAdd( aCol, { "NTOTMOV", "N", 16, 6, {|| oInf:cPicOut }, "Total",                 .t., "Total"     } )

   aAdd( aIdx, { "CODRUT", "CCODRUT + CCODCLI" } )

   oInf  := TCliRutas():New( "Facturación por rutas", aCol, aIdx, "01046" )

   oInf:AddGroup( {|| oInf:oDbf:cCodRut},                     {|| "Rutas  : " + Rtrim( oInf:oDbf:cCodRut ) + "-" + oRetFld( oInf:oDbf:cCodRut, oInf:oDbfRut ) } )

   oInf:Resource()
   oInf:Activate()

   oInf:End()
   oInf  := nil

RETURN NIL

//---------------------------------------------------------------------------//

CLASS TCliRutas FROM TInfGen

   DATA  lExcCero    AS LOGIC    INIT .f.
   DATA  lTvta       AS LOGIC    INIT .f.
   DATA  oEstado     AS OBJECT
   DATA  oFacCliT    AS OBJECT
   DATA  oFacCliL    AS OBJECT
   DATA  oDbfRut     AS OBJECT
   DATA  cEstado     AS CHARACTER     INIT  "Todas"
   DATA  aEstado     AS ARRAY    INIT  { "Pendientes", "Cobradas", "Todas" }
   DATA  cRutDesde   AS CHAR
   DATA  cRutHasta   AS CHARACTER

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHOD Resource( cFld )

   METHOD lGenerate()

END CLASS

//---------------------------------------------------------------------------//

METHOD OpenFiles() CLASS TCliRutas

  local oBlock
  local oError
  local lOpen := .t.

   /*
   Ficheros necesarios
   */

   oBlock   := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   ::oFacCliT := TDataCenter():oFacCliT()
   ::oFacCliT:SetOrder("CCODCLI")

   DATABASE NEW ::oFacCliL  PATH ( cPatEmp() ) FILE "FACCLIL.DBF" VIA ( cDriver() ) SHARED INDEX "FACCLIL.CDX"

   DATABASE NEW ::oDbfRut   PATH ( cPatEmp() ) FILE "RUTA.DBF" VIA ( cDriver() ) SHARED INDEX "RUTA.CDX"

   DATABASE NEW ::oDbfArt   PATH ( cPatEmp() ) FILE "ARTICULO.DBF" VIA ( cDriver() ) SHARED INDEX "ARTICULO.CDX"

   RECOVER USING oError

      lOpen := .f.

      msgStop( "Imposible abrir todas las bases de datos" )
      ::CloseFiles()

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD CloseFiles() CLASS TCliRutas

   if !Empty( ::oFacCliT ) .and. ::oFacCliT:Used()
      ::oFacCliT:End()
   end if

   if !Empty( ::oFacCliL ) .and. ::oFacCliL:Used()
      ::oFacCliL:End()
   end if

   if !Empty( ::oDbfRut ) .and. ::oDbfRut:Used()
      ::oDbfRut:End()
   end if

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD Resource( cFld ) CLASS TCliRutas

   local oRutDesde
   local oRutHasta
   local oRutDesTx
   local cRutDesTx
   local oRutHasTx
   local cRutHasTx
   local This        := Self

   if !::StdResource( "INF_GEN20" )
      return .f.
   end if

   /*
   Monta los obras de manera automatica
   */

   ::oDefCliInf( 110, 120, 130, 140 )

   /*
   Monta los articulos de manera automatica
   */

   ::lDefFamInf( 150, 160, 170, 180 )

   /*
   Montamos desde - hasta rutas
   */

   ::cRutDesde   := dbFirst( ::oDbfRut, 1 )
   ::cRutHasta   := dbLast ( ::oDbfRut, 1 )
   cRutDesTx     := dbFirst( ::oDbfRut, 2 )
   cRutHasTx     := dbLast ( ::oDbfRut, 2 )

   REDEFINE GET oRutDesde VAR ::cRutDesde ;
      ID       70 ;
      VALID    cRuta( oRutDesde, this:cAlias, oRutDesTx ) ;
      BITMAP   "LUPA" ;
      ON HELP  BrwRuta( oRutDesde, this:cAlias, oRutDesTx );
      OF       ::oFld:aDialogs[1]

   REDEFINE GET oRutDesTx VAR cRutDesTx ;
		WHEN 		.F.;
      ID       80 ;
      OF       ::oFld:aDialogs[1]

   REDEFINE GET oRutHasta VAR ::cRutHasta ;
      ID       90 ;
      VALID    cRuta( oRutHasta, this:cAlias, oRutHasTx );
      BITMAP   "LUPA" ;
      ON HELP  BrwRuta( oRutHasta, this:cAlias, oRutHasTx );
      OF       ::oFld:aDialogs[1]

   REDEFINE GET oRutHasTx VAR cRutHasTx ;
		WHEN 		.F.;
      ID       100 ;
      OF       ::oFld:aDialogs[1]

   /*
   Damos valor al meter
   */

   ::oMtrInf:SetTotal( ::oDbfCli:Lastrec() )

   ::oDefResInf()

   /*REDEFINE COMBOBOX ::oEstado ;
      VAR      cEstado ;
      ID       218 ;
      ITEMS    ::aEstado ;
      OF       ::oFld:aDialogs[1] */

RETURN ( Self )

//---------------------------------------------------------------------------//
/*
Esta funcion crea la base de datos para generar posteriormente el informe
*/

METHOD lGenerate() CLASS TCliRut

   local bValid   := {|| .t. }
   local lExcCero := .f.

   ::oDlg:Disable()

   ::oDbf:Zap()
   ::oDbfCli:GoTop()

   /*do case
      case ::oEstado:nAt == 1
         bValid   := {|| !::oFacCliT:lLiquidada }
      case ::oEstado:nAt == 2
         bValid   := {|| ::oFacCliT:lLiquidada }
      case ::oEstado:nAt == 3
         bValid   := {|| .t. }
   end case*/

     ::aHeader   := {{|| "Fecha    : " + Dtoc( Date() ) },;
                     {|| "Periodo  : " + Dtoc( ::dIniInf )  + " > " + Dtoc( ::dFinInf ) },;
                     {|| "Clientes : " + Rtrim( ::cCliOrg ) + " > " + Rtrim( ::cCliDes ) },;
                     {|| "Rutas    : " + Rtrim( ::cRutDesde ) + " > " + Rtrim( ::cRutHasta ) },;
                     {|| "Familias : " + Rtrim( ::cFamOrg ) + " > " + Rtrim( ::cFamDes ) } }
                     //{|| "Estado   : " + ::aEstado[ ::oEstado:nAt ] } }

/*
 Como Tefesa, quiere que le salgan todos los clientes, consuman o no, vamos a ir buscando
 cliente a cliente, lo que relentizará un poco el informe
*/

while !::oDbfCli:Eof()

/* Buscamos el cliente en las facturas - si lo encontramos . . .  */

   if ::oFacCliT:Seek( ::oDbfCli:Cod )

      /* Comprobamos que cumple las condiciones */

      while ::oFacCliT:cCodCli == ::oDbfCli:Cod       .AND. ;
            ::oFacCliT:cCodRut >= ::cRutDesde         .AND. ;
            ::oFacCliT:cCodRut <= ::cRutHasta         .AND. ;
            lChkSer( ::oFacCliT:CSERIE, ::aSer )
            //Eval( bValid )                            .AND. ;

            /* Buscamos ahora en las lineas de detalle en busca del consumo */

            if ::oFacCliL:Seek( ::oFacCliT:cSerie + Str( ::oFacCliT:nNumFac ) + ::oFacCliT:cSufFac )

               /* Para el acumulado vemos las fechas - si está entre fecha sumamos */

               if ::oFacCliT:dFecFac >= ::dIniInf                                   .AND. ;
                  ::oFacCliT:dFecFac <= ::dFinInf                                   .AND. ;
                  ::oFacCliL:cCodFam >= ::cFamOrg                                   .AND. ;
                  ::oFacCliL:cCodFam <= ::cFamDes

                  ::oDbf:Append()

                  ::oDbf:cCodRut := ::oFacCliT:cCodRut
                  ::oDbf:cCodCli := ::oFacCliT:cCodCli
                  ::oDbf:cCodFam := retFamArt( ::oFacCliL:cRef, ::oDbfArt )
                  ::oDbf:cNomCli := ::oFacCliT:cNomCli
                  ::oDbf:dFecMov := ::oFacCliT:dFecFac
                  ::oDbf:nImpArt += ::oFacCliL:nPreUnit
                  ::oDbf:nNumCaj += ::oFacCliL:nCanEnt
                  ::oDbf:nNumUnd += ::oFacCliL:nUniCaja
                  ::oDbf:nComAge += nComLFacCli( ::oFacCliT:cAlias, ::oFacCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
                  ::oDbf:nTotMov += nImpLFacCli( ::oFacCliT:cAlias, ::oFacCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv, .f., .t., .f., .f. )
                  ::oDbf:nAcuImp += ::oFacCliL:nPreUnit
                  ::oDbf:nAcuCaj += ::oFacCliL:nCanEnt
                  ::oDbf:nAcuUnd += ::oFacCliL:nUniCaja

                  ::oDbf:Save()

               /* Si no acumulamos */

               else

                  if ( ::oDbf:Seek( ::oFacCliT:cCodRut + ::oFacCliT:cCodCli ) )
                     ::oDbf:Load()

                     ::oDbf:nAcuImp += ::oFacCliL:nPreUnit
                     ::oDbf:nAcuCaj += ::oFacCliL:nCanEnt
                     ::oDbf:nAcuUnd += ::oFacCliL:nUniCaja

                     ::oDbf:Save()
                  else

                     ::oDbf:Append()

                     ::oDbf:cCodRut := ::oFacCliT:cCodRut
                     ::oDbf:cCodCli := ::oFacCliT:cCodCli
                     ::oDbf:cCodFam := ::oFacCliL:cCodFam
                     ::oDbf:cNomCli := ::oFacCliT:cNomCli
                     ::oDbf:dFecMov := ::oFacCliT:dFecFac
                     ::oDbf:nTotMov += nImpLFacCli( ::oFacCliT:cAlias, ::oFacCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv, .f., .t., .f., .f. )
                     ::oDbf:nAcuImp += ::oFacCliL:nPreUnit
                     ::oDbf:nAcuCaj += ::oFacCliL:nCanEnt
                     ::oDbf:nAcuUnd += ::oFacCliL:nUniCaja

                     ::oDbf:Save()

                  end if

               end if

            end if

            ::oFacCliT:Skip()

      end while

   /* Si el cliente no tiene facturas - lo ponemos todo a cero*/

   else

      ::oDbf:Append()

      ::oDbf:cCodRut := ::oFacCliT:cCodRut
      ::oDbf:cCodCli := ::oFacCliT:cCodCli
      ::oDbf:cCodFam := ::oFacCliL:cCodFam
      ::oDbf:cNomCli := ::oFacCliT:cNomCli
      ::oDbf:dFecMov := ::oFacCliT:dFecFac
      ::oDbf:nImpArt := 0
      ::oDbf:nNumCaj := 0
      ::oDbf:nNumUnd := 0
      ::oDbf:nComAge := 0
      ::oDbf:nTotMov := 0
      ::oDbf:nAcuImp := 0
      ::oDbf:nAcuCaj := 0
      ::oDbf:nAcuUnd := 0

      ::oDbf:Save()

   end if

   ::oDbfCli:Skip()

   ::oMtrInf:AutoInc( ::oDbfCli:OrdKeyNo() )

   end while

   ::oDlg:Enable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//