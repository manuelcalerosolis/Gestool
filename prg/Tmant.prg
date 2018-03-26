#include "FiveWin.Ch"
#include "Font.ch"
#include "Report.ch"
#include "Factu.ch" 
#include "Xbrowse.ch"
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS TMant

   CLASSDATA oBandera
   CLASSDATA oInstance
   
   DATA nView

   DATA nLevel
   
   DATA oMenuItem

   DATA nMode

   DATA cPath
   DATA cDriver         INIT cDriver()

   DATA cMru

   DATA aGet

   DATA oDbf
   DATA oDbfDet

   DATA oDbfDiv

   DATA oDbfFilter

   DATA oBmpDiv

   DATA oBuscar

   DATA oWndParent
   DATA oWndBrw

   DATA oReport

   DATA cFirstKey
   DATA bFirstKey       INIT {|| .t. }

   DATA cExpresion

   DATA lAutoButtons    INIT .t.
   DATA lOpenFiles

   DATA lCreateShell    INIT .f.
   DATA lReport         INIT .t.

   DATA cBitmap         INIT "WebTopBlack"

   DATA lAccess         INIT .t.

   DATA lMinimize       INIT .f.

   DATA bOnPreAppend, bOnPostAppend
   DATA bOnPreEdit, bOnPostEdit
   DATA bOnPreDelete, bOnPostDelete
   DATA bOnPreSave, bOnPostSave
   DATA bOnPreLoad, bOnPostLoad

   DATA cHtmlHelp

   DATA cPicUnd

   DATA nSeconds

   DATA cPinDiv
   DATA cPirDiv
   DATA cPpvDiv
   DATA cPouDiv
   DATA cPorDiv
   DATA cPpvDiv
   DATA nDinDiv
   DATA nDirDiv
   DATA nDouDiv
   DATA nDorDiv
   DATA nDpvDiv
   DATA nVdvDiv
   DATA nRouDiv

   DATA cTipoDocumento
   DATA cMessageNotFound   INIT "Valor no encontrado."

   DATA lAppendBuscar      INIT .t.
   DATA lModificarBuscar   INIT .t.

   METHOD New( cPath, oWndParent, oMenuItem )   CONSTRUCTOR
   METHOD Create( cPath, cDriver )              CONSTRUCTOR

   Method Play( cPath, oWndParent, oMenuItem )

   METHOD OpenFiles()  
   METHOD DefineFiles()    VIRTUAL
   METHOD CheckFiles( cFileAppendFrom )

   METHOD Append()
   METHOD Edit()
   METHOD Zoom()
   METHOD Del()
   METHOD Dup()

   METHOD Resources()      VIRTUAL

   METHOD CreateFiles( cPath, lAppend, cPathOld, oMeter )

   METHOD Reindexa()

   METHOD Reindex( oMeter )

   METHOD Activate()

   METHOD SetFocus()                      INLINE   ( if( ::oWndBrw != nil, ::oWndBrw:SetFocus(), ) )

   METHOD CloseFiles()
   MESSAGE CloseService()                 METHOD CloseFiles()

   METHOD Buscar()

   MESSAGE Search()                       METHOD Buscar()

   METHOD Existe( uValue, oGetTxt, uField, lFill, cFillChar )

   METHOD NotExiste( uValue, oGetTxt, uField, lFill, cFillChar )

   METHOD ReturnField( uValue )

   METHOD GetAlias()                      INLINE ( ::oDbf:cAlias )

   METHOD Select()                        INLINE ( ( ::oDbf:cAlias)->( Select() ) )

   METHOD End()

   METHOD AppendFrom( cPath )

   METHOD SyncAllDbf()

   METHOD HelpTopic()

   METHOD OpenService( lExclusive )
   METHOD CloseService()

   METHOD BuildFiles( cPath )             INLINE ( ::DefineFiles( cPath ):Create() ) 

   METHOD lValid( oGet, oSay )

   METHOD InitSeconds()                   INLINE ( ::nSeconds := Seconds() )
   METHOD GetSeconds()                    INLINE ( msgInfo( ::nSeconds - Seconds() ) )

   METHOD lLoadDivisa()
   METHOD closeDivisa()

   METHOD SetFilter( cFilter )            INLINE ( ::oDbf:SetFilter( cFilter ) )
   METHOD KillFilter()                    INLINE ( ::oDbf:SetFilter() )

   METHOD Filter()
   METHOD LoadFilter()

   METHOD Report()

   METHOD CreateShell( nLevel )

   METHOD GetInstance()                   INLINE ( if( empty( ::oInstance ), ::oInstance := ::Create(), ), ::oInstance ) 
   METHOD EndInstance()                   INLINE ( if( !empty( ::oInstance ), ::oInstance := nil, ), nil ) 

   METHOD Top()                           INLINE ( dbFirst( ::oDbf:cAlias ) )
   METHOD Bottom()                        INLINE ( dbLast( ::oDbf:cAlias ) )

   METHOD GetField( cCodigo, uField )     INLINE ( oRetFld( cCodigo, ::oDbf, uField ) )

   METHOD lAppendMode()                   INLINE ( ::nMode == APPD_MODE )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( cPath, cDriver, oWndParent, oMenuItem ) CLASS TMant

   DEFAULT cPath        := cPatEmp()
   DEFAULT cDriver      := cDriver()
   DEFAULT oWndParent   := oWnd()

   ::cPath              := cPath
   ::cDriver            := cDriver
   ::oWndParent         := oWndParent

   if oMenuItem != nil
      ::nLevel          := Auth():Level( oMenuItem )
   end if

   ::oDbf               := nil

   ::lAutoButtons       := .t.
   ::lCreateShell       := .f.

   ::cPicUnd            := MasUnd()

   ::lAppendBuscar      := .f.
   ::lModificarBuscar   := .f.

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD Create( cPath, cDriver )

   DEFAULT cPath        := cPatEmp()
   DEFAULT cDriver      := cDriver()

   ::cPath              := cPath
   ::cDriver            := cDriver

   ::oDbf               := nil

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD CreateShell( nLevel ) CLASS TMant

   local cIndex
   local oField
   local cTitle
   local lPixel      := .f.
   local nHelpId
   local aFlds       := {}
   local cAlias
   local aIndex      := {}
   local nSizeBtn    := 42

   DEFAULT nLevel    := ::nLevel

   /*
   Alias para el Tshell-------------------------------------------------------
   */

   cAlias            := ::oDbf

   /*
   Los indices los ponemos como Tabs-------------------------------------------
   */

   for each cIndex in ::oDbf:aTIndex
      if !Empty( cIndex:cComment )
         aAdd( aIndex, cIndex:cComment )
      end if
   next

   /*
   Titulo para el tshell-------------------------------------------------------
   */

   cTitle            := ::oDbf:cComment

   /*
   Creamos el objeto-----------------------------------------------------------
   */

   ::oWndBrw         := TShell():New(  2, 10, 18, 70, cTitle, nil, ::oWndParent, nil, nil,;
                                       lPixel, nHelpId, nil, ::oDbf, nil, nil, nil, nil,;
                                       aIndex, {|| ::Append() }, {|| ::Edit() }, {|| ::Del() }, {|| ::Dup() },;
                                       nSizeBtn, nLevel, ::cMru, ::cBitmap, .f., {|| ::Zoom() }, .t. )

   /*
   Añadimos las columnas-------------------------------------------------------
   */

   for each oField in ::oDbf:aTField

      if ! oField:lHide

         with object ( ::oWndBrw:AddXCol() )

            :nWidth           := oField:nColSize

            if oField:lColAlign
               :nDataStrAlign := AL_RIGHT
               :nHeadStrAlign := AL_RIGHT
            end if

            if oField:lCalculate
               :bEditValue    := oField:bSetGet
            else
               :bEditValue    := oField:bDirect
            end if

            if !Empty( oField:aBitmaps )
               :bStrData      := {|| "" }
               :SetCheck( oField:aBitmaps )
            end if

            if Valtype( oField:cComment ) == "A"
               :cHeader       := oField:cComment[ 1 ]
               :AddResource( oField:cComment[ 2 ] )
               :nHeadBmpNo    := oField:cComment[ 3 ]
            else
               :cHeader       := oField:cComment
            end if

            if aScan( aIndex, {|cIndex| cIndex == :cHeader } ) != 0
               :cSortOrder    := oField:cName
               :bLClickHeader := {| nMRow, nMCol, nFlags, oCol | ::oWndBrw:ClickOnHeader( oCol ) }
            end if

         end with

      endif

   next

   /*
   Creación del control--------------------------------------------------------
   */

   ::oWndBrw:CreateXFromCode()

   ::lCreateShell    := .t.

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD OpenFiles( lExclusive, cPath )

   local oError
   local oBlock         

   DEFAULT lExclusive   := .f.
   
   oBlock               := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      if Empty( ::oDbf )
         ::oDbf         := ::DefineFiles( cPath )
      end if

      ::oDbf:Activate( .f., !( lExclusive ) )

      ::lOpenFiles      := .t.

   RECOVER USING oError

      msgStop( ErrorMessage( oError ), "Imposible abrir las bases de datos." )

      ::CloseFiles()
      
      ::lOpenFiles      := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( ::lOpenFiles )

