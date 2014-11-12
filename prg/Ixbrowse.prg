#include "FiveWin.ch"
#include "InKey.ch"
#include "constant.ch"
#include "xbrowse.ch"
#include "Report.ch"
#include "Factu.ch" 

#ifdef __HARBOUR__
   #ifndef __XHARBOUR__
      #xtranslate DbSkipper => __DbSkipper
   #endif
#endif

//----------------------------------------------------------------------------//

CLASS IXBrowse FROM TXBrowse

   CLASSDATA lRegistered   AS LOGICAL

   CLASSDATA  dbfUsr
   CLASSDATA  lOpenData    AS LOGIC       INIT .f.

   DATA  cOriginal         AS CHARACTER   INIT ""
   DATA  cName             AS CHARACTER   INIT ""

   DATA  bToolTip
   DATA  oToolTip
   DATA  oTimer

   DATA  lOnProcess        AS LOGIC       INIT .f.

   CLASSDATA nToolTip      AS NUMERIC     INIT 900

   METHOD New( oWnd )

   Method GetOriginal()    INLINE ( ::cOriginal := ::SaveState() )
   Method SetOriginal()    INLINE ( ::RestoreState( ::cOriginal ) )

   Method Load()           INLINE ( ::OpenData(), ::LoadData(), ::CloseData() )
   Method Save()           INLINE ( ::OpenData(), ::SaveData( .t. ), ::CloseData() )

   Method CreateData( cPath )

   Method ReindexData( cPath )

   Method LoadData()

   Method SaveData( lSaveBrowseState )

   Method CleanData()

   Method DeleteData()

   Method CloseData()

   Method OpenData( cPath )

   Method RButtonDown( nRow, nCol, nFlags )

   Method CheckExtendInfo()

   Method ShowExtendInfo()

   Method SetRDD( lAddColumns, lAutoOrder, aFldNames )

   METHOD ExportToExcel()

/*
   Method Refresh( lComplete )
*/
   
END CLASS

//---------------------------------------------------------------------------//

METHOD New( oWnd ) 

   ::Super:New( oWnd )

   ::lAutoSort       := .t.
   ::l2007           := .f.
   ::bClrSel         := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
   ::bClrSelFocus    := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

#ifndef __XHARBOUR__
   ::lSortDescend    := .f. 
#endif

Return ( Self )

//----------------------------------------------------------------------------//

Method CreateData( cPath )

   DEFAULT cPath  := cPatEmp()

   if !lExistTable( cPath + "CfgUse.Dbf" )
      dbCreate( cPath + "CfgUse.Dbf", aSqlStruct( aItmHea() ), cDriver() )
   end if

Return ( Self )

//------------------------------------------------------------------------//

Method ReindexData( cPath )

   local dbfUse

   DEFAULT cPath  := cPatEmp()

   if !lExistTable( cPath + "CfgUse.Dbf" )
      ::CreateData( cPath )
   end if

   dbUseArea( .t., cDriver(), cPath + "CfgUse.Dbf", cCheckArea( "CfgUse", @dbfUse ), .f. )

   if !( dbfUse )->( neterr() )

      ( dbfUse )->( __dbPack() )

      ( dbfUse )->( ordCondSet( "!Deleted()", {|| !Deleted() }  ) )
      ( dbfUse )->( ordCreate( cPath + "CfgUse.Cdx", "cCodUse", "cCodUse + cNomCfg", {|| Field->cCodUse + Field->cNomCfg } ) )

      ( dbfUse )->( dbCloseArea() )

   else

      msgStop( "Imposible abrir en modo exclusivo la tabla de ventanas" )

   end if

Return ( Self )

//------------------------------------------------------------------------//

