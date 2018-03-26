#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS InfTar FROM TInfGen

   DATA  oDbfTarT  AS OBJECT
   DATA  oDbfTarL  AS OBJECT
   DATA  oDbfArt   AS OBJECT
   DATA  cTarOrg   AS CHARACTER
   DATA  cTarDes   AS CHARACTER
   DATA  lAllTar   AS LOGIC   INIT .t.
   DATA  lGrpFam   AS LOGIC   INIT .f.

   METHOD Create()

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHOD lResource( cFld )

   METHOD lGenerate()

   METHOD AddLine()

   METHOD NewGroup( lDesFam )

   METHOD QuiGroup( lDesFam )

END CLASS

//---------------------------------------------------------------------------//

METHOD Create()

   ::AddField( "cCodTar",   "C",  5, 0, {|| "" },           "Cód. tar.",      .f., "Código de la tarifa",       5, .f. )
   ::AddField( "cNomTar",   "C", 30, 0, {|| "" },           "Tarifa",         .f., "Nombre de la tarifa",      30, .f. )
   ::AddField( "cCodigo",   "C", 18, 0, {|| "" },           "Código",         .t., "Código del art./fam.",     15, .f. )
   ::AddField( "cNombre",   "C",100, 0, {|| "" },           "Nombre",         .t., "Nombre del art./fam.",     50, .f. )
   ::AddField( "cCodFam",   "C", 16, 0, {|| "" },           "Cod. Fam.",      .f., "Código de la familia",     15, .f. )
   ::AddField( "cNomFam",   "C", 40, 0, {|| "" },           "Nom. Fam.",      .f., "Nombre de la familia",     50, .f. )
   ::FldPropiedades()
   ::AddField( "nPrcTar1",  "N", 16, 6, {|| "" },           "Precio1",        .t., "Precio1",                  12, .f. )
   ::AddField( "nPrcTar2",  "N", 16, 6, {|| "" },           "Precio2",        .f., "Precio2",                  12, .f. )
   ::AddField( "nPrcTar3",  "N", 16, 6, {|| "" },           "Precio3",        .f., "Precio3",                  12, .f. )
   ::AddField( "nPrcTar4",  "N", 16, 6, {|| "" },           "Precio4",        .f., "Precio4",                  12, .f. )
   ::AddField( "nPrcTar5",  "N", 16, 6, {|| "" },           "Precio5",        .f., "Precio5",                  12, .f. )
   ::AddField( "nPrcTar6",  "N", 16, 6, {|| "" },           "Precio6",        .f., "Precio6",                  12, .f. )
   ::AddField( "nDtoArt",   "N",  6, 2, {|| "@E 99.99" },   "% Dto.",         .t., "Dto. porcentual",           6, .f. )
   ::AddField( "nDtoDiv",   "N", 16, 6, {|| "" },           "Dto. lin.",      .t., "Dto. lineal",              12, .f. )
   ::AddField( "dIniPrm",   "D",  8, 0, {|| "" },           "Ini. Prom.",     .f., "Fecha inicio de promoción",10, .f. )
   ::AddField( "dFinPrm",   "D",  8, 0, {|| "" },           "Fin Prom.",      .f., "Fecha fin de promoción",   10, .f. )
   ::AddField( "nDtoPrm",   "N",  6, 2, {|| "@E 99.99" },   "% Dto. Prom.",   .f., "Descuento promoción",       6, .f. )

   ::AddTmpIndex ( "cCodTar", "cCodTar + cCodigo" )

   ::AddGroup( {|| ::oDbf:cCodTar }, {|| "Tarifa : " + Rtrim( ::oDbf:cCodTar ) + "-" + Rtrim( ::oDbf:cNomTar ) }, {||"Total tarifa..."} )

   ::lDefFecInf   := .f.
   ::lDefSerInf   := .f.
   ::lDefDivInf   := .f.

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD OpenFiles()

   local lOpen    := .t.
   local oBlock   := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

      DATABASE NEW ::oDbfTarT PATH ( cPatEmp() )   FILE "TARPRET.DBF"   VIA ( cDriver() ) SHARED INDEX "TARPRET.CDX"

      DATABASE NEW ::oDbfTarL PATH ( cPatEmp() )   FILE "TARPREL.DBF"   VIA ( cDriver() ) SHARED INDEX "TARPREL.CDX"

      DATABASE NEW ::oDbfArt  PATH ( cPatEmp() )   FILE "ARTICULO.DBF"  VIA ( cDriver() ) SHARED INDEX "ARTICULO.CDX"

   RECOVER

      msgStop( 'Imposible abrir todas las bases de datos' )
      ::CloseFiles()
      lOpen       := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD CloseFiles()

   if !Empty( ::oDbfTarT ) .and. ::oDbfTarT:Used()
      ::oDbfTarT:End()
   end if

   if !Empty( ::oDbfTarL ) .and. ::oDbfTarL:Used()
      ::oDbfTarL:End()
   end if

   if !Empty( ::oDbfArt ) .and. ::oDbfArt:Used()
      ::oDbfArt:End()
   end if

   ::oDbfTarT  := nil
   ::oDbfTarL  := nil
   ::oDbfArt   := nil

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD lResource( cFld )

   local cSayTarOrg
   local cSayTarDes
   local oSayTarOrg
   local oSayTarDes
   local oTarOrg
   local oTarDes

   if !::StdResource( "INF_TAR01" )
      return .f.
   end if

   /*Montamos los tipos de movimientos de almacen*/

   ::cTarOrg   := dbFirst( ::oDbfTarT, 1 )
   ::cTarDes   := dbLast(  ::oDbfTarT, 1 )
   cSayTarOrg  := dbFirst( ::oDbfTarT, 2 )
   cSayTarDes  := dbLast(  ::oDbfTarT, 2 )

   REDEFINE CHECKBOX ::lAllTar ;
      ID       ( 60 ) ;
      OF       ::oFld:aDialogs[1]

   REDEFINE GET oTarOrg VAR ::cTarOrg;
      ID       ( 70 );
      WHEN     ( !::lAllTar );
      BITMAP   "LUPA" ;
		COLOR 	CLR_GET ;
      OF       ::oFld:aDialogs[1]

      oTarOrg:bValid   := {|| cTarifa( oTarOrg, oSayTarOrg ) }
      oTarOrg:bHelp    := {|| BrwTarifa( oTarOrg, oSayTarOrg ) }

   REDEFINE GET oSayTarOrg VAR cSayTarOrg ;
      ID       ( 80 );
      WHEN     .f.;
      COLOR    CLR_GET ;
      OF       ::oFld:aDialogs[1]

   REDEFINE GET oTarDes VAR ::cTarDes;
      ID       ( 90 );
      WHEN     ( !::lAllTar );
      BITMAP   "LUPA" ;
		COLOR 	CLR_GET ;
      OF       ::oFld:aDialogs[1]

      oTarDes:bValid   := {|| cTarifa( oTarDes, oSayTarDes ) }
      oTarDes:bHelp    := {|| BrwTarifa( oTarDes, oSayTarDes ) }

   REDEFINE GET oSayTarDes VAR cSayTarDes ;
      WHEN     .f.;
      ID       ( 100 );
      OF       ::oFld:aDialogs[1]

   if !::lDefFamInf( 110, 111, 120, 121, 130 )
      Return .f.
   end if

   REDEFINE CHECKBOX ::lGrpFam ;
      ID       ( 200 ) ;
      OF       ::oFld:aDialogs[1]

   /*
   Damos valor al meter--------------------------------------------------------
   */

   ::oMtrInf:SetTotal( ::oDbfTarT:Lastrec() )

   ::CreateFilter( aItmTar(), ::oDbfTarT )

   ::bPreGenerate    := {|| ::NewGroup( ::lGrpFam ) }
   ::bPostGenerate   := {|| ::QuiGroup( ::lGrpFam ) }

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

   ::aHeader      := {  {|| "Fecha    : " + Dtoc( Date() ) },;
                        {|| "Tarifas  : " + if( ::lAllTar, "Todos", AllTrim( ::cTarOrg ) + " > " + AllTrim( ::cTarDes ) ) },;
                        {|| "Familias : " + if( ::lAllFam, "Todas", AllTrim( ::cFamOrg ) + " > " + AllTrim( ::cFamDes ) ) } }

   ::oDbfTarT:OrdSetFocus( "CCODTAR" )

   if !::lAllTar
      cExpHead       := 'cCodTar >= "' + Rtrim( ::cTarOrg ) + '" .and. cCodTar <= "' + Rtrim( ::cTarDes ) + '"'
   else
      cExpHead       := '.t.'
   end if

   if !Empty( ::oFilter:cExpresionFilter )
      cExpHead       += ' .and. ' + ::oFilter:cExpresionFilter
   end if

   ::oDbfTarT:AddTmpIndex( Auth():Codigo(), GetFileNoExt( ::oDbfTarT:cFile ), ::oDbfTarT:OrdKey(), ( cExpHead ), , , , , , , , .t. )

   ::oDbfTarT:GoTop()

   while !::lBreak .and. !::oDbfTarT:Eof()

      if ::oDbfTarL:Seek( ::oDbfTarT:cCodTar )

            while ::oDbfTarT:cCodTar == ::oDbfTarL:cCodTar .and. !::oDbfTarL:Eof()

               if ::oDbfTarL:nTipTar <= 1

                  if ( ::lAllFam .or. ( oRetFld( ::oDbfTarL:cCodArt, ::oDbfArt, "Familia" ) >= ::cFamOrg .and. oRetFld( ::oDbfTarL:cCodArt, ::oDbfArt, "Familia" ) <= ::cFamDes ) )
                     ::AddLine()
                  end if

               else

                  if( ::lAllFam .or.( ::oDbfTarL:cCodFam >= ::cFamOrg .and. ::oDbfTarL:cCodFam <= ::cFamDes ) )
                     ::AddLine()
                  end if

               end if

               ::oDbfTarL:Skip()

            end while

      end if

      ::oDbfTarT:Skip()

      ::oMtrInf:AutoInc( ::oDbfTarT:OrdKeyNo() )

   end while

   ::oDbfTarT:IdxDelete( Auth():Codigo(), GetFileNoExt( ::oDbfTarT:cFile ) )

   ::oMtrInf:AutoInc( ::oDbfTarT:LastRec() )

   ::oDlg:Enable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//

