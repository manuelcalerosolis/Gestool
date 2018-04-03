#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

FUNCTION TInfTkc()

   local oInf
   local aCol  := {}
   local aIdx  := {}

   aAdd( aCol, { "CCODART", "C", 18, 0, {|| "@!" },         "Art",                        .f., "Cod. Artículo",              14 } )
   aAdd( aCol, { "CCODALM", "C", 16, 0, {|| "@!" },         "Alm",                        .f., "Cod. Almacén",                3 } )
   aAdd( aCol, { "CCODCLI", "C", 12, 0, {|| "@!" },         "Cli",                        .t., "Cod. Cliente",                9 } )
   aAdd( aCol, { "CNOMCLI", "C", 50, 0, {|| "@!" },         "Nom",                        .t., "Nombre Cliente",             35 } )
   aAdd( aCol, { "CNIFCLI", "C", 15, 0, {|| "@!" },         "Nif",                        .f., "Nif",                        15 } )
   aAdd( aCol, { "CDOMCLI", "C", 35, 0, {|| "@!" },         "Dom",                        .f., "Domicilio",                  35 } )
   aAdd( aCol, { "CPOBCLI", "C", 35, 0, {|| "@!" },         "Pob",                        .f., "Población",                  25 } )
   aAdd( aCol, { "CPROCLI", "C", 20, 0, {|| "@!" },         "Prov",                       .f., "Provincia",                  20 } )
   aAdd( aCol, { "CCDPCLI", "C",  7, 0, {|| "@!" },         "CP",                         .f., "Cod. Postal",                 7 } )
   aAdd( aCol, { "CTLFCLI", "C", 12, 0, {|| "@!" },         "Tlf",                        .f., "Teléfono",                   12 } )
   aAdd( aCol, { "NUNTENT", "N", 13, 6, {|| MasUnd() },     "Und.",                       .t., "Unidades",                    8 } )
   aAdd( aCol, { "NPREDIV", "N", 16, 6, {|| oInf:cPicOut }, "Importe",                    .t., "Importe",                     8 } )
   aAdd( aCol, { "CDOCMOV", "C", 14, 0, {|| "@!" },         "Tik",                        .t., "Tiktura",                     8 } )
   aAdd( aCol, { "DFECMOV", "D",  8, 0, {|| "@!" },         "Fecha",                      .t., "Fecha",                       8 } )
   aAdd( aCol, { "CTIPVEN", "C", 20, 0, {|| "@!" },         "Venta",                      .f., "Tipo de Venta",              10 } )

   aAdd( aIdx, { "CCODALM", "CCODALM + CCODART" } )

   oInf  := TInfDetTkc():New( "Informe detallado de facturas de clientes agrupados por almacenes", aCol, aIdx, "01044" )

   oInf:AddGroup( {|| oInf:oDbf:cCodAlm },                     {|| "Almacén  : " + Rtrim( oInf:oDbf:cCodAlm ) + "-" + oRetFld( oInf:oDbf:cCodAlm, oInf:oDbfAlm ) }, {||"Total almacén..."} )
   oInf:AddGroup( {|| oInf:oDbf:cCodAlm + oInf:oDbf:cCodArt }, {|| "Artículo : " + Rtrim( oInf:oDbf:cCodArt ) + "-" + oRetFld( oInf:oDbf:cCodArt, oInf:oDbfArt ) }, {||""} )

   oInf:Resource()
   oInf:Activate()

   oInf:End()

RETURN NIL

//---------------------------------------------------------------------------//

CLASS TInfDetTkc FROM TInfGen

   DATA  lResumen    AS LOGIC    INIT .f.
   DATA  lExcCero    AS LOGIC    INIT .f.
   DATA  oEstado     AS OBJECT
   DATA  oTikCliT    AS OBJECT
   DATA  oTikCliL    AS OBJECT
   DATA  aEstado     AS ARRAY    INIT { "Pendientes", "Cobradas", "Todas" }

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHod lResource( cFld )

   METHOD lGenerate()

END CLASS

//---------------------------------------------------------------------------//

METHOD OpenFiles()

   local lOpen    := .t.
   local oBlock   := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   /*
   Ficheros necesarios
   */

   BEGIN SEQUENCE

   DATABASE NEW ::oTikCliT PATH ( cPatEmp() ) FILE "TIKET.DBF" VIA ( cDriver() ) SHARED INDEX "TIKET.CDX"

   DATABASE NEW ::oTikCliL PATH ( cPatEmp() ) FILE "TIKETL.DBF" VIA ( cDriver() ) SHARED INDEX "TIKETL.CDX"

   DATABASE NEW ::oDbfCli PATH ( cPatEmp() ) FILE "CLIENT.DBF" VIA ( cDriver() ) SHARED INDEX "CLIENT.CDX"

   RECOVER

      msgStop( "Imposible abrir todas las bases de datos" )
      ::CloseFiles()
      lOpen          := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD CloseFiles()

   if !Empty( ::oTikCliT ) .and. ::oTikCliT:Used()
      ::oTikCliT:End()
   end if

   if !Empty( ::oTikCliL ) .and. ::oTikCliL:Used()
      ::oTikCliL:End()
   end if

   if !Empty( ::oDbfCli ) .and. ::oDbfCli:Used()
      ::oDbfCli:End()
   end if

