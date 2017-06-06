#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS TdlAgeAlb FROM TInfGen

   DATA  lResumen    AS LOGIC    INIT .f.
   DATA  lTvta       AS LOGIC    INIT .f.
   DATA  oEstado     AS OBJECT
   DATA  oAlbCliT    AS OBJECT
   DATA  oAlbCliL    AS OBJECT
   DATA  cTipVen
   DATA  cTipVen2
   DATA  aEstado     AS ARRAY    INIT  { "No Facturado", "Facturado", "Todos" }

   METHOD Create()

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHOD lResource( cFld )

   METHOD lGenerate()

END CLASS

//---------------------------------------------------------------------------//

METHOD Create()

   ::AddField( "cCodAge", "C",  3, 0,  {|| "@!" },         "Cod. age.",                 .f., "Código agente",               3 )
   ::AddField( "cNomAge", "C", 50, 0,  {|| "@!" },         "Agente",                    .f., "Agente",                     25 )
   ::AddField( "cRefArt", "C", 18, 0,  {|| "@!" },         "Código artículo",                 .t., "Código artículo",            10 )
   ::AddField( "cDesArt", "C", 50, 0,  {|| "@!" },         "Artículo",                  .t., "Artículo",                   25 )
   ::FldCliente()
   ::AddField( "cDocMov", "C", 14, 0,  {|| "@!" },         "N/Albarán",                 .f., "Nuestro albarán",            14 )
   ::AddField( "cCsuAlb", "C", 12, 0,  {|| "@!" },         "S/Albarán",                 .t., "Su albarán Nº",              12 )
   ::AddField( "dFecMov", "D",  8, 0,  {|| "@!" },         "Fecha",                     .t., "Fecha",                       8 )
   ::AddField( "nUndCaj", "N", 13, 6,  {|| MasUnd() },     "Caj.",                      .t., "Cajas",                       8 )
   ::AddField( "nUndArt", "N", 13, 6,  {|| MasUnd() },     "Und.",                      .t., "Unidades",                    8 )
   ::AddField( "nCajUnd", "N", 13, 6,  {|| MasUnd() },     "Tot. und.",                 .f., "Total unidades",             10 )
   ::AddField( "nBasCom", "N", 13, 6,  {|| ::cPicOut },    "Base",                      .t., "Base comisión",              10 )
   ::AddField( "nComAge", "N",  4, 1,  {|| ::cPicOut },    "%Com",                      .t., "Porcentaje de comisión",     10 )
   ::AddField( "nTotCom", "N", 13, 6,  {|| ::cPicOut },    "Comisión",                  .t., "Comisión",                   10 )
   ::AddField( "cTipVen", "C", 20, 0,  {|| "@!" },         "Venta",                     .f., "Tipo de venta",              20 )

   ::AddTmpIndex( "cCodAge", "cCodAge" )

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD OpenFiles() CLASS TdlAgeAlb

   local lOpen    := .t.
   local oBlock   := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

   ::oAlbCliT := TDataCenter():oAlbCliT()

   DATABASE NEW ::oAlbCliL  PATH ( cPatEmp() ) FILE "ALBCLIL.DBF" VIA ( cDriver() ) SHARED INDEX "ALBCLIL.CDX"

   DATABASE NEW ::oDbfCli   PATH ( cPatCli() ) FILE "CLIENT.DBF"  VIA ( cDriver() ) SHARED INDEX "CLIENT.CDX"

   RECOVER

      msgStop( 'Imposible abrir todas las bases de datos' )
      ::CloseFiles()
      lOpen          := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD CloseFiles() CLASS TdlAgeAlb

   if !Empty( ::oAlbCliT ) .and. ::oAlbCliT:Used()
   ::oAlbCliT:End()
   end if
   if !Empty( ::oAlbCliL ) .and. ::oAlbCliL:Used()
   ::oAlbCliL:End()
   end if
   if !Empty( ::oDbfCli ) .and. ::oDbfCli:Used()
   ::oDbfCli:End()
   end if

   ::oAlbCliT := nil
   ::oAlbCliL := nil
   ::oDbfCli  := nil

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD lResource( cFld ) CLASS TdlAgeAlb

   local oTipVen
   local oTipVen2
   local cEstado     := "Todos"
   local This        := Self

   if !::StdResource( "INF_GEN17RA" )
      return .f.
   end if

   /*
   Monta los agentes de manera automatica
   */

   if !::oDefAgeInf( 70, 80, 90, 100, 930 )
      return .f.
   end if

   /*
   Monta los articulos de manera automatica
   */

   if !::lDefArtInf( 110, 120, 130, 140, 800 )
      return .f.
   end if
   
   ::oMtrInf:SetTotal( ::oAlbCliT:Lastrec() )

   ::oDefExcInf( 210 )
   ::oDefExcImp( 211 )

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

