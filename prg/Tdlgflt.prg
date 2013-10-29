#include "FiveWin.Ch"
#include "Factu.ch"
#include "Font.ch"
#include "Report.ch"
#include "MesDbf.ch"
#include "DbInfo.ch"
#include "Xbrowse.ch"

//---------------------------------------------------------------------------//

CLASS TDlgFlt

   DATA oDbf

   DATA aTField

   DATA cExpFilter
   DATA bExpFilter
   DATA aExpFilter
   DATA cTxtFilter
   DATA aFldFilter
   DATA aConFilter
   DATA aValFilter
   DATA aNexFilter
   DATA oFldFilter
   DATA oConFilter
   DATA oValFilter
   DATA oNexFilter

   DATA aTblConditionNumerico 
   DATA aTblConditionCaracter 
   DATA aTblConditionFecha
   DATA aTblConditionLogico

   DATA cTipFilter
   DATA cTexFilter            INIT ""
   DATA cDbfFilter

   DATA oWndBrw

   DATA lDefaultFilter        INIT .f.
   DATA cDefaultFilter

   DATA lAllUser              INIT .f.

   DATA lMultyExpresion       INIT .f.

   DATA aTblMask
   DATA aTblField
   DATA aTblType
   DATA aTblLen
   DATA aTblDecimals
   DATA aTblNexo
   DATA aTblCondition
   DATA aTblExpresion
   DATA aTblSimbolos

   DATA oReplace
   DATA cReplace
   DATA cFldReplace
   DATA oExpReplace
   DATA cExpReplace
   DATA oMtrReplace
   DATA nMtrReplace
   DATA lAllRecno

   DATA oWebBtn

   DATA lAplyFilter

   DATA bOnAplyFilter
   DATA bOnKillFilter

   DATA cPath

   DATA lAppendFilter         INIT .f.

   DATA oDlg
   DATA oFld
   DATA cResource             INIT "FastFiltros"
   DATA oBrwFilter
   DATA oBrwAlmacenados

   DATA oColCondicion
   DATA oColValor

   CLASSDATA aFilter          INIT {}

   CLASSDATA cOrdAnterior
   CLASSDATA nRecAnterior
   CLASSDATA cBagAnterior
   CLASSDATA cNamAnterior

   METHOD New( aTField, oDbf )
   METHOD Init( oDbf, oWndBrw )
   METHOD Create( aTField, oDbf )

   METHOD CreateFilter( oDlg )
   METHOD SaveFilter()
   METHOD DeleteFilter()

   METHOD KillFilter( oDlg )

   METHOD SetFilter( cText )

   METHOD lBuildFilter()
   METHOD AplyFilter()
   METHOD lBuildAplyFilter()  INLINE ( if( ::lBuildFilter(), ::AplyFilter(), ) )

   METHOD Default()

   METHOD AddFilter()         INLINE ( ::lAppendFilter := .t., ::Resource() )
   METHOD EditFilter()        INLINE ( ::lAppendFilter := .f., ::Resource() )
   METHOD Resource()
   METHOD StarResource( oBtnSave, oBtnDelete, oDlg )

   METHOD Dialog()
   METHOD InitDialog()
   METHOD ValidDialog()

   METHOD Load()              VIRTUAL
   METHOD LoadFilter()

   METHOD ChgFields()

   METHOD ExpMaker()

   METHOD aExpMaker()

   METHOD ExeReplace()

   METHOD ChgGet( cType, nLen, nDec )

   METHOD lGetFilterName()

   METHOD lValidFilterName( oDlg )

   METHOD NexoOnPostEdit( o, x, n ) 

   METHOD CampoOnPostEdit( o, x, n )
  
   METHOD ReturnFilter()               INLINE ( if( ::ExpresionBuilder(), ::oDlg:End( IDOK ), ) )

   METHOD ExpresionBuilder( oDlg )   

   METHOD cField( aField )             INLINE ( ::aTblField[ Min( Max( aScan( ::aTblMask, Alltrim( aField[ 1 ] ) ), 0 ), len( ::aTblField ) ) ] )

   METHOD cCondition( aField )         INLINE ( ::aTblSimbolos[ Min( Max( aScan( ::aTblCondition, aField[ 2 ] ), 0 ), len( ::aTblSimbolos ) ) ] )

   METHOD cValue( aField )             INLINE ( cGetValue( aField[ 3 ], ::aTblType[ Min( Max( aScan( ::aTblMask, Alltrim( aField[ 1 ] ) ), 0 ), len( ::aTblType ) ) ] ) )

   METHOD cNexo( aField )              INLINE ( ::aTblExpresion[ Min( Max( aScan( ::aTblNexo, Alltrim( aField[ 4 ] ) ), 0 ), len( ::aTblExpresion ) ) ] )

   METHOD SetFilterType( cTipFilter )  INLINE ( ::cTipFilter := cTipFilter )

   INLINE METHOD cSerializeFilter()

      local cFilter
      local aFilter
      local cSerializeFilter  := ""

      for each aFilter in ::aFilter
         for each cFilter in aFilter
            cSerializeFilter  += Alltrim( cValToChar( cFilter ) ) + ","
         next
      next

      RETURN ( cSerializeFilter )

   ENDMETHOD

   INLINE METHOD cDeSerializeFilter( cFilterSerialized )

      local cFilter
      local aFilter           := hb_ATokens( cFilterSerialized, "," )

      ::aFilter               := { {} }

      for each cFilter in aFilter
         
         aAdd( aTail( ::aFilter ), cFilter )

         if ( mod( hb_EnumIndex(), 4 ) == 0 )
            aAdd( ::aFilter, {} )
         end if 

      next 

      RETURN ( Self )

   ENDMETHOD

   INLINE METHOD SetFilterDatabase( uDbfFilter )

      do case
         case IsObject( uDbfFilter )
            ::cDbfFilter   := uDbfFilter:nArea
         case IsChar(  uDbfFilter )
            ::cDbfFilter   := uDbfFilter
      end case

      RETURN ( Self )

   ENDMETHOD

   INLINE METHOD SelectTable()

      do case
         case IsObject( ::oDbf )
            ::oDbf:SetFocus()
         case IsChar( ::oDbf )
            Select( ::oDbf )
      end case 

      RETURN ( Self )

   ENDMETHOD

   METHOD AppendLine()                 INLINE ( aAdd( ::aFilter, { ::aTblMask[ 1 ], ::aTblCondition[ 1 ], Space( 200 ), ::aTblNexo[ 1 ] } ) )

   INLINE METHOD DeleteLine()

      local nLineasFilter  := len( ::aFilter )

      if ( nLineasFilter > 1 ) .and. ( ::oBrwFilter:nArrayAt <= nLineasFilter )
         aDel( ::aFilter, ::oBrwFilter:nArrayAt, .t. ) 
         ::oBrwFilter:Refresh()
      end if 

      RETURN ( Self )

   ENDMETHOD

END CLASS

//---------------------------------------------------------------------------//

METHOD New( aTField, oDbf, oWebBtn, lAplyFilter, oWndBrw ) CLASS TDlgFlt

   local n

   DEFAULT aTField      := dbStruct()
   DEFAULT lAplyFilter  := .t.

   ::aTField            := aTField
   ::oDbf               := oDbf
   ::oWebBtn            := oWebBtn
   ::lAplyFilter        := lAplyFilter
   ::oWndBrw            := oWndBrw

   ::cTipFilter         := ""
   ::cTexFilter         := ""
   ::cDbfFilter         := ""

   ::cTxtFilter         := nil
   ::cExpFilter         := nil
   ::bExpFilter         := nil
   ::aExpFilter         := nil

   if Empty( ::aTField )
      MsgStop( "No hay tabla definida." )
      return ( Self )
   end if

   ::Default()

RETURN Self

//---------------------------------------------------------------------------//

METHOD Create( oDbf, oWebBtn, lAplyFilter, oWndBrw ) CLASS TDlgFlt

   local n

   DEFAULT lAplyFilter  := .t.

   ::oDbf               := oDbf
   ::oWebBtn            := oWebBtn
   ::lAplyFilter        := lAplyFilter
   ::oWndBrw            := oWndBrw

   ::aTField            := aClone( oDbf:aTField )

   ::lAllRecno          := .f.

   ::cTxtFilter         := nil
   ::cExpFilter         := nil
   ::bExpFilter         := nil
   ::aExpFilter         := nil

   if Empty( ::aTField )
      MsgStop( "No hay tabla definida." )
      return ( Self )
   end if

   ::aFilter            := {}

   ::Default()

   ::AppendLine()

RETURN Self

//---------------------------------------------------------------------------//

METHOD Init( oWndBrw ) CLASS TDlgFlt

   ::oWndBrw            := oWndBrw
   ::oDbf               := oWndBrw:xAlias

   ::aFilter            := {}

   ::lAplyFilter        := .t.

RETURN Self

//---------------------------------------------------------------------------//