//----------------------------------------------------------------------------//

METHOD CloseFiles() CLASS TMant

   if !Empty( ::oDbf ) .and. ::oDbf:Used()
      ::oDbf:End()
   end if

   ::oDbf      := nil

RETURN .t.

//----------------------------------------------------------------------------//

METHOD CreateFiles( cPath, lAppend, cPathOld, oMeter ) CLASS TMant

   DEFAULT cPath     := ::cPath
   DEFAULT lAppend   := .f.

   if oMeter != NIL
		oMeter:cText	:= "Generando Bases"
      SysRefresh()
   end if

   if !file( cPath + ::oDbf:cFile )
      ::oDbf:Create()
   end if

   /*
   Añadimos desde otra base de datos
   */

   if lAppend .and. lIsDir( cPathOld ) .and. file( cPathOld + ::oDbf:cFile )
      ( ::oDbf:cAlias )->( __dbApp( cPathOld + ::oDbf:cFile ) )
   end if

RETURN NIL

//---------------------------------------------------------------------------//
/*
Definicion del master----------------------------------------------------------
*/

METHOD Reindexa()

   if Empty( ::oDbf )
      ::oDbf   := ::DefineFiles()
   end if

   ::oDbf:IdxFDel()

   if ::OpenService( .t. )
      ::oDbf:Pack()
   end if

   ::CloseService()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD Reindex( oMeter ) CLASS TMant

   local bOption     := {|| .t. }

   if oMeter   != nil
      oMeter:nTotal  := ::oDbf:LastRec() + 1
      bOption        := {|| oMeter:Set( ::oDbf:OrdKeyNo() ), SysRefresh() }
   end if

   ::oDbf:Pack()
   ::oDbf:ReindexAll( bOption, 0, "!Deleted()", {|| !Deleted() } )

