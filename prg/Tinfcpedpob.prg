#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS TInfCPedPob FROM TInfCli

   DATA  lExcMov     AS LOGIC       INIT .f.
   DATA  lResumen    AS LOGIC       INIT .f.
   DATA  lExcCero    AS LOGIC       INIT .f.
   DATA  lAllCP      AS LOGIC       INIT .t.
   DATA  lIncEsc     AS LOGIC       INIT .f.
   DATA  oPedCliT    AS OBJECT
   DATA  oPedCliL    AS OBJECT
   DATA  oDbfArt     AS OBJECT
   DATA  cCPOrg      AS CHARACTER   INIT "00000"
   DATA  cCPDes      AS CHARACTER   INIT "99999"
   DATA  aEstado     AS ARRAY       INIT  { "Pendiente", "Parcilamente", "Entregado", "Todos" }
   DATA  oEstado     AS OBJECT

   METHOD Create()

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHOD lResource( cFld )

   METHOD lGenerate()

END CLASS

//---------------------------------------------------------------------------//

METHOD Create()

   ::AddField( "cTipDoc", "C", 20, 0, {|| "@!" },          "Tipo",                 .f., "Tipo de documento"         , 10, .f. )
   ::AddField( "cDocMov", "C", 14, 0, {|| "@!" },          "Doc.",                 .t., "Documento"                 , 12, .f. )
   ::AddField( "dFecMov", "D",  8, 0, {|| "@!" },          "Fecha",                .t., "Fecha"                     , 10, .f. )
   ::AddField( "cCodArt", "C", 18, 0, {|| "@!" },          "Art.",                 .t., "Código artículo"           , 14, .f. )
   ::AddField( "cNomArt", "C",100, 0, {|| "@!" },          "Descripción",          .t., "Descripción"               , 35, .f. )
   ::FldPropiedades()
   ::AddField( "cLote",   "C", 14, 0, ,                    "Lote",                 .f., "Número de lote"            , 10, .f. )
   ::AddField( "cCodCli", "C", 12, 0, {|| "@!" },          "Cód. cli.",            .f., "Cod. Cliente"              ,  8, .f. )
   ::AddField( "cNomCli", "C", 50, 0, {|| "@!" },          "Cliente",              .f., "Nom. Cliente"              , 30, .f. )
   ::AddField( "cNifCli", "C", 15, 0, {|| "@!" },          "Nif",                  .f., "Nif"                       , 12, .f. )
   ::AddField( "cDomCli", "C", 35, 0, {|| "@!" },          "Domicilio",            .f., "Domicilio"                 , 20, .f. )
   ::AddField( "cPobCli", "C", 25, 0, {|| "@!" },          "Población",            .f., "Población"                 , 25, .f. )
   ::AddField( "cProCli", "C", 20, 0, {|| "@!" },          "Provincia",            .f., "Provincia"                 , 20, .f. )
   ::AddField( "cCdpCli", "C",  7, 0, {|| "@!" },          "Cod. Postal",          .f., "Cod. Postal"               ,  7, .f. )
   ::AddField( "cTlfCli", "C", 12, 0, {|| "@!" },          "Teléfono",             .f., "Teléfono"                  , 12, .f. )
   ::AddField( "cTipVen", "C", 20, 0, {|| "@!" },          "Venta",                .f., "Tipo de venta"             , 10, .f. )
   ::AddField( "nNumCaj", "N", 16, 6, {|| MasUnd() },      cNombreCajas(),         .f., cNombreCajas()              , 12, .t. )
   ::AddField( "nUniDad", "N", 16, 6, {|| MasUnd() },      cNombreUnidades(),      .f., cNombreUnidades()           , 12, .t. )
   ::AddField( "nNumUni", "N", 16, 6, {|| MasUnd() },      "Tot. " + cNombreUnidades(), .t., "Tot. " + cNombreUnidades() , 10, .t. )
   ::AddField( "nImpArt", "N", 16, 6, {|| ::cPicImp },     "Precio",               .t., "Precio"                    , 12, .f. )
   ::AddField( "nPntVer", "N", 16, 6, {|| ::cPicImp },     "Pnt. ver.",            .f., "Punto verde"               , 10, .f. )
   ::AddField( "nImpTrn", "N", 16, 6, {|| ::cPicImp },     "Portes",               .f., "Portes"                    , 10, .f. )
   ::AddField( "nImpTot", "N", 16, 6, {|| ::cPicOut },     "Base",                 .t., "Base"                      , 15, .t. )
   ::AddField( "nTotPes", "N", 16, 6, {|| MasUnd() },      "Tot. peso",            .f., "Total peso"                , 12, .t. )
   ::AddField( "nPreKgr", "N", 16, 6, {|| ::cPicImp },     "Pre. Kg.",             .f., "Precio kilo"               , 12, .f. )
   ::AddField( "nTotVol", "N", 16, 6, {|| MasUnd() },      "Tot. volumen",         .f., "Total volumen"             , 12, .t. )
   ::AddField( "nPreVol", "N", 16, 6, {|| ::cPicImp },     "Pre. vol.",            .f., "Precio volumen"            , 12, .f. )
   ::AddField( "nIvaTot", "N", 16, 6, {|| ::cPicOut },     cImp(),               .t., cImp()                    , 12, .t. )
   ::AddField( "nTotFin", "N", 16, 6, {|| ::cPicOut },     "Total",                .t., "Total"                     , 12, .t. )
   ::AddField( "nDtoEsp", "N",  6, 2, {|| '@E 99.99' },    "%Dto.1",               .f., "Primer porcetaje descuento",  6, .f. )
   ::AddField( "nDpp",    "N",  6, 2, {|| '@E 99.99' },    "%Dto.2",               .f., "Segundo porcentaje descuento",6, .t. )
   ::AddField( "nDtoUno", "N",  6, 2, {|| '@E 99.99' },    "%Dto.3",               .f., "Tercer porcentaje descuento", 6, .t. )
   ::AddField( "nDtoDos", "N",  6, 2, {|| '@E 99.99' },    "%Dto.4",               .f., "Cuarto porcentaje descuento", 6, .t. )
   ::AddField( "cPerCto", "C", 30, 0, {|| '@!' },          "Contacto",             .f., "Contacto",                    15,.f. )
   ::AddField( "Telefono","C", 20, 0, {|| '@!' },          "Telefono",             .f., "Telefono",                    15,.f. )
   ::AddField( "Fax",     "C", 20, 0, {|| '@!' },          "Fax",                  .f., "Fax",                         15,.f. )
   ::AddField( "Movil",   "C", 20, 0, {|| '@!' },          "Movil",                .f., "Movil",                       15,.f. )
   ::AddField( "mObserv", "M", 10, 0, {|| '@!' },          "Observ.",              .f., "Observaciones",               15,.f. )

   ::AddTmpIndex( "cCdpCli", "cCdpCli + cCodCli + dTos( dFecMov )" )

   ::AddGroup( {|| ::oDbf:cCdpCli }, {|| "Código postal : " + Rtrim( ::oDbf:cCdpCli ) }, {||"Total código postal..."} )

   ::AddGroup( {|| ::oDbf:cCdpCli + ::oDbf:cCodCli }, {|| "Cliente  : " + Rtrim( ::oDbf:cCodCli ) + "-" + oRetFld( ::oDbf:cCodCli, ::oDbfCli ) }, {||"Total cliente..."} )

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD OpenFiles()

   local lOpen    := .t.
   local oBlock   := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

   ::oPedCliT := TDataCenter():oPedCliT()

   DATABASE NEW ::oPedCliL    PATH ( cPatEmp() )   FILE "PEDCLIL.DBF"  VIA ( cDriver() ) SHARED INDEX "PEDCLIL.CDX"

   DATABASE NEW ::oDbfArt     PATH ( cPatEmp() )   FILE "ARTICULO.DBF" VIA ( cDriver() ) SHARED INDEX "ARTICULO.CDX"

   RECOVER

      msgStop( "Imposible abrir todas las bases de datos" )
      ::CloseFiles()
      lOpen          := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD CloseFiles()

   if !Empty( ::oPedCliT ) .and. ::oPedCliT:Used()
      ::oPedCliT:End()
   end if
   if !Empty( ::oPedCliL ) .and. ::oPedCliL:Used()
      ::oPedCliL:End()
   end if
   if !Empty( ::oDbfArt ) .and. ::oDbfArt:Used()
      ::oDbfArt:End()
   end if

   ::oPedCliT := nil
   ::oPedCliL := nil
   ::oDbfArt  := nil

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD lResource( cFld )

   local oCPOrg
   local oCPDes
   local oIncEsc
   local cEstado  := "Todos"

   if !::StdResource( "INF_GEN32A" )
      return .f.
   end if

   /*
   Monta los desde - hasta
   ----------------------------------------------------------------------------
   */

   if !::oDefCliInf( 110, 120, 130, 140, , 600 )
      return .f.
   end if

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

   /*
   Monta los checks y el combo para las opciones
   ----------------------------------------------------------------------------
   */

   REDEFINE CHECKBOX oIncEsc VAR ::lIncEsc;
      ID       750 ;
      OF       ::oFld:aDialogs[1]

   ::oDefExcInf()

   ::oDefResInf()

   REDEFINE COMBOBOX ::oEstado ;
      VAR      cEstado ;
      ID       210 ;
      ITEMS    ::aEstado ;
      OF       ::oFld:aDialogs[1]

   /*
   Monta los filtros
   ----------------------------------------------------------------------------
   */

   ::CreateFilter( aItmPedCli(), ::oPedCliT:cAlias )

