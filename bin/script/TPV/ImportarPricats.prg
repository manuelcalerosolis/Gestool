#include "HbXml.ch"
#include "TDbfDbf.ch"
#include "FiveWin.Ch"
#include "Struct.ch"
#include "Factu.ch" 
#include "Ini.ch"
#include "MesDbf.ch"
#include "Report.ch"
#include "Print.ch"

#define __localDirectory            "c:\Bestseller\"
#define __localDirectoryPorcessed   "c:\Bestseller\Processed\" 

//----------------------------------------------------------------------------//

static aXmlDocuments
static oXmlDocument

static aCodigoBarras

static hArticulo
static hCodigoBarras

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

   BestsellerFtp():New()

   dbUseArea( .t., ( cDriver() ), ( cPatArt() + "Articulo.Dbf" ), ( cCheckArea( "Articulo", @dbfArticulo ) ), .t., .f. )
   if !lAIS() ; ordListAdd( ( cPatArt() + "Articulo.Cdx" ) ) ; else ; ordSetFocus( 1 ) ; end

   dbUseArea( .t., ( cDriver() ), ( cPatArt() + "ArtCodebar.Dbf" ), ( cCheckArea( "ArtCodebar", @dbfCodebar ) ), .t., .f. )
   if !lAIS() ; ordListAdd( ( cPatArt() + "ArtCodebar.Cdx" ) ) ; else ; ordSetFocus( 1 ) ; end
   ( dbfCodebar )->( ordSetFocus( "cArtBar" ) )

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

   aXmlDocuments        := directory( __localDirectory + "PRICAT_*.*" )

   if !Empty( aXmlDocuments )
      for each cDocumentXml in aXmlDocuments
         proccessXml( cDocumentXml[ 1 ] ) 
      next
   else
      msgStop( "No hay ficheros en el directorio")
   end if 

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
   local oXmlNode

   aCodigoBarras        := {}
   hArticulo            := {=>}
   cDocumentXml         := __localDirectory + cDocumentXml

   oXmlDocument         := TXmlDocument():New( cDocumentXml )

   if oXmlDocument:nStatus != HBXML_STATUS_OK

      switch oXmlDocument:nStatus
         case HBXML_STATUS_ERROR
            msgStop( "Ay! pillin, nos jorobo alguna cosa....!!" )
         case HBXML_STATUS_MALFORMED
            msgStop( "No es un documento xml" )
      end

   else

      oXmlNode                := oXmlDocument:FindFirst()
      while !Empty( oXmlNode )
         proccessNode( oXmlNode ) 
         oXmlNode             := oXmlDocument:FindNext()
      end while

   end if

   ProccessArticulo()

Return ( nil )

//---------------------------------------------------------------------------//

Static Function moveXml( cDocumentXml )

   __copyFile( __localDirectory + cDocumentXml, __localDirectoryPorcessed + cDocumentXml )
   ferase( __localDirectory + cDocumentXml )

Return ( nil )

//---------------------------------------------------------------------------//

Static Function ProccessNode( oXmlNode ) 

   local cNodeName   := cValtoChar( oXmlNode:cName )

   do case
      case cNodeName == "cac:SellersItemIdentification" 
         IteratorCodigoArticulo( oXmlNode )       

      case cNodeName == "cac:Item"
         IteratorNombreArticulo( oXmlNode )       

      case cNodeName == "cac:Price"
         IteratorPrieceArticulo( oXmlNode )   

      case cNodeName == "cac:LineValidityPeriod"
         IteratorTemporadaArticulo( oXmlNode )

      case cNodeName == "cac:CatalogueLine"
         IteratorCodebarArticulo( oXmlNode )

   end case
 
Return ( nil )

//---------------------------------------------------------------------------//

Static Function IteratorCodigoArticulo( oXmlNode )

   local oIter
   local oNode

   oIter                := TXMLIteratorScan():New( oXmlNode )
   oNode                := oIter:Find( "cbc:ID" ) 

   if !Empty( oNode )
      hSet( hArticulo, "Codigo", oNode:cData )
   end if 

Return ( nil )

//---------------------------------------------------------------------------//

