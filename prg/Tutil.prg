//----------------------------------------------------------------------------//
//  AUTOR.....: Manuel Exp¢sito Su rez   Soft 4U                              //
//  e-Mail....: maex14@dipusevilla.es                                         //
//  CLASE.....: General                                                       //
//  FECHA MOD.: 24/01/2002                                                    //
//  VERSION...: 11.00                                                         //
//  PROPOSITO.: Funciones auxiliares  para TDbf                               //
//----------------------------------------------------------------------------//
//----------------------------------------------------------------------------//

#include "FiveWin.Ch"

#ifndef __PDA__

//---------------------------------------------------------------------------//
//Funciones del programa
//---------------------------------------------------------------------------//

function lSetBuffer( oDbf, cOnOff )

    local lBuf := .f.
    local cType := "C"

    if ValType( oDbf ) == "O"
        lBuf := oDbf:lBuffer
        if cOnOff == nil
            lBuf := .f.
        else
            cType := ValType( cOnOff )
            if cType == "C"
                cOnOff := upper( cOnOff )
                if cOnOff $ "ON TRUE ACTIVE"
                    lBuf := .t.
                elseif cOnOff $ "OFF FALSE DEACTIVE"
                    lBuf := .f.
                endif
            elseif cType == "L"
                lBuf := cOnOff
            endif
        endif
        oDbf:SetBuffer( lBuf )
    endif

return( lBuf )

//----------------------------------------------------------------------------//
// Devuelve una cadena con el registro actual en la TDbf

Function DbRow( oDb )

    loca aRet := {}

    AEval( oDb:aTField, { | oFld | AAdd( aRet, oFld:AsString ) } )

return( aRet )

//----------------------------------------------------------------------------//
// Devuelve el numero total de ordenes en una lista de ordenes de una WA
// USO:
// nIdxTotal := ( nArea )->( OrdListLen() )

Function OrdListLen()

    local nRet := 0
    local n    := 0

    while !empty( OrdName( ++n ) )
        ++nRet
    end

return( nRet )

//----------------------------------------------------------------------------//
// Extrae registro a bajo nivel
// Si no se pasa registro se supone el actual

function GetRecord( nRec )

   local nRecNo  := RecNo()
   local nHeader := Header()
   local nLenRec := RecSize()
   local nHdl    := DbfHdl()
   local nOffSet := 0
   local cBuffer := space( nLenRec )

   nRec := if( ValType( nRec ) != "N", RecNo(), nRec )
   nOffSet := ( nLenRec * ( nRec - 1 ) ) + nHeader

   FSeek( nHdl, nOffSet, 0 )
   FRead( nHdl, @cBuffer, nLenRec )

   DbGoTo( nRecNo )

return( cBuffer )

//---------------------------------------------------------------------------//
//
// Actualiza la estructura del objeto oDbf e importa sus datos
//

function lCheckDbf( oDbf, bRecord )

   local i
   local nPos
   local lMemo
   local nCount
   local cFileNew
   local cMemoNew
   local cFileName
   local cMemoName

   if !IsObject( oDbf )
      return .f.
   end if

   nCount            := 0
   lMemo             := oDbf:lMemo
   cFileName         := Upper( oDbf:cFile )
   cMemoName         := StrTran( Upper( oDbf:cFile ), ".DBF", ".FPT" )

   while lExistTable( cFileNew := oDbf:cPath + "FNew" + PadL( ++nCount, 3, "0" ) + ".DBF" ) .or. ;
         lExistTable( cMemoNew := oDbf:cPath + "FNew" + PadL( nCount, 3, "0" ) + ".FPT" )
   end while

   /*
   Cerramos la base de datos--------------------------------------------------
   */

   if oDbf:Used()
      oDbf:Close()
   end if

   /*
   Borramos los indices -------------------------------------------------------
   */

   oDbf:IdxFDel()

   /*
   Intento de renombrar--------------------------------------------------------
   */

   if fRenameTable( cFileName, cFileNew, oDbf:cRDD ) != 0
      return .f.
   end if

   if isTrue( lMemo ) .and. fRenameTable( cMemoName, cMemoNew, oDbf:cRDD ) != 0
      return .f.
   end if

   /*
   Trasbase de informacion-----------------------------------------------------
   */

   oDbf:Activate( .f., .f. )

   if File( cFileNew )

      dbUseArea( .t., oDbf:cRDD, cFileNew, "_WNew", .f. )

      nCount := oDbf:fCount() //_WNew->( FCount() )

      while !_WNew->( Eof() )

         ( oDbf:nArea )->( DbAppend() )

         for i := 1 to nCount
            nPos  := _WNew->( FieldPos( ( oDbf:nArea )->( FieldName( i ) ) ) )
            if nPos != 0
               ( oDbf:nArea )->( FieldPut( i, _WNew->( FieldGet( nPos ) ) ) )
            end if
         next

         if( ValType( bRecord ) == "B", Eval( bRecord, oDbf ), )

         _WNew->( dbSkip() )

      end

      _WNew->( dbCloseArea() )

   end if

   if lExistTable( cFileNew, oDbf:cRDD )
      fEraseTable( cFileNew, oDbf:cRDD )
   end if

   if isTrue( lMemo ) .and. lExistTable( cMemoNew, oDbf:cRDD )
      fEraseTable( cMemoNew, oDbf:cRDD )
   end if

   oDbf:Close()

