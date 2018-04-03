#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS TInfTCon FROM TInfGen

   DATA  lExcMov       AS LOGIC    INIT .f.
   DATA  oEstado       AS OBJECT
   DATA  oAlbCliT      AS OBJECT
   DATA  oAlbCliL      AS OBJECT
   DATA  oDbfArt       AS OBJECT
   DATA  aEstado       AS ARRAY    INIT { "No facturados", "Facturados", "Todos" }
   DATA  nTotSalmuera  AS OBJECT
   DATA  nTotCocidas   AS OBJECT
   DATA  nTotRellenas  AS OBJECT

   METHOD Create()

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHod lResource( cFld )

   METHOD lGenerate()

END CLASS

//---------------------------------------------------------------------------//

METHOD Create() CLASS TInfTCon

   ::AddField( "cCodTip",     "C",  4, 0, {|| "@!" },              "Cod.",                                    .f., "Código tipo"             ,  3 )
   ::AddField( "cNomTip",     "C", 50, 0, {|| "@!" },              "Tipo",                                    .f., "Tipo de artículo"        , 28 )
   ::AddField( "cCodCli",     "C", 12, 0, {|| "@!" },              "Cód. cli.",                               .f., "Cod. Cliente"            ,  8 )
   ::AddField( "cNomCli",     "C", 50, 0, {|| "@!" },              "Cliente",                                 .f., "Nom. Cliente"            , 30 )
   ::AddField( "cNifCli",     "C", 15, 0, {|| "@!" },              "Nif",                                     .f., "Nif"                     , 12 )
   ::AddField( "cDomCli",     "C", 35, 0, {|| "@!" },              "Domicilio",                               .f., "Domicilio"               , 20 )
   ::AddField( "cPobCli",     "C", 25, 0, {|| "@!" },              "Población",                               .f., "Población"               , 25 )
   ::AddField( "cProCli",     "C", 20, 0, {|| "@!" },              "Provincia",                               .f., "Provincia"               , 20 )
   ::AddField( "cCdpCli",     "C",  7, 0, {|| "@!" },              "Cod. Postal",                             .f., "Cod. Postal"             ,  7 )
   ::AddField( "cTlfCli",     "C", 12, 0, {|| "@!" },              "Teléfono",                                .f., "Teléfono"                , 12 )
   ::AddField( "cNumDoc",     "C", 10, 0, {|| "@!" },              "Documento",                               .f., "Documento"               , 10 )
   ::AddField( "dFecDo1",     "C", 10, 0, {|| "@!" },              "Fecha",                                   .t., "Fecha (entamada)"        , 10 )
   ::AddField( "nKilEx1",     "N", 19, 6, {|| "@EZ 999,999.999" }, "Kg. Expedidos",                           .t., "Kilogramos (entamada)"   , 15 )
   ::AddField( "cVarAc1",     "C", 25, 0, {|| "@!" },              "Variedad de aceituna",                    .t., "Variedad (entamada)"     , 20 )
   ::AddField( "cDesti1",     "C", 50, 0, {|| "@!" },              "Destinatario",                            .t., "Destinatario (entamada)" , 25 )
   ::AddField( "dFecDo2",     "C", 10, 0, {|| "@!" },              "Fecha",                                   .t., "Fecha"                   , 10 )
   ::AddField( "nKilEx2",     "N", 19, 6, {|| "@EZ 999,999.999" }, "Kg. Expedidos",                           .t., "Kilogramos"              , 15 )
   ::AddField( "cVarAc2",     "C", 25, 0, {|| "@!" },              "Variedad de aceituna",                    .t., "Variedad"                , 20 )
   ::AddField( "cDesti2",     "C", 50, 0, {|| "@!" },              "Destinatario",                            .t., "Destinatario"            , 25 )
   ::AddField( "nKgNoEn",     "n", 19, 6, {|| "@EZ 999,999.999" }, "Kg. sin entamar",                         .t., "Kg. sin entamar"         , 20 )

   ::AddTmpIndex( "cCodTip", "cCodTip + cNumDoc" )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD OpenFiles() CLASS TInfTCon

   local lOpen    := .t.
   local oBlock   := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

   ::oAlbCliT := TDataCenter():oAlbCliT()

   DATABASE NEW ::oAlbCliL PATH ( cPatEmp() ) FILE "AlbCliL.DBF" VIA ( cDriver() ) SHARED INDEX "AlbCliL.CDX"

   DATABASE NEW ::oDbfArt PATH ( cPatEmp() ) FILE "ARTICULO.DBF" VIA ( cDriver() ) SHARED INDEX "ARTICULO.CDX"

   RECOVER

      msgStop( "Imposible abrir todas las bases de datos" )
      ::CloseFiles()
      lOpen          := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD CloseFiles() CLASS TInfTCon

   if !Empty( ::oAlbCliT ) .and. ::oAlbCliT:Used()
      ::oAlbCliT:End()
   end if
   if !Empty( ::oAlbCliL ) .and. ::oAlbCliL:Used()
      ::oAlbCliL:End()
   end if
   if !Empty( ::oDbfArt ) .and. ::oDbfArt:Used()
      ::oDbfArt:End()
   end if

   ::oAlbCliT := nil
   ::oAlbCliL := nil
   ::oDbfArt  := nil