Static Function IteratorNombreArticulo( oXmlNode )

   local oIter
   local oNode

   oIter                := TXMLIteratorScan():New( oXmlNode ) 
   oNode                := oIter:Find( "cbc:Description" ) 

   if !Empty( oNode )
      hSet( hArticulo, "Nombre", Upper( oNode:cData ) )
   end if 

   oNode                := oIter:Find( "cbc:BrandName" ) 

   if !Empty( oNode )
      hSet( hArticulo, "Familia", Upper( oNode:cData ) )
   end if 

   oNode                := oIter:Find( "cbc:ModelName" ) 

   if !Empty( oNode )
      hSet( hArticulo, "Tipo", Upper( oNode:cData ) )
   end if 

Return ( nil )

//---------------------------------------------------------------------------//

Static Function IteratorPrieceArticulo( oXmlNode )       

   local oIter
   local oNode
   local nPrice

   oIter                := TXMLIteratorScan():New( oXmlNode )  
   oNode                := oIter:Find( "cbc:PriceAmount" ) 

   if !Empty( oNode ) 
      nPrice            := Val( oNode:cData )
   end if 

   oNode                := oIter:Find( "cbc:PriceTypeCode" ) 

   if !Empty( oNode ) .and. ( oNode:cData == "GRP" )
      hSet( hArticulo, "Costo", nPrice )
   end if

   if !Empty( oNode ) .and. ( oNode:cData == "SRP" )
      hSet( hArticulo, "Venta", nPrice )
   end if
   
Return ( nil )

//---------------------------------------------------------------------------//

Static Function IteratorTemporadaArticulo( oXmlNode )

   local oIter
   local oNode

   oIter                := TXMLIteratorScan():New( oXmlNode )

   oNode                := oIter:Find( "cbc:Description" ) 

   if !Empty( oNode )
      hSet( hArticulo, "Temporada", Upper( oNode:cData ) )
   end if 

Return ( nil )

//---------------------------------------------------------------------------//

Static Function IteratorCodebarArticulo( oXmlNode )

   local oId
   local oItem
   local oIter
   local oNumero
   local oSellersItemIdentification
   local oItemAdditionalProperty

   hCodigoBarras                 := {=>}

   oItem                         := TXMLIteratorScan():New( oXmlNode ):Find( "cac:Item" )

   if !Empty( oItem )

      // Propiedades del item--------------------------------------------------

      oItemAdditionalProperty    := TXMLIteratorScan():New( oItem ):Find( "cac:AdditionalItemProperty" )

      while !Empty( oItemAdditionalProperty )

         oName                   := TXMLIteratorScan():New( oItemAdditionalProperty ):Find( "cbc:Name" )
         
         if !Empty( oName )

            if oName:cData == "Size"

               oValue            := TXMLIteratorScan():New( oItemAdditionalProperty ):Find( "cbc:Value" )
            
               if !hHasKey( hCodigoBarras, "Talla")
                  hSet( hCodigoBarras, "Talla", oValue:cData )
               end if 

            end if 

            if oName:cData == "ColourName"
            
               oValue            := TXMLIteratorScan():New( oItemAdditionalProperty ):Find( "cbc:Value" )
            
               if !hHasKey( hCodigoBarras, "Color")
                  if At( "/", oValue:cData ) != 0
                     hSet( hCodigoBarras, "Color", substr( oValue:cData, 1, At( "/", oValue:cData ) - 1 ) )
                  else
                     hSet( hCodigoBarras, "Color", oValue:cData )
                  end if 
               end if 

            end if 

         end if 

         oItemAdditionalProperty := oItemAdditionalProperty:nextintree()

      end while
   
      // Codigo del Item-------------------------------------------------------
      
      oSellersItemIdentification := TXMLIteratorScan():New( oItem ):Find( "cac:StandardItemIdentification" )

      if !Empty( oSellersItemIdentification )

         //msgAlert( oItem:Path(), "Path cac:StandardItemIdentification")
         
         oId                     := TXMLIteratorScan():New( oSellersItemIdentification ):Find( "cbc:ID" ) 

         if !Empty( oId )
            hSet( hCodigoBarras, "Codigo", oId:cData )
         end if

      end if 

   end if 

   aAdd( aCodigoBarras, hCodigoBarras )   

Return ( nil )

//---------------------------------------------------------------------------//

