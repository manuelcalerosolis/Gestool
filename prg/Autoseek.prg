#ifndef __PDA__
   #include "FiveWin.Ch"
   #include "DbInfo.ch"
   #include "Ord.ch"
   #include "Factu.ch" 
#else
   #include "FWCE.ch"
   #include "DbInfo.ch"
   REQUEST DBFCDX
#endif

#ifndef __PDA__
   Static lTmpIndex  := .t.
#endif

static cBagAnterior
static cOldIndexName
static nRecAnterior
static cTmpAnterior
static cNamAnterior
static cFiltroUsuario
static cFiltroFecha

#ifndef __PDA__

/*
Funciones del programa principal
*/

//--------------------------------------------------------------------------//
/*
Muestra una caja de dialogo para buscar por el indice activo
*/

FUNCTION Searching( cAlias, aIndex, oBrw, cPreFij )

	local oDlg
   local cType
   local oIndice
	local cIndice
	local oCadena
   local xValueToSearch  := Space( 100 )
	local nOrdAnt

	DEFAULT cAlias	:= Alias()
   DEFAULT aIndex := { "Código", "Descripción" }

   nOrdAnt        := ( cAlias )->( OrdNumber() )
   cIndice        := aIndex[ Min( nOrdAnt, Len( aIndex ) ) ]
   cType          := ( cAlias )->( dbOrderInfo( DBOI_KEYTYPE ) )

   DEFINE DIALOG oDlg RESOURCE "SSEARCH"

	REDEFINE GET oCadena VAR xValueToSearch ;
      ID          100 ;
      PICTURE     "@!" ;
      ON CHANGE   ( lBigSeek( nil, oCadena, cAlias ), ( if( !empty( oBrw ), oBrw:Refresh(), ) ) );
      VALID       ( OrdClearScope( oBrw, cAlias ) );
      OF          oDlg ;

	REDEFINE COMBOBOX oIndice VAR cIndice ;
      ITEMS       aIndex ;
      ID          101 ;
      ON CHANGE   ( ( cAlias )->( OrdSetFocus( oIndice:nAt ) ), oBrw:Refresh(), oCadena:SetFocus(), oCadena:SelectAll() ) ;
      OF          oDlg

	REDEFINE BUTTON ;
      ID          510 ;
      OF          oDlg ;
      CANCEL ;
      ACTION      ( oDlg:end() )

	ACTIVATE DIALOG oDlg CENTER

   OrdClearScope( oBrw, cAlias )

   ( cAlias )->( OrdSetFocus( nOrdAnt ) )

RETURN NIL

//---------------------------------------------------------------------------//

#endif

/*
Funciones comunes
*/

FUNCTION AutoSeek( nKey, nFlags, oGet, oBrw, xAlias, lUpper, cPreFij, lAllowFilter, lNotUser, lNotFecha, nLen )

   local cType
	local xValueToSearch
   local lReturn        := .t.

   DEFAULT xAlias       := Alias()
   DEFAULT lUpper       := .t.
   DEFAULT lAllowFilter := .t.
   DEFAULT lNotUser     := .t.
   DEFAULT lNotFecha    := .t.
   DEFAULT nLen         := 10

   if ValType( xAlias ) == "O"
      xAlias            := xAlias:cAlias
   end if

   oGet:Assign()
   xValueToSearch       := oGet:VarGet()

   if isChar( xValueToSearch )
      xValueToSearch    := Rtrim( xValueToSearch )
   else
      xValueToSearch    := ""
   end if

   cType                := ( xAlias )->( dbOrderInfo( DBOI_KEYTYPE ) )

   do case
      case cType == "C"

         if lUpper
            xValueToSearch     := Upper( xValueToSearch )
         end if

      case cType == "N"

         xValueToSearch        := Val( xValueToSearch )

   end case

   if lBigSeek( cPreFij, xValueToSearch, xAlias, oBrw, lNotUser, lNotFecha, nLen, lAllowFilter ) .or. empty( xValueToSearch )

      oGet:SetColor( Rgb( 0, 0, 0 ), Rgb( 255, 255, 255 ) )

   else

      oGet:SetColor( Rgb( 255, 255, 255 ), Rgb( 255, 102, 102 ) )

      lReturn           := .f.

   end if

   if oBrw != nil
      oBrw:Refresh()
   end if

Return ( lReturn )

//--------------------------------------------------------------------------//

