#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"
//---------------------------------------------------------------------------//

CLASS TUndCRVta FROM TInfGen

   DATA  oAlbCliT    AS OBJECT
   DATA  oAlbCliL    AS OBJECT
   DATA  oFacCliT    AS OBJECT
   DATA  oFacCliL    AS OBJECT
   DATA  oFacRecT    AS OBJECT
   DATA  oFacRecL    AS OBJECT
   DATA  oTikCliT    AS OBJECT
   DATA  oTikCliL    AS OBJECT

   METHOD Create()

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHOD lResource( cFld )

   METHOD lGenerate()

END CLASS

//---------------------------------------------------------------------------//
/*Creamos la temporal, los ordenes y los grupos*/

METHOD Create()

   ::AddField( "cCodArt", "C", 18, 0, {|| "@!" },         "Cód. Art.",   .f., "Código artículo",         10, .f. )
   ::AddField( "cNomArt", "C",100, 0, {|| "@!" },         "Artículo",    .f., "Nombre artículo",         30, .f. )
   ::AddField( "cCodCli", "C", 12, 0, {|| "@!" },         "Cód. cli.",   .t., "Código cliente",          10, .f. )
   ::AddField( "cNomCli", "C", 50, 0, {|| "@!" },         "Cliente",     .t., "Nombre cliente",          30, .f. )
   ::AddField( "nUndDoc", "N", 16, 6, {|| MasUnd() },     "Unidades",    .t., "Unidades vendidas",       20, .t. )
   ::AddField( "nRegDoc", "N", 16, 6, {|| MasUnd() },     "Regalo",      .t., "Unidades regaladas",      20, .t. )
   ::AddField( "nPctDto", "N",  6, 2, {|| "@ 99.99" },    "% Dto.",      .t., "Porcentaje de descuento", 15, .f. )

   ::AddTmpIndex( "cCodArt", "cCodArt + cCodCli " )

   ::AddGroup( {|| ::oDbf:cCodArt }, {|| "Artículo : " + Rtrim( ::oDbf:cCodArt ) + "-" + AllTrim( ::oDbf:cNomArt ) }, {||"Total artículo..."} )

RETURN ( self )

//---------------------------------------------------------------------------//
/*Abrimos las tablas necesarias*/