RETURN ( Self )

//--------------------------------------------------------------------------//

METHOD End() CLASS TMant

   if ::oDbfDiv != nil .and. ::oDbfDiv:Used()
      ::oDbfDiv:End()
      ::oDbfDiv   := nil
   end if

   if ::oBandera != nil
      ::oBandera:End()
   end if


   if ::oWndBrw != nil
      ::oWndBrw:End()
      ::oWndBrw   := nil
   end if

   ::CloseFiles()

RETURN ( .t. )

//--------------------------------------------------------------------------//

METHOD Activate() CLASS TMant

   if nAnd( ::nLevel, 1 ) != 0
      msgStop( "Acceso no permitido." )
      Return ( Self )
   end if

   /*
   Cerramos todas las ventanas
   */

   if ::oWndParent != nil
      ::oWndParent:CloseAll()
   end if

   if Empty( ::oDbf ) .or. !::oDbf:Used()
      ::lOpenFiles      := ::OpenFiles()
   end if

   /*
   Creamos el Shell
   */

   if ::lOpenFiles

      if !::lCreateShell
         ::CreateShell( ::nLevel )
      end if

      if ::lAutoButtons
         ::oWndBrw:AutoButtons( Self )
      end if

      if ::cHtmlHelp != nil
         ::oWndBrw:cHtmlHelp  := ::cHtmlHelp
      end if

      ::oWndBrw:Activate( nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, {|| ::CloseFiles() } )

   end if

RETURN ( Self )

//----------------------------------------------------------------------------//

#ifndef __PDA__

METHOD Report() CLASS TMant

   local n
   local aPrompt     := {}
   local aoCols      := {}

   ::oDbf:GetStatus()

   /*
   Creamos todas las columnas--------------------------------------------------
   */

   for n := 1 to ::oDbf:fCount()

      if !::oDbf:aTField[ n ]:lCalculate .and. !Empty( ::oDbf:aTField[ n ]:cComment )

         aAdd( aoCols, {   ::oDbf:aTField[ n ]:cName,;
                           ::oDbf:aTField[ n ]:cType,;
                           ::oDbf:aTField[ n ]:nLen,;
                           ::oDbf:aTField[ n ]:nDec,;
                           ::oDbf:aTField[ n ]:cPict,;
                           SubStr( ::oDbf:aTField[ n ]:cComment, 1, ::oDbf:aTField[ n ]:nLen + ::oDbf:aTField[ n ]:nDec ),;
                           !::oDbf:aTField[ n ]:lHide,;
                           ::oDbf:aTField[ n ]:cComment,;
                           ::oDbf:aTField[ n ]:nLen + ::oDbf:aTField[ n ]:nDec } )

      endif

   next

   for n := 1 to len( ::oDbf:aTIndex )

      aAdd( aPrompt, { ::oDbf:aTIndex[ n ]:cComment } )

   next

   ::oReport            := TInfGen():New( ::oDbf:cComment, aoCols, aPrompt )

   ::oReport:CreateFilter( nil, ::oDbf )

   ::oReport:lDefDivInf := .f.
   ::oReport:lDefSerInf := .f.
   ::oReport:lDefFecInf := .f.

   ::oReport:oParent    := Self
   ::oReport:oDbfMai    := ::oDbf

   ::oReport:StdResource()
   ::oReport:oDefDesHas()

   ::oReport:Activate()
   ::oReport:End()

   ::oDbf:SetStatus()

RETURN NIL

#endif

//----------------------------------------------------------------------------//

#ifndef __PDA__

