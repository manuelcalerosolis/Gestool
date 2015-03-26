#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS TResCFac FROM TInfGen

   DATA  lTvta       AS LOGIC    INIT .f.
   DATA  oEstado     AS OBJECT
   DATA  oFacCliT    AS OBJECT
   DATA  oFacCliL    AS OBJECT
   DATA  oFacRecT    AS OBJECT
   DATA  oFacRecL    AS OBJECT
   DATA  oDbfTvta    AS OBJECT
   DATA  aEstado     AS ARRAY    INIT  { "Pendiente", "Liquidada", "Todas" }
   DATA  cTipVen     AS CHARACTER
   DATA  cTipVen2    AS CHARACTER

   METHOD Create()

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHOD lResource( cFld )

   METHOD lGenerate()

END CLASS

//---------------------------------------------------------------------------//

METHOD Create()

   ::AddField ( "CCODART", "C", 18, 0, {|| "@!" },         "Código artículo",                 .f., "Cod. Artículo"       , 14 )
   ::AddField ( "CNOMART", "C",100, 0, {|| "@!" },         "Artículo",                  .t., "Artículo"            , 25 )
   ::AddField ( "NCAJENT", "N", 19, 6, {|| MasUnd() },     cNombreCajas(),              .f., cNombreCajas()        , 10 )
   ::AddField ( "NUNIDAD", "N", 19, 6, {|| MasUnd() },     cNombreUnidades(),           .t., cNombreUnidades()     , 10 )
   ::AddField ( "NUNTENT", "N", 19, 6, {|| MasUnd() },     "Tot. " + cNombreUnidades(), .t., "Total " + cNombreUnidades() , 10 )
   ::AddField ( "NPREDIV", "N", 19, 6, {|| ::cPicOut },    "Importe",                   .t., "Importe"             , 10 )
   ::AddField ( "NCOMAGE", "N", 19, 6, {|| ::cPicOut },    "Com. age.",                 .t., "Comisión agente"     , 10 )
   ::AddField ( "NTOTAGE", "N", 19, 6, {|| ::cPicOut },    "Imp. Age.",                 .t., "Importe agente"      , 10 )

   ::AddTmpIndex( "CCODART", "CCODART" )


RETURN ( self )

//---------------------------------------------------------------------------//

METHOD OpenFiles() CLASS TResCFac

   local lOpen    := .t.
   local oBlock   := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

   ::oFacCliT := TDataCenter():oFacCliT()

   DATABASE NEW ::oFacCliL  PATH ( cPatEmp() ) FILE "FACCLIL.DBF" VIA ( cDriver() ) SHARED INDEX "FACCLIL.CDX"

   DATABASE NEW ::oFacRecT  PATH ( cPatEmp() ) FILE "FACRECT.DBF" VIA ( cDriver() ) SHARED INDEX "FACRECT.CDX"

   DATABASE NEW ::oFacRecL  PATH ( cPatEmp() ) FILE "FACRECL.DBF" VIA ( cDriver() ) SHARED INDEX "FACRECL.CDX"

   DATABASE NEW ::oDbfTvta  PATH ( cPatDat() ) FILE "TVTA.DBF"    VIA ( cDriver() ) SHARED INDEX "TVTA.CDX"

   RECOVER

      msgStop( 'Imposible abrir todas las bases de datos' )
      ::CloseFiles()
      lOpen          := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD CloseFiles() CLASS TResCFac

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

   if !Empty( ::oDbfTvta ) .and. ::oDbfTvta:Used()
      ::oDbfTvta:End()
   end if

   ::oFacCliT := nil
   ::oFacCliL := nil
   ::oFacRecT := nil
   ::oFacRecL := nil
   ::oDbfTvta := nil

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD lResource( cFld ) CLASS TResCFac

   local cEstado     := "Todas"
   local oTipVen
   local oTipVen2
   local This        := Self

   if !::StdResource( "INF_GEN04" )
      return .f.
   end if

   /*
   Monta los obras de manera automatica
   */

   if !::oDefCliInf( 70, 80, 90, 100, , 600 )
      return .f.
   end if

   /*
   Monta los clientes de manera automatica
   */

   if !::oDefObrInf( 110, 120, 130, 140, 220 )
      return .f.
   end if

   /*
   Monta los articulos de manera automatica
   */

   if !::lDefArtInf( 150, 160, 170, 180, 800 )
      return .f.
   end if


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

   /*
   Damos valor al meter
   */

   ::oMtrInf:SetTotal( ::oFacCliT:Lastrec() )

   ::oDefExcInf()

   ::oDefExcImp()

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

