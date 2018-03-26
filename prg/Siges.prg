#include "FiveWin.Ch"
#include "Struct.ch"
#include "Factu.ch" 
#include "Ini.ch"
#include "MesDbf.ch"

//----------------------------------------------------------------------------//

CLASS TSiges

   DATA  nLevel

   DATA  cIniFile                   INIT  cIniEmpresa()

   DATA  oGetPathFile
   DATA  cPathFile                  INIT  Space( 254 )

   DATA  cFilTxt
   DATA  oFilTxt
   DATA  hFilTxt

   DATA  oBtnOk
   DATA  oBtnCancel

   DATA  oFile

   DATA  oTree
   DATA  oTreeFile

   DATA  oDlg

   DATA  oAlbCliT
   DATA  oAlbCliL
   DATA  oAlbPrvT
   DATA  oAlbPrvL
   DATA  oTikCliT
   DATA  oTikCliL
   DATA  oDbfFam
   DATA  oDbfClient
   DATA  oDbfDiv
   DATA  oDbfArt
   DATA  oDbfIva
   DATA  oDbfPrv
   DATA  oDbfPrvArt

   DATA  cNumOldDocumento           INIT Space(1)
   DATA  cNumOldGst                 INIT Space(1)

   METHOD New()
   METHOD Activate()

   METHOD Create( oMenuItem, oWnd ) INLINE ( if( ::New( oMenuItem, oWnd ) != nil, ::Activate(), ) )

   METHOD OpenFiles()
   METHOD CloseFiles()

   METHOD LoadFromIni()
   METHOD SaveToIni()

   METHOD Import()
   METHOD ImportFile()
   METHOD ProccesLine( cLine )

END CLASS

//----------------------------------------------------------------------------//

METHOD New( oMenuItem, oWnd )

   DEFAULT oMenuItem    := "01073"

   ::nLevel             := Auth():Level( oMenuItem )

   if nAnd( ::nLevel, 1 ) != 0
      msgStop( "Acceso no permitido." )
      Return ( nil )
   end if

   if oWnd != nil
      SysRefresh(); oWnd:CloseAll(); SysRefresh()
   end if

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD LoadFromIni()

   ::cPathFile             := GetPvProfString( "SIGES", "Ruta", cValToChar( ::cPathFile ), ::cIniFile )
   ::cPathFile             := Padr( ::cPathFile, 254 )

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD SaveToIni()

   WritePProString( "SIGES", "Ruta", cValToChar( ::cPathFile ), ::cIniFile )

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD OpenFiles()

   local lOpen    := .t.
   local oBlock   := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

   ::oAlbCliT := TDataCenter():oAlbCliT()

   DATABASE NEW ::oAlbCliL    FILE "ALBCLIL.DBF"   PATH ( cPatEmp() )  VIA ( cDriver() ) SHARED INDEX  "ALBCLIL.CDX"

   DATABASE NEW ::oAlbPrvT    FILE "ALBPROVT.DBF"  PATH ( cPatEmp() )  VIA ( cDriver() ) SHARED INDEX  "ALBPROVT.CDX"

   DATABASE NEW ::oAlbPrvL    FILE "ALBPROVL.DBF"  PATH ( cPatEmp() )  VIA ( cDriver() ) SHARED INDEX  "ALBPROVL.CDX"

   DATABASE NEW ::oDbfDiv     FILE "DIVISAS.DBF"   PATH ( cPatDat() )  VIA ( cDriver() ) SHARED INDEX  "DIVISAS.CDX"

   DATABASE NEW ::oDbfClient  FILE "CLIENT.DBF"    PATH ( cPatCli() )  VIA ( cDriver() ) SHARED INDEX  "CLIENT.CDX"

   DATABASE NEW ::oDbfArt     FILE "ARTICULO.DBF"  PATH ( cPatArt() )  VIA ( cDriver() ) SHARED INDEX  "ARTICULO.CDX"

   DATABASE NEW ::oDbfIva     FILE "TIVA.DBF"      PATH ( cPatDat() )  VIA ( cDriver() ) SHARED INDEX  "TIVA.CDX"

   DATABASE NEW ::oDbfPrv     FILE "PROVEE.DBF"    PATH ( cPatPrv() )  VIA ( cDriver() ) SHARED INDEX  "PROVEE.CDX"

   DATABASE NEW ::oDbfPrvArt  FILE "PROVART.DBF"   PATH ( cPatArt() )  VIA ( cDriver() ) SHARED INDEX  "PROVART.CDX"

   DATABASE NEW ::oTikCliT    FILE "TIKET.DBF"     PATH ( cPatEmp() )  VIA ( cDriver() ) SHARED INDEX  "TIKET.CDX"

   DATABASE NEW ::oTikCliL    FILE "TIKEL.DBF"     PATH ( cPatEmp() )  VIA ( cDriver() ) SHARED INDEX  "TIKEL.CDX"

   DATABASE NEW ::oDbfFam     FILE "FAMILIAS.DBF"  PATH ( cPatArt() )  VIA ( cDriver() ) SHARED INDEX  "FAMILIAS.CDX"

   RECOVER

      msgStop( "Imposible abrir todas las bases de datos" )
      ::CloseFiles()
      lOpen       := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//----------------------------------------------------------------------------//

