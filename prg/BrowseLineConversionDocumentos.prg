#include "FiveWin.Ch"
#include "Factu.ch" 
#include "MesDbf.ch"
#include "Report.ch"
#include "XBrowse.ch"

//---------------------------------------------------------------------------//

CLASS TBrowseLineConversionDocumentos 

   DATA oSender

   DATA oDocumentLines

   DATA oSearchLines
   DATA cSearchLines

   DATA oSortLines
   DATA cSortLines                                 INIT ""
   DATA aSortLines                                 INIT {}

   DATA oTitle 
   DATA cTitle 

   DATA oBrwLines

   DATA oColumnNumeroDocumento

   DATA aPropertiesTable

   METHOD New()

   METHOD getView()                                INLINE ( ::oSender:nView )
   
   METHOD getPictureRound()                        INLINE ( ::oSender:cPictureRound )
   METHOD getDecimalPrice()                        INLINE ( ::oSender:nDecimalPrice )
   METHOD getRoundDecimalPrice()                   INLINE ( ::oSender:nRoundDecimalPrice )

   METHOD Dialog()
      METHOD buildBrowse()
      METHOD buildColumnsBrowse()
      METHOD buildOrdersColumns()                  

      METHOD setTitle( cTitle )                    INLINE ( ::cTitle := cTitle )

      METHOD setName( cName )                      INLINE ( if( !empty( ::oBrwLines ), ::oBrwLines:cName := cName, ) )
      METHOD load()                                INLINE ( if( !empty( ::oBrwLines ), ::oBrwLines:Load(), ) )
      METHOD addCol()                              INLINE ( if( !empty( ::oBrwLines ), ::oBrwLines:addCol(), ) )
      METHOD insCol( nPos )                        INLINE ( if( !empty( ::oBrwLines ), ::oBrwLines:insCol( nPos ), ) )

      METHOD goTop()                               INLINE ( if( !empty( ::oBrwLines ), ::oBrwLines:goTop(), ) )
      METHOD Refresh()                             INLINE ( if( !empty( ::oBrwLines ), ::oBrwLines:Refresh(), ) )

      METHOD setArray()                            INLINE ( if( !empty( ::oBrwLines ), ::oBrwLines:setArray( ::oDocumentLines:getLines(), .t., , .f. ), ) )

      METHOD Reset()                               

      METHOD changeSearchLines()                   INLINE ( if( !empty( ::oBrwLines ), ::oBrwLines:Seek( alltrim( ::cSearchLines ) ), ) )

      METHOD getDocument()                         INLINE ( alltrim( ::cDocument ) )

   METHOD selectLine()                             
   METHOD unSelectLine()                           
   METHOD toogleSelectLine()                       

   METHOD selectAllLine()                          INLINE ( ::oDocumentLines:selectAll(),       ::oBrwLines:Refresh() )
   METHOD unselectAllLine()                        INLINE ( ::oDocumentLines:unSelectAll(),     ::oBrwLines:Refresh() )
   METHOD getLinesDocument()                       INLINE ( ::oDocumentLines:getLines() )

   METHOD propertiesLine()

   METHOD changeUnits( oColumn, uValue, nKey )

   METHOD clickOnHeader()

   METHOD seekLine()

   METHOD changeSortLines()

   METHOD injectValuesBrowseProperties()
   METHOD saveValuesBrowseProperties()
   METHOD setValuesBrowseProperties()

   METHOD setBrowseLinesDocument()                 

   METHOD getDocumentLine( nPosition )             INLINE ( ::oDocumentLines:getLine( if( !empty( nPosition ), nPosition, ::oBrwLines:nArrayAt ) ) )

ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( oSender )

   ::oSender            := oSender
   
   ::oDocumentLines     := DocumentLines():New( Self )

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD Dialog( oDlg )

   REDEFINE SAY   ::oTitle ;
      PROMPT      ::cTitle ;
      ID          300 ;
      OF          oDlg

   REDEFINE GET   ::oSearchLines ;
      VAR         ::cSearchLines ;
      ID          200 ;
      PICTURE     "@!" ;
      BITMAP      "Find" ;
      OF          oDlg

   ::oSearchLines:bChange           := {|| ::changeSearchLines() }
   ::oSearchLines:bValid            := {|| ::oSearchLines:varPut( space( 100 ) ), .t. }

   REDEFINE COMBOBOX ::oSortLines ;
      VAR         ::cSortLines ;
      ITEMS       ::aSortLines ;
      ID          210 ;
      OF          oDlg

   ::oSortLines:bChange             := {|| ::changeSortLines() }

   REDEFINE BUTTON ;
      ID       500 ;
      OF       oDlg ;
      ACTION   ( ::selectLine() )

   REDEFINE BUTTON ;
      ID       510 ;
      OF       oDlg ;
      ACTION   ( ::unselectLine() )

   REDEFINE BUTTON ;
      ID       520 ;
      OF       oDlg ;
      ACTION   ( ::selectAllLine() )

   REDEFINE BUTTON ;
      ID       530 ;
      OF       oDlg ;
      ACTION   ( ::unselectAllLine() )

   REDEFINE BUTTON ;
      ID       540 ;
      OF       oDlg ;
      ACTION   ( ::propertiesLine() )

   // build creacion de browse de lineas---------------------------------------

   ::buildBrowse( oDlg )

   ::buildColumnsBrowse()

   ::buildOrdersColumns()

   ::clickOnHeader( ::oColumnNumeroDocumento )