METHOD Buscar( oGet, cField, oGetField ) CLASS TMant

   local oDlg
   local nOrd
   local oBrw
   local uVal
   local oField
   local nOrdAnt
   local cDlgName
   local cCbxIndex
   local oCbxIndex
   local aCbxIndex
   local oGetSearch
   local cGetSearch

   /*
   Apertura de ficheros si no lo estan-----------------------------------------
   */

   if Empty( ::oDbf ) .or. !::oDbf:Used()
      if !::OpenFiles()
         Return .f.
      end if
   end if

   /*
   Instanciamos la variables---------------------------------------------------
   */

   DEFAULT cField := ::oDbf:FieldName( 1 )

   cGetSearch     := Space( 100 )

   cDlgName       := "Buscando " + Rtrim( Lower( ::oDbf:cComment ) )
   aCbxIndex      := ::oDbf:aCommentIndex()

   nOrd           := 2
   nOrd           := Min( Max( nOrd, 1 ), len( aCbxIndex ) )
   cCbxIndex      := aCbxIndex[ nOrd ]

   /*
   Estado de la base de datos--------------------------------------------------
   */

   if !empty( oGet )
      do case
         case IsObject( oGet ) .and. !empty( oGet:varGet() )
            uVal  := alltrim( oGet:varGet() )
         case IsChar( oGet ) .and. !empty( oGet )
            uVal  := alltrim( oGet )
      end case          
   end if 

   if !empty( uVal ) .and. ( uVal != replicate( "Z", ::oDbf:FieldSize( cField ) ) )
      ::oDbf:Seek( uVal, .t. )
   else
      nOrdAnt              := ::oDbf:OrdSetFocus( nOrd )
      ::oDbf:GoTop()
   end if 

   /*
   Creamos el dialogo----------------------------------------------------------
   */

   oDlg                    := TDialog():New( , , , , cDlgName, "HELPENTRY" )

   oGetSearch              := TGet():ReDefine( 104, { | u | if( PCount() == 0, cGetSearch, cGetSearch := u ) }, oDlg, , "@!", , , , , , , .f., , , .f., .f. )
   oGetSearch:bChange      := {|| oGetSearch:Assign(), oBrw:Seek( Alltrim( oGetSearch:VarGet() ) ) }

   oCbxIndex               := TComboBox():ReDefine( 102, { | u | if( PCount() == 0, cCbxIndex, cCbxIndex := u ) }, aCbxIndex, oDlg, , , , , , , .f. )
   oCbxIndex:bChange       := {|| ::oDbf:OrdSetFocus( oCbxIndex:nAt ), oBrw:Refresh(), oGet:SetFocus() }

   oBrw                    := IXBrowse():New( oDlg )

   oBrw:lUpdate            := .t.

   oBrw:bClrSel            := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
   oBrw:bClrSelFocus       := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

   oBrw:nMarqueeStyle      := 5

   oBrw:cName              := cDlgName
   oBrw:bSeek              := {|c| ::oDbf:Seek( c ) }

   oBrw:oSeek              := oGetSearch

   oBrw:bLDblClick         := {|| oDlg:end( IDOK ) }
   oBrw:bRClicked          := {| nRow, nCol, nFlags | oBrw:RButtonDown( nRow, nCol, nFlags ) }

   ::oDbf:SetBrowse( oBrw )

   /*
   Columnas--------------------------------------------------------------------
   */

   for each oField in ::oDbf:aTField

      if !oField:lHide .and. !oField:lCalculate

         with object ( oBrw:AddCol() )

            if Valtype( oField:cComment ) == "A"
               :cHeader       := oField:cComment[ 1 ]
               :AddResource( oField:cComment[ 2 ] )
               :nHeadBmpNo    := oField:cComment[ 3 ]
            else
               :cHeader       := oField:cComment
            end if
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

            if aScan( aCbxIndex, {|cIndex| Valtype( :cHeader ) == "C" .and. cIndex == :cHeader } ) != 0
               :cSortOrder    := oField:cName
               :bLClickHeader := {| nMRow, nMCol, nFlags, oCol | oCbxIndex:Set( oCol:cHeader ), oBrw:GoTop() }
            end if

         end with

      endif

   next

   oBrw:CreateFromResource( 105 )

   /*
   Botones---------------------------------------------------------------------
   */

   TButton():ReDefine( 500, {|| ::Append( oBrw ) }, oDlg, , , .f., {|| ::lAppendBuscar .and. !IsReport() } )

   TButton():ReDefine( 501, {|| ::Edit( oBrw ) }, oDlg, , , .f., {|| ::lModificarBuscar .and. !IsReport() } )

   TButton():ReDefine( IDOK, {|| oDlg:end( IDOK ) }, oDlg, , , .f. )

   TButton():ReDefine( IDCANCEL, {|| oDlg:end() }, oDlg, , , .f. )

   oDlg:bStart             := {|| oBrw:Load(), if( !Empty( oGet ) .and. IsObject( oGet ), oGet:SetFocus(), ) }

   if !IsReport()
      oDlg:AddFastKey( VK_F2, {|| ::Append( oBrw ) } )
      oDlg:AddFastKey( VK_F3, {|| ::Edit( oBrw ) } )
   end if

   oDlg:AddFastKey( VK_F5,    {|| oDlg:end( IDOK ) } )
   oDlg:AddFastKey( VK_RETURN,{|| oDlg:end( IDOK ) } )

   oDlg:Activate( , , , .t. )

   /*
   Resultados------------------------------------------------------------------
   */

   if oDlg:nResult == IDOK

      uVal                 := ::oDbf:FieldGetByName( cField )

      if !Empty( oGet ) .and. IsObject( oGet ) .and. !Empty( uVal )

         oGet:cText( uVal )
         oGet:lValid()
         oGet:SetFocus()

      end if

   end if

   ::oDbf:OrdSetFocus( nOrdAnt )

