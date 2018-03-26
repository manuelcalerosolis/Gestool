#include "FiveWin.Ch"
#include "Factu.ch" 
#include "MesDbf.ch"
#include "Xbrowse.ch"

#define DT_TOP                      0x00000000
#define DT_WORDBREAK                0x00000010
#define DT_CENTER                   0x00000001

//----------------------------------------------------------------------------//

CLASS TpvMenu FROM TMasDet

   CLASSDATA oInstance

   DATA  cMru                                   INIT "gc_clipboard_empty_16"

   DATA  oGetCodigo
   DATA  oGetNombre

   DATA oOrdenComandas  

   DATA oDbfArticulo

   DATA oDetMenuArticulo
   DATA oMenuOrdenes

   DATA oDlgAcompannamiento

   DATA oBrwOrdenesComanda
   DATA oBrwAcompannamiento

   DATA oLstArticulos

   DATA oSender

   DATA aIngredientes

   METHOD New( cPath, oWndParent, oMenuItem )   CONSTRUCTOR
   METHOD Create( cPath )                       CONSTRUCTOR

   METHOD DefineFiles()

   METHOD OpenFiles( lExclusive, cPath )  

   METHOD CloseFiles( lExclusive, cPath ) 

   METHOD OpenService( lExclusive, cPath )
   METHOD CloseService( lExclusive,cPath )  

   METHOD Resource( nMode )
   METHOD   StartResource()                     VIRTUAL
   METHOD   lSaveResource()

   METHOD lIsMenuActive()
   METHOD nMenuActive()
   METHOD cMenuActive()

   METHOD cNombre( cCodMnu )
   METHOD nPrecio( cCodMnu )

   // Menu Acompañamiento-----------------------------------------------------//
   
   METHOD InitAcompannamientoMultiple()
   METHOD InitAcompannamientoSimple( cCodigoMenu, cCodigoOrden )
   METHOD CargaDatosAcompannamiento()
   METHOD ProcesaDatosAcompannamiento()

   METHOD SumaUnidadesAcompannamiento()   INLINE ( ::aIngredientes[ ::oBrwAcompannamiento:nArrayAt, "Unidades" ]++,;
                                                   ::oBrwAcompannamiento:Refresh() )

   METHOD RestaUnidadesAcompannamiento()  INLINE ( if (  ::aIngredientes[ ::oBrwAcompannamiento:nArrayAt, "Unidades" ] > 0,;
                                                         ::aIngredientes[ ::oBrwAcompannamiento:nArrayAt, "Unidades" ]--,;
                                                         ),;
                                                   ::oBrwAcompannamiento:Refresh() )

   METHOD nUnidadesAcompannamiento()

   METHOD Acompannamiento( cCodigoMenu )


   METHOD AgregarAcompannamientoSimple( cCodigoArticulo, cCodigoMenu, cCodigoOrden )
   METHOD StartDialogAcompannamiento()
   METHOD CreateItemAcompannamiento()
   METHOD ActionAcompannamientoSimple()

END CLASS

//----------------------------------------------------------------------------//

