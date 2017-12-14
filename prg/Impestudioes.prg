#include "FiveWin.Ch"
#include "Struct.ch"
#include "Factu.ch" 
#include "Ini.ch"
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS TImpEstudio

   DATA nLevel
   DATA oDbfArt
   DATA oDbfCodeBar
   DATA oDbfIva
   DATA oDbfFam
   DATA oGrpFam
   DATA oDlg
   DATA oFld
   DATA cDirOrigen
   DATA oTree
   DATA oTreeFile
   DATA oMtrProceso
   DATA nMtrProceso
   DATA oBtnImprimir
   DATA oBtnSiguiente
   DATA cFilTxt
   DATA oCmbTar
   DATA cCmbTar      INIT  "Tarifa 1"
   DATA aCmbTar      INIT  { "Tarifa 1", "Tarifa 2", "Tarifa 3", "Tarifa 4", "Tarifa 5", "Tarifa 6" }
   DATA oColCodArt
   DATA oColNomArt
   DATA oColCodBar
   DATA oColUniCaj
   DATA oColpCosto
   DATA oColpVenta
   DATA oColGFamilia
   DATA oColFamilia
   DATA cColCodArt
   DATA cColNomArt
   DATA cColCodBar
   DATA cColUniCaj
   DATA cColpCosto
   DATA cColpVenta
   DATA cColGFamilia
   DATA cColFamilia

   METHOD New()

   METHOD Create( oMenuItem, oWnd ) INLINE ( if( ::New( oMenuItem, oWnd ) != nil, ::Activate(), ) )

   METHOD lOpenFiles()

   METHOD CloseFiles()

   METHOD Activate( oWnd )

   METHOD BotonSiguiente()

   METHOD ImportaHoja()

   METHOD GuardarValoresIni()

   METHOD CargarValoresIni()

END CLASS

//---------------------------------------------------------------------------//
/*
Método constructor
*/

METHOD New( oMenuItem, oWnd )

   DEFAULT oMenuItem    := "01102"

   ::nLevel             := nLevelUsr( oMenuItem )

   if oWnd != nil
      SysRefresh(); oWnd:CloseAll(); SysRefresh()
   end if

RETURN ( Self )

//---------------------------------------------------------------------------//
/*
Método para abrir ficheros que necesitaremos
*/

METHOD lOpenFiles()

   local lOpen    := .t.
   local oBlock   := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

   DATABASE NEW ::oDbfArt     FILE "ARTICULO.DBF"     PATH ( cPatArt() )    VIA ( cDriver() ) SHARED INDEX  "ARTICULO.CDX"

   DATABASE NEW ::oDbfCodeBar FILE "ARTCODEBAR.DBF"   PATH ( cPatArt() )    VIA ( cDriver() ) SHARED INDEX  "ARTCODEBAR.CDX"

   DATABASE NEW ::oDbfIva     FILE "TIVA.DBF"         PATH ( cPatDat() )    VIA ( cDriver() ) SHARED INDEX  "TIVA.CDX"

   DATABASE NEW ::oDbfFam     FILE "FAMILIAS.DBF"     PATH ( cPatArt() )    VIA ( cDriver() ) SHARED INDEX  "FAMILIAS.CDX"

   DATABASE NEW ::oGrpFam     FILE "GRPFAM.DBF"       PATH ( cPatArt() )    VIA ( cDriver() ) SHARED INDEX  "GRPFAM.CDX"

   RECOVER

      msgStop( "Imposible abrir todas las bases de datos" )

      ::CloseFiles()

      lOpen       := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//
/*
Método que cierra los ficheros abiertos
*/

METHOD CloseFiles()

   if !Empty ( ::oDbfArt )
      ::oDbfArt:End()
   end if

   if !Empty ( ::oDbfCodeBar )
      ::oDbfCodeBar:End()
   end if

   if !Empty ( ::oDbfIva )
      ::oDbfIva:End()
   end if

   if !Empty ( ::oDbfFam )
      ::oDbfFam:End()
   end if

   if !Empty( ::oGrpFam )
      ::oGrpFam:End()
   end if


   ::oDbfArt     := nil
   ::oDbfCodeBar := nil
   ::oDbfIva     := nil
   ::oDbfFam     := nil
   ::oGrpFam     := nil

RETURN ( Self )

//---------------------------------------------------------------------------//
/*
Método que monta el diálogo y con el que ya pasamos a la acción
*/