RETURN ( Self )

//---------------------------------------------------------------------------//
//
// browse de lineas
//

METHOD buildBrowse( oDlg )

   ::oBrwLines                      := IXBrowse():New( oDlg )

   ::oBrwLines:lAutoSort            := .f.
   ::oBrwLines:bClrSel              := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
   ::oBrwLines:bClrSelFocus         := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

   ::oBrwLines:nMarqueeStyle        := 6
   ::oBrwLines:cName                := "Browse.Lineas." + ::ClassName()

   ::oBrwLines:lFooter              := .t.

   ::setBrowseLinesDocument()

   ::oBrwLines:CreateFromResource( 100 )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD buildColumnsBrowse()

   with object ( ::oBrwLines:AddCol() )
      :cHeader                      := "Seleccionando"
      :bEditValue                   := {|| ::getDocumentLine():isSelectLine() }
      :nWidth                       := 20
      :SetCheck( { "Sel16", "Nil16" } )
   end with

   ::oColumnNumeroDocumento               := ::oBrwLines:AddCol() 
   ::oColumnNumeroDocumento:cHeader       := "Número"
   ::oColumnNumeroDocumento:Cargo         := "getNumeroDocumento"
   ::oColumnNumeroDocumento:bEditValue    := {|| ::getDocumentLine():getNumeroDocumento() }
   ::oColumnNumeroDocumento:nWidth        := 80
   ::oColumnNumeroDocumento:bLClickHeader := {|nMRow, nMCol, nFlags, oColumn| ::clickOnHeader( oColumn ) }   
   ::oColumnNumeroDocumento:bLDClickData  := {|| ::toogleSelectLine() }

   with object ( ::oBrwLines:AddCol() )
      :cHeader                      := "Fecha"
      :Cargo                        := "getHeaderDate"
      :bEditValue                   := {|| ::getDocumentLine():getHeaderDate() }
      :nWidth                       := 80
      :bLClickHeader                := {|nMRow, nMCol, nFlags, oColumn| ::clickOnHeader( oColumn ) }         
      :bLDClickData                 := {|| ::toogleSelectLine() }
      :lHide                        := .t.
      :nDataStrAlign                := 3
      :nHeadStrAlign                := 3
   end with

   with object ( ::oBrwLines:AddCol() )
      :cHeader                      := "Cliente"
      :Cargo                        := "getHeaderClient"
      :bEditValue                   := {|| ::getDocumentLine():getHeaderClient() }
      :nWidth                       := 80
      :bLClickHeader                := {|nMRow, nMCol, nFlags, oColumn| ::clickOnHeader( oColumn ) }         
      :bLDClickData                 := {|| ::toogleSelectLine() }
      :lHide                        := .t.
   end with
  
   with object ( ::oBrwLines:AddCol() )
      :cHeader                      := "Nombre cliente"
      :Cargo                        := "getHeaderClientName"
      :bEditValue                   := {|| ::getDocumentLine():getHeaderClientName() }
      :nWidth                       := 280
      :bLClickHeader                := {|nMRow, nMCol, nFlags, oColumn| ::clickOnHeader( oColumn ) }         
      :bLDClickData                 := {|| ::toogleSelectLine() }
      :lHide                        := .t.
   end with

   with object ( ::oBrwLines:AddCol() )
      :cHeader                      := "Código"
      :Cargo                        := "getCode"
      :bEditValue                   := {|| ::getDocumentLine():getCode() }
      :nWidth                       := 80
      :bLClickHeader                := {|nMRow, nMCol, nFlags, oColumn| ::clickOnHeader( oColumn ) }         
      :bLDClickData                 := {|| ::toogleSelectLine() }
   end with

   with object ( ::oBrwLines:AddCol() )
      :cHeader                      := "Descripción"
      :Cargo                        := "getDescription"
      :bEditValue                   := {|| ::getDocumentLine():getDescription() }
      :nWidth                       := 340
      :bLClickHeader                := {|nMRow, nMCol, nFlags, oColumn| ::clickOnHeader( oColumn ) }         
      :bLDClickData                 := {|| ::toogleSelectLine() }
   end with

   with object ( ::oBrwLines:AddCol() )
      :cHeader                      := "Prop. 1"
      :Cargo                        := "getCodeFirstProperty"
      :bEditValue                   := {|| ::getDocumentLine():getCodeFirstProperty() }
      :nWidth                       := 60
      :lHide                        := .t.
      :bLClickHeader                := {|nMRow, nMCol, nFlags, oColumn| ::clickOnHeader( oColumn ) }         
      :bLDClickData                 := {|| ::toogleSelectLine() }
   end with

   with object ( ::oBrwLines:AddCol() )
      :cHeader                      := "Prop. 2"
      :Cargo                        := "getCodeSecondProperty"
      :bEditValue                   := {|| ::getDocumentLine():getCodeSecondProperty() }
      :nWidth                       := 60
      :lHide                        := .t.
      :bLClickHeader                := {|nMRow, nMCol, nFlags, oColumn| ::clickOnHeader( oColumn ) }         
      :bLDClickData                 := {|| ::toogleSelectLine() }
   end with

   with object ( ::oBrwLines:AddCol() )
      :cHeader                      := "Valor propiedad 1"
      :Cargo                        := "getValueFirstProperty"
      :bEditValue                   := {|| ::getDocumentLine():getValueFirstProperty() }
      :nWidth                       := 60
      :lHide                        := .t.
      :bLClickHeader                := {|nMRow, nMCol, nFlags, oColumn| ::clickOnHeader( oColumn ) }         
      :bLDClickData                 := {|| ::toogleSelectLine() }
   end with

   with object ( ::oBrwLines:AddCol() )
      :cHeader                      := "Valor propiedad 2"
      :Cargo                        := "getValueSecondProperty"
      :bEditValue                   := {|| ::getDocumentLine():getValueSecondProperty() }
      :nWidth                       := 60
      :lHide                        := .t.
      :bLClickHeader                := {|nMRow, nMCol, nFlags, oColumn| ::clickOnHeader( oColumn ) }         
      :bLDClickData                 := {|| ::toogleSelectLine() }
   end with

   with object ( ::oBrwLines:AddCol() )
      :cHeader                      := "Nombre propiedad 1"
      :Cargo                        := "getNameFirstProperty"
      :bEditValue                   := {|| ::getDocumentLine():getNameFirstProperty() }
      :nWidth                       := 60
      :lHide                        := .t.
      :bLClickHeader                := {|nMRow, nMCol, nFlags, oColumn| ::clickOnHeader( oColumn ) }         
      :bLDClickData                 := {|| ::toogleSelectLine() }
   end with

   with object ( ::oBrwLines:AddCol() )
      :cHeader                      := "Nombre propiedad 2"
      :Cargo                        := "getNameSecondProperty"
      :bEditValue                   := {|| ::getDocumentLine():getNameSecondProperty() }
      :nWidth                       := 60
      :lHide                        := .t.
      :bLClickHeader                := {|nMRow, nMCol, nFlags, oColumn| ::clickOnHeader( oColumn ) }         
      :bLDClickData                 := {|| ::toogleSelectLine() }
   end with

   with object ( ::oBrwLines:AddCol() )
      :cHeader                      := "Lote"
      :Cargo                        := "getLote"
      :bEditValue                   := {|| ::getDocumentLine():getLote() }
      :nWidth                       := 80
      :lHide                        := .t.
      :bLClickHeader                := {|nMRow, nMCol, nFlags, oColumn| ::clickOnHeader( oColumn ) }         
      :bLDClickData                 := {|| ::toogleSelectLine() }
   end with

   with object ( ::oBrwLines:AddCol() )
      :cHeader                      := cNombreCajas()
      :Cargo                        := "getBoxes"
      :bEditValue                   := {|| ::getDocumentLine():getBoxes() }
      :cEditPicture                 := masUnd()
      :nWidth                       := 50
      :nDataStrAlign                := 1
      :nHeadStrAlign                := 1
      :lHide                        := .t.
      :bLClickHeader                := {|nMRow, nMCol, nFlags, oColumn| ::clickOnHeader( oColumn ) }         
      :bLDClickData                 := {|| ::toogleSelectLine() }
   end with

   with object ( ::oBrwLines:AddCol() )
      :cHeader                      := cNombreUnidades()
      :Cargo                        := "getUnits"
      :bEditValue                   := {|| ::getDocumentLine():getUnits() }
      :cEditPicture                 := masUnd()
      :nWidth                       := 60
      :nDataStrAlign                := 1
      :nHeadStrAlign                := 1
      :nEditType                    := 1
      :lHide                        := .t.
      :bLClickHeader                := {|nMRow, nMCol, nFlags, oColumn| ::clickOnHeader( oColumn ) }      
      :bOnPostEdit                  := {|oColumn, uValue, nKey| ::changeUnits( oColumn, uValue, nKey ) }
   end with

   with object ( ::oBrwLines:AddCol() )
      :cHeader                      := "Total " + cNombreUnidades()
      :Cargo                        := "getTotalUnits"
      :bEditValue                   := {|| ::getDocumentLine():getTotalUnits() }
      :cDataType                    := "N"
      :cEditPicture                 := masUnd()
      :cFooterPicture               := masUnd()
      :nWidth                       := 60
      :nDataStrAlign                := 1
      :nHeadStrAlign                := 1
      :nFootStrAlign                := 1
      :lHide                        := .f.
      :nFooterType                  := AGGR_SUM
      :bLClickHeader                := {|nMRow, nMCol, nFlags, oColumn| ::clickOnHeader( oColumn ) }         
      :bLDClickData                 := {|| ::toogleSelectLine() }
   end with

   with object ( ::oBrwLines:AddCol() )
      :cHeader                      := "UM. Unidad de medición"
      :Cargo                        := "getMeasurementUnit"
      :bEditValue                   := {|| ::getDocumentLine():getMeasurementUnit() }
      :nWidth                       := 25
      :lHide                        := .t.
      :bLClickHeader                := {|nMRow, nMCol, nFlags, oColumn| ::clickOnHeader( oColumn ) }         
      :bLDClickData                 := {|| ::toogleSelectLine() }
   end with

   with object ( ::oBrwLines:AddCol() )
      :cHeader                      := "Almacen"
      :Cargo                        := "getStore"
      :bEditValue                   := {|| ::getDocumentLine():getStore() }
      :nWidth                       := 60
      :bLClickHeader                := {|nMRow, nMCol, nFlags, oColumn| ::clickOnHeader( oColumn ) }         
      :bLDClickData                 := {|| ::toogleSelectLine() }
   end with

   with object ( ::oBrwLines:AddCol() )
      :cHeader                      := "Importe"
      :Cargo                        := "getNetPrice"
      :bEditValue                   := {|| ::getDocumentLine():getNetPrice() }
      :cEditPicture                 := ::getPictureRound()
      :nWidth                       := 90
      :nDataStrAlign                := 1
      :nHeadStrAlign                := 1
      :bLClickHeader                := {|nMRow, nMCol, nFlags, oColumn| ::clickOnHeader( oColumn ) }         
      :bLDClickData                 := {|| ::toogleSelectLine() }
   end with

   with object ( ::oBrwLines:AddCol() )
      :cHeader                      := "% Dto."
      :Cargo                        := "getPercentageDiscount"
      :bEditValue                   := {|| ::getDocumentLine():getPercentageDiscount() }
      :cEditPicture                 := "@E 999.99"
      :nWidth                       := 50
      :nDataStrAlign                := 1
      :nHeadStrAlign                := 1
      :lHide                        := .t.
      :bLClickHeader                := {|nMRow, nMCol, nFlags, oColumn| ::clickOnHeader( oColumn ) }         
      :bLDClickData                 := {|| ::toogleSelectLine() }
   end with

   with object ( ::oBrwLines:AddCol() )
      :cHeader                      := "% Dto. promoción"
      :Cargo                        := "getPercentagePromotion"
      :bEditValue                   := {|| ::getDocumentLine():getPercentagePromotion() }
      :cEditPicture                 := "@E 999.99"
      :nWidth                       := 50
      :nDataStrAlign                := 1
      :nHeadStrAlign                := 1
      :lHide                        := .t.
      :bLClickHeader                := {|nMRow, nMCol, nFlags, oColumn| ::clickOnHeader( oColumn ) }         
      :bLDClickData                 := {|| ::toogleSelectLine() }
   end with

   with object ( ::oBrwLines:AddCol() )
      :cHeader                      := "% " + cImp()
      :Cargo                        := "getPercentageTax"
      :bEditValue                   := {|| ::getDocumentLine():getPercentageTax() }
      :cEditPicture                 := "@E 999.99"
      :nWidth                       := 50
      :nDataStrAlign                := 1
      :nHeadStrAlign                := 1
      :bLClickHeader                := {|nMRow, nMCol, nFlags, oColumn| ::clickOnHeader( oColumn ) }         
      :bLDClickData                 := {|| ::toogleSelectLine() }
   end with

   with object ( ::oBrwLines:AddCol() )
      :cHeader                      := "Total"
      :Cargo                        := "getBruto"
      :bEditValue                   := {|| Transform( ::getDocumentLine():getBruto(), ::getPictureRound() ) } 
      :cEditPicture                 := ::getPictureRound()
      :nWidth                       := 80
      :nDataStrAlign                := 1
      :nHeadStrAlign                := 1
      :bLClickHeader                := {|nMRow, nMCol, nFlags, oColumn| ::clickOnHeader( oColumn ) }         
      :bLDClickData                 := {|| ::toogleSelectLine() }
   end with

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD buildOrdersColumns()