Method Default()

   local oFld

   ::aFldFilter            := Afill( Array( 5 ), "" )
   ::aConFilter            := Afill( Array( 5 ), "Contenga" )
   ::aValFilter            := Afill( Array( 5 ), Space( 100 ) )
   ::aNexFilter            := Afill( Array( 4 ), "" )

   ::oFldFilter            := Array( 5 )
   ::oConFilter            := Array( 5 )
   ::oValFilter            := Array( 5 )
   ::oNexFilter            := Array( 4 )

   ::lAllRecno             := .f.

   ::aTblMask              := {}          // Muestra las mascaras
   ::aTblField             := {}          // Muestra las campos
   ::aTblType              := {}          // Tipos de campo
   ::aTblLen               := {}          // Len del campo
   ::aTblDecimals          := {}          // Decimales del campo

   ::nMtrReplace           := 0

   ::cExpReplace           := Space( 100 )

   ::aTblNexo              := {  " ", "Y", "O" }
   ::aTblExpresion         := {  "", " .and. ", " .or. " }

   ::aTblCondition         := {  "Igual",;
                                 "Distinto",;
                                 "Mayor",;
                                 "Menor",;
                                 "Mayor igual",;
                                 "Menor igual",;
                                 "Contenga",;
                                 "Dia semana igual",;
                                 "Mes igual",;
                                 "Año igual" }

   ::aTblSimbolos          := {  " == ", " != ", " > ", " < ", " >= ", " <= ", " $ " }

   ::aTblConditionNumerico := {  "Igual",;
                                 "Distinto",;
                                 "Mayor",;
                                 "Menor",;
                                 "Mayor igual",;
                                 "Menor igual" }

   ::aTblConditionCaracter := {  "Igual",;
                                 "Distinto",;
                                 "Contenga" }

   ::aTblConditionFecha    := {  "Igual",;
                                 "Distinto",;
                                 "Mayor",;
                                 "Menor",;
                                 "Mayor igual",;
                                 "Menor igual",;
                                 "Dia semana igual",;
                                 "Mes igual",;
                                 "Año igual" }

   ::aTblConditionLogico   := {  "Igual",;
                                 "Distinto" }


   if !Empty( ::aTField )                              
      
      for each oFld in ::aTField

         do case
         case IsObject( oFld )

            if !Empty( oFld:cComment ) .and. !( oFld:lCalculate ) .and. !( oFld:lHide )
               aAdd( ::aTblField,      oFld:cName )
               aAdd( ::aTblType,       oFld:cType )
               aAdd( ::aTblLen,        oFld:nLen )
               aAdd( ::aTblDecimals,   oFld:nDec )
               aAdd( ::aTblMask,       oFld:cComment )
            end if

         case IsArray( oFld )

            if !Empty( oFld[ 5 ] )
               aAdd( ::aTblField,      oFld[ 1 ] )
               aAdd( ::aTblType,       oFld[ 2 ] )
               aAdd( ::aTblLen,        oFld[ 3 ] )
               aAdd( ::aTblDecimals,   oFld[ 4 ] )
               aAdd( ::aTblMask,       oFld[ 5 ] )
            end if

         end case

      next

   end if

   for each oFld in ::aFldFilter
      if Empty( oFld )
         oFld           := ::aTblMask[ 1 ]
      end if
   next

Return ( Self )

//---------------------------------------------------------------------------//
//
// Caja de dialogo para creal el filtro
//

METHOD Resource( cTipFilter, cTexFilter, uDbfFilter, lDefFilter ) CLASS TDlgFlt

   local n
   local oBmp
   local oDlg
   local oBtnSave
   local oBtnDelete

   // Control antes de comenzar------------------------------------------------

   if Empty( ::aTField )
      MsgStop( "No hay tabla definida." )
      return ( Self )
   end if

   // Parametros --------------------------------------------------------------

   if !Empty( cTipFilter )
      ::cTipFilter      := cTipFilter
   end if

   if !Empty( cTexFilter )
      ::cTexFilter      := cTexFilter
   end if

   ::SetFilterDatabase( uDbfFilter )

   if IsLogic( lDefFilter )
      ::lDefaultFilter  := lDefFilter
   end if

   // Valores por defecto------------------------------------------------------

   ::Default()

   // Dialog-------------------------------------------------------------------

   DEFINE DIALOG oDlg ;
      RESOURCE    "Consulta" ;
      TITLE       if( ::lAppendFilter, "Añadiendo filtro", "Modificando filtro : " + Rtrim( ::cTexFilter ) )

      REDEFINE BITMAP oBmp ;
         ID       400 ;
         RESOURCE "Funnel_48_alpha"  ;
         TRANSPARENT ;
         OF       oDlg

      REDEFINE COMBOBOX ::oFldFilter[1] VAR ::aFldFilter[1] ;
         ITEMS    ::aTblMask ;
         ID       100 ;
         OF       oDlg

      REDEFINE COMBOBOX ::oConFilter[1] VAR ::aConFilter[1] ;
         ITEMS    ::aTblCondition ;
         ID       110 ;
         OF       oDlg

      REDEFINE GET ::oValFilter[1] VAR ::aValFilter[1] ;
         ID       120 ;
         OF       oDlg

      REDEFINE COMBOBOX ::oNexFilter[1] VAR ::aNexFilter[1] ;
         ITEMS    ::aTblNexo ;
         ON CHANGE( oDlg:aEvalWhen() ) ;
         ID       130 ;
         OF       oDlg

      /*
      Segunda linea______________________________________________________________
      */

      REDEFINE COMBOBOX ::oFldFilter[2] VAR ::aFldFilter[2] ;
         ITEMS    ::aTblMask ;
         WHEN     !empty( ::aNexFilter[1] ) ;
         ID       140 ;
         OF       oDlg

      REDEFINE COMBOBOX ::oConFilter[2] VAR ::aConFilter[2] ;
         ITEMS    ::aTblCondition ;
         WHEN     !empty( ::aNexFilter[1] );
         ID       150 ;
         OF       oDlg

      REDEFINE GET ::oValFilter[2] VAR ::aValFilter[2] ;
         WHEN     !empty( ::aNexFilter[1] ) ;
         ID       160 ;
         OF       oDlg

      REDEFINE COMBOBOX ::oNexFilter[2] VAR ::aNexFilter[2] ;
         ITEMS    ::aTblNexo ;
         ON CHANGE( oDlg:aEvalWhen() ) ;
         WHEN     !empty( ::aNexFilter[1] ) ;
         ID       170 ;
         OF       oDlg

      /*
      Tercera linea______________________________________________________________
      */

      REDEFINE COMBOBOX ::oFldFilter[3] VAR ::aFldFilter[3] ;
         ITEMS    ::aTblMask ;
         WHEN     !empty( ::aNexFilter[2] ) ;
         ID       180 ;
         OF       oDlg

      REDEFINE COMBOBOX ::oConFilter[3] VAR ::aConFilter[3] ;
         ITEMS    ::aTblCondition ;
         WHEN     !empty( ::aNexFilter[2] ) ;
         ID       190 ;
         OF       oDlg

      REDEFINE GET ::oValFilter[3] VAR ::aValFilter[3] ;
         WHEN     !empty( ::aNexFilter[2] ) ;
         ID       200 ;
         OF       oDlg

      REDEFINE COMBOBOX ::oNexFilter[3] VAR ::aNexFilter[3] ;
         ITEMS    ::aTblNexo ;
         ON CHANGE( oDlg:aEvalWhen() ) ;
         WHEN     !empty( ::aNexFilter[2] ) ;
         ID       210 ;
         OF       oDlg

      /*
      Cuarta linea_______________________________________________________________
      */

      REDEFINE COMBOBOX ::oFldFilter[4] VAR ::aFldFilter[4] ;
         ITEMS    ::aTblMask ;
         WHEN     !empty( ::aNexFilter[3] ) ;
         ID       220 ;
         OF       oDlg

      REDEFINE COMBOBOX ::oConFilter[4] VAR ::aConFilter[4] ;
         ITEMS    ::aTblCondition ;
         WHEN     !empty( ::aNexFilter[3] ) ;
         ID       230 ;
         OF       oDlg

      REDEFINE GET ::oValFilter[4] VAR ::aValFilter[4] ;
         WHEN     !empty( ::aNexFilter[3] ) ;
         ID       240 ;
         OF       oDlg

      REDEFINE COMBOBOX ::oNexFilter[4] VAR ::aNexFilter[4] ;
         ITEMS    ::aTblNexo ;
         ON CHANGE( oDlg:aEvalWhen() ) ;
         WHEN     !empty( ::aNexFilter[3] ) ;
         ID       250 ;
         OF       oDlg

      /*
      Quinta linea_______________________________________________________________
      */

      REDEFINE COMBOBOX ::oFldFilter[5] VAR ::aFldFilter[5] ;
         ITEMS    ::aTblMask ;
         WHEN     !empty( ::aNexFilter[4] ) ;
         ID       260 ;
         OF       oDlg

      REDEFINE COMBOBOX ::oConFilter[5] VAR ::aConFilter[5] ;
         ITEMS    ::aTblCondition ;
         WHEN     !empty( ::aNexFilter[4] ) ;
         ID       270 ;
         OF       oDlg

      REDEFINE GET ::oValFilter[5] VAR ::aValFilter[5] ;
         WHEN     !empty( ::aNexFilter[4] ) ;
         ID       280 ;
         OF       oDlg

      REDEFINE METER ::oMtrReplace VAR ::nMtrReplace ;
         PROMPT   "Filtrando" ;
         ID       290 ;
         OF       oDlg

      REDEFINE BUTTON oBtnSave ;
         ID       510 ;
         OF       oDlg ;
         ACTION   ( ::SaveFilter( oDlg ) )

      REDEFINE BUTTON oBtnDelete ;
         ID       500 ;
         OF       oDlg ;
         ACTION   ( ::DeleteFilter( oDlg ) )

      REDEFINE BUTTON ;
         ID       IDOK ;
         OF       oDlg ;
         ACTION   ( ::CreateFilter( oDlg ) )

      REDEFINE BUTTON ;
         ID       IDCANCEL ;
         OF       oDlg ;
         ACTION   ( oDlg:end( IDOK ) )

      oDlg:AddFastKey( VK_F5, {|| ::CreateFilter( oDlg ) } )

      oDlg:bStart := {|| ::StarResource( oBtnSave, oBtnDelete, oDlg ) }

   oDlg:Activate( , , , .t. )

   oBmp:End()

