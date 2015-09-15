#include "HbXml.ch"
#include "TDbfDbf.ch"

//---------------------------------------------------------------------------//

static aXmlDocuments
static oXmlDocument

static cDirectoryXml

static aFacturaLinea

static hFacturaCabecera
static hFacturaLinea

static dbfFacPrvT
static dbfFacPrvL
static dbfFacPrvI
static dbfFacPrvD
static dbfFacPrvS
static dbfFacPrvP
static dbfPrv
static dbfIva

static dbfArticulo
static dbfCodebar
static dbfFamilia
static dbfPropieades
static dbfCategorias
static dbfTipoArticulo
static dbfTemporadaArticulo

//---------------------------------------------------------------------------//

Function ImportaXmlBestseller()

   local cDocumentXml

   dbUseArea( .t., ( cDriver() ), ( cPatEmp() + "FACPRVT.DBF" ), ( cCheckArea( "FACPRVT", @dbfFacPrvT ) ), .t., .f. ) 
   if !lAIS() ; ordListAdd( ( cPatEmp() + "FACPRVT.CDX" ) ) ; else ; ordSetFocus( 1 ) ; end

   dbUseArea( .T., ( cDriver() ), ( cPatEmp() + "FACPRVL.DBF" ), ( cCheckArea( "FACPRVL", @dbfFacPrvL ) ), .t., .f. )
   if !lAIS() ; ordListAdd( ( cPatEmp() + "FACPRVL.CDX" ) ) ; else ; ordSetFocus( 1 ) ; end

   dbUseArea( .T., ( cDriver() ), ( cPatEmp() + "FACPRVI.DBF" ), ( cCheckArea( "FACPRVI", @dbfFacPrvI ) ), .t., .f. )
   if !lAIS() ; ordListAdd( ( cPatEmp() + "FACPRVI.CDX" ) ) ; else ; ordSetFocus( 1 ) ; end

   dbUseArea( .T., ( cDriver() ), ( cPatEmp() + "FACPRVD.DBF" ), ( cCheckArea( "FACPRVD", @dbfFacPrvD ) ), .t., .f. )
   if !lAIS() ; ordListAdd( ( cPatEmp() + "FACPRVD.CDX" ) ) ; else ; ordSetFocus( 1 ) ; end

   dbUseArea( .T., ( cDriver() ), ( cPatEmp() + "FACPRVS.DBF" ), ( cCheckArea( "FACPRVS", @dbfFacPrvS ) ), .t., .f. )
   if !lAIS() ; ordListAdd( ( cPatEmp() + "FACPRVS.CDX" ) ) ; else ; ordSetFocus( 1 ) ; end

   dbUseArea( .T., ( cDriver() ), ( cPatEmp() + "FACPRVP.DBF" ), ( cCheckArea( "FACPRVP", @dbfFacPrvP ) ), .t., .f. )
   if !lAIS() ; ordListAdd( ( cPatEmp() + "FACPRVP.CDX" ) ) ; else ; ordSetFocus( 1 ) ; end

   dbUseArea( .T., ( cDriver() ), ( cPatPrv() + "PROVEE.DBF" ), ( cCheckArea( "PROVEE", @dbfPrv ) ), .t., .f. )
   if !lAIS() ; ordListAdd( ( cPatPrv() + "PROVEE.CDX" ) ) ; else ; ordSetFocus( 1 ) ; end

   dbUseArea( .T., ( cDriver() ), ( cPatDat() + "TIVA.DBF" ), ( cCheckArea( "TIVA", @dbfIva ) ), .t., .f. )
   if !lAIS() ; ordListAdd( ( cPatDat() + "TIVA.CDX" ) ) ; else ; ordSetFocus( 1 ) ; end

   dbUseArea( .t., ( cDriver() ), ( cPatArt() + "Articulo.Dbf" ), ( cCheckArea( "Articulo", @dbfArticulo ) ), .t., .f. )
   if !lAIS() ; ordListAdd( ( cPatArt() + "Articulo.Cdx" ) ) ; else ; ordSetFocus( 1 ) ; end

   dbUseArea( .t., ( cDriver() ), ( cPatArt() + "ArtCodebar.Dbf" ), ( cCheckArea( "ArtCodebar", @dbfCodebar ) ), .t., .f. )
   if !lAIS() ; ordListAdd( ( cPatArt() + "ArtCodebar.Cdx" ) ) ; else ; ordSetFocus( 1 ) ; end
   ( dbfCodebar )->( ordSetFocus( "cCodBar" ) )

   dbUseArea( .t., ( cDriver() ), ( cPatArt() + "Familias.Dbf" ), ( cCheckArea( "Familias", @dbfFamilia ) ), .t., .f. )
   if !lAIS() ; ordListAdd( ( cPatArt() + "Familias.Cdx" ) ) ; else ; ordSetFocus( 1 ) ; end

   dbUseArea( .t., ( cDriver() ), cPatArt() + "Pro.Dbf", cCheckArea( "Pro", @dbfPropieades ), .t., .f. )
   if !lAIS() ; ordListAdd( ( cPatArt() + "Pro.Cdx" ) ) ; else ; ordSetFocus( 1 ) ; end

   dbUseArea( .t., ( cDriver() ), cPatArt() + "Categorias.Dbf", cCheckArea( "Categorias", @dbfCategorias ), .t., .f. )
   if !lAIS() ; ordListAdd( ( cPatArt() + "Categorias.Cdx" ) ) ; else ; ordSetFocus( 1 ) ; end

   dbUseArea( .t., ( cDriver() ), cPatArt() + "Tipart.Dbf", cCheckArea( "Tipart", @dbfTipoArticulo ), .t., .f. )
   if !lAIS() ; ordListAdd( ( cPatArt() + "Tipart.Cdx" ) ) ; else ; ordSetFocus( 1 ) ; end

   dbUseArea( .t., ( cDriver() ), cPatArt() + "Temporadas.Dbf", cCheckArea( "Temporadas", @dbfTemporadaArticulo ), .t., .f. )
   if !lAIS() ; ordListAdd( ( cPatArt() + "Temporadas.Cdx" ) ) ; else ; ordSetFocus( 1 ) ; end

   cDirectoryXml        := "c:\Bestseller\Invoice" //cGetDir( "Selecciona directorio")

   aXmlDocuments        := Directory( cDirectoryXml + "\*.*" )

   if !Empty( aXmlDocuments )

      for each cDocumentXml in aXmlDocuments
         ProccessXml( cDocumentXml[ 1 ] )
      next

   else

      msgStop( "No hay ficheros en el directorio")

   end if 

   ( dbfFacPrvT            )->( dbCloseArea() )
   ( dbfFacPrvL            )->( dbCloseArea() )
   ( dbfFacPrvI            )->( dbCloseArea() )
   ( dbfFacPrvD            )->( dbCloseArea() )
   ( dbfFacPrvS            )->( dbCloseArea() )
   ( dbfFacPrvP            )->( dbCloseArea() )
   ( dbfPrv                )->( dbCloseArea() )

   ( dbfArticulo           )->( dbCloseArea() )
   ( dbfCodebar            )->( dbCloseArea() )
   ( dbfFamilia            )->( dbCloseArea() )
   ( dbfPropieades         )->( dbCloseArea() )
   ( dbfCategorias         )->( dbCloseArea() )
   ( dbfTipoArticulo       )->( dbCloseArea() )
   ( dbfTemporadaArticulo  )->( dbCloseArea() )

   msgStop( "Proceso finalizado :)")

