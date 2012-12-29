#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch"
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS TarArt FROM TInfGen

   DATA  oCliAtp     AS OBJECT
   DATA  oDbfKit     AS OBJECT
   DATA  oDbfFam     AS OBJECT

   METHOD Create()

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHOD lResource( cFld )

   METHOD lGenerate()

END CLASS

//---------------------------------------------------------------------------//

METHOD Create()

   ::AddField(  "cCodCli", "C",  12, 0, {|| "@!" },         "Cod. Cli.",                 .t., "Cod. cliente"        ,  12, .f.  )
   ::AddField(  "cNomCli", "C",  50, 0, {|| "@!" },         "Nom. Cli.",                 .t., "Nombre cliente"      ,  40, .f.  )
   ::AddField(  "cCodArt", "C",  18, 0, {|| "@!" },         "Cod.",                      .f., "Cod. artículo"       ,  18, .f.  )
   ::AddField(  "cNomArt", "C", 100, 0, {|| "@!" },         "Artículo-familia",          .f., "Artículo-familia"    ,  40, .f.  )
   ::AddField(  "nPrcCos", "N",  16, 6, {|| ::cPicCom },    "Costo",                     .t., "Costo"               ,  10, .f.  )
   ::AddField(  "nPrcArt1","N",  19, 6, {|| ::cPicImp },    "Precio 1",                  .t., "Precio 1"            ,  10, .f.  )
   ::AddField(  "nPrcArt2","N",  19, 6, {|| ::cPicImp },    "Precio 2",                  .f., "Precio 2"            ,  10, .f.  )
   ::AddField(  "nPrcArt3","N",  19, 6, {|| ::cPicImp },    "Precio 3",                  .f., "Precio 3"            ,  10, .f.  )
   ::AddField(  "nPrcArt4","N",  19, 6, {|| ::cPicImp },    "Precio 4",                  .f., "Precio 4"            ,  10, .f.  )
   ::AddField(  "nPrcArt5","N",  19, 6, {|| ::cPicImp },    "Precio 5",                  .f., "Precio 5"            ,  10, .f.  )
   ::AddField(  "nPrcArt6","N",  19, 6, {|| ::cPicImp },    "Precio 6",                  .f., "Precio 6"            ,  10, .f.  )
   ::AddField(  "nDtoArt", "N",   6, 2, {|| "@ 999.99" },   "%Dto",                      .t., "Dto% artículo"       ,   6, .f.  )
   ::AddField(  "nDtoPrm", "N",   6, 2, {|| "@ 999.99" },   "%Dto Prm",                  .f., "Dto% promoción"      ,   6, .f.  )
   ::AddField(  "nDtoDiv", "N",  19, 6, {|| ::cPicImp },    "Dto. lineal",               .f., "Dto. lineal"         ,  10, .f.  )
   ::AddField(  "nComAge", "N",   6, 2, {|| "@ 999.99" },   "Com. age.",                 .f., "Comisión agente"     ,   6, .f.  )
   ::AddField(  "dFecIni", "D",   8, 0, {|| "" },           "Inicio",                    .f., "Fecha inicio"        ,   8, .f.  )
   ::AddField(  "dFecFin", "D",   8, 0, {|| "" },           "Fin",                       .f., "Fecha fin"           ,   8, .f.  )

   ::AddTmpIndex( "CCODART", "CCODART + CCODCLI" )

   ::AddGroup( {|| ::oDbf:cCodArt }, {|| "Artículo : " + Rtrim( ::oDbf:cCodArt ) + " - " + ::oDbf:cNomArt }, {|| "" } )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD OpenFiles() CLASS TarArt

   local lOpen    := .t.
   local oBlock   := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

   DATABASE NEW ::oCliAtp PATH ( cPatCli() ) FILE "CLIATP.DBF"    VIA ( cDriver() ) SHARED INDEX "CLIATP.CDX"

   DATABASE NEW ::oDbfFam PATH ( cPatArt() ) FILE "FAMILIAS.DBF"  VIA ( cDriver() ) SHARED INDEX "FAMILIAS.CDX"

   DATABASE NEW ::oDbfKit PATH ( cPatArt() ) FILE "ARTKIT.DBF"    VIA ( cDriver() ) SHARED INDEX "ARTKIT.CDX"

   RECOVER

      msgStop( 'Imposible abrir todas las bases de datos' )
      ::CloseFiles()
      lOpen          := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD CloseFiles() CLASS TarArt

   if !Empty( ::oCliAtp ) .and. ::oCliAtp:Used()
      ::oCliAtp:End()
   end if

   if !Empty( ::oDbfFam ) .and. ::oDbfFam:Used()
      ::oDbfFam:End()
   end if

   if !Empty( ::oDbfKit ) .and. ::oDbfKit:Used()
      ::oDbfKit:End()
   end if

   ::oCliAtp   := nil
   ::oDbfFam   := nil
   ::oDbfKit   := nil

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD lResource( cFld ) CLASS TarArt

   ::lDefSerInf   := .f.

   if !::StdResource( "INF_ARTATP" )
      return .f.
   end if

   /*
   Monta los desde - hasta ----------------------------------------------------
   */

   if !::lDefArtInf( 110, 111, 120, 121, 130 )
      return .f.
   end if

   if !::oDefCliInf( 70, 80, 90, 100, , 600 )
      return .f.
   end if

   /*
   Damos valor al meter--------------------------------------------------------
   */

   ::oMtrInf:SetTotal( ::oCliAtp:Lastrec() )

   ::CreateFilter( aItmAtp(), ::oCliAtp:cAlias )