RETURN ( Self )

//---------------------------------------------------------------------------//

Method StarResource( oBtnSave, oBtnDelete, oDlg )

   if ::lAppendFilter
      oBtnDelete:Hide()
   else
      ::LoadFilter( oDlg )
   end if

RETURN ( Self )

//---------------------------------------------------------------------------//

Method Dialog()

   /*
   Aplicamos los valores segun se han archivado--------------------------------
   */

   ::Default()

   /*
   Caja de dialogo-------------------------------------------------------------
   */

   DEFINE DIALOG ::oDlg RESOURCE "FastFiltros"

      REDEFINE PAGES ::oFld ;
         ID       300;
         OF       ::oDlg ;
         DIALOGS  "FastFiltros_Definicion",;
                  "FastFiltros_Almacenados"

   /*
   Browse de los rangos----------------------------------------------------------
   */

   ::oBrwFilter                  := TXBrowse():New( ::oFld:aDialogs[ 1 ] )

   ::oBrwFilter:bClrSel          := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
   ::oBrwFilter:bClrSelFocus     := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

   ::oBrwFilter:SetArray( ::aFilter, , , .f. )

   ::oBrwFilter:lHScroll         := .f.
   ::oBrwFilter:lVScroll         := .f.
   ::oBrwFilter:lRecordSelector  := .t.
   ::oBrwFilter:lFastEdit        := .t.

   ::oBrwFilter:nFreeze          := 1
   ::oBrwFilter:nMarqueeStyle    := 3

   ::oBrwFilter:bChange          := {|| ::CampoOnPostEdit() }

   ::oBrwFilter:CreateFromResource( 310 )

   with object ( ::oBrwFilter:AddCol() )
      :cHeader          := "Campo"
      :bEditValue       := {|| ::aFilter[ ::oBrwFilter:nArrayAt, 1 ] }
      :nEditType        := EDIT_LISTBOX
      :aEditListTxt     := ::aTblMask
      :nWidth           := 240
      :bOnPostEdit      := {|o,x,n| ::CampoOnPostEdit( o, x, n ) } 
   end with

   with object ( ::oColCondicion := ::oBrwFilter:AddCol() )
      :cHeader          := "Condicion"
      :bEditValue       := {|| ::aFilter[ ::oBrwFilter:nArrayAt, 2 ] }
      :nEditType        := EDIT_LISTBOX
      :aEditListTxt     := ::aTblCondition
      :nWidth           := 100
      :bOnPostEdit      := {|o,x,n| If( n != VK_ESCAPE, ::aFilter[ ::oBrwFilter:nArrayAt, 2 ] := x, ) } 
   end with

   with object ( ::oColValor := ::oBrwFilter:AddCol() )
      :cHeader          := "Valor"
      :bEditValue       := {|| ::aFilter[ ::oBrwFilter:nArrayAt, 3 ] }
      :nEditType        := EDIT_GET
      :nWidth           := 200
      :bOnPostEdit      := {|o,x,n| If( n != VK_ESCAPE, ::aFilter[ ::oBrwFilter:nArrayAt, 3 ] := x, ) } 
   end with

   with object ( ::oBrwFilter:AddCol() )
      :cHeader          := "Nexo"
      :bEditValue       := {|| ::aFilter[ ::oBrwFilter:nArrayAt, 4 ] }
      :nEditType        := EDIT_LISTBOX
      :aEditListTxt     := ::aTblNexo
      :nWidth           := 60
      :bOnPostEdit      := {|o,x,n| ::NexoOnPostEdit( o, x, n ) } 
   end with

   /*
   Browse de los filtros almacenados-------------------------------------------
   */

   ::oBrwAlmacenados                   := TXBrowse():New( ::oFld:aDialogs[ 2 ] )

   ::oBrwAlmacenados:bClrSel           := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
   ::oBrwAlmacenados:bClrSelFocus      := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

   ::oBrwAlmacenados:nMarqueeStyle     := 5

   ::oBrwAlmacenados:lHScroll          := .f.
   ::oBrwAlmacenados:lVScroll          := .t.
   ::oBrwAlmacenados:lRecordSelector   := .t.

   ::oBrwAlmacenados:cAlias            := ::cDbfFilter

   ::oBrwAlmacenados:CreateFromResource( 310 )

   with object ( ::oBrwAlmacenados:AddCol() )
      :cHeader          := "Filtro"
      :bEditValue       := {|| ( ::cDbfFilter )->cTexFlt }
      :nWidth           := 600
   end with

   ::oDlg:AddFastKey( VK_F5, {|| ::ReturnFilter() } )

   ::oDlg:Activate( , , , .t., , , {|| ::InitDialog() } )

   ::ValidDialog()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD InitDialog()

   local oGrupo
   local oCarpeta
   local oOfficeBar

   CursorWait()

   oOfficeBar              := TDotNetBar():New( 0, 0, 1020, 115, ::oDlg, 1 )
   oOfficeBar:lPaintAll    := .f.
   oOfficeBar:lDisenio     := .f.

   oOfficeBar:SetStyle( 1 )

      oCarpeta             := TCarpeta():New( oOfficeBar, "Filtros" )

      oGrupo               := TDotNetGroup():New( oCarpeta, 66, "Acciones", .f. )
         
      TDotNetButton():New( 60, oGrupo, "Disk_blue_32",   "Guardar filtro",  1, {|| ::SaveFilter() }, , , .f., .f., .f. )

      oGrupo               := TDotNetGroup():New( oCarpeta, 126, "Acciones", .f. )
      
      TDotNetButton():New( 120, oGrupo, "Up16",    "Subir línea",    1, {|| ::oBrwFilter:GoUp() }, , , .f., .f., .f. )
      TDotNetButton():New( 120, oGrupo, "Down16",  "Bajar línea",    1, {|| ::oBrwFilter:GoDown() }, , , .f., .f., .f. )
      TDotNetButton():New( 120, oGrupo, "Del16",   "Eliminar línea", 1, {|| ::DeleteLine() }, , , .f., .f., .f. )

      oGrupo               := TDotNetGroup():New( oCarpeta, 126, "Salida", .f. )
         
      TDotNetButton():New( 60, oGrupo, "Funnel_32", "Aplicar filtro",   1, {|| ::ReturnFilter() }, , , .f., .f., .f. )
      TDotNetButton():New( 60, oGrupo, "End32",     "Salir",            2, {|| ::oDlg:End() }, , , .f., .f., .f. )

      if !Empty( ::cTipFilter )

      oCarpeta             := TCarpeta():New( oOfficeBar, "Filtros almacenados" )

      oGrupo               := TDotNetGroup():New( oCarpeta, 126, "Acciones", .f. )
         
      TDotNetButton():New( 60, oGrupo, "Disk_blue_32",   "Cargar filtro",     1, {|| ::LoadFilter() }, , , .f., .f., .f. )
      TDotNetButton():New( 60, oGrupo, "Del32",          "Eliminar filtro",   2, {|| ::DeleteFilter() }, , , .f., .f., .f. )

      oOfficeBar:bChange   := {|| ::oFld:SetOption( oOfficeBar:nOption ) }

      ( ::cDbfFilter )->( OrdScope( 0, ::cTipFilter ) )
      ( ::cDbfFilter )->( OrdScope( 1, ::cTipFilter ) )
      ( ::cDbfFilter )->( dbGoTop() )

      end if

   ::oDlg:oTop             := oOfficeBar

   CursorWE()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD ValidDialog()

   if ::oDlg:nResult != IDOK
      ::cExpFilter      := ""
      ::bExpFilter      := nil
   end if

   ( ::cDbfFilter )->( OrdScope( 0, nil ) )
   ( ::cDbfFilter )->( OrdScope( 1, nil ) )
   ( ::cDbfFilter )->( dbGoTop() )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD NexoOnPostEdit( o, x, n ) 

   local nAt               := ::oBrwFilter:nArrayAt

   if IsNum( n ) .and. ( n != VK_ESCAPE )

      if !Empty( x )
      
         ::aFilter[ nAt, 4 ]  := x

         if ( nAt ) == len( ::aFilter ) 
            ::AppendLine()
         end if 

         ::oBrwFilter:Refresh()

      end if 

   end if

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD CampoOnPostEdit( o, x, n )

   local nPos
   local lCambio                          := .f.
   local nAt                              := ::oBrwFilter:nArrayAt

   if IsNum( n ) .and. ( n != VK_ESCAPE )

      if !IsNil( x )
         if ::aFilter[ nAt, 1 ] != x
            ::aFilter[ nAt, 1 ]           := x
            lCambio                       := .t.
         end if 
      end if

      nPos                                := aScan( ::aTblMask, ::aFilter[ nAt, 1 ] )
      if nPos != 0

         do case
            case ::aTblType[ nPos ] == "C"

               ::oColCondicion:aEditListTxt   := ::aTblConditionCaracter

               ::oColValor:nEditType            := EDIT_GET              

               if Empty( ::aFilter[ nAt, 3 ] ) .or. lCambio
                  ::aFilter[ nAt, 3 ]           := Space( 200 )
               end if 

            case ::aTblType[ nPos ] == "N"

               ::oColCondicion:aEditListTxt   := ::aTblConditionNumerico

               ::oColValor:nEditType            := EDIT_GET              

               if Empty( ::aFilter[ nAt, 3 ] ) .or. lCambio
                  ::aFilter[ nAt, 3 ]           := 0
               end if 

            case ::aTblType[ nPos ] == "D"
               
               ::oColCondicion:aEditListTxt   := ::aTblConditionFecha

               ::oColValor:nEditType            := EDIT_DATE       
               
               if Empty( ::aFilter[ nAt, 3 ] ) .or. lCambio
                  ::aFilter[ nAt, 3 ]           := Date()
               end if 
               
            case ::aTblType[ nPos ] == "L"

               ::oColCondicion:aEditListTxt   := ::aTblConditionLogico

               ::oColValor:aEditListTxt         := { "Si", "No" }

               ::oColValor:nEditType            := EDIT_GET_LISTBOX

               if Empty( ::aFilter[ nAt, 3 ] ) .or. lCambio
                  ::aFilter[ nAt, 3 ]           := "Si"
               end if 

            otherwise

               ::oColCondicion:aEditListTxt     := ::aTblCondition

         end case 

         ::oBrwFilter:Refresh()

      end if

   end if 

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD ExpresionBuilder()

   local oBlock
   local oError
   local aFilter
   local lExpMaker   := .f.

   oBlock            := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      ::cExpFilter   := ""
      ::bExpFilter   := nil
      ::cTxtFilter   := ""

      for each aFilter in ::aFilter

         if len( aFilter ) > 0

            do case
               case aFilter[ 2 ] == "Igual"
                  ::cExpFilter   += ::cField( aFilter ) + " == " + ::cValue( aFilter )
   
               case aFilter[ 2 ] == "Distinto"
                  ::cExpFilter   += ::cField( aFilter ) + " != " + ::cValue( aFilter )
   
               case aFilter[ 2 ] == "Mayor"
                  ::cExpFilter   += ::cField( aFilter ) + " > " + ::cValue( aFilter )
   
               case aFilter[ 2 ] == "Menor"
                  ::cExpFilter   += ::cField( aFilter ) + " < " + ::cValue( aFilter )
   
               case aFilter[ 2 ] == "Mayor igual"
                  ::cExpFilter   += ::cField( aFilter ) + " >= " + ::cValue( aFilter )
   
               case aFilter[ 2 ] == "Menor igual"
                  ::cExpFilter   += ::cField( aFilter ) + " <= " + ::cValue( aFilter )
   
               case aFilter[ 2 ] == "Contenga"
                  ::cExpFilter   += ::cValue( aFilter ) + " $ " + ::cField( aFilter )
   
               case aFilter[ 2 ] == "Dia semana igual"
   
               case aFilter[ 2 ] == "Mes igual"
   
               case aFilter[ 2 ] == "Año igual"
               
            end case
   
            ::cExpFilter         += ::cNexo( aFilter )

         end if 

      next

      /*
      Seleccionamos la tabla--------------------------------------------------
      */

      ::SelectTable( ::oDbf )

      /*
      Construimos el filtro----------------------------------------------------
      */

      if Empty( ::cExpFilter ) .or. At( Type( ::cExpFilter ), "UEUI" ) != 0

         msgStop( "Expresión " + Rtrim( ::cExpFilter ) + " no valida", "Expresión incorrecta [" + Type( ::cExpFilter ) + "]" )
      
         ::cExpFilter   := ""
         ::bExpFilter   := nil
         ::cTxtFilter   := ""
      
      else
      
         ::bExpFilter   := Compile( ::cExpFilter )

         lExpMaker      := .t.
      
      end if

   RECOVER USING oError

      msgStop( ErrorMessage( oError ), "Error!" )

   END SEQUENCE

   ErrorBlock( oBlock )

