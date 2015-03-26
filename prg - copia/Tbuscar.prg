#ifndef __PDA__
   #include "FiveWin.Ch"
   #include "Objects.ch"
   #include "XBrowse.ch"
#else
   #include "FWCE.ch"
   REQUEST DBFCDX
#endif

//-----------------------------------------------------------------------------------------------------------------------------

CLASS TBuscar INHERIT TDialog

      DATA aCampos      AS ARRAY    INIT {}
      DATA aTitulos     AS ARRAY    INIT {}
      DATA aSizes
      DATA cAlias
      DATA cField
      DATA aJustify     AS ARRAY    INIT {}
      DATA nOrdenAnt
      DATA uOrden
      DATA aOrd         AS ARRAY    INIT {}
      DATA bAlta
      DATA bEdit
      DATA bZoom

      DATA oBmp         AS OBJECT
      DATA oRdo         AS OBJECT
      DATA uVal

      DATA cCampo
      DATA uVal1
      DATA uVal2
      DATA nRecno       AS NUMERIC

      DATA oBrw         AS OBJECT

      METHOD New( cCaption, cAlias, uOrden, cField, aOrd, aCampos, aTitulos, aSizes, bAlta, bEdit, bZoom, aJustify ) CONSTRUCTOR
      Method Create( oParent, cField )

      METHOD Resources()
      METHOD aFields()

      METHOD SetFilter( cfield, uVal1, uVal2 )
      METHOD ChangeGet( uBuffer )
      METHOD Append()
      METHOD Edit()
      METHOD Zoom()

      METHOD Getfield()
      METHOD Activate()
      METHOD End( nResult )

END CLASS

//------------------------------------------------------------------------------------------------------------------------------

METHOD New( cCaption, cAlias, uOrden, cField, aOrd, aCampos, aTitulos, aSizes,;
            bAlta, bEdit, bZoom, aJustify ) CLASS TBuscar

   DEFAULT cAlias    := Alias()
   DEFAULT cCaption  := "Busqueda incremental de " + cAlias
   DEFAULT uOrden    := ( cAlias )->( OrdSetFocus() )
   DEFAULT cField    := ( cAlias )->( FieldName( 1 ) )
   DEFAULT aOrd      := { ( cAlias )->( OrdName( 0 ) ) }
   DEFAULT aCampos   := { ( cAlias )->( FieldGet( 1 ) ), ( cAlias )->( FieldGet( 2 ) ) }
   DEFAULT aTitulos  := { ( cAlias )->( FieldName( 1 ) ), ( cAlias )->( FieldName( 2 ) ) }

   ::cAlias          := cAlias
   ::cField          := cField
   ::aOrd            := aOrd
   ::uOrden          := uOrden
   ::aCampos         := aCampos
   ::aTitulos        := aTitulos
   ::aSizes          := aSizes
   ::bAlta           := bAlta
   ::bEdit           := bEdit
   ::bZoom           := bZoom
   if aJustify  != nil
      ::aJustify     := aJustify
   end if

   ::nOrdenAnt       := ( ::cAlias )->( OrdSetFocus( uOrden ) )
   ::nRecno          := ( ::cAlias )->( Recno() )

   ( ::cAlias )->( dbGoTop() )

   ::Super:New( nil, nil, nil, nil, cCaption, "HELPENTRY", GetResources() )

   ::Resources()

Return ( Self )

//------------------------------------------------------------------------------------------------------------------------------

METHOD Resources() CLASS TBuscar

   local oGet
   local cGet     := Space( 100 )
   local oCbxOrd
   local cCbxOrd
   local nOrdAnt  := GetBrwOpt( ::cCaption )

   nOrdAnt        := Min( Max( nOrdAnt, 1 ), len( ::aOrd ) )
   cCbxOrd        := ::aOrd[ nOrdAnt ]

   ( ::cAlias )->( OrdSetFocus( nOrdAnt ) )

   ( ::cAlias )->( dbGoTop() )

   REDEFINE GET oGet VAR cGet;
      ID       104 ;
      PICTURE  "@!" ;
      BITMAP   "FIND" ;
      OF       Self

   oGet:bChange         := {|nKey, nFlags| AutoSeek( nKey, nFlags, oGet, ::oBrw, ::cAlias, .t. ) }
   oGet:bValid          := {|| OrdClearScope( ::oBrw, ::cAlias ), ::oBrw:Refresh(), .t. }

   REDEFINE COMBOBOX oCbxOrd VAR cCbxOrd ;
      ID       102 ;
      ITEMS    ::aOrd ;
      OF       Self
   oCbxOrd:bChange      := {|| ( ::cAlias )->( OrdSetFocus( oCbxOrd:nAt ) ), ::oBrw:Refresh(), oGet:SetFocus() }

   ::oBrw               := TWBrowse():Redefine( 105,;
                                                {|| ::aFields() },;
                                                Self,;
                                                ::aTitulos,;
                                                ::aSizes, , , , , , , , , , , , ,;
                                                ::cAlias  )
   ::oBrw:blDblClick    := {|| ::End( IDOK ) }
   ::oBrw:aJustify      := ::aJustify

   REDEFINE BUTTON ;
      ID       500 ;
      OF       Self ;
      WHEN     ::bAlta != nil .and. !IsReport() ;
      ACTION   ::Append()

   REDEFINE BUTTON ;
      ID       501 ;
      OF       Self ;
      WHEN     ::bEdit != nil .and. !IsReport() ;
      ACTION   ::Edit()

   REDEFINE BUTTON ;
      ID       IDOK ;
      OF       Self ;
      ACTION   ( ::end( IDOK ) )

   REDEFINE BUTTON ;
      ID       IDCANCEL ;
      OF       Self ;
      ACTION   ( ::end() )

   ::bStart             := {|| oGet:SetFocus()  }

