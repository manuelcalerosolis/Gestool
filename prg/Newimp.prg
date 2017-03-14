#include "FiveWin.Ch"
#include "Factu.ch" 
#include "MesDbf.ch"


//----------------------------------------------------------------------------//

CLASS TNewImp FROM TMant

   DATA  cName          INIT "ImpuestosEspeciales"  

   DATA  cPouDiv

   DATA  cMru           INIT "gc_moneybag_euro_16"

   METHOD Create( cPath )

   METHOD New( cPath, oWndParent, oMenuItem )

   METHOD DefineFiles()

   METHOD OpenFiles( lExclusive )
   MESSAGE OpenService( lExclusive )   METHOD OpenFiles( lExclusive )

   METHOD Resource( nMode )

   METHOD nValImp( cCodImp, lIvaInc, nIva )

   METHOD nBrwImp( oGet )

   METHOD cCtaImp( cCodImp )

   METHOD lPreSave()

   METHOD setCodeAndValue( cCodImp, uCode, uValue )

END CLASS

//----------------------------------------------------------------------------//

METHOD Create( cPath )

   DEFAULT cPath        := cPatEmp()

   ::cPath              := cPath
   ::oDbf               := nil

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD New( cPath, oWndParent, oMenuItem )

   DEFAULT cPath        := cPatEmp()
   DEFAULT oWndParent   := GetWndFrame()
   DEFAULT oMenuItem    := "01037"

   ::cPath              := cPath
   ::oWndParent         := oWndParent
   ::nLevel             := nLevelUsr( oMenuItem )

   ::oDbf               := nil

   ::lAutoButtons       := .t.
   ::lCreateShell       := .f.

   ::cBitmap            := clrTopArchivos

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD OpenFiles( lExclusive, cPath ) CLASS TNewImp

   local lOpen          := .t.
   local oBlock
   local oError

   DEFAULT lExclusive   := .f.

   oBlock               := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      if Empty( ::oDbf )
         ::DefineFiles( cPath )
      end if

      ::oDbf:Activate( .f., !( lExclusive ) )

      ::cPouDiv         := cPouDiv( cDivEmp() )

   RECOVER USING oError

      lOpen             := .f.

      ::CloseFiles()

      msgStop( ErrorMessage( oError ), "Imposible abrir todas las bases de datos de impuestos especiales" )

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//----------------------------------------------------------------------------//

METHOD DefineFiles( cPath, cDriver ) CLASS TNewImp

   DEFAULT cPath        := ::cPath
   DEFAULT cDriver      := cDriver()

   DEFINE DATABASE ::oDbf FILE "NewImp.Dbf" CLASS "NewImp" ALIAS "NewImp" PATH ( cPath ) VIA ( cDriver ) COMMENT "Impuestos"

      FIELD NAME "cCodImp" TYPE "C" LEN  3  DEC 0 COMMENT "Código"                        PICTURE "@!"      COLSIZE 60                    OF ::oDbf
      FIELD NAME "cNomImp" TYPE "C" LEN 50  DEC 0 COMMENT "Nombre"                                          COLSIZE 200                   OF ::oDbf
      FIELD NAME "nValImp" TYPE "N" LEN 16  DEC 6 COMMENT "Importe"                       PICTURE ::cPouDiv COLSIZE 80  ALIGN RIGHT       OF ::oDbf
      FIELD NAME "nPctImp" TYPE "N" LEN  6  DEC 2 COMMENT "Porcentaje de impuesto"        HIDE                                            OF ::oDbf
      FIELD NAME "nTypImp" TYPE "N" LEN  1  DEC 0 COMMENT "Tipo de impuesto"              HIDE                                            OF ::oDbf
      FIELD NAME "cSubCta" TYPE "C" LEN 12  DEC 0 COMMENT "Subcuenta contabilidad"        HIDE                                            OF ::oDbf
      FIELD NAME "lIvaVol" TYPE "L" LEN 1   DEC 0 COMMENT "Aplicar impuesto por volumen"  HIDE                                            OF ::oDbf

      INDEX TO "NewImp.Cdx" TAG "cCodImp" ON "cCodImp"   COMMENT "Código"    NODELETED OF ::oDbf
      INDEX TO "NewImp.Cdx" TAG "cNomImp" ON "cNomImp"   COMMENT "Nombre"    NODELETED OF ::oDbf
      INDEX TO "NewImp.Cdx" TAG "nValImp" ON "nValImp"   COMMENT "Importe"   NODELETED OF ::oDbf

   END DATABASE ::oDbf

