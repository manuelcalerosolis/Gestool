#include "FiveWin.Ch"
#include "Factu.ch" 
#include "Font.ch"

//---------------------------------------------------------------------------//

CLASS TDet

   CLASSDATA oInstance

   DATA  oParent

   DATA  oDbf
   DATA  oDbfVir

   DATA  cPath
   DATA  cDriver                                      INIT cDriver()

   DATA  cPathBeforeAppend                            INIT ""
   DATA  aHbrBeforeAppend                             AS ARRAY INIT {}

   DATA  cPathAfterAppend                             INIT ""
   DATA  aHbrAfterAppend                              AS ARRAY INIT {}

   DATA  cFirstKey
   DATA  bWhile

   DATA  oBrw

   DATA  bWhile

   DATA  nRegisterLoaded                              AS NUMERIC  INIT  0

   DATA  cMessageNotFound                             INIT "Valor no encontrado."

   DATA  nMode           

   DATA  nView

   DATA  bOnPreAppend, bOnPostAppend
   DATA  bOnPreEdit, bOnPostEdit
   DATA  bOnPreDelete, bOnPostDelete
   DATA  bOnPreDeleteDetail, bOnPostDeleteDetail
   DATA  bOnPreSave, bOnPostSave
   DATA  bOnPreSaveDetail, bOnPostSaveDetail
   DATA  bOnPreLoad, bOnPostLoad
   DATA  bDefaultValues

   // Datas para la selecion generica de registros-----------------------------

   DATA  oRadSelect
   DATA  nRadSelect                                   AS NUMERIC
   DATA  oChkSelect
   DATA  lChkSelect                                   AS LOGIC    INIT  .t.
   DATA  oDlgSelect

   // Metodos------------------------------------------------------------------

   METHOD New( cPath, cDriver, oParent )              CONSTRUCTOR
   MESSAGE Create( cPath, cDriver, oParent )          METHOD New( cPath, cDriver, oParent )

   METHOD End()                                       INLINE ( ::CloseFiles(), Self := nil )

   METHOD Load()
   METHOD LoadAppend()                                INLINE ( ::Load( .t. ) )
   METHOD RollBack()

   METHOD Append()
   METHOD Edit()
   METHOD Zoom()
   METHOD Del()
   METHOD Duplicate()

   METHOD DefineFiles()                               VIRTUAL
   METHOD OpenFiles( lExclusive, cPath )     
   METHOD CloseFiles()

   METHOD OpenService( lExclusive, cPath )            INLINE ( ::OpenFiles( lExclusive, cPath ) )
   METHOD CloseService()                              INLINE ( ::CloseFiles() )

   METHOD Resource( nMode )                           VIRTUAL

   METHOD CreateBrowse()

   METHOD Save()
   METHOD Cancel()

   METHOD GetFirstKey()                               INLINE ( if( ::bFirstKey != nil, ::cFirstKey := Eval( ::bFirstKey, Self ), ) )

   METHOD GetStatus()                                 INLINE ( ::oDbf:GetStatus() )
   METHOD SetStatus()                                 INLINE ( ::oDbf:SetStatus() )

   METHOD AppendFrom( cPath )

   METHOD SyncAllDbf()

   METHOD Reindexa()

   METHOD CheckFiles( cFileAppendFrom )

   METHOD Existe( uValue, oGetTxt, uField, lMessage, lFill, cFillChar )
   METHOD NotExiste( uValue, oGetTxt, uField, lMessage, lFill, cFillChar )

   METHOD BuildFiles( cPath )                         INLINE ( ::DefineFiles( cPath ):Create() )

   METHOD NewInstance( cPath, cDriver, oParent )      INLINE ( ::EndInstance(), ::GetInstance( cPath, cDriver, oParent ), ::oInstance ) 
   METHOD GetInstance( cPath, cDriver, oParent )      INLINE ( if( empty( ::oInstance ), ::oInstance := ::New( cPath, cDriver, oParent ), ::oInstance ) ) 
   METHOD EndInstance()                               INLINE ( if( !empty( ::oInstance ), ::oInstance := nil, ), nil ) 

   METHOD setPathBeforeAppend()
   METHOD setPathAfterAppend()

   METHOD getCompileHbrDirectory( cDirectory )        INLINE ( TScripts():getCompileHbr( cDirectory + "\" ) )

   METHOD runScriptBeforeAppend( uParam1 )            INLINE ( TScripts():runArrayScripts( ::aHbrBeforeAppend, uParam1 ) )
   METHOD runScriptAfterAppend( uParam1 )             INLINE ( TScripts():runArrayScripts( ::aHbrAfterAppend, uParam1 ) )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( cPath, cDriver, oParent ) CLASS TDet

   DEFAULT cPath        := cPatEmp()
   DEFAULT cDriver      := cDriver()

   ::cPath              := cPath
   ::cDriver            := cDriver
   ::oParent            := oParent

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD OpenFiles( lExclusive, cPath ) CLASS TDet

   local lOpen             := .t.
   local oError
   local oBlock            := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   DEFAULT  lExclusive     := .f.

   BEGIN SEQUENCE

      if Empty( ::oDbf )
         ::oDbf            := ::DefineFiles( cPath )
      end if

      ::oDbf:Activate( .f., !lExclusive )

   RECOVER USING oError

      lOpen                := .f.

      ::CloseFiles()

      msgStop( ErrorMessage( oError ), "Imposible abrir todas las bases de datos" )

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD CloseFiles()

   if ::oDbf != nil .and. ::oDbf:Used()
      ::oDbf:End()
      ::oDbf      := nil
   end if

RETURN .t.

//---------------------------------------------------------------------------//

METHOD Load( lAppend ) CLASS TDet

   DEFAULT lAppend   := .f.

   ::nRegisterLoaded := 0

   if Empty( ::oDbfVir )
      ::oDbfVir      := ::DefineFiles( cPatTmp(), cLocalDriver(), .t. )
   end if

   if !( ::oDbfVir:Used() )
      ::oDbfVir:Activate( .f., .f. )
   end if

   ::oDbfVir:Zap()

   if Empty( ::oParent:cFirstKey )
      if ::bDefaultValues != nil
         Eval( ::bDefaultValues, Self )
      end if
   end if

   if !Empty( ::oParent )

      if ::oParent:cFirstKey != nil

         if ( lAppend ) .and. ::oDbf:Seek( ::oParent:cFirstKey )

            while !Empty( ::oDbf:OrdKeyVal() ) .and. ( ::oDbf:OrdKeyVal() == ::oParent:cFirstKey ) .and. !( ::oDbf:Eof() )

               if ::bOnPreLoad != nil
                  Eval( ::bOnPreLoad, Self )
               end if

               ::oDbfVir:AppendFromObject( ::oDbf )

               ::nRegisterLoaded++

               if ::bOnPostLoad != nil
                  Eval( ::bOnPostLoad, Self )
               end if

               ::oDbf:Skip()

            end while

         end if

      end if

   end if

   ::oDbfVir:GoTop()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD RollBack() CLASS TDet

   if empty(::oParent)
      return ( self )
   end if 

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

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD Save() CLASS TDet

   ::oDbfVir:OrdSetFocus( 0 )

   ::oDbfVir:GoTop()
   while !::oDbfVir:eof()

      if ::bOnPreSaveDetail != nil
         Eval( ::bOnPreSaveDetail, Self )
      end if

      ::oDbf:AppendFromObject( ::oDbfVir )

      if ::bOnPostSaveDetail != nil
         Eval( ::bOnPostSaveDetail, Self )
      endif

      ::oDbfVir:Skip()

   end while

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD Append( oBrw, xOthers ) CLASS TDet

   ::oDbfVir:Blank()

   if ::bOnPreAppend != nil
      Eval( ::bOnPreAppend, Self )
   end if

   ::nMode           := APPD_MODE

   if ::Resource( ::nMode, xOthers )

      if ::bOnPreSave != nil
         Eval( ::bOnPreSave, Self )
      end if

      ::oDbfVir:Insert()

      if ::bOnPostSave != nil
         Eval( ::bOnPostSave, Self )
      end if

      if ::bOnPostAppend != nil
         Eval( ::bOnPostAppend, Self )
      end if

   end if

   ::oDbfVir:Cancel()

   if( oBrw != nil, oBrw:Refresh(), )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD Edit( oBrw ) CLASS TDet

   if ::oDbfVir:Recno() == 0
      RETURN ( Self )
   end if

   ::oDbfVir:Load()

   if ::bOnPreEdit != nil
      Eval( ::bOnPreEdit, Self )
   end if

   ::nMode           := EDIT_MODE

   if ::Resource( ::nMode )

      if ::bOnPreSave != nil
         Eval( ::bOnPreSave, Self )
      end if

      ::oDbfVir:Save()

      if ::bOnPostSave != nil
         Eval( ::bOnPostSave, Self )
      end if

      if ::bOnPostEdit != nil
         Eval( ::bOnPostEdit, Self )
      end if

   else 
   
      ::oDbfVir:Cancel()

   end if

   if( oBrw != nil, oBrw:Refresh(), )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD Zoom() CLASS TDet

   if ::oDbfVir:Recno() == 0
      RETURN ( Self )
   end if

   ::oDbfVir:Load()

   ::nMode           := ZOOM_MODE

   ::Resource( ::nMode )

   ::oDbfVir:Cancel()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD Del( oBrw ) CLASS TDet

   if ::oDbfVir:Recno() == 0
      RETURN ( Self )
   end if

   if SQLAjustableModel():getRolNoConfirmacionEliminacion( Auth():rolUuid() ) .or. ApoloMsgNoYes("¿ Desea eliminar definitivamente este registro ?", "Confirme supersión" )

      if ::bOnPreDelete != nil
         Eval( ::bOnPreDelete, Self )
      end if

      ::oDbfVir:Delete( .t. )

      if ::bOnPostDelete != nil
         Eval( ::bOnPostDelete, Self )
      end if

   end if

   if( oBrw != nil, oBrw:Refresh(), )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD Duplicate() CLASS TDet

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD CreateBrowse( nId, oDlg ) CLASS TDet

   local n
   local aFlds       := {}
   local aHeaders    := {}
   local aColSizes   := {}
   local aJustify    := {}

   if Empty( ::oDbf )
      ::OpenFiles()
   end if

   /*
   Añadimos columnas, cbeceras, justificados
   */

   for n := 1 to len( ::oDbf:aTField )

      if !::oDbf:aTField[ n ]:lHide

         aAdd( aFlds,      ::oDbf:FieldBlock( n ) )
         aAdd( aHeaders,   ::oDbf:aTField[ n ]:cComment  )
         aAdd( aColSizes,  ::oDbf:aTField[ n ]:nColSize  )
         aAdd( aJustify,   ::oDbf:aTField[ n ]:lColAlign )

      endif

   next

   /*
   Creamos el objeto-----------------------------------------------------------
   */

   ::oBrw            := TWBrowse():Redefine( nId, {|| _aFlds( aFlds ) }, oDlg, aHeaders, aColSizes, , , , , , , , , , , , , ::oDbf:cAlias  )
   ::oBrw:aJustify   := aJustify

   ::oDbfVir:SetBrowse( ::oBrw )

RETURN ( Self )

//---------------------------------------------------------------------------//
/*
METHOD Reindexa()

   if Empty( ::oDbf )
      ::oDbf   := ::DefineFiles( ::cPath )
   end if

   if ::oDbf:ClassName() == "TPNTVTA"
      ? "Antes de borrar"
   end if

   ::oDbf:IdxFDel()

   if ::oDbf:ClassName() == "TPNTVTA"
      ? "Despues de borrar"
   end if

   ::oDbf:Activate( .f., .f., .f. )

   if ::oDbf:ClassName() == "TPNTVTA"
      ? "Despues de activate"
   end if

   ::oDbf:Pack()

   if ::oDbf:ClassName() == "TPNTVTA"
      ? "Pack"
   end if

   ::oDbf:End()

   if ::oDbf:ClassName() == "TPNTVTA"
      ? "End"
   end if

RETURN ( Self )
*/
//---------------------------------------------------------------------------//

METHOD Reindexa()

   /*
   Definicion del master-------------------------------------------------------
   */

   if Empty( ::oDbf )
      ::oDbf   := ::DefineFiles()
   end if

   ::oDbf:IdxFDel()

   if ::OpenService( .t. )

      ::oDbf:IdxFCheck()
      ::oDbf:Pack()
   
      ::CloseFiles()
   
   end if

RETURN ( Self )

//---------------------------------------------------------------------------//

static function _aFlds( aFields )

   local nFor
   local nLen  := Len( aFields )
   local aFld  := {}

   for nFor = 1 to nLen
      aAdd( aFld, Eval( aFields[ nFor ] ) )
   next

RETURN ( aFld )

//---------------------------------------------------------------------------//

METHOD Cancel()

   local cFileName

   if !Empty( ::oDbfVir ) .and. ::oDbfVir:Used()

      cFileName      := ::oDbfVir:cPath + ::oDbfVir:cName

      ::oDbfVir:End()

   end if

   if !Empty( cFileName )
      dbfErase( cFileName )
   end if

   ::oDbfVir         := nil

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD SyncAllDbf( lInfo )

   local oDbfTmp
   local oDbfOld

   DEFAULT lInfo  := .f.

   oDbfTmp        := ::DefineFiles( cPatEmpTmp() )

   if lInfo
      msginfo( "::DefineFiles( cPatEmpTmp() )" )
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
      msginfo( "::DefineFiles( cPatEmp() )" )
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
      msginfo( "dbfErase( oDbfOld:cPath + GetFileNoExt( oDbfOld:cFile ) )" )
   end if

   oDbfTmp:Destroy()
   oDbfOld:Destroy()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD CheckFiles( cFileAppendFrom )

   if ::OpenFiles()
      if !Empty( cFileAppendFrom )
         ::AppendFrom( cFileAppendFrom )
      end if
      ::CloseFiles()
   end if

Return ( Self )

//---------------------------------------------------------------------------//

METHOD AppendFrom( cFile )

   if !file( cFile )
      MsgStop( "No existe el fichero " + cFile )
   else
      ::oDbf:AppendFrom( cFile )
   end if

return ( Self )

//---------------------------------------------------------------------------//

METHOD Existe( uValue, oGetTxt, uField, lMessage, lFill, cFillChar, cOrder )

   local uValor
   local lValid      := .f.

   DEFAULT uField    := 2
   DEFAULT lFill     := .f.
   DEFAULT cFillChar := "0"
   DEFAULT lMessage  := .t.

   if ValType( uValue ) == "O"
      uValor         := uValue:VarGet()
   else
      uValor         := uValue
   end if

   if Empty( uValor )
      return .t.
   end if

   if ( Alltrim( uValor ) == Replicate( "Z", len( Alltrim( uValor ) ) ) )
      return .t.
   end if

   ::oDbf:GetStatus( .t. )

   if lFill
      uValor         := RJust( uValor, cFillChar )
      if ValType( uValue ) == "O"
         uValue:cText( uValor )
         uValue:Refresh()
      end if
   end if

   if !Empty( cOrder )
      ::oDbf:OrdSetFocus( cOrder )
   end if

   if ::oDbf:Seek( uValor )

      if ValType( uValue ) == "O"
         uValue:cText( uValor )
      end if

      if oGetTxt != nil

         if ValType( uField ) == "N"
            uField   := ::oDbf:FieldGet( uField )
         else
            uField   := ::oDbf:FieldGetByName( uField )
         end if

         oGetTxt:cText( uField )

      end if

      lValid         := .t.

   else

      if lMessage
         msgStop( ::cMessageNotFound, "Valor buscado " + cvaltochar( uValor ) )
      end if

   end if

   ::oDbf:SetStatus()

RETURN lValid

//---------------------------------------------------------------------------//

METHOD NotExiste( uValue, oGetTxt, uField, lMessage, lFill, cFillChar )

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

METHOD setPathBeforeAppend( cDirectorio ) CLASS TDet

   ::cPathBeforeAppend  := cDirectorio
   
   ::aHbrBeforeAppend   := ::getCompileHbrDirectory( cDirectorio )

Return .t.

//---------------------------------------------------------------------------//

METHOD setPathAfterAppend( cDirectorio ) CLASS TDet

   ::cPathAfterAppend  := cDirectorio
   
   ::aHbrAfterAppend   := ::getCompileHbrDirectory( cDirectorio )

Return .t.

//---------------------------------------------------------------------------//