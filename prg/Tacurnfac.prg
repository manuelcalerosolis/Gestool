#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS TAcuRNFac FROM TInfPArt

   DATA  oFacCliT    AS OBJECT
   DATA  oFacCliL    AS OBJECT
   DATA  oFacRecT    AS OBJECT
   DATA  oFacRecL    AS OBJECT
   DATA  oEstado     AS OBJECT
   DATA  aEstado     AS ARRAY    INIT  { "Pendientes", "Cobradas", "Todas" }

   METHOD Create ()

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHOD lResource( cFld )

   METHOD lGenerate()

END CLASS

//---------------------------------------------------------------------------//

METHOD Create ()

   ::AddField( "cCodAge", "C",  3, 0, {|| "@!" },           "Cod. Age. ",                 .f., "Código agente"             ,  3, .f. )
   ::AddField( "cNomAge", "C", 50, 0, {|| "@!" },           "Agente",                     .f., "Nombre agente"             , 28, .f. )
   ::AddField( "cCodArt", "C", 18, 0, {|| "@!" },           "Cod. Art",                   .t., "Código de artículo"        , 14, .f. )
   ::AddField( "cNomArt", "C",100, 0, {|| "@!" },           "Artículo",                   .t., "Nombre de artículo"        , 35, .f. )
   ::AddField( "nNumCaj", "N", 16, 6, {|| MasUnd() },       cNombreCajas(),               .f., cNombreCajas()              , 12, .t. )
   ::AddField( "nUniDad", "N", 16, 6, {|| MasUnd() },       cNombreUnidades(),            .f., cNombreUnidades()           , 12, .f. )
   ::AddField( "nNumUni", "N", 16, 6, {|| MasUnd() },       "Tot. " + cNombreUnidades(),  .t., "Total " + cNombreUnidades(), 12, .t. )
   ::AddField( "nImpArt", "N", 16, 6, {|| ::cPicImp },      "Precio",                     .f., "Precio"                    , 12, .f. )
   ::AddField( "nImpTot", "N", 16, 6, {|| ::cPicOut },      "Base",                       .t., "Base"                      , 12, .t. )
   ::AddField( "nPreMed", "N", 16, 6, {|| ::cPicImp },      "Pre. Med.",                  .t., "Precio medio"              , 12, .f. )
   ::AddField( "nIvaTot", "N", 16, 6, {|| ::cPicOut },      cImp(),                     .t., cImp()                    , 12, .t. )
   ::AddField( "nTotFin", "N", 16, 6, {|| ::cPicOut },      "Total",                      .t., "Total"                     , 12, .t. )
   ::AddField( "nTotCom", "N", 16, 6, {|| ::cPicOut },      "Total Com.",                 .f., "Total comisión"            , 12, .t. )

   ::AddTmpIndex( "CCODAGE", "CCODAGE + CCODART" )

   ::AddGroup( {|| ::oDbf:cCodAge }, {|| "Agente : " + Rtrim( ::oDbf:cCodAge ) + " - " + Rtrim( ::oDbf:cNomAge ) }, {||"Total agente..."} )

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD OpenFiles() CLASS TAcuRNFac

   local lOpen    := .t.
   local oBlock   := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE


   ::oFacCliT := TDataCenter():oFacCliT()

   DATABASE NEW ::oFacCliL PATH ( cPatEmp() ) FILE "FACCLIL.DBF"  VIA ( cDriver() ) SHARED INDEX "FACCLIL.CDX"

   DATABASE NEW ::oFacRecT PATH ( cPatEmp() ) FILE "FACRECT.DBF"  VIA ( cDriver() ) SHARED INDEX "FACRECT.CDX"

   DATABASE NEW ::oFacRecL PATH ( cPatEmp() ) FILE "FACRECL.DBF"  VIA ( cDriver() ) SHARED INDEX "FACRECL.CDX"

   RECOVER

      msgStop( "Imposible abrir todas las bases de datos" )
      ::CloseFiles()
      lOpen          := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD CloseFiles() CLASS TAcuRNFac

   if !Empty( ::oFacCliT ) .and. ::oFacCliT:Used()
      ::oFacCliT:End()
   end if
   if !Empty( ::oFacCliL ) .and. ::oFacCliL:Used()
      ::oFacCliL:End()
   end if
   if !Empty( ::oFacRecT ) .and. ::oFacRecT:Used()
      ::oFacRecT:End()
   end if
   if !Empty( ::oFacRecL ) .and. ::oFacRecL:Used()
      ::oFacRecL:End()
   end if

   ::oFacCliT := nil
   ::oFacCliL := nil
   ::oFacRecT := nil
   ::oFacRecL := nil

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD lResource( cFld ) CLASS TAcuRNFac

   local cEstado  := "Todas"

   if !::StdResource( "INFACUARTAGE" )
      return .f.
   end if

   if !::oDefAgeInf( 110, 120, 130, 140, 150 )
      return .f.
   end if

   if !::lDefArtInf( 70, 80, 90, 100, 800 )
      return .f.
   end if

   ::oDefExcInf( 210 )
   ::oDefExcImp( 211 )

   REDEFINE COMBOBOX ::oEstado ;
      VAR      cEstado ;
      ID       218 ;
      ITEMS    ::aEstado ;
      OF       ::oFld:aDialogs[1]

   ::oMtrInf:SetTotal( ::oFacCliT:Lastrec() )

   ::CreateFilter( aItmFacCli(), ::oFacCliT:cAlias )