METHOD AddLine()

   ::oDbf:Append()

   ::oDbf:cCodTar    := ::oDbfTarT:cCodTar
   ::oDbf:cNomTar    := retTarifa( ::oDbf:cCodTar, ::oDbfTarT:cAlias )

   if ::oDbfTarL:nTipTar <= 1
      ::oDbf:cCodigo := ::oDbfTarL:cCodArt
      ::oDbf:cNombre := ::oDbfTarL:cNomArt
      ::oDbf:cCodFam := oRetFld( ::oDbfTarL:cCodArt, ::oDbfArt, "Familia" )
      ::oDbf:cNomFam := oRetFld( ::oDbf:cCodFam, ::oDbfFam )
   else
      ::oDbf:cCodigo := ::oDbfTarL:cCodFam
      ::oDbf:cNombre := ::oDbfTarL:cNomFam
      ::oDbf:cCodFam := ::oDbfTarL:cCodFam
      ::oDbf:cNomFam := ::oDbfTarL:cNomFam
   end if

   ::oDbf:cCodPr1   := ::oDbfTarL:cCodPr1
   ::oDbf:cNomPr1   := retProp( ::oDbfTarL:cCodPr1 )
   ::oDbf:cValPr1   := ::oDbfTarL:cValPr1
   ::oDbf:cNomVl1   := retValProp( ::oDbfTarL:cCodPr1 + ::oDbfTarL:cValPr1 )
   ::oDbf:cCodPr2   := ::oDbfTarL:cCodPr2
   ::oDbf:cNomPr2   := retProp( ::oDbfTarL:cCodPr2 )
   ::oDbf:cValPr2   := ::oDbfTarL:cValPr2
   ::oDbf:cNomVl2   := retValProp( ::oDbfTarL:cCodPr2 + ::oDbfTarL:cValPr2 )
   ::oDbf:nPrcTar1  := ::oDbfTarL:nPrcTar1
   ::oDbf:nPrcTar2  := ::oDbfTarL:nPrcTar2
   ::oDbf:nPrcTar3  := ::oDbfTarL:nPrcTar3
   ::oDbf:nPrcTar4  := ::oDbfTarL:nPrcTar4
   ::oDbf:nPrcTar5  := ::oDbfTarL:nPrcTar5
   ::oDbf:nPrcTar6  := ::oDbfTarL:nPrcTar6
   ::oDbf:nDtoArt   := ::oDbfTarL:nDtoArt
   ::oDbf:nDtoDiv   := ::oDbfTarL:nDtoDiv
   ::oDbf:dIniPrm   := ::oDbfTarL:dIniPrm
   ::oDbf:dFinPrm   := ::oDbfTarL:dFinPrm
   ::oDbf:nDtoPrm   := ::oDbfTarL:nDtoPrm

   ::oDbf:Save()

RETURN .t.

//---------------------------------------------------------------------------//

METHOD NewGroup( lDesFam )

   if !lDesFam
      ::AddGroup( {|| ::oDbf:cCodTar + ::oDbf:cCodFam }, {|| "Familia : " + Rtrim( ::oDbf:cCodFam ) + "-" + Rtrim( ::oDbf:cNomFam ) }, {||"Total familia..."} )
   end if

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD QuiGroup( lDesFam )

   if !lDesFam
      ::DelGroup()
   end if

RETURN ( Self )

//---------------------------------------------------------------------------//