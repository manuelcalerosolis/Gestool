#include "FiveWin.Ch"
#include "Factu.ch" 
#include "MesDbf.ch"
#include "Font.ch"

static aObjBmps

//---------------------------------------------------------------------------//

CLASS TMasDet FROM TMant

   DATA  oParent

   DATA  oDbfVir

   DATA  cFirstKey

   DATA  cSerDoc
   DATA  cNumDoc
   DATA  cSufDoc

   DATA  aBmp

   DATA  aIva

   DATA  aGetVir

   DATA  oBrwDet

   DATA  bWhile

   DATA  bOnPreAppend, bOnPostAppend
   DATA  bOnPreEdit, bOnPostEdit
   DATA  bOnPreDelete, bOnPostDelete
   DATA  bOnPreSave, bOnPostSave
   DATA  bOnPreLoad, bOnPostLoad
   DATA  bDefaultValues

   DATA  bOnPreInsertDetail
   DATA  bOnPreAppendDetail, bOnPostAppendDetail
   DATA  bOnPreEditDetail, bOnPostEditDetail
   DATA  bOnPreDeleteDetail, bOnPostDeleteDetail
   DATA  bOnPreSaveDetail, bOnPostSaveDetail
   DATA  bOnPreLoadDetail, bOnPostLoadDetail

   // Datas para la selecion generica de registros

   DATA  oRadSelect
   DATA  nRadSelect     AS NUMERIC
   DATA  oChkSelect
   DATA  lChkSelect     AS LOGIC    INIT  .t.
   DATA  oChkUnSelect
   DATA  lChkUnSelect   AS LOGIC    INIT  .t.
   DATA  oDlgSelect
   DATA  oTreeSelect
   DATA  oMtrSelect
   DATA  cSerDocIni
   DATA  cSerDocFin
   DATA  nNumDocIni
   DATA  nNumDocFin
   DATA  cSufDocIni
   DATA  cSufDocFin

   DATA  oBtnCancel

   DATA  nLenDocIni

   DATA  lNumDocChr     AS LOGIC    INIT .f.

   DATA  lMoveDlgSelect AS LOGIC    INIT .f.

   DATA  cSerDocKey
   DATA  cNumDocKey
   DATA  cSufDocKey

   DATA  lAutoActions   AS LOGIC    INIT .t.

   DATA  lMinimize      AS LOGIC    INIT .f.

   DATA  lFecha         AS LOGIC    INIT .t.
   DATA  dFechaDesde    AS DATE     INIT CtoD( "01/01/" + Str( Year( Date() ) ) )
   DATA  dFechaHasta    AS DATE     INIT Date()

   METHOD NewDetail( cPath, oParent )

   METHOD Load()
   METHOD LoadAppend()        INLINE ( ::Load( .t. ) )
   METHOD Cancel()
   METHOD Save()

   METHOD LoadDetails()

   METHOD End()
   METHOD EndResource( nMode )

   METHOD Append()
   METHOD EndAppend()

   METHOD Dup()
   METHOD EndDup()

   METHOD Edit()
   METHOD EndEdit()

   METHOD Zoom()
   METHOD Del()

   METHOD Next( oBrw )
   METHOD Prior( oBrw )

   METHOD AppendDet()
   METHOD EditDet()
   METHOD ZoomDet()
   METHOD DeleteDet()
   METHOD DelDetail()
   METHOD MultiDeleteDet()
   METHOD DupDet()            VIRTUAL

   METHOD Detalle( nMode )    VIRTUAL

   METHOD StartSelect( cChkTitle )

   METHOD SelectRec( bAction, cDlgTitle, cChkTitle )

   METHOD EvalSelect( bAction )

   METHOD RollBack()

   METHOD SaveDetails()
   METHOD CancelDetails()
   METHOD DefineDetails()     VIRTUAL

   METHOD ReportDetails()

   METHOD GetNewCount()       VIRTUAL
   METHOD PutNewCount()       VIRTUAL

   METHOD GetFirstKey()       INLINE ( if( ::bFirstKey != nil, ::cFirstKey := Eval( ::bFirstKey, Self ), ) )

   METHOD OpenService( lExclusive, cPath )
   METHOD CloseService()

   METHOD CloseFiles()

   METHOD AddDetail( oDetail )

   METHOD Activate()

   METHOD oDefDiv( nId, nIdBmp, nIdChg, oDlg, nMode )

   METHOD OpenDetails()       INLINE ( aSend( ::oDbfDet, "OpenFiles()" ) )
   METHOD CloseDetails()      INLINE ( aSend( ::oDbfDet, "CloseFiles()" ) )

   METHOD nRegisterToProcess()

END CLASS

//---------------------------------------------------------------------------//

