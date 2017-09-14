#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

/*FUNCTION TDCliFac( lGrpCli )

   local oInf
   local aCol        := {}
   local aIdx        := {}

   DEFAULT lGrpCli   := .t.

   aAdd( aCol, { "CCODCLI", "C", 12, 0, {|| "@!" },         "Cod. cli.",                 .f., "Código cliente",             8 } )
   aAdd( aCol, { "CNOMCLI", "C", 50, 0, {|| "@!" },         "Nombre",                    .f., "Nombre cliente",            25 } )
   aAdd( aCol, { "CDOCMOV", "C", 14, 0, {|| "@!" },         "Factura",                   .t., "Factura",                   14 } )
   aAdd( aCol, { "DFECMOV", "D",  8, 0, {|| "@!" },         "Fecha",                     .t., "Fecha",                     14 } )
   aAdd( aCol, { "CNIFCLI", "C", 15, 0, {|| "@!" },         "Nif",                       .f., "Nif",                        8 } )
   aAdd( aCol, { "CDOMCLI", "C", 35, 0, {|| "@!" },         "Domicilio",                 .f., "Domicilio",                 10 } )
   aAdd( aCol, { "CPOBCLI", "C", 25, 0, {|| "@!" },         "Población",                 .f., "Población",                 25 } )
   aAdd( aCol, { "CPROCLI", "C", 20, 0, {|| "@!" },         "Prov",                      .f., "Provincia",                 20 } )
   aAdd( aCol, { "CCDPCLI", "C",  7, 0, {|| "@!" },         "CP",                        .f., "Cod. Postal",               20 } )
   aAdd( aCol, { "CTLFCLI", "C", 12, 0, {|| "@!" },         "Tlf",                       .f., "Teléfono",                   7 } )
   aAdd( aCol, { "NTOTNET", "N", 16, 6, {|| oInf:cPicOut }, "Neto",                      .t., "Neto",                      10 } )
   aAdd( aCol, { "NTOTIVA", "N", 16, 6, {|| oInf:cPicOut }, cImp(),                       .t., cImp(),                       10 } )
   aAdd( aCol, { "NTOTREQ", "N", 16, 3, {|| oInf:cPicOut }, "Rec",                       .t., "Rec",                       10 } )
   aAdd( aCol, { "NTOTDOC", "N", 16, 6, {|| oInf:cPicOut }, "Total",                     .t., "Total",                     10 } )
   aAdd( aCol, { "NCOMAGE", "N", 13, 6, {|| oInf:cPicOut }, "Com. age",                  .t., "Comisión agente",           10 } )
   aAdd( aCol, { "CTIPVEN", "C", 20, 0, {|| "@!" },         "Venta",                     .f., "Tipo de venta",             20 } )

   if lGrpCli
   aAdd( aIdx, { "CCODCLI", "CCODCLI" } )
   oInf  := TDiaCFac():New( "Informe totalizado de facturas de clientes agrupados por clientes", aCol, aIdx, "01045" )
   oInf:AddGroup( {|| oInf:oDbf:cCodCli }, {|| "Cliente  : " + Rtrim( oInf:oDbf:cCodCli ) + "-" + oRetFld( oInf:oDbf:cCodCli, oInf:oDbfCli ) } )
   else
   aAdd( aIdx, { "DFECMOV", "DFECMOV" } )
   oInf  := TDiaCFac():New( "Diario de facturación de clientes", aCol, aIdx, "01045" )
   end if

   oInf:Resource()
   oInf:Activate()

   oInf:End()
   oInf  := nil

RETURN NIL*/

//---------------------------------------------------------------------------//

CLASS TDiaCFac FROM TInfGen

   DATA  lExcCero    AS LOGIC    INIT .f.
   DATA  oEstado     AS OBJECT
   DATA  oDbfIva     AS OBJECT
   DATA  oFacCliP    AS OBJECT
   DATA  oFacCliT    AS OBJECT
   DATA  oFacCliL    AS OBJECT
   DATA  oAntCliT    AS OBJECT
   DATA  aEstado     AS ARRAY    INIT  { "Pendiente", "Liquidada", "Todas" }
   DATA  lExcCredito AS LOGIC    INIT .f.

   METHOD Create()

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHOD Resource( cFld )

   METHOD lGenerate()

END CLASS

