#include "FiveWin.Ch"
#include "Factu.ch" 
#include "Menu.ch"
#include "Folder.ch"

static dbfRuta
static oTipArt

//----------------------------------------------------------------------------//

CLASS TEdm

   DATA  oDlg
   DATA  oFld
   DATA  oBrwRuta
   DATA  oBrwTipo
   DATA  oMetUno
   DATA  nMetUno
   DATA  oMetDos
   DATA  nMetDos
   DATA  oPath
   DATA  cPath
   DATA  oPathOrg
   DATA  cPathOrg
   DATA  lDelFiles
   DATA  oSerie
   DATA  cSerie
   DATA  oCodPgo
   DATA  cCodPgo

   METHOD   OpenFiles()
   METHOD   CloseFiles()

   METHOD   Activate( oWnd )

   METHOD   SelRuta( lSel )
   METHOD   SelAllRuta( lSel )

   METHOD   MkSndEdm()
   METHOD   MkRecEdm()

END CLASS

//----------------------------------------------------------------------------//

Method OpenFiles( cPatEmp )

   local lOpen       := .t.
   local oBlock      := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   DEFAULT cPatEmp   := cPatEmp()

   BEGIN SEQUENCE

   USE ( cPatEmp() + "RUTA.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "RUTA", @dbfRuta ) )
   SET ADSINDEX TO ( cPatEmp() + "RUTA.CDX" ) ADDITIVE

   oTipArt           := TTipArt():New( cPatEmp() )
   oTipArt:OpenFiles()

   RECOVER

      msgStop( "Imposible abrir todas las bases de datos" )
      ::CloseFiles()
      lOpen       := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN lOpen

//----------------------------------------------------------------------------//

Method CloseFiles()

   CLOSE ( dbfRuta )

   if !Empty( oTipArt )
      oTipArt:end()
   end if

RETURN self

//----------------------------------------------------------------------------//

Method Activate( oMenuItem, oWnd )

   local oSayPgo
   local cSayPgo
   local oStru

   local nLevel      := Auth():Level( oMenuItem )
   if nAnd( nLevel, 1 ) == 0
      msgStop( "Acceso no permitido." )
      return ( nil )
   end if

   if !::OpenFiles()
      Return nil
   end if

   oTipArt:SelectAll( .f. )

   ::SelAllRuta( .f. )

   ::nMetUno     := 0
   ::nMetDos     := 0
   ::cPath       := FullCurDir() + "PSION\"
   ::cPathOrg    := FullCurDir() + "PSION\"
   ::lDelFiles   := .t.
   ::cCodPgo     := cDefFpg()

   /*
   Caja de dialogo-------------------------------------------------------------
	*/

   DEFINE DIALOG ::oDlg RESOURCE "SND_EDM" OF oWnd()

   REDEFINE FOLDER ::oFld ;
			ID 		500 ;
         OF       ::oDlg ;
         PROMPT   "&Exportar",;
                  "&Importar";
         DIALOGS  "SND_EDM1",;
                  "SND_EDM2"

   ::oBrwTipo                 := IXBrowse():New( ::oFld:aDialogs[ 1 ] )

   oTipArt:oDbf:SetBrowse( ::oBrwTipo, .f. )

   ::oBrwTipo:bClrSel         := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
   ::oBrwTipo:bClrSelFocus    := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

   ::oBrwTipo:nMarqueeStyle   := 5

   ::oBrwTipo:CreateFromResource( 90 )

   with object ( ::oBrwTipo:addCol() )
      :cHeader       := "Se. Seleccionada"
      :bStrData      := {|| "" }
      :bEditValue    := {|| oTipArt:oDbf:lSelect }
      :nWidth        := 20
      :SetCheck( { "Sel16", "Nil16" } )
   end with

   with object ( ::oBrwTipo:addCol() )
      :cHeader       := "Código"
      :bEditValue    := {|| oTipArt:oDbf:cCodTip }
      :nWidth        := 50
   end with

   with object ( ::oBrwTipo:addCol() )
      :cHeader       := "Descripción"
      :bEditValue    := {|| oTipArt:oDbf:cNomTip }
      :nWidth        := 200
   end with

   ::oBrwTipo:bLDblClick := {|| oTipArt:InvSelect( ::oBrwTipo ) }

   REDEFINE BUTTON ;
      ID       561;
      OF       ::oFld:aDialogs[ 1 ] ;
      ACTION   ( oTipArt:InvSelect( ::oBrwTipo ) )

   REDEFINE BUTTON ;
      ID       562;
      OF       ::oFld:aDialogs[ 1 ] ;
      ACTION   ( oTipArt:SelectAll( .t., ::oBrwTipo ) )

   REDEFINE BUTTON ;
      ID       563;
      OF       ::oFld:aDialogs[ 1 ] ;
      ACTION   ( oTipArt:SelectAll( .f., ::oBrwTipo ) )

   /*
   Primera caja de dialogo-----------------------------------------------------
   */

   ::oBrwRuta                 := IXBrowse():New( ::oFld:aDialogs[ 1 ] )

   ::oBrwRuta:cAlias          := dbfRuta

   ::oBrwRuta:bClrSel         := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
   ::oBrwRuta:bClrSelFocus    := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

   ::oBrwRuta:nMarqueeStyle   := 5

   ::oBrwRuta:CreateFromResource( 100 )

   with object ( ::oBrwRuta:addCol() )
      :cHeader       := "Se. Seleccionada"
      :bStrData      := {|| "" }
      :bEditValue    := {|| ( dbfRuta )->lSelRut }
      :nWidth        := 20
      :SetCheck( { "Sel16", "Nil16" } )
   end with

   with object ( ::oBrwRuta:addCol() )
      :cHeader       := "Código"
      :bEditValue    := {|| ( dbfRuta )->cCodRut }
      :nWidth        := 50
   end with

   with object ( ::oBrwRuta:addCol() )
      :cHeader       := "Descripción"
      :bEditValue    := {|| ( dbfRuta )->cDesRut }
      :nWidth        := 200
   end with

   ::oBrwRuta:bLDblClick := {|| ::SelRuta() }

   REDEFINE GET   ::oPath ;
      VAR         ::cPath ;
      ID          110 ;
      BITMAP      "FOLDER" ;
      OF          ::oFld:aDialogs[ 1 ]

   ::oPath:bHelp  := {|| ::oPath:cText( cGetDir32( "Seleccione destino" ) ) }

   REDEFINE BUTTON ;
      ID       514;
      OF       ::oFld:aDialogs[ 1 ] ;
      ACTION   ( ::SelRuta() )

   REDEFINE BUTTON ;
      ID       516;
      OF       ::oFld:aDialogs[ 1 ] ;
      ACTION   ( ::SelAllRuta( .t. ) )

   REDEFINE BUTTON ;
      ID       517;
      OF       ::oFld:aDialogs[ 1 ] ;
      ACTION   ( ::SelAllRuta( .f. ) )

   REDEFINE APOLOMETER ::oMetUno;
      VAR      ::nMetUno ;
      PROMPT   "Progreso";
      ID       120 ;
      OF       ::oFld:aDialogs[ 1 ] ;
      TOTAL    100

   /*
   Segunda caja de dialogo
   */

   REDEFINE GET ::oPathOrg VAR ::cPathOrg ;
      ID       110 ;
      COLOR    CLR_GET ;
      BITMAP   "FOLDER" ;
      ON HELP  ( ::oPathOrg:cText( cGetDir( "Seleccione destino" ) ) ) ;
      OF       ::oFld:aDialogs[ 2 ]

   REDEFINE CHECKBOX ::lDelFiles ;
      ID       120 ;
      OF       ::oFld:aDialogs[ 2 ]

   REDEFINE GET ::oCodPgo VAR ::cCodPgo ;
      ID       130;
      PICTURE  "@!" ;
      BITMAP   "LUPA" ;
      OF       ::oFld:aDialogs[ 2 ]

      ::oCodPgo:bValid  := {|| cFPago( ::oCodPgo, , oSayPgo ) }
      ::oCodPgo:bHelp   := {|| BrwFPago( ::oCodPgo, oSayPgo ) }

   REDEFINE GET oSayPgo VAR cSayPgo ;
      WHEN     .F. ;
      ID       141 ;
      OF       ::oFld:aDialogs[ 2 ]

   REDEFINE APOLOMETER ::oMetDos;
      VAR      ::nMetDos ;
      PROMPT   "Progreso";
      ID       140 ;
      OF       ::oFld:aDialogs[ 2 ] ;
      TOTAL    100

   /*
   Botones---------------------------------------------------------------------
   */

   REDEFINE BUTTON ;
      ID       IDOK;
      OF       ::oDlg ;
      ACTION   ( if( ::oFld:nOption == 1, ::MkSndEdm(), ::MkRecEdm() ) )

   REDEFINE BUTTON ;
      ID       IDCANCEL;
      OF       ::oDlg ;
      ACTION   ( ::oDlg:end() )

   REDEFINE BUTTON ;
      ID       9 ;
      OF       ::oDlg ;
      ACTION   ( ChmHelp( "ExportarDatos" ) )

   ::oDlg:AddFastKey( VK_F5, {|| if( ::oFld:nOption == 1, ::MkSndEdm(), ::MkRecEdm() ) } )
   ::oDlg:AddFastKey( VK_F1, {|| ChmHelp( "ExportarDatos" ) } )

   ACTIVATE DIALOG ::oDlg CENTER

   ::CloseFiles()

RETURN NIL

//--------------------------------------------------------------------------//

METHOD SelRuta( lSel )

   DEFAULT lSel   := !( dbfRuta )->lSelRut

   if dbDialogLock( dbfRuta )
      ( dbfRuta )->lSelRut := lSel
      ( dbfRuta )->( dbUnlock() )
   end if

   ::oBrwRuta:Refresh()

return nil

//--------------------------------------------------------------------------//

Method SelAllRuta( lSel )

   local nRec  := ( dbfRuta )->( Recno() )

   ( dbfRuta )->( dbGoTop() )
   while !( dbfRuta )->( eof() )

      if dbDialogLock( dbfRuta )
         ( dbfRuta )->lSelRut := lSel
         ( dbfRuta )->( dbUnlock() )
      end if

      ( dbfRuta )->( dbSkip() )
   end while

   ( dbfRuta )->( dbGoTo( nRec ) )

   if !Empty( ::oBrwRuta )
      ::oBrwRuta:Refresh()
   end if

return nil

//--------------------------------------------------------------------------//
/*
Exporta los datos a los terminales
*/

Method MkSndEdm()

   /*
   Debe seleccionar al menos una ruta
   */

   local lRut  := .f.
   local nRec  := ( dbfRuta )->( Recno() )

   /*
   Caja de dialogo desabilitada
   */

   ::oFld:aDialogs[ 1 ]:Disable()

   /*
   Eliminar los datos del directorio
   */

   aEval( directory( "PSION\*.*" ), {|aFiles| fErase( "PSION\" + aFiles[1] ) } )

   ( dbfRuta )->( dbGoTop() )
   while !( dbfRuta )->( eof() )

      if ( dbfRuta )->lSelRut

         // Enviando fichero de articulo a las maquinitas

         EdmArt( ( dbfRuta )->cCodRut, ::cPath, Self, oTipArt )

         // Enviando fichero de clientes a las maquinitas

         EdmCli( ( dbfRuta )->cCodRut, ::cPath, Self, oTipArt )

         // Enviando fichero de rutas y clientes a las maquinitas

         EdmRutCli( ( dbfRuta )->cCodRut, ::cPath, Self, oTipArt )

         // Ofertas a clientes

         EdmOfe( ( dbfRuta )->cCodRut, ::cPath, Self )

         ::oMetUno:Set( 0 )

         lRut  := .t.

      end if

      ( dbfRuta )->( dbSkip() )

   end while

   ( dbfRuta )->( dbGoTo( nRec ) )

   if lRut

      MsgInfo( "Proceso de exportación finalizado con exito." )

   else

      msgStop( "Debe seleccionar al menos una ruta." )

   end if

   /*
   if lRut
      EdmArt( , ::cPath, oStru, oTipArt )
      EdmCli( , ::cPath, oStru, oTipArt )
      EdmRutCli( , dbfRuta, ::cPath, oStru, oTipArt )
      EdmRecCli( ,  ::cPath, oStru )
      EdmOfe( , ::cPath, oStru )
      ::oMetUno:Set( 0 )
      MsgInfo( "Proceso de exportación finalizado con exito." )
   else
      msgStop( "Debe seleccionar al menos una ruta." )
   end if
   */

   /*
   Caja de dialogo desabilitada
   */

   ::oFld:aDialogs[ 1 ]:Enable()

return nil

//---------------------------------------------------------------------------//
/*
Recoje los datos desde los terminales------------------------------------------
*/

Method MkRecEdm()

   local aSucces  := {}

   if Empty( ::cCodPgo )
      msgStop( "Es necesario introducir una forma de pago" )
      return .f.
   end if

   if ( dbfRuta )->( LastRec() ) == 0
      msgStop( "No hay rutas para importar" )
      return .f.
   end if

   /*
   Caja de dialogo desabilitada------------------------------------------------
   */

   ::oFld:aDialogs[ 2 ]:Disable()

   ( dbfRuta )->( dbGoTop() )
   while !( dbfRuta )->( eof() )

      /*
      Recibiendo fichero de pedidos de clientes--------------------------------
      */

      EdmPedCli( ( dbfRuta )->cCodRut, ::cPathOrg, Self, aSucces )

      ::oMetDos:Set( 0 )

      /*
      Recibiendo fichero de albaraness de clientes
      */

      EdmAlbCli( ( dbfRuta )->cCodRut, ::cPathOrg, Self, aSucces )
      SynAlbCli()

      ::oMetDos:Set( 0 )

      /*
      Recibiendo fichero de albaraness de clientes
      */

      EdmFacCli( ( dbfRuta )->cCodRut, ::cPathOrg, Self, aSucces )
      SynFacCli()

      ::oMetDos:Set( 0 )

      ( dbfRuta )->( dbSkip() )

   end while

   /*
   Visor de sucesos
   */

   if !Empty( aSucces )
      Visor( aSucces )
   end if

   if ::lDelFiles
      aEval( Directory( ::cPath + "*.PSI" ), {|aFiles| fErase( ::cPath + aFiles[1] ) } )
   end if

   ::oFld:aDialogs[ 2 ]:Enable()

return nil

//--------------------------------------------------------------------------//

function EdmSubStr( cChar, nStart, nEnd, lSep )

   DEFAULT lSep   := .t.
   DEFAULT nStart := 1
   DEFAULT nEnd   := len( cChar )

   cChar          := cValToChar( cChar )
   cChar          := Upper( AllTrim( SubStr( StrTran( cChar, ",", "" ), nStart, nEnd ) ) ) + if( lSep, ",", "" )

   /*
   No le gustan los acentos
   */

   cChar          := StrTran( cChar, "Á", "A" )
   cChar          := StrTran( cChar, "É", "E" )
   cChar          := StrTran( cChar, "Í", "I" )
   cChar          := StrTran( cChar, "Ó", "O" )
   cChar          := StrTran( cChar, "Ú", "U" )

RETURN ( cChar )

//--------------------------------------------------------------------------//

function EdmLogicSN( lLogic, lSep )

   DEFAULT lSep   := .t.

return ( If( lLogic, "S", "N" ) + if( lSep, ",", "" ) )

//--------------------------------------------------------------------------//

function EdmLocig12( lLogic, lSep )

   DEFAULT lSep   := .t.

return ( If( lLogic, "1", "2" ) + if( lSep, ",", "" ) )

//--------------------------------------------------------------------------//

function EdmRjust( cChar, cSep, nLen, lSep )

   DEFAULT cSep   := " "
   DEFAULT nLen   := Len( cChar )
   DEFAULT lSep   := .t.

return ( Rjust( cChar, cSep, nLen ) + if( lSep, ",", "" ) )

//--------------------------------------------------------------------------//

/*
Exporta el fichero de articulos a EDM
*/

FUNCTION EdmCli( cCodRut, cPathTo, oStru )

   local n           := 0
   local cChr
   local fTar
   local cFilEdm
   local cFilOdb
   local nWrote
   local nRead
   local oError
   local oBlock
   local dbfClient

   DEFAULT cCodRut   := "001"
   DEFAULT cPathTo   := "C:\INTERS~1\"

   cCodRut           := SubStr( cCodRut, -3 )

   cFilEdm           := cPathTo + "ECLIE" + cCodRut + ".TXT"
   cFilOdb           := cPathTo + "ECLIE" + cCodRut + ".ODB"

   /*
   Creamos el fichero destino
   */

   IF file( cFilEdm )
      fErase( cFilEdm )
   END IF

   fTar              := fCreate( cFilEdm )

   /*
   Abrimos las bases de datos
   */

   oBlock            := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   USE ( cPatEmp() + "CLIENT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "CLIENT", @dbfClient ) )
   SET ADSINDEX TO ( cPatEmp() + "CLIENT.CDX" ) ADDITIVE

   oStru:oMetUno:cText   := "Clientes"
   oStru:oMetUno:SetTotal( ( dbfClient )->( LastRec() ) )

   WHILE !(dbfClient)->( eof() )

      cChr  := "+"
      cChr  += Rjust( (dbfClient)->COD, "0", 7 ) + ","                        // Codigo de cliente

      if !empty( (dbfClient)->NBREST )
      cChr  += EdmSubStr( (dbfClient)->NBREST, 1, 35 )                        // Nombre del estblecimiento
      else
      cChr  += EdmSubStr( (dbfClient)->TITULO, 1, 35 )                        // Nombre de cliente
      end if

      cChr  += EdmSubStr( (dbfClient)->TITULO, 1, 35 )                        // Nombre de cliente
      cChr  += EdmSubStr( (dbfClient)->DOMICILIO, 1, 35 )                     // Domicilio
      cChr  += EdmSubStr( (dbfClient)->POBLACION, 1, 25 )                     // Población
      cChr  += EdmSubStr( (dbfClient)->NIF, 1, 14 )                           // N.I.F.
      cChr  += EdmLogicSN( (dbfClient)->LREQ )                                // Recargo de Equivalencia
      cChr  += EdmLocig12( (dbfClient)->LMAYORISTA )                          // Tipo de tarifa
      cChr  += EdmSubStr( "S" )                                               // Valoración de albaranes
      cChr  += EdmSubStr( Trans( (dbfClient)->NDTOESP, "@ 99.99" ), 1, 5 )    // Descuento de cliente
      cChr  += EdmSubStr( "0" )                                               // Numero para grupo de ofertas
      cChr  += EdmSubStr( Trans( (dbfClient)->RIESGO, "@ 9999.99" ), 1, 7 )   // Riesgo
      cChr  += EdmSubStr( Trans( (dbfClient)->NDPP, "@ 99.99" ), 1, 5 )       // Descuento pronto pago de cliente
      cChr  += EdmSubStr( "S", 1, 1, .f. )                                    // S/N Imprime en Euros o en Ptas
      //cChr  += EdmSubStr( (dbfClient)->Telefono, 1, 10 )                      // Telefono
      cChr  += CRLF

      nWrote:= fwrite( fTar, cChr, nRead )

      oStru:oMetUno:Set( ++n )

      /*
      IF fError() != 0
         msginfo( "Hay errores" )
      END IF
      */

      (dbfClient)->( dbSkip() )

   END DO

   RECOVER USING oError

      msgStop( ErrorMessage( oError ), "Imposible abrir todas las bases de datos" )

   END SEQUENCE
   ErrorBlock( oBlock )

   CLOSE ( dbfClient )
   fClose( fTar )

   /*
   Conversion a formato exportable a la psion
   */

   if file( FullCurDir() + "CONVER.EXE" )
      WinExec( FullCurDir() + "CONVER.EXE " + cFilEdm + " " + cFilOdb + " 44 -x", 6 ) // Minimized
   end if

RETURN NIL

//---------------------------------------------------------------------------//

/*
Exporta el fichero de rutas y clientes a EDM
*/

FUNCTION EdmRutCli( cCodRut, cPathTo, oStru )

   local n           := 0
   local cChr
   local fTar
   local nWrote
   local nRead
   local cFilEdm
   local cFilOdb
   local cRutCli
   local dbfClient

   DEFAULT cCodRut   := "001"
   DEFAULT cPathTo   := "C:\INTERS~1\"

   cRutCli           := cCodRut

   cCodRut           := SubStr( cCodRut, -3 )

   cFilEdm           := cPathTo + "ERUTA" + cCodRut + ".TXT"    //  de momento ruta unica
   cFilOdb           := cPathTo + "ERUTA" + cCodRut + ".ODB"    //  de momento ruta unica

   /*
   Creamos el fichero destino
   */

   if file( cFilEdm )
      fErase( cFilEdm )
   end if

   fTar              := fCreate( cFilEdm )

   /*
   Abrimos las bases de datos
   */

   USE ( cPatEmp() + "CLIENT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "CLIENT", @dbfClient ) )
   SET ADSINDEX TO ( cPatEmp() + "CLIENT.CDX" ) ADDITIVE

   oStru:oMetUno:cText   := "Rutas"
   oStru:oMetUno:SetTotal( ( dbfClient )->( LastRec() ) )

   WHILE !(dbfClient)->( eof() )

      if ( dbfClient )->cCodRut == cRutCli

         cChr  := Right( cCodRut, 1 )                             // Codigo de ruta
         cChr  += Rjust( (dbfClient)->COD, "0", 7 )               // Codigo de cliente
         cChr  += CRLF

         nWrote:= fwrite( fTar, cChr, nRead )

      end if

      oStru:oMetUno:Set( ++n )

      /*
      IF fError() != 0
         msginfo( "Hay errores" )
      END IF
      */

      ( dbfClient )->( dbSkip() )

   END DO

   CLOSE ( dbfClient )
   fClose( fTar )

   if file( FullCurDir() + "CONVER.EXE" )
      WinExec( FullCurDir() + "CONVER.EXE " + cFilEdm + " " + cFilOdb + " 44 -x", 6 ) // Minimized
   end if

RETURN NIL

