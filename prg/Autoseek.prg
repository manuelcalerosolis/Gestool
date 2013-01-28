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
   local xCadena  := Space( 100 )
	local nOrdAnt

	DEFAULT cAlias	:= Alias()
   DEFAULT aIndex := { "Código", "Descripción" }

   nOrdAnt        := ( cAlias )->( OrdNumber() )
   cIndice        := aIndex[ Min( nOrdAnt, Len( aIndex ) ) ]
   cType          := ( cAlias )->( dbOrderInfo( DBOI_KEYTYPE ) )

   DEFINE DIALOG oDlg RESOURCE "SSEARCH"

	REDEFINE GET oCadena VAR xCadena ;
      ID          100 ;
      PICTURE     "@!" ;
      ON CHANGE   ( lBigSeek( nil, oCadena, cAlias ), ( if( !Empty( oBrw ), oBrw:Refresh(), ) ) );
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

FUNCTION AutoSeek( nKey, nFlags, oGet, oBrw, xAlias, lUpper, cPreFij, lAllowFilter, lNotUser, lNotFecha )

   local cType
	local xCadena
   local lReturn        := .t.

   DEFAULT xAlias       := Alias()
   DEFAULT lUpper       := .t.
   DEFAULT lAllowFilter := .t.
   DEFAULT lNotUser     := .t.
   DEFAULT lNotFecha    := .t.

   if ValType( xAlias ) == "O"
      xAlias            := xAlias:cAlias
   end if

   oGet:Assign()

   xCadena              := Rtrim( oGet:VarGet() )

   cType                := ( xAlias )->( dbOrderInfo( DBOI_KEYTYPE ) )

   do case
      case cType == "C"

         if lUpper
            xCadena     := Upper( xCadena )
         end if

      case cType == "N"

         xCadena        := Val( xCadena )

   end case

   if lBigSeek( cPreFij, xCadena, xAlias, oBrw, lNotUser, lNotFecha ) .or. Empty( xCadena )

      oGet:SetColor( Rgb( 0, 0, 0 ), Rgb( 255, 255, 255 ) )

   else

      oGet:SetColor( Rgb( 255, 255, 255 ), Rgb( 255, 102, 102 ) )

      lReturn           := .f.

   end if

   if oBrw != nil
      oBrw:Refresh( .t. )
   end if

Return ( lReturn )

//--------------------------------------------------------------------------//

FUNCTION lBigSeek( cPreFij, xCadena, xAlias, oBrw, lNotUser, lNotFecha )

   local oCol
   local xVal
   local nRec
   local nLen
   local lRet        := .f.
   local cSort
   local nSort

   DEFAULT lNotUser  := .t.
   DEFAULT lNotFecha := .t.

   if IsObject( xCadena )
      xCadena:Assign()
      xCadena        := xCadena:VarGet()
   end if

   xCadena           := StrTran( xCadena, Chr( 8 ), "" )

   if !Empty( cPreFij )
      xCadena        := cPreFij + xCadena
   end if

   xCadena           := Alltrim( xCadena )

   if IsObject( xAlias )
      xAlias         := xAlias:cAlias
   end if

   if !( xAlias )->( Used() )
      return .t.
   end if

   /*
   Probando ordWildSeek--------------------------------------------------------

   if Left( xCadena, 1 ) == "*"
      if Right( xCadena, 1 ) == "*" .and. len( Rtrim( xCadena ) ) > 1
         if ( xAlias )->( ordWildSeek( xCadena, .t. ) )
            return .t.
         else
            return .f.
         end if
      else
         return .t.
      end if
   end if
   */

   /*
   Filtros desde la cabecera---------------------------------------------------
   */

   DestroyFastFilter( xAlias, .f., .f. )

   CreateFastFilter( "", xAlias, .f., , , , lNotUser, lNotFecha )

   if Left( xCadena, 1 ) == "*"

      if Right( xCadena, 1 ) == "*" .and. len( Rtrim( xCadena ) ) > 1

         CreateFastFilter( SubStr( xCadena, 2, len( xCadena ) - 2 ), xAlias, .t. , , , , lNotUser, lNotFecha )

         return .t.

      else

         CreateFastFilter( "", xAlias, .f., , , , lNotUser, lNotFecha )

         return .t.

      end if

   end if

   /*
   Comprobaciones antes de buscar----------------------------------------------
   */

   cSort       := ( xAlias )->( OrdSetFocus() )

   lRet        := lMiniSeek( cPrefij, xCadena, xAlias, nLen )

   if uFieldEmpresa( "lBusCir" )

      if !lRet .and. !Empty( oBrw )

         for each oCol in oBrw:aCols

            if isChar( oCol:cSortOrder ) .and. !Empty( oCol:cSortOrder )

               ( xAlias )->( OrdSetFocus( oCol:cSortOrder ) )

               lRet  := lMiniSeek( cPrefij, xCadena, xAlias, nLen )

               if lRet
                  oCol:SetOrder()
                  if !Empty( oCol:bLClickHeader )
                     Eval( oCol:bLClickHeader, nil, nil, nil, oCol )
                  end if
                  oBrw:Select( 0 )
                  oBrw:Select( 1 )
                  oBrw:Refresh()
                  exit
               end if

            end if

         next

      end if

   end if

   if !lRet
      ( xAlias )->( OrdSetFocus( cSort ) )
   end if

