#ifndef __PDA__
#include "FiveWin.Ch"
#include "WinApi.ch"
#include "InKey.ch"
#include "Constant.ch"
#include "Report.ch"
#include "MesDbf.ch"
#include "Factu.ch" 
#else
#include "FWCE.ch"
REQUEST DBFCDX
#endif

#ifndef __PDA__

#define CS_DBLCLKS            8

#define MK_MBUTTON           16

#endif

//----------------------------------------------------------------------------//
//Metodos y clases del programa y pda
//----------------------------------------------------------------------------//

CLASS IWBrowse FROM TWBrowse

   DATA  dbfCfgCol

   DATA  aIntFields
   DATA  aIntHeaders
   DATA  aIntColSizes
   DATA  aIntJustify
   DATA  aIntColSelect
   DATA  aIntColPos
   DATA  aIntColFoot

   DATA  nFlds

   DATA  bFont

   DATA  lNoSave     AS LOGIC    INIT .f.

   DATA  aOriginal   AS ARRAY    INIT {}

   DATA  cWndName

   DATA  aFooters

   /*
   Fin de las datas
   */

   METHOD ReDefine( nId, aFields, oDlg, aHeaders, aColSizes, cField, uVal1, uVal2,;
                    bChange, bLDblClick, bRClick, oFont, oCursor,;
                    nClrFore, nClrBack, cMsg, lUpdate, cAlias,;
                    bWhen, bValid, bLClick, aActions )

   METHOD OpenData( lExclusive )
   METHOD CloseData()

   Method LoadData()
   Method SaveData()
   Method CleanData()

   METHOD SaveOriginal()
   METHOD PutOriginal()

   METHOD SetColumn()
   METHOD DlgColumn()
   METHOD ActColSizes()

   METHOD UpColumn( oBrw, aFields, aHeaders, aColSizes, aColSelect, aColPos, aJustify )
   METHOD DwColumn( oBrw, aFields, aHeaders, aColSizes, aColSelect, aColPos, aJustify )

#ifndef __PDA__
   METHOD KeyDown( nKey, nFlags )   INLINE ( if( nKey == VK_F9, ::PutOriginal(), ), Super:KeyDown( nKey, nFlags ) )

   Method RightButtonDown( nRow, nCol, nFlags )
#endif

ENDCLASS

//----------------------------------------------------------------------------//

METHOD CloseData()

   if ( !Empty( ::dbfCfgCol ) .and. ( ::dbfCfgCol )->( Used() ) )
      ( ::dbfCfgCol )->( dbCloseArea() )
   end if

Return ( Self )

//---------------------------------------------------------------------------//

METHOD SaveOriginal() CLASS IWBrowse

   ::aOriginal       := {}

   aAdd( ::aOriginal, aClone( ::aIntFields      ) )
   aAdd( ::aOriginal, aClone( ::aIntHeaders     ) )
   aAdd( ::aOriginal, aClone( ::aIntColSizes    ) )
   aAdd( ::aOriginal, aClone( ::aIntJustify     ) )
   aAdd( ::aOriginal, aClone( ::aIntColSelect   ) )
   aAdd( ::aOriginal, aClone( ::aIntColFoot     ) )
   aAdd( ::aOriginal, aClone( ::aIntColPos      ) )

return nil

//----------------------------------------------------------------------------//