METHOD New( cPath, oWndParent, nLevel )

   DEFAULT oWndParent   := GetWndFrame()
   DEFAULT nLevel       := "menus"

   ::Create( cPath )

   if Empty( ::nLevel )
      ::nLevel          := Auth():Level( nLevel )
   end if

   /*
   Cerramos todas las ventanas-------------------------------------------------
   */

   if oWndParent != nil
      oWndParent:CloseAll()
   end if

   ::cPath              := cPath
   ::oWndParent         := oWndParent

   ::lAutoButtons       := .t.
   ::lCreateShell       := .f.

   ::oOrdenComandas     := TOrdenComanda():Create()

   ::oMenuOrdenes       := TpvMenuOrdenes():New( cPath, cDriver(), Self )
   ::AddDetail( ::oMenuOrdenes )

   ::oDetMenuArticulo   := TpvMenuArticulo():New( cPath, cDriver(), Self )
   ::AddDetail( ::oDetMenuArticulo )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD Create( cPath, oSender )

   DEFAULT cPath        := cPatEmp()

   ::cPath              := cPath
   ::oSender            := oSender

   ::oDbf               := nil

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD DefineFiles( cPath, cDriver )

   local oDbf 

   DEFAULT cPath        := ::cPath
   DEFAULT cDriver      := cDriver()

   DEFINE DATABASE oDbf FILE "TpvMenus.Dbf" CLASS "TpvMenus" ALIAS "TpvMenus" PATH ( cPath ) VIA ( cDriver ) COMMENT "Menús TPV" 

      FIELD NAME "cCodMnu"  TYPE "C" LEN 03  DEC 0  COMMENT "Código"                                                    COLSIZE 80                 OF oDbf
      FIELD NAME "cNomMnu"  TYPE "C" LEN 40  DEC 0  COMMENT "Nombre"                                                    COLSIZE 200                OF oDbf
      FIELD NAME "nImpMnu"  TYPE "N" LEN 16  DEC 6  COMMENT "Precio"                ALIGN RIGHT   PICTURE cPorDiv()     COLSIZE 80                 OF oDbf
      FIELD NAME "lObsMnu"  TYPE "L" LEN 01  DEC 0  COMMENT "Obsoleto"                                                  HIDE                       OF oDbf
      FIELD NAME "lAcomp"   TYPE "L" LEN 01  DEC 0  COMMENT "Menú acompañamiento"                                       HIDE                       OF oDbf

      INDEX TO "TpvMenus.Cdx" TAG "cCodMnu" ON "cCodMnu"   COMMENT "Código"         NODELETED                                                      OF oDbf
      INDEX TO "TpvMenus.Cdx" TAG "cNomMnu" ON "cNomMnu"   COMMENT "Nombre"         NODELETED                                                      OF oDbf
      INDEX TO "TpvMenus.Cdx" TAG "lObsMnu" ON "cCodMnu"   COMMENT ""               FOR "!Deleted() .and. !Field->lObsMnu"                         OF oDbf
      INDEX TO "TpvMenus.Cdx" TAG "lAcomp"  ON "cCodMnu"   COMMENT ""               FOR "!Deleted() .and. !Field->lAcomp"                          OF oDbf
      INDEX TO "TpvMenus.Cdx" TAG "lShwMnu" ON "cCodMnu"   COMMENT ""               FOR "!Deleted() .and. !Field->lAcomp .and. !Field->lObsMnu"    OF oDbf

   END DATABASE oDbf

RETURN ( oDbf )

//----------------------------------------------------------------------------//

METHOD OpenFiles( lExclusive, cPath )

   local oError
   local oBlock         

   DEFAULT lExclusive   := .f.

   ::lOpenFiles         := .t.

   oBlock               := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      if Empty( ::oDbf )
         ::oDbf         := ::DefineFiles( cPath )
      end if

      ::oDbf:Activate( .f., !( lExclusive ) )

      DATABASE NEW ::oDbfArticulo PATH ( cPatEmp() ) FILE "ARTICULO.DBF" VIA ( cDriver() ) SHARED INDEX "ARTICULO.CDX"

      ::oOrdenComandas:OpenFiles()

      ::OpenDetails()

      ::bFirstKey          := {|| ::oDbf:cCodMnu }  

   RECOVER USING oError

      msgStop( ErrorMessage( oError ), "Imposible abrir las bases de datos de TPV Menús." )

      ::CloseFiles()
      
      ::lOpenFiles      := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( ::lOpenFiles )

//----------------------------------------------------------------------------//

METHOD CloseFiles() 

   if !Empty( ::oDbf ) .and. ::oDbf:Used()
      ::oDbf:End()
   end if

   if !empty( ::oOrdenComandas )
      ::oOrdenComandas:CloseFiles()
   end if 

   if !Empty( ::oDbfArticulo ) .and. ( ::oDbfArticulo:used() )
      ::oDbfArticulo:End()
   end if 

   ::CloseDetails()     

   ::oDbf      := nil

RETURN .t.

//----------------------------------------------------------------------------//