METHOD NewDetail( cPath, oParent ) CLASS TMasDet

   DEFAULT cPath        := cPatEmp()

   ::cPath              := cPath
   ::oParent            := oParent

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD Load( lAppend ) CLASS TMasDet

   DEFAULT lAppend   := .f.

   if Empty( ::oDbfVir )
      ::oDbfVir      := ::DefineFiles( cPatTmp(), cLocalDriver(), .t. )
   end if

   if !( ::oDbfVir:Used() )
      ::oDbfVir:Activate( .f., .f. )
   end if

   if ::oParent:cFirstKey != nil

      if ( lAppend ) .and. ::oDbf:Seek( ::oParent:cFirstKey )

         while !Empty( ::oDbf:OrdKeyVal() ) .and. ( ::oDbf:OrdKeyVal() <= ::oParent:cFirstKey ) .and. !::oDbf:Eof()

            if ::bOnPreLoad != nil
               Eval( ::bOnPreLoad, Self )
            end if

            ::oDbfVir:AppendFromObject( ::oDbf )

            if ::bOnPostLoad != nil
               Eval( ::bOnPostLoad, Self )
            end if

            ::oDbf:Skip()

         end while

      end if

   end if

   ::oDbfVir:GoTop()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD Save() CLASS TMasDet

   ::oDbfVir:OrdSetFocus( 0 )

   ::oDbfVir:GoTop()
   while !::oDbfVir:eof()

      if ::bOnPreSaveDetail != nil
         Eval( ::bOnPreSaveDetail, Self )
      end if

      ::oDbf:AppendFromObject( ::oDbfVir )

      /*
      if ::oDbf:Append()
         aEval( ::oDbf:aTField, {| oFld, n | ::oDbf:FldPut( n, ::oDbfVir:FldGet( n ) ) } )
         ::oDbf:Save()
      end if
      */

      if ::bOnPostSaveDetail != nil
         Eval( ::bOnPostSaveDetail, Self )
      endif

      ::oDbfVir:Skip()

   end while

   ::Cancel()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD Cancel() CLASS TMasDet

   local cFileName   := ::oDbfVir:cPath + ::oDbfVir:cName

   if !Empty( ::oDbfVir ) .and. ::oDbfVir:Used()
      ::oDbfVir:Zap()
      ::oDbfVir:End()
   end if

   dbfErase( cFileName )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD LoadDetails( lAppend ) CLASS TMasDet

   DEFAULT lAppend   := .f.

   CursorWait()

   ::GetFirstKey()

   if ::cFirstKey != nil

      do case
         case ValType( ::oDbfDet ) == "O"

            ::oDbfVir         := ::DefineDetails( cPatTmp(), cLocalDriver(), .t. )

            if ::oDbfVir != nil

               ::oDbfVir:Activate( .f., .f. )

               if !lAppend .and. ::bDefaultValues != nil
                  Eval( ::bDefaultValues, Self )
               end if

               if ( lAppend ) .and. ::oDbfDet:Seek( ::cFirstKey )

                  while !Empty( ::oDbfDet:OrdKeyVal() ) .and. ( ::oDbfDet:OrdKeyVal() <= ::cFirstKey ) .and. !::oDbfDet:Eof()

                     if ::bOnPreLoad != nil
                        Eval( ::bOnPreLoad, Self )
                     end if

                     ::oDbfVir:AppendFromObject( ::oDbfDet )

                     if ::bOnPostLoad != nil
                        Eval( ::bOnPostLoad, Self )
                     end if

                     ::oDbfDet:Skip()

                  end while

                  ::oDbfVir:GoTop()

               end if

            end if

         case ValType( ::oDbfDet ) == "A"

            if lAppend
               aSend( ::oDbfDet, "LoadAppend()" )
            else
               aSend( ::oDbfDet, "Load()" )
            end if

      end case

   end if

   CursorWE()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD RollBack() CLASS TMasDet

   ::GetFirstKey()

   if ::cFirstKey != nil

      do case
         case IsObject( ::oDbfDet )

            while ::oDbfDet:Seek( ::cFirstKey )

               if ::bOnPreDeleteDetail != nil
                  Eval( ::bOnPreDeleteDetail, Self )
               end if

               ::oDbfDet:Delete( .f. )

               if ::bOnPostDeleteDetail != nil
                  Eval( ::bOnPostDeleteDetail, Self )
               end if

            end while

         case IsArray( ::oDbfDet )

            aSend( ::oDbfDet, "RollBack()" )

         case IsNil( ::oDbfDet )

            if ::oParent:cFirstKey != nil

               while ::oDbf:Seek( ::oParent:cFirstKey )

                  if ::bOnPreDeleteDetail != nil
                     Eval( ::bOnPreDeleteDetail, Self )
                  end if

                  ::oDbf:Delete( .f. )

                  if ::bOnPostDeleteDetail != nil
                     Eval( ::bOnPostDeleteDetail, Self )
                  end if

               end while

            end if

      end case

   end if

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD SaveDetails() CLASS TMasDet

   local nOrd

   beginTransaction()

   do case
      case IsObject( ::oDbfDet )

         nOrd     := ::oDbfVir:OrdSetFocus( 0 )

         ::oDbfVir:GoTop()
         while !::oDbfVir:eof()

            if ::bOnPreSaveDetail != nil
               Eval( ::bOnPreSaveDetail, Self )
            end if

            ::oDbfDet:AppendFromObject( ::oDbfVir )

            if ::bOnPostSaveDetail != nil
               Eval( ::bOnPostSaveDetail, Self )
            endif

            ::oDbfVir:Skip()

         end while

      case IsArray( ::oDbfDet )

         aSend( ::oDbfDet, "Save()" ) 

   end case

   dbCommitAll()

   commitTransaction()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD CancelDetails() CLASS TMasDet

   local cFileName

   do case
      case IsObject( ::oDbfDet )

         cFileName   := ::oDbfVir:cPath + ::oDbfVir:cName

         if !Empty( ::oDbfVir ) .and. ::oDbfVir:Used()
            ::oDbfVir:Zap()
            ::oDbfVir:End()
         end if

         dbfErase( cFileName )

      case IsArray( ::oDbfDet )

         aSend( ::oDbfDet, "Cancel()" )

   end case

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD OpenService( lExclusive, cPath ) CLASS TMasDet

   local lOpen          := .t.
   local oError
   local oBlock         := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   DEFAULT lExclusive   := .f.

   BEGIN SEQUENCE

      if Empty( ::oDbf )
         ::oDbf         := ::DefineFiles( cPath )
      end if

      ::oDbf:Activate( .f., !( lExclusive ) )

   RECOVER USING oError

      lOpen             := .f.

      msgStop( ErrorMessage( oError ), "Imposible abrir todas las bases de datos" )

      ::CloseService()

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD CloseService() CLASS TMasDet

   if !Empty( ::oDbf ) .and. ::oDbf:Used()
      ::oDbf:End()
   end if

   ::oDbf            := nil

RETURN ( .t. )

//----------------------------------------------------------------------------//

