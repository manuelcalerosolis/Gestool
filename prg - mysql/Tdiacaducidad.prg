#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS TDiaCaducidad FROM TNewInfGen

   DATA oAlbPrvL     AS OBJECT
   DATA oFacPrvL     AS OBJECT
   DATA oAlbCliL     AS OBJECT
   DATA oFacCliL     AS OBJECT
   DATA oFacRecL     AS OBJECT
   DATA oTikCliL     AS OBJECT
   DATA aArticulos   AS ARRAY INIT {}
   DATA nPos         AS NUMERIC INIT 0

   METHOD Create()

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHOD lResource( cFld )

   METHOD lGenerate()

   METHOD AddAlbaranesproveedor( cCodArt )

   METHOD AddFacturasproveedor( cCodArt )

   METHOD AddAlbaranesClientes( cCodArt )

   METHOD AddFacturasClientes( cCodArt )

   METHOD AddTicketsClientes( cCodArt )

   METHOD AddFacturasRectificativas( cCodArt )

END CLASS

//---------------------------------------------------------------------------//

METHOD Create()

   ::AddField( "cCodArt",     "C", 18, 0,  {|| "@!" },        "Código artículo",   .f., "Código artículo",        14, .f. )
   ::AddField( "cNomArt",     "C",100, 0,  {|| "@!" },        "Nom. art.",   .f., "Nombre artículo",        14, .f. )
   ::AddField( "cCodTip",     "C",  4, 0,  {|| "@!" },        "Cod. tip.",   .f., "Código tipo artículo",   14, .f. )
   ::AddField( "cNomTip",     "C", 35, 0,  {|| "@!" },        "Nom. tip.",   .f., "Nombre tipo artículo",   14, .f. )
   ::AddField( "cCodFam",     "C", 16, 0,  {|| "@!" },        "Cod. fam.",   .f., "Código familia",         14, .f. )
   ::AddField( "cNomFam",     "C", 40, 0,  {|| "@!" },        "Nom. fam.",   .f., "Nombre familia",         14, .f. )
   ::AddField( "cCodCat",     "C",  3, 0,  {|| "@!" },        "Cod. cat.",   .f., "Código categoria",       14, .f. )
   ::AddField( "cNomCat",     "C", 50, 0,  {|| "@!" },        "Nom. cat.",   .f., "Nombre categoria",       14, .f. )
   ::AddField( "dFecCad",     "D",  8, 0,  {|| "@!" },        "Caducidad",   .t., "Fecha de caducidad",     14, .f. )
   ::AddField( "cLote",       "C", 14, 0,  {|| "@!" },        "Lote",        .t., "Lote del producto",      20, .f. )
   ::AddField( "nUnidades",   "N", 16, 6,  {|| MasUnd() },    "Unidades",    .t., "Unidades actuales",      20, .f. )
   ::AddField( "nCompras",    "N", 16, 6,  {|| MasUnd() },    "Compras",     .f., "Unidades compradas",     20, .f. )
   ::AddField( "nVentas",     "N", 16, 6,  {|| MasUnd() },    "Ventas",      .f., "Unidades vendidas",      20, .f. )

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD OpenFiles() CLASS TDiaCaducidad

   local lOpen    := .t.
   local oBlock   := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

   DATABASE NEW ::oAlbPrvL  PATH ( cPatEmp() ) FILE "ALBPROVL.DBF" VIA ( cDriver() ) SHARED INDEX "ALBPROVL.CDX"
   ::oAlbPrvL:OrdSetFocus( "cStkFast" )

   DATABASE NEW ::oFacPrvL  PATH ( cPatEmp() ) FILE "FACPRVL.DBF"  VIA ( cDriver() ) SHARED INDEX "FACPRVL.CDX"
   ::oAlbPrvL:OrdSetFocus( "cRef" )

   DATABASE NEW ::oAlbCliL  PATH ( cPatEmp() ) FILE "ALBCLIL.DBF"  VIA ( cDriver() ) SHARED INDEX "ALBCLIL.CDX"
   ::oAlbPrvL:OrdSetFocus( "cStkFast" )

   DATABASE NEW ::oFacCliL  PATH ( cPatEmp() ) FILE "FACCLIL.DBF"  VIA ( cDriver() ) SHARED INDEX "FACCLIL.CDX"
   ::oAlbPrvL:OrdSetFocus( "cRef" )

   DATABASE NEW ::oFacRecL  PATH ( cPatEmp() ) FILE "FACRECL.DBF"  VIA ( cDriver() ) SHARED INDEX "FACRECL.CDX"
   ::oAlbPrvL:OrdSetFocus( "cRef" )

   DATABASE NEW ::oTikCliL  PATH ( cPatEmp() ) FILE "TIKEL.DBF"    VIA ( cDriver() ) SHARED INDEX "TIKEL.CDX"
   ::oAlbPrvL:OrdSetFocus( "CCBATIL" )

   RECOVER

      msgStop( 'Imposible abrir todas las bases de datos' )
      ::CloseFiles()
      lOpen          := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD CloseFiles() CLASS TDiaCaducidad

   if !Empty( ::oAlbPrvL ) .and. ::oAlbPrvL:Used()
      ::oAlbPrvL:End()
   end if
      if !Empty( ::oFacPrvL ) .and. ::oFacPrvL:Used()
      ::oFacPrvL:End()
   end if
   if !Empty( ::oAlbCliL ) .and. ::oAlbCliL:Used()
      ::oAlbCliL:End()
   end if
   if !Empty( ::oFacCliL ) .and. ::oFacCliL:Used()
      ::oFacCliL:End()
   end if
   if !Empty( ::oFacRecL ) .and. ::oFacRecL:Used()
      ::oFacRecL:End()
   end if
   if !Empty( ::oTikCliL ) .and. ::oTikCliL:Used()
      ::oTikCliL:End()
   end if

   ::oAlbPrvL := nil
   ::oFacPrvL := nil
   ::oAlbCliL := nil
   ::oFacCliL := nil
   ::oFacRecL := nil
   ::oTikCliL := nil

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD lResource( cFld ) CLASS TDiaCaducidad

   ::lNewInforme  := .t.

   /*
   Campo de la temporal por el que tiene que ordenar si no hay agrupamientos---
   */

   ::cEmptyIndex  := "cCodArt"

   if !::NewResource()
      return .f.
   end if

   if !::lGrupoFamilia( .f. )
      return .f.
   end if

   if !::lGrupoTipoArticulo( .f. )
      return .f.
   end if

   if !::lGrupoCategoria( .f. )
      return .f.
   end if

   if !::lGrupoArticulo( .t. )
      return .f.
   end if

   ::lDefCondiciones := .f.

   ::oMtrInf:SetTotal( ::oDbfArt:Lastrec() )

   ::CreateFilter( aItmArt(), ::oDbfArt:cAlias )

