#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS TFpgRec FROM TInfGen

   DATA  oEstado
   DATA  cEstado     AS CHARACTER     INIT  "Pendientes"
   DATA  aEstado     AS ARRAY    INIT  { "Pendientes", "Cobrados", "Descontados", "Todos" }
   DATA  oFacCliT    AS OBJECT
   DATA  oFacCliL    AS OBJECT
   DATA  oFacCliP    AS OBJECT
   DATA  oAntCliT    AS OBJECT
   DATA  oDbfIva     AS OBJECT

   METHOD Create()

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHOD lResource( cFld )

   METHOD lGenerate()

   METHOD lIsValid()

END CLASS

//---------------------------------------------------------------------------//

METHOD Create()

   ::AddField( "CCODPGO", "C",  2, 0, {|| "@!" },         "Pg",                        .f., "Código de formas de pago"  ,  4, .f.)
   ::AddField( "CNOMPGO", "C", 40, 0, {|| "@!" },         "Forma de pago",             .f., "Nombre de formas de pago"  , 40, .f.)
   ::AddField( "CDOCMOV", "C", 18, 0, {|| "@!" },         "Recibo",                    .t., "Recibo"                    , 14, .f.)
   ::AddField( "CCODCLI", "C", 12, 0, {|| "@!" },         "Código",                    .t., "Código cliente"            , 10, .f.)
   ::AddField( "CNOMCLI", "C", 50, 0, {|| "@!" },         "Cliente",                   .t., "Nombre cliente"            , 35, .f.)
   ::AddField( "CNIFCLI", "C", 15, 0, {|| "@!" },         "Nif",                       .f., "Nif"                       ,  8, .f.)
   ::AddField( "CDOMCLI", "C", 35, 0, {|| "@!" },         "Domicilio",                 .f., "Domicilio"                 , 25, .f.)
   ::AddField( "CPOBCLI", "C", 25, 0, {|| "@!" },         "Población",                 .f., "Población"                 , 20, .f.)
   ::AddField( "CPROCLI", "C", 20, 0, {|| "@!" },         "Provincia",                 .f., "Provincia"                 , 20, .f.)
   ::AddField( "CCDPCLI", "C",  7, 0, {|| "@!" },         "CP",                        .f., "Cod. postal"               , 20, .f.)
   ::AddField( "CTLFCLI", "C", 12, 0, {|| "@!" },         "Tlf.",                      .f., "Teléfono"                  ,  7, .f.)
   ::AddField( "CCODAGE", "C",  3, 0, {|| "@!" },         "Cod. age.",                 .f., "Código agente"             , 14, .f.)
   ::AddField( "CNOMAGE", "C", 40, 0, {|| "@!" },         "Agente",                    .f., "Nombre agente"             , 14, .f.)
   ::AddField( "NTOTDOC", "N", 16, 6, {|| ::cPicOut },    "Tot. Rec",                  .t., "Total recibo"              , 14, .t.)
   ::AddField( "DFECMOV", "D",  8, 0, {|| "@!" },         "Exped.",                    .t., "Fecha de expedición"       , 10, .f.)
   ::AddField( "DFECCOB", "D",  8, 0, {|| "@!" },         "Cobro",                     .f., "Fecha de cobro"            , 10, .f.)
   ::AddField( "NTOTFAC", "N", 16, 6, {|| ::cPicOut },    "Tot. Fac",                  .f., "Total factura"             , 14, .t.)
   ::AddField( "NTOTCOB", "N", 16, 6, {|| ::cPicOut },    "Tot. Cob",                  .f., "Total cobrado"             , 14, .t.)
   ::AddField( "NTOTPEN", "N", 16, 6, {|| ::cPicOut },    "Tot. Pen",                  .f., "Total pendiente"           , 14, .t.)
   ::AddField( "CBANCO",  "C", 50, 0, {|| "@!" },         "Banco",                     .f., "Nombre del banco"          , 20, .f. )
   ::AddField( "CCUENTA", "C", 30, 0, {|| "@!" },         "Cuenta",                    .f., "Cuenta bancaria"           , 35, .f. )

   ::AddTmpIndex( "cCodPgo", "cCodPgo" )

   ::AddGroup( {|| ::oDbf:cCodPgo }, {|| "Forma de pago : " + Rtrim( ::oDbf:cCodPgo ) + "-" + Rtrim( ::oDbf:cNomPgo ) }, {|| "" } )

   ::aHeader   := {  {|| "Fecha   : " + Dtoc( Date() ) },;
                     {|| "Periodo : " + Dtoc( ::dIniInf ) + " > " + Dtoc( ::dFinInf ) },;
                     {|| "Estado  : " + ::aEstado[ ::oEstado:nAt ]                    },;
                     {|| "Cliente : " + ::cCliOrg         + " > " + ::cCliDes         },;
                     {|| "Pago    : " + ::cFpgDes         + " > " + ::cFpgHas         } }

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD OpenFiles()

   local lOpen    := .t.
   local oBlock   := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

   ::oFacCliT     := TDataCenter():oFacCliT()  

   ::oFacCliP     := TDataCenter():oFacCliP()

   DATABASE NEW ::oFacCliL PATH ( cPatEmp() ) FILE  "FACCLIL.DBF" VIA ( cDriver() ) SHARED INDEX "FACCLIL.CDX"

   DATABASE NEW ::oDbfIva  PATH ( cPatDat() ) FILE  "TIVA.DBF"    VIA ( cDriver() ) SHARED INDEX "TIVA.CDX"

   DATABASE NEW ::oAntCliT PATH ( cPatEmp() ) FILE  "ANTCLIT.DBF" VIA ( cDriver() ) SHARED INDEX "ANTCLIT.CDX"

   RECOVER

      msgStop( 'Imposible abrir todas las bases de datos' )
      
      ::CloseFiles()

      lOpen       := .f.

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
   if !Empty( ::oFacCliP ) .and. ::oFacCliP:Used()
      ::oFacCliP:End()
   end if
   if !Empty( ::oDbfIva ) .and. ::oDbfIva:Used()
      ::oDbfIva:End()
   end if
   if !Empty( ::oAntCliT ) .and. ::oAntCliT:Used()
      ::oAntCliT:End()
   end if

   ::oFacCliT := nil
   ::oFacCliL := nil
   ::oFacCliP := nil
   ::oAntCliT := nil
   ::oDbfIva  := nil

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD lResource( cFld )

   if !::StdResource( "INF_FPGREC" )
      return .f.
   end if

   /*
   Montamos las formas de pago
   */

   if !::oDefFpgInf( 70, 80, 90, 100, 920 )
      return .f.
   end if

   if !::oDefCliInf( 110, 120, 130, 140, , 600 )
      return .f.
   end if

   REDEFINE COMBOBOX ::oEstado VAR ::cEstado ;
      ID       210 ;
      ITEMS    ::aEstado ;
      OF       ::oFld:aDialogs[1]

   /*
   Damos valor al meter
   */

   ::oMtrInf:SetTotal( ::oFacCliP:Lastrec() )

   ::CreateFilter( aItmRecCli(), ::oFacCliP:cAlias )