RETURN ( uVal )

#endif

//----------------------------------------------------------------------------//

METHOD Filter( cTipoDocumento, oButton, oDbfFilter ) CLASS TMant

   local oFilter     := TFilterCreator():Init()

   if !Empty( oFilter )

      oFilter:SetDatabase( ::oDbf )
      oFilter:Dialog()

      ::oDbf:SetFilter( oFilter:cExpresionFilter )

   end if 

RETURN NIL

//----------------------------------------------------------------------------//

METHOD LoadFilter() CLASS TMant

   if !Empty( ::oWndBrw )
      ::oWndBrw:oActiveFilter:SetDatabase( ::oDbf ) 
      ::oWndBrw:oActiveFilter:SetFilterType( ::cTipoDocumento )
   end if

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD Existe( uValue, oGetTxt, uField, lMessage, lFill, cFillChar, uOrder ) CLASS TMant

   local n
   local uFieldGet
   local uValor
   local lValid      := .f.

   DEFAULT uField    := 2
   DEFAULT lFill     := .f.
   DEFAULT cFillChar := "0"
   DEFAULT lMessage  := .t.
   DEFAULT uOrder    := 1

   if IsObject( uValue )
      uValor         := uValue:VarGet()
   else
      uValor         := uValue
   end if

   if Empty( uValor )

      do case
      case IsArray( oGetTxt )

         aEval( oGetTxt, {|o| o:cText( "" ) } )

      case IsObject( oGetTxt )

         oGetTxt:cText( "" )

      end case

      return .t.

   else

      uValor         := Upper( uValor )

   end if

   if ( Alltrim( uValor ) == Replicate( "Z", len( Alltrim( uValor ) ) ) )
      return .t.
   end if

   ::oDbf:GetStatus( .t. )

   if lFill
      uValor         := RJust( uValor, cFillChar )
      if IsObject( uValue )
         uValue:cText( uValor )
      end if
   end if

   if !Empty( uOrder )
      ::oDbf:OrdSetFocus( uOrder )
   end if

   if ::oDbf:Seek( uValor )

      if IsObject( uValue )
         uValue:cText( uValor )
      end if

      do case
      case IsArray( oGetTxt ) .and. IsArray( uField )

         for n := 1 to len( oGetTxt )

            do case
            case IsNum( uField[ n ] )
               uFieldGet   := ::oDbf:FieldGet( uField[ n ] )

            case IsChar( uField[ n ] )
               uFieldGet   := ::oDbf:FieldGet( ::oDbf:FieldPos( uField[ n ] ) )

            case IsBlock( uField[ n ] )
               uFieldGet   := oSend( ::oDbf, Eval( uField[ n ] ) )

            end case

            oGetTxt[ n ]:cText( uFieldGet )

         next

      case IsObject( oGetTxt ) .and. !IsNil( uField )

         do case
         case IsNum( uField )
            uFieldGet      := ::oDbf:FieldGet( uField )

         case IsChar( uField )
            uFieldGet      := ::oDbf:FieldGet( ::oDbf:FieldPos( uField ) )

         case IsBlock( uField )
            uFieldGet      := oSend( ::oDbf, Eval( uField ) )

         end case

         oGetTxt:cText( uFieldGet )

      end case

      lValid         := .t.

   else

      if lMessage
         msgStop( ::cMessageNotFound, ::oDbf:ClassName )
      end if

   end if

   ::oDbf:SetStatus()

RETURN lValid

//---------------------------------------------------------------------------//

METHOD NotExiste( uValue, oGetTxt, uField, lMessage, lFill, cFillChar ) CLASS TMant

   local uValor
   local lValid      := .f.
   local nRecno      := ::oDbf:Recno()

   DEFAULT uField    := 2
   DEFAULT lFill     := .f.
   DEFAULT cFillChar := "0"
   DEFAULT lMessage  := .t.

   if ValType( uValue ) == "O"
      uValor   := uValue:VarGet()
   else
      uValor   := uValue
   end if

   if Empty( uValor )
      return .t.
   end if

   if lFill
      uValor   := RJust( uValor, cFillChar )
   end if

   if !::oDbf:Seek( uValor )

      if ValType( uValue ) == "O"
         uValue:cText( uValor )
      end if

      lValid   := .t.

   else

      if lMessage
         msgStop( "Valor ya existe." )
      end if

   end if

   ::oDbf:GoTo( nRecno )