return( .t. )

//---------------------------------------------------------------------------//

function xArea( uWA )

    local nArea := 0
    local nType := ValType( uWA )

    if nType == "O"
        nArea := uWA:nArea          // Es un objeto TDbf
    elseif nType == "C"
        nArea := Select( uWA )      // Es un alias
    else
        nArea := Select()           // El area por defecto
    endif

return( nArea )

//---------------------------------------------------------------------------//

function aType( cType )

    local aTipo   := { "ALL" }

    cType         := upper( cType )

    do case
        case cType $ "CM"
            aTipo := { "CHARACTER" }
        case cType == "N"
            aTipo := { "NUMERIC" }
        case cType == "D"
            aTipo := { "DATE" }
        case cType == "L"
            aTipo := { "BOOL" }
        case cType == "B"
            aTipo := { "BLOCK" }
    end case

return( aTipo )

//----------------------------------------------------------------------------//

Function UpTime( oGet )

   local cTime    := oGet:VarGet()
   local nHora    := Val( SubStr( cTime, 1, 2 ) )
   local nMinuto  := Val( SubStr( cTime, 3, 2 ) )

   ++nMinuto

   if nMinuto > 59
      nMinuto     := 0
      ++nHora
      if nHora > 23
         nHora    := 0
      end if
   end if

   oGet:cText( StrZero( nHora, 2 ) + StrZero( nMinuto, 2 ) )

Return ( .t. )

//----------------------------------------------------------------------------//

Function DwTime( oGet )

   local cTime    := oGet:VarGet()
   local nHora    := Val( SubStr( cTime, 1, 2 ) )
   local nMinuto  := Val( SubStr( cTime, 3, 2 ) )

   --nMinuto

   if nMinuto < 0
      nMinuto     := 59
      --nHora
      if nHora < 0
         nHora    := 23
      end if
   end if

   oGet:cText( StrZero( nHora, 2 ) + StrZero( nMinuto, 2 ) )

Return ( .t. )

//----------------------------------------------------------------------------//

Function nElapTime( cTimeInicial, cTimeFinal )

   local nTotalMinutos  := 0

   nTotalMinutos        := ( Val( SubStr( cTimeFinal, 1, 2 ) ) * 60 ) + Val( SubStr( cTimeFinal, 3, 2 ) )
   nTotalMinutos        -= ( Val( SubStr( cTimeInicial, 1, 2 ) ) * 60 ) + Val( SubStr( cTimeInicial, 3, 2 ) )

   if nTotalMinutos < 0
      nTotalMinutos  += 1440 // Total de minutos de un dia
   end if

Return ( nTotalMinutos )

//---------------------------------------------------------------------------//
/*
Devuelve las horas empleadas entre dos fechas y dos horas----------------------
*/