METHOD OpenService( lExclusive, cPath )

   local lOpen             := .t.
   local oError
   local oBlock         

   DEFAULT lExclusive      := .f.

   oBlock                  := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      if Empty( ::oDbf )
         ::oDbf            := ::DefineFiles()
      end if

      ::oDbf:Activate( .f., !( lExclusive ) )

      ::oMenuOrdenes       := TpvMenuOrdenes():New( cPath, Self )
      if !::oMenuOrdenes:OpenService()
         lOpen             := .f.
      end if

      ::oDetMenuArticulo   := TpvMenuArticulo():New( cPath, Self )
      if !::oDetMenuArticulo:OpenService()
         lOpen             := .f.
      end if

   RECOVER USING oError

      lOpen                := .f.

      ::CloseService()

      msgStop( ErrorMessage( oError ), "Imposible abrir las bases de datos de TpvMenus" )

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD CloseService()

   if !empty( ::oDbf ) .and. ::oDbf:Used()
      ::oDbf:End()
   end if

   if !empty( ::oMenuOrdenes )
      ::oMenuOrdenes:CloseService()
      ::oMenuOrdenes:End()
   end if

   if !empty( ::oDetMenuArticulo )
      ::oDetMenuArticulo:CloseService()
      ::oDetMenuArticulo:End()
   end if

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD Resource( nMode )

	local oDlg

   DEFINE DIALOG oDlg RESOURCE "TpvMenus" TITLE LblTitle( nMode ) + "Ménus"

      REDEFINE GET ::oGetCodigo ;
         VAR      ::oDbf:cCodMnu ;
			ID 		100 ;
         WHEN     ( nMode == APPD_MODE .or. nMode == DUPL_MODE ) ;
         VALID    NotValid( ::oGetCodigo, ::oDbf:cAlias, .t., "0" ) ;
			PICTURE 	"@!" ;
			OF 		oDlg

      REDEFINE GET ::oGetNombre ;
         VAR      ::oDbf:cNomMnu ;
			ID 		110 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
			OF 		oDlg

      REDEFINE GET ::oDbf:nImpMnu ;
         ID       120 ;
         PICTURE  ( cPorDiv() ) ;
         WHEN     ( nMode != ZOOM_MODE .and. !::oDbf:lAcomp ) ;
         OF       oDlg

      REDEFINE CHECKBOX ::oDbf:lObsMnu ;
         ID       130 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oDlg

      REDEFINE CHECKBOX ::oDbf:lAcomp ;
         ID       140 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oDlg

      // Browse de odenes de comanda------------------------------------------

      ::oBrwOrdenesComanda                := IXBrowse():New( oDlg )

      ::oBrwOrdenesComanda:bClrSel        := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      ::oBrwOrdenesComanda:bClrSelFocus   := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      ::oMenuOrdenes:oDbfVir:SetBrowse( ::oBrwOrdenesComanda ) 

      ::oBrwOrdenesComanda:nMarqueeStyle  := 6
      ::oBrwOrdenesComanda:cName          := "Lineas de ordenes de comanda"
      ::oBrwOrdenesComanda:lFooter        := .f.

      ::oBrwOrdenesComanda:bLDblClick     := {|| ::oMenuOrdenes:Edit( ::oBrwOrdenesComanda ) }

      ::oBrwOrdenesComanda:CreateFromResource( 400 )

      with object ( ::oBrwOrdenesComanda:AddCol() )
         :cHeader          := "Código"
         :bStrData         := {|| ::oMenuOrdenes:oDbfVir:FieldGetByName( "cCodOrd" ) }
         :nWidth           := 50
      end with

      with object ( ::oBrwOrdenesComanda:AddCol() )
         :cHeader          := "Orden de comanda"
         :bStrData         := {|| ::oOrdenComandas:cNombre( ::oMenuOrdenes:oDbfVir:FieldGetByName( "cCodOrd" ) ) } 
         :nWidth           := 200
      end with

      with object ( ::oBrwOrdenesComanda:AddCol() )
         :cHeader          := "Intercambiable"
         :bStrData         := {|| ::oMenuOrdenes:Intercambiable( ::oMenuOrdenes:oDbfVir:FieldGetByName( "lIntOrd" ) ) }
         :nWidth           := 100
      end with

      REDEFINE BUTTON ;
         ID       500 ;
         OF       oDlg ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( ::oMenuOrdenes:Append( ::oBrwOrdenesComanda ) )

      REDEFINE BUTTON ;
         ID       501 ;
         OF       oDlg ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( ::oMenuOrdenes:Edit( ::oBrwOrdenesComanda ) )

      REDEFINE BUTTON ;
         ID       502 ;
         OF       oDlg ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( ::oMenuOrdenes:Del( ::oBrwOrdenesComanda ) )

      /*
      Creamos los botones------------------------------------------------------
      */

      REDEFINE BUTTON ;
         ID       IDOK ;
			OF 		oDlg ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         ACTION   ( ::lSaveResource( nMode, oDlg ) )

		REDEFINE BUTTON ;
         ID       IDCANCEL ;
			OF 		oDlg ;
         CANCEL ;
			ACTION 	( oDlg:end() )

   oDlg:AddFastKey( VK_F2, {|| ::oMenuOrdenes:Append( ::oBrwOrdenesComanda ) } )
   oDlg:AddFastKey( VK_F3, {|| ::oMenuOrdenes:Edit( ::oBrwOrdenesComanda ) } )
   oDlg:AddFastKey( VK_F4, {|| ::oMenuOrdenes:Del( ::oBrwOrdenesComanda ) } )
   oDlg:AddFastKey( VK_F5, {|| ::lSaveResource( nMode, oDlg ) } )

   oDlg:bStart    := {|| ::StartResource() }

	ACTIVATE DIALOG oDlg	CENTER