Return ( lExpMaker )

//--------------------------------------------------------------------------//

Method CreateFilter( oDlg, cTipFilter )

   oDlg:Disable()

   if ::lMultyExpresion
      if ::aExpMaker()
         ::AplyFilter()
      end if
   else
      if ::ExpMaker()
         ::AplyFilter()
      end if
   end if

   oDlg:Enable()

   oDlg:End( IDOK )

Return ( Self )

//---------------------------------------------------------------------------//

METHOD ChgFields()

   local This     := Self
   local oDlg

   if Empty( ::aTField )
      MsgStop( "No hay tabla definida." )
      return ( Self )
   end if

   DEFINE DIALOG oDlg RESOURCE "CHGFIELDS"

   REDEFINE COMBOBOX ::oReplace VAR ::cReplace ;
      ITEMS    ::aTblMask ;
      ON CHANGE( This:cFldReplace := This:aTblField[ This:oReplace:nAt ] ) ;
      ID       80 ;
      OF       oDlg

   REDEFINE GET ::oExpReplace VAR ::cExpReplace ;
      ID       90 ;
      OF       oDlg

   REDEFINE CHECKBOX ::lAllRecno ;
      ID       70 ;
      ON CHANGE( oDlg:aEvalWhen() );
      OF       oDlg

   REDEFINE COMBOBOX ::oFldFilter[1] VAR ::aFldFilter[1] ;
      ITEMS    ::aTblMask ;
      WHEN     !::lAllRecno ;
      ID       100 ;
      OF       oDlg

   REDEFINE COMBOBOX ::oConFilter[1] VAR ::aConFilter[1] ;
      ITEMS    ::aTblCondition ;
      WHEN     !::lAllRecno ;
      ID       110 ;
      OF       oDlg

   REDEFINE GET ::oValFilter[1] VAR ::aValFilter[1] ;
      ID       120 ;
      WHEN     !::lAllRecno ;
      OF       oDlg

   REDEFINE COMBOBOX ::oNexFilter[1] VAR ::aNexFilter[1] ;
      ITEMS    ::aTblNexo ;
      ON CHANGE( oDlg:aEvalWhen() ) ;
      WHEN     !::lAllRecno ;
      ID       130 ;
      OF       oDlg

   /*
   Segunda linea______________________________________________________________
   */

   REDEFINE COMBOBOX ::oFldFilter[2] VAR ::aFldFilter[2] ;
      ITEMS    ::aTblMask ;
      WHEN     ( !::lAllRecno .and. !empty( ::aNexFilter[1] ) );
      ID       140 ;
      OF       oDlg

   REDEFINE COMBOBOX ::oConFilter[2] VAR ::aConFilter[2] ;
      ITEMS    ::aTblCondition ;
      WHEN     ( !::lAllRecno .and. !empty( ::aNexFilter[1] ) );
      ID       150 ;
      OF       oDlg

   REDEFINE GET ::oValFilter[2] VAR ::aValFilter[2] ;
      WHEN     ( !::lAllRecno .and. !empty( ::aNexFilter[1] ) );
      ID       160 ;
      OF       oDlg

   REDEFINE COMBOBOX ::oNexFilter[2] VAR ::aNexFilter[2] ;
      ITEMS    ::aTblNexo ;
      ON CHANGE( oDlg:aEvalWhen() ) ;
      WHEN     ( !::lAllRecno .and. !empty( ::aNexFilter[1] ) );
      ID       170 ;
      OF       oDlg

   /*
   Tercera linea______________________________________________________________
   */

   REDEFINE COMBOBOX ::oFldFilter[3] VAR ::aFldFilter[3] ;
      ITEMS    ::aTblMask ;
      WHEN     ( !::lAllRecno .and. !empty( ::aNexFilter[2] ) );
      ID       180 ;
      OF       oDlg

   REDEFINE COMBOBOX ::oConFilter[3] VAR ::aConFilter[3] ;
      ITEMS    ::aTblCondition ;
      WHEN     ( !::lAllRecno .and. !empty( ::aNexFilter[2] ) );
      ID       190 ;
      OF       oDlg

   REDEFINE GET ::oValFilter[3] VAR ::aValFilter[3] ;
      WHEN     ( !::lAllRecno .and. !empty( ::aNexFilter[2] ) );
      ID       200 ;
      OF       oDlg

   REDEFINE COMBOBOX ::oNexFilter[3] VAR ::aNexFilter[3] ;
      ITEMS    ::aTblNexo ;
      ON CHANGE( oDlg:aEvalWhen() ) ;
      WHEN     ( !::lAllRecno .and. !empty( ::aNexFilter[2] ) );
      ID       210 ;
      OF       oDlg

   /*
   Cuarta linea_______________________________________________________________
   */

   REDEFINE COMBOBOX ::oFldFilter[4] VAR ::aFldFilter[4] ;
      ITEMS    ::aTblMask ;
      WHEN     ( !::lAllRecno .and. !empty( ::aNexFilter[3] ) );
      ID       220 ;
      OF       oDlg

   REDEFINE COMBOBOX ::oConFilter[4] VAR ::aConFilter[4] ;
      ITEMS    ::aTblCondition ;
      WHEN     ( !::lAllRecno .and. !empty( ::aNexFilter[3] ) );
      ID       230 ;
      OF       oDlg

   REDEFINE GET ::oValFilter[4] VAR ::aValFilter[4] ;
      WHEN     ( !::lAllRecno .and. !empty( ::aNexFilter[3] ) );
      ID       240 ;
      OF       oDlg

   REDEFINE COMBOBOX ::oNexFilter[4] VAR ::aNexFilter[4] ;
      ITEMS    ::aTblNexo ;
      ON CHANGE( oDlg:aEvalWhen() ) ;
      WHEN     ( !::lAllRecno .and. !empty( ::aNexFilter[3] ) );
      ID       250 ;
      OF       oDlg

   /*
   Quinta linea_______________________________________________________________
   */

   REDEFINE COMBOBOX ::oFldFilter[5] VAR ::aFldFilter[5] ;
      ITEMS    ::aTblMask ;
      WHEN     ( !::lAllRecno .and. !empty( ::aNexFilter[4] ) );
      ID       260 ;
      OF       oDlg

   REDEFINE COMBOBOX ::oConFilter[5] VAR ::aConFilter[5] ;
      ITEMS    ::aTblCondition ;
      WHEN     ( !::lAllRecno .and. !empty( ::aNexFilter[4] ) );
      ID       270 ;
      OF       oDlg

   REDEFINE GET ::oValFilter[5] VAR ::aValFilter[5] ;
      WHEN     ( !::lAllRecno .and. !empty( ::aNexFilter[4] ) );
      ID       280 ;
      OF       oDlg

   REDEFINE METER ::oMtrReplace VAR ::nMtrReplace ;
      PROMPT   "Procesando" ;
      ID       290 ;
      OF       oDlg

   REDEFINE BUTTON ;
      ID       IDOK ;
      OF       oDlg ;
      ACTION   ( if( ::ExpMaker(), ( ::ExeReplace(), oDlg:end( IDOK ) ), ) )

   REDEFINE BUTTON ;
      ID       IDCANCEL ;
      OF       oDlg ;
      ACTION   ( oDlg:end() )

   oDlg:AddFastKey( VK_F5, {|| if( ::ExpMaker(), ( ::ExeReplace(), oDlg:end( IDOK ) ), ) } )

   ACTIVATE DIALOG oDlg CENTER

   if oDlg:nResult != IDOK
      ::cExpFilter   := ""
      ::bExpFilter   := nil
   end if

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD ExpMaker()

   local oBlock
   local n           := 1
   local lExpMaker   := .f.
   local aNex        := { " .AND. ", " .OR. " }
   local aExpCon     := { " == ", " != ", " > ", " < ", " >= ", " <= ", " $ ", "Dow()", "Month()", "Year()" }

   oBlock            := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   if ::lAllRecno

      ::cExpFilter   := ""
      ::bExpFilter   := {|| .t. }
      ::cTxtFilter   := ""
      lExpMaker      := .t.

   else

      ::cExpFilter   := ""
      ::bExpFilter   := nil
      ::cTxtFilter   := ""

      while n <= len( ::aValFilter )

         do case
            case aExpCon[ ::oConFilter[ n ]:nAt ] == " $ "
               ::cExpFilter   += cGetVal( ::aValFilter[ n ], ::aTblType[ ::oFldFilter[ n ]:nAt ] ) + aExpCon[ ::oConFilter[ n ]:nAt ] + cGetField( ::aTblField[ ::oFldFilter[ n ]:nAt ], ::aTblType[ ::oFldFilter[ n ]:nAt ] )

            case aExpCon[ ::oConFilter[ n ]:nAt ] == "Dow()"
               ::cExpFilter   += "Dow( " + cGetField( ::aTblField[ ::oFldFilter[ n ]:nAt ], ::aTblType[ ::oFldFilter[ n ]:nAt ] ) + " ) == " + cGetVal( ::aValFilter[ n ], ::aTblType[ ::oFldFilter[ n ]:nAt ], aExpCon[ ::oConFilter[ n ]:nAt ] )

            case aExpCon[ ::oConFilter[ n ]:nAt ] == "Month()"
               ::cExpFilter   += "Month( " + cGetField( ::aTblField[ ::oFldFilter[ n ]:nAt ], ::aTblType[ ::oFldFilter[ n ]:nAt ] ) + " ) == " + cGetVal( ::aValFilter[ n ], ::aTblType[ ::oFldFilter[ n ]:nAt ], aExpCon[ ::oConFilter[ n ]:nAt ] )

            case aExpCon[ ::oConFilter[ n ]:nAt ] == "Year()"
               ::cExpFilter   += "Year( " + cGetField( ::aTblField[ ::oFldFilter[ n ]:nAt ], ::aTblType[ ::oFldFilter[ n ]:nAt ] ) + " ) == " + cGetVal( ::aValFilter[ n ], ::aTblType[ ::oFldFilter[ n ]:nAt ], aExpCon[ ::oConFilter[ n ]:nAt ] )

            otherwise
               ::cExpFilter   += cGetField( ::aTblField[ ::oFldFilter[ n ]:nAt ], ::aTblType[ ::oFldFilter[ n ]:nAt ] ) + aExpCon[ ::oConFilter[ n ]:nAt ] + cGetVal( ::aValFilter[ n ], ::aTblType[ ::oFldFilter[ n ]:nAt ] )

         end case

         ::cTxtFilter      += ::aTblMask[ ::oFldFilter[n]:nAt ] + Space( 1 ) + lower( ::aTblCondition[ ::oConFilter[n]:nAt ] ) + Space( 1 ) + cGetVal( ::aValFilter[n], ::aTblType[ ::oFldFilter[n]:nAt ] )

         if ::oNexFilter[ n ]:nAt != 1
            ::cExpFilter   += aNex[ ::oNexFilter[n]:nAt - 1 ]
            ::cTxtFilter   += Space( 1 ) + lower( ::aTblNexo[ ::oNexFilter[n]:nAt ] ) + Space( 1 )
         else
            exit
         end if

         n++

      end do

      do case
         case IsObject( ::oDbf )
            ::oDbf:SetFocus()
         case IsChar( ::oDbf )
            Select( ::oDbf )
      end case

      if Empty( ::cExpFilter ) .or. At( Type( ::cExpFilter ), "UEUI" ) != 0
         msgStop( "Expresión " + Rtrim( ::cExpFilter ) + " no valida" )
         ::cExpFilter   := ""
         ::bExpFilter   := nil
         ::cTxtFilter   := ""
      else
         ::bExpFilter   := Compile( ::cExpFilter )
         lExpMaker      := .t.
      end if

   end if

   RECOVER

      msgStop( "Expresión " + Rtrim( ::cExpFilter ) + " no valida" )

   END SEQUENCE

   ErrorBlock( oBlock )

