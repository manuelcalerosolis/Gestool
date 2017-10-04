#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS TRecAge FROM TInfGen

   DATA  lResumen    AS LOGIC    INIT .f.
   DATA  lExcCero    AS LOGIC    INIT .f.
   DATA  lNumDias    AS LOGIC    INIT .f.
   DATA  nNumDias    AS NUMERIC  INIT 15
   DATA  oOrden      AS OBJECT
   DATA  oFacCliT    AS OBJECT
   DATA  oFacCliL    AS OBJECT
    
   DATA  oDbfIva     AS OBJECT
   DATA  oFacCliP    AS OBJECT
   DATA  oAntCliT    AS OBJECT
   DATA  dLasDoc
   DATA  cNumDoc
   DATA  nImpDoc
   DATA  oEstado
   DATA  cEstado     AS CHARACTER     INIT  "Cobrados"
   DATA  aEstado     AS ARRAY    INIT  { "Cobrados", "Pendientes" }

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHOD Create()

   METHOD lResource( cFld )

   METHOD lGenerate()

   METHOD GetDocument()

   METHOD AddDocument()

   METHOD AddLine( cAgeFac )

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

   DATABASE NEW ::oAntCliT  PATH ( cPatEmp() ) FILE  "ANTCLIT.DBF" VIA ( cDriver() ) SHARED INDEX "ANTCLIT.CDX"

   RECOVER

      msgStop( 'Imposible abrir todas las bases de datos' )
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

   ::AddField( "cCodAge", "C",  3, 0, {|| "@!" },         "Cód. age.",              .f., "Código agente"             ,  8, .f. )
   ::AddField( "cNomAge", "C", 50, 0, {|| "@!" },         "Agente",                 .f., "Nombre agente"             , 25, .f. )
   ::AddField( "cCodCli", "C", 12, 0, {|| "@!" },         "Código",                 .t., "Código cliente"            ,  8, .f. )
   ::AddField( "cNomCli", "C", 50, 0, {|| "@!" },         "Cliente",                .t., "Nombre cliente"            , 25, .f. )
   ::AddField( "cDocMov", "C", 20, 0, {|| "@!" },         "Recibo",                 .t., "Recibo"                    , 14, .f. )
   ::AddField( "dFecMov", "D",  8, 0, {|| "@!" },         "Fecha",                  .t., "Fecha"                     , 14, .f. )
   ::AddField( "cDniCli", "C", 15, 0, {|| "@!" },         "Nif",                    .f., "Nif"                       ,  8, .f. )
   ::AddField( "cDomCli", "C", 35, 0, {|| "@!" },         "Domicilio",              .f., "Domicilio"                 , 25, .f. )
   ::AddField( "cPobCli", "C", 25, 0, {|| "@!" },         "Población",              .f., "Población"                 , 20, .f. )
   ::AddField( "cProCli", "C", 20, 0, {|| "@!" },         "Provincia",              .f., "Provincia"                 , 20, .f. )
   ::AddField( "cCdpCli", "C",  7, 0, {|| "@!" },         "CP",                     .f., "Cod. Postal"               , 20, .f. )
   ::AddField( "cTlfCli", "C", 12, 0, {|| "@!" },         "Tlf",                    .f., "Teléfono"                  ,  7, .f. )
   ::AddField( "nTotDoc", "N", 16, 6, {|| ::cPicOut },    "Tot. Rec",               .t., "Total recibo"              , 10, .t. )
   ::AddField( "nTotDia", "N", 16, 0, {|| "99999" },      "Dias",                   .t., "Dias transcurridos"        ,  4, .t. )
   ::AddField( "nTotFac", "N", 16, 6, {|| ::cPicOut },    "Tot. Fac",               .t., "Total factura"             , 10, .t. )
   ::AddField( "nTotCob", "N", 16, 6, {|| ::cPicOut },    "Tot. Cob",               .t., "Total cobrado"             , 10, .t. )
   ::AddField( "nTotPen", "N", 16, 6, {|| ::cPicOut },    "Tot. Pen",               .t., "Total pendiente"           , 10, .t. )
   ::AddField( "dLasDoc", "D",  8, 0, {|| "" },           "",                       .f., ""                          ,  0, .f. )
   ::AddField( "cNumDoc", "C", 16, 0, {|| "" },           "",                       .f., ""                          ,  0, .f. )
   ::AddField( "nImpDoc", "N", 16, 6, {|| ::cPicOut },    "",                       .f., ""                          ,  0, .f. )
   ::AddField( "cBanco",  "C", 50, 0, {|| "@!" },         "Banco",                  .f., "Nombre del banco"          , 20, .f. )
   ::AddField( "cCuenta", "C", 30, 0, {|| "@!" },         "Cuenta",                 .f., "Cuenta bancaria"           , 35, .f. )

   ::AddTmpIndex( "cCodAge", "cCodAge + cCodCli" )

   ::AddGroup( {|| ::oDbf:cCodAge },;
               {|| "Agente : " + if( ::lAgeAll, "Todos", Rtrim( ::oDbf:cCodAge ) + "-" + Rtrim( oRetFld( ::oDbf:cCodAge, ::oDbfAge, 2 ) ) + "," + Rtrim( oRetFld( ::oDbf:cCodAge, ::oDbfAge, 3 ) ) ) },;
               {|| "Total agente..."} )
   ::AddGroup( {|| ::oDbf:cCodAge + ::oDbf:cCodCli },;
               {|| "Cliente : " + Rtrim( ::oDbf:cCodCli ) + " - " + Rtrim( oRetFld( ::oDbf:cCodCli, ::oDbfCli ) ) + " - Ultimo cobro : " + Dtoc( ::oDbf:dLasDoc ) + " - Recibo :" + StrTran( Trans( ::oDbf:cNumDoc, "@R #/#########/##/##" ), " ", "" ) + " - Importe " + Trans( ::oDbf:nImpDoc, ::cPicOut ) },;
               {|| "Total cliente..."} )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD lResource( cFld )

   if !::StdResource( "INF_GEN28B" )
      return .f.
   end if

   /*
   Montamos agentes
   */

   if !::oDefCliInf( 70, 71, 80, 81, , 600)
      return .f.
   end if

   /*
   Montamos agentes
   */

   if !::oDefAgeInf( 90, 91, 100, 101, 110 )
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

   ::CreateFilter( aItmCli(), ::oDbfCli )