METHOD ReportDetails() CLASS TMasDet

   local n
   local aPrompt     := {}
   local aoCols      := {}
   local oDbfDet

   ::oDbf:GetStatus()

   do case
      case ValType( ::oDbfDet ) == "O"
         oDbfDet     := ::oDbfDet
         ::oDbfDet:GetStatus()
      case ValType( ::oDbfDet ) == "A"
         oDbfDet     := ::oDbfDet[ 1 ]:oDbf
         aSend( ::oDbfDet, "GetStatus()" )
   end case

   /*
   Creamos todas las columnas--------------------------------------------------
   */

   for n := 1 to oDbfDet:FCount()

      if !oDbfDet:aTField[ n ]:lCalculate

         aAdd( aoCols, {   oDbfDet:aTField[ n ]:cName,;
                           oDbfDet:aTField[ n ]:cType,;
                           oDbfDet:aTField[ n ]:nLen,;
                           oDbfDet:aTField[ n ]:nDec,;
                           oDbfDet:aTField[ n ]:cPict,;
                           SubStr( oDbfDet:aTField[ n ]:cComment, 1, oDbfDet:aTField[ n ]:nLen + oDbfDet:aTField[ n ]:nDec ),;
                           !oDbfDet:aTField[ n ]:lHide,;
                           oDbfDet:aTField[ n ]:cComment,;
                           oDbfDet:aTField[ n ]:nLen + oDbfDet:aTField[ n ]:nDec } )

      endif

   next

   for n := 1 to len( oDbfDet:aTIndex )
      aAdd( aPrompt, { oDbfDet:aTIndex[ n ]:cComment } )
   next

   ::oReport            := TInfGen():New( ::oDbf:cComment, aoCols )

   ::oReport:lDefDivInf := .f.
   ::oReport:lDefSerInf := .f.
   ::oReport:lDefFecInf := .f.

   ::oReport:oParent    := Self
   ::oReport:oDbfMai    := ::oDbf
   ::oReport:oDbfDet    := oDbfDet

   ::oReport:AddTmpIndex( "cName", oDbfDet:OrdKey(), "!Deleted()" )

   ::oReport:AddGroup( {|| ::oReport:oDbfMai:OrdKeyVal() }, {|| "Grupo : " + ::oReport:oDbfMai:OrdKeyVal() } )

   ::oReport:StdResource()
   ::oReport:oDefDesHas()

   ::oReport:Activate()
   ::oReport:End()

   do case
      case ValType( ::oDbfDet ) == "O"
         ::oDbfDet:SetStatus()

      case ValType( ::oDbfDet ) == "A"
         aSend( ::oDbfDet, "SetStatus()" )

   end case

   ::oDbf:SetStatus()

RETURN NIL

//---------------------------------------------------------------------------//

METHOD Append( oBrw ) CLASS TMasDet

   local lAppend
   local lTrigger

   if ::lMinimize
      if( ::oWndBrw != nil, ::oWndBrw:Minimize(), )
   end if

   if ::bOnPreAppend != nil
      lTrigger := Eval( ::bOnPreAppend, Self )
      if Valtype( lTrigger ) == "L" .and. !lTrigger
         return .f.
      end if
   end if

   ::nMode        := APPD_MODE

   ::oDbf:Blank()
   ::oDbf:SetDefault()

   ::LoadDetails( .t. )

   lAppend       := ::Resource( 1 )

   if ::lAutoActions
      ::EndAppend( lAppend )
   end if

   if ::lMinimize
      if( ::oWndBrw != nil, ( ::oWndBrw:Maximize(), ::oWndBrw:Refresh() ), )
   end if

   if lAppend .and. !Empty( oBrw )
      oBrw:Refresh()
   end if

   if ::bOnPostAppend != nil
      Eval( ::bOnPostAppend, Self )
   end if

return ( lAppend )

//---------------------------------------------------------------------------//

Method EndAppend( lAppend )

   if lAppend

      ::GetNewCount()

      ::oDbf:Insert()

      ::SaveDetails( APPD_MODE )

      if( ::oWndBrw != nil, ::oWndBrw:Refresh(), )

   else

      ::oDbf:Cancel()

      if( ::oWndBrw != nil, ::oWndBrw:Refresh(), )

   end if

   ::CancelDetails()

return ( lAppend )

//---------------------------------------------------------------------------//

METHOD Edit( oBrw ) CLASS TMasDet

   local lEdit
   local lTrigger

   if ::oDbf:OrdKeyCount() == 0
      return .f.
   end if

   if ::lMinimize
      if ( ::oWndBrw != nil, ::oWndBrw:Minimize(), )
   end if

   if ::oDbf:RecLock()

      if ::bOnPreEdit != nil
         lTrigger    := Eval( ::bOnPreEdit, Self )
         if Valtype( lTrigger ) == "L" .and. !lTrigger
            ::oDbf:UnLock()
            return .f.
         end if
      end if

      ::oDbf:Load( .f. )

      ::LoadDetails( .t. )

      lEdit          := ::Resource( 2 )

      if ::lAutoActions
         ::EndEdit( lEdit )
      end if

      if lEdit .and. !Empty( oBrw )
         oBrw:Refresh()
      end if

      if ::bOnPostEdit != nil
         lTrigger    := Eval( ::bOnPostEdit, Self )
      end if

      ::oDbf:UnLock()

   end if

   if ::lMinimize
      if ( ::oWndBrw != nil, ::oWndBrw:Maximize(), )
   end if

   if ( ::oWndBrw != nil, ::oWndBrw:Refresh(), )

RETURN ( .t. )

//---------------------------------------------------------------------------//

Method EndEdit( lEdit )

   if lEdit

      ::RollBack()

      ::oDbf:Save( .f. )

      ::SaveDetails( EDIT_MODE )

   else

      ::oDbf:Cancel()

   end if

   ::CancelDetails()

Return ( lEdit )

//---------------------------------------------------------------------------//

