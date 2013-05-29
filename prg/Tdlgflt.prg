#include "FiveWin.Ch"
#include "Factu.ch"
#include "Font.ch"
#include "Report.ch"
#include "MesDbf.ch"
#include "DbInfo.ch"

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

   DATA cTipFilter
   DATA cTexFilter            INIT ""
   DATA cDbfFilter

   DATA oWndBrw

   DATA aFilter               INIT {}


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
   Method StarResource( oBtnSave, oBtnDelete, oDlg )

   METHOD Load()
   METHOD LoadFilter()

   METHOD ChgFields()

   METHOD ExpMaker()

   METHOD aExpMaker()

   METHOD ExeReplace()

   METHOD ChgGet( cType, nLen, nDec )

   METHOD lGetFilterName()

   METHOD lValidFilterName( oDlg )

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

   /*
   ::aTField            := aSort( ::aTField, , , { |x, y| x[ 5 ] < y[ 5 ] } )

   for n := 1 TO Len( ::aTField )
      if !Empty( ::aTField[ n, 5 ] )
         aAdd( ::aTblField,      ::aTField[ n, 1 ] )
         aAdd( ::aTblType,       ::aTField[ n, 2 ] )
         aAdd( ::aTblLen,        ::aTField[ n, 3 ] )
         aAdd( ::aTblDecimals,   ::aTField[ n, 4 ] )
         aAdd( ::aTblMask,       ::aTField[ n, 5 ] )
      end if
   next

   for n := 1 to len( ::aFldFilter )
      if Empty( ::aFldFilter[n] )
         ::aFldFilter[n]   := ::aTblMask[1]
      end if
   next
   */

RETURN Self

//---------------------------------------------------------------------------//

METHOD Create( oDbf, oWebBtn, lAplyFilter, oWndBrw ) CLASS TDlgFlt

   local n

   DEFAULT lAplyFilter  := .t.

   ::aTField            := aClone( oDbf:aTField )
   ::oDbf               := oDbf
   ::oWebBtn            := oWebBtn
   ::lAplyFilter        := lAplyFilter
   ::oWndBrw            := oWndBrw

   ::lAllRecno          := .f.

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

METHOD Init( oWndBrw ) CLASS TDlgFlt

   ::oWndBrw            := oWndBrw
   ::oDbf               := oWndBrw:xAlias

   ::lAplyFilter        := .t.

RETURN Self

//---------------------------------------------------------------------------//

Method Default()

   local oFld

   ::aFldFilter         := Afill( Array( 5 ), "" )
   ::aConFilter         := Afill( Array( 5 ), "Contenga" )
   ::aValFilter         := Afill( Array( 5 ), Space( 100 ) )
   ::aNexFilter         := Afill( Array( 4 ), "" )

   ::oFldFilter         := Array( 5 )
   ::oConFilter         := Array( 5 )
   ::oValFilter         := Array( 5 )
   ::oNexFilter         := Array( 4 )

   ::lAllRecno          := .f.

   ::aTblMask           := {}          // Muestra las mascaras
   ::aTblField          := {}          // Muestra las campos
   ::aTblType           := {}          // Tipos de campo
   ::aTblLen            := {}          // Len del campo
   ::aTblDecimals       := {}          // Decimales del campo

   ::nMtrReplace        := 0

   ::cExpReplace        := Space( 100 )

   ::aTblNexo           := {  "", "Y", "O" }
   ::aTblCondition      := {  "Igual",;
                              "Distinto",;
                              "Mayor",;
                              "Menor",;
                              "Mayor igual",;
                              "Menor igual",;
                              "Contenga",;
                              "Dia semana igual",;
                              "Mes igual",;
                              "Año igual" }

   ::aTField            := aSort( ::aTField, , , { |x, y| x[ 5 ] < y[ 5 ] } )

   for each oFld in ::aTField

      do case
         case IsObject( oFld )

            if !Empty( oFld:cComment ) .and. !oFld:lCalculate
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

   do case
      case IsObject( uDbfFilter )
         ::cDbfFilter   := uDbfFilter:nArea
      case IsChar(  uDbfFilter )
         ::cDbfFilter   := uDbfFilter
   end case

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

Method CreateFilter( oDlg )

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

   oDlg:end( IDOK )

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

