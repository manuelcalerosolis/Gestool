#include "FiveWin.Ch"
#include "Factu.ch" 
#include "MesDbf.ch"
#include "Xbrowse.ch"

//----------------------------------------------------------------------------//

CLASS TSpecialInfoCliente

   DATA cCodigoCliente
   DATA cNombreCliente

   METHOD New( cCodigoCliente, cNombreCliente )

   METHOD Resource()

   METHOD isSelectSATFromCliente()    INLINE ( TDataCenter():selectSATFromClient( ::cCodigoCliente ) )

   METHOD Run( cCodigoCliente, cNombreCliente )

END CLASS

//----------------------------------------------------------------------------//

METHOD New( cCodigoCliente, cNombreCliente ) CLASS TSpecialInfoCliente

   ::cCodigoCliente    := cCodigoCliente
   ::cNombreCliente    := cNombreCliente

Return ( Self )

//----------------------------------------------------------------------------//

METHOD Run( cCodigoCliente, cNombreCliente )

   ::New( cCodigoCliente, cNombreCliente )

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

   REDEFINE BITMAP oBmp ID 500 RESOURCE "Businessman2_Alpha_48" TRANSPARENT OF oDlg

      oBrwCliente                       := IXBrowse():New( oDlg )

      oBrwCliente:bClrSel               := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      oBrwCliente:bClrSelFocus          := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      oBrwCliente:nMarqueeStyle         := 6
      oBrwCliente:cName                 := "Máquinas en informe de clientes"

      oBrwCliente:setTree( TDataCenter():treeProductFromSAT(), { "Navigate_Minus_16", "Navigate_Plus_16" } )

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
         :bBmpData         := {|| nBitmapTipoEstadoSat( oBrwCliente:oTreeItem:Cargo[ "cTipo" ] ) }
         :nWidth           := 170
         AddResourceTipoCategoria( hb_QWith() )
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

      oDlg:bStart     := {|| oBrwCliente:LoadData() }

   ACTIVATE DIALOG oDlg CENTER

   if !Empty( oBmp )
      oBmp:End()
   end if
  
RETURN ( Self )

//----------------------------------------------------------------------------//