RETURN ( oDlg:nResult == IDOK )

//--------------------------------------------------------------------------//

Method lSaveResource( nMode, oDlg )

   if ( nMode == APPD_MODE .or. nMode == DUPL_MODE )

      if Empty( ::oDbf:cCodMnu )
         MsgStop( "Código de menú no puede estar vacío" )
         ::oGetCodigo:SetFocus()
         Return nil
      end if

      if ::oDbf:SeekInOrd( ::oDbf:cCodMnu, "cCodMnu" )
         msgStop( "Código existente" )
         ::oGetCodigo:SetFocus()
         Return nil
      end if

   end if

   if Empty( ::oDbf:cNomMnu )
      MsgStop( "Nombre de menú no puede estar vacío" )
      ::oGetNombre:SetFocus()
      Return nil
   end if

   if ::oMenuOrdenes:nIntercambiables( ::oMenuOrdenes:oDbfVir:cCodMnu, ::oMenuOrdenes:oDbfVir ) == 1
      MsgStop( "Tiene que haber más de un orden intercambiable o ninguno." )
      Return ( .f. )
   end if

   // ::SaveDetails()

Return ( oDlg:end( IDOK ) )

//---------------------------------------------------------------------------//

METHOD lIsMenuActive()

Return ( ::nMenuActive() > 0 )

//---------------------------------------------------------------------------//

METHOD nMenuActive()

   local nMenuActive := 0

   ::oDbf:getStatus()
   ::oDbf:ordsetfocus( "lShwMnu" )

   nMenuActive       := ::oDbf:ordKeyCount()

   ::oDbf:setStatus()

Return ( nMenuActive )

//---------------------------------------------------------------------------//

METHOD cMenuActive()

   local cMenuActive := ""

   ::oDbf:getStatus()
   ::oDbf:ordSetfocus( "lShwMnu" )
   ::oDbf:goTop()
   
   cMenuActive       := ::oDbf:cCodMnu

   ::oDbf:setStatus()

Return ( cMenuActive )

//---------------------------------------------------------------------------//

METHOD cNombre( cCodMnu )

   local cNombre        := ""

   ::oDbf:GetStatus()

   if ::oDbf:SeekInOrd( cCodMnu, "cCodMnu" )
      cNombre           := ::oDbf:cNomMnu
   end if

   ::oDbf:SetStatus()

RETURN ( cNombre )

//---------------------------------------------------------------------------//

METHOD nPrecio( cCodMnu )

   local nPrecio        := 0

   ::oDbf:GetStatus()

   if ::oDbf:SeekInOrd( cCodMnu, "cCodMnu" )
      nPrecio           := ::oDbf:nImpMnu
   end if

   ::oDbf:SetStatus()

RETURN ( nPrecio )

//---------------------------------------------------------------------------//

