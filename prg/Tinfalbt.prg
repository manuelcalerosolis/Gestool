#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS TInfAlbT FROM TInfGen

   DATA  lResumen    AS LOGIC    INIT .f.
   DATA  lExcCero    AS LOGIC    INIT .f.
   DATA  oEstado     AS OBJECT
   DATA  oAlbCliT    AS OBJECT
   DATA  oAlbCliL    AS OBJECT
    
   DATA  aEstado     AS ARRAY    INIT  { "No facturado", "Facturado", "Todos" }

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
   ::AddField( "nUniCaj",   "N", 16, 6, {|| ::cPicOut },   "Tot. " + cNombreUnidades(), .t., "Total " + cNombreUnidades(), 12, .f. )
   ::AddField( "nPreArt",   "N", 16, 6, {|| ::cPicOut },   "Precio",         .t., "Precio artículo",     12, .f. )
   ::AddField( "nBase",     "N", 16, 6, {|| ::cPicOut },   "Base",           .t., "Base",                12, .t. )
   ::AddField( "nIva",      "N", 16, 6, {|| ::cPicOut },   cImp(),            .t., cImp(),                 12, .t. )
   ::AddField( "nTotal",    "N", 16, 6, {|| ::cPicOut },   "Total",          .t., "Total",               12, .t. )

   ::AddTmpIndex( "cNumDoc", "cNumDoc" )

   ::AddGroup( {|| ::oDbf:cNumDoc }, {|| "Albarán: " + Rtrim( ::oDbf:cNumDoc )+ " - " + Dtoc( ::oDbf:dFecDoc ) + " Cliente:" + Rtrim( ::oDbf:cCodCli ) + "-" + Rtrim( ::oDbf:cNomCli ) + if( !Empty( ::oDbf:cCodObr), " Obra:" + Rtrim( ::oDbf:cCodObr ) , " " ) + " E:" + RTrim( ::oDbf:cEstado ) }, {|| Space(1) } )

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD OpenFiles()

   local lOpen    := .t.
   local oBlock   := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

   ::oAlbCliT := TDataCenter():oAlbCliT()

   DATABASE NEW ::oAlbCliL PATH ( cPatEmp() ) FILE "ALBCLIL.DBF" VIA ( cDriver() ) SHARED INDEX "ALBCLIL.CDX"

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

   ::oAlbCliT := nil
   ::oAlbCliL := nil

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD lResource ( cFld )

   local cEstado := "Todos"

   if !::StdResource( "INFPRESUPUESTOS" )
      return .f.
   end if

   /*
   Monta los almacenes de manera automatica
   */

   if !::oDefCliInf( 70, 71, 80, 81, , 910 )
      return .f.
   end if

   REDEFINE COMBOBOX ::oEstado ;
      VAR      cEstado ;
      ID       218 ;
      ITEMS    ::aEstado ;
      OF       ::oFld:aDialogs[1]

   ::CreateFilter( aItmAlbCli(), ::oAlbCliT:cAlias )

   /*
   Damos valor al meter
   */

   ::oMtrInf:SetTotal( ::oAlbCliT:Lastrec() )

RETURN .t.

//---------------------------------------------------------------------------//
/*
Esta funcion crea la base de datos para generar posteriormente el informe
*/

METHOD lGenerate()

   local cExpHead   := ""

   ::oDlg:Disable()
   ::oBtnCancel:Enable()
   ::oDbf:Zap()

   ::aHeader      := {  {|| "Fecha    : " + Dtoc( Date() ) },;
                        {|| "Periodo  : " + Dtoc( ::dIniInf ) + " > " + Dtoc( ::dFinInf ) },;
                        {|| "Clientes : " + if( ::lAllCli, "Todos", AllTrim( ::cCliOrg ) + " > " + AllTrim( ::cCliDes ) ) },;
                        {|| "Estado   : " + ::aEstado[ ::oEstado:nAt ] } }

   ::oAlbCliT:OrdSetFocus( "dFecAlb" )

   do case
      case ::oEstado:nAt == 1
         cExpHead    := 'nFacturado < 3 .and. dFecAlb >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecAlb <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'
      case ::oEstado:nAt == 2
         cExpHead    := 'nFacturado == 3 .and. dFecAlb >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecAlb <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'
      case ::oEstado:nAt == 3
         cExpHead    := 'dFecAlb >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecAlb <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'
   end case

   if !::lAllCli
      cExpHead       += ' .and. cCodCli >= "' + Rtrim( ::cCliOrg ) + '" .and. cCodCli <= "' + Rtrim( ::cCliDes ) + '"'
   end if

   if !Empty( ::oFilter:cExpresionFilter )
      cExpHead       += ' .and. ' + ::oFilter:cExpresionFilter
   end if

   ::oAlbCliT:AddTmpIndex( Auth():Codigo(), GetFileNoExt( ::oAlbCliT:cFile ), ::oAlbCliT:OrdKey(), ( cExpHead ), , , , , , , , .t. )

   ::oMtrInf:SetTotal( ::oAlbCliT:OrdKeyCount() )

   ::oAlbCliT:GoTop()

   while !::lBreak .and. !::oAlbCliT:Eof()

      if lChkSer( ::oAlbCliT:cSerAlb, ::aSer )

         if ::oAlbCliL:Seek( ::oAlbCliT:cSerAlb + Str( ::oAlbCliT:nNumAlb ) + ::oAlbCliT:cSufAlb )

            while ::oAlbCliT:cSerAlb + Str( ::oAlbCliT:nNumAlb ) + ::oAlbCliT:cSufAlb == ::oAlbCliL:cSerAlb + Str( ::oAlbCliL:nNumAlb ) + ::oAlbCliL:cSufAlb .AND. ! ::oAlbCliL:eof()

               ::oDbf:Append()

               ::oDbf:cNumDoc     := AllTrim( ::oAlbCliT:cSerAlb ) + "/" + AllTrim( Str( ::oAlbCliT:nNumAlb ) ) + "/" + AllTrim( ::oAlbCliT:cSufAlb )
               ::oDbf:dFecDoc     := ::oAlbCliT:dFecAlb
               ::oDbf:cCodCli     := ::oAlbCliT:cCodCli
               ::oDbf:cNomCli     := ::oAlbCliT:cNomCli
               ::oDbf:cCodObr     := ::oAlbCliT:cCodObr

               do case
                  case !lFacturado( ::oAlbCliT )
                     ::oDbf:cEstado  := "No facturado"
                  case lFacturado( ::oAlbCliT )
                     ::oDbf:cEstado  := "Facturado"
               end if
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

   ::oAlbCliT:IdxDelete( Auth():Codigo(), GetFileNoExt( ::oAlbCliT:cFile ) )

   ::oMtrInf:AutoInc( ::oAlbCliT:LastRec() )

   ::oDlg:Enable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//