FUNCTION lBigSeek( cPreFij, xValueToSearch, xAlias, oBrw, lNotUser, lNotFecha, nLen, lAllowFilter )

   local oCol
   local xVal
   local nRec
   local lRet              := .f.
   local cSort
   local nSort

   DEFAULT lNotUser        := .t.
   DEFAULT lNotFecha       := .t.
   DEFAULT nLen            := 10
   DEFAULT lAllowFilter    := .t.

   if isObject( xValueToSearch )
      xValueToSearch:Assign()
      xValueToSearch        := xValueToSearch:VarGet()
   end if

   if isObject( xAlias )
      xAlias         := xAlias:cAlias
   end if

   if !( xAlias )->( Used() )
      return .t.
   end if

   // Uso de filtros-----------------------------------------------------------

   if lAllowFilter .and. isChar( xValueToSearch )

      xValueToSearch        := StrTran( xValueToSearch, Chr( 8 ), "" )
      if !empty( cPreFij )
         xValueToSearch     := cPreFij + xValueToSearch
      end if
      xValueToSearch        := Alltrim( xValueToSearch )

      DestroyFastFilter( xAlias, .f., .f. )

      CreateFastFilter( "", xAlias, .f., , , , lNotUser, lNotFecha )

      if Left( xValueToSearch, 1 ) == "*" .and. Right( xValueToSearch, 1 ) == "*" .and. len( Rtrim( xValueToSearch ) ) > 1

         CreateFastFilter( SubStr( xValueToSearch, 2, len( xValueToSearch ) - 2 ), xAlias, .t. , , , , lNotUser, lNotFecha )

         return .t.

      end if

   end if

   // Comprobaciones antes de buscar-------------------------------------------

   cSort       := ( xAlias )->( OrdSetFocus() )

   lRet        := lMiniSeek( xValueToSearch, xAlias, nLen )

   if !lRet
      ( xAlias )->( OrdSetFocus( cSort ) )
   end if

RETURN ( lRet )

//---------------------------------------------------------------------------//

Function lMiniSeek( xValueToSearch, xAlias, nLen )

   local lRet              := .f.

   DEFAULT nLen            := 10

   lRet                    := lSeekKeyType( xValueToSearch, xAlias )

   if !lRet .and. ( xAlias )->( dbOrderInfo( DBOI_KEYTYPE ) ) == "C"
      lRet                 := seekDocumento( xValueToSearch, xAlias, nLen )
   end if 

Return ( lRet )

//---------------------------------------------------------------------------//

Function lSeekKeyWild( xValueToSearch, xAlias )

   local nRec              := ( xAlias )->( recno() )
   local lFound            := .f.

   if left( xValueToSearch, 1 ) == "*" .and. right( xValueToSearch, 1 ) == "*" .and. len( rtrim( xValueToSearch ) ) > 1
      lFound               := ( xAlias )->( ordWildSeek( xValueToSearch, .f., .t. ) )
   end if

   if !lFound
      ( xAlias )->( dbgoto( nRec ) )
   end if 

Return ( lFound )

//---------------------------------------------------------------------------//

Function lSeekKeySimple( xValueToSearch, xAlias )

Return ( lSeekKey( xValueToSearch, xAlias, .f. ) )

//---------------------------------------------------------------------------//

Function lSeekKeyType( xValueToSearch, xAlias )

Return ( lSeekKey( xValueToSearch, xAlias, .t. ) )

//---------------------------------------------------------------------------//

Function lSeekKey( xValueToSearch, xAlias, lScope )

   local nRec
   local lRet              := .f.
   local cType
   local oBlock
   local oError

   cType                   := ( xAlias )->( dbOrderInfo( DBOI_KEYTYPE ) )

   if !( cType $ "CDN" )
      return .f.
   end if

   DEFAULT lScope          := .t.

   oBlock                  := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   nRec                    := ( xAlias )->( Recno() )

   if !empty( xValueToSearch )

      if lScope
         ( xAlias )->( OrdScope( 0, nil ) )
         ( xAlias )->( OrdScope( 1, nil ) )
      end if 

      do case
      case cType == "D"

         if len( Rtrim( xValueToSearch ) ) == 10
            if ( xAlias )->( dbSeek( Ctod( xValueToSearch ), .t. ) )
               if lScope
                  ( xAlias )->( OrdScope( 0, Ctod( xValueToSearch ) ) )
                  ( xAlias )->( OrdScope( 1, Ctod( xValueToSearch ) ) )
               end if 
            else
               if lScope
                  ( xAlias )->( OrdScope( 0, nil ) )
                  ( xAlias )->( OrdScope( 1, nil ) )
               end if 
            end if
         end if

         lRet     := .t.

      case cType == "N"

         xValueToSearch := alltrim( xValueToSearch )
         xValueToSearch := strtran( xValueToSearch, ",", "." )
         xValueToSearch := val( xValueToSearch )

         ( xAlias )->( dbSeek( xValueToSearch, .t. ) ) 

         lRet           := .t.

      case cType == "C"

         if ( xAlias )->( dbSeek( xValueToSearch, .t. ) )

            if lScope
               ( xAlias )->( OrdScope( 0, xValueToSearch ) )
               ( xAlias )->( OrdScope( 1, xValueToSearch ) )
            end if 

            lRet  := .t.

         end if

      end case

   end if

   if !lRet
      ( xAlias )->( dbgoto( nRec ) )
   end if

   RECOVER USING oError

   END SEQUENCE

   ErrorBlock( oBlock )