METHOD CloseFiles()

   if !Empty ( ::oAlbCliT )
      ::oAlbCliT:End()
   end if

   if !Empty ( ::oAlbCliL )
      ::oAlbCliL:End()
   end if

   if !Empty ( ::oAlbPrvT )
      ::oAlbPrvT:End()
   end if

   if !Empty ( ::oAlbPrvL )
      ::oAlbPrvL:End()
   end if

   if !Empty ( ::oDbfDiv )
      ::oDbfDiv:End()
   end if

   if !Empty ( ::oDbfClient )
      ::oDbfClient:End()
   end if

   if !Empty ( ::oDbfArt )
      ::oDbfArt:End()
   end if

   if !Empty ( ::oDbfIva )
      ::oDbfIva:End()
   end if

   if !Empty ( ::oDbfPrv )
      ::oDbfPrv:End()
   end if

   if !Empty ( ::oDbfPrvArt )
      ::oDbfPrvArt:End()
   end if

   if !Empty ( ::oTikCliT )
      ::oTikCliT:End()
   end if

   if !Empty ( ::oTikCliL )
      ::oTikCliL:End()
   end if

   if !Empty ( ::oDbfFam )
      ::oDbfFam:End()
   end if

   ::oAlbCliT     := nil
   ::oAlbCliL     := nil
   ::oAlbPrvT     := nil
   ::oAlbPrvL     := nil
   ::oDbfDiv      := nil
   ::oDbfClient   := nil
   ::oDbfArt      := nil
   ::oDbfIva      := nil
   ::oDbfPrv      := nil
   ::oDbfPrvArt   := nil
   ::oTikCliT     := nil
   ::oTikCliL     := nil
   ::oDbfFam      := nil


RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD Activate( oWnd )

   if ! ::OpenFiles()
      Return ( Self )
   end if

   ::LoadFromIni()

   /*
   Apertura del fichero de texto ----------------------------------------------
   */

   DEFINE DIALOG ::oDlg RESOURCE "SIGES"

      REDEFINE GET ::oGetPathFile ;
         VAR      ::cPathFile ;
         ID       110 ;
         BITMAP   "Folder" ;
         OF       ::oDlg

      ::oGetPathFile:bHelp := {|| ::oGetPathFile:cText( cGetDir( 'Seleccione la ruta' ) ) }

      /*
      Tercera caja de dialogo--------------------------------------------------
      */

      ::oTree     := TTreeView():Redefine( 100, ::oDlg )

      /*
      Botones------------------------------------------------------------------
      */

      REDEFINE BUTTON ::oBtnOk ;
         ID       IDOK ;
         OF       ::oDlg ;
         ACTION   ( ::Import() )

      REDEFINE BUTTON ::oBtnCancel ;
         ID       IDCANCEL ;
         OF       ::oDlg ;
         ACTION   ( ::oDlg:end() )

   ACTIVATE DIALOG ::oDlg CENTER

   /*
   Grabamos el fichero---------------------------------------------------------
   */

   ::SaveToIni()

   ::CloseFiles()

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD Import()

   local n
   local aFiles

   ::cPathFile    := cPath( ::cPathFile )

   ::oDlg:Disable()

   aFiles         := Directory( ::cPathFile + "*.*" )

   for n := 1 to len( aFiles )

      ::ImportFile( ::cPathFile + aFiles[ n, 1 ] )

   next

   ::oDlg:Enable()

   MsgInfo( "Proceso finalizado" )

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD ImportFile( cFile )

   ::oTreeFile    := ::oTree:Add( "Importando fichero " + cFile )
   ::oTree:Select( ::oTreeFile )

   ::oFile        := TTxtFile():New( cFile, 0 )

   if ::oFile:hFile == -1
      ::oTreeFile:Add( "Imposible abrir fichero " + cFile + ", error : " + Str( fError() ) )
   else

      while !( ::oFile:lEoF() )

         ::ProccesLine( ::oFile:ReadLine() )

         ::oFile:Skip()

      end while

      ::oFile:End()

   end if

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD ProccesLine( cLine )

   local cNumeroDocumento
   local cNum
   local nRec
   local nOrdAnt

   do case

      case SubStr( cLine, 1, 4 ) == "1004"

         //Albaranes de clientes

         cNumeroDocumento  := "A" + Str( Val( SubStr( cLine, 29, 10 ) ), 9 ) + RetSufEmp()

         if !::oAlbCliT:Seek( cNumeroDocumento )

            //Si el documento no existe se crea directamente la cabecera

            ::oAlbCliT:Append()

            ::oAlbCliT:cSerAlb      := "A"
            ::oAlbCliT:nNumAlb      := Val( SubStr( cLine, 29, 10 ) )
            ::oAlbCliT:cSufAlb      := RetSufEmp()
            ::oAlbCliT:cCodCli      := Rjust( SubStr( cLine, 89, 6 ), "0", RetNumCodCliEmp() )
            ::oAlbCliT:cCodObr      := SubStr( cLine, 118, 10 )
            ::oAlbCliT:dFecAlb      := Ctod( SubStr( cLine, 157, 2 ) + "-" + SubStr( cLine, 155, 2 ) + "-" + SubStr( cLine, 151, 4 ) )
            ::oAlbCliT:dFecCre      := Ctod( SubStr( cLine, 157, 2 ) + "-" + SubStr( cLine, 155, 2 ) + "-" + SubStr( cLine, 151, 4 ) )
            ::oAlbCliT:cTimCre      := SubStr( cLine, 159, 2 ) + ":" + SubStr( cLine, 161, 2 )
            ::oAlbCliT:cTurAlb      := cCurSesion()
            ::oAlbCliT:cCodAlm      := oUser():cAlmacen()
            ::oAlbCliT:cDivAlb      := cDivEmp()
            ::oAlbCliT:cCodPago     := cDefFpg()
            ::oAlbCliT:cCodCaj      := oUser():cCaja()
            ::oAlbCliT:cCodUsr      := Auth():Codigo()
            ::oAlbCliT:nVdvAlb      := nChgDiv( cDivEmp(), ::oDbfDiv )
            ::oAlbCliT:lFacturado   := .f.
            ::oAlbCliT:lSndDoc      := .t.
            ::oAlbCliT:dFecEnv      := Ctod( "" )
            ::oAlbCliT:dFecImp      := Ctod( "" )
            ::oAlbCliT:cCodDlg      := Application():CodigoDelegacion()
            ::oAlbCliT:lIvaInc      := .t.

            if SubStr( cLine, 58, 1 )  == "J"
               ::oAlbCliT:nDtoEsp      :=  Val( SubStr( cLine, 59, 2 ) + "." + SubStr( cLine, 61, 2 ) )
            end if

            ::oDbfClient:GoTop()

            if ::oDbfClient:Seek( Rjust( SubStr( cLine, 89, 6 ), "0", RetNumCodCliEmp() ) )

               ::oAlbCliT:cNomCli   := ::oDbfClient:Titulo
               ::oAlbCliT:cDirCli   := ::oDbfClient:Domicilio
               ::oAlbCliT:cPobCli   := ::oDbfClient:Poblacion
               ::oAlbCliT:cPrvCli   := ::oDbfClient:Provincia
               ::oAlbCliT:cPosCli   := ::oDbfClient:CodPostal
               ::oAlbCliT:cDniCli   := ::oDbfClient:Nif

            else

               ::oAlbCliT:cNomCli   := Space( 80 )
               ::oAlbCliT:cDirCli   := Space( 100 )
               ::oAlbCliT:cPobCli   := Space( 35 )
               ::oAlbCliT:cPrvCli   := Space( 20 )
               ::oAlbCliT:cPosCli   := Space( 5 )
               ::oAlbCliT:cDniCli   := Space( 15 )

            end if

            ::oAlbCliT:Save()

            ::oTreeFile:Add( "Procesando albarán de cliente : A" + "/" + AllTrim( Str( Val( SubStr( cLine, 29, 10 ) ), 9 ) ) + "/" + RetSufEmp() )

         else

            /*Comprobamos que sea la primera linea lara borrarlas
            todas e insertarlas de nuevo, para que no se encuentren lineas repetidas*/

            if cNumeroDocumento != ::cNumOldDocumento

               while ::oAlbCliL:Seek( cNumeroDocumento )
                  ::oAlbCliL:Delete( .f. )
               end if

            end if

         end if

         //Añadimos la línea

         ::oAlbCliL:Append()

         ::oAlbCliL:cSerAlb      := "A"
         ::oAlbCliL:nNumAlb      := Val( SubStr( cLine, 29, 10 ) )
         ::oAlbCliL:cSufAlb      := RetSufEmp()
         ::oAlbCliL:cRef         := Padr( SubStr( cLine, 6, 8 ), 18 )

         if ::oDbfArt:Seek( Padr( SubStr( cLine, 6, 8 ), 18 ) )
            ::oAlbCliL:cDetalle  := ::oDbfArt:Nombre
            ::oAlbCliL:cUniDad   := ::oDbfArt:cUnidad
            ::oAlbCliL:nPesoKg   := ::oDbfArt:nPesoKg
            ::oAlbCliL:nCosDiv   := ::oDbfArt:pCosto
            ::oAlbCliL:nPvpRec   := ::oDbfArt:PvpRec
         else
            ::oAlbCliL:cDetalle  := Space(250)
            ::oAlbCliL:cUniDad   := Space(2)
            ::oAlbCliL:nPesoKg   := 0
            ::oAlbCliL:nCosDiv   := 0
            ::oAlbCliL:nPvpRec   := 0
         end if

         ::oAlbCliL:nPreUnit     := Val( SubStr( cLine, 39, 6 ) + "." + SubStr( cLine, 45, 3 ) )
         ::oAlbCliL:nCanEnt      := 1
         ::oAlbCliL:nUniCaja     := Val( SubStr( cLine, 48, 6 ) + "." + SubStr( cLine, 56, 3 ) )
         ::oAlbCliL:lControl     := .f.
         ::oAlbCliL:lTotLin      := .f.
         ::oAlbCliL:dFecha       := Ctod( SubStr( cLine, 157, 2 ) + "-" + SubStr( cLine, 155, 2 ) + "-" + SubStr( cLine, 151, 4 ) )
         ::oAlbCliL:cAlmLin      := oUser():cAlmacen()
         ::oAlbCliL:lIvaLin      := .t.
         ::oAlbCliL:nIva         := nIvaCodTer( SubStr( cLine, 57, 1 ), ::oDbfIva:cAlias )

         do case
            case SubStr( cLine, 58, 1 )  == "P"
               ::oAlbCliL:nDtoDiv   :=  Val( SubStr( cLine, 59, 1 ) + "." + SubStr( cLine, 60, 3 ) )
            case SubStr( cLine, 58, 1 )  == "J"
               ::oAlbCliL:nDto      :=  Val( SubStr( cLine, 59, 2 ) + "." + SubStr( cLine, 61, 2 ) )
         end case

         ::oAlbCliL:Save()

         //Escribomos en el tree, para informar

         ::oTreeFile:Add( Space(5) + "Artículo: " + AllTrim( Padr( SubStr( cLine, 6, 8 ), 18 ) ) + " ; " + AllTrim( Str( Val( SubStr( cLine, 48, 6 ) + "." + SubStr( cLine, 56, 3 ) ) ) ) + " ; " + AllTrim( Str( Val( SubStr( cLine, 39, 6 ) + "." + SubStr( cLine, 45, 3 ) ) ) ) )

         //Pasamos el valor del documento a la variable para la proxima línea

         ::cNumOldDocumento      := cNumeroDocumento

      case SubStr( cLine, 1, 4 ) == "1009"

         //Albaranes de proveedor

         nRec              := ::oAlbPrvT:Recno()
         nOrdAnt           := ::oAlbPrvT:OrdSetFocus( "CSUALB" )

         if !::oAlbPrvT:Seek( SubStr( cLine, 5, 10 ) )

            //Añadimos la Cabecera

            ::oAlbPrvT:Append()

            cNum                  := nNewDoc( "A", ::oAlbPrvT:cAlias, "NALBPRV" )
            cNumeroDocumento      := "A" + Str( cNum ) + RetSufEmp()

            ::oAlbPrvT:cSerAlb    := "A"
            ::oAlbPrvT:nNumAlb    := cNum
            ::oAlbPrvT:cSufAlb    := RetSufEmp()
            ::oAlbPrvT:cTurAlb    := cCurSesion()
            ::oAlbPrvT:cCodAlm    := oUser():cAlmacen()
            ::oAlbPrvT:cCodCaj    := oUser():cCaja()
            ::oAlbPrvT:cDivAlb    := cDivEmp()
            ::oAlbPrvT:nVdvAlb    := nChgDiv( cDivEmp(), ::oDbfDiv )
            ::oAlbPrvT:lSndDoc    := .t.
            ::oAlbPrvT:cCodUsr    := Auth():Codigo()
            ::oAlbPrvT:cCodDlg    := Application():CodigoDelegacion()
            ::oAlbPrvT:cCodPgo    := cDefFpg()
            ::oAlbPrvT:lFacturado := .f.
            ::oAlbPrvT:dFecAlb    := Ctod( SubStr( cLine, 76, 2 ) + "-" + SubStr( cLine, 74, 2 ) + "-" + SubStr( cLine, 70, 4 ) )
            ::oAlbPrvT:cSuAlb     := SubStr( cLine, 5, 10 )
            ::oAlbPrvT:dSuAlb     := Ctod( SubStr( cLine, 76, 2 ) + "-" + SubStr( cLine, 74, 2 ) + "-" + SubStr( cLine, 70, 4 ) )
            ::oAlbPrvT:dFecChg    := Ctod( SubStr( cLine, 76, 2 ) + "-" + SubStr( cLine, 74, 2 ) + "-" + SubStr( cLine, 70, 4 ) )
            ::oAlbPrvT:cTimChg    := SubStr( cLine, 78, 2 ) + ":" + SubStr( cLine, 80, 2 )
            ::oAlbPrvT:nDtoEsp    := Val( SubStr( cLine, 82, 2 ) + "." + SubStr( cLine, 84, 2 ) )
            ::oAlbPrvT:cCodPrv    := Rjust( SubStr( cLine, 16, 6 ), "0", RetNumCodPrvEmp() )
            ::oAlbPrvT:cNumPed    := SubStr( cLine, 22, 10 )

            if ::oDbfPrv:Seek( Rjust( SubStr( cLine, 16, 6 ), "0", RetNumCodPrvEmp() ) )

               ::oAlbPrvT:cNomPrv := ::oDbfPrv:Titulo
               ::oAlbPrvT:cDirPrv := ::oDbfPrv:Domicilio
               ::oAlbPrvT:cPobPrv := ::oDbfPrv:Poblacion
               ::oAlbPrvT:cProPrv := ::oDbfPrv:Provincia
               ::oAlbPrvT:cPosPrv := ::oDbfPrv:CodPostal
               ::oAlbPrvT:cDniPrv := ::oDbfPrv:Nif

            else

               ::oAlbPrvT:cNomPrv := Space(35)
               ::oAlbPrvT:cDirPrv := Space(35)
               ::oAlbPrvT:cPobPrv := Space(25)
               ::oAlbPrvT:cProPrv := Space(20)
               ::oAlbPrvT:cPosPrv := Space(5)
               ::oAlbPrvT:cDniPrv := Space(15)

            end if

            ::oAlbPrvT:Save()

            ::oTreeFile:Add( "Procesando albarán de proveedor : A" + "/" + AllTrim( Str( cNum, 9 ) ) + "/" + RetSufEmp() )

         else

            cNumeroDocumento  := ::oAlbPrvT:cSerAlb + Str( ::oAlbPrvT:nNumAlb ) + ::oAlbPrvT:cSufAlb

            if cNumeroDocumento != ::cNumOldDocumento

               while ::oAlbPrvL:Seek( cNumeroDocumento )
                  ::oAlbPrvL:Delete( .f. )
               end if

            end if

         end if

         //Añadimos las lineas

         ::oAlbPrvL:Append()

         ::oAlbPrvL:cSerAlb      := "A"
         ::oAlbPrvL:nNumAlb      := Val( SubStr( cNumeroDocumento, 2, 9 ) )
         ::oAlbPrvL:cSufAlb      := RetSufEmp()
         ::oAlbPrvL:cRef         := Padr( SubStr( cLine, 32, 8 ), 18 )
         ::oAlbPrvL:nUniCaja     := Val( SubStr( cLine, 88, 6 ) + "." + SubStr( cLine, 94, 3 ) )
         ::oAlbPrvL:nCanEnt      := 1
         ::oAlbPrvL:nCanPed      := 1
         ::oAlbPrvL:lIvaLin      := .t.
         ::oAlbPrvL:cAlmLin      := oUser():cAlmacen()
         ::oAlbPrvL:lControl     := .f.
         ::oAlbPrvL:cNumPed      := SubStr( cLine, 22, 10 )
         ::oAlbPrvL:nPreDiv      := Val( SubStr( cLine, 61, 6 ) + "." + SubStr( cLine, 67, 3 ) )
         ::oAlbPrvL:nDtoLin      := Val( SubStr( cLine, 82, 2 ) + "." + SubStr( cLine, 84, 2 ) )
         ::oAlbPrvL:nIva         := nIva( ::oDbfIva, cDefIva() )

         if ::oDbfArt:Seek( Padr( SubStr( cLine, 32, 8 ), 18 ) )
            ::oAlbPrvL:cDetalle  := ::oDbfArt:Nombre
            ::oAlbPrvL:cUniDad   := ::oDbfArt:cUnidad
         else
            ::oAlbPrvL:cDetalle  := Space(250)
            ::oAlbPrvL:cUniDad   := Space(2)
         end if

         ::oAlbPrvL:Save()

      ::oTreeFile:Add( Space(5) + "Artículo: " + AllTrim( Padr( SubStr( cLine, 32, 8 ), 18 ) ) + " ; " + AllTrim( Str( Val( SubStr( cLine, 88, 6 ) + "." + SubStr( cLine, 94, 3 ) ) ) ) + " ; " + AllTrim( Str( Val( SubStr( cLine, 61, 6 ) + "." + SubStr( cLine, 67, 3 ) ) ) ) )

      ::oAlbPrvT:OrdSetFocus( nOrdAnt )
      ::oAlbPrvT:GoTo( nRec )

      ::cNumOldDocumento      := cNumeroDocumento

      case SubStr( cLine, 1, 4 ) == "1017"

         //Artículos

         ::oDbfArt:GoTop()

         if !::oDbfArt:Seek( Padr( SubStr( cLine, 22, 8 ), 18 ) )

            ::oTreeFile:Add( "Añadiendo el artículo: " + Padr( SubStr( cLine, 22, 8 ), 18 ) )

            //Añadimos el artículo

            ::oDbfArt:Append()

            ::oDbfArt:Codigo        := Padr( SubStr( cLine, 22, 8 ), 18 )
            ::oDbfArt:Nombre        := Padr( SubStr( cLine, 30, 30 ), 100 )
            ::oDbfArt:cDesTik       := SubStr( cLine, 60, 20 )
            ::oDbfArt:CodeBar       := Padr( SubStr( cLine, 7, 15 ), 20 )
            ::oDbfArt:TipoIva       := cCodTerToCodIva( SubStr( cLine, 97, 1 ), ::oDbfIva:cAlias )
            ::oDbfArt:lIvaInc       := .f.
            ::oDbfArt:cPrvHab       := Rjust( SubStr( cLine, 107, 6 ), "0", RetNumCodPrvEmp() )
            ::oDbfArt:pCosto        := 0
            ::oDbfArt:PvpRec        := 0
            ::oDbfArt:pVenta1       := Val( SubStr( cLine, 131, 6 ) + "." + SubStr( cLine, 137, 3 ) )
            ::oDbfArt:pVtaIva1      := ( ( Val( SubStr( cLine, 131, 6 ) + "." + SubStr( cLine, 137, 3 ) ) * nIvaCodTer( SubStr( cLine, 97, 1 ), ::oDbfIva:cAlias ) ) / 100 )
            ::oDbfArt:nMinimo       := Val( SubStr( cLine, 154, 5 ) + "." + SubStr( cLine, 159, 3 ) )
            ::oDbfArt:LastChg       := GetSysDate()
            ::oDbfArt:dFecChg       := GetSysDate()
            ::oDbfArt:cTimChg       := Time()
            ::oDbfArt:cUnidad       := SubStr( cLine, 153, 1 ) + Space(1)
            ::oDbfArt:cCodUsr       := Auth():Codigo()
            ::oDbfArt:lSndDoc       := .t.

            ::oDbfArt:Save()

            //Añadimos la referencia artículo proveedor

            ::oDbfPrvArt:Append()

            ::oDbfPrvArt:cCodArt    := Padr( SubStr( cLine, 22, 8 ), 18 )
            ::oDbfPrvArt:cCodPrv    := Rjust( SubStr( cLine, 107, 6 ), "0", RetNumCodPrvEmp() )
            ::oDbfPrvArt:cRefPrv    := Padr( SubStr( cLine, 113, 15 ), 18 )
            ::oDbfPrvArt:cDivPrv    := cDivEmp()
            ::oDbfPrvArt:lDefPrv    := .t.

            ::oDbfPrvArt:Save()

         else

            ::oTreeFile:Add( "Modificando el artículo: " + Padr( SubStr( cLine, 22, 8 ), 18 ) )

            ::oDbfArt:Load()

            ::oDbfArt:Nombre        := Padr( SubStr( cLine, 30, 30 ), 100 )
            ::oDbfArt:cDesTik       := SubStr( cLine, 60, 20 )
            ::oDbfArt:CodeBar       := Padr( SubStr( cLine, 7, 15 ), 20 )
            ::oDbfArt:TipoIva       := cCodTerToCodIva( SubStr( cLine, 97, 1 ), ::oDbfIva:cAlias )

            if ::oDbfArt:cPrvHab != Rjust( SubStr( cLine, 107, 6 ), "0", RetNumCodPrvEmp() )
               ::oDbfArt:cPrvHab    := Rjust( SubStr( cLine, 107, 6 ), "0", RetNumCodPrvEmp() )

               /*Articulo proveedor*/

               ::oDbfPrvArt:OrdSetFocus( "CCODPRV" )

               ::oDbfPrvArt:GoTop()

               if ::oDbfPrvArt:Seek( Rjust( SubStr( cLine, 107, 6 ), "0", RetNumCodPrvEmp() ) + Padr( SubStr( cLine, 22, 8 ), 18 ) )

                  ::oDbfPrvArt:Append()
                  ::oDbfPrvArt:cRefPrv    := Padr( SubStr( cLine, 113, 15 ), 18 )
                  ::oDbfPrvArt:Save()

               else

                  ::oDbfPrvArt:GoTop()

                  while !::oDbfPrvArt:Eof()
                     ::oDbfPrvArt:Load()
                     ::oDbfPrvArt:lDefPrv    := .f.
                     ::oDbfPrvArt:Save()
                  ::oDbfPrvArt:Skip()
                  end while

                  ::oDbfPrvArt:Append()

                  ::oDbfPrvArt:cCodArt    := Padr( SubStr( cLine, 22, 8 ), 18 )
                  ::oDbfPrvArt:cCodPrv    := Rjust( SubStr( cLine, 107, 6 ), "0", RetNumCodPrvEmp() )
                  ::oDbfPrvArt:cRefPrv    := Padr( SubStr( cLine, 113, 15 ), 18 )
                  ::oDbfPrvArt:cDivPrv    := cDivEmp()
                  ::oDbfPrvArt:lDefPrv    := .t.

                  ::oDbfPrvArt:Save()

               end if

            end if

            ::oDbfArt:pVenta1       := Val( SubStr( cLine, 131, 6 ) + "." + SubStr( cLine, 137, 3 ) )
            ::oDbfArt:pVtaIva1      := ( ( Val( SubStr( cLine, 131, 6 ) + "." + SubStr( cLine, 137, 3 ) ) * nIvaCodTer( SubStr( cLine, 97, 1 ), ::oDbfIva:cAlias ) ) / 100 )
            ::oDbfArt:nMinimo       := Val( SubStr( cLine, 154, 5 ) + "." + SubStr( cLine, 159, 3 ) )
            ::oDbfArt:dFecChg       := GetSysDate()
            ::oDbfArt:cTimChg       := Time()
            ::oDbfArt:cUnidad       := SubStr( cLine, 153, 1 ) + Space(1)
            ::oDbfArt:lSndDoc       := .t.

            ::oDbfArt:Save()

         end if

      case SubStr( cLine, 1, 4 ) == "1020"

         //Tickets de clientes

         cNumeroDocumento  := "A" + SubStr( cLine, 29, 10 ) + RetSufEmp()

         if !::oTikCliT:Seek( cNumeroDocumento )

            //Si el documento no existe se crea directamente la cabecera

            ::oTikCliT:Append()

            ::oTikCliT:cSerTik      := "A"
            ::oTikCliT:cNumTik      := SubStr( cLine, 33, 10 )
            ::oTikCliT:cSufTik      := RetSufEmp()
            ::oTikCliT:cTipTik      := "1"
            ::oTikCliT:cTurTik      := cCurSesion()
            ::oTikCliT:dFecTik      := Ctod( SubStr( cLine, 157, 2 ) + "-" + SubStr( cLine, 155, 2 ) + "-" + SubStr( cLine, 151, 4 ) )
            ::oTikCliT:cHorTik      := SubStr( cLine, 159, 2 ) + ":" + SubStr( cLine, 161, 2 )
            ::oTikCliT:cCcjTik      := Auth():Codigo()
            ::oTikCliT:cNcjTik      := oUser():cCaja()
            ::oTikCliT:cAlmTik      := oUser():cAlmacen()
            ::oTikCliT:cFpgTik      := cDefFpg()
            ::oTikCliT:cDivTik      := cDivEmp()
            ::oTikCliT:nVdvTik      := nChgDiv( cDivEmp(), ::oDbfDiv )
            ::oTikCliT:cCodDlg      := Application():CodigoDelegacion()
            ::oTikCliT:dFecCre      := Ctod( SubStr( cLine, 157, 2 ) + "-" + SubStr( cLine, 155, 2 ) + "-" + SubStr( cLine, 151, 4 ) )
            ::oTikCliT:cTimCre      := SubStr( cLine, 159, 2 ) + ":" + SubStr( cLine, 161, 2 )
            ::oTikCliT:nTarifa      := 1
            ::oTikCliT:cRetMat      := Padr( SubStr( cLine, 119, 10 ), 20 )
            ::oTikCliT:cCliTik      := Rjust( SubStr( cLine, 94, 6 ), "0", RetNumCodCliEmp() )

            if ::oDbfClient:Seek( Rjust( SubStr( cLine, 94, 6 ), "0", RetNumCodCliEmp() ) )
               ::oTikCliT:cNomTik   := ::oDbfClient:Titulo
               ::oTikCliT:cDirCli   := ::oDbfClient:Domicilio
               ::oTikCliT:cPobCli   := ::oDbfClient:Poblacion
               ::oTikCliT:cPrvCli   := ::oDbfClient:Provincia
               ::oTikCliT:cPosCli   := ::oDbfClient:CodPostal
               ::oTikCliT:cDniCli   := ::oDbfClient:Nif
            else
               ::oTikCliT:cNomTik   := Space( 80 )
               ::oTikCliT:cDirCli   := Space( 100 )
               ::oTikCliT:cPobCli   := Space( 35 )
               ::oTikCliT:cPrvCli   := Space( 20 )
               ::oTikCliT:cPosCli   := Space( 5 )
               ::oTikCliT:cDniCli   := Space( 15 )
            end if

            ::oTikCliT:lCloTik      := .f.
            ::oTikCliT:lSndDoc      := .t.
            ::oTikCliT:lPgdTik      := .t.
            ::oTikCliT:lLiqTik      := .t.
            ::oTikCliT:lConTik      := .f.
            ::oTikCliT:lSelDoc      := .t.
            ::oTikCliT:lCnvTik      := .f.
            ::oTikCliT:cNumDoc      := Space( 12 )

            //::oTikCliT:nCobTik      := N   16   6    Importe cobrado
            //::oTikCliT:nCamTik      := N   16   6    Devolución

            ::oTikCliT:Save()

            ::oTreeFile:Add( "Procesando tiket de cliente : A" + "/" + AllTrim( SubStr( cLine, 33, 10 ) ) + "/" + RetSufEmp() )

         else

            /*Comprobamos que sea la primera linea para borrarlas
            todas e insertarlas de nuevo, para que no se encuentren lineas repetidas*/

            if cNumeroDocumento != ::cNumOldDocumento

               while ::oTikCliL:Seek( cNumeroDocumento )
                  ::oTikCliL:Delete( .f. )
               end if

            end if

         end if

         //Añadimos la línea

         ::oTikCliL:Append()

         ::oTikCliL:cSerTil         := "A"
         ::oTikCliL:cNumTil         := SubStr( cLine, 29, 10 )
         ::oTikCliL:cSufTil         := RetSufEmp()
         ::oTikCliL:cCbaTil         := Padr( SubStr( cLine, 6, 8 ), 18 )
         ::oTikCliL:cAlmLin         := oUser():cAlmacen()
         ::oTikCliL:lControl        := .f.
         ::oTikCliL:lOfeTil         := .f.
         ::oTikCliL:lFreTil         := .f.

         if ::oDbfArt:Seek( Padr( SubStr( cLine, 6, 8 ), 18 ) )
            ::oTikCliL:cNomTil      := ::oDbfArt:Nombre
            ::oTikCliL:cCodFam      := ::oDbfArt:Familia
            ::oTikCliL:cGrpFam      := RetFld( ::oDbfArt:Familia, ::oDbfFam:cAlias, "cCodGrp"  )
            ::oTikCliL:lTipAcc      := ::oDbfArt:lTipAcc
            ::oTikCliL:nCtlStk      := ::oDbfArt:nCtlStock
            ::oTikCliL:nCosDiv      := ::oDbfArt:pCosto
         else
            ::oTikCliL:cNomTil      := Space(250)
            ::oTikCliL:cCodFam      := Space( 8 )
            ::oTikCliL:cGrpFam      := Space( 3 )
            ::oTikCliL:nCtlStk      := 1
            ::oTikCliL:nCosDiv      := 0
         end if

         ::oTikCliL:nPvpTil         := Val( SubStr( cLine, 39, 6 ) + "." + SubStr( cLine, 45, 3 ) )
         ::oTikCliL:nUntTil         := Val( SubStr( cLine, 48, 6 ) + "." + SubStr( cLine, 54, 3 ) )
         ::oTikCliL:nIvaTil         := nIvaCodTer( SubStr( cLine, 57, 1 ), ::oDbfIva:cAlias )

         do case
            case SubStr( cLine, 58, 1 ) == "P"
               ::oTikCliL:nDtoLin   := 0
               ::oTikCliL:nDtoDiv   := Val( SubStr( cLine, 59, 1 ) + "." + SubStr( cLine, 60, 3 ) )
            case SubStr( cLine, 58, 1 ) == "J"
               ::oTikCliL:nDtoLin   := Val( SubStr( cLine, 59, 2 ) + "." + SubStr( cLine, 60, 2 ) )
               ::oTikCliL:nDtoDiv   := 0
            Otherwise
               ::oTikCliL:nDtoLin   := 0
               ::oTikCliL:nDtoDiv   := 0
         end case

         ::oTikCliL:Save()

         //Escribimos en el tree, para informar

         ::oTreeFile:Add( Space(5) + "Artículo: " + AllTrim( Padr( SubStr( cLine, 6, 8 ), 18 ) ) + " ; " + AllTrim( Str( Val( SubStr( cLine, 48, 6 ) + "." + SubStr( cLine, 54, 3 ) ) ) ) + " ; " + AllTrim( Str( Val( SubStr( cLine, 39, 6 ) + "." + SubStr( cLine, 45, 3 ) ) ) ) )

         //Pasamos el valor del documento a la variable para la proxima línea

         ::cNumOldDocumento         := cNumeroDocumento

   end case

RETURN ( Self )

//----------------------------------------------------------------------------//