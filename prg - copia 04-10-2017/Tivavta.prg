#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"
//---------------------------------------------------------------------------//

CLASS TIvaVta FROM TInfGen

   DATA  oAlbCliT    AS OBJECT
   DATA  oAlbCliL    AS OBJECT
   DATA  oFacCliP    AS OBJECT
   DATA  oFacCliT    AS OBJECT
   DATA  oFacCliL    AS OBJECT
   DATA  oFacRecT    AS OBJECT
   DATA  oFacRecL    AS OBJECT
   DATA  oAntCliT    AS OBJECT
   DATA  oTikCliT    AS OBJECT
   DATA  oTikCliL    AS OBJECT
   DATA  oDbfIva     AS OBJECT
   DATA  oDbfDiv     AS OBJECT
   DATA  lAllIva     AS LOGIC    INIT .t.
   DATA  cIvaDes     AS CHARACTER
   DATA  cIvaHas     AS CHARACTER

   METHOD Create()

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHOD lResource( cFld )

   METHOD lGenerate()

END CLASS

//---------------------------------------------------------------------------//
/*Creamos la temporal, los ordenes y los grupos*/

METHOD Create()

   ::AddField( "cTipIva", "C",  1, 0, {|| "@!" },         "Tipo",             .f., "Tipo I.V.A",            1, .f. )
   ::AddField( "cNomIva", "C", 30, 0, {|| "@!" },         "Nom. " + cImp(),   .f., "Nombre tipo I.V.A",    35, .f. )
   ::AddField( "nPctIva", "N",  6, 2, {|| "@ 99.99" },    "% " + cImp(),      .f., "Porcentaje de I.V.A",  12, .f. )
   ::AddField( "cTipDoc", "C", 20, 0, {|| "@!" },         "Tipo",             .t., "Tipo documento",       15, .f. )
   ::AddField( "cDocMov", "C", 14, 0, {|| "@!" },         "Documento",        .t., "Documento",            14, .f. )
   ::AddField( "cSerDoc", "C",  1, 0, {|| "@!" },         "Serie documento",  .f., "Serie",                 4, .f. )
   ::AddField( "nNumDoc", "N",  9, 0, {|| "999999999" },  "Número documento", .f., "Número",               10, .f. )
   ::AddField( "cSufDoc", "C",  2, 0, {|| "@!" },         "Sufijo documento", .f., "Sufijo",                4, .f. )
   ::AddField( "dFecMov", "D",  8, 0, {|| "@!" },         "Fecha",            .t., "Fecha",                10, .f. )
   ::AddField( "cCodCli", "C", 12, 0, {|| "@!" },         "Cód. cli.",        .t., "Código cliente",        8, .f. )
   ::AddField( "cNomCli", "C", 50, 0, {|| "@!" },         "Cliente",          .t., "Nombre cliente",       30, .f. )
   ::AddField( "nTotNet", "N", 16, 6, {|| ::cPicOut },    "Neto",             .t., "Neto",                 10, .t. )
   ::AddField( "nTotPnt", "N", 16, 6, {|| ::cPicPnt },    "P.V.",             .f., "Punto verde",          10, .t. )
   ::AddField( "nTotTrn", "N", 16, 6, {|| ::cPicOut },    "Transp.",          .f., "Transporte",           10, .t. )
   ::AddField( "nTotIva", "N", 16, 6, {|| ::cPicOut },    cImp(),             .t., cImp(),                 10, .t. )
   ::AddField( "nTotReq", "N", 16, 3, {|| ::cPicOut },    "Rec",              .f., "Rec",                  10, .t. )
   ::AddField( "nTotDoc", "N", 16, 6, {|| ::cPicOut },    "Total",            .t., "Total",                10, .t. )

   ::AddTmpIndex( "cTipIva", "cTipIva + dTos( dFecMov )" )

   ::AddGroup( {|| ::oDbf:cTipIva }, {|| "Tipo " + cImp() + " : " + Rtrim( ::oDbf:cTipIva ) + "-" + alltrim( ::oDbf:cNomIva ) + " - " + alltrim( Trans( ::oDbf:nPctIva, "@EZ 99.99%" ) ) }, {||"Total tipo impuestos.."} )

   ::dIniInf := GetSysDate()

