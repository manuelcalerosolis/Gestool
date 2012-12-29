#include "Fivewin.ch"
#include "Struct.ch"
#include "Factu.Ch"

static hRas		:= 0
static lConnect:= .t.

static aoSay
static acSay

static oMtrOne
static oBtnOk

//-------------------------------------------------------------------------//

FUNCTION Internet( oWnd )

	local oDlg
   local oSay
   local oPro
   local oMtr
   local nMtr
   local oBtnCon
   local oBtnOk
   local cSay     := ""
   local cPro     := ""
   local cTitle   := "Conexión a internet como " + cCodEnvUsr()

   aoSay          := Array( 8 )
   acSay          := Array( 8 )

   /*
   Cerramos todas las ventanas MDI
   */

   if oWnd != nil
      SysRefresh(); oWnd:CloseAll(); SysRefresh()
   end if

	IF oWnd:oWndClient:getActive() != NIL
      msgStop( "Imposible realizar operación", "Existen procesos abiertos" )
		RETURN NIL
	END IF

   DEFINE DIALOG oDlg RESOURCE "INTERNET" TITLE cTitle

      REDEFINE SAY aoSay[ 1 ] PROMPT acSay[ 1 ];
         ID       10 ;
         OF       oDlg

      REDEFINE SAY aoSay[ 2 ] PROMPT acSay[ 2 ];
         ID       20 ;
         OF       oDlg

      REDEFINE SAY aoSay[ 3 ] PROMPT acSay[ 3 ];
         ID       30 ;
         OF       oDlg

      REDEFINE SAY aoSay[ 4 ] PROMPT acSay[ 4 ];
         ID       40 ;
         OF       oDlg

      REDEFINE SAY aoSay[ 5 ] PROMPT acSay[ 5 ];
         ID       50 ;
         OF       oDlg

      REDEFINE SAY aoSay[ 6 ] PROMPT acSay[ 6 ];
         ID       60 ;
         OF       oDlg

      REDEFINE SAY aoSay[ 7 ] PROMPT acSay[ 7 ];
         ID       70 ;
         OF       oDlg

      REDEFINE SAY aoSay[ 8 ] PROMPT acSay[ 8 ];
         ID       80 ;
         OF       oDlg

      REDEFINE SAY oSay PROMPT cSay ;
         ID       100 ;
         OF       oDlg

      REDEFINE SAY oPro PROMPT cPro ;
         ID       110 ;
         OF       oDlg

      REDEFINE METER oMtr ;
         VAR      nMtr ;
         ID       120 ;
         OF       oDlg

      REDEFINE BUTTON oBtnCon ;
         ID       552 ;
         OF       oDlg ;
         ACTION   (  oBtnCon:disable(), ;
                     oBtnOk:disable(), ;
                     PutFtp( oDlg, oSay, oPro, oMtr ), ;
                     oBtnCon:enable(), ;
                     oBtnOk:enable() )

      REDEFINE BUTTON oBtnOk ;
         ID       551 ;
         OF       oDlg ;
         ACTION   ( oDlg:end() )

   ACTIVATE DIALOG oDlg CENTER

RETURN NIL

//----------------------------------------------------------------------------//

/*
Recoge la documentaci¢n del buz¢n
*/

