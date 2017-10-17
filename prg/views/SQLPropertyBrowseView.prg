#include "FiveWin.Ch"
#include "Factu.Ch"
#include "Xbrowse.Ch"

//------------------------------------------------------------------------//

CLASS SQLPropertyBrowseView 

   DATA oController

   DATA oModel 

   DATA oBrowse

   DATA aPropertyOne
   DATA aPropertyTwo 

   DATA aPropertiesTable

   DATA nTotalRow
   DATA nTotalColumn                 

   METHOD New()

   METHOD Hide()              INLINE ( ::oBrowse:Hide() )
   METHOD Show()              INLINE ( ::oBrowse:Show() )

   METHOD setPropertyOne( aPropiedadesArticulo )
   METHOD setPropertyTwo( aPropiedadesArticulo )

   METHOD build()

ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( id, oDlg )

   ::oBrowse                  := IXBrowse():New( oDlg )

   ::oBrowse:nDataType        := DATATYPE_ARRAY

   ::oBrowse:bClrSel          := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
   ::oBrowse:bClrSelFocus     := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

   ::oBrowse:lHScroll         := .t.
   ::oBrowse:lVScroll         := .t.

   ::oBrowse:nMarqueeStyle    := 3
   ::oBrowse:nFreeze          := 1

   ::oBrowse:lRecordSelector  := .f.
   ::oBrowse:lFastEdit        := .t.
   ::oBrowse:lFooter          := .t.

   ::oBrowse:SetArray( {}, .f., 0, .f. )

   ::oBrowse:MakeTotals()

   ::oBrowse:CreateFromResource( id )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD setPropertyOne( aPropiedadesArticulo )

   ::nTotalRow       := len( aPropiedadesArticulo )

   ::aPropertyOne    := aPropiedadesArticulo

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD setPropertyTwo( aPropiedadesArticulo )

   if len( aPropiedadesArticulo ) == 0
      ::nTotalColumn := 2
   else 
      ::nTotalColumn := len( aPropiedadesArticulo ) + 1
   end if 

   ::aPropertyTwo    := aPropiedadesArticulo

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD build()

   local n
   local nRow

   ::aPropertiesTable   := array( ::nTotalRow, ::nTotalColumn )

   aeval( ::aPropertyOne, {| h, n | ::aPropertiesTable[ n, 1 ] := TPropertiesItems():buildOne( h ) } ) 

   if !empty( ::aPropertyTwo )
      for nRow := 1 to ::nTotalColumn
         aeval( ::aPropertyTwo, {| h, n | ::aPropertiesTable[ nRow, n ] := TPropertiesItems():buildTwo( ::aPropertyOne[ n ], h ) } ) 
      next 
   end if 

   ::oBrowse:aCols                 := {}
   ::oBrowse:Cargo                 := ::aPropertiesTable   
   ::oBrowse:nFreeze               := 1
   
   ::oBrowse:SetArray( ::aPropertiesTable, .f., 0, .f. )

   for n := 1 to len( ::aPropertiesTable[ 1 ] )

      msgalert( hb_valtoexp( ::aPropertiesTable[ 1 ] ), "hb_valtoexp( ::aPropertiesTable[ 1 ] )" )
      msgalert( ::aPropertiesTable[ ::oBrowse:nArrayAt, n ]:cHead, "::aPropertiesTable[ ::oBrowse:nArrayAt, n ]:cHead" )
      msgalert( n, "n" )

      if hb_isnil( ::aPropertiesTable[ ::oBrowse:nArrayAt, n ]:Value )

         // Columna del titulo de la propiedad------------------------------

         with object ( ::oBrowse:AddCol() )
            :Adjust()
            :cHeader          := ::aPropertiesTable[ ::oBrowse:nArrayAt, n ]:cHead
            :bEditValue       := bGenEditText( ::aPropertiesTable, ::oBrowse, n )
            :nWidth           := 100
            :bFooter          := {|| "Total" }
         end with

         // Columna del color de la propiedad-------------------------------

         if ::aPropertiesTable[ ::oBrowse:nArrayAt, n ]:lColor

            with object ( ::oBrowse:AddCol() )
               :Adjust()
               :cHeader       := "Color"
               :nWidth        := 40
               :bFooter       := {|| "" }
               :bStrData      := {|| "" }
               :nWidth        := 16
               :bClrStd       := bGenRGBValue( ::aPropertiesTable, ::oBrowse, n )
               :bClrSel       := bGenRGBValue( ::aPropertiesTable, ::oBrowse, n )
               :bClrSelFocus  := bGenRGBValue( ::aPropertiesTable, ::oBrowse, n )
            end with
            
            ::oBrowse:nFreeze++
            ::oBrowse:nColOffset++

         end if 

      else