RETURN ( self )

//---------------------------------------------------------------------------//
/*Abrimos las tablas necesarias*/

METHOD OpenFiles()

   local lOpen    := .t.
   local oBlock   := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

   ::oAlbCliT     := TDataCenter():oAlbCliT()

   DATABASE NEW ::oAlbCliL PATH ( cPatEmp() ) FILE "ALBCLIL.DBF"  VIA ( cDriver() ) SHARED INDEX "ALBCLIL.CDX"

   ::oFacCliT     := TDataCenter():oFacCliT()

   DATABASE NEW ::oFacCliL PATH ( cPatEmp() ) FILE "FACCLIL.DBF"  VIA ( cDriver() ) SHARED INDEX "FACCLIL.CDX"

   DATABASE NEW ::oFacRecT PATH ( cPatEmp() ) FILE "FACRECT.DBF"  VIA ( cDriver() ) SHARED INDEX "FACRECT.CDX"

   DATABASE NEW ::oFacRecL PATH ( cPatEmp() ) FILE "FACRECL.DBF"  VIA ( cDriver() ) SHARED INDEX "FACRECL.CDX"

   ::oFacCliP     := TDataCenter():oFacCliP()

   DATABASE NEW ::oTikCliT PATH ( cPatEmp() ) FILE "TIKET.DBF"    VIA ( cDriver() ) SHARED INDEX "TIKET.CDX"

   DATABASE NEW ::oTikCliL PATH ( cPatEmp() ) FILE "TIKEL.DBF"    VIA ( cDriver() ) SHARED INDEX "TIKEL.CDX"

   DATABASE NEW ::oDbfIva  PATH ( cPatDat() ) FILE "TIVA.DBF"     VIA ( cDriver() ) SHARED INDEX "TIVA.CDX"

   DATABASE NEW ::oDbfDiv  PATH ( cPatDat() ) FILE "DIVISAS.DBF"  VIA ( cDriver() ) SHARED INDEX "DIVISAS.CDX"

   DATABASE NEW ::oAntCliT  PATH ( cPatEmp() ) FILE "ANTCLIT.DBF"  VIA ( cDriver() ) SHARED INDEX "ANTCLIT.CDX"

   RECOVER

      msgStop( 'Imposible abrir todas las bases de datos' )
      ::CloseFiles()
      lOpen       := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//
/*Cerramos las tablas abiertas anteriormente*/