RETURN .t.

//---------------------------------------------------------------------------//
/*
Esta funcion crea la base de datos para generar posteriormente el informe
*/

METHOD lGenerate()

   local cCodPgo  := ""
   local cExpHead := ""

   ::oDlg:Disable()
   ::oBtnCancel:Enable()
   ::oDbf:Zap()

   ::oFacCliP:OrdSetFocus( "dPreCob" )

   if !Empty( ::oFilter:cExpresionFilter )
      cExpHead       := ::oFilter:cExpresionFilter
   else
      cExpHead       := '.t.'
   end if

   ::oFacCliP:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oFacCliP:cFile ), ::oFacCliP:OrdKey(), ( cExpHead ), , , , , , , , .t. )

   ::oFacCliP:GoTop()

   while !::lBreak .and. !::oFacCliP:Eof()

      /*
      Condiciones
      */

      cCodPgo        := cPgoFacCli( ::oFacCliP:cSerie + Str( ::oFacCliP:nNumFac ) + ::oFacCliP:cSufFac, ::oFacCliT )

      if ::lIsValid()                                                                                 .AND.;
         ::oFacCliP:dPreCob >= ::dIniInf                                                              .AND.;
         ::oFacCliP:dPreCob <= ::dFinInf                                                              .AND.;
         ( ::lAllFpg .or. ( cCodPgo >= ::cFpgDes .AND. cCodPgo <= ::cFpgHas ) )                       .AND.;
         ( ::lAllCli .or. ( ::oFacCliP:cCodCli >= ::cCliOrg .AND. ::oFacCliP:cCodCli <= ::cCliDes ) ) .AND.;
         lChkSer( ::oFacCliP:cSerie, ::aSer )

         /*
         Si cumple todas, empezamos a añadir
         */

         ::oDbf:Append()

         ::oDbf:cDocMov    := ::oFacCliP:cSerie + "/" + Str( ::oFacCliP:nNumFac ) + "/" + ::oFacCliP:cSufFac + "/" + Str( ::oFacCliP:nNumRec )
         ::oDbf:cCodCli    := ::oFacCliP:cCodCli

         if ::oDbfCli:Seek( ::oFacCliP:cCodCli )
            ::oDbf:cNomCli := ::oDbfCli:Titulo
            ::oDbf:cNifCli := ::oDbfCli:Nif
            ::oDbf:cDomCli := ::oDbfCli:Domicilio
            ::oDbf:cPobCli := ::oDbfCli:Poblacion
            ::oDbf:cProCli := ::oDbfCli:Provincia
            ::oDbf:cCdpCli := ::oDbfCli:CodPostal
            ::oDbf:cTlfCli := ::oDbfCli:Telefono
         end if

         ::oDbf:dFecMov    := ::oFacCliP:dPreCob
         ::oDbf:dFecCob    := ::oFacCliP:dEntrada
         ::oDbf:nTotDoc    := nTotRecCli( ::oFacCliP:cAlias, ::oDbfDiv:cAlias, ::cDivInf )
         ::oDbf:nTotFac    := nTotFacCli( ::oFacCliP:cSerie + Str( ::oFacCliP:nNumFac ) + ::oFacCliP:cSufFac, ::oFacCliT:cAlias, ::oFacCliL:cAlias, ::oDbfIva:cAlias, ::oDbfDiv:cAlias, ::oFacCliP:cAlias, ::oAntCliT:cAlias )
         ::oDbf:nTotCob    := nPagFacCli( ::oFacCliP:cSerie + Str( ::oFacCliP:nNumFac ) + ::oFacCliP:cSufFac, ::oFacCliT:cAlias, ::oFacCliP:cAlias, ::oDbfIva:cAlias, ::oDbfDiv:cAlias, ::cDivInf,.t. )
         ::oDbf:nTotPen    := ::oDbf:nTotCob - ::oDbf:nTotFac
         ::oDbf:cBanco     := ::oFacCliP:cBncCli
         ::oDbf:cCuenta    := ::oFacCliP:cEntCli + "-" + ::oFacCliP:cSucCli + "-" + ::oFacCliP:cDigCli + "-" + ::oFacCliP:cCtaCli

         ::oDbf:cCodPgo    := cCodPgo
         ::oDbf:cNomPgo    := cNbrFPago( cCodPgo, ::oDbfFpg )

         ::oDbf:Save()

      end if

      ::oFacCliP:Skip()

      ::oMtrInf:AutoInc()

   end while

   ::oMtrInf:SetTotal( ::oFacCliP:Lastrec() )

   ::oFacCliP:IdxDelete( cCurUsr(), GetFileNoExt( ::oFacCliP:cFile ) )

   ::oDlg:Enable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//

METHOD lIsValid()

   local lRet  := .t.

   do case
      case ::oEstado:nAt == 1 // "Pendientes"
         lRet  := !::oFacCliP:lCobrado
      case ::oEstado:nAt == 2 // "Cobrados"
         lRet  := ::oFacCliP:lCobrado
      case ::oEstado:nAt == 3 // "Descontados"
         lRet  := ::oFacCliP:lRecDto
      case ::oEstado:nAt == 4 // "Todos"
         lRet  := .t.
   end case

RETURN ( lRet )

//---------------------------------------------------------------------------//