METHOD Zoom( oBrw ) CLASS TMasDet

   ::GetFirstKey()

   if ::oDbf:RecLock()

      ::oDbf:Load()

      ::LoadDetails( .t. )

      ::Resource( 3 )

      ::CancelDetails()

      ::oDbf:Cancel()

      ::oDbf:UnLock()

   end if

   if !Empty( oBrw )
      oBrw:Refresh()
   end if

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD Del( lHead, lDetail ) CLASS TMasDet

   local nRec 
   local cTxt
   local lDel        := .f.
   local nMarked
   local lTrigger

   DEFAULT lHead     := .t.
   DEFAULT lDetail   := .t.

   if ::bOnPreDelete != nil
      lTrigger       := Eval( ::bOnPreDelete, Self )
      if IsLogic( lTrigger ) .and. !lTrigger
         return .f.
      end if
   end if

   if !empty( ::oWndBrw ) .and. !empty( ::oWndBrw:oBrw ) .and. ( "XBROWSE" $ ::oWndBrw:oBrw:ClassName() ) .and. ( len( ::oWndBrw:oBrw:aSelected ) > 1 )

      cTxt           := "¿ Desea eliminar definitivamente " + AllTrim( Trans( len( ::oWndBrw:oBrw:aSelected ), "999999" ) ) + " registros ?"

      if oUser():lNotConfirmDelete() .or. ApoloMsgNoYes( cTxt, "Confirme supresión" )

         CursorWait()

         for each nRec in ( ::oWndBrw:oBrw:aSelected )

            ::oDbf:GoTo( nRec ) 

            if lDetail
               ::RollBack()
            end if

            if lHead
               ::oDbf:Delete()
            end if

            lDel     := .t.

         next

         CursorWE()

      end if

   else
   
      if oUser():lNotConfirmDelete() .or. apoloMsgNoYes("¿Desea eliminar el registro en curso?", "Confirme supresión" )
   
         CursorWait()

         if lDetail
            ::RollBack()
         end if
   
         if lHead
            ::oDbf:Delete()
         end if
   
         lDel     := .t.
   
         CursorWE()
   
      end if
   
      if ::bOnPostDelete != nil
         return Eval( ::bOnPostDelete, Self )
      end if

   end if 

RETURN ( lDel )

//---------------------------------------------------------------------------//

METHOD Dup( oBrw ) CLASS TMasDet

   local lAppend
   local lTrigger

   if ::bOnPreAppend != nil
      lTrigger := Eval( ::bOnPreAppend, Self )
      if Valtype( lTrigger ) == "L" .and. !lTrigger
         return .f.
      end if
   end if

   ::oDbf:Load()

   ::LoadDetails( .t. )

   lAppend       := ::Resource( 1 )

   if ::lAutoActions
      ::EndDup( lAppend )
   end if

   if lAppend .and. !Empty( oBrw )
      oBrw:Refresh()
   end if

   if ::bOnPostAppend != nil
      return ( Eval( ::bOnPostAppend, Self ) )
   end if

RETURN ( lAppend )

//---------------------------------------------------------------------------//

Method EndDup( lAppend )

   if lAppend

      ::GetNewCount()

      ::oDbf:Insert()

      ::SaveDetails( APPD_MODE )

      if( ::oWndBrw != nil, ::oWndBrw:Refresh(), )

   else

      ::oDbf:Cancel()

      if( ::oWndBrw != nil, ::oWndBrw:Refresh(), )

   end if

   ::CancelDetails()

RETURN ( lAppend )

//---------------------------------------------------------------------------//

METHOD Next( nMode, oBrw ) CLASS TMasDet

   local nRecno
   local lTrigger

   if ::oDbf:OrdKeyCount() == 0
      return .f.
   end if

   nRecno      := ::oDbf:Recno()

   /*
   Guardamos el registro-------------------------------------------------------
   */

   ::RollBack()

   ::oDbf:Save()

   ::SaveDetails( EDIT_MODE )

   ::oDbf:UnLock()

   ::oDbf:Next()

   if !::oDbf:Eof()

      if ::oDbf:RecLock()

         if ::bOnPreEdit != nil

            lTrigger    := Eval( ::bOnPreEdit, Self )
            if IsLogic( lTrigger ) .and. !lTrigger
               ::oDbf:UnLock()
               return .f.
            end if

         end if

         ::oDbf:Load()

         ::LoadDetails( .t. )

      end if

   else

      ::oDbf:GoTo( nRecno )

      RETURN ( .f. )

   end if

   if ( ::oWndBrw != nil, ::oWndBrw:Refresh(), )

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD Prior( nMode, oBrw ) CLASS TMasDet

   local nRecno
   local lTrigger

   if ::oDbf:OrdKeyCount() == 0
      return .f.
   end if

   nRecno      := ::oDbf:Recno()

   /*
   Guardamos el registro-------------------------------------------------------
   */

   ::RollBack()

   ::oDbf:Save()

   ::SaveDetails( EDIT_MODE )

   ::oDbf:UnLock()

   ::oDbf:Prior()

   if !::oDbf:Bof()

      if ::oDbf:RecLock()

         if ::bOnPreEdit != nil

            lTrigger    := Eval( ::bOnPreEdit, Self )
            if IsLogic( lTrigger ) .and. !lTrigger
               ::oDbf:UnLock()
               return .f.
            end if

         end if

         ::oDbf:Load()

         ::LoadDetails( .t. )

      end if

   else

      ::oDbf:GoTo( nRecno )

      RETURN ( .f. )

   end if

   if ( ::oWndBrw != nil, ::oWndBrw:Refresh(), )

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD AppendDet() CLASS TMasDet

   local lTrigger

   while .t.

      if ::bOnPreAppendDetail != nil
         lTrigger := Eval( ::bOnPreAppendDetail, Self )
         if Valtype( lTrigger ) == "L" .and. !lTrigger
            return .f.
         end if
      end if

      ::oDbfVir:Blank()

      if ::Detalle( 1 )

         ::oDbfVir:Insert()

         if ::oBrwDet != nil
            ::oBrwDet:Refresh()
         end if

         if ::bOnPostAppendDetail != nil
            Eval( ::bOnPostAppendDetail, Self )
         end if

         if lEntCon()
            loop
         else
            exit
         end if

      else

         ::oDbfVir:Cancel()

         if ::oBrwDet != nil
            ::oBrwDet:Refresh()
         end if

         exit

      end if

   end while

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD EditDet() CLASS TMasDet

   if ::oDbfVir:Recno() == 0
      Return ( Self )
   end if

   ::oDbfVir:Load()

   if ::Detalle( 2 )

      ::oDbfVir:Save()

      if ::bOnPostEditDetail != nil
         Eval( ::bOnPostEditDetail, Self )
      end if

   else

      ::oDbfVir:Cancel()

   end if

   if( ::oBrwDet != nil, ::oBrwDet:Refresh(), )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD ZoomDet() CLASS TMasDet

   if ::oDbfVir:Recno() == 0
      Return ( Self )
   end if

   ::oDbfVir:Load()
   ::Detalle( 3 )
   ::oDbfVir:Cancel()