Return ( lRet )

//---------------------------------------------------------------------------//

Function seekCodigoTerceros( xValueToSearch, xAlias, nLenCodigo )

   local nRec
   local lRet        := .f.

   nRec              := ( xAlias )->( Recno() )

   xValueToSearch           :=  rjust( alltrim( xValueToSearch ), "0", nLenCodigo )

   if ( xAlias )->( dbSeek( xValueToSearch ) ) 

      ( xAlias )->( OrdScope( 0, xValueToSearch ) )
      ( xAlias )->( OrdScope( 1, xValueToSearch ) )

      lRet           := .t.
            
   end if

   if !lRet
      ( xAlias )->( dbGoTo( nRec ) )
   end if

return ( lRet )

//---------------------------------------------------------------------------//

Function seekDocumentoSimple( xValueToSearch, xAlias, nLen )

Return seekDocumento( xValueToSearch, xAlias, nLen, .f. )

//---------------------------------------------------------------------------//

Function seekDocumento( xValueToSearch, xAlias, nLen, lScope )
   
   local n
   local nRec
   local cPre
   local cPos
   local lRet        := .f.

   DEFAULT nLen      := 12
   DEFAULT lScope    := .t.

   nRec              := ( xAlias )->( Recno() )

   cPre              := SubStr( xValueToSearch, 1, 1 )
   cPos              := Padl( Rtrim( SubStr( xValueToSearch, 2, nLen - 1 ) ), nLen - 1 )

   for n := 1 to nLen

      if ( xAlias )->( dbSeek( cPre + cPos, .f. ) )

         if lScope
            ( xAlias )->( OrdScope( 0, cPre + cPos ) )
            ( xAlias )->( OrdScope( 1, cPre + cPos ) )
         end if 

         lRet  := .t.
         
         exit

      end if

      if empty( SubStr( cPos, 2, 1 ) )
         lRet  := .f.
         cPos  := SubStr( cPos, 2, len( cPos ) - 1 )
      else
         lRet  := .f.
         exit
      end if

   next

   if !lRet
      ( xAlias )->( dbGoTo( nRec ) )
   end if

Return ( lRet )

//---------------------------------------------------------------------------//

Function CreateUserFilter( cExpresionFilter, cAlias, lInclude, oMeter, cExpUsuario, cExpFecha )

RETURN ( CreateFastFilter( cExpresionFilter, cAlias, lInclude, oMeter, cExpUsuario, cExpFecha, .f., .f. ) )

//---------------------------------------------------------------------------//

