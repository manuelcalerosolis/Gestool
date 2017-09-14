#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"
//---------------------------------------------------------------------------//

CLASS OInfXFac FROM TPrvGrpPrv

   DATA  oFacPrvT    AS OBJECT
   DATA  oFacPrvL    AS OBJECT
   DATA  oFacPrvP    AS OBJECT
   DATA  oDbfIva     AS OBJECT
   DATA  oEstado     AS OBJECT
   DATA  aEstado     AS ARRAY    INIT { "Pendientes", "Liquidadas", "Todas" }

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

   ::oFacPrvT := nil
   ::oFacPrvL := nil
   ::oFacPrvP := nil
   ::oDbfIva := nil

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD lResource( cFld )

   local cEstado := "Todas"

   if !::StdResource( "INFDETGRPPRV" )
      return .f.
   end if

   /* Monta los desde - hasta*/

   if !::oDefGrpPrv( 70, 71, 80, 81, 90 )
      return .f.
   end if

   if !::oDefPrvInf( 150, 151, 160, 161, 170 )
      return .f.
   end if

   REDEFINE COMBOBOX ::oEstado ;
      VAR      cEstado ;
      ID       218 ;
      ITEMS    ::aEstado ;
      OF       ::oFld:aDialogs[1]

   ::oMtrInf:SetTotal( ::oFacPrvT:Lastrec() )

   ::CreateFilter( aItmFacPrv(), ::oFacPrvT:cAlias )

RETURN .t.

//---------------------------------------------------------------------------//
/*
Esta funcion crea la base de datos para generar posteriormente el informe
*/

METHOD lGenerate()

   local cExpHead  := ""
   local cCodGrp
   local aTotFac

   /*Desabilitamos el diálogo para que no lo toquen mientras se procesa el informe*/
   ::oDlg:Disable()
   ::oBtnCancel:Enable()
   ::oDbf:Zap()

   /*Cabecera del listado*/
   ::aHeader   := {  {|| "Fecha     : " + Dtoc( Date() ) },;
                     {|| "Periodo   : " + Dtoc( ::dIniInf )   + " > " + Dtoc( ::dFinInf ) },;
                     {|| "Grp. prov.: " + if( ::lGrpPrvAll, "Todos", AllTrim( ::cGrpPrvOrg ) + " > " + AllTrim( ::cGrpPrvDes ) ) },;
                     {|| "Proveedor : " + if( ::lAllPrv, "Todos", AllTrim( ::cPrvOrg ) + " > " + AllTrim (::cPrvDes ) ) },;
                     {|| "Estado    : " + ::aEstado[ ::oEstado:nAt ] } }

   /*Creamos los filtros para que entre sólo lo que interesa*/

   ::oFacPrvT:OrdSetFocus( "dFecFac" )
   ::oFacPrvL:OrdSetFocus( "nNumFac" )

   do case
      case ::oEstado:nAt == 1
         cExpHead    := '!lLiquidada .and. dFecFac >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecFac <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'
      case ::oEstado:nAt == 2
         cExpHead    := 'lLiquidada .and. dFecFac >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecFac <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'
      case ::oEstado:nAt == 3
         cExpHead    := 'dFecFac >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecFac <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'
   end case

   if !::lAllPrv
      cExpHead       += ' .and. cCodPrv >= "' + Rtrim( ::cPrvOrg ) + '" .and. cCodPrv <= "' + Rtrim( ::cPrvDes ) + '"'
   end if

   if !Empty( ::oFilter:cExpresionFilter )
      cExpHead       += ' .and. ' + ::oFilter:cExpresionFilter
   end if

   ::oFacPrvT:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oFacPrvT:cFile ), ::oFacPrvT:OrdKey(), ( cExpHead ), , , , , , , , .t. )

   ::oMtrInf:SetTotal( ::oFacPrvT:OrdKeyCount() )

   ::oFacPrvT:GoTop()

   while !::oFacPrvT:Eof()

      /*Tomamos el valor del grupo de proveedor*/
      cCodGrp        := cGruPrv( ::oFacPrvT:cCodPrv, ::oDbfPrv )

      /*Comprobamos que entre solo lo que tiene que entrar*/
      if ( ::lGrpPrvAll .or. ( cCodGrp >= ::cGrpPrvOrg .AND. cCodGrp <= ::cGrpPrvDes ) ) .AND.;
         lChkSer( ::oFacPrvT:cSerFac, ::aSer )

         aTotFac        := aTotFacPrv (::oFacPrvT:cSerFac + Str( ::oFacPrvT:nNumFac ) + ::oFacPrvT:cSufFac, ::oFacPrvT:cAlias, ::oFacPrvL:cAlias, ::oDbfIva, ::oDbfDiv, ::oFacPrvP:cAlias )

         ::oDbf:Append()

         ::oDbf:cCodGrp    := cCodGrp
         ::oDbf:cNomGrp    := cNomGrp( cCodGrp, ::oGrpPrv:oDbf )
         ::oDbf:cCodPrv    := ::oFacPrvT:cCodPrv
         ::oDbf:cNomPrv    := ::oFacPrvT:cNomPrv
         ::oDbf:cDocMov    := AllTrim( ::oFacPrvT:cSerFac ) + "/" + AllTrim ( Str( ::oFacPrvT:nNumFac ) ) + "/" + AllTrim ( ::oFacPrvT:cSufFac )
         ::oDbf:dFecMov    := ::oFacPrvT:dFecFac
         ::oDbf:cTipDoc    := "Factura"
         ::oDbf:nImpTot    := aTotFac[1]
         ::oDbf:nIvaTot    := aTotFac[2]
         ::oDbf:nTotFin    := aTotFac[4]

         ::oDbf:Save()

      end if

      ::oFacPrvT:Skip()

      ::oMtrInf:AutoInc( ::oFacPrvT:OrdKeyNo() )

   end while

   ::oMtrInf:AutoInc( ::oFacPrvT:Lastrec() )

   /*Destruimos los filtros*/
   ::oFacPrvT:IdxDelete( cCurUsr(), GetFileNoExt( ::oFacPrvT:cFile ) )

   ::oDlg:Enable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//