#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS TInfRemMov FROM TInfGen

   DATA  nRemDes
   DATA  nRemHas
   DATA  cSufDes
   DATA  cSufHas
   DATA  oArtDbf
   DATA  oRemMovL
   DATA  oRemMovT

   METHOD Create()

   METHOD OpenFiles()

   METHOD lResource( cFld )

   METHOD lGenerate()

END CLASS

//---------------------------------------------------------------------------//

METHOD Create()

   ::AddField( "dFecMov", "D",  8, 0, {|| "@!" },      "Fecha",      .t., "Fecha",               8 )
   ::AddField( "cAliMov", "C", 16, 0, {|| "@!" },      "Ent",        .t., "Almacen entrada",    16 )
   ::AddField( "cAloMov", "C", 16, 0, {|| "@!" },      "Sal",        .t., "Almacen salida",     16 )
   ::AddField( "cRefMov", "C", 18, 0, {|| "@!" },      "Código",     .t., "Código",             14 )
   ::AddField( "cNomMov", "C",100, 0, {|| "@!" },      "Artículo",   .t., "Artículo",           40 )
   ::AddField( "cCodMov", "C",  2, 0, {|| "" },        "TM",         .t., "Tipo de movimiento",  2 )
   ::AddField( "cValPr1", "C", 20, 0, {|| "@!" },      "Prp.1",      .f., "Propiedad 1",         4 )
   ::AddField( "cValPr2", "C", 20, 0, {|| "@!" },      "Prp.2",      .f., "Propiedad 2",         4 )
   ::AddField( "cLote",   "C", 14, 0, {|| "@!" },      "Lote",       .f., "Lote",                7 )
   ::AddField( "nCajMov", "N", 19, 6, {|| MasUnd() },  "Caj.",       .f., "Caja",                8, .t. )
   ::AddField( "nUndMov", "N", 19, 6, {|| MasUnd() },  "Und.",       .f., "Unidades",            8, .t. )
   ::AddField( "nTotMov", "N", 19, 6, {|| MasUnd() },  "Tot. und.",  .t., "Total unidades",      8, .t. )
   ::AddField( "nPreDiv", "N", 19, 6, {|| ::cPicOut},  "Importe",    .t., "Importe",             8, .t. )
   ::AddField( "nTotImp", "N", 19, 6, {|| ::cPicOut},  "Tot. imp.",  .t., "Total importe",       8, .t. )
   ::AddField( "nNumRem", "N",  9, 0, {|| "" },        "Número",     .f., "Número",              9 )
   ::AddField( "cSufRem", "C",  2, 0, {|| "" },        "Sufijo",     .f., "Sufijo",              2 )

   ::AddTmpIndex( "cNumRem", "Str( nNumRem ) + cSufRem" )

   ::AddGroup( {|| Str( ::oDbf:nNumRem ) + ::oDbf:cSufRem }, {|| "Remesa : " + AllTrim( Str( ::oDbf:nNumRem ) ) + "/" + AllTrim( ::oDbf:cSufRem ) }, {|| "Total remesa..." } )

   ::oRemMovT  := ::xOthers[ 1 ]
   ::oRemMovL  := ::xOthers[ 2 ]
   ::oArtDbf   := ::xOthers[ 3 ]

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD OpenFiles()

   DATABASE NEW ::oDbfDiv PATH ( cPatDat() ) FILE "DIVISAS.DBF" VIA ( cDriver() ) SHARED INDEX "DIVISAS.CDX"

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD lResource( cFld )

   ::nRemDes      := ::oRemMovT:nNumRem
   ::nRemHas      := ::oRemMovT:nNumRem
   ::cSufDes      := ::oRemMovT:cSufRem
   ::cSufHas      := ::oRemMovT:cSufRem

   ::lDefFecInf   := .f.
   ::lDefDivInf   := .f.
   ::lDefSerInf   := .f.

   if !::StdResource( "INF_GENORDCAR" )
      return .f.
   end if

   ::lLoadDivisa()

   /*
	Llamada a la funcion que activa la caja de dialogo
	*/

   REDEFINE GET ::nRemDes ;
      PICTURE  "999999999" ;
      ID       100 ;
      SPINNER ;
      OF       ::oFld:aDialogs[1]

   REDEFINE GET ::cSufDes ;
      ID       110 ;
      OF       ::oFld:aDialogs[1]

   REDEFINE GET ::nRemHas ;
      PICTURE  "999999999" ;
      ID       120 ;
      SPINNER ;
      OF       ::oFld:aDialogs[1]

   REDEFINE GET ::cSufHas ;
      ID       130 ;
      OF       ::oFld:aDialogs[1]

   ::CreateFilter(  , ::oRemMovT )

