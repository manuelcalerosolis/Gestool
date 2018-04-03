#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS TarCli FROM TInfGen

   DATA  oCliAtp     AS OBJECT
   DATA  oDbfKit     AS OBJECT

   METHOD Create()

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHOD lResource( cFld )

   METHOD lGenerate()

END CLASS

//---------------------------------------------------------------------------//

METHOD Create()

   ::AddField(  "cCodCli", "C",  12, 0, {|| "@!" },         "Cod. Cli.",                 .f., "Cod. cliente"        ,  12, .f.  )
   ::AddField(  "cNomCli", "C",  50, 0, {|| "@!" },         "Nom. Cli.",                 .f., "Nombre cliente"      ,  40, .f.  )
   ::AddField(  "cCodArt", "C",  18, 0, {|| "@!" },         "Cod.",                      .t., "Cod. artículo"       ,  18, .f.  )
   ::AddField(  "cNomArt", "C", 100, 0, {|| "@!" },         "Artículo-familia",          .t., "Artículo-familia"    ,  40, .f.  )
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

   ::AddTmpIndex( "CCODCLI", "CCODCLI" )

   ::AddGroup( {|| ::oDbf:cCodCli }, {|| "Cliente : " + Rtrim( ::oDbf:cCodCli ) + " - " + ::oDbf:cNomCli }, {|| "" } )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD OpenFiles() CLASS TarCli

   local lOpen    := .t.
   local oBlock   := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

   DATABASE NEW ::oDbfCli PATH ( cPatEmp() ) FILE "CLIENT.DBF"    VIA ( cDriver() ) SHARED INDEX "CLIENT.CDX"

   DATABASE NEW ::oCliAtp PATH ( cPatEmp() ) FILE "CLIATP.DBF"    VIA ( cDriver() ) SHARED INDEX "CLIATP.CDX"

   DATABASE NEW ::oDbfFam PATH ( cPatEmp() ) FILE "FAMILIAS.DBF"  VIA ( cDriver() ) SHARED INDEX "FAMILIAS.CDX"

   DATABASE NEW ::oDbfArt PATH ( cPatEmp() ) FILE "ARTICULO.DBF"  VIA ( cDriver() ) SHARED INDEX "ARTICULO.CDX"

   DATABASE NEW ::oDbfKit PATH ( cPatEmp() ) FILE "ARTKIT.DBF"    VIA ( cDriver() ) SHARED INDEX "ARTKIT.CDX"

   RECOVER

      msgStop( 'Imposible abrir todas las bases de datos' )
      ::CloseFiles()
      lOpen          := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD CloseFiles() CLASS TarCli

   if !Empty( ::oDbfCli ) .and. ::oDbfCli:Used()
      ::oDbfCli:End()
   end if

   if !Empty( ::oCliAtp ) .and. ::oCliAtp:Used()
      ::oCliAtp:End()
   end if

   if !Empty( ::oDbfFam ) .and. ::oDbfFam:Used()
      ::oDbfFam:End()
   end if

   if !Empty( ::oDbfArt ) .and. ::oDbfArt:Used()
      ::oDbfArt:End()
   end if

   if !Empty( ::oDbfKit ) .and. ::oDbfKit:Used()
      ::oDbfKit:End()
   end if

   ::oDbfCli   := nil
   ::oCliAtp   := nil
   ::oDbfFam   := nil
   ::oDbfArt   := nil
   ::oDbfKit   := nil

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD lResource( cFld ) CLASS TarCli

   ::lDefSerInf   := .f.

   if !::StdResource( "INF_CLIATP" )
      return .f.
   end if

   /*
   Monta los clientes de manera automatica-------------------------------------
   */

   if !::oDefCliInf( 70, 80, 90, 100, , 600 )
      return .f.
   end if

   /*
   Damos valor al meter--------------------------------------------------------
   */

   ::oMtrInf:SetTotal( ::oCliAtp:Lastrec() )

   ::oBtnFilter:Disable()

RETURN .t.

//---------------------------------------------------------------------------//
/*
Esta funcion crea la base de datos para generar posteriormente el informe
*/

METHOD lGenerate() CLASS TarCli

   ::oDlg:Disable()
   ::oBtnCancel:Enable()
   ::oBtnFilter:Disable()
   ::oDbf:Zap()

   ::aHeader   := {  {|| "Fecha    : " + Dtoc( Date() ) },;
                     {|| "Periodo  : " + Dtoc( ::dIniInf ) + " > " + Dtoc( ::dFinInf ) },;
                     {|| "Clientes : " + Rtrim( ::cCliOrg ) + " > " + Rtrim( ::cCliDes ) },;
                     {|| "Divisa   : " + ::cDivInf + " - " + cNomDiv( ::cDivInf, ::oDbfDiv:cAlias ) }}

   ::oCliAtp:OrdSetFocus( "CCODART" )

   ::oCliAtp:GoTop()

   while !::lBreak .and. !::oCliAtp:Eof()

      if ( ::oCliAtp:dFecIni >= ::dIniInf .or. Empty( ::oCliAtp:dFecIni ) .or. Empty( ::dIniInf ) ) .and.;
         ( ::oCliAtp:dFecFin <= ::dFinInf .or. Empty( ::oCliAtp:dFecFin ) .or. Empty( ::dFinInf ) ) .and.;
         ( ::lAllCli .or. ( ::oCliAtp:cCodCli >= ::cCliOrg .and. ::oCliAtp:cCodCli <= ::cCliDes ) )

         /*
         Posicionamos en las lineas de detalle --------------------------------
         */

         ::oDbf:Append()

         ::oDbf:cCodCli       := ::oCliAtp:cCodCli
         ::oDbf:cNomCli       := RetClient( ::oCliAtp:cCodCli, ::oDbfCli )

         if ::oCliAtp:nTipAtp <= 1
            ::oDbf:cCodArt    := ::oCliAtp:cCodArt
            if ::oDbfArt:Seek( ::oCliAtp:cCodArt )
               ::oDbf:nPrcCos := nCosto( nil, ::oDbfArt:cAlias, ::oDbfKit:cAlias, .f., ::cDivInf )
            end if
         else
            ::oDbf:cCodArt    := ::oCliAtp:cCodFam
         end if

         if ::oCliAtp:nTipAtp <= 1
            ::oDbf:cNomArt    := RetArticulo( ::oCliAtp:cCodArt, ::oDbfArt )
         else
            ::oDbf:cNomArt    := RetFamilia( ::oCliAtp:cCodFam, ::oDbfFam )
         end if

         ::oDbf:nPrcArt1      := nCnv2Div( ::oCliAtp:nPrcArt,  cDivEmp(), ::cDivInf )
         ::oDbf:nPrcArt2      := nCnv2Div( ::oCliAtp:nPrcArt2, cDivEmp(), ::cDivInf )
         ::oDbf:nPrcArt3      := nCnv2Div( ::oCliAtp:nPrcArt3, cDivEmp(), ::cDivInf )
         ::oDbf:nPrcArt4      := nCnv2Div( ::oCliAtp:nPrcArt4, cDivEmp(), ::cDivInf )
         ::oDbf:nPrcArt5      := nCnv2Div( ::oCliAtp:nPrcArt5, cDivEmp(), ::cDivInf )
         ::oDbf:nPrcArt6      := nCnv2Div( ::oCliAtp:nPrcArt6, cDivEmp(), ::cDivInf )
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

   ::oMtrInf:AutoInc( ::oCliAtp:LastRec() )

   ::oDlg:Enable()
   ::oBtnFilter:Disable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//