METHOD lGenerate() CLASS TdlAgeAlb

   local cExpHead := ""
   local cExpLine := ""

   ::oDlg:Disable()
   ::oBtnCancel:Enable()
   ::oDbf:Zap()


   ::aHeader      := {{|| "Fecha         : "   + Dtoc( Date() ) },;
                     {|| "Periodo       : "   + Dtoc( ::dIniInf ) + " > " + Dtoc( ::dFinInf ) },;
                     {|| "Agentes       : "   + if( ::lAgeAll, "Todos", AllTrim( ::cAgeOrg ) + " > " + AllTrim( ::cAgeDes ) ) },;
                     {|| "Artículos     : "   + if( ::lAllArt, "Todos", AllTrim( ::cArtOrg ) + " > " + AllTrim( ::cArtDes ) ) },;
                     {|| if ( ::lTvta, (if (!Empty( ::cTipVen ), "Tipo de Venta : " + ::cTipVen2, "Tipo de Venta : Todos" ) ), "Tipo de Venta: Ninguno" ) },;
                     {|| "Estado        : " + ::aEstado[ ::oEstado:nAt ] },;
                     {|| if( ::lTvta, "Aplicando comportamiento de los tipos de venta", "" ) } }


   ::oAlbCliT:OrdSetFocus( "dFecAlb" )
   ::oAlbCliL:OrdSetFocus( "nNumAlb" )

   do case
      case ::oEstado:nAt == 1
         cExpHead    := 'nFacturado < 3 .and. dFecAlb >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecAlb <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'
      case ::oEstado:nAt == 2
         cExpHead    := 'nFacturado == 3 .and. dFecAlb >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecAlb <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'
      case ::oEstado:nAt == 3
         cExpHead    := 'dFecAlb >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecAlb <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'
   end case

   if !::lAgeAll
      cExpHead       += ' .and. cCodAge >= "' + Rtrim( ::cAgeOrg ) + '" .and. cCodAge <= "' + Rtrim( ::cAgeDes ) + '"'
   end if

   if !Empty( ::oFilter:cExpresionFilter )
      cExpHead       += ' .and. ' + ::oFilter:cExpresionFilter
   end if

   ::oAlbCliT:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oAlbCliT:cFile ), ::oAlbCliT:OrdKey(), ( cExpHead ), , , , , , , , .t. )

   ::oMtrInf:SetTotal( ::oAlbCliT:OrdKeyCount() )

   /*
   Lineas de albaranes
   */

   cExpLine          := '!lTotLin .and. !lControl'

   if !::lAllArt
      cExpLine       += ' .and. cRef >= "' + ::cArtOrg + '" .and. cRef <= "' + ::cArtDes + '"'
   end if

   ::oAlbCliL:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oAlbCliL:cFile ), ::oAlbCliL:OrdKey(), cAllTrimer( cExpLine ), , , , , , , , .t. )

   ::oAlbCliT:GoTop()

   while !::lBreak .and. !::oAlbCliT:Eof()

      if lChkSer( ::oAlbCliT:cSerAlb, ::aSer )

         if ::oAlbCliL:Seek( ::oAlbCliT:cSerAlb + Str( ::oAlbCliT:nNumAlb ) + ::oAlbCliT:cSufAlb )

            while ::oAlbCliT:cSerAlb + Str( ::oAlbCliT:nNumAlb ) + ::oAlbCliT:cSufAlb == ::oAlbCliL:cSerAlb + Str( ::oAlbCliL:nNumAlb ) + ::oAlbCliL:cSufAlb .AND. ! ::oAlbCliL:eof()

               if !( ::lExcCero .AND. nTotNAlbCli( ::oAlbCliL:cAlias ) == 0 ) .and.;
                  !( ::lExcImp .AND. nImpLAlbCli( ::oAlbCliT:cAlias, ::oAlbCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv ) == 0 )

                  /*
                  Preguntamos y tratamos el tipo de venta
                  */

                  if ::lTvta

                     if  ( if (!Empty( ::cTipVen ), ::oAlbCliL:cTipMov == ::cTipVen, .t. ) )

                        ::oDbf:Append()
                        ::oDbf:Blank()

                        ::oDbf:cCodAge := ::oAlbCliT:cCodAge
                        ::oDbf:cCodCli := ::oAlbCliT:cCodCli
                        ::oDbf:cNomCli := ::oAlbCliT:cNomCli
                        ::oDbf:dFecMov := ::oAlbCliT:dFecAlb
                        ::oDbf:cCsuAlb := ::oAlbCliT:cCodSuAlb
                        ::oDbf:cDocMov := ::oAlbCliT:cSerAlb + "/" + AllTrim( Str( ::oAlbCliT:nNumAlb ) ) + "/" + ::oAlbCliT:cSufAlb
                        ::oDbf:cRefArt := ::oAlbCliL:cRef
                        ::oDbf:cDesArt := ::oAlbCliL:cDetalle

                        ::AddCliente( ::oAlbCliT:CCODCLI, ::oAlbCliT, .f. )

                        if ( ::oDbfAge:Seek (::oAlbCliT:cCodAge) )
                           ::oDbf:cNomAge := ::oDbfAge:cApeAge + ", " + ::oDbfAge:cNbrAge
                        end if

                        ::oDbf:Save()

                    end if

                  /*
                  Pasamos de los tipos de ventas
                  */

                  else

                     ::oDbf:Append()

                     ::oDbf:cCodAge := ::oAlbCliT:cCodAge
                     ::oDbf:cCodCli := ::oAlbCliT:cCodCli
                     ::oDbf:cNomCli := ::oAlbCliT:cNomCli
                     ::oDbf:dFecMov := ::oAlbCliT:dFecAlb
                     ::oDbf:cCsuAlb := ::oAlbCliT:cCodSuAlb
                     ::oDbf:cDocMov := ::oAlbCliT:cSerAlb + "/" + AllTrim( Str( ::oAlbCliT:nNumAlb ) ) + "/" + ::oAlbCliT:cSufAlb
                     ::oDbf:cRefArt := ::oAlbCliL:cRef
                     ::oDbf:cDesArt := ::oAlbCliL:cDetalle

                     ::AddCliente( ::oAlbCliT:cCodCli, ::oAlbCliT, .f. )

                     if ( ::oDbfAge:Seek (::oAlbCliT:cCodAge) )
                        ::oDbf:cNomAge := ::oDbfAge:cApeAge + ", " + ::oDbfAge:cNbrAge
                     end if

                     ::oDbf:nUndCaj := ::oAlbCliL:nCanEnt
                     ::oDbf:nCajUnd := NotCaja( ::oAlbCliL:nCanEnt )* ::oAlbCliL:nUniCaja
                     ::oDbf:nUndArt := ::oAlbCliL:nUniCaja
                     ::oDbf:nComAge := ( ::oAlbCliL:nComAge )
                     ::oDbf:nBasCom := nImpLAlbCli( ::oAlbCliT:cAlias, ::oAlbCliL:cAlias, ::nDecOut, ::nDerOut )
                     ::oDbf:nTotCom := nComLAlbCli( ::oAlbCliT:cAlias, ::oAlbCliL:cAlias, ::nDecOut, ::nDerOut )

                     ::oDbf:Save()

                  end if

               end if

               ::oAlbCliL:Skip()

            end while

         end if

         end if

         ::oAlbCliT:Skip()

         ::oMtrInf:AutoInc()

   end while

   ::oAlbCliT:IdxDelete( cCurUsr(), GetFileNoExt( ::oAlbCliT:cFile ) )

   ::oAlbCliL:IdxDelete( cCurUsr(), GetFileNoExt( ::oAlbCliL:cFile ) )

   ::oMtrInf:AutoInc( ::oAlbCliT:LastRec() )

   ::oDlg:Enable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//