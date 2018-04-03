#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS TInfChgCBr FROM TInfGen

   DATA  oDbfBar   AS OBJECT

   METHOD create()

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHOD lResource( cFld )

   METHOD lGenerate()

END CLASS

//---------------------------------------------------------------------------//

METHOD Create()

   ::AddField( "cCodArt",  "C", 18, 0, {|| "@!" },        'Código artículo',                 .f., 'Cod. artículo'            , 15, .f. )
   ::AddField( "cNomArt",  "C",100, 0, {|| "@!" },        'Descripción',               .f., 'Descripción'              , 50, .f. )
   ::AddField( "cCodBar",  "C", 20, 0, {|| "@!" },        'Código de barras',          .t., 'Código de barras'         , 25, .f. )
   ::AddField( "cTipBar",  "C", 40, 0, {|| "@!" },        'Tipo de código de barras',  .t., 'Tipo de código de barras' , 40, .f. )
   ::AddField( "cDefecto", "C", 10, 0, {|| "@!" },        'Defecto',                   .t., 'Defecto'                  , 10, .f. )
   ::AddField( "LastChg",  "D",  8, 0, {|| "@!" },        'Cambio',                    .f., 'Fecha de cambio'          , 10, .f. )

   ::AddTmpIndex( "CCODART", "CCODART + CCODBAR" )

   ::AddGroup( {|| ::oDbf:cCodArt }, {|| "Artículo  : " + Rtrim( ::oDbf:cCodArt ) + "-" + Rtrim( ::oDbf:cNomArt ) }, {||""} )

   ::dIniInf      := GetSysDate()
   ::lDefSerInf   := .f.
   ::lDefDivInf   := .f.

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD OpenFiles()

   local lOpen    := .t.
   local oBlock   := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

      DATABASE NEW ::oDbfBar PATH ( cPatEmp() ) FILE "ARTCODEBAR.DBF" VIA ( cDriver() ) SHARED INDEX "ARTCODEBAR.CDX"

   RECOVER

      msgStop( 'Imposible abrir todas las bases de datos' )
      ::CloseFiles()
      lOpen       := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD CloseFiles()

   if !Empty( ::oDbfBar ) .and. ::oDbfBar:Used()
      ::oDbfBar:End()
   end if

   ::oDbfBar      := nil

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD lResource ( cFld )

   if !::StdResource( "INFCHGBAR" )
      return .f.
   end if

   if !::lDefArtInf( 110, 120, 130, 140, 600 )
      return .f.
   end if

   /*
   Damos valor al meter
   */

   ::oMtrInf:SetTotal( ::oDbfArt:Lastrec() )

   ::CreateFilter( aItmArt(), ::oDbfArt:cAlias )

RETURN .t.

//---------------------------------------------------------------------------//
/*
Esta funcion crea la base de datos para generar posteriormente el informe
*/

METHOD lGenerate()

   local cExpHead := ""

   ::oDlg:Disable()
   ::oDbf:Zap()

   ::aHeader      := {  {|| 'Fecha     : ' + Dtoc( Date() ) },;
                        {|| 'Periodo   : ' + Dtoc( ::dIniInf ) + ' > ' + Dtoc( ::dFinInf ) },;
                        {|| 'Artículos : ' + if( ::lAllArt, "Todos", AllTrim( ::cArtOrg ) + ' > ' + AllTrim( ::cArtDes ) ) } }

   cExpHead       := 'LastChg >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. LastChg <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'

   if !::lAllArt
      cExpHead    += ' .and. Codigo >= "' + Rtrim( ::cArtOrg ) + '" .and. Codigo <= "' + Rtrim( ::cArtDes ) + '"'
   end if

   if !Empty( ::oFilter:cExpresionFilter )
      cExpHead    := ' .and. ' + ::oFilter:cExpresionFilter
   end if

   ::oDbfArt:AddTmpIndex( Auth():Codigo(), GetFileNoExt( ::oDbfArt:cFile ), ::oDbfArt:OrdKey(), ( cExpHead ), , , , , , , , .t. )

   ::oMtrInf:SetTotal( ::oDbfArt:OrdKeyCount() )

   ::oDbfArt:OrdSetFocus( "Codigo" )

   ::oDbfArt:GoTop()

   while !::oDbfArt:Eof()

      if ::oDbfBar:SeekInOrd( ::oDbfArt:Codigo, "cCodArt" )

         while ::oDbfBar:cCodArt == ::oDbfArt:Codigo .and. !::oDbfBar:Eof()

            ::oDbf:Append()

            ::oDbf:LastChg          := ::oDbfArt:LastChg
            ::oDbf:cCodArt          := ::oDbfArt:Codigo
            ::oDbf:cNomArt          := ::oDbfArt:Nombre
            ::oDbf:cCodBar          := ::oDbfBar:cCodBar

            if ::oDbfBar:lDefBar
               ::oDbf:cDefecto      := "Si"
            else
               ::oDbf:cDefecto      := ""
            end if

            do case
               case ::oDbfBar:nTipBar == 1
                  ::oDbf:cTipBar    := "Ean13"
               case ::oDbfBar:nTipBar == 2
                  ::oDbf:cTipBar    := "Code39"
               case ::oDbfBar:nTipBar == 3
                  ::oDbf:cTipBar    := "Code128"
            end case

            ::oDbf:Save()

            ::oDbfBar:Skip()

         end while

      end if

      ::oDbfArt:Skip()

      ::oMtrInf:AutoInc( ::oDbfArt:OrdKeyNo() )

   end while

   ::oDbfArt:IdxDelete( Auth():Codigo(), GetFileNoExt( ::oDbfArt:cFile ) )

   ::oMtrInf:AutoInc( ::oDbfArt:Lastrec() )

   ::oDlg:Enable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//