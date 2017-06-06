#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

FUNCTION TDCliPre()

   local oInf
   local aCol  := {}
   local aIdx  := {}


   aAdd( aCol, { "CCODCLI", "C", 12, 0, {|| "@!" },         "Cli",                       .f., "Cod. Cliente"              ,  8 } )
   aAdd( aCol, { "CNOMCLI", "C", 50, 0, {|| "@!" },         "Nom",                       .f., "Nombre Cliente"            , 25 } )
   aAdd( aCol, { "CDOCMOV", "C", 14, 0, {|| "@!" },         "Pre",                       .t., "Presupuesto"               , 14 } )
   aAdd( aCol, { "DFECMOV", "D",  8, 0, {|| "@!" },         "Fecha",                     .t., "Fecha"                     , 14 } )
   aAdd( aCol, { "CNIFCLI", "C", 15, 0, {|| "@!" },         "Nif",                       .f., "Nif"                       ,  8 } )
   aAdd( aCol, { "CDOMCLI", "C", 35, 0, {|| "@!" },         "Dom",                       .f., "Domicilio"                 , 10 } )
   aAdd( aCol, { "CPOBCLI", "C", 35, 0, {|| "@!" },         "Pob",                       .f., "Población"                 , 25 } )
   aAdd( aCol, { "CPROCLI", "C", 20, 0, {|| "@!" },         "Prov",                      .f., "Provincia"                 , 20 } )
   aAdd( aCol, { "CCDPCLI", "C",  7, 0, {|| "@!" },         "CP",                        .f., "Cod. Postal"               , 20 } )
   aAdd( aCol, { "CTLFCLI", "C", 12, 0, {|| "@!" },         "Tlf",                       .f., "Teléfono"                  ,  7 } )
   aAdd( aCol, { "NTOTNET", "N", 16, 6, {|| oInf:cPicOut }, "Neto",                      .t., "Neto"                      , 10 } )
   aAdd( aCol, { "NTOTIVA", "N", 16, 6, {|| oInf:cPicOut }, cImp(),                       .t., cImp()                       , 10 } )
   aAdd( aCol, { "NTOTREQ", "N", 16, 3, {|| oInf:cPicOut }, "Rec",                       .t., "Rec"                       , 10 } )
   aAdd( aCol, { "NTOTDOC", "N", 16, 6, {|| oInf:cPicOut }, "Total",                     .t., "Total"                     , 10 } )
   aAdd( aCol, { "NCOMAGE", "N", 13, 6, {|| oInf:cPicOut }, "Com. Age",                  .f., "Comisión agente"           , 20 } )

   aAdd( aIdx, { "CCODCLI", "CCODCLI" } )

   oInf  := TDiaCPre():New( "Informe totalizado de presupuestos de clientes agrupados por clientes", aCol, aIdx, "01045" )

   oInf:AddGroup( {|| oInf:oDbf:cCodCli }, {|| "Cliente  : " + Rtrim( oInf:oDbf:cCodCli ) + "-" + oRetFld( oInf:oDbf:cCodCli, oInf:oDbfCli ) } )

   oInf:Resource()
   oInf:Activate()

   oInf:End()
   oInf  := nil

RETURN NIL

//---------------------------------------------------------------------------//

CLASS TDiaCPre FROM TInfGen

   DATA  lExcCero    AS LOGIC    INIT .f.
   DATA  oEstado     AS OBJECT
   DATA  oPreCliT    AS OBJECT
   DATA  oPreCliL    AS OBJECT
   DATA  oDbfIva     AS OBJECT
   DATA  oDbfPago    AS OBJECT
   DATA  aEstado     AS ARRAY    INIT { "Pendiente", "Aceptado", "Todos" }

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHOD Resource( cFld )

   METHOD lGenerate()

END CLASS

//---------------------------------------------------------------------------//

METHOD OpenFiles() CLASS TDiaCPre

  local oBlock
  local oError
  local lOpen := .t.

   /*
   Ficheros necesarios
   */

   oBlock   := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   ::oPreCliT  := TDataCenter():oPreCliT()

   DATABASE NEW ::oPreCliL  PATH ( cPatEmp() ) FILE "PRECLIL.DBF" VIA ( cDriver() ) SHARED INDEX "PRECLIL.CDX"

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

METHOD CloseFiles() CLASS TDiaCPre

   if !Empty( ::oPreCliT ) .and. ::oPreCliT:Used()
      ::oPreCliT:End()
   end if

   if !Empty( ::oPreCliL ) .and. ::oPreCliL:Used()
      ::oPreCliL:End()
   end if

   if !Empty( ::oDbfIva ) .and. ::oDbfIva:Used()
      ::oDbfIva:End()
   end if

   if !Empty( ::oDbfPago ) .and. ::oDbfPago:Used()
      ::oDbfPago:End()
   end if

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD Resource( cFld ) CLASS TDiaCPre

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

   ::oMtrInf:SetTotal( ::oPreCliT:Lastrec() )

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