METHOD Activate( oWnd )

   local oBmp
   local oDirOrigen

   if nAnd( ::nLevel, 1 ) != 0
      msgStop( "Acceso no permitido." )
      Return( Self )
   end if

   if ! ::lOpenFiles()
      Return( Self )
   end if


   ::CargarValoresIni()

   DEFINE DIALOG ::oDlg RESOURCE "ASS_ESTUDIO" OF oWnd()

      REDEFINE BITMAP oBmp RESOURCE "gc_import_48"  TRANSPARENT ID 600 OF ::oDlg

      REDEFINE PAGES ::oFld ;
         ID       100 ;
         OF       ::oDlg ;
         DIALOGS  "ASS_ESTUDIO01", "ASS_ESTUDIO02"

      REDEFINE GET oDirOrigen VAR ::cDirOrigen;
         ID       100;
         BITMAP   "Folder" ;
         ON HELP ( oDirOrigen:cText( cGetFile( "*.xls", "Selección de fichero" ) ) ) ;
         OF       ::oFld:aDialogs[ 1 ]

      REDEFINE COMBOBOX ::oCmbTar VAR ::cCmbTar ;
         ITEMS    ::aCmbTar ;
         ID       130 ;
         OF       ::oFld:aDialogs[1]

      REDEFINE GET ::oColCodArt VAR ::cColCodArt ;
         ID       140 ;
         PICTURE  "@!" ;
         SPINNER ;
         ON UP    ( UpSerie( ::oColCodArt ) );
         ON DOWN  ( DwSerie( ::oColCodArt ) );
         VALID    ( ::cColCodArt == Space( 1 ) .or. ( ::cColCodArt >= "A" .AND. ::cColCodArt <= "Z"  ) );
         OF       ::oFld:aDialogs[1]

      REDEFINE GET ::oColNomArt VAR ::cColNomArt ;
         ID       150 ;
         PICTURE  "@!" ;
			COLOR 	CLR_GET ;
         SPINNER ;
         ON UP    ( UpSerie( ::oColNomArt ) );
         ON DOWN  ( DwSerie( ::oColNomArt ) );
         VALID    ( ::cColNomArt == Space( 1 ) .or. ( ::cColNomArt >= "A" .AND. ::cColNomArt <= "Z"  ) );
         OF       ::oFld:aDialogs[1]

      REDEFINE GET ::oColCodBar VAR ::cColCodBar ;
         ID       160 ;
         PICTURE  "@!" ;
			COLOR 	CLR_GET ;
         SPINNER ;
         ON UP    ( UpSerie( ::oColCodBar ) );
         ON DOWN  ( DwSerie( ::oColCodBar ) );
         VALID    ( ::cColCodBar == Space( 1 ) .or. ( ::cColCodBar >= "A" .AND. ::cColCodBar <= "Z"  ) );
         OF       ::oFld:aDialogs[1]

      REDEFINE GET ::oColUniCaj VAR ::cColUniCaj ;
         ID       170 ;
         PICTURE  "@!" ;
			COLOR 	CLR_GET ;
         SPINNER ;
         ON UP    ( UpSerie( ::oColUniCaj ) );
         ON DOWN  ( DwSerie( ::oColUniCaj ) );
         VALID    ( ::cColUniCaj == Space( 1 ) .or. ( ::cColUniCaj >= "A" .AND. ::cColUniCaj <= "Z"  ) );
         OF       ::oFld:aDialogs[1]

      REDEFINE GET ::oColpCosto VAR ::cColpCosto ;
         ID       180 ;
         PICTURE  "@!" ;
			COLOR 	CLR_GET ;
         SPINNER ;
         ON UP    ( UpSerie( ::oColpCosto ) );
         ON DOWN  ( DwSerie( ::oColpCosto ) );
         VALID    ( ::cColpCosto == Space( 1 ) .or.  ( ::cColpCosto >= "A" .AND. ::cColpCosto <= "Z"  ) );
         OF       ::oFld:aDialogs[1]

      REDEFINE GET ::oColpVenta VAR ::cColpVenta ;
         ID       190 ;
         PICTURE  "@!" ;
			COLOR 	CLR_GET ;
         SPINNER ;
         ON UP    ( UpSerie( ::oColpVenta ) );
         ON DOWN  ( DwSerie( ::oColpVenta ) );
         VALID    ( ::cColpVenta == Space( 1 ) .or. ( ::cColpVenta >= "A" .AND. ::cColpVenta <= "Z"  ) );
         OF       ::oFld:aDialogs[1]

      REDEFINE GET ::oColGFamilia VAR ::cColGFamilia ;
         ID       200 ;
         PICTURE  "@!" ;
			COLOR 	CLR_GET ;
         SPINNER ;
         ON UP    ( UpSerie( ::oColGFamilia ) );
         ON DOWN  ( DwSerie( ::oColGFamilia ) );
         VALID    ( ::cColGFamilia == Space( 1 ) .or. ( ::cColGFamilia >= "A" .AND. ::cColGFamilia <= "Z"  ) );
         OF       ::oFld:aDialogs[1]

      REDEFINE GET ::oColFamilia VAR ::cColFamilia ;
         ID       210 ;
         PICTURE  "@!" ;
			COLOR 	CLR_GET ;
         SPINNER ;
         ON UP    ( UpSerie( ::oColFamilia ) );
         ON DOWN  ( DwSerie( ::oColFamilia ) );
         VALID    ( ::cColFamilia == Space( 1 ) .or. ( ::cColFamilia >= "A" .AND. ::cColFamilia <= "Z"  ) );
         OF       ::oFld:aDialogs[1]

      ::oTree     := TTreeView():Redefine( 100, ::oFld:aDialogs[ 2 ] )