Function nTiempoEntreFechas( dFecInicio, dFecFin, cTimeInicio, cTimeFin )

   local nTotalHoras    := 0
   local nTotalMinutos  := 0
   local nDiferencia    := 0

   nDiferencia          := dFecFin - dFecInicio

   nTotalMinutos        := ( Val( SubStr( cTimeFin, 1, 2 ) ) * 60 ) + Val( SubStr( cTimeFin, 3, 2 ) )
   nTotalMinutos        -= ( Val( SubStr( cTimeInicio, 1, 2 ) ) * 60 ) + Val( SubStr( cTimeInicio, 3, 2 ) )


   if nDiferencia == 0
      nTotalHoras       := ( nDiferencia ) * 24
   else
      if nTotalMinutos  >= 0
         nTotalHoras       := ( nDiferencia ) * 24
      else
         nTotalHoras       := ( nDiferencia - 1 ) * 24
      end if

   end if

   if nTotalMinutos < 0
      nTotalHoras          += ( ( nTotalMinutos + 1440 ) / 60 )
   else
      nTotalHoras          += ( nTotalMinutos / 60 )
   end if

Return ( nTotalHoras )

//---------------------------------------------------------------------------//
/*
Devuelve Dias, Horas y Minutos pasandole las horas trascurridas entre dos fechas
*/

Function cFormatoDDHHMM( nHoras )

   local nDias       := 0
   local nHor        := 0
   local nMinutos    := 0
   local nCalculo    := 0
   local cFormato    := ""

   if nHoras > 0

      nCalculo       := nHoras / 24
      nDias          := Int( nCalculo )
      nCalculo       := ( nCalculo - Int( nCalculo ) ) * 24
      nHor           := Int( nCalculo )
      nCalculo       := ( nCalculo - Int( nCalculo ) ) * 60
      nMinutos       := Int( Round( nCalculo, 0 ) )

      do case
         case nDias > 1
         cFormato    := AllTrim( Str( nDias ) ) + " días, " + AllTrim( Str( nHor ) ) + "h " + AllTrim( Str( nMinutos ) ) + " min"
         case nDias == 1
         cFormato    := AllTrim( Str( nDias ) ) + " día, " + AllTrim( Str( nHor ) ) + "h " + AllTrim( Str( nMinutos ) ) + " min"
         case nDias < 1
         cFormato    := AllTrim( Str( nHor ) ) + "h " + AllTrim( Str( nMinutos ) ) + " min"
      end case

   end if

Return ( cFormato )

//---------------------------------------------------------------------------//

Function cAllTrimer( cCadena )

Return ( StrTran( cCadena, " ", "" ) )

//---------------------------------------------------------------------------//

/*
Pita y selecciona, una buena idea ?
*/

Function MsgBeepYesNo( cText, cTitle )

	ArtBeep()

Return ApoloMsgNoYes( cText, cTitle )

//-------------------------------------------------------------------------//

/*
Pita y da mensaje de Stop, una buena idea ?
*/

Function MsgBeepStop( cText, cTitle )

   DEFAULT cText  := "Stop"
   DEFAULT cTitle := "Stop"

	ArtBeep()

Return MsgStop( cText, cTitle )

//-------------------------------------------------------------------------//

/*
Pita y da mensaje de Stop, una buena idea ?
*/

Function MsgBeepWait( cText, cTitle, nTime )

	ArtBeep()

Return MsgWait( cText, cTitle, nTime )

//-------------------------------------------------------------------------//

Function ArtBeep()

	Tone( 100, 1 )
	Tone( 300, 1 )
	Tone( 100, 1 )
	Tone( 300, 1 )

Return .t.

#endif

//---------------------------------------------------------------------------//
// Funciones comunes del programa y pda
//---------------------------------------------------------------------------//
//
// Crea un codeBlock
//

Function c2Block( cExp )

   local bExp

   if !Empty( cExp ) //.and. At( Type( cExp ), "UEUI" ) == 0
      bExp     := &( "{|| " + cExp + " }" )
   end if

Return ( bExp )

//----------------------------------------------------------------------------//

// Extrae el fichero sin extension

function GetFileNoExt( cFullFile )

   local cNameFile := AllTrim( GetFileName( cFullFile ) )
   local n         := AT( ".", cNameFile )