Return ( nil )

//---------------------------------------------------------------------------//

Static Function ProccessXml( cDocumentXml )

   local cXml
   local oXmlDocument
   local oXmlIter
   local oTagActual

   aFacturaLinea        := {}
   hFacturaCabecera     := {=>}
   cDocumentXml         := cDirectoryXml + "\" + cDocumentXml

   oXmlDocument         := TXmlDocument():New( cDocumentXml )

   if oXmlDocument:nStatus != HBXML_STATUS_OK

      switch oXmlDocument:nStatus
         case HBXML_STATUS_ERROR
            msgStop( "Ay! pillin, nos jorobo alguna cosa....!!" )
         case HBXML_STATUS_MALFORMED
            msgStop( "No es un documento xml" )
      end

   else

      oXmlIter          := TXmlIterator():New( oXmlDocument:oRoot )

      while .t.
         oTagActual     := oXmlIter:Next()
         if oTagActual != nil
            ProccessNode( oTagActual )
            // MsgInfo( oTagActual:cName, oTagActual:cData )
            // HEval( oTagActual:aAttributes, { | cKey, cValue | MsgStop( cKey, cValue ) } )
         else
            exit
         endif
      end

      ProccessFactura()

   end if

/*
      while !Empty( oActual )
         
         MsgInfo( oActual:cName, oActual:cData )
         
         ProccessNode( oActual ) 

         oActual        := oActual:Next()

      end while


   end if
*/