return ( NIL )

//------------------------------------------------------------------------------------------------------------------------------

METHOD aFields() CLASS TBuscar

   local i
   local nPos
   local aFields        := Array( len( ::aCampos ) )

   for i := 1 to len( ::aCampos )
      if ValType( ::aCampos[ i ] ) == "C"
         nPos           := ( ::cAlias )->( fieldPos( ::aCampos[ i ] ) )
         aFields[ i ]   := ( ::cAlias )->( fieldGet( nPos ) )
         aFields[ i ]   := cValToChar( aFields[ i ] )
      else
         aFields[ i ]   := cValToChar( eval( ::aCampos[ i ] ) )
      endif
   next

return ( aFields )

//------------------------------------------------------------------------------------------------------------------------------

METHOD SetFilter( cField, uVal1, uVal2 ) CLASS TBuscar

   ::cCampo := cField
   ::uVal1  := uVal1
   ::uVal2  := uVal2
   ::oBrw:SetFilter( ::cCampo, ::uVal1, ::uVal2 )
   ::oBrw:Refresh()

return nil

//------------------------------------------------------------------------------------------------------------------------------

METHOD ChangeGet( uBuffer ) CLASS TBuscar

   local xValor

   if ::cCampo != NIL
      uBuffer := ::uVal1 + uBuffer
   end if

   xValor   := ( ::cAlias )->( ordKeyVal() )

   if ValTYpe( xValor ) == "N"
      uBuffer := Val( uBuffer )
   endif

   DbSeek( uBuffer , .t. )
   ::oBrw:Refresh()

return nil

//------------------------------------------------------------------------------------------------------------------------------

METHOD Append() CLASS TBuscar

   if ::bAlta != NIL
      Eval( ::bAlta , Self )
      ::oBrw:refresh()
   endif

return nil

//------------------------------------------------------------------------------------------------------------------------------

METHOD Edit() CLASS TBuscar

   if ::bEdit != NIL
      Eval( ::bEdit , Self )
      ::oBrw:refresh()
   endif

return nil

//------------------------------------------------------------------------------------------------------------------------------

METHOD Zoom() CLASS TBuscar

   if ::bZoom != NIL
      Eval( ::bZoom , Self )
      ::oBrw:refresh()
   endif

return nil

//------------------------------------------------------------------------------------------------------------------------------

METHOD Getfield() CLASS TBuscar

return ( ::uVal )

//------------------------------------------------------------------------------------------------------------------------------

METHOD Activate() CLASS TBuscar

   if !IsReport()
      ::AddFastKey( VK_F2, {|| ::Append() } )
      ::AddFastKey( VK_F3, {|| ::Edit() } )
   end if

   ::AddFastKey( VK_F5, {|| ::End( IDOK ) } )

Return ::Super:Activate( , , , .t. )

//------------------------------------------------------------------------------------------------------------------------------

METHOD End( nResult ) CLASS TBuscar

   DEFAULT nResult := IDCANCEL

   ::Super:End( nResult )

   if nResult == IDOK
      ::uVal := ( ::cAlias )->( fieldGet( fieldPos( ::cField ) ) )
   endif

return .t.

//------------------------------------------------------------------------------------------------------------------------------