REDEFINE APOLOMETER ::oMtrProceso ;
         VAR      ::nMtrProceso ;
         PROMPT   "Procesando" ;
         TOTAL    100 ;
         ID       110 ;
         OF       ::oFld:aDialogs[ 2 ]

      /*
      Botones------------------------------------------------------------------
      */

       REDEFINE BUTTON ::oBtnSiguiente ;
         ID       510 ;
         OF       ::oDlg ;
         ACTION   ( ::BotonSiguiente() )

      REDEFINE BUTTON ::oBtnImprimir ;
         ID       520 ;
         OF       ::oDlg ;
         ACTION   ( WinExec( "notepad.exe " + AllTrim( ::cFilTxt ) ) )

   ::oDlg:bStart  := {|| ::oBtnImprimir:Hide() }

   ACTIVATE DIALOG ::oDlg CENTER

   ::GuardarValoresIni()

   ::CloseFiles()

   oBmp:End()

RETURN ( Self )

//---------------------------------------------------------------------------//
/*Método con las acciones del botón siguiente*/

METHOD BotonSiguiente()

   do case
      case ::oFld:nOption == 1

         if Empty( ::cDirOrigen )
            MsgStop( "El archivo origen no puede estar vacío" )
            Return .f.
         end if

         ::oFld:GoNext()

         ::ImportaHoja()

      case ::oFld:nOption == 2

         ::oDlg:End()

   end case

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD ImportaHoja()

   local n
   local nIva
   local nCosto
   local pVenta
   local oBlock
   local oError
   local cCodArt
   local cNomArt
   local cCodBar
   local cCodNew
   local hFilTxt
   local nUniCaja
   local oOleExcel
   local cCodGFamilia
   local cCodFamilia
   local cGrupoFamilia
   local cFamilia
   local nLinesBlank := 0
   local cNewFam     := Space( 8 )
   local cNewGrpFam  := Space( 3 )

   /*
   Ponemos el boton de cancelar------------------------------------------------
   */

   SetWindowText( ::oBtnSiguiente:hWnd, "Procesando..." )

   ::oDlg:Disable()

   /*
   Manejador de errores--------------------------------------------------------
   */

   /*oBlock            := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE*/

   /*
   Creamos un fichero de texto para hacer un log de lo que exportemos----------
   */

   ::cFilTxt    := cGetNewFileName( cPatLog() + "IMP" + Dtos( Date() ) + StrTran( Time(), ":", "" ) ) + ".txt"
   hFilTxt      := fCreate( ::cFilTxt )

   if Empty( hFilTxt )
      hFilTxt        := fOpen( ::cFilTxt, 1 )
   endif

   if File( ::cDirOrigen )

      fWrite( hFilTxt, "Procesando " + ::cDirOrigen + CRLF )

      ::oTreeFile    := ::oTree:Add( "Procesando " + ::cDirOrigen )
      ::oTreeFile:Expand()

      /*
      Creamos el objeto oleexcel y abrimos la hoja de calculo---
      */


      oOleExcel                        := TOleExcel():New( "Importando hoja de excel", "Conectando...", .f. )

      oOleExcel:oExcel:Visible         := .f.
      oOleExcel:oExcel:DisplayAlerts   := .f.
      oOleExcel:oExcel:WorkBooks:Open( ::cDirOrigen )

      oOleExcel:oExcel:WorkSheets( 1 ):Activate()   //Hojas de la hoja de calculo

      /*
      Nos movemos por las columnas---------------------------------------------
      */

      ::oMtrProceso:SetTotal( 65536 )

      SysRefresh()

      for n := 2 to 65536

         if !Empty( ::cColCodArt )
            cCodArt     := Padr( oOleExcel:oExcel:ActiveSheet:Range( ::cColCodArt + lTrim( Str( n ) ) ):Value, 18 )
         end if
         cCodArt        := Alltrim( cValToChar( cCodArt ) )

         if !Empty( ::cColNomArt )
            cNomArt     := oOleExcel:oExcel:ActiveSheet:Range( ::cColNomArt + lTrim( Str( n ) ) ):Value
         end if
         cNomArt        := AllTrim( cValToChar( cNomArt ) )

         /*
         Cogemos el código de barras
         */

         if !Empty( ::cColCodBar )
            cCodBar     := oOleExcel:oExcel:ActiveSheet:Range( ::cColCodBar + lTrim( Str( n ) ) ):Value
         end if
         cCodBar        := AllTrim( cValToChar( cCodBar ) )


         if !Empty( ::cColpVenta )
            pVenta      := oOleExcel:oExcel:ActiveSheet:Range( ::cColpVenta + lTrim( Str( n ) ) ):Value
         end if

         if Empty( pVenta )
            pVenta      := 0
         end if

         if Valtype( pVenta ) == "C"   //Comprobamos que obtengamos un número, pq la tarifa nueva está mal picada
            pVenta      := Val( StrTran( pVenta, ",", "." ) )
         end if

         if !Empty( ::cColpCosto )
            nCosto      := oOleExcel:oExcel:ActiveSheet:Range( ::cColpCosto + lTrim( Str( n ) ) ):Value
         end if

         /*if Empty( nCosto )
            nCosto      := 0
         end if*/

         //?Valtype( nCosto )

         do case
            case Valtype( nCosto ) == "C"

               nCosto      := Val( StrTran( nCosto, ",", "." ) )

            case Valtype( nCosto ) != "N"

               nCosto      := 0

         end case



         /*if Valtype( nCosto ) == "C"   //Comprobamos que obtengamos un número, pq la tarifa nueva está mal picada
            nCosto      := Val( StrTran( nCosto, ",", "." ) )
            ?nCosto
         else
            ?"2"
            nCosto      := 0
         end if*/

         if !Empty( ::cColUniCaj )
            nUniCaja    := oOleExcel:oExcel:ActiveSheet:Range( ::cColUniCaj + lTrim( Str( n ) ) ):Value
         end if

         if Empty( nUniCaja )
            nUniCaja    := 0
         end if

         if Valtype( nUniCaja ) == "C"   //Comprobamos que obtengamos un número, pq la tarifa nueva está mal picada
            nUniCaja    := Val( StrTran( nUniCaja, ",", "." ) )
         end if

         if !Empty( ::cColGFamilia )
            cGrupoFamilia  := oOleExcel:oExcel:ActiveSheet:Range( ::cColGFamilia + lTrim( Str( n ) ) ):Value
         end if

         cGrupoFamilia  := Alltrim( cValToChar( cGrupoFamilia ) )

         if !Empty( ::cColFamilia )
            cFamilia    := oOleExcel:oExcel:ActiveSheet:Range( ::cColFamilia + lTrim( Str( n ) ) ):Value
         end if

         cFamilia       := Alltrim( cValToChar( cFamilia ) )

         nIva           := nIva( ::oDbfIva, cDefIva() ) / 100

         if !Empty( cCodArt )

            nLinesBlank := 0

            if pVenta == 0

               fWrite( hFilTxt, "No incluido: " + AllTrim( cCodArt ) + " - " + AllTrim( cNomArt ) + ", por no tener precio de venta" + CRLF )
               ::oTree:Select( ::oTreeFile:Add( "No incluido: " + AllTrim( cCodArt ) + " - " + AllTrim( cNomArt ) + ", por no tener precio de venta" ) )

            else

               /*
               Tratamos las familias y subfamilias
               */

               if Empty( cFamilia )

                  fWrite( hFilTxt, "El artículo " + AllTrim( cCodArt ) + " - " + AllTrim( cNomArt ) + "no tiene familia" + CRLF )
                  ::oTree:Select( ::oTreeFile:Add( "El artículo " + AllTrim( cCodArt ) + " - " + AllTrim( cNomArt ) + "no tiene familia" ) )

               else

                  /*
                  Añadimos el grupo de familia si no existe
                  */

                  if !::oGrpFam:SeekInOrd( Upper( Padr( cGrupoFamilia, 30 ) ), "CNOMGRP" )

                     cNewGrpFam           := RJust( NextVal( dbLast( ::oGrpFam, 1 ) ), "0", 3 )

                     ::oGrpFam:Append()

                     ::oGrpFam:cCodGrp    := cNewGrpFam
                     ::oGrpFam:cNomGrp    := Upper( Padr( cGrupoFamilia, 30 ) )
                     ::oGrpFam:lPubInt    := .f.

                     ::oGrpFam:Save()

                     fWrite( hFilTxt, "Añadido grupo de familia " + AllTrim( cNewGrpFam ) + " - " + AllTrim( Upper( cGrupoFamilia ) ) + CRLF )
                     ::oTree:Select( ::oTreeFile:Add( "Añadido grupo de familia " + AllTrim( cNewGrpFam ) + " - " + AllTrim( Upper( cGrupoFamilia ) ) ) )

                  else

                     cNewGrpFam           := ::oGrpFam:cCodGrp

                  end if

                  /*
                  Añadimos el grupo de familias si no existe
                  */

                  if !::oDbfFam:SeekInOrd( Upper( Padr( cFamilia, 40 ) ), "CNOMFAM" )

                     cNewFam              := RJust( NextVal( Rtrim( dbLast( ::oDbfFam, 1 ) ) ), "0", 8 )

                     ::oDbfFam:Append()

                     ::oDbfFam:cCodFam    := cNewFam
                     ::oDbfFam:cNomFam    := Upper( Padr( cFamilia, 40 ) )
                     ::oDbfFam:cCodGrp    := cNewGrpFam
                     ::oDbfFam:lIncTpv    := .f.
                     ::oDbfFam:lPubInt    := .f.

                     ::oDbfFam:Save()

                     fWrite( hFilTxt, "Añadida familia: " + AllTrim( cNewFam ) + " - " + AllTrim( Upper( cFamilia ) ) + CRLF )
                     ::oTree:Select( ::oTreeFile:Add( "Añadida familia: " + AllTrim( cNewFam ) + " - " + AllTrim( Upper( cFamilia ) ) ) )

                  else

                     cNewFam           := ::oDbfFam:cCodFam

                  end if


               end if


               /*
               Marcamos como obsoleto si lo tenemos creado con código de barras
               */

               if !Empty( cCodBar )

                  ::oDbfArt:Gotop()

                  if ::oDbfArt:SeekInOrd( cCodBar, "Codigo" )

                     if !::oDbfArt:lObs

                        ::oDbfArt:Load()

                        ::oDbfArt:lNevObs  := .f.
                        ::oDbfArt:lObs     := .t.

                        ::oDbfArt:Save()

                        fWrite( hFilTxt, AllTrim( ::oDbfArt:Codigo ) + " - " + AllTrim( ::oDbfArt:Nombre ) + " marcado como obsoleto " + CRLF )

                        ::oTree:Select( ::oTreeFile:Add( AllTrim( ::oDbfArt:Codigo ) + " - " + AllTrim( ::oDbfArt:Nombre ) + " marcado como obsoleto " ) )

                     end if

                  end if

               end if

               if !::oDbfArt:Seek( cCodArt )

                  /*
                  Añadimos el artículo
                  */

                  ::oDbfArt:Append()

                  ::oDbfArt:Codigo     := cCodArt
                  ::oDbfArt:Nombre     := cNomArt
                  ::oDbfArt:cUnidad    := "UD"
                  ::oDbfArt:nLabel     := 1
                  ::oDbfArt:nCtlStock  := 1
                  ::oDbfArt:lLote      := .f.
                  ::oDbfArt:TipoIva    := cDefIva()

                  if ValType( nUniCaja ) != "N"
                     ::oDbfArt:nUniCaja   := Val( nUniCaja )
                  else
                     ::oDbfArt:nUniCaja   := nUniCaja
                  end if

                  ::oDbfArt:Familia    := cNewFam

                  if !Empty( cCodBar )

                     cCodNew                    := cCodBar

                     while .t.

                        ::oDbfArt:CodeBar       := cCodNew
                        ::oDbfArt:nTipBar       := 1

                        ::oDbfCodeBar:Append()
                        ::oDbfCodeBar:cCodArt   := cCodArt
                        ::oDbfCodeBar:cCodBar   := cCodNew
                        ::oDbfCodeBar:nTipBar   := 1
                        ::oDbfCodeBar:lDefBar   := .t.
                        ::oDbfCodeBar:Save()

                        if SubStr( cCodNew, 1, 1 ) == "0"
                           cCodNew              := SubStr( cCodNew, 2 )
                        else
                           exit
                        end if

                     end while

                  else

                     ::oDbfArt:CodeBar       := Space( 18 )
                     ::oDbfArt:nTipBar       := 1

                  end if

                  // Precios y beneficios

                  ::oDbfArt:pCosto     := nCosto

                  do case
                     case ::oCmbTar:nAt == 1

                           if nCosto != 0
                              ::oDbfArt:Benef1  := ( Div( pVenta, nCosto ) - 1 ) * 100
                           end if

                           ::oDbfArt:lBnf1      := .f.
                           ::oDbfArt:nBnfSbr1   := 1
                           ::oDbfArt:pVenta1    := pVenta
                           ::oDbfArt:pVtaIva1   := ( ::oDbfArt:pVenta1 * nIva ) + ::oDbfArt:pVenta1

                     case ::oCmbTar:nAt == 2

                           if nCosto != 0
                              ::oDbfArt:Benef2  := ( Div( pVenta, nCosto ) - 1 ) * 100
                           end if

                           ::oDbfArt:lBnf2      := .f.
                           ::oDbfArt:nBnfSbr2   := 1
                           ::oDbfArt:pVenta2    := pVenta
                           ::oDbfArt:pVtaIva2   := ( ::oDbfArt:pVenta2 * nIva ) + ::oDbfArt:pVenta2

                     case ::oCmbTar:nAt == 3

                           if nCosto != 0
                              ::oDbfArt:Benef3  := ( Div( pVenta, nCosto ) - 1 ) * 100
                           end if

                           ::oDbfArt:lBnf3      := .f.
                           ::oDbfArt:nBnfSbr3   := 1
                           ::oDbfArt:pVenta3    := pVenta
                           ::oDbfArt:pVtaIva3   := ( ::oDbfArt:pVenta3 * nIva ) + ::oDbfArt:pVenta3

                     case ::oCmbTar:nAt == 4

                           if nCosto != 0
                              ::oDbfArt:Benef4  := ( Div( pVenta, nCosto ) - 1 ) * 100
                           end if

                           ::oDbfArt:lBnf4      := .f.
                           ::oDbfArt:nBnfSbr4   := 1
                           ::oDbfArt:pVenta4    := pVenta
                           ::oDbfArt:pVtaIva4   := ( ::oDbfArt:pVenta4 * nIva ) + ::oDbfArt:pVenta4

                     case ::oCmbTar:nAt == 5

                           if nCosto != 0
                              ::oDbfArt:Benef5  := ( Div( pVenta, nCosto ) - 1 ) * 100
                           end if

                           ::oDbfArt:lBnf5      := .f.
                           ::oDbfArt:nBnfSbr5   := 1
                           ::oDbfArt:pVenta5    := pVenta
                           ::oDbfArt:pVtaIva5   := ( ::oDbfArt:pVenta5 * nIva ) + ::oDbfArt:pVenta5

                     case ::oCmbTar:nAt == 6

                           if nCosto != 0
                              ::oDbfArt:Benef6  := ( Div( pVenta, nCosto ) - 1 ) * 100
                           end if

                           ::oDbfArt:lBnf6      := .f.
                           ::oDbfArt:nBnfSbr6   := 1
                           ::oDbfArt:pVenta6    := pVenta
                           ::oDbfArt:pVtaIva6   := ( ::oDbfArt:pVenta6 * nIva ) + ::oDbfArt:pVenta6

                  end case

                  ::oDbfArt:Save()

                  fWrite( hFilTxt, "Añadido artículo " + AllTrim( cCodArt ) + " - " + AllTRim( cNomArt ) + CRLF )
                  ::oTree:Select( ::oTreeFile:Add( "Añadido artículo " + AllTrim( cCodArt ) + " - " + AllTRim( cNomArt ) ) )

               else

                  /*
                  Reemplazamos el artículo-------------------------------------
                  */

                  ::oDbfArt:Load()

                  if ValType( nUniCaja ) != "N"
                     ::oDbfArt:nUniCaja   := Val( nUniCaja )
                  else
                     ::oDbfArt:nUniCaja   := nUniCaja
                  end if
                  ::oDbfArt:Familia       := cNewFam

                  /*
                  Códigos de barras--------------------------------------------
                  */

                  if !Empty( cCodBar ) .and. Rtrim( ::oDbfArt:CodeBar ) != Rtrim( cCodBar )

                     ::oDbfArt:CodeBar    := cCodBar
                     ::oDbfArt:nTipBar    := 1

                     if ::oDbfCodeBar:Seek( cCodArt )

                        while ::oDbfCodeBar:cCodArt == cCodArt .and. !::oDbfCodeBar:Eof()

                           ::oDbfCodeBar:Load()
                           ::oDbfCodeBar:lDefBar   := .f.
                           ::oDbfCodeBar:Save()

                           ::oDbfCodeBar:Skip()

                        end while

                     end if

                     ::oDbfCodeBar:Append()

                     ::oDbfCodeBar:cCodArt   := cCodArt
                     ::oDbfCodeBar:cCodBar   := cCodBar
                     ::oDbfCodeBar:nTipBar   := 1
                     ::oDbfCodeBar:lDefBar   := .t.

                     ::oDbfCodeBar:Save()

                  end if

                  /*
                  Precios y beneficios-----------------------------------------
                  */

                  ::oDbfArt:pCosto        := nCosto

                  do case
                     case ::oCmbTar:nAt == 1

                           if nCosto != 0
                              ::oDbfArt:Benef1  := ( Div( pVenta, nCosto ) - 1 ) * 100
                           end if

                           ::oDbfArt:lBnf1      := .f.
                           ::oDbfArt:pVenta1    := pVenta
                           ::oDbfArt:pVtaIva1   := ( ::oDbfArt:pVenta1 * nIva ) + ::oDbfArt:pVenta1

                     case ::oCmbTar:nAt == 2

                           if nCosto != 0
                              ::oDbfArt:Benef2  := ( Div( pVenta, nCosto ) - 1 ) * 100
                           end if

                           ::oDbfArt:lBnf2      := .f.
                           ::oDbfArt:pVenta2    := pVenta
                           ::oDbfArt:pVtaIva2   := ( ::oDbfArt:pVenta2 * nIva ) + ::oDbfArt:pVenta2

                     case ::oCmbTar:nAt == 3

                           if nCosto != 0
                              ::oDbfArt:Benef3  := ( Div( pVenta, nCosto ) - 1 ) * 100
                           end if

                           ::oDbfArt:lBnf3      := .f.
                           ::oDbfArt:pVenta3    := pVenta
                           ::oDbfArt:pVtaIva3   := ( ::oDbfArt:pVenta3 * nIva ) + ::oDbfArt:pVenta3

                     case ::oCmbTar:nAt == 4

                           if nCosto != 0
                              ::oDbfArt:Benef4  := ( Div( pVenta, nCosto ) - 1 ) * 100
                           end if

                           ::oDbfArt:lBnf4      := .f.
                           ::oDbfArt:pVenta4    := pVenta
                           ::oDbfArt:pVtaIva4   := ( ::oDbfArt:pVenta4 * nIva ) + ::oDbfArt:pVenta4

                     case ::oCmbTar:nAt == 5

                           if nCosto != 0
                              ::oDbfArt:Benef5  := ( Div( pVenta, nCosto ) - 1 ) * 100
                           end if

                           ::oDbfArt:lBnf5      := .f.
                           ::oDbfArt:pVenta5    := pVenta
                           ::oDbfArt:pVtaIva5   := ( ::oDbfArt:pVenta5 * nIva ) + ::oDbfArt:pVenta5

                     case ::oCmbTar:nAt == 6

                           if nCosto != 0
                              ::oDbfArt:Benef6  := ( Div( pVenta, nCosto ) - 1 ) * 100
                           end if

                           ::oDbfArt:lBnf6      := .f.
                           ::oDbfArt:pVenta6    := pVenta
                           ::oDbfArt:pVtaIva6   := ( ::oDbfArt:pVenta6 * nIva ) + ::oDbfArt:pVenta6

                  end case

                  ::oDbfArt:Save()

                  fWrite( hFilTxt, "Reemplazado artículo " + AllTrim( cCodArt ) + " - " + AllTRim( cNomArt ) + CRLF )
                  ::oTree:Select( ::oTreeFile:Add( "Reemplazado artículo " + AllTrim( cCodArt ) + " - " + AllTRim( cNomArt ) ) )

               end if

            end if

         else

            ++nLinesBlank

         end if

         ::oMtrProceso:Set( n )

         SysRefresh()

         if nLinesBlank > 100
            exit
         end if

      next

      ::oMtrProceso:Set( 65536 )

      /*
      Cerramos la hoja de calculos y destruimos el objeto oleexcel
      */

      oOleExcel:oExcel:WorkBooks:Close()

      oOleExcel:oExcel:Quit()

      oOleExcel:oExcel:DisplayAlerts := .t.

      oOleExcel:End()

   else

      fWrite( hFilTxt, "El fichero seleccionado para importar no es válido" )
      ::oTreeFile    := ::oTree:Add( "El fichero seleccionado para importar no es válido" )

   end if

   /*
   Cerramos el archivo log
   */

   fClose( hFilTxt )

   /*
   Cerrando el control de errores-------------------------------------------
   */

   /*RECOVER USING oError

      msgStop( "Error en el proceso de importación" + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )*/

   /*
   Boton de cerrar-------------------------------------------------------------
   */

   ::oDlg:Enable()

   SetWindowText( ::oBtnSiguiente:hWnd, "&Cerrar" )

   ::oBtnImprimir:Show()