//---------------------------------------------------------------------------//

METHOD create()

   ::AddField( "CCODCLI", "C", 12, 0, {|| "@!" },         "Cod. cli.",                 .f., "Código cliente",             8 )
   ::AddField( "CNOMCLI", "C", 50, 0, {|| "@!" },         "Nombre",                    .f., "Nombre cliente",            25 )
   ::AddField( "CDOCMOV", "C", 14, 0, {|| "@!" },         "Factura",                   .t., "Factura",                   14 )
   ::AddField( "DFECMOV", "D",  8, 0, {|| "@!" },         "Fecha",                     .t., "Fecha",                     14 )
   ::AddField( "CNIFCLI", "C", 15, 0, {|| "@!" },         "Nif",                       .f., "Nif",                        8 )
   ::AddField( "CDOMCLI", "C", 35, 0, {|| "@!" },         "Domicilio",                 .f., "Domicilio",                 10 )
   ::AddField( "CPOBCLI", "C", 25, 0, {|| "@!" },         "Población",                 .f., "Población",                 25 )
   ::AddField( "CPROCLI", "C", 20, 0, {|| "@!" },         "Prov",                      .f., "Provincia",                 20 )
   ::AddField( "CCDPCLI", "C",  7, 0, {|| "@!" },         "CP",                        .f., "Cod. Postal",               20 )
   ::AddField( "CTLFCLI", "C", 12, 0, {|| "@!" },         "Tlf",                       .f., "Teléfono",                   7 )
   ::AddField( "NTOTNET", "N", 16, 6, {|| ::cPicOut },    "Neto",                      .t., "Neto",                      10 )
   ::AddField( "NTOTIVA", "N", 16, 6, {|| ::cPicOut },    cImp(),                       .t., cImp(),                       10 )
   ::AddField( "NTOTREQ", "N", 16, 3, {|| ::cPicOut },    "Rec",                       .t., "Rec",                       10 )
   ::AddField( "NTOTDOC", "N", 16, 6, {|| ::cPicOut },    "Total",                     .t., "Total",                     10 )
   ::AddField( "NCOMAGE", "N", 13, 6, {|| ::cPicOut },    "Com. age",                  .t., "Comisión agente",           10 )
   ::AddField( "CTIPVEN", "C", 20, 0, {|| "@!" },         "Venta",                     .f., "Tipo de venta",             20 )

   if ::xOthers
   ::AddTmpIndex( "CCODCLI", "CCODCLI" )
   ::AddGroup( {|| ::oDbf:cCodCli }, {|| "Cliente  : " + Rtrim( ::oDbf:cCodCli ) + "-" + oRetFld( ::oDbf:cCodCli, ::oDbfCli ) } )
   else
   ::AddTmpIndex( "DFECMOV", "DFECMOV" )
   end if


RETURN ( self )

//---------------------------------------------------------------------------//

METHOD OpenFiles() CLASS TDiaCFac

  local oBlock
  local oError
  local lOpen := .t.

   /*
   Ficheros necesarios
   */

   oBlock   := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   ::oFacCliT := TDataCenter():oFacCliT()
   ::oFacCliT:SetOrder( "DFECFAC" )

   DATABASE NEW ::oFacCliL  PATH ( cPatEmp() ) FILE "FACCLIL.DBF" VIA ( cDriver() ) SHARED INDEX "FACCLIL.CDX"

   DATABASE NEW ::oDbfIva   PATH ( cPatDat() ) FILE "TIVA.DBF"  VIA ( cDriver() ) SHARED INDEX "TIVA.CDX"

   ::oFacCliP := TDataCenter():oFacCliP()

   RECOVER USING oError

      lOpen := .f.

      msgStop( "Imposible abrir todas las bases de datos" )
      ::CloseFiles()

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD CloseFiles() CLASS TDiaCFac

   if !Empty( ::oFacCliT ) .and. ::oFacCliT:Used()
      ::oFacCliT:End()
   end if

   if !Empty( ::oFacCliL ) .and. ::oFacCliL:Used()
      ::oFacCliL:End()
   end if

  if !Empty( ::oDbfCli ) .and. ::oDbfCli:Used()
      ::oDbfCli:End()
   end if

  if !Empty( ::oDbfIva ) .and. ::oDbfIva:Used()
      ::oDbfIva:End()
   end if

  if !Empty( ::oDbfFacCliP ) .and. ::oDbfFacCliP:Used()
      ::oDbfFacCliP:End()
   end if

   if !Empty( ::oAntCliT ) .and. ::oAntCliT:Used()
      ::oAntCliT:End()
   end if

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD Resource( cFld ) CLASS TDiaCFac

   local cEstado := "Todas"

   if !::StdResource( "INF_GEN05" )
      return .f.
   end if

   /*
   Monta los obras de manera automatica
   */

   ::oDefCliInf( 70, 80, 90, 100 )

   /*
   Monta los clientes de manera automatica
   */

   ::lDefArtInf( 110, 120, 130, 140 )

   /*
   Damos valor al meter
   */

   ::oMtrInf:SetTotal( ::oFacCliT:Lastrec() )

   ::oDefExcInf()

   ::oDefResInf()

   REDEFINE CHECKBOX ::lExcCredito ;
      ID       191;
      OF       ::oFld:aDialogs[1]

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

