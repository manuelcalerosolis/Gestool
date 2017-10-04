#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS TPerRec FROM TInfGen

   DATA  lResumen    AS LOGIC    INIT .f.
   DATA  lExcCero    AS LOGIC    INIT .f.
   DATA  lNumDias    AS LOGIC    INIT .f.
   DATA  nNumDias    AS NUMERIC  INIT 15
   DATA  oOrden      AS OBJECT
   DATA  oFacCliT    AS OBJECT
   DATA  oFacCliL    AS OBJECT
   DATA  oFacCliP    AS OBJECT
   DATA  oAntCliT    AS OBJECT
    
   DATA  oDbfIva     AS OBJECT
   DATA  oEstado
   DATA  cEstado     AS CHARACTER   INIT  "Cobrados"
   DATA  aEstado     AS ARRAY       INIT  { "Cobrados", "Pendientes", "Todos" }

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHOD Create()

   METHOD lResource( cFld )

   METHOD lGenerate()

   METHOD AddLine()

END CLASS

//---------------------------------------------------------------------------//

METHOD OpenFiles()

   local lOpen    := .t.
   local oBlock   := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

   ::oFacCliT     := TDataCenter():oFacCliT()

   DATABASE NEW ::oFacCliL PATH ( cPatEmp() ) FILE  "FACCLIL.DBF" VIA ( cDriver() ) SHARED INDEX "FACCLIL.CDX"

   ::oFacCliP := TDataCenter():oFacCliP()
   ::oFacCliP:OrdSetFocus( "CCODCLI" )

   DATABASE NEW ::oDbfIva  PATH ( cPatDat() ) FILE  "TIVA.DBF"    VIA ( cDriver() ) SHARED INDEX "TIVA.CDX"

   DATABASE NEW ::oAntCliT PATH ( cPatEmp() ) FILE  "ANTCLIT.DBF" VIA ( cDriver() ) SHARED INDEX "ANTCLIT.CDX"

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