METHOD SaveData() CLASS IWBrowse

   local n
   local nCols
   local oError
   local oBlock

   oBlock               := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      nCols             := Len( ::aIntFields )

      if !::lNoSave .and. !Empty( ::dbfCfgCol ) .and. ( ::dbfCfgCol )->( Used() )

         // Borramos las columnas-------------------------------------------------

         ::CleanData()

         // Tamaño de las columnas------------------------------------------------

         ::ActColSizes()

         // Orden de las columnas-------------------------------------------------

         for n := 1 to nCols

            ( ::dbfCfgCol )->( dbAppend() )
            if !( ::dbfCfgCol )->( NetErr() )
               ( ::dbfCfgCol )->nNumCol   := n
               ( ::dbfCfgCol )->cCodUse   := cCurUsr()
               ( ::dbfCfgCol )->cNomCfg   := ::cWndName
               ( ::dbfCfgCol )->nPosCol   := ::aIntColPos   [ n ]
               ( ::dbfCfgCol )->lSelCol   := ::aIntColSelect[ n ]
               ( ::dbfCfgCol )->nSizCol   := ::aIntColSizes [ n ]
               ( ::dbfCfgCol )->lJusCol   := ::aIntJustify  [ n ]
               ( ::dbfCfgCol )->( dbUnLock() )
            end if

         next

         msgInfo( "Configuración de columnas guardada." )

      end if

   RECOVER USING oError

      msgStop( "Imposible salvar las configuraciones de columnas" + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( Self )

//---------------------------------------------------------------------------//

Method CleanData()

   /*
   Vamos a borrar las columnas ------------------------------------------------
   */

   while ( ::dbfCfgCol )->( dbSeek( cCurUsr() + ::cWndName ) )
      dbDel( ::dbfCfgCol )
   end while

Return ( Self )

//----------------------------------------------------------------------------//

Method LoadData() CLASS IWBrowse

   local n
   local nPos
   local aTmpFld
   local aTmpHea
   local aTmpJus
   local aTmpSiz

   // Guadamos la situación original-------------------------------------------

   ::SaveOriginal()

   // Abrimos la tabla para leer la consiguracion------------------------------

   if !::OpenData()
      Return ( Self )
   end if

   ::cWndName                 := Padr( Rtrim( ::cWndName ), 40 )

   if ( ::dbfCfgCol )->( dbSeek( cCurUsr() + ::cWndName ) )

      // Número de campos---------------------------------------------------------

      ::nFlds                    := len( ::aIntFields )

      // Fields ------------------------------------------------------------------

      ::aIntColPos               := Array( ::nFlds )
      aEval( ::aIntColPos, {| x, n | ::aIntColPos[ n ] := n } )

      for n := 1 to ::nFlds
         if ( ::dbfCfgCol )->( dbSeek( cCurUsr() + ::cWndName + Str( n, 2 ) ) ) .and. n <= len( ::aIntColPos )
            ::aIntColPos   [ n ] := ( ::dbfCfgCol )->nPosCol
            ::aIntColSelect[ n ] := ( ::dbfCfgCol )->lSelCol
            ::aIntColSizes [ n ] := ( ::dbfCfgCol )->nSizCol
            ::aIntJustify  [ n ] := ( ::dbfCfgCol )->lJusCol
         end if
      next

      aTmpFld                    := Array( ::nFlds )
      aTmpHea                    := Array( ::nFlds )

      for n := 1 to ::nFlds
        nPos                    := ::aIntColPos[ n ]
         if nPos > 0 .and. nPos <= ::nFlds
            aTmpFld[ n ]         := ::aIntFields  [ nPos ]
            aTmpHea[ n ]         := ::aIntHeaders [ nPos ]
         end if
      next

      ::aIntFields               := aTmpFld
      ::aIntHeaders              := aTmpHea

   end if

   ::Default()

   ::SetColumn( .f. )

Return ( Self )

//----------------------------------------------------------------------------//

METHOD OpenData( lExclusive ) CLASS IWBrowse

   local lOpen          := .t.
   local oError
   local oBlock         := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   DEFAULT lExclusive   := .f.

   BEGIN SEQUENCE

      if !lExistTable( cPatEmp() + "CfgDet.Dbf" )
         CreateConfigDetalle()
      end if

      if !lExistIndex( cPatEmp() + "CfgDet.Cdx" )
         ReindexConfigDetalle()
      end if

      dbUseArea( .t., cDriver(), ( cPatEmp() + "CfgDet.Dbf" ), ( ::dbfCfgCol := cCheckArea( "CfgDet" ) ), !lExclusive )
      ( ::dbfCfgCol )->( OrdListAdd( cPatEmp() + "CfgDet.Cdx" ) )

   RECOVER

      lOpen             := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD ReDefine( nId, aFields, oDlg, aHeaders, aColSizes, cField, uVal1, uVal2,;
                 bChange, bLDblClick, bRClick, oFont, oCursor,;
                 nClrFore, nClrBack, cMsg, lUpdate, cAlias,;
                 bWhen, bValid, bLClick, aActions, aJustify, aSelected ) CLASS IWBrowse

   local bLine

   ::aIntFields            := aFields
   ::aIntHeaders           := aHeaders
   ::aIntColSizes          := aColSizes
   ::aIntJustify           := aJustify
   ::aIntColSelect         := aSelected

   DEFAULT ::aIntColSelect := Afill( Array( len( aFields ) ), .t. )

   ::aIntColPos            := Array( len( aFields ) )
   aEval( ::aIntColPos, {| x, n | ::aIntColPos[ n ] := n } )

   ::aIntColFoot           := Afill( Array( len( aFields ) ), .t. )

   bLine                   := {|| _aFld( aFields,           ::aIntColSelect ) }
   aHeaders                := _aColHead( ::aIntHeaders,     ::aIntColSelect )
   aColSizes               := _aColSize( ::aIntColSizes,    ::aIntColSelect )

   ::aJustify              := _aColJustify( ::aIntJustify,  ::aIntColSelect )

Return Super:ReDefine(  nId, bLine, oDlg, aHeaders, aColSizes, cField, uVal1, uVal2,;
                        bChange, bLDblClick, bRClick, oFont, oCursor,;
                        nClrFore, nClrBack, cMsg, lUpdate, cAlias,;
                        bWhen, bValid, bLClick, aActions )

//----------------------------------------------------------------------------//

METHOD PutOriginal() CLASS IWBrowse

   /*
   Tamaño de las columnas------------------------------------------------------
   */

   ::aIntFields      := aClone( ::aOriginal[1] )
   ::aIntHeaders     := aClone( ::aOriginal[2] )
   ::aIntColSizes    := aClone( ::aOriginal[3] )
   ::aIntJustify     := aClone( ::aOriginal[4] )
   ::aIntColSelect   := aClone( ::aOriginal[5] )
   ::aIntColFoot     := aClone( ::aOriginal[6] )
   ::aIntColPos      := aClone( ::aOriginal[7] )

   ::CleanData()

   ::SetColumn( .t. )

   ::Refresh()

return nil

//----------------------------------------------------------------------------//

METHOD UpColumn( oBrw, aFields, aHeaders, aColSizes, aColSelect, aColPos, aJustify ) CLASS IWBrowse

   local nPos  := oBrw:nAt

   if nPos <= len( aFields ) .and. nPos > 1

      SwapUpArray( aFields,    nPos )
      SwapUpArray( aHeaders,   nPos )
      SwapUpArray( aColSizes,  nPos )
      SwapUpArray( aColSelect, nPos )
      SwapUpArray( aColPos,    nPos )
      SwapUpArray( aJustify,   nPos )

      oBrw:GoUp()
      oBrw:Refresh()
      oBrw:SetFocus()

   end if

return ( Self )

//----------------------------------------------------------------------------//

Function CreateConfigDetalle( lReindex )

   local aData       := {}

   DEFAULT lReindex  := .t.

   aAdd( aData, { "cCodUse", "C",   3,  0,  "Código usuario"             } )
   aAdd( aData, { "cNomCfg", "C",  40,  0,  "Nombre ventana"             } )
   aAdd( aData, { "nNumCol", "N",   2,  0,  "Número de la columna"       } )
   aAdd( aData, { "lSelCol", "L",   1,  0,  "Columna seleccionada"       } )
   aAdd( aData, { "nPosCol", "N",   2,  0,  "Posicición de la columna"   } )
   aAdd( aData, { "nSizCol", "N",   6,  0,  "Tamaño de la columna"       } )
   aAdd( aData, { "lJusCol", "L",   1,  0,  "Columna a la derecha"       } )

   if !lExistTable( cPatEmp() + "CfgDet.Dbf" )
      dbCreate( cPatEmp() + "CfgDet.Dbf", aData, cDriver() )
   end if

   if lReindex
      ReindexConfigDetalle()
   end if

Return .t.

//----------------------------------------------------------------------------//

//
// Actualiza los anchos de columnas
//

METHOD ActColSizes() CLASS IWBrowse

   local nFor
   local n     := 1
   local nLen  := len( ::aIntFields )

   /*
   Reescribimos los valores actuales del ancho de columna----------------------
   */

   for nFor := 1 to nLen
      if ::aIntColSelect[ nFor ]
         ::aIntColSizes[ nFor ]  := ::aColSizes[ n++ ]
      end if
   next

return nil

//----------------------------------------------------------------------------//

METHOD DwColumn( oBrw, aFields, aHeaders, aColSizes, aColSelect, aColPos, aJustify ) CLASS IWBrowse

   local nPos  := oBrw:nAt

   if nPos < len( aFields ) .and. nPos > 0

      SwapDwArray( aFields,    nPos )
      SwapDwArray( aHeaders,   nPos )
      SwapDwArray( aColSizes,  nPos )
      SwapDwArray( aColSelect, nPos )
      SwapDwArray( aColPos,    nPos )
      SwapDwArray( aJustify,   nPos )

      oBrw:GoDown()
      oBrw:Refresh()
      oBrw:SetFocus()

   end if

return ( Self )

//----------------------------------------------------------------------------//

Function ReindexConfigDetalle()

   local dbf

   if !lExistTable( cPatEmp() + "CfgDet.Dbf" )
      CreateConfigDetalle( .f. )
   end if

   fEraseIndex( cPatEmp() + "CfgDet.Cdx" )

   dbUseArea( .t., cDriver(), cPatEmp() + "CfgDet.Dbf", cCheckArea( "CfgDet", @dbf ), .f. )
   if !( dbf )->( neterr() )

      ( dbf )->( __dbPack() )

      ( dbf )->( ordCondSet( "!Deleted()", {|| !Deleted() }  ) )
      ( dbf )->( ordCreate( cPatEmp() + "CfgDet.Cdx", "cCodUse", "Field->cCodUse + Field->cNomCfg + Str( Field->nNumCol )", {|| Field->cCodUse + Field->cNomCfg + Str( Field->nNumCol ) } ) )

      ( dbf )->( dbCloseArea() )
   else

      msgStop( "Imposible abrir en modo exclusivo la tabla de configuraciones de columnas" )

   end if

Return .t.

//----------------------------------------------------------------------------//

METHOD SetColumn( lRefresh ) CLASS IWBrowse

   local aData       := _aData( ::aIntFields,         ::aIntColSelect )
   local aHeaders    := _aColHead( ::aIntHeaders,     ::aIntColSelect )
   local aColSizes   := _aColSize( ::aIntColSizes,    ::aIntColSelect )
   local aJustify    := _aColJustify( ::aIntJustify,  ::aIntColSelect )
   local aFooter     := _aColFoot( ::aIntColFoot,     ::aIntColSelect )

   DEFAULT lRefresh  := .t.

   ::SetCols( aData, aHeaders, aColSizes )

   ::aJustify        := aJustify
   ::aFooters        := aFooter

   if lRefresh
      ::Refresh()
   end if

return nil

//----------------------------------------------------------------------------//

METHOD DlgColumn() CLASS IWBrowse

   local oDlg
   local oGet
   local oBrwCol
   local aFields     := aClone( ::aIntFields    )
   local aHeaders    := aClone( ::aIntHeaders   )
   local aColSizes   := aClone( ::aIntColSizes  )
   local aColSelect  := aClone( ::aIntColSelect )
   local aColPos     := aClone( ::aIntColPos    )
   local aJustify    := aClone( ::aIntJustify   )

   local hBmp        := LoadBitmap( 0, 32760 )

   DEFINE DIALOG oDlg RESOURCE "DLGCOLUM"

   REDEFINE LISTBOX oBrwCol;
      FIELDS   if( aColSelect[ oBrwCol:nAt ], hBmp, "" ) ,;
               aHeaders[ oBrwCol:nAt ] ;
      FIELDSIZES ;
               14,;
               40 ;
      HEAD     "S",;
               "Columna" ;
      ID       100 ;
      ON CHANGE( oGet:Refresh() ) ;
      OF       oDlg

      oBrwCol:nLineStyle := 10
      oBrwCol:SetArray( aHeaders )

   REDEFINE GET oGet VAR aColSizes[ oBrwCol:nAt ] ;
      ID       101 ;
      SPINNER ;
      MIN      1 ;
      MAX      999 ;
      PICTURE  "999" ;
      VALID    aColSizes[ oBrwCol:nAt ] > 0 ;
      OF       oDlg

   REDEFINE BUTTON ;
      ID       400 ;
      OF       oDlg ;
      ACTION   ( if( CheckOne( aColSelect ), oDlg:end( IDOK ), ) )

   REDEFINE BUTTON ;
      ID       401 ;
      OF       oDlg ;
      ACTION   ( oDlg:end() )

   REDEFINE BUTTON ;
      ID       402 ;
      OF       oDlg ;
      ACTION   ( aColSelect[ oBrwCol:nAt ] := .t., oBrwCol:SetFocus(), oBrwCol:Refresh() )

   REDEFINE BUTTON ;
      ID       403 ;
      OF       oDlg ;
      ACTION   ( aColSelect[ oBrwCol:nAt ] := .f., oBrwCol:SetFocus(), oBrwCol:Refresh() )

   REDEFINE BUTTON ;
      ID       404 ;
      OF       oDlg ;
      ACTION   ( ::UpColumn( oBrwCol, aFields, aHeaders, aColSizes, aColSelect, aColPos, aJustify ) )

   REDEFINE BUTTON ;
      ID       405 ;
      OF       oDlg ;
      ACTION   ( ::DwColumn( oBrwCol, aFields, aHeaders, aColSizes, aColSelect, aColPos, aJustify ) )

   ACTIVATE DIALOG oDlg CENTER

   if oDlg:nResult == IDOK
      ::aIntFields      := aFields
      ::aIntHeaders     := aHeaders
      ::aIntColSizes    := aColSizes
      ::aIntColSelect   := aColSelect
      ::aIntColPos      := aColPos
      ::aIntJustify     := aJustify
      ::SetColumn( .t. )
      ::SaveData()
   end if

   DeleteObject( hBmp )

   hBmp                 := nil

return nil

//----------------------------------------------------------------------------//

#ifndef __PDA__

//----------------------------------------------------------------------------//
//Clases y metodos del programa
//----------------------------------------------------------------------------//

Method RightButtonDown( nRow, nCol, nFlags )

   local nLen
   local nFor
   local oMenu
   local bMenuSelect
   local oMenuColumns

   if oUser():lAdministrador()

      nLen           := len( ::aIntHeaders )

      ::ActColSizes()

      /*
      Montamos el menu------------------------------------------------------------
      */

      oMenu          := MenuBegin( .t. )
      bMenuSelect    := ::bMenuSelect

      MenuAddItem( "Columnas", "Columnas de la rejilla de datos", .f., .t., , , "gc_table_selection_column_16", oMenu )

      MenuBegin( .f.,,, .f. )

         for nFor := 1 to nLen
            if ValType( ::aIntHeaders[ nFor ] ) == "C" .and. !Empty( ::aIntHeaders[ nFor ] )
               MenuAddItem( ::aIntHeaders[ nFor ], ::aIntHeaders[ nFor ], ::aIntColSelect[ nFor ], .t., bSelColumn( nFor, Self ) )
            end if
         next

      MenuEnd()

      //MenuAddItem( "Personalizar...", "Personalizar la rejilla de datos", .f., .t., {|| ::DlgColumn() }, , "gc_table_selection_column_16", oMenu )

      MenuAddItem( "Guardar vista actual", "Guarda la vista actual de la rejilla de datos", .f., .t., {|| ::SaveData( .t. ) }, , "gc_table_selection_column_disk_16", oMenu )

      MenuAddItem( "Cargar vista por defecto", "Carga la vista por defecto de la rejilla de datos", .f., .t., {|| ::PutOriginal() }, , "gc_table_selection_column_refresh_16", oMenu )

      MenuAddItem()

      MenuAddItem( "Exportar a E&xcel", "Exportar rejilla de datos a Excel", .f., .t., {|| ::ExportToExcel() }, , "gc_spreadsheet_sum_16", oMenu )

      MenuAddItem( "Exportar a &Word", "Exportar rejilla de datos a Word", .f., .t., {|| ::ExportToWord() }, , "gc_document_text_16", oMenu )

      MenuEnd()

      oMenu:Activate( nRow, nCol, Self )

      ::bMenuSelect  := bMenuSelect

   end if

Return Self

//---------------------------------------------------------------------------//


static function bSelColumn( nFor, Self )
return {|| ::aIntColSelect[ nFor ] := !::aIntColSelect[ nFor ], if( CheckOne( ::aIntColSelect ), ( ::SetColumn(), ::Refresh() ), ) }

#endif