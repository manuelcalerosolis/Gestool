#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS TInfOfr FROM TInfGen

   DATA  oDbfOfr     AS OBJECT
   DATA  oDbfArt     AS OBJECT
   DATA  lAllOfr     AS LOGIC    INIT .t.
   DATA  lAllArt     AS LOGIC    INIT .f.
   DATA  lExcObs     AS LOGIC    INIT .f.
   DATA  lExcNoAct   AS LOGIC    INIT .f.
   DATA  cOfrDes     AS CHARACTER
   DATA  cOfrHas     AS CHARACTER
   DATA  oOrden      AS OBJECT
   DATA  aOrden      AS ARRAY    INIT { "Código", "Nombre" }
   DATA  aTipoOferta AS ARRAY    INIT { "Artículos", "Familias", "Tipo de artículo", "Categorias", "Temporadas", "Fabricantes" }

   METHOD create()

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHOD lResource(cFld)

   METHOD lGenerate()

END CLASS

//---------------------------------------------------------------------------//

METHOD Create()

   ::AddField( "cTipOfe", "C", 30, 0, {|| "@!" },        "Tip. oferta",          .t., "Tip. oferta",           20, .f. )
   ::AddField( "cCodOfe", "C", 18, 0, {|| "@!" },        "Cod. oferta",          .t., "Cod. oferta",           10, .f. )
   ::AddField( "cNomOfe", "C",100, 0, {|| "@!" },        "Descripción",          .t., "Descripción",           50, .f. )
   ::AddField( "cNomArt", "C",100, 0, {|| "@!" },        "Descripción artículo", .f., "Nombre del artículo",   50, .f. )
   ::AddField( "cFecIni", "D",  8, 0, {|| "@!" },        "Fecha Ini.",           .t., "Fecha inicio",          12, .f. )
   ::AddField( "cFecFin", "D",  8, 0, {|| "@!" },        "Fecha Fin.",           .t., "Fecha final",           12, .f. )
   ::AddField( "nPrecio1","N", 16, 6, {|| ::cPicImp },   "Precio 1",             .t., "Precio1",               12, .f. )
   ::AddField( "nPrecio2","N", 16, 6, {|| ::cPicImp },   "Precio 2",             .t., "Precio2",               12, .f. )
   ::AddField( "nPrecio3","N", 16, 6, {|| ::cPicImp },   "Precio 3",             .f., "Precio3",               12, .f. )
   ::AddField( "nPrecio4","N", 16, 6, {|| ::cPicImp },   "Precio 4",             .f., "Precio4",               12, .f. )
   ::AddField( "nPrecio5","N", 16, 6, {|| ::cPicImp },   "Precio 5",             .f., "Precio5",               12, .f. )
   ::AddField( "nPrecio6","N", 16, 6, {|| ::cPicImp },   "Precio 6",             .f., "Precio6",               12, .f. )
   ::AddField( "nMaxVen", "N",  6, 0, {|| MasUnd() },    "Max. Ventas",          .t., "Max. Ventas",           12, .f. )
   ::AddField( "cTipOfr", "C", 18, 0, {|| "@!" },        "X*Y",                  .t., "X*Y",                   18, .f. )

   ::AddTmpIndex( "cCodOfe", "cCodOfe" )
   ::AddTmpIndex( "cNomOfe", "cNomOfe" )

   ::lDefSerInf := .f.
   ::lDefFecInf := .f.

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD OpenFiles()

   local lOpen    := .t.
   local oBlock   := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

      DATABASE NEW ::oDbfOfr  PATH ( cPatEmp() ) FILE "OFERTA.DBF" VIA ( cDriver() ) SHARED INDEX "OFERTA.CDX"

      DATABASE NEW ::oDbfArt  PATH ( cPatEmp() ) FILE "ARTICULO.DBF" VIA ( cDriver() ) SHARED INDEX "ARTICULO.CDX"

   RECOVER

      msgStop( "Imposible abrir todas las bases de datos" )
      ::CloseFiles()
      lOpen          := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD CloseFiles()

   if !Empty( ::oDbfOfr ) .and. ::oDbfOfr:Used()
      ::oDbfOfr:End()
   end if

   ::oDbfOfr := nil

RETURN ( Self )

//---------------------------------------------------------------------------//