Return ( lExpMaker )

//--------------------------------------------------------------------------//

METHOD aExpMaker()

   local n           := 1
   local i           := 1
   local aNex        := {  " .AND. ", " .OR. " }
   local aExpCon     := {  " == ", " != ", " > ", " < ", " >= ", " <= ", " $ " }
   local oBlock      := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

   if ::lAllRecno

      ::aExpFilter   := { {|| .t. } }

   else

      ::aExpFilter            := {}

      for i := 1 to len( ::oDbf )

         ::cExpFilter         := ""
         ::cTxtFilter         := ""

         n                    := 1
         while n <= len( ::aValFilter )

            if Empty( ::aTblField[ ::oFldFilter[ n ]:nAt, i ] )
               ::cExpFilter      += ".t."
            else
               if aExpCon[ ::oConFilter[ n ]:nAt ] == " $ "
                  ::cExpFilter   += cGetVal( ::aValFilter[ n ], ::aTblType[ ::oFldFilter[ n ]:nAt, i ] ) + aExpCon[ ::oConFilter[ n ]:nAt ] + cGetField( ::aTblField[ ::oFldFilter[ n ]:nAt, i ], ::aTblType[ ::oFldFilter[ n ]:nAt, i ] )
               else
                  ::cExpFilter   += cGetField( ::aTblField[ ::oFldFilter[n]:nAt, i ], ::aTblType[ ::oFldFilter[n]:nAt, i ] ) + aExpCon[ ::oConFilter[n]:nAt ] + cGetVal( ::aValFilter[n], ::aTblType[ ::oFldFilter[n]:nAt, i ] )
               end if
            end if

            ::cTxtFilter         += ::aTblMask[ ::oFldFilter[ n ]:nAt ] + Space( 1 ) + lower( ::aTblCondition[ ::oConFilter[ n ]:nAt ] ) + Space( 1 ) + cGetVal( ::aValFilter[ n ], ::aTblType[ ::oFldFilter[ n ]:nAt, i ] )

            if ::oNexFilter[ n ]:nAt != 1
               ::cExpFilter      += aNex[ ::oNexFilter[ n ]:nAt - 1 ]
               ::cTxtFilter      += Space( 1 ) + lower( ::aTblNexo[ ::oNexFilter[ n ]:nAt ] ) + Space( 1 )
            else
               exit
            end if

            n++

         end do

         ::oDbf[ i ]:SetFocus()

         if Empty( ::cExpFilter ) .or. At( Type( ::cExpFilter ), "UEUI" ) != 0
            msgStop( "Expresión " + Rtrim( ::cExpFilter ) + " no valida" )
            ::cExpFilter         := ""
            ::cTxtFilter         := ""
         else
            aAdd( ::aExpFilter, Rtrim( ::cExpFilter ) )
         end if

      next

   end if

   RECOVER

      msgStop( "Expresión " + Rtrim( ::cExpFilter ) + " no valida" )
      Return ( .f. )

   END SEQUENCE

   ErrorBlock( oBlock )