//         with object ( ::oBrowse:AddCol() )
//            :Adjust()
//            :cHeader          := ::aPropertiesTable[ ::oBrowse:nArrayAt, n ]:cHead
//            :bEditValue       := bGenEditValue( ::aPropertiesTable, ::oBrowse, n )
//            :cEditPicture     := MasUnd()
//            :nWidth           := 50
//            :setAlign( AL_RIGHT )
//            :nFooterType      := AGGR_SUM
//            :nEditType        := EDIT_GET
//            :nHeadStrAlign    := AL_RIGHT
//            :bOnPostEdit      := {| oCol, xVal, nKey | bPostEditProperties( oCol, xVal, nKey, ::oBrowse ) }
//            :nFootStyle       := :defStyle( AL_RIGHT, .t. )               
//            :Cargo            := n
//         end with

      end if

   next
      
   ::oBrowse:aCols[ 1 ]:Hide()
   ::oBrowse:Adjust()

   ::oBrowse:nColSel          := ::oBrowse:nFreeze + 1

   ::oBrowse:nRowHeight       := 20
   ::oBrowse:nHeaderHeight    := 20
   ::oBrowse:nFooterHeight    := 20

   ::oBrowse:Show()
      
RETURN ( self )

//---------------------------------------------------------------------------//

STATIC FUNCTION bGenEditText( aPropertiesTable, oBrowse, n )

RETURN ( {|| aPropertiesTable[ oBrowse:nArrayAt, n ]:cText } )

//--------------------------------------------------------------------------//

STATIC FUNCTION bGenEditValue( aPropertiesTable, oBrowse, n )

RETURN ( {|| aPropertiesTable[ oBrowse:nArrayAt, n ]:Value } )

//--------------------------------------------------------------------------//

STATIC FUNCTION bGenRGBValue( aPropertiesTable, oBrowse, n )

RETURN ( {|| { nRGB( 0, 0, 0), aPropertiesTable[ oBrowse:nArrayAt, n ]:nRgb } } )

//--------------------------------------------------------------------------//

STATIC FUNCTION aPropertiesTable( oBrowse, nTotalCol )

   local n
   local nAt         := oBrowse:nAt
   local aRow        := {}

   if nAt == 0
      RETURN ( aRow )
   end if 

   for n := 1 to nTotalCol
      if oBrowse:Cargo[ nAt, n ]:Value == nil
         aAdd( aRow, oBrowse:Cargo[ nAt, n ]:cText )
      else
         aAdd( aRow, Trans( oBrowse:Cargo[ nAt, n ]:Value, MasUnd() ) )
      end if
   next

RETURN ( aRow )

//---------------------------------------------------------------------------//

STATIC FUNCTION EditPropertiesTable( oBrowse )

   local nRow     := oBrowse:nAt
   local nCol     := oBrowse:nColAct
   local uVar     := oBrowse:Cargo[ nRow, nCol ]:Value

   if nCol <= 1
      return .f.
   end if

   if oBrowse:lEditCol( nCol, @uVar, MasUnd() )
      oBrowse:Cargo[ nRow, nCol ]:Value   := uVar
      oBrowse:Refresh()
   end if

RETURN .t.

//--------------------------------------------------------------------------//

STATIC FUNCTION PutPropertiesTable( oBrowse, oGet )

   local nRow
   local nCol
   local uVar

   if !Empty( oBrowse ) .and. !Empty( oBrowse:Cargo )

      nRow        := oBrowse:nAt
      nCol        := oBrowse:nColAct
      uVar        := oBrowse:Cargo[ nRow, nCol ]:nPrecioCompra

      if !Empty( oGet )
         oGet:cText( uVar )
      end if

   end if

RETURN .t.

//--------------------------------------------------------------------------//

STATIC FUNCTION validPropertiesTable( oBrowse, oGet )

   local nRow
   local nCol
   local uVar
   local oBlock

   oBlock         := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      nRow        := oBrowse:nAt
      nCol        := oBrowse:nColAct
      uVar        := oGet:VarGet()

      if IsArray( oBrowse:Cargo )
         oBrowse:Cargo[ nRow, nCol ]:nPrecioCompra := uVar
      end if

   RECOVER

      msgStop( "Imposible asignar valor a la celda." )

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN .t.

//--------------------------------------------------------------------------//