METHod lResource ( cFld )

   local cOrden := "Código"
   local oOfrDes
   local oOfrHas
   local oOfrDesTxt
   local oOfrHasTxt
   local cOfrDesTxt
   local cOfrHasTxt
   local oThis := ::oDbfOfr

   if !::StdResource( "INF_OFR" )
      return .f.
   end if

   ::cOfrDes   := dbFirst( ::oDbfOfr, 1 )
   ::cOfrHas   := dbLast(  ::oDbfOfr, 1 )
   cOfrDesTxt  := dbFirst( ::oDbfOfr, 2 )
   cOfrHasTxt  := dbLast(  ::oDbfOfr, 2 )

   REDEFINE CHECKBOX ::lAllOfr ;
      ID       600 ;
      OF       ::oFld:aDialogs[1]

   REDEFINE CHECKBOX ::lExcObs ;
      ID       750 ;
      OF       ::oFld:aDialogs[1]

   REDEFINE CHECKBOX ::lExcNoAct ;
      ID       760 ;
      OF       ::oFld:aDialogs[1]

   REDEFINE CHECKBOX ::lAllArt ;
      ID       700 ;
      OF       ::oFld:aDialogs[1]

   /*
   Montamos el Desde -- Hasta impuestos
   */

   REDEFINE GET oOfrDes VAR ::cOfrDes ;
      ID       110 ;
      WHEN     ( !::lAllOfr );
      BITMAP   "LUPA" ;
      ON HELP  ( BrwOfe( oOfrDes, oThis:cAlias, oOfrDesTxt ) );
      OF       ::oFld:aDialogs[1]

   REDEFINE GET oOfrDesTxt VAR cOfrDesTxt ;
      WHEN     .f. ;
      ID       120 ;
      OF       ::oFld:aDialogs[1]

   REDEFINE GET oOfrHas VAR ::cOfrHas ;
      ID       130 ;
      WHEN     ( !::lAllOfr );
      BITMAP   "LUPA" ;
      ON HELP  ( BrwOfe( oOfrHas, oThis:cAlias, oOfrHasTxt ) ) ;
      OF       ::oFld:aDialogs[1]

   REDEFINE GET oOfrHasTxt VAR cOfrHasTxt ;
      WHEN     .f. ;
      ID       140 ;
      OF       ::oFld:aDialogs[1]

   REDEFINE COMBOBOX ::oOrden ;
      VAR      cOrden ;
      ID       218 ;
      ITEMS    ::aOrden;
      OF       ::oFld:aDialogs[1]

   /*
   Damos valor al meter
   */

   ::oMtrInf:SetTotal( ::oDbfOfr:Lastrec() )

   ::CreateFilter( aItmOfe(), ::oDbfOfr )

RETURN .t.

//---------------------------------------------------------------------------//
/*
Esta funcion crea la base de datos para generar posteriormente el informe
*/