METHOD InitAcompannamientoMultiple( cCodigoMenu, cCodigoOrden, nUnidades )

   local oFntBrw                  
   local cCodigoArticulo

   if !::CargaDatosAcompannamiento( cCodigoMenu, cCodigoOrden )
      Return ( Self )
   end if 

   oFntBrw                          := TFont():New( "Segoe UI",  0, 27, .f., .t. )

   // Definimos el dialogo para el menú de acompañamiento-----------------------

   DEFINE DIALOG ::oDlgAcompannamiento RESOURCE "TPVMenuAcomp"

      REDEFINE BUTTONBMP ;
         ID       110 ;
         OF       ::oDlgAcompannamiento ;
         BITMAP   "gc_navigate_up2a_32" ;
         ACTION   ( ::oBrwAcompannamiento:Select( 0 ), ::oBrwAcompannamiento:PageUp(), ::oBrwAcompannamiento:Select( 1 ) )

      REDEFINE BUTTONBMP ;
         ID       111 ;
         OF       ::oDlgAcompannamiento ;
         BITMAP   "gc_navigate_down2a_32" ;
         ACTION   ( ::oBrwAcompannamiento:Select( 0 ), ::oBrwAcompannamiento:PageDown(), ::oBrwAcompannamiento:Select( 1 ) )

      REDEFINE BUTTONBMP ;
         BITMAP   "gc_check_32" ;
         ID       IDOK ;
         OF       ::oDlgAcompannamiento ;
         ACTION   ( ::ProcesaDatosAcompannamiento( nUnidades ) )

      REDEFINE BUTTONBMP ;
         BITMAP   "Delete_32" ;
         ID       IDCANCEL ;
         OF       ::oDlgAcompannamiento ;
         ACTION   ( ::oDlgAcompannamiento:End() )

      ::oBrwAcompannamiento                  := IXBrowse():New( ::oDlgAcompannamiento )

      ::oBrwAcompannamiento:bClrSel          := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      ::oBrwAcompannamiento:bClrSelFocus     := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }
      ::oBrwAcompannamiento:nMarqueeStyle    := 3
      ::oBrwAcompannamiento:cName            := "Acompañamiento de artículo"
      ::oBrwAcompannamiento:lHeader          := .f.
      ::oBrwAcompannamiento:lHScroll         := .f.
      ::oBrwAcompannamiento:nRowHeight       := 55

      ::oBrwAcompannamiento:lFooter          := .t.

      ::oBrwAcompannamiento:CreateFromResource( 100 )

      ::oBrwAcompannamiento:SetFont( oFntBrw )

      ::oBrwAcompannamiento:setArray( ::aIngredientes, , , .f. )

      with object ( ::oBrwAcompannamiento:AddCol() )
         :bEditValue                         := {|| hGet( ::aIngredientes[ ::oBrwAcompannamiento:nArrayAt ], "Nombre" ) }
         :nWidth                             := 490
         :bFooter                            := {|| "Total ingredientes a seleccionar: " + alltrim( str( nUnidades ) ) }
      end with

      with object ( ::oBrwAcompannamiento:AddCol() )
         :bEditValue                         := {|| hGet( ::aIngredientes[ ::oBrwAcompannamiento:nArrayAt ], "Unidades" ) }
         :cEditPicture                       := "9"
         :nWidth                             := 65
         :nDataStrAlign                      := 1
         :nHeadStrAlign                      := 1
         :nFooterType                        := AGGR_SUM
      end with

      with object ( ::oBrwAcompannamiento:AddCol() )
         :cHeader             := "Sumar unidades"
         :bEditBlock          := {|| ::SumaUnidadesAcompannamiento() }
         :nEditType           := 5
         :nWidth              := 53
         :nHeadBmpNo          := 1
         :nBtnBmp             := 1
         :nHeadBmpAlign       := 1
         :AddResource( "Navigate2_plus_48" )
      end with

      with object ( ::oBrwAcompannamiento:AddCol() )
         :cHeader             := "Restar unidades"
         :bEditBlock          := {|| ::RestaUnidadesAcompannamiento() }
         :nEditType           := 5
         :nWidth              := 53
         :nHeadBmpNo          := 1
         :nBtnBmp             := 1
         :nHeadBmpAlign       := 1
         :AddResource( "Navigate2_minus_48" )
      end with

      ::oDlgAcompannamiento:bStart             := {|| ::oSender:SeleccionarDefecto( ::oBrwAcompannamiento ) }

   ACTIVATE DIALOG ::oDlgAcompannamiento CENTER

   ::oSender:oBrwLineas:Refresh()

   if !Empty( oFntBrw )
      oFntBrw:End()
   end if

Return ( cCodigoArticulo )

//---------------------------------------------------------------------------//

