#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch"
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

FUNCTION TlAgePed()

   local oInf
   local aCol  := {}
   local aIdx  := {}


   aAdd( aCol, { "CCODAGE", "C",  3, 0,  {|| "@!" },         "Cod. age.",                 .f., "Código agente",             3 } )
   aAdd( aCol, { "CNOMAGE", "C", 50, 0,  {|| "@!" },         "Agente",                    .f., "Agente",                   25 } )
   aAdd( aCol, { "CCODCLI", "C", 12, 0,  {|| "@!" },         "Cod. cli.",                 .t., "Código cliente",            8 } )
   aAdd( aCol, { "CNOMCLI", "C", 50, 0,  {|| "@!" },         "Cliente",                   .t., "Nombre cliente",           25 } )
   aAdd( aCol, { "CNIFCLI", "C", 15, 0,  {|| "@!" },         "Nif",                       .f., "Nif",                        12 } )
   aAdd( aCol, { "CDOMCLI", "C", 35, 0,  {|| "@!" },         "Domicilio",                 .f., "Domicilio",                  20 } )
   aAdd( aCol, { "CPOBCLI", "C", 35, 0,  {|| "@!" },         "Población",                 .f., "Población",                  25 } )
   aAdd( aCol, { "CPROCLI", "C", 20, 0,  {|| "@!" },         "Provincia",                 .f., "Provincia",                  20 } )
   aAdd( aCol, { "CCDPCLI", "C",  7, 0,  {|| "@!" },         "Cod. Postal",               .f., "Cod. Postal",                 7 } )
   aAdd( aCol, { "CTLFCLI", "C", 12, 0,  {|| "@!" },         "Teléfono",                  .f., "Teléfono",                   12 } )
   aAdd( aCol, { "CDEFI01", "C",100, 0,  {|| "@!" },         {|| oInf:cNameIniCli(1) },   .f., {|| oInf:cNameIniCli(1) },    50 } )
   aAdd( aCol, { "CDEFI02", "C",100, 0,  {|| "@!" },         {|| oInf:cNameIniCli(2) },   .f., {|| oInf:cNameIniCli(2) },    50 } )
   aAdd( aCol, { "CDEFI03", "C",100, 0,  {|| "@!" },         {|| oInf:cNameIniCli(3) },   .f., {|| oInf:cNameIniCli(3) },    50 } )
   aAdd( aCol, { "CDEFI04", "C",100, 0,  {|| "@!" },         {|| oInf:cNameIniCli(4) },   .f., {|| oInf:cNameIniCli(4) },    50 } )
   aAdd( aCol, { "CDEFI05", "C",100, 0,  {|| "@!" },         {|| oInf:cNameIniCli(5) },   .f., {|| oInf:cNameIniCli(5) },    50 } )
   aAdd( aCol, { "CDEFI06", "C",100, 0,  {|| "@!" },         {|| oInf:cNameIniCli(6) },   .f., {|| oInf:cNameIniCli(6) },    50 } )
   aAdd( aCol, { "CDEFI07", "C",100, 0,  {|| "@!" },         {|| oInf:cNameIniCli(7) },   .f., {|| oInf:cNameIniCli(7) },    50 } )
   aAdd( aCol, { "CDEFI08", "C",100, 0,  {|| "@!" },         {|| oInf:cNameIniCli(8) },   .f., {|| oInf:cNameIniCli(8) },    50 } )
   aAdd( aCol, { "CDEFI09", "C",100, 0,  {|| "@!" },         {|| oInf:cNameIniCli(9) },   .f., {|| oInf:cNameIniCli(9) },    50 } )
   aAdd( aCol, { "CDEFI10", "C",100, 0,  {|| "@!" },         {|| oInf:cNameIniCli(10)},   .f., {|| oInf:cNameIniCli(10)},    50 } )
   aAdd( aCol, { "CREFART", "C", 18, 0,  {|| "@!" },         "Cod. art.",                 .t., "Código artículo",          10 } )
   aAdd( aCol, { "CDESART", "C", 50, 0,  {|| "@!" },         "Artículo",                  .t., "Artículo",                 25 } )
   aAdd( aCol, { "NUNDCAJ", "N", 13, 6,  {|| MasUnd () },    "Cajas",                     .f., "Cajas",                     8 } )
   aAdd( aCol, { "NUNDART", "N", 13, 6,  {|| MasUnd () },    "Und.",                      .t., "Unidades",                  8 } )
   aAdd( aCol, { "NCAJUND", "N", 13, 6,  {|| MasUnd () },    "Caj x Und",                 .f., "Cajas x unidades",         10 } )
   aAdd( aCol, { "NBASCOM", "N", 13, 6,  {|| oInf:cPicOut }, "Base",                      .t., "Base comisión",            10 } )
   aAdd( aCol, { "NCOMAGE", "N",  4, 1,  {|| oInf:cPicOut }, "%Com",                      .f., "Porcentaje de comisión",   10 } )
   aAdd( aCol, { "NTOTCOM", "N", 13, 6,  {|| oInf:cPicOut }, "Importe",                   .t., "Importe comisión",         10 } )
   aAdd( aCol, { "CDOCMOV", "C", 14, 0,  {|| "@!" },         "Pedido",                    .t., "Pedido",                   14 } )
   aAdd( aCol, { "DFECMOV", "D",  8, 0,  {|| "@!" },         "Fecha",                     .t., "Fecha",                     8 } )
   aAdd( aCol, { "CTIPVEN", "C", 20, 0,  {|| "@!" },         "Venta",                     .f., "Tipo de venta",            20 } )

   aAdd( aIdx, { "CNOMAGE", "CNOMAGE + CREFART" } )

   oInf  := TdlAgePed():New( "Informe detallado de la liquidación de agentes en pedidos de clientes", aCol, aIdx, "01047" )

   oInf:AddGroup( {|| oInf:oDbf:cNomAge },                     {|| "Agente  : " + Rtrim( oInf:oDbf:cNomAge ) + "-" + oRetFld( oInf:oDbf:cNomAge, oInf:oDbfAge ) },  {||"Total agente..."} )
   oInf:AddGroup( {|| oInf:oDbf:cNomAge + oInf:oDbf:cDesArt }, {|| "Artículo : " + Rtrim( oInf:oDbf:cRefArt ) + "-" + Rtrim( oInf:oDbf:cDesArt ) }, {||""} )

   oInf:Resource()
   oInf:Activate()

   oInf:End()
   oInf  := nil