STATIC FUNCTION PutFtp( oDlg, oSay, oPro, oMtr )

   local oInt
   local oFTP
   local lServer  := ( "Servidor" $ cCodEnvUsr() )
   local ftpSit   := Rtrim( cSitFtp() )
   local nbrUsr   := Rtrim( cUsrFtp() )
   local accUsr   := Rtrim( cPswFtp() )
   local cEntry   := Rtrim( cNomConInt() )
   local cUser    := Rtrim( cUsrConInt() )
   local cPass    := Rtrim( cPswConInt() )

   /*
   Comprobamos el tipo de conexión a internet y marcamos
   */

   if nTipConInt() == 2

      if !Empty( cEntry )
         cEntry   := EditEntry( cEntry )
      end if

      hRas        := Ras_Dial( cEntry, cUser, cPass, .f. )

   end if

   /*
   Conexion con el sitio ftp
   */

   if nTipConInt() == 2

      aoSay[ 1 ]:SetText( "> Conectando con el sitio " + rtrim( ftpSit ) + "..." )

      oInt        := TInternet():New()
      oFTP        := TFTP():New( ftpSit, oInt, nbrUsr, accUsr )

      if oFtp == NIL
         msgStop( "Imposible crear la conexión" )
         return nil
      end if

      if empty( oFTP:hFTP )
         msgStop( "¡Imposible conectar con el sitio FTP!" )
         return nil
      else
         aoSay[ 1 ]:SetText( "Conectado con el sitio " + rtrim( ftpSit ) )
      endif

   end if

   /*
   Solo para el servidor-------------------------------------------------------
	*/

   IF lServer

      aoSay[ 2 ]:SetText( "> Procesando artículos" )
      SndArt( oDlg, oMtr, oFtp, oSay, oPro )
      GetArt( oDlg, oMtr, oFtp, oSay, oPro, .t. )
      aoSay[ 2 ]:SetText( "Artículos procesados" )

      aoSay[ 3 ]:SetText( "> Procesando clientes" )
      SndCli( oDlg, oMtr, oFtp, oSay, oPro, lServer )
      aoSay[ 3 ]:SetText( "Clientes porcesados" )

      aoSay[ 4 ]:SetText( "> Procesando pedidos de proveedores" )
      GetPedPrv( oDlg, oMtr, oFtp, oSay, oPro )
      aoSay[ 4 ]:SetText( "Pedidos de proveedores procesados" )

      aoSay[ 5 ]:SetText( "> Procesando albaranes de proveedores" )
      GetAlbPrv( oDlg, oMtr, oFtp, oSay, oPro )
      aoSay[ 5 ]:SetText( "Albaranes de proveedores procesados" )

      aoSay[ 6 ]:SetText( "> Procesando albaranes de clientes" )
      GetAlbCli( oDlg, oMtr, oFtp, oSay, oPro )
      aoSay[ 6 ]:SetText( "Albaranes de clientes procesados" )

      aoSay[ 7 ]:SetText( "> Enviando facturas de clientes" )
      GetFacCli( oDlg, oMtr, oFtp, oSay, oPro )
      aoSay[ 7 ]:SetText( "Facturas de clientes procesadas" )

      aoSay[ 8 ]:SetText( "> Procesando tikets de clientes" )
      GetTpvCli( oDlg, oMtr, oFtp, oSay, oPro )
      aoSay[ 8 ]:SetText( "Tickets de clientes procesados" )

      oSay:SetText( "Proceso finalizado" )

	/*
   Solo para el cliente-------------------------------------------------------
	*/

   ELSE

      aoSay[ 2 ]:SetText( "> Recibiendo artículos" )
      GetArt( oDlg, oMtr, oFtp, oSay, oPro )

      aoSay[ 2 ]:SetText( "> Enviando artículos" )
      SndArt( oDlg, oMtr, oFtp, oSay, oPro, .t. )
      aoSay[ 2 ]:SetText( "Artículos recibidos" )

      aoSay[ 3 ]:SetText( "> Recibiendo clientes" )
      GetCli( oDlg, oMtr, oFtp, oSay, oPro )
      aoSay[ 3 ]:SetText( "Clientes recibidos" )

      aoSay[ 4 ]:SetText( "> Enviando pedidos a proveedores" )
      SndPedPrv( oDlg, oMtr, oFtp, oSay, oPro )
      aoSay[ 4 ]:SetText( "Pedidos a proveedores enviados" )

      aoSay[ 5 ]:SetText( "> Enviando albaranes de proveedores" )
      GetAlbPrv( oDlg, oMtr, oFtp, oSay, oPro )
      aoSay[ 5 ]:SetText( "Albaranes de proveedores enviados" )

      aoSay[ 6 ]:SetText( "> Enviando albaranes a clientes" )
      SndAlbCli( oDlg, oMtr, oFtp, oSay, oPro )
      aoSay[ 6 ]:SetText( "Albaranes de clientes enviados" )

      aoSay[ 7 ]:SetText( "> Enviando tikets de clientes" )
      SndFacCli( oDlg, oMtr, oFtp, oSay, oPro )
      aoSay[ 7 ]:SetText( "Tickets de clientes enviados" )

      aoSay[ 8 ]:SetText( "> Enviando tikets de clientes" )
      SndTpvCli( oDlg, oMtr, oFtp, oSay, oPro )
      aoSay[ 8 ]:SetText( "Tickets de clientes enviados" )

      oSay:SetText( "Proceso finalizado" )

   END IF

   if oInt != nil
      oInt:end()
   end if

   if oFtp != nil
      oFtp:end()
   end if

   if hRas != 0
      Ras_Hangup( hRas )
   end if

   oDlg:end()