METHOD lGenerate() CLASS TResCFac

   local cExpHead  := ""
   local cExpLine  := ""

   ::oDlg:Disable()
   ::oBtnCancel:Enable()
   ::oDbf:Zap()

   ::aHeader   := {{|| "Fecha     : " + Dtoc( Date() ) },;
                   {|| "Periodo   : " + Dtoc( ::dIniInf )  + " > " + Dtoc( ::dFinInf ) },;
                   {|| "Clientes  : " + if( ::lAllCli, "Todos", Rtrim( ::cCliOrg ) + " > " + Rtrim( ::cCliDes ) ) },;
                   {|| "Obras     : " + if( ::lAllObr, "Todas", Rtrim( ::cObrOrg ) + " > " + Rtrim( ::cObrDes ) ) },;
                   {|| "Artículos : " + if( ::lAllArt, "Todos", Rtrim( ::cArtOrg ) + " > " + Rtrim( ::cArtDes ) ) },;
                   {|| if( !Empty( ::cTipVen ), "Tipo de Venta: " + ::cTipVen2, "Tipo de Venta: Todos" ) },;
                   {|| "Estado    : " + ::aEstado[ ::oEstado:nAt ] },;
                   {|| if( ::lTvta, "Aplicando comportamiento de los tipos de venta", "" ) } }

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

   if !::lAllCli
      cExpHead       += ' .and. cCodCli >= "' + Rtrim( ::cCliOrg ) + '" .and. cCodCli <= "' + Rtrim( ::cCliDes ) + '"'
   end if

   if !::lAllObr
      cExpHead       += ' .and. cCodObr >= "' + Rtrim( ::cObrOrg ) + '" .and. cCodObr <= "' + Rtrim( ::cObrDes ) + '"'
   end if

   if !Empty( ::oFilter:cExpresionFilter )
      cExpHead       += ' .and. ' + ::oFilter:cExpresionFilter
   end if

   ::oFacCliT:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oFacCliT:cFile ), ::oFacCliT:OrdKey(), ( cExpHead ), , , , , , , , .t. )

   ::oMtrInf:SetTotal( ::oFacCliT:OrdKeyCount() )

   /*
   Lineas de albaranes
   */

   cExpLine          := '!lTotLin .and. !lControl'

   if !::lAllArt
      cExpLine       += ' .and. cRef >= "' + ::cArtOrg + '" .and. cRef <= "' + ::cArtDes + '"'
   end if

   ::oFacCliL:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oFacCliL:cFile ), ::oFacCliL:OrdKey(), cAllTrimer( cExpLine ), , , , , , , , .t. )

   ::oFacCliT:GoTop()

   while !::lBreak .and. !::oFacCliT:Eof()

      if lChkSer( ::oFacCliT:CSERIE, ::aSer )

         /*
         Posicionamos en las lineas de detalle --------------------------------
         */

         if ::oFacCliL:Seek( ::oFacCliT:CSERIE + Str( ::oFacCliT:NNUMFAC ) + ::oFacCliT:CSUFFAC )

            while ::oFacCliT:CSERIE + Str( ::oFacCliT:NNUMFAC ) + ::oFacCliT:CSUFFAC == ::oFacCliL:CSERIE + Str( ::oFacCliL:NNUMFAC ) + ::oFacCliL:CSUFFAC .AND. ! ::oFacCliL:eof()

               if ::lTvta

                  if ( if( !Empty(::cTipVen), ::oFacCliL:cTipMov == ::cTipVen, .t. ) )                      .AND.;
                     !( ::lExcCero .AND. ( nTotNFacCli( ::oFacCliL ) == 0 ) )                               .AND.;
                     !( ::lExcImp .and. ( nTotLFacCli( ::oFacCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv ) == 0 ) )

                     if ::oDbf:Seek( ::oFacCliL:cRef )

                        ::oDbf:Load()

                        if ::oDbfTvta:Seek( ::oFacCliL:cTipMov )

                           if ::oDbfTvta:nUndMov == 1
                              ::oDbf:NCAJENT += ::oFacCliL:NCANENT
                              ::oDbf:nUnidad += ::oFacCliL:NUNICAJA
                              ::oDbf:NUNTENT += nTotNFacCli( ::oFacCliL )
                           elseif ::oDbfTvta:nUndMov == 2
                              ::oDbf:NCAJENT += - ::oFacCliL:NCANENT
                              ::oDbf:nUnidad += - ::oFacCliL:NUNICAJA
                              ::oDbf:NUNTENT += - nTotNFacCli( ::oFacCliL )
                           elseif ::oDbfTvta:nUndMov == 3
                              ::oDbf:NCAJENT += 0
                              ::oDbf:NUNTENT += 0
                              ::oDbf:nUnidad += 0
                           end

                           if ::oDbfTvta:nImpMov != 3
                              ::oDbf:nTotAge += nComLFacCli( ::oFacCliT:cAlias, ::oFacCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
                              ::oDbf:nPreDiv += nImpLFacCli( ::oFacCliT:cAlias, ::oFacCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv, .f., .t., .f., .f. )
                           end

                        end if

                        ::oDbf:Save()

                     else

                        ::oDbf:Append()

                        ::oDbf:CCODART := ::oFacCliL:cRef
                        ::oDbf:CNOMART := ::oFacCliL:cDetalle

                        if ::oDbfTvta:Seek( ::oFacCliL:cTipMov )

                           if ::oDbfTvta:nUndMov == 1
                              ::oDbf:NCAJENT := ::oFacCliL:NCANENT
                              ::oDbf:nUnidad := ::oFacCliL:NUNICAJA
                              ::oDbf:NUNTENT := nTotNFacCli( ::oFacCliL )
                           elseif ::oDbfTvta:nUndMov == 2
                              ::oDbf:NCAJENT := - ::oFacCliL:NCANENT
                              ::oDbf:nUnidad := - ::oFacCliL:NUNICAJA
                              ::oDbf:NUNTENT := - nTotNFacCli( ::oFacCliL )
                           elseif ::oDbfTvta:nUndMov == 3
                              ::oDbf:NCAJENT := 0
                              ::oDbf:NUNTENT := 0
                              ::oDbf:nUnidad := 0
                           end if

                           if ::oDbfTvta:nImpMov != 3
                              ::oDbf:nTotAge := nComLFacCli( ::oFacCliT:cAlias, ::oFacCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
                              ::oDbf:nPreDiv := nImpLFacCli( ::oFacCliT:cAlias, ::oFacCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv, .f., .t., .f., .f. )
                           else
                              ::oDbf:nTotAge := 0
                              ::oDbf:nPreDiv := 0
                           end if

                        end if

                        ::oDbf:Save()

                     end if

                  end if

                  ::oFacCliL:Skip()

               else

                  if !( ::lExcCero .and. ( nTotNFacCli( ::oFacCliL ) == 0 ) )                               .AND.;
                     !( ::lExcImp .and. ( nTotLFacCli( ::oFacCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv ) == 0 ) )

                     if ::oDbf:Seek( ::oFacCliL:CREF )

                        ::oDbf:Load()

                        ::oDbf:NCAJENT += ::oFacCliL:NCANENT
                        ::oDbf:nUnidad += ::oFacCliL:NUNICAJA
                        ::oDbf:NUNTENT += nTotNFacCli( ::oFacCliL )
                        ::oDbf:nTotAge += nComLFacCli( ::oFacCliT:cAlias, ::oFacCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
                        ::oDbf:nPreDiv += nImpLFacCli( ::oFacCliT:cAlias, ::oFacCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv, .f., .t., .f., .f. )

                        ::oDbf:Save()

                     else

                        ::oDbf:Append()

                        ::oDbf:cCodArt := ::oFacCliL:CREF
                        ::oDbf:cNomArt := ::oFacCliL:cDetalle
                        ::oDbf:nCajEnt := ::oFacCliL:NCANENT
                        ::oDbf:nUnidad := ::oFacCliL:NUNICAJA
                        ::oDbf:nUntEnt := nTotNFacCli( ::oFacCliL )
                        ::oDbf:nTotAge := nComLFacCli( ::oFacCliT:cAlias, ::oFacCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
                        ::oDbf:nPreDiv := nImpLFacCli( ::oFacCliT:cAlias, ::oFacCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv, .f., .t., .f., .f. )

                        ::oDbf:Save()

                     end if

                  end if

                  ::oFacCliL:Skip()

               end if

            end while

         end if

      end if
      ::oFacCliT:Skip()

      ::oMtrInf:AutoInc()

   end while

   ::oFacCliT:IdxDelete( cCurUsr(), GetFileNoExt( ::oFacCliT:cFile ) )

   ::oFacCliL:IdxDelete( cCurUsr(), GetFileNoExt( ::oFacCliL:cFile ) )

   //facturas rectificativas

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

   if !::lAllCli
      cExpHead       += ' .and. cCodCli >= "' + Rtrim( ::cCliOrg ) + '" .and. cCodCli <= "' + Rtrim( ::cCliDes ) + '"'
   end if

   if !::lAllObr
      cExpHead       += ' .and. cCodObr >= "' + Rtrim( ::cObrOrg ) + '" .and. cCodObr <= "' + Rtrim( ::cObrDes ) + '"'
   end if

   if !Empty( ::oFilter:cExpresionFilter )
      cExpHead       += ' .and. ' + ::oFilter:cExpresionFilter
   end if

   ::oFacRecT:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oFacRecT:cFile ), ::oFacRecT:OrdKey(), ( cExpHead ), , , , , , , , .t. )

   ::oMtrInf:SetTotal( ::oFacRecT:OrdKeyCount() )

   /*
   Lineas de albaranes
   */

   cExpLine          := '!lTotLin .and. !lControl'

   if !::lAllArt
      cExpLine       += ' .and. cRef >= "' + ::cArtOrg + '" .and. cRef <= "' + ::cArtDes + '"'
   end if

   ::oFacRecL:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oFacRecL:cFile ), ::oFacRecL:OrdKey(), cAllTrimer( cExpLine ), , , , , , , , .t. )

   ::oFacRecT:GoTop()

   while !::lBreak .and. !::oFacRecT:Eof()

      if lChkSer( ::oFacRecT:CSERIE, ::aSer )

         /*
         Posicionamos en las lineas de detalle --------------------------------
         */

         if ::oFacRecL:Seek( ::oFacRecT:CSERIE + Str( ::oFacRecT:NNUMFAC ) + ::oFacRecT:CSUFFAC )

            while ::oFacRecT:CSERIE + Str( ::oFacRecT:NNUMFAC ) + ::oFacRecT:CSUFFAC == ::oFacRecL:CSERIE + Str( ::oFacRecL:NNUMFAC ) + ::oFacRecL:CSUFFAC .AND. ! ::oFacRecL:eof()

               if ::lTvta

                  if ( if( !Empty(::cTipVen), ::oFacRecL:cTipMov == ::cTipVen, .t. ) )                      .AND.;
                     !( ::lExcCero .AND. ( nTotNFacRec( ::oFacRecL ) == 0 ) )                               .AND.;
                     !( ::lExcImp .and. ( nTotLFacRec( ::oFacRecL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv ) == 0 ) )

                     if ::oDbf:Seek( ::oFacRecL:cRef )

                        ::oDbf:Load()

                        if ::oDbfTvta:Seek( ::oFacRecL:cTipMov )

                           if ::oDbfTvta:nUndMov == 1
                              ::oDbf:NCAJENT += ::oFacRecL:NCANENT
                              ::oDbf:nUnidad += ::oFacRecL:NUNICAJA
                              ::oDbf:NUNTENT += nTotNFacCli( ::oFacRecL )
                           elseif ::oDbfTvta:nUndMov == 2
                              ::oDbf:NCAJENT += - ::oFacRecL:NCANENT
                              ::oDbf:nUnidad += - ::oFacRecL:NUNICAJA
                              ::oDbf:NUNTENT += - nTotNFacRec( ::oFacRecL )
                           elseif ::oDbfTvta:nUndMov == 3
                              ::oDbf:NCAJENT += 0
                              ::oDbf:NUNTENT += 0
                              ::oDbf:nUnidad += 0
                           end

                           if ::oDbfTvta:nImpMov != 3
                              ::oDbf:nTotAge += nComLFacRec( ::oFacRecT:cAlias, ::oFacRecL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
                              ::oDbf:nPreDiv += nImpLFacRec( ::oFacRecT:cAlias, ::oFacRecL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv, .f., .t., .f., .f. )
                           end

                        end if

                        ::oDbf:Save()

                     else

                        ::oDbf:Append()

                        ::oDbf:CCODART := ::oFacRecL:cRef
                        ::oDbf:CNOMART := ::oFacRecL:cDetalle

                        if ::oDbfTvta:Seek( ::oFacRecL:cTipMov )

                           if ::oDbfTvta:nUndMov == 1
                              ::oDbf:NCAJENT := ::oFacRecL:NCANENT
                              ::oDbf:nUnidad := ::oFacRecL:NUNICAJA
                              ::oDbf:NUNTENT := nTotNFacRec( ::oFacRecL )
                           elseif ::oDbfTvta:nUndMov == 2
                              ::oDbf:NCAJENT := - ::oFacRecL:NCANENT
                              ::oDbf:nUnidad := - ::oFacRecL:NUNICAJA
                              ::oDbf:NUNTENT := - nTotNFacRec( ::oFacRecL )
                           elseif ::oDbfTvta:nUndMov == 3
                              ::oDbf:NCAJENT := 0
                              ::oDbf:NUNTENT := 0
                              ::oDbf:nUnidad := 0
                           end if

                           if ::oDbfTvta:nImpMov != 3
                              ::oDbf:nTotAge := nComLFacRec( ::oFacRecT:cAlias, ::oFacRecL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
                              ::oDbf:nPreDiv := nImpLFacRec( ::oFacRecT:cAlias, ::oFacRecL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv, .f., .t., .f., .f. )
                           else
                              ::oDbf:nTotAge := 0
                              ::oDbf:nPreDiv := 0
                           end if

                        end if

                        ::oDbf:Save()

                     end if

                  end if

                  ::oFacRecL:Skip()

               else

                  if !( ::lExcCero .and. ( nTotNFacRec( ::oFacRecL ) == 0 ) )                               .AND.;
                     !( ::lExcImp .and. ( nTotLFacRec( ::oFacRecL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv ) == 0 ) )

                     if ::oDbf:Seek( ::oFacRecL:CREF )

                        ::oDbf:Load()

                        ::oDbf:NCAJENT += ::oFacRecL:NCANENT
                        ::oDbf:nUnidad += ::oFacRecL:NUNICAJA
                        ::oDbf:NUNTENT += nTotNFacRec( ::oFacRecL )
                        ::oDbf:nTotAge += nComLFacRec( ::oFacRecT:cAlias, ::oFacRecL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
                        ::oDbf:nPreDiv += nImpLFacRec( ::oFacRecT:cAlias, ::oFacRecL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv, .f., .t., .f., .f. )

                        ::oDbf:Save()

                     else

                        ::oDbf:Append()

                        ::oDbf:cCodArt := ::oFacRecL:CREF
                        ::oDbf:cNomArt := ::oFacRecL:cDetalle
                        ::oDbf:nCajEnt := ::oFacRecL:NCANENT
                        ::oDbf:nUnidad := ::oFacRecL:NUNICAJA
                        ::oDbf:nUntEnt := nTotNFacRec( ::oFacRecL )
                        ::oDbf:nTotAge := nComLFacRec( ::oFacRecT:cAlias, ::oFacRecL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
                        ::oDbf:nPreDiv := nImpLFacRec( ::oFacRecT:cAlias, ::oFacRecL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv, .f., .t., .f., .f. )

                        ::oDbf:Save()

                     end if

                  end if

                  ::oFacRecL:Skip()

               end if

            end while

         end if

      end if
      ::oFacRecT:Skip()

      ::oMtrInf:AutoInc()

   end while

   ::oFacRecT:IdxDelete( cCurUsr(), GetFileNoExt( ::oFacRecT:cFile ) )

   ::oFacRecL:IdxDelete( cCurUsr(), GetFileNoExt( ::oFacRecL:cFile ) )

   ::oMtrInf:AutoInc( ::oFacRecT:Lastrec() )

   ::oDlg:Enable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//