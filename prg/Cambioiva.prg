#include "FiveWin.Ch"
#include "Factu.ch" 
#include "MesDbf.ch"
#include "Report.ch"
#include "XBrowse.ch"

//---------------------------------------------------------------------------//

CLASS TCambioDeIva

   DATA oDlg
   DATA oFld

   DATA lChangeIva
   DATA oBtnSiguiente
   DATA oBtnInforme
   DATA oBtnSalir
   DATA oTree
   DATA oMetMsg
   DATA oAni

   DATA oBrwEmp
   DATA aEmp

   DATA oDbfIva
   DATA oDbfEmpresa
   DATA oDbfUser
   DATA oDbfDlg
   DATA oDbfDiv

   DATA oDbfCli
   DATA oDbfArt
   DATA oArtDiv
   DATA oCliAtp

   DATA cFilTxt
   DATA hFilTxt

   METHOD Create()

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHOD OpenFilesEmpresa()

   METHOD CloseFilesEmpresa()

   METHOD BotonSiguiente()

   METHOD IniciarAsistente( oDlg )

   METHOD CambioTipoIva()

   METHOD CambioArticulos()

   METHOD CambioPropiedades()

   METHOD CambioAtipicas()

   METHOD lSalirAsistente()

ENDCLASS

//----------------------------------------------------------------------------//

METHOD Create() CLASS TCambioDeIva

   local oBmp
   local nMetMsg     := 0
   local acImages    := { "BAR_01" }
   local nLevel

   /*
   Comprobamos si hemos cambiado el tipo de iva--------------------------------
   */

   ::lChangeIva      := AllTrim( GetPvProfString( "ChangeIva21", "lChangeIva21", cValToChar( .f. ), FullCurDir() + "GstApolo.Ini" ) ) == ".T."

   if GetSysDate() < CtoD( "01/09/2012" )
      MsgStop( "No puede ejecutar el asistente para cambio de I.V.A. antes del día 01/09/2012" )
      Return nil
   end if

   if ::lChangeIva
      MsgStop( "Ya ha realizado el cambio de I.V.A." )
      Return nil
   end if

   /*
   Compruebo que el usuario tenga permisos para cambiar articulos--------------
   */

   nLevel            := nLevelUsr( "01014" )

   if ( nAnd( nLevel, ACC_APPD ) == 0 ) .or. ( nAnd( nLevel, ACC_EDIT ) == 0 )
      return nil
   end if

   /*
   Compruebo que el usuario tenga permisos para cambiar Tipos de Iva-----------
   */

   nLevel            := nLevelUsr( "01036" )

   if ( nAnd( nLevel, ACC_APPD ) == 0 ) .or. ( nAnd( nLevel, ACC_EDIT ) == 0 )
      return nil
   end if

   /*
   Comprueba si hay mas de un usuario------------------------------------------
   */

   if nUsrInUse() > 1
      return nil
   end if

   /*
   Marco como proceso exclusivo------------------------------------------------
   */

   ::aEmp         := {}

   TReindex():lCreateHandle()

   if !::OpenFiles()
      Return nil
   end if

   /*
   Cargamos las empresas----------------------------------------------------
   */

   while !::oDbfEmpresa:Eof()
      if !::oDbfEmpresa:lGrupo
         aAdd( ::aEmp, { ( cCodEmp() == ::oDbfEmpresa:CodEmp  ), ::oDbfEmpresa:CodEmp, ::oDbfEmpresa:cNombre } )
      end if
      ::oDbfEmpresa:Skip()
   end do

   DEFINE DIALOG ::oDlg RESOURCE "AssChangeIva"

   REDEFINE BITMAP oBmp;
      RESOURCE "AssCambioIva" ;
      ID       800 ;
      OF       ::oDlg

   REDEFINE PAGES ::oFld ;
      ID       100;
      OF       ::oDlg ;
      DIALOGS  "AssChangeIva_1", "AssChangeIva_2"

   /*
   Primera caja de diálogo--------------------------------------------------
   */

   ::oBrwEmp                        := IXBrowse():New( ::oFld:aDialogs[ 1 ] )

   ::oBrwEmp:bClrSel                := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
   ::oBrwEmp:bClrSelFocus           := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

   ::oBrwEmp:SetArray( ::aEmp )

   ::oBrwEmp:nMarqueeStyle          := 5
   ::oBrwEmp:lHScroll               := .f.

   ::oBrwEmp:CreateFromResource( 100 )

   with object ( ::oBrwEmp:aCols[ 1 ] )
      :cHeader       := "Se. Seleccionada"
      :bStrData      := {|| "" }
      :bEditValue    := {|| ::aEmp[ ::oBrwEmp:nArrayAt, 1 ] }
      :nWidth        := 20
      :SetCheck( { "Sel16", "Nil16" } )
   end with

   with object ( ::oBrwEmp:aCols[ 2 ] )
      :cHeader       := "Código"
      :bEditValue    := {|| ::aEmp[ ::oBrwEmp:nArrayAt, 2 ] }
      :nWidth        := 40
   end with

   with object ( ::oBrwEmp:aCols[ 3 ] )
      :cHeader       := "Empresa"
      :bEditValue    := {|| ::aEmp[ ::oBrwEmp:nArrayAt, 3 ] }
      :nWidth        := 520
   end with

   ::oBrwEmp:bLDblClick   := {|| ::aEmp[ ::oBrwEmp:nArrayAt, 1 ] := !::aEmp[ ::oBrwEmp:nArrayAt, 1 ], ::oBrwEmp:Refresh() }

   REDEFINE BUTTON ;
      ID       500 ;
      OF       ::oFld:aDialogs[ 1 ] ;
      ACTION   ( ::aEmp[ ::oBrwEmp:nArrayAt, 1 ] := !::aEmp[ ::oBrwEmp:nArrayAt, 1 ], ::oBrwEmp:Refresh() )

   REDEFINE BUTTON ;
      ID       501 ;
      OF       ::oFld:aDialogs[ 1 ] ;
      ACTION   ( aEval( ::aEmp, { |aItem| aItem[ 1 ] := .t. } ), ::oBrwEmp:Refresh() )

   REDEFINE BUTTON ;
      ID       502 ;
      OF       ::oFld:aDialogs[ 1 ] ;
      ACTION   ( aEval( ::aEmp, { |aItem| aItem[ 1 ] := .f. } ), ::oBrwEmp:Refresh() )

   /*
   Segunda caja de diálogo
   */

   ::oTree    := TTreeView():Redefine( 100, ::oFld:aDialogs[ 2 ] )

   ::oMetMsg  := TApoloMeter():ReDefine( 120, { | u | if( pCount() == 0, nMetMsg, nMetMsg := u ) }, 10, ::oFld:aDialogs[ 2 ], .f., , , .t., rgb( 255,255,255 ), , rgb( 128,255,0 ) )

   ::oAni     := TAnimat():Redefine( ::oFld:aDialogs[ 2 ], 130, acImages, 1 )

   REDEFINE BUTTON ::oBtnSiguiente;
      ID       500 ;
      OF       ::oDlg ;
      ACTION   ( ::BotonSiguiente() )

   REDEFINE BUTTON ::oBtnSalir ;
      ID       550 ;
      OF       ::oDlg ;
      ACTION   ( ::lSalirAsistente(), ::oDlg:End() )

   REDEFINE BUTTON ::oBtnInforme ;
      ID       600 ;
      OF       ::oDlg ;
      ACTION   ( if( File( AllTrim( ::cFilTxt ) ), WinExec( "notepad.exe " + AllTrim( ::cFilTxt ) ), ) )

   ::oDlg:bStart := {|| ::oBtnInforme:Disable() }

   ACTIVATE DIALOG ::oDlg CENTER

   ::CloseFiles()

   oBmp:End()

   /*
   Libero el proceso exclusivo----------------------------------------------
   */

   TReindex():lCloseHandle()

