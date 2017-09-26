#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

FUNCTION TDCliPed()

   local oInf
   local aCol  := {}
   local aIdx  := {}

   aAdd( aCol, { "CCODCLI", "C", 12, 0, {|| "@!" },         "Cod. cli.",                 .f., "Cod. cliente",               8 } )
   aAdd( aCol, { "CNOMCLI", "C", 50, 0, {|| "@!" },         "Nombre",                    .f., "Nombre cliente",            25 } )
   aAdd( aCol, { "CDOCMOV", "C", 14, 0, {|| "@!" },         "Ped",                       .t., "Pedidos",                   14 } )
   aAdd( aCol, { "DFECMOV", "D",  8, 0, {|| "@!" },         "Fecha",                     .t., "Fecha",                     14 } )
   aAdd( aCol, { "CNIFCLI", "C", 15, 0, {|| "@!" },         "Nif",                       .f., "Nif",                        8 } )
   aAdd( aCol, { "CDOMCLI", "C", 35, 0, {|| "@!" },         "Domicilio",                 .f., "Domicilio",                 10 } )
   aAdd( aCol, { "CPOBCLI", "C", 35, 0, {|| "@!" },         "Población",                 .f., "Población",                 25 } )
   aAdd( aCol, { "CPROCLI", "C", 20, 0, {|| "@!" },         "Provincia",                 .f., "Provincia",                 20 } )
   aAdd( aCol, { "CCDPCLI", "C",  7, 0, {|| "@!" },         "CP",                        .f., "Cod. postal",               20 } )
   aAdd( aCol, { "CTLFCLI", "C", 12, 0, {|| "@!" },         "Tlf",                       .f., "Teléfono",                   7 } )
   aAdd( aCol, { "NTOTNET", "N", 16, 6, {|| oInf:cPicOut }, "Neto",                      .t., "Neto",                      10 } )
   aAdd( aCol, { "NTOTIVA", "N", 16, 6, {|| oInf:cPicOut }, cImp(),                      .t., cImp(),                      10 } )
   aAdd( aCol, { "NTOTREQ", "N", 16, 3, {|| oInf:cPicOut }, "Rec",                       .t., "Rec",                       10 } )
   aAdd( aCol, { "NTOTDOC", "N", 16, 6, {|| oInf:cPicOut }, "Total",                     .t., "Total",                     10 } )
   aAdd( aCol, { "NCOMAGE", "N", 13, 6, {|| oInf:cPicOut }, "Com. age",                  .t., "Comisión agente",           10 } )
   aAdd( aCol, { "CTIPVEN", "C", 20, 0, {|| "@!" },         "Venta",                     .f., "Tipo de venta",             20 } )

   aAdd( aIdx, { "CCODCLI", "CCODCLI" } )

   oInf  := TDiaCPed():New( "Informe totalizado de pedidos de clientes agrupados por clientes", aCol, aIdx, "01045" )

   oInf:AddGroup( {|| oInf:oDbf:cCodCli }, {|| "Cliente  : " + Rtrim( oInf:oDbf:cCodCli ) + "-" + oRetFld( oInf:oDbf:cCodCli, oInf:oDbfCli ) } )

   oInf:Resource()
   oInf:Activate()

   oInf:End()
   oInf  := nil

RETURN NIL

//---------------------------------------------------------------------------//

CLASS TDiaCPed FROM TInfGen

   DATA  lExcCero    AS LOGIC    INIT .f.
   DATA  oEstado     AS OBJECT
   DATA  oPedCliT    AS OBJECT
   DATA  oPedCliL    AS OBJECT
   DATA  oDbfPago    AS OBJECT
   DATA  oDbfIva     AS OBJECT
   DATA  oDbfCli     AS OBJECT
   DATA  aEstado     AS ARRAY    INIT  { "Pendiente", "Parcialmente", "Entregados", "Todos" }

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHOD Resource( cFld )

   METHOD lGenerate()

END CLASS

//---------------------------------------------------------------------------//

METHOD OpenFiles() CLASS TDiaCPed

  local oBlock
  local oError
  local lOpen := .t.

   /*
   Ficheros necesarios
   */

   oBlock   := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   ::oPedCliT := TDataCenter():oPedCliT()

   DATABASE NEW ::oPedCliL  PATH ( cPatEmp() ) FILE "PEDCLIL.DBF" VIA ( cDriver() ) SHARED INDEX "PEDCLIL.CDX"

   DATABASE NEW ::oDbfIva   PATH ( cPatDat() ) FILE "TIVA.DBF"  VIA ( cDriver() ) SHARED INDEX "TIVA.CDX"

   DATABASE NEW ::oDbfPago  PATH ( cPatEmp() ) FILE "FPAGO.DBF"  VIA ( cDriver() ) SHARED INDEX "FPAGO.CDX"

   RECOVER USING oError

      lOpen := .f.

      msgStop( "Imposible abrir todas las bases de datos" )
      ::CloseFiles()

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD CloseFiles() CLASS TDiaCPed

   if !Empty( ::oPedCliT ) .and. ::oPedCliT:Used()
      ::oPedCliT:End()
   end if

   if !Empty( ::oPedCliL ) .and. ::oPedCliL:Used()
      ::oPedCliL:End()
   end if

   if !Empty( ::oDbfIva ) .and. ::oDbfIva:Used()
      ::oDbfIva:End()
   end if

   if !Empty( ::oDbfPago ) .and. ::oDbfPago:Used()
      ::oDbfPago:End()
   end if

   if !Empty( ::oDbfCli ) .and. ::oDbfCli:Used()
      ::oDbfCli:End()
   end if

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD Resource( cFld ) CLASS TDiaCPed

   local cEstado := "Todos"

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

   ::oMtrInf:SetTotal( ::oPedCliT:Lastrec() )

   ::oDefExcInf()

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

