#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS TInfTrazLot FROM TInfGen

   DATA  cLote    

   DATA  dbfTmp

   METHOD Create()

   METHod lResource( cFld )

   METHOD OpenFiles()       VIRTUAL
   METHOD CloseFiles()      VIRTUAL

   METHOD lGenerate()

END CLASS

//---------------------------------------------------------------------------//

METHOD Create()

   ::AddField( "cTipDoc",  "C",40, 0, {|| "@!" },     "Tip. Doc.",          .f., "Tipo de documento",     25, .f.  )
   ::AddField( "cNumDoc",  "C",12, 0, {|| "@!" },     "Num. Doc.",          .t., "Número del documento",  15, .f.  )
   ::AddField( "dFecDoc",  "D", 8, 0, {|| "@!" },     "Fecha",              .t., "Fecha del documento",   12, .f.  )
   ::AddField( "cCodCli",  "C",12, 0, {|| "@!" },     "Cod. Cli/Prv",       .t., "Código del Cli/Prv",    15, .f.  )
   ::AddField( "cNomCli",  "C",50, 0, {|| "@!" },     "Nom. Cli/Prv",       .t., "Nombre del Cli/Prv",    50, .f.  )
   ::AddField( "cCodObr",  "C",10, 0, {|| "@!" },     "Dirección",               .f., "Dirección",                  10, .f.  )
   ::AddField( "cCodigo",  "C",18, 0, {|| "@!" },     "Código artículo",    .t., "Código del artículo",   18, .f.  )
   ::AddField( "cNomArt",  "C",100,0, {|| "@!" },     "Nom. Art.",          .t., "Nombre del artículo",   20, .f.  )
   ::AddField( "nUnidades","N",16, 6, {|| MasUnd() }, "Und.",               .t., "Unidades de artículo",  10, .t.  )
   ::AddField( "cLote",    "C",14, 0, {|| "@!" },     "Lote",               .t., "Lote",                  10, .f.  )

   ::AddTmpIndex ( "cTipDoc", "cTipDoc + Dtos( dFecDoc )" ) 

   ::AddGroup( {|| ::oDbf:cTipDoc }, {|| "Documento : " + Rtrim( ::oDbf:cTipDoc ) }, {||"Total grupo..."} )

   ::lDefSerInf   := .f.

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD lResource( cFld )

   if !::StdResource( "INF_TRAZALOTE" )
      return .f.
   end if

   ::oBtnFilter:Disable()

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

   ::oMtrInf:SetTotal( ( ::dbfTmp )->( OrdKeyCount() ) )

   ::aHeader      := { {|| "Fecha : " + Dtoc( Date() ) }, {|| "Lote  : " + AllTrim( ::cLote ) } }

   ( ::dbfTmp )->( dbGoTop() )
   while !( ::dbfTmp )->( Eof() )

      if ( ::dbfTmp )->dFecDoc >= ::dIniInf .and. ( ::dbfTmp )->dFecDoc <= ::dFinInf

         ::oDbf:Append()

         ::oDbf:cTipDoc     := ( ::dbfTmp )->cTipDoc
         ::oDbf:cNumDoc     := ( ::dbfTmp )->cNumDoc
         ::oDbf:cCodigo     := ( ::dbfTmp )->cCodigo
         ::oDbf:cNomArt     := AllTrim( ( ::dbfTmp )->cNomArt )
         ::oDbf:dFecDoc     := ( ::dbfTmp )->dFecDoc
         ::oDbf:cCodCli     := ( ::dbfTmp )->cCodCli
         ::oDbf:cNomCli     := ( ::dbfTmp )->cNomCli
         ::oDbf:cCodObr     := ( ::dbfTmp )->cCodObr
         ::oDbf:cLote       := ( ::dbfTmp )->cLote

         do case
            case (  AllTrim( ( ::dbfTmp )->cTipDoc ) == "Pedido a proveedor"                .or.;
                    AllTrim( ( ::dbfTmp )->cTipDoc ) == "Albarán de proveedor"              .or.;
                    AllTrim( ( ::dbfTmp )->cTipDoc ) == "Factura de proveedor"              .or.;
                    AllTrim( ( ::dbfTmp )->cTipDoc ) == "Movimiento de almacén"             .or.;
                    AllTrim( ( ::dbfTmp )->cTipDoc ) == "Material producido" )

              ::oDbf:nUnidades   := ( ::dbfTmp )->nUnidades

            case (  AllTrim( ( ::dbfTmp )->cTipDoc ) == "Presupuesto de cliente"            .or.;
                    AllTrim( ( ::dbfTmp )->cTipDoc ) == "Pedido de cliente"                 .or.;
                    AllTrim( ( ::dbfTmp )->cTipDoc ) == "Albarán de cliente"                .or.;
                    AllTrim( ( ::dbfTmp )->cTipDoc ) == "Factura de cliente"                .or.;
                    AllTrim( ( ::dbfTmp )->cTipDoc ) == "Factura rectificativa de cliente"  .or.;
                    AllTrim( ( ::dbfTmp )->cTipDoc ) == "Material consumido" )

              ::oDbf:nUnidades   := -( ( ::dbfTmp )->nUnidades )

         end case

         ::oDbf:Save()

      end if

      ( ::dbfTmp )->( dbSkip() )

      ::oMtrInf:AutoInc( ( ::dbfTmp )->( OrdKeyNo() ) )

   end while

   ::oMtrInf:AutoInc( ( ::dbfTmp )->( OrdKeyCount() ) )

   ( ::dbfTmp )->( dbGoTop() )

   ::oDlg:Enable()

   RECOVER USING oError

      msgStop( "Error al generar el informe" + CRLF + ErrorMessage( oError )  )

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//