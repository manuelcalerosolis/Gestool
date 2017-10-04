#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS TCliObr FROM TInfGen

   DATA  lResumen    AS LOGIC    INIT .f.
   DATA  lExcCero    AS LOGIC    INIT .f.
   DATA  oAlbCliT    AS OBJECT
   DATA  oAlbCliL    AS OBJECT
   DATA  oEstado     AS OBJECT
   DATA  aEstado     AS ARRAY    INIT  { "Facturado", "No facturado", "Todos" }

   METHOD Create()

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHOD Resource( cFld )

   METHOD lGenerate()

END CLASS

//---------------------------------------------------------------------------//

METHOD Create()

   ::AddField ( "cCodObr", "C", 18, 0, {|| "@!" },         "Dirección",                      .f., "Código dirección",                14 )
   ::AddField ( "cNomObr", "C", 50, 0, {|| "@!" },         "Nom.obra",                  .f., "Nombre dirección",                20 )
   ::AddField ( "cCodArt", "C", 18, 0, {|| "@!" },         "Cod. artículo",             .t., "Código artículo",            14 )
   ::AddField ( "cNomArt", "C",100, 0, {|| "@!" },         "Descripción",               .t., "Nombre artículo",            32 )
   ::AddField ( "cCodCli", "C", 12, 0, {|| "@!" },         "Cód. cli.",                 .f., "Cod. Cliente",                8 )
   ::AddField ( "cNomCli", "C", 50, 0, {|| "@!" },         "Cliente",                   .f., "Nom. Cliente",               30 )
   ::AddField ( "cNifCli", "C", 15, 0, {|| "@!" },         "Nif",                       .f., "Nif",                        12 )
   ::AddField ( "cDomCli", "C", 35, 0, {|| "@!" },         "Domicilio",                 .f., "Domicilio",                  20 )
   ::AddField ( "cPobCli", "C", 25, 0, {|| "@!" },         "Población",                 .f., "Población",                  25 )
   ::AddField ( "cProCli", "C", 20, 0, {|| "@!" },         "Provincia",                 .f., "Provincia",                  20 )
   ::AddField ( "cCdpCli", "C",  7, 0, {|| "@!" },         "Cod. Postal",               .f., "Cod. Postal",                 7 )
   ::AddField ( "cTlfCli", "C", 12, 0, {|| "@!" },         "Teléfono",                  .f., "Teléfono",                   12 )
   ::AddField ( "cCodAlm", "C", 18, 0, {|| "@!" },         "Cod. Almacen",              .f., "Código almacén",             18 )
   ::AddField ( "cCodAge", "C", 18, 0, {|| "@!" },         "Cod. Agente",               .f., "Código agente",              18 )
   ::AddField ( "nNumCaj", "N", 16, 6, {|| MasUnd() },     cNombreCajas(),              .f., cNombreCajas(),               12 )
   ::AddField ( "nNumUnd", "N", 16, 6, {|| MasUnd() },     cNombreUnidades(),           .f., cNombreUnidades(),            12 )
   ::AddField ( "nTotUnd", "N", 16, 6, {|| MasUnd() },     "Tot. " + cNombreUnidades(), .t., "Total " + cNombreUnidades(), 12 )
   ::AddField ( "nImpArt", "N", 16, 6, {|| ::cPicOut },    "Importe",                   .t., "Importe",                    12 )
   ::AddField ( "cDocMov", "C", 14, 0, {|| "@!" },         "Documento",                 .t., "Documento",                  14 )
   ::AddField ( "dFecMov", "D",  8, 0, {|| "@!" },         "Fecha",                     .t., "Fecha",                      10 )

   ::AddTmpIndex( "cCodCli", "cCodCli + cCodObr" )

   ::AddGroup( {|| ::oDbf:cCodCli }, {|| "Cliente  : " + Rtrim( ::oDbf:cCodCli ) + "-" + oRetFld( ::oDbf:cCodCli, ::oDbfCli ) }, {||"Total Cliente..."} )
   ::AddGroup( {|| ::oDbf:cCodCli + ::oDbf:cCodObr }, {|| "Obras  : " + Rtrim( ::oDbf:cCodObr ) + "-" + RTrim ( ::oDbf:CNOMOBR ) }, {||"Total Obras..."} )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD OpenFiles()

   local lOpen    := .t.
   local oBlock   := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

   ::oAlbCliT := TDataCenter():oAlbCliT()

   DATABASE NEW ::oAlbCliL PATH ( cPatEmp() ) FILE "ALBCLIL.DBF" VIA ( cDriver() ) SHARED INDEX "ALBCLIL.CDX"

   RECOVER

      msgStop( "Imposible abrir todas las bases de datos" )
      ::CloseFiles()
      lOpen          := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD CloseFiles()

   if !Empty( ::oAlbCliT ) .and. ::oAlbCliT:Used()
      ::oAlbCliT:End()
   end if
   if !Empty( ::oAlbCliL ) .and. ::oAlbCliL:Used()
      ::oAlbCliL:End()
   end if

   ::oAlbCliT := nil
   ::oAlbCliL := nil

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD Resource( cFld )

   local cEstado := "Todos"

   if !::StdResource( "INF_GEN04" )
      return .f.
   end if

   /*
   Monta los clientes de manera automatica
   */

   if !::oDefCliInf( 70, 80, 90, 100 )
      return .f.
   end if

   /* Monta obras */

   if !::oDefObrInf( 110, 120, 130, 140, 220 )
      return .f.
   end if

   /*
   Monta los articulos de manera automatica
   */

   if !::lDefArtInf( 150, 160, 170, 180 )
      return .f.
   end if

   /*
   Damos valor al meter
   */

   ::oMtrInf:SetTotal( ::oAlbCliT:Lastrec() )

   ::oDefExcInf( 200 )

   ::oDefExcImp( 210 )

   REDEFINE COMBOBOX ::oEstado ;
      VAR      cEstado ;
      ID       218 ;
      ITEMS    ::aEstado ;
      OF       ::oFld:aDialogs[1]

   ::CreateFilter( aItmAlbCli(), ::oAlbCliT:cAlias )