RETURN .t.

//---------------------------------------------------------------------------//

METHOD lGenerate() CLASS TDiaCaducidad

   local cExpArt     := ""
   local aArticulo

   ::aArticulos      := {}

   ::oDlg:Disable()
   ::oBtnCancel:Enable()
   ::oDbf:Zap()

   /*
   Cabeceras del documento-----------------------------------------------------
   */

   ::aHeader      := {  {|| Padr( "Fecha", 13 ) + ": " + Dtoc( Date() ) },;
                        {|| Padr( "Periodo", 13 ) + ": " + Dtoc( ::dIniInf ) + " > " + Dtoc( ::dFinInf ) } }

   if !::oGrupoFamilia:Cargo:Todos
      aAdd( ::aHeader, {|| Padr( "Familia", 13 ) + ": " + AllTrim( ::oGrupoFamilia:Cargo:Desde ) + " > " + AllTrim( ::oGrupoFamilia:Cargo:Hasta ) } )
   end if

   if !::oGrupoTArticulo:Cargo:Todos
      aAdd( ::aHeader, {|| Padr( "Tipo artículo", 13 ) + ": " + AllTrim( ::oGrupoTArticulo:Cargo:Desde ) + " > " + AllTrim( ::oGrupoTArticulo:Cargo:Hasta ) } )
   end if

   if !::oGrupoCategoria:Cargo:Todos
      aAdd( ::aHeader, {|| Padr( "Categorias", 13 ) + ": " + AllTrim( ::oGrupoCategoria:Cargo:Desde ) + " > " + AllTrim( ::oGrupoCategoria:Cargo:Hasta ) } )
   end if

   if !::oGrupoArticulo:Cargo:Todos
      aAdd( ::aHeader, {|| Padr( "Artículo", 13 ) + ": " + AllTrim( ::oGrupoArticulo:Cargo:Desde ) + " > " + AllTrim( ::oGrupoArticulo:Cargo:Hasta ) } )
   end if

   /*
   Le creamos los filtros a la tabla-------------------------------------------
   */

   ::oDbfArt:OrdSetFocus( "Codigo" )

   if !::oGrupoArticulo:Cargo:Todos
      cExpArt     := 'Codigo >= "' + ::oGrupoArticulo:Cargo:Desde + '" .and. Codigo <= "' + ::oGrupoArticulo:Cargo:Hasta + '"'
   else
      cExpArt     := '.t.'
   end if

   if !::oGrupoFamilia:Cargo:Todos
      cExpArt     += ' .and. Familia >= "' + ::oGrupoFamilia:Cargo:Desde + '" .and. Familia <= "' + ::oGrupoFamilia:Cargo:Hasta + '"'
   end if

   if !::oGrupoTArticulo:Cargo:Todos
      cExpArt     += ' .and. cCodTip >= "' + ::oGrupoTArticulo:Cargo:Desde + '" .and. cCodTip <= "' + ::oGrupoTArticulo:Cargo:Hasta + '"'
   end if

   if !::oGrupoCategoria:Cargo:Todos
      cExpArt     += ' .and. cCodCate >= "' + ::oGrupoCategoria:Cargo:Desde + '" .and. cCodCate <= "' + ::oGrupoCategoria:Cargo:Hasta + '"'
   end if

   if !Empty( ::oFilter:cExpresionFilter )
      cExpArt     += ' .and. ' + ::oFilter:cExpresionFilter
   end if

   ::oDbfArt:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oDbfArt:cFile ), ::oDbfArt:OrdKey(), ( cExpArt ), , , , , , , , .t. )

   /*
   Cargamos los valores en un array--------------------------------------------
   */

   ::AddAlbaranesproveedor()
   ::AddFacturasproveedor()
   ::AddAlbaranesClientes()
   ::AddTicketsClientes()
   ::AddFacturasRectificativas()

   /*
   Recorremos la tabla de artículos para ir metirndo los valores en la temporal
   */

   ::oMtrInf:SetTotal( ::oDbfArt:OrdKeyCount() )

   ::oDbfArt:GoTop()

   while !::lBreak .and. !::oDbfArt:Eof()

      for each aArticulo in ::aArticulos

         if aArticulo[1] == ::oDbfArt:Codigo .and. aArticulo[ 4 ] > 0

            ::oDbf:Append()

            ::oDbf:cCodArt   := ::oDbfArt:Codigo
            ::oDbf:cNomArt   := ::oDbfArt:Nombre
            ::oDbf:cCodTip   := ::oDbfArt:cCodTip
            ::oDbf:cNomTip   := oRetFld( ::oDbfArt:cCodTip, ::oTipArt:oDbf )
            ::oDbf:cCodFam   := ::oDbfArt:Familia
            ::oDbf:cNomFam   := oRetFld( ::oDbfArt:Familia, ::oDbfFam )
            ::oDbf:cCodCat   := ::oDbfArt:cCodCate
            ::oDbf:cNomCat   := oRetFld( ::oDbfArt:cCodCate, ::oDbfCat )
            ::oDbf:cLote     := aArticulo[ 2 ]
            ::oDbf:dFecCad   := aArticulo[ 3 ]
            ::oDbf:nUnidades := aArticulo[ 4 ]
            ::oDbf:nCompras  := aArticulo[ 5 ]
            ::oDbf:nVentas   := aArticulo[ 6 ]

            ::oDbf:Save()

         end if

      next

      ::oDbfArt:Skip()

      ::oMtrInf:AutoInc( ::oDbfArt:OrdKeyNo() )

   end while

   ::oDbfArt:IdxDelete( cCurUsr(), GetFileNoExt( ::oDbfArt:cFile ) )

   ::oMtrInf:AutoInc( ::oDbfArt:Lastrec() )

   ::oDlg:Enable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//