RETURN .t.

//---------------------------------------------------------------------------//
/*
Esta funcion crea la base de datos para generar posteriormente el informe
*/

METHOD lGenerate() CLASS TarArt

   local cExpHead := ".t."

   ::oDlg:Disable()
   ::oBtnCancel:Enable()
   ::oDbf:Zap()

   ::aHeader   := {  {|| "Fecha    : " + Dtoc( Date() ) },;
                     {|| "Periodo  : " + Dtoc( ::dIniInf ) + " > " + Dtoc( ::dFinInf ) },;
                     {|| "Artículos: " + if( ::lAllArt, "Todos", Rtrim( ::cArtOrg ) + " > " + Rtrim( ::cArtDes ) ) },;
                     {|| "Clientes : " + if( ::lAllCli, "Todos", Rtrim( ::cCliOrg ) + " > " + Rtrim( ::cCliDes ) ) },;
                     {|| "Divisa   : " + ::cDivInf + " - " + cNomDiv( ::cDivInf, ::oDbfDiv:cAlias ) }}

   ::oCliAtp:OrdSetFocus( "CCODART" )

   if !::lAllCli
      cExpHead       += ' .and. cCodCli >= "' + ::cCliOrg + '" .and. cCodCli <= "' + ::cCliDes + '"'
   end if

   if !::lAllArt
      cExpHead       += ' .and. cCodArt >= "' + ::cArtOrg + '" .and. cCodArt <= "' + ::cArtDes + '"'
   end if

   if !Empty( ::oFilter:cExpFilter )
      cExpHead       += ' .and. ' + ::oFilter:cExpFilter
   end if

   ::oCliAtp:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oCliAtp:cFile ), ::oCliAtp:OrdKey(), ( cExpHead ), , , , , , , , .t. )

   ::oCliAtp:GoTop()

   while !::lBreak .and. !::oCliAtp:Eof()

      if ( ::oCliAtp:dFecIni >= ::dIniInf .or. Empty( ::oCliAtp:dFecIni ) .or. Empty( ::dIniInf ) ) .and.;
         ( ::oCliAtp:dFecFin <= ::dFinInf .or. Empty( ::oCliAtp:dFecFin ) .or. Empty( ::dFinInf ) )

         /*
         Posicionamos en las lineas de detalle --------------------------------
         */

         ::oDbf:Append()

         ::oDbf:cCodCli       := ::oCliAtp:cCodCli
         ::oDbf:cNomCli       := RetClient( ::oCliAtp:cCodCli, ::oDbfCli )

         if ::oCliAtp:nTipAtp <= 1
            ::oDbf:cCodArt    := ::oCliAtp:cCodArt
            if ::oDbfArt:Seek( ::oCliAtp:cCodArt )
               ::oDbf:nPrcCos := nCosto( nil, ::oDbfArt:cAlias, ::oDbfKit:cAlias, .f., ::cDivInf, ::oDbfDiv:cAlias )
            end if
         else
            ::oDbf:cCodArt    := ::oCliAtp:cCodFam
         end if

         if ::oCliAtp:nTipAtp <= 1
            ::oDbf:cNomArt    := RetArticulo( ::oCliAtp:cCodArt, ::oDbfArt )
         else
            ::oDbf:cNomArt    := RetFamilia( ::oCliAtp:cCodFam, ::oDbfFam )
         end if

         ::oDbf:nPrcArt1      := nCnv2Div( ::oCliAtp:nPrcArt,  cDivEmp(), ::cDivInf, ::oDbfDiv:cAlias )
         ::oDbf:nPrcArt2      := nCnv2Div( ::oCliAtp:nPrcArt2, cDivEmp(), ::cDivInf, ::oDbfDiv:cAlias )
         ::oDbf:nPrcArt3      := nCnv2Div( ::oCliAtp:nPrcArt3, cDivEmp(), ::cDivInf, ::oDbfDiv:cAlias )
         ::oDbf:nPrcArt4      := nCnv2Div( ::oCliAtp:nPrcArt4, cDivEmp(), ::cDivInf, ::oDbfDiv:cAlias )
         ::oDbf:nPrcArt5      := nCnv2Div( ::oCliAtp:nPrcArt5, cDivEmp(), ::cDivInf, ::oDbfDiv:cAlias )
         ::oDbf:nPrcArt6      := nCnv2Div( ::oCliAtp:nPrcArt6, cDivEmp(), ::cDivInf, ::oDbfDiv:cAlias )
         ::oDbf:nDtoArt       := ::oCliAtp:nDtoArt
         ::oDbf:nDtoPrm       := ::oCliAtp:nDprArt
         ::oDbf:nDtoDiv       := ::oCliAtp:nDtoDiv
         ::oDbf:nComAge       := ::oCliAtp:nComAge
         ::oDbf:dFecIni       := ::oCliAtp:dFecIni
         ::oDbf:dFecFin       := ::oCliAtp:dFecFin

         ::oDbf:Save()

      end if

      ::oCliAtp:Skip()

      ::oMtrInf:AutoInc( ::oCliAtp:OrdKeyNo() )

   end while

   ::oCliAtp:IdxDelete( cCurUsr(), GetFileNoExt( ::oCliAtp:cFile ) )

   ::oMtrInf:AutoInc( ::oCliAtp:LastRec() )

   ::oDlg:Enable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//