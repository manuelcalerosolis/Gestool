#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS TarAge FROM TInfGen

   DATA  oCliAtp     AS OBJECT

   METHOD Create()

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHOD lResource( cFld )

   METHOD lGenerate()

END CLASS

//---------------------------------------------------------------------------//

METHOD Create() CLASS TarAge

   ::AddField(  "cCodAge", "C",  3, 0, {|| "@!" },         "Cod. age.",                 .f., "Cod. agente"         ,  6, .f.  )
   ::AddField(  "cNomAge", "C", 50, 0, {|| "@!" },         "Agente",                    .f., "Nombre agente"       , 40, .f.  )
   ::AddField(  "cCodCli", "C", 12, 0, {|| "@!" },         "Cod. cli.",                 .f., "Cod. cliente"        , 12, .f.  )
   ::AddField(  "cNomCli", "C", 50, 0, {|| "@!" },         "Cliente",                   .f., "Nombre cliente"      , 40, .f.  )
   ::AddField(  "cCodArt", "C", 18, 0, {|| "@!" },         "Cod.",                      .t., "Cod. artículo"       , 18, .f.  )
   ::AddField(  "cNomArt", "C",100, 0, {|| "@!" },         "Artículo/familia",          .t., "Artículo/familia"    , 40, .f.  )
   ::AddField(  "nPrcArt1","N", 19, 6, {|| ::cPicImp },    "Precio 1",                  .t., "Precio 1"            , 10, .f.  )
   ::AddField(  "nPrcArt2","N", 19, 6, {|| ::cPicImp },    "Precio 2",                  .f., "Precio 2"            , 10, .f.  )
   ::AddField(  "nPrcArt3","N", 19, 6, {|| ::cPicImp },    "Precio 3",                  .f., "Precio 3"            , 10, .f.  )
   ::AddField(  "nPrcArt4","N", 19, 6, {|| ::cPicImp },    "Precio 4",                  .f., "Precio 4"            , 10, .f.  )
   ::AddField(  "nPrcArt5","N", 19, 6, {|| ::cPicImp },    "Precio 5",                  .f., "Precio 5"            , 10, .f.  )
   ::AddField(  "nPrcArt6","N", 19, 6, {|| ::cPicImp },    "Precio 6",                  .f., "Precio 6"            , 10, .f.  )
   ::AddField(  "nDtoArt", "N",  6, 2, {|| "@ 999.99" },   "%Dto",                      .t., "Dto% artículo"       ,  6, .f.  )
   ::AddField(  "nDtoPrm", "N",  6, 2, {|| "@ 999.99" },   "%Dto Prm",                  .f., "Dto% promoción"      ,  6, .f.  )
   ::AddField(  "nDtoDiv", "N", 19, 6, {|| ::cPicImp },    "Dto. lineal",               .f., "Dto. lineal"         , 10, .f.  )
   ::AddField(  "nComAge", "N",  6, 2, {|| "@ 999.99" },   "Com. age.",                 .f., "Comisión agente"     ,  6, .f.  )
   ::AddField(  "dFecIni", "D",  8, 0, {|| "" },           "Inicio",                    .f., "Fecha inicio"        ,  8, .f.  )
   ::AddField(  "dFecFin", "D",  8, 0, {|| "" },           "Fin",                       .f., "Fecha fin"           ,  8, .f.  )

   ::AddTmpIndex( "cCodAge", "cCodAge + cCodCli" )

   ::AddGroup( {|| ::oDbf:cCodAge }, {|| "Agente  : " + Rtrim( ::oDbf:cCodAge ) + " - " + ::oDbf:cNomAge }, {|| Space(1) } )
   ::AddGroup( {|| ::oDbf:cCodCli }, {|| "Cliente : " + Rtrim( ::oDbf:cCodCli ) + " - " + ::oDbf:cNomCli }, {|| Space(1) } )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD OpenFiles() CLASS TarAge

   local lOpen    := .t.
   local oBlock   := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

   DATABASE NEW ::oDbfCli PATH ( cPatCli() ) FILE "CLIENT.DBF" VIA ( cDriver() ) SHARED INDEX "CLIENT.CDX"

   DATABASE NEW ::oCliAtp  PATH ( cPatCli() ) FILE "CLIATP.DBF" VIA ( cDriver() ) SHARED INDEX "CLIATP.CDX"

   DATABASE NEW ::oDbfFam PATH ( cPatArt() ) FILE "FAMILIAS.DBF" VIA ( cDriver() ) SHARED INDEX "FAMILIAS.CDX"

   DATABASE NEW ::oDbfArt PATH ( cPatArt() ) FILE "ARTICULO.DBF" VIA ( cDriver() ) SHARED INDEX "ARTICULO.CDX"

   DATABASE NEW ::oDbfDiv PATH ( cPatDat() ) FILE "DIVISAS.DBF" VIA ( cDriver() ) SHARED INDEX "DIVISAS.CDX"

   RECOVER

      msgStop( "Imposible abrir todas las bases de datos" )
      ::CloseFiles()
      lOpen          := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD CloseFiles() CLASS TarAge

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

   ::oDbfCli := nil
   ::oCliAtp := nil
   ::oDbfFam := nil
   ::oDbfArt := nil

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD lResource( cFld ) CLASS TarAge

   ::lDefFecInf   := .f.
   ::lDefDivInf   := .f.
   ::lDefSerInf   := .f.

   if !::StdResource( "INF_AGEATP" )
      return .f.
   end if

   ::oBtnFilter:Disable()

   ::lLoadDivisa()

   /*
   Monta los obras de manera automatica
   */

   if !::oDefAgeInf( 70, 80, 90, 100, 930 )
      return .f.
   end if

   /*
   Damos valor al meter
   */

   ::oMtrInf:SetTotal( ::oCliAtp:Lastrec() )