RETURN ( Self )

//---------------------------------------------------------------------------//
/*
Guarga la familia y la categoria en cIniEmpresa()
*/

METHOD GuardarValoresIni()

   local oIniApp
   local cIniApp  := cIniEmpresa()

   INI oIniApp FILE cIniApp

      SET SECTION  "Importacion" ENTRY "Tarifa"      TO ::cCmbTar       OF oIniApp
      SET SECTION  "Importacion" ENTRY "CodArt"      TO ::cColCodArt    OF oIniApp
      SET SECTION  "Importacion" ENTRY "NomArt"      TO ::cColNomArt    OF oIniApp
      SET SECTION  "Importacion" ENTRY "CodBar"      TO ::cColCodBar    OF oIniApp
      SET SECTION  "Importacion" ENTRY "UniCaj"      TO ::cColUniCaj    OF oIniApp
      SET SECTION  "Importacion" ENTRY "pCosto"      TO ::cColpCosto    OF oIniApp
      SET SECTION  "Importacion" ENTRY "pVenta"      TO ::cColpVenta    OF oIniApp
      SET SECTION  "Importacion" ENTRY "GFamilia"    TO ::cColGFamilia  OF oIniApp
      SET SECTION  "Importacion" ENTRY "Familia"     TO ::cColFamilia   OF oIniApp

   ENDINI