METHOD OpenFiles()

   local lOpen    := .t.
   local oBlock   := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

   ::oAlbCliT := TDataCenter():oAlbCliT()

   DATABASE NEW ::oAlbCliL PATH ( cPatEmp() ) FILE "ALBCLIL.DBF"  VIA ( cDriver() ) SHARED INDEX "ALBCLIL.CDX"

   ::oFacCliT     := TDataCenter():oFacCliT()

   DATABASE NEW ::oFacCliL PATH ( cPatEmp() ) FILE "FACCLIL.DBF"  VIA ( cDriver() ) SHARED INDEX "FACCLIL.CDX"

   DATABASE NEW ::oFacRecT PATH ( cPatEmp() ) FILE "FACRECT.DBF"  VIA ( cDriver() ) SHARED INDEX "FACRECT.CDX"

   DATABASE NEW ::oFacRecL PATH ( cPatEmp() ) FILE "FACRECL.DBF"  VIA ( cDriver() ) SHARED INDEX "FACRECL.CDX"

   DATABASE NEW ::oTikCliT PATH ( cPatEmp() ) FILE "TIKET.DBF"    VIA ( cDriver() ) SHARED INDEX "TIKET.CDX"

   DATABASE NEW ::oTikCliL PATH ( cPatEmp() ) FILE "TIKEL.DBF"    VIA ( cDriver() ) SHARED INDEX "TIKEL.CDX"

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
   if !Empty( ::oTikCliT ) .and. ::oTikCliT:Used()
      ::oTikCliT:End()
   end if
   if !Empty( ::oTikCliL ) .and. ::oTikCliL:Used()
      ::oTikCliL:End()
   end if

   ::oALbCliT := nil
   ::oAlbCliL := nil
   ::oFacCliT := nil
   ::oFacCliL := nil
   ::oFacRecT := nil
   ::oFacRecL := nil
   ::oTikCliT := nil
   ::oTikCliL := nil

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD lResource( cFld )

   if !::StdResource( "INFUNDCLIART" )
      return .f.
   end if

   /*Se montan los desde - hasta*/

   if !::lDefArtInf( 110, 120, 130, 140, 600 )
      return .f.
   end if

   if !::oDefCliInf( 70, 80, 90, 100, , 800 )
      return .f.
   end if

   /*Monta el filtro para el informe*/

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
   local cExpLine := ""

   /*Desabilita el diálogo y vacía la dbf temporal*/

   ::oDlg:Disable()
   ::oBtnCancel:Enable()
   ::oDbf:Zap()

   /*Monta la cabecera del documento*/

   ::aHeader      := {  {|| "Fecha    : " + Dtoc( Date() ) },;
                        {|| "Periodo  : " + Dtoc( ::dIniInf ) + " > " + Dtoc( ::dFinInf ) },;
                        {|| "Artículo : " + if( ::lAllArt, "Todos",  AllTrim( ::cArtOrg ) + " > " + AllTrim( ::cArtDes ) ) },;
                        {|| "Cliente  : " + if( ::lAllCli, "Todos",  AllTrim( ::cCliOrg ) + " > " + AllTrim( ::cCliDes ) ) } }


   /*Albaranes de clientes*/

   ::oAlbCliT:OrdSetFocus( "dFecAlb" )
   ::oAlbCliL:OrdSetFocus( "nNumAlb" )

   cExpHead          := 'nFacturado < 3 .and. dFecAlb >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecAlb <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'

   if !::lAllCli
      cExpHead       += ' .and. cCodCli >= "' + Rtrim( ::cCliOrg ) + '" .and. cCodCli <= "' + Rtrim( ::cCliDes ) + '"'
   end if

   if !Empty( ::oFilter:cExpresionFilter )
      cExpHead       += ' .and. ' + ::oFilter:cExpresionFilter
   end if

   ::oAlbCliT:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oAlbCliT:cFile ), ::oAlbCliT:OrdKey(), ( cExpHead ), , , , , , , , .t. )

   ::oMtrInf:SetTotal( ::oAlbCliT:OrdKeyCount() )

   /*
   Líneas de albaranes
   */

   cExpLine          := '!lTotLin .and. !lControl'

   if !::lAllArt
      cExpLine       += ' .and. cRef >= "' + ::cArtOrg + '" .and. cRef <= "' + ::cArtDes + '"'
   end if

   ::oAlbCliL:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oAlbCliL:cFile ), ::oAlbCliL:OrdKey(), cAllTrimer( cExpLine ), , , , , , , , .t. )

   ::oAlbCliT:GoTop()

   while !::lBreak .and. !::oAlbCliT:Eof()

      if lChkSer( ::oAlbCliT:cSerAlb, ::aSer )  .and.;
         ::oAlbCliL:Seek( ::oAlbCliT:cSerAlb + Str( ::oAlbCliT:nNumAlb ) + ::oAlbCliT:cSufAlb )

         while ::oAlbCliT:cSerAlb + Str( ::oAlbCliT:nNumAlb ) + ::oAlbCliT:cSufAlb == ::oAlbCliL:cSerAlb + Str( ::oAlbCliL:nNumAlb ) + ::oAlbCliL:cSufAlb .and. !::oAlbCliL:Eof()

            if ::oDbf:Seek( ::oAlbCliL:cRef + ::oAlbCLiT:cCodCli )

               ::oDbf:Load()

               if ::oAlbCliL:nDto != 0
                  ::oDbf:nPctDto    := ::oAlbCliL:nDto
               end if

               if nImpLAlbCli( ::oAlbCliT:cAlias, ::oAlbCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv ) == 0
                  ::oDbf:nRegDoc    += nTotNAlbCli( ::oAlbCliL:cAlias )
               else
                  ::oDbf:nUndDoc    += nTotNAlbCli( ::oAlbCliL:cAlias )
               end if

               ::oDbf:Save()

            else

               ::oDbf:Append()

               ::oDbf:cCodArt       := ::oAlbCliL:cRef
               ::oDbf:cNomArt       := Descrip( ::oAlbCliL:cAlias )
               ::oDbf:cCodCli       := ::oAlbCliT:cCodCli
               ::oDbf:cNomCli       := ::oAlbCliT:cNomCli
               ::oDbf:nPctDto       := ::oAlbCliL:nDto

               if nImpLAlbCli( ::oAlbCliT:cAlias, ::oAlbCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv ) == 0
                  ::oDbf:nUndDoc    := 0
                  ::oDbf:nRegDoc    := nTotNAlbCli( ::oAlbCliL:cAlias )
               else
                  ::oDbf:nUndDoc    := nTotNAlbCli( ::oAlbCliL:cAlias )
                  ::oDbf:nRegDoc    := 0
               end if

               ::oDbf:Save()

            end if

            ::oAlbCliL:Skip()

         end while

      end if

      ::oAlbCliT:Skip()

      ::oMtrInf:AutoInc()

   end while

   /*Destruimos los filtros creados anteriormente*/

   ::oAlbCliT:IdxDelete( cCurUsr(), GetFileNoExt( ::oAlbCliT:cFile ) )

   /*Facturas de clientes*/

   ::oFacCliT:OrdSetFocus( "dFecFac" )
   ::oFacCliL:OrdSetFocus( "nNumFac" )

   cExpHead          := 'dFecFac >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecFac <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'

   if !::lAllCli
      cExpHead       += ' .and. cCodCli >= "' + Rtrim( ::cCliOrg ) + '" .and. cCodCli <= "' + Rtrim( ::cCliDes ) + '"'
   end if

   if !Empty( ::oFilter:cExpresionFilter )
      cExpHead       += ' .and. ' + ::oFilter:cExpresionFilter
   end if

   ::oFacCliT:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oFacCliT:cFile ), ::oFacCliT:OrdKey(), ( cExpHead ), , , , , , , , .t. )

   ::oMtrInf:SetTotal( ::oFacCliT:OrdKeyCount() )

   cExpLine          := '!lTotLin .and. !lControl'

   if !::lAllArt
      cExpLine       += ' .and. cRef >= "' + ::cArtOrg + '" .and. cRef <= "' + ::cArtDes + '"'
   end if

   ::oFacCliL:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oFacCliL:cFile ), ::oFacCliL:OrdKey(), cAllTrimer( cExpLine ), , , , , , , , .t. )

   ::oFacCliT:GoTop()

   while !::lBreak .and. !::oFacCliT:Eof()

      if lChkSer( ::oFacCliT:cSerie, ::aSer )  .and.;
         ::oFacCliL:Seek( ::oFacCliT:cSerie + Str( ::oFacCliT:nNumFac ) + ::oFacCliT:cSufFac )

         while ::oFacCliT:cSerie + Str( ::oFacCliT:nNumFac ) + ::oFacCliT:cSufFac == ::oFacCliL:cSerie + Str( ::oFacCliL:nNumFac ) + ::oFacCliL:cSufFac .and. !::oFacCliL:Eof()

            if ::oDbf:Seek( ::oFacCliL:cRef + ::oFacCLiT:cCodCli )

               ::oDbf:Load()

               if ::oFacCliL:nDto != 0
                  ::oDbf:nPctDto    := ::oFacCliL:nDto
               end if

               if nImpLFacCli( ::oFacCliT:cAlias, ::oFacCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv ) == 0
                  ::oDbf:nRegDoc    += nTotNFacCli( ::oFacCliL:cAlias )
               else
                  ::oDbf:nUndDoc    += nTotNFacCli( ::oFacCliL:cAlias )
               end if

               ::oDbf:Save()

            else

               ::oDbf:Append()

               ::oDbf:cCodArt       := ::oFacCliL:cRef
               ::oDbf:cNomArt       := Descrip( ::oFacCliL:cAlias )
               ::oDbf:cCodCli       := ::oFacCliT:cCodCli
               ::oDbf:cNomCli       := ::oFacCliT:cNomCli
               ::oDbf:nPctDto       := ::oFacCliL:nDto

               if nImpLFacCli( ::oFacCliT:cAlias, ::oFacCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv ) == 0
                  ::oDbf:nUndDoc    := 0
                  ::oDbf:nRegDoc    := nTotNFacCli( ::oFacCliL:cAlias )
               else
                  ::oDbf:nUndDoc    := nTotNFacCli( ::oFacCliL:cAlias )
                  ::oDbf:nRegDoc    := 0
               end if

               ::oDbf:Save()

            end if

            ::oFacCliL:Skip()

         end while

      end if

      ::oFacCliT:Skip()

      ::oMtrInf:AutoInc()

   end while

   /*Destruimos los filtros creados anteriormente*/

   ::oFacCliT:IdxDelete( cCurUsr(), GetFileNoExt( ::oFacCliT:cFile ) )

   /*Facturas Rectificativas*/

   ::oFacRecT:OrdSetFocus( "dFecFac" )
   ::oFacRecL:OrdSetFocus( "nNumFac" )

   cExpHead          := 'dFecFac >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecFac <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'

   if !::lAllCli
      cExpHead       += ' .and. cCodCli >= "' + Rtrim( ::cCliOrg ) + '" .and. cCodCli <= "' + Rtrim( ::cCliDes ) + '"'
   end if

   if !Empty( ::oFilter:cExpresionFilter )
      cExpHead       += ' .and. ' + ::oFilter:cExpresionFilter
   end if

   ::oFacRecT:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oFacRecT:cFile ), ::oFacRecT:OrdKey(), ( cExpHead ), , , , , , , , .t. )

   ::oMtrInf:SetTotal( ::oFacRecT:OrdKeyCount() )

   cExpLine          := '!lTotLin .and. !lControl'

   if !::lAllArt
      cExpLine       += ' .and. cRef >= "' + ::cArtOrg + '" .and. cRef <= "' + ::cArtDes + '"'
   end if

   ::oFacRecL:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oFacRecL:cFile ), ::oFacRecL:OrdKey(), cAllTrimer( cExpLine ), , , , , , , , .t. )

   ::oFacRecT:GoTop()

   while !::lBreak .and. !::oFacRecT:Eof()

      if lChkSer( ::oFacRecT:cSerie, ::aSer )  .and.;
         ::oFacRecL:Seek( ::oFacRecT:cSerie + Str( ::oFacRecT:nNumFac ) + ::oFacRecT:cSufFac )

         while ::oFacRecT:cSerie + Str( ::oFacRecT:nNumFac ) + ::oFacRecT:cSufFac == ::oFacRecL:cSerie + Str( ::oFacRecL:nNumFac ) + ::oFacRecL:cSufFac .and. !::oFacRecL:Eof()

            if ::oDbf:Seek( ::oFacRecL:cRef + ::oFacRecT:cCodCli )

               ::oDbf:Load()

               if ::oFacRecL:nDto != 0
                  ::oDbf:nPctDto    := ::oFacRecL:nDto
               end if

               if nImpLFacRec( ::oFacRecT:cAlias, ::oFacRecL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv ) == 0
                  ::oDbf:nRegDoc    += nTotNFacRec( ::oFacRecL:cAlias )
               else
                  ::oDbf:nUndDoc    += nTotNFacRec( ::oFacRecL:cAlias )
               end if

               ::oDbf:Save()

            else

               ::oDbf:Append()

               ::oDbf:cCodArt       := ::oFacRecL:cRef
               ::oDbf:cNomArt       := Descrip( ::oFacRecL:cAlias )
               ::oDbf:cCodCli       := ::oFacRecT:cCodCli
               ::oDbf:cNomCli       := ::oFacRecT:cNomCli
               ::oDbf:nPctDto       := ::oFacRecL:nDto

               if nImpLFacRec( ::oFacRecT:cAlias, ::oFacRecL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv ) == 0
                  ::oDbf:nUndDoc    := 0
                  ::oDbf:nRegDoc    := nTotNFacRec( ::oFacRecL:cAlias )
               else
                  ::oDbf:nUndDoc    := nTotNFacRec( ::oFacRecL:cAlias )
                  ::oDbf:nRegDoc    := 0
               end if

               ::oDbf:Save()

            end if

            ::oFacRecL:Skip()

         end while

      end if

      ::oFacRecT:Skip()

      ::oMtrInf:AutoInc()

   end while

   /*Destruimos los filtros creados anteriormente*/

   ::oFacRecT:IdxDelete( cCurUsr(), GetFileNoExt( ::oFacRecT:cFile ) )

   /*Tickets de clientes*/

   ::oTikCliT:OrdSetFocus( "dFecTik" )
   ::oTikCliL:OrdSetFocus( "cNumTil" )

   cExpHead          := 'dFecTik >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecTik <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'

   if !::lAllCli
      cExpHead       += ' .and. cCliTik >= "' + Rtrim( ::cCliOrg ) + '" .and. cCliTik <= "' + Rtrim( ::cCliDes ) + '"'
   end if

   if !Empty( ::oFilter:cExpresionFilter )
      cExpHead       += ' .and. ' + ::oFilter:cExpresionFilter
   end if

   ::oTikCliT:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oTikCliT:cFile ), ::oTikCliT:OrdKey(), ( cExpHead ), , , , , , , , .t. )

   ::oMtrInf:SetTotal( ::oTikCliT:OrdKeyCount() )

   cExpLine          := '!lControl'

   if ::lAllArt
      cExpLine       += ' .and. !Empty( cCbaTil ) .or. !Empty( cComTil )'
   else
      cExpLine       += ' .and. ( ( !Empty( cCbaTil ) .and. cCbaTil >= "' + ::cArtOrg + '" .and. cCbaTil <= "' + ::cArtDes + '" )'
      cExpLine       += ' .or. '
      cExpLine       += '( !Empty( cComTil ) .and. cComTil >= "' + ::cArtOrg + '" .and. cComTil <= "' + ::cArtDes + '" ) )'
   end if

   ::oTikCliL:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oTikCliL:cFile ), ::oTikCliL:OrdKey(), cAllTrimer( cExpLine ), , , , , , , , .t. )

   ::oTikCliT:GoTop()

   while !::lBreak .and. !::oTikCliT:Eof()

      if lChkSer( ::oTikCliT:cSerTik, ::aSer )  .and.;
         ::oTikCliL:Seek( ::oTikCliT:cSerTik + ::oTikCliT:cNumTik + ::oTikCliT:cSufTik )

         while ::oTikCliT:cSerTik + ::oTikCliT:cNumTik + ::oTikCliT:cSufTik == ::oTikCliL:cSerTil + ::oTikCliL:cNumTil + ::oTikCliL:cSufTil .and. !::oTikCliL:Eof()

            if !Empty( ::oTikCliL:cCbaTil )

               if ::oDbf:Seek( ::oTikCliL:cCbaTil + ::oTikCLiT:cCliTik )

                  ::oDbf:Load()

                  if ::oTikCliL:nDtoLin != 0
                     ::oDbf:nPctDto    := ::oTikCliL:nDtoLin
                  end if

                  if ::oTikCliL:nPvpTil == 0
                     ::oDbf:nRegDoc    += ::oTikCliL:nUntTil
                  else
                     ::oDbf:nUndDoc    += ::oTikCliL:nUntTil
                  end if

                  ::oDbf:Save()

               else

                  ::oDbf:Append()

                  ::oDbf:cCodArt       := ::oTikCliL:cCbaTil
                  ::oDbf:cNomArt       := RetArticulo( ::oTikCliL:cCbaTil, ::oDbfArt )
                  ::oDbf:cCodCli       := ::oTikCliT:cCliTik
                  ::oDbf:cNomCli       := ::oTikCliT:cNomTik
                  ::oDbf:nPctDto       := ::oTikCliL:nDtoLin

                  if ::oTikCliL:nPvpTil == 0
                     ::oDbf:nUndDoc    := 0
                     ::oDbf:nRegDoc    := ::oTikCliL:nUntTil
                  else
                     ::oDbf:nUndDoc    := ::oTikCliL:nUntTil
                     ::oDbf:nRegDoc    := 0
                  end if

                  ::oDbf:Save()

               end if

            end if

            if !Empty( ::oTikCliL:cComTil )

               if ::oDbf:Seek( ::oTikCliL:cComTil + ::oTikCLiT:cCliTik )

                  ::oDbf:Load()

                  if ::oTikCliL:nDtoLin != 0
                     ::oDbf:nPctDto    := ::oTikCliL:nDtoLin
                  end if

                  if ::oTikCliL:nPcmTil == 0
                     ::oDbf:nRegDoc    += ::oTikCliL:nUntTil
                  else
                     ::oDbf:nUndDoc    += ::oTikCliL:nUntTil
                  end if

                  ::oDbf:Save()

               else

                  ::oDbf:Append()

                  ::oDbf:cCodArt       := ::oTikCliL:cComTil
                  ::oDbf:cNomArt       := RetArticulo( ::oTikCliL:cComTil, ::oDbfArt )
                  ::oDbf:cCodCli       := ::oTikCliT:cCliTik
                  ::oDbf:cNomCli       := ::oTikCliT:cNomTik
                  ::oDbf:nPctDto       := ::oTikCliL:nDtoLin

                  if ::oTikCliL:nPcmTil == 0
                     ::oDbf:nUndDoc    := 0
                     ::oDbf:nRegDoc    := ::oTikCliL:nUntTil
                  else
                     ::oDbf:nUndDoc    := ::oTikCliL:nUntTil
                     ::oDbf:nRegDoc    := 0
                  end if

                  ::oDbf:Save()

               end if

            end if

            ::oTikCliL:Skip()

         end while

      end if

      ::oTikCliT:Skip()

      ::oMtrInf:AutoInc()

   end while

   /*Destruimos los filtros creados anteriormente*/

   ::oTikCliT:IdxDelete( cCurUsr(), GetFileNoExt( ::oTikCliT:cFile ) )

   ::oMtrInf:AutoInc( ::oTikCliT:Lastrec() )

   ::oDlg:Enable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//