RETURN ( aeval( ::oBrwLines:aCols, {|oColumn| aadd( ::aSortLines, oColumn:cHeader ) } ) )

//---------------------------------------------------------------------------//

METHOD changeUnits( oColumn, uValue, nKey )

   if isNum( nKey ) .and. ( nKey == VK_ESCAPE )
      Return ( Self )
   end if 

   if !isNil( uValue )
      ::getDocumentLine():setUnits( uValue  )
   end if  

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD propertiesLine()

   local idProduct               := ::getDocumentLine():getCode()
   local oDialogBrowseProperties

   ::aPropertiesTable            := D():getArticuloTablaPropiedades( idProduct, ::getView() )
   if empty( ::aPropertiesTable )
      msgStop( "Este artículo no tiene propiedades." )
      Return ( Self )
   end if

   ::injectValuesBrowseProperties( idProduct )

   oDialogBrowseProperties       := DialogBrowseProperties():new( Self )
   if oDialogBrowseProperties:Dialog()

      ::saveValuesBrowseProperties()
   
      ::oBrwLines:Refresh()
   
   end if 

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD selectLine()
   
   local position 

   for each position in ::oBrwLines:aSelected
      ::getDocumentLine( position ):selectLine()
   next

   ::oBrwLines:Refresh()

Return ( Self )

