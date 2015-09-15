#include "HbXml.ch" 
#include "TDbfDbf.ch"   


//---------------------------------------------------------------------------//

static aXmlDocuments
static oXmlDocument

static cDirectoryXml

static aCodigoBarras

static hArticulo
static hCodigoBarras

static dbfArticulo
static dbfCodebar
static dbfArtDiv
static dbfFamilia
static dbfFabricante
static dbfPropieades
static dbfCategorias
static dbfTipoArticulo
static dbfTemporadaArticulo
static dbfLineasPropiedades

//---------------------------------------------------------------------------//

Function ImportaXmlBestseller()

   local cDocumentXml

   dbUseArea( .t., ( cDriver() ), ( cPatArt() + "Articulo.Dbf" ), ( cCheckArea( "Articulo", @dbfArticulo ) ), .t., .f. )
   if !lAIS() ; ordListAdd( ( cPatArt() + "Articulo.Cdx" ) ) ; else ; ordSetFocus( 1 ) ; end

   dbUseArea( .t., ( cDriver() ), ( cPatArt() + "ArtCodebar.Dbf" ), ( cCheckArea( "ArtCodebar", @dbfCodebar ) ), .t., .f. )
   if !lAIS() ; ordListAdd( ( cPatArt() + "ArtCodebar.Cdx" ) ) ; else ; ordSetFocus( 1 ) ; end
   ( dbfCodebar )->( ordSetFocus( "cArtBar" ) )

   dbUseArea( .t., ( cDriver() ), ( cPatArt() + "ArtDiv.Dbf" ), ( cCheckArea( "ArtDiv", @dbfArtDiv ) ), .t., .f. )
   if !lAIS() ; ordListAdd( ( cPatArt() + "ArtDiv.Cdx" ) ) ; else ; ordSetFocus( 1 ) ; end
   ( dbfArtDiv )->( ordSetFocus( "cCodArt" ) )

   dbUseArea( .t., ( cDriver() ), ( cPatArt() + "Familias.Dbf" ), ( cCheckArea( "Familias", @dbfFamilia ) ), .t., .f. )
   if !lAIS() ; ordListAdd( ( cPatArt() + "Familias.Cdx" ) ) ; else ; ordSetFocus( 1 ) ; end

   dbUseArea( .t., ( cDriver() ), ( cPatArt() + "Fabricantes.Dbf" ), ( cCheckArea( "Fabricante", @dbfFabricante ) ), .t., .f. )
   if !lAIS() ; ordListAdd( ( cPatArt() + "Fabricantes.Cdx" ) ) ; else ; ordSetFocus( 1 ) ; end

   dbUseArea( .t., ( cDriver() ), cPatArt() + "Pro.Dbf", cCheckArea( "Pro", @dbfPropieades ), .t., .f. )
   if !lAIS() ; ordListAdd( ( cPatArt() + "Pro.Cdx" ) ) ; else ; ordSetFocus( 1 ) ; end

   dbUseArea( .t., ( cDriver() ), cPatArt() + "TblPro.Dbf", cCheckArea( "TblPro", @dbfLineasPropiedades ), .t., .f. )
   if !lAIS() ; ordListAdd( ( cPatArt() + "TblPro.Cdx" ) ) ; else ; ordSetFocus( 1 ) ; end

   dbUseArea( .t., ( cDriver() ), cPatArt() + "Categorias.Dbf", cCheckArea( "Categorias", @dbfCategorias ), .t., .f. )
   if !lAIS() ; ordListAdd( ( cPatArt() + "Categorias.Cdx" ) ) ; else ; ordSetFocus( 1 ) ; end

   dbUseArea( .t., ( cDriver() ), cPatArt() + "Tipart.Dbf", cCheckArea( "Tipart", @dbfTipoArticulo ), .t., .f. )
   if !lAIS() ; ordListAdd( ( cPatArt() + "Tipart.Cdx" ) ) ; else ; ordSetFocus( 1 ) ; end

   dbUseArea( .t., ( cDriver() ), cPatArt() + "Temporadas.Dbf", cCheckArea( "Temporadas", @dbfTemporadaArticulo ), .t., .f. )
   if !lAIS() ; ordListAdd( ( cPatArt() + "Temporadas.Cdx" ) ) ; else ; ordSetFocus( 1 ) ; end

   cDirectoryXml        := "C:\Bestseller\Pricat" //cGetDir( "Selecciona directorio")

   aXmlDocuments        := Directory( cDirectoryXml + "\*.*" )

   if !Empty( aXmlDocuments )

      for each cDocumentXml in aXmlDocuments
         ProccessXml( cDocumentXml[ 1 ] )
      next

   else

      msgStop( "No hay ficheros en el directorio")

   end if 

   ( dbfArticulo           )->( dbCloseArea() )
   ( dbfCodebar            )->( dbCloseArea() )
   ( dbfArtDiv             )->( dbCloseArea() )
   ( dbfFamilia            )->( dbCloseArea() )
   ( dbfFabricante         )->( dbCloseArea() )
   ( dbfPropieades         )->( dbCloseArea() )
   ( dbfLineasPropiedades  )->( dbCloseArea() )
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
   cDocumentXml         := cDirectoryXml + "\" + cDocumentXml

   // msgStop( cDocumentXml, "cDocumentXml" )

   oXmlDocument         := TXmlDocument():New( cDocumentXml )

   if oXmlDocument:nStatus != HBXML_STATUS_OK

      switch oXmlDocument:nStatus
         case HBXML_STATUS_ERROR
            msgStop( "Ay! pillin, nos jorobo alguna cosa....!!" )
         case HBXML_STATUS_MALFORMED
            msgStop( "No es un documento xml" )
      end

   else

      oXmlNode                := oXmlDocument:oRoot

      while !Empty( oXmlNode )

         ProccessNode( oXmlNode ) 

         oXmlNode             := oXmlNode:NextInTree()

      end while

   end if

   ProccessArticulo()

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
      hSet( hArticulo, "Fabricante", Upper( oNode:cData ) )
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

                  hSet( hCodigoBarras, "Color", cNombreColor( oValue:cData ) )

               end if 

            end if 

            if oName:cData == "HexCode"
            
               oValue            := TXMLIteratorScan():New( oItemAdditionalProperty ):Find( "cbc:Value" )

               if !hHasKey( hCodigoBarras, "RGB")
                  hSet( hCodigoBarras, "RGB", hb_HexToNum( SubStr( oValue:cData, 2 ) ) )
               end if 

            end if 

         end if 

         oItemAdditionalProperty := oItemAdditionalProperty:NextInTree()

      end while
   
      // Codigo del Item-------------------------------------------------------
      
      oSellersItemIdentification := TXMLIteratorScan():New( oItem ):Find( "cac:StandardItemIdentification" )

      if !Empty( oSellersItemIdentification )

         // msgAlert( oItem:Path(), "Path cac:StandardItemIdentification")
         
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
   local cValPrp1
   local cValPrp2

   cCodigo                       := Padr( hGet( hArticulo, "Codigo"), 18 )

   lAppend                       := !( dbfArticulo )->( dbSeek( cCodigo ) )

   if dbDialogLock( dbfArticulo, lAppend )

      ( dbfArticulo )->Codigo    := cCodigo
      ( dbfArticulo )->Nombre    := hGet( hArticulo, "Nombre" )

      ( dbfArticulo )->pCosto    := hGet( hArticulo, "Costo" )
      ( dbfArticulo )->pVtaIva1  := hGet( hArticulo, "Venta" )

      ( dbfArticulo )->lIvaInc   := .t.
      ( dbfArticulo )->TipoIva   := cDefIva()

      ( dbfArticulo )->cCodPrp1  := "001" // Tallas 
      ( dbfArticulo )->cCodPrp2  := "003" // Colores bestseller

      ( dbfArticulo )->cCodFab   := cCodigoFabricanteBestseller( hGet( hArticulo, "Fabricante" ) )

      if Empty( ( dbfArticulo )->cCodCate ) 
      ( dbfArticulo )->cCodCate  := cCodigoCategoriaBestseller() 
      end if

      if Empty( ( dbfArticulo )->cCodTip ) 
      ( dbfArticulo )->cCodTip   := cCodigoTipoBestseller( hGet( hArticulo, "Tipo" ) )
      end if

      if Empty( ( dbfArticulo )->cCodTemp ) 
      ( dbfArticulo )->cCodTemp  := cCodigoTemporadaBestseller( hGet( hArticulo, "Temporada" ) )
      end if

      ( dbfArticulo )->( dbUnlock() )
   
   end if

   // msgStop( len( aCodigoBarras ) )

   for each hCodigoBarras in aCodigoBarras

      /*
      Rellenamos los códigos de barras-----------------------------------------
      */

      cValPrp1                   := Upper( hGet( hCodigoBarras, "Talla" ) )
      cValPrp2                   := Upper( hGet( hCodigoBarras, "Color" ) )

      lAppend                    := !( dbfCodebar )->( dbSeek( cCodigo + hGet( hCodigoBarras, "Codigo" ) ) )

      if dbDialogLock( dbfCodebar, lAppend )

         ( dbfCodebar )->cCodArt := hGet( hArticulo, "Codigo" )
         ( dbfCodebar )->cCodBar := hGet( hCodigoBarras, "Codigo" )
         ( dbfCodebar )->cCodPr1 := "001"
         ( dbfCodebar )->cCodPr2 := "003"
         ( dbfCodebar )->cValPr1 := cValPrp1
         ( dbfCodebar )->cValPr2 := cValPrp2

         ( dbfCodebar )->( dbUnlock() )

      end if 

      /*
      Rellenamos la tabla de precios por propiedades---------------------------
      */

      if !( dbfArtDiv )->( dbSeek( cCodigo + Padr( "001", 20 ) + Padr( "003", 20 ) + Padr( cValPrp1, 40 ) + Padr( cValPrp2, 40 ) ) )

         ( dbfArtDiv )->( dbAppend() )

         ( dbfArtDiv )->cCodArt  := hGet( hArticulo, "Codigo" )
         ( dbfArtDiv )->cCodPr1  := "001"
         ( dbfArtDiv )->cCodPr2  := "003"
         ( dbfArtDiv )->cValPr1  := cValPrp1
         ( dbfArtDiv )->cValPr2  := cValPrp2
         ( dbfArtDiv )->nPreCom  := hGet( hArticulo, "Costo" )
         ( dbfArtDiv )->nPreIva1 := hGet( hArticulo, "Venta" )

         ( dbfArtDiv )->( dbUnlock() )

      else
      
         if dbLock( dbfArtDiv )

            ( dbfArtDiv )->nPreCom  := hGet( hArticulo, "Costo" )
            ( dbfArtDiv )->nPreIva1 := hGet( hArticulo, "Venta" )

            ( dbfArtDiv )->( dbUnlock() )  

         end if   

      end if   

      /*
      Comprobamos que existan las distintas propiedades---------------------
      */

      if !( dbfLineasPropiedades )->( dbSeek( Padr( "001", 20 ) + Padr( cValPrp1, 40 ) ) )
            
         ( dbfLineasPropiedades )->( dbAppend() )

         ( dbfLineasPropiedades )->cCodPro   := "001"
         ( dbfLineasPropiedades )->cCodTbl   := cValPrp1
         ( dbfLineasPropiedades )->cDesTbl   := cValPrp1

         ( dbfLineasPropiedades )->( dbUnlock() )

      end if   

      if !( dbfLineasPropiedades )->( dbSeek( Padr( "003", 20 ) + Padr( cValPrp2, 40 ) ) )
            
         ( dbfLineasPropiedades )->( dbAppend() )

         ( dbfLineasPropiedades )->cCodPro   := "003"
         ( dbfLineasPropiedades )->cCodTbl   := cValPrp2
         ( dbfLineasPropiedades )->cDesTbl   := cValPrp2
         ( dbfLineasPropiedades )->nColor    := hGet( hCodigoBarras, "RGB" )

         ( dbfLineasPropiedades )->( dbUnlock() )

      else

         if DbLock( dbfLineasPropiedades )
            ( dbfLineasPropiedades )->nColor := hGet( hCodigoBarras, "RGB" )
            ( dbfLineasPropiedades )->( dbUnlock() )
         end if      

      end if

   next 

   EdtArticulo( cCodigo )