RETURN NIL

//----------------------------------------------------------------------------//

FUNCTION FtpSndFile( aSource, aTarget, nBufSize, oFTP, oDlg, oMeter, lDisco )

   local n
   local hSource
   local cBuffer
   local nBytes
   local oFile
   local nFile          := 0
   local nTotal         := 0
   local nTotSize       := 0

   DEFAULT aTarget      := aSource
   DEFAULT nBufSize     := 2000
   DEFAULT lDisco       := ( nTipConInt() == 1 )

   IF ValType( aSource ) != "A"
      aSource := { aSource }
   END IF

   IF ValType( aTarget ) != "A"
      aTarget := { aTarget }
   END IF

   cBuffer              := Space( nBufSize )

   for n = 1 to Len( aSource )

      if ! File( aSource[ n ] )
         msgStop( "File not found: " + aSource[ n ] )
         oDlg:end()
         exit
      endif

      hSource  := FOpen( aSource[ n ] )
      nTotSize += FSeek( hSource, 0, 2 )
      fclose( hSource )
      SysRefresh()

   next

   oMeter:nTotal = nTotSize

   for n = 1 to Len( aSource )

      hSource  := fOpen( aSource[ n ] )

      if lDisco
         oFile := TTxtFile():New( cRutConInt() + if( rat( "\", cRutConInt() ) != 0, "", "\" ) + aTarget[ n ] )
      else
         oFile := TFtpFile():New( aTarget[ n ], oFTP )
         oFile:OpenWrite()
      end if

      oMeter:Set( 0 )
      oMeter:nTotal := fSeek( hSource, 0, 2 )
      fseek( hSource, 0, 0 )
      nFile         := 0

      SysRefresh()

      while ( nBytes := fRead( hSource, @cBuffer, nBufSize ) ) > 0

         if lDisco
            oFile:PutStr( SubStr( cBuffer, 1, nBytes ) )
         else
            oFile:Write( SubStr( cBuffer, 1, nBytes ) )
         end if

         oMeter:Set( nFile += nBytes )
         sysRefresh()

      end

      fClose( hSource )
      oFile:end()

   next

   oMeter:Set(0)
   SysRefresh()

return nil

//----------------------------------------------------------------------------//

FUNCTION SendFile( cSource, cTarget, nBufSize, oFTP, oDlg, oMtr )

RETURN FtpSndFile( cSource, cTarget, nBufSize, oFTP, oDlg, oMtr )

//----------------------------------------------------------------------------//

function FtpGetFiles( aSource, cTarget, nBufSize, oFTP, oDlg, oMeter, lDisco )

   local n
   local i
   local hTarget
   local cBuffer
   local nBytes
   local oFile
   local aFiles
   local nFile          := 0
   local nTotal         := 0
   local nTotSize       := 0
   local aSizes         := {}

   DEFAULT nBufSize     := 2000
   DEFAULT lDisco       := ( nTipConInt() == 1 )

   if ValType( aSource ) != "A"
      aSource           := { aSource }
   end if

   cBuffer              := Space( nBufSize )

   /*
   Obtenemos el tamaño del fichero a bajas
   */

   for n = 1 to Len( aSource )

      if lDisco
         aFiles := Directory( cRutConInt() + if( rat( "\", cRutConInt() ) != 0, "", "\" )  + aSource[ n ] )
      else
         aFiles := oFTP:Directory( aSource[ n ] )
      end if

      for i = 1 to Len( aFiles )

         if Len( aFiles ) > 0
            aadd( aSizes, aFiles[ i , 2 ] ) // first file, size
            nTotSize += aTail( aSizes )
         else
            aadd( aSizes, 0 )
         endif

      next

      SysRefresh()

   next

   oMeter:nTotal  := nTotSize

   /*
   Comenzemos a bajar el fichero-----------------------------------------------
   */

   for n = 1 to Len( aSource )

      if lDisco
         aFiles := Directory( cRutConInt() + if( rat( "\", cRutConInt() ) != 0, "", "\" ) + aSource[ n ] )
      else
         aFiles := oFTP:Directory( aSource[ n ] )
      end if

      for i = 1 to Len( aFiles )

         hTarget  := LCreat( cTarget + aFiles[ i, 1 ] )

         if lDisco
            oFile := TTxtFile():New( cRutConInt() + if( rat( "\", cRutConInt() ) != 0, "", "\" ) + aFiles[ i, 1 ] )
         else
            oFile := TFtpFile():New( aFiles[ i, 1 ], oFTP )
            oFile:OpenRead()
         end if

         oMeter:Set( 0 )
         oMeter:nTotal  := aFiles[ i, 2 ]
         nFile          := 0
         SysRefresh()

         while ( nBytes := Len( cBuffer := if( lDisco, oFile:cGetStr( nBufSize ), oFile:Read( nBufSize ) ) ) ) > 0

            fWrite( hTarget, cBuffer, nBytes )
            oMeter:Set( nFile += nBytes )
            SysRefresh()

         end

         fClose( hTarget )
         oFile:end()

      next

   next

   oMeter:Set( 0 )
   SysRefresh()

return nil

//----------------------------------------------------------------------------//

*-- FUNCTION -----------------------------------------------------------------
*         Name: SFN2LPN               Docs: Jim Gale
*  Description: Short File Name to Long Path Name (works with long too)
*                  Returns a complete, LONG pathname and LONG filename.
*       Author: Jim Gale
* Date created: 7/10/97               Date updated: þ7/10/97
* Time created: 2:01:25AM             Time updated: þ2:01:25AM
*-----------------------------------------------------------------------------
*    Arguments: cSpec                 - file specification, long or short
* Return Value: cFullPathFile         - returns long path and file names
*     See Also:
*-----------------------------------------------------------------------------

Function SFN2LPN(cSpec)
Local cLongName:=Space(261), nNamePos:=0
   GetFullPathName( SFN2LFN(cSpec), Len( cLongName ), @cLongName, @nNamePos )
Return alltrim(cLongName)


*-- FUNCTION -----------------------------------------------------------------
*         Name: SFN2LFN               Docs: Jim Gale
*  Description: Short File Name to Long File Name (works with long too)
*                  Guarantee a long file name (path not expanded)
*       Author: Jim Gale
* Date created: 7/10/97               Date updated: þ7/10/97
* Time created: 2:03:13AM             Time updated: þ2:03:13AM
*-----------------------------------------------------------------------------
*    Arguments: cSpec                 - file specification, long or short
* Return Value: cLongName             - long file name
*     See Also:
*-----------------------------------------------------------------------------
Function SFN2LFN(cSpec)
Local oWin32, c, h

   STRUCT oWin32
      MEMBER nFileAttributes  AS DWORD
      MEMBER nCreation        AS STRING LEN 8
      MEMBER nLastRead        AS STRING LEN 8
      MEMBER nLastWrite       AS STRING LEN 8
      MEMBER nSizeHight       AS DWORD
      MEMBER nSizeLow         AS DWORD
      MEMBER nReserved0       AS DWORD
      MEMBER nReserved1       AS DWORD
      MEMBER cFileName        AS STRING LEN 260
      MEMBER cAltName         AS STRING LEN  14
   ENDSTRUCT

   c := oWin32:cBuffer
   h := apiFindFst(cSpec,@c)
   oWin32:cBuffer := c

   apiFindCls(h)

Return psz(oWin32:cFileName)

*-- FUNCTION -----------------------------------------------------------------
*         Name: LFN2SFN               Docs: Jim Gale
*  Description: Long File Name to Short File Name (works with short too)
*                  Guarantee a short file name (path not expanded)
*       Author: Jim Gale
* Date created: 7/10/97               Date updated: þ7/10/97
* Time created: 2:04:10AM             Time updated: þ2:04:10AM
*-----------------------------------------------------------------------------
*    Arguments: cSpec                 - file specification, long or short
* Return Value: cLongName             - short file name
*     See Also:
*-----------------------------------------------------------------------------
Function LFN2SFN(cSpec)
Local oWin32, c, h

   STRUCT oWin32
      MEMBER nFileAttributes  AS DWORD
      MEMBER nCreation        AS STRING LEN 8
      MEMBER nLastRead        AS STRING LEN 8
      MEMBER nLastWrite       AS STRING LEN 8
      MEMBER nSizeHight       AS DWORD
      MEMBER nSizeLow         AS DWORD
      MEMBER nReserved0       AS DWORD
      MEMBER nReserved1       AS DWORD
      MEMBER cFileName        AS STRING LEN 260
      MEMBER cAltName         AS STRING LEN  14
   ENDSTRUCT

   c := oWin32:cBuffer
   h := apiFindFst(cSpec,@c)
   oWin32:cBuffer := c

   apiFindCls(h)

Return if(empty(psz(oWin32:cAltName)),psz(oWin32:cFileName),psz(oWin32:cAltName))

/*
*-- FUNCTION -----------------------------------------------------------------
*         Name: LDirectory            Docs: Jim Gale
*  Description: Returns a directory with {shortname,size,date,time,attr,longname}
*                  element structure
*       Author: Jim Gale
* Date created: 7/10/97               Date updated: þ7/10/97
* Time created: 2:05:10AM             Time updated: þ2:05:10AM
*-----------------------------------------------------------------------------
*    Arguments: cSpec                 - file specification, long or short
*             : cAttr                 - file attributes
*             : bWhile                - while block
* Return Value: aDirectory            - directory listing
*        NOTES: INCOMPLETE
*-----------------------------------------------------------------------------
*/

Function LDirectory(cSpec,cAttr,bWhile)

Local a:={}, oWin32, c, n, adt, h, cLast := "//", nn:=0, cSF

   STRUCT oWin32
      MEMBER nFileAttributes  AS DWORD
      MEMBER nCreation        AS STRING LEN 8
      MEMBER nLastRead        AS STRING LEN 8
      MEMBER nLastWrite       AS STRING LEN 8
      MEMBER nSizeHight       AS DWORD
      MEMBER nSizeLow         AS DWORD
      MEMBER nReserved0       AS DWORD
      MEMBER nReserved1       AS DWORD
      MEMBER cFileName        AS STRING LEN 260
      MEMBER cAltName         AS STRING LEN  14
   ENDSTRUCT

   c := oWin32:cBuffer
   h := apiFindFst(cSpec,@c)
   oWin32:cBuffer := c

   cLast := oWin32:cFileName

   while !empty(psz(oWin32:cFileName))
      if ++nn>4000
         exit
      endif
      sysrefresh()
      adt := FTtoDT(oWin32:nCreation)
      cSF := psz(oWin32:cAltName)
      if empty(cSF)
         cSF := psz(oWin32:cFileName)
      endif
      AAdd(a,{cSF,oWin32:nSizeHight*65536+oWin32:nSizeLow,adt[1],adt[2],"",psz(oWin32:cFileName)})
      c := oWin32:cBuffer
      apiFindNxt(h,@c)
      oWin32:cBuffer := c

      if oWin32:cFileName == cLast
         exit
      endif
      cLast := oWin32:cFileName

   enddo
   apiFindCls(h)

Return a
*/

*-- FUNCTION -----------------------------------------------------------------
*         Name: psz                   Docs: Jim Gale
*  Description: Truncate a zero-terminated string to a proper size
*       Author: Jim Gale
* Date created: 7/10/97               Date updated: þ7/10/97
* Time created: 2:07:22AM             Time updated: þ2:07:22AM
*-----------------------------------------------------------------------------
*    Arguments: cZString              - string containing zeroes
* Return Value: cString               - string without zeroes
*     See Also:
*-----------------------------------------------------------------------------
Function psz(c)
Return substr(c,1,at(chr(0),c)-1)


*-- FUNCTION -----------------------------------------------------------------
*         Name: FTtoDT                Docs: Jim Gale
*  Description: FileTime to DosDateTime
*       Author: Jim Gale
* Date created: 7/10/97               Date updated: þ7/10/97
* Time created: 2:08:25AM             Time updated: þ2:08:25AM
*-----------------------------------------------------------------------------
*    Arguments: cFT                   - filetime bytes (2)
* Return Value: {d,t}                 - array {date,time}
*        NOTES: has minor inconsistencies, incomplete
*-----------------------------------------------------------------------------
Function FTtoDT(cFT)
Local d, t, c, ld, lt, cLT, nDay, nMon, nYr, nSec, nMin, nHr

   cLT := Space(8)
   apiFT2LT(@cFT,@cLT)

   ld := Space(2)
   lt := Space(2)
   apiFT2DT(@cLT,@ld,@lt)

   nDay := nAND(asc(substr(lD,1,1)),31)
   nMon := nOR(nAND(asc(substr(lD,1,1)),224)/32,nAND(asc(substr(lD,2,1)),1)*8)
   nYr  := nAND(asc(substr(lD,2,1)),127)/2+1980

   d    := CtoD(strzero(nMon,2)+"/"+strzero(nDay,2)+"/"+strzero(nYr,4))

   nSec := nAND(asc(substr(lt,1,1)),31)
   nMin := nOR(nAND(asc(substr(lt,1,1)),224)/32,nAND(asc(substr(lt,2,1)),7)*8)
   nHr  := nAND(asc(substr(lt,2,1)),248)/8

   t    := strzero(nHr,2)+":"+strzero(nMin,2)+":"+strzero(nSec,2)

return {d,t}


DLL32 Function GetFullPathName( lpszFile AS LPSTR, cchPath AS DWORD,;
               lpszPath AS LPSTR, @nFilePos AS PTR ) AS DWORD ;
               PASCAL FROM "GetFullPathNameA" LIB "kernel32.dll"

DLL32 Function apiFindFst(lpFilename AS LPSTR, @cWin32DataInfo AS LPSTR) AS LONG PASCAL FROM "FindFirstFileA" LIB "KERNEL32.DLL"
DLL32 Function apiFindNxt(nHandle AS LONG, @cWin32DataInfo AS LPSTR) AS BOOL PASCAL FROM "FindNextFileA" LIB "KERNEL32.DLL"
DLL32 Function apiFindCls(nHandle AS LONG) AS BOOL PASCAL FROM "FindClose" LIB "KERNEL32.DLL"
DLL32 Function apiFT2DT(@lpFT AS LPSTR, @lpDATE AS LPSTR, @lpTIME AS LPSTR) AS BOOL PASCAL FROM "FileTimeToDosDateTime" LIB "KERNEL32.DLL"
DLL32 Function apiFT2LT(@lpFT AS LPSTR, @lpLT AS LPSTR) AS BOOL PASCAL FROM "FileTimeToLocalFileTime" LIB "KERNEL32.DLL"