METHOD AddAlbaranesProveedor()

   ::oMtrInf:SetTotal( ::oAlbPrvL:OrdKeyCount() )

   ::oAlbPrvL:GoTop()

   while !::oAlbPrvL:Eof()

      if ::oAlbPrvL:dFecCad >= ::dIniInf .and. ::oAlbPrvL:dFecCad <= ::dFinInf

         if ( ::nPos := aScan( ::aArticulos, {|a| a[1] == ::oAlbPrvL:cRef .and. a[2] == ::oAlbPrvL:cLote } ) ) != 0
            ::aArticulos[ ::nPos, 4 ] += nTotNAlbPrv( ::oAlbPrvL )
            ::aArticulos[ ::nPos, 5 ] += nTotNAlbPrv( ::oAlbPrvL )
         else
            aAdd( ::aArticulos, { ::oAlbPrvL:cRef, ::oAlbPrvL:cLote, ::oAlbPrvL:dFecCad, nTotNAlbPrv( ::oAlbPrvL ), nTotNAlbPrv( ::oAlbPrvL ), 0 } )
         end if

      end if

      ::oAlbPrvL:Skip()

      ::oMtrInf:AutoInc( ::oAlbPrvL:OrdKeyNo() )

   end while

   ::oMtrInf:AutoInc( ::oAlbPrvL:Lastrec() )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD AddFacturasproveedor()

   ::oMtrInf:SetTotal( ::oFacPrvL:OrdKeyCount() )

   ::oFacPrvL:GoTop()

   while !::oFacPrvL:Eof()

      if ::oFacPrvL:dFecCad >= ::dIniInf .and. ::oFacPrvL:dFecCad <= ::dFinInf

         if ( ::nPos := aScan( ::aArticulos, {|a| a[1] == ::oFacPrvL:cRef .and. a[2] == ::oFacPrvL:cLote } ) ) != 0
            ::aArticulos[ ::nPos, 4 ] += nTotNFacPrv( ::oFacPrvL )
            ::aArticulos[ ::nPos, 5 ] += nTotNFacPrv( ::oFacPrvL )
         else
            aAdd( ::aArticulos, { ::oFacPrvL:cRef, ::oFacPrvL:cLote, ::oFacPrvL:dFecCad, nTotNFacPrv( ::oFacPrvL ), nTotNFacPrv( ::oFacPrvL ), 0 } )
         end if

      end if

      ::oFacPrvL:Skip()

      ::oMtrInf:AutoInc( ::oFacPrvL:OrdKeyNo() )

   end while

   ::oMtrInf:AutoInc( ::oFacPrvL:Lastrec() )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD AddAlbaranesClientes()

   ::oMtrInf:SetTotal( ::oAlbCliL:OrdKeyCount() )

   ::oAlbCliL:GoTop()

   while !::oAlbCliL:Eof()

      if ( ::nPos := aScan( ::aArticulos, {|a| a[1] == ::oAlbCliL:cRef .and. a[2] == ::oAlbCliL:cLote } ) ) != 0
         ::aArticulos[ ::nPos, 4 ] -= nTotNAlbCli( ::oAlbCliL )
         ::aArticulos[ ::nPos, 6 ] += nTotNAlbCli( ::oAlbCliL )
      end if

      ::oAlbCliL:Skip()

      ::oMtrInf:AutoInc( ::oAlbCliL:OrdKeyNo() )

   end while

   ::oMtrInf:AutoInc( ::oAlbCliL:Lastrec() )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD AddFacturasClientes()

   ::oMtrInf:SetTotal( ::oFacCliL:OrdKeyCount() )

   ::oFacCliL:GoTop()

   while !::oFacCliL:Eof()

      if ( ::nPos := aScan( ::aArticulos, {|a| a[1] == ::oFacCliL:cRef .and. a[2] == ::oFacCliL:cLote } ) ) != 0
         ::aArticulos[ ::nPos, 4 ] -= nTotNFacCli( ::oFacCliL )
         ::aArticulos[ ::nPos, 6 ] += nTotNFacCli( ::oFacCliL )
      end if

      ::oFacCliL:Skip()

      ::oMtrInf:AutoInc( ::oFacCliL:OrdKeyNo() )

   end while

   ::oMtrInf:AutoInc( ::oFacCliL:Lastrec() )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD AddTicketsClientes()

   ::oMtrInf:SetTotal( ::oTikCliL:OrdKeyCount() )

   ::oTikCliL:GoTop()

   while !::oTikCliL:Eof()

      if ( ::nPos := aScan( ::aArticulos, {|a| a[1] == ::oTikCliL:cCbaTil .and. a[2] == ::oTikCliL:cLote } ) ) != 0
         ::aArticulos[ ::nPos, 4 ] -= ::oTikCliL:nUntTil
         ::aArticulos[ ::nPos, 6 ] += ::oTikCliL:nUntTil
      end if

      ::oTikCliL:Skip()

      ::oMtrInf:AutoInc( ::oTikCliL:OrdKeyNo() )

   end while

   ::oMtrInf:AutoInc( ::oTikCliL:Lastrec() )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD AddFacturasRectificativas()

   ::oMtrInf:SetTotal( ::oFacRecL:OrdKeyCount() )

   ::oFacRecL:GoTop()

   while !::oFacRecL:Eof()

      if ( ::nPos := aScan( ::aArticulos, {|a| a[1] == ::oFacRecL:cRef .and. a[2] == ::oFacRecL:cLote } ) ) != 0
         ::aArticulos[ ::nPos, 4 ] -= nTotNFacRec( ::oFacRecL )
         ::aArticulos[ ::nPos, 6 ] += nTotNFacRec( ::oFacRecL )
      end if

      ::oFacRecL:Skip()

      ::oMtrInf:AutoInc( ::oFacRecL:OrdKeyNo() )

   end while

   ::oMtrInf:AutoInc( ::oFacRecL:Lastrec() )

RETURN ( nil )

//---------------------------------------------------------------------------//