Return ( Self )

//---------------------------------------------------------------------------//

METHOD DeleteDet( lMessage ) CLASS TMasDet

   DEFAULT lMessage  := .t.

   if ::oDbfVir:Recno() == 0
      RETURN ( Self )
   end if

   if oUser():lNotConfirmDelete() .or. if( lMessage, ApoloMsgNoYes("¿ Desea eliminar definitivamente este registro ?", "Confirme supersión" ), .t. )

      ::oDbfVir:Delete( .t. )

      if ::bOnPostDeleteDetail != nil
         Eval( ::bOnPostDeleteDetail, Self )
      end if

      if( ::oBrwDet != nil, ::oBrwDet:Refresh(), )

   end if

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD MultiDeleteDet() CLASS TMasDet

   local nSelected
   local aSelected  := ::oBrwDet:aSelected

   if oUser():lNotConfirmDelete() .or. ;
      ApoloMsgNoYes( "¿ Desea eliminar definitivamente " + alltrim( str( len( aSelected ) ) ) + " registro(s) ?", "Confirme supersión" )

      for each nSelected in aSelected
         ::oDbfVir:GoTo( nSelected )
         ::DeleteDet( .f. )
      next

   end if 

Return ( self )

//---------------------------------------------------------------------------//

METHOD DelDetail() CLASS TMasDet

   if ::oDbfVir:Recno() == 0
      Return ( Self )
   end if

   if ::cFirstKey != nil

      while ::oDbfVir:Seek( ::cFirstKey )

         ::oDbfVir:Delete( .f. )

         if ::bOnPostDeleteDetail != nil
            Eval( ::bOnPostDeleteDetail, Self )
         end if

      end while

   end if

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD SelectRec( bAction, cDlgTitle, cChkTitle, lClose ) CLASS TMasDet

   local oSerDocIni
   local oNumDocIni
   local oSufDocIni
   local oBtnDocIni
   local oSerDocFin
   local oNumDocFin
   local oSufDocFin
   local oBtnDocFin
   local nMtrInf     := 0
   local cPicture    := "999999999"
   local oImageList

   DEFAULT bAction   := {|| msgStop( "bAction no pasado" ) }
   DEFAULT cDlgTitle := ""
   DEFAULT cChkTitle := ""
   DEFAULT lClose    := .f.

   if !Empty( ::oWndBrw:oBrw ) .and. len( ::oWndBrw:oBrw:aSelected ) > 1
      ::nRadSelect   := 1
   else
      ::nRadSelect   := 2
   end if

   oImageList        := TImageList():New( 16, 16 )
   oImageList:AddMasked( TBitmap():Define( "bRed" ), Rgb( 255, 0, 255 ) )
   oImageList:AddMasked( TBitmap():Define( "bGreen" ), Rgb( 255, 0, 255 ) )

   if ::cSerDocKey != nil
      ::cSerDocIni   := ::cSerDocFin   := ::oDbf:FieldGetName( ::cSerDocKey )
   end if

   ::nNumDocIni      := ::nNumDocFin   := ::oDbf:FieldGetName( ::cNumDocKey )
   ::cSufDocIni      := ::cSufDocFin   := ::oDbf:FieldGetName( ::cSufDocKey )

   if ValType( ::nNumDocIni ) == "C"
      ::lNumDocChr   := .t.
      ::nLenDocIni   := Len( ::nNumDocIni )
      ::nNumDocIni   := Val( Trans( ::nNumDocIni, cPicture ) )
      ::nNumDocFin   := Val( Trans( ::nNumDocFin, cPicture ) )
   else
      ::nLenDocIni   := Len( Str( ::nNumDocIni ) )
   end if

   cPicture          := Replicate( "9", ::nLenDocIni )

   DEFINE DIALOG ::oDlgSelect RESOURCE "SelectRango" TITLE cDlgTitle

   REDEFINE RADIO ::oRadSelect VAR ::nRadSelect ;
      ID       80, 81 ;
      OF       ::oDlgSelect

   REDEFINE GET oSerDocIni VAR ::cSerDocIni ;
      ID       100 ;
      PICTURE  "@!" ;
      SPINNER ;
      ON UP    ( UpSerie( oSerDocIni ) );
      ON DOWN  ( DwSerie( oSerDocIni ) );
      VALID    ( ::cSerDocIni >= "A" .and. ::cSerDocIni <= "Z"  );
      WHEN     ( ::nRadSelect == 2 ) ;
      OF       ::oDlgSelect

   REDEFINE BTNBMP oBtnDocIni ;
      ID       101 ;
      OF       ::oDlgSelect ;
      RESOURCE "Up16" ;
      NOBORDER ;

   oBtnDocIni:bAction   := {|| dbFirst( ::oDbf:cAlias, ::cNumDocKey, oNumDocIni, ::cSerDocIni ) }

   REDEFINE GET oNumDocIni VAR ::nNumDocIni ;
      ID       120 ;
      PICTURE  cPicture ;
      SPINNER ;
      WHEN     ( ::nRadSelect == 2 ) ;
      OF       ::oDlgSelect

   REDEFINE BTNBMP oBtnDocFin ;
      ID       111 ;
      OF       ::oDlgSelect ;
      RESOURCE "Down16" ;
      NOBORDER ;

   oBtnDocFin:bAction   := {|| dbLast( ::oDbf:cAlias, ::cNumDocKey, oNumDocFin, ::cSerDocFin ) }

   REDEFINE GET oSufDocIni VAR ::cSufDocIni ;
      ID       140 ;
      WHEN     ( ::nRadSelect == 2 ) ;
      OF       ::oDlgSelect

   REDEFINE GET oSerDocFin VAR ::cSerDocFin ;
      ID       110 ;
      PICTURE  "@!" ;
      SPINNER ;
      ON UP    ( UpSerie( oSerDocFin ) );
      ON DOWN  ( DwSerie( oSerDocFin ) );
      WHEN     ( ::nRadSelect == 2 ) ;
      VALID    ( ::cSerDocFin >= "A" .and. ::cSerDocFin <= "Z"  );
      OF       ::oDlgSelect

   REDEFINE GET oNumDocFin VAR ::nNumDocFin ;
      ID       130 ;
      PICTURE  cPicture ;
      SPINNER ;
      WHEN     ( ::nRadSelect == 2 ) ;
      OF       ::oDlgSelect

   REDEFINE GET oSufDocFin VAR ::cSufDocFin ;
      ID       150 ;
      WHEN     ( ::nRadSelect == 2 ) ;
      OF       ::oDlgSelect

   /*
   Rango de fechas-------------------------------------------------------------
   */

   REDEFINE CHECKBOX ::lFecha ;
      ID       300 ;
      OF       ::oDlgSelect

   REDEFINE GET ::dFechaDesde ;
      ID       310 ;
      WHEN     ( !::lFecha ) ;
      SPINNER ;
      OF       ::oDlgSelect

   REDEFINE GET ::dFechaHasta ;
      ID       320 ;
      WHEN     ( !::lFecha ) ;
      SPINNER ;
      OF       ::oDlgSelect

   REDEFINE CHECKBOX ::oChkSelect VAR ::lChkSelect;
      ID       160 ;
      OF       ::oDlgSelect

   REDEFINE CHECKBOX ::oChkUnSelect VAR ::lChkUnSelect;
      ID       180 ;
      OF       ::oDlgSelect

   ::oTreeSelect  := TTreeView():Redefine( 170, ::oDlgSelect )

   REDEFINE BUTTON ;
      ID       IDOK ;
      OF       ::oDlgSelect ;
      ACTION   ( ::EvalSelect( bAction, ::oMtrSelect ), if( lClose, ::oDlgSelect:end(), if( !Empty( ::oWndBrw:oBrw ), ::oWndBrw:oBrw:Refresh(), ) ) )

   REDEFINE BUTTON ::oBtnCancel ;
      ID       IDCANCEL ;
      OF       ::oDlgSelect ;
      ACTION   ( ::oDlgSelect:end() )

   REDEFINE APOLOMETER ::oMtrSelect ;
      VAR      nMtrInf ;
      PROMPT   "Proceso" ;
      ID       200;
      TOTAL    ::oDbf:LastRec() ;
      OF       ::oDlgSelect

   ::oDlgSelect:AddFastKey( VK_F5, {|| ::EvalSelect( bAction, ::oMtrSelect ), if( lClose, ::oDlgSelect:end(), if( !Empty( ::oWndBrw:oBrw ), ::oWndBrw:oBrw:Refresh(), ) ) } )

   ::oDlgSelect:bStart := {|| ::StartSelect( cChkTitle, oSerDocIni, oSerDocFin, oImageList ), ::oTreeSelect:SetImageList( oImageList ) }

   ACTIVATE DIALOG ::oDlgSelect CENTER

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD StartSelect( cChkTitle, oSerDocIni, oSerDocFin, oImageList ) CLASS TMasDet

   ::oTreeSelect:SetImageList( oImageList )

   if Empty( cChkTitle )
      ::oChkSelect:Hide()
   else
      SetWindowText( ::oChkSelect:hWnd, cChkTitle )
      ::oChkSelect:Refresh()
   end if

   ::oChkUnSelect:Hide()

   if Empty( ::cSerDocKey )
      oSerDocIni:Hide()
      oSerDocFin:Hide()
   end if

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD EvalSelect( bAction ) CLASS TMasDet

   local nPos
   local aPos
   local cSeek
   local bCond
   local lWhile   := .t.
   local lresult

   /*
   Preparamos la pantalla para mostrar la simulación---------------------------
   */

   if ::lMoveDlgSelect
      aPos        := { 0, 0 }
      ClientToScreen( ::oDlgSelect:hWnd, aPos )
      ::oDlgSelect:Move( aPos[ 1 ] - 26, aPos[ 2 ] - 510 )
   end if

   ::oDbf:GetStatus()

   ::oDlgSelect:Disable()

   ::oTreeSelect:Enable()
   ::oTreeSelect:DeleteAll()

   ::oBtnCancel:bAction := {|| lWhile := .f. }
   ::oBtnCancel:Enable()

   if ::nRadSelect == 1

      for each nPos in ( ::oWndBrw:oBrw:aSelected )

         ::oDbf:GoTo( nPos )

         Eval( bAction, ::lChkSelect )

         ::oMtrSelect:Set( ::oDbf:OrdKeyNo() )

         SysRefresh()

         if !lWhile
            exit
         end if

      next

      ::oMtrSelect:Set( ::oDbf:LastRec() )

   else

      /*
      Vamos a ver si tiene numero de serie
      */

      if ::cSerDocKey == nil

         cSeek       := Str( ::nNumDocIni, ::nLenDocIni ) + ::cSufDocIni

         /*
         El campo es de tipo caracter
         */

         if ::lNumDocChr

            bCond    := {||   ::oDbf:FieldGetName( ::cNumDocKey ) + ::oDbf:FieldGetName( ::cSufDocKey ) >= Str( ::nNumDocIni, ::nLenDocIni ) + ::cSufDocIni .and.;
                              ::oDbf:FieldGetName( ::cNumDocKey ) + ::oDbf:FieldGetName( ::cSufDocKey ) <= Str( ::nNumDocFin, ::nLenDocIni ) + ::cSufDocFin }

         else

            bCond    := {||   Str( ::oDbf:FieldGetName( ::cNumDocKey ), ::nLenDocIni ) + ::oDbf:FieldGetName( ::cSufDocKey ) >= Str( ::nNumDocIni, ::nLenDocIni ) + ::cSufDocIni .and.;
                              Str( ::oDbf:FieldGetName( ::cNumDocKey ), ::nLenDocIni ) + ::oDbf:FieldGetName( ::cSufDocKey ) <= Str( ::nNumDocFin, ::nLenDocIni ) + ::cSufDocFin .and.;
                              !::oDbf:Eof() }

         end if

      else

         cSeek       := ::cSerDocIni + Str( ::nNumDocIni, ::nLenDocIni ) + ::cSufDocIni
         bCond       := {|| ::oDbf:FieldGetName( ::cSerDocKey ) + Str( ::oDbf:FieldGetName( ::cNumDocKey ), ::nLenDocIni ) + ::oDbf:FieldGetName( ::cSufDocKey ) >= Str( ::nNumDocIni, ::nLenDocIni ) + ::cSufDocIni .and.;
                            ::oDbf:FieldGetName( ::cSerDocKey ) + Str( ::oDbf:FieldGetName( ::cNumDocKey ), ::nLenDocIni ) + ::oDbf:FieldGetName( ::cSufDocKey ) <= Str( ::nNumDocFin, ::nLenDocIni ) + ::cSufDocFin }

      end if

      lResult        := ::oDbf:Seek( cSeek, .t. )

      ::oMtrSelect:Set( ::oDbf:OrdKeyNo() )

      while ( lWhile ) .and. Eval( bCond ) .and. !::oDbf:eof()

         Eval( bAction, ::lChkSelect )

         ::oDbf:Skip()

         ::oMtrSelect:Set( ::oDbf:OrdKeyNo() )

      end while

      ::oMtrSelect:Set( ::oDbf:LastRec() )

   end if

   ::oDbf:SetStatus()

   ::oBtnCancel:bAction := {|| ::oDlgSelect:End() }

   if ::lMoveDlgSelect
      WndCenter( ::oDlgSelect:hWnd )
   end if

   ::oDlgSelect:Enable()