RETURN NIL

//---------------------------------------------------------------------------//

CLASS TdlAgePed FROM TInfGen

   DATA  lExcCero    AS LOGIC    INIT .f.
   DATA  lTvta       AS LOGIC    INIT .f.
   DATA  oEstado     AS OBJECT
   DATA  oPedCliT    AS OBJECT
   DATA  oPedCliL    AS OBJECT
   DATA  oDbfTvta    AS OBJECT
   DATA  cTipVen     AS CHARACTER
   DATA  cTipVen2    AS CHARACTER
   DATA  aEstado     AS ARRAY    INIT  { "Pendientes", "Parcial", "Recibidos" , "Todos" }

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHOD Resource( cFld )

   METHOD lGenerate()

END CLASS

//---------------------------------------------------------------------------//

METHOD OpenFiles() CLASS TdlAgeAlb

   local lOpen    := .t.
   local oBlock   := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   /*
   Ficheros necesarios
   */

   BEGIN SEQUENCE

   ::oPedCliT := TDataCenter():oPedCliT()

   DATABASE NEW ::oPedCliL  PATH ( cPatEmp() ) FILE "PEDCLIL.DBF" VIA ( cDriver() ) SHARED INDEX "PEDCLIL.CDX"

   DATABASE NEW ::oDbfCli   PATH ( cPatCli() ) FILE "CLIENT.DBF"  VIA ( cDriver() ) SHARED INDEX "CLIENT.CDX"

   DATABASE NEW ::oDbfTvta  PATH ( cPatDat() ) FILE "TVTA.DBF"    VIA ( cDriver() ) SHARED INDEX "TVTA.CDX"

   RECOVER

      msgStop( "Imposible abrir todas las bases de datos" )
      ::CloseFiles()
      lOpen          := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD CloseFiles() CLASS TdlAgeAlb

   if !Empty( ::oPedCliT ) .and. ::oPedCliT:Used()
      ::oPedCliT:End()
   end if
   if !Empty( ::oPedCliL ) .and. ::oPedCliL:Used()
      ::oPedCliL:End()
   end if

   if !Empty( ::oDbfTvta ) .and. ::oDbfTvta:Used()
      ::oDbfTvta:End()
   end if

   if !Empty( ::oDbfCli ) .and. ::oDbfCli:Used()
      ::oDbfCli:End()
   end if

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD Resource( cFld ) CLASS TdlAgeAlb

   local oTipVen
   local oTipVen2
   local cEstado     := "Todos"
   local This        := Self

   if !::StdResource( "INF_GEN17" )
      return .f.
   end if

   /*
   Monta los agentes de manera automatica
   */

   ::oDefAgeInf( 70, 80, 90, 100 )

   /*
   Damos valor al meter
   */

   REDEFINE CHECKBOX ::lTvta ;
      ID       260 ;
      OF       ::oFld:aDialogs[1]

   REDEFINE GET oTipVen VAR ::cTipVen ;
      VALID    ( cTVta( oTipVen, This:oDbfTvta:cAlias, oTipVen2 ) ) ;
      BITMAP   "LUPA" ;
      ON HELP  ( BrwTVta( oTipVen, This:oDbfTVta:cAlias, oTipVen2 ) ) ;
      ID       270 ;
      OF       ::oFld:aDialogs[1]

   REDEFINE GET oTipVen2 VAR ::cTipVen2 ;
      ID       280 ;
      WHEN     ( .F. ) ;
      COLOR    CLR_GET ;
      OF       ::oFld:aDialogs[1]

   ::oMtrInf:SetTotal( ::oPedCliT:Lastrec() )

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

