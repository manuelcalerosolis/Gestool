#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS TPdtCobPob FROM TInfGen

   DATA  oEstado     AS OBJECT
   DATA  aEstado     AS ARRAY    INIT { "Pendientes", "Cobradas", "Todas" }
   DATA  oFacCliT    AS OBJECT
   DATA  oFacCliL    AS OBJECT
   DATA  oFacRecT    AS OBJECT
   DATA  oFacRecL    AS OBJECT
   DATA  oFacCliP    AS OBJECT
   DATA  oAntCliT    AS OBJECT
   DATA  oDbfIva     AS OBJECT
   DATA  lAllCP      AS LOGIC    INIT .t.
   DATA  cCPOrg      AS CHARACTER     INIT "00000"
   DATA  cCPDes      AS CHARACTER     INIT "99999"

   METHOD Create()

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHOD lResource( cFld )

   METHOD lGenerate()

END CLASS

//---------------------------------------------------------------------------//

METHOD Create()

   ::AddField ( "CCODCLI", "C", 12, 0, {|| "@!" },         "Código",                    .f., "Código cliente"            ,  8, .f. )
   ::AddField ( "CNOMCLI", "C", 50, 0, {|| "@!" },         "Cliente",                   .t., "Nombre cliente"            , 25, .f. )
   ::AddField ( "CDOCMOV", "C", 18, 0, {|| "@!" },         "Factura",                   .t., "Factura"                   , 14, .f. )
   ::AddField ( "DFECMOV", "D",  8, 0, {|| "@!" },         "Fecha",                     .t., "Fecha"                     , 14, .f. )
   ::AddField ( "CNIFCLI", "C", 15, 0, {|| "@!" },         "Nif",                       .f., "Nif"                       ,  8, .f. )
   ::AddField ( "CDOMCLI", "C", 35, 0, {|| "@!" },         "Dom",                       .f., "Domicilio"                 , 25, .f. )
   ::AddField ( "CPOBCLI", "C", 25, 0, {|| "@!" },         "Pob",                       .f., "Población"                 , 20, .f. )
   ::AddField ( "CPROCLI", "C", 20, 0, {|| "@!" },         "Prov",                      .f., "Provincia"                 , 20, .f. )
   ::AddField ( "CCDPCLI", "C",  7, 0, {|| "@!" },         "CP",                        .f., "Cod. Postal"               , 20, .f. )
   ::AddField ( "CTLFCLI", "C", 12, 0, {|| "@!" },         "Tlf",                       .f., "Teléfono"                  ,  7, .f. )
   ::AddField ( "COBRCLI", "C", 10, 0, {|| "@!" },         "Dirección",                      .f., "Código dirección"               , 12, .f. )
   ::AddField ( "NTOTDOC", "N", 16, 3, {|| ::cPicOut },    "Tot. Fac",                  .t., "Total factura"             , 10, .t. )
   ::AddField ( "NTOTCOB", "N", 16, 3, {|| ::cPicOut },    "Tot. Cob",                  .t., "Total cobrado"             , 10, .t. )
   ::AddField ( "NTOTPEN", "N", 16, 3, {|| ::cPicOut },    "Tot. Pen",                  .t., "Total pendiente"           , 10, .t. )
   ::AddField ( "CTIPVEN", "C", 20, 0, {|| "@!" },         "Venta",                     .f., "Tipo de venta"             , 15, .f. )

   ::AddTmpIndex ( "CCDPCLI", "CCDPCLI + CCODCLI" )

   ::AddGroup( {|| ::oDbf:cCdpCli }, {|| "Código postal : " + Rtrim( ::oDbf:cCdpCli )  }, {||"Total código postal..."} )

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD OpenFiles()

   local lOpen    := .t.
   local oBlock   := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

   ::oFacCliT     := TDataCenter():oFacCliT()

   DATABASE NEW ::oFacCliL  PATH ( cPatEmp() ) FILE  "FACCLIL.DBF" VIA ( cDriver() ) SHARED INDEX "FACCLIL.CDX"

   DATABASE NEW ::oFacRecT  PATH ( cPatEmp() ) FILE  "FACRECT.DBF" VIA ( cDriver() ) SHARED INDEX "FACRECT.CDX"

   DATABASE NEW ::oFacRecL  PATH ( cPatEmp() ) FILE  "FACRECL.DBF" VIA ( cDriver() ) SHARED INDEX "FACRECL.CDX"

   ::oFacCliP := TDataCenter():oFacCliP()

   DATABASE NEW ::oDbfIva   PATH ( cPatDat() ) FILE  "TIVA.DBF"    VIA ( cDriver() ) SHARED INDEX "TIVA.CDX"

   DATABASE NEW ::oAntCliT  PATH ( cPatEmp() ) FILE  "ANTCLIT.DBF" VIA ( cDriver() ) SHARED INDEX "ANTCLIT.CDX"

   RECOVER

      msgStop( "Imposible abrir todas las bases de datos" )
      ::CloseFiles()
      lOpen          := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD CloseFiles()

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
   if !Empty( ::oFacCliP ) .and. ::oFacCliP:Used()
      ::oFacCliP:End()
   end if
   if !Empty( ::oDbfIva ) .and. ::oDbfIva:Used()
      ::oDbfIva:End()
   end if
   if !Empty( ::oAntCliT ) .and. ::oAntCliT:Used()
      ::oAntCliT:End()
   end if

   ::oFacCliP := nil
   ::oAntCliT := nil
   ::oDbfIva  := nil
   ::oFacCliT := nil
   ::oFacCliL := nil
   ::oFacRecT := nil
   ::oFacRecL := nil

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD lResource( cFld )

   local cEstado := "Pendientes"
   local oCPOrg
   local oCPDes

   if !::StdResource( "INF_GEN16C" )
      return .f.
   end if

   REDEFINE CHECKBOX ::lAllCP ;
      ID       800 ;
      OF       ::oFld:aDialogs[1]

   REDEFINE GET oCPOrg VAR ::cCPOrg;
      ID       801 ;
      WHEN     ( !::lAllCP );
      PICTURE  "99999" ;
      OF       ::oFld:aDialogs[1]

   REDEFINE GET oCPDes VAR ::cCPDes;
      ID       802 ;
      WHEN     ( !::lAllCP );
      PICTURE  "99999" ;
      OF       ::oFld:aDialogs[1]

   if !::oDefCliInf( 70, 80, 90, 100, , 600 )
      return .f.
   end if

   REDEFINE COMBOBOX ::oEstado ;
      VAR      cEstado ;
      ID       218 ;
      ITEMS    ::aEstado;
      OF       ::oFld:aDialogs[1]

   ::oMtrInf:SetTotal( ::oFacCliT:Lastrec() )

   ::CreateFilter( aItmFacCli(), ::oFacCliT:cAlias )