Function CreateFastFilter( cExpresionFilter, cAlias, lInclude, oMeter, cExpUsuario, cExpFecha, lNotUser, lNotFecha )

   local nEvery
   local bEvery
   local cOrdKey
   local bOrdKey
   local bExpFilter
   local oBlock
   local oError
   local cCondAnterior

   DEFAULT lInclude        := .t.
   DEFAULT cExpUsuario     := ""
   DEFAULT cExpFecha       := ""
   DEFAULT lNotUser        := .t.
   DEFAULT lNotFecha       := .t.

   if empty( cAlias )
      return .f.
   end if

   oBlock                  := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   if !empty( cExpUsuario )
      cFiltroUsuario       := cExpUsuario
   else
      cFiltroUsuario       := ""
   end if

   if !empty( cExpFecha )

      if cExpFecha == "all"
         cFiltroFecha      := ""
      else
         cFiltroFecha      := cExpFecha
      end if

   end if

   if lAIS()

      buildSetFilter( cExpresionFilter, cAlias, lInclude, cExpUsuario, cExpFecha )

   else

      nRecAnterior         := ( cAlias )->( Recno() )
      cOldIndexName        := ( cAlias )->( OrdSetFocus() )
      cBagAnterior         := ( cAlias )->( dbOrderInfo( DBOI_FULLPATH ) )
      cNamAnterior         := "OrdTmp" + Auth():Codigo()
      cCondAnterior        := ( cAlias )->( dbOrderInfo( DBOI_CONDITION ) )

      cOrdKey              := ( cAlias )->( OrdKey() )
      bOrdKey              := c2Block( cOrdKey )

      if !empty( oMeter )
         nEvery            := Int( ( cAlias )->( OrdKeyCount() ) / 10 )
         bEvery            := {|| oMeter:Set( ( cAlias )->( OrdKeyNo() ) ) }
      end if

      if lInclude
         cExpresionFilter  := "'" + cExpresionFilter + "' $ " + cOrdKey + ".and. " + cCondAnterior
      end if

      if !lNotUser .and. empty( cExpUsuario ) .and. !empty( cFiltroUsuario )
         if !empty( cExpresionFilter )
            cExpresionFilter     += " .and. " + cFiltroUsuario
         else
            cExpresionFilter     := cFiltroUsuario
         end if
      end if

      if !lNotFecha .and. empty( cExpFecha ) .and. !empty( cFiltroFecha )
         if !empty( cExpresionFilter )
            cExpresionFilter     += " .and. " + cFiltroFecha
         else
            cExpresionFilter     := cFiltroFecha
         end if
      end if

      Select( cAlias )

      bExpFilter           := bCheck2Block( cExpresionFilter )

      if !empty( bExpFilter ) .and. !empty( cOldIndexName ) .and. !empty( cBagAnterior )
         ( cAlias )->( OrdCondSet( cExpresionFilter, bExpFilter ) )
         ( cAlias )->( OrdCreate( cBagAnterior, cNamAnterior, cOrdKey, bOrdKey ) )
         ( cAlias )->( OrdSetFocus( cNamAnterior, cBagAnterior ) )
         ( cAlias )->( dbGoTop() )
      else
         cOldIndexName     := nil
         nRecAnterior      := nil
         cBagAnterior      := nil
      end if

   end if

   RECOVER USING oError

      bExpFilter           := nil

      msgStop( "Imposible crear el filtro en el indice" + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

Return ( .t. )

//---------------------------------------------------------------------------//

Function DestroyFastFilter( cAlias, lUser, lFecha )

   DEFAULT lUser       := .f.
   DEFAULT lFecha      := .f.

   if lAds() .or. lAIS()

      if !empty( cAlias ) .and. ( cAlias )->( used() )
         ( cAlias )->( dbClearFilter() )
      end if

   else

      if !empty( cBagAnterior )

         if !empty( cAlias ) .and. ( cAlias )->( Used() )

            ( cAlias )->( OrdSetFocus( cOldIndexName, cBagAnterior ) )
            ( cAlias )->( OrdDestroy( cNamAnterior, cBagAnterior ) )
            ( cAlias )->( dbGoTo( nRecAnterior ) )

            cOldIndexName  := nil
            nRecAnterior   := nil
            cBagAnterior   := nil

         end if

      end if

   end if

   if lUser
      cFiltroUsuario    := ""
   end if

   if lFecha
      cFiltroFecha      := ""
   end if

Return .t.

//---------------------------------------------------------------------------//

Function OrdClearScope( oBrw, dbf )

   if !empty( dbf ) .and. ( dbf )->( Used() )
      ( dbf )->( OrdScope( 0, nil ) )
      ( dbf )->( OrdScope( 1, nil ) )
   end if

   if oBrw != nil
      oBrw:Refresh()
   end if

Return .t.

//---------------------------------------------------------------------------//

Function buildSetFilter( cExpresionFilter, cAlias, lInclude, cExpUsuario, cExpFecha )

   local cOrdKey
   local bExpFilter

   DEFAULT lInclude     := .t.
   DEFAULT cExpUsuario  := ""
   DEFAULT cExpFecha    := ""

   cOrdKey              := ( cAlias )->( OrdKey() )

   if lInclude
      cExpresionFilter  := "'" + cExpresionFilter + "' $ " + cOrdKey + " .and. !Deleted()"
   end if

   if empty( cExpUsuario ) .and. !empty( cFiltroUsuario )
      cExpresionFilter  += if( !empty( cExpresionFilter ), " .and. ", "" ) + cFiltroUsuario
   end if

   if empty( cExpFecha ) .and. !empty( cFiltroFecha )
      cExpresionFilter  += if( !empty( cExpresionFilter ), " .and. ", "" ) + cFiltroFecha
   end if

   if !empty( cExpresionFilter )
      ( cAlias )->( adsSetAOF( cExpresionFilter ) )
      ( cAlias )->( dbgotop() )
   end if

Return nil

//---------------------------------------------------------------------------//

Function quitSetFilter( cAlias )

   if !empty( cAlias ) .and. ( cAlias )->( used() )
      ( cAlias )->( dbClearFilter() )
   end if

Return nil

//---------------------------------------------------------------------------//
