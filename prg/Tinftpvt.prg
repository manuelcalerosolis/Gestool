#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS TInfTpvT FROM TInfGen

   DATA  lResumen    AS LOGIC    INIT .f.
   DATA  lExcCero    AS LOGIC    INIT .f.
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
   ::AddField( "cCodArt",   "C", 18, 0, {|| "@!" },        "Cod.",           .t., "Cod. artículo",       10, .f. )
   ::AddField( "cNomArt",   "C",100, 0, {|| "@!" },        "Artículo",       .t., "Nom. artículo",       40, .f. )
   ::FldPropiedades()
   ::AddField( "nUniCaj",   "N", 16, 6, {|| ::cPicOut },   cNombreUnidades(),.t., cNombreUnidades(),     12, .f. )
   ::AddField( "nPreArt",   "N", 16, 6, {|| ::cPicOut },   "Precio",         .t., "Precio artículo",     12, .f. )
   ::AddField( "nBase",     "N", 16, 6, {|| ::cPicOut },   "Base",           .t., "Base",                12, .t. )
   ::AddField( "nIva",      "N", 16, 6, {|| ::cPicOut },   cImp(),            .t., cImp(),                 12, .t. )
   ::AddField( "nTotal",    "N", 16, 6, {|| ::cPicOut },   "Total",          .t., "Total",               12, .t. )

   ::AddTmpIndex( "cNumDoc", "cNumDoc" )

   ::AddGroup( {|| ::oDbf:cNumDoc }, {|| "Tiket: " + Rtrim( ::oDbf:cNumDoc )+ " - " + Dtoc( ::oDbf:dFecDoc ) + " Cliente:" + Rtrim( ::oDbf:cCodCli ) + "-" + Rtrim( ::oDbf:cNomCli ) + if( !Empty( ::oDbf:cCodObr), " Obra:" + Rtrim( ::oDbf:cCodObr ) , " " ) }, {||Space(1)} )

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD OpenFiles()

   local lOpen    := .t.
   local oBlock   := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

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

   if !Empty( ::oTikCliT ) .and. ::oTikCliT:Used()
      ::oTikCliT:End()
   end if
   if !Empty( ::oTikCliL ) .and. ::oTikCliL:Used()
      ::oTikCliL:End()
   end if

   ::oTikCliT := nil
   ::oTikCliL := nil

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD lResource ( cFld )

   if !::StdResource( "INFTIKET" )
      return .f.
   end if

   /*
   Monta los almacenes de manera automatica
   */

   if !::oDefCliInf( 70, 71, 80, 81, , 910 )
      return .f.
   end if

   /*
   Damos valor al meter
   */

   ::oMtrInf:SetTotal( ::oTikCliT:Lastrec() )

   ::CreateFilter( aItmTik(), ::oTikCliT:cAlias )

RETURN .t.

//---------------------------------------------------------------------------//
/*
Esta funcion crea la base de datos para generar posteriormente el informe
*/

METHOD lGenerate()

   local cExpHead := ""

   ::oDlg:Disable()
   ::oBtnCancel:Enable()
   ::oDbf:Zap()

   ::aHeader      := {  {|| "Fecha    : " + Dtoc( Date() ) },;
                        {|| "Periodo  : " + Dtoc( ::dIniInf ) + " > " + Dtoc( ::dFinInf ) },;
                        {|| "Clientes : " + if( ::lAllCli, "Todos", AllTrim( ::cCliOrg ) + " > " + AllTrim( ::cCliDes ) ) } }

   ::oTikCliT:OrdSetFocus( "dFecTik" )

   cExpHead          := 'dFecTik >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecTik <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'

   if !::lAllCli
      cExpHead       += ' .and. cCliTik >= "' + Rtrim( ::cCliOrg ) + '" .and. cCliTik <= "' + Rtrim( ::cCliDes ) + '"'
   end if

   if !Empty( ::oFilter:cExpresionFilter )
      cExpHead       += ' .and. ' + ::oFilter:cExpresionFilter
   end if

   ::oTikCliT:AddTmpIndex( Auth():Codigo(), GetFileNoExt( ::oTikCliT:cFile ), ::oTikCliT:OrdKey(), ( cExpHead ), , , , , , , , .t. )

   ::oMtrInf:SetTotal( ::oTikCliT:OrdKeyCount() )

   ::oTikCliT:GoTop()

   while !::lBreak .and. !::oTikCliT:Eof()

      if lChkSer( ::oTikCliT:cSerTik, ::aSer )

         if ::oTikCliL:Seek( ::oTikCliT:cSerTik + ::oTikCliT:cNumTik + ::oTikCliT:cSufTik )

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

               ::oDbf:cCodPr1        := ::oTikCliL:cCodPr1
               ::oDbf:cNomPr1        := retProp( ::oTikCliL:cCodPr1 )
               ::oDbf:cCodPr2        := ::oTikCliL:cCodPr2
               ::oDbf:cNomPr2        := retProp( ::oTikCliL:cCodPr2 )
               ::oDbf:cValPr1        := ::oTikCliL:cValPr1
               ::oDbf:cNomVl1        := retValProp( ::oTikCliL:cCodPr1 + ::oTikCliL:cValPr1 )
               ::oDbf:cValPr2        := ::oTikCliL:cValPr2
               ::oDbf:cNomVl2        := retValProp( ::oTikCliL:cCodPr2 + ::oTikCliL:cValPr2 )

               if ::oTikCliT:cTipTik == "4"
                  ::oDbf:nUniCaj     := - ::oTikCliL:nUntTil
               else
                  ::oDbf:nUniCaj     := ::oTikCliL:nUntTil
               end if

               ::oDbf:nTotal         := ::oDbf:nBase + ::oDbf:nIva

               ::oDbf:Save()

               ::oTikCliL:Skip()

            end while

         end if

      end if

      ::oTikCliT:Skip()

      ::oMtrInf:AutoInc()

   end while

   ::oTikCliT:IdxDelete( Auth():Codigo(), GetFileNoExt( ::oTikCliT:cFile ) )

   ::oMtrInf:AutoInc( ::oTikCliT:LastRec() )

   ::oDlg:Enable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//