RETURN ( Self )

//---------------------------------------------------------------------------//
/*
Esta funcion crea la base de datos para generar posteriormente el informe
*/

METHOD lGenerate()

   local bValid   := {|| .t. }
   local lExcCero := .f.

   ::oDlg:Disable()
   ::oBtnCancel:Enable()
   ::oDbf:Zap()
   ::oAlbCliT:GoTop():Load()

   do case
      case ::oEstado:nAt == 1
         bValid   := {|| !lFacturado( ::oAlbCliT ) }
      case ::oEstado:nAt == 2
         bValid   := {|| lFacturado( ::oAlbCliT ) }
      case ::oEstado:nAt == 3
         bValid   := {|| .t. }
   end case

   ::aHeader   := {  {|| "Fecha    : " + Dtoc( Date() ) },;
                     {|| "Periodo  : " + Dtoc( ::dIniInf )   + " > " + Dtoc( ::dFinInf ) },;
                     {|| "Clientes : " + AllTrim( ::cCliOrg ) + " > " + AllTrim (::cCliDes ) },;
                     {|| "Artículos: " + AllTrim( ::cArtOrg ) + " > " + AllTrim (::cArtDes ) },;
                     {|| "Estado   : " + ::aEstado[ ::oEstado:nAt ] } }

   /*
   Nos movemos por las cabeceras de los albaranes a proveedores
	*/

   WHILE !::lBreak .and. !::oAlbCliT:Eof()

      IF Eval( bValid )                                                                               .AND.;
         ::oAlbCliT:DFECALB >= ::dIniInf                                                              .AND.;
         ::oAlbCliT:DFECALB <= ::dFinInf                                                              .AND.;
         ::oAlbCliT:CCODCLI >= ::cCliOrg                                                              .AND.;
         ::oAlbCliT:CCODCLI <= ::cCliDes                                                              .AND.;
         ( ( ::oAlbCliT:CCODOBR >= ::cObrOrg .AND. ::oAlbCliT:CCODOBR <= ::cObrDes ) .or. ::lAllObr ) .AND.;
         lChkSer( ::oAlbCliT:CSERALB, ::aSer )                                                        .AND.;
         ::EvalFilter()

         /*
         Posicionamos en las lineas de detalle --------------------------------
         */

         if ::oAlbCliL:Seek( ::oAlbCliT:CSERALB + Str( ::oAlbCliT:NNUMALB ) + ::oAlbCliT:CSUFALB )

            while ::oAlbCliT:CSERALB + Str( ::oAlbCliT:NNUMALB ) + ::oAlbCliT:CSUFALB == ::oAlbCliL:CSERALB + Str( ::oAlbCliL:NNUMALB ) + ::oAlbCliL:CSUFALB .AND. ! ::oAlbCliL:eof()

               if ::oAlbCliL:CREF >= ::cArtOrg                       .AND.;
                  ::oAlbCliL:CREF <= ::cArtDes                       .AND.;
                  !( ::lExcCero .AND. ::oAlbCliL:NPREUNIT == 0 )

                  ::oDbf:Append()

                  ::AddCliente( ::oAlbCliT:cCodCli, ::oAlbCliT, .f. )

                  ::oDbf:CCODOBR := ::oAlbCliT:CCODOBR
                  ::oDbf:CNOMOBR := RetObras( ::oAlbCliT:cCodCli, ::oAlbCliT:cCodObr, ::oDbfObr:cAlias )
                  ::oDbf:CCODART := ::oAlbCliL:CREF
                  ::oDbf:CNOMART := ::oAlbCliL:CDETALLE
                  ::oDbf:CCODALM := ::oAlbCliT:CCODALM
                  ::oDbf:CCODAGE := ::oAlbCliT:CCODAGE
                  ::oDbf:DFECMOV := ::oAlbCliT:DFECALB
                  ::oDbf:CDOCMOV := lTrim ( ::oAlbCliL:CSERALB ) + "/" + lTrim ( Str( ::oAlbCliL:NNUMALB ) ) + "/" + lTrim ( ::oAlbCliL:CSUFALB )
                  ::oDbf:NNUMCAJ := ::oAlbCliL:nCanEnt
                  ::oDbf:NNUMUND := ::oAlbCliL:nUniCaja
                  ::oDbf:nTotUnd := nTotNAlbCli( ::oAlbCliL )
                  ::oDbf:NIMPART := nImpLAlbCli( ::oAlbCliT:cAlias, ::oAlbCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
                  ::oDbf:CDOCMOV := lTrim ( ::oAlbCliL:CSERALB ) + "/" + lTrim ( Str( ::oAlbCliL:NNUMALB ) ) + "/" + lTrim ( ::oAlbCliL:CSUFALB )

                  ::oDbf:Save()

               end if

               ::oAlbCliL:Skip()

            end while

         end if

      end if

      ::oAlbCliT:Skip()

      ::oMtrInf:AutoInc()

   end while

   ::oMtrInf:SetTotal( ::oAlbCliT:Lastrec() )

   ::oDlg:Enable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//