RETURN ( Self )

//---------------------------------------------------------------------------//

Method BotonSiguiente()

   local i
   local cText := ""

   /*
   Compruebo que haya seleccionado alguna empresa------------------------------
   */

   for i := 1 to Len( ::aEmp )
      if ::aEmp[ i, 1 ]
         cText += AllTrim( ::aEmp[ i, 2 ] ) + " - " + AllTrim( ::aEmp[ i, 3 ] ) + CRLF
      end if
   next

   /*
   Comprobaciones antes de lanzar el asistente---------------------------------
   */

   if !Empty( cText )

      if ApoloMsgNoYes( "Va a proceder al cambio de " + cImp() + " a las empresas siguientes:" + CRLF + cText, "¿Desea continuar?" )

         ::oFld:GoNext()
         SetWindowText( ::oBtnSiguiente:hWnd, "Procesando..." )
         ::IniciarAsistente()

      else

         return nil

      end if

   else

      msgStop( "Tiene que seleccionar alguna empresa para comenzar el asistente" )

      return nil

   end if

return ( Self )

//---------------------------------------------------------------------------//

METHOD OpenFiles() CLASS TCambioDeIva

   local lOpen          := .t.
   local oError
   local oBlock         := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

   DATABASE NEW ::oDbfIva     PATH ( cPatDat() )   FILE "TIVA.DBF"      VIA ( cDriver() ) SHARED INDEX "TIVA.CDX"

   DATABASE NEW ::oDbfEmpresa PATH ( cPatDat() )   FILE "EMPRESA.DBF"   VIA ( cDriver() ) SHARED INDEX "EMPRESA.CDX"

   DATABASE NEW ::oDbfDlg     PATH ( cPatDat() )   FILE "DELEGA.DBF"    VIA ( cDriver() ) SHARED INDEX "DELEGA.CDX"

   DATABASE NEW ::oDbfUser    PATH ( cPatDat() )   FILE "USERS.DBF"     VIA ( cDriver() ) SHARED INDEX "USERS.CDX"

   DATABASE NEW ::oDbfDiv     PATH ( cPatDat() )   FILE "DIVISAS.DBF"   VIA ( cDriver() ) SHARED INDEX "DIVISAS.CDX"

   RECOVER USING oError

      lOpen             := .f.
      msgStop( "Imposible abrir todas las bases de datos" + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

   if !lOpen
      ::CloseFiles()
   end if

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD CloseFiles() CLASS TCambioDeIva

   if ::oDbfIva != nil .and. ::oDbfIva:Used()
      ::oDbfIva:End()
   end if

   if ::oDbfEmpresa != nil .and. ::oDbfEmpresa:Used()
      ::oDbfEmpresa:End()
   end if

   if ::oDbfUser != nil .and. ::oDbfUser:Used()
      ::oDbfUser:End()
   end if

   if ::oDbfDlg != nil .and. ::oDbfDlg:Used()
      ::oDbfDlg:End()
   end if

   if ::oDbfDiv != nil .and. ::oDbfDiv:Used()
      ::oDbfDiv:End()
   end if

   if !Empty( ::oTree )
      ::oTree:End()
   end if

   if !Empty( ::oAni )
      ::oAni:End()
   end if

   ::oDbfIva   := nil
   ::oTree     := nil
   ::oDbfUser  := nil
   ::oDbfDlg   := nil
   ::oAni      := nil
   ::oDbfDiv   := nil

Return ( Self )

//---------------------------------------------------------------------------//

METHOD IniciarAsistente( oDlg ) CLASS TCambioDeIva

   local oItem
   local i
   local cEmpActiva     := cCodEmp()
   local cGrupoEmpresa  := Space(2)

   ::oBtnSiguiente:Disable()
   ::oBtnSalir:Disable()

   ::cFilTxt    := cGetNewFileName( cPatLog() + "CAMBIVA" + Dtos( Date() ) + StrTran( Time(), ":", "" ) ) + ".txt"
   ::hFilTxt    := fCreate( ::cFilTxt )

   if Empty( ::hFilTxt )
      ::hFilTxt        := fOpen( ::cFilTxt, 1 )
   endif

   fWrite( ::hFilTxt, "Proceso iniciado: " + AllTrim( Dtoc( GetSysDate() ) ) + CRLF )

   ::oTree:DeleteAll()

   ::oTree:Select( ::oTree:Add( "Proceso iniciado " + AllTrim( Dtoc( GetSysDate() ) ) ) )

   /*
   Cambiamos los tipos de IVA--------------------------------------------------
   */

   ::CambioTipoIva()

   /*
   Nos movemos y seleccionamos las distintas empresas y grupos-----------------
   */

   ::oMetMsg:SetTotal( Len( ::aEmp ) )

   for i := 1 to Len( ::aEmp )

      if ::aEmp[ i, 1 ]

         /*
         Nos posicionamos en la empresa----------------------------------------
         */

         fWrite( ::hFilTxt, Space( 3 ) + "Nos posicionamos en la empresa " + AllTrim( ::aEmp[ i, 2 ] ) + " - " + AllTrim( ::aEmp[ i, 3 ] ) + CRLF )
         ::oTree:Select( ::oTree:Add( Space( 3 ) + "Nos posicionamos en la empresa " + AllTrim( ::aEmp[ i, 2 ] ) + " - " + AllTrim( ::aEmp[ i, 3 ] ) ) )

         SetEmpresa( ::aEmp[ i, 2 ], ::oDbfEmpresa:cAlias, ::oDbfDlg:cAlias, ::oDbfUser:cAlias )

         /*
         Realizamos una copia de seguridad-------------------------------------
         */

         fWrite( ::hFilTxt, Space( 3 ) + "Realizando copia de seguridad de la empresa " + AllTrim( ::aEmp[ i, 2 ] ) + " - " + AllTrim( ::aEmp[ i, 3 ] ) + CRLF )
         ::oTree:Select( ::oTree:Add( Space( 3 ) + "Realizando copia de seguridad de la empresa " + AllTrim( ::aEmp[ i, 2 ] ) + " - " + AllTrim( ::aEmp[ i, 3 ] ) ) )

         CompressEmpresa( ::aEmp[ i, 2 ] )

         if ::OpenFilesEmpresa()

            /*
            Cambiamos precios en artículos----------------------------------------------
            */

            ::CambioArticulos()

            /*
            Cambiamos precios por propiedades-------------------------------------------
            */

            ::CambioPropiedades()

            /*
            Cambiamos precios en atípicas de clientes-----------------------------------
            */

            ::CambioAtipicas()

         end if

         ::CloseFilesEmpresa()

         cGrupoEmpresa  := oRetFld( ::aEmp[ i, 2 ], ::oDbfEmpresa, "cCodGrp" )

         if !Empty( cGrupoEmpresa )

            /*
            Grupos de empresas----------------------------------------------------
            */

            fWrite( ::hFilTxt, Space( 3 ) + "Nos posicionamos en el grupo " + AllTrim( cGrupoEmpresa ) + " - " + AllTrim( oRetFld( cGrupoEmpresa, ::oDbfEmpresa, "cNombre" ) ) + CRLF )
            ::oTree:Select( ::oTree:Add( Space( 3 ) + "Nos posicionamos en el grupo " + AllTrim( cGrupoEmpresa ) + " - " + AllTrim( oRetFld( cGrupoEmpresa, ::oDbfEmpresa, "cNombre" ) ) ) )

            cPatCli( cGrupoEmpresa, nil, .f. )
            cPatArt( cGrupoEmpresa, nil, .f. )

            /*
            Realizamos una copia de seguridad-------------------------------------
            */

            fWrite( ::hFilTxt, Space( 3 ) + "Realizando copia de seguridad del grupo " + AllTrim( cGrupoEmpresa ) + " - " + AllTrim( oRetFld( cGrupoEmpresa, ::oDbfEmpresa, "cNombre" ) ) + CRLF )
            ::oTree:Select( ::oTree:Add( Space( 3 ) + "Realizando copia de seguridad del grupo " + AllTrim( cGrupoEmpresa ) + " - " + AllTrim( oRetFld( cGrupoEmpresa, ::oDbfEmpresa, "cNombre" ) ) ) )

            CompressGrupo( cGrupoEmpresa )

            if ::OpenFilesEmpresa()

               /*
               Cambiamos precios en artículos----------------------------------------------
               */

               ::CambioArticulos()

               /*
               Cambiamos precios por propiedades-------------------------------------------
               */

               ::CambioPropiedades()

               /*
               Cambiamos precios en atípicas de clientes-----------------------------------
               */

               ::CambioAtipicas()

            end if

            ::CloseFilesEmpresa()

         end if

      end if

      ::oMetMsg:AutoInc()

   next

   ::oMetMsg:AutoInc( Len( ::aEmp ) )

   /*
   Dejamos posicionado en la empresa que estabamos-----------------------------
   */

   fWrite( ::hFilTxt, "Seleccionando la empresa activa" + CRLF )

   ::oTree:Select( ::oTree:Add( "Seleccionando la empresa activa" ) )

   SetEmpresa( cEmpActiva, ::oDbfEmpresa:cAlias, ::oDbfDlg:cAlias, ::oDbfUser:cAlias )

   /*
   Marcamos en Gestion.ini para que no lance más el proceso--------------------
   */

   fWrite( ::hFilTxt, "Guardando configuración" + CRLF )

   ::oTree:Select( ::oTree:Add( "Guardando configuración" ) )

   ::lChangeIva      := .t.

   WritePProString( "ChangeIva21", "lChangeIva21", cValToChar( ::lChangeIva ), FullCurDir() + "GstApolo.Ini" )

   /*
   Cerramos el log para terminar el proceso------------------------------------
   */

   ::oBtnInforme:Enable()
   ::oBtnSalir:Enable()
   ::oAni:Hide()

   MsgInfo( "Proceso finalizado correctamente", "" )

   fWrite( ::hFilTxt, "Proceso finalizado correctamente" )

   ::oTree:Select( ::oTree:Add( "Proceso finalizado correctamente" ) )

   SetWindowText( ::oBtnSiguiente:hWnd, "Finalizado" )

   fClose( ::hFilTxt )

Return ( Self )

//---------------------------------------------------------------------------//

METHOD lSalirAsistente()

   if !::lChangeIva

      if !MsgYesNo( "¿Desea lanzar el asistente para el cambio de iva en un futuro?", "Elija una opción" )

         ::lChangeIva      := .t.

         WritePProString( "ChangeIva21", "lChangeIva21", cValToChar( ::lChangeIva ), FullCurDir() + "GstApolo.Ini" )

      end if

   end if

Return ( .t. )

//---------------------------------------------------------------------------//

METHOD CambioTipoIva() CLASS TCambioDeIva

   fWrite( ::hFilTxt,               Space( 3 ) + "Cambiando tipos de " + cImp() + CRLF )
   ::oTree:Select( ::oTree:Add(     Space( 3 ) + "Cambiando tipos de " + cImp() ) )

   if ::oDbfIva:Seek( "G" )

      ::oDbfIva:Load()
      ::oDbfIva:nOldIva := ::oDbfIva:TpIva
      ::oDbfIva:TpIva   := 21
      ::oDbfIva:nRecEq  := 5.2
      ::oDbfIva:DescIva := "General al 21%"
      ::oDbfIva:lSndDoc := .t.
      ::oDbfIva:Save()

      fWrite( ::hFilTxt,            Space( 6 ) + "Tipo de " + cImp() + " G - General, cambiado al 21%" + CRLF )

      ::oTree:Select( ::oTree:Add(  Space( 6 ) + "Tipo de " + cImp() + " G - General, cambiado al 21%" ) )

   end if

   if ::oDbfIva:Seek( "N" )

      ::oDbfIva:Load()
      ::oDbfIva:nOldIva := ::oDbfIva:TpIva
      ::oDbfIva:TpIva   := 10
      ::oDbfIva:nRecEq  := 1.4
      ::oDbfIva:DescIva := "Reducido al 10%"
      ::oDbfIva:lSndDoc := .t.
      ::oDbfIva:Save()

      fWrite( ::hFilTxt,            Space( 6 ) + "Tipo de " + cImp() + " N - Reducido, cambiado al 10%" + CRLF )

      ::oTree:Select( ::oTree:Add(  Space( 6 ) + "Tipo de " + cImp() + " N - Reducido, cambiado al 10%" ) )

   end if

Return ( Self )

//---------------------------------------------------------------------------//

METHOD OpenFilesEmpresa() CLASS TCambioDeIva

   local lOpen          := .t.
   local oError
   local oBlock         := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

   DATABASE NEW ::oDbfArt     PATH ( cPatArt() )   FILE "ARTICULO.DBF"  VIA ( cDriver() ) SHARED INDEX "ARTICULO.CDX"

   DATABASE NEW ::oArtDiv     PATH ( cPatArt() )   FILE "ARTDIV.DBF"    VIA ( cDriver() ) SHARED INDEX "ARTDIV.CDX"

   DATABASE NEW ::oDbfCli     PATH ( cPatCli() )   FILE "CLIENT.DBF"    VIA ( cDriver() ) SHARED INDEX "CLIENT.CDX"

   DATABASE NEW ::oCliAtp     PATH ( cPatCli() )   FILE "CLIATP.DBF"    VIA ( cDriver() ) SHARED INDEX "CLIATP.CDX"

   RECOVER USING oError

      lOpen             := .f.
      msgStop( "Imposible abrir todas las bases de datos" + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

   if !lOpen
      ::CloseFilesEmpresa()
   end if

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD CloseFilesEmpresa() CLASS TCambioDeIva

   if ::oDbfArt != nil .and. ::oDbfArt:Used()
      ::oDbfArt:End()
   end if

   if ::oArtDiv != nil .and. ::oArtDiv:Used()
      ::oArtDiv:End()
   end if

   if ::oDbfCli != nil .and. ::oDbfCli:Used()
      ::oDbfCli:End()
   end if

   if ::oCliAtp != nil .and. ::oCliAtp:Used()
      ::oCliAtp:End()
   end if

   ::oDbfArt   := nil
   ::oArtDiv   := nil
   ::oDbfCli   := nil
   ::oCliAtp   := nil

Return ( Self )

//---------------------------------------------------------------------------//

METHOD CambioArticulos() CLASS TCambioDeIva

   if !Empty( ::oDbfArt )

      fWrite( ::hFilTxt, "      Recalculando precios de artículos" + CRLF )
      ::oTree:Select( ::oTree:Add( "      Recalculando precios de artículos" ) )

      ::oDbfArt:GoTop()

      while !::oDbfArt:Eof()

         if !::oDbfArt:lObs

            ::oDbfArt:Load()

            if ::oDbfArt:pVenta1 != 0

               if ::oDbfArt:lIvaInc

                  ::oDbfArt:pVenta1       := nCalBas( ::oDbfArt:pVtaIva1, ::oDbfArt:lIvaInc, ::oDbfArt:TipoIva, ::oDbfArt:cCodImp )

               else

                  ::oDbfArt:pVtaIva1      := nCalIva( ::oDbfArt:pVenta1 , ::oDbfArt:lIvaInc, ::oDbfArt:TipoIva, ::oDbfArt:cCodImp )

                  if ::oDbfArt:lMarAju .and. !Empty( ::oDbfArt:cMarAju )
                     ::oDbfArt:pVtaIva1   := nAjuste( ::oDbfArt:pVtaIva1, ::oDbfArt:cMarAju )
                     ::oDbfArt:pVenta1    := nCalBas( ::oDbfArt:pVtaIva1, ::oDbfArt:lIvaInc, ::oDbfArt:TipoIva, ::oDbfArt:cCodImp )
                  end if

               end if

            end if

            if ::oDbfArt:pVenta2 != 0

               if ::oDbfArt:lIvaInc

                  ::oDbfArt:pVenta2    := nCalBas( ::oDbfArt:pVtaIva2, ::oDbfArt:lIvaInc, ::oDbfArt:TipoIva, ::oDbfArt:cCodImp )

               else

                  ::oDbfArt:pVtaIva2   := nCalIva( ::oDbfArt:pVenta2 , ::oDbfArt:lIvaInc, ::oDbfArt:TipoIva, ::oDbfArt:cCodImp )

                  if ::oDbfArt:lMarAju .and. !Empty( ::oDbfArt:cMarAju )
                     ::oDbfArt:pVtaIva2   := nAjuste( ::oDbfArt:pVtaIva2, ::oDbfArt:cMarAju )
                     ::oDbfArt:pVenta2    := nCalBas( ::oDbfArt:pVtaIva2, ::oDbfArt:lIvaInc, ::oDbfArt:TipoIva, ::oDbfArt:cCodImp )
                  end if

               end if


            end if

            if ::oDbfArt:pVenta3 != 0

               if ::oDbfArt:lIvaInc

                  ::oDbfArt:pVenta3    := nCalBas( ::oDbfArt:pVtaIva3, ::oDbfArt:lIvaInc, ::oDbfArt:TipoIva, ::oDbfArt:cCodImp )

               else

                  ::oDbfArt:pVtaIva3   := nCalIva( ::oDbfArt:pVenta3 , ::oDbfArt:lIvaInc, ::oDbfArt:TipoIva, ::oDbfArt:cCodImp )

                  if ::oDbfArt:lMarAju .and. !Empty( ::oDbfArt:cMarAju )
                     ::oDbfArt:pVtaIva3   := nAjuste( ::oDbfArt:pVtaIva3, ::oDbfArt:cMarAju )
                     ::oDbfArt:pVenta3    := nCalBas( ::oDbfArt:pVtaIva3, ::oDbfArt:lIvaInc, ::oDbfArt:TipoIva, ::oDbfArt:cCodImp )
                  end if

               end if

            end if

            if ::oDbfArt:pVenta4 != 0

               if ::oDbfArt:lIvaInc

                  ::oDbfArt:pVenta4    := nCalBas( ::oDbfArt:pVtaIva4, ::oDbfArt:lIvaInc, ::oDbfArt:TipoIva, ::oDbfArt:cCodImp )

               else

                  ::oDbfArt:pVtaIva4   := nCalIva( ::oDbfArt:pVenta4 , ::oDbfArt:lIvaInc, ::oDbfArt:TipoIva, ::oDbfArt:cCodImp )

                  if ::oDbfArt:lMarAju .and. !Empty( ::oDbfArt:cMarAju )
                     ::oDbfArt:pVtaIva4   := nAjuste( ::oDbfArt:pVtaIva4, ::oDbfArt:cMarAju )
                     ::oDbfArt:pVenta4    := nCalBas( ::oDbfArt:pVtaIva4, ::oDbfArt:lIvaInc, ::oDbfArt:TipoIva, ::oDbfArt:cCodImp )
                  end if

               end if

            end if

            if ::oDbfArt:pVenta5 != 0

               if ::oDbfArt:lIvaInc

                  ::oDbfArt:pVenta5    := nCalBas( ::oDbfArt:pVtaIva5, ::oDbfArt:lIvaInc, ::oDbfArt:TipoIva, ::oDbfArt:cCodImp )

               else

                  ::oDbfArt:pVtaIva5   := nCalIva( ::oDbfArt:pVenta5 , ::oDbfArt:lIvaInc, ::oDbfArt:TipoIva, ::oDbfArt:cCodImp )

                  if ::oDbfArt:lMarAju .and. !Empty( ::oDbfArt:cMarAju )
                     ::oDbfArt:pVtaIva5   := nAjuste( ::oDbfArt:pVtaIva5, ::oDbfArt:cMarAju )
                     ::oDbfArt:pVenta5    := nCalBas( ::oDbfArt:pVtaIva5, ::oDbfArt:lIvaInc, ::oDbfArt:TipoIva, ::oDbfArt:cCodImp )
                  end if

               end if

            end if

            if ::oDbfArt:pVenta6 != 0

               if ::oDbfArt:lIvaInc

                  ::oDbfArt:pVenta6    := nCalBas( ::oDbfArt:pVtaIva6, ::oDbfArt:lIvaInc, ::oDbfArt:TipoIva, ::oDbfArt:cCodImp )

               else

                  ::oDbfArt:pVtaIva6   := nCalIva( ::oDbfArt:pVenta6 , ::oDbfArt:lIvaInc, ::oDbfArt:TipoIva, ::oDbfArt:cCodImp )

                  if ::oDbfArt:lMarAju .and. !Empty( ::oDbfArt:cMarAju )
                     ::oDbfArt:pVtaIva6   := nAjuste( ::oDbfArt:pVtaIva6, ::oDbfArt:cMarAju )
                     ::oDbfArt:pVenta6    := nCalBas( ::oDbfArt:pVtaIva6, ::oDbfArt:lIvaInc, ::oDbfArt:TipoIva, ::oDbfArt:cCodImp )
                  end if

               end if

            end if

            ::oDbfArt:lSndDoc    := .t.
            ::oDbfArt:dFecChg    := GetSysDate()
            ::oDbfArt:cTimChg    := Time()

            ::oDbfArt:Save()

            fWrite( ::hFilTxt, Space( 8 ) + AllTrim( ::oDbfArt:Codigo ) + " - " + AllTrim( ::oDbfArt:Nombre ) + " actualizado correctamente" + CRLF )
            ::oTree:Select( ::oTree:Add( Space( 8 ) + AllTrim( ::oDbfArt:Codigo ) + " - " + AllTrim( ::oDbfArt:Nombre ) + " actualizado correctamente" ) )

         end if

         SysRefresh()

         ::oDbfArt:Skip()

      end while

   end if

Return ( Self )

//---------------------------------------------------------------------------//

METHOD CambioPropiedades() CLASS TCambioDeIva

   if !Empty( ::oArtDiv )

      fWrite( ::hFilTxt, "      Recalculando precios de propiedades" + CRLF )
      ::oTree:Select( ::oTree:Add( "      Recalculando precios de propiedades" ) )

      ::oArtDiv:GoTop()

      while !::oArtDiv:Eof()

         if ::oDbfArt:Seek( ::oArtDiv:cCodArt )

            ::oArtDiv:Load()

            if ::oArtDiv:nPreVta1 != 0

               if ::oDbfArt:lIvaInc

                  ::oArtDiv:nPreVta1      := nCalBas( ::oArtDiv:nPreIva1, ::oDbfArt:lIvaInc, ::oDbfArt:TipoIva, ::oDbfArt:cCodImp )

               else

                  ::oArtDiv:nPreIva1      := nCalIva( ::oArtDiv:nPreVta1 , ::oDbfArt:lIvaInc, ::oDbfArt:TipoIva, ::oDbfArt:cCodImp )

                  if ::oDbfArt:lMarAju .and. !Empty( ::oDbfArt:cMarAju )
                     ::oArtDiv:nPreIva1   := nAjuste( ::oArtDiv:nPreIva1, ::oDbfArt:cMarAju )
                     ::oArtDiv:nPreVta1   := nCalBas( ::oArtDiv:nPreIva1, ::oDbfArt:lIvaInc, ::oDbfArt:TipoIva, ::oDbfArt:cCodImp )
                  end if

               end if

            end if

            if ::oArtDiv:nPreVta2 != 0

               if ::oDbfArt:lIvaInc

                  ::oArtDiv:nPreVta2      := nCalBas( ::oArtDiv:nPreIva2, ::oDbfArt:lIvaInc, ::oDbfArt:TipoIva, ::oDbfArt:cCodImp )

               else

                  ::oArtDiv:nPreIva2      := nCalIva( ::oArtDiv:nPreVta2 , ::oDbfArt:lIvaInc, ::oDbfArt:TipoIva, ::oDbfArt:cCodImp )

                  if ::oDbfArt:lMarAju .and. !Empty( ::oDbfArt:cMarAju )
                     ::oArtDiv:nPreIva2   := nAjuste( ::oArtDiv:nPreIva2, ::oDbfArt:cMarAju )
                     ::oArtDiv:nPreVta2   := nCalBas( ::oArtDiv:nPreIva2, ::oDbfArt:lIvaInc, ::oDbfArt:TipoIva, ::oDbfArt:cCodImp )
                  end if

               end if

            end if

            if ::oArtDiv:nPreVta3 != 0

               if ::oDbfArt:lIvaInc

                  ::oArtDiv:nPreVta3      := nCalBas( ::oArtDiv:nPreIva3, ::oDbfArt:lIvaInc, ::oDbfArt:TipoIva, ::oDbfArt:cCodImp )

               else

                  ::oArtDiv:nPreIva3      := nCalIva( ::oArtDiv:nPreVta3 , ::oDbfArt:lIvaInc, ::oDbfArt:TipoIva, ::oDbfArt:cCodImp )

                  if ::oDbfArt:lMarAju .and. !Empty( ::oDbfArt:cMarAju )
                     ::oArtDiv:nPreIva3   := nAjuste( ::oArtDiv:nPreIva3, ::oDbfArt:cMarAju )
                     ::oArtDiv:nPreVta3   := nCalBas( ::oArtDiv:nPreIva3, ::oDbfArt:lIvaInc, ::oDbfArt:TipoIva, ::oDbfArt:cCodImp )
                  end if

               end if

            end if

            if ::oArtDiv:nPreVta4 != 0

               if ::oDbfArt:lIvaInc

                  ::oArtDiv:nPreVta4      := nCalBas( ::oArtDiv:nPreIva4, ::oDbfArt:lIvaInc, ::oDbfArt:TipoIva, ::oDbfArt:cCodImp )

               else

                  ::oArtDiv:nPreIva4      := nCalIva( ::oArtDiv:nPreVta4 , ::oDbfArt:lIvaInc, ::oDbfArt:TipoIva, ::oDbfArt:cCodImp )

                  if ::oDbfArt:lMarAju .and. !Empty( ::oDbfArt:cMarAju )
                     ::oArtDiv:nPreIva4   := nAjuste( ::oArtDiv:nPreIva4, ::oDbfArt:cMarAju )
                     ::oArtDiv:nPreVta4   := nCalBas( ::oArtDiv:nPreIva4, ::oDbfArt:lIvaInc, ::oDbfArt:TipoIva, ::oDbfArt:cCodImp )
                  end if

               end if

            end if

            if ::oArtDiv:nPreVta5 != 0

               if ::oDbfArt:lIvaInc

                  ::oArtDiv:nPreVta5      := nCalBas( ::oArtDiv:nPreIva5, ::oDbfArt:lIvaInc, ::oDbfArt:TipoIva, ::oDbfArt:cCodImp )

               else

                  ::oArtDiv:nPreIva5      := nCalIva( ::oArtDiv:nPreVta5 , ::oDbfArt:lIvaInc, ::oDbfArt:TipoIva, ::oDbfArt:cCodImp )

                  if ::oDbfArt:lMarAju .and. !Empty( ::oDbfArt:cMarAju )
                     ::oArtDiv:nPreIva5   := nAjuste( ::oArtDiv:nPreIva5, ::oDbfArt:cMarAju )
                     ::oArtDiv:nPreVta5   := nCalBas( ::oArtDiv:nPreIva5, ::oDbfArt:lIvaInc, ::oDbfArt:TipoIva, ::oDbfArt:cCodImp )
                  end if

               end if

            end if

            if ::oArtDiv:nPreVta6 != 0

               if ::oDbfArt:lIvaInc

                  ::oArtDiv:nPreVta6      := nCalBas( ::oArtDiv:nPreIva6, ::oDbfArt:lIvaInc, ::oDbfArt:TipoIva, ::oDbfArt:cCodImp )

               else

                  ::oArtDiv:nPreIva6      := nCalIva( ::oArtDiv:nPreVta6 , ::oDbfArt:lIvaInc, ::oDbfArt:TipoIva, ::oDbfArt:cCodImp )

                  if ::oDbfArt:lMarAju .and. !Empty( ::oDbfArt:cMarAju )
                     ::oArtDiv:nPreIva6   := nAjuste( ::oArtDiv:nPreIva6, ::oDbfArt:cMarAju )
                     ::oArtDiv:nPreVta6   := nCalBas( ::oArtDiv:nPreIva6, ::oDbfArt:lIvaInc, ::oDbfArt:TipoIva, ::oDbfArt:cCodImp )
                  end if

               end if

            end if

            ::oArtDiv:Save()

            fWrite( ::hFilTxt, Space( 8 ) + AllTrim( ::oArtDiv:cCodArt ) + " - " + AllTrim( ::oDbfArt:Nombre ) + " actualizado correctamente" + CRLF )
            ::oTree:Select( ::oTree:Add( Space( 8 ) + AllTrim( ::oArtDiv:cCodArt ) + " - " + AllTrim( ::oDbfArt:Nombre ) + " actualizado correctamente" ) )

         end if

         SysRefresh()

         ::oArtDiv:Skip()

      end while

   end if

Return ( Self )

//---------------------------------------------------------------------------//

METHOD CambioAtipicas() CLASS TCambioDeIva

   local nCosto   := 0

   if !Empty( ::oCliAtp )

      fWrite( ::hFilTxt, "      Recalculando precios de atípicas" + CRLF )
      ::oTree:Select( ::oTree:Add( "      Recalculando precios de atípicas" ) )

      ::oCliAtp:GoTop()

      while !::oCliAtp:Eof()

         if ::oCliAtp:nTipAtp < 2

            if ::oDbfArt:Seek( ::oCliAtp:cCodArt )

               nCosto   := if( ::oCliAtp:lPrcCom, ::oCliAtp:nPrcCom, ::oDbfArt:pCosto )

               ::oCliAtp:Load()

                  if ::oDbfArt:lIvaInc

                     ::oCliAtp:nPrcArt    := nCalBas( ::oCliAtp:nPreIva1, ::oDbfArt:lIvaInc, ::oDbfArt:TipoIva, ::oDbfArt:cCodImp )
                     ::oCliAtp:nPrcArt2   := nCalBas( ::oCliAtp:nPreIva2, ::oDbfArt:lIvaInc, ::oDbfArt:TipoIva, ::oDbfArt:cCodImp )
                     ::oCliAtp:nPrcArt3   := nCalBas( ::oCliAtp:nPreIva3, ::oDbfArt:lIvaInc, ::oDbfArt:TipoIva, ::oDbfArt:cCodImp )
                     ::oCliAtp:nPrcArt4   := nCalBas( ::oCliAtp:nPreIva4, ::oDbfArt:lIvaInc, ::oDbfArt:TipoIva, ::oDbfArt:cCodImp )
                     ::oCliAtp:nPrcArt5   := nCalBas( ::oCliAtp:nPreIva5, ::oDbfArt:lIvaInc, ::oDbfArt:TipoIva, ::oDbfArt:cCodImp )
                     ::oCliAtp:nPrcArt6   := nCalBas( ::oCliAtp:nPreIva6, ::oDbfArt:lIvaInc, ::oDbfArt:TipoIva, ::oDbfArt:cCodImp )

                  else

                     ::oCliAtp:nPreIva1   := nCalIva( ::oCliAtp:nPrcArt , ::oDbfArt:lIvaInc, ::oDbfArt:TipoIva, ::oDbfArt:cCodImp )

                     if ::oDbfArt:lMarAju .and. !Empty( ::oDbfArt:cMarAju )
                        ::oCliAtp:nPreIva1   := nAjuste( ::oCliAtp:nPreIva1, ::oDbfArt:cMarAju )
                        ::oCliAtp:nPrcArt    := nCalBas( ::oCliAtp:nPreIva1, ::oDbfArt:lIvaInc, ::oDbfArt:TipoIva, ::oDbfArt:cCodImp )
                     end if

                     ::oCliAtp:nPreIva2   := nCalIva( ::oCliAtp:nPrcArt2, ::oDbfArt:lIvaInc, ::oDbfArt:TipoIva, ::oDbfArt:cCodImp )

                     if ::oDbfArt:lMarAju .and. !Empty( ::oDbfArt:cMarAju )
                        ::oCliAtp:nPreIva2   := nAjuste( ::oCliAtp:nPreIva2, ::oDbfArt:cMarAju )
                        ::oCliAtp:nPrcArt2   := nCalBas( ::oCliAtp:nPreIva2, ::oDbfArt:lIvaInc, ::oDbfArt:TipoIva, ::oDbfArt:cCodImp )
                     end if

                     ::oCliAtp:nPreIva3   := nCalIva( ::oCliAtp:nPrcArt3, ::oDbfArt:lIvaInc, ::oDbfArt:TipoIva, ::oDbfArt:cCodImp )

                     if ::oDbfArt:lMarAju .and. !Empty( ::oDbfArt:cMarAju )
                        ::oCliAtp:nPreIva3   := nAjuste( ::oCliAtp:nPreIva3, ::oDbfArt:cMarAju )
                        ::oCliAtp:nPrcArt3   := nCalBas( ::oCliAtp:nPreIva3, ::oDbfArt:lIvaInc, ::oDbfArt:TipoIva, ::oDbfArt:cCodImp )
                     end if

                     ::oCliAtp:nPreIva4   := nCalIva( ::oCliAtp:nPrcArt4, ::oDbfArt:lIvaInc, ::oDbfArt:TipoIva, ::oDbfArt:cCodImp )

                     if ::oDbfArt:lMarAju .and. !Empty( ::oDbfArt:cMarAju )
                        ::oCliAtp:nPreIva4   := nAjuste( ::oCliAtp:nPreIva4, ::oDbfArt:cMarAju )
                        ::oCliAtp:nPrcArt4   := nCalBas( ::oCliAtp:nPreIva4, ::oDbfArt:lIvaInc, ::oDbfArt:TipoIva, ::oDbfArt:cCodImp )
                     end if

                     ::oCliAtp:nPreIva5   := nCalIva( ::oCliAtp:nPrcArt5, ::oDbfArt:lIvaInc, ::oDbfArt:TipoIva, ::oDbfArt:cCodImp )

                     if ::oDbfArt:lMarAju .and. !Empty( ::oDbfArt:cMarAju )
                        ::oCliAtp:nPreIva5   := nAjuste( ::oCliAtp:nPreIva5, ::oDbfArt:cMarAju )
                        ::oCliAtp:nPrcArt5   := nCalBas( ::oCliAtp:nPreIva5, ::oDbfArt:lIvaInc, ::oDbfArt:TipoIva, ::oDbfArt:cCodImp )
                     end if

                     ::oCliAtp:nPreIva6   := nCalIva( ::oCliAtp:nPrcArt6, ::oDbfArt:lIvaInc, ::oDbfArt:TipoIva, ::oDbfArt:cCodImp )

                     if ::oDbfArt:lMarAju .and. !Empty( ::oDbfArt:cMarAju )
                        ::oCliAtp:nPreIva6   := nAjuste( ::oCliAtp:nPreIva6, ::oDbfArt:cMarAju )
                        ::oCliAtp:nPrcArt6   := nCalBas( ::oCliAtp:nPreIva6, ::oDbfArt:lIvaInc, ::oDbfArt:TipoIva, ::oDbfArt:cCodImp )
                     end if

                  end if

               ::oCliAtp:Save()

               fWrite( ::hFilTxt, Space( 8 ) + AllTrim( ::oCliAtp:cCodArt ) + " - " + AllTrim( ::oDbfArt:Nombre ) + " actualizado correctamente" + CRLF )
               ::oTree:Select( ::oTree:Add( Space( 8 ) + AllTrim( ::oCliAtp:cCodArt ) + " - " + AllTrim( ::oDbfArt:Nombre ) + " actualizado correctamente" ) )

            end if

         end if

         if ::oDbfCli:Seek( ::oCliAtp:cCodCli )

            ::oDbfCli:Load()

            ::oDbfCli:lSndInt    := .t.
            ::oDbfCli:dFecChg    := GetSysDate()
            ::oDbfCli:cTimChg    := Time()

            ::oDbfCli:Save()

         end if

         SysRefresh()

         ::oCliAtp:Skip()

      end while

   end if

Return ( Self )

//---------------------------------------------------------------------------//