//---------------------------------------------------------------------------//

METHOD unSelectLine()
   
   local position 

   for each position in ::oBrwLines:aSelected
      ::getDocumentLine( position ):unSelectLine()
   next

   ::oBrwLines:Refresh()

Return ( Self )

//---------------------------------------------------------------------------//

METHOD toogleSelectLine()
   
   local position 

   for each position in ::oBrwLines:aSelected
      ::getDocumentLine( position ):toogleSelectLine()
   next

   ::oBrwLines:Refresh()

Return ( Self )

//---------------------------------------------------------------------------//

METHOD setBrowseLinesDocument()

   ::oBrwLines:setArray( ::oDocumentLines:getLines(), .t., , .f. )
   
   ::oBrwLines:bSeek := {|c| ::seekLine( c ) }

   ::oBrwLines:makeTotals()

   ::oBrwLines:goTop()

RETURN ( .t. ) 

//---------------------------------------------------------------------------//

METHOD clickOnHeader( oColumn, setSortLines )

   DEFAULT setSortLines    := .t.

   aeval( ::oBrwLines:aCols, {|o| if( o:cHeader == oColumn:cHeader, o:cOrder := "A", o:cOrder := "" ) } )

   ::oDocumentLines:sortingPleaseWait( oColumn:Cargo )
   
   ::oBrwLines:Refresh()

   if setSortLines
      ::oSortLines:set( oColumn:cHeader )
   end if 

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD seekLine( cSeek )

   local nRow
   local uVal
   local nColumnToSearch

   nColumnToSearch         := ascan( ::oBrwLines:aCols, { |o| !Empty( o:cOrder ) } )

   if nColumnToSearch == 0
      Return .f.
   end if 

   nRow                    := ::oBrwLines:nArrayAt

   for ::oBrwLines:nArrayAt := 1 to ::oBrwLines:nLen

      uVal                 := eval( ::oBrwLines:aCols[ nColumnToSearch ]:bEditValue )

      if hb_WildMatch( '*' + cSeek, uVal )
         ::oBrwLines:SelectCurrent()
         Return .t.
      endif
     
   next 

   ::oBrwLines:nArrayAt    := nRow