RETURN .t.

//---------------------------------------------------------------------------//
/*
Esta funcion crea la base de datos para generar posteriormente el informe
*/

METHOD lGenerate()

   local cExpHead := ""

   ::oDlg:Disable()
   ::oDbf:Zap()

   ::oRemMovT:GetStatus()

   ::aHeader      := {  {|| "Fecha  : " + Dtoc( Date() ) },;
                        {|| "Rango  : " + AllTrim( Str( ::nRemDes ) ) + "/" + AllTrim( ::cSufDes ) + " > " + AllTrim( Str( ::nRemHas ) ) + "/" + AllTrim( ::cSufHas ) } }

   ::oRemMovT:OrdSetFocus( "CNUMREM" )

   if !Empty( ::oFilter:cExpresionFilter )
      cExpHead       := ::oFilter:cExpresionFilter
   else
      cExpHead       := '.t.'
   end if

   ::oRemMovT:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oRemMovT:cFile ), ::oRemMovT:OrdKey(), ( cExpHead ), , , , , , , , .t. )

   if ::oRemMovT:Seek( Str( ::nRemDes ) + ::cSufDes )

      while Str( ::oRemMovT:nNumRem ) + ::oRemMovT:cSufRem <= Str( ::nRemHas ) + ::cSufHas .and. !::oRemMovT:eof()

         /*
         Posicionamos en las lineas de detalle --------------------------------
         */

         if ::oRemMovL:Seek( Str( ::oRemMovT:nNumRem ) + ::oRemMovT:cSufRem )

            while Str( ::oRemMovT:nNumRem ) + ::oRemMovT:cSufRem == Str( ::oRemMovL:nNumRem ) + ::oRemMovL:cSufRem .and. !::oRemMovL:Eof()

               if ::oDbf:Append()
                  ::oDbf:Blank()

                  ::oDbf:dFecMov    := ::oRemMovL:dFecMov
                  ::oDbf:cAliMov    := ::oRemMovL:cAliMov
                  ::oDbf:cAloMov    := ::oRemMovL:cAloMov
                  ::oDbf:cRefMov    := ::oRemMovL:cRefMov
                  ::oDbf:cNomMov    := retArticulo( ::oRemMovL:cRefMov, ::oArtDbf:nArea )
                  ::oDbf:cCodMov    := ::oRemMovL:cCodMov
                  ::oDbf:cValPr1    := ::oRemMovL:cValPr1
                  ::oDbf:cValPr2    := ::oRemMovL:cValPr2
                  ::oDbf:cLote      := ::oRemMovL:cLote
                  ::oDbf:nCajMov    := ::oRemMovL:nCajMov
                  ::oDbf:nUndMov    := ::oRemMovL:nUndMov
                  ::oDbf:nTotMov    := nTotNMovAlm( ::oRemMovL )
                  ::oDbf:nTotImp    := nTotLMovAlm( ::oRemMovL )
                  ::oDbf:nPreDiv    := ::oRemMovL:nPreDiv
                  ::oDbf:nNumRem    := ::oRemMovL:nNumRem
                  ::oDbf:cSufRem    := ::oRemMovL:cSufRem

                  ::oDbf:Save()
               end if

               ::oRemMovL:Skip()

            end while

         end if

         ::oRemMovT:Skip()

      end while

   end if

   ::oRemMovT:IdxDelete( cCurUsr(), GetFileNoExt( ::oRemMovT:cFile ) )

   ::oRemMovT:SetStatus()

   ::oDlg:Enable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//