RETURN ( Self )

//---------------------------------------------------------------------------//

METHod lResource( cFld )

   if !::StdResource( "INF_GEN01" )
      return .f.
   end if

   /*
   Monta los almacenes de manera automatica
   */

   ::oDefAlmInf( 70, 80, 90, 100 )

   /*
   Monta los articulos de manera automatica
   */

   ::lDefArtInf( 110, 120, 130, 140 )

   /*
   Damos valor al meter
   */

   ::oMtrInf:SetTotal( ::ofacCliT:Lastrec() )

   ::oDefExcInf()

   ::oDefResInf()

RETURN .t.

//---------------------------------------------------------------------------//
/*
Esta funcion crea la base de datos para generar posteriormente el informe
*/

METHOD lGenerate()

   local lExcCero := .f.

   ::oDlg:Disable()

   ::oDbf:Zap()
   ::oTikCliT:GoTop()

   ::aHeader   := {  {|| "Fecha  : " + Dtoc( Date() ) },;
                     {|| "Periodo: " + Dtoc( ::dIniInf ) + " > " + Dtoc( ::dFinInf ) },;
                     {|| "Almacen: " + ::cAlmOrg         + " > " + ::cAlmDes },;
                     {|| "Estado : " + ::aEstado[ ::oEstado:nAt ] } }

   /*
   Nos movemos por las cabeceras de los facturas a proveedores
	*/

   WHILE !::oTikCliT:Eof()

      IF ::oTikCliT:cTipTik == "1"                                                          .AND.;
         ::oTikCliT:dFecTik >= ::dIniInf                                                    .AND.;
         ::oTikCliT:dFecTik <= ::dFinInf                                                    .AND.;
         ::oTikCliT:cAlmTik >= ::cAlmOrg                                                    .AND.;
         ::oTikCliT:cAlmTik <= ::cAlmDes                                                    .AND.;
         lChkSer( ::oTikCliT:cSerTik, ::aSer )

         /*
         Posicionamos en las lineas de detalle --------------------------------
         */

         if ::oTikCliL:Seek( ::oTikCliT:cSerTik + ::oTikCliT:cNumTik + ::oTikCliT:cSufTik )

            while ::oTikCliT:cSerTik + ::oTikCliT:cNumTik + ::oTikCliT:cSufTik == ::oTikCliL:cSerTil + ::oTikCliL:cNumTil + ::oTikCliL:cSufTil .AND. ! ::oTikCliL:eof()

               if ::oTikCliL:CREF >= ::cArtOrg                 .AND.;
                  ::oTikCliL:CREF <= ::cArtDes                 .AND.;
                  !( ::lExcCero .AND. ::oTikCliL:nUntTil == 0 )

                  ::oDbf:Append()

                  ::oDbf:CCODALM := ::oTikCliT:cAlmTik
                  ::oDbf:CCODCLI := ::oTikCliT:cCliTik
                  ::oDbf:CNOMCLI := ::oTikCliT:cNomTik
                  ::oDbf:DFECMOV := ::oTikCliT:dFecTik

                  ::oDbf:CCODART := ::oTikCliL:cCbaTil
                  ::oDbf:nUntEnt := ::oTikCliL:nUntTil
                  ::oDbf:nPreDiv := nTotLTikCli( ::oTikCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
                  ::oDbf:CDOCMOV := ::oTikCliL:CSERIE + "/" + Str( ::oTikCliL:NNUMFAC ) + "/" + ::oTikCliL:CSUFFAC

                  IF ::oDbfCli:Seek ( ::oTikCliT:CNOMCLI )

                     ::oDbf:CNIFCLI := ::oDbfCli:Nif
                     ::oDbf:CDOMCLI := ::oDbfCli:Domicilio
                     ::oDbf:CPOBCLI := ::oDbfCli:Poblacion
                     ::oDbf:CPROCLI := ::oDbfCli:Provincia
                     ::oDbf:CCDPCLI := ::oDbfCli:CodPostal
                     ::oDbf:CTLFCLI := ::oDbfCli:Telefono

                   END IF

                  ::oDbf:Save()

               end if

               ::oTikCliL:Skip()

            end while

         end if

      end if

      ::oTikCliT:Skip()

      ::oMtrInf:AutoInc()

   end while

   ::oDlg:Enable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//