METHOD lGenerate()

   ::oDlg:Disable()
   ::oBtnCancel:Enable()
   ::oDbf:Zap()

   ::aHeader      := {  {|| "Fecha   : " + Dtoc( Date() ) },;
                        {|| "Oferta  : " + if( ::lAllOfr, "Todas", AllTrim( ::cOfrDes ) + " > " + AllTrim( ::cOfrHas ) ) } }

   ::oDbfOfr:OrdSetFocus( "cArtOfe" )

   ::oDbfOfr:GoTop()
   while !::lBreak .and. !::oDbfOfr:Eof()

      if ( ::lAllOfr .or.( ::oDbfOfr:cArtOfe >= ::cOfrDes .and. ::oDbfOfr:cArtOfe <= ::cOfrHas ) )          .and.;
         ::EvalFilter()                                                                                     .and.;
         ( !::lExcNoAct .or. ( ::oDbfOfr:dIniOfe <= Date() .or. empty( ::oDbfOfr:dIniOfe ) )                .and.;
                             ( ::oDbfOfr:dFinOfe >= Date() .or. empty( ::oDbfOfr:dFinOfe ) ) )              .and.;
         ( ::oDbfOfr:nTblOfe > 1.or. ( !::lExcObs .or. !oRetFld( ::oDbfOfr:cArtOfe, ::oDbfArt, "lObs" ) ) ) .and.;
         ( ::oDbfOfr:nTblOfe > 1 .or. ( ::oDbfOfr:nTblOfe <= 1 .and. ::oDbfArt:SeekInOrd( ::oDbfOfr:cArtOfe, "Codigo" ) ) )

         ::oDbf:Append()

         ::oDbf:cTipOfe             := ::aTipoOferta[ Max( ::oDbfOfr:nTblOfe, 1 ) ]
         ::oDbf:cCodOfe             := ::oDbfOfr:cArtOfe
         ::oDbf:cNomOfe             := ::oDbfOfr:cDesOfe

         if ::oDbfOfr:nTblOfe <= 1
            ::oDbf:cNomArt          := oRetFld( ::oDbfOfr:cArtOfe, ::oDbfArt, "Nombre" )
         end if

         ::oDbf:cFecIni             := ::oDbfOfr:dIniOfe
         ::oDbf:cFecFin             := ::oDbfOfr:dFinOfe

         do case
            case ::oDbfOfr:nTipOfe == 1
               ::oDbf:nPrecio1      := ::oDbfOfr:nPreOfe1
               ::oDbf:nPrecio2      := ::oDbfOfr:nPreOfe2
               ::oDbf:nPrecio3      := ::oDbfOfr:nPreOfe3
               ::oDbf:nPrecio4      := ::oDbfOfr:nPreOfe4
               ::oDbf:nPrecio5      := ::oDbfOfr:nPreOfe5
               ::oDbf:nPrecio6      := ::oDbfOfr:nPreOfe6

            case ::oDbfOfr:nTipOfe == 2
               if ::oDbfArt:Seek( ::oDbfOfr:cArtOfe )
                  ::oDbf:nPrecio1   := ::oDbfArt:pVenta1
                  ::oDbf:nPrecio2   := ::oDbfArt:pVenta2
                  ::oDbf:nPrecio3   := ::oDbfArt:pVenta3
                  ::oDbf:nPrecio4   := ::oDbfArt:pVenta4
                  ::oDbf:nPrecio5   := ::oDbfArt:pVenta5
                  ::oDbf:nPrecio6   := ::oDbfArt:pVenta6
               end if

         end case

         ::oDbf:nMaxVen             := ::oDbfOfr:nMaxOfe
         ::oDbf:cTipOfr             := Trans( ::oDbfOfr:nUnvOfe, "@E 999" ) + " x" + Trans( ::oDbfOfr:nUncOfe, "@E 999" )

         ::oDbf:Save()

      end if

      ::oDbfOfr:Skip()

      ::oMtrInf:AutoInc()

   end while

   ::oMtrInf:AutoInc( ::oDbfOfr:Lastrec() )

   /*
   Incluimos todos los artículos-----------------------------------------------
   */

   ::oMtrInf:SetTotal( ::oDbfArt:Lastrec() )

   if ::lAllArt

      ::oDbfArt:GoTop()

      while !::oDbfArt:Eof()

         if ( ::lAllOfr .or. ( ::oDbfArt:Codigo >= ::cOfrDes .and. ::oDbfArt:Codigo <= ::cOfrHas ) ) .and.;
            !::oDbf:Seek( ::oDbfArt:Codigo ) .and.;
            ( !::lExcObs .or. !::oDbfArt:lObs )

            ::oDbf:Append()
            ::oDbf:Blank()

            ::oDbf:cTipOfe       := "Artículos"
            ::oDbf:cCodOfe       := ::oDbfArt:Codigo
            ::oDbf:cNomOfe       := ::oDbfArt:Nombre
            ::oDbf:cNomArt       := ::oDbfArt:Nombre
            ::oDbf:cFecIni       := Ctod( "" )
            ::oDbf:cFecFin       := Ctod( "" )
            ::oDbf:nPrecio1      := ::oDbfArt:pVenta1
            ::oDbf:nPrecio2      := ::oDbfArt:pVenta2
            ::oDbf:nPrecio3      := ::oDbfArt:pVenta3
            ::oDbf:nPrecio4      := ::oDbfArt:pVenta4
            ::oDbf:nPrecio5      := ::oDbfArt:pVenta5
            ::oDbf:nPrecio6      := ::oDbfArt:pVenta6
            ::oDbf:nMaxVen       := 0
            ::oDbf:cTipOfr       := ""

            ::oDbf:Save()

         end if

         ::oDbfArt:Skip()

         ::oMtrInf:AutoInc()

      end while

      ::oMtrInf:AutoInc( ::oDbfArt:Lastrec() )

   end if

   ::oDlg:Enable()

   /*
   Ponemos el orden deseado----------------------------------------------------
   */

   ::oDbf:OrdSetFocus( ::oOrden:nAt )

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//