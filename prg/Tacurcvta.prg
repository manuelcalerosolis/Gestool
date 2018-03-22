#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS TAcuRCVta FROM TInfGen

   DATA  oAlbCliT    AS OBJECT
   DATA  oAlbCliL    AS OBJECT
   DATA  oFacCliT    AS OBJECT
   DATA  oFacCliL    AS OBJECT
   DATA  oFacRecT    AS OBJECT
   DATA  oFacRecL    AS OBJECT
   DATA  oTikCliT    AS OBJECT
   DATA  oTikCliL    AS OBJECT
   DATA  lIncEsc     AS LOGIC         INIT .f.
   DATA  lAllCp      AS LOGIC         INIT .t.
   DATA  cCPOrg      AS CHARACTER     INIT "00000"
   DATA  cCPDes      AS CHARACTER     INIT "99999"

   METHOD Create ()

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHOD lResource( cFld )

   METHOD lGenerate()

END CLASS

//---------------------------------------------------------------------------//

METHOD Create()

   ::AddField( "cCodPos", "C",  5, 0, {|| "@!" },           "Cod. Pos",      .f., "Código postal"     ,           14, .f. )
   ::AddField( "cPobCli", "C", 25, 0, {|| "@!" },           "Población",     .f., "Población"         ,           14, .f. )
   ::AddField( "cCodCli", "C", 12, 0, {|| "@!" },           "Cod. Cli",      .f., "Código cliente"    ,           14, .f. )
   ::AddField( "cNomCli", "C",100, 0, {|| "@!" },           "Cliente",       .f., "Nombre cliente"    ,           14, .f. )
   ::AddField( "cCodArt", "C", 18, 0, {|| "@!" },           "Cod. Art",      .t., "Código artículo"         ,           14, .f. )
   ::AddField( "cNomArt", "C",100, 0, {|| "@!" },           "Artículo",      .t., "Artículo"          ,           35, .f. )
   ::AddField( "nNumCaj", "N", 16, 6, {|| MasUnd() },       cNombreCajas(),  .f., cNombreCajas()      ,           12, .f. )
   ::AddField( "nUniDad", "N", 16, 6, {|| MasUnd() },       cNombreUnidades(),.f.,cNombreUnidades()   ,           12, .f. )
   ::AddField( "nNumUni", "N", 16, 6, {|| MasUnd() },       "Tot. " + cNombreUnidades(),.t., "Total " + cNombreUnidades(), 12, .t. )
   ::AddField( "nImpArt", "N", 16, 6, {|| ::cPicImp },      "Precio",        .f., "Precio"            ,           12, .f. )
   ::AddField( "nPntVer", "N", 16, 6, {|| ::cPicImp },      "Pnt. ver.",     .f., "Punto verde"       ,           10, .f. )
   ::AddField( "nTotPVer","N", 16, 6, {|| ::cPicPnt },      "Tot. p.v.",     .f., "Total punto verde" ,           10, .t. )
   ::AddField( "nImpTrn", "N", 16, 6, {|| ::cPicImp },      "Portes",        .f., "Portes"            ,           10, .f. )
   ::AddField( "nTotTrn", "N", 16, 6, {|| ::cPicImp },      "Tot. trn.",     .f., "Total transporte"  ,           10, .t. )
   ::AddField( "nImpTot", "N", 16, 6, {|| ::cPicOut },      "Base",          .t., "Base"              ,           12, .t. )
   ::AddField( "nTotPes", "N", 16, 6, {|| MasUnd() },       "Tot. peso",     .f., "Total peso"        ,           12, .t. )
   ::AddField( "nPreKgr", "N", 16, 6, {|| ::cPicImp },      "Pre. peso",     .f., "Precio peso"       ,           12, .f. )
   ::AddField( "nTotVol", "N", 16, 6, {|| MasUnd() },       "Tot. volumen",  .f., "Total volumen"     ,           12, .t. )
   ::AddField( "nPreVol", "N", 16, 6, {|| ::cPicImp },      "Pre. vol.",     .f., "Precio volumen"    ,           12, .f. )
   ::AddField( "nPreMed", "N", 16, 6, {|| ::cPicImp },      "Pre. med.",     .t., "Precio medio"      ,           12, .f. )
   ::AddField( "nIvaTot", "N", 16, 6, {|| ::cPicOut },      "Tot. " + cImp(),   .t., "Total " + cImp()      ,           12, .t. )
   ::AddField( "nTotFin", "N", 16, 6, {|| ::cPicOut },      "Total",         .t., "Total"             ,           12, .t. )
   ::AddField( "nDtoEsp", "N",  6, 2, {|| '@E 99.99' },     "%Dto.1",        .f., "Primer porcetaje descuento",    6, .f. )
   ::AddField( "nDpp",    "N",  6, 2, {|| '@E 99.99' },     "%Dto.2",        .f., "Segundo porcentaje descuento",  6, .t. )
   ::AddField( "nDtoUno", "N",  6, 2, {|| '@E 99.99' },     "%Dto.3",        .f., "Tercer porcentaje descuento",   6, .t. )
   ::AddField( "nDtoDos", "N",  6, 2, {|| '@E 99.99' },     "%Dto.4",        .f., "Cuarto porcentaje descuento",   6, .t. )
   ::AddField( "cPerCto", "C", 30, 0, {|| '@!' },           "Contacto",      .f., "Contacto",                     15, .f. )
   ::AddField( "Telefono","C", 20, 0, {|| '@!' },           "Telefono",      .f., "Telefono",                     15, .f. )
   ::AddField( "Fax",     "C", 20, 0, {|| '@!' },           "Fax",           .f., "Fax",                          15, .f. )
   ::AddField( "Movil",   "C", 20, 0, {|| '@!' },           "Movil",         .f., "Movil",                        15,   .f. )
   ::AddField( "mObserv", "M", 10, 0, {|| '@!' },           "Observ.",       .f., "Observaciones",                15,   .f. )

   ::AddTmpIndex( "CCODART", "CCODPOS + CCODCLI + CCODART" )

   ::AddGroup( {|| ::oDbf:cCodPos }, {|| "Cod.Postal  : " + Rtrim( ::oDbf:cCodPos ) + "-" + Rtrim( ::oDbf:cPobCli ) }, {||"Total código postal..."} )
   ::AddGroup( {|| ::oDbf:cCodPos + ::oDbf:cCodCli  }, {|| "Cliente : " + Rtrim( ::oDbf:cCodCli ) + "-" + Rtrim( ::oDbf:cNomCli ) }, {|| "Total cliente..." } )

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD OpenFiles() CLASS TAcuRCVta

   local lOpen    := .t.
   local oBlock   := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

   DATABASE NEW ::oTikCliT PATH ( cPatEmp() ) FILE "TIKET.DBF"    VIA ( cDriver() ) SHARED INDEX "TIKET.CDX"

   DATABASE NEW ::oTikCliL PATH ( cPatEmp() ) FILE "TIKEL.DBF"    VIA ( cDriver() ) SHARED INDEX "TIKEL.CDX"

   ::oAlbCliT := TDataCenter():oAlbCliT()

   DATABASE NEW ::oAlbCliL PATH ( cPatEmp() ) FILE "ALBCLIL.DBF"  VIA ( cDriver() ) SHARED INDEX "ALBCLIL.CDX"

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

