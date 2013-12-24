#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS TInfTrazLot FROM TInfGen

   DATA  oDbfTmp  AS OBJECT
   DATA  cLote    AS CHARACTER

   METHOD Create()

   METHod lResource( cFld )

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHOD lGenerate()

END CLASS

//---------------------------------------------------------------------------//

METHOD OpenFiles() CLASS TInfTrazLot
RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD CloseFiles() CLASS TInfTrazLot
RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD Create()

   ::AddField( "cTipDoc",  "C",40, 0, {|| "@!" },     "Tip. Doc.",    .f., "Tipo de documento",     25, .f.  )
   ::AddField( "cNumDoc",  "C",12, 0, {|| "@!" },     "Num. Doc.",    .t., "Número del documento",  15, .f.  )
   ::AddField( "dFecDoc",  "D", 8, 0, {|| "@!" },     "Fecha",        .t., "Fecha del documento",   12, .f.  )
   ::AddField( "cCodCli",  "C",12, 0, {|| "@!" },     "Cod. Cli/Prv", .t., "Código del Cli/Prv",    15, .f.  )
   ::AddField( "cNomCli",  "C",50, 0, {|| "@!" },     "Nom. Cli/Prv", .t., "Nombre del Cli/Prv",    50, .f.  )
   ::AddField( "cCodObr",  "C",10, 0, {|| "@!" },     "Obra",         .f., "Obra",                  10, .f.  )
   ::AddField( "cCodigo",  "C",18, 0, {|| "@!" },     "Código artículo",    .t., "Código del artículo",   18, .f.  )
   ::AddField( "cNomArt",  "C",100,0, {|| "@!" },     "Nom. Art.",    .t., "Nombre del artículo",   20, .f.  )
   ::AddField( "nUnidades","N",16, 6, {|| MasUnd() }, "Und.",         .t., "Unidades de artículo",  10, .t.  )
   ::AddField( "cLote",    "C",12, 0, {|| "@!" },     "Lote",         .t., "Lote",                  10, .f.  )

   ::AddTmpIndex ( "cTipDoc", "cTipDoc + Dtos( dFecDoc )" ) 

   ::AddGroup( {|| ::oDbf:cTipDoc }, {|| "Documento : " + Rtrim( ::oDbf:cTipDoc ) }, {||"Total grupo..."} )

   ::lDefSerInf   := .f.

   ::oDbfTmp      := ::xOthers[ 1 ]
   ::cLote        := ::xOthers[ 2 ]

RETURN ( Self )

//---------------------------------------------------------------------------//

METHod lResource( cFld )

   if !::StdResource( "INF_TRAZALOTE" )
      return .f.
   end if

   ::oBtnFilter:Disable()

   ::oMtrInf:SetTotal( ::oDbfTmp:Lastrec() )

RETURN .t.

//---------------------------------------------------------------------------//
/*
Esta funcion crea la base de datos para generar posteriormente el informe
*/

METHOD lGenerate()

   local oBlock
   local oError

   oBlock         := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   ::oDlg:Disable()

   ::oDbf:Zap()

   ::aHeader      := { {|| "Fecha : " + Dtoc( Date() ) }, {|| "Lote  : " + AllTrim( ::cLote ) } }

   ::oDbfTmp:GoTop()
   while !::oDbfTmp:Eof()

      if ::oDbfTmp:dFecDoc >= ::dIniInf .and. ::oDbfTmp:dFecDoc <= ::dFinInf

         ::oDbf:Append()

         ::oDbf:cTipDoc     := ::oDbfTmp:cTipDoc
         ::oDbf:cNumDoc     := ::oDbfTmp:cNumDoc
         ::oDbf:cCodigo     := ::oDbfTmp:cCodigo
         ::oDbf:cNomArt     := AllTrim( ::oDbfTmp:cNomArt )
         ::oDbf:dFecDoc     := ::oDbfTmp:dFecDoc
         ::oDbf:cCodCli     := ::oDbfTmp:cCodCli
         ::oDbf:cNomCli     := ::oDbfTmp:cNomCli
         ::oDbf:cCodObr     := ::oDbfTmp:cCodObr
         ::oDbf:cLote       := ::oDbfTmp:cLote

         do case
            case (  AllTrim( ::oDbfTmp:cTipDoc ) == "Pedido a proveedor"                .or.;
                    AllTrim( ::oDbfTmp:cTipDoc ) == "Albarán de proveedor"              .or.;
                    AllTrim( ::oDbfTmp:cTipDoc ) == "Factura de proveedor"              .or.;
                    AllTrim( ::oDbfTmp:cTipDoc ) == "Movimiento de almacén"             .or.;
                    AllTrim( ::oDbfTmp:cTipDoc ) == "Material producido" )

              ::oDbf:nUnidades   := ::oDbfTmp:nUnidades

            case (  AllTrim( ::oDbfTmp:cTipDoc ) == "Presupuesto de cliente"            .or.;
                    AllTrim( ::oDbfTmp:cTipDoc ) == "Pedido de cliente"                 .or.;
                    AllTrim( ::oDbfTmp:cTipDoc ) == "Albarán de cliente"                .or.;
                    AllTrim( ::oDbfTmp:cTipDoc ) == "Factura de cliente"                .or.;
                    AllTrim( ::oDbfTmp:cTipDoc ) == "Factura rectificativa de cliente"  .or.;
                    AllTrim( ::oDbfTmp:cTipDoc ) == "Material consumido" )

              ::oDbf:nUnidades   := -( ::oDbfTmp:nUnidades )

         end case

         ::oDbf:Save()

      end if

      ::oDbfTmp:Skip()

      ::oMtrInf:AutoInc( ::oDbfTmp:OrdKeyNo() )

   end while

   ::oMtrInf:AutoInc( ::oDbfTmp:LastRec() )

   ::oBtnFilter:Disable()

   ::oDbfTmp:GoTop()

   ::oDlg:Enable()

   RECOVER USING oError

      msgStop( "Erroe al generar el informe" + CRLF + ErrorMessage( oError )  )

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//