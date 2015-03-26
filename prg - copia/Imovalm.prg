#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS IMovAlm FROM TInfGen

   DATA  oDbfArt  AS OBJECT
   DATA  cAlmOrg  AS CHARACTER   INIT ""
   DATA  cAlmDes  AS CHARACTER   INIT ""
   DATA  oHisMov  AS OBJECT

   METHOD Create()

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHOD lResource( cFld )

   METHOD lGenerate()

END CLASS

//---------------------------------------------------------------------------//

METHOD Create()

   ::AddField( "dFecMov",   "D",  8, 0, {|| "" },     "Fecha",      .t.,"Fecha del movimiento",  12, .f.  )
   ::AddField( "cAliMov",   "C", 16, 0, {|| "" },     "Alm. Org.",  .t.,"Almacen origen",        10, .f.  )
   ::AddField( "cAloMov",   "C", 16, 0, {|| "" },     "Alm. Des.",  .t.,"Almacen destino",       10, .f.  )
   ::AddField( "cCodArt",   "C", 18, 0, {|| "" },     "Código artículo",  .t.,"Código de artículo",    15, .f.  )
   ::AddField( "cNomArt",   "C",100, 0, {|| "" },     "Nom. Art",   .t.,"Nombre de artículo",    30, .f.  )
   ::AddField( "nUndMov",   "N", 16, 3, {|| "" },     "Unidades",   .t.,"Unidades movidas",      10, .t.  )
   ::AddField( "nImpMov",   "N", 16, 3, {|| "" },     "Importe",    .t.,"Importe",               10, .f.  )
   ::AddField( "nTotMov",   "N", 16, 3, {|| "" },     "Total",      .t.,"Total",                 10, .t.  )

   ::AddTmpIndex ( "dFecMov", "dFecMov" )

   ::lDefSerInf   := .f.
   ::lDefDivInf   := .f.

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD OpenFiles()

   local lOpen    := .t.
   local oBlock   := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

   DATABASE NEW ::oDbfArt PATH ( cPatArt() )   FILE "ARTICULO.DBF"   VIA ( cDriver() ) SHARED INDEX "ARTICULO.CDX"

   DATABASE NEW ::oHisMov PATH ( cPatEmp() )   FILE "HISMOV.DBF"     VIA ( cDriver() ) SHARED INDEX "HISMOV.CDX"

   RECOVER

      msgStop( "Imposible abrir todas las bases de datos" )
      ::CloseFiles()
      lOpen          := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD CloseFiles()

   if !Empty( ::oDbfArt ) .and. ::oDbfArt:Used()
      ::oDbfArt:End()
   end if
   if !Empty( ::oHisMov ) .and. ::oHisMov:Used()
      ::oHisMov:End()
   end if

   ::oDbfArt := nil
   ::oHisMov := nil

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD lResource( cFld )

   local oAlmOrg
   local oAlmDes
   local oSayOrg
   local cSayOrg
   local oSayDes
   local cSayDes

   if !::StdResource( "INF_MOVALM" )
      return .f.
   end if

   REDEFINE GET oAlmOrg VAR ::cAlmOrg ;
      ID       70;
      VALID    cAlmacen( oAlmOrg, , oSayOrg ) ;
      BITMAP   "LUPA" ;
      ON HELP  BrwAlmacen( oAlmOrg, oSayOrg ) ;
      OF       ::oFld:aDialogs[1]

   REDEFINE GET oSayOrg VAR cSayOrg ;
      ID       80 ;
      WHEN     ( if( empty( ::cAlmOrg ), ( oSayOrg:cText( "Todos los almacenes" ), .f. ), .f. ) );
      OF       ::oFld:aDialogs[1]

   REDEFINE GET oAlmDes VAR ::cAlmDes ;
      ID       90;
      VALID    cAlmacen( oAlmDes, , oSayDes ) ;
      BITMAP   "LUPA" ;
      ON HELP  BrwAlmacen( oAlmDes, oSayDes ) ;
      OF       ::oFld:aDialogs[1]

   REDEFINE GET oSayDes VAR cSayDes ;
      ID       100 ;
      WHEN     ( if( empty( ::cAlmDes ), ( oSayDes:cText( "Todos los almacenes" ), .f. ), .f. ) );
      OF       ::oFld:aDialogs[1]

   ::oMtrInf:SetTotal( ::oHisMov:Lastrec() )

   ::CreateFilter( , ::oHisMov )

RETURN .t.

//---------------------------------------------------------------------------//

/*
Esta funcion crea la base de datos para generar posteriormente el informe
*/

METHOD lGenerate()

   ::oDlg:Disable()
   ::oBtnCancel:Enable()
   ::oDbf:Zap()

   ::aHeader      := {  {|| "Fecha           : " + Dtoc( Date() ) },;
                        {|| "Periodo         : " + Dtoc( ::dIniInf ) + " > " + Dtoc( ::dFinInf ) },;
                        {|| "Almacén origen  : " + if( Empty( ::cAlmOrg ), "Todos los almacenes", AllTrim( ::cAlmOrg ) ) },;
                        {|| "Almacén destino : " + if( Empty( ::cAlmDes ), "Todos los almacenes", AllTrim( ::cAlmDes ) ) } }

   ::oHisMov:OrdSetFocus( "dFecMov" )

   ::oHisMov:GoTop()
   while !::oHisMov:Eof()

      if ::EvalFilter()                                                                                     .and.;
         ::oHisMov:dFecMov >= ::dIniInf .and. ::oHisMov:dFecMov <= ::dFinInf                                .and.;
         ( ( ::oHisMov:cAloMov >= ::cAlmOrg .or. ::oHisMov:cAloMov <= ::cAlmOrg .or. empty( ::cAlmOrg ) )   .or.;
         ( ::oHisMov:cAliMov >= ::cAlmDes .or. ::oHisMov:cAliMov <= ::cAlmDes .or. empty( ::cAlmDes ) ) )

         ::oDbf:Append()

         ::oDbf:dFecMov  := ::oHisMov:dFecMov
         ::oDbf:cAliMov  := ::oHisMov:cAliMov
         ::oDbf:cAloMov  := ::oHisMov:cAloMov
         ::oDbf:cCodArt  := ::oHisMov:cRefMov
         ::oDbf:cNomArt  := RetArticulo( ::oHisMov:cRefMov, ::oDbfArt:cAlias )
         ::oDbf:nUndMov  := nTotNMovAlm( ::oHisMov:cAlias )
         ::oDbf:nImpMov  := ::oHisMov:nPreDiv
         ::oDbf:nTotMov  := nTotLMovAlm( ::oHisMov:cAlias )

         ::oDbf:Save()

      end if

      ::oHisMov:Skip()

      ::oMtrInf:AutoInc( ::oHisMov:OrdKeyNo() )

   end while

   ::oMtrInf:AutoInc( ::oHisMov:LastRec() )

   ::oDlg:Enable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//