#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"
//---------------------------------------------------------------------------//

CLASS OInfGFac FROM TPrvGrp

   DATA  lExcMov     AS LOGIC    INIT .f.
   DATA  oEstado     AS OBJECT
   DATA  oFacPrvT    AS OBJECT
   DATA  oFacPrvL    AS OBJECT
   DATA  oFacPrvP    AS OBJECT
   DATA  oDbfIva     AS OBJECT
   DATA  aEstado     AS ARRAY    INIT { "Pendientes", "Cobradas", "Todas" }

   METHOD Create()

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHOD lResource( cFld )

   METHOD lGenerate()

END CLASS

//---------------------------------------------------------------------------//

METHOD Create()

   ::CreateFields()

   ::AddTmpIndex( "cGrpFam", "cGrpFam + cCodArt" )

   ::AddGroup( {|| ::oDbf:cGrpFam }, {|| "Grupo Familia  : " + Rtrim( ::oDbf:cGrpFam ) + "-" + AllTrim( ::oDbf:cNomGrp ) }, {||"Total Grupo de Familia..."} )
   ::AddGroup( {|| ::oDbf:cGrpFam + ::oDbf:cCodArt }, {|| "Artículo : " + Rtrim( ::oDbf:cCodArt ) + "-" + AllTrim( ::oDbf:cNomArt ) }, {|| Space(1) } )

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD OpenFiles()

   local lOpen    := .t.
   local oBlock   := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

   DATABASE NEW ::oFacPrvT PATH ( cPatEmp() ) FILE "FACPRVT.DBF" VIA ( cDriver() ) SHARED INDEX "FACPRVT.CDX"

   DATABASE NEW ::oFacPrvL PATH ( cPatEmp() ) FILE "FACPRVL.DBF" VIA ( cDriver() ) SHARED INDEX "FACPRVL.CDX"

   DATABASE NEW ::oFacPrvP PATH ( cPatEmp() ) FILE "FACPRVP.DBF" VIA ( cDriver() ) SHARED INDEX "FACPRVP.CDX"

   DATABASE NEW ::oDbfIva  PATH ( cPatDat() ) FILE "TIVA.DBF"    VIA ( cDriver() ) SHARED INDEX "TIVA.CDX"

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

   ::oFacPrvT  := nil
   ::oFacPrvL  := nil
   ::oFacPrvP  := nil
   ::oDbfIva   := nil

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD lResource( cFld )

   local cEstado := "Todas"

   if !::StdResource( "INF_GEN14" )
      return .f.
   end if

   /*
   Monta Grupos de Familias
   */

   if !::oDefGrFInf( 110, 120, 130, 140, 900 )
      return .f.
   end if

   /*
   Meter
   */

   ::oMtrInf:SetTotal( ::oFacPrvT:Lastrec() )

   /*
   Monta los articulos de manera automatica
   */

   if !::lDefArtInf( 150, 160, 170, 180, 800 )
      return .f.
   end if

   ::oDefExcInf()

   REDEFINE COMBOBOX ::oEstado ;
      VAR      cEstado ;
      ID       218 ;
      ITEMS    ::aEstado ;
      OF       ::oFld:aDialogs[1]

   ::CreateFilter( aItmFacPrv(), ::oFacPrvT:cAlias )

RETURN .t.

//---------------------------------------------------------------------------//
/*
Esta funcion crea la base de datos para generar posteriormente el informe
*/