METHOD Create()

   ::AddField( "cCodCli", "C", 12, 0, {|| "@!" },         "Código",                 .f., "Código cliente"            ,  8, .f. )
   ::AddField( "cNomCli", "C", 50, 0, {|| "@!" },         "Cliente",                .f., "Nombre cliente"            , 25, .f. )
   ::AddField( "cDocMov", "C", 20, 0, {|| "@!" },         "Recibo",                 .t., "Recibo"                    , 14, .f. )
   ::AddField( "dFecMov", "D",  8, 0, {|| "@!" },         "Fecha",                  .t., "Fecha"                     , 10, .f. )
   ::AddField( "cDniCli", "C", 30, 0, {|| "@!" },         "Nif",                    .f., "Nif"                       ,  8, .f. )
   ::AddField( "cDomCli", "C", 35, 0, {|| "@!" },         "Domicilio",              .f., "Domicilio"                 , 25, .f. )
   ::AddField( "cPobCli", "C", 25, 0, {|| "@!" },         "Población",              .f., "Población"                 , 20, .f. )
   ::AddField( "cProCli", "C", 20, 0, {|| "@!" },         "Provincia",              .f., "Provincia"                 , 20, .f. )
   ::AddField( "cCdpCli", "C",  7, 0, {|| "@!" },         "CP",                     .f., "Cod. Postal"               , 20, .f. )
   ::AddField( "cTlfCli", "C", 12, 0, {|| "@!" },         "Tlf",                    .f., "Teléfono"                  ,  7, .f. )
   ::AddField( "cDesCri", "C",100, 0, {|| "@!" },         "Descripción",            .t., "Descripción"               , 50, .f. )
   ::AddField( "nTotDoc", "N", 16, 6, {|| ::cPicOut },    "Tot. Rec",               .t., "Total recibo"              , 10, .t. )
   ::AddField( "cEstado", "C", 20, 0, {|| "@!" },         "Estado",                 .f., "Estado"                    , 10, .f. )
   ::AddField( "dFecVto", "D",  8, 0, {|| "@!" },         "Fec. vto.",              .t., "Fecha de vencimiento"      , 10, .f. )
   ::AddField( "dFecCob", "D",  8, 0, {|| "@!" },         "Fec. cobro",             .f., "Fecha de cobro"            , 10, .f. )
   ::AddField( "nTotDia", "N", 16, 0, {|| "99999" },      "Dias",                   .f., "Dias transcurridos"        , 10, .f. )
   ::AddField( "nTotFac", "N", 16, 6, {|| ::cPicOut },    "Tot. Fac",               .f., "Total factura"             , 10, .t. )
   ::AddField( "nTotCob", "N", 16, 6, {|| ::cPicOut },    "Tot. Cob",               .f., "Total cobrado"             , 10, .t. )
   ::AddField( "nTotPen", "N", 16, 6, {|| ::cPicOut },    "Tot. Pen",               .f., "Total pendiente"           , 10, .t. )
   ::AddField( "cEspDoc", "C", 20, 0, {|| "@!" },         "Espera doc.",            .t., "Espera documentacón"       , 20, .f. )
   ::AddField( "cBanco",  "C", 50, 0, {|| "@!" },         "Banco",                  .f., "Nombre del banco"          , 20, .f. )
   ::AddField( "cCuenta", "C", 30, 0, {|| "@!" },         "Cuenta",                 .f., "Cuenta bancaria"           , 35, .f. )

   ::AddTmpIndex( "cCodCli", "cCodCli" )

   ::AddGroup( {|| ::oDbf:cCodCli }, {|| "Cliente : " + Rtrim( ::oDbf:cCodCli ) + Space( 1 ) + Rtrim( ::oDbf:cNomCli ) }, {|| "Total cliente..."} )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD lResource( cFld )

   if !::StdResource( "INF_GEN28" )
      return .f.
   end if

   /*
   Montamos agentes
   */

   if !::oDefCliInf( 70, 71, 80, 81, , 600)
      return .f.
   end if

   REDEFINE COMBOBOX ::oEstado ;
      VAR      ::cEstado ;
      ID       210 ;
      ITEMS    ::aEstado ;
      OF       ::oFld:aDialogs[1]

   REDEFINE CHECKBOX ::lNumDias ;
      ID       190;
      OF       ::oFld:aDialogs[1]

   REDEFINE GET ::nNumDias ;
      WHEN     ::lNumDias ;
      PICTURE  "999" ;
      SPINNER ;
      MIN      0 ;
      MAX      999 ;
      ID       200 ;
      OF       ::oFld:aDialogs[1]

   /*
   Damos valor al meter
   */

   ::oMtrInf:SetTotal( ::oDbfCli:Lastrec() )

   ::CreateFilter( aItmCli(), ::oDbfCli:cAlias )

RETURN .t.

//---------------------------------------------------------------------------//
/*
Esta funcion crea la base de datos para generar posteriormente el informe
*/

METHOD lGenerate()


   local cExpHead := ""
   local bValid   := {|| .t. }

   ::oDlg:Disable()
   ::oBtnCancel:Enable()
   ::oDbf:Zap()

   do case
      case ::oEstado:nAt == 1
         bValid   := {|| ::oFacCliP:lCobrado }
      case ::oEstado:nAt == 2
         bValid   := {|| !::oFacCliP:lCobrado }
      case ::oEstado:nAt == 3
         bValid   := {|| .t. }
   end case

   /*
   Nos movemos por las cabeceras de los facturas de clientes
	*/

   ::aHeader   := {  {|| "Fecha   : " + Dtoc( Date() ) },;
                     {|| "Periodo : " + Dtoc( ::dIniInf ) + " > " + Dtoc( ::dFinInf ) },;
                     {|| "Cliente : " + AllTrim( ::cCliOrg ) + " > " + AllTrim( ::cCliDes ) },;
                     {|| "Estado  : " + ::cEstado },;
                     {|| "Dias    : " + if( ::lNumDias, Trans( ::nNumDias, "999" ), "Sin especificar" ) } }

   ::oDbfCli:OrdSetFocus( "COD" )

   if !Empty( ::oFilter:cExpresionFilter )
      cExpHead       := ::oFilter:cExpresionFilter
   else
      cExpHead       := '.t.'
   end if

   ::oDbfCli:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oDbfCli:cFile ), ::oDbfCli:OrdKey(), ( cExpHead ), , , , , , , , .t. )

   ::oDbfCli:GoTop()
   while !::lBreak .and. !::oDbfCli:Eof()

      if ( ::lAllCli .or. ( ::oDbfCli:Cod >= ::cCliOrg .AND. ::oDbfCli:Cod <= ::cCliDes ) )   .AND.;
         ::oFacCliP:Seek( ::oDbfCli:Cod )

         while ::oFacCliP:cCodCli == ::oDbfCli:Cod .and. !::oFacCliP:Eof()

            if Eval( bValid )                                                                 .AND.;
               ::oFacCliP:dPreCob >= ::dIniInf                                                .AND.;
               ::oFacCliP:dPreCob <= ::dFinInf                                                .AND.;
               lChkSer( ::oFacCliP:cSerie, ::aSer )

               if ::lNumDias .and. ( GetSysDate() - ::oFacCliP:dPreCob <= ::nNumDias )
                  ::AddLine()
               else
                 ::AddLine()
               end if

            end if

         ::oFacCliP:Skip()

         end while

      end if

      ::oDbfCli:Skip()

      ::oMtrInf:AutoInc( ::oDbfCli:OrdKeyNo() )

   end while

   ::oDbfCli:IdxDelete( cCurUsr(), GetFileNoExt( ::oDbfCli:cFile ) )

   ::oMtrInf:AutoInc( ::oDbfCli:LastRec() )

   ::oDlg:Enable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//