RETURN ( lRet )

//---------------------------------------------------------------------------//

Function lMiniSeek( cPrefij, xCadena, xAlias, nLen )

   local n
   local nRec
   local lRet     := .f.
   local cPre
   local cPos
   local cType
   local oBlock
   local oError

   cType          := ( xAlias )->( dbOrderInfo( DBOI_KEYTYPE ) )

   if !( cType $ "CDN" )
      return .f.
   end if

   oBlock         := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   nRec           := ( xAlias )->( Recno() )

   if !Empty( xCadena )

      ( xAlias )->( OrdScope( 0, nil ) )
      ( xAlias )->( OrdScope( 1, nil ) )

      do case
      case cType == "D"

         if len( Rtrim( xCadena ) ) == 10
            if ( xAlias )->( dbSeek( Ctod( xCadena ), .t. ) )
               ( xAlias )->( OrdScope( 0, Ctod( xCadena ) ) )
               ( xAlias )->( OrdScope( 1, Ctod( xCadena ) ) )
            else
               ( xAlias )->( OrdScope( 0, nil ) )
               ( xAlias )->( OrdScope( 1, nil ) )
            end if
         end if

         lRet     := .t.

      case cType == "N"

         if ( xAlias )->( dbSeek( Val( xCadena ), .t. ) )
            lRet  := .t.
         else
            lRet  := .t.
         end if

      case cType == "C"

         if ( xAlias )->( dbSeek( xCadena, .t. ) )

            ( xAlias )->( OrdScope( 0, xCadena ) )
            ( xAlias )->( OrdScope( 1, xCadena ) )

            lRet     := .t.

         else

            nLen     := 14

            if Empty( cPrefij )

               cPre  := SubStr( xCadena, 1, 1 )
               cPos  := Padl( Rtrim( SubStr( xCadena, 2, nLen - 1 ) ), nLen - 1 )

               for n := 1 to nLen

                  if ( xAlias )->( dbSeek( cPre + cPos, .f. ) )

                     ( xAlias )->( OrdScope( 0, cPre + cPos ) )
                     ( xAlias )->( OrdScope( 1, cPre + cPos ) )

                     lRet  := .t.
                     exit

                  end if

                  if Empty( SubStr( cPos, 2, 1 ) )
                     lRet  := .f.
                     cPos  := SubStr( cPos, 2, len( cPos ) - 1 )
                  else
                     lRet  := .f.
                     exit
                  end if

               next

            else

               ( xAlias )->( OrdScope( 0, cPreFij ) )
               ( xAlias )->( OrdScope( 1, cPreFij ) )

            end if

         end if

      end case

      if !lRet
         ( xAlias )->( dbGoTo( nRec ) )
      end if

   else

      ( xAlias )->( OrdScope( 0, cPreFij ) )
      ( xAlias )->( OrdScope( 1, cPreFij ) )

      lRet           := .f.

   end if

   if !lRet
      ( xAlias )->( dbGoTo( nRec ) )
   end if

   RECOVER USING oError

   END SEQUENCE

   ErrorBlock( oBlock )