RETURN .t.

//---------------------------------------------------------------------------//
/*
Esta funcion crea la base de datos para generar posteriormente el informe
*/

METHOD lGenerate()

   local cExpHead := ""
   local cExpLine := ""

   ::oDlg:Disable()
   ::oBtnCancel:Enable()
   ::oDbf:Zap()

   ::aHeader   := {  {|| "Fecha     : " + Dtoc( Date() ) },;
                     {|| "Periodo   : " + Dtoc( ::dIniInf )   + " > " + Dtoc( ::dFinInf ) },;
                     {|| "C. Postal : " + if( ::lAllCP, "Todos", AllTrim( ::cCPOrg ) + " > " + AllTrim( ::cCPDes ) ) },;
                     {|| "Clientes  : " + if( ::lAllCli, "Todos", AllTrim( ::cCliOrg ) + " > " + AllTrim( ::cCliDes ) ) },;
                     {|| "Estado    : " + ::aEstado[ ::oEstado:nAt ] } }

   ::oPedCliT:OrdSetFocus( "dFecPed" )
   ::oPedCliL:OrdSetFocus( "nNumPed" )

   cExpHead          := "!lCancel "

   do case
      case ::oEstado:nAt == 1
         cExpHead    += ' .and. nEstado == 1'
      case ::oEstado:nAt == 2
         cExpHead    += ' .and. nEstado == 2'
      case ::oEstado:nAt == 3
         cExpHead    += ' .and. nEstado == 3'
   end case

   cExpHead          += ' .and. dFecPed >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecPed <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'

   if !::lAllCP
      cExpHead       += ' .and. cPosCli >= "' + Rtrim( ::cCPOrg ) + '" .and. cPosCli <= "' + Rtrim( ::cCPDes ) + '"'
   end if

   if !::lAllCli
      cExpHead       += ' .and. cCodCli >= "' + Rtrim( ::cCliOrg ) + '" .and. cCodCli <= "' + Rtrim( ::cCliDes ) + '"'
   end if

   if !Empty( ::oFilter:cExpresionFilter ) 
      cExpHead       += ' .and. ' + ::oFilter:cExpresionFilter
   end if

   ::oPedCliT:AddTmpIndex( Auth():Codigo(), GetFileNoExt( ::oPedCliT:cFile ), ::oPedCliT:OrdKey(), ( cExpHead ), , , , , , , , .t. )

   ::oMtrInf:cText := "Procesando pedidos"
   ::oMtrInf:SetTotal( ::oPedCliT:OrdKeyCount() )

   if !::lIncEsc
      cExpLine       := '!lKitChl'
   else
      cExpLine       := '.t.'
   end if

   ::oPedCliL:AddTmpIndex( Auth():Codigo(), GetFileNoExt( ::oPedCliL:cFile ), ::oPedCliL:OrdKey(), cAllTrimer( cExpLine ), , , , , , , , .t. )

   ::oPedCliT:GoTop()

   WHILE !::lBreak .and. !::oPedCliT:Eof()

      if lChkSer( ::oPedCliT:cSerPed, ::aSer )

         if ::oPedCliL:Seek( ::oPedCliT:cSerPed + Str( ::oPedCliT:nNumPed ) + ::oPedCliT:cSufPed )

            while ::oPedCliT:cSerPed + Str( ::oPedCliT:nNumPed ) + ::oPedCliT:cSufPed == ::oPedCliL:cSerPed + Str( ::oPedCliL:nNumPed ) + ::oPedCliL:cSufPed

               if !( ::oPedCliL:lTotLin ) .and. !( ::oPedCliL:lControl )                                 .AND.;
                  !( ::lExcMov .AND. nTotNPedCli( ::oPedCliL:cAlias ) == 0 )                             .AND.;
                  !( ::lExcCero .AND. nImpLPedCli( ::oPedCliT:cAlias, ::oPedCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv ) == 0 )

                  ::AddPed( .f. )

                  ::oDbf:Load()

                  ::oDbf:nDtoEsp       := ::oPedCliT:nDtoEsp
                  ::oDbf:nDpp          := ::oPedCliT:nDpp
                  ::oDbf:nDtoUno       := ::oPedCliT:nDtoUno
                  ::oDbf:nDtoDos       := ::oPedCliT:nDtoDos
                  ::oDbf:cPerCto       := oRetFld( ::oPedCliT:cCodCli, ::oDbfCli, "cPerCto" )
                  ::oDbf:Telefono      := oRetFld( ::oPedCliT:cCodCli, ::oDbfCli, "Telefono" )
                  ::oDbf:Fax           := oRetFld( ::oPedCliT:cCodCli, ::oDbfCli, "Fax" )
                  ::oDbf:Movil         := oRetFld( ::oPedCliT:cCodCli, ::oDbfCli, "Movil" )
                  ::oDbf:mObserv       := oRetFld( ::oPedCliT:cCodCli, ::oDbfCli, "MCOMENT" )

                  ::oDbf:Save()

               end if

               ::oPedCliL:Skip()

            end while

         end if

      end if

      ::oPedCliT:Skip()

      ::oMtrInf:AutoInc()

   end while

   ::oPedCliT:IdxDelete( Auth():Codigo(), GetFileNoExt( ::oPedCliT:cFile ) )
   ::oPedCliL:IdxDelete( Auth():Codigo(), GetFileNoExt( ::oPedCliL:cFile ) )

   ::oMtrInf:AutoInc( ::oPedCliT:Lastrec() )

   ::oDlg:Enable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//