METHOD lGenerate() CLASS TDiaCPre

   local bValid   := {|| .t. }
   local lExcCero := .f.

   ::oDlg:Disable()

   ::oDbf:Zap()
   ::oPreCliT:GoTop()
   ::oPreCliL:GoTop()

   do case
      case ::oEstado:nAt == 1
         bValid   := {|| !::oPreCliT:lEstado }
      case ::oEstado:nAt == 2
         bValid   := {|| ::oPreCliT:lEstado }
      case ::oEstado:nAt == 3
         bValid   := {|| .t. }
   end case

	/*
   Nos movemos por las cabeceras de los presupuestos a clientes
	*/

   ::aHeader   := {  {|| "Fecha   : " + Dtoc( Date() ) },;
                     {|| "Periodo : " + Dtoc( ::dIniInf ) + " > " + Dtoc( ::dFinInf ) },;
                     {|| "Cliente : " + ::cCliOrg         + " > " + ::cCliDes         },;
                     {|| "Artículo: " + ::cArtOrg         + " > " + ::cArtDes         },;
                     {|| "Estado  : " + ::aEstado[ ::oEstado:nAt ] } }

   WHILE !::oPreCliT:Eof()

      IF Eval( bValid )                                                                     .AND.;
         ::oPreCliT:DFECPRE >= ::dIniInf                                                    .AND.;
         ::oPreCliT:DFECPRE <= ::dFinInf                                                    .AND.;
         ::oPreCliT:CCODCLI >= ::cCliOrg                                                    .AND.;
         ::oPreCliT:CCODCLI <= ::cCliDes                                                    .AND.;
         lChkSer( ::oPreCliT:CSERPRE, ::aSer )

         /*
         Posicionamos en las lineas de detalle --------------------------------
         */

            ::oDbf:Append()

            ::oDbf:CCODCLI := ::oPreCliT:CCODCLI
            ::oDbf:CNOMCLI := ::oPreCliT:CNOMCLI
            ::oDbf:DFECMOV := ::oPreCliT:DFECPRE
            ::oDbf:NTOTNET := aTotPreCli (::oPreCliT:CSERPRE + Str( ::oPreCliT:NNUMPRE ) + ::oPreCliT:CSUFPRE, ::oPreCliT:cAlias, ::oPreCliL:cAlias, ::oDbfIva:cAlias, ::oDbfDiv:cAlias, ::oDbfPago:cAlias, nil, cDivEmp())[1]
            ::oDbf:NTOTIVA := aTotPreCli (::oPreCliT:CSERPRE + Str( ::oPreCliT:NNUMPRE ) + ::oPreCliT:CSUFPRE, ::oPreCliT:cAlias, ::oPreCliL:cAlias, ::oDbfIva:cAlias, ::oDbfDiv:cAlias, ::oDbfPago:cAlias, nil, cDivEmp())[2]
            ::oDbf:NTOTREQ := aTotPreCli (::oPreCliT:CSERPRE + Str( ::oPreCliT:NNUMPRE ) + ::oPreCliT:CSUFPRE, ::oPreCliT:cAlias, ::oPreCliL:cAlias, ::oDbfIva:cAlias, ::oDbfDiv:cAlias, ::oDbfPago:cAlias, nil, cDivEmp())[3]
            ::oDbf:nComAge := ::oPreCliL:nComAge
            ::oDbf:NTOTDOC := aTotPreCli (::oPreCliT:CSERPRE + Str( ::oPreCliT:NNUMPRE ) + ::oPreCliT:CSUFPRE, ::oPreCliT:cAlias, ::oPreCliL:cAlias, ::oDbfIva:cAlias, ::oDbfDiv:cAlias, ::oDbfPago:cAlias, nil, cDivEmp())[4]
            ::oDbf:CDOCMOV := ::oPreCliT:CSERPRE + "/" + Str( ::oPreCliT:NNUMPRE ) + "/" + ::oPreCliT:CSUFPRE

            IF ::oDbfCli:Seek ( ::oPreCliT:CCODCLI )

               ::oDbf:CNIFCLI := ::oDbfCli:Nif
               ::oDbf:CDOMCLI := ::oDbfCli:Domicilio
               ::oDbf:CPOBCLI := ::oDbfCli:Poblacion
               ::oDbf:CPROCLI := ::oDbfCli:Provincia
               ::oDbf:CCDPCLI := ::oDbfCli:CodPostal
               ::oDbf:CTLFCLI := ::oDbfCli:Telefono

            END IF

            ::oDbf:Save()

      end if

      ::oPreCliT:Skip()

      ::oMtrInf:AutoInc()

   end while

   ::oDlg:Enable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//