Return ( nil )

//---------------------------------------------------------------------------//

Static Function ProccessNode( oXmlNode ) 

   local cNodeName   := cValtoChar( oXmlNode:cName )

   do case
      case cNodeName == "Invoice"
         msgwait("invoice","invoice",.1) 
         IteratorInvoice( oXmlNode )   

      case cNodeName == "cac:InvoiceLine"
         IteratorInvoiceLine( oXmlNode )

   end case
 
Return ( nil )

//---------------------------------------------------------------------------//

Static Function IteratorInvoice( oXmlNode )

   local oIter
   local oNode

   oIter                := TXMLIteratorScan():New( oXmlNode )
   
   oNode                := oIter:Find( "cbc:ID" ) 
   if !Empty( oNode )
      hSet( hFacturaCabecera, "Numero", Val( oNode:cData ) )
   end if 

   oNode                := oIter:Find( "cbc:IssueDate" ) 
   if !Empty( oNode )
      hSet( hFacturaCabecera, "Fecha", StoD( StrTran( oNode:cData, "-", "" ) ) )
   end if 

Return ( nil )

//---------------------------------------------------------------------------//

Static Function IteratorInvoiceLine( oXmlNode )

   local oId
   local oItem
   local oQuantity
   local oPrice
   local oNode
   local oStandard
   local oDescription

   hFacturaLinea        := {=>}

   // Unidades-----------------------------------------------------------------

   oQuantity            := TXMLIteratorScan():New( oXmlNode ):Find( "cbc:InvoicedQuantity" ) 

   if !Empty( oQuantity )
      hSet( hFacturaLinea, "Unidades", Val( oQuantity:cData ) )
   end if 

   // Código-------------------------------------------------------------------

   oItem                := TXMLIteratorScan():New( oXmlNode ):Find( "cac:Item" ) 

   if !Empty( oItem )

      oStandard         := TXMLIteratorScan():New( oItem ):Find( "cac:StandardItemIdentification" )

      if !Empty( oStandard )

         oId            := TXMLIteratorScan():New( oStandard ):Find( "cbc:ID" )

         if !Empty( oId )
            msgwait( oId:cData, "Codigo encontrado", .1 )
            hSet( hFacturaLinea, "Codigo", oId:cData )
         end if 

      end if 

      // Descripcion-----------------------------------------------------------

      oDescription      := TXMLIteratorScan():New( oItem ):Find( "cbc:Name" )

      if !Empty( oDescription )
         hSet( hFacturaLinea, "Descripcion", oDescription:cData )
      end if 

   end if

   // Precio-------------------------------------------------------------------

   oItem                := TXMLIteratorScan():New( oXmlNode ):Find( "cac:Price" ) 

   if !Empty( oItem )

      oPrice            := TXMLIteratorScan():New( oItem ):Find( "cbc:PriceAmount" )

      if !Empty( oPrice )

         hSet( hFacturaLinea, "Precio", Val( oPrice:cData ) )

      end if 

   end if 

   aAdd( aFacturaLinea, hFacturaLinea )

   // msgStop( valtoprg( hFacturaLinea ) )

Return ( nil )

//---------------------------------------------------------------------------//