Return ( .t. )

//--------------------------------------------------------------------------//

METHOD ExeReplace()

   local nRpl     := 0
   local cGetVal
   local nOrdAnt
   local nDbfRec
   local nFldPos

   if Empty( ::cFldReplace ) .or. Empty( ::cExpReplace )
      Return nil
   end if

   ::oMtrReplace:SetTotal( ( ::oDbf )->( LastRec() ) )

   do case
      case Valtype( ::oDbf ) == "O"

         ::oDbf:GetStatus()

         ::oDbf:SetStatus()

      case Valtype( ::oDbf ) == "C"

         nDbfRec        := ( ::oDbf )->( Recno() )
         nOrdAnt        := ( ::oDbf )->( OrdSetFocus( 0 ) )
         nFldPos        := ( ::oDbf )->( FieldPos( Rtrim( ::cFldReplace ) ) )

         if nFldPos != 0

            ( ::oDbf )->( dbGoTop() )
            while !( ::oDbf )->( eof() )

               cGetVal  := ( ::oDbf )->( Eval( Compile( cGetVal( ::cExpReplace, ValType( ( ::oDbf )->( FieldGet( nFldPos ) ) ) ) ) ) )

               if ::lAllRecno .or. ( ::oDbf )->( Eval( ::bExpFilter ) )
                  if ( ::oDbf )->( dbRLock() )
                     ( ::oDbf )->( FieldPut( nFldPos, cGetVal ) )
                     ( ::oDbf )->( dbUnLock() )
                  end if
                  ++nRpl
               end if

               ::oMtrReplace:Set( ( ::oDbf )->( RecNo() ) )

               ( ::oDbf )->( dbSkip() )

            end while

         end if

         ( ::oDbf )->( OrdSetFocus( nOrdAnt ) )
         ( ::oDbf )->( dbGoTo( nDbfRec ) )

   end case

   msgInfo( "Total de registros reemplazados " + Str( nRpl ), "Proceso finalizado." )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD ChgGet( cType, nLen, nDec, n )

   ::oValFilter[n]:bValid       := {|| .t. }
   ::oValFilter[n]:oGet:Picture := ""

   if cType == "L"
      ::oValFilter[n]:bValid := {| oVal | oVal:varGet() $ "SN" }
   end if

   ::oValFilter[n]:refresh()

RETURN ( Self )

//--------------------------------------------------------------------------//

STATIC FUNCTION retGet( cType, nLen, nDec )

   local cRet  := ""

   do case
      case cType == "L"
         cRet  := "S"
      case cType == "C"
         cRet  := Space( nLen )
      case cType == "N"
         cRet  := 0
      case cType == "D"
         cRet  := date()
   end case

RETURN cRet

//--------------------------------------------------------------------------//

STATIC FUNCTION cGetValue( xVal, cType )

   local cTemp    := ""

   DEFAULT cType  := ValType( xVal )

   do case
      case cType == "C" .or. cType == "M"

         if !Empty( xVal )
            xVal  := Rtrim( xVal )
         end if
         
         if ( '"' $ xVal ) .or. ( "'" $ xVal )
            cTemp := Rtrim( cValToChar( xVal ) )
         else
            cTemp := '"' + Rtrim( cValToChar( xVal ) ) + '"'
         end if

      case cType == "N"
         cTemp    := cValToChar( xVal )

      case cType == "D"

         cTemp    := 'Ctod( "' + Rtrim( cValToChar( xVal ) ) + '" )'

      case cType == "L"
         if "S" $ Rtrim( Upper( xVal ) )
            cTemp := ".t."
         else
            cTemp := ".f."
         end if

   end case

RETURN ( Rtrim( cTemp ) )

//---------------------------------------------------------------------------//

STATIC FUNCTION cGetVal( xVal, cType, cNexo )

   local cTemp    := ""

   DEFAULT cType  := ValType( xVal )

   if "$" $ xVal
      xVal        := Rtrim( StrTran( xVal, "$", "" ) )
      xVal        := &( xVal )
   end if

   if SubStr( xVal, 1, 1 ) == "&"
      Return ( cGetVal( Eval( bChar2Block( SubStr( xVal, 2 ) ) ), cType ) )
   end if

   do case
      case cType == "C" .or. cType == "M"
         if !Empty( xVal )
            xVal  := Rtrim( xVal )
         end if
         if ( '"' $ xVal ) .or. ( "'" $ xVal )
            cTemp := Rtrim( cValToChar( xVal ) )
         else
            cTemp := '"' + Rtrim( cValToChar( xVal ) ) + '"'
         end if

      case cType == "N"
         cTemp    := cValToChar( xVal )

      case cType == "D"

         do case
            case cNexo == "Dow()"
               cTemp := Rtrim( cValToChar( xVal ) )
            case cNexo == "Month()"
               cTemp := Rtrim( cValToChar( xVal ) )
            case cNexo == "Year()"
               cTemp := Rtrim( cValToChar( xVal ) )
            otherwise
               cTemp := 'Ctod( "' + Rtrim( cValToChar( xVal ) ) + '" )'
         end case

      case cType == "L"
         if "S" $ Rtrim( Upper( xVal ) )
            cTemp := ".t."
         else
            cTemp := ".f."
         end if

   end case

RETURN ( Rtrim( cTemp ) )

//---------------------------------------------------------------------------//

STATIC FUNCTION cGetField( xField, cType )

   local cTemp    := ""

   DEFAULT cType  := ValType( xField )

   if cType == "C" .or. cType == "M"
      cTemp       := 'Rtrim( ' + Rtrim( xField ) + ' )'
   else
      cTemp       := xField
   end case

RETURN ( cTemp )

//---------------------------------------------------------------------------//