METHOD Acompannamiento( cCodigoMenu )
   
   local cOrden
   local aOrdenes    := ::oMenuOrdenes:aOrdenes( cCodigoMenu )

   for each cOrden in aOrdenes

      if ::oMenuOrdenes:nUnidadesOrdenAcompannamiento( cCodigoMenu, cOrden ) > 1

         ::InitAcompannamientoMultiple( cCodigoMenu, cOrden, ::oMenuOrdenes:nUnidadesOrdenAcompannamiento( cCodigoMenu, cOrden ) )

      else

         ::InitAcompannamientoSimple( cCodigoMenu, cOrden )

      end if

   next  

RETURN( Self )

//---------------------------------------------------------------------------//

METHOD CargaDatosAcompannamiento( cCodigoMenu, cCodigoOrden )

   ::aIngredientes     := {}

   ::oDetMenuArticulo:oDbf:GetStatus()
   ::oDetMenuArticulo:oDbf:OrdSetFocus( "cMnuOrd" )

   if ::oDetMenuArticulo:oDbf:Seek( cCodigoMenu + cCodigoOrden )

      while ::oDetMenuArticulo:oDbf:cCodMnu == cCodigoMenu .and. ::oDetMenuArticulo:oDbf:cCodOrd == cCodigoOrden .and. !::oDetMenuArticulo:oDbf:Eof()

         aAdd( ::aIngredientes,  {  "Codigo"       => ::oDetMenuArticulo:oDbf:cCodArt ,;
                                    "Nombre"       => Alltrim( oRetFld( ::oDetMenuArticulo:oDbf:cCodArt, ::oSender:oArticulo )) ,;
                                    "Unidades"     => 0 ,;
                                    "Imagen"       => oRetFld( ::oDetMenuArticulo:oDbf:cCodArt, ::oSender:oArticulo, "cImagen" ) ,;
                                    "Color"        => oRetFld( ::oDetMenuArticulo:oDbf:cCodArt, ::oSender:oArticulo, "nColBtn" ) ,;
                                    "CodigoMenu"   => cCodigoMenu ,;
                                    "CodigoOrden"  => cCodigoOrden })

         ::oDetMenuArticulo:oDbf:skip()

      end while

   end if

   ::oDetMenuArticulo:oDbf:SetStatus()

RETURN ( len( ::aIngredientes ) > 0 )

//--------------------------------------------------------------------------//

METHOD ProcesaDatosAcompannamiento( nUnidades )

   local aIngrediente
   local nTotal      := 0

   DEFAULT nUnidades := 1

   if ::nUnidadesAcompannamiento() > nUnidades
      MsgStop( "Has introducido más ingredientes de lo permitido." )
      Return nil
   end if

   if ::nUnidadesAcompannamiento() == 0
      MsgStop( "No has seleccionado ningún ingrediente." )
      Return nil
   end if

   ::oDlgAcompannamiento:Disable()

   for each aIngrediente in ::aIngredientes

      if aIngrediente[ "Unidades" ] > 0

         ::oSender:AgregarAcompannamiento( aIngrediente[ "Codigo" ], aIngrediente[ "Unidades" ], aIngrediente[ "CodigoMenu" ], aIngrediente[ "CodigoOrden" ] )

      end if

   next

   ::oDlgAcompannamiento:Enable()

   ::oDlgAcompannamiento:End()

RETURN ( Self )

//--------------------------------------------------------------------------//

METHOD nUnidadesAcompannamiento()
   
   local aIngrediente
   local nTotal      := 0

   for each aIngrediente in ::aIngredientes

      if aIngrediente[ "Unidades" ] > 0

         nTotal   += aIngrediente[ "Unidades" ]

      end if

   next

RETURN ( nTotal )

//--------------------------------------------------------------------------//