METHOD CloseFiles() CLASS TAcuRCVta

   if !Empty( ::oTikCliT ) .and. ::oTikCliT:Used()
   ::oTikCliT:End()
   end if
   if !Empty( ::oTikCliL ) .and. ::oTikCliL:Used()
   ::oTikCliL:End()
   end if
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
   if !Empty( ::oAlbCliT ) .and. ::oAlbCliT:Used()
   ::oAlbCliT:End()
   end if
   if !Empty( ::oAlbCliL ) .and. ::oAlbCliL:Used()
   ::oAlbCliL:End()
   end if

   ::oTikCliT := nil
   ::oTikCliL := nil
   ::oFacCliT := nil
   ::oFacCliL := nil
   ::oFacRecT := nil
   ::oFacRecL := nil
   ::oAlbCliT := nil
   ::oAlbCliL := nil

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD lResource( cFld ) CLASS TAcuRCVta

   local oCPOrg
   local oCPDes
   local oIncEsc

   if !::StdResource( "INFACUARTC" )
      return .f.
   end if

   /*
   Monta los articulos de manera automatica
   */

   REDEFINE CHECKBOX ::lAllCP ;
      ID       800 ;
      OF       ::oFld:aDialogs[1]

   REDEFINE GET oCPOrg VAR ::cCPOrg;
      ID       70 ;
      WHEN     ( !::lAllCP );
      PICTURE  "99999" ;
      OF       ::oFld:aDialogs[1]

   REDEFINE GET oCPDes VAR ::cCPDes;
      ID       90 ;
      WHEN     ( !::lAllCP );
      PICTURE  "99999" ;
      OF       ::oFld:aDialogs[1]

   ::oDefCliInf( 110, 120, 130, 140, , 600 )

   if !::lDefArtInf( 150, 151, 160, 161, 700 )
      return .f.
   end if

   REDEFINE CHECKBOX oIncEsc VAR ::lIncEsc;
      ID       190 ;
      OF       ::oFld:aDialogs[1]

   ::oDefExcInf( 210 )
   ::oDefExcImp( 211 )

   ::lExcCero := .f.

   ::CreateFilter( , ::oDbf, .t. )

RETURN .t.

//---------------------------------------------------------------------------//
/*
Esta funcion crea la base de datos para generar posteriormente el informe
*/