Static Function ProccessFactura()

   local hLinea
   local lAppend                 
   local cNumero                    
   local nNumero 
   local dFecha 

   if Empty( hFacturaCabecera )
      Return ( nil )      
   end if

   cNumero                          := "A" + Str( hGet( hFacturaCabecera, "Numero" ), 9 ) + "00"
   nNumero 							:= hGet( hFacturaCabecera, "Numero" )
   dFecha 							:= hGet( hFacturaCabecera, "Fecha")
   lAppend                          := !( dbfFacPrvT )->( dbSeek( cNumero ) )

   if dbDialogLock( dbfFacPrvT, lAppend )

      ( dbfFacPrvT )->cSerFac       := "A"
      ( dbfFacPrvT )->nNumFac       := nNumero
      ( dbfFacPrvT )->cSufFac       := "00"
      ( dbfFacPrvT )->dFecFac       := dFecha
      ( dbfFacPrvT )->cCodPrv       := "0000003"
      ( dbfFacPrvT )->cCodAlm       := "000"
      ( dbfFacPrvT )->cCodCaj       := "000"
      ( dbfFacPrvT )->cNomPrv       := "BESTSELLER WHOLESALE S.L.U."
      ( dbfFacPrvT )->cDirPrv       := "Av. Los Manantianles Esq. C.N. 340"
      ( dbfFacPrvT )->cPobPrv       := "Torremolinos"
      ( dbfFacPrvT )->cProvProv     := "Malaga"
      ( dbfFacPrvT )->cPosPrv       := "29620"
      ( dbfFacPrvT )->cDniPrv       := "B29826351"
      ( dbfFacPrvT )->cCodPago      := "60"

      ( dbfFacPrvT )->( dbUnlock() )
   
   end if

   while ( dbfFacPrvL )->( dbSeek( cNumero ) ) .and. !( dbfFacPrvL )->( eof() )
      if dbLock( dbfFacPrvL )
         ( dbfFacPrvL )->( dbDelete() )
         ( dbfFacPrvL )->( dbUnLock() )
      end if
   end while

   for each hLinea in aFacturaLinea

      if CodigoPropiedadesLineas( hLinea )

         if dbDialogLock( dbfFacPrvL, .t. )

            msgwait( "linea" + str( hb_enumindex() ), "procesando linea", .1 )

            ( dbfFacPrvL )->nNumLin    := hb_enumIndex()
            ( dbfFacPrvL )->cSerFac    := "A"
            ( dbfFacPrvL )->nNumFac    := nNumero 
            ( dbfFacPrvL )->cSufFac    := "00"
            ( dbfFacPrvL )->cAlmLin    := "000"
            ( dbfFacPrvL )->cRef       := hGet( hLinea, "Referencia" )
            ( dbfFacPrvL )->cDetalle   := hGet( hLinea, "Descripcion" )
            ( dbfFacPrvL )->cCodPr1    := hGet( hLinea, "Codigo propiedad 1" )
            ( dbfFacPrvL )->cCodPr2    := hGet( hLinea, "Codigo propiedad 2" )
            ( dbfFacPrvL )->cValPr1    := hGet( hLinea, "Valor propiedad 1" )
            ( dbfFacPrvL )->cValPr2    := hGet( hLinea, "Valor propiedad 2" )
            ( dbfFacPrvL )->nUniCaja   := hGet( hLinea, "Unidades" )
            ( dbfFacPrvL )->nPreUnit   := hGet( hLinea, "Precio" )
            ( dbfFacPrvL )->nIva       := 21

            ( dbfFacPrvL )->( dbUnlock() )

         else  
            msgWait("no puedo bloquear", "stop", .1 )
         end if 

      else  
         msgWait("no CodigoPropiedadesLineas", "stop", .1 )

      end if 

   next

   EdtFacPrv( cNumero )

Return ( nil )

//---------------------------------------------------------------------------//

Static Function CodigoPropiedadesLineas( hLinea )

   local lReturn 					:= .f.
   local cCodigo                    := alltrim( hGet( hLinea, "Codigo" ) )
   local nOrd 						:= ( dbfCodebar )->( ordsetfocus( "cCodBar" ) )

   if ( dbfCodebar )->( dbSeek( cCodigo ) )
      
      hSet( hLinea, "Referencia",         ( dbfCodebar )->cCodArt )
      hSet( hLinea, "Codigo propiedad 1", ( dbfCodebar )->cCodPr1 )
      hSet( hLinea, "Codigo propiedad 2", ( dbfCodebar )->cCodPr2 )
      hSet( hLinea, "Valor propiedad 1",  ( dbfCodebar )->cValPr1 )
      hSet( hLinea, "Valor propiedad 2",  ( dbfCodebar )->cValPr2 )

      lReturn := .t.

   else

      msgWait( "Codigo de barras " + Alltrim( cCodigo ) + " no encontrado.", "Atención", .1 )

   end if 

   ( dbfCodebar )->( ordsetfocus( nOrd ) )

Return ( lReturn )

//---------------------------------------------------------------------------//