METHOD AplyFilter()

   local oBlock
   local oError
   local nEvery
   local cOrdKey
   local bOrdKey

   oBlock               := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   /*
   Borramos el filtro anterior si los hubiera--------------------------------
   */

   if !Empty( ::bOnAplyFilter )
      Eval( ::bOnAplyFilter )
   end if

   if ::cExpFilter != nil .and. ::lAplyFilter

      do case
         case IsObject( ::oDbf )

            if Empty( ::nRecAnterior )
               ::nRecAnterior := ( ::oDbf:cAlias )->( Recno() )
            end if

            if lAdsRdd()

               ( ::oDbf:cAlias )->( dbSetFilter( c2Block( ::cExpFilter + " .and. !Deleted()" ), ::cExpFilter + " .and. !Deleted()" ) )

               if !Empty( ::oWndBrw )
                  ::oWndBrw:ShowButtonFilter()
                  ::oWndBrw:ShowEditButtonFilter()
                  ::oWndBrw:Refresh()
               end if

            else

               SysRefresh()

               cOrdKey           := ( ::oDbf:cAlias )->( OrdKey() )

               if cOrdKey != nil

                  bOrdKey        := c2Block( cOrdKey )

                  if !Empty( ::oMtrReplace )
                     ::oMtrReplace:SetTotal( ( ::oDbf:cAlias )->( Lastrec() ) )
                     nEvery      := Int( ::oMtrReplace:nTotal / 10 )
                  end if

                  if Empty( ::cOrdAnterior )
                     ::cOrdAnterior := ( ::oDbf:cAlias )->( OrdSetFocus() )
                  end if

                  if Empty( ::nRecAnterior )
                     ::nRecAnterior := ( ::oDbf:cAlias )->( Recno() )
                  end if

                  if Empty( ::cBagAnterior )
                     ::cBagAnterior := ( ::oDbf:cAlias )->( dbOrderInfo( DBOI_FULLPATH ) )
                  end if

                  if Empty( ::cNamAnterior )
                     ::cNamAnterior := "OrdTmp" + cCurUsr()
                  end if

                  if !Empty( ::oMtrReplace )
                     ( ::oDbf:cAlias )->( OrdCondSet( ::cExpFilter + " .and. !Deleted()", c2Block( ::cExpFilter + " .and. !Deleted()" ),,, {|| ::oMtrReplace:Set( ( ::oDbf:cAlias )->( RecNo() ) ), SysRefresh() }, nEvery ) )
                  else
                     ( ::oDbf:cAlias )->( OrdCondSet( ::cExpFilter + " .and. !Deleted()", c2Block( ::cExpFilter + " .and. !Deleted()" ),,, {|| SysRefresh() } ) )
                  end if

                  ( ::oDbf:cAlias )->( OrdCreate( ::cBagAnterior, ::cNamAnterior, cOrdKey, bOrdKey ) )
                  ( ::oDbf:cAlias )->( OrdSetFocus( ::cNamAnterior, ::cBagAnterior ) )
                  ( ::oDbf:cAlias )->( dbGoTop() )

                  if !Empty( ::oWndBrw )
                     ::oWndBrw:ShowButtonFilter()
                     ::oWndBrw:ShowEditButtonFilter()
                     ::oWndBrw:Refresh()
                  end if

               else

                  MsgStop( "No existe indice para la busqueda" )

               end if

            end if

         case IsChar( ::oDbf )

            if Empty( ::nRecAnterior )
               ::nRecAnterior := ( ::oDbf )->( Recno() )
            end if

            if lAdsRdd()

               ( ::oDbf )->( dbSetFilter( c2Block( ::cExpFilter + " .and. !Deleted()" ), ::cExpFilter + " .and. !Deleted()" ) )

               if !Empty( ::oWndBrw )
                  ::oWndBrw:ShowButtonFilter()
                  ::oWndBrw:ShowEditButtonFilter()
                  ::oWndBrw:Refresh()
               end if

            else

               SysRefresh()

               cOrdKey           := ( ::oDbf )->( OrdKey() )

               if !Empty( cOrdKey )

                  bOrdKey        := c2Block( cOrdKey )

                  if !Empty( ::oMtrReplace )
                     ::oMtrReplace:SetTotal( ( ::oDbf )->( Lastrec() ) )
                     nEvery      := Int( ::oMtrReplace:nTotal / 10 )
                  end if

                  if Empty( ::cOrdAnterior )
                     ::cOrdAnterior := ( ::oDbf )->( OrdSetFocus() )
                  end if

                  if Empty( ::cBagAnterior )
                     ::cBagAnterior := ( ::oDbf )->( dbOrderInfo( DBOI_FULLPATH ) )
                  end if

                  if Empty( ::nRecAnterior )
                     ::nRecAnterior := ( ::oDbf )->( Recno() )
                  end if

                  if Empty( ::cNamAnterior )
                     ::cNamAnterior := "OrdTmp" + cCurUsr()
                  end if

                  if !Empty( ::oMtrReplace )
                     ( ::oDbf )->( OrdCondSet( ::cExpFilter + " .and. !Deleted()", c2Block( ::cExpFilter + " .and. !Deleted()" ),,, {|| ::oMtrReplace:Set( ( ::oDbf )->( RecNo() ) ), SysRefresh() }, nEvery ) )
                  else
                     ( ::oDbf )->( OrdCondSet( ::cExpFilter + " .and. !Deleted()", c2Block( ::cExpFilter + " .and. !Deleted()" ),,, {|| SysRefresh() } ) )
                  end if

                  ( ::oDbf )->( OrdCreate( ::cBagAnterior, ::cNamAnterior, cOrdKey, bOrdKey ) )
                  ( ::oDbf )->( OrdSetFocus( ::cNamAnterior, ::cBagAnterior ) )
                  ( ::oDbf )->( dbGoTop() )

                  if !Empty( ::oWndBrw )
                     ::oWndBrw:ShowButtonFilter()
                     ::oWndBrw:ShowEditButtonFilter()
                     ::oWndBrw:Refresh()
                  end if

               else

                  MsgStop( "No existe indice para la busqueda" )

               end if

            end if

      end case

      if !Empty( ::oMtrReplace )
         ::oMtrReplace:SetTotal( 0 )
      end if

   end if

   RECOVER USING oError

      msgStop( "Imposible establecer filtros " + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

Return ( Self )

//---------------------------------------------------------------------------//

METHOD KillFilter( oDlg )

   if !Empty( ::bOnKillFilter )
      Eval( ::bOnKillFilter )
   end if

   do case
      case IsObject( ::oDbf )

         if lAdsRdd()

            ( ::oDbf:cAlias )->( dbClearFilter() )

         else

            if !Empty( ::cBagAnterior )
               ( ::oDbf:cAlias )->( OrdSetFocus( ::cOrdAnterior, ::cBagAnterior ) )
               ( ::oDbf:cAlias )->( OrdDestroy( ::cNamAnterior, ::cBagAnterior ) )
            end if

         end if

      case IsChar( ::oDbf )

         if lAdsRdd()

            ( ::oDbf )->( dbClearFilter() )

         else

            if !Empty( ::cBagAnterior )
               ( ::oDbf )->( OrdSetFocus( ::cOrdAnterior, ::cBagAnterior ) )
               ( ::oDbf )->( OrdDestroy( ::cNamAnterior, ::cBagAnterior ) )
            end if

         end if

   end case

   ::cOrdAnterior := nil
   ::nRecAnterior := nil
   ::cBagAnterior := nil
   ::cNamAnterior := nil

   ::cTxtFilter   := nil
   ::cExpFilter   := nil
   ::bExpFilter   := nil
   ::aExpFilter   := nil

   do case
      case IsObject( ::oDbf )

         if !Empty( ::nRecAnterior )
            ( ::oDbf:cAlias )->( dbGoTo( ::nRecAnterior ) )
         else
            ( ::oDbf:cAlias )->( dbGoTop() )
         end if

      case IsChar( ::oDbf )

         if !Empty( ::nRecAnterior )
            ( ::oDbf )->( dbGoTo( ::nRecAnterior ) )
         else
            ( ::oDbf )->( dbGoTop() )
         end if

   end case

   if !Empty( ::oWndBrw )
      ::oWndBrw:HideButtonFilter()
      ::oWndBrw:HideEditButtonFilter()
      ::oWndBrw:Refresh()
   end if

   if !Empty( oDlg )
      oDlg:End()
   end if

RETURN ( Self )

//--------------------------------------------------------------------------//

METHOD SaveFilter()

   local aFilter
   local n        := 1
   local c        := ""
   local lExiste  := .t.

   if !::ExpresionBuilder() // !::ExpMaker() .or. 
      Return ( .f. )
   end if

   // Tomamos un nombre para el filtro-----------------------------------------

   if ::lGetFilterName()

      if !Empty( ::oDlg )
         ::oDlg:Disable()
      end if 

      // Si el nuevo es un filtro por defecto quitamos todos-------------------

      if ::lDefaultFilter

         if ( ::cDbfFilter )->( dbSeek( ::cTipFilter ) )

            while ( ( ::cDbfFilter)->cTipDoc == ::cTipFilter .and. !( ::cDbfFilter )->( eof() ) )

               if ( ::cDbfFilter )->( dbRLock() )
                  ( ::cDbfFilter )->lDefFlt  := .f.
                  ( ::cDbfFilter )->( dbUnLock() )
               end if

               ( ::cDbfFilter )->( dbSkip() )

            end while

         end if

      end if

      // Anotamos el filtro----------------------------------------------------

      lExiste     := ( ::cDbfFilter)->( dbSeek( ::cTipFilter + Upper( ::cTexFilter ) ) )

      if dbDialogLock( ::cDbfFilter, !lExiste )

         ( ::cDbfFilter )->cCodUsr     := if( !::lAllUser, cCurUsr(), Space( 3 ) )
         ( ::cDbfFilter )->cTipDoc     := ::cTipFilter
         ( ::cDbfFilter )->cTexFlt     := ::cTexFilter
         ( ::cDbfFilter )->cExpFlt     := ::cExpFilter
         ( ::cDbfFilter )->lDefFlt     := ::lDefaultFilter
         ( ::cDbfFilter )->cFldFlt     := ::cSerializeFilter()

         ( ::cDbfFilter )->( dbUnLock() )

      end if

      ::Load()

      if !Empty( ::oWndBrw )
         ::oWndBrw:EnableComboFilter( ::aFilter )
         ::oWndBrw:SetComboFilter( ::cTexFilter )
      end if

      if !Empty( ::oDlg )
         ::oDlg:Enable()
      end if 

   end if

Return ( .t. )

//---------------------------------------------------------------------------//

METHOD DeleteFilter( oDlg )

   local cTipFilter  := ( ::cDbfFilter )->cTipDoc
   local cTxtFilter  := Alltrim( ( ::cDbfFilter)->cTexFlt )

   if oUser():lNotConfirmDelete() .or. ApoloMsgNoYes( "¿ Desea eliminar el filtro : " + Rtrim( cTxtFilter ) + " ?", "Confirme supresión" )

      if ( ::cDbfFilter)->( dbSeek( cTipFilter + Upper( cTxtFilter ) ) )

         delRecno( ::cDbfFilter )

         if !Empty( ::oWndBrw )
            ::oWndBrw:EnableComboFilter( ::aFilter )
            ::KillFilter()
         end if

         if !Empty( oDlg )
            oDlg:End()
         end if 

         if !Empty( ::oBrwAlmacenados )
            ::oBrwAlmacenados:Refresh()
         end if 

      end if

   end if

Return ( .t. )

//---------------------------------------------------------------------------//

Method lGetFilterName()

   local oDlg

   ::cTexFilter   := Padr( ::cTexFilter, 100 )

   DEFINE DIALOG oDlg RESOURCE "Nombre_Filtro"

   REDEFINE GET ::cTexFilter ;
      ID          100 ;
      OF          oDlg

   REDEFINE CHECKBOX ::lDefaultFilter ;
      ID          110 ;
      OF          oDlg

   REDEFINE CHECKBOX ::lAllUser ;
      WHEN        ( oUser():lAdministrador() );
      ID          120 ;
      OF          oDlg

   REDEFINE BUTTON ;
      ID          IDOK ;
      OF          oDlg ;
      ACTION      ( if( ::lValidFilterName(), oDlg:end( IDOK ), ) )

   REDEFINE BUTTON ;
      ID          IDCANCEL ;
      OF          oDlg ;
      ACTION      ( oDlg:end() )

   oDlg:AddFastKey( VK_F5, {|| oDlg:end( IDOK ) } )

   ACTIVATE DIALOG oDlg CENTER

Return ( oDlg:nResult == IDOK )

//---------------------------------------------------------------------------//

Method lValidFilterName()

   if Empty( ::cTexFilter )
      MsgStop( "El nombre del filtro no puede estar vacio" )
      Return ( .f. )
   end if

Return ( .t. )

//---------------------------------------------------------------------------//

Method LoadFilter( cTipFilter, cTxtFilter )

   if !Empty( cTipFilter ) .and. !Empty( cTxtFilter )

      if ( ::cDbfFilter )->( dbSeek( cTipFilter + Rtrim( Upper( cTxtFilter ) ) ) )
         
         ::cDeSerializeFilter( ( ::cDbfFilter )->cFldFlt )

      else
         
         MsgStop( "Código de filtro " + cTipFilter + " - " + Rtrim( Upper( cTxtFilter ) ) + " no encontrado" )
         Return .f.

      end if 
   
   else 
      
      ::cDeSerializeFilter( ( ::cDbfFilter )->cFldFlt )
   
   end if

   if !Empty( ::oBrwFilter )
      ::oBrwFilter:SetArray( ::aFilter )
   end if 

   if !Empty( ::oDlg ) .and. !Empty( ::oDlg:oTop )
      ::oDlg:oTop:SetOption( 1 )
   end if

   if !Empty( ::oFld )
      ::oFld:SetOption( 1 )
   end if 

Return ( .t. )

//---------------------------------------------------------------------------//

Method lBuildFilter()

   local lBuild      := .f.

   if Empty( ::cExpFilter )
      Return ( lBuild )
   end if

   ::SelectTable( ::oDbf )

   if At( Type( ::cExpFilter ), "UEUI" ) != 0

      msgStop( "Expresión " + Rtrim( ::cExpFilter ) + " no valida" )

      ::cExpFilter   := ""
      ::bExpFilter   := nil
      ::cTxtFilter   := ""
   
   else
   
      ::bExpFilter   := Compile( ::cExpFilter )
   
      lBuild         := .t.
   
   end if

Return ( lBuild )

//---------------------------------------------------------------------------//

Function lLoadFiltro( cTipoDocumento, aItems, oButton, oWndBrw, dbfFlt, dbf )

   local cFilter
   local bFilter

   if ( dbfFlt )->( dbSeek( cTipoDocumento ) )

      while ( dbfFlt )->cTipDoc == cTipoDocumento .and. !( dbfFlt )->( eof() )

         bFilter     := bFiltro( aItems, dbfFlt, dbf, oButton, oWndBrw )

         oWndBrw:NewAt( "bFilter", , , bFilter, Rtrim( by( ( dbfFlt )->cTexFlt ) ), , , , , oButton )

         if Empty( cFilter )
            cFilter  := Rtrim( by( ( dbfFlt )->cExpFlt ) )
         end if

         ( dbfFlt )->( dbSkip() )

      end do

   end if

return nil

//---------------------------------------------------------------------------//

METHOD SetFilter( cText )

   local nFilter        := 0

   if !Empty( cText )

      nFilter           := aScan( ::aFilter, {|a| a[ 1 ] == cText } )
      if nFilter != 0

         ::cTexFilter   := ::aFilter[ nFilter, 1 ]
         ::cExpFilter   := ::aFilter[ nFilter, 2 ]

         ::lBuildAplyFilter()

      else

         ::KillFilter()

      end if

   end if

return nil

//---------------------------------------------------------------------------//

Static Function bFiltro( aItems, dbfFlt, dbf, oButton, oWndBrw )

   local cTip     := by( ( dbfFlt )->cTipDoc )
   local cTxt     := by( ( dbfFlt )->cTexFlt )
   local bGen     := {|| TDlgFlt():New( aItems, dbf, oButton, .t., oWndBrw ):Resource( cTip, cTxt, dbfFlt ) }

Return ( bGen )

//---------------------------------------------------------------------------//

FUNCTION mkFilter( cPath, oMeter )

   DEFAULT cPath     := cPatDat()

   if oMeter != NIL
      oMeter:cText   := "Generando Bases"
      sysrefresh()
   end if

   dbCreate( cPath + "CnfFlt.Dbf", aSqlStruct( aItmFilter() ), cDriver() )

   rxFilter( cPath, oMeter )

RETURN .t.

//--------------------------------------------------------------------------//

FUNCTION rxFilter( cPath, oMeter )

   local dbfFilter

   DEFAULT cPath     := cPatDat()

   if !lExistTable( cPath + "CnfFlt.Dbf" )
      dbCreate( cPath + "CnfFlt.Dbf", aSqlStruct( aItmFilter() ), cDriver() )
   end if

   fEraseIndex( cPath + "CnfFlt.Cdx" )

   dbUseArea( .t., cDriver(), cPath + "CnfFlt.Dbf", cCheckArea( "CnfFlt", @dbfFilter ), .f. )

   if !( dbfFilter )->( neterr() )

      ( dbfFilter )->( __dbPack() )

      ( dbfFilter )->( ordCondSet( "!Deleted()", {||!Deleted()}  ) )
      ( dbfFilter )->( ordCreate( cPath + "CnfFlt.Cdx", "cTipDoc", "cTipDoc + Upper( cTexFlt )", {|| Field->cTipDoc + Upper( Field->cTexFlt ) } ) )

      ( dbfFilter )->( dbCloseArea() )

   else

      msgStop( "Imposible abrir en modo exclusivo la tabla de filtros" )

   end if

RETURN NIL

//--------------------------------------------------------------------------//

FUNCTION aItmFilter()

   local aBase := {}

   aAdd( aBase, { "cTipDoc",  "C",  2, 0, "Tipo de documento" }            )
   aAdd( aBase, { "cCodUsr",  "C",  3, 0, "Usuario" }                      )
   aAdd( aBase, { "cTexFlt",  "C",100, 0, "Descripción" }                  )
   aAdd( aBase, { "cFldFlt",  "M", 10, 0, "Texto largo de la nota" }       )
   aAdd( aBase, { "cExpFlt",  "M", 10, 0, "Expresión del filtro" }         )
   aAdd( aBase, { "lDefFlt",  "L",  1, 0, "Lógico de filtro por defecto" } )

RETURN ( aBase )

//----------------------------------------------------------------------------//

