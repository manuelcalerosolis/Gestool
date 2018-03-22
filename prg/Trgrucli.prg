#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"
//---------------------------------------------------------------------------//

CLASS TRGruCliInf FROM TInfGen

   DATA  lExcCero    AS LOGIC    INIT .f.
   DATA  lTvta       AS LOGIC    INIT .f.
   DATA  oEstado     AS OBJECT
   DATA  oFacCliT    AS OBJECT
   DATA  oFacCliL    AS OBJECT
   DATA  oFacRecT    AS OBJECT
   DATA  oFacRecL    AS OBJECT
    
   DATA  oDbfGprCli  AS OBJECT
   DATA  aEstado     AS ARRAY    INIT  { "Pendiente", "Liquidada", "Todas" }
   DATA  cTipVen     AS CHARACTER
   DATA  cTipVen2    AS CHARACTER
   DATA  cGrCOrg     AS CHARACTER
   DATA  cGrCDes     AS CHARACTER

   METHOD Create()

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHOD lResource( cFld )

   METHOD lGenerate()

END CLASS

//---------------------------------------------------------------------------//

METHOD Create()

   ::AddField ( "cCodGrc", "C",  5, 0, {|| "@!" },         "Cod.",              .f., "Código grupo cliente",    5 )
   ::AddField ( "cNomGrc", "C", 50, 0, {|| "@!" },         "Grupo",             .f., "Nombre grupo cliente",   20 )
   ::AddField ( "cCodArt", "C", 18, 0, {|| "@!" },         "Art.",              .t., "Cod. artículo",          12 )
   ::AddField ( "cNomArt", "C",100, 0, {|| "@!" },         "Artículo",          .t., "Artículo",               50 )
   ::AddField ( "nCajEnt", "N", 19, 6, {|| MasUnd() },     cNombreCajas(),      .f., cNombreCajas(),           12 )
   ::AddField ( "nUniDad", "N", 19, 6, {|| MasUnd() },     cNombreUnidades(),   .t., cNombreUnidades(),        12 )
   ::AddField ( "nUntEnt", "N", 19, 6, {|| MasUnd() },     "Tot. " + cNombreUnidades(), .f., "Total " + cNombreUnidades(), 12 )
   ::AddField ( "nPreDiv", "N", 19, 6, {|| ::cPicOut },    "Importe",           .t., "Importe",                12 )
   ::AddField ( "nComAge", "N", 19, 6, {|| ::cPicOut },    "Com. Age",          .t., "Comisión agente",        12 )
   ::AddField ( "nTotAge", "N", 19, 6, {|| ::cPicOut },    "Imp. Age",          .t., "Importe agente",         12 )

   ::AddTmpIndex ( "CCODGRC", "CCODGRC + CCODART" )

   ::AddGroup( {|| ::oDbf:cCodGrC }, {|| "Grupo cliente  : " + Rtrim( ::oDbf:cCodGrC ) + "-" + oRetFld( ::oDbf:cCodGrC, ::oGrpCli:oDbf) } )

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD OpenFiles()

   local lOpen       := .t.
   local oBlock      := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

      ::oFacCliT     := TDataCenter():oFacCliT()

      DATABASE NEW ::oFacCliL   PATH ( cPatEmp() ) FILE "FACCLIL.DBF" VIA ( cDriver() ) SHARED INDEX "FACCLIL.CDX"

      DATABASE NEW ::oFacRecT   PATH ( cPatEmp() ) FILE "FACRECT.DBF" VIA ( cDriver() ) SHARED INDEX "FACRECT.CDX"

      DATABASE NEW ::oFacRecL   PATH ( cPatEmp() ) FILE "FACRECL.DBF" VIA ( cDriver() ) SHARED INDEX "FACRECL.CDX"

      DATABASE NEW ::oDbfCli    PATH ( cPatCli() ) FILE "CLIENT.DBF"  VIA ( cDriver() ) SHARED INDEX "CLIENT.CDX"

   RECOVER

      msgStop( 'Imposible abrir todas las bases de datos' )

      ::CloseFiles()
      
      lOpen          := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD CloseFiles()


   if !Empty( ::oFacCliT ) .and. ::oFacCliT:Used()
      ::oFacCliT:End()
   end if
   if !Empty( ::oFacCliL ) .and. ::oFacCliL:Used()
      ::oFacCliL:End()
   end if
   if !Empty( ::oFacRecT ) .and. ::oFacRecT:Used()
      ::oFacRecT:End()
   end if
   if !Empty( ::oFacRecL ) .and. ::oFacRecL:Used()
      ::oFacRecL:End()
   end if
   if !Empty( ::oDbfCli ) .and. ::oDbfCli:Used()
      ::oDbfCli:End()
   end if

   ::oFacCliT := nil
   ::oFacCliL := nil
   ::oFacRecT := nil
   ::oFacRecL := nil
   ::oDbfCli  := nil

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD lResource( cFld )

   local cEstado     := "Todas"
   local oTipVen
   local oTipVen2
   local This        := Self

   if !::StdResource( "INF_GEN22" )
      return .f.
   end if

   //monta los grupos de clientes

   if !::oDefGrpCli( 70, 71, 80, 81, 90 )
      return .f.
   end if

   /*
   Monta las rutas de manera automatica
   */

   if !::oDefRutInf( 110, 120, 130, 140, 600 )
      return .f.
   end if

   /*
   Monta los articulos de manera automatica
   */

   if !::lDefArtInf( 150, 160, 170, 180, 800 )
      return .f.
   end if

   /*
   Damos valor al meter
   */

   ::oMtrInf:SetTotal( ::oFacCliT:Lastrec() )

   ::oDefExcInf()

   REDEFINE COMBOBOX ::oEstado ;
      VAR      cEstado ;
      ID       218 ;
      ITEMS    ::aEstado ;
      OF       ::oFld:aDialogs[1]

   ::CreateFilter( aItmFacCli(), ::oFacCliT:cAlias )