METHOD lGenerate()

   local cExpHead    := ""
   local cExpLine    := ""
   local aTot        := {}

   ::oDlg:Disable()
   ::oBtnCancel:Enable()
   ::oDbf:Zap()

   ::aHeader         := {  {|| "Fecha    : " + Dtoc( Date() ) },;
                           {|| "Periodo  : " + Dtoc( ::dIniInf ) + " > " + Dtoc( ::dFinInf ) },;
                           {|| "Grp.Fam. : " + if( ::lAllGrp, "Todos", AllTrim( ::cGruFamOrg ) + " > " + AllTrim( ::cGruFamDes ) ) },;
                           {|| "Artículo : " + if( ::lAllArt, "Todos", AllTrim( ::cArtOrg )+ " > " + AllTrim( ::cArtDes ) )},;
                           {|| "Estado   : " + ::aEstado[ ::oEstado:nAt ] } }

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

   if !Empty( ::oFilter:cExpresionFilter )
      cExpHead       += ' .and. ' + ::oFilter:cExpresionFilter
   end if

   ::oFacPrvT:AddTmpIndex( Auth():Codigo(), GetFileNoExt( ::oFacPrvT:cFile ), ::oFacPrvT:OrdKey(), ( cExpHead ), , , , , , , , .t. )

   ::oMtrInf:SetTotal( ::oFacPrvT:OrdKeyCount() )

   if !::lAllGrp
      cExpLine       := 'cGrpFam >= "' + Rtrim( ::cGruFamOrg ) + '" .and. cGrpFam <= "' + Rtrim( ::cGruFamDes ) + '"'
   else
      cExpLine       := '.t.'
   end if

   if !::lAllArt
      cExpLine       += ' .and. cRef >= "' + ::cArtOrg + '" .and. cRef <= "' + ::cArtDes + '"'
   end if

   ::oFacPrvL:AddTmpIndex( Auth():Codigo(), GetFileNoExt( ::oFacPrvL:cFile ), ::oFacPrvL:OrdKey(), cAllTrimer( cExpLine ), , , , , , , , .t. )

   ::oFacPrvT:GoTop()

   while !::lBreak .and. !::oFacPrvT:Eof()

      if lChkSer( ::oFacPrvT:cSerFac, ::aSer )

         if ::oFacPrvT:lFacGas

            aTot              := aTotFacPrv( ::oFacPrvT:cSerFac + Str( ::oFacPrvT:nNumFac ) + ::oFacPrvT:cSufFac, ::oFacPrvT:cAlias, ::oFacPrvL:cAlias, ::oDbfIva:cAlias, ::oDbfDiv:cAlias, ::oFacPrvP:cAlias, ::cDivInf )

            ::oDbf:Append()

            ::oDbf:cGrpFam    := Space( 5 )
            ::oDbf:cNomGrp    := Space( 40 )
            ::AddProveedor( ::oFacPrvT:cCodPrv )
            ::oDbf:cCodArt    := Space(18)
            ::oDbf:cNomArt    := "Factura de gastos. Concepto: " + ::oFacPrvT:mComGas
            ::oDbf:nNumCaj    := 1
            ::oDbf:nUniDad    := 1
            ::oDbf:cDocMov    := ::oFacPrvT:cSerFac + "/" + AllTrim ( Str( ::oFacPrvT:nNumFac ) ) + If( !Empty( ::oFacPrvT:cSufFac ), "/" + AllTrim ( ::oFacPrvT:cSufFac ), "" )
            ::oDbf:dFecMov    := ::oFacPrvT:dFecFac
            ::oDbf:nNumUni    := 1
            ::oDbf:nImpArt    := aTot[1]
            ::oDbf:nImpTot    := aTot[1]
            ::oDbf:nIvaTot    := aTot[2]
            ::oDbf:nTotFin    := aTot[4]

            ::oDbf:Save()

         else

            if ::oFacPrvL:Seek( ::oFacPrvT:cSerFac + Str( ::oFacPrvT:nNumFac ) + ::oFacPrvT:cSufFac )

               while ::oFacPrvT:cSerFac + Str( ::oFacPrvT:nNumFac ) + ::oFacPrvT:cSufFac == ::oFacPrvL:cSerFac + Str( ::oFacPrvL:nNumFac ) + ::oFacPrvL:cSufFac .AND. ! ::oFacPrvL:eof()

                  if !( ::lExcCero .AND. nImpLFacPrv( ::oFacPrvT:cAlias, ::oFacPrvL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv ) == 0 )

                     ::AddFac( .f. )

                  end if

                  ::oFacPrvL:Skip()

               end while

            end if

         end if

      end if

      ::oFacPrvT:Skip()

      ::oMtrInf:AutoInc( ::oFacPrvT:OrdKeyNo() )

   end while

   ::oMtrInf:AutoInc( ::oFacPrvT:Lastrec() )

   ::oFacPrvT:IdxDelete( Auth():Codigo(), GetFileNoExt( ::oFacPrvT:cFile ) )

   ::oFacPrvL:IdxDelete( Auth():Codigo(), GetFileNoExt( ::oFacPrvL:cFile ) )

   ::oDlg:Enable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//