Method Create( oParent, cField )

   local oGet
   local cGet           := Space( 100 )
   local oBrw
   local oDbf
   local oIndex
   local oField
   local oCbxOrd
   local cCbxOrd
   local aIndex         := {}
   local nOrdAnt        := 2
   local cCaption

   if Empty( oParent )
      MsgStop( "No se ha definido objeto padre en la clase busqueda." )
      Return ( Self )
   end if

   oDbf                 := oParent:oDbf
   ::cField             := cField

   cCaption             := "Buscando " + Rtrim( Lower( oDbf:cComment ) )

   /*
   Relación de ordenes---------------------------------------------------------
   */

   for each oIndex in oDbf:aTIndex
      if !Empty( oIndex:cComment )
         aAdd( aIndex, oIndex:cComment )
      end if
   next

   /*
   Orden de la tabla-----------------------------------------------------------
   */

   nOrdAnt              := Min( Max( nOrdAnt, 1 ), len( aIndex ) )
   cCbxOrd              := aIndex[ nOrdAnt ]

   /*
   Estado de la base de datos--------------------------------------------------
   */

   oDbf:OrdSetFocus( nOrdAnt )

   oDbf:GoTop()

   /*
   Creamos el dialogo----------------------------------------------------------
   */

   ::Super:New( , , , , cCaption, "HELPENTRY", GetResources() )

   REDEFINE GET oGet VAR cGet;
      ID       104 ;
      PICTURE  "@!" ;
      OF       Self
   oGet:bChange            := {|| oGet:Assign(), oBrw:Seek( Alltrim( oGet:VarGet() ) ) }

   REDEFINE COMBOBOX oCbxOrd VAR cCbxOrd ;
      ID       102 ;
      ITEMS    aIndex ;
      OF       Self
   oCbxOrd:bChange         := {|| oDbf:OrdSetFocus( oCbxOrd:nAt ), oBrw:Refresh(), oGet:SetFocus() }

   /*
   Objeto xBrowse--------------------------------------------------------------
   */

#ifndef __PDA__
   oBrw                    := IXBrowse():New( Self )
#endif

   oBrw:bClrSel            := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
   oBrw:bClrSelFocus       := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

   oBrw:nMarqueeStyle      := 5

   oBrw:cName              := cCaption

   oBrw:bSeek              := {|c| oDbf:Seek( c ) }
   oBrw:oSeek              := oGet

   oBrw:bLDblClick         := {|| ::end( IDOK ) }
   oBrw:bRClicked          := {| nRow, nCol, nFlags | oBrw:RButtonDown( nRow, nCol, nFlags ) }

   oDbf:SetBrowse( oBrw )

   /*
   Añadimos las columnas-------------------------------------------------------
   */

   for each oField in oDbf:aTField

      if ! oField:lHide

         with object ( oBrw:AddCol() )

            :cHeader          := oField:cComment
            :nWidth           := oField:nColSize

            if oField:lCalculate
               :bEditValue    := oField:bSetGet
            else
               :bEditValue    := oField:bDirect
            end if

            if !Empty( oField:aBitmaps )
               :bStrData      := {|| "" }
               :SetCheck( oField:aBitmaps )
            end if

            if oField:lColAlign
               :nDataStrAlign := AL_RIGHT
               :nHeadStrAlign := AL_RIGHT
            end if

            if aScan( aIndex, {|cIndex| cIndex == :cHeader } ) != 0
               :cSortOrder    := oField:cName
               :bLClickHeader := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ), oBrw:GoTop() }
            end if

         end with

      endif

   next

   oBrw:CreateFromResource( 105 )

   /*
   Botones---------------------------------------------------------------------
   */

   REDEFINE BUTTON ;
      ID       500 ;
      OF       Self ;
      WHEN     ( !IsReport() ) ;
      ACTION   ( oParent:Append( oBrw ) )

   REDEFINE BUTTON ;
      ID       501 ;
      OF       Self ;
      WHEN     ( !IsReport() ) ;
      ACTION   ( oParent:Edit( oBrw ) )

   REDEFINE BUTTON ;
      ID       IDOK ;
      OF       Self ;
      ACTION   ( ::end( IDOK ) )

   REDEFINE BUTTON ;
      ID       IDCANCEL ;
      OF       Self ;
      ACTION   ( ::end() )

   ::bStart    := {|| oBrw:Load(), oGet:SetFocus() }

   if !IsReport()
      ::AddFastKey( VK_F2, {|| ::Append( oBrw ) } )
      ::AddFastKey( VK_F3, {|| ::Edit( oBrw ) } )
   end if

   ::AddFastKey( VK_F5, {|| ::end( IDOK ) } )

   ::Super:Activate( , , , .t. )

   /*
   Guardamos el valor de la busqueda-------------------------------------------
   */

   if ::nResult == IDOK
      ::uVal   := oDbf:FieldGetByName( ::cField )
   endif

Return ( Self )

//------------------------------------------------------------------------------------------------------------------------------