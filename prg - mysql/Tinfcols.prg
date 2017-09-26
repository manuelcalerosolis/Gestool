#include "FiveWin.Ch"
#include "Font.ch"
#include "Report.ch"

//---------------------------------------------------------------------------//

CLASS TInfCols

   DATA bFld
   DATA cTitle
   DATA nPad         INIT 1
   DATA lTotal       INIT .f.
   DATA lSeparador   INIT .f.
   DATA lSombra      INIT .f.
   DATA bPict
   DATA nSize        INIT 0
   DATA lSelect      INIT .t.
   DATA nPos         INIT 0
   DATA cDescrip
   DATA bFont
   DATA Cargo
   DATA oParent
   DATA bStartTotal

   METHOD New( bFld, cTitle, bPict, lSelect, nPad, lTotal, lSeparador, lSombra, nPos,;
               nSize, cDescrip, Cargo ) CONSTRUCTOR

   METHOD lEditCol()

   METHOD Select()      INLINE   ( ::lSelect := .t., ::lSave2Exit() )

   METHOD UnSelect()    INLINE   ( ::lSelect := .f., ::lSave2Exit() )

   METHOD Toogle()      INLINE   ( ::lSelect := !::lSelect, ::lSave2Exit() )

   METHOD lSave2Exit()  INLINE   if( ::oParent != nil, ::oParent:lSave2Exit := .t., )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( bFld, cTitle, bPict, lSelect, nPad, lTotal, lSeparador, lSombra, nPos, nSize, cDescrip, bFont, Cargo, oParent ) CLASS TInfCols

   DEFAULT  bFld        := {|| "" }
   DEFAULT  cTitle      := ""
   DEFAULT  bPict       := {|| "" }
   DEFAULT  lSelect     := .t.
   DEFAULT  nPad        := 1
   DEFAULT  lTotal      := .f.
   DEFAULT  lSeparador  := .f.
   DEFAULT  lSombra     := .f.
   DEFAULT  nPos        := 0
   DEFAULT  nSize       := 0
   DEFAULT  cDescrip    := cTitle
   DEFAULT  bFont       := {|| 2 }

   ::bFld               := bFld
   ::cTitle             := cTitle
   ::bPict              := bPict
   ::lSelect            := lSelect
   ::nPad               := nPad
   ::lTotal             := lTotal
   ::lSeparador         := lSeparador
   ::lSombra            := lSombra
   ::nPos               := nPos
   ::nSize              := nSize
   ::cDescrip           := cDescrip
   ::bFont              := bFont
   ::Cargo              := Cargo
   ::oParent            := oParent

RETURN Self

//----------------------------------------------------------------------------//

METHOD lEditCol() CLASS TInfCols

   local oDlg
   local oJustificado
   local aJustificado   := { "Izquierda", "Derecha" }
   local cJustificado   := aJustificado[ ::nPad ]
   local cTitle         := padr( ::cTitle, 50 )
   local lSelect        := ::lSelect
   local lTotal         := ::lTotal
   local lSeparador     := ::lSeparador
   local lSombra        := ::lSombra
   local nSize          := ::nSize

   DEFINE DIALOG oDlg RESOURCE "REP_COL" TITLE ::cDescrip

   REDEFINE GET cTitle ;
      ID       100 ;
      OF       oDlg

   REDEFINE GET nSize ;
      ID       110 ;
      SPINNER ;
      PICTURE  "@E 999" ;
      OF       oDlg

   REDEFINE COMBOBOX oJustificado VAR cJustificado ;
      ITEMS    aJustificado ;
      ID       120 ;
		OF 		oDlg

   REDEFINE CHECKBOX lTotal ;
      ID       130 ;
      OF       oDlg

   REDEFINE CHECKBOX lSombra ;
      ID       140 ;
      OF       oDlg

   REDEFINE CHECKBOX lSeparador ;
      ID       150 ;
      OF       oDlg

	REDEFINE BUTTON ;
      ID       IDOK ;
		OF 		oDlg ;
      ACTION   ( oDlg:end( IDOK ) )

	REDEFINE BUTTON ;
      ID       IDCANCEL ;
		OF 		oDlg ;
		ACTION 	( oDlg:end() )

   ACTIVATE DIALOG oDlg CENTER

   if oDlg:nResult == IDOK

      ::nPad            := oJustificado:nAt
      ::cTitle          := Rtrim( cTitle )
      ::lSelect         := lSelect
      ::lTotal          := lTotal
      ::lSeparador      := lSeparador
      ::lSombra         := lSombra
      ::nSize           := nSize

      ::lSave2Exit()

   end if

RETURN ( oDlg:nResult == IDOK )

//---------------------------------------------------------------------------//