#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS TInfFacT FROM TInfGen

   DATA  lResumen    AS LOGIC    INIT .f.
   DATA  lExcCero    AS LOGIC    INIT .f.
   DATA  lIncEsc     AS LOGIC    INIT .f.
   DATA  oEstado     AS OBJECT
   DATA  oFacCliT    AS OBJECT
   DATA  oFacCliL    AS OBJECT
   DATA  oFacRecT    AS OBJECT
   DATA  oFacRecL    AS OBJECT
    
   DATA  oOrden      AS OBJECT
   DATA  aEstado     AS ARRAY    INIT  { "Pendientes", "Cobradas", "Todas" }

   METHOD create()

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHOD lResource( cFld )

   METHOD lGenerate()

END CLASS

//---------------------------------------------------------------------------//

METHOD Create()

   ::AddField( "cNumDoc",   "C", 14, 0, {|| "@!" },        "Doc",            .f., "Documento",                    8,    .f. )
   ::AddField( "dFecDoc",   "D",  8, 0, {|| "@!" },        "Fecha",          .f., "Fecha del documento",          10,   .f. )
   ::AddField( "cCodCli",   "C", 12, 0, {|| "@!" },        "Cliente",        .f., "Cod. cliente",                 8,    .f. )
   ::AddField( "cNomCli",   "C", 50, 0, {|| "@!" },        "Nombre",         .f., "Nom. cliente",                 8,    .f. )
   ::AddField( "cCodObr",   "C", 12, 0, {|| "@!" },        "Dirección",           .f., "Cod. dirección",                    8,    .f. )
   ::AddField( "cEstado",   "C", 12, 0, {|| "@!" },        "Estado",         .f., "Estado del doc.",              10,   .f. )
   ::AddField( "cCodArt",   "C", 18, 0, {|| "@!" },        "Cod.",           .t., "Cod. artículo",                10,   .f. )
   ::AddField( "cNomArt",   "C",100, 0, {|| "@!" },        "Artículo",       .t., "Nom. artículo",                40,   .f. )
   ::FldPropiedades()
   ::AddField( "nCajas",    "N", 16, 6, {|| ::cPicOut },   cNombreCajas(),   .f., cNombreCajas(),                 12,   .f. )
   ::AddField( "nUnidades", "N", 16, 6, {|| ::cPicOut },   cNombreUnidades(),.f., cNombreUnidades(),              12,   .f. )
   ::AddField( "nUniCaj",   "N", 16, 6, {|| ::cPicOut },   "Tot. " + cNombreUnidades(), .t., "Total " + cNombreUnidades(), 12, .f. )
   ::AddField( "nPreArt",   "N", 16, 6, {|| ::cPicOut },   "Precio",         .t., "Precio artículo",              12,   .f. )
   ::AddField( "nBase",     "N", 16, 6, {|| ::cPicOut },   "Base",           .t., "Base",                         12,   .t. )
   ::AddField( "nIva",      "N", 16, 6, {|| ::cPicOut },   cImp(),            .t., cImp(),                          12,   .t. )
   ::AddField( "nTotal",    "N", 16, 6, {|| ::cPicOut },   "Total",          .t., "Total",                        12,   .t. )
   ::AddField( "nDtoEsp",   "N",  6, 2, {|| '@E 99.99' },  "%Dto.1",         .f., "Primer porcetaje descuento",   6,    .f. )
   ::AddField( "nDpp",      "N",  6, 2, {|| '@E 99.99' },  "%Dto.2",         .f., "Segundo porcentaje descuento", 6,    .t. )
   ::AddField( "nDtoUno",   "N",  6, 2, {|| '@E 99.99' },  "%Dto.3",         .f., "Tercer porcentaje descuento",  6,    .t. )
   ::AddField( "nDtoDos",   "N",  6, 2, {|| '@E 99.99' },  "%Dto.4",         .f., "Cuarto porcentaje descuento",  6,    .t. )
   ::AddField( "cPerCto",   "C", 30, 0, {|| '@!' },        "Contacto",       .f., "Contacto",                     15,   .f. )
   ::AddField( "Telefono",  "C", 20, 0, {|| '@!' },        "Telefono",       .f., "Telefono",                     15,   .f. )
   ::AddField( "Fax",       "C", 20, 0, {|| '@!' },        "Fax",            .f., "Fax",                          15,   .f. )
   ::AddField( "Movil",     "C", 20, 0, {|| '@!' },        "Movil",          .f., "Movil",                        15,   .f. )
   ::AddField( "mObserv",   "M", 10, 0, {|| '@!' },        "Observ.",        .f., "Observaciones",                15,   .f. )

   ::AddTmpIndex( "cNumDoc", "cNumDoc" )
   ::AddTmpIndex( "dFecDoc", "dTos(dFecDoc)" )

   ::AddGroup( {|| ::oDbf:cNumDoc }, {|| "Factura: " + Rtrim( ::oDbf:cNumDoc )+ " - " + Dtoc( ::oDbf:dFecDoc ) + " Cliente:" + Rtrim( ::oDbf:cCodCli ) + "-" + Rtrim( ::oDbf:cNomCli ) + if( !Empty( ::oDbf:cCodObr), " Obra:" + Rtrim( ::oDbf:cCodObr ) , " " ) + " E:" + RTrim( ::oDbf:cEstado ) }, {|| Space(1) } )

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD OpenFiles()

   local lOpen    := .t.
   local oBlock   := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

   ::oFacCliT := TDataCenter():oFacCliT()

   DATABASE NEW ::oFacCliL PATH ( cPatEmp() ) FILE "FACCLIL.DBF" VIA ( cDriver() ) SHARED INDEX "FACCLIL.CDX"

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

   ::oFacCliT := nil
   ::oFacCliL := nil
   ::oFacRecT := nil
   ::oFacRecL := nil

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD lResource ( cFld )

   local cOrden  := "Número"
   local cEstado := "Todas"
   local oIncEsc

   if !::StdResource( "INFFACTURA" )
      return .f.
   end if

   /*
   Monta los almacenes de manera automatica
   */

   if !::oDefCliInf( 70, 71, 80, 81, , 910 )
      return .f.
   end if

   REDEFINE CHECKBOX oIncEsc VAR ::lIncEsc;
      ID       600 ;
      OF       ::oFld:aDialogs[1]

   REDEFINE COMBOBOX ::oOrden ;
      VAR      cOrden ;
      ID       217 ;
      ITEMS    { "Número", "Fecha" } ;
      OF       ::oFld:aDialogs[1]

   REDEFINE COMBOBOX ::oEstado ;
      VAR      cEstado ;
      ID       218 ;
      ITEMS    ::aEstado ;
      OF       ::oFld:aDialogs[1]

   /*
   Damos valor al meter
   */

   ::oMtrInf:SetTotal( ::oFacCliT:Lastrec() )

   ::CreateFilter( aItmFacCli(), ::oFacCliT:cAlias )

