#include "FiveWin.Ch"
#include "Factu.Ch"
#include "Xbrowse.Ch"

//------------------------------------------------------------------------//

CLASS SQLPropertyBrowseView 

   DATA oController

   DATA oBrowse

   DATA onPostEdit

   DATA aPropertyOne
   DATA aPropertyTwo 

   DATA aProperties                       INIT {}

   DATA aPropertiesTable

   DATA nTotalRow
   DATA nTotalColumn          

   METHOD New()

   METHOD CreateControl()

   METHOD getBrowse()                     INLINE ( ::oBrowse )

   METHOD Refresh()                       INLINE ( ::oBrowse:MakeTotals(), ::oBrowse:Refresh() )
   METHOD lVisible()                      INLINE ( ::oBrowse:lVisible )

   METHOD setPropertyOne( aPropiedadesArticulo )
   METHOD setPropertyTwo( aPropiedadesArticulo )

   METHOD setOnPostEdit( onPostEdit )     INLINE ( ::onPostEdit := onPostEdit  )

   METHOD build()
   METHOD setBrowsePropertyTable()
   METHOD createColumnBrowseProperty()
   METHOD Adjust()

   METHOD getProperties()
      METHOD addProperty()

   METHOD setValueAndUuidToPropertiesTable()
      METHOD scanProperty( oProperty )

   METHOD addColumnTitleProperty( n )
   METHOD addColumnColorProperty( n )
   METHOD addColumnValueProperty( n )
   METHOD postEditProperties( oCol, xVal, nKey )

   METHOD bGenEditText( n )   
   METHOD bGenEditValue( n )  
   METHOD bGenRGBValue( n )  

   METHOD nTotalUnits()

ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( oController )

   ::oController  := oController

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD CreateControl( nId, oDialog )

   local oError

   if empty( nId ) .or. empty( oDialog )
      RETURN ( Self )
   end if 

   try 

   ::oBrowse                  := IXBrowse():New( oDialog )

   ::oBrowse:nDataType        := DATATYPE_ARRAY

   ::oBrowse:bClrSel          := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
   ::oBrowse:bClrSelFocus     := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

   ::oBrowse:lVisible         := .t.

   ::oBrowse:lHScroll         := .t.
   ::oBrowse:lVScroll         := .t.

   ::oBrowse:nMarqueeStyle    := 3
   ::oBrowse:nFreeze          := 1

   ::oBrowse:lRecordSelector  := .f.
   ::oBrowse:lFastEdit        := .t.
   ::oBrowse:lFooter          := .t.

   ::oBrowse:SetArray( {}, .f., 0, .f. )

   ::oBrowse:MakeTotals()

   ::oBrowse:CreateFromResource( nId )

   catch oError

      msgStop( "Imposible crear el control browse de propiedades." + CRLF + ErrorMessage( oError ) )

   end   

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

   ::setBrowsePropertyTable()

   ::createColumnBrowseProperty()

   ::Adjust()

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD setBrowsePropertyTable()

   ::oBrowse:aCols            := {}
   ::oBrowse:Cargo            := ::aPropertiesTable   
   ::oBrowse:nFreeze          := 1
   
   ::oBrowse:SetArray( ::aPropertiesTable, .f., 0, .f. )

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD createColumnBrowseProperty()

   local n

   if !hb_isarray( ::aPropertiesTable ) .or. len( ::aPropertiesTable ) == 0
      RETURN ( self )
   end if 

   for n := 1 to len( ::aPropertiesTable[ 1 ] )

      if hb_isnil( ::aPropertiesTable[ ::oBrowse:nArrayAt, n ]:Value )

         ::addColumnTitleProperty( n )

         ::addColumnColorProperty( n )

      else

         ::addColumnValueProperty( n )

      end if

   next

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD Adjust()

   ::oBrowse:aCols[ 1 ]:Hide()

   ::oBrowse:nColSel          := ::oBrowse:nFreeze + 1

   ::oBrowse:nRowHeight       := 20
   ::oBrowse:nHeaderHeight    := 20
   ::oBrowse:nFooterHeight    := 20

   ::oBrowse:Adjust()

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD addColumnTitleProperty( n )

   with object ( ::oBrowse:AddCol() )
      :Adjust()
      :cHeader       := ::aPropertiesTable[ ::oBrowse:nArrayAt, n ]:cHead
      :bEditValue    := ::bGenEditText( n )
      :nWidth        := 100
      :bFooter       := {|| "Total" }
   end with

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD addColumnColorProperty( n )

   if !( ::aPropertiesTable[ ::oBrowse:nArrayAt, n ]:lColor )
      RETURN ( Self )
   end if 

   with object ( ::oBrowse:AddCol() )
      :Adjust()
      :cHeader       := ""
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
      :cEditPicture     := masUnd()
      :nWidth           := 50
      :setAlign( AL_RIGHT )
      :nHeadStrAlign    := AL_RIGHT
      :nEditType        := EDIT_GET
      :bOnPostEdit      := {| oCol, xVal, nKey | ::postEditProperties( oCol, xVal, nKey ) }
      :nFootStyle       := :defStyle( AL_RIGHT, .t. )               
      :nFooterType      := AGGR_SUM
      :cFooterPicture   := masUnd()
      :cDataType        := "N"
      :Cargo            := n
   end with

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD postEditProperties( oCol, xVal, nKey )

   ::oBrowse:Cargo[ ::oBrowse:nArrayAt, oCol:Cargo ]:Value := xVal

   if hb_isblock( ::onPostEdit )
      eval( ::onPostEdit )
   end if 

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD getProperties()

   ::aProperties        := {}

   if empty( ::aPropertiesTable )
      RETURN ( ::aProperties )
   end if 

   aeval( ::aPropertiesTable,;
      {| aProperty | aeval( aProperty,;
         {| oProperty | ::addProperty( oProperty ) } ) } )

