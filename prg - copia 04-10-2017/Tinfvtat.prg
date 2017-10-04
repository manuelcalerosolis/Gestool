#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS TInfVtaT FROM TInfGen

   DATA  lResumen    AS LOGIC    INIT .f.
   DATA  lExcCero    AS LOGIC    INIT .f.
   DATA  oAlbCliT    AS OBJECT
   DATA  oAlbCliL    AS OBJECT
   DATA  oFacCliT    AS OBJECT
   DATA  oFacCliL    AS OBJECT
   DATA  oFacRecT    AS OBJECT
   DATA  oFacRecL    AS OBJECT
   DATA  oTikCliT    AS OBJECT
   DATA  oTikCliL    AS OBJECT
    

   METHOD create()

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHOD lResource( cFld )

   METHOD lGenerate()

END CLASS

//---------------------------------------------------------------------------//

METHOD Create()

   ::AddField( "cNumDoc",   "C", 14, 0, {|| "@!" },        "Doc",            .f., "Documento",            8, .f. )
   ::AddField( "dFecDoc",   "D",  8, 0, {|| "@!" },        "Fecha",          .f., "Fecha del documento", 10, .f. )
   ::AddField( "cCodCli",   "C", 12, 0, {|| "@!" },        "Cliente",        .f., "Cod. cliente",         8, .f. )
   ::AddField( "cNomCli",   "C", 50, 0, {|| "@!" },        "Nombre",         .f., "Nom. cliente",         8, .f. )
   ::AddField( "cCodObr",   "C", 12, 0, {|| "@!" },        "Dirección",           .f., "Cod. dirección",            8, .f. )
   ::AddField( "cEstado",   "C", 12, 0, {|| "@!" },        "Estado",         .f., "Estado del doc.",     10, .f. )
   ::AddField( "cCodArt",   "C", 18, 0, {|| "@!" },        "Cod.",           .t., "Cod. artículo",       10, .f. )
   ::AddField( "cNomArt",   "C",100, 0, {|| "@!" },        "Artículo",       .t., "Nom. artículo",       40, .f. )
   ::FldPropiedades()
   ::AddField( "nCajas",    "N", 16, 6, {|| ::cPicOut },   cNombreCajas(),   .f., cNombreCajas(),        12, .f. )
   ::AddField( "nUnidades", "N", 16, 6, {|| ::cPicOut },   cNombreUnidades(),.f., cNombreUnidades(),     12, .f. )
   ::AddField( "nUniCaj",   "N", 16, 6, {|| ::cPicOut },   "Tot. " + cNombreUnidades(),      .t., "Total " + cNombreUnidades(), 12, .f. )
   ::AddField( "nPreArt",   "N", 16, 6, {|| ::cPicOut },   "Precio",         .t., "Precio artículo",     12, .f. )
   ::AddField( "nBase",     "N", 16, 6, {|| ::cPicOut },   "Base",           .t., "Base",                12, .t. )
   ::AddField( "nIva",      "N", 16, 6, {|| ::cPicOut },   cImp(),            .t., cImp(),                 12, .t. )
   ::AddField( "nTotal",    "N", 16, 6, {|| ::cPicOut },   "Total",          .t., "Total",               12, .t. )

   ::AddTmpIndex( "cNumDoc", "cNumDoc" )

   ::AddGroup( {|| ::oDbf:cNumDoc }, {|| "Documento: " + Rtrim( ::oDbf:cNumDoc )+ " - " + Dtoc( ::oDbf:dFecDoc ) + " Cliente:" + Rtrim( ::oDbf:cCodCli ) + "-" + Rtrim( ::oDbf:cNomCli ) + if( !Empty( ::oDbf:cCodObr), " Obra:" + Rtrim( ::oDbf:cCodObr ) , " " ) + " T:" + RTrim( ::oDbf:cEstado ) }, {|| Space(1) } )

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD OpenFiles()

   local lOpen    := .t.
   local oBlock   := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

   ::oAlbCliT := TDataCenter():oAlbCliT()

   DATABASE NEW ::oAlbCliL PATH ( cPatEmp() ) FILE "ALBCLIL.DBF" VIA ( cDriver() ) SHARED INDEX "ALBCLIL.CDX"

   ::oFacCliT := TDataCenter():oFacCliT()

   DATABASE NEW ::oFacCliL PATH ( cPatEmp() ) FILE "FACCLIL.DBF" VIA ( cDriver() ) SHARED INDEX "FACCLIL.CDX"

   DATABASE NEW ::oFacRecT PATH ( cPatEmp() ) FILE "FACRECT.DBF" VIA ( cDriver() ) SHARED INDEX "FACRECT.CDX"

   DATABASE NEW ::oFacRecL PATH ( cPatEmp() ) FILE "FACRECL.DBF" VIA ( cDriver() ) SHARED INDEX "FACRECL.CDX"

   DATABASE NEW ::oTikCliT PATH ( cPatEmp() ) FILE "TIKET.DBF" VIA ( cDriver() ) SHARED INDEX "TIKET.CDX"

   DATABASE NEW ::oTikCliL PATH ( cPatEmp() ) FILE "TIKEL.DBF" VIA ( cDriver() ) SHARED INDEX "TIKEL.CDX"

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
   if !Empty( ::oTikCliT ) .and. ::oTikCliT:Used()
      ::oTikCliT:End()
   end if
   if !Empty( ::oTikCliL ) .and. ::oTikCliL:Used()
      ::oTikCliL:End()
   end if

   ::oAlbCliT := nil
   ::oAlbCliL := nil
   ::oFacRecT := nil
   ::oFacRecL := nil
   ::oTikCliT := nil
   ::oTikCliL := nil

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD lResource ( cFld )

   if !::StdResource( "INFTIKET" )
      return .f.
   end if

   ::CreateFilter( , ::oDbf, .t. )

   /*
   Monta los almacenes de manera automatica
   */

   if !::oDefCliInf( 70, 71, 80, 81, , 910 )
      return .f.
   end if