RETURN .t.

//---------------------------------------------------------------------------//
/*
Esta funcion crea la base de datos para generar posteriormente el informe
*/

METHOD lGenerate()

   local cExpHead   := ""
   local cExpLine   := ""

   ::oDlg:Disable()
   ::oBtnCancel:Enable()
   ::oDbf:Zap()

   ::aHeader      := {  {|| "Fecha    : " + Dtoc( Date() ) },;
                        {|| "Periodo  : " + Dtoc( ::dIniInf ) + " > " + Dtoc( ::dFinInf ) },;
                        {|| "Clientes : " + if( ::lAllCli, "Todos", AllTrim( ::cCliOrg ) + " > " + AllTrim( ::cCliDes ) ) },;
                        {|| "Estado   : " + ::aEstado[ ::oEstado:nAt ] } }

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

   if !Empty( ::oFilter:cExpresionFilter )
      cExpHead       += ' .and. ' + ::oFilter:cExpresionFilter
   end if

   ::oFacCliT:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oFacCliT:cFile ), ::oFacCliT:OrdKey(), ( cExpHead ), , , , , , , , .t. )

   ::oMtrInf:SetTotal( ::oFacCliT:OrdKeyCount() )

   if !::lIncEsc
      cExpLine       := '!lKitChl'
   else
      cExpLine       := '.t.'
   end if

   ::oFacCliL:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oFacCliL:cFile ), ::oFacCliL:OrdKey(), cAllTrimer( cExpLine ), , , , , , , , .t. )

   ::oFacCliT:GoTop()

   while !::lBreak .and. !::oFacCliT:Eof()

      if lChkSer( ::oFacCliT:cSerie, ::aSer )

         if ::oFacCliL:Seek( ::oFacCliT:cSerie + Str( ::oFacCliT:nNumFac ) + ::oFacCliT:cSufFac )

            while ::oFacCliT:cSerie + Str( ::oFacCliT:nNumFac ) + ::oFacCliT:cSufFac == ::oFacCliL:cSerie + Str( ::oFacCliL:nNumFac ) + ::oFacCliL:cSufFac .AND. ! ::oFacCliL:eof()

               ::oDbf:Append()

               ::oDbf:cNumDoc       := AllTrim( ::oFacCliT:cSerie ) + "/" + AllTrim( Str( ::oFacCliT:nNumFac ) ) + "/" + AllTrim( ::oFacCliT:cSufFac )
               ::oDbf:dFecDoc       := ::oFacCliT:dFecFac
               ::oDbf:cCodCli       := ::oFacCliT:cCodCli
               ::oDbf:cNomCli       := ::oFacCliT:cNomCli
               ::oDbf:cCodObr       := ::oFacCliT:cCodObr
               do case
                  case !::oFacCliT:lLiquidada
                     ::oDbf:cEstado := "Pendiente"
                  case ::oFacCliT:lLiquidada
                     ::oDbf:cEstado := "Cobrada"
               end if

               ::oDbf:cCodArt       := ::oFacCliL:cRef
               ::oDbf:cNomArt       := Descrip( ::oFacCliL:cAlias )//::oFacCliL:cDetalle
               ::oDbf:cCodPr1       := ::oFacCliL:cCodPr1
               ::oDbf:cNomPr1       := retProp( ::oFacCliL:cCodPr1 )
               ::oDbf:cCodPr2       := ::oFacCliL:cCodPr2
               ::oDbf:cNomPr2       := retProp( ::oFacCliL:cCodPr2 )
               ::oDbf:cValPr1       := ::oFacCliL:cValPr1
               ::oDbf:cNomVl1       := retValProp( ::oFacCliL:cCodPr1 + ::oFacCliL:cValPr1 )
               ::oDbf:cValPr2       := ::oFacCliL:cValPr2
               ::oDbf:cNomVl2       := retValProp( ::oFacCliL:cCodPr2 + ::oFacCliL:cValPr2 )
               ::oDbf:nCajas        := ::oFacCliL:nCanEnt
               ::oDbf:nUnidades     := ::oFacCliL:nUniCaja
               ::oDbf:nUniCaj       := nTotNFacCli( ::oFacCliL )
               ::oDbf:nPreArt       := nTotUFacCli( ::oFacCliL:cAlias, ::nDecOut, ::nValDiv )
               ::oDbf:nBase         := nImpLFacCli( ::oFacCliT:cAlias, ::oFacCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv, , , .t., .t.  )
               ::oDbf:nIva          := nIvaLFacCli( ::oFacCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
               ::oDbf:nTotal        := ::oDbf:nBase + ::oDbf:nIva
               ::oDbf:nDtoEsp       := ::oFacCliT:nDtoEsp
               ::oDbf:nDpp          := ::oFacCliT:nDpp
               ::oDbf:nDtoUno       := ::oFacCliT:nDtoUno
               ::oDbf:nDtoDos       := ::oFacCliT:nDtoDos
               ::oDbf:cPerCto       := oRetFld( ::oFacCliT:cCodCli, ::oDbfCli, "cPerCto" )
               ::oDbf:Telefono      := oRetFld( ::oFacCliT:cCodCli, ::oDbfCli, "Telefono" )
               ::oDbf:Fax           := oRetFld( ::oFacCliT:cCodCli, ::oDbfCli, "Fax" )
               ::oDbf:Movil         := oRetFld( ::oFacCliT:cCodCli, ::oDbfCli, "Movil" )
               ::oDbf:mObserv       := oRetFld( ::oFacCliT:cCodCli, ::oDbfCli, "MCOMENT" )

               ::oDbf:Save()

               ::oFacCliL:Skip()

            end while

         end if

      end if

      ::oFacCliT:Skip()

      ::oMtrInf:AutoInc()

   end while

   ::oFacCliT:IdxDelete( cCurUsr(), GetFileNoExt( ::oFacCliT:cFile ) )
   ::oFacCliL:IdxDelete( cCurUsr(), GetFileNoExt( ::oFacCliL:cFile ) )
   ::oMtrInf:AutoInc( ::oFacCliT:LastRec() )

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

   if !Empty( ::oFilter:cExpresionFilter )
      cExpHead       += ' .and. ' + ::oFilter:cExpresionFilter
   end if

   ::oFacRecT:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oFacRecT:cFile ), ::oFacRecT:OrdKey(), ( cExpHead ), , , , , , , , .t. )

   ::oMtrInf:SetTotal( ::oFacRecT:OrdKeyCount() )

   if !::lIncEsc
      cExpLine       := '!lKitChl'
   else
      cExpLine       := '.t.'
   end if

   ::oFacRecL:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oFacRecL:cFile ), ::oFacRecL:OrdKey(), cAllTrimer( cExpLine ), , , , , , , , .t. )

   ::oFacRecT:GoTop()

   while !::lBreak .and. !::oFacRecT:Eof()

      if lChkSer( ::oFacRecT:cSerie, ::aSer )

         if ::oFacRecL:Seek( ::oFacRecT:cSerie + Str( ::oFacRecT:nNumFac ) + ::oFacRecT:cSufFac )

            while ::oFacRecT:cSerie + Str( ::oFacRecT:nNumFac ) + ::oFacRecT:cSufFac == ::oFacRecL:cSerie + Str( ::oFacRecL:nNumFac ) + ::oFacRecL:cSufFac .AND. ! ::oFacRecL:eof()

               ::oDbf:Append()

               ::oDbf:cNumDoc       := AllTrim( ::oFacRecT:cSerie ) + "/" + AllTrim( Str( ::oFacRecT:nNumFac ) ) + "/" + AllTrim( ::oFacRecT:cSufFac )
               ::oDbf:dFecDoc       := ::oFacRecT:dFecFac
               ::oDbf:cCodCli       := ::oFacRecT:cCodCli
               ::oDbf:cNomCli       := ::oFacRecT:cNomCli
               ::oDbf:cCodObr       := ::oFacRecT:cCodObr
               do case
                  case !::oFacRecT:lLiquidada
                     ::oDbf:cEstado := "Pendiente"
                  case ::oFacRecT:lLiquidada
                     ::oDbf:cEstado := "Cobrada"
               end if
               ::oDbf:cCodArt       := ::oFacRecL:cRef
               ::oDbf:cNomArt       := ::oFacRecL:cDetalle
               ::oDbf:cCodPr1       := ::oFacRecL:cCodPr1
               ::oDbf:cNomPr1       := retProp( ::oFacRecL:cCodPr1 )
               ::oDbf:cCodPr2       := ::oFacRecL:cCodPr2
               ::oDbf:cNomPr2       := retProp( ::oFacRecL:cCodPr2 )
               ::oDbf:cValPr1       := ::oFacRecL:cValPr1
               ::oDbf:cNomVl1       := retValProp( ::oFacRecL:cCodPr1 + ::oFacRecL:cValPr1 )
               ::oDbf:cValPr2       := ::oFacRecL:cValPr2
               ::oDbf:cNomVl2       := retValProp( ::oFacRecL:cCodPr2 + ::oFacRecL:cValPr2 )
               ::oDbf:nCajas        := ::oFacRecL:nCanEnt
               ::oDbf:nUnidades     := ::oFacRecL:nUniCaja
               ::oDbf:nUniCaj       := nTotNFacRec( ::oFacRecL )
               ::oDbf:nPreArt       := nTotUFacRec( ::oFacRecL:cAlias, ::nDecOut, ::nValDiv )
               ::oDbf:nBase         := nImpLFacRec( ::oFacRecT:cAlias, ::oFacRecL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv, , , .t., .t.  )
               ::oDbf:nIva          := nIvaLFacRec( ::oFacRecL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
               ::oDbf:nTotal        := ::oDbf:nBase + ::oDbf:nIva
               ::oDbf:nDtoEsp       := ::oFacRecT:nDtoEsp
               ::oDbf:nDpp          := ::oFacRecT:nDpp
               ::oDbf:nDtoUno       := ::oFacRecT:nDtoUno
               ::oDbf:nDtoDos       := ::oFacRecT:nDtoDos
               ::oDbf:cPerCto       := oRetFld( ::oFacRecT:cCodCli, ::oDbfCli, "cPerCto" )
               ::oDbf:Telefono      := oRetFld( ::oFacRecT:cCodCli, ::oDbfCli, "Telefono" )
               ::oDbf:Fax           := oRetFld( ::oFacRecT:cCodCli, ::oDbfCli, "Fax" )
               ::oDbf:Movil         := oRetFld( ::oFacRecT:cCodCli, ::oDbfCli, "Movil" )
               ::oDbf:mObserv       := oRetFld( ::oFacRecT:cCodCli, ::oDbfCli, "MCOMENT" )

               ::oDbf:Save()

               ::oFacRecL:Skip()

            end while

         end if

      end if

      ::oFacRecT:Skip()

      ::oMtrInf:AutoInc()

   end while

   ::oFacRecT:IdxDelete( cCurUsr(), GetFileNoExt( ::oFacRecT:cFile ) )
   ::oFacRecL:IdxDelete( cCurUsr(), GetFileNoExt( ::oFacRecL:cFile ) )

   ::oMtrInf:AutoInc( ::oFacRecT:LastRec() )

   ::oDbf:OrdSetFocus( ::oOrden:nAt )

   ::oDlg:Enable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//