METHOD lGenerate() CLASS TDiaCFac

   local bValid   := {|| .t. }
   local lExcCero := .f.
   local aTotTmp  := {}

   ::oDlg:Disable()

   ::oDbf:Zap()
   ::oFacCliT:GoTop()

   do case
      case ::oEstado:nAt == 1
         bValid   := {|| !::oFacCliT:lLiquidada }
      case ::oEstado:nAt == 2
         bValid   := {|| ::oFacCliT:lLiquidada }
      case ::oEstado:nAt == 3
         bValid   := {|| .t. }
   end case

   ::aHeader   := {  {|| "Fecha   : " + Dtoc( Date() ) },;
                     {|| "Periodo : " + Dtoc( ::dIniInf ) + " > " + Dtoc( ::dFinInf ) },;
                     {|| "Cliente : " + ::cCliOrg         + " > " + ::cCliDes         },;
                     {|| "Estado  : " + ::aEstado[ ::oEstado:nAt ] } }

   /*
   Nos movemos por las cabeceras de los albaranes a clientes
	*/
   WHILE !::oFacCliT:Eof()

      if Eval( bValid )                                                                     .AND.;
         ::oFacCliT:DFECFAC >= ::dIniInf                                                    .AND.;
         ::oFacCliT:DFECFAC <= ::dFinInf                                                    .AND.;
         ::oFacCliT:CCODCLI >= ::cCliOrg                                                    .AND.;
         ::oFacCliT:CCODCLI <= ::cCliDes                                                    .AND.;
         if( ::lExcCredito, lClienteBloquearRiesgo( ::oFacCliT:cCodCli, ::oDbfCli:cAlias ), .t. ) .AND.;
         lChkSer( ::oFacCliT:CSERIE, ::aSer )

         /*
         Posicionamos en las lineas de detalle --------------------------------
         */

         ::oDbf:Append()

         ::oDbf:CCODCLI := ::oFacCliT:CCODCLI
         ::oDbf:CNOMCLI := ::oFacCliT:CNOMCLI
         ::oDbf:DFECMOV := ::oFacCliT:DFECFAC

         aTotTmp        := aTotFacCli (::oFacCliT:CSERIE + Str( ::oFacCliT:NNUMFAC ) + ::oFacCliT:CSUFFAC, ::oFacCliT:cAlias, ::oFacCliL:cAlias, ::oDbfIva:cAlias, ::oDbfDiv:cAlias, ::oFacCliP:cAlias, ::oAntCliT:cAlias, ::cDivInf )

         ::oDbf:NTOTNET := aTotTmp[1] - aTotTmp[5] - aTotTmp[6]
         ::oDbf:NTOTIVA := aTotTmp[2]
         ::oDbf:NTOTREQ := aTotTmp[3]
         ::oDbf:NTOTDOC := aTotTmp[4]
         ::oDbf:CDOCMOV := ::oFacCliT:CSERIE + "/" + Str( ::oFacCliT:NNUMFAC ) + "/" + ::oFacCliT:CSUFFAC

         ::AddCliente( ::oFacCliT:cCodCli, ::oFacCliT, .f. )

         ::oDbf:Save()

      end if

      ::oMtrInf:AutoInc()

      ::oFacCliT:Skip()

   end while

   ::oDlg:Enable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//