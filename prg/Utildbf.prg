#include "FileIO.ch"
#include "FiveWin.Ch"
#include "Error.ch"
#include "DbStruct.ch"
#include "DbInfo.ch"
#include "Factu.ch" 
#include "RichEdit.ch" 
#include "hbwin.ch"
#include "hbMemory.ch"

//----------------------------------------------------------------------------//

#define NNET_TIME                            10

#define MODE_FILE                            1
#define MODE_RECORD                          2
#define MODE_APPEND                          3

#ifndef HB_ZEBRA_ERROR_INVALIDZEBRA
#define HB_ZEBRA_ERROR_INVALIDZEBRA          101
#endif

static aResources             := {}
static aAdsDirectory          := {}

static cLenguajeSegundario    := ""

static hTraslations           := {=>}

static scriptSystem

//--------------------------------------------------------------------------//
// Funciones para DBF's
//
//--------------------------------------------------------------------------//

FUNCTION dbSwapUp( cAlias, oBrw )

	local aRecNew
   local aRecOld  := dbScatter( cAlias )
   local nOrdNum  := ( cAlias )->( OrdSetFocus( 0 ) )
   local nRecNum  := ( cAlias )->( RecNo() )

   ( cAlias )->( dbSkip( -1 ) )

   if ( cAlias )->( Bof() )
		Tone(300,1)
		( cAlias )->( dbGoTo( nRecNum ) )
   else
      aRecNew     := dbScatter( cAlias )
      ( cAlias )->( dbSkip( 1 ) )
      dbGather( aRecNew, cAlias )
      ( cAlias )->( dbSkip( -1 ) )
      dbGather( aRecOld, cAlias )
   end if

   ( cAlias )->( OrdSetFocus( nOrdNum ) )

   if !empty( oBrw )
      oBrw:Refresh()
      oBrw:select( 0 )
      oBrw:select( 1 )
      oBrw:SetFocus()
   end if

RETURN NIL

//--------------------------------------------------------------------------//

FUNCTION dbSwapDown( cAlias, oBrw )

	local aRecNew
   local aRecOld  := dbScatter( cAlias )
   local nOrdNum  := ( cAlias )->( OrdSetFocus( 0 ) )
   local nRecNum  := ( cAlias )->( RecNo() )

   ( cAlias )->( dbSkip() )

   if ( cAlias )->( Eof() )

      Tone( 300, 1 )
		( cAlias )->( dbGoTo( nRecNum ) )

   else

      aRecNew     := dbScatter( cAlias )
      ( cAlias )->( dbSkip( -1 ) )

      dbGather( aRecNew, cAlias )
      ( cAlias )->( dbSkip() )

      dbGather( aRecOld, cAlias )

   end if

   ( cAlias )->( OrdSetFocus( nOrdNum ) )

   if !empty( oBrw )
      oBrw:Refresh()
      oBrw:select( 0 )
      oBrw:select( 1 )
      oBrw:SetFocus()
   end if

RETURN nil

//--------------------------------------------------------------------------//

FUNCTION DBTrans( cAliOrigen, cAliDestino, lApp )

	local i
	local nField 	:= (cAliOrigen)->( Fcount() )

	DEFAULT lApp	:= .f.

	IF lApp
		(cAliDestino)->( dbAppend() )
   ELSE
      (cAliDestino)->( dbRLock() )
   END IF

	for i = 1 to nField
		(cAliDestino)->( FieldPut( i, (cAliOrigen)->( FieldGet( i ) ) ) )
	next

   ( cAliDestino )->( dbUnLock() )

RETURN NIL

//----------------------------------------------------------------------------//
/*
Bloquea un fichero
*/

FUNCTION DBFLock( cAlias )

	if DBLock( cAlias, MODE_FILE )
      RETURN .T.
   endif

   while ApoloMsgNoYes( "Fichero Bloquedo," + CRLF + "� Reintentar ?" )

		if DBLock( cAlias, MODE_FILE )
         RETURN .T.
		else
			loop
		endif

   enddo

RETURN .F.

//--------------------------------------------------------------------------//

FUNCTION aBlankArray( aBlank, cAlias )

   local i
   local aStruct  := ( cAlias )->( dbStruct() )

   for i = 1 to ( cAlias )->( fCount() )
      Do Case
         Case aStruct[ i, DBS_TYPE ] == "C"
            aBlank[ i ] := Space( aStruct[ i, DBS_LEN ] )
         Case aStruct[ i, DBS_TYPE ] == "M"
            aBlank[ i ] := ""             // Space( aStruct[ i, DBS_LEN ] )
         Case aStruct[ i, DBS_TYPE ] == "N"
            aBlank[ 1 ] := Val( "0." + Replicate( "0", aStruct[ i, DBS_DEC ] ) )
         Case aStruct[ i, DBS_TYPE ] == "L"
            aBlank[ 1 ] := .f.
         Case aStruct[ i, DBS_TYPE ] == "D"
            aBlank[ 1 ] := GetSysDate()   // CtoD( "" ) )
      End Case
   next

RETURN aBlank

//--------------------------------------------------------------------------//
/*
Comprueba que no exista el mismo nombre de fichero
*/

FUNCTION cFilName( cFilName )

	local n := 1

	while file( cFilName + rjust( str( n ), "0", 2 ) )
		n++
	end

RETURN ( cFilName + rjust( str( n ), "0", 2 ) )

//---------------------------------------------------------------------------//

/*
Busca el primero valido dentro de un indice y desde un valor
como origen
*/

FUNCTION dbFirst( cAlias, nField, oGet, xDesde, nOrd )

	local xValRet
   local nPosAct
   local nOrdAct

   DEFAULT cAlias := Alias()
	DEFAULT nField	:= 1

   /*
   Para TDBF-------------------------------------------------------------------
   */

   if IsObject( cAlias )
      cAlias      := cAlias:cAlias
   end if

   nPosAct        := ( cAlias )->( Recno() )

   if nOrd != nil
      nOrdAct     := ( cAlias )->( OrdSetFocus( nOrd ) )
   end if

   if empty( xDesde )
      ( cAlias )->( dbGoTop() )
   else
      ( cAlias )->( dbSeek( xDesde, .t. ) ) // Busqueda suuuuave
      if ( cAlias )->( eof() )
         ( cAlias )->( dbGoTop() )
      end if
   end if

   if IsChar( nField )
      nField      := ( cAlias )->( FieldPos( nField ) )
   end if

   xValRet        := ( cAlias )->( FieldGet( nField ) )

   ( cAlias )->( dbGoTo( nPosAct ) )

   if !empty( nOrd )
      ( cAlias )->( OrdSetFocus( nOrdAct ) )
   end if

   if !empty( oGet )
		oGet:cText( xValRet )
      RETURN .t.
   end if

RETURN ( xValRet )

//--------------------------------------------------------------------------//

/*
Busca el primero valido dentro de un indice
*/

FUNCTION dbFirstIdx( cAlias, nOrden, oGet, xDesde )

	local xValRet

	DEFAULT cAlias := Alias()

	IF nOrden == NIL
		nOrden := ( cAlias )->( OrdSetFocus() )
	ELSE
		( cAlias )->( OrdSetFocus( nOrden ) )
	END IF

	select( cAlias )

	IF xDesde == NIL
		(cAlias)->( DbGoTop() )
	ELSE
		(cAlias)->( DbSeek( xDesde, .T. ) )	// Busqueda suuuuave
		IF (cAlias)->(Eof())
			(cAlias)->(DbGoTop())
		END
	END

	xValRet	:= Eval( Compile( (cAlias)->( OrdKey( nOrden ) ) ) )

	IF oGet != NIL
		oGet:cText( xValRet )
		RETURN .T.
	END

RETURN ( xValRet )

//--------------------------------------------------------------------------//

/*
Busca el ultimo registro dentro de un indice
*/

FUNCTION dbLastIdx( cAlias, nOrden, oGet, xHasta )

	local xValRet

	DEFAULT cAlias := Alias()

	IF nOrden == NIL
		nOrden := ( cAlias )->( OrdSetFocus() )
	ELSE
		( cAlias )->( OrdSetFocus( nOrden ) )
	END IF

	select( cAlias )

	IF xHasta == NIL
		(cAlias)->(DbGoBottom())
	ELSE
		(cAlias)->( DbSeek( xHasta, .T. ) )
		IF (cAlias)->( Eof() )
			(cAlias)->(DbGoBottom())
		END
	END

	xValRet := Eval( Compile( (cAlias)->( OrdKey( nOrden ) ) ) )

	IF oGet != NIL
		oGet:cText( xValRet )
		RETURN .T.
	END

RETURN ( xValRet )

//--------------------------------------------------------------------------//

/*
Devuelva una array con todos los tags de un indice
*/

FUNCTION DBRetIndex( cAlias )

	local aIndexes := { "<Ninguno>" }
	local cIndice
   local i        := 1

   IF empty( ( cAlias )->( OrdSetFocus() ) )
		RETURN aIndexes
	END IF

   while .t.
      cIndice     := ( cAlias )->( OrdName( i ) )

      if cIndice != ""
         aAdd( aIndexes, cIndice )
      else
         exit
      end if

		i++
   end while

RETURN aIndexes

//--------------------------------------------------------------------------//

FUNCTION aDbfToArr( cAlias, nField )

   local aTabla   := {}

	DEFAULT cAlias := Alias()
	DEFAULT nField := 1

   ( cAlias )->( dbGoTop() )
   while !( cAlias )->( Eof() )
      aAdd( aTabla, cValToChar( ( cAlias )->( FieldGet( nField ) ) ) )
      ( cAlias )->( dbSkip() )
   end while
   ( cAlias )->( dbGoTop() )

RETURN aTabla

//--------------------------------------------------------------------------//

/*
Cambia el indice y coloca en los valores correspondientes en las
variables pasadas
*/

FUNCTION ChangeIndex( cAlias, nRadOrden, oGetDesde, oGetHasta )

	DEFAULT cAlias    := Alias()
	DEFAULT nRadOrden := ( cAlias )->( OrdSetFocus() )

	IF oGetDesde != NIL
		oGetDesde:cText( DBFirstIdx( cAlias, nRadOrden ) )
	END IF

	IF oGetHasta != NIL
		oGetHasta:cText( DBLastIdx( cAlias, nRadOrden ) )
	END IF

RETURN .T.

//---------------------------------------------------------------------------//

FUNCTION oExiste( oClave, cAlias )

RETURN Existe( oClave:varGet(), cAlias )

//-------------------------------------------------------------------------//

FUNCTION oNotExiste( oClave, cAlias )

RETURN ( !Existe( oClave:varGet(), cAlias ) )

//---------------------------------------------------------------------------//

FUNCTION cNoExt( cFullFile )

   local cNameFile := AllTrim( cFullFile )
   local n         := AT( ".", cNameFile )

RETURN AllTrim( if( n > 0, left( cNameFile, n - 1 ), cNameFile ) )

//----------------------------------------------------------------------------//

FUNCTION cNoPathInt( cFileName, cCon )

   DEFAULT cCon := "/"

RETURN Alltrim( SubStr( cFileName, RAt( cCon, cFileName ) + 1 ) )

//----------------------------------------------------------------------------//

FUNCTION cOnlyPath( cFileName )