RETURN ( ::oDbf )

//----------------------------------------------------------------------------//

METHOD Resource( nMode ) CLASS TNewImp

	local oDlg
   local oGet
   local oGet2
   local oCta
   local oGetSubCta
   local cGetSubCta  := ""

   DEFINE DIALOG oDlg RESOURCE "NEWIMP" TITLE LblTitle( nMode ) + "impuestos especiales"

      REDEFINE GET oGet VAR ::oDbf:cCodImp UPDATE;
			ID 		100 ;
         WHEN     ( nMode == APPD_MODE .or. nMode == DUPL_MODE ) ;
         VALID    NotValid( oGet, ::oDbf:cAlias, .t., "0" ) ;
			PICTURE 	"@!" ;
			OF 		oDlg

      REDEFINE GET oGet2 VAR ::oDbf:cNomImp UPDATE;
			ID 		110 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
			OF 		oDlg

      REDEFINE GET ::oDbf:nValImp UPDATE;
         ID       130 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         SPINNER ;
         PICTURE  ::cPouDiv ;
			OF 		oDlg

      REDEFINE GET oCta VAR ::oDbf:cSubCta UPDATE ;
         ID       140 ;
         PICTURE  ( Replicate( "X", nLenSubcuentaContaplus() ) ) ;
         WHEN     ( nLenCuentaContaplus() != 0 .AND. nMode != ZOOM_MODE ) ;
         BITMAP   "LUPA" ;
         ON HELP  ( BrwChkSubcuenta( oCta, oGetSubCta ) );
         VALID    ( MkSubcuenta( oCta, { ::oDbf:cSubCta, ::oDbf:cNomImp }, oGetSubCta ) );
         OF       oDlg

      REDEFINE GET oGetSubCta VAR cGetSubCta ;
         ID       141 ;
			WHEN 		.F. ;
         OF       oDlg

      REDEFINE CHECKBOX ::oDbf:lIvaVol UPDATE;
         ID       150;
         OF       oDlg

      REDEFINE BUTTON ;
         ID       IDOK ;
			OF 		oDlg ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         ACTION   ( ::lPreSave( oGet, oGet2, nMode, oDlg ) )

		REDEFINE BUTTON ;
         ID       IDCANCEL ;
			OF 		oDlg ;
         CANCEL ;
			ACTION 	( oDlg:end() )

   if nMode != ZOOM_MODE
      oDlg:AddFastKey( VK_F5, {|| ::lPreSave( oGet, oGet2, nMode, oDlg ) } )
   end if

   oDlg:bStart := {|| if( !Empty( ::oDbf:cSubCta ), oCta:lValid(), ), oGet:SetFocus() }

   ACTIVATE DIALOG oDlg CENTER

RETURN ( oDlg:nResult == IDOK )

//---------------------------------------------------------------------------//

Method lPreSave( oGet, oGet2, nMode, oDlg )

   if nMode == APPD_MODE .or. nMode == DUPL_MODE

      if Empty( ::oDbf:cCodImp )
         MsgStop( "Código del impuesto no puede estar vacío." )
         oGet:SetFocus()
         Return nil
      end if

      if ::oDbf:SeekInOrd( ::oDbf:cCodImp, "CCODIMP" )
         MsgStop( "Código ya existe " + Rtrim( ::oDbf:cCodImp ) )
         return nil
      end if

   end if

   if Empty( ::oDbf:cNomImp )
      MsgStop( "Nombre del impuesto no puede estar vacío." )
      oGet2:SetFocus()
      Return nil
   end if