Method LoadData()

   local oBlock
   local oError

   oBlock               := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      ::cOriginal       := ::SaveState()

      if !Empty( ::dbfUsr ) .and. ( ::dbfUsr )->( Used() )

         if ( ::dbfUsr )->( dbSeek( cCurUsr() + ::cName ) )

            if !Empty( ( ::dbfUsr )->cBrwCfg )
               ::RestoreState( ( ::dbfUsr )->cBrwCfg )
            end if

         end if

      end if

   RECOVER USING oError

      msgStop( "Error al establecer la configuración de columnas." + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

Return ( Self )

//------------------------------------------------------------------------//

Method SaveData( lSaveBrowseState )

   local oError
   local oBlock

   DEFAULT lSaveBrowseState      := .t.

   oBlock                        := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   // Datos del browse --------------------------------------------------------

   if !Empty( ::dbfUsr ) .and. ( ::dbfUsr )->( Used() )

      if ( ::dbfUsr )->( dbSeek( cCurUsr() + ::cName ) )

         if ( ::dbfUsr )->( dbRLock() )
            ( ::dbfUsr )->cBrwCfg   := ::SaveState()
            ( ::dbfUsr )->( dbRUnLock() )
         end if

      else

         ( ::dbfUsr )->( dbAppend() )
         if !( ::dbfUsr )->( neterr() )
            ( ::dbfUsr )->cCodUse   := cCurUsr()
            ( ::dbfUsr )->cNomCfg   := ::cName
            ( ::dbfUsr )->cBrwCfg   := ::SaveState()
         end if
         ( ::dbfUsr )->( dbRUnLock() )

      end if

      if lSaveBrowseState
         msgInfo( "Configuración de columnas guardada.", ::cName )
      end if

   end if

   RECOVER USING oError

      msgStop( "Imposible salvar las configuraciones de columnas" + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

Return ( Self )

//------------------------------------------------------------------------//

Method CleanData()

   // Limpiar las configuraciones----------------------------------------------

   if !Empty( ::dbfUsr ) .and. ( ::dbfUsr )->( Used() )
      while ( ::dbfUsr )->( dbSeek( cCurUsr() + ::cName ) )
         dbDel( ::dbfUsr )
      end while
   end if

Return ( Self )

//------------------------------------------------------------------------//

Method DeleteData()

   fErase( cPatEmp() + "CfgUse.Dbf" )
   fErase( cPatEmp() + "CfgUse.Cdx" )

Return ( Self )

//------------------------------------------------------------------------//

Method CloseData()

   if !Empty( ::dbfUsr ) .and. ( ::dbfUsr )->( Used() )
      ( ::dbfUsr )->( dbCloseArea() )
   end if

   ::lOpenData          := .f.

Return ( Self )

//------------------------------------------------------------------------//

Method OpenData( cPath )

   local oBlock
   local oError

   DEFAULT cPath        := cPatEmp()

   if !lExistTable( cPath + "CfgUse.Dbf" )
      ::CreateData( cPath )
   end if

   if !lExistIndex( cPath + "CfgUse.Cdx" )
      ::ReindexData( cPath )
   end if

   oBlock               := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      if !::lOpenData

         dbUseArea( .t., cDriver(), ( cPath + "CfgUse.Dbf" ), ( ::dbfUsr := cCheckArea( "CfgUse" ) ), .t. )
         if( !lAIS(), ( ::dbfUsr )->( OrdListAdd( cPath + "CfgUse.Cdx" ) ), ( ::dbfUsr )->( OrdSetFocus( 1 ) ) )

         ::lOpenData    := .t.

      end if

   RECOVER USING oError

      msgStop( "Imposible abrir todas las bases de datos" + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

   Return ( Self )

//------------------------------------------------------------------------//

METHOD RButtonDown( nRow, nCol, nFlags )

   local oCol
   local oMenu
   local bMenuSelect

   /*
   Montamos el menu------------------------------------------------------------
   */

   oMenu             := MenuBegin( .t. )
   bMenuSelect       := ::bMenuSelect

   ::bMenuSelect     := nil

   MenuAddItem( "Columnas", "Columnas de la rejilla de datos", .f., .t., , , "Column_16", oMenu )

   MenuBegin( .f.,,, .f. )

   for each oCol in ::aCols
      MenuAddItem( oCol:cHeader, , !oCol:lHide, ( Len( ::aDisplay ) != 1 .or. oCol:nPos != 1 ), GenMenuBlock( oCol ) )
   next

   MenuEnd()

   if !Empty( ::cName )

      MenuAddItem( "Guardar vista actual", "Guarda la vista actual de la rejilla de datos", .f., .t., {|| ::Save() }, , "Column_Disk_16", oMenu )

      MenuAddItem( "Cargar vista por defecto", "Carga la vista por defecto de la rejilla de datos", .f., .t., {|| ::SetOriginal() }, , "Column_Refresh_16", oMenu )

   end if

   MenuAddItem( "Seleccionar &todo", "Selecciona todas las filas de la rejilla", .f., .t., {|| ::SelectAll() }, , "Table_Selection_All_16", oMenu )

   MenuAddItem( "&Quitar selección", "Quita la selección de todas las filas de la rejilla", .f., .t., {|| ::SelectNone() }, , "Table_Sql_16", oMenu )

   MenuAddItem()

   MenuAddItem( "Exportar a E&xcel", "Exportar rejilla de datos a Excel", .f., .t., {|| ::ExportToExcel() }, , "Text_Sum_16", oMenu )

   MenuEnd() 

   oMenu:Activate( nRow, nCol, Self )

   ::bMenuSelect     := bMenuSelect

   oMenu:end()

   ::SetFocus()

Return ( Self )

//----------------------------------------------------------------------------//

static function GenMenuBlock( oCol )

return {|| iif( oCol:lHide, oCol:Show(), oCol:Hide() ) }

//----------------------------------------------------------------------------//

Method CheckExtendInfo()

   if Empty( ::bToolTip )
      Return ( Self )
   endif

   if !Empty( ::oToolTip )
      ::oToolTip:End()
      ::oToolTip  := nil
   endif

   if !Empty( ::oTimer )
      ::oTimer:End()
      ::oTimer    := nil
   endif

   if !::lOnProcess
      ::oTimer             := TTimer():New( ::nToolTip, {|| ::ShowExtendInfo(), if( ::oTimer != nil, ::oTimer:End(), nil ), ::oTimer := nil }, )
      ::oTimer:hWndOwner   := GetActiveWindow()
      ::oTimer:Activate()
   end if

   /*
   Me cargo el objeto tooltip
   */

   if !Empty( ::oToolTip )
      ::oToolTip:End()
   end if

Return ( Self )

//----------------------------------------------------------------------------//

METHOD ShowExtendInfo()

   local nRow
   local oBlock

   ::lOnProcess      := .t.

   oBlock            := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   if ::oToolTip == nil

      ::oToolTip     := CheckEval( ::bToolTip )

      if Valtype( ::oToolTip ) == "O"

         nRow           := ( ::nRowSel * ::DataHeight ) + ::HeaderHeight()

         if ( nRow + ::oToolTip:nHeight() ) >= ( ::BrwHeight() - 100 )
            nRow     -= ( ::oToolTip:nHeight() + ::DataHeight + 108 ) // + 100
         else
            nRow     += 4
         end if

         ::oToolTip:Activate( , , , .f., , .f., {|o| o:Move( nRow, ( ::BrwWidth() - ::oToolTip:nWidth() - 4 ), ::oToolTip:nWidth(), ::oToolTip:nHeight() ) } )

         ::SetFocus()

         if !Empty( ::oTimer )
            ::oTimer:End()
            ::oTimer := nil
         endif

      end if

   end if

   END SEQUENCE

   ErrorBlock( oBlock )

   ::lOnProcess      := .f.

Return ( Self )

//----------------------------------------------------------------------------//
/*
METHOD Refresh( lComplete )

   if ::lFooter
   ::Super:MakeTotals()
   end if 

Return ( ::Super:Refresh( lComplete ) )
*/
//----------------------------------------------------------------------------//

METHOD SetRDD( lAddColumns, lAutoOrder, aFldNames ) CLASS IXBrowse

   local oCol, aStruct
   local cAlias
   local nFields, nFor
   local bOnSkip

   if Empty( ::cAlias )
      ::cAlias 		  		:= Alias()
      if Empty( ::cAlias )
         return nil
      endif
   endif

   cAlias      				:= ::cAlias
   ::nDataType 				:= DATATYPE_RDD

   DEFAULT lAddColumns     := .f.
   DEFAULT lAutoOrder      := .f. // ::lAutoSort

   ::bGoTop                := {|| if( ( cAlias )->( Used() ), ( cAlias )->( DbGoTop() ), ) }
   ::bGoBottom             := {|| if( ( cAlias )->( Used() ), ( cAlias )->( DbGoBottom() ), ) }
   ::bSkip                 := {| n | iif( n == nil, n := 1, ), if( ( cAlias )->( Used() ), ( cAlias )->( DbSkipper( n ) ), 0 ) }
   ::bBof                  := {|| if( ( cAlias )->( Used() ), ( cAlias )->( Bof() ), .t. ) }
   ::bEof                  := {|| if( ( cAlias )->( Used() ), ( cAlias )->( Eof() ), .t. ) }
   ::bBookMark             := {| n | iif( n == nil, if( ( cAlias )->( Used() ), ( cAlias )->( RecNo() ), 0 ), if( ( cAlias )->( Used() ), ( cAlias )->( DbGoto( n ) ), 0 ) ) }
   ::bKeyNo                := {| n | iif( n == nil, if( ( cAlias )->( Used() ), ( cAlias )->( OrdKeyNo() ), 0 ), if( ( cAlias )->( Used() ), ( cAlias )->( OrdKeyGoto( n ) ), 0 ) ) }
   ::bKeyCount             := {|| if( ( cAlias )->( Used() ), ( cAlias )->( OrdKeyCount() ), 0 ) }
   ::bLock                 := {|| if( ( cAlias )->( Used() ), ( cAlias )->( DbrLock() ), .f. ) }
   ::bUnlock               := {|| if( ( cAlias )->( Used() ), ( cAlias )->( DbrUnlock() ), .f. ) }

   if lAutoOrder
      for nFor := 1 to Len( ::aCols )
         if ( ::cAlias )->( OrdNumber( ::aCols[ nFor ]:cHeader ) ) > 0
            ::aCols[nFor]:cSortOrder := ::aCols[ nFor ]:cHeader
         else
            ::aCols[nFor]:cSortOrder := ( cAlias )->( FindTag( ::aCols[ nFor ]:cHeader ) )
         endif
      next nFor
   endif

   if ::lCreated
      ::Adjust()
      ::Refresh()
   endif

Return nil

//----------------------------------------------------------------------------//

METHOD ExportToExcel()

   local oError
   local oBlock

   oBlock            := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      CursorWait()

      ::ToExcel()

      CursorWe()

   RECOVER USING oError
      
      msgStop( "Error exportando a excel." + CRLF + ErrorMessage( oError ) )
   
   END SEQUENCE

   ErrorBlock( oBlock )

Return nil

//----------------------------------------------------------------------------//

static function FindTag( cFld, nOrder )

   local nOrders  := OrdCount()
   local cTag, nAt, cKey, n, nLen, aOrders := {}

   cFld     := Upper( Trim( cFld ) )
   nLen     := Len( cFld )

   for n := 1 to nOrders
      cKey  := OrdKey( n )
      cKey  := Upper( StrTran( cKey, ' ','' ) )
      if Left( cKey, nLen ) == cFld
         nOrder   := n
         cTag     := OrdName( n )
         exit
      endif
   next
   if Empty( cTag )
      for n := 1 to nOrders
         cKey  := OrdKey( n )
         cKey  := Upper( StrTran( cKey, ' ','' ) )
         if ( nAt := At( "(", cKey ) ) > 0
            cKey  := SubStr( cKey, nAt + 1 )
            if Left( cKey, nLen ) == cFld
               nOrder   := n
               cTag     := OrdName( n )
               exit
            endif
         endif
      next
   endif

return cTag

//------------------------------------------------------------------//