RETURN ( Self )

//---------------------------------------------------------------------------//

METHod lResource( cFld ) CLASS TInfTCon

   local cEstado := "Todos"

  if !::StdResource( "INF_TIPCON" )
   return .f.
   end if

   /* Monta tipo de artículos */

   if !::oDefTipInf( 110, 120, 130, 140, 910 )
      return .f.
   end if

   /* Meter */

   ::oMtrInf:SetTotal( ::oAlbCliT:Lastrec() )

   REDEFINE COMBOBOX ::oEstado ;
      VAR      cEstado ;
      ID       218 ;
      ITEMS    ::aEstado ;
      OF       ::oFld:aDialogs[1]

   ::CreateFilter( aItmAlbCli(), ::oAlbCliT:cAlias )

RETURN .t.

//---------------------------------------------------------------------------//
/*
Esta funcion crea la base de datos para generar posteriormente el informe
*/

METHOD lGenerate() CLASS TInfTCon

   local bValid   := {|| .t. }
   local cCodTip
   local cDocMov

   ::nTotSalmuera := 0
   ::nTotCocidas  := 0
   ::nTotRellenas := 0

   ::oDlg:Disable()

   ::oDbf:Zap()

   do case
      case ::oEstado:nAt == 1
         bValid   := {|| !lFacturado( ::oAlbCliT ) }
      case ::oEstado:nAt == 2
         bValid   := {|| lFacturado( ::oAlbCliT ) }
      case ::oEstado:nAt == 3
         bValid   := {|| .t. }
   end case

   ::aHeader := {  {|| "ANEXO IV  Contabilidad de existencias   Salida de productos(aceituna, hueso, destrío y otros)"},;
                   {|| "INDUSTRIA DE ENTAMADO número 21/41127-001                                  Campaña: 2003/2004"},;
                   {|| "Nombre o razón social ACEITUNAS LA PALMA, S.L.                         Hoja número:" + Str( ::oReport:nPage ) },;
                   {|| "Localidad LA PALMA DEL CONDADO          Provincia HUELVA" },;
                   {|| "                   Aceituna transformada (entamada)                                                Aceituna rellena, hueso, destrío, y otros" } }

   ::aFooter := {  {|| "Salmuera o acetico   : " + Trans( ::nTotSalmuera,::cPicOut ) },;
                   {|| "Cocidas para verde   : " + Trans( ::nTotCocidas, ::cPicOut ) },;
                   {|| "Rellenas             : " + Trans( ::nTotRellenas, ::cPicOut ) } }

   ::oAlbCliT:GoTop()

   while !::oAlbCliT:Eof()

      if Eval ( bValid )                                                         .AND.;
         ::oAlbCliT:dFecAlb >= ::dIniInf                                         .AND.;
         ::oAlbCliT:dFecAlb <= ::dFinInf                                         .AND.;
         lChkSer( ::oAlbCliT:cSerAlb, ::aSer )

         if ::oAlbCliL:Seek( ::oAlbCliT:cSerAlb + Str( ::oAlbCliT:nNumAlb ) + ::oAlbCliT:cSufAlb )

            while ::oAlbCliT:cSerAlb + Str( ::oAlbCliT:nNumAlb ) + ::oAlbCliT:cSufAlb == ::oAlbCliL:cSerAlb + Str( ::oAlbCliL:nNumAlb ) + ::oAlbCliL:cSufAlb

               cCodTip := oRetFld( ::oAlbCliL:cRef, ::oDbfArt , "cCodTip")

               if ( ::lAllTip .or. ( cCodTip >= ::cTipOrg .AND. cCodTip <= ::cTipDes ) )                 .AND.;
                  !::oAlbCliL:lKitChl

                  cDocMov := lTrim( ::oAlbCliL:CSERALB ) + "/" + lTrim ( Str( ::oAlbCliL:NNUMALB ) ) + "/" + lTrim ( ::oAlbCliL:CSUFALB )

                  if cCodTip == "ENT"

                     if ::oDbf:Seek( cCodTip + cDocMov )

                        ::oDbf:Load()
                        ::oDbf:nKilEx1 += nTotNAlbCli( ::oAlbCliL ) *  oRetFld( ::oAlbCliL:cRef, ::oDbfArt, "nPesoKg" )
                        ::oDbf:Save()

                     else

                        ::oDbf:Append()
                        ::oDbf:Blank()
                        ::AddCliente( ::oAlbCliT:cCodCli, ::oAlbCliT, .f. )
                        ::oDbf:dFecDo1 := Dtoc( ::oAlbCliT:dFecAlb )
                        ::oDbf:nKilEx1 := nTotNAlbCli( ::oAlbCliL ) *  oRetFld( ::oAlbCliL:cRef, ::oDbfArt, "nPesoKg" )
                        ::oDbf:cDesti1 := lTrim( ::oAlbCliT:cNomCli )
                        ::oDbf:cNumDoc := cDocMov
                        ::oDbf:Save()

                        ::oDbf:Append()
                        ::oDbf:Blank()
                        ::oDbf:cDesti1 := lTrim( ::oAlbCliT:cDirCli )
                        ::oDbf:cNumDoc := cDocMov
                        ::oDbf:Save()

                        ::oDbf:Append()
                        ::oDbf:Blank()
                        ::oDbf:cDesti1 := lTrim( ::oAlbCliT:cPobCli )
                        ::oDbf:cNumDoc := cDocMov
                        ::oDbf:Save()

                        ::oDbf:Append()
                        ::oDbf:Blank()
                        ::oDbf:cDesti1 := "C.I.F.:" + lTrim( ::oAlbCliT:cDniCli )
                        ::oDbf:cNumDoc := cDocMov
                        ::oDbf:Save()

                        ::oDbf:Append()
                        ::oDbf:Blank()
                        ::oDbf:cDesti1 := "Doc.:" + cDocMov
                        ::oDbf:cNumDoc := cDocMov
                        ::oDbf:Save()

                     end if

                  else

                     if ::oDbf:Seek( cCodTip + cDocMov )

                        ::oDbf:Load()
                        ::oDbf:nKilEx2 += nTotNAlbCli( ::oAlbCliL ) *  oRetFld( ::oAlbCliL:cRef, ::oDbfArt, "nPesoKg" )
                        ::oDbf:Save()

                     else

                        ::oDbf:Append()
                        ::oDbf:Blank()
                        ::AddCliente( ::oAlbCliT:cCodCli, ::oAlbCliT, .f. )
                        ::oDbf:dFecDo2 := Dtoc( ::oAlbCliT:dFecAlb )
                        ::oDbf:nKilEx2 := nTotNAlbCli( ::oAlbCliL ) *  oRetFld( ::oAlbCliL:cRef, ::oDbfArt, "nPesoKg" )
                        ::oDbf:cDesti2 := lTrim( ::oAlbCliT:cNomCli )
                        ::oDbf:cNumDoc := cDocMov
                        ::oDbf:Save()

                        ::oDbf:Append()
                        ::oDbf:Blank()
                        ::oDbf:cDesti2 := lTrim( ::oAlbCliT:cDirCli )
                        ::oDbf:cNumDoc := cDocMov
                        ::oDbf:Save()

                        ::oDbf:Append()
                        ::oDbf:Blank()
                        ::oDbf:cDesti2 := lTrim( ::oAlbCliT:cPobCli )
                        ::oDbf:cNumDoc := cDocMov
                        ::oDbf:Save()

                        ::oDbf:Append()
                        ::oDbf:Blank()
                        ::oDbf:cDesti2 := "C.I.F.:" + lTrim( ::oAlbCliT:cDniCli )
                        ::oDbf:cNumDoc := cDocMov
                        ::oDbf:Save()

                        ::oDbf:Append()
                        ::oDbf:Blank()
                        ::oDbf:cDesti2 := "Doc.:" + cDocMov
                        ::oDbf:cNumDoc := cDocMov
                        ::oDbf:Save()

                     end if

                  end if

                  do case
                     case cCodTip == "DHM" .or. cCodTip == "LMO" .or. cCodTip == "PMO" .or. cCodTip == "LAM"
                        ::nTotSalmuera += nTotNAlbCli( ::oAlbCliL ) *  oRetFld( ::oAlbCliL:cRef, ::oDbfArt, "nPesoKg" )
                     case cCodTip == "DHV" .or. cCodTip == "LVE" .or. cCodTip == "PVE" .or. cCodTip == "LAV"
                        ::nTotCocidas += nTotNAlbCli( ::oAlbCliL ) *  oRetFld( ::oAlbCliL:cRef, ::oDbfArt, "nPesoKg" )
                     case cCodTip == "RAL" .or. cCodTip == "RAN" .or. cCodTip == "RPA" .or. cCodTip == "RPE" .or. cCodTip == "RPP"
                        ::nTotRellenas += nTotNAlbCli( ::oAlbCliL ) *  oRetFld( ::oAlbCliL:cRef, ::oDbfArt, "nPesoKg" )
                  end case

               end if

               ::oAlbCliL:Skip()

            end while

         end if

      end if

      ::oAlbCliT:Skip()

      ::oMtrInf:AutoInc()

   end while

   ::oMtrInf:AutoInc( ::oAlbCliT:Lastrec() )

   ::oDlg:Enable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//