RETURN .t.

//---------------------------------------------------------------------------//
/*
Esta funcion crea la base de datos para generar posteriormente el informe
*/

METHOD lGenerate()

   local cExpHead  := ""

   ::oDlg:Disable()
   ::oBtnCancel:Enable()
   ::oDbf:Zap()

   /*
   Creamos la cabcera del listado
   */

   ::aHeader      := {  {|| "Fecha    : " + Dtoc( Date() ) },;
                        {|| "Periodo  : " + Dtoc( ::dIniInf ) + " > " + Dtoc( ::dFinInf ) },;
                        {|| "Clientes : " + if( ::lAllCli, "Todos", AllTrim( ::cCliOrg ) + " > " + AllTrim( ::cCliDes ) ) } }

   ::oAlbCliT:OrdSetFocus( "dFecAlb" )

   cExpHead          := 'nFacturado < 3 .and. dFecAlb >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecAlb <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'

   if !::lAllCli
      cExpHead       += ' .and. cCodCli >= "' + Rtrim( ::cCliOrg ) + '" .and. cCodCli <= "' + Rtrim( ::cCliDes ) + '"'
   end if

   if !Empty( ::oFilter:cExpresionFilter ) 
      cExpHead       += ' .and. ' + ::oFilter:cExpresionFilter
   end if

   ::oAlbCliT:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oAlbCliT:cFile ), ::oAlbCliT:OrdKey(), ( cExpHead ), , , , , , , , .t. )

   ::oMtrInf:SetTotal( ::oAlbCliT:OrdKeyCount() )
   ::oMtrInf:cText   := "Albaranes"

   ::oAlbCliT:GoTop()

   while !::lBreak .and. !::oAlbCliT:Eof()

      if lChkSer( ::oAlbCliT:cSerAlb, ::aSer )

         if ::oAlbCliL:Seek( ::oAlbCliT:cSerAlb + Str( ::oAlbCliT:nNumAlb ) + ::oAlbCliT:cSufAlb ) .and.;
            !( ::oAlbCliL:lTotLin ) .and. !( ::oAlbCliL:lControl )

            while ::oAlbCliT:cSerAlb + Str( ::oAlbCliT:nNumAlb ) + ::oAlbCliT:cSufAlb == ::oAlbCliL:cSerAlb + Str( ::oAlbCliL:nNumAlb ) + ::oAlbCliL:cSufAlb .AND. ! ::oAlbCliL:eof()

               ::oDbf:Append()

               ::oDbf:cNumDoc     := AllTrim( ::oAlbCliT:cSerAlb ) + "/" + AllTrim( Str( ::oAlbCliT:nNumAlb ) ) + "/" + AllTrim( ::oAlbCliT:cSufAlb )
               ::oDbf:dFecDoc     := ::oAlbCliT:dFecAlb
               ::oDbf:cCodCli     := ::oAlbCliT:cCodCli
               ::oDbf:cNomCli     := ::oAlbCliT:cNomCli
               ::oDbf:cCodObr     := ::oAlbCliT:cCodObr
               ::oDbf:cEstado     := "Albarán"
               ::oDbf:cCodArt     := ::oAlbCliL:cRef
               ::oDbf:cNomArt     := ::oAlbCliL:cDetalle
               ::oDbf:cCodPr1     := ::oAlbCliL:cCodPr1
               ::oDbf:cNomPr1     := retProp( ::oAlbCliL:cCodPr1 )
               ::oDbf:cCodPr2     := ::oAlbCliL:cCodPr2
               ::oDbf:cNomPr2     := retProp( ::oAlbCliL:cCodPr2 )
               ::oDbf:cValPr1     := ::oAlbCliL:cValPr1
               ::oDbf:cNomVl1     := retValProp( ::oAlbCliL:cCodPr1 + ::oAlbCliL:cValPr1 )
               ::oDbf:cValPr2     := ::oAlbCliL:cValPr2
               ::oDbf:cNomVl2     := retValProp( ::oAlbCliL:cCodPr2 + ::oAlbCliL:cValPr2 )
               ::oDbf:nCajas      := ::oAlbCliL:nCanEnt
               ::oDbf:nUnidades   := ::oAlbCliL:nUniCaja
               ::oDbf:nUniCaj     := nTotNAlbCli( ::oAlbCliL )
               ::oDbf:nPreArt     := nTotUAlbCli( ::oAlbCliL:cAlias, ::nDecOut, ::nValDiv )
               ::oDbf:nBase       := nImpLAlbCli( ::oAlbCliT:cAlias, ::oAlbCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv, , , .t., .t.  )
               ::oDbf:nIva        := nIvaLAlbCli( ::oAlbCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
               ::oDbf:nTotal      := ::oDbf:nBase + ::oDbf:nIva

               ::oDbf:Save()

               ::oAlbCliL:Skip()

            end while

         end if

      end if

      ::oAlbCliT:Skip()

      ::oMtrInf:AutoInc()

   end while

   ::oAlbCliT:IdxDelete( cCurUsr(), GetFileNoExt( ::oAlbCliT:cFile ) )

   ::oFacCliT:OrdSetFocus( "dFecFac" )

   cExpHead          := 'dFecFac >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecFac <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'

   if !::lAllCli
      cExpHead       += ' .and. cCodCli >= "' + Rtrim( ::cCliOrg ) + '" .and. cCodCli <= "' + Rtrim( ::cCliDes ) + '"'
   end if

   if !Empty( ::oFilter:cExpresionFilter )
      cExpHead       += ' .and. ' + ::oFilter:cExpresionFilter
   end if

   ::oFacCliT:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oFacCliT:cFile ), ::oFacCliT:OrdKey(), ( cExpHead ), , , , , , , , .t. )

   ::oMtrInf:SetTotal( ::oFacCliT:OrdKeyCount() )
   ::oMtrInf:cText   := "Facturas"

   ::oFacCliT:GoTop()

   while !::lBreak .and. !::oFacCliT:Eof()

      if lChkSer( ::oFacCliT:cSerie, ::aSer )

         if ::oFacCliL:Seek( ::oFacCliT:cSerie + Str( ::oFacCliT:nNumFac ) + ::oFacCliT:cSufFac )  .and.;
            !( ::oFacCliL:lTotLin ) .and. !( ::oFacCliL:lControl )

            while ::oFacCliT:cSerie + Str( ::oFacCliT:nNumFac ) + ::oFacCliT:cSufFac == ::oFacCliL:cSerie + Str( ::oFacCliL:nNumFac ) + ::oFacCliL:cSufFac .AND. ! ::oFacCliL:eof()

               ::oDbf:Append()

               ::oDbf:cNumDoc     := AllTrim( ::oFacCliT:cSerie ) + "/" + AllTrim( Str( ::oFacCliT:nNumFac ) ) + "/" + AllTrim( ::oFacCliT:cSufFac )
               ::oDbf:dFecDoc     := ::oFacCliT:dFecFac
               ::oDbf:cCodCli     := ::oFacCliT:cCodCli
               ::oDbf:cNomCli     := ::oFacCliT:cNomCli
               ::oDbf:cCodObr     := ::oFacCliT:cCodObr
               ::oDbf:cEstado     := "Factura"
               ::oDbf:cCodArt     := ::oFacCliL:cRef
               ::oDbf:cNomArt     := ::oFacCliL:cDetalle
               ::oDbf:cCodPr1     := ::oFacCliL:cCodPr1
               ::oDbf:cNomPr1     := retProp( ::oFacCliL:cCodPr1 )
               ::oDbf:cCodPr2     := ::oFacCliL:cCodPr2
               ::oDbf:cNomPr2     := retProp( ::oFacCliL:cCodPr2 )
               ::oDbf:cValPr1     := ::oFacCliL:cValPr1
               ::oDbf:cNomVl1     := retValProp( ::oFacCliL:cCodPr1 + ::oFacCliL:cValPr1 )
               ::oDbf:cValPr2     := ::oFacCliL:cValPr2
               ::oDbf:cNomVl2     := retValProp( ::oFacCliL:cCodPr2 + ::oFacCliL:cValPr2 )
               ::oDbf:nCajas      := ::oFacCliL:nCanEnt
               ::oDbf:nUnidades   := ::oFacCliL:nUniCaja
               ::oDbf:nUniCaj     := nTotNFacCli( ::oFacCliL )
               ::oDbf:nPreArt     := nTotUFacCli( ::oFacCliL:cAlias, ::nDecOut, ::nValDiv )
               ::oDbf:nBase       := nImpLFacCli( ::oFacCliT:cAlias, ::oFacCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv, , , .t., .t.  )
               ::oDbf:nIva        := nIvaLFacCli( ::oFacCliL:cAlias, ::nDecOut, ::nValDiv )
               ::oDbf:nTotal      := ::oDbf:nBase + ::oDbf:nIva

               ::oDbf:Save()

               ::oFacCliL:Skip()

            end while

         end if

      end if

      ::oFacCliT:Skip()

      ::oMtrInf:AutoInc()

   end while

   ::oFacCliT:IdxDelete( cCurUsr(), GetFileNoExt( ::oFacCliT:cFile ) )

   ::oFacRecT:OrdSetFocus( "dFecFac" )

   cExpHead          := 'dFecFac >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecFac <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'

   if !::lAllCli
      cExpHead       += ' .and. cCodCli >= "' + Rtrim( ::cCliOrg ) + '" .and. cCodCli <= "' + Rtrim( ::cCliDes ) + '"'
   end if

   if !Empty( ::oFilter:cExpresionFilter )
      cExpHead       += ' .and. ' + ::oFilter:cExpresionFilter 
   end if

   ::oFacRecT:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oFacRecT:cFile ), ::oFacRecT:OrdKey(), ( cExpHead ), , , , , , , , .t. )

   ::oMtrInf:SetTotal( ::oFacRecT:OrdKeyCount() )
   ::oMtrInf:cText   := "Fac. rec."

   ::oFacRecT:GoTop()

   while !::lBreak .and. !::oFacRecT:Eof()

      if lChkSer( ::oFacRecT:cSerie, ::aSer )

         if ::oFacRecL:Seek( ::oFacRecT:cSerie + Str( ::oFacRecT:nNumFac ) + ::oFacRecT:cSufFac )  .and.;
            !( ::oFacRecL:lTotLin ) .and. !( ::oFacRecL:lControl )

            while ::oFacRecT:cSerie + Str( ::oFacRecT:nNumFac ) + ::oFacRecT:cSufFac == ::oFacRecL:cSerie + Str( ::oFacRecL:nNumFac ) + ::oFacRecL:cSufFac .AND. !::oFacRecL:eof()

               ::oDbf:Append()

               ::oDbf:cNumDoc     := AllTrim( ::oFacRecT:cSerie ) + "/" + AllTrim( Str( ::oFacRecT:nNumFac ) ) + "/" + AllTrim( ::oFacRecT:cSufFac )
               ::oDbf:dFecDoc     := ::oFacRecT:dFecFac
               ::oDbf:cCodCli     := ::oFacRecT:cCodCli
               ::oDbf:cNomCli     := ::oFacRecT:cNomCli
               ::oDbf:cCodObr     := ::oFacRecT:cCodObr
               ::oDbf:cEstado     := "Fac. rec."
               ::oDbf:cCodArt     := ::oFacRecL:cRef
               ::oDbf:cNomArt     := ::oFacRecL:cDetalle
               ::oDbf:cCodPr1     := ::oFacRecL:cCodPr1
               ::oDbf:cNomPr1     := retProp( ::oFacRecL:cCodPr1 )
               ::oDbf:cCodPr2     := ::oFacRecL:cCodPr2
               ::oDbf:cNomPr2     := retProp( ::oFacRecL:cCodPr2 )
               ::oDbf:cValPr1     := ::oFacRecL:cValPr1
               ::oDbf:cNomVl1     := retValProp( ::oFacRecL:cCodPr1 + ::oFacRecL:cValPr1 )
               ::oDbf:cValPr2     := ::oFacRecL:cValPr2
               ::oDbf:cNomVl2     := retValProp( ::oFacRecL:cCodPr2 + ::oFacRecL:cValPr2 )
               ::oDbf:nCajas      := -( ::oFacRecL:nCanEnt )
               ::oDbf:nUnidades   := -( ::oFacRecL:nUniCaja )
               ::oDbf:nUniCaj     := -( nTotNFacRec( ::oFacRecL ) )
               ::oDbf:nPreArt     := nTotUFacRec( ::oFacRecL:cAlias, ::nDecOut, ::nValDiv )
               ::oDbf:nBase       := -( nImpLFacRec( ::oFacRecT:cAlias, ::oFacRecL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv, , , .t., .t.  ) )
               ::oDbf:nIva        := -( nIvaLFacRec( ::oFacRecL:cAlias, ::nDecOut, ::nValDiv ) )
               ::oDbf:nTotal      := ::oDbf:nBase + ::oDbf:nIva

               ::oDbf:Save()

               ::oFacRecL:Skip()

            end while

         end if

      end if

      ::oFacRecT:Skip()

      ::oMtrInf:AutoInc()

   end while

   ::oFacRecT:IdxDelete( cCurUsr(), GetFileNoExt( ::oFacRecT:cFile ) )

   ::oTikCliT:OrdSetFocus( "dFecTik" )

   cExpHead          := 'dFecTik >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecTik <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'

   if !::lAllCli
      cExpHead       += ' .and. cCliTik >= "' + Rtrim( ::cCliOrg ) + '" .and. cCliTik <= "' + Rtrim( ::cCliDes ) + '"'
   end if

   ::oTikCliT:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oTikCliT:cFile ), ::oTikCliT:OrdKey(), ( cExpHead ), , , , , , , , .t. )

   ::oMtrInf:SetTotal( ::oTikCliT:OrdKeyCount() )
   ::oMtrInf:cText   := "Tikets"

   ::oTikCliT:GoTop()

   while !::lBreak .and. !::oTikCliT:Eof()

      if lChkSer( ::oTikCliT:cSerTik, ::aSer )

         if ::oTikCliL:Seek( ::oTikCliT:cSerTik + ::oTikCliT:cNumTik + ::oTikCliT:cSufTik ) .and.;
            !( ::oTikCliL:lControl )

            while ::oTikCliT:cSerTik + ::oTikCliT:cNumTik + ::oTikCliT:cSufTik == ::oTikCliL:cSerTil + ::oTikCliL:cNumTil + ::oTikCliL:cSufTil .AND. ! ::oTikCliL:eof()

               ::oDbf:Append()

               ::oDbf:cNumDoc        := AllTrim( ::oTikCliT:cSerTik ) + "/" + AllTrim( ::oTikCliT:cNumTik ) + "/" + AllTrim( ::oTikCliT:cSufTik )
               ::oDbf:dFecDoc        := ::oTikCliT:dFecTik
               ::oDbf:cCodCli        := ::oTikCliT:cCliTik
               ::oDbf:cNomCli        := ::oTikCliT:cNomTik
               ::oDbf:cCodObr        := ::oTikCliT:cCodObr
               if !Empty( ::oTikCliL:cCbaTil )
                  ::oDbf:cCodArt     := ::oTikCliL:cCbaTil
                  ::oDbf:cNomArt     := RetArticulo( ::oTikCliL:cCbaTil, ::oDbfArt )
                  ::oDbf:nPreArt     := nImpUTpv( ::oTikCliT, ::oTikCliL, ::nDecOut, ::nValDiv, nil, 1 )
                  ::oDbf:nBase       := nImpLTpv( ::oTikCliT, ::oTikCliL, ::nDecOut, ::nDerOut, ::nValDiv, nil, 1 )
                  ::oDbf:nIva        := nIvaLTpv( ::oTikCliT, ::oTikCliL, ::nDecOut, ::nDerOut, ::nValDiv, 1 )
               else
                  ::oDbf:cCodArt     := ::oTikCliL:cComTil
                  ::oDbf:cNomArt     := RetArticulo( ::oTikCliL:cComTil, ::oDbfArt )
                  ::oDbf:nPreArt     := nImpUTpv( ::oTikCliT, ::oTikCliL, ::nDecOut, ::nValDiv, nil, 2 )
                  ::oDbf:nBase       := nImpLTpv( ::oTikCliT, ::oTikCliL, ::nDecOut, ::nDerOut, ::nValDiv, nil, 2 )
                  ::oDbf:nIva        := nIvaLTpv( ::oTikCliT, ::oTikCliL, ::nDecOut, ::nDerOut, ::nValDiv, 2 )
               end if

                  ::oDbf:cCodPr1     := ::oTikCliL:cCodPr1
                  ::oDbf:cNomPr1     := retProp( ::oTikCliL:cCodPr1 )
                  ::oDbf:cCodPr2     := ::oTikCliL:cCodPr2
                  ::oDbf:cNomPr2     := retProp( ::oTikCliL:cCodPr2 )
                  ::oDbf:cValPr1     := ::oTikCliL:cValPr1
                  ::oDbf:cNomVl1     := retValProp( ::oTikCliL:cCodPr1 + ::oTikCliL:cValPr1 )
                  ::oDbf:cValPr2     := ::oTikCliL:cValPr2
                  ::oDbf:cNomVl2     := retValProp( ::oTikCliL:cCodPr2 + ::oTikCliL:cValPr2 )

               if ::oTikCliT:cTipTik == "4"
                  ::oDbf:nUniCaj     := - ::oTikCliL:nUntTil
               else
                  ::oDbf:nUniCaj     := ::oTikCliL:nUntTil
               end if

               ::oDbf:cEstado        := "Tiket"
               ::oDbf:nTotal         := ::oDbf:nBase + ::oDbf:nIva

               ::oDbf:Save()

               ::oTikCliL:Skip()

            end while

         end if

      end if

      ::oTikCliT:Skip()

      ::oMtrInf:AutoInc()

   end while

   ::oTikCliT:IdxDelete( cCurUsr(), GetFileNoExt( ::oTikCliT:cFile ) )

   ::oMtrInf:AutoInc( ::oTikCliT:LastRec() )

   ::oDlg:Enable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//