Return ( oDlg:end( IDOK ) )

//---------------------------------------------------------------------------//

METHOD nValImp( cCodImp, lIvaInc, nValIva ) CLASS TNewImp

   local nValImp     := 0

   if !Empty( cCodImp )
      if ::oDbf:Seek( cCodImp )
         nValImp     := ::oDbf:nValImp
         /*
         if lIvaInc .and. nValIva != nil
            nValImp  += nValImp * nValIva / 100
         end if
         */
      end if
   end if

return ( nValImp )

//---------------------------------------------------------------------------//

METHOD cCtaImp( nValImp ) CLASS TNewImp

   local cCtaImp     := ""

   if !Empty( nValImp )

      //nValImp        := Str( nValImp, 16, 6 )

      ::oDbf:GetStatus()

      ::oDbf:OrdSetFocus( "nValImp" )

      if ::oDbf:Seek( nValImp )
         cCtaImp     := ::oDbf:cSubCta
      end if

      ::oDbf:SetStatus()

   end if

return ( cCtaImp )

//---------------------------------------------------------------------------//

METHOD nBrwImp( oGet ) CLASS TNewImp

   local n
   local cCaption
   local cAlias
   local cField
   local aSizes   := {}
   local uOrden   := "nValImp"
   local aOrd     := {}
   local aCampos  := {}
   local aTitulos := {}
   local bAlta    := {|| ::Append() }
   local bEdit    := {|| ::Edit()   }
   local bZoom    := {|| ::Zoom()   }
   local aJustify := {}

   cCaption       := ::oDbf:cComment
   cAlias         := ::oDbf:cAlias
   cField         := "nValImp"

   for n := 1 to ::oDbf:FCount()

      if !::oDbf:aTField[ n ]:lHide .and. !::oDbf:aTField[ n ]:lCalculate

         aAdd( aCampos, FieldWBlock( ::oDbf:aTField[ n ]:cName, ::oDbf:nArea ) )
         aAdd( aTitulos, ::oDbf:aTField[ n ]:cComment )
         aAdd( aSizes, ::oDbf:aTField[ n ]:nColSize )
         aAdd( aJustify, ::oDbf:aTField[ n ]:cType == "N"  )

      endif

   next

   for n := 1 to len( ::oDbf:aTIndex ) - 1
      if !Empty( ::oDbf:aTIndex[ n ]:cComment )
         aAdd( aOrd, ::oDbf:aTIndex[ n ]:cComment )
      end if
   next

   ::oBuscar   := TBuscar():New( cCaption, cAlias, uOrden, cField, aOrd, aCampos, aTitulos, aSizes, bAlta, bEdit, bZoom, aJustify )

   ::oBuscar:Activate()

   if oGet != nil

      if ::oBuscar:GetField() != nil
         oGet:cText( ::oBuscar:Getfield() )
      else
         oGet:cText( 0 )
      end if
      oGet:lValid()

   end if

RETURN nil

//----------------------------------------------------------------------------//

METHOD setCodeAndValue( cCodImp, uValue )

   local nImporteImpuesto  := 0
 
   if !empty( cCodImp )
      nImporteImpuesto     := ::nValImp( cCodImp ) 
   end if 

   if isObject( uValue )
      uValue:cText( nImporteImpuesto )
   else 
      uValue               := nImporteImpuesto
   end if

   sysrefresh()

Return nil

//----------------------------------------------------------------------------//

FUNCTION NewImp( uMenuItem, oWnd )


   local oNewImp

   DEFAULT  uMenuItem   := "01037"
   DEFAULT  oWnd        := oWnd()

   oNewImp              := TNewImp():New( cPatEmp(), oWnd, uMenuItem )
   oNewImp:Activate()

RETURN oNewImp

//---------------------------------------------------------------------------//