Return ( nil )   

//---------------------------------------------------------------------------//

Function cCodigoFabricanteBestseller( cNombreFabricante )

   local cFabricante
   local cSubFabricante
   local cCodigoFabricanteBestseller   := ""

   cFabricante                         := substr( cNombreFabricante, 1, at( "/", cNombreFabricante ) - 1 ) 
   cSubFabricante                      := substr( cNombreFabricante, at( "/", cNombreFabricante ) + 1 ) 

   if dbSeekInOrd( cSubFabricante, "cNomFab", dbfFabricante )
      cCodigoFabricanteBestseller      := ( dbfFabricante )->cCodFab
   end if

   if Empty( cCodigoFabricanteBestseller )
      if dbSeekInOrd( cFabricante, "cNomFab", dbfFabricante )
         cCodigoFabricanteBestseller   := ( dbfFabricante )->cCodFab
      end if
   end if

Return ( cCodigoFabricanteBestseller )

//---------------------------------------------------------------------------//

Function cCodigoCategoriaBestseller()

   local cCodigoFabricante             := Alltrim( ( dbfArticulo )->cCodFab )
   local cCodigoCategoriaBestseller := ""

   do case
      case cCodigoFabricante == "003" .or. cCodigoFabricante == "019" // Name it kids o mini
         cCodigoCategoriaBestseller := "003"

      case cCodigoFabricante == "004" // Jack & jones
         cCodigoCategoriaBestseller := "001"

      case cCodigoFabricante == "005" // Only
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

Function cNombreColor( cNombreColor )

   local nPos        := At( "/", cNombreColor )

   if nPos != 0

      cNombreColor   := SubStr( cNombreColor, 1, nPos - 1 )

   end if

Return ( cNombreColor )

//---------------------------------------------------------------------------//