RETURN lValid

//---------------------------------------------------------------------------//

METHOD ReturnField( uValue, uField ) CLASS TMant

   local uReturnField

   if ::oDbf:Seek( uValue )

      if ValType( uField ) == "N"
         uReturnField   := ::oDbf:FieldGet( uField )
      else
         uField         := ::oDbf:FieldPos( uField )
         uReturnField   := ::oDbf:FieldGet( uField )
      end if

   else

      uReturnField      := ""

   end if

return ( uReturnField )

//---------------------------------------------------------------------------//

METHOD AppendFrom( cFile ) CLASS TMant

   if !file( cFile )
      MsgStop( "No existe el fichero " + cFile )
   else
      ::oDbf:AppendFrom( cFile )
   end if

return ( Self )

//---------------------------------------------------------------------------//

METHOD Append( oBrw ) CLASS TMant

   local lAppend
   local lTrigger

   DEFAULT oBrw   := ::oWndBrw

   if ::lMinimize
      if( oBrw != nil, oBrw:Minimize(), )
   end if

   ::oDbf:Blank()
   ::oDbf:SetDefault()

   if ::bOnPreAppend != nil
      lTrigger    := Eval( ::bOnPreAppend, Self )
      if IsFalse( lTrigger )
         return .f.
      end if
   end if

   ::nMode           := APPD_MODE

   lAppend           := ::Resource( ::nMode )

   if lAppend

      if ::bOnPreSave != nil
         lTrigger    := Eval( ::bOnPreSave, Self )
         if IsFalse( lTrigger )
            return .f.
         end if
      end if

      ::oDbf:Insert()

      if ::bOnPostSave != nil
         lTrigger    := Eval( ::bOnPostSave, Self )
         if IsFalse( lTrigger )
            return .f.
         end if
      end if

   else

      ::oDbf:Cancel()

   end if

   ::nMode           := nil

   if ::lMinimize
      if( oBrw != nil, oBrw:Maximize(), )
   end if

   if lAppend .and. !Empty( oBrw )
      oBrw:Refresh()
   end if

   if ::bOnPostAppend != nil
      lTrigger       := Eval( ::bOnPostAppend, Self )
      if IsFalse( lTrigger )
         return .f.
      end if
   end if


return ( lAppend )

//---------------------------------------------------------------------------//

METHOD Dup() CLASS TMant

   local lDup
   local lTrigger

   if ::oDbf:OrdKeyCount() == 0
      return .f.
   end if

   ::oDbf:Blank()
   ::oDbf:Load()

   if ::bOnPreAppend != nil
      lTrigger := Eval( ::bOnPreAppend, Self )
      if Valtype( lTrigger ) == "L" .and. !lTrigger
         return .f.
      end if
   end if

   ::nMode     := APPD_MODE

   lDup        := ::Resource( ::nMode )

   if lDup

      if ::bOnPreSave != nil
         lTrigger    := Eval( ::bOnPreSave, Self )
         if IsFalse( lTrigger )
            return .f.
         end if
      end if

      ::oDbf:Insert()

      if ::bOnPostSave != nil
         lTrigger    := Eval( ::bOnPostSave, Self )
         if IsFalse( lTrigger )
            return .f.
         end if
      end if

      if ::oWndBrw != nil
         ::oWndBrw:Refresh()
      end if

   else

      ::oDbf:Cancel()

   end if

   ::nMode     := nil 

   if ::bOnPostAppend != nil
      lTrigger       := Eval( ::bOnPostAppend, Self )
      if IsFalse( lTrigger )
         return .f.
      end if
   end if

RETURN ( lDup )

//---------------------------------------------------------------------------//

METHOD Edit( oBrw ) CLASS TMant

   local lEdit
   local lTrigger

   DEFAULT oBrw   := ::oWndBrw

   if ::oDbf:OrdKeyCount() == 0
      return .f.
   end if

   if ::lMinimize
      if( oBrw != nil, oBrw:Minimize(), )
   end if

   if ::oDbf:RecLock()

      if ::bOnPreEdit != nil
         lTrigger    := Eval( ::bOnPreEdit, Self )
         if Valtype( lTrigger ) == "L" .and. !lTrigger
            return .f.
         end if
      end if

      ::oDbf:Load()

      ::nMode        := EDIT_MODE

      lEdit          := ::Resource( ::nMode )

      if lEdit

         if ::bOnPreSave != nil
            lTrigger    := Eval( ::bOnPreSave, Self )
            if IsFalse( lTrigger )
               return .f.
            end if
         end if

         ::oDbf:Save()

         if ::bOnPostSave != nil
            lTrigger    := Eval( ::bOnPostSave, Self )
            if IsFalse( lTrigger )
               return .f.
            end if
         end if

      else

         ::oDbf:Cancel()

      end if

      ::oDbf:UnLock()

   end if

   ::nMode     := nil

   if ::lMinimize
      if( oBrw != nil, oBrw:Maximize(), )
   end if

   if( oBrw != nil, oBrw:Refresh(), )

   if ::bOnPostEdit != nil
      lTrigger    := Eval( ::bOnPostEdit, Self )
      if IsFalse( lTrigger )
         return .f.
      end if
   end if