RETURN ( ::aProperties )

//---------------------------------------------------------------------------//

METHOD addProperty( oProperty )

   if hb_isnumeric( oProperty:Value )
      aadd( ::aProperties, oProperty )
   end if 

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD setValueAndUuidToPropertiesTable( hLine )

   local oProperty

   if empty( hget( hLine, "uuid" ) )
      RETURN ( nil )
   end if 

   if empty( hget( hLine, "unidades_articulo" ) )
      RETURN ( nil )
   end if 

   if empty( hget( hLine, "codigo_primera_propiedad" ) )
      RETURN ( nil )
   end if 

   if empty( hget( hLine, "valor_primera_propiedad" ) )
      RETURN ( nil )
   end if 

   if empty( ::aPropertiesTable )
      RETURN ( nil )
   end if 

   aeval( ::aPropertiesTable,;
      {| aProperty | aeval( aProperty,;
         {| oProperty | ::scanProperty( hLine, oProperty ) } ) } )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD scanProperty( hLine, oProperty )

   if alltrim( hget( hLine, "codigo_primera_propiedad" ) )  == alltrim( oProperty:cCodigoPropiedad1 ) .and. ;
      alltrim( hget( hLine, "valor_primera_propiedad" ) )   == alltrim( oProperty:cValorPropiedad1 )  .and. ;
      alltrim( hget( hLine, "codigo_segunda_propiedad" ) )  == alltrim( oProperty:cCodigoPropiedad2 ) .and. ;
      alltrim( hget( hLine, "valor_segunda_propiedad" ) )   == alltrim( oProperty:cValorPropiedad2 )    

      oProperty:Uuid    := hget( hLine, "uuid" )
      oProperty:Value   := hget( hLine, "unidades_articulo" )

   end if 

RETURN ( nil )

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

METHOD nTotalUnits()

   local nTotalUnits    := 0

   if empty( ::oBrowse:Cargo )
      RETURN ( nTotalUnits )
   end if 

   aeval( ::oBrowse:Cargo,;
      {| aRow | aeval( aRow,;
         {| oCol | if( hb_isnumeric( oCol:Value ), nTotalUnits += oCol:Value, ) } ) } )

RETURN ( nTotalUnits )

//---------------------------------------------------------------------------//