return AllTrim( if( n > 0, left( cNameFile, n - 1 ), cNameFile ) )

//---------------------------------------------------------------------------//
// Extrae el Path de un fichero

function GetFileName( cFullFile )

   local nPos  := Rat( "\", cFullFile )
   local cFile := ""

   if !empty( cFullFile )
      if nPos == 0
         nPos  := At( ":", cFullFile )
      endif
      cFile    := SubStr( cFullFile, nPos + 1 )
   endif

return( cFile )

//----------------------------------------------------------------------------//

function GetPathFileNoExt( cFullFile )

   local cNameFile := alltrim( cFullFile )
   local n         := at( ".", cNameFile )

return alltrim( if( n > 0, left( cNameFile, n - 1 ), cNameFile ) )

//---------------------------------------------------------------------------//

function lChkSer( cSer, aSer )

   if Empty( cSer )
      cSer     := "A"
   end if

return ( aSer[ Min( Max( Asc( cSer ) - 64, 1 ), len( aSer ) ) ] )

//---------------------------------------------------------------------------//

function retFld( cCod, cAlias, xFld, nOrd )

   local nRec
   local nAnt
   local xRet     := ""

   if Empty( cAlias )
      return xRet
   end if

   if Empty( xFld )
      xFld        := 2
   end if
   if Empty( nOrd )
      nOrd        := 1
   end if

   nAnt           := ( cAlias )->( OrdSetFocus( nOrd ) )
   nRec           := ( cAlias )->( Recno() )

   // si no existe no situamos en EOF + 1 para que devuelva un campo vacio

   ( cAlias )->( dbgotop() )
   if !( cAlias )->( dbSeek( cCod ) )
       ( cAlias )->( dbGoBottom() )
       ( cAlias )->( dbSkip() )
   endif

   if ( valType( xFld ) == "N" )
      xRet        := ( cAlias )->( fieldget( xFld ) )
   elseif ( valType( xFld ) == "C" )
      xFld        := ( cAlias )->( fieldpos( xFld ) )
      xRet        := ( cAlias )->( fieldget( xFld ) )
   endif

   ( cAlias )->( OrdSetFocus( nAnt ) )
   ( cAlias )->( dbGoTo( nRec ) )

return ( xRet )

//--------------------------------------------------------------------------//
// Extrae el Path de un fichero

function GetPath( cFile )

    local nPos := 0
    local cPath := ""

    if ( nPos := rat( "\", cFile ) ) != 0
        cPath := upper( SubStr( cFile, 1, nPos ) )
    endif

return( cPath )

//----------------------------------------------------------------------------//

// Extrae la extension del fichero

function GetFileExt( cFullFile )

   local cExt := AllTrim( GetFileName( cFullFile ) )
   local n    := rat( ".", cExt )
   local nLen := len( cExt )

return AllTrim( if( n > 0 .and. nLen > n, right( cExt, nLen - n ), "" ) )

//---------------------------------------------------------------------------//

// Encuentra el siguiente valor

function NextVal( uVal )

   local nLen

   if ValType( uVal ) == "C"
      nLen  := Len( uVal )
      uVal  := Val( uVal )
      uVal  := AllTrim( Str( ++uVal ) )
      uVal  := Padr( uVal, nLen )
   else
      uVal++
   end if

return( uVal )

//----------------------------------------------------------------------------//

#ifndef __PDA__

function NextKey( uVal, uAlias, cChar, nLen )

   local nRec
   local nOrd

   if IsChar( ValType( uVal ) )

      if IsChar( uAlias )

         if IsNil( nLen )
            nLen  := Len( uVal )
         end if

         nOrd     := ( uAlias )->( ordsetfocus( 1 ) )
         nRec     := ( uAlias )->( OrdKeyNo() )

         ( uAlias )->( OrdKeyGoto( ( uAlias )->( OrdKeyCount() ) ) )

         if ( uAlias )->( OrdKeyVal() ) != nil
            uVal  := ( uAlias )->( OrdKeyVal() )
         else
            uVal  := ""
         end if

         while .t.

            uVal     := AllTrim( Str( Val( uVal ) + 1 ) )

            if !Empty( cChar )
               uVal  := rjust( uVal, cChar, nLen )
            end if

            if ( uAlias )->( dbSeek( uVal ) )
               loop
            else
               exit
            end if

         end while

         ( uAlias )->( ordsetfocus( nOrd ) )
         ( uAlias )->( OrdKeyGoTo( nRec ) )

      else

         nOrd     := uAlias:ordsetfocus( 1 )
         nRec     := uAlias:OrdKeyNo()

         uAlias:OrdKeyGoto( uAlias:OrdKeyCount() )

         if uAlias:OrdKeyVal() != nil
            uVal  := uAlias:OrdKeyVal()
         else
            uVal  := ""
         end if

         uVal     := AllTrim( Str( Val( uVal ) + 1 ) )

         uAlias:ordsetfocus( nOrd )
         uAlias:OrdKeyGoTo( nRec )

      end if

      uVal     := Padr( uVal, nLen )

   else

      if IsChar( Valtype( uAlias ) )
         uVal  := ( uAlias )->( OrdKeyCount() ) + 1
      else
         uVal  := uAlias:OrdKeyCount() + 1
      end if

   end if

return ( uVal )

#endif

//----------------------------------------------------------------------------//

function oRetFld( cCod, oDbf, xFld, nOrd )

   local nRec
   local nAnt
   local xRet     := ""

   if Empty( oDbf )
      return xRet
   end if

   if xFld == nil
      xFld        := 2
   end if

   if empty( nOrd )
      nOrd        := 1
   end if

   nRec           := oDbf:recno()

   if nOrd != nil
      nAnt        := oDbf:ordsetfocus( nOrd )
   end if

   /*
   si no existe no situamos en EOF + 1 para que devuelva un campo vacio
   con el mismo formato de campo pedido
   */

   if !oDbf:Seek( cCod )
       
       oDbf:GoBottom()

       oDbf:Skip()

   end if

   if ( valType( xFld ) == "N" )

       xRet  := oDbf:FieldGet( xFld )

   elseif ( valType( xFld ) == "C" )

       xFld  := oDbf:FieldPos( xFld )
       xRet  := oDbf:FieldGet( xFld )

   end if

   oDbf:GoTo( nRec )

   if nAnt != nil
      oDbf:ordsetfocus( nAnt )
   end if

return ( xRet )

//---------------------------------------------------------------------------//

function cGetFilename( cExt, cText, oGet )

   local cPathFile

   DEFAULT cExt      := 'Doc ( *.* ) | *.*'
   DEFAULT cText     := 'Seleccione el nombre del fichero'

   cPathFile         := cGetFile( cExt, cText )

   if !Empty( cPathFile ) .and. !Empty( oGet )
      oGet:cText( Padr( cPathFile, len( oGet:VarGet() ) )  )
   end if

return ( cPathFile )

//---------------------------------------------------------------------------//

function GetFileDateTime( cFile )

   if !file( cFile )
      Return ""
   end if 

Return ( dtos( FileDate( cFile ) ) + FileTime( cFile ) ) 

//---------------------------------------------------------------------------//

function getFieldFromDatabase( id, uField, cDatabase, uOrder )

   local workArea
   local fieldFromDatabase       := ""

   if empty( id )
      Return ( fieldFromDatabase )
   end if 

   if empty( cDatabase )
      Return ( fieldFromDatabase )
   end if 

   DEFAULT uField               := 2
   DEFAULT uOrder               := 1   

   dbUseArea( .t., cDriver(), cDatabase, cCheckArea( "workArea", @workArea ), .t. )
   ( workArea )->( ordListAdd( cDatabase ) )

   if ( workArea )->( used() )

      ( workArea )->( ordsetfocus( uOrder ) )

      if ( workArea )->( dbseek( id ) )
         if ( isnum( uField ) )
            fieldFromDatabase   := ( workArea )->( fieldget( uField ) )
         else 
            fieldFromDatabase   := ( workArea )->( fieldget( fieldpos( uField ) ) )
         end if 
      else
         fieldFromDatabase      := "valor no encontrado"
      end if 

      ( workArea )->( dbclosearea() )

   end if 

return ( fieldFromDatabase )

//--------------------------------------------------------------------------//
