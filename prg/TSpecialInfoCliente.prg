#include "FiveWin.Ch"
#include "Factu.ch" 
#include "MesDbf.ch"
#include "Xbrowse.ch"

//----------------------------------------------------------------------------//

CLASS TSpecialInfoCliente

   DATA cCodigoCliente
   DATA cNombreCliente
   DATA cCodigoArticulo

   METHOD New( cCodigoCliente, cNombreCliente, cCodigoArticulo )

   METHOD Resource()

   METHOD isSelectSATFromCliente()    INLINE ( TDataCenter():selectSATFromClient( ::cCodigoCliente, , ::cCodigoArticulo ) )

   METHOD Run( cCodigoCliente, cNombreCliente, cCodigoArticulo )

END CLASS

//----------------------------------------------------------------------------//

METHOD New( cCodigoCliente, cNombreCliente, cCodigoArticulo ) CLASS TSpecialInfoCliente

   ::cCodigoCliente    := cCodigoCliente
   ::cNombreCliente    := cNombreCliente
   ::cCodigoArticulo   := cCodigoArticulo

Return ( Self )

//----------------------------------------------------------------------------//

METHOD Run( cCodigoCliente, cNombreCliente, cCodigoArticulo )

   ::New( cCodigoCliente, cNombreCliente, cCodigoArticulo )

   if ::isSelectSATFromCliente()
      ::Resource()
   end if

Return ( Self )

//----------------------------------------------------------------------------//

METHOD Resource() CLASS TSpecialInfoCliente

   local oDlg
   local oBmp
   local oBrwCliente

   DEFINE DIALOG oDlg RESOURCE "Info_5" TITLE "Información del cliente : " + Rtrim( ::cCodigoCliente ) + " - " + Rtrim( ::cNombreCliente )

   REDEFINE BITMAP oBmp ID 500 RESOURCE "gc_businessman_48" TRANSPARENT OF oDlg

      oBrwCliente                       := IXBrowse():New( oDlg )

      oBrwCliente:bClrSel               := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      oBrwCliente:bClrSelFocus          := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      oBrwCliente:nMarqueeStyle         := 6
      oBrwCliente:cName                 := "Máquinas en informe de clientes"

      oBrwCliente:setTree( TDataCenter():treeProductFromSAT(), { "gc_navigate_minus_16", "gc_navigate_plus_16" } )

      if len( oBrwCliente:aCols ) > 0
         oBrwCliente:aCols[ 1 ]:cHeader := ""
         oBrwCliente:aCols[ 1 ]:nWidth  := 20
      end if

      oBrwCliente:bLDblClick  := {|| EdtSatCli( oBrwCliente:oTreeItem:Cargo[ "cSerSat" ] + str( oBrwCliente:oTreeItem:Cargo[ "nNumSat" ], 9 ) + oBrwCliente:oTreeItem:Cargo[ "cSufSat" ] ) }
      
      oBrwCliente:CreateFromResource( 300 )

      with object ( oBrwCliente:addCol() )
         :cHeader          := "Artículo"
         :bEditValue       := {|| alltrim( oBrwCliente:oTreeItem:Cargo[ "cRef" ] ) + " - " + alltrim( oBrwCliente:oTreeItem:Cargo[ "Nombre" ] ) }
         :nWidth           := 260
      end with

      with object ( oBrwCliente:addCol() )
         :cHeader          := "S.A.T."
         :bEditValue       := {|| oBrwCliente:oTreeItem:Cargo[ "cSerSat" ] + "/" + alltrim( str( oBrwCliente:oTreeItem:Cargo[ "nNumSat" ] ) ) }
         :nDataStrAlign    := AL_LEFT
         :nHeadStrAlign    := AL_LEFT
         :nWidth           := 120
      end with

      with object ( oBrwCliente:addCol() )
         :cHeader          := "Dlg."
         :bEditValue       := {|| oBrwCliente:oTreeItem:Cargo[ "cSufSat" ] }
         :nDataStrAlign    := AL_LEFT
         :nHeadStrAlign    := AL_LEFT
         :lHide            := .t.
         :nWidth           := 40
      end with

      with object ( oBrwCliente:addCol() )
         :cHeader          := "Fecha"
         :bEditValue       := {|| oBrwCliente:oTreeItem:Cargo[ "dFecSat" ] }
         :nDataStrAlign    := AL_LEFT
         :nHeadStrAlign    := AL_LEFT
         :nWidth           := 80
      end with

      with object ( oBrwCliente:addCol() )
         :cHeader          := "Operario"
         :bEditValue       := {|| oBrwCliente:oTreeItem:Cargo[ "cCodOpe" ] + " - " + oBrwCliente:oTreeItem:Cargo[ "cNomTra" ] }
         :nWidth           := 170
      end with

      with object ( oBrwCliente:addCol() )
         :cHeader          := "Estado"
         :bEditValue       := {|| alltrim( oBrwCliente:oTreeItem:Cargo[ "cCodEst" ] ) }
         :bStrData         := {|| alltrim( oBrwCliente:oTreeItem:Cargo[ "cCodEst" ] ) + " - " + oBrwCliente:oTreeItem:Cargo[ "cNombre" ] }
         :nWidth           := 170
      end with

      with object ( oBrwCliente:addCol() )
         :cHeader          := "Situación"
         :bEditValue       := {|| alltrim( oBrwCliente:oTreeItem:Cargo[ "cSituac" ] ) }
         :nWidth           := 100
      end with

      with object ( oBrwCliente:addCol() )
         :cHeader          := "Ubicación"
         :bEditValue       := {|| alltrim( oBrwCliente:oTreeItem:Cargo[ "cDesUbi" ] ) }
         :nWidth           := 130
      end with

      with object ( oBrwCliente:addCol() )
         :cHeader          := "Contador"
         :bEditValue       := {|| if( !Empty( oBrwCliente:oTreeItem:Cargo[ "nCntAct" ] ), Trans( oBrwCliente:oTreeItem:Cargo[ "nCntAct" ], "99999999999" ), "" ) }
         :nWidth           := 130
         :nDataStrAlign    := AL_RIGHT
         :nHeadStrAlign    := AL_RIGHT
         :lHide            := .t.
      end with

      with object ( oBrwCliente:addCol() )
         :cHeader          := "Observaciones"
         :bEditValue       := {|| oBrwCliente:oTreeItem:Cargo[ "mObsLin" ] }
         :nWidth           := 150
         :lHide            := .t.
      end with

      oDlg:bStart     := {|| oBrwCliente:Load() }

   ACTIVATE DIALOG oDlg CENTER

   if !Empty( oBmp )
      oBmp:End()
   end if
  
RETURN ( Self )

//----------------------------------------------------------------------------//