RETURN Alltrim( SubStr( cFileName, 1, RAt( "\", cFileName ) ) )

//----------------------------------------------------------------------------//

FUNCTION cDrivePath( cFileName )

RETURN SubStr( cFileName, 1, RAt( ":", cFileName ) + 1 )

//----------------------------------------------------------------------------//

FUNCTION cFirstPath( cPath )

   local nAt     := At( "\", cPath )

   if nAT == 0
      nAt        := At( "/", cPath )
   end if

RETURN SubStr( cPath, 1, nAt - 1 )

//----------------------------------------------------------------------------//

FUNCTION cLastPath( cFileName )

   local cLastPath   := cOnlyPath( cFileName )
   local n           := Rat( "\", SubStr( cLastPath, 1, Len( cLastPath ) - 1 ) ) + 1

RETURN ( SubStr( cLastPath, n ) )

//----------------------------------------------------------------------------//

FUNCTION cPath( cPath )

   cPath             := Rtrim( cPath )

   if Right( cPath, 1 ) != "\"
      cPath          += "\"
   end if

RETURN ( cPath )

//----------------------------------------------------------------------------//

FUNCTION cLeftPath( cPath )

   cPath             := Rtrim( cPath )

   if Right( cPath, 1 ) != "/"
      cPath          += "/"
   end if

RETURN ( cPath )

//----------------------------------------------------------------------------//

FUNCTION recursiveMakeDir( cPath )

   local cRute       := ""
   local aPath       := hb_atokens( cPath, "\" )

   for each cPath in aPath 
      cRute          += cPath + "\"
      if !( ":" $ cPath ) .and. !lIsDir( cRute )
         MakeDir( cRute )
      end if 
   next

RETURN ( cPath )

//----------------------------------------------------------------------------//

FUNCTION EvalGet( aGet, nMode )

	local i
   local nLen  := len( aGet )

   for i = 1 to nLen

      if ValType( aGet[i] ) == "O"
         if "GET" $ aGet[ i ]:ClassName()
            aGet[ i ]:lValid()
         end if
      end if

   next

RETURN nil

//-------------------------------------------------------------------------//

FUNCTION bChar2Block( cChar, lLogic, lMessage, lHard )

	local bBlock
   local oBlock
   local oError
   local lError      := .f.

   DEFAULT lLogic    := .f.
   DEFAULT lMessage  := .t.
   DEFAULT lHard     := .f.

   if empty( cChar )

      if lLogic
         bBlock      := {|| .t.}
      else
         bBlock      := {|| "" }
      end if

      RETURN ( bBlock )

   end if

   oBlock            := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      /*
      Esto es para probar la expresion-----------------------------------------
      */

      if ValType( cChar ) == "C"
         cChar    := rtrim( cChar )
         bBlock   := &( "{||" + cChar + "}" )

      elseif ValType( cChar ) == "N"
         bBlock   := {|| cChar }

      end if

      /*
      Probamos la expresion-------------------------------------------------
      */

      Eval( bBlock )

   RECOVER USING oError

      lError         := .t.

   END SEQUENCE

   ErrorBlock( oBlock )

   if lError

      if lMessage
         msgStop( "Expresi�n incorrecta " + cChar + CRLF + ErrorMessage( oError ), "bChar2Block" + Type( cChar ) )
      end if

      if lHard
         bBlock      := nil
      else
         if lLogic
            bBlock   := {|| .t.}
         else
            bBlock   := {|| "" }
         end if
      end if

   end if

RETURN ( bBlock )

//---------------------------------------------------------------------------//

// Marca registro a bajo nivel en el espacio de la marca del deleted
// si lo consigue devuelve .t.

FUNCTION SetMarkRec( cMark, nRec  )

   local nRecNo   := RecNo()
   local nHdl     := DbfHdl()
   local nOffSet  := 0

   nRec           := if( ValType( nRec )  != "N", RecNo(), nRec  )
   cMark          := if( ValType( cMark ) != "C", "#",     cMark )

   nOffSet        := ( RecSize() * ( nRec - 1 ) ) + Header()

   FSeek( nHdl, nOffSet, 0 )
   FWrite( nHdl, cMark, 1 )

   DbGoTo( nRecNo )

RETURN( FError() == 0 )

//---------------------------------------------------------------------------//
// Invierte la marca del registro

FUNCTION ChgMarked( cMark, nRec )

   if lMarked( cMark, nRec )
      SetMarkRec( Space( 1 ), nRec )
   else
      SetMarkRec( cMark, nRec )
   end if

RETURN ( nil )

//---------------------------------------------------------------------------//
// Marca registro a bajo nivel en el espacio de la marca del deleted
// si lo consigue devuelve .t.

FUNCTION SetAllMark( cMark, cAlias )

   local nRecNo   := ( cAlias )->( RecNo() )

   cMark          := if( ValType( cMark ) != "C", "#", cMark )

   ( cAlias )->( dbGoTop() )
   while !( cAlias )->( eof() )

      ( cAlias )->( SetMarkRec( cMark ) )
      ( cAlias )->( dbSkip() )

   end while

   ( cAlias )->( DbGoTo( nRecNo ) )

RETURN ( nil )

//---------------------------------------------------------------------------//

FUNCTION SkipFor( nWantMoved, cAlias, bFor )

   local nMoved   := 0

   if nWantMoved < 0

      while nMoved > nWantMoved .and. !( cAlias )->( bof() )
         ( cAlias )->( dbSkip( -1 ) )
         if ( cAlias )->( Eval( bFor ) )
            nMoved--
         end if
      end while

   else

      while nMoved < nWantMoved .and. !( cAlias )->( eof() )
         ( cAlias )->( dbSkip() )
         if ( cAlias )->( Eval( bFor ) )
            nMoved++
         end if
      end while


   end if

RETURN ( nMoved )

//---------------------------------------------------------------------------//

FUNCTION NotMinus( nUnits )

RETURN ( if( nUnits < 0, 0, nUnits ) )

//--------------------------------------------------------------------------//

FUNCTION cDateTime()

RETURN ( Dtos( Date() ) + Left( StrTran( Time(), ":","" ), 4 ) )

//----------------------------------------------------------------------------//

FUNCTION lNegativo( nNum )

RETURN ( -0.1 > nNum )

//---------------------------------------------------------------------------//

FUNCTION IsArray( u )

RETURN ( Valtype( u ) == "A" )

//---------------------------------------------------------------------------//

FUNCTION IsHash( u )

RETURN ( HB_isHash( u ) )

//---------------------------------------------------------------------------//

FUNCTION retChr( cCadena )

   local cChr     := ""

   if Valtype( cCadena ) != "C"
      RETURN ( cChr )
   end if

   cCadena        := AllTrim( cCadena )

   if !empty( cCadena )
      cCadena     += Space( 1 )
   end if

   while !empty( cCadena )
      cChr        += Chr( Val( SubStr( cCadena, 1, At( " ", cCadena ) ) ) )
      cCadena     := SubStr( cCadena, At( " ", cCadena ) + 1 )
   end while

RETURN ( cChr )

//---------------------------------------------------------------------------//

FUNCTION DateToJuliano( dFecha )

   local dInicial

   DEFAULT dFecha := Date()

   dInicial       := Ctod( "01/01/" + AllTrim( Str( Year( dFecha ) ) ) )

RETURN ( dFecha - dInicial + 1 )

//---------------------------------------------------------------------------//

FUNCTION JulianoToDate( nYear, nJuliana )

   local dFecIni

   DEFAULT nYear     := Year( Date() )
   DEFAULT nJuliana  := 0

   dFecIni           := Ctod( "01/01/" + Str( nYear, 4, 0 ) )

RETURN ( dFecIni + nJuliana - 1 )

//---------------------------------------------------------------------------//

FUNCTION addMonth( ddate, nMth )

   local nDay
   local nMonth
   local nYear
   local nLDOM

   nDay     := Day( dDate )
   nMonth   := Month( dDate )
   nYear    := Year( dDate )

   nMonth   += nmth

   if nMonth <= 0
      do while nMonth <= 0
         nMonth += 12
         nYear--
      enddo
   endif

   if nMonth > 12
      do while nMonth > 12
         nMonth -= 12
         nYear++
      enddo
   endif

   // correction for different end of months
   if nDay > ( nLDOM := lastdayom( nMonth ) )
     nDay   := nLDOM
   endif

RETURN ( Ctod( StrZero( nDay, 2 ) + "/" + StrZero( nMonth, 2 ) + "/" + StrZero( nYear, 4 ) ) )

//---------------------------------------------------------------------------//

FUNCTION LastDayoM( xDate )

   local nMonth   := 0
   local nDays    := 0
   local lleap    := .F.

   do case
      case empty ( xDate)
         nMonth   := month( date() )

      case valtype ( xDate ) == "D"
         nMonth   := month (xdate)
         lleap    := isleap ( xdate)

      case valtype (xDate ) == "N"
         if xdate > 12
            nmonth := 0
         else
            nMonth := xDate
         endif
   endcase

   if nmonth != 0
      ndays       := daysInmonth( nMonth, lleap )
   endif

RETURN ndays

//---------------------------------------------------------------------------//

FUNCTION isLeap ( ddate )

   local nYear
   local nMmyr
   local nCyYr
   local nQdYr
   local lRetval

   if empty ( ddate )
     ddate  := date()
   endif

   nYear    := year (ddate)
   nCyYr    := nYear / 400
   nMmyr    := nYear /100
   nQdYr    := nYear / 4

   do case
      case int (nCyYr) == nCyYr
         lRetVal := .T.

      case int (nMmyr) == nMmyr
         lRetVal := .F.

      case int (nQdYr) == nQdYr
         lRetVal := .T.

      otherwise
         lRetVal := .F.
   endcase

RETURN lRetVal

//---------------------------------------------------------------------------//

FUNCTION daysInmonth ( nMonth, lLeap )

   local nday := 0

   do case
   case nMonth == 2 .and. lLeap
      nday  := 29
   case nMonth == 2 .and. !lLeap
      nday  := 28
   case nMonth == 4 .or. nMonth == 6 .or. nMonth == 9 .or. nMonth == 11
      nday  := 30
   otherwise
      nday  := 31
   endcase

RETURN nday

//---------------------------------------------------------------------------//

/*
Selecciona todos los registros
*/

FUNCTION lselectAll( oBrw, dbf, cFieldName, lselect, lTop, lMeter )

   local nPos
   local nRecAct        := ( dbf )->( Recno() )

   DEFAULT cFieldName   := "lSndDoc"
   DEFAULT lselect      := .t.
   DEFAULT lTop         := .t.
   DEFAULT lMeter       := .f.

   if lMeter
      CreateWaitMeter( nil, nil, ( dbf )->( OrdKeyCount() ) )
   else
      CursorWait()
   end if

   if lTop
      ( dbf )->( dbGoTop() )
   end if

   while !( dbf )->( eof() )

      if dbLock( dbf )
         
         nPos           := ( dbf )->( FieldPos( cFieldName ) )
         if nPos != 0
            ( dbf )->( FieldPut( nPos, lselect ) )
         end if
         
         nPos           := ( dbf )->( FieldPos( "dFecCre" ) )
         if nPos != 0
            ( dbf )->( FieldPut( nPos, Date() ) )
         end if
         
         nPos           := ( dbf )->( FieldPos( "cTimCre" ) )
         if nPos != 0
            ( dbf )->( FieldPut( nPos, Time() ) )
         end if
         
         dbSafeUnLock( dbf )

      end if

      ( dbf )->( dbSkip() )

      if lMeter
         RefreshWaitMeter( ( dbf )->( OrdKeyNo() ) )
      else
         SysRefresh()
      end if

   end do

   ( dbf )->( dbGoTo( nRecAct ) )

   if lMeter
      EndWaitMeter()
   else
      CursorWE()
   end if

   if !empty( oBrw )
      oBrw:Refresh()
      oBrw:SetFocus()
   end if

RETURN nil

//---------------------------------------------------------------------------//

FUNCTION ChangeField( dbfAlias, xField, xValue, oBrowse )

   if ( dbfAlias )->( dbRLock() )
      ( dbfAlias )->( FieldPut( ( dbfAlias )->( FieldPos( xField ) ), xValue ) )
      ( dbfAlias )->( dbCommit() )
      ( dbfAlias )->( dbUnLock() )
   end if

   if oBrowse != nil
      oBrowse:Refresh()
   end if

RETURN nil

//---------------------------------------------------------------------------//

FUNCTION Capitalize( cChar )

RETURN ( Upper( Left( cChar, 1 ) ) + Rtrim( Lower( SubStr( cChar, 2 ) ) ) )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS TDesdeHasta

   DATA  cSerieInicio   INIT "A"
   DATA  cSerieFin      INIT "A"
   DATA  nNumeroInicio  INIT 0
   DATA  nNumeroFin     INIT 0
   DATA  cSufijoInicio  INIT Space( 2 )
   DATA  cSufijoFin     INIT Space( 2 )
   DATA  dFechaInicio   INIT Date()
   DATA  dFechaFin      INIT Date()
   DATA  nRadio         INIT 1

   Method Init()  CONSTRUCTOR

   Method cNumeroInicio()  INLINE ::cSerieInicio + Str( ::nNumeroInicio ) + ::cSufijoInicio

END CLASS

//---------------------------------------------------------------------------//

Method Init( cSerie, nNumero, cSufijo, dFecha )

   DEFAULT cSerie       := "A"
   DEFAULT nNumero      := 0
   DEFAULT cSufijo      := Space( 2 )
   DEFAULT dFecha       := Date()

   ::cSerieInicio       := cSerie
   ::cSerieFin          := cSerie
   ::nNumeroInicio      := nNumero
   ::nNumeroFin         := nNumero
   ::cSufijoInicio      := cSufijo
   ::cSufijoFin         := cSufijo
   ::dFechaInicio       := dFecha
   ::dFechaFin          := dFecha

RETURN ( Self )

//---------------------------------------------------------------------------//

FUNCTION DecimalMod( nDividend, nDivisor )

   local nMod  := Int( nDividend / nDivisor )
   nMod        := nDividend - ( nMod * nDivisor )

RETURN ( nMod )

//----------------------------------------------------------------------------//

FUNCTION LTrans( Exp, cSayPicture )

RETURN ( Ltrim( Trans( Exp, cSayPicture ) ) )

//----------------------------------------------------------------------------//
/*
No borrar esta version es para el Garrido
*/

FUNCTION cNumTiket( cCodAlb, dbfAlbCliT )

RETURN ( nil )

//----------------------------------------------------------------------------//

FUNCTION msgDbfInfo( dbfAlias, cTitle )

   local oDlg
   local oTreeInfo

   if empty( dbfAlias )
      RETURN ( nil )      
   end if

   DEFINE DIALOG oDlg RESOURCE "dbInfo" TITLE ( cTitle )

      oTreeInfo   := TTreeView():Redefine( 100, oDlg )

   REDEFINE BUTTON ID ( IDCANCEL ) OF oDlg CANCEL ACTION ( oDlg:end() )

   oDlg:bStart    := {|| StartDbfInfo( dbfAlias, oTreeInfo ) }

   ACTIVATE DIALOG oDlg CENTER

RETURN ( nil )

//---------------------------------------------------------------------------//
// NO BORRAR SE USA EN ALGUNOS SCRIPTS ----------------------------------------

FUNCTION MsgCombo( cTitle, cText, aItems, uVar, cBmpFile, cResName )          

   local oDlg, oBmp, oCbx
   local lOk      := .f.
   local cItem

   DEFAULT cTitle := "Title"
   DEFAULT cText  := "Valor"
   DEFAULT aItems := { "One", "Two", "Three" }

   cItem          := aItems[1]

   DEFINE DIALOG oDlg FROM 10, 20 TO 18, 59.5 TITLE cTitle

   if ! empty( cBmpFile ) .or. ! empty( cResName )

      if ! empty( cBmpFile )
         @ 1, 1 BITMAP oBmp FILENAME cBmpFile SIZE 20, 20 NO BORDER OF oDlg
      endif

      if ! empty( cResName )
         @ 1, 1 BITMAP oBmp RESOURCE cResName SIZE 20, 20 NO BORDER OF oDlg
      endif

      @ 0.5, 6 SAY cText OF oDlg SIZE 250, 10
      
      @ 1.6, 4 COMBOBOX oCbx VAR cItem ;
      SIZE 120, 12 ;
      ITEMS aItems ;

   else   
      
      @ 0.5, 3.3 SAY cText OF oDlg SIZE 250, 10

      @ 1.6, 2.3 COMBOBOX oCbx VAR cItem ;
      SIZE 120, 12 ;
      ITEMS aItems ;

   endif   

   @ 2.25, 7.5 - If( oBmp == nil, 2, 0 ) BUTTON "&Ok"  OF oDlg SIZE 35, 12 ;
      ACTION ( oDlg:End(), lOk := .t. ) DEFAULT

   @ 2.25, 16.5 - If( oBmp == nil, 2, 0 ) BUTTON "&Cancel" OF oDlg SIZE 35, 12 ;
      ACTION ( oDlg:End(), lOk := .f. )

   ACTIVATE DIALOG oDlg CENTERED

   if lOk
      uVar := cItem
   endif

RETURN lOk

//---------------------------------------------------------------------------//

Static FUNCTION StartDbfInfo( dbfAlias, oTreeInfo )

   local n := 0

   select( dbfAlias )

   oTreeInfo:Add( "RDDI_ISDBF       : "  + cValToChar( dbInfo( RDDI_ISDBF       ) ) )
   oTreeInfo:Add( "RDDI_CANPUTREC   : "  + cValToChar( dbInfo( RDDI_CANPUTREC   ) ) )
   oTreeInfo:Add( "RDDI_DELIMITER   : "  + cValToChar( dbInfo( RDDI_DELIMITER   ) ) )
   oTreeInfo:Add( "RDDI_SEPARATOR   : "  + cValToChar( dbInfo( RDDI_SEPARATOR   ) ) )
   oTreeInfo:Add( "RDDI_TABLEEXT    : "  + cValToChar( dbInfo( RDDI_TABLEEXT    ) ) )
   oTreeInfo:Add( "RDDI_MEMOEXT     : "  + cValToChar( dbInfo( RDDI_MEMOEXT     ) ) )
   oTreeInfo:Add( "RDDI_ORDBAGEXT   : "  + cValToChar( dbInfo( RDDI_ORDBAGEXT   ) ) )
   oTreeInfo:Add( "RDDI_ORDEREXT    : "  + cValToChar( dbInfo( RDDI_ORDEREXT    ) ) )
   oTreeInfo:Add( "RDDI_ORDSTRUCTEXT: "  + cValToChar( dbInfo( RDDI_ORDSTRUCTEXT) ) )
   oTreeInfo:Add( "RDDI_LOCAL       : "  + cValToChar( dbInfo( RDDI_LOCAL       ) ) )
   oTreeInfo:Add( "RDDI_REMOTE      : "  + cValToChar( dbInfo( RDDI_REMOTE      ) ) )
   oTreeInfo:Add( "RDDI_CONNECTION  : "  + cValToChar( dbInfo( RDDI_CONNECTION  ) ) )
   oTreeInfo:Add( "RDDI_TABLETYPE   : "  + cValToChar( dbInfo( RDDI_TABLETYPE   ) ) )
   oTreeInfo:Add( "RDDI_MEMOTYPE    : "  + cValToChar( dbInfo( RDDI_MEMOTYPE    ) ) )
   oTreeInfo:Add( "RDDI_LARGEFILE   : "  + cValToChar( dbInfo( RDDI_LARGEFILE   ) ) )
   oTreeInfo:Add( "RDDI_LOCKSCHEME  : "  + cValToChar( dbInfo( RDDI_LOCKSCHEME  ) ) )
   oTreeInfo:Add( "RDDI_RECORDMAP   : "  + cValToChar( dbInfo( RDDI_RECORDMAP   ) ) )
   oTreeInfo:Add( "RDDI_ENCRYPTION  : "  + cValToChar( dbInfo( RDDI_ENCRYPTION  ) ) )
   oTreeInfo:Add( "RDDI_AUTOLOCK    : "  + cValToChar( dbInfo( RDDI_AUTOLOCK    ) ) )
   oTreeInfo:Add( "DBI_DBFILTER     : "  + cValToChar( dbInfo( DBI_DBFILTER     ) ) )

   oTreeInfo:Add( "Index parameters" )
   oTreeInfo:Add( "RDDI_STRUCTORD   : "  + cValToChar( dbInfo( RDDI_STRUCTORD   ) ) )
   oTreeInfo:Add( "RDDI_STRICTREAD  : "  + cValToChar( dbInfo( RDDI_STRICTREAD  ) ) )
   oTreeInfo:Add( "RDDI_STRICTSTRUCT: "  + cValToChar( dbInfo( RDDI_STRICTSTRUCT) ) )
   oTreeInfo:Add( "RDDI_OPTIMIZE    : "  + cValToChar( dbInfo( RDDI_OPTIMIZE    ) ) )
   oTreeInfo:Add( "RDDI_FORCEOPT    : "  + cValToChar( dbInfo( RDDI_FORCEOPT    ) ) )
   oTreeInfo:Add( "RDDI_AUTOOPEN    : "  + cValToChar( dbInfo( RDDI_AUTOOPEN    ) ) )
   oTreeInfo:Add( "RDDI_AUTOORDER   : "  + cValToChar( dbInfo( RDDI_AUTOORDER   ) ) )
   oTreeInfo:Add( "RDDI_AUTOSHARE   : "  + cValToChar( dbInfo( RDDI_AUTOSHARE   ) ) )
   oTreeInfo:Add( "RDDI_MULTITAG    : "  + cValToChar( dbInfo( RDDI_MULTITAG    ) ) )
   oTreeInfo:Add( "RDDI_SORTRECNO   : "  + cValToChar( dbInfo( RDDI_SORTRECNO   ) ) )
   oTreeInfo:Add( "RDDI_MULTIKEY    : "  + cValToChar( dbInfo( RDDI_MULTIKEY    ) ) )

   oTreeInfo:Add( "Memo parameters" )
   oTreeInfo:Add( "RDDI_MEMOBLOCKSIZE: "  + cValToChar( dbInfo( RDDI_MEMOBLOCKSIZE  ) ) )
   oTreeInfo:Add( "RDDI_MEMOVERSION  : "  + cValToChar( dbInfo( RDDI_MEMOVERSION    ) ) )
   oTreeInfo:Add( "RDDI_MEMOGCTYPE   : "  + cValToChar( dbInfo( RDDI_MEMOGCTYPE     ) ) )
   oTreeInfo:Add( "RDDI_MEMOREADLOCK : "  + cValToChar( dbInfo( RDDI_MEMOREADLOCK   ) ) )
   oTreeInfo:Add( "RDDI_MEMOREUSE    : "  + cValToChar( dbInfo( RDDI_MEMOREUSE      ) ) )
   oTreeInfo:Add( "RDDI_BLOB_SUPPORT : "  + cValToChar( dbInfo( RDDI_BLOB_SUPPORT   ) ) )

   oTreeInfo:Add( "OrderInfo" )
   oTreeInfo:Add( "DBOI_CONDITION    : "  + cValToChar( dbOrderInfo( DBOI_CONDITION       ) ) )
   oTreeInfo:Add( "DBOI_EXPRESSION   : "  + cValToChar( dbOrderInfo( DBOI_EXPRESSION      ) ) )
   oTreeInfo:Add( "DBOI_POSITION     : "  + cValToChar( dbOrderInfo( DBOI_POSITION        ) ) )

   oTreeInfo:Add( "DBOI_NAME         : "  + cValToChar( dbOrderInfo( DBOI_NAME            ) ) )
   oTreeInfo:Add( "DBOI_NUMBER       : "  + cValToChar( dbOrderInfo( DBOI_NUMBER          ) ) )
   oTreeInfo:Add( "DBOI_BAGNAME      : "  + cValToChar( dbOrderInfo( DBOI_BAGNAME         ) ) )
   oTreeInfo:Add( "DBOI_BAGEXT       : "  + cValToChar( dbOrderInfo( DBOI_BAGEXT          ) ) )
   oTreeInfo:Add( "DBOI_INDEXEXT     : "  + cValToChar( dbOrderInfo( DBOI_INDEXEXT        ) ) )
   oTreeInfo:Add( "DBOI_INDEXNAME    : "  + cValToChar( dbOrderInfo( DBOI_INDEXNAME       ) ) )
   oTreeInfo:Add( "DBOI_ORDERCOUNT   : "  + cValToChar( dbOrderInfo( DBOI_ORDERCOUNT      ) ) )
   oTreeInfo:Add( "DBOI_FILEHANDLE   : "  + cValToChar( dbOrderInfo( DBOI_FILEHANDLE      ) ) )
   oTreeInfo:Add( "DBOI_ISCOND       : "  + cValToChar( dbOrderInfo( DBOI_ISCOND          ) ) )
   oTreeInfo:Add( "DBOI_ISDESC       : "  + cValToChar( dbOrderInfo( DBOI_ISDESC          ) ) )
   oTreeInfo:Add( "DBOI_UNIQUE       : "  + cValToChar( dbOrderInfo( DBOI_UNIQUE          ) ) )
   oTreeInfo:Add( "DBOI_FULLPATH     : "  + cValToChar( dbOrderInfo( DBOI_FULLPATH        ) ) )
   oTreeInfo:Add( "DBOI_KEYTYPE      : "  + cValToChar( dbOrderInfo( DBOI_KEYTYPE         ) ) )
   oTreeInfo:Add( "DBOI_KEYSIZE      : "  + cValToChar( dbOrderInfo( DBOI_KEYSIZE         ) ) )
   oTreeInfo:Add( "DBOI_KEYCOUNT     : "  + cValToChar( dbOrderInfo( DBOI_KEYCOUNT        ) ) )
   oTreeInfo:Add( "DBOI_HPLOCKING    : "  + cValToChar( dbOrderInfo( DBOI_HPLOCKING       ) ) )
   oTreeInfo:Add( "DBOI_LOCKOFFSET   : "  + cValToChar( dbOrderInfo( DBOI_LOCKOFFSET      ) ) )
   oTreeInfo:Add( "DBOI_KEYVAL       : "  + cValToChar( dbOrderInfo( DBOI_KEYVAL          ) ) )
   oTreeInfo:Add( "DBOI_SCOPETOP     : "  + cValToChar( dbOrderInfo( DBOI_SCOPETOP        ) ) )
   oTreeInfo:Add( "DBOI_SCOPEBOTTOM  : "  + cValToChar( dbOrderInfo( DBOI_SCOPEBOTTOM     ) ) )
   oTreeInfo:Add( "DBOI_SCOPETOPCLEAR: "  + cValToChar( dbOrderInfo( DBOI_SCOPETOPCLEAR   ) ) )
   oTreeInfo:Add( "DBOI_SCOPEBOTTOMCLEAR:"+ cValToChar( dbOrderInfo( DBOI_SCOPEBOTTOMCLEAR) ) )
   oTreeInfo:Add( "DBOI_CUSTOM       : "  + cValToChar( dbOrderInfo( DBOI_CUSTOM          ) ) )
   //oTreeInfo:Add( "DBOI_SKIPUNIQUE   : "  + cValToChar( dbOrderInfo( DBOI_SKIPUNIQUE      ) ) )
   oTreeInfo:Add( "DBOI_KEYSINCLUDED : "  + cValToChar( dbOrderInfo( DBOI_KEYSINCLUDED    ) ) )
   oTreeInfo:Add( "DBOI_KEYGOTO      : "  + cValToChar( dbOrderInfo( DBOI_KEYGOTO         ) ) )
   oTreeInfo:Add( "DBOI_KEYGOTORAW   : "  + cValToChar( dbOrderInfo( DBOI_KEYGOTORAW      ) ) )
   oTreeInfo:Add( "DBOI_KEYNO        : "  + cValToChar( dbOrderInfo( DBOI_KEYNO           ) ) )
   oTreeInfo:Add( "DBOI_KEYNORAW     : "  + cValToChar( dbOrderInfo( DBOI_KEYNORAW        ) ) )
   oTreeInfo:Add( "DBOI_KEYCOUNTRAW  : "  + cValToChar( dbOrderInfo( DBOI_KEYCOUNTRAW     ) ) )

RETURN ( nil )

//---------------------------------------------------------------------------//

//----------------------------------------------------------------------------//
/*Parte de c�digo comun a PDA y a la aplicaci�n normal*/
//----------------------------------------------------------------------------//

FUNCTION cNoPath( cFileName )

RETURN Alltrim( SubStr( cFileName, RAt( "\", cFileName ) + 1 ) )

//----------------------------------------------------------------------------//

FUNCTION cNoPathLeft( cFileName )

   local nAt     := At( "\", cFileName )

   if nAT == 0
      nAt        := At( "/", cFileName )
   end if

RETURN Alltrim( SubStr( cFileName, nAt + 1 ) )

//----------------------------------------------------------------------------//

/*
Checks for a possible area name conflict
*/

FUNCTION cCheckArea( cDbfName, cAlias )

   local n     := 2

   cAlias      := cDbfName

	while select( cAlias ) != 0
      cAlias   := cDbfName + alltrim( str( n++ ) )
	end

RETURN cAlias

//---------------------------------------------------------------------------//

FUNCTION dbSeekInOrd( uVal, cOrd, cAlias, lSoft, lLast )

   local nOrd
   local lRet        := .f.

   DEFAULT cAlias    := select()

   if ( cAlias )->( used() )
      nOrd           := ( cAlias )->( ordsetfocus( cOrd ) )
      lRet           := ( cAlias )->( dbseek( uVal, lSoft, lLast ) )
      ( cAlias )->( ordsetfocus( nOrd ) )
   end if

RETURN ( lRet )

//---------------------------------------------------------------------------//

FUNCTION hSeekInOrd( hHash )

   local h
   local nOrd
   local lRet
   local lSoft
   local lLast
   local uValue
   local uOrder
   local cAlias

   lRet                 := .f.

   if IsHash( hHash )

      if HHasKey( hHash, "Value" )
         uValue         := HGet( hHash, "Value" )  
      end if  

      if HHasKey( hHash, "Order" )
         uOrder         := HGet( hHash, "Order" ) 
      end if 

      if HHasKey( hHash, "Alias" )
         cAlias         := HGet( hHash, "Alias" ) 
      end if 

      if HHasKey( hHash, "Soft" )
         lSoft          := HGet( hHash, "Soft" ) 
      end if 

      if HHasKey( hHash, "Last" )
         lLast          := HGet( hHash, "Last" ) 
      end if 

      if !empty( uValue ) .and. !empty( uOrder ) .and. !empty( cAlias )

         if ( cAlias )->( Used() )
            uOrder      := ( cAlias )->( OrdSetFocus( uOrder ) )
            lRet        := ( cAlias )->( dbSeek( uValue, lSoft, lLast ) )
            ( cAlias )->( OrdSetFocus( uOrder ) )
         end if

      end if 

   end if 

RETURN ( lRet )

//---------------------------------------------------------------------------//

FUNCTION aSqlStruct( aStruct )

   local a
   local aSqlStruct  := {}

   for each a in aStruct
      aAdd( aSqlStruct, { a[1], a[2], a[3], a[4] } )
   next

RETURN ( aSqlStruct )

//----------------------------------------------------------------------------//

FUNCTION lExistTable( cTable, cVia )
   
   DEFAULT cVia   := cDriver()
   
RETURN ( file( cTable ) ) // dbExists( cTable ) )

//----------------------------------------------------------------------------//

FUNCTION lExistIndex( cIndex, cVia )

   DEFAULT cVia   := cDriver()

RETURN ( file( cIndex ) )

//----------------------------------------------------------------------------//

FUNCTION fEraseTable( cTable, cVia )

   local lErase   := .t.

   if !lExistTable( cTable )
      RETURN ( lErase )
   end if 

   lErase         := ( fErase( cTable ) == 0 )
   if !lErase
      MsgStop( "Imposible eliminar el fichero " + cTable + ". C�digo de error " + Str( fError() ) )
   end if

RETURN ( lErase )

//----------------------------------------------------------------------------//

FUNCTION fRenameTable( cTableOld, cTableNew )

RETURN ( fRename( cTableOld, cTableNew ) )

//----------------------------------------------------------------------------//

FUNCTION dbSafeUnlock( cAlias )

   if ( cAlias )->( Used() )
      ( cAlias )->( dbUnLock() )
   end if

RETURN nil

//---------------------------------------------------------------------------//

FUNCTION dbSafeLock( cAlias )

   if !( cAlias )->( Used() )
      RETURN .f.
   end if
      
   if dbLock( cAlias )
      RETURN .t.
   end if

RETURN .f.

//----------------------------------------------------------------------------//

FUNCTION dbAppendDefault( cAliOrigen, cAliDestino, aStruct )

	local i
   local cNom
	local	xVal
   local nPos
   local lPass    := .f.
   local nField   := ( cAliDestino )->( fCount() )

   ( cAliDestino )->( dbAppend() )

   if ( cAliDestino )->( !NetErr() )

      for i := 1 to nField

         if ( len( aStruct[ i ] ) >= 9 ) .and. ( !empty( aStruct[ i, 9 ] ) )
            ( cAliDestino )->( FieldPut( i, aStruct[ i, 9 ] ) )
         end if

      next

      for i := 1 to nField

         cNom     := ( cAliDestino )->( FieldName( i ) )
         nPos     := ( cAliOrigen  )->( FieldPos( cNom ) )

         if nPos != 0
            xVal  := ( cAliOrigen )->( FieldGet( nPos ) )
            ( cAliDestino )->( FieldPut( i, xVal ) )
         end if

      next

      dbSafeUnLock( cAliDestino )

      lPass    := .t.

   end if

RETURN ( lPass )

//----------------------------------------------------------------------------//

FUNCTION fEraseIndex( cTable, cVia )

   DEFAULT cVia   := cDriver()

   if cVia == "ADS"
      RETURN .t.
   end if

RETURN ( fErase( cTable ) )

//----------------------------------------------------------------------------//

FUNCTION buildIndex( cDataBase, cDriver, aIndex )

   local cAlias
   local aCurrent

   dbUseArea( .t., cDriver, databaseFileName( cDataBase ), cCheckArea( "Alias", @cAlias ), .f. )

   if !( cAlias )->( neterr() )
      ( cAlias)->( __dbPack() )

      for each aCurrent in aIndex
         ( cAlias )->( ordCondSet( "!Deleted()", {|| !Deleted() }, , , , , , , , , aCurrent[ 5 ] ) )
         ( cAlias )->( ordCreate( databaseFileIndex( cDataBase ), aCurrent[ 2 ], aCurrent[ 3 ], aCurrent[ 4 ] ) )
      next 

      ( cAlias )->( dbCloseArea() )
   else
      msgStop( "Imposible abrir en modo exclusivo la tabla : " + cDataBase )
   end if

RETURN ( nil )

//----------------------------------------------------------------------------//
   
FUNCTION bCheck2Block( cChar, lMessage )

   local cType
	local bBlock
   local oBlock
   local oError
   local lError      := .f.

   DEFAULT lMessage  := .t.

   if empty( cChar )
      RETURN ( bBlock )
   end if

   oBlock            := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      cType          := Type( cChar )

      if cType != "UE" //  .and. cType != "UI" ) // UI

         cChar       := Rtrim( cChar )
         bBlock      := &( "{||" + cChar + "}" )

      else

         lError      := .t.

      end if

   RECOVER USING oError

      lError         := .t.

   END SEQUENCE

   ErrorBlock( oBlock )

   if lError

      if lMessage
         msgStop( "Expresi�n incorrecta " + cChar, "Tipo de expresi�n " + Type( cChar ) )
      end if

      bBlock         := nil

   end if

RETURN ( bBlock )

//---------------------------------------------------------------------------//

FUNCTION setScriptSystem( cScriptSystem )

   scriptSystem   := cScriptSystem

RETURN ( nil )   

//---------------------------------------------------------------------------//

FUNCTION runScriptBeforeAppend()

   if !empty(scriptSystem)
      runEventScript( scriptSystem + "\beforeAppend" )
   end if 

RETURN ( nil )

//---------------------------------------------------------------------------//

FUNCTION runScriptAfterAppend()

   if !empty(scriptSystem)
      runEventScript( scriptSystem + "\afterAppend" )
   end if 

RETURN ( nil )

//---------------------------------------------------------------------------//

FUNCTION runScriptBeforeEdit()

   if !empty(scriptSystem)
      runEventScript( scriptSystem + "\beforeEdit" )
   end if 

RETURN ( nil )

//---------------------------------------------------------------------------//

FUNCTION runScriptAfterEdit()

   if !empty(scriptSystem)
      runEventScript( scriptSystem + "\afterEdit" )
   end if 

RETURN ( nil )

//---------------------------------------------------------------------------//
/*
A�ade regsitros a la base de datos
	- oBrw. Browse de procedencia
	- bEdit. Codeblock a ejecutar en la edicion
	- cAlias. Pues eso
	- bWhen. Codeblock con la funcion When
	- bValid.  "   "   con la funcion Valid
	- xOthers. Mas parametros.
	- bPostAction. Accion a evaluar despues de A�adir
*/

FUNCTION WinAppRec( oBrw, bEdit, cAlias, bWhen, bValid, xOthers )

   local aTmp
   local aGet
   local lRETURN     := .f.
   local nOrd        := 0

   DEFAULT cAlias    := Alias()
   DEFAULT bWhen     := "" //{ || .t. }
   DEFAULT bValid    := "" //{ || .t. }

   if select( cAlias ) == 0
      RETURN .f.
   end if

   if lDemoMode() .and. ( cAlias )->( lastRec() ) >= 50
      msgStop( "Esta usted utilizando una versi�n demo.", "El programa se abortar�" )
      RETURN .f.
   end if

   // Script antes de a�adir---------------------------------------------------

   runScriptBeforeAppend()

   // Orden principal----------------------------------------------------------

   if empty( ( cAlias )->( OrdSetFocus() ) )
      nOrd        := ( cAlias )->( OrdSetFocus( 1 ) )
   end if

   aTmp           := dbBlankRec( cAlias )

   aGet           := Array( ( cAlias )->( fCount() ) )

	// Bloqueamos el registro durante la edici�n-----------------------------------

   lRETURN        := Eval( bEdit, aTmp, aGet, cAlias, oBrw, bWhen, bValid, APPD_MODE, xOthers )

   if lRETURN
      dbSafeUnLock( cAlias )
   end if

   if IsNum( nOrd ) .and. ( nOrd != 0 )
      ( cAlias )->( OrdSetFocus ( nOrd ) )
   end if

   // Script despues de a�adir

   runScriptAfterAppend()

   runScriptAfterEdit()

   // refrescos en pantalla

   if !empty( oBrw ) .and. ( oBrw:lActive )

      if oBrw:lFooter .and. !empty( oBrw:nFooterHeight )
         oBrw:MakeTotals()
      end if 

      oBrw:select( 0 )
      oBrw:select( 1 )
      oBrw:Refresh()

   end if

RETURN lRETURN

//-------------------------------------------------------------------------//

/*
Duplica registros a la base de datos
	- oBrw. Browse de procedencia
	- bEdit. Codeblock a ejecutar en la edicion
	- cAlias. Pues eso
	- bWhen. Codeblock con la funcion When
	- bValid.  "   "   con la funcion Valid
	- xOthers. Mas parametros.
	- bPostAction. Accion a evaluar despues de A�adir
*/

FUNCTION WinDupRec( oBrw, bEdit, cAlias, bWhen, bValid, xOthers )

   local aTmp
   local aGet
   local nRec
   local lResult  := .f.
   local nOrd     := 0

   if select( cAlias ) == 0
      RETURN .f.
   end if

   if lDemoMode() .and. ( cAlias )->( lastRec() ) >= 50
      msgStop( "Esta usted utilizando una versi�n demo.", "El programa se abortar�" )
      RETURN .f.
   end if

   // Script antes de a�adir---------------------------------------------------

   runScriptBeforeAppend()

   // Orden principal----------------------------------------------------------

   nRec           := ( cAlias )->( Recno() )

   if empty( ( cAlias )->( OrdSetFocus() ) )
      nOrd        := ( cAlias )->( OrdSetFocus( 1 ) )
   end if

	// Bloqueamos el registro durante la edici�n--------------------------------

   if !( cAlias )->( eof() )

      aTmp        := dbScatter( cAlias )

      aGet        := Array( ( cAlias )->( fCount() ) )

      lResult     := Eval( bEdit, aTmp, aGet, cAlias, oBrw, bWhen, bValid, DUPL_MODE, xOthers )

      if lResult
         dbSafeUnLock( cAlias )
      end if

   end if

   if IsNum( nOrd ) .and. nOrd != 0
      ( cAlias )->( OrdSetFocus( nOrd ) )
   end if

   if !lResult
      ( cAlias )->( dbGoTo( nRec ) )
   end if

   // Script despues de a�adir-------------------------------------------------

   runScriptAfterAppend()

   runScriptAfterEdit()

   // refrescos en pantalla----------------------------------------------------

   if lResult .and. !empty( oBrw ) .and. ( oBrw:lActive )

      oBrw:select( 0 )
      oBrw:select( 1 )

		if oBrw:lFooter .and. !empty( oBrw:nFooterHeight )
			oBrw:MakeTotals()
		end if 

      oBrw:Refresh()

   end if

RETURN lResult

//-------------------------------------------------------------------------//

/*
Edita regsitros a la base de datos
	- oBrw. Browse de procedencia
	- bEdit. Codeblock a ejecutar en la edicion
	- cAlias. Pues eso
	- bWhen. Codeblock con la funcion When
	- bValid.  "   "   con la funcion Valid
	- xOthers. Mas parametros.
	- bPostAction. Accion a evaluar despues de A�adir
*/

FUNCTION WinEdtRec( oBrw, bEdit, cAlias, bWhen, bValid, xOthers )

   local aTmp
   local aGet
   local lResult     := .f.
   local nOrd        := 0
   local nRec 

   DEFAULT cAlias    := Alias()
   DEFAULT bWhen     := "" //{ || .t. }
   DEFAULT bValid    := "" //{ || .t. }

   if select( cAlias ) == 0 .OR. ( ( cAlias )->( LastRec() ) == 0 )
      RETURN .f.
   end if

   // Script antes de a�adir

   runScriptBeforeEdit()

   // Orden principal

   if empty( ( cAlias )->( OrdSetFocus() ) )
      nOrd           := ( cAlias )->( OrdSetFocus( 1 ) )
   end if

   nRec              := ( cAlias )->( Recno() )

   if !( cAlias )->( eof() )
      if dbDialogLock( cAlias )
         aTmp        := dbScatter( cAlias )
         aGet        := array( ( cAlias )->( fCount() ) )
         lResult     := Eval( bEdit, aTmp, aGet, cAlias, oBrw, bWhen, bValid, EDIT_MODE, xOthers )
         dbSafeUnLock( cAlias )
      end if
   end if

   if isNum( nOrd ) .and. nOrd != 0
      ( cAlias )->( OrdSetFocus( nOrd ) )
   end if

   // Script despues de a�adir

   runScriptAfterEdit()

   // refrescos en pantalla

   if lResult .and. oBrw != nil

      oBrw:select( 0 )
      oBrw:select( 1 )

		if oBrw:lFooter .and. !empty( oBrw:nFooterHeight )
			oBrw:MakeTotals()
		end if 

      oBrw:Refresh()

   end if

   if isNum( nRec )
      ( cAlias )->( dbGoto( nRec ) )
   end if

RETURN lResult

//-------------------------------------------------------------------------//

/*
Edita regsitros a la base de datos
	- oBrw. 		Browse de procedencia
	- bEdit. 	Codeblock a ejecutar en la edicion
	- cAlias.	Pues eso
	- bWhen. 	Codeblock con la funcion When
	- bValid.  	"   "   con la funcion Valid
	- xOthers. 	Mas parametros.
*/

FUNCTION WinZooRec( oBrw, bEdit, cAlias, bWhen, bValid, xOthers )

   local aTmp
   local aGet
   local lResult     := .f.
   local nOrd        := 0

   DEFAULT cAlias    := Alias()
   DEFAULT bWhen     := "" //{ || .t. }
   DEFAULT bValid    := "" //{ || .t. }

	IF select( cAlias ) == 0
		RETURN .F.
	END IF

   if empty( ( cAlias )->( OrdSetFocus() ) )
      nOrd        := ( cAlias )->( OrdSetFocus( 1 ) )
   end if

   IF !( cAlias )->( eof() )
      aTmp        := DBScatter( cAlias )
      aGet        := Array( (cAlias)->(fCount()) )
      lResult     := Eval( bEdit, aTmp, aGet, cAlias, oBrw, bWhen, bValid, ZOOM_MODE, xOthers )
	END IF

   if ValType( nOrd ) == "N" .and. nOrd != 0
      ( cAlias )->( OrdSetFocus( nOrd ) )
   end if

RETURN lResult

//---------------------------------------------------------------------------//
/*
Lee del disco un registro desde un array
*/

FUNCTION dbScatter( cAlias )

   local i
   local aField := {}
   local nField := ( cAlias )->( fCount() )

   // Creating requested field array-------------------------------------------

   for i := 1 to nField
      aAdd( aField, ( cAlias )->( FieldGet( i ) ) )
	next

RETURN aField

//----------------------------------------------------------------------------//

/*
Lee del disco un registro desde un array
*/

FUNCTION aScatter( cAlias, aTmp )

   aEval( aTmp, {|x,n| aTmp[ n ] := ( cAlias )->( FieldGet( n ) ) } )

RETURN aTmp

//----------------------------------------------------------------------------//
/*
Bloquea un registro, diferencianado caso de estar a�adiendo
registros
*/

FUNCTION dbDialogLock( cAlias, lAppend )

   DEFAULT lAppend   := .f.

   if DBLock( cAlias, if( lAppend, MODE_APPEND, MODE_RECORD ) )
      RETURN .t.
	endif

   while ApoloMsgNoYes( "Registro bloqueado," + CRLF + "� Reintentar ?" )

		if DBLock( cAlias, if( lAppend, MODE_APPEND, MODE_RECORD ) )
         RETURN .t.
		else
			loop
		endif

   enddo

RETURN .f.

//--------------------------------------------------------------------------//
/*
Devuelve un array con un registro en blanco, del alias pasado como argumento
*/

FUNCTION dbBlankRec( cAlias )

   local i
   local aBlank   := {}
   local aStruct  := ( cAlias )->( dbStruct() )

   for i = 1 to ( cAlias )->( fCount() )

      do case
         case aStruct[ i, DBS_TYPE ] == "C"
            AAdd( aBlank, Space( aStruct[ i, DBS_LEN ] ) )
         case aStruct[ i, DBS_TYPE ] == "M"
            AAdd( aBlank, "" )            // Space( aStruct[ i, DBS_LEN ] )
         case aStruct[ i, DBS_TYPE ] == "N"
            AAdd( aBlank, Val( "0." + Replicate( "0", aStruct[ i, DBS_DEC ] ) ) )
         case aStruct[ i, DBS_TYPE ] == "L"
            AAdd( aBlank, .F. )
         case aStruct[ i, DBS_TYPE ] == "D"
            AAdd( aBlank, GetSysDate() )  // CtoD( "" ) )
         case aStruct[ i, DBS_TYPE ] == "@"
            AAdd( aBlank, DateTime() )  
      end case

   next

RETURN aBlank

//--------------------------------------------------------------------------//

FUNCTION dbHash( cAlias )

   local i
   local hHash       := {=>}

   DEFAULT cAlias    := Alias()

   for i = 1 to ( cAlias )->( fCount() )
      hSet( hHash, ( cAlias )->( fieldname(i) ), ( cAlias )->( fieldget( i ) ) )
   next

RETURN ( hHash )

//--------------------------------------------------------------------------//
/*
Bloquea un registro
*/

FUNCTION dbLock( cAlias, nMode )

   local i

   DEFAULT nMode  := MODE_RECORD

	for i = 1 to NNET_TIME

      if nMode == MODE_APPEND

         ( cAlias )->( dbAppend() )
         if !NetErr()
            RETURN .t.
			endif

		else

         if ( cAlias )->( dbRLock() )
				RETURN .t.
			end if

		endif

	next

RETURN .f.

//--------------------------------------------------------------------------//
/*
Paremetro lMaster, para solicitar permisos de ususrio master antes de
eliminar el registro
*/

FUNCTION WinDelRec( oBrw, cAlias, bPreBlock, bPostBlock, lMaster, lTactil )

   local nRec        := 0
   local cTxt        := "�Desea eliminar el registro en curso?"
   local nMarked     := 0
   local lRETURN     := .f.
   local lTrigger    := .t.
   local oWaitMeter

   DEFAULT cAlias    := Alias()
   DEFAULT lMaster   := .f.
   DEFAULT lTactil   := .f.

   if select( cAlias ) == 0 .or. ( cAlias )->( lastrec() ) == 0
      RETURN ( .f. )
   end if

   // Cuantos registros marcados tenemos---------------------------------------

   if !empty( oBrw ) .and. ( "XBROWSE" $ oBrw:ClassName() )

      nMarked        := len( oBrw:aselected )
      if nMarked > 1
         cTxt        := "� Desea eliminar definitivamente " + alltrim( Trans( nMarked, "999999" ) ) + " registros ?"
      end if

      if SQLAjustableModel():getRolNoConfirmacionEliminacion( Auth():rolUuid() ) .or. apoloMsgNoYes( cTxt, "Confirme supresi�n", lTactil )

         oWaitMeter        := TWaitMeter():New( "Eliminando registros", "Espere por favor..." )
         oWaitMeter:run()
         oWaitMeter:setTotal( len( oBrw:aselected ) )

         for each nRec in ( oBrw:aselected )

            ( cAlias )->( dbGoTo( nRec ) )

            if !empty( bPreBlock )
               lTrigger    := CheckEval( bPreBlock )
            end if

            if !isLogic( lTrigger ) .or. lTrigger

               dbDel( cAlias )

               if !empty( bPostBlock )
                  checkEval( bPostBlock )
               end if

            end if

            oWaitMeter:autoInc()

         next

         oWaitMeter:end()

      end if

   else

      if SQLAjustableModel():getRolNoConfirmacionEliminacion( Auth():rolUuid() ) .or. ApoloMsgNoYes( cTxt, "Confirme supersi�n", lTactil )

         if !empty( bPreBlock )
            lTrigger    := CheckEval( bPreBlock )
         end if

         if !isLogic( lTrigger ) .or. lTrigger

            dbDel( cAlias )

            if !empty( bPostBlock )
               lTrigger := CheckEval( bPostBlock )
            end if

            lRETURN     := .t.

         end if

      end if

   end if

   if !empty( oBrw )
      oBrw:select( 0 )
      oBrw:select( 1 )
      oBrw:Refresh()
      oBrw:SetFocus() // .t. )
   end if

RETURN ( lRETURN )

//--------------------------------------------------------------------------//

/*
Confirmaci�n de la supresi�n de un registro
*/

FUNCTION dbDelRec( oBrw, cAlias, bPreBlock, bPostBlock, lDelMarked, lBig )

   local nRec           := 0
   local cTxt           := "�Desea eliminar el registro en curso?"
   local nMarked        := 0
   local lRETURN        := .f.

   DEFAULT cAlias       := Alias()
   DEFAULT lDelMarked   := .f.
   DEFAULT lBig         := .f.

   if select( cAlias ) == 0 .or. ( cAlias )->( LastRec() ) == 0
      RETURN ( .f. )
   end if

   /*
   Cuantos registros marcados tenemos
   */

   if ( lDelMarked ) .and. ( "TXBROWSE" $ oBrw:ClassName() )
      nMarked           := len( oBrw:aselected )
      if nMarked > 1
         cTxt           := "� Desea eliminar definitivamente " + AllTrim( Str( nMarked, 3 ) ) + " registros ?"
      end if

      if SQLAjustableModel():getRolNoConfirmacionEliminacion( Auth():rolUuid() ) .or. ApoloMsgNoYes( cTxt, "Confirme supersi�n", lBig )
         for each nRec in oBrw:aselected

            ( cAlias )->( dbGoTo( nRec ) )

            CheckEval( bPreBlock )
            dbDel( cAlias )
            CheckEval( bPostBlock )

            if( !( cAlias )->( eof() ), oBrw:GoUp(), )
            oBrw:Refresh()
            oBrw:SetFocus()

         next

      end if

   else
      if SQLAjustableModel():getRolNoConfirmacionEliminacion( Auth():rolUuid() ) .or. ApoloMsgNoYes( cTxt, "Confirme supersi�n" )

         CheckEval( bPreBlock )

         DelRecno( cAlias, oBrw )

         CheckEval( bPostBlock )

         if !empty( oBrw )
            oBrw:Refresh()
         end if

         lRETURN        := .t.

      end if

   end if

RETURN ( lRETURN )

//--------------------------------------------------------------------------//

FUNCTION DelRecno( cAlias, oBrw, lDelMarked )

   local nRec
   local nNtx

   DEFAULT lDelMarked:= .f.

   if lDelMarked

      ( cAlias )->( dbGoTop() )
      while !( cAlias )->( eof() )
         if ( cAlias )->( lMarked() ) .and.  dbLock( cAlias, .f. )
            ( cAlias )->( dbDelete() )
            dbSafeUnLock( cAlias )
         end if
      end do

   else

      dbDel( cAlias )

   end if

   if oBrw != nil
      oBrw:select( 0 )
      oBrw:select( 1 )
      oBrw:SetFocus()
   end if

RETURN nil

//------------------------------------------------------------------------//

FUNCTION CheckEval( bCodeBlock )

   local oBlock
   local oError
   local lCheckEval  := .t.

   oBlock            := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      if !empty( bCodeBlock ) .and. Valtype( bCodeBlock ) == "B"
         lCheckEval  := Eval( bCodeBlock )
      end if

   RECOVER USING oError

      lCheckEval     := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lCheckEval )

//--------------------------------------------------------------------------//

FUNCTION nGetAllMark( cMark, cAlias )

   local nNum     := 0
   local nRecNo   := ( cAlias )->( RecNo() )

   cMark          := if( ValType( cMark ) != "C", "#", cMark )

   ( cAlias )->( dbGoTop() )
   while !( cAlias )->( eof() )

      if ( cAlias )->( lMarked( cMark ) )
         ++nNum
      end if
      ( cAlias )->( dbSkip() )

   end while

   ( cAlias )->( dbGoTo( nRecNo ) )

RETURN ( nNum )

//---------------------------------------------------------------------------//

FUNCTION dbDel( cAlias )

   if ( cAlias )->( dbRLock() ) //dbLock( cAlias )
      ( cAlias )->( dbDelete() )
      ( cAlias )->( dbUnLock() )
   else
      msgStop( "No he podido bloquear.")
   end if

   ( cAlias )->( dbSkip( 0 ) )

RETURN nil

//---------------------------------------------------------------------------//

FUNCTION dbLockDelete( cAlias )

   if dbLock( cAlias )
      ( cAlias )->( dbDelete() )
      ( cAlias )->( dbUnLock() )
   else 
      RETURN .f.
   end if

RETURN .t.

//---------------------------------------------------------------------------//

// Esta marcado el registro?

FUNCTION lMarked( cMark, nRec )

    cMark := if( ValType( cMark ) == "C", cMark, "#" )

RETURN( GetMarkRec( cMark, nRec ) == cMark )

//---------------------------------------------------------------------------//
// Extrae la marca del registro a bajo nivel del espacio de la marca de deleted

FUNCTION GetMarkRec( nRec )

   local nRecNo   := RecNo()
   local nHdl     := DbfHdl()
   local nOffSet  := 0
   local cMark    := " "

   nRec           := if( ValType( nRec )  != "N", RecNo(), nRec  )
   nOffSet        := ( RecSize() * ( nRec - 1 ) ) + Header()

   FSeek( nHdl, nOffSet, 0 )
   FRead( nHdl, @cMark, 1  )

   DbGoTo( nRecNo )

RETURN( cMark )

//---------------------------------------------------------------------------//

FUNCTION WinGather( aTmp, aGet, cAlias, oBrw, nMode, bPostAction, lempty )

   local lAdd     := ( nMode == APPD_MODE .or. nMode == DUPL_MODE )

	DEFAULT lempty	:= .t.

	CursorWait()

   if dbDialogLock( cAlias, lAdd )
      aEval( aTmp, { | uTmp, n | ( cAlias )->( fieldPut( n, uTmp ) ) } )
      dbSafeUnLock( cAlias )
   end if

   ( cAlias )->( dbCommit() )

   if lempty
      aCopy( dbBlankRec( cAlias ), aTmp )
      if !empty( aGet )
         aEval( aGet, {| o, i | if( "GET" $ o:ClassName(), o:cText( aTmp[ i ] ), ) } )
      end if
   end if

   if bPostAction != nil
		Eval( bPostAction )
   end if

   if oBrw != nil
      oBrw:Refresh()
   end if

   CursorWe()

RETURN ( nil )

//--------------------------------------------------------------------------//

FUNCTION dbCopy( cAliOrigen, cAliDestino, lApp )

	local i
	local nField 	:= (cAliOrigen)->( Fcount() )

	DEFAULT lApp	:= .f.

	IF lApp
		(cAliDestino)->( dbAppend() )
   ELSE
      (cAliDestino)->( dbRLock() )
	END IF

	for i = 1 to nField
		(cAliDestino)->( FieldPut( i, (cAliOrigen)->( FieldGet( i ) ) ) )
	next

   IF !lApp
      dbSafeUnLock( cAliDestino )
	END IF

RETURN NIL

//---------------------------------------------------------------------------//

FUNCTION NotCero( nUnits )

RETURN ( if( nUnits != 0, nUnits, 1 ) )

//--------------------------------------------------------------------------//

FUNCTION SetStatus( cAlias, aStatus )

   ( cAlias )->( OrdSetFocus( aStatus[ 2 ] ) )
   ( cAlias )->( dbGoTo( aStatus[ 1 ] ) )

RETURN nil

//--------------------------------------------------------------------------//

FUNCTION aGetStatus( cAlias, lInit )

   local aStatus  := { ( cAlias )->( Recno() ), ( cAlias )->( ordsetfocus() ) }

   DEFAULT lInit  := .f.

   if lInit
      ( cAlias )->( OrdSetFocus( 1 ) )
      ( cAlias )->( dbGoTop() )
   end if

RETURN ( aStatus )

//--------------------------------------------------------------------------//

FUNCTION hGetStatus( cAlias, uOrder )

   local hStatus  := {  "Alias" => cAlias,;
                        "Recno" => ( cAlias )->( Recno() ),;
                        "Order" => ( cAlias )->( OrdSetFocus() ) }

   if !isNil( uOrder )
      ( cAlias )->( OrdSetFocus( uOrder ) )
      ( cAlias )->( dbGoTop() )
   end if

RETURN ( hStatus )

//--------------------------------------------------------------------------//

FUNCTION hSetStatus( hStatus )

   ( hget( hStatus, "Alias" ) )->( ordsetfocus( hget( hStatus, "Order" ) ) )
   ( hget( hStatus, "Alias" ) )->( dbgoto(      hget( hStatus, "Recno" ) ) )

RETURN nil

//--------------------------------------------------------------------------//
/*
Comprueba si existe una clave
*/

FUNCTION notValid( oGet, uAlias, lRjust, cChar, nTag, nLen )

   local lRETURN  := .t.

   if !validKey( oGet, uAlias, lRjust, cChar, nTag, nLen )
      msgStop( "Clave existente", "Aviso del sistema" )
      lRETURN     := .f.
   end if

RETURN lRETURN

//-------------------------------------------------------------------------//

FUNCTION validKey( oGet, uAlias, lRjust, cChar, nTag, nLen )

   local nOldTag
   local cAlias
   local cFilter
   local lRETURN  := .t.
   local xClave   := oGet:VarGet()

   DEFAULT uAlias := Alias()
   DEFAULT lRjust := .f.
	DEFAULT cChar	:= "0"
	DEFAULT nTag   := 1

   if isObject( uAlias )
      cAlias      := uAlias:cAlias
   else
      cAlias      := uAlias
   end if

   cFilter        := ( cAlias )->( dbFilter() )
   ( cAlias )->( dbClearFilter() )

   nOldTag        := ( cAlias )->( OrdSetFocus( nTag ) )

   /*
	Cambiamos el tag y guardamos el anterior
	*/

   if empty( ( cAlias )->( OrdSetFocus() ) )
      MsgInfo( "Indice no disponible, comprobaci�n imposible" )
      RETURN .t.
   end if

   if lRjust
      if ischar( xClave ) .and. at( ".", xClave ) != 0
         PntReplace( oGet, cChar, nLen )
      else 
         RJustObj( oGet, cChar, nLen )
      end if
   end if

   xClave         := oGet:VarGet()

   if Existe( xClave, cAlias )
      lRETURN     := .f.
   end if

	( cAlias )->( OrdSetFocus( nOldTag ) )

   if !empty( cFilter )
      ( cAlias )->( dbSetFilter( {|| &cFilter }, cFilter ) )
   end if

RETURN lRETURN

//-------------------------------------------------------------------------//

/*
Comprueba la existencia anterior de una clave
*/

FUNCTION Existe( xClave, cAlias, nOrd )

   local nRec
   local lFound

	DEFAULT cAlias := Alias()
   DEFAULT nOrd   := ( cAlias )->( OrdSetFocus() )

   nRec           := ( cAlias )->( Recno() )
   nOrd           := ( cAlias )->( OrdSetFocus( nOrd ) )

   lFound         := ( cAlias )->( dbSeek( xClave ) )

   ( cAlias )->( OrdSetFocus( nOrd ) )
   ( cAlias )->( dbGoTo( nRec ) )

RETURN ( lFound )

//-------------------------------------------------------------------------//

FUNCTION LblTitle( nMode )

   local cTitle   := ""

   do case
      case nMode  == APPD_MODE
         cTitle   := "A�adiendo "
      case nMode  == EDIT_MODE
         cTitle   := "Modificando "
      case nMode  == ZOOM_MODE
         cTitle   := "Visualizando "
      case nMode  == DUPL_MODE
         cTitle   := "Duplicando "
   end case

RETURN ( cTitle )

//----------------------------------------------------------------------------//

FUNCTION dbAppe( cAlias )

   ( cAlias )->( dbAppend() )
   if !( cAlias )->( NetErr() )
      RETURN .t.
   endif

RETURN .f.

//--------------------------------------------------------------------------//

FUNCTION databaseFileName( cFile )

RETURN ( cFile + ".Dbf" )

//--------------------------------------------------------------------------//

FUNCTION databaseFileIndex( cFile )

RETURN ( cFile + ".Cdx" )

//--------------------------------------------------------------------------//

FUNCTION databaseFileMemo( cFile )

RETURN ( cFile + ".Fpt" )

//--------------------------------------------------------------------------//

FUNCTION dbfErase( cFileName )

   if empty( cFileName )
      RETURN .t.
   end if

   if dbExists( cFileName )
      dbDrop( cFileName )
   end if

   if file( databaseFileName( cFileName ) )
      if ferase( databaseFileName( cFileName ) ) == F_ERROR
         RETURN .f.
      end if
   end if

   if file( databaseFileIndex( cFileName ) )
      if fErase( databaseFileIndex( cFileName ) ) == F_ERROR
         RETURN .f.
      end if
   end if

   if file( databaseFileMemo( cFileName ) )
      if fErase( databaseFileMemo( cFileName ) ) == F_ERROR
         RETURN .f.
      end if
   end if

RETURN .t.

//---------------------------------------------------------------------------//

FUNCTION dbfRename( cFileNameOld, cFileNameNew )

   if file( cFileNameOld + ".Dbf" )
      if fRename( cFileNameOld + ".Dbf", cFileNameNew + ".Dbf" ) == F_ERROR
         //MsgStop( "No se pudo renombrar el fichero " + cFileNameOld + ".Dbf" )
         RETURN .f.
      end if
   end if

   if file( cFileNameOld + ".Cdx" )
      if fRename( cFileNameOld + ".Cdx", cFileNameNew + ".Cdx" ) == F_ERROR
         //MsgStop( "No se pudo renombrar el fichero " + cFileNameOld + ".Cdx" )
         RETURN .f.
      end if
   end if

   if file( cFileNameOld + ".Fpt" )
      if fRename( cFileNameOld + ".Fpt", cFileNameNew + ".Fpt" ) == F_ERROR
         MsgStop( "No se pudo renombrar el fichero " + cFileNameOld + ".Fpt" )
         RETURN .f.
      end if
   end if

RETURN .t.

//---------------------------------------------------------------------------//

FUNCTION dbDelKit( oBrw, dbfTmp, nNumLin )

   local nRec  := ( dbfTmp )->( Recno() )
   local nOrd  := ( dbfTmp )->( OrdSetFocus( "nNumLin" ) )
   local cFlt  := ( dbfTmp )->( dbFilter() )
   local nNum  := Str( nNumLin, 4 )

   if !empty( cFlt )
      ( dbfTmp )->( dbSetFilter() )
   end if 

   if ( dbfTmp )->( dbSeek( nNum ) )
      while Str( ( dbfTmp )->nNumLin, 4 ) == nNum .and. ( !( dbfTmp )->( Eof() ) )
         if ( dbfTmp )->lKitChl      
            ( dbfTmp )->( dbDelete() )
         end if 
         ( dbfTmp )->( dbSkip() )
         SysRefresh()
      end while
   end if 

   if !empty( cFlt )
      ( dbfTmp )->( dbSetFilter( c2Block( cFlt ), cFlt ) )
   end if 

   ( dbfTmp )->( OrdSetFocus( nOrd ) )
   ( dbfTmp )->( dbGoTo( nRec ) )

   if !empty( oBrw )
      oBrw:Refresh()
   end if

RETURN nil

//---------------------------------------------------------------------------- //

FUNCTION cGetNewFileName( cName, cExt, lExt, cPath )

   local cTemp
   local nId      := Val( Auth():Codigo() )


   DEFAULT cExt   := { "Dbf", "Cdx", "Fpt" }
   DEFAULT lExt   := .f.
   DEFAULT cPath  := ""
 
   cTemp          := cName + Auth():Codigo()

   if Valtype( cExt ) == "A"

      while File( cPath + cTemp + "." + cExt[ 1 ] ) .or. File( cPath + cTemp + "." + cExt[ 2 ] ) .or. File( cPath + cTemp + "." + cExt[ 3 ] )
         cTemp    := cName + StrZero( ++nId, 3 )
      end

   else

      while File( cPath + cTemp + "." + cExt )
         cTemp    := cName + StrZero( ++nId, 3 )
      end

   end if

   if lExt
      cTemp       += "." + cExt
   end if

RETURN cTemp

//----------------------------------------------------------------------------//

FUNCTION CommitTransaction()

   dbCommitAll()

RETURN ( .t. )

//----------------------------------------------------------------------------//

FUNCTION BeginTransaction()

RETURN ( .t. )

//----------------------------------------------------------------------------//

FUNCTION RollBackTransaction()

RETURN ( .t. )

//----------------------------------------------------------------------------//

FUNCTION Div( nDividend, nDivisor )

RETURN( if( nDivisor != 0, ( nDividend / nDivisor ), 0 ) )

//----------------------------------------------------------------------------//

FUNCTION cFileBitmap( cPath, cFileName )

   local cFileBitmap

   if At( ":", cFileName ) != 0
      cFileBitmap       := Rtrim( cFileName )
   else
      cFileBitmap       := Rtrim( cPath ) + Rtrim( cFileName )
   end if

RETURN ( cFileBitmap )

//----------------------------------------------------------------------------//

/*
Busca el ultimo registro dentro de un indice
*/

FUNCTION dbLast( cAlias, nField, oGet, xHasta, nOrd )

   local xValRet
   local nPosAct
   local nOrdAct

   DEFAULT cAlias := Alias()
	DEFAULT nField	:= 1

   /*
   Para TDBF-------------------------------------------------------------------
   */

   if IsObject( cAlias )
      cAlias      := cAlias:cAlias
   end if

   nPosAct        := ( cAlias )->( Recno() )

   /*
   Ordenes especiales----------------------------------------------------------
   */

   if nOrd != nil
      nOrdAct     := ( cAlias )->( OrdSetFocus( nOrd ) )
   end if

   if empty( xHasta )
      ( cAlias )->( dbGoBottom() )
   else
      ( cAlias )->( dbSeek( xHasta, .t., .t. ) )
      if ( cAlias )->( eof() )
         ( cAlias )->( dbGoBottom() )
      end if
   end if

   if IsChar( nField )
      nField      := ( cAlias )->( FieldPos( nField ) )
   end if
   xValRet        := ( cAlias )->( FieldGet( nField ) )

   /*
   Ordenes especiales----------------------------------------------------------
   */

   ( cAlias )->( dbGoTo( nPosAct ) )

   if !empty( nOrd )
      ( cAlias )->( OrdSetFocus( nOrdAct ) )
   end if

   if !empty( oGet )
		oGet:cText( xValRet )
      RETURN .t.
   end if

RETURN ( xValRet )

//--------------------------------------------------------------------------//

FUNCTION IsNil( u )

RETURN ( u == nil )

//---------------------------------------------------------------------------//

FUNCTION WinMulRec( oBrw, bEdit, cAlias, bWhen, bValid, xOthers )

   local aTmp
   local aGet
   local lRETURN     := .f.
   local nOrd        := 0

   DEFAULT cAlias    := Alias()
   DEFAULT bWhen     := "" //{ || .t. }
   DEFAULT bValid    := "" //{ || .t. }

	IF select( cAlias ) == 0
		RETURN .F.
	END IF

   if empty( ( cAlias )->( OrdSetFocus() ) )
      nOrd        := ( cAlias )->( OrdSetFocus( 1 ) )
   end if

   aTmp           := dbBlankRec( cAlias )
   aGet           := Array( ( cAlias)->( fCount() ) )

	/*
	Bloqueamos el registro durante la edici�n
	*/

   lRETURN        := Eval( bEdit, aTmp, aGet, cAlias, oBrw, bWhen, bValid, MULT_MODE, xOthers )
   if lRETURN
      dbSafeUnLock( cAlias )
   end if

   if ValType( nOrd ) == "N" .and. nOrd != 0
      ( cAlias )->( OrdSetFocus( nOrd ) )
   end if

RETURN ( lRETURN )

//-------------------------------------------------------------------------//

FUNCTION lMayorIgual( nTotal, nCobrado, nDiferencia )

   DEFAULT nDiferencia  := 0

   nTotal               := Abs( nTotal )
   nCobrado             := Abs( nCobrado )

RETURN ( ( nTotal >= nCobrado ) .and. ( ( nTotal - nCobrado ) >= nDiferencia ) )

//---------------------------------------------------------------------------//

FUNCTION lDiferencia( nTotal, nCobrado, nDiferencia )

   DEFAULT nDiferencia  := 0

RETURN ( abs( nTotal - nCobrado ) >= nDiferencia )

//---------------------------------------------------------------------------//

FUNCTION dbPass( cAliOrigen, cAliDestino, lApp, xField1, xField2, xField3, xField4, xField5 )

	local i
   local cNom
	local	xVal
   local nPos
   local lPass    := .f.
   local nField   := ( cAliDestino )->( fCount() )

	DEFAULT lApp	:= .f.

   if lApp

      ( cAliDestino )->( dbAppend() )

      if ( cAliDestino )->( !NetErr() )

         for i = 1 to nField

            cNom     := ( cAliDestino )->( FieldName( i ) )
            nPos     := ( cAliOrigen  )->( FieldPos( cNom ) )

            if nPos != 0
               xVal  := ( cAliOrigen )->( FieldGet( nPos ) )
               ( cAliDestino )->( FieldPut( i, xVal ) )
            end if

         next

         if !empty( xField1 )
            ( cAliDestino )->( FieldPut( 1, xField1 ) )
         end if

         if !empty( xField2 )
            ( cAliDestino )->( FieldPut( 2, xField2 ) )
         end if

         if !empty( xField3 )
            ( cAliDestino )->( FieldPut( 3, xField3 ) )
         end if

         if !empty( xField4 )
            ( cAliDestino )->( FieldPut( 4, xField4 ) )
         end if

         if !empty( xField5 )
            ( cAliDestino )->( FieldPut( 5, xField5 ) )
         end if

         dbSafeUnlock( cAliDestino )

         lPass       := .t.

      end if

   else

      if ( cAliDestino )->( dbRLock() )

         for i = 1 to nField

            cNom     := ( cAliDestino )->( FieldName( i ) )
            nPos     := ( cAliOrigen  )->( FieldPos( cNom ) )

            if nPos != 0
               xVal  := ( cAliOrigen )->( FieldGet( nPos ) )
               ( cAliDestino )->( FieldPut( i, xVal ) )
            end if

         next

         if !empty( xField1 )
            ( cAliDestino )->( FieldPut( 1, xField1 ) )
         end if

         if !empty( xField2 )
            ( cAliDestino )->( FieldPut( 2, xField2 ) )
         end if

         if !empty( xField3 )
            ( cAliDestino )->( FieldPut( 3, xField3 ) )
         end if

         if !empty( xField4 )
            ( cAliDestino )->( FieldPut( 4, xField4 ) )
         end if

         if !empty( xField5 )
            ( cAliDestino )->( FieldPut( 5, xField5 ) )
         end if

         dbSafeUnLock( cAliDestino )

         lPass       := .t.

      end if

   end if

RETURN ( lPass )

//----------------------------------------------------------------------------//

FUNCTION appendRegisterByHash( cAliOrigen, cAliDestino, hHash )

   local lPass    := .f.

   ( cAliDestino )->( dbAppend(.t.) )

   if !( cAliDestino )->( NetErr() )

      passField( cAliOrigen, cAliDestino )

      passHash( cAliDestino, hHash )

      ( cAliDestino )->( dbUnLock() )

      lPass       := .t.

   end if

RETURN ( lPass )

//----------------------------------------------------------------------------//

FUNCTION EditPass( cAliOrigen, cAliDestino, hHash )

   if ( cAliDestino )->( dbRLock() )

      PassField( cAliOrigen, cAliDestino )

      PassHash( cAliDestino, hHash )
      
      dbSafeUnLock( cAliDestino )

   end if

RETURN ( .t. )

//----------------------------------------------------------------------------//

FUNCTION PassField( cAliOrigen, cAliDestino )

   local i
   local uValue
   local cFieldName
   local nFieldPosition
   local nFieldTotal    := ( cAliDestino )->( fcount() )

   for i := 1 to nFieldTotal

      cFieldName        := ( cAliDestino )->( fieldname( i ) )
      nFieldPosition    := ( cAliOrigen  )->( fieldpos( cFieldName ) )

      if nFieldPosition != 0
         uValue         := ( cAliOrigen )->( fieldget( nFieldPosition ) )
         ( cAliDestino )->( fieldput( i, uValue ) )
      end if

   next

RETURN ( .t. )

//----------------------------------------------------------------------------//

FUNCTION PassHash( cAliDestino, hHash )

   local h
   local nPos

   if empty(hHash)
      RETURN ( .t. )
   end if 

   for each h in hHash
      nPos     := ( cAliDestino )->( fieldpos( h:__enumKey() ) )
      if nPos != 0
         ( cAliDestino )->( fieldput( nPos, h:__enumValue() ) )
      end if
   next

RETURN ( .t. )

//----------------------------------------------------------------------------//

FUNCTION IsTrue( u )

RETURN ( Valtype( u ) == "L" .and. u )

//---------------------------------------------------------------------------//

FUNCTION isFalse( u )

RETURN ( hb_islogical( u ) .and. !( u ) )

//---------------------------------------------------------------------------//

FUNCTION ValidEmailAddress( cMail, lMessage )

   local lValid      := .t.

   DEFAULT lMessage  := .f.

   lValid            := empty( cMail ) .or. HB_RegExMatch( "[A-Z0-9._%-]+@[A-Z0-9.-]+\.[A-Z]{2,4}", cMail, .f. )

   if !lValid .and. lMessage
      MsgStop( "La direcci�n de mail introducida no es correcta" )
   end if

RETURN ( lValid )

//---------------------------------------------------------------------------//

FUNCTION IsChar( u )

RETURN ( Valtype( u ) == "C" )

//---------------------------------------------------------------------------//

FUNCTION IsNum( u )

RETURN ( Valtype( u ) == "N" )

//---------------------------------------------------------------------------//

FUNCTION IsLogic( u )

RETURN ( Valtype( u ) == "L" )

//----------------------------------------------------------------------------//

FUNCTION IsObject( u )

RETURN ( Valtype( u ) == "O" )

//----------------------------------------------------------------------------//

FUNCTION IsDate( u )

RETURN ( Valtype( u ) == "D" )

//---------------------------------------------------------------------------//

FUNCTION IsBlock( u )

RETURN ( Valtype( u ) == "B" )

//---------------------------------------------------------------------------//

FUNCTION IsInteger( u )

RETURN ( u - int( u ) == 0 )

//---------------------------------------------------------------------------//
/*
Escribe un registro de disco
*/

FUNCTION dbGather( aField, cAlias, lAppend )

   local i

   DEFAULT lAppend := .f.

   if dbLock( cAlias, If( lAppend, MODE_APPEND, MODE_RECORD ) )
      for i := 1 to Len( aField )
         ( cAlias )->( FieldPut( i, aField[ i ] ) )
      next
      dbSafeUnlock( cAlias )
   end if

   //( cAlias )->( dbCommit() )

RETURN Nil

//----------------------------------------------------------------------------//

FUNCTION DisableMainWnd( oWnd )

   local oBlock

   DEFAULT oWnd   := oWnd()

   oBlock         := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   if !empty( oWnd:oMenu )
      oWnd:oMenu:Disable()
   end if

   if !empty( oWnd:oTop:oTop )
      oWnd:oTop:oTop:Disable()
   end if

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( nil )

//---------------------------------------------------------------------------//

FUNCTION EnableMainWnd( oWnd )

   local oBlock

   DEFAULT oWnd   := oWnd()

   oBlock         := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   if !empty( oWnd:oMenu )
      oWnd:oMenu:Enable()
   end if

   if !empty( oWnd:oTop:oTop )
      oWnd:oTop:oTop:Enable()
   end if

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( nil )

//---------------------------------------------------------------------------//

FUNCTION IsLock( cAlias )

   local n
   local a  := ( cAlias )->( dbRLockList() )

   for each n in a

      if ( n == ( cAlias )->( Recno() ) )
         RETURN .t.
      end if
   end if

RETURN .f.

//--------------------------------------------------------------------------//

FUNCTION pdaLockSemaphore( cAlias )

   local h
   local cFile := cPatLog() + Alltrim( Str( ( cAlias )->( Recno() ) ) ) + ".txt"

   if !file( cFile )
      h        := fCreate( cFile, 0 )
      if h != -1
         fClose( h )
      end if
   end if

RETURN .t.

//--------------------------------------------------------------------------//

FUNCTION pdaUnLockSemaphore( cAlias )

   local cFile := cPatLog() + Alltrim( Str( ( cAlias )->( Recno() ) ) ) + ".txt"

   if file( cFile )
      fErase( cFile )
   end if

RETURN .t.

//--------------------------------------------------------------------------//

FUNCTION pdaIsLockSemaphore( cAlias )

RETURN ( file( cPatLog() + Alltrim( Str( ( cAlias )->( Recno() ) ) ) + ".txt" ) )

//--------------------------------------------------------------------------//

FUNCTION AdsFile( cFile )

RETURN .f.

//--------------------------------------------------------------------------//

FUNCTION ApoloBreak( oError )

RETURN ( if( oError:GenCode == EG_ZERODIV, 0, Break( oError ) ) )

//---------------------------------------------------------------------------//

FUNCTION Quoted( uValue )

   if ( hb_isnumeric( uValue ) )
      RETURN ( hb_ntos( uValue ) )
   end if 

   if ( hb_ischar( uValue ) .or. hb_ismemo( uValue ) ) .and. !empty( uValue )
      RETURN ( "'" + alltrim( getSqlDatabase():escapeStr( uValue ) ) + "'" )
   end if 

RETURN ( "''" )

//---------------------------------------------------------------------------//

FUNCTION notEscapedQuoted( uValue )

   if ( hb_isnumeric( uValue ) )
      RETURN ( hb_ntos( uValue ) )
   end if 

   if ( hb_ischar( uValue ) .or. hb_ismemo( uValue ) )
      RETURN ( "'" + alltrim( uValue ) + "'" )
   end if 

RETURN ( "''" )

//---------------------------------------------------------------------------//

FUNCTION toSQLString( value )

   do case
      case hb_isnil( value ) ;      RETURN ( 'null' )
      case hb_isnumeric( value ) ;  RETURN ( hb_ntos( value ) )
      case hb_ischar( value ) ;     RETURN ( quoted( value ) ) 
      case hb_islogical( value ) ;  RETURN ( if( value, "1", "0" ) )
      case hb_isdate( value ) ;     RETURN ( if( empty( value ), 'null', quoted( hb_dtoc( value, 'yyyy-mm-dd' ) ) ) )
      case hb_isdatetime( value ) ; RETURN ( quoted( hb_tstostr( value ) ) )
      case hb_ismemo( value ) ;     RETURN ( quoted( value ) ) 
   end case 

RETURN ( value )
       
//---------------------------------------------------------------------------//

FUNCTION Chiled( cString )

RETURN ( Space( 3 ) + "<" + Alltrim( cString ) + ">" )

//---------------------------------------------------------------------------//

FUNCTION lChangeStruct( cAlias, aStruct )

   local i
   local aAliasStruct   

   if ( cAlias )->( fCount() ) != len( aStruct )
      RETURN .t.
   end if 

   aAliasStruct         := ( cAlias )->( dbStruct() ) 

   for i := 1 to ( cAlias )->( fCount() )

      if Upper( aAliasStruct[ i, DBS_NAME ] ) != Upper( aStruct[ i, DBS_NAME ] ) .or. ;
         aAliasStruct[ i, DBS_TYPE ] != aStruct[ i, DBS_TYPE ] .or. ;
         aAliasStruct[ i, DBS_LEN  ] != aStruct[ i, DBS_LEN  ] .or. ;
         aAliasStruct[ i, DBS_DEC  ] != aStruct[ i, DBS_DEC  ]

         RETURN .t.

      end if

   next

RETURN .f.

//----------------------------------------------------------------------------//

FUNCTION ValToMoney( cMoney )

RETURN ( Val( StrTran( cMoney, ",", "." ) ) )

//--------------------------------------------------------------------------//

FUNCTION LineDown( cAlias, oBrw )

RETURN ( lineReposition( cAlias, oBrw, .f. ) )

//--------------------------------------------------------------------------//

FUNCTION LineDownOld( cAlias, oBrw )

RETURN ( lineRepositionOld( cAlias, oBrw, .f. ) )

//--------------------------------------------------------------------------//

FUNCTION LineUp( cAlias, oBrw )

RETURN ( lineReposition( cAlias, oBrw, .t. ) )

//--------------------------------------------------------------------------//

FUNCTION LineUpOld( cAlias, oBrw )

RETURN ( lineRepositionOld( cAlias, oBrw, .t. ) )

//--------------------------------------------------------------------------//

FUNCTION lineReposition( cAlias, oBrw, lUp )

   local nOrdNum  
   local nRecNum  
   local nOldNum
   local nNewNum
   local currentAlias

   DEFAULT lUp    := .t.

   if ( cAlias )->( fieldpos( "nPosPrint" ) ) == 0
      RETURN .f.
   end if

   nOrdNum        := ( cAlias )->( OrdSetFocus( "nPosPrint" ) )

   if ( lUp .and. ( cAlias )->( OrdKeyNo() ) == 1 )
      ( cAlias )->( OrdSetFocus( nOrdNum ) )   
      RETURN .f.
   end if 

   if ( !lUp .and. ( cAlias )->( OrdKeyNo() ) == ( cAlias )->( OrdKeyCount() ) )
      ( cAlias )->( OrdSetFocus( nOrdNum ) )   
      RETURN .f.
   end if

   CursorWait()

   nRecNum        := ( cAlias )->( RecNo() )
   nOldNum        := ( cAlias )->nPosPrint

   if lUp
      ( cAlias )->( dbSkip(-1) )
   else 
      ( cAlias )->( dbSkip() )
   end if 

   nNewNum        := ( cAlias )->nPosPrint

   // cambio de lineas

   swapLines( nOldNum, nNewNum, cAlias )

   // orden anterior

   ( cAlias )->( OrdSetFocus( nOrdNum ) )
   ( cAlias )->( dbGoTo( nRecNum ) )

   CursorWE()

   if !empty( oBrw )
      oBrw:Refresh()
      oBrw:select( 0 )
      oBrw:select( 1 )
      oBrw:SetFocus()
   end if

RETURN ( nil )

//--------------------------------------------------------------------------//

FUNCTION lineRepositionOld( cAlias, oBrw, lUp )

   local nOrdNum  
   local nRecNum  
   local nOldNum
   local nNewNum
   local currentAlias
   
   DEFAULT lUp    := .t.

   if ( cAlias )->( fieldpos( "nNumLin" ) ) == 0
      RETURN .f.
   end if

   nOrdNum        := ( cAlias )->( OrdSetFocus( "nNumLin" ) )

   if ( lUp .and. ( cAlias )->( OrdKeyNo() ) == 1 )
      ( cAlias )->( OrdSetFocus( nOrdNum ) )   
      RETURN .f.
   end if 

   if ( !lUp .and. ( cAlias )->( OrdKeyNo() ) == ( cAlias )->( OrdKeyCount() ) )
      ( cAlias )->( OrdSetFocus( nOrdNum ) )   
      RETURN .f.
   end if

   CursorWait()

   nRecNum        := ( cAlias )->( RecNo() )
   nOldNum        := ( cAlias )->nNumLin

   if lUp
      ( cAlias )->( dbSkip(-1) )
   else 
      ( cAlias )->( dbSkip() )
   end if 

   nNewNum        := ( cAlias )->nNumLin

   // cambio de lineas

   swapLines( nOldNum, nNewNum, cAlias )

   // orden anterior

   ( cAlias )->( OrdSetFocus( nOrdNum ) )
   ( cAlias )->( dbGoTo( nRecNum ) )

   CursorWE()

   if !empty( oBrw )
      oBrw:Refresh()
      oBrw:select( 0 )
      oBrw:select( 1 )
      oBrw:SetFocus()
   end if

RETURN ( nil )

//--------------------------------------------------------------------------//

Static FUNCTION swapLines( nOldNum, nNewNum, cAlias ) 

   lineMove( nOldNum, -1, cAlias )
   lineMove( nNewNum, nOldNum, cAlias )
   lineMove( -1, nNewNum, cAlias )

RETURN ( nil )

//--------------------------------------------------------------------------//

Static FUNCTION swapLinesOld( nOldNum, nNewNum, cAlias ) 

   lineMoveOld( nOldNum, -1, cAlias )
   lineMoveOld( nNewNum, nOldNum, cAlias )
   lineMoveOld( -1, nNewNum, cAlias )

RETURN ( nil )

//--------------------------------------------------------------------------//

Static FUNCTION LineMove( nOldNum, nNewNum, cAlias )

   local ordenAnterior  := ( cAlias )->( ordsetfocus( 0 ) )

   ( cAlias )->( dbgotop() )
   while !( cAlias )->( eof() )

      if ( cAlias )->nPosPrint == nOldNum
         ( cAlias )->nPosPrint := nNewNum
      end if

      ( cAlias )->( dbSkip() )

   end while

   ( cAlias )->( ordsetfocus( ordenAnterior ) )

RETURN nil

//--------------------------------------------------------------------------//

Static FUNCTION LineMoveOld( nOldNum, nNewNum, cAlias )

   local ordenAnterior  := ( cAlias )->( ordsetfocus( 0 ) )

   ( cAlias )->( dbgotop() )
   while !( cAlias )->( eof() )

      if ( cAlias )->nNumLin == nOldNum
         ( cAlias )->nNumLin := nNewNum
      end if

      ( cAlias )->( dbSkip() )

   end while

   ( cAlias )->( ordsetfocus( ordenAnterior ) )

RETURN nil

//--------------------------------------------------------------------------//

FUNCTION DeleteFilesToDirectory( cPath )

   local cDirectory
   local aDirectory     := Directory( cPath + "/*.*" )

   for each cDirectory in aDirectory
      ERASE ( cPath + "/" + cDirectory[ 1 ] )
   next

RETURN .t.   

//--------------------------------------------------------------------------//

FUNCTION PutBrackets( cText )

RETURN ( "[" + QuitBrackets( cText ) + "]" )   

//--------------------------------------------------------------------------//

FUNCTION QuitBrackets( cText )

   cText    := strtran( cText, "[", "" )
   cText    := strtran( cText, "]", "" )

RETURN ( alltrim( cText ) )

//--------------------------------------------------------------------------//

FUNCTION DateToString( dDate )
      
   local cDateFormat    := set( 4, "yyyy/mm/dd" )
   local strDate        := if( dDate != nil, dtos( dDate ), dtos( date() ) )
   set( 4, cDateFormat )

RETURN( strDate )

//---------------------------------------------------------------------------//

FUNCTION DateToSQLString( dDate )
      
   local cDateFormat    := set( 4, "yyyy-mm-dd" )
   local strDate        := if( dDate != nil, dtoc( dDate ), dtoc( date() ) )
   set( 4, cDateFormat )

RETURN( strDate )

//---------------------------------------------------------------------------//

FUNCTION DlgWait( nRetardo )

   local nSeconds

   DEFAULT nRetardo  := 0.1

   nSeconds          := Seconds() + nRetardo

   while nSeconds >= Seconds()
   end while

RETURN ( nil )

//---------------------------------------------------------------------------//

FUNCTION setLenguajeSegundario( cLenguaje )

   if !empty( cLenguaje )
      cLenguajeSegundario  := cLenguaje
   end if

RETURN( .t. )

//---------------------------------------------------------------------------//

FUNCTION getLenguajeSegundario()

RETURN cLenguajeSegundario

//---------------------------------------------------------------------------//

FUNCTION fieldGetByName( cFieldName )

   if empty( alias() )
      RETURN ""
   end if 

RETURN ( ( alias() )->( fieldget( fieldpos( cFieldName ) ) ) )

//---------------------------------------------------------------------------//

FUNCTION hGetDefault( hash, key, default )

   if hhaskey( hash, key )
      RETURN ( hGet( hash, key ) )
   end if 

RETURN ( default )

//---------------------------------------------------------------------------//
   
CLASS excluyentArray

   CLASSDATA  aArray       INIT {}

   Method Init()           INLINE ( ::aArray := {} )
   Method Add(uValue)      INLINE ( if( aScan( ::aArray, uValue ) == 0, aAdd( ::aArray, uValue ), ) )
   Method Get(n)           INLINE ( if( empty(n), ::aArray, ::aArray[ n ] ) )
   Method empty()          INLINE ( empty( ::aArray ) )

END CLASS

//---------------------------------------------------------------------------//

FUNCTION assertUserActive( uuidUsuario )

   local nHandle

   uuidUsuario    := alltrim( uuidUsuario )

   if file( cPatUsr() + uuidUsuario + ".usr" )
      RETURN ( .t. )
   end if 
   
   nHandle        := fcreate( cPatUsr() + uuidUsuario + ".usr", FC_NORMAL )
   if ( nHandle != F_ERROR )
      fClose( nHandle )
   end if

RETURN ( .t. )

//----------------------------------------------------------------------------//

FUNCTION isUserActive( uuidUsuario, lClose )

   local nHandle

   DEFAULT lClose := .t.   

   uuidUsuario    := alltrim( uuidUsuario )

   assertUserActive( uuidUsuario )

   nHandle        := fopen( cPatUsr() + uuidUsuario + ".usr", FO_EXCLUSIVE )  
   if ( nHandle == F_ERROR )
      RETURN ( .t. )
   end if 

   if lClose
      fClose( nHandle )
   end if 

RETURN ( .f. )

//----------------------------------------------------------------------------//

FUNCTION setUserActive( uuidUsuario )

RETURN ( isUserActive( uuidUsuario, .f. ) )

//----------------------------------------------------------------------------//

FUNCTION debug( uValue, cTitle )

RETURN ( msgInfo( hb_valtoexp( uValue ), cTitle ) )

//----------------------------------------------------------------------------//

FUNCTION setCustomFilter( cExpresionFilter )

   ( select() )->( dbSetFilter( bCheck2Block( cExpresionFilter ), cExpresionFilter ) )

RETURN ( nil )

//----------------------------------------------------------------------------//

FUNCTION quitCustomFilter()

   ( select() )->( dbSetFilter() )

RETURN ( nil )

//----------------------------------------------------------------------------//

FUNCTION dbCustomKeyCount()

RETURN ( ( select() )->( ordkeycount() ) )

//----------------------------------------------------------------------------//

FUNCTION isAppendOrDuplicateMode( nMode )
 
RETURN ( nMode == APPD_MODE .or. nMode == DUPL_MODE )

//----------------------------------------------------------------------------//

FUNCTION isEditMode( nMode )
 
RETURN ( nMode == EDIT_MODE )

//----------------------------------------------------------------------------//

FUNCTION priorSecond( time )

   time  := ( substr( time, 1, 2 ) + ":" + substr( time, 3, 2 ) + ":" + substr( time, 5, 2 ) )
   time  := secToTime( timeToSec( time ) - 1 )  
   time  := strtran( time, ":", "" )

RETURN ( time )

//----------------------------------------------------------------------------//

FUNCTION dialogArticulosScaner() 

   local oDlg
   local memoArticulos

   DEFINE DIALOG oDlg RESOURCE "IMPORTAR_INVENTARIO" 

      REDEFINE GET memoArticulos ;
         MEMO ;
         ID       110 ;
         OF       oDlg

      REDEFINE BUTTON ;
         ID       IDOK ;
         OF       oDlg ;
         ACTION   ( oDlg:end( IDOK ) )

      REDEFINE BUTTON ;
         ID       IDCANCEL ;
         OF       oDlg ;
         CANCEL ;
         ACTION   ( oDlg:end() )

   oDlg:AddFastKey( VK_F5, {|| oDlg:end( IDOK ) } )

   ACTIVATE DIALOG oDlg CENTER

   if oDlg:nResult == IDOK
      RETURN ( alltrim( memoArticulos ) )
   end if 

RETURN ( nil )

//----------------------------------------------------------------------------//

FUNCTION transIdDocument( id )

RETURN ( strtran( trans( id, "@R X/XXXXXXXXX/XX" ), " ", "" ) )

//----------------------------------------------------------------------------//

FUNCTION cNoBrackets( cFileName )

   local n           := rat( "[", cFileName )

   if ( n != 0 )
      cFileName      := substr( cFileName, 1, n - 1 )
   end if 

RETURN ( cFileName )

//----------------------------------------------------------------------------//

FUNCTION trimedSeconds()

RETURN ( alltrim( strtran( str( seconds() ), ".", "" ) ) )

//----------------------------------------------------------------------------//

FUNCTION serializeArray( aArray, cDelimiter, lQuoted )

   local cSerialized    := ""

   DEFAULT cDelimiter   := ","
   DEFAULT lQuoted      := .f.

   if empty( aArray )
      RETURN ( cSerialized )
   end if 

   aeval( aArray, {|elem| cSerialized += if( lQuoted, quoted( elem ), alltrim( elem ) ) + cDelimiter } )

   cSerialized          := left( cSerialized, len( cSerialized ) - 1 )

RETURN ( cSerialized )

//----------------------------------------------------------------------------//

FUNCTION serializeQuotedArray( aArray, cDelimiter )

RETURN ( serializeArray( aArray, cDelimiter, .t. ) )

//----------------------------------------------------------------------------//


FUNCTION aFirst( aArray )

   if !hb_isarray( aArray ) .or. len( aArray ) = 0
      RETURN ( nil )
   end if 

RETURN ( aArray[ 1 ] )

//----------------------------------------------------------------------------//

FUNCTION getHashFromWorkArea( cAlias ) 

   local n
   local hash        := {=>}

   if empty( cAlias )
      RETURN ( hash )
   end if  

   for n := 1 to ( cAlias )->( fcount() )
      hSet( hash, lower( ( cAlias )->( fieldname( n ) ) ), ( cAlias )->( fieldget( n ) ) )
   next  

RETURN ( hash )

//---------------------------------------------------------------------------//

FUNCTION fetchHashFromWorkArea( cAlias )

   local aFetch   := {}

   ( cAlias )->( dbeval( {|| aadd( aFetch, getHashFromWorkArea( cAlias ) ) } ) )

RETURN ( aFetch )

//---------------------------------------------------------------------------//

FUNCTION externalObjectSender( cMsg, u1, u2, u3, u4, u5, u6, u7, u8, u9, u10 )

   local nPos
   local uRETURN
   local cObject

   if empty( cMsg )
      RETURN ( "" )
   end if 

   nPos        := at( ":", cMsg )
   if nPos == 0
      RETURN ( "" )
   end if 

   cObject     := substr( cMsg, 1, nPos - 1 )

   cMsg        := strtran( cMsg, cObject, "" )
   cMsg        := strtran( cMsg, ":", "" )

   try 

      uRETURN  := apoloSender( &( cObject ), cMsg, u1, u2, u3, u4, u5, u6, u7, u8, u9, u10 )

   catch

      msgStop( "Error en la expresi�n : " + cMsg )

   end

RETURN ( uRETURN )

//---------------------------------------------------------------------------//

FUNCTION ApoloSender( oObject, cMsg, u1, u2, u3, u4, u5, u6, u7, u8, u9, u10 )

   cMsg           := StrTran( cMsg, "()", "" )

   do case
      case IsNil( u1 )
         RETURN ( oObject:&( cMsg )() )

      case IsNil( u2 )
         RETURN ( oObject:&( cMsg )( u1 ) )

      case IsNil( u3 )
         RETURN ( oObject:&( cMsg )( u1, u2 ) )

      case IsNil( u4 )
         RETURN ( oObject:&( cMsg )( u1, u2, u3 ) )

      case IsNil( u5 )
         RETURN ( oObject:&( cMsg )( u1, u2, u3, u4 ) )

      case IsNil( u6 )
         RETURN ( oObject:&( cMsg )( u1, u2, u3, u4, u5 ) )

      case IsNil( u7 )
         RETURN ( oObject:&( cMsg )( u1, u2, u3, u4, u5, u6 ) )

      case IsNil( u8 )
         RETURN ( oObject:&( cMsg )( u1, u2, u3, u4, u5, u6, u7 ) )

      case IsNil( u9 )
         RETURN ( oObject:&( cMsg )( u1, u2, u3, u4, u5, u6, u7, u8 ) )

      case IsNil( u10 )
         RETURN ( oObject:&( cMsg )( u1, u2, u3, u4, u5, u6, u7, u8, u9 ) )

      otherwise
         RETURN ( oObject:&( cMsg )( u1, u2, u3, u4, u5, u6, u7, u8, u9, u10 ) )

   end case 

RETURN ( nil )

//--------------------------------------------------------------------------//

FUNCTION dialogSayNo( oDlg )

   oDlg:coorsUpdate()
   oDlg:Move( oDlg:nTop, oDlg:nLeft - 100 )  ; SysWait(.05)
   oDlg:Move( oDlg:nTop, oDlg:nLeft )        ; SysWait(.05)
   oDlg:Move( oDlg:nTop, oDlg:nLeft + 100 )  ; SysWait(.05)
   oDlg:Move( oDlg:nTop, oDlg:nLeft )        ; SysWait(.05)
   oDlg:Move( oDlg:nTop, oDlg:nLeft - 50 )   ; SysWait(.1)
   oDlg:Move( oDlg:nTop, oDlg:nLeft  )       ; SysWait(.1)
   oDlg:Move( oDlg:nTop, oDlg:nLeft + 50 )   ; SysWait(.1)
   oDlg:Move( oDlg:nTop, oDlg:nLeft )

RETURN ( .f. )

//---------------------------------------------------------------------------//

/*
Selecciona el fichero de un grafico
*/

FUNCTION GetBmp( aGet, cMask, cPath )

   local cFile 

   DEFAULT cMask  := "Imagenes (*.bmp,jpg,png,gif)|*.bmp;*.jpg;*.png;*.gif|"
   DEFAULT cPath  := cPatImg()

   cFile          := upper( cGetFile( cMask, "Seleccione el fichero", 1, cPath ) )

   if aGet != nil .and. !empty( cFile )

      aGet:cText( padr( cFile, 254 ) )

      if !empty( aGet:bChange )
         eval( aGet:bChange )
      end if

   end if

RETURN ( cFile )

//---------------------------------------------------------------------------//

FUNCTION GetDocumento( aGet )

RETURN ( GetBmp( aGet, "Documento (*.*)|*.*|" ) )

//---------------------------------------------------------------------------//

FUNCTION ChgBmp( aGet, bmpFile )

   local cFile    := ""

   do case
      case hb_isobject( aGet )
         cFile    := cFileBmpName( Rtrim( aGet:VarGet() ) )
      case hb_ischar( aGet )
         cFile    := Rtrim( aGet )
   end case

   if empty( bmpFile )
      RETURN ( .t. )
   end if 

   if !file( cFile )
      bmpFile:Hide()
      RETURN ( .t. )
   end if

   bmpFile:LoadBmp( cFile )
   bmpFile:Show()

RETURN ( .t. )

//---------------------------------------------------------------------------//

FUNCTION ChgDoc( aGet, docFile )

   local cFile    := ""

   do case
      case hb_isobject( aGet )
         cFile    := cFileBmpName( Rtrim( aGet:VarGet() ) )
      case hb_ischar( aGet )
         cFile    := Rtrim( aGet )
   end case

   if empty( docFile )
      RETURN ( .t. )
   end if 

   if !file( cFile )
      docFile:Hide()
      RETURN ( .t. )
   end if

   docFile:LoadBmp( cFile )
   docFile:Show()

RETURN ( .t. )

//---------------------------------------------------------------------------//

FUNCTION cFileBmpName( cFile, lEmptyImage )

   DEFAULT lEmptyImage  := .f.

   if File( cFile )
      RETURN ( cFile )
   end if

   if At( ":", cFile ) == 0 .and. !Empty( cPatImg() )
      cFile    := Rtrim( cPatImg() ) + Rtrim( cFile )
   else
      cFile    := Rtrim( cFile )
   end if

   if lEmptyImage .and. !File( cFile )
      cFile    := "Bmp\NoImage.bmp"
   end if

RETURN ( cFile )

//---------------------------------------------------------------------------//

FUNCTION isImageInApplicationStorage( cFile )

   if empty( cFile )
      RETURN ( .f. )
   end if

   if empty( cPatImg() )
      RETURN ( .f. )
   end if

   cFile       := rtrim( cPatImg() ) + rtrim( cFile )

RETURN ( file( cFile ) )

//---------------------------------------------------------------------------//

FUNCTION isDocumentInApplicationStorage( cFile  )

   if empty( cFile )
      RETURN ( .f. )
   end if

   if empty( cPatDoc() )
      RETURN ( .f. )
   end if

   cFile       := rtrim( cPatDoc() ) + rtrim( cFile )

RETURN ( file( cFile ) )

//---------------------------------------------------------------------------//

FUNCTION permutateArray( aArray )

   local x
   local aResults    := {}

   for x = 1 to len( aArray ) - 1
      if x = 1
         aResults    := mixArray( aArray[ x ], aArray[ x + 1 ] )
      else
         aResults    := mixArray( aResults, aArray[ x + 1 ] )
      end if
   next x

RETURN ( aclone( aResults ) )

//----------------------------------------------------------------------------//

FUNCTION mixArray( aGrp1, aGrp2 )

   local x
   local y
   local aTemps   := {}

   if !empty( aGrp1 ) .and. !empty( aGrp2 )
      if !( hb_isarray( aGrp1[ 1 ] ) )
         for x = 1 to Len( aGrp1 )
            for y = 1 to Len( aGrp2 )
               aadd( aTemps, {} )
               aadd( atail( aTemps ), aGrp1[ x ] )
               aadd( atail( aTemps ), aGrp2[ y ] )
            next y
         next x
      else
         for x = 1 to Len( aGrp1 )
            for y = 1 to Len( aGrp2 )
               aadd( aTemps, {} )
               aeval( aGrp1[ x ], { | a | aadd( atail( aTemps ), a ) } )
               aadd( aTail( aTemps ), aGrp2[ y ] )
            next y
         next x
      endif
   endif

RETURN ( aclone( aTemps ) )

//----------------------------------------------------------------------------//

FUNCTION ShowImage( oBmpImage )

   local oDlg
   local oBmp
   local nHeight
   local nWidth

   if !Empty( oBmpImage )

      nHeight     := oBmpImage:nHeight()
      nWidth      := oBmpImage:nWidth()

      if !Empty( nHeight ) .and. !Empty( nWidth )

         DEFINE DIALOG oDlg FROM 0, 0 TO nHeight, nWidth PIXEL TITLE "Imagen"

            @ 0, 0   IMAGE    oBmp ;
                     OF       oDlg ;
                     FILE     Rtrim( oBmpImage:cBmpFile )

         ACTIVATE DIALOG oDlg CENTER

      end if

   end if

RETURN nil

//---------------------------------------------------------------------------//

FUNCTION ShowImageFile( cImageFile )

   local oDlg
   local oBmp

   if File( Rtrim( cImageFile ) )

      DEFINE DIALOG oDlg FROM 0, 0 TO 800, 800 PIXEL TITLE "Imagen"

         @ 0, 0   IMAGE oBmp ;
                  OF    oDlg ;
                  FILE  Rtrim( cImageFile )

      ACTIVATE DIALOG oDlg CENTER

   else

      MsgStop( "Fichero " + Rtrim( cImageFile ) + " no encontrado." )

   end if

RETURN nil

//---------------------------------------------------------------------------//

Function Calendario( dDate, cTitle )

   local oDlg
   local oCal

   DEFAULT dDate  := Date()
   DEFAULT cTitle := "Calendario"

   DEFINE DIALOG oDlg RESOURCE "Calendar" TITLE cTitle

      oCal        := TCalendar():ReDefine( 100, { |u| if( pCount() == 0, dDate, dDate := u ) }, , oDlg, , , , , , , , , , , , {|| oDlg:End( IDOK ) }, {|| oDlg:End( IDOK ) } )

   ACTIVATE DIALOG oDlg CENTER

   if ( oDlg:nResult == IDOK )
      dDate       := oCal:GetDate()
   end if

RETURN ( dDate )

//----------------------------------------------------------------------------//

FUNCTION msgMemory()

   local cText    := ""

   cText          += "Free Variable Space (kb) : " + hb_ntos( memory( HB_MEM_CHAR ) ) + hb_eol() 
   cText          += "Largest String (kb) : " + hb_ntos( memory( HB_MEM_BLOCK ) ) + hb_eol() 
   cText          += "RUN Memory (kb) : " + hb_ntos( memory( HB_MEM_RUN ) ) + hb_eol() 
   
   cText          += "Virtual Memory (kb) : " + hb_ntos( memory( HB_MEM_VM ) ) + hb_eol() 
   cText          += "Fixed Memory/Heap (kb) : " + hb_ntos( memory( HB_MEM_FM ) ) + hb_eol() 
   cText          += "Segments in Fixed Memory/Heap  : " + hb_ntos( memory( HB_MEM_FMSEGS ) ) + hb_eol() 
   cText          += "Free Swap Memory (KB) : " + hb_ntos( memory( HB_MEM_SWAP ) ) + hb_eol() 
   cText          += "Free Conventional (KB) : " + hb_ntos( memory( HB_MEM_CONV ) ) + hb_eol() 
   cText          += "Used Expanded Memory (KB) : " + hb_ntos( memory( HB_MEM_EMSUSED ) ) + hb_eol() 

   cText          += "Memory used (bytes) : " + hb_ntos( memory( HB_MEM_USED ) ) + hb_eol() 
   cText          += "Maximum memory used (bytes) : " + hb_ntos( memory( HB_MEM_USEDMAX ) ) + hb_eol() 
   cText          += "Total items on the stack : " + hb_ntos( memory( HB_MEM_STACKITEMS ) ) + hb_eol() 
   cText          += "Total memory size used by the stack (bytes) : " + hb_ntos( memory( HB_MEM_STACK ) ) + hb_eol() 
   cText          += "Total items currently on the stack : " + hb_ntos( memory( HB_MEM_STACK_TOP ) ) + hb_eol() 
   cText          += "List all allocated blocks : " + hb_ntos( memory( HB_MEM_BLOCKS ) ) + hb_eol() 

RETURN ( msgInfo( cText, "Estado de la memmoria" ) )

//---------------------------------------------------------------------------//

FUNCTION cPatImg( cPath )

   DEFAULT cPath  := "Imagen" 

   if right( cPath, 1 ) != "\"
      cPath       += "\"
   end if

RETURN ( cPath )

//----------------------------------------------------------------------------//

 FUNCTION cPatDoc( cPath )

   DEFAULT cPath  := "Doc"

   if right( cPath, 1 ) != "\"
      cPath       += "\"
   end if

RETURN ( cPath )

//---------------------------------------------------------------------------//

FUNCTION hDels( hHash, aKeys )

RETURN ( aeval( aKeys, {|cKey| hdel( hHash, cKey ) } ) )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//