RETURN ( Self )

//---------------------------------------------------------------------------//
/*
Carga la familia y la categoria desde cIniEmpresa()
*/

METHOD CargarValoresIni()

   local oIniApp
   local cIniApp  := cIniEmpresa()

   INI oIniApp FILE cIniApp

      GET ::cCmbTar        SECTION  "Importacion" ENTRY "Tarifa"     OF oIniApp DEFAULT "Tarifa 1"
      GET ::cColCodArt     SECTION  "Importacion" ENTRY "CodArt"     OF oIniApp DEFAULT "A"
      GET ::cColNomArt     SECTION  "Importacion" ENTRY "NomArt"     OF oIniApp DEFAULT "B"
      GET ::cColCodBar     SECTION  "Importacion" ENTRY "CodBar"     OF oIniApp DEFAULT "K"
      GET ::cColUniCaj     SECTION  "Importacion" ENTRY "UniCaj"     OF oIniApp DEFAULT "C"
      GET ::cColpCosto     SECTION  "Importacion" ENTRY "pCosto"     OF oIniApp DEFAULT "H"
      GET ::cColpVenta     SECTION  "Importacion" ENTRY "pVenta"     OF oIniApp DEFAULT "D"
      GET ::cColGFamilia   SECTION  "Importacion" ENTRY "GFamilia"   OF oIniApp DEFAULT "O"
      GET ::cColFamilia    SECTION  "Importacion" ENTRY "Familia"    OF oIniApp DEFAULT "P"

   ENDINI

RETURN ( Self )

//---------------------------------------------------------------------------//