RETURN NIL

//---------------------------------------------------------------------------//

METHOD AddDetail( oDetail ) CLASS TMasDet

   if ::oDbfDet == nil
      ::oDbfDet   := {}
   end if

   aAdd( ::oDbfDet, oDetail )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD Activate() CLASS TMasDet

   if nAnd( ::nLevel, 1 ) == 0

      /*
      Cerramos todas las ventanas
      */

      if ::oWndParent != nil
         ::oWndParent:CloseAll()
      end if

      if Empty( ::oDbf )
         if !::OpenFiles()
            return nil
         end if
      end if

      /*
      Creamos el Shell
      */

      if !::lCreateShell
         ::CreateShell( ::nLevel )
      end if

      if ::lAutoButtons
         ::oWndBrw:AutoButtons( Self )
      end if

      if ::cHtmlHelp != nil
         ::oWndBrw:cHtmlHelp  := ::cHtmlHelp
      end if

      ::oWndBrw:Activate(  nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, {|| ::CloseFiles() } )

   else

      msgStop( "Acceso no permitido." )

   end if

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD oDefDiv( nId, nIdBmp, nIdChg, oDlg, nMode ) CLASS TMasDet

   local oCodDiv
   local oVdvDiv

   local This        := Self

   DEFAULT nId       := 1130
   DEFAULT nIdBmp    := 1131
   DEFAULT nIdChg    := 1132
   DEFAULT oDlg      := ::oFld:aDialogs[1]
   DEFAULT nMode     := APPD_MODE

   if Empty( ::oDbfDiv )
      DATABASE NEW ::oDbfDiv PATH ( cPatDat() ) FILE "DIVISAS.DBF" VIA ( cDriver() ) SHARED INDEX "DIVISAS.CDX"
   end if

   if Empty( ::oBandera )
      ::oBandera     := TBandera():New()
   end if

   if Empty( ::oDbf:cCodDiv )
      ::oDbf:cCodDiv := cDivEmp()
   end if

   REDEFINE GET oCodDiv VAR ::oDbf:cCodDiv ;
		PICTURE  "@!";
      ID       ( nId );
      BITMAP   "LUPA" ;
      WHEN     ( nMode == APPD_MODE ) ;
      VALID    ( This:lLoadDivisa() ) ;
      ON HELP  ( BrwDiv( oCodDiv, This:oBmpDiv, oVdvDiv, This:oDbfDiv:cAlias, This:oBandera ), This:lLoadDivisa() );
      OF       oDlg

   REDEFINE BITMAP ::oBmpDiv ;
      RESOURCE "BAN_EURO" ;
      ID       ( nIdBmp ) ;
      OF       oDlg

   REDEFINE GET oVdvDiv VAR ::oDbf:nVdvDiv ;
      WHEN     ( .f. ) ;
      ID       ( nIdChg ) ;
      PICTURE  "@E 999,999.9999" ;
      OF       oDlg

   ::lLoadDivisa()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD CloseFiles() CLASS TMasDet

   if !Empty( ::oDbf ) .and. ::oDbf:Used()
      ::oDbf:End()
   end if

   if isArray( ::oDbfDet )
      aSend( ::oDbfDet, "End()" )
   else
      if !Empty( ::oDbfDet ) .and. ::oDbfDet:Used()
         ::oDbfDet:End()
      end if
   end if