RETURN .t.

//---------------------------------------------------------------------------//
/*
Esta funcion crea la base de datos para generar posteriormente el informe
*/

METHOD lGenerate() CLASS TarAge

   local cCodAge

   ::oDlg:Disable()
   ::oBtnCancel:Enable()
   ::oDbf:Zap()

   ::oCliAtp:GoTop()

   ::aHeader   := {  {|| "Fecha   : " + Dtoc( Date() ) },;
                     {|| "Agentes : " + Rtrim( ::cAgeOrg ) + " > " + Rtrim( ::cAgeDes ) } }

   /*
   Nos movemos por las cabeceras de facturas de clientes-----------------------
	*/

   while !::lBreak .and. !::oCliAtp:Eof()

      cCodAge  := oRetFld( ::oCliAtp:cCodCli, ::oDbfCli, "cAgente" )

      if ( ::lAgeAll .or. ( cCodAge >= ::cAgeOrg .AND. cCodAge <= ::cAgeDes ) )

         /*
         Posicionamos en las lineas de detalle --------------------------------
         */

         ::oDbf:Append()

         ::oDbf:cCodAge    := cCodAge
         ::oDbf:cNomAge    := cNbrAgent( cCodAge, ::oDbfAge )

         ::oDbf:cCodCli    := ::oCliAtp:cCodCli
         ::oDbf:cNomCli    := RetClient( ::oCliAtp:cCodCli, ::oDbfCli )

         if ::oCliAtp:nTipAtp <= 1
            ::oDbf:cCodArt := ::oCliAtp:cCodArt
         else
            ::oDbf:cCodArt := ::oCliAtp:cCodFam
         end if

         if ::oCliAtp:nTipAtp <= 1
            ::oDbf:cNomArt := RetArticulo( ::oCliAtp:cCodArt, ::oDbfArt )
         else
            ::oDbf:cNomArt := RetFamilia( ::oCliAtp:cCodFam, ::oDbfFam )
         end if

         ::oDbf:nPrcArt1   := ::oCliAtp:nPrcArt
         ::oDbf:nPrcArt2   := ::oCliAtp:nPrcArt2
         ::oDbf:nPrcArt3   := ::oCliAtp:nPrcArt3
         ::oDbf:nPrcArt4   := ::oCliAtp:nPrcArt4
         ::oDbf:nPrcArt5   := ::oCliAtp:nPrcArt5
         ::oDbf:nPrcArt6   := ::oCliAtp:nPrcArt6
         ::oDbf:nDtoArt    := ::oCliAtp:nDtoArt
         ::oDbf:nDtoPrm    := ::oCliAtp:nDprArt
         ::oDbf:nDtoDiv    := ::oCliAtp:nDtoDiv
         ::oDbf:nComAge    := ::oCliAtp:nComAge
         ::oDbf:dFecIni    := ::oCliAtp:dFecIni
         ::oDbf:dFecFin    := ::oCliAtp:dFecFin

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