RETURN .t.

//---------------------------------------------------------------------------//
/*
Esta funcion crea la base de datos para generar posteriormente el informe
*/

METHOD lGenerate()

   local cExpHead    := ""
   local cExpLine    := ""

   ::oDlg:Disable()
   ::oBtnCancel:Enable()
   ::oDbf:Zap()

   ::aHeader   := {  {|| "Fecha         : " + Dtoc( Date() ) },;
                     {|| "Periodo       : " + Dtoc( ::dIniInf )  + " > " + Dtoc( ::dFinInf ) },;
                     {|| "Grp. clientes : " + if( ::lGrpAll, "Todos", Rtrim( ::cGrpOrg ) + " > " + Rtrim( ::cGrpDes ) ) },;
                     {|| "Rutas         : " + if( ::lAllRut, "Todos", Rtrim( ::cRutOrg ) + " > " + Rtrim( ::cRutDes ) ) },;
                     {|| "Artículos     : " + if( ::lAllArt, "Todos", Rtrim( ::cArtOrg ) + " > " + Rtrim( ::cArtDes ) ) },;
                     {|| if ( ::lTvta,( if( !Empty( ::cTipVen ), "Tipo de Venta: " + ::cTipVen2, "Tipo de Venta: Todos" ) ), "Tipo de Venta: Ninguno" ) },;
                     {|| "Estado   : " + ::aEstado[ ::oEstado:nAt ] } }

   ::oFacCliT:OrdSetFocus( "dFecFac" )
   ::oFacCliL:OrdSetFocus( "nNumFac" )

   do case
      case ::oEstado:nAt == 1
         cExpHead    := '!lLiquidada .and. dFecFac >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecFac <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'
      case ::oEstado:nAt == 2
         cExpHead    := 'lLiquidada .and. dFecFac >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecFac <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'
      case ::oEstado:nAt == 3
         cExpHead    := 'dFecFac >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecFac <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'
   end case

   if !::lAllRut
      cExpHead       += ' .and. cCodRut >= "' + Rtrim( ::cRutOrg ) + '" .and. cCodRut <= "' + Rtrim( ::cRutDes ) + '"'
   end if

   if !Empty( ::oFilter:cExpresionFilter )
      cExpHead       += ' .and. ' + ::oFilter:cExpresionFilter
   end if

   ::oFacCliT:AddTmpIndex( Auth():Codigo(), GetFileNoExt( ::oFacCliT:cFile ), ::oFacCliT:OrdKey(), ( cExpHead ), , , , , , , , .t. )

   ::oMtrInf:SetTotal( ::oFacCliT:OrdKeyCount() )

   cExpLine          := '!lControl .and. !lTotLin'

   if !::lAllArt
      cExpLine       += ' .and. cRef >= "' + ::cArtOrg + '" .and. cRef <= "' + ::cArtDes + '"'
   end if

   ::oFacCliL:AddTmpIndex( Auth():Codigo(), GetFileNoExt( ::oFacCliL:cFile ), ::oFacCliL:OrdKey(), cAllTrimer( cExpLine ), , , , , , , , .t. )

   ::oFacCliT:GoTop()

   while !::lBreak .and. !::oFacCliT:Eof()

      if ( ::lGrpAll .or. ( cGruCli( ::oFacCliT:cCodCli, ::oDbfCli ) >= ::cGrpOrg .AND. cGruCli( ::oFacCliT:cCodCli, ::oDbfCli ) <= ::cGrpDes ) ) .AND.;
         lChkSer( ::oFacCliT:cSerie, ::aSer )

         if ::oFacCliL:Seek( ::oFacCliT:cSerie + Str( ::oFacCliT:nNumFac ) + ::oFacCliT:cSufFac )

            while ::oFacCliT:cSerie + Str( ::oFacCliT:nNumFac ) + ::oFacCliT:cSufFac == ::oFacCliL:cSerie + Str( ::oFacCliL:nNumFac ) + ::oFacCliL:cSufFac .AND. ! ::oFacCliL:eof()

               if !( ::lExcCero .AND. ( nTotNFacCli( ::oFacCliL ) == 0 ) )

                  if ::oDbf:Seek( cGruCli( ::oFacCliT:cCodCli, ::oDbfCli ) + ::oFacCliL:CREF )

                     ::oDbf:Load()

                     ::oDbf:NCAJENT += ::oFacCliL:NCANENT
                     ::oDbf:NUNTENT += nTotNFacCli( ::oFacCliL )
                     ::oDbf:nUnidad += ::oFacCliL:NUNICAJA
                     ::oDbf:nComAge += ::oFacCliL:nComAge
                     ::oDbf:nTotAge += nComLFacCli( ::oFacCliT:cAlias, ::oFacCliL:cAlias, ::nDecOut, ::nDerOut  )
                     ::oDbf:nPreDiv += nImpLFacCli( ::oFacCliT:cAlias, ::oFacCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv, .f., .t., .f., .f. )

                     ::oDbf:Save()

                  else

                     ::oDbf:Append()

                     ::oDbf:cCodGrC := cGruCli( ::oFacCliT:cCodCli, ::oDbfCli )
                     ::oDbf:cNomGrc := oRetFld( ::oDbf:cCodGrC, ::oGrpCli:oDbf )
                     ::oDbf:CCODART := ::oFacCliL:CREF
                     ::oDbf:CNOMART := ::oFacCliL:cDetalle
                     ::oDbf:NCAJENT := ::oFacCliL:NCANENT
                     ::oDbf:NUNTENT := nTotNFacCli( ::oFacCliL )
                     ::oDbf:nUnidad := ::oFacCliL:NUNICAJA
                     ::oDbf:nComAge := ::oFacCliL:nComAge
                     ::oDbf:nTotAge := nComLFacCli( ::oFacCliT:cAlias, ::oFacCliL:cAlias, ::nDecOut, ::nDerOut  )
                     ::oDbf:nPreDiv := nImpLFacCli( ::oFacCliT:cAlias, ::oFacCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv, .f., .t., .f., .f. )

                     ::oDbf:Save()

                  end if

               end if

               ::oFacCliL:Skip()

              end while

         end if

      end if
      ::oFacCliT:Skip()

      ::oMtrInf:AutoInc()

   end while

   ::oMtrInf:AutoInc( ::oFacCliT:LastRec() )

   ::oFacCliT:IdxDelete( Auth():Codigo(), GetFileNoExt( ::oFacCliT:cFile ) )
   ::oFacCliL:IdxDelete( Auth():Codigo(), GetFileNoExt( ::oFacCliL:cFile ) )

    /*
   comenzamos con las rectificativas
   */

   ::oFacRecT:OrdSetFocus( "dFecFac" )
   ::oFacRecL:OrdSetFocus( "nNumFac" )

   do case
      case ::oEstado:nAt == 1
         cExpHead    := '!lLiquidada .and. dFecFac >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecFac <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'
      case ::oEstado:nAt == 2
         cExpHead    := 'lLiquidada .and. dFecFac >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecFac <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'
      case ::oEstado:nAt == 3
         cExpHead    := 'dFecFac >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecFac <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'
   end case

   if !::lAllRut
      cExpHead       += ' .and. cCodRut >= "' + Rtrim( ::cRutOrg ) + '" .and. cCodRut <= "' + Rtrim( ::cRutDes ) + '"'
   end if

   if !Empty( ::oFilter:cExpresionFilter )
      cExpHead       += ' .and. ' + ::oFilter:cExpresionFilter
   end if

   ::oFacRecT:AddTmpIndex( Auth():Codigo(), GetFileNoExt( ::oFacRecT:cFile ), ::oFacRecT:OrdKey(), ( cExpHead ), , , , , , , , .t. )

   ::oMtrInf:SetTotal( ::oFacRecT:OrdKeyCount() )

   cExpLine          := '!lControl .and. !lTotLin'

   if !::lAllArt
      cExpLine       += ' .and. cRef >= "' + ::cArtOrg + '" .and. cRef <= "' + ::cArtDes + '"'
   end if

   ::oFacRecL:AddTmpIndex( Auth():Codigo(), GetFileNoExt( ::oFacRecL:cFile ), ::oFacRecL:OrdKey(), cAllTrimer( cExpLine ), , , , , , , , .t. )

   ::oFacRecT:GoTop()

   while !::lBreak .and. !::oFacRecT:Eof()

      if ( ::lGrpAll .or. ( cGruCli( ::oFacRecT:cCodCli, ::oDbfCli ) >= ::cGrpOrg .AND. cGruCli( ::oFacRecT:cCodCli, ::oDbfCli ) <= ::cGrpDes ) ) .AND.;
         lChkSer( ::oFacRecT:cSerie, ::aSer )

         if ::oFacRecL:Seek( ::oFacRecT:cSerie + Str( ::oFacRecT:nNumFac ) + ::oFacRecT:cSufFac )

            while ::oFacRecT:cSerie + Str( ::oFacRecT:nNumFac ) + ::oFacRecT:cSufFac == ::oFacRecL:cSerie + Str( ::oFacRecL:nNumFac ) + ::oFacRecL:cSufFac .AND. ! ::oFacRecL:eof()

               if !( ::lExcCero .AND. ( nTotNFacRec( ::oFacRecL ) == 0 ) )

                  if ::oDbf:Seek( cGruCli( ::oFacRecT:cCodCli, ::oDbfCli ) + ::oFacRecL:CREF )

                     ::oDbf:Load()

                     ::oDbf:NCAJENT += ::oFacRecL:NCANENT
                     ::oDbf:NUNTENT += nTotNFacRec( ::oFacRecL )
                     ::oDbf:nUnidad += ::oFacRecL:NUNICAJA
                     ::oDbf:nComAge += ::oFacRecL:nComAge
                     ::oDbf:nTotAge += nComLFacRec( ::oFacRecT:cAlias, ::oFacRecL:cAlias, ::nDecOut, ::nDerOut  )
                     ::oDbf:nPreDiv += nImpLFacRec( ::oFacRecT:cAlias, ::oFacRecL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv, .f., .t., .f., .f. )

                     ::oDbf:Save()

                  else

                     ::oDbf:Append()

                     ::oDbf:cCodGrC := cGruCli( ::oFacRecT:cCodCli, ::oDbfCli )
                     ::oDbf:cNomGrc := oRetFld( ::oDbf:cCodGrC, ::oGrpCli:oDbf )
                     ::oDbf:CCODART := ::oFacRecL:CREF
                     ::oDbf:CNOMART := ::oFacRecL:cDetalle
                     ::oDbf:NCAJENT := ::oFacRecL:NCANENT
                     ::oDbf:NUNTENT := nTotNFacRec( ::oFacRecL )
                     ::oDbf:nUnidad := ::oFacRecL:NUNICAJA
                     ::oDbf:nComAge := ::oFacRecL:nComAge
                     ::oDbf:nTotAge := nComLFacRec( ::oFacRecT:cAlias, ::oFacRecL:cAlias, ::nDecOut, ::nDerOut  )
                     ::oDbf:nPreDiv := nImpLFacRec( ::oFacRecT:cAlias, ::oFacRecL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv, .f., .t., .f., .f. )

                     ::oDbf:Save()

                  end if

               end if

               ::oFacRecL:Skip()

              end while

         end if

      end if
      ::oFacRecT:Skip()

      ::oMtrInf:AutoInc()

   end while

   ::oMtrInf:AutoInc( ::oFacRecT:LastRec() )

   ::oFacRecT:IdxDelete( Auth():Codigo(), GetFileNoExt( ::oFacRecT:cFile ) )
   ::oFacRecL:IdxDelete( Auth():Codigo(), GetFileNoExt( ::oFacRecL:cFile ) )

   ::oDlg:Enable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//