METHOD lGenerate() CLASS TDiaCPed

   local bValid   := {|| .t. }
   local lExcCero := .f.

   ::oDlg:Disable()

   ::oDbf:Zap()
   ::oPedCliT:GoTop()

   do case
      case ::oEstado:nAt == 1
         bValid   := {|| ::oPedCliT:nEstado == 1 }
      case ::oEstado:nAt == 2
         bValid   := {|| ::oPedCliT:nEstado == 2 }
      case ::oEstado:nAt == 3
         bValid   := {|| ::oPedCliT:nEstado == 3 }
      case ::oEstado:nAt == 4
         bValid   := {|| .t. }
   end case

   ::aHeader   := {  {|| "Fecha   : " + Dtoc( Date() ) },;
                     {|| "Periodo : " + Dtoc( ::dIniInf ) + " > " + Dtoc( ::dFinInf ) },;
                     {|| "Cliente : " + ::cCliOrg         + " > " + ::cCliDes         },;
                     {|| "Estado  : " + ::aEstado[ ::oEstado:nAt ] } }

   /*
   Nos movemos por las cabeceras de los albaranes a clientes
	*/

   WHILE ! ::oPedCliT:Eof()

      IF Eval( bValid )                                                                     .AND.;
         ::oPedCliT:DFECPED >= ::dIniInf                                                    .AND.;
         ::oPedCliT:DFECPED <= ::dFinInf                                                    .AND.;
         ::oPedCliT:CCODCLI >= ::cCliOrg                                                    .AND.;
         ::oPedCliT:CCODCLI <= ::cCliDes                                                    .AND.;
         lChkSer( ::oPedCliT:CSERPED, ::aSer )

          /*
         Posicionamos en las lineas de detalle --------------------------------
         */

            ::oDbf:Append()

            ::oDbf:CCODCLI := ::oPedCliT:CCODCLI
            ::oDbf:CNOMCLI := ::oPedCliT:CNOMCLI
            ::oDbf:DFECMOV := ::oPedCliT:DFECPED

            ::oDbf:NTOTNET := aTotPedCli (::oPedCliT:CSERPED + Str( ::oPedCliT:NNUMPED ) + ::oPedCliT:CSUFPED, ::oPedCliT:cAlias, ::oPedCliL:cAlias, ::oDbfIva:cAlias, ::oDbfDiv:cAlias, ::oDbfPago:cAlias, nil, cDivEmp())[1]
            ::oDbf:NTOTIVA := aTotPedCli (::oPedCliT:CSERPED + Str( ::oPedCliT:NNUMPED ) + ::oPedCliT:CSUFPED, ::oPedCliT:cAlias, ::oPedCliL:cAlias, ::oDbfIva:cAlias, ::oDbfDiv:cAlias, ::oDbfPago:cAlias, nil, cDivEmp())[2]
            ::oDbf:NTOTREQ := aTotPedCli (::oPedCliT:CSERPED + Str( ::oPedCliT:NNUMPED ) + ::oPedCliT:CSUFPED, ::oPedCliT:cAlias, ::oPedCliL:cAlias, ::oDbfIva:cAlias, ::oDbfDiv:cAlias, ::oDbfPago:cAlias, nil, cDivEmp())[3]
            ::oDbf:nComAge := ::oPedCliL:nComAge
            ::oDbf:NTOTDOC := aTotPedCli (::oPedCliT:CSERPED + Str( ::oPedCliT:NNUMPED ) + ::oPedCliT:CSUFPED, ::oPedCliT:cAlias, ::oPedCliL:cAlias, ::oDbfIva:cAlias, ::oDbfDiv:cAlias, ::oDbfPago:cAlias, nil, cDivEmp())[4]
            ::oDbf:CDOCMOV := ::oPedCliT:CSERPED + "/" + Str( ::oPedCliT:NNUMPED ) + "/" + ::oPedCliT:CSUFPED

            IF ::oDbfCli:Seek ( ::oPedCliT:CCODCLI )

               ::oDbf:CNIFCLI := ::oDbfCli:Nif
               ::oDbf:CDOMCLI := ::oDbfCli:Domicilio
               ::oDbf:CPOBCLI := ::oDbfCli:Poblacion
               ::oDbf:CPROCLI := ::oDbfCli:Provincia
               ::oDbf:CCDPCLI := ::oDbfCli:CodPostal
               ::oDbf:CTLFCLI := ::oDbfCli:Telefono

            END IF

           ::oDbf:Save()

      end if

      ::oPedCliT:Skip()

      ::oMtrInf:AutoInc()

   end while

   ::oDlg:Enable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//