METHOD CloseFiles()

   if !Empty( ::oAlbCliT ) .and. ::oAlbCliT:Used()
      ::oAlbCliT:End()
   end if
   if !Empty( ::oAlbCliL ) .and. ::oAlbCliL:Used()
      ::oAlbCliL:End()
   end if
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
   if !Empty( ::oFacCliP ) .and. ::oFacCliP:Used()
      ::oFacCliP:End()
   end if
   if !Empty( ::oDbfIva ) .and. ::oDbfIva:Used()
      ::oDbfIva:End()
   end if
   if !Empty( ::oTikCliT ) .and. ::oTikCliT:Used()
      ::oTikCliT:End()
   end if
   if !Empty( ::oTikCliL ) .and. ::oTikCliL:Used()
      ::oTikCliL:End()
   end if
   if !Empty( ::oDbfDiv ) .and. ::oDbfDiv:Used()
      ::oDbfDiv:End()
   end if
   if !Empty( ::oAntCliT ) .and. ::oAntCliT:Used()
      ::oAntCliT:End()
   end if

   ::oALbCliT := nil
   ::oAlbCliL := nil
   ::oFacCliT := nil
   ::oFacCliL := nil
   ::oFacRecT := nil
   ::oFacRecL := nil
   ::oFacCliP := nil
   ::oDbfIva  := nil
   ::oDbfDiv  := nil
   ::oTikCliT := nil
   ::oTikCliL := nil
   ::oAntCliT := nil

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD lResource( cFld )

   local cEstado     := "Todas"
   local oIvaDes
   local oIvaHas
   local oIvaDesTxt
   local oIvaHasTxt
   local cIvaDesTxt
   local cIvaHasTxt
   local oThis := ::oDbfIva

   if !::StdResource( "INF_GEN19B" )
      return .f.
   end if

   /*Se montan los desde - hasta ( en este caso se monta aquí pq no está en el tinfgen )*/

   ::cIvaDes   := dbFirst( ::oDbfIva, 1 )
   ::cIvaHas   := dbLast(  ::oDbfIva, 1 )
   cIvaDesTxt  := dbFirst( ::oDbfIva, 2 )
   cIvaHasTxt  := dbLast(  ::oDbfIva, 2 )

   REDEFINE CHECKBOX ::lAllIva ;
      ID       500 ;
      OF       ::oFld:aDialogs[1]

   REDEFINE GET oIvaDes VAR ::cIvaDes ;
      ID       130 ;
      WHEN     ( !::lAllIva );
      VALID    ( cTiva( oIvaDes, oThis:cAlias, oIvaDesTxt ) );
      BITMAP   "LUPA" ;
      ON HELP  ( BrwIva( oIvaDes, oThis:cAlias, oIvaDesTxt ) ) ;
      OF       ::oFld:aDialogs[1]

   REDEFINE GET oIvaDesTxt VAR cIvaDesTxt ;
      WHEN     .f. ;
      ID       131 ;
      OF       ::oFld:aDialogs[1]

   REDEFINE GET oIvaHas VAR ::cIvaHas ;
      ID       140 ;
      WHEN     ( !::lAllIva );
      VALID    ( cTiva( oIvaHas, oThis:cAlias, oIvaHasTxt ) );
      BITMAP   "LUPA" ;
      ON HELP  ( BrwIva( oIvaHas, oThis:cAlias, oIvaHasTxt ) ) ;
      OF       ::oFld:aDialogs[1]

   REDEFINE GET oIvaHasTxt VAR cIvaHasTxt ;
      WHEN     .f. ;
      ID       141 ;
      OF       ::oFld:aDialogs[1]

   ::CreateFilter( , ::oDbf, .t. )

RETURN .t.

//---------------------------------------------------------------------------//
/*Generamos el informe*/