STATIC FUNCTION KeyPropertiesTable( nKey, oBrowse )

   local nVar     := 0
   local nRow     := oBrowse:nAt
   local nCol     := oBrowse:nColAct
   local uVar     := Val( Chr( nKey ) )

   if nCol <= 1
      return .f.
   end if

   if oBrowse:lEditCol( nCol, @nVar, MasUnd(), , , , , , , , {|oGet| oGet:KeyChar( nKey ) } )
      oBrowse:Cargo[ nRow, nCol ]:Value   := nVar
      oBrowse:GoDown()
      oBrowse:Refresh()
   end if

Return .t.

//--------------------------------------------------------------------------//

STATIC FUNCTION aPropertiesFooter( oBrowse, nTotalRow, nTotalCol, oGet )

   local n
   local i
   local nTot  := 0
   local aRow  := AFill( Array( nTotalCol ), 0 )

   for n := 1 to nTotalCol
      for i := 1 to nTotalRow
         if oBrowse:Cargo[ i, n ]:Value == nil
            aRow[ n ]   := "Total"
         else
            aRow[ n ]   += oBrowse:Cargo[ i, n ]:Value
         end if
      next
   next

   for n := 1 to nTotalCol
      if ValType( aRow[ n ] ) == "N"
         nTot           += aRow[ n ]
         aRow[ n ]      := Trans( aRow[ n ], MasUnd() )
      end if
   next

   if oGet != nil
      oGet:cText( nTot )
   end if

RETURN ( aRow )

//---------------------------------------------------------------------------//

STATIC FUNCTION bPostEditProperties( oCol, xVal, nKey, oBrowse, oGetUnidades )

   oBrowse:Cargo[ oBrowse:nArrayAt, oCol:Cargo ]:Value := xVal 

   nTotalProperties( oBrowse, oGetUnidades )

RETURN ( .t. )

//---------------------------------------------------------------------------//

STATIC FUNCTION nTotalProperties( oBrowse, oGet )

   local aRow  
   local aCol
   local nTot  := 0

   for each aRow in oBrowse:Cargo
      for each aCol in aRow
         if isNum( aCol:Value )
            nTot  += aCol:Value 
         end if
      next
   next 

   if !empty( oGet )
      oGet:cText( nTot )
   end if 

RETURN ( .t. )

//---------------------------------------------------------------------------//


//    for each hValorPropiedad in aPropiedadesArticulo1
// 
//       aPropertiesTable[ nRow, nCol ]                        := TPropertiesItems():New()
//       aPropertiesTable[ nRow, nCol ]:cCodigo                := cCodArt
//       aPropertiesTable[ nRow, nCol ]:cHead                  := hValorPropiedad[ "TipoPropiedad" ]
//       aPropertiesTable[ nRow, nCol ]:cText                  := hValorPropiedad[ "CabeceraPropiedad" ]
//       aPropertiesTable[ nRow, nCol ]:cCodigoPropiedad1      := hValorPropiedad[ "CodigoPropiedad" ]
//       aPropertiesTable[ nRow, nCol ]:cValorPropiedad1       := hValorPropiedad[ "ValorPropiedad" ]
//       aPropertiesTable[ nRow, nCol ]:lColor                 := hValorPropiedad[ "ColorPropiedad" ]
//       aPropertiesTable[ nRow, nCol ]:nRgb                   := hValorPropiedad[ "RgbPropiedad" ]
// 
//       nRow++
//    
//    next


/*
Function setPropertiesTable( cCodArt, cCodPr1, cCodPr2, nPrecioCosto, oGetUnidades, oBrw, nView )

   local n
   local a
   local o
   local nRow                    := 1
   local nCol                    := 1
   local nTotalRow               := 0
   local nTotalCol               := 0
   local aSizesTable             := {}
   local aHeadersTable           := {}
   local aJustifyTable           := {}
   local hValorPropiedad
   local aPropertiesTable        := {}
   local aPropiedadesArticulo1   
   local aPropiedadesArticulo2   

   aPropiedadesArticulo1         := aPropiedadesArticulo1( cCodArt, nView ) 
   nTotalRow                     := len( aPropiedadesArticulo1 )
   if nTotalRow != 0
      aPropiedadesArticulo2      := aPropiedadesArticulo2( cCodArt, nView ) 
   else 
      aPropiedadesArticulo1      := aPropiedadesGeneral( cCodPr1, nView )
      nTotalRow                  := len( aPropiedadesArticulo1 )
      if nTotalRow != 0
         aPropiedadesArticulo2   := aPropiedadesGeneral( cCodPr2, nView )
      else
         Return nil
      end if 
   end if

   // Montamos los array con las propiedades-----------------------------------

   if len( aPropiedadesArticulo2 ) == 0
      nTotalCol                  := 2
   else
      nTotalCol                  := len( aPropiedadesArticulo2 ) + 1
   end if

   aPropertiesTable              := array( nTotalRow, nTotalCol )

   if ( D():Propiedades( nView ) )->( dbSeek( cCodPr1 ) )
      aadd( aHeadersTable, ( D():Propiedades( nView ) )->cDesPro )
      aadd( aSizesTable, 60 )
      aadd( aJustifyTable, .f. )
   end if

   for each hValorPropiedad in aPropiedadesArticulo1

      aPropertiesTable[ nRow, nCol ]                        := TPropertiesItems():New()
      aPropertiesTable[ nRow, nCol ]:cCodigo                := cCodArt
      aPropertiesTable[ nRow, nCol ]:cHead                  := hValorPropiedad[ "TipoPropiedad" ]
      aPropertiesTable[ nRow, nCol ]:cText                  := hValorPropiedad[ "CabeceraPropiedad" ]
      aPropertiesTable[ nRow, nCol ]:cCodigoPropiedad1      := hValorPropiedad[ "CodigoPropiedad" ]
      aPropertiesTable[ nRow, nCol ]:cValorPropiedad1       := hValorPropiedad[ "ValorPropiedad" ]
      aPropertiesTable[ nRow, nCol ]:lColor                 := hValorPropiedad[ "ColorPropiedad" ]
      aPropertiesTable[ nRow, nCol ]:nRgb                   := hValorPropiedad[ "RgbPropiedad" ]

      nRow++
   
   next

   if !empty( cCodPr2 ) .and. !empty( aPropiedadesArticulo2 )

      for each hValorPropiedad in aPropiedadesArticulo2

         nCol++

         aadd( aHeadersTable, hValorPropiedad[ "CabeceraPropiedad" ] )
         aadd( aSizesTable, 60 )
         aadd( aJustifyTable, .t. )

         for n := 1 to nTotalRow
            aPropertiesTable[ n, nCol ]                     := TPropertiesItems():New()
            aPropertiesTable[ n, nCol ]:Value               := 0
            aPropertiesTable[ n, nCol ]:cHead               := hValorPropiedad[ "CabeceraPropiedad" ]
            aPropertiesTable[ n, nCol ]:cCodigo             := cCodArt
            aPropertiesTable[ n, nCol ]:cCodigoPropiedad1   := aPropertiesTable[ n, 1 ]:cCodigoPropiedad1
            aPropertiesTable[ n, nCol ]:cValorPropiedad1    := aPropertiesTable[ n, 1 ]:cValorPropiedad1
            aPropertiesTable[ n, nCol ]:cCodigoPropiedad2   := hValorPropiedad[ "CodigoPropiedad" ]
            aPropertiesTable[ n, nCol ]:cValorPropiedad2    := hValorPropiedad[ "ValorPropiedad" ]
            aPropertiesTable[ n, nCol ]:lColor              := aPropertiesTable[ n, 1 ]:lColor
            aPropertiesTable[ n, nCol ]:nRgb                := aPropertiesTable[ n, 1 ]:nRgb
         next

      next

   else

      nCol++

      aAdd( aHeadersTable, "Unidades" )
      aAdd( aSizesTable,   60 )
      aAdd( aJustifyTable, .t. )

      for n := 1 to nTotalRow
         aPropertiesTable[ n, nCol ]                        := TPropertiesItems():New()
         aPropertiesTable[ n, nCol ]:Value                  := 0
         aPropertiesTable[ n, nCol ]:cHead                  := "Unidades"
         aPropertiesTable[ n, nCol ]:cCodigo                := cCodArt
         aPropertiesTable[ n, nCol ]:cCodigoPropiedad1      := aPropertiesTable[ n, 1 ]:cCodigoPropiedad1
         aPropertiesTable[ n, nCol ]:cValorPropiedad1       := aPropertiesTable[ n, 1 ]:cValorPropiedad1
         aPropertiesTable[ n, nCol ]:cCodigoPropiedad2      := Space( 20 )
         aPropertiesTable[ n, nCol ]:cValorPropiedad2       := Space( 40 )
         aPropertiesTable[ n, nCol ]:lColor                 := aPropertiesTable[ n, 1 ]:lColor
         aPropertiesTable[ n, nCol ]:nRgb                   := aPropertiesTable[ n, 1 ]:nRgb
      next

   end if

   // Calculo de precios-------------------------------------------------------

   for each a in aPropertiesTable
      for each o in a
         if IsObject( o )
            o:PrecioCompra( nPrecioCosto, D():ArticuloPrecioPropiedades( nView ) )
         end if
      next
   next

   // Asignamos la informacion al browse---------------------------------------

   if !empty( oBrw ) 

      ::oBrowse:aCols                 := {}
      ::oBrowse:Cargo                 := aPropertiesTable   
      ::oBrowse:nFreeze               := 1
      
      ::oBrowse:SetArray( aPropertiesTable, .f., 0, .f. )

      for n := 1 to len( aPropertiesTable[ 1 ] )

         if isNil( aPropertiesTable[ ::oBrowse:nArrayAt, n ]:Value )

            // Columna del titulo de la propiedad------------------------------

            with object ( ::oBrowse:AddCol() )
               :Adjust()
               :cHeader          := aPropertiesTable[ ::oBrowse:nArrayAt, n ]:cHead
               :bEditValue       := bGenEditText( aPropertiesTable, oBrw, n )
               :nWidth           := 100
               :bFooter          := {|| "Total" }
            end with

            // Columna del color de la propiedad

            if aPropertiesTable[ ::oBrowse:nArrayAt, n ]:lColor

               with object ( ::oBrowse:AddCol() )
                  :Adjust()
                  :cHeader       := "Color"
                  :nWidth        := 40
                  :bFooter       := {|| "" }
                  :bStrData      := {|| "" }
                  :nWidth        := 16
                  :bClrStd       := bGenRGBValue( aPropertiesTable, oBrw, n )
                  :bClrSel       := bGenRGBValue( aPropertiesTable, oBrw, n )
                  :bClrSelFocus  := bGenRGBValue( aPropertiesTable, oBrw, n )
               end with
               
               ::oBrowse:nFreeze++
               ::oBrowse:nColOffset++

            end if 

         else

            with object ( ::oBrowse:AddCol() )
               :Adjust()
               :cHeader          := aPropertiesTable[ ::oBrowse:nArrayAt, n ]:cHead
               :bEditValue       := bGenEditValue( aPropertiesTable, oBrw, n )
               :cEditPicture     := MasUnd()
               :nWidth           := 50
               :setAlign( AL_RIGHT )
               :nFooterType      := AGGR_SUM
               :nEditType        := EDIT_GET
               :nHeadStrAlign    := AL_RIGHT
               :bOnPostEdit      := {| oCol, xVal, nKey | bPostEditProperties( oCol, xVal, nKey, oBrw, oGetUnidades ) }
               :nFootStyle       := :defStyle( AL_RIGHT, .t. )               
               :Cargo            := n
            end with

         end if

      next
         
      ::oBrowse:aCols[ 1 ]:Hide()
      ::oBrowse:Adjust()

      ::oBrowse:nColSel               := ::oBrowse:nFreeze + 1

      ::oBrowse:nRowHeight            := 20
      ::oBrowse:nHeaderHeight         := 20
      ::oBrowse:nFooterHeight         := 20

      ::oBrowse:Show()
      
   end if

RETURN ( aPropertiesTable )

//---------------------------------------------------------------------------//

Function aPropiedadesArticulo( cCodigoArticulo, nView, cFieldCodigo, cValueCodigo )

   local aValores    := {}

   cCodigoArticulo   := rtrim( cCodigoArticulo )

   D():getInitStatus( "ArtDiv", nView )

   if ( D():ArticuloPrecioPropiedades( nView ) )->( dbSeek( cCodigoArticulo ) )

      while rtrim( ( D():ArticuloPrecioPropiedades( nView ) )->cCodArt ) == cCodigoArticulo .and. !( D():ArticuloPrecioPropiedades( nView ) )->( eof() )

         if !isValoresPorpiedad( aValores, nView, cFieldCodigo, cValueCodigo )
            addValoresPorpiedad( aValores, nView, cCodigoArticulo, cFieldCodigo, cValueCodigo )
         end if 

         ( D():ArticuloPrecioPropiedades( nView ) )->( dbskip() )

      end while

   end if 

   // asort( aValores, , , {|x,y| val( x[ "ValorPropiedad" ] ) < val( y[ "ValorPropiedad" ] ) } )

   asort( aValores, , , {|x,y| x[ "OrdenPropiedad" ] < y[ "OrdenPropiedad" ] } )

   D():setStatus( "ArtDiv", nView )

RETURN ( aValores )
*/
//---------------------------------------------------------------------------//



