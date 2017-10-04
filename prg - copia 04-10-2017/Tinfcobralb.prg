#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS TInfCliObr FROM TInfGen

   DATA  lResumen    AS LOGIC    INIT .f.
   DATA  lExcCero    AS LOGIC    INIT .f.
   DATA  oAlbCliT    AS OBJECT
   DATA  oAlbCliL    AS OBJECT
   DATA  oEstado     AS OBJECT
   DATA  aEstado     AS ARRAY    INIT  { "Facturado", "No facturado", "Todos" }

   METHOD Create()

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHOD lResource( cFld )

   METHOD lGenerate()

END CLASS

//---------------------------------------------------------------------------//

METHOD Create()

   ::AddField ( "cCodObr", "C", 18, 0, {|| "@!" },         "Dirección",                      .f., "Código dirección",                14 )
   ::AddField ( "cNomObr", "C", 50, 0, {|| "@!" },         "Nom.obra",                  .f., "Nombre dirección",                20 )
   ::AddField ( "cCodArt", "C", 18, 0, {|| "@!" },         "Cod. artículo",             .t., "Código artículo",            14 )
   ::AddField ( "cNomArt", "C",100, 0, {|| "@!" },         "Descripción",               .t., "Nombre artículo",            32 )
   ::FldPropiedades()
   ::AddField ( "cCodCli", "C", 12, 0, {|| "@!" },         "Cód. cli.",                 .f., "Cod. Cliente",                8 )
   ::AddField ( "cNomCli", "C", 50, 0, {|| "@!" },         "Cliente",                   .f., "Nom. Cliente",               30 )
   ::AddField ( "cNifCli", "C", 15, 0, {|| "@!" },         "Nif",                       .f., "Nif",                        12 )
   ::AddField ( "cDomCli", "C", 35, 0, {|| "@!" },         "Domicilio",                 .f., "Domicilio",                  20 )
   ::AddField ( "cPobCli", "C", 25, 0, {|| "@!" },         "Población",                 .f., "Población",                  25 )
   ::AddField ( "cProCli", "C", 20, 0, {|| "@!" },         "Provincia",                 .f., "Provincia",                  20 )
   ::AddField ( "cCdpCli", "C",  7, 0, {|| "@!" },         "Cod. Postal",               .f., "Cod. Postal",                 7 )
   ::AddField ( "cTlfCli", "C", 12, 0, {|| "@!" },         "Teléfono",                  .f., "Teléfono",                   12 )
   ::AddField ( "cCodAlm", "C", 18, 0, {|| "@!" },         "Cod. Almacen",              .f., "Código almacén",             18 )
   ::AddField ( "cCodAge", "C", 18, 0, {|| "@!" },         "Cod. Agente",               .f., "Código agente",              18 )
   ::AddField ( "nNumCaj", "N", 16, 6, {|| MasUnd() },     cNombreCajas(),              .f., cNombreCajas(),               12 )
   ::AddField ( "nNumUnd", "N", 16, 6, {|| MasUnd() },     cNombreUnidades(),           .f., cNombreUnidades(),            12 )
   ::AddField ( "nTotUnd", "N", 16, 6, {|| MasUnd() },     "Tot. " + cNombreUnidades(), .t., "Total " + cNombreUnidades(), 12 )
   ::AddField ( "nImpArt", "N", 16, 6, {|| ::cPicOut },    "Importe",                   .t., "Importe",                    12 )
   ::AddField ( "cDocMov", "C", 14, 0, {|| "@!" },         "Documento",                 .t., "Documento",                  14 )
   ::AddField ( "dFecMov", "D",  8, 0, {|| "@!" },         "Fecha",                     .t., "Fecha",                      10 )

   ::AddTmpIndex( "cCodCli", "cCodCli + cCodObr" )

   ::AddGroup( {|| ::oDbf:cCodCli }, {|| "Cliente  : " + Rtrim( ::oDbf:cCodCli ) + "-" + oRetFld( ::oDbf:cCodCli, ::oDbfCli ) }, {||"Total Cliente..."} )
   ::AddGroup( {|| ::oDbf:cCodCli + ::oDbf:cCodObr }, {|| "Obras  : " + Rtrim( ::oDbf:cCodObr ) + "-" + RTrim ( ::oDbf:CNOMOBR ) }, {||"Total Obras..."} )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD OpenFiles()

   local lOpen    := .t.
   local oBlock   := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

   ::oAlbCliT := TDataCenter():oAlbCliT()

   DATABASE NEW ::oAlbCliL PATH ( cPatEmp() ) FILE "ALBCLIL.DBF" VIA ( cDriver() ) SHARED INDEX "ALBCLIL.CDX"

   RECOVER

      msgStop( 'Imposible abrir todas las bases de datos' )
      ::CloseFiles()
      lOpen          := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD CloseFiles()

   if !Empty( ::oAlbCliT ) .and. ::oAlbCliT:Used()
      ::oAlbCliT:End()
   end if
   if !Empty( ::oAlbCliL ) .and. ::oAlbCliL:Used()
      ::oAlbCliL:End()
   end if

   ::oAlbCliT := nil
   ::oAlbCliL := nil

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD lResource( cFld )

   local cEstado := "Todos"

   if !::StdResource( "INF_GEN04" )
      return .f.
   end if

   /*
   Monta los clientes de manera automatica
   */

   if !::oDefCliInf( 70, 80, 90, 100, , 600 )
      return .f.
   end if

   /* Monta obras */

   if !::oDefObrInf( 110, 120, 130, 140, 220 )
      return .f.
   end if

   /*
   Monta los articulos de manera automatica
   */

   if !::lDefArtInf( 150, 160, 170, 180, 800 )
      return .f.
   end if

   /*
   Damos valor al meter
   */

   ::oMtrInf:SetTotal( ::oAlbCliT:Lastrec() )

   ::oDefExcInf( 200 )

   ::oDefExcImp( 210 )

   REDEFINE COMBOBOX ::oEstado ;
      VAR      cEstado ;
      ID       218 ;
      ITEMS    ::aEstado ;
      OF       ::oFld:aDialogs[1]

   ::CreateFilter( aItmAlbCli(), ::oAlbCliT:cAlias )

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
                     {|| "Clientes  : " + if( ::lAllCli, "Todos", AllTrim( ::cCliOrg ) + " > " + AllTrim (::cCliDes ) ) },;
                     {|| "Obras     : " + if( ::lAllObr, "Todos", AllTrim( ::cObrOrg ) + " > " + AllTrim (::cObrDes ) ) },;
                     {|| "Artículos : " + if( ::lAllArt, "Todos", AllTrim( ::cArtOrg ) + " > " + AllTrim (::cArtDes ) ) },;
                     {|| "Estado    : " + ::aEstado[ ::oEstado:nAt ] } }

   ::oAlbCliT:OrdSetFocus( "dFecAlb" )
   ::oAlbCliL:OrdSetFocus( "nNumAlb" )

   do case
      case ::oEstado:nAt == 1
         cExpHead    := 'nFacturado < 3 .and. dFecAlb >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecAlb <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'
      case ::oEstado:nAt == 2
         cExpHead    := 'nFacturado == 3 .and. dFecAlb >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecAlb <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'
      case ::oEstado:nAt == 3
         cExpHead    := 'dFecAlb >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecAlb <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'
   end case

   if !::lAllCli
      cExpHead       += ' .and. cCodCli >= "' + Rtrim( ::cCliOrg ) + '" .and. cCodCli <= "' + Rtrim( ::cCliDes ) + '"'
   end if

   if !::lAllObr
      cExpHead       += ' .and. cCodObr >= "' + Rtrim( ::cObrOrg ) + '" .and. cCodObr <= "' + Rtrim( ::cObrDes ) + '"'
   end if

   if !Empty( ::oFilter:cExpresionFilter )
      cExpHead       += ' .and. ' + ::oFilter:cExpresionFilter
   end if

   ::oAlbCliT:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oAlbCliT:cFile ), ::oAlbCliT:OrdKey(), ( cExpHead ), , , , , , , , .t. )

   ::oMtrInf:SetTotal( ::oAlbCliT:OrdKeyCount() )

   /*
   Lineas de albaranes
   */

   cExpLine          := '!lTotLin .and. !lControl'

   if !::lAllArt
      cExpLine       += ' .and. cRef >= "' + ::cArtOrg + '" .and. cRef <= "' + ::cArtDes + '"'
   end if

   ::oAlbCliL:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oAlbCliL:cFile ), ::oAlbCliL:OrdKey(), cAllTrimer( cExpLine ), , , , , , , , .t. )

   /*
   Nos movemos por las cabeceras de los albaranes a proveedores
	*/

   ::oAlbCliT:GoTop()

   WHILE !::lBreak .and. !::oAlbCliT:Eof()

      IF lChkSer( ::oAlbCliT:CSERALB, ::aSer )

         /*
         Posicionamos en las lineas de detalle --------------------------------
         */

         if ::oAlbCliL:Seek( ::oAlbCliT:CSERALB + Str( ::oAlbCliT:NNUMALB ) + ::oAlbCliT:CSUFALB )

            while ::oAlbCliT:CSERALB + Str( ::oAlbCliT:NNUMALB ) + ::oAlbCliT:CSUFALB == ::oAlbCliL:CSERALB + Str( ::oAlbCliL:NNUMALB ) + ::oAlbCliL:CSUFALB .AND. ! ::oAlbCliL:eof()

               if !( ::lExcCero .AND. ::oAlbCliL:nPreUnit == 0 )

                  ::oDbf:Append()

                  ::AddCliente( ::oAlbCliT:cCodCli, ::oAlbCliT, .f. )

                  ::oDbf:cCodObr := ::oAlbCliT:cCodObr
                  ::oDbf:cNomObr := RetObras( ::oAlbCliT:cCodCli, ::oAlbCliT:cCodObr, ::oDbfObr:cAlias )
                  ::oDbf:cCodAlm := ::oAlbCliT:CCODALM
                  ::oDbf:cCodAge := ::oAlbCliT:CCODAGE
                  ::oDbf:dFecMov := ::oAlbCliT:DFECALB
                  ::oDbf:nNumCaj := ::oAlbCliL:nCanEnt
                  ::oDbf:nNumUnd := ::oAlbCliL:nUniCaja
                  ::oDbf:cCodArt := ::oAlbCliL:cRef
                  ::oDbf:cNomArt := ::oAlbCliL:cDetalle
                  ::oDbf:cCodPr1 := ::oAlbCliL:cCodPr1
                  ::oDbf:cNomPr1 := retProp( ::oAlbCliL:cCodPr1 )
                  ::oDbf:cCodPr2 := ::oAlbCliL:cCodPr2
                  ::oDbf:cNomPr2 := retProp( ::oAlbCliL:cCodPr2 )
                  ::oDbf:cValPr1 := ::oAlbCliL:cValPr1
                  ::oDbf:cNomVl1 := retValProp( ::oAlbCliL:cCodPr1 + ::oAlbCliL:cValPr1 )
                  ::oDbf:cValPr2 := ::oAlbCliL:cValPr2
                  ::oDbf:cNomVl2 := retValProp( ::oAlbCliL:cCodPr2 + ::oAlbCliL:cValPr2 )
                  ::oDbf:nTotUnd := nTotNAlbCli( ::oAlbCliL )
                  ::oDbf:nImpArt := nImpLAlbCli( ::oAlbCliT:cAlias, ::oAlbCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
                  ::oDbf:cDocMov := lTrim ( ::oAlbCliL:cSerAlb ) + "/" + lTrim ( Str( ::oAlbCliL:nNumAlb ) ) + "/" + lTrim ( ::oAlbCliL:cSufAlb )

                  ::oDbf:Save()

               end if

               ::oAlbCliL:Skip()

            end while

         end if

      end if

      ::oAlbCliT:Skip()

      ::oMtrInf:AutoInc()

   end while

   ::oAlbCliT:IdxDelete( cCurUsr(), GetFileNoExt( ::oAlbCliT:cFile ) )

   ::oAlbCliL:IdxDelete( cCurUsr(), GetFileNoExt( ::oAlbCliL:cFile ) )

   ::oMtrInf:AutoInc( ::oAlbCliT:Lastrec() )

   ::oDlg:Enable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//