#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"
//---------------------------------------------------------------------------//

CLASS OInfXCom FROM TPrvGrpPrv

   DATA  oAlbPrvT    AS OBJECT
   DATA  oAlbPrvL    AS OBJECT
   DATA  oFacPrvT    AS OBJECT
   DATA  oFacPrvL    AS OBJECT
   DATA  oFacPrvP    AS OBJECT
   DATA  oDbfIva     AS OBJECT

   METHOD Create()

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHOD lResource( cFld )

   METHOD lGenerate()

END CLASS

//---------------------------------------------------------------------------//

METHOD Create()

   ::CreateFields()

   ::AddTmpIndex ( "cCodGrp", "cCodGrp + cCodPrv" )

   ::AddGroup( {|| ::oDbf:cCodGrp }, {|| "Grupo proveedor  : " + Rtrim( ::oDbf:cCodGrp ) + "-" + Rtrim( ::oDbf:cNomGrp ) }, {||"Total grupo proveedores..."} )
   ::AddGroup( {|| ::oDbf:cCodGrp + ::oDbf:cCodPrv },  {|| "Proveedor : " + Rtrim( ::oDbf:cCodPrv ) + " - " + Rtrim( ::oDbf:cNomPrv ) }, {|| "Total proveedor..." } )

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD OpenFiles()

   local lOpen    := .t.
   local oBlock   := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

   DATABASE NEW ::oAlbPrvT PATH ( cPatEmp() ) FILE "ALBPROVT.DBF" VIA ( cDriver() ) SHARED INDEX "ALBPROVT.CDX"

   DATABASE NEW ::oAlbPrvL PATH ( cPatEmp() ) FILE "ALBPROVL.DBF" VIA ( cDriver() ) SHARED INDEX "ALBPROVL.CDX"

   DATABASE NEW ::oFacPrvT PATH ( cPatEmp() ) FILE "FACPRVT.DBF"  VIA ( cDriver() ) SHARED INDEX "FACPRVT.CDX"

   DATABASE NEW ::oFacPrvL PATH ( cPatEmp() ) FILE "FACPRVL.DBF"  VIA ( cDriver() ) SHARED INDEX "FACPRVL.CDX"

   DATABASE NEW ::oFacPrvP PATH ( cPatEmp() ) FILE "FACPRVP.DBF"  VIA ( cDriver() ) SHARED INDEX "FACPRVP.CDX"

   DATABASE NEW ::oDbfIva  PATH ( cPatDat() ) FILE "TIVA.DBF"     VIA ( cDriver() ) SHARED INDEX "TIVA.CDX"

   RECOVER

      msgStop( "Imposible abrir todas las bases de datos" )
      ::CloseFiles()
      lOpen          := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD CloseFiles()

   if !Empty( ::oAlbPrvT ) .and. ::oAlbPrvT:Used()
      ::oAlbPrvT:End()
   end if
   if !Empty( ::oAlbPrvL ) .and. ::oAlbPrvL:Used()
      ::oAlbPrvL:End()
   end if
   if !Empty( ::oFacPrvT ) .and. ::oFacPrvT:Used()
      ::oFacPrvT:End()
   end if
   if !Empty( ::oFacPrvL ) .and. ::oFacPrvL:Used()
      ::oFacPrvL:End()
   end if
   if !Empty( ::oFacPrvP ) .and. ::oFacPrvP:Used()
      ::oFacPrvP:End()
   end if
   if !Empty( ::oDbfIva ) .and. ::oDbfIva:Used()
      ::oDbfIva:End()
   end if

   ::oAlbPrvT := nil
   ::oAlbPrvL := nil
   ::oFacPrvT := nil
   ::oFacPrvL := nil
   ::oFacPrvP := nil
   ::oDbfIva := nil

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD lResource( cFld )

   if !::StdResource( "INFDETGRPPRVB" )
      return .f.
   end if

   ::CreateFilter( aItmCompras(), { ::oAlbPrvT, ::oFacPrvT }, .t. )

   /* Monta los desde - hasta*/

   if !::oDefGrpPrv( 70, 71, 80, 81, 90 )
      return .f.
   end if

   if !::oDefPrvInf( 150, 151, 160, 161, 170 )
      return .f.
   end if