METHOD InitAcompannamientoSimple( cCodigoMenu, cCodigoOrden )

   local cCodigoArticulo

   if !::CargaDatosAcompannamiento( cCodigoMenu, cCodigoOrden )
      Return ( Self )
   end if 

   // Definimos el dialogo para el menú de acompañamiento-----------------------

   DEFINE DIALOG ::oDlgAcompannamiento RESOURCE "TPVMenuAcompSimple"

      REDEFINE BUTTONBMP ;
         ID       110 ;
         OF       ::oDlgAcompannamiento ;
         BITMAP   "gc_navigate_up2a_32" ;
         ACTION   ( ::oLstArticulos:PageUp() )

      REDEFINE BUTTONBMP ;
         ID       111 ;
         OF       ::oDlgAcompannamiento ;
         BITMAP   "gc_navigate_down2a_32" ;
         ACTION   ( ::oLstArticulos:PageDown() )

      REDEFINE BUTTONBMP ;
         BITMAP   "Delete_32" ;
         ID       IDCANCEL ;
         OF       ::oDlgAcompannamiento ;
         ACTION   ( ::oDlgAcompannamiento:End() )

      ::oLstArticulos               := C5ImageView():Redefine( 100, ::oDlgAcompannamiento )
      ::oLstArticulos:nWItem        := ::oSender:nImageViewWItem
      ::oLstArticulos:nHItem        := ::oSender:nImageViewHItem
      ::oLstArticulos:nVSep         := ::oSender:nImageViewVSep
      ::oLstArticulos:nHSep         := ::oSender:nImageViewHSep
      ::oLstArticulos:aTextMargin   := ::oSender:aImageViewTextMargin
      ::oLstArticulos:lTitle        := ::oSender:lImagenArticulos
      ::oLstArticulos:nHTitle       := ::oSender:nImageViewTitle
      ::oLstArticulos:lShowOption   := .f.
      ::oLstArticulos:lxVScroll     := .f.
      ::oLstArticulos:lxHScroll     := .f.
      ::oLstArticulos:lAdjust       := .f.
      ::oLstArticulos:nClrTextSel   := CLR_BLACK
      ::oLstArticulos:nClrPane      := CLR_WHITE
      ::oLstArticulos:nClrPaneSel   := CLR_WHITE
      ::oLstArticulos:nAlignText    := nOr( DT_TOP, DT_CENTER, DT_WORDBREAK )

      ::oLstArticulos:nOption       := 0
      ::oLstArticulos:bAction       := {|| ::ActionAcompannamientoSimple() }

      ::oLstArticulos:SetFont( ::oSender:oFntBrw )

      ::oDlgAcompannamiento:bStart  := {|| ::StartDialogAcompannamiento()}

   ACTIVATE DIALOG ::oDlgAcompannamiento CENTER

   ::oSender:oBrwLineas:Refresh()

Return ( cCodigoArticulo )

//---------------------------------------------------------------------------//

METHOD StartDialogAcompannamiento()

   local aItems         := {}
   local aIngrediente

   for each aIngrediente in ::aIngredientes
      ::CreateItemAcompannamiento( aIngrediente, aItems )
   next

   ::oLstArticulos:SetItems( aItems )

Return ( aItems )

//---------------------------------------------------------------------------//

METHOD CreateItemAcompannamiento( aIngrediente, aItems )

   with object ( C5ImageViewItem() )

      :Cargo            := aIngrediente[ "Codigo" ]
      :cText            := aIngrediente[ "Nombre" ]

      :bAction          := {|cCodigoArticulo| ::AgregarAcompannamientoSimple( cCodigoArticulo, aIngrediente[ "CodigoMenu" ], aIngrediente[ "CodigoOrden" ] ) }

      if ( ::oSender:lImagenArticulos ) .and. ( ::oSender:lFileBmpName( aIngrediente[ "Imagen" ] ) )

         :cImage        := ::oSender:cFileBmpName( aIngrediente[ "Imagen" ] )
      
      else
         
         :nClrPane      := aIngrediente[ "Color" ] 
            
      end if

      :Add( aItems )

   end with

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD AgregarAcompannamientoSimple( cCodigoArticulo, cCodigoMenu, cCodigoOrden )

   ::oSender:AgregarAcompannamiento( cCodigoArticulo, 1, cCodigoMenu, cCodigoOrden )

   ::oDlgAcompannamiento:End()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD ActionAcompannamientoSimple()

   local oOpt

   oOpt     := ::oLstArticulos:GetSelection()

   if Empty( oOpt )
      MsgStop( "Seleccione una opción valida." )
      Return ( Self )
   end if

   if !empty( ::oLstArticulos:GetSelection():bAction )
      eval( ::oLstArticulos:GetSelection():bAction, ::oLstArticulos:GetSelection():Cargo )
   end if

RETURN ( Self )

//---------------------------------------------------------------------------//