RETURN ( lEdit )

//---------------------------------------------------------------------------//

METHOD Zoom() CLASS TMant

   if ::oDbf:OrdKeyCount() == 0
      return .f.
   end if

   if ::oDbf:RecLock()

      ::oDbf:Load()
      
      ::nMode     := ZOOM_MODE

      ::Resource( ::nMode )

      ::nMode     := nil

      ::oDbf:Cancel()

      ::oDbf:UnLock()

   end if

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD Del() CLASS TMant

   local lDel
   local cTxt
   local oBrw 
   local nRec
   local lTrigger

   if ::oDbf:OrdKeyCount() == 0
      return .f.
   end if

   if !Empty( ::oWndBrw ) .and. !Empty( ::oWndBrw:oBrw )
      oBrw        := ::oWndBrw:oBrw
   end if

   if ( "XBROWSE" $ oBrw:ClassName() ) .and. ( len( oBrw:aSelected ) > 1 )

      cTxt        := "¿ Desea eliminar definitivamente " + AllTrim( Trans( len( oBrw:aSelected ), "999999" ) ) + " registros ?"

      if SQLAjustableModel():getRolNoConfirmacionEliminacion( Auth():rolUuid() ) .or. ApoloMsgNoYes( cTxt, "Confirme supresión" )

         CursorWait()

         for each nRec in ( oBrw:aSelected )

            ::oDbf:GoTo( nRec )

            if ::bOnPreDelete != nil
               lTrigger := Eval( ::bOnPreDelete, Self )
               if IsFalse( lTrigger )
                  return .f.
               end if
            end if
      
            if ::oDbf:RecLock()
               lDel     := ::oDbf:Delete()
               ::oDbf:UnLock()
            end if
      
            if ::bOnPostDelete != nil
               lTrigger := Eval( ::bOnPostDelete, Self )
               if IsFalse( lTrigger )
                  return .f.
               end if
            end if
   
         next 
   
         CursorWE()

      end if

   else 

      if ::bOnPreDelete != nil
         lTrigger    := Eval( ::bOnPreDelete, Self )
         if IsFalse( lTrigger )
            return .f.
         end if
      end if
   
      if ::oDbf:RecLock()
   
         if SQLAjustableModel():getRolNoConfirmacionEliminacion( Auth():rolUuid() ) .or. ApoloMsgNoYes( "¿Desea eliminar el registro en curso?", "Confirme supresión" )
            CursorWait()
            lDel     := ::oDbf:Delete()
            CursorWE()
         else
            lDel     := .f.
         end if
   
         ::oDbf:UnLock()
   
      end if
   
      if ::bOnPostDelete != nil
         lTrigger := Eval( ::bOnPostDelete, Self )
         if IsFalse( lTrigger )
            return .f.
         end if
      end if

   end if 

   if ::bOnPostDelete != nil
      lTrigger := Eval( ::bOnPostDelete, Self )
      if IsFalse( lTrigger )
         return .f.
      end if
   end if

   if ::oWndBrw != nil
      ::oWndBrw:Refresh()
   end if

RETURN ( lDel )

//---------------------------------------------------------------------------//