RETURN .t.

//---------------------------------------------------------------------------//
/*
Esta funcion crea la base de datos para generar posteriormente el informe
*/

METHOD lGenerate()

   local cExpHead  := ""
   local cCodGrp
   local aTotTmp

   /*Desabilitamos el di�logo para que no lo toquen mientras se procesa el informe*/
   ::oDlg:Disable()
   ::oBtnCancel:Enable()
   ::oDbf:Zap()

   /*Cabecera del listado*/
   ::aHeader   := {  {|| "Fecha     : " + Dtoc( Date() ) },;
                     {|| "Periodo   : " + Dtoc( ::dIniInf )   + " > " + Dtoc( ::dFinInf ) },;
                     {|| "Grp. prov.: " + if( ::lGrpPrvAll, "Todos", AllTrim( ::cGrpPrvOrg ) + " > " + AllTrim( ::cGrpPrvDes ) ) },;
                     {|| "Proveedor : " + if( ::lAllPrv, "Todos", AllTrim( ::cPrvOrg ) + " > " + AllTrim (::cPrvDes ) ) } }

   /*Creamos los filtros para que entre s�lo lo que interesa*/

   ::oAlbPrvT:OrdSetFocus( "dFecAlb" )

   cExpHead          := '!lFacturado .and. dFecAlb >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecAlb <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'

   if !::lAllPrv
      cExpHead       += ' .and. cCodPrv >= "' + Rtrim( ::cPrvOrg ) + '" .and. cCodPrv <= "' + Rtrim( ::cPrvDes ) + '"'
   end if

   if !Empty( ::oFilter:cExpresionFilter ) 
      cExpHead       += ' .and. ' + ::oFilter:cExpresionFilter
   end if

   ::oAlbPrvT:AddTmpIndex( Auth():Codigo(), GetFileNoExt( ::oAlbPrvT:cFile ), ::oAlbPrvT:OrdKey(), ( cExpHead ), , , , , , , , .t. )

   ::oMtrInf:SetTotal( ::oAlbPrvT:OrdKeyCount() )

   ::oAlbPrvT:GoTop()

   while !::oAlbPrvT:Eof()

      /*Tomamos el valor del grupo de proveedor*/
      cCodGrp        := cGruPrv( ::oAlbPrvT:cCodPrv, ::oDbfPrv )

      /*Comprobamos que entre solo lo que tiene que entrar*/
      if ::lGrpPrvAll .or. ( cCodGrp >= ::cGrpPrvOrg .AND. cCodGrp <= ::cGrpPrvDes ) .AND.;
         lChkSer( ::oAlbPrvT:cSerAlb, ::aSer )

         aTotTmp        := aTotAlbPrv (::oAlbPrvT:cSerAlb + Str( ::oAlbPrvT:nNumAlb ) + ::oAlbPrvT:cSufAlb, ::oAlbPrvT:cAlias, ::oAlbPrvL:cAlias, ::oDbfIva, ::oDbfDiv, nil, .f. )

         ::oDbf:Append()

         ::oDbf:cCodGrp    := cCodGrp
         ::oDbf:cNomGrp    := cNomGrp( cCodGrp, ::oGrpPrv:oDbf )
         ::oDbf:cCodPrv    := ::oAlbPrvT:cCodPrv
         ::oDbf:cNomPrv    := ::oAlbPrvT:cNomPrv
         ::oDbf:cDocMov    := AllTrim( ::oAlbPrvT:cSerAlb ) + "/" + AllTrim ( Str( ::oAlbPrvT:nNumAlb ) ) + "/" + AllTrim ( ::oAlbPrvT:cSufAlb )
         ::oDbf:dFecMov    := ::oAlbPrvT:dFecAlb
         ::oDbf:cTipDoc    := "Albar�n"
         ::oDbf:nImpTot    := aTotTmp[1]
         ::oDbf:nIvaTot    := aTotTmp[2]
         ::oDbf:nTotFin    := aTotTmp[4]

         ::oDbf:Save()

      end if

      ::oAlbPrvT:Skip()

      ::oMtrInf:AutoInc( ::oAlbPrvT:OrdKeyNo() )

   end while

   ::oMtrInf:AutoInc( ::oAlbPrvT:Lastrec() )

   /*Destruimos los filtros*/
   ::oAlbPrvT:IdxDelete( Auth():Codigo(), GetFileNoExt( ::oAlbPrvT:cFile ) )

   /*Creamos los filtros para que entre s�lo lo que interesa*/

   ::oFacPrvT:OrdSetFocus( "dFecFac" )

   cExpHead          := 'dFecFac >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecFac <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'

   if !::lAllPrv
      cExpHead       += ' .and. cCodPrv >= "' + Rtrim( ::cPrvOrg ) + '" .and. cCodPrv <= "' + Rtrim( ::cPrvDes ) + '"'
   end if

   if !Empty( ::oFilter:cExpresionFilter )
      cExpHead       += ' .and. ' + ::oFilter:cExpresionFilter
   end if

   ::oFacPrvT:AddTmpIndex( Auth():Codigo(), GetFileNoExt( ::oFacPrvT:cFile ), ::oFacPrvT:OrdKey(), ( cExpHead ), , , , , , , , .t. )

   ::oMtrInf:SetTotal( ::oFacPrvT:OrdKeyCount() )

   ::oFacPrvT:GoTop()

   while !::oFacPrvT:Eof()

      /*Tomamos el valor del grupo de proveedor*/
      cCodGrp        := cGruPrv( ::oFacPrvT:cCodPrv, ::oDbfPrv )

      /*Comprobamos que entre solo lo que tiene que entrar*/
      if ( ::lGrpPrvAll .or. ( cCodGrp >= ::cGrpPrvOrg .AND. cCodGrp <= ::cGrpPrvDes ) ) .AND.;
         lChkSer( ::oFacPrvT:cSerFac, ::aSer )

         aTotTmp        := aTotFacPrv (::oFacPrvT:cSerFac + Str( ::oFacPrvT:nNumFac ) + ::oFacPrvT:cSufFac, ::oFacPrvT:cAlias, ::oFacPrvL:cAlias, ::oDbfIva, ::oDbfDiv, ::oFacPrvP:cAlias )

         ::oDbf:Append()

         ::oDbf:cCodGrp    := cCodGrp
         ::oDbf:cNomGrp    := cNomGrp( cCodGrp, ::oGrpPrv:oDbf )
         ::oDbf:cCodPrv    := ::oFacPrvT:cCodPrv
         ::oDbf:cNomPrv    := ::oFacPrvT:cNomPrv
         ::oDbf:cDocMov    := AllTrim( ::oFacPrvT:cSerFac ) + "/" + AllTrim ( Str( ::oFacPrvT:nNumFac ) ) + "/" + AllTrim ( ::oFacPrvT:cSufFac )
         ::oDbf:dFecMov    := ::oFacPrvT:dFecFac
         ::oDbf:cTipDoc    := "Factura"
         ::oDbf:nImpTot    := aTotTmp[1]
         ::oDbf:nIvaTot    := aTotTmp[2]
         ::oDbf:nTotFin    := aTotTmp[4]

         ::oDbf:Save()

      end if

      ::oFacPrvT:Skip()

      ::oMtrInf:AutoInc( ::oFacPrvT:OrdKeyNo() )

   end while

   ::oMtrInf:AutoInc( ::oFacPrvT:Lastrec() )

   /*Destruimos los filtros*/
   ::oFacPrvT:IdxDelete( Auth():Codigo(), GetFileNoExt( ::oFacPrvT:cFile ) )

   ::oDlg:Enable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//