Return .t.

//---------------------------------------------------------------------------//

METHOD changeSortLines()

   local nScan

   nScan          := ascan( ::oBrwLines:aCols, {| oColumn | oColumn:cHeader == ::cSortLines } )
   if nScan != 0
      ::clickOnHeader( ::oBrwLines:aCols[ nScan ], .f. )
   end if 

Return ( .t. )

//---------------------------------------------------------------------------//

METHOD injectValuesBrowseProperties( idProduct )

   local oLine
   local aLines   := ::getLinesDocument()

   for each oLine in aLines
      if idProduct == oLine:getProductId()
         D():setArticuloTablaPropiedades( oLine:getProductId(), oLine:getCodeFirstProperty(), oLine:getCodeSecondProperty(), oLine:getValueFirstProperty(), oLine:getValueSecondProperty(), oLine:getTotalUnits(), ::aPropertiesTable )
      end if 
   next

Return ( .t. )

//---------------------------------------------------------------------------//

METHOD saveValuesBrowseProperties( idProduct )

   local oLineSave
   local aLinesSaved

   for each aLinesSaved in ::aPropertiesTable
      for each oLineSave in aLinesSaved
         ::setValuesBrowseProperties( oLineSave )
      next 
   next

Return ( .t. )

//---------------------------------------------------------------------------//

