#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"
//---------------------------------------------------------------------------//

CLASS TInfStockMinimoFamilia FROM TInfGen

   DATA  lResumen    AS LOGIC    INIT .f.
   DATA  lExcCero    AS LOGIC    INIT .f.
   DATA  lMinCero    AS LOGIC    INIT .t.
   DATA  nEstado     AS NUMERIC  INIT 2
   DATA  oDbfArt     AS OBJECT
   DATA  oStock      AS OBJECT
   DATA  oAlbPrvL    AS OBJECT
   DATA  oFacPrvL    AS OBJECT
   DATA  oAlbCliL    AS OBJECT
   DATA  oFacCliL    AS OBJECT
   DATA  oFacRecL    AS OBJECT
   DATA  oTikCliL    AS OBJECT
   DATA  oProLin     AS OBJECT
   DATA  oProMat     AS OBJECT
   DATA  oHisMov     AS OBJECT

   METHOD Create()

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHOD lResource( cFld )

   METHOD lGenerate()

   METHOD oDefDivInf()  VIRTUAL
   METHOD oDefIniInf()  VIRTUAL
   METHOD oDefFinInf()  VIRTUAL

   END CLASS

//---------------------------------------------------------------------------//

METHOD Create()

   ::AddField ( "cCodAlm", "C", 16, 0, {|| "@!" },            "Alm.",            .f., "Código almacén",     03 )
   ::AddField ( "cCodArt", "C", 18, 0, {|| "@!" },            "Código artículo",       .t., "Código artículo",    14 )
   ::AddField ( "cNomArt", "C",100, 0, {|| "@!" },            "Artículo",        .t., "Artículo",           40 )
   ::AddField ( "cCodFam", "C", 16, 0, {|| "@!" },            "Cod. Fam.",       .f., "Código familia",     05 )
   ::AddField ( "cNomFam", "C", 30, 0, {|| "@!" },            "Familia",         .f., "Nombre familia",     30 )
   ::AddField ( "cCodPrv", "C", 12, 0, {|| "@!" },            "Cod. Prv.",       .f., "Código proveedor",   09 )
   ::AddField ( "cNomPrv", "C", 80, 0, {|| "@!" },            "Proveedor",       .f., "Nombre proveedor",   30 )
   ::AddField ( "nNumUnd", "N", 13, 6, {|| MasUnd() },        cNombreUnidades(), .t., cNombreunidades(),    12 )
   ::AddField ( "nUndMin", "N", 13, 6, {|| MasUnd() },        "Mínimo",          .t., "Mínimo unidades",    12 )

   ::AddTmpIndex( "CCODALM", "CCODALM + CCODFAM + CCODART" )

   ::AddGroup( {|| ::oDbf:cCodAlm }, {|| "Almacén  : " + Rtrim( ::oDbf:cCodAlm ) + "-" + oRetFld( ::oDbf:cCodAlm, ::oDbfAlm ) }, {||"Total almacén..."} )
   ::AddGroup( {|| ::oDbf:cCodAlm + ::oDbf:cCodFam }, {|| "Família : " + Rtrim( ::oDbf:cCodFam ) + "-" + oRetFld( ::oDbf:cCodFam, ::oDbfFam ) }, {|| Space(1) } )

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD OpenFiles()

   local lOpen    := .t.
   local oBlock   := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

      DATABASE NEW ::oDbfArt  PATH ( cPatArt() )   FILE "ARTICULO.DBF"  VIA ( cDriver() ) SHARED INDEX "ARTICULO.CDX"

      DATABASE NEW ::oAlbPrvL PATH ( cPatEmp() )   FILE "ALBPROVL.DBF"  VIA ( cDriver() ) SHARED INDEX "ALBPROVL.CDX"

      DATABASE NEW ::oFacPrvL PATH ( cPatEmp() )   FILE "FACPRVL.DBF"   VIA ( cDriver() ) SHARED INDEX "FACPRVL.CDX"

      DATABASE NEW ::oAlbCliL PATH ( cPatEmp() )   FILE "ALBCLIL.DBF"   VIA ( cDriver() ) SHARED INDEX "ALBCLIL.CDX"

      DATABASE NEW ::oFacCliL PATH ( cPatEmp() )   FILE "FACCLIL.DBF"   VIA ( cDriver() ) SHARED INDEX "FACCLIL.CDX"

      DATABASE NEW ::oFacRecL PATH ( cPatEmp() )   FILE "FACRECL.DBF"   VIA ( cDriver() ) SHARED INDEX "FACRECL.CDX"

      DATABASE NEW ::oTikCliL PATH ( cPatEmp() )   FILE "TIKEL.DBF"     VIA ( cDriver() ) SHARED INDEX "TIKEL.CDX"

      DATABASE NEW ::oProLin  PATH ( cPatEmp() )   FILE "PROLIN.DBF"    VIA ( cDriver() ) SHARED INDEX "PROLIN.CDX"

      DATABASE NEW ::oProMat  PATH ( cPatEmp() )   FILE "PROMAT.DBF"    VIA ( cDriver() ) SHARED INDEX "PROMAT.CDX"

      DATABASE NEW ::oHisMov  PATH ( cPatEmp() )   FILE "HISMOV.DBF"    VIA ( cDriver() ) SHARED INDEX "HISMOV.CDX"

      ::oStock    := TStock():New()
      if !::oStock:lOpenFiles()
         lOpen    := .f.
      end if

   RECOVER

      lOpen       := .f.
      msgStop( 'Imposible abrir todas las bases de datos' )

   END SEQUENCE

   ErrorBlock( oBlock )

   if !lOpen
      ::CloseFiles()
   end if

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD CloseFiles()

   if !Empty( ::oDbfArt ) .and. ::oDbfArt:Used()
      ::oDbfArt:End()
   end if

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

   if !Empty( ::oProLin ) .and. ::oProLin:Used()
      ::oProLin:End()
   end if

   if !Empty( ::oProMat ) .and. ::oProMat:Used()
      ::oProMat:End()
   end if

   if !Empty( ::oHisMov ) .and. ::oHisMov:Used()
      ::oHisMov:End()
   end if

   if !Empty( ::oStock )
      ::oStock:End()
   end if

   ::oDbfArt   := nil
   ::oStock    := nil
   ::oAlbPrvL  := nil
   ::oFacPrvL  := nil
   ::oAlbCliL  := nil
   ::oFacCliL  := nil
   ::oFacRecL  := nil
   ::oTikCliL  := nil
   ::oProLin   := nil
   ::oProMat   := nil
   ::oHisMov   := nil

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD lResource( cFld )

   ::lDefSerInf   := .f.

   if !::StdResource( "STK_MIN_FAM" )
      return .f.
   end if

   /*
   Monta los almacenes de manera automatica
   */

   if !::oDefAlmInf( 70, 80, 90, 100, 700 )
      return .f.
   end if

   /*
   Monta las familias de manera automatica
   */

   if !::lDefFamInf( 150, 160, 170, 180, 900 )
      return .f.
   end if

   REDEFINE CHECKBOX ::lMinCero ;
      ID       ( 203 );
      OF       ::oFld:aDialogs[1]

   REDEFINE RADIO ::nEstado ;
      ID       201, 202;
      OF       ::oFld:aDialogs[1]

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

   local cExpArt        := ""
   local nStockActual   := 0

   ::oDlg:Disable()
   ::oBtnCancel:Enable()
   ::oDbf:Zap()

   ::oDbfAlm:GoTop()

   ::aHeader   := {  {|| "Fecha       : " + Dtoc( Date() ) },;
                     {|| "Almacenes   : " + if( ::lAllAlm, "Todos", AllTrim( ::cAlmOrg ) + " > " + AllTrim( ::cAlmDes ) ) },;
                     {|| "Familias    : " + if( ::lAllFam, "Todas", AllTrim( ::cFamOrg ) + " > " + AllTrim( ::cFamDes ) ) },;
                     {|| if( ::nEstado == 1, "Solo artículos con stock bajo mínimo", "Todos los artículos" ) },;
                     {|| if( ::lMinCero, "Solo artículos con stock mínimo distinto de 0", ""  ) } }

   ::oDbfArt:OrdSetFocus( "CODIGO" )

   cExpArt           := 'nCtlStock == 1 .and. !lKitArt'

   if !::lAllFam
      cExpArt        += ' .and. Familia >= "' + Rtrim( ::cFamOrg ) + '" .and. Familia <= "' + Rtrim( ::cFamDes ) + '"'
   end if

   if !Empty( ::oFilter:cExpresionFilter )
      cExpArt        += ' .and. ' + ::oFilter:cExpresionFilter
   end if

   ::oDbfArt:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oDbfArt:cFile ), ::oDbfArt:OrdKey(), ( cExpArt ), , , , , , , , .t. )

   while !::lBreak .and. !::oDbfAlm:Eof()

      if ( ::lAllAlm .or. ( ::oDbfAlm:cCodAlm >= ::cAlmOrg .AND. ::oDbfAlm:cCodAlm <= ::cAlmDes ) )

      ::oMtrInf:SetTotal( ::oDbfArt:OrdKeyCount() )

      ::oDbfArt:GoTop()

      while !::lBreak .and. !::oDbfArt:Eof()

         if ( !::lMinCero .or. ::oDbfArt:nMinimo != 0 )

            nStockActual   := ::oStock:nStockAlmacen( ::oDbfArt:Codigo, ::oDbfAlm:cCodAlm )

            if ( ::nEstado == 1 .or. nStockActual < ::oDbfArt:nMinimo )

               ::oDbf:Append()
               ::oDbf:cCodAlm := ::oDbfAlm:cCodAlm
               ::oDbf:cCodFam := ::oDbfArt:Familia
               ::oDbf:cNomFam := oRetFld( ::oDbf:cCodFam, ::oDbfFam )
               ::oDbf:cCodArt := ::oDbfArt:Codigo
               ::oDbf:cNomArt := ::oDbfArt:Nombre
               ::oDbf:nNumUnd := nStockActual
               ::oDbf:nUndMin := ::oDbfArt:nMinimo
               ::oDbf:cCodPrv := ::oDbfArt:cPrvHab
               ::oDbf:cNomPrv := oRetFld( ::oDbf:cCodPrv, ::oDbfFam )
               ::oDbf:Save()

            end if

         end if

         ::oDbfArt:Skip()

         ::oMtrInf:AutoInc( ::oDbfArt:OrdKeyNo() )

      end do

      ::oMtrInf:AutoInc( ::oDbfArt:LastRec() )

      end if

      ::oDbfAlm:Skip()

   end do

   ::oDbfArt:IdxDelete( cCurUsr(), GetFileNoExt( ::oDbfArt:cFile ) )

   ::oDlg:Enable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//