Static Function ProccessArticulo()

   local n
   local lAppend
   local cCodigo
   local hCodigoBarras

   cCodigo                       := Padr( hGet( hArticulo, "Codigo"), 18 )

   lAppend                       := !( dbfArticulo )->( dbSeek( cCodigo ) )

   if dbDialogLock( dbfArticulo, lAppend )

      ( dbfArticulo )->Codigo    := cCodigo
      ( dbfArticulo )->Nombre    := hGet( hArticulo, "Nombre" )

      ( dbfArticulo )->pCosto    := hGet( hArticulo, "Costo" )
      ( dbfArticulo )->pVtaIva1  := hGet( hArticulo, "Venta" )

      ( dbfArticulo )->lIvaInc   := .t.
      ( dbfArticulo )->TipoIva   := cDefIva()

      ( dbfArticulo )->Familia   := cCodigoFamiliaBestseller( hGet( hArticulo, "Familia") )

      ( dbfArticulo )->cCodPrp1  := "001" // Tallas 
      ( dbfArticulo )->cCodPrp2  := "003" // Colores bestseller

      ( dbfArticulo )->cCodCate  := cCodigoCategoriaBestseller() 

      ( dbfArticulo )->cCodTip   := cCodigoTipoBestseller( hGet( hArticulo, "Tipo" ) )

      ( dbfArticulo )->cCodTemp  := cCodigoTemporadaBestseller( hGet( hArticulo, "Temporada" ) )

      ( dbfArticulo )->( dbUnlock() )
   
   end if

   for each hCodigoBarras in aCodigoBarras

      lAppend                    := !( dbfCodebar )->( dbSeek( cCodigo + hGet( hCodigoBarras, "Codigo" ) ) )

      if dbDialogLock( dbfCodebar, lAppend )

         ( dbfCodebar )->cCodArt := hGet( hArticulo, "Codigo" )
         ( dbfCodebar )->cCodBar := hGet( hCodigoBarras, "Codigo" )
         ( dbfCodebar )->cCodPr1 := "001"
         ( dbfCodebar )->cCodPr2 := "003"
         ( dbfCodebar )->cValPr1 := hGet( hCodigoBarras, "Talla" )
         ( dbfCodebar )->cValPr2 := hGet( hCodigoBarras, "Color" )
 
         ( dbfCodebar )->( dbUnlock() )

      end if 

   next 

   edtArticulo( cCodigo )

Return ( nil )   

//---------------------------------------------------------------------------//

Function cCodigoFamiliaBestseller( cNombreFamilia )

   local cFamilia
   local cSubFamilia
   local cCodigoFamiliaBestseller   := ""

   cFamilia                         := substr( cNombreFamilia, 1, at( "/", cNombreFamilia ) - 1 ) 
   cSubFamilia                      := substr( cNombreFamilia, at( "/", cNombreFamilia ) + 1 ) 

   if dbSeekInOrd( cSubFamilia, "cNomFam", dbfFamilia )
      cCodigoFamiliaBestseller      := ( dbfFamilia )->cCodFam
   end if

   if Empty( cCodigoFamiliaBestseller )
      if dbSeekInOrd( cFamilia, "cNomFam", dbfFamilia )
         cCodigoFamiliaBestseller   := ( dbfFamilia )->cCodFam
      end if
   end if

Return ( cCodigoFamiliaBestseller )

//---------------------------------------------------------------------------//

Function cCodigoCategoriaBestseller()

   local cCodigoFamilia             := Alltrim( ( dbfArticulo )->Familia )
   local cCodigoCategoriaBestseller := ""

   do case
      case cCodigoFamilia == "003" .or. cCodigoFamilia == "019" // Name it kids o mini
         cCodigoCategoriaBestseller := "003"

      case cCodigoFamilia == "004" // Jack & jones
         cCodigoCategoriaBestseller := "001"

      case cCodigoFamilia == "005" // Only
         cCodigoCategoriaBestseller := "002"

   end case

Return ( cCodigoCategoriaBestseller )

//---------------------------------------------------------------------------//

Function cCodigoTipoBestseller( cCodigoTipo )

   local cCodigoTipoBestseller      := ""

   if dbSeekInOrd( cCodigoTipo, "cNomTip", dbfTipoArticulo )
      cCodigoTipoBestseller         := ( dbfTipoArticulo )->cCodTip
   end if

Return ( cCodigoTipoBestseller )

//---------------------------------------------------------------------------//

Function cCodigoTemporadaBestseller( cCodigoTemporada )

   local cCodigoTemporadaBestseller := ""

   if dbSeekInOrd( cCodigoTemporada, "Nombre", dbfTemporadaArticulo )
      cCodigoTemporadaBestseller    := ( dbfTemporadaArticulo )->cCodigo
   end if

Return ( cCodigoTemporadaBestseller )

//---------------------------------------------------------------------------//
  
#include "BestsellerFtp.prg"