RETURN .t.

//---------------------------------------------------------------------------//
/*
Esta funcion crea la base de datos para generar posteriormente el informe
*/

METHOD lGenerate() CLASS TAcuRNFac

   local cExpHead := ""
   local cExpLine := ""

   ::oDlg:Disable()
   ::oBtnCancel:Enable()
   ::oDbf:Zap()

   /*Cabecera del documento*/

   ::aHeader      := {  {|| "Fecha     : " + Dtoc( Date() ) },;
                        {|| "Periodo   : " + Dtoc( ::dIniInf ) + " > " + Dtoc( ::dFinInf ) },;
                        {|| "Agentes   : " + if( ::lAgeAll, "Todos", AllTrim( ::cAgeOrg ) + " > " + AllTrim (::cAgeDes ) ) },;
                        {|| "Artículos : " + if( ::lAllArt, "Todos", AllTrim( ::cArtOrg ) + " > " + AllTrim (::cArtDes ) ) },;
                        {|| "Estado    : " + ::aEstado[ ::oEstado:nAt ] } }

   /*
   comenzamos con las facturas
   */

   ::oFacCliT:OrdSetFocus( "dFecFac" )
   ::oFacCliL:OrdSetFocus( "nNumFac" )

   /*
   Cabeceras de las facturas
   */

   do case
      case ::oEstado:nAt == 1
         cExpHead    := '!lLiquidada .and. dFecFac >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecFac <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'
      case ::oEstado:nAt == 2
         cExpHead    := 'lLiquidada .and. dFecFac >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecFac <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'
      case ::oEstado:nAt == 3
         cExpHead    := 'dFecFac >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecFac <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'
   end case

   if !::lAgeAll
      cExpHead       += ' .and. cCodAge >= "' + Rtrim( ::cAgeOrg ) + '" .and. cCodAge <= "' + Rtrim( ::cAgeDes ) + '"'
   end if

   if !Empty( ::oFilter:cExpresionFilter )
      cExpHead       += ' .and. ' + ::oFilter:cExpresionFilter
   end if

   ::oFacCliT:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oFacCliT:cFile ), ::oFacCliT:OrdKey(), ( cExpHead ), , , , , , , , .t. )

   ::oMtrInf:SetTotal( ::oFacCliT:OrdKeyCount() )

   //Líneas de las facturas

   cExpLine          := '!lControl .and. !lTotLin'

   if !::lAllArt
      cExpLine       += ' .and. cRef >= "' + Rtrim( ::cArtOrg ) + '" .and. cRef <= "' + Rtrim( ::cArtDes ) + '"'
   end if

   ::oFacCliL:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oFacCliL:cFile ), ::oFacCliL:OrdKey(), cAllTrimer( cExpLine ), , , , , , , , .t. )

   ::oFacCliT:GoTop()

   while !::lBreak .and. !::oFacCliT:Eof()

      if lChkSer( ::oFacCliT:cSerie, ::aSer )

         if ::oFacCliL:Seek( ::oFacCliT:cSerie + Str( ::oFacCliT:nNumFac ) + ::oFacCliT:cSufFac )

            while ::oFacCliT:cSerie + Str( ::oFacCliT:nNumFac ) + ::oFacCliT:cSufFac == ::oFacCliL:cSerie + Str( ::oFacCliL:nNumFac ) + ::oFacCliL:cSufFac .AND. ! ::oFacCliL:eof()

               if !( ::lExcCero .and. nTotNFacCli( ::oFacCliL:cAlias ) == 0 ) .and.;
                  !( ::lExcImp .and. nImpLFacCli( ::oFacCliT:cAlias, ::oFacCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv ) == 0 )

                  if !::oDbf:Seek( ::oFacCliT:cCodAge + ::oFacCliL:cRef )

                     //Añadimos

                     ::oDbf:Append()

                     ::oDbf:cCodAge    := ::oFacCliT:cCodAge
                     ::oDbf:cNomAge    := AllTrim( oRetFld( ::oFacCliT:cCodAge, ::oDbfAge, "CAPEAGE" ) ) + ", " + AllTrim( oRetFld( ::oFacCliT:cCodAge, ::oDbfAge, "CNBRAGE" ) )
                     ::oDbf:cCodArt    := ::oFacCliL:cRef
                     ::oDbf:cNomArt    := ::oFacCliL:cDetalle
                     ::oDbf:nNumCaj    := ::oFacCliL:nCanEnt
                     ::oDbf:nUniDad    := ::oFacCliL:nUniCaja
                     ::oDbf:nNumUni    := nTotNFacCli( ::oFacCliL )
                     ::oDbf:nImpArt    := nImpUFacCli( ::oFacCliT:cAlias, ::oFacCliL:cAlias, ::nDecOut, ::nValDiv )
                     ::oDbf:nImpTot    := nImpLFacCli( ::oFacCliT:cAlias, ::oFacCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
                     ::oDbf:nIvaTot    := nIvaLFacCli( ::oFacCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
                     ::oDbf:nTotFin    := ::oDbf:nImpTot + ::oDbf:nIvaTot
                     ::oDbf:nPreMed    := ::oDbf:nImpTot / ::oDbf:nNumUni
                     ::oDbf:nTotCom    := nComLFacCli( ::oFacCliT:cAlias, ::oFacCliL:cAlias, ::nDecOut, ::nDerOut )

                     ::oDbf:Save()

                  else

                     //Acumulamos

                     ::oDbf:Load()

                     ::oDbf:nNumCaj    += ::oFacCliL:nCanEnt
                     ::oDbf:nUniDad    := ::oFacCliL:nUniCaja
                     ::oDbf:nNumUni    += nTotNFacCli( ::oFacCliL )
                     ::oDbf:nImpTot    += nImpLFacCli( ::oFacCliT:cAlias, ::oFacCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
                     ::oDbf:nIvaTot    += nIvaLFacCli( ::oFacCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
                     ::oDbf:nTotFin    += nImpLFacCli( ::oFacCliT:cAlias, ::oFacCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
                     ::oDbf:nTotFin    += nIvaLFacCli( ::oFacCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
                     ::oDbf:nPreMed    := ::oDbf:nImpTot / ::oDbf:nNumUni
                     ::oDbf:nTotCom    += nComLFacCli( ::oFacCliT:cAlias, ::oFacCliL:cAlias, ::nDecOut, ::nDerOut )

                     ::oDbf:Save()

                  end if

               end if

               ::oFacCliL:Skip()

            end while

         end if

      end if

      ::oFacCliT:Skip()

      ::oMtrInf:AutoInc()

   end while

   ::oFacCliT:IdxDelete( cCurUsr(), GetFileNoExt( ::oFacCliT:cFile ) )
   ::oFacCliL:IdxDelete( cCurUsr(), GetFileNoExt( ::oFacCliL:cFile ) )

   /*
   comenzamos con las rectificativas
   */

   ::oFacRecT:OrdSetFocus( "dFecFac" )
   ::oFacRecL:OrdSetFocus( "nNumFac" )

   //Cabeceras de las facturas

   do case
      case ::oEstado:nAt == 1
         cExpHead    := '!lLiquidada .and. dFecFac >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecFac <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'
      case ::oEstado:nAt == 2
         cExpHead    := 'lLiquidada .and. dFecFac >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecFac <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'
      case ::oEstado:nAt == 3
         cExpHead    := 'dFecFac >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecFac <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'
   end case

   if !::lAgeAll
      cExpHead       += ' .and. cCodAge >= "' + Rtrim( ::cAgeOrg ) + '" .and. cCodAge <= "' + Rtrim( ::cAgeDes ) + '"'
   end if

   if !Empty( ::oFilter:cExpresionFilter )
      cExpHead       += ' .and. ' + ::oFilter:cExpresionFilter
   end if

   ::oFacRecT:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oFacRecT:cFile ), ::oFacRecT:OrdKey(), ( cExpHead ), , , , , , , , .t. )

   ::oMtrInf:SetTotal( ::oFacRecT:OrdKeyCount() )

   // Líneas de las facturas

   cExpLine          := '!lControl .and. !lTotLin'

   if !::lAllArt
      cExpLine       += ' .and. cRef >= "' + Rtrim( ::cArtOrg ) + '" .and. cRef <= "' + Rtrim( ::cArtDes ) + '"'
   end if

   ::oFacRecL:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oFacRecL:cFile ), ::oFacRecL:OrdKey(), cAllTrimer( cExpLine ), , , , , , , , .t. )

   ::oFacRecT:GoTop()

   while !::lBreak .and. !::oFacRecT:Eof()

      if lChkSer( ::oFacRecT:cSerie, ::aSer )

         if ::oFacRecL:Seek( ::oFacRecT:cSerie + Str( ::oFacRecT:nNumFac ) + ::oFacRecT:cSufFac )

            while ::oFacRecT:cSerie + Str( ::oFacRecT:nNumFac ) + ::oFacRecT:cSufFac == ::oFacRecL:cSerie + Str( ::oFacRecL:nNumFac ) + ::oFacRecL:cSufFac .AND. ! ::oFacRecL:eof()

               if !( ::lExcCero .and. nTotNFacRec( ::oFacRecL:cAlias ) == 0 ) .and.;
                  !( ::lExcImp .and. nImpLFacRec( ::oFacRecT:cAlias, ::oFacRecL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv ) == 0 )

                  if !::oDbf:Seek( ::oFacRecT:cCodAge + ::oFacRecL:cRef )

                     //Añadimos

                     ::oDbf:Append()

                     ::oDbf:cCodAge    := ::oFacRecT:cCodAge
                     ::oDbf:cNomAge    := AllTrim( oRetFld( ::oFacRecT:cCodAge, ::oDbfAge, "CAPEAGE" ) ) + ", " + AllTrim( oRetFld( ::oFacRecT:cCodAge, ::oDbfAge, "CNBRAGE" ) )
                     ::oDbf:cCodArt    := ::oFacRecL:cRef
                     ::oDbf:cNomArt    := ::oFacRecL:cDetalle
                     ::oDbf:nNumCaj    := ::oFacRecL:nCanEnt
                     ::oDbf:nUniDad    := ::oFacRecL:nUniCaja
                     ::oDbf:nNumUni    := nTotNFacRec( ::oFacRecL )
                     ::oDbf:nImpArt    := nImpUFacRec( ::oFacRecT:cAlias, ::oFacRecL:cAlias, ::nDecOut, ::nValDiv )
                     ::oDbf:nImpTot    := nImpLFacRec( ::oFacRecT:cAlias, ::oFacRecL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
                     ::oDbf:nIvaTot    := nIvaLFacRec( ::oFacRecL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
                     ::oDbf:nTotFin    := ::oDbf:nImpTot + ::oDbf:nIvaTot
                     ::oDbf:nPreMed    := ::oDbf:nImpTot / ::oDbf:nNumUni
                     ::oDbf:nTotCom    := nComLFacRec( ::oFacRecT:cAlias, ::oFacRecL:cAlias, ::nDecOut, ::nDerOut )

                     ::oDbf:Save()

                  else

                     //Acumulamos

                     ::oDbf:Load()

                     ::oDbf:nNumCaj    += ::oFacRecL:nCanEnt
                     ::oDbf:nUniDad    := ::oFacRecL:nUniCaja
                     ::oDbf:nNumUni    += nTotNFacRec( ::oFacRecL )
                     ::oDbf:nImpTot    += nImpLFacRec( ::oFacRecT:cAlias, ::oFacRecL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
                     ::oDbf:nIvaTot    += nIvaLFacRec( ::oFacRecL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
                     ::oDbf:nTotFin    += nImpLFacRec( ::oFacRecT:cAlias, ::oFacRecL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
                     ::oDbf:nTotFin    += nIvaLFacRec( ::oFacRecL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
                     ::oDbf:nPreMed    := ::oDbf:nImpTot / ::oDbf:nNumUni
                     ::oDbf:nTotCom    += nComLFacRec( ::oFacRecT:cAlias, ::oFacRecL:cAlias, ::nDecOut, ::nDerOut )

                     ::oDbf:Save()

                  end if

               end if

               ::oFacRecL:Skip()

            end while

         end if

      end if

      ::oFacRecT:Skip()

      ::oMtrInf:AutoInc()

   end while

   ::oFacRecT:IdxDelete( cCurUsr(), GetFileNoExt( ::oFacRecT:cFile ) )
   ::oFacRecL:IdxDelete( cCurUsr(), GetFileNoExt( ::oFacRecL:cFile ) )

   ::oMtrInf:AutoInc( ::oFacCliT:Lastrec() )

   ::oDlg:Enable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//