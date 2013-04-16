#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch"
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS TDiaCFac FROM TInfGen

   DATA  lExcCero    AS LOGIC    INIT .f.
   DATA  oEstado     AS OBJECT
   DATA  oDbfIva     AS OBJECT
   DATA  oFacCliP    AS OBJECT
   DATA  oFacCliT    AS OBJECT
   DATA  oFacCliL    AS OBJECT
   DATA  oAntCliT    AS OBJECT
   DATA  oDbfTvta    AS OBJECT
   DATA  oDbfCli     AS OBJECT

   METHOD Create()

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHod lResource( cFld )

   METHOD lGenerate()

END CLASS

//---------------------------------------------------------------------------//

METHOD Create()

   ::AddField( "CCODCLI", "C", 12, 0, {|| "@!" },         "Cli",                       .f., "Cod. Cliente",        )
   ::AddField( "CNOMCLI", "C", 50, 0, {|| "@!" },         "Nom",                       .f., "Nombre Cliente",      )
   ::AddField( "CDOCMOV", "C", 14, 0, {|| "@!" },         "Fac",                       .t., "Factura",             )
   ::AddField( "DFECMOV", "D",  8, 0, {|| "@!" },         "Fecha",                     .t., "Fecha",               )
   ::AddField( "CNIFCLI", "C", 15, 0, {|| "@!" },         "Nif",                       .f., "Nif",                 )
   ::AddField( "CDOMCLI", "C", 35, 0, {|| "@!" },         "Dom",                       .f., "Domicilio",           )
   ::AddField( "CPOBCLI", "C", 25, 0, {|| "@!" },         "Pob",                       .f., "Población",           )
   ::AddField( "CPROCLI", "C", 20, 0, {|| "@!" },         "Prov",                      .f., "Provincia",           )
   ::AddField( "CCDPCLI", "C",  7, 0, {|| "@!" },         "CP",                        .f., "Cod. Postal",         )
   ::AddField( "CTLFCLI", "C", 12, 0, {|| "@!" },         "Tlf",                       .f., "Teléfono",            )
   ::AddField( "CDEFI01", "C",100, 0, {|| "@!" },         {|| ::cNameIniCli(1) },      .f., {|| ::cNameIniCli(1) } )
   ::AddField( "CDEFI02", "C",100, 0, {|| "@!" },         {|| ::cNameIniCli(2) },      .f., {|| ::cNameIniCli(2) } )
   ::AddField( "CDEFI03", "C",100, 0, {|| "@!" },         {|| ::cNameIniCli(3) },      .f., {|| ::cNameIniCli(3) } )
   ::AddField( "CDEFI04", "C",100, 0, {|| "@!" },         {|| ::cNameIniCli(4) },      .f., {|| ::cNameIniCli(4) } )
   ::AddField( "CDEFI05", "C",100, 0, {|| "@!" },         {|| ::cNameIniCli(5) },      .f., {|| ::cNameIniCli(5) } )
   ::AddField( "CDEFI06", "C",100, 0, {|| "@!" },         {|| ::cNameIniCli(6) },      .f., {|| ::cNameIniCli(6) } )
   ::AddField( "CDEFI07", "C",100, 0, {|| "@!" },         {|| ::cNameIniCli(7) },      .f., {|| ::cNameIniCli(7) } )
   ::AddField( "CDEFI08", "C",100, 0, {|| "@!" },         {|| ::cNameIniCli(8) },      .f., {|| ::cNameIniCli(8) } )
   ::AddField( "CDEFI09", "C",100, 0, {|| "@!" },         {|| ::cNameIniCli(9) },      .f., {|| ::cNameIniCli(9) } )
   ::AddField( "CDEFI10", "C",100, 0, {|| "@!" },         {|| ::cNameIniCli(10)},      .f., {|| ::cNameIniCli(10)} )
   ::AddField( "NTOTNET", "N", 16, 6, {|| ::cPicOut },    "Neto",                      .t., "Neto",                )
   ::AddField( "NTOTIVA", "N", 16, 6, {|| ::cPicOut },    cImp(),                       .t., cImp(),                 )
   ::AddField( "NTOTREQ", "N", 16, 3, {|| ::cPicOut },    "Rec",                       .t., "Rec",                 )
   ::AddField( "NTOTDOC", "N", 16, 6, {|| ::cPicOut },    "Total",                     .t., "Total",               )
   ::AddField( "NCOMAGE", "N", 13, 6, {|| ::cPicOut },    "Com. Age",                  .t., "Comisión Agente",     )
   ::AddField( "CTIPVEN", "C", 20, 0, {|| "@!" },         "Venta",                     .f., "Tipo de Venta",       )

   ::AddTmpIndex ( "CCODCLI", "CCODCLI" )
   ::AddGroup( {|| ::oDbf:cCodCli }, {|| "Cliente  : " + Rtrim( ::oDbf:cCodCli ) + "-" + oRetFld( ::oDbf:cCodCli, ::oDbfCli ) } )

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD OpenFiles() CLASS TDiaCFac

  local oBlock
  local oError
  local lOpen := .t.

   /*
   Ficheros necesarios
   */

   oBlock   := ErrorBlock( { | oError | ApoloBreak( oError ) }
   BEGIN SEQUENCE

   ::oFacCliT := TDataCenter():oFacCliT()

   DATABASE NEW ::oFacCliL  PATH ( cPatEmp() ) FILE "FACCLIL.DBF" VIA ( cDriver() ) SHARED INDEX "FACCLIL.CDX"

   DATABASE NEW ::oDbfIva   PATH ( cPatDat() ) FILE "TIVA.DBF"  VIA ( cDriver() ) SHARED INDEX "TIVA.CDX"

   DATABASE NEW ::oFacCliP  PATH ( cPatEmp() ) FILE "FACCLIP.DBF"  VIA ( cDriver() ) SHARED INDEX "FACCLIP.CDX"

   DATABASE NEW ::oDbfTvta  PATH ( cPatDat() ) FILE "TVTA.DBF"    VIA ( cDriver() ) SHARED INDEX "TVTA.CDX"

   DATABASE NEW ::oAntCliT  PATH ( cPatEmp() ) FILE "ANTCLIT.DBF" VIA ( cDriver() ) SHARED INDEX "ANTCLIT.CDX"

   RECOVER USING oError

      lOpen := .f.

      msgStop( "Imposible abrir todas las bases de datos" )
      ::CloseFiles()

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD CloseFiles() CLASS TDiaCFac

   ::oFacCliT:End()
   ::oFacCliL:End()
   ::oDbfTvta:End()
   ::oDbfCli:End()
   ::oDbfIva:End()
   ::oFacCliP:End()
   ::oAntCliT:End()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHod lResource( cFld ) CLASS TDiaCFac

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

   REDEFINE COMBOBOX ::oEstado ;
      VAR      cEstado ;
      ID       218 ;
      ITEMS    { "Pendiente", "Liquidada", "Todas" } ;
      OF       ::oFld:aDialogs[1]

RETURN ( Self )

//---------------------------------------------------------------------------//
/*
Esta funcion crea la base de datos para generar posteriormente el informe
*/

METHOD lGenerate() CLASS TDiaCFac

   local aTotFac
   local bValid   := {|| .t. }
   local lExcCero := .f.

   ::oDlg:Disable()

   ::oDbf:Zap()
   ::oFacCliT:GoTop():Load()

   do case
      case ::oEstado:nAt == 1
         bValid   := {|| !::oFacCliT:lLiquidada }
      case ::oEstado:nAt == 2
         bValid   := {|| ::oFacCliT:lLiquidada }
      case ::oEstado:nAt == 3
         bValid   := {|| .t. }
   end case

	/*
   Nos movemos por las cabeceras de los albaranes a clientes
	*/

   WHILE ! ::oFacCliT:Eof()

      IF Eval( bValid )                                                                     .AND.;
         ::oFacCliT:DFECFAC >= ::dIniInf                                                    .AND.;
         ::oFacCliT:DFECFAC <= ::dFinInf                                                    .AND.;
         ::oFacCliT:CCODCLI >= ::cCliOrg                                                    .AND.;
         ::oFacCliT:CCODCLI <= ::cCliDes                                                    .AND.;
         lChkSer( ::oFacCliT:CSERIE, ::aSer )

          /*
         Posicionamos en las lineas de detalle --------------------------------
         */

         if ::oFacCliL:Seek( ::oFacCliT:CSERIE + Str( ::oFacCliT:NNUMFAC ) + ::oFacCliT:CSUFFAC )

            ::oFacCliL:load()

            while ::oFacCliT:CSERIE + Str( ::oFacCliT:NNUMFAC ) + ::oFacCliT:CSUFFAC == ::oFacCliL:CSERIE + Str( ::oFacCliL:NNUMFAC ) + ::oFacCliL:CSUFFAC .AND. ! ::oFacCliL:eof()

               if ::oFacCliL:CREF >= ::cArtOrg                 .AND.;
                  ::oFacCliL:CREF <= ::cArtDes                 .AND.;
                  !( ::lExcCero .AND. ::oFacCliL:NFACUNIT == 0 )

                  ::oDbf:Append()

                  ::oDbf:CCODCLI := ::oFacCliT:CCODCLI
                  ::oDbf:CNOMCLI := ::oFacCliT:CNOMCLI
                  ::oDbf:DFECMOV := ::oFacCliT:DFECFAC

                  aTotFac        := aTotFacCli( ::oFacCliT:CSERIE + Str( ::oFacCliT:NNUMFAC ) + ::oFacCliT:CSUFFAC, ::oFacCliT:cAlias, ::oFacCliL:cAlias, ::oDbfIva:cAlias, ::oDbfDiv:cAlias, ::oFacCliP:cAlias, ::oAntCliT:cAlias, cDivEmp() )

                  ::oDbf:NTOTNET := aTotFac[1] - aTotFac[5] - aTotFac[6]
                  ::oDbf:NTOTIVA := aTotFac[2]
                  ::oDbf:NTOTREQ := aTotFac[3]
                  ::oDbf:nComAge := ::oFacCliL:nComAge
                  ::oDbf:NTOTDOC := aTotFac[4]
                  ::oDbf:CDOCMOV := ::oFacCliL:CSERIE + "/" + Str( ::oFacCliL:NNUMFAC ) + "/" + ::oFacCliL:CSUFFAC

                  ::oDbfTvta:Seek (::oFacCliL:cTipMov)
                  ::oDbfTvta:Load ()
                  ::oDbf:cTipVen    := ::oDbfTvta:cDesMov

                  IF ::oDbfCli:Seek ( ::oFacCliT:CCODCLI )
                     ::oDbfCli:Load()

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

                   END IF

                  ::oDbf:Save()

               end if

               ::oFacCliL:Skip():Load()

            end while

         end if

      end if

      ::oFacCliT:Skip():Load()

      ::oMtrInf:AutoInc()

   end while

   ::oDlg:Enable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//