METHOD HelpTopic() CLASS TMant

   if !Empty( ::cHtmlHelp )
      HtmlHelp( ::cHtmlHelp )
   end if

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD SyncAllDbf( lInfo )

   local oDbfTmp
   local oDbfOld
   local oBlock
   local oError

   DEFAULT lInfo  := .f.

   oBlock         := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   oDbfTmp        := ::DefineFiles( cPatEmpTmp() )

   if lInfo
      msginfo( ::cPath, "::cPath" )
      msginfo( "::DefineFiles( " + cEmpTmp() + " )" )
   end if

   if !Empty( oDbfTmp )
      oDbfTmp:Activate( .f., .f. )
   end if

   if lInfo
      msginfo( "oDbfTmp:Activate( .f., .f. )" )
   end if

   oDbfOld        := ::DefineFiles()
   //oDbfOld:IdxFDel()

   if lInfo
      msginfo( "::DefineFiles()" )
   end if

   if !Empty( oDbfOld )
      oDbfOld:Activate( .f., .f., , , , .t. )
   end if

   if lInfo
      msginfo( "oDbfOld:Activate( .f., .f., , , , .t. )" )
   end if

   while !oDbfOld:Eof()
      dbPass( oDbfOld:cAlias, oDbfTmp:cAlias, .t. )
      oDbfOld:Skip()
   end

   if lInfo
      msginfo( "dbPass( oDbfOld:cAlias, oDbfTmp:cAlias, .t. )" )
   end if

   oDbfTmp:Close()
   oDbfOld:Close()

   if lInfo
      msginfo( "oDbfOld:Close()" )
   end if

   if dbfErase( oDbfOld:cPath + GetFileNoExt( oDbfOld:cFile ) )
      if dbfRename( oDbfTmp:cPath + GetFileNoExt( oDbfTmp:cFile ), oDbfOld:cPath + GetFileNoExt( oDbfOld:cFile ) )
         dbfErase( oDbfTmp:cPath + GetFileNoExt( oDbfTmp:cFile ) )
      else
         MsgStop( "No se actualizo el fichero " + GetFileNoExt( oDbfOld:cFile ) + ".Dbf" )
      end if
   end if

   if lInfo
      msginfo( "dbfRename(" + oDbfTmp:cPath + GetFileNoExt( oDbfTmp:cFile ) )
      msginfo( "dbfErase( " + oDbfOld:cPath + GetFileNoExt( oDbfOld:cFile ) )
   end if

   RECOVER USING oError

      msgStop( ErrorMessage( oError ), "Imposible actualizar fichero a nueva estructura" )

   END SEQUENCE

   ErrorBlock( oBlock )

   if !Empty( oDbfTmp )
      oDbfTmp:Destroy()
   end if

   if !Empty( oDbfOld )
      oDbfOld:Destroy()
   end if

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD OpenService( lExclusive, cPath )

   local lOpen          := .t.
   local oError
   local oBlock

   DEFAULT  lExclusive  := .f.

   oBlock               := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      /*
      Definicion del master-------------------------------------------------------
      */

      if Empty( ::oDbf )
         ::oDbf         := ::DefineFiles( cPath )
      end if

      ::oDbf:Activate( .f., !( lExclusive ) )

   RECOVER USING oError

      lOpen             := .f.

      ::CloseService()

      msgStop( "Imposible abrir todas las bases de datos" + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD CloseService()

   if !Empty( ::oDbf )
      ::oDbf:End()
   end if 

   ::oDbf   := nil

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD lValid( oGet, oSay )

   local lVal  := .f.
   local xVal  := oGet:VarGet()

   ::oDbf:GetStatus( .t. )

   if ::oDbf:Seek( xVal )

      if oSay != nil
         oSay:cText( ::oDbf:FieldGet( 2 ) )
      end if

      lVal     := .t.

   end if

   ::oDbf:SetStatus()

RETURN ( lVal )

//---------------------------------------------------------------------------//

METHOD lLoadDivisa( cCodDiv )

   local lRet

   DEFAULT cCodDiv   := cDivEmp()

   if Empty( ::oDbfDiv )
      DATABASE NEW ::oDbfDiv PATH ( cPatDat() ) FILE "DIVISAS.DBF" VIA ( cDriver() ) SHARED INDEX "DIVISAS.CDX"
   end if

   if ::oDbfDiv:Seek( cCodDiv )

      ::cPinDiv   := RetPic( ::oDbfDiv:nNinDiv, ::oDbfDiv:nDinDiv )
      ::cPirDiv   := RetPic( ::oDbfDiv:nNinDiv, ::oDbfDiv:nRinDiv )
      ::cPouDiv   := RetPic( ::oDbfDiv:nNouDiv, ::oDbfDiv:nDouDiv )
      ::cPorDiv   := RetPic( ::oDbfDiv:nNouDiv, ::oDbfDiv:nRouDiv )
      ::nDinDiv   := ::oDbfDiv:nDinDiv
      ::nDirDiv   := ::oDbfDiv:nRinDiv
      ::nDouDiv   := ::oDbfDiv:nDouDiv
      ::nDorDiv   := ::oDbfDiv:nRouDiv
      ::nVdvDiv   := nDiv2Div( cCodDiv, cDivEmp(), ::oDbfDiv:cAlias )
      ::nRouDiv   := ::oDbfDiv:nRouDiv

      if ::oBandera != nil .and. ::oBmpDiv != nil
         ::oBmpDiv:Reload( ::oDbfDiv:cBndDiv )
      end if

      lRet        := .t.
   else
      MsgStop( "Divisa no encontrada " + cCodDiv  )
      lRet        := .f.
   end if

   ::cPicUnd      := MasUnd()

return ( lRet )

//----------------------------------------------------------------------------//

METHOD closeDivisa( cCodDiv )

   if !empty( ::oDbfDiv ) .and. ( ::oDbfDiv:used() )
      ::oDbfDiv:end()
   end if

   ::oDbfDiv   := nil

Return ( nil )

//----------------------------------------------------------------------------//

METHOD CheckFiles( cFileAppendFrom )

   if ::OpenService()
      if !Empty( cFileAppendFrom )
         ::AppendFrom( cFileAppendFrom )
      end if
      ::CloseService()
   end if

Return ( Self )

//---------------------------------------------------------------------------//

Method Play()

   if ::OpenFiles()
      ::Activate()
   else
      ::CloseFiles()
   end if

Return ( Self )

//---------------------------------------------------------------------------//