METHOD SaveFilter( oDlg )

   local n        := 1
   local c        := ""
   local lExiste  := .t.

   if !::ExpMaker()
      Return ( .f. )
   end if

   if ::lGetFilterName()

      oDlg:Disable()

      while n <= len( ::aValFilter )

         c        += ::aFldFilter[ n ] + ","
         c        += ::aConFilter[ n ] + ","
         c        += Alltrim( ::aValFilter[ n ] ) + ","

         if ::oNexFilter[ n ]:nAt != 1
            c     += ::aNexFilter[ n ] + ","
         else
            exit
         end if

         n++

      end do

      // Si el nuevo es un filtro por defecto quitamos todos-------------------

      if ::lDefaultFilter

         if ( ::cDbfFilter)->( dbSeek( ::cTipFilter ) )

            while ( ( ::cDbfFilter)->cTipDoc == ::cTipFilter .and. !( ::cDbfFilter)->( eof() ) )

               if ( ::cDbfFilter )->( dbRLock() )
                  ( ::cDbfFilter )->lDefFlt  := .f.
                  ( ::cDbfFilter )->( dbUnLock() )
               end if

               ( ::cDbfFilter)->( dbSkip() )

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
         ( ::cDbfFilter )->cFldFlt     := c

         ( ::cDbfFilter )->( dbUnLock() )

      end if

      ::Load()

      if !Empty( ::oWndBrw )
         ::oWndBrw:EnableComboFilter( ::aFilter )
         ::oWndBrw:SetComboFilter( ::cTexFilter )
      end if

      oDlg:Enable()

   end if

Return ( .t. )

//---------------------------------------------------------------------------//

METHOD DeleteFilter( oDlg )

   if oUser():lNotConfirmDelete() .or. ApoloMsgNoYes( "¿ Desea eliminar el filtro : " + Rtrim( ::cTexFilter ) + " ?", "Confirme supresión" )

      if ( ::cDbfFilter)->( dbSeek( ::cTipFilter + Upper( ::cTexFilter ) ) )

         delRecno( ::cDbfFilter )

         ::Load()

         if !Empty( ::oWndBrw )
            ::oWndBrw:EnableComboFilter( ::aFilter )
         end if

         ::KillFilter()

         oDlg:End()

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

Method LoadFilter()

   local mFldFlt
   local cFldFlt
   local nPosLin  := 1
   local nPosFld  := 1
   local nPosSer  := 0

   if Empty( ::cTipFilter ) .or. Empty( ::cTexFilter )
      Return ( Self )
   end if

   if ( ::cDbfFilter )->( dbSeek( ::cTipFilter + Rtrim( Upper( ::cTexFilter ) ) ) )

      mFldFlt     := Rtrim( ( ::cDbfFilter )->cFldFlt )

      while ( nPosSer := At( ",", mFldFlt ) ) > 0

         if nPosSer != 0

            cFldFlt  := SubStr( mFldFlt, 1, nPosSer - 1 )
            cFldFlt  := Rtrim( cFldFlt )

            do case
               case nPosFld == 1
                  ::oFldFilter[ nPosLin ]:Set( cFldFlt )

               case nPosFld == 2
                  ::oConFilter[ nPosLin ]:Set( cFldFlt )

               case nPosFld == 3
                  ::oValFilter[ nPosLin ]:cText( Padr( SubStr( mFldFlt, 1, nPosSer - 1 ), 100 ) )

               case nPosFld == 4
                  ::oNexFilter[ nPosLin ]:Set( SubStr( mFldFlt, 1, nPosSer - 1 ) )

                  ++nPosLin
                  nPosFld  := 0

            end case

            ++nPosFld

            mFldFlt  := SubStr( mFldFlt, nPosSer + 1 )

         end if

      end while

   else

      MsgStop( "Código de filtro " + ::cTipFilter + " - " + Rtrim( Upper( ::cTexFilter ) ) + " no encontrado" )

   end if

Return ( Self )

//---------------------------------------------------------------------------//

Method lBuildFilter()

   local lBuild      := .f.

   if Empty( ::cExpFilter )
      Return ( lBuild )
   end if

   do case
      case IsObject( ::oDbf )
         ::oDbf:SetFocus()
      case IsChar( ::oDbf )
         Select( ::oDbf )
   end case

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

Method Load()

   local cText := ""

   if Empty( ::cDbfFilter )
      Return ( Self )
   end if

   CursorWait()

   ::aFilter   := {}

   if ( ::cDbfFilter )->( dbSeek( ::cTipFilter ) )

      while ( ( ::cDbfFilter )->cTipDoc == ::cTipFilter ) .and. !( ::cDbfFilter )->( eof() )

         if Empty( ( ::cDbfFilter )->cCodUsr ) .or. ( ( ::cDbfFilter )->cCodUsr == cCurUsr() )

            if ( ::cDbfFilter )->lDefFlt
               ::cTexFilter   := ( ::cDbfFilter )->cTexFlt
               ::cExpFilter   := ( ::cDbfFilter )->cExpFlt
            end if

            aAdd( ::aFilter, { Rtrim( ( ::cDbfFilter )->cTexFlt ) , Rtrim( ( ::cDbfFilter )->cExpFlt ), ( ::cDbfFilter )->lDefFlt } )

         end if

         ( ::cDbfFilter )->( dbSkip() )

      end do

   end if

   CursorWE()

Return ( Self )

//---------------------------------------------------------------------------//
/*
Static Function bLoad( cTxt, oWndBrw )

   local cTxt     := Rtrim( by( ( dbfFlt )->cTexFlt ) )
   local bGen     := {|| oWndBrw:oActiveFilter:Reource( , cTxt ) }

Return ( bGen )
*/
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