METHOD lGenerate() CLASS TdlAgeAlb

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
         bValid   := {|| ::oPedCliT:nEstado == 2 }
      case ::oEstado:nAt == 4
         bValid   := {|| .t. }
   end case

   ::aHeader      := {{|| "Fecha   : "   + Dtoc( Date() ) },;
                     {|| "Periodo : "   + Dtoc( ::dIniInf ) + " > " + Dtoc( ::dFinInf ) },;
                     {|| "Agentes : "   + ::cAgeOrg         + " > " + ::cAgeDes },;
                     {|| if ( ::lTvta, (if (!Empty( ::cTipVen ), "Tipo de Venta: " + ::cTipVen2, "Tipo de Venta: Todos" ) ), "Tipo de Venta: Ninguno" ) },;
                     {|| "Estado  : " + ::aEstado[ ::oEstado:nAt ] },;
                     {|| if( ::lTvta, "Aplicando comportamiento de los tipos de venta", "" ) } }

	/*
   Nos movemos por las cabeceras de los albaranes
   */

   WHILE ! ::oPedCliT:Eof()

      IF Eval( bValid )                                                                     .AND.;
         ::oPedCliT:DFECPED >= ::dIniInf                                                    .AND.;
         ::oPedCliT:DFECPED <= ::dFinInf                                                    .AND.;
         ::oPedCliT:CCODAGE >= ::cAgeOrg                                                    .AND.;
         ::oPedCliT:CCODAGE <= ::cAgeDes                                                    .AND.;
         lChkSer( ::oPedCliT:CSERPED, ::aSer )

         /*
         Posicionamos en las lineas de detalle --------------------------------
         */

         if ::oPedCliL:Seek( ::oPedCliT:CSERPED + Str( ::oPedCliT:NNUMPED ) + ::oPedCliT:CSUFPED )

            while ::oPedCliT:CSERPED + Str( ::oPedCliT:NNUMPED ) + ::oPedCliT:CSUFPED == ::oPedCliL:CSERPED + Str( ::oPedCliL:NNUMPED ) + ::oPedCliL:CSUFPED .AND. ! ::oPedCliL:eof()

                /* Preguntamos y tratamos el tipo de venta */

                if ::lTvta

                     if  ( if (!Empty( ::cTipVen ), ::oPedCliL:cTipMov == ::cTipVen, .t. ) )

                        ::oDbf:Append()

                        ::oDbf:cCodAge := ::oPedCliT:cCodAge
                        ::oDbf:CCODCLI := ::oPedCliT:CCODCLI
                        ::oDbf:CNOMCLI := ::oPedCliT:CNOMCLI
                        ::oDbf:DFECMOV := ::oPedCliT:DFECPED
                        ::oDbf:CDOCMOV := ::oPedCliT:CSERPED + "/" + Str( ::oPedCliT:NNUMPED ) + "/" + ::oPedCliT:CSUFPED
                        ::oDbf:CREFART := ::oPedCliL:CREF
                        ::oDbf:CDESART := ::oPedCliL:cDetalle

                        if ::oDbfCli:Seek ( ::oPedCliT:CCODCLI )

                           ::oDbf:CNIFCLI := ::oDbfCli:Nif
                           ::oDbf:CDOMCLI := ::oDbfCli:Domicilio
                           ::oDbf:CPOBCLI := ::oDbfCli:Poblacion
                           ::oDbf:CPROCLI := ::oDbfCli:Provincia
                           ::oDbf:CCDPCLI := ::oDbfCli:CodPostal
                           ::oDbf:CTLFCLI := ::oDbfCli:Telefono
                           ::oDbf:CDEFI01 := ::oDbfCli:CusRDef01
                           ::oDbf:CDEFI02 := ::oDbfCli:CusRDef02
                           ::oDbf:CDEFI03 := ::oDbfCli:CusRDef03
                           ::oDbf:CDEFI04 := ::oDbfCli:CusRDef04
                           ::oDbf:CDEFI05 := ::oDbfCli:CusRDef05
                           ::oDbf:CDEFI06 := ::oDbfCli:CusRDef06
                           ::oDbf:CDEFI07 := ::oDbfCli:CusRDef07
                           ::oDbf:CDEFI08 := ::oDbfCli:CusRDef08
                           ::oDbf:CDEFI09 := ::oDbfCli:CusRDef09
                           ::oDbf:CDEFI10 := ::oDbfCli:CusRDef10

                        end if

                        if ( ::oDbfAge:Seek (::oPedCliT:cCodAge) )
                           ::oDbf:cNomAge := ::oDbfAge:cApeAge + ", " + ::oDbfAge:cNbrAge
                        end if

                        if ::oDbfTvta:Seek( ::oPedCliL:cTipMov )
                           ::oDbf:cTipVen    := ::oDbfTvta:cDesMov

                           if ::oDbfTvta:nUndMov == 1
                              ::oDbf:NUNDCAJ := ::oPedCliL:NCANENT
                              ::oDbf:NCAJUND := NotCaja( ::oPedCliL:NCANENT ) * ::oPedCliL:NUNICAJA
                              ::oDbf:NUNDART := ::oPedCliL:NUNICAJA
                           elseif ::oDbfTvta:nUndMov == 2
                              ::oDbf:NUNDCAJ := (::oPedCliL:NCANENT) * (-1)
                              ::oDbf:NCAJUND := ( NotCaja( ::oPedCliL:NCANENT ) * ::oPedCliL:NUNICAJA )* (-1)
                              ::oDbf:NUNDART := (::oPedCliL:NUNICAJA) * (-1)
                           elseif ::oDbfTvta:nUndMov == 3
                              ::oDbf:NUNDCAJ := 0
                              ::oDbf:NCAJUND := 0
                              ::oDbf:NUNDART := 0
                           end if

                           if ::oDbfTvta:nImpMov == 3
                              ::oDbf:nComAge := 0
                              ::oDbf:nBasCom := 0
                              ::oDbf:nTotCom := 0
                           else
                              ::oDbf:nComAge := ( ::oPedCliL:nComAge )
                              ::oDbf:nBasCom := nImpLPedCli( ::oPedCliT:cAlias, ::oPedCliL:cAlias, ::nDecOut, ::nDerOut )
                              ::oDbf:nTotCom := nComLPedCli( ::oPedCliT:cAlias, ::oPedCliL:cAlias, ::nDecOut, ::nDerOut )
                           end if

                        end if


                        ::oDbf:Save()

                    end if

                /*
                Pasamos de los tipos de ventas
                */

                else

                  ::oDbf:Append()

                  ::oDbf:cCodAge := ::oPedCliT:cCodAge
                  ::oDbf:CCODCLI := ::oPedCliT:CCODCLI
                  ::oDbf:CNOMCLI := ::oPedCliT:CNOMCLI
                  ::oDbf:DFECMOV := ::oPedCliT:DFECPED
                  ::oDbf:CDOCMOV := ::oPedCliT:CSERPED + "/" + Str( ::oPedCliT:NNUMPED ) + "/" + ::oPedCliT:CSUFPED
                  ::oDbf:CREFART := ::oPedCliL:CREF
                  ::oDbf:CDESART := ::oPedCliL:cDetalle

                  if ::oDbfCli:Seek ( ::oPedCliT:CCODCLI )

                     ::oDbf:CNIFCLI := ::oDbfCli:Nif
                     ::oDbf:CDOMCLI := ::oDbfCli:Domicilio
                     ::oDbf:CPOBCLI := ::oDbfCli:Poblacion
                     ::oDbf:CPROCLI := ::oDbfCli:Provincia
                     ::oDbf:CCDPCLI := ::oDbfCli:CodPostal
                     ::oDbf:CTLFCLI := ::oDbfCli:Telefono
                     ::oDbf:CDEFI01 := ::oDbfCli:CusRDef01
                     ::oDbf:CDEFI02 := ::oDbfCli:CusRDef02
                     ::oDbf:CDEFI03 := ::oDbfCli:CusRDef03
                     ::oDbf:CDEFI04 := ::oDbfCli:CusRDef04
                     ::oDbf:CDEFI05 := ::oDbfCli:CusRDef05
                     ::oDbf:CDEFI06 := ::oDbfCli:CusRDef06
                     ::oDbf:CDEFI07 := ::oDbfCli:CusRDef07
                     ::oDbf:CDEFI08 := ::oDbfCli:CusRDef08
                     ::oDbf:CDEFI09 := ::oDbfCli:CusRDef09
                     ::oDbf:CDEFI10 := ::oDbfCli:CusRDef10

                  end if

                  if ( ::oDbfAge:Seek (::oPedCliT:cCodAge) )
                     ::oDbf:cNomAge := ::oDbfAge:cApeAge + ", " + ::oDbfAge:cNbrAge
                  end if

                  ::oDbf:NUNDCAJ := ::oPedCliL:NCANENT
                  ::oDbf:NCAJUND := NotCaja( ::oPedCliL:NCANENT )* ::oPedCliL:NUNICAJA
                  ::oDbf:NUNDART := ::oPedCliL:NUNICAJA
                  ::oDbf:nComAge := ( ::oPedCliL:nComAge )
                  ::oDbf:nBasCom := nImpLPedCli( ::oPedCliT:cAlias, ::oPedCliL:cAlias, ::nDecOut, ::nDerOut )
                  ::oDbf:nTotCom := nComLPedCli( ::oPedCliT:cAlias, ::oPedCliL:cAlias, ::nDecOut, ::nDerOut )

                  ::oDbf:Save()

                end if

                ::oPedCliL:Skip()

            end while

         end if

         end if

         ::oPedCliT:Skip()

         ::oMtrInf:AutoInc()

   end while

   ::oDlg:Enable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//