RETURN .t.

//---------------------------------------------------------------------------//
/*
Esta funcion crea la base de datos para generar posteriormente el informe
*/

METHOD lGenerate()

   local cExpHead := ""

   ::oDlg:Disable()
   ::oBtnCancel:Enable()
   ::oDbf:Zap()

   /*
   Nos movemos por las cabeceras de los facturas de clientes
	*/

   ::aHeader   := {  {|| "Fecha   : " + Dtoc( Date() ) },;
                     {|| "Periodo : " + Dtoc( ::dIniInf ) + " > " + Dtoc( ::dFinInf ) },;
                     {|| "Cliente : " + AllTrim( ::cCliOrg ) + " > " + AllTrim( ::cCliDes ) },;
                     {|| "Agente  : " + if( !::lAgeAll, ( ::cAgeOrg + " > " + ::cAgeDes ), "Todos" ) },;
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

      if ::lAgeAll

         if ( ::lAllCli .or. ( ::oDbfCli:Cod >= ::cCliOrg .AND. ::oDbfCli:Cod <= ::cCliDes ) )   .AND.;
            ::oFacCliP:Seek( ::oDbfCli:Cod )

            ::GetDocument()
            ::AddDocument()

         end if

      else

         ::oDbfAge:GoTop()
         while !::oDbfAge:Eof()

            if ::oDbfCli:Cod >= ::cCliOrg                         .and.;
               ::oDbfCli:Cod <= ::cCliDes                         .and.;
               ::oDbfAge:cCodAge >= ::cAgeOrg                     .and.;
               ::oDbfAge:cCodAge <= ::cAgeDes                     .and.;
               ::oFacCliP:Seek( ::oDbfCli:Cod )

               ::GetDocument()
               ::AddDocument()

            end if

            ::oDbfAge:Skip()

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

METHOD GetDocument()

   local cAgeFac

   ::dLasDoc      := Ctod( "" )
   ::cNumDoc      := ""
   ::nImpDoc      := 0

   if ::oFacCliP:Seek( ::oDbfCli:Cod )

      while ::oFacCliP:cCodCli == ::oDbfCli:Cod .and. !::oFacCliP:Eof()

         if ::lAgeAll
            cAgeFac     := ""
         else
            if Empty( ::oFacCliP:cCodAge )
               cAgeFac  := cAgeFacCli( ::oFacCliP:cSerie + Str( ::oFacCliP:nNumFac ) + ::oFacCliP:cSufFac, ::oFacCliT )
            else
               cAgeFac  := ::oFacCliP:cCodAge
            end if
         end if

         if ( if( ::lAgeAll, .t., ::oDbfAge:cCodAge == cAgeFac ) )                        .and.;
            ::oFacCliP:dPreCob >= ::dIniInf                                               .and.;
            ::oFacCliP:dPreCob <= ::dFinInf                                               .and.;
            ::oFacCliP:lCobrado                                                           .and.;
            lChkSer( ::oFacCliP:cSerie, ::aSer )                                          .and.;
            ::oFacCliP:dEntrada >= ::dLasDoc

            ::dLasDoc   := ::oFacCliP:dEntrada
            ::cNumDoc   := ::oFacCliP:cSerie + Str( ::oFacCliP:nNumFac ) + ::oFacCliP:cSufFac + Str( ::oFacCliP:nNumRec )
            ::nImpDoc   := nTotRecCli( ::oFacCliP:cAlias, ::oDbfDiv:cAlias, ::cDivInf )

         end if

         ::oFacCliP:Skip()

      end while

   end if

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD AddDocument()

   local cAgeFac

   if ::oFacCliP:Seek( ::oDbfCli:Cod )

      while ::oFacCliP:cCodCli == ::oDbfCli:Cod .and. !::oFacCliP:Eof()

         if ::lAgeAll
            cAgeFac     := ""
         else
            if Empty( ::oFacCliP:cCodAge )
               cAgeFac  := cAgeFacCli( ::oFacCliP:cSerie + Str( ::oFacCliP:nNumFac ) + ::oFacCliP:cSufFac, ::oFacCliT )
            else
               cAgeFac  := ::oFacCliP:cCodAge
            end if
         end if

         if ( if( ::lAgeAll, .t., ::oDbfAge:cCodAge == cAgeFac ) )                        .and.;
            ( if( ::oEstado:nAt == 1, ::oFacCliP:lCobrado, !::oFacCliP:lCobrado ) )       .and.;
            ::oFacCliP:dPreCob >= ::dIniInf                                               .and.;
            ::oFacCliP:dPreCob <= ::dFinInf                                               .and.;
            lChkSer( ::oFacCliP:cSerie, ::aSer )

            if ::lNumDias
               if ::cEstado == "Cobrados"
                  if GetSysDate() - ::oFacCliP:dEntrada <= ::nNumDias
                     ::AddLine( cAgeFac )
                  end if
               else
                  if GetSysDate() - ::oFacCliP:dPreCob >= ::nNumDias
                     ::AddLine( cAgeFac )
                  end if
               end if
            else
               ::AddLine( cAgeFac )
            end if

         end if

         ::oFacCliP:Skip()

      end while

   end if

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD AddLine( cAgeFac )

   ::oDbf:Append()
   ::oDbf:Blank()

   ::oDbf:cCodAge := cAgeFac
   ::oDbf:cNomAge := oRetFld( ::oDbf:cCodAge, ::oDbfAge, 3 )

   ::oDbf:cCodCli := ::oDbfCli:Cod
   ::oDbf:cNomCli := ::oDbfCli:Titulo
   ::oDbf:cDniCli := ::oDbfCli:Nif
   ::oDbf:cDomCli := ::oDbfCli:Domicilio
   ::oDbf:cPobCli := ::oDbfCli:Poblacion
   ::oDbf:cProCli := ::oDbfCli:Provincia
   ::oDbf:cCdpCli := ::oDbfCli:CodPostal
   ::oDbf:cTlfCli := ::oDbfCli:Telefono

   ::oDbf:dFecMov := ::oFacCliP:dPreCob
   ::oDbf:nTotDoc := nTotRecCli( ::oFacCliP:cAlias, ::oDbfDiv:cAlias, ::cDivInf )
   ::oDbf:nTotFac := nTotFacCli( ::oFacCliP:cSerie + Str( ::oFacCliP:nNumFac ) + ::oFacCliP:cSufFac, ::oFacCliT:cAlias, ::oFacCliL:cAlias, ::oDbfIva:cAlias, ::oDbfDiv:cAlias, ::oFacCliP:cAlias, ::oAntCliT:cAlias )
   ::oDbf:nTotCob := nPagFacCli( ::oFacCliP:cSerie + Str( ::oFacCliP:nNumFac ) + ::oFacCliP:cSufFac, ::oFacCliT:cAlias, ::oFacCliP:cAlias, ::oDbfIva:cAlias, ::oDbfDiv:cAlias, ::cDivInf, .t. )
   ::oDbf:nTotPen := ::oDbf:nTotFac - ::oDbf:nTotCob
   ::oDbf:cDocMov := StrTran( ::oFacCliP:cSerie + "/" + Str( ::oFacCliP:nNumFac ) + "/" + ::oFacCliP:cSufFac + "/" + Str( ::oFacCliP:nNumRec ), " ", "" )
   ::oDbf:nTotDia := GetSysDate() - ::oFacCliP:dPreCob
   ::oDbf:dLasDoc := ::dLasDoc
   ::oDbf:cNumDoc := ::cNumDoc
   ::oDbf:nImpDoc := ::nImpDoc
   ::oDbf:cBanco  := ::oFacCliP:cBncCli
   ::oDbf:cCuenta := ::oFacCliP:cEntCli + "-" + ::oFacCliP:cSucCli + "-" + ::oFacCliP:cDigCli + "-" + ::oFacCliP:cCtaCli

   ::oDbf:Save()

RETURN ( Self )

//---------------------------------------------------------------------------//