METHOD lGenerate()

   local n
   local cCodIva
   local aTotDoc
   local aTotBas
   local aTotImp
   local cExpHead := ""

   /*Desabilita el diálogo y vacía la dbf temporal*/

   ::oDlg:Disable()
   ::oBtnCancel:Enable()
   ::oDbf:Zap()

   /*Monta la cabecera del documento*/

   ::aHeader      := {  {|| "Fecha    : " + Dtoc( Date() ) },;
                        {|| "Periodo  : " + Dtoc( ::dIniInf ) + " > " + Dtoc( ::dFinInf ) },;
                        {|| "Tipo     : " + cImp() + " : " + if( ::lAllIva, "Todos",  alltrim( ::cIvaDes ) + " > " + alltrim( ::cIvaHas ) ) } }


   /*Albaranes de clientes*/

   ::oAlbCliT:OrdSetFocus( "dFecAlb" )

   cExpHead          := 'nFacturado < 3 .and. dFecAlb >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecAlb <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'

   ::oAlbCliT:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oAlbCliT:cFile ), ::oAlbCliT:OrdKey(), ( cExpHead ), , , , , , , , .t. )

   ::oMtrInf:SetTotal( ::oAlbCliT:OrdKeyCount() )

   /*Recorremos las cabeceras de las facturas*/

   ::oAlbCliT:GoTop()

   while !::lBreak .and. !::oAlbCliT:Eof()

      if lChkSer( ::oAlbCliT:cSerAlb, ::aSer )

         aTotDoc  := aTotAlbCli( ::oAlbCliT:cSerAlb + Str( ::oAlbCliT:nNumAlb ) + ::oAlbCliT:cSufAlb, ::oAlbCliT:cAlias, ::oAlbCliL:cAlias, ::oDbfIva:cAlias, ::oDbfDiv:cAlias )[ 8 ]

         for n := 1 to len( aTotDoc )

            if aTotDoc[ n, 3 ] != nil

               cCodIva           := cCodigoIva( ::oDbfIva:cAlias, aTotDoc[ n, 3 ] )

               if ( ::lAllIva .or. ( cCodIva >= ::cIvaDes .and. cCodIva <= ::cIvaHas ) )

                  ::oDbf:Append()

                  ::oDbf:dFecMov := ::oAlbCliT:dFecAlb

                  ::oDbf:cDocMov := alltrim( ::oAlbCliT:cSerAlb ) + "/" + alltrim( Str( ::oAlbCliT:nNumAlb ) ) + "/" + alltrim( ::oAlbCliT:cSufAlb )

                  ::oDbf:cSerDoc := ::oAlbCliT:cSerAlb
                  ::oDbf:nNumDoc := ::oAlbCliT:nNumAlb
                  ::oDbf:cSufDoc := ::oAlbCliT:cSufAlb 

                  ::oDbf:cCodCli := ::oAlbCliT:cCodCli
                  ::oDbf:cNomCli := ::oAlbCliT:cNomCli
                  ::oDbf:cTipIva := cCodIva
                  ::oDbf:cNomIva := oRetFld( cCodIva, ::oDbfIva )
                  ::oDbf:nPctIva := aTotDoc[ n, 3 ]
                  ::oDbf:nTotNet := aTotDoc[ n, 2 ]
                  ::oDbf:nTotIva := aTotDoc[ n, 8 ]
                  ::oDbf:nTotReq := aTotDoc[ n, 9 ]
                  ::oDbf:nTotDoc := ::oDbf:nTotNet + ::oDbf:nTotIva + ::oDbf:nTotReq
                  ::oDbf:cTipDoc := "Albarán"

                  ::oDbf:Save()

               end if

            end if

         next

      end if

      ::oAlbCliT:Skip()

      ::oMtrInf:AutoInc()

   end while

   /*Destruimos los filtros creados anteriormente*/

   ::oAlbCliT:IdxDelete( cCurUsr(), GetFileNoExt( ::oAlbCliT:cFile ) )

   /*Facturas de clientes*/

   ::oFacCliT:OrdSetFocus( "dFecFac" )

   cExpHead          := 'dFecFac >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecFac <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'

   ::oFacCliT:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oFacCliT:cFile ), ::oFacCliT:OrdKey(), ( cExpHead ), , , , , , , , .t. )

   ::oMtrInf:SetTotal( ::oFacCliT:OrdKeyCount() )

   /*Recorremos las cabeceras de las facturas*/

  ::oFacCliT:GoTop()

   while !::lBreak .and. !::oFacCliT:Eof()

      if lChkSer( ::oFacCliT:cSerie, ::aSer )

         aTotDoc  := aTotFacCli( ::oFacCliT:cSerie + Str( ::oFacCliT:nNumFac ) + ::oFacCliT:cSufFac, ::oFacCliT:cAlias, ::oFacCliL:cAlias, ::oDbfIva:cAlias, ::oDbfDiv:cAlias, ::oFacCliP:cAlias, ::oAntCliT:cAlias )[ 8 ]

         for n := 1 to len( aTotDoc )

            if aTotDoc[ n, 3 ] != nil

               cCodIva           := cCodigoIva( ::oDbfIva:cAlias, aTotDoc[ n, 3 ] )

               if ( ::lAllIva .or. ( cCodIva >= ::cIvaDes .and. cCodIva <= ::cIvaHas ) )

                  ::oDbf:Append()

                  ::oDbf:dFecMov := ::oFacCliT:dFecFac
                  ::oDbf:cDocMov := alltrim( ::oFacCliT:cSerie ) + "/" + alltrim( Str( ::oFacCliT:nNumFac ) ) + "/" + alltrim( ::oFacCliT:cSufFac )

                  ::oDbf:cSerDoc := ::oFacCliT:cSerie
                  ::oDbf:nNumDoc := ::oFacCliT:nNumFac
                  ::oDbf:cSufDoc := ::oFacCliT:cSufFac 

                  ::oDbf:cCodCli := ::oFacCliT:cCodCli
                  ::oDbf:cNomCli := ::oFacCliT:cNomCli
                  ::oDbf:cTipIva := cCodIva
                  ::oDbf:cNomIva := oRetFld( cCodIva, ::oDbfIva )
                  ::oDbf:nPctIva := aTotDoc[ n, 3 ]
                  ::oDbf:nTotNet := aTotDoc[ n, 2 ]
                  ::oDbf:nTotIva := aTotDoc[ n, 8 ]
                  ::oDbf:nTotReq := aTotDoc[ n, 9 ]
                  ::oDbf:nTotDoc := ::oDbf:nTotNet + ::oDbf:nTotIva + ::oDbf:nTotReq
                  ::oDbf:cTipDoc := "Factura"

                  ::oDbf:Save()

               end if

            end if

         next

      end if

      ::oFacCliT:Skip()

      ::oMtrInf:AutoInc()

   end while

   /*Destruimos los filtros creados anteriormente*/

   ::oFacCliT:IdxDelete( cCurUsr(), GetFileNoExt( ::oFacCliT:cFile ) )

   /*Facturas de clientes rectificativas*/

   ::oFacRecT:OrdSetFocus( "dFecFac" )

   cExpHead          := 'dFecFac >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecFac <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'

   ::oFacRecT:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oFacRecT:cFile ), ::oFacRecT:OrdKey(), ( cExpHead ), , , , , , , , .t. )

   ::oMtrInf:SetTotal( ::oFacRecT:OrdKeyCount() )

   /*Recorremos las cabeceras de las facturas*/

   ::oFacRecT:GoTop()

   while !::lBreak .and. !::oFacRecT:Eof()

      if lChkSer( ::oFacRecT:cSerie, ::aSer )

         aTotDoc  := aTotFacRec( ::oFacRecT:cSerie + Str( ::oFacRecT:nNumFac ) + ::oFacRecT:cSufFac, ::oFacRecT:cAlias, ::oFacRecL:cAlias, ::oDbfIva:cAlias, ::oDbfDiv:cAlias )[ 8 ]

         for n := 1 to len( aTotDoc )

            if aTotDoc[ n, 3 ] != nil

               cCodIva           := cCodigoIva( ::oDbfIva:cAlias, aTotDoc[ n, 3 ] )

               if ( ::lAllIva .or. ( cCodIva >= ::cIvaDes .and. cCodIva <= ::cIvaHas ) )

                  ::oDbf:Append()

                  ::oDbf:dFecMov := ::oFacRecT:dFecFac
                  ::oDbf:cDocMov := alltrim( ::oFacRecT:cSerie ) + "/" + alltrim( Str( ::oFacRecT:nNumFac ) ) + "/" + alltrim( ::oFacRecT:cSufFac )

                  ::oDbf:cSerDoc := ::oFacRecT:cSerie
                  ::oDbf:nNumDoc := ::oFacRecT:nNumFac
                  ::oDbf:cSufDoc := ::oFacRecT:cSufFac 

                  ::oDbf:cCodCli := ::oFacRecT:cCodCli
                  ::oDbf:cNomCli := ::oFacRecT:cNomCli
                  ::oDbf:cTipIva := cCodIva
                  ::oDbf:cNomIva := oRetFld( cCodIva, ::oDbfIva )
                  ::oDbf:nPctIva := aTotDoc[ n, 3 ]
                  ::oDbf:nTotNet := aTotDoc[ n, 2 ]
                  ::oDbf:nTotIva := aTotDoc[ n, 8 ]
                  ::oDbf:nTotReq := aTotDoc[ n, 9 ]
                  ::oDbf:nTotDoc := ::oDbf:nTotNet + ::oDbf:nTotIva + ::oDbf:nTotReq
                  ::oDbf:cTipDoc := "Rectificativa"

                  ::oDbf:Save()

               end if

            end if

         next

      end if

      ::oFacRecT:Skip()

      ::oMtrInf:AutoInc()

   end while

   /*Destruimos los filtros creados anteriormente*/

   ::oFacRecT:IdxDelete( cCurUsr(), GetFileNoExt( ::oFacRecT:cFile ) )

   /*Tickets de clientes*/

   ::oTikCliT:OrdSetFocus( "dFecTik" )

   cExpHead       := 'dFecTik >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecTik <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'

   cExpHead       += ' .and. ( cTipTik == "1" .or. cTipTik == "4" )'

   ::oTikCliT:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oTikCliT:cFile ), ::oTikCliT:OrdKey(), ( cExpHead ), , , , , , , , .t. )

   ::oMtrInf:SetTotal( ::oTikCliT:OrdKeyCount() )

   /*Recorremos las cabeceras de los tickets*/

   ::oTikCliT:GoTop()

   while !::lBreak .and. !::oTikCliT:Eof()

      if lChkSer( ::oTikCliT:cSerTik, ::aSer )

         aTotDoc  := aTotTik( ::oTikCliT:cSerTik + ::oTikCliT:cNumTik + ::oTikCliT:cSufTik, ::oTikCliT:cAlias, ::oTikCliL:cAlias, ::oDbfDiv:cAlias )[ 5 ]
         aTotBas  := aTotTik( ::oTikCliT:cSerTik + ::oTikCliT:cNumTik + ::oTikCliT:cSufTik, ::oTikCliT:cAlias, ::oTikCliL:cAlias, ::oDbfDiv:cAlias )[ 6 ]
         aTotImp  := aTotTik( ::oTikCliT:cSerTik + ::oTikCliT:cNumTik + ::oTikCliT:cSufTik, ::oTikCliT:cAlias, ::oTikCliL:cAlias, ::oDbfDiv:cAlias )[ 7 ]

         for n := 1 to len( aTotDoc )

         if !Empty( aTotDoc[n] )

            cCodIva  := cCodigoIva( ::oDbfIva:cAlias, aTotDoc[ n ] )

               if ( ::lAllIva .or. ( cCodIva >= ::cIvaDes .and. cCodIva <= ::cIvaHas ) )

                     ::oDbf:Append()

                     ::oDbf:dFecMov := ::oTikCliT:dFecTik
                     ::oDbf:cDocMov := alltrim( ::oTikCliT:cSerTik ) + "/" + alltrim( ::oTikCliT:cNumTik ) + "/" + alltrim( ::oTikCliT:cSufTik )

                     ::oDbf:cSerDoc := ::oTikCliT:cSerTik
                     ::oDbf:nNumDoc := val( ::oTikCliT:cNumTik )
                     ::oDbf:cSufDoc := ::oTikCliT:cSufTik 

                     ::oDbf:cCodCli := ::oTikCliT:cCliTik
                     ::oDbf:cNomCli := ::oTikCliT:cNomTik
                     ::oDbf:cTipIva := cCodIva
                     ::oDbf:cNomIva := oRetFld( cCodIva, ::oDbfIva )
                     ::oDbf:nPctIva := aTotDoc[ n ]
                     ::oDbf:nTotNet := aTotBas[ n ]
                     ::oDbf:nTotIva := aTotImp[ n ]
                     ::oDbf:nTotDoc := ::oDbf:nTotNet + ::oDbf:nTotIva
                     ::oDbf:cTipDoc := "Ticket"

                     ::oDbf:Save()

               end if

            end if

         next

      end if

      ::oTikCliT:Skip()

      ::oMtrInf:AutoInc()

   end while

   /*Destruimos los filtros creados anteriormente*/

   ::oTikCliT:IdxDelete( cCurUsr(), GetFileNoExt( ::oTikCliT:cFile ) )

   /*
   Ponemos el filtro en la tabla temporal--------------------------------------
   */

   if !Empty( ::oFilter:cExpresionFilter )
      cExpHead       := ::oFilter:cExpresionFilter 
   else
      cExpHead       := ".t."   
   end if

   ::oDbf:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oDbf:cFile ), ::oDbf:OrdKey(), ( cExpHead ), , , , , , , , .t. )

   ::oMtrInf:AutoInc( ::oTikCliT:Lastrec() )

   ::oDlg:Enable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//