RETURN .t.

//---------------------------------------------------------------------------//
/*
Esta funcion crea la base de datos para generar posteriormente el informe
*/

METHOD lGenerate()

   local nTotFacCli     := 0
   local nPagFacCli     := 0
   local cExpHead       := ""
   local nTotFacRec     := 0
   local nPagFacRec     := 0

   ::oDlg:Disable()
   ::oBtnCancel:Enable()
   ::oDbf:Zap()

   ::aHeader   := {  {|| "Fecha     : " + Dtoc( Date() ) },;
                     {|| "Periodo   : " + Dtoc( ::dIniInf ) + " > " + Dtoc( ::dFinInf ) },;
                     {|| "Cliente   : " + if( ::lAllCli, "Todos", AllTrim( ::cCliOrg ) + " > " + AllTrim( ::cCliDes ) ) },;
                     {|| "C. postal : " + if( ::lAllCp, "Todos", AllTrim( ::cCpOrg ) + " > " + AllTrim( ::cCpDes ) ) },;
                     {|| "Estado    : " + ::aEstado[ ::oEstado:nAt ] } }

   ::oFacCliT:OrdSetFocus( "dFecFac" )

   do case
      case ::oEstado:nAt == 1
         cExpHead    := '!lLiquidada .and. dFecFac >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecFac <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'
      case ::oEstado:nAt == 2
         cExpHead    := 'lLiquidada .and. dFecFac >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecFac <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'
      case ::oEstado:nAt == 3
         cExpHead    := 'dFecFac >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecFac <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'
   end case

   if !::lAllCli
      cExpHead       += ' .and. cCodCli >= "' + Rtrim( ::cCliOrg ) + '" .and. cCodCli <= "' + Rtrim( ::cCliDes ) + '"'
   end if

   if !::lAllCp
      cExpHead       += ' .and. cPosCli >= "' + Rtrim( ::cCpOrg ) + '" .and. cPosCli <= "' + Rtrim( ::cCpDes ) + '"'
   end if

   if !Empty( ::oFilter:cExpresionFilter )
      cExpHead       += ' .and. ' + ::oFilter:cExpresionFilter
   end if

   ::oFacCliT:AddTmpIndex( Auth():Codigo(), GetFileNoExt( ::oFacCliT:cFile ), ::oFacCliT:OrdKey(), ( cExpHead ), , , , , , , , .t. )

   ::oMtrInf:SetTotal( ::oFacCliT:OrdKeyCount() )

   ::oFacCliT:GoTop()

   while !::lBreak .and. !::oFacCliT:Eof()

      if lChkSer( ::oFacCliT:CSERIE, ::aSer )

         nTotFacCli  := nTotFacCli( ::oFacCliT:cSerie + Str( ::oFacCliT:nNumFac ) + ::oFacCliT:cSufFac, ::oFacCliT:cAlias, ::oFacCliL:cAlias, ::oDbfIva:cAlias, ::oDbfDiv:cAlias, ::oFacCliP:cAlias, ::oAntCliT:cAlias )
         nPagFacCli  := nPagFacCli( ::oFacCliT:cSerie + Str( ::oFacCliT:nNumFac ) + ::oFacCliT:cSufFac, ::oFacCliT:cAlias, ::oFacCliP:cAlias, ::oDbfIva:cAlias, ::oDbfDiv:cAlias )

         ::oDbf:Append()

         ::oDbf:dFecMov := ::oFacCliT:DFecFac
         ::oDbf:nTotDoc := nTotFacCli
         ::oDbf:cDocMov := lTrim ( ::oFacCliT:cSerie ) + "/" + lTrim ( Str( ::oFacCliT:nNumFac ) ) + "/" + lTrim ( ::oFacCliT:cSufFac )

         // Datos del cliente en cuestion

         ::AddCliente( ::oFacCliT:cCodCli, ::oFacCliT, .f. )

         ::oDbf:nTotCob := nPagFacCli
         ::oDbf:nTotPen := nTotFacCli - nPagFacCli
         ::oDbf:Save()

      end if

      ::oFacCliT:Skip()

      ::oMtrInf:AutoInc()

   end while

   ::oFacCliT:IdxDelete( Auth():Codigo(), GetFileNoExt( ::oFacCliT:cFile ) )

   /*
   comenzamos con las rectificativas
   */

   ::oFacRecT:OrdSetFocus( "dFecFac" )

   do case
      case ::oEstado:nAt == 1
         cExpHead    := '!lLiquidada .and. dFecFac >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecFac <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'
      case ::oEstado:nAt == 2
         cExpHead    := 'lLiquidada .and. dFecFac >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecFac <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'
      case ::oEstado:nAt == 3
         cExpHead    := 'dFecFac >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecFac <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'
   end case

   if !::lAllCli
      cExpHead       += ' .and. cCodCli >= "' + Rtrim( ::cCliOrg ) + '" .and. cCodCli <= "' + Rtrim( ::cCliDes ) + '"'
   end if

   if !::lAllCp
      cExpHead       += ' .and. cPosCli >= "' + Rtrim( ::cCpOrg ) + '" .and. cPosCli <= "' + Rtrim( ::cCpDes ) + '"'
   end if

   if !Empty( ::oFilter:cExpresionFilter )
      cExpHead       += ' .and. ' + ::oFilter:cExpresionFilter
   end if

   ::oFacRecT:AddTmpIndex( Auth():Codigo(), GetFileNoExt( ::oFacRecT:cFile ), ::oFacRecT:OrdKey(), ( cExpHead ), , , , , , , , .t. )

   ::oMtrInf:SetTotal( ::oFacRecT:OrdKeyCount() )

   ::oFacRecT:GoTop()

   while !::lBreak .and. !::oFacRecT:Eof()

      if lChkSer( ::oFacRecT:cSerie, ::aSer )

         nTotFacRec  := nTotFacRec( ::oFacRecT:cSerie + Str( ::oFacRecT:nNumFac ) + ::oFacRecT:cSufFac, ::oFacRecT:cAlias, ::oFacRecL:cAlias, ::oDbfIva:cAlias, ::oDbfDiv:cAlias )
         nPagFacRec  := nPagFacRec( ::oFacRecT:cSerie + Str( ::oFacRecT:nNumFac ) + ::oFacRecT:cSufFac, ::oFacRecT:cAlias, ::oFacCliP:cAlias, ::oDbfIva:cAlias, ::oDbfDiv:cAlias )

         ::oDbf:Append()

         ::oDbf:dFecMov := ::oFacRecT:dFecFac
         ::oDbf:nTotDoc := nTotFacRec
         ::oDbf:cDocMov := lTrim ( ::oFacRecT:cSerie ) + "/" + lTrim ( Str( ::oFacRecT:nNumFac ) ) + "/" + lTrim ( ::oFacRecT:cSufFac )

         // Datos del cliente en cuestion

         ::AddCliente( ::oFacRecT:cCodCli, ::oFacRecT, .f. )

         ::oDbf:nTotCob := nPagFacRec
         ::oDbf:nTotPen := nTotFacRec - nPagFacRec
         ::oDbf:Save()

      end if

      ::oFacRecT:Skip()

      ::oMtrInf:AutoInc()

   end while

   ::oFacRecT:IdxDelete( Auth():Codigo(), GetFileNoExt( ::oFacRecT:cFile ) )

   ::oMtrInf:AutoInc( ::oFacRecT:LastRec() )

   ::oDlg:Enable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//