METHOD setValuesBrowseProperties( oLineSave )

   local oLineDocument
   local aLinesDocument    := ::getLinesDocument()

   for each oLineDocument in aLinesDocument

      if rtrim( oLineSave:cCodigo )            == rtrim( oLineDocument:getProductId() )            .and. ;
         rtrim( oLineSave:cCodigoPropiedad1 )  == rtrim( oLineDocument:getCodeFirstProperty() )    .and. ;
         rtrim( oLineSave:cCodigoPropiedad2 )  == rtrim( oLineDocument:getCodeSecondProperty() )   .and. ;
         rtrim( oLineSave:cValorPropiedad1 )   == rtrim( oLineDocument:getValueFirstProperty() )   .and. ;
         rtrim( oLineSave:cValorPropiedad2 )   == rtrim( oLineDocument:getValueSecondProperty() )

         oLineDocument:setUnidades( oLineSave:Value )
         
         oLineDocument:selectLine() 

      end if 

   next

Return ( .t. )

//---------------------------------------------------------------------------//

METHOD Reset()

   if empty( ::oDocumentLines )
      Return ( .f. )
   end if 

   if empty( ::oBrwLines )
      Return ( .f. )
   end if 

   ::oDocumentLines:Reset()

   ::oBrwLines:setArray( ::oDocumentLines:getLines(), .t., , .f. )

Return ( .t. )

//---------------------------------------------------------------------------//