RETURN ( .t. )

//----------------------------------------------------------------------------//

METHOD End() CLASS TMasDet

   if ::oDbfDiv != nil .and. ::oDbfDiv:Used()
      ::oDbfDiv:End()
      ::oDbfDiv   := nil
   end if

   if ::oBandera != nil
      ::oBandera:End()
   end if

   ::Super:End()

RETURN ( .t. )

//--------------------------------------------------------------------------//

METHOD EndResource( lOk, nMode, oDlg )

   if !Empty( oDlg )
      oDlg:Disable()
   end if

   do case
      case nMode == APPD_MODE
         ::EndAppend( lOk )

      case nMode == DUPL_MODE
         ::EndDup( lOk )

      case nMode == EDIT_MODE
         ::EndEdit( lOk )

   end case

   if !Empty( oDlg )
      oDlg:Enable()
   end if

Return ( lOk )

//--------------------------------------------------------------------------//

METHOD nRegisterToProcess()

   local nRegisterToProcess   := 0

   do case
      case IsObject( ::oDbfDet )
         nRegisterToProcess   += ::oDbfDet:nRegisterLoaded
         nRegisterToProcess   += ::oDbfVir:LastRec()

      case IsArray( ::oDbfDet )
         aEval( ::oDbfDet, {|o| nRegisterToProcess += o:nRegisterLoaded } )
         aEval( ::oDbfDet, {|o| nRegisterToProcess += o:oDbfVir:LastRec() } )

   end case