METHOD lGenerate() CLASS TAcuRCVta

   local cExpHead := ""
   local cExpLine := ""

   ::oDlg:Disable()
   ::oBtnCancel:Enable()
   ::oDbf:Zap()

   ::aHeader      := {  {|| "Fecha     : " + Dtoc( Date() ) },;
                        {|| "Periodo   : " + Dtoc( ::dIniInf ) + " > " + Dtoc( ::dFinInf ) },;
                        {|| "C. postal : " + if( ::lAllCp, "Todos", AllTrim( ::cCpOrg ) + " > " + AllTrim( ::cCpDes ) ) },;
                        {|| "Clientes  : " + if( ::lAllCli, "Todos", AllTrim( ::cCliOrg ) + " > " + AllTrim( ::cCliDes ) ) },;
                        {|| "Artículos : " + if( ::lAllArt, "Todos", AllTrim( ::cArtOrg ) + " > " + AllTrim (::cArtDes ) ) } }
   /*
   Albaranes-------------------------------------------------------------------
   */

   ::oAlbCliT:OrdSetFocus( "dFecAlb" )
   ::oAlbCliL:OrdSetFocus( "nNumAlb" )

   ::oMtrInf:cText   := "Filtrando albaranes..."

   cExpHead          := 'nFacturado < 3 .and. dFecAlb >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecAlb <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'

   if !::lAllCp
      cExpHead       += ' .and. cPosCli >= "' + Rtrim( ::cCpOrg ) + '" .and. cPosCli <= "' + Rtrim( ::cCpDes ) + '"'
   end if

   if !::lAllCli
      cExpHead       += ' .and. cCodCli >= "' + Rtrim( ::cCliOrg ) + '" .and. cCodCli <= "' + Rtrim( ::cCliDes ) + '"'
   end if

   if !Empty( ::oFilter:cExpresionFilter ) 
      cExpHead       += ' .and. ' + ::oFilter:cExpresionFilter
   end if

   ::oAlbCliT:AddTmpIndex( Auth():Codigo(), GetFileNoExt( ::oAlbCliT:cFile ), ::oAlbCliT:OrdKey(), ( cExpHead ), , , , , , , , .t. )

   ::oMtrInf:cText   := "Filtrando lineas de albaranes..."
   ::oMtrInf:SetTotal( ::oAlbCliT:OrdKeyCount() )

   /*
   Lineas de albaranes
   */

   cExpLine          := '!lControl .and. !lTotLin'

   if !::lAllArt
      cExpLine       += ' .and. cRef >= "' + ::cArtOrg + '" .and. cRef <= "' + ::cArtDes + '"'
   end if

   if !::lIncEsc
      cExpLine       += ' .and. !lKitChl'
   end if

   ::oAlbCliL:AddTmpIndex( Auth():Codigo(), GetFileNoExt( ::oAlbCliL:cFile ), ::oAlbCliL:OrdKey(), cAllTrimer( cExpLine ), , , , , , , , .t. )

   ::oMtrInf:cText   := "Procesando albaranes"

   ::oAlbCliT:GoTop()

   while !::lBreak .and. !::oAlbCliT:Eof()

     if lChkSer( ::oAlbCliT:cSerAlb, ::aSer ) .and. ::oAlbCliL:Seek( ::oAlbCliT:cSerAlb + Str( ::oAlbCliT:nNumAlb ) + ::oAlbCliT:cSufAlb )

        while ::oAlbCliT:cSerAlb + Str( ::oAlbCliT:nNumAlb ) + ::oAlbCliT:cSufAlb == ::oAlbCliL:cSerAlb + Str( ::oAlbCliL:nNumAlb ) + ::oAlbCliL:cSufAlb .AND. ! ::oAlbCliL:eof()

           if !( ::lExcCero .and. nTotNAlbCli( ::oAlbCliL ) == 0 )   .AND.;
              !( ::lExcImp .and. nImpLAlbCli( ::oAlbCliT:cAlias, ::oAlbCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv ) == 0 )

               if !::oDbf:Seek( ::oAlbCliT:cPosCli + ::oAlbCliT:cCodCli + ::oAlbCliL:cRef  )

                  ::oDbf:Append()

                  ::oDbf:cCodPos    := ::oAlbCliT:cPosCli
                  ::oDbf:cPobCli    := ::oAlbCliT:cPobCli
                  ::oDbf:cCodCli    := ::oAlbCliT:cCodCli
                  ::oDbf:cNomCli    := ::oAlbCliT:cNomCli

                  ::oDbf:nDtoEsp    := oRetFld( ::oAlbCliT:cCodCli, ::oDbfCli, "nDtoEsp" )
                  ::oDbf:nDpp       := oRetFld( ::oAlbCliT:cCodCli, ::oDbfCli, "nDpp" )
                  ::oDbf:nDtoUno    := oRetFld( ::oAlbCliT:cCodCli, ::oDbfCli, "nDtoCnt" )
                  ::oDbf:nDtoDos    := oRetFld( ::oAlbCliT:cCodCli, ::oDbfCli, "nDtoRap" )
                  ::oDbf:cPerCto    := oRetFld( ::oAlbCliT:cCodCli, ::oDbfCli, "cPerCto" )
                  ::oDbf:Telefono   := oRetFld( ::oAlbCliT:cCodCli, ::oDbfCli, "Telefono" )
                  ::oDbf:Fax        := oRetFld( ::oAlbCliT:cCodCli, ::oDbfCli, "Fax" )
                  ::oDbf:Movil      := oRetFld( ::oAlbCliT:cCodCli, ::oDbfCli, "Movil" )
                  ::oDbf:mObserv    := oRetFld( ::oAlbCliT:cCodCli, ::oDbfCli, "MCOMENT" )

                  ::oDbf:cCodArt    := ::oAlbCliL:cRef
                  ::oDbf:cNomArt    := descrip( ::oAlbCliL:cAlias ) //::oAlbCliL:cDetalle
                  ::oDbf:nNumCaj    := ::oAlbCliL:nCanEnt
                  ::oDbf:nUniDad    := ::oAlbCliL:nUniCaja
                  ::oDbf:nNumUni    := nTotNAlbCli( ::oAlbCliL )
                  ::oDbf:nImpArt    := nTotUAlbCli( ::oAlbCliL:cAlias, ::nDecOut, ::nValDiv )
                  ::oDbf:nImpTrn    := nTrnUAlbCli( ::oAlbCliL:cAlias, ::nDecOut, ::nValDiv )
                  ::oDbf:nPntVer    := nPntUAlbCli( ::oAlbCliL:cAlias, ::nDecOut, ::nValDiv )
                  ::oDbf:nImpTot    := nImpLAlbCli( ::oAlbCliT:cAlias, ::oAlbCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
                  ::oDbf:nIvaTot    := nIvaLAlbCli( ::oAlbCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
                  ::oDbf:nTotFin    := ::oDbf:nImpTot + ::oDbf:nIvaTot
                  ::AcuPesVol( ::oAlbCliL:cRef, nTotNAlbCli( ::oAlbCliL ), ::oDbf:nImpTot, .f. )

                  ::oDbf:Save()

               else

                  ::oDbf:Load()

                  ::oDbf:nNumCaj    += ::oAlbCliL:nCanEnt
                  ::oDbf:nUniDad    += ::oAlbCliL:nUniCaja
                  ::oDbf:nNumUni    += nTotNAlbCli( ::oAlbCliL )
                  ::oDbf:nImpArt    += nTotUAlbCli( ::oAlbCliL:cAlias, ::nDecOut, ::nValDiv )
                  ::oDbf:nImpTrn    += nTrnUAlbCli( ::oAlbCliL:cAlias, ::nDecOut, ::nValDiv )
                  ::oDbf:nPntVer    += nPntUAlbCli( ::oAlbCliL:cAlias, ::nDecOut, ::nValDiv )
                  ::oDbf:nImpTot    += nImpLAlbCli( ::oAlbCliT:cAlias, ::oAlbCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
                  ::oDbf:nPreMed    := ::oDbf:nImpTot / ::oDbf:nNumUni
                  ::oDbf:nIvaTot    += nIvaLAlbCli( ::oAlbCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
                  ::oDbf:nTotFin    += nImpLAlbCli( ::oAlbCliT:cAlias, ::oAlbCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
                  ::oDbf:nTotFin    += nIvaLAlbCli( ::oAlbCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )

                  ::AcuPesVol( ::oAlbCliL:cRef, nTotNAlbCli( ::oAlbCliL ), ::oDbf:nImpTot, .t. )

                  ::oDbf:Save()

               end if

           end if

           ::oAlbCliL:Skip()

        end while

     end if

     ::oAlbCliT:Skip()

     ::oMtrInf:AutoInc()

   end while

   ::oMtrInf:AutoInc( ::oAlbCliT:Lastrec() )

   ::oAlbCliT:IdxDelete( Auth():Codigo(), GetFileNoExt( ::oAlbCliT:cFile ) )

   ::oAlbCliL:IdxDelete( Auth():Codigo(), GetFileNoExt( ::oAlbCliL:cFile ) )

   /*
   Facturas--------------------------------------------------------------------
   */

   ::oFacCliT:OrdSetFocus( "dFecFac" )
   ::oFacCliL:OrdSetFocus( "nNumFac" )

   ::oMtrInf:cText   := "Filtrando facturas..."
   cExpHead          := 'dFecFac >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecFac <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'

   if !::lAllCp
      cExpHead       += ' .and. cPosCli >= "' + Rtrim( ::cCpOrg ) + '" .and. cPosCli <= "' + Rtrim( ::cCpDes ) + '"'
   end if

   if !::lAllCli
      cExpHead       += ' .and. cCodCli >= "' + Rtrim( ::cCliOrg ) + '" .and. cCodCli <= "' + Rtrim( ::cCliDes ) + '"'
   end if

   if !Empty( ::oFilter:cExpresionFilter )
      cExpHead       += ' .and. ' + ::oFilter:cExpresionFilter
   end if

   ::oFacCliT:AddTmpIndex( Auth():Codigo(), GetFileNoExt( ::oFacCliT:cFile ), ::oFacCliT:OrdKey(), ( cExpHead ), , , , , , , , .t. )

   ::oMtrInf:cText   := "Filtrando lineas de facturas..."
   ::oMtrInf:SetTotal( ::oFacCliT:OrdKeyCount() )

   /*
   Lineas de albaranes
   */

   cExpLine          := '!lControl .and. !lTotLin'

   if !::lAllArt
      cExpLine       += ' .and. cRef >= "' + ::cArtOrg + '" .and. cRef <= "' + ::cArtDes + '"'
   end if

   if !::lIncEsc
      cExpLine       += ' .and. !lKitChl'
   end if

   ::oFacCliL:AddTmpIndex( Auth():Codigo(), GetFileNoExt( ::oFacCliL:cFile ), ::oFacCliL:OrdKey(), cAllTrimer( cExpLine ), , , , , , , , .t. )

   ::oMtrInf:cText   := "Procesando facturas"

   ::oFacCliT:GoTop()
   while !::lBreak .and. !::oFacCliT:Eof()

     if lChkSer( ::oFacCliT:cSerie, ::aSer ) .and. ::oFacCliL:Seek( ::oFacCliT:cSerie + Str( ::oFacCliT:nNumFac ) + ::oFacCliT:cSufFac )

        while ::oFacCliT:cSerie + Str( ::oFacCliT:nNumFac ) + ::oFacCliT:cSufFac == ::oFacCliL:cSerie + Str( ::oFacCliL:nNumFac ) + ::oFacCliL:cSufFac .AND. ! ::oFacCliL:eof()

           if !( ::lExcCero .and. nTotNFacCli( ::oFacCliL ) == 0 )      .AND.;
              !( ::lExcImp .and. nImpLFacCli( ::oFacCliT:cAlias, ::oFacCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv ) == 0 )

              if !::oDbf:Seek( ::oFacCliT:cPosCli + ::oFacCliT:cCodCli + ::oFacCliL:cRef )

                  ::oDbf:Append()

                  ::oDbf:cCodPos    := ::oFacCliT:cPosCli
                  ::oDbf:cPobCli    := ::oFacCliT:cPobCli
                  ::oDbf:cCodCli    := ::oFacCliT:cCodCli
                  ::oDbf:cNomCli    := ::oFacCliT:cNomCli

                  ::oDbf:nDtoEsp    := oRetFld( ::oFacCliT:cCodCli, ::oDbfCli, "nDtoEsp" )
                  ::oDbf:nDpp       := oRetFld( ::oFacCliT:cCodCli, ::oDbfCli, "nDpp" )
                  ::oDbf:nDtoUno    := oRetFld( ::oFacCliT:cCodCli, ::oDbfCli, "nDtoCnt" )
                  ::oDbf:nDtoDos    := oRetFld( ::oFacCliT:cCodCli, ::oDbfCli, "nDtoRap" )
                  ::oDbf:cPerCto    := oRetFld( ::oFacCliT:cCodCli, ::oDbfCli, "cPerCto" )
                  ::oDbf:Telefono   := oRetFld( ::oFacCliT:cCodCli, ::oDbfCli, "Telefono" )
                  ::oDbf:Fax        := oRetFld( ::oFacCliT:cCodCli, ::oDbfCli, "Fax" )
                  ::oDbf:Movil      := oRetFld( ::oFacCliT:cCodCli, ::oDbfCli, "Movil" )
                  ::oDbf:mObserv    := oRetFld( ::oFacCliT:cCodCli, ::oDbfCli, "MCOMENT" )

                  ::oDbf:cCodArt    := ::oFacCliL:cRef
                  ::oDbf:cNomArt    := Descrip( ::oFacCliL:cAlias )//::oFacCliL:cDetalle
                  ::oDbf:nNumCaj    := ::oFacCliL:nCanEnt
                  ::oDbf:nUniDad    := ::oFacCliL:nUniCaja
                  ::oDbf:nNumUni    := nTotNFacCli( ::oFacCliL )
                  ::oDbf:nImpArt    := nImpUFacCli( ::oFacCliT:cAlias,  ::oFacCliL:cAlias, ::nDecOut, ::nValDiv )
                  ::oDbf:nImpTrn    := nTrnUFacCli( ::oFacCliL:cAlias, ::nDecOut, ::nValDiv )
                  ::oDbf:nPntVer    := nPntUFacCli( ::oFacCliL:cAlias, ::nDecOut, ::nValDiv )
                  ::oDbf:nTotTrn    := nTrnLFacCli( ::oFacCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
                  ::oDbf:nTotPVer   := nPntLFacCli( ::oFacCliL:cAlias, ::nDecOut, ::nValDiv )
                  ::oDbf:nImpTot    := nImpLFacCli( ::oFacCliT:cAlias, ::oFacCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
                  ::oDbf:nIvaTot    := nIvaLFacCli( ::oFacCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
                  ::oDbf:nPreMed    := ::oDbf:nImpTot / ::oDbf:nNumUni
                  ::oDbf:nTotFin    := ::oDbf:nImpTot + ::oDbf:nIvaTot
                  ::AcuPesVol( ::oFacCliL:cRef, nTotNFacCli( ::oFacCliL ), ::oDbf:nImpTot, .f. )

                  ::oDbf:Save()

               else

                  ::oDbf:Load()

                  ::oDbf:nNumCaj    += ::oFacCliL:nCanEnt
                  ::oDbf:nUniDad    += ::oFacCliL:nUniCaja
                  ::oDbf:nNumUni    += nTotNFacCli( ::oFacCliL )
                  ::oDbf:nImpArt    += nImpUFacCli( ::oFacCliT:cAlias, ::oFacCliL:cAlias, ::nDecOut, ::nValDiv )
                  ::oDbf:nImpTrn    := nTrnUFacCli( ::oFacCliL:cAlias, ::nDecOut, ::nValDiv )
                  ::oDbf:nPntVer    := nPntUFacCli( ::oFacCliL:cAlias, ::nDecOut, ::nValDiv )
                  ::oDbf:nTotTrn    += nTrnLFacCli( ::oFacCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
                  ::oDbf:nTotPVer   += nPntLFacCli( ::oFacCliL:cAlias, ::nDecOut, ::nValDiv )
                  ::oDbf:nImpTot    += nImpLFacCli( ::oFacCliT:cAlias, ::oFacCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
                  ::oDbf:nPreMed    := ::oDbf:nImpTot / ::oDbf:nNumUni
                  ::oDbf:nIvaTot    += nIvaLFacCli( ::oFacCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
                  ::oDbf:nTotFin    += nImpLFacCli( ::oFacCliT:cAlias, ::oFacCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
                  ::oDbf:nTotFin    += nIvaLFacCli( ::oFacCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
                  ::AcuPesVol( ::oFacCliL:cRef, nTotNFacCli( ::oFacCliL ), ::oDbf:nImpTot, .t. )

                  ::oDbf:Save()

               end if

           end if

           ::oFacCliL:Skip()

        end while

     end if

     ::oFacCliT:Skip()

     ::oMtrInf:AutoInc()

   end while

   ::oMtrInf:AutoInc( ::oFacCliT:Lastrec() )

   ::oFacCliT:IdxDelete( Auth():Codigo(), GetFileNoExt( ::oFacCliT:cFile ) )

   ::oFacCliL:IdxDelete( Auth():Codigo(), GetFileNoExt( ::oFacCliL:cFile ) )

   /*
   Facturas rectificativas-----------------------------------------------------
   */

   ::oFacRecT:OrdSetFocus( "dFecFac" )
   ::oFacRecL:OrdSetFocus( "nNumFac" )

   ::oMtrInf:cText   := "Filtrando fac. rec."
   cExpHead          := 'dFecFac >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecFac <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'

   if !::lAllCp
      cExpHead       += ' .and. cPosCli >= "' + Rtrim( ::cCpOrg ) + '" .and. cPosCli <= "' + Rtrim( ::cCpDes ) + '"'
   end if

   if !::lAllCli
      cExpHead       += ' .and. cCodCli >= "' + Rtrim( ::cCliOrg ) + '" .and. cCodCli <= "' + Rtrim( ::cCliDes ) + '"'
   end if

   if !Empty( ::oFilter:cExpresionFilter )
      cExpHead       += ' .and. ' + ::oFilter:cExpresionFilter 
   end if

   ::oFacRecT:AddTmpIndex( Auth():Codigo(), GetFileNoExt( ::oFacRecT:cFile ), ::oFacRecT:OrdKey(), ( cExpHead ), , , , , , , , .t. )

   ::oMtrInf:cText   := "Filtrando líneas de fac. rec."
   ::oMtrInf:SetTotal( ::oFacRecT:OrdKeyCount() )

   /*
   Lineas de albaranes
   */

   cExpLine          := '!lControl .and. !lTotLin'

   if !::lAllArt
      cExpLine       += ' .and. cRef >= "' + ::cArtOrg + '" .and. cRef <= "' + ::cArtDes + '"'
   end if

   if !::lIncEsc
      cExpLine       += ' .and. !lKitChl'
   end if

   ::oFacRecL:AddTmpIndex( Auth():Codigo(), GetFileNoExt( ::oFacRecL:cFile ), ::oFacRecL:OrdKey(), cAllTrimer( cExpLine ), , , , , , , , .t. )

   ::oMtrInf:cText   := "Procesando fac. rec."

   ::oFacRecT:GoTop()
   while !::lBreak .and. !::oFacRecT:Eof()

     if lChkSer( ::oFacRecT:cSerie, ::aSer ) .and. ::oFacRecL:Seek( ::oFacRecT:cSerie + Str( ::oFacRecT:nNumFac ) + ::oFacRecT:cSufFac )

        while ::oFacRecT:cSerie + Str( ::oFacRecT:nNumFac ) + ::oFacRecT:cSufFac == ::oFacRecL:cSerie + Str( ::oFacRecL:nNumFac ) + ::oFacRecL:cSufFac .AND. ! ::oFacRecL:eof()

            if !( ::lExcCero .and. nTotNFacRec( ::oFacRecL ) == 0 )     .AND.;
               !( ::lExcImp .and. nImpLFacRec( ::oFacRecT:cAlias, ::oFacRecL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv ) == 0 )

               if !::oDbf:Seek( ::oFacRecT:cPosCli + ::oFacRecT:cCodCli + ::oFacRecL:cRef )

                  ::oDbf:Append()

                  ::oDbf:cCodPos    := ::oFacRecT:cPosCli
                  ::oDbf:cPobCli    := ::oFacRecT:cPobCli
                  ::oDbf:cCodCli    := ::oFacRecT:cCodCli
                  ::oDbf:cNomCli    := ::oFacRecT:cNomCli

                  ::oDbf:nDtoEsp    := oRetFld( ::oFacRecT:cCodCli, ::oDbfCli, "nDtoEsp" )
                  ::oDbf:nDpp       := oRetFld( ::oFacRecT:cCodCli, ::oDbfCli, "nDpp" )
                  ::oDbf:nDtoUno    := oRetFld( ::oFacRecT:cCodCli, ::oDbfCli, "nDtoCnt" )
                  ::oDbf:nDtoDos    := oRetFld( ::oFacRecT:cCodCli, ::oDbfCli, "nDtoRap" )
                  ::oDbf:cPerCto    := oRetFld( ::oFacRecT:cCodCli, ::oDbfCli, "cPerCto" )
                  ::oDbf:Telefono   := oRetFld( ::oFacRecT:cCodCli, ::oDbfCli, "Telefono" )
                  ::oDbf:Fax        := oRetFld( ::oFacRecT:cCodCli, ::oDbfCli, "Fax" )
                  ::oDbf:Movil      := oRetFld( ::oFacRecT:cCodCli, ::oDbfCli, "Movil" )
                  ::oDbf:mObserv    := oRetFld( ::oFacRecT:cCodCli, ::oDbfCli, "MCOMENT" )

                  ::oDbf:cCodArt    := ::oFacRecL:cRef
                  ::oDbf:cNomArt    := Descrip( ::oFacRecL:cAlias )//::oFacRecL:cDetalle
                  ::oDbf:nNumCaj    := ::oFacRecL:nCanEnt
                  ::oDbf:nUniDad    := ::oFacRecL:nUniCaja
                  ::oDbf:nNumUni    := nTotNFacRec( ::oFacRecL )
                  ::oDbf:nImpArt    := nImpUFacRec( ::oFacRecT:cAlias, ::oFacRecL:cAlias, ::nDecOut, ::nValDiv )
                  ::oDbf:nImpTrn    := nTrnUFacRec( ::oFacRecL:cAlias, ::nDecOut, ::nValDiv )
                  ::oDbf:nPntVer    := nPntUFacRec( ::oFacRecL:cAlias, ::nDecOut, ::nValDiv )
                  ::oDbf:nTotTrn    := nTrnLFacRec( ::oFacRecL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
                  ::oDbf:nTotPVer   := nPntLFacRec( ::oFacRecL:cAlias, ::nDecOut, ::nValDiv )
                  ::oDbf:nImpTot    := nImpLFacRec( ::oFacRecT:cAlias, ::oFacRecL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
                  ::oDbf:nIvaTot    := nIvaLFacRec( ::oFacRecL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
                  ::oDbf:nTotFin    := ::oDbf:nImpTot + ::oDbf:nIvaTot
                  ::AcuPesVol( ::oFacRecL:cRef, nTotNFacRec( ::oFacRecL ), ::oDbf:nImpTot, .f. )

                  ::oDbf:Save()

               else

                  ::oDbf:Load()

                  ::oDbf:nNumCaj    += ::oFacRecL:nCanEnt
                  ::oDbf:nUniDad    += ::oFacRecL:nUniCaja
                  ::oDbf:nNumUni    += nTotNFacRec( ::oFacRecL )
                  ::oDbf:nImpArt    += nImpUFacRec( ::oFacRecT:cAlias, ::oFacRecL:cAlias, ::nDecOut, ::nValDiv )
                  ::oDbf:nImpTrn    := nTrnUFacRec( ::oFacRecL:cAlias, ::nDecOut, ::nValDiv )
                  ::oDbf:nPntVer    := nPntUFacRec( ::oFacRecL:cAlias, ::nDecOut, ::nValDiv )
                  ::oDbf:nTotTrn    += nTrnLFacRec( ::oFacRecL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
                  ::oDbf:nTotPVer   += nPntLFacRec( ::oFacRecL:cAlias, ::nDecOut, ::nValDiv )
                  ::oDbf:nImpTot    += nImpLFacRec( ::oFacRecT:cAlias, ::oFacRecL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
                  ::oDbf:nPreMed    := ::oDbf:nImpTot / ::oDbf:nNumUni
                  ::oDbf:nIvaTot    += nIvaLFacRec( ::oFacRecL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
                  ::oDbf:nTotFin    += nImpLFacRec( ::oFacRecT:cAlias, ::oFacRecL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
                  ::oDbf:nTotFin    += nIvaLFacRec( ::oFacRecL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )

                  ::AcuPesVol( ::oFacRecL:cRef, nTotNFacRec( ::oFacRecL ), ::oDbf:nImpTot, .t. )

                  ::oDbf:Save()

               end if

           end if

           ::oFacRecL:Skip()

        end while

     end if

     ::oFacRecT:Skip()

     ::oMtrInf:AutoInc()

   end while

   ::oMtrInf:AutoInc( ::oFacRecT:Lastrec() )

   ::oFacRecT:IdxDelete( Auth():Codigo(), GetFileNoExt( ::oFacRecT:cFile ) )

   ::oFacRecL:IdxDelete( Auth():Codigo(), GetFileNoExt( ::oFacRecL:cFile ) )

   /*
   Tikets ---------------------------------------------------------------------
   */

   ::oTikCliT:OrdSetFocus( "dFecTik" )
   ::oTikCliL:OrdSetFocus( "cNumTil" )

   ::oMtrInf:cText   := "Filtrando tikets..."

   /*
   Cabeceras de tikets creamos el indice sobre la cabecera
   */

   cExpHead          := 'dFecTik >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecTik <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'

   cExpHead          += ' .and. ( cTipTik == "1" .or. cTipTik == "4" )'

   if !::lAllCp
      cExpHead       += ' .and. cPosCli >= "' + Rtrim( ::cCpOrg ) + '" .and. cPosCli <= "' + Rtrim( ::cCpDes ) + '"'
   end if

   if !::lAllCli
      cExpHead       += ' .and. cCliTik >= "' + Rtrim( ::cCliOrg ) + '" .and. cCliTik <= "' + Rtrim( ::cCliDes ) + '"'
   end if

   if !Empty( ::oFilter:cExpresionFilter )
      cExpHead       += ' .and. ' + ::oFilter:cExpresionFilter 
   end if

   ::oTikCliT:AddTmpIndex( Auth():Codigo(), GetFileNoExt( ::oTikCliT:cFile ), ::oTikCliT:OrdKey(), ( cExpHead ), , , , , , , , .t. )

   ::oMtrInf:cText   := "Filtrando lineas de tikets..."
   ::oMtrInf:SetTotal( ::oTikCliT:OrdKeyCount() )

   /*
   Lineas de tikets
   */

   cExpLine          := '!lControl .and. '

   if !::lIncEsc
      cExpLine       += '!lKitChl .and. '
   end if

   if ::lAllArt
      cExpLine       += '(!Empty( cCbaTil ) .or. !Empty( cComTil ))'
   else
      cExpLine       += '( ( !Empty( cCbaTil ) .and. cCbaTil >= "' + ::cArtOrg + '" .and. cCbaTil <= "' + ::cArtDes + '" )'
      cExpLine       += ' .or. '
      cExpLine       += '( !Empty( cComTil ) .and. cComTil >= "' + ::cArtOrg + '" .and. cComTil <= "' + ::cArtDes + '" ) )'
   end if

   ::oTikCliL:AddTmpIndex( Auth():Codigo(), GetFileNoExt( ::oTikCliL:cFile ), ::oTikCliL:OrdKey(), cAllTrimer( cExpLine ), , , , , , , , .t. )

   ::oMtrInf:cText   := "Procesando tikets"

   ::oTikCliT:GoTop()
   while !::lBreak .and. !::oTikCliT:Eof()

      if lChkSer( ::oTikCliT:cSerTik, ::aSer ) .and. ::oTikCliL:Seek( ::oTikCliT:cSerTik + ::oTikCliT:cNumTik + ::oTikCliT:cSufTik )

         while ::oTikCliT:cSerTik + ::oTikCliT:cNumTik + ::oTikCliT:cSufTik == ::oTikCliL:cSerTil + ::oTikCliL:cNumTil + ::oTikCliL:cSufTil .and. !::oTikCliL:Eof()

            if !Empty( ::oTikCliL:cCbaTil )                       .AND.;
               !( ::lExcCero .AND. ::oTikCliL:nUntTil == 0 )      .AND.;
               !( ::lExcImp .AND. ::oTikCliL:nPvpTil == 0 )

               if !::oDbf:Seek( ::oTikCliT:cPosCli + ::oTikCliT:cCliTik + ::oTikCliL:cCbaTil )

                  ::oDbf:Append()

                  ::oDbf:cCodPos       := ::oTikCliT:cPosCli
                  ::oDbf:cPobCli       := ::oTikCLiT:cPobCli
                  ::oDbf:cCodCli       := ::oTikCliT:cCliTik
                  ::oDbf:cNomCli       := ::oTikCliT:cNomTik

                  ::oDbf:nDtoEsp       := oRetFld( ::oTikCliT:cCliTik, ::oDbfCli, "nDtoEsp" )
                  ::oDbf:nDpp          := oRetFld( ::oTikCliT:cCliTik, ::oDbfCli, "nDpp" )
                  ::oDbf:nDtoUno       := oRetFld( ::oTikCliT:cCliTik, ::oDbfCli, "nDtoCnt" )
                  ::oDbf:nDtoDos       := oRetFld( ::oTikCliT:cCliTik, ::oDbfCli, "nDtoRap" )
                  ::oDbf:cPerCto       := oRetFld( ::oTikCliT:cCliTik, ::oDbfCli, "cPerCto" )
                  ::oDbf:Telefono      := oRetFld( ::oTikCliT:cCliTik, ::oDbfCli, "Telefono" )
                  ::oDbf:Fax           := oRetFld( ::oTikCliT:cCliTik, ::oDbfCli, "Fax" )
                  ::oDbf:Movil         := oRetFld( ::oTikCliT:cCliTik, ::oDbfCli, "Movil" )
                  ::oDbf:mObserv       := oRetFld( ::oTikCliT:cCliTik, ::oDbfCli, "MCOMENT" )


                  ::oDbf:cCodArt       := ::oTikCliL:cCbaTil
                  ::oDbf:cNomArt       := RetArticulo( ::oTikCliL:cCbaTil, ::oDbfArt )

                  if ::oTikCliT:cTipTik == "4"
                     ::oDbf:nNumUni    := - ::oTikCliL:nUntTil
                  else
                    ::oDbf:nNumUni     := ::oTikCliL:nUntTil
                  end if

                  ::oDbf:nImpArt       := nImpUTpv( ::oTikCliT, ::oTikCliL, ::nDecOut, ::nValDiv, nil, 1 )
                  ::oDbf:nImpTot       := nImpLTpv( ::oTikCliT, ::oTikCliL, ::nDecOut, ::nDerOut, ::nValDiv, nil, 1 )
                  ::oDbf:nIvaTot       := nIvaLTpv( ::oTikCliT, ::oTikCliL, ::nDecOut, ::nDerOut, ::nValDiv, 1 )
                  ::oDbf:nTotFin       := ::oDbf:nImpTot + ::oDbf:nIvaTot
                  ::AcuPesVol( ::oTikCliL:cCbaTil, ::oTikCliL:nUntTil, ::oDbf:nImpTot, .f. )

                  ::oDbf:Save()

               else

                  ::oDbf:Load()

                  if ::oTikCliT:cTipTik == "4"
                     ::oDbf:nNumUni     -= ::oTikCliL:nUntTil
                  else
                     ::oDbf:nNumUni     += ::oTikCliL:nUntTil
                  end if

                  ::oDbf:nImpArt       += nImpUTpv( ::oTikCliT, ::oTikCliL, ::nDecOut, ::nValDiv, nil, 1 )
                  ::oDbf:nImpTot       += nImpLTpv( ::oTikCliT, ::oTikCliL, ::nDecOut, ::nDerOut, ::nValDiv, nil, 1 )
                  ::oDbf:nIvaTot       += nIvaLTpv( ::oTikCliT, ::oTikCliL, ::nDecOut, ::nDerOut, ::nValDiv, 1 )
                  ::oDbf:nTotFin       := ::oDbf:nImpTot + ::oDbf:nIvaTot
                  ::AcuPesVol( ::oTikCliL:cCbaTil, ::oTikCliL:nUntTil, ::oDbf:nImpTot, .t. )

                  ::oDbf:Save()

               end if

            end if

            if !Empty( ::oTikCliL:cComTil )                       .AND.;
               !( ::lExcCero .AND. ::oTikCliL:nUntTil == 0 )      .AND.;
               !( ::lExcCero .AND. ::oTikCliL:nPcmTil == 0 )

               if !::oDbf:Seek( ::oTikCliT:cPosCli + ::oTikCliT:cCliTik + ::oTikCliL:cComTil )

                  ::oDbf:Append()

                  ::oDbf:cCodPos       := ::oTikCliT:cPosCli
                  ::oDbf:cPobCli       := ::oTikCLiT:cPobCli
                  ::oDbf:cCodCli       := ::oTikCliT:cCliTik
                  ::oDbf:cNomCli       := ::oTikCliT:cNomTik

                  ::oDbf:nDtoEsp       := oRetFld( ::oTikCliT:cCliTik, ::oDbfCli, "nDtoEsp" )
                  ::oDbf:nDpp          := oRetFld( ::oTikCliT:cCliTik, ::oDbfCli, "nDpp" )
                  ::oDbf:nDtoUno       := oRetFld( ::oTikCliT:cCliTik, ::oDbfCli, "nDtoCnt" )
                  ::oDbf:nDtoDos       := oRetFld( ::oTikCliT:cCliTik, ::oDbfCli, "nDtoRap" )
                  ::oDbf:cPerCto       := oRetFld( ::oTikCliT:cCliTik, ::oDbfCli, "cPerCto" )
                  ::oDbf:Telefono      := oRetFld( ::oTikCliT:cCliTik, ::oDbfCli, "Telefono" )
                  ::oDbf:Fax           := oRetFld( ::oTikCliT:cCliTik, ::oDbfCli, "Fax" )
                  ::oDbf:Movil         := oRetFld( ::oTikCliT:cCliTik, ::oDbfCli, "Movil" )
                  ::oDbf:mObserv       := oRetFld( ::oTikCliT:cCliTik, ::oDbfCli, "MCOMENT" )

                  ::oDbf:cCodArt       := ::oTikCliL:cComTil
                  ::oDbf:cNomArt       := RetArticulo( ::oTikCliL:cComTil, ::oDbfArt )

                  if ::oTikCliT:cTipTik == "4"
                     ::oDbf:nNumUni    := - ::oTikCliL:nUntTil
                  else
                    ::oDbf:nNumUni     := ::oTikCliL:nUntTil
                  end if

                  ::oDbf:nImpArt       := nImpUTpv( ::oTikCliT, ::oTikCliL, ::nDecOut, ::nValDiv, nil, 2 )
                  ::oDbf:nImpTot       := nImpLTpv( ::oTikCliT, ::oTikCliL, ::nDecOut, ::nDerOut, ::nValDiv, nil, 2 )
                  ::oDbf:nIvaTot       := nIvaLTpv( ::oTikCliT, ::oTikCliL, ::nDecOut, ::nDerOut, ::nValDiv, 2 )
                  ::oDbf:nTotFin       := ::oDbf:nImpTot + ::oDbf:nIvaTot
                  ::AcuPesVol( ::oTikCliL:cComTil, ::oTikCliL:nUntTil, ::oDbf:nImpTot, .f. )

                  ::oDbf:Save()

               else

                  ::oDbf:Load()

                  if ::oTikCliT:cTipTik == "4"
                     ::oDbf:nNumUni     -= ::oTikCliL:nUntTil
                  else
                     ::oDbf:nNumUni     += ::oTikCliL:nUntTil
                  end if

                  ::oDbf:nImpArt       += nImpUTpv( ::oTikCliT, ::oTikCliL, ::nDecOut, ::nValDiv, nil, 2 )
                  ::oDbf:nImpTot       += nImpLTpv( ::oTikCliT, ::oTikCliL, ::nDecOut, ::nDerOut, ::nValDiv, nil, 2 )
                  ::oDbf:nIvaTot       += nIvaLTpv( ::oTikCliT, ::oTikCliL, ::nDecOut, ::nDerOut, ::nValDiv, 2 )
                  ::oDbf:nTotFin       := ::oDbf:nImpTot + ::oDbf:nIvaTot
                  ::AcuPesVol( ::oTikCliL:cComTil, ::oTikCliL:nUntTil, ::oDbf:nImpTot, .t. )

                  ::oDbf:Save()

               end if

            end if

            ::oTikCliL:Skip()

         end while

      end if

      ::oTikCliT:Skip()

      ::oMtrInf:AutoInc()

   end while

   ::oTikCliT:IdxDelete( Auth():Codigo(), GetFileNoExt( ::oTikCliT:cFile ) )

   ::oTikCliL:IdxDelete( Auth():Codigo(), GetFileNoExt( ::oTikCliL:cFile ) )

   ::oMtrInf:AutoInc( ::oTikCliT:Lastrec() )

   ::oDlg:Enable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//