METHOD AddLine()

   ::oDbf:Append()
   ::oDbf:Blank()

   ::oDbf:cCodCli    := ::oDbfCli:Cod
   ::oDbf:cNomCli    := ::oDbfCli:Titulo
   ::oDbf:cDniCli    := ::oDbfCli:Nif
   ::oDbf:cDomCli    := ::oDbfCli:Domicilio
   ::oDbf:cPobCli    := ::oDbfCli:Poblacion
   ::oDbf:cProCli    := ::oDbfCli:Provincia
   ::oDbf:cCdpCli    := ::oDbfCli:CodPostal
   ::oDbf:cTlfCli    := ::oDbfCli:Telefono

   ::oDbf:dFecMov    := ::oFacCliP:dPreCob
   ::oDbf:dFecVto    := ::oFacCliP:dFecVto
   ::oDbf:cDocMov    := StrTran( ::oFacCliP:cSerie + "/" + Str( ::oFacCliP:nNumFac ) + "/" + ::oFacCliP:cSufFac + "/" + Str( ::oFacCliP:nNumRec ), " ", "" )
   ::oDbf:nTotDoc    := nTotRecCli( ::oFacCliP:cAlias, ::oDbfDiv:cAlias, ::cDivInf )
   ::oDbf:nTotFac    := nTotFacCli( ::oFacCliP:cSerie + Str( ::oFacCliP:nNumFac ) + ::oFacCliP:cSufFac, ::oFacCliT:cAlias, ::oFacCliL:cAlias, ::oDbfIva:cAlias, ::oDbfDiv:cAlias, ::oFacCliP:cAlias, ::oAntCliT:cAlias )
   ::oDbf:nTotCob    := nPagFacCli( ::oFacCliP:cSerie + Str( ::oFacCliP:nNumFac ) + ::oFacCliP:cSufFac, ::oFacCliT:cAlias, ::oFacCliP:cAlias, ::oDbfIva:cAlias, ::oDbfDiv:cAlias, ::cDivInf, .t. )
   ::oDbf:nTotPen    := ::oDbf:nTotFac - ::oDbf:nTotCob
   ::oDbf:nTotDia    := GetSysDate() - ::oFacCliP:dPreCob
   ::oDbf:cDescri    := ::oFacCliP:cDescrip
   ::oDbf:cBanco     := ::oFacCliP:cBncCli
   ::oDbf:cCuenta    := ::oFacCliP:cEntCli + "-" + ::oFacCliP:cSucCli + "-" + ::oFacCliP:cDigCli + "-" + ::oFacCliP:cCtaCli

   if ::oFacCliP:lCobrado
      ::oDbf:cEstado := "Cobrado"
      ::oDbf:dFecCob := ::oFacCliP:dEntrada
   else
      ::oDbf:cEstado := "Pendiente"
   end if

   if ::oFacCliP:lEsperaDoc
      ::oDbf:cEspDoc := ""
   else
      ::oDbf:cEspDoc := "Espera doc."
   end if

   ::oDbf:Save()

RETURN ( Self )

//---------------------------------------------------------------------------//