RETURN ( nRegisterToProcess )

//---------------------------------------------------------------------------//

function oCopy( oDbfOrg, oDbfDes, lApp )

	local i
   local nField   := oDbfOrg:FCount()

	DEFAULT lApp	:= .f.

   if lApp
      ( oDbfOrg:nArea )->( dbAppend() )
   else
      ( oDbfDes:nArea )->( dbRLock() )
   end if

	for i = 1 to nField
      ( oDbfDes:nArea )->( FieldPut( i, ( oDbfOrg )->( FieldGet( i ) ) ) )
	next

RETURN NIL

//---------------------------------------------------------------------------//

function ObjInspect( oObject, cTitle )

   local oIco
   local oBrw
   local oWndObj
   local aObjInfo
   local nItem       := 1

   CursorWait()

   DEFAULT  aObjBmps := {  "Array"    ,;
                           "Block"    ,;
                           "Chain"    ,;
                           "Date"     ,;
                           "Logic"    ,;
                           "Number"   ,;
                           "Memo"     ,;
                           "Object"   ,;
                           "Undefined",;
                           "SmallBug" ,;
                           "NoInfo"   }

   if ValType( oObject ) == "O"
      aObjInfo = aOData( oObject )
      // Let's give the Data Names the 'hungarian notation' look
      AEval( aObjInfo, { | cData, n | aObjInfo[ n ] := cChr2Data( cData ) } )
   endif

   DEFAULT cTitle := If( ValType( oObject ) == "O",;
                         "Object Inspector",;
                         "Array Inspector" )

   DEFINE ICON oIco RESOURCE "Objects"

   DEFINE WINDOW oWndObj FROM 1, 1 TO 23, 33 ;
      TITLE If( ValType( oObject ) == "O", "Object Inspector: ",;
                "Array Inspector: " ) + cTitle ;
      MDICHILD OF oWnd() ;
      ICON oIco

   @ 0, 0 LISTBOX oBrw FIELDS "" ;
      HEADERS "  ", "Data", "Value" ;
      FIELDSIZES 16, 90, 300 ;
      OF oWndObj ;
      SIZE 400, 400 ;
      ON DBLCLICK DataInspect( oObject, nItem, aObjInfo, cTitle )

   oBrw:bLine = { || aGetData( oObject, nItem, aObjInfo, cTitle ) }

   // Browsing an Array using FiveWin a TWBrowse Object !

   oBrw:bGoTop    = { || nItem := 1 }
   oBrw:bGoBottom = { || nItem := Eval( oBrw:bLogicLen ) }

   oBrw:bSkip     = { | nWant, nOld | nOld := nItem, nItem += nWant,;
                        nItem := Max( 1, Min( nItem, Eval( oBrw:bLogicLen ) ) ),;
                        nItem - nOld }

   oBrw:bLogicLen = { || If( ValType( oObject ) == "O", Len( aObjInfo ),;
                             Len( oObject ) ) }
   oBrw:cAlias    = "Array"  // We need a non empty cAlias !

   oWndObj:SetControl( oBrw )

   ACTIVATE WINDOW oWndObj

return nil

//----------------------------------------------------------------------------//

static function cGetData( uData, cType )

   local cResult := ""

   do case
      case cType == "B"
           cResult = "{ || ... }"

      case cType == "A"
           cResult = "[ ... ]"

      case cType == "O"
           cResult = "Object"

      case cType == "U"
           cResult = "Undefined"

      otherwise
           cResult = cValToChar( uData )
   endcase

return cResult

//----------------------------------------------------------------------------//

static function DataInspect( oObject, nItem, aObjInfo, cTitle )

   local cType := ValType( oObject )
   local cData, uData

   do case
      case cType == "A"
           cData = "[ " + AllTrim( Str( nItem ) ) + " ]"
           if Len( oObject[ nItem ] ) > 0
              ObjInspect( oObject[ nItem ], cTitle + cData )
           else
              MsgInfo( "Array is empty!", "Attention" )
           endif

      case cType == "O"
           cData = aObjInfo[ nItem ]
           uData = OSend( oObject, cData )
           if ValType( uData ) $ "AO"
              ObjInspect( OSend( oObject, cData ), cTitle + ":" + cData )
           else
              MsgInfo( "I don't find an Object or an Array there!", "Attention" )
           endif
   endcase

return nil

//----------------------------------------------------------------------------//

static function aGetData( oObject, nItem, aObjInfo )

   local uData, cData, cType

   do case
      case ValType( oObject ) == "A"
           uData = oObject[ nItem ]
           cData = "[ " + AllTrim( Str( nItem ) ) + " ]"

      case ValType( oObject ) == "O"
           uData = OSend( oObject, aObjInfo[ nItem ] )
           cData = aObjInfo[ nItem ]
   endcase

   cType = ValType( uData )

return { aObjBmps[ At( cType, "ABCDLNMOU" ) ], cData, cGetData( uData, cType ) }

//----------------------------------------------------------------------------//

static function cGetHierarchy( oObject )

   local nClass   := oObject:ClassH
   local cClasses := "Class Hierarchy:" + CRLF
   local n := 1

   while n < nClass
      if oObject:ChildLevel( __ClassIns( n ) ) != 0
         cClasses += __ClassNam( n ) + CRLF
      endif
      n++
   end

   cClasses += oObject:ClassName()

return cClasses

//----------------------------------------------------------------------------//