Return ( lRet )

//---------------------------------------------------------------------------//

Function CreateUserFilter( cExpFilter, cAlias, lInclude, oMeter, cExpUsuario, cExpFecha )

RETURN ( CreateFastFilter( cExpFilter, cAlias, lInclude, oMeter, cExpUsuario, cExpFecha, .f., .f. ) )

//---------------------------------------------------------------------------//

Function CreateFastFilter( cExpFilter, cAlias, lInclude, oMeter, cExpUsuario, cExpFecha, lNotUser, lNotFecha )

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

   if Empty( cAlias )
      return .f.
   end if

   oBlock                  := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   if !Empty( cExpUsuario )
      cFiltroUsuario       := cExpUsuario
   else
      cFiltroUsuario       := ""
   end if

   if !Empty( cExpFecha )

      if cExpFecha == "all"
         cFiltroFecha      := ""
      else
         cFiltroFecha      := cExpFecha
      end if

   end if

   if lAds() .or. lAIS()

      cOrdKey              := ( cAlias )->( OrdKey() )

      if lInclude
         cExpFilter        := "'" + cExpFilter + "' $ " + cOrdKey + " .and. !Deleted()"
      end if

      if Empty( cExpUsuario ) .and. !Empty( cFiltroUsuario )
         cExpFilter        += if( !Empty( cExpFilter ), " .and. ", "" ) + cFiltroUsuario
      end if

      if Empty( cExpFecha ) .and. !Empty( cFiltroFecha )
         cExpFilter        += if( !Empty( cExpFilter ), " .and. ", "" ) + cFiltroFecha
      end if

      if !Empty( cExpFilter )

         bExpFilter        := bCheck2Block( cExpFilter )

         ( cAlias )->( dbSetFilter( bExpFilter, cExpFilter ) )
         ( cAlias )->( dbGoTop() )

      else

         ( cAlias )->( dbSetFilter() )

      end if

   else

      nRecAnterior         := ( cAlias )->( Recno() )
      cOldIndexName        := ( cAlias )->( OrdSetFocus() )
      cBagAnterior         := ( cAlias )->( dbOrderInfo( DBOI_FULLPATH ) )
      cNamAnterior         := "OrdTmp" + cCurUsr()
      cCondAnterior        := ( cAlias )->( dbOrderInfo( DBOI_CONDITION ) )

      cOrdKey              := ( cAlias )->( OrdKey() )
      bOrdKey              := c2Block( cOrdKey )

      if !Empty( oMeter )
         nEvery            := Int( ( cAlias )->( OrdKeyCount() ) / 10 )
         bEvery            := {|| oMeter:Set( ( cAlias )->( OrdKeyNo() ) ) }
      end if

      if lInclude
         cExpFilter        := "'" + cExpFilter + "' $ " + cOrdKey + ".and. " + cCondAnterior
      end if

      if !lNotUser .and. Empty( cExpUsuario ) .and. !Empty( cFiltroUsuario )
         if !Empty( cExpFilter )
            cExpFilter     += " .and. " + cFiltroUsuario
         else
            cExpFilter     := cFiltroUsuario
         end if
      end if

      if !lNotFecha .and. Empty( cExpFecha ) .and. !Empty( cFiltroFecha )
         if !Empty( cExpFilter )
            cExpFilter     += " .and. " + cFiltroFecha
         else
            cExpFilter     := cFiltroFecha
         end if
      end if

      Select( cAlias )

      bExpFilter           := bCheck2Block( cExpFilter )

      if !Empty( bExpFilter ) .and. !Empty( cOldIndexName ) .and. !Empty( cBagAnterior )
         ( cAlias )->( OrdCondSet( cExpFilter, bExpFilter ) )
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


Return ( bExpFilter != nil )

//---------------------------------------------------------------------------//

Function DestroyFastFilter( cAlias, lUser, lFecha )

   DEFAULT lUser       := .f.
   DEFAULT lFecha      := .f.

   if lAds() .or. lAIS()

      if !Empty( cAlias ) .and. ( cAlias )->( used() )
         ( cAlias )->( dbClearFilter() )
      end if

   else

      if !Empty( cBagAnterior )

         if !Empty( cAlias ) .and. ( cAlias )->( Used() )

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

   if !Empty( dbf ) .and. ( dbf )->( Used() )
      ( dbf )->( OrdScope( 0, nil ) )
      ( dbf )->( OrdScope( 1, nil ) )
   end if

   if oBrw != nil
      oBrw:Refresh()
   end if

Return .t.

//---------------------------------------------------------------------------//
//
// Crea Bag Customer con tags indicados o Bag normal con sus tags correspondientes si es un filtro
//
/*
FUNCTION cAddBagTmp( aTags, xCond, cBag, lAddKeys, lCustomer, lTemporal )

   LOCAL nPos, cCond, bCond
   LOCAL nTag  := OrdNumber()
   LOCAL nTags := Len( aTags )
   LOCAL cType := ValType( xCond )

   DEFAULT cBag      := cTmpFileName( "CDX" ),;
           lAddKeys  := .T.,;
           lCustomer := cType $ 'BUA',;
           lTemporal := .F.

   IF cType = 'B'
      cCond := ''
      bCond := xCond
   ELSEIF cType != 'A'
      DEFAULT xCond := '.T.'
      cCond := xCond
      bCond := &('{|| ' + xCond + '}')
   ENDIF

   IF ! lCustomer .OR. ( lAddKeys .AND. cType != 'A' )

      FOR nPos := 1 TO nTags
         IF Len( aTags[nPos] ) = 2
            AAdd( aTags[nPos], &('{|| ' + aTags[nPos,2] + '}') )
         ENDIF
         OrdCondSet( cCond, bCond,,,,,,,,,,, .T., .T.,,,, lTemporal, .T., .T. )
         OrdCreate( cBag, aTags[nPos,1], aTags[nPos,2], aTags[nPos,3] )
         IF lCustomer
            DbOrderInfo( DBOI_CUSTOM, cBag, aTags[nPos,1], .T. )
            DbOrderInfo( DBOI_CONDITION, cBag, aTags[nPos,1], ".T." )
         ENDIF
      NEXT nPos
      OrdListAdd( cBag )
      OrdSetFocus( aTags[1,1], cBag )
      DbGoTop()
   ELSE
      FOR nPos := 1 TO nTags
         IF Len( aTags[nPos] ) = 2
            AAdd( aTags[nPos], &('{|| ' + aTags[nPos,2] + '}') )
         ENDIF
         OrdCondSet( ,,,,,,,,,,,, .T., .F., .T., .F.,, lTemporal, .T., .T. )
         OrdCreate( cBag, aTags[nPos,1], aTags[nPos,2], aTags[nPos,3] )
      NEXT nPos
      OrdListAdd( cBag )
      OrdSetFocus( nTag )
      IF lAddKeys // cType == 'A'
         IF nTags = 1
            AEval( xCond, {|n| DbGoTo( n ), OrdKeyAdd( aTags[1,1], cBag ) } )
         ELSE
            AEval( xCond, {|n| DbGoTo( n ), AEval( aTags, {|a| OrdKeyAdd( a[1], cBag ) } ) } )
         ENDIF
         // Fijamos primer tag del bag temporal
         OrdSetFocus( aTags[1,1], cBag )
         DbGoTop()
      ENDIF
   ENDIF

RETURN cBag
*/
//---------------------------------------------------------------------------//