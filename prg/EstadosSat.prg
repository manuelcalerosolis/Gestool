#include "FiveWin.Ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS EstadosSat FROM SQLBaseView

   DATA     aStrTipo                      INIT {   "Círculo azul"       ,;
                                                   "Círculo verde"      ,;
                                                   "Círculo rojo"       ,;
                                                   "Círculo amarillo"   ,;
                                                   "Cuadrado azul"      ,;
                                                   "Cuadrado verde"     ,;
                                                   "Cuadrado rojo"      ,;
                                                   "Cuadrado amarillo"  ,;
                                                   "Triángulo azul"     ,;
                                                   "Triángulo verde"    ,;
                                                   "Triángulo rojo"     ,;
                                                   "Triángulo amarillo" }

   DATA     aResTipo                      INIT {   "BULLET_BALL_GLASS_BLUE_16"   ,;
                                                   "BULLET_BALL_GLASS_GREEN_16"  ,;
                                                   "BULLET_BALL_GLASS_RED_16"    ,;
                                                   "BULLET_BALL_GLASS_YELLOW_16" ,;
                                                   "BULLET_SQUARE_BLUE_16"       ,;
                                                   "gc_check_12"                 ,;
                                                   "gc_delete_12"                ,;
                                                   "gc_shape_square_12"          ,;
                                                   "BULLET_TRIANGLE_BLUE_16"     ,;
                                                   "BULLET_TRIANGLE_GREEN_16"    ,;
                                                   "BULLET_TRIANGLE_RED_16"      ,;
                                                   "BULLET_TRIANGLE_YELLOW_16"   }

   METHOD   New()

   METHOD   buildSQLShell()
  
   //METHOD   buildSQLBrowse( oGet )

   METHOD   buildSQLModel()               INLINE ( EstadosSatModel():New() )

   METHOD   getFieldFromBrowse()          INLINE ( ::oModel:getRowSet():fieldGet( "nombre" ) )
 
   METHOD   Dialog()

END CLASS

//---------------------------------------------------------------------------//

METHOD New()

   ::idUserMap             := "01101"

   ::cHistoryName          := "Estados_SAT"

   ::aStrTipo              := {     "Círculo azul"       ,;
                                    "Círculo verde"      ,;
                                    "Círculo rojo"       ,;
                                    "Círculo amarillo"   ,;
                                    "Cuadrado azul"      ,;
                                    "Cuadrado verde"     ,;
                                    "Cuadrado rojo"      ,;
                                    "Cuadrado amarillo"  ,;
                                    "Triángulo azul"     ,;
                                    "Triángulo verde"    ,;
                                    "Triángulo rojo"     ,;
                                    "Triángulo amarillo" }

   ::aResTipo              := {     "BULLET_BALL_GLASS_BLUE_16"   ,;
                                    "BULLET_BALL_GLASS_GREEN_16"  ,;
                                    "BULLET_BALL_GLASS_RED_16"    ,;
                                    "BULLET_BALL_GLASS_YELLOW_16" ,;
                                    "BULLET_SQUARE_BLUE_16"       ,;
                                    "gc_check_12"                 ,;
                                    "gc_delete_12"                ,;
                                    "gc_shape_square_12"          ,;
                                    "BULLET_TRIANGLE_BLUE_16"     ,;
                                    "BULLET_TRIANGLE_GREEN_16"    ,;
                                    "BULLET_TRIANGLE_RED_16"      ,;
                                    "BULLET_TRIANGLE_YELLOW_16"   }

   ::Super:New()

Return ( Self )

//---------------------------------------------------------------------------//

METHOD buildSQLShell()

   disableAcceso()

   ::oShell                := SQLTShell():New( 2, 10, 18, 70, "Estado de los documentos", , oWnd(), , , .f., , , ::oModel, , , , , {}, {|| ::Edit() },, {|| ::Delete() },, nil, ::nLevel, "gc_bookmarks_16", ( 104 + ( 0 * 256 ) + ( 63 * 65536 ) ),,, .t. )

      with object ( ::oShell:AddCol() )
         :cHeader          := "Id"
         :cSortOrder       := "id"
         :bEditValue       := {|| ::oModel:getRowSet():fieldGet( "id" ) }
         :nWidth           := 40
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | ::clickOnHeader( oCol, ::oShell:getBrowse(), ::oShell:getCombobox() ) }
      end with

      with object ( ::oShell:AddCol() )
         :cHeader          := "Código"
         :cSortOrder       := "cod_estado"
         :bEditValue       := {|| ::oModel:getRowSet():fieldGet( "cod_estado" ) }
         :nWidth           := 40
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | ::clickOnHeader( oCol, ::oShell:getBrowse(), ::oShell:getCombobox() ) }
      end with

      with object ( ::oShell:AddCol() )
         :cHeader          := "Nombre"
         :cSortOrder       := "nombre"
         :bEditValue       := {|| ::oModel:getRowSet():fieldGet( "nombre" ) }
         :nWidth           := 260
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | ::clickOnHeader( oCol, ::oShell:getBrowse(), ::oShell:getCombobox() ) }
      end with

      ::oShell:createXFromCode()

      ::oShell:setDClickData( {|| ::Edit( ::oShell:getBrowse() ) } )

      ::AutoButtons()

   ACTIVATE WINDOW ::oShell

   ::oShell:bValid   := {|| ::saveHistory( ::getHistoryNameShell() , ::oShell:getBrowse() ), .t. }
   ::oShell:bEnd     := {|| ::destroySQLModel() }

   ::oShell:setComboBoxChange( {|| ::changeCombo( ::oShell:getBrowse(), ::oShell:getCombobox() ) } )

   ::setCombo( ::oShell:getBrowse(), ::oShell:getCombobox() )

   enableAcceso()

Return ( Self )

//----------------------------------------------------------------------------//

METHOD Dialog( lZoom )

   local oDlg
   local oGetNombre

   DEFINE DIALOG oDlg RESOURCE "ESTADOSAT" TITLE lblTitle( ::getMode() ) + "estado del documento"

   REDEFINE GET   oGetNombre ;
      VAR         ::oModel:hBuffer[ "cod_estado" ] ;
      ID          100 ;
      WHEN        ( ::isAppendMode() .or. ::isDuplicateMode() ) ;
      PICTURE     "@!" ;
      OF          oDlg

   REDEFINE GET   oGetNombre ;
      VAR         ::oModel:hBuffer[ "nombre" ] ;
      MEMO ;
      ID          110 ;
      WHEN        ( ! ::isZoomMode() ) ;
      OF          oDlg

   REDEFINE COMBOBOX   oGetNombre ;
      VAR         ::oModel:hBuffer[ "tipo" ] ;
      ID          120 ;
      WHEN        ( ! ::isZoomMode() ) ;
      ITEMS       ::aStrTipo ;
      BITMAPS     ::aResTipo ;
      OF          oDlg

   REDEFINE RADIO ::oModel:hBuffer[ "disponible" ] ;
         ID       130, 140 ;
         WHEN     ( ! ::isZoomMode() ) ;
         OF       oDlg

   REDEFINE BUTTON ;
      ID          500 ;
      OF          oDlg ;
      WHEN        ( ! ::isZoomMode() ) ;
      ACTION      ( oDlg:end( IDOK ) )

   REDEFINE BUTTON ;
      ID          510 ;
      OF          oDlg ;
      CANCEL ;
      ACTION      ( oDlg:end() )

   // Teclas rpidas-----------------------------------------------------------

   oDlg:AddFastKey( VK_F5, {|| oDlg:end( IDOK ) } )

   ACTIVATE DIALOG oDlg CENTER

RETURN ( oDlg:nResult == IDOK )

//----------------------------------------------------------------------------//