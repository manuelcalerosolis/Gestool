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

   METHOD addColumnTitleProperty( n )
   METHOD addColumnColorProperty( n )
   METHOD addColumnValueProperty( n )

   METHOD bGenEditText( n )   
   METHOD bGenEditValue( n )  
   METHOD bGenRGBValue( n )  

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

   msgalert( hb_valtoexp( aPropiedadesArticulo ), "aPropiedadesArticulo" )

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD build()

   local n
   local nRow 
   local nCol 
   local nTotalCol
   local nTotalRow
   local oGetUnidades
   local hValorPropiedad

   nRow                 := 1
   nCol                 := 1

   ::aPropertiesTable   := array( ::nTotalRow, ::nTotalColumn )

   aeval( ::aPropertyOne, {| h, n | ::aPropertiesTable[ n, nCol ] := TPropertiesItems():buildOne( h ) } ) 

   /*
   if !empty( ::aPropertyTwo )
      for nRow := 1 to ::nTotalColumn
         aeval( ::aPropertyTwo,;
            {| h, n | aPropertiesTable[ nRow, n ] := TPropertiesItems():buildTwo( ::aPropertyOne[ n ], h ) } ) 
      next 
   end if 
   */

   if !empty( ::aPropertyTwo )

      for each hValorPropiedad in ::aPropertyTwo

         nCol++

         for n := 1 to ::nTotalRow

            ::aPropertiesTable[ n, nCol ]                     := TPropertiesItems():New()
            ::aPropertiesTable[ n, nCol ]:Value               := 0
            ::aPropertiesTable[ n, nCol ]:cHead               := hValorPropiedad[ "CabeceraPropiedad" ]
            ::aPropertiesTable[ n, nCol ]:cCodigo             := hValorPropiedad[ "CodigoArticulo" ]
            ::aPropertiesTable[ n, nCol ]:cCodigoPropiedad1   := ::aPropertiesTable[ n, 1 ]:cCodigoPropiedad1
            ::aPropertiesTable[ n, nCol ]:cValorPropiedad1    := ::aPropertiesTable[ n, 1 ]:cValorPropiedad1
            ::aPropertiesTable[ n, nCol ]:cCodigoPropiedad2   := hValorPropiedad[ "CodigoPropiedad" ]
            ::aPropertiesTable[ n, nCol ]:cValorPropiedad2    := hValorPropiedad[ "ValorPropiedad" ]
            ::aPropertiesTable[ n, nCol ]:lColor              := ::aPropertiesTable[ n, 1 ]:lColor
            ::aPropertiesTable[ n, nCol ]:nRgb                := ::aPropertiesTable[ n, 1 ]:nRgb
         next

      next

   else

      nCol++

      for n := 1 to ::nTotalRow
         ::aPropertiesTable[ n, nCol ]                        := TPropertiesItems():New()
         ::aPropertiesTable[ n, nCol ]:Value                  := 0
         ::aPropertiesTable[ n, nCol ]:cHead                  := "Unidades"
         ::aPropertiesTable[ n, nCol ]:cCodigo                := ::aPropertiesTable[ n, 1 ]:cCodigoArticulo
         ::aPropertiesTable[ n, nCol ]:cCodigoPropiedad1      := ::aPropertiesTable[ n, 1 ]:cCodigoPropiedad1
         ::aPropertiesTable[ n, nCol ]:cValorPropiedad1       := ::aPropertiesTable[ n, 1 ]:cValorPropiedad1
         ::aPropertiesTable[ n, nCol ]:cCodigoPropiedad2      := Space( 20 )
         ::aPropertiesTable[ n, nCol ]:cValorPropiedad2       := Space( 40 )
         ::aPropertiesTable[ n, nCol ]:lColor                 := ::aPropertiesTable[ n, 1 ]:lColor
         ::aPropertiesTable[ n, nCol ]:nRgb                   := ::aPropertiesTable[ n, 1 ]:nRgb
      next

   end if

   // Asignamos la informacion al browse---------------------------------------

   ::oBrowse:aCols            := {}
   ::oBrowse:Cargo            := ::aPropertiesTable   
   ::oBrowse:nFreeze          := 1
   
   ::oBrowse:SetArray( ::aPropertiesTable, .f., 0, .f. )

   for n := 1 to len( ::aPropertiesTable[ 1 ] )

      if hb_isnil( ::aPropertiesTable[ ::oBrowse:nArrayAt, n ]:Value )

         ::addColumnTitleProperty( n )

         ::addColumnColorProperty( n )

      else

         ::addColumnValueProperty( n )

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

METHOD addColumnTitleProperty( n )

   with object ( ::oBrowse:AddCol() )
      :Adjust()
      :cHeader          := ::aPropertiesTable[ ::oBrowse:nArrayAt, n ]:cHead
      :bEditValue       := ::bGenEditText( n )
      :nWidth           := 100
      :bFooter          := {|| "Total" }
   end with

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD addColumnColorProperty( n )

   // Columna del color de la propiedad

   if !( ::aPropertiesTable[ ::oBrowse:nArrayAt, n ]:lColor )
      RETURN ( Self )
   end if 

   with object ( ::oBrowse:AddCol() )
      :Adjust()
      :cHeader       := "Color"
      :nWidth        := 40
      :bFooter       := {|| "" }
      :bStrData      := {|| "" }
      :nWidth        := 16
      :bClrStd       := ::bGenRGBValue( n )
      :bClrSel       := ::bGenRGBValue( n )
      :bClrSelFocus  := ::bGenRGBValue( n )
   end with
      
   ::oBrowse:nFreeze++
   ::oBrowse:nColOffset++

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD addColumnValueProperty( n )

   local oGetUnidades

   with object ( ::oBrowse:AddCol() )
      :Adjust()
      :cHeader          := ::aPropertiesTable[ ::oBrowse:nArrayAt, n ]:cHead
      :bEditValue       := ::bGenEditValue( n )
      :cEditPicture     := MasUnd()
      :nWidth           := 50
      :setAlign( AL_RIGHT )
      :nFooterType      := AGGR_SUM
      :nEditType        := EDIT_GET
      :nHeadStrAlign    := AL_RIGHT
      :bOnPostEdit      := {| oCol, xVal, nKey | bPostEditProperties( oCol, xVal, nKey, ::oBrowse, oGetUnidades ) }
      :nFootStyle       := :defStyle( AL_RIGHT, .t. )               
      :Cargo            := n
   end with

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD bGenEditText( n )   

RETURN ( {|| ::aPropertiesTable[ ::oBrowse:nArrayAt, n ]:cText } )

//---------------------------------------------------------------------------//

METHOD bGenEditValue( n )  

RETURN ( {|| ::aPropertiesTable[ ::oBrowse:nArrayAt, n ]:Value } )

//---------------------------------------------------------------------------//

METHOD bGenRGBValue( n )   

RETURN ( {|| { nRGB( 0, 0, 0), ::aPropertiesTable[ ::oBrowse:nArrayAt, n ]:nRgb } } )

//---------------------------------------------------------------------------//

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


