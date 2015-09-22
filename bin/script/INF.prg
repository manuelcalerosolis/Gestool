/******************************************************************************
Script creado a Joaquin Infante, para crear y mandar el informe que necesita
******************************************************************************/

function InicioHRB()

   local cUrl
   local oUrl
   local oFtp
   local cHostFtp       := "80.34.189.190"
   local cUserFtp       := "amh_infante"
   local cPasswdFtp     := "B21230560"
   local lPassiveFtp    := .f.
   local oFile
   local oScript
   local cConfFile      := "c:\fw195\Gestool\bin\Infante.zip"
   local cTxtFile       := "c:\fw195\Gestool\bin\B21230560.txt"

   CursorWait()

   /*
   Si existe el fichero lo eliminamos para crear el nuevo----------------------
   */

   if File( cTxtFile )
      fErase( cTxtFile )
   end if

   /*
   Instanciamos la clase-------------------------------------------------------
   */

   oScript  := TExportaCompras():New()

   if !Empty( oScript )

      if oScript:OpenFiles()

         if oScript:lResource()

            /*
            Valores por defecto para crear el informe--------------------------
            */

            oScript:dIniInf                                 := ctod( "01/01/2000" )
            oScript:dFinInf                                 := GetSysDate()

            oScript:oGrupoFacturasCompras:Cargo:Todos       := .t.
            oScript:oGrupoFacturasCompras:Cargo:Desde       := ""
            oScript:oGrupoFacturasCompras:Cargo:Hasta       := ""

            oScript:oGrupoProveedor:Cargo:Todos             := .t.
            oScript:oGrupoProveedor:Cargo:Desde             := ""
            oScript:oGrupoProveedor:Cargo:Hasta             := ""

            oScript:oGrupoGProveedor:Cargo:Todos            := .t.
            oScript:oGrupoGProveedor:Cargo:Desde            := ""
            oScript:oGrupoGProveedor:Cargo:Hasta            := ""

            oScript:oGrupoArticulo:Cargo:Todos              := .t.
            oScript:oGrupoArticulo:Cargo:Desde              := ""
            oScript:oGrupoArticulo:Cargo:Hasta              := ""

            oScript:lSuprEspacios                           := .t.

            /*
            Cargamos la tabla de configuración del fichero---------------------
            */

            oScript:LoadConf( cConfFile )

            /*
            Lanzamos el diálogo y ejecutamos el proceso------------------------
            */

            if !Empty( oScript:oDlg )

               oScript:oDlg:bStart  := {|| StartDialog( oScript, cTxtFile ) }

               oScript:oDlg:Activate( , , , .t. )

            end if

         end if

      end if

      oScript:CloseFiles()

      /*
      Mandamos el fichero por FTP----------------------------------------------
      */

      if File( cTxtFile )

         if !empty( cHostFtp )

            cUrl                 := "ftp://" + cUserFtp + ":" + cPasswdFtp + "@" + cHostFtp

            oUrl               := TUrl():New( cUrl )
            oFTP               := TIPClientFTP():New( oUrl, .t. )
            oFTP:nConnTimeout  := 20000
            oFTP:bUsePasv      := lPassiveFtp

            lOpen                := oFTP:Open( cUrl )

            if !lOpen
               cStr              := "Could not connect to FTP server " + oURL:cServer
               if empty( oFTP:SocketCon )
                  cStr           += hb_eol() + "Connection not initialized"
               elseif hb_inetErrorCode( oFTP:SocketCon ) == 0
                  cStr           += hb_eol() + "Server response:" + " " + oFTP:cReply
               else
                  cStr           += hb_eol() + "Error in connection:" + " " + hb_inetErrorDesc( oFTP:SocketCon )
               endif 
               msgStop( cStr, "Error" )
            else

               //MANDAMOS EL FICHERO

               oFtp:UploadFile( cTxtFile )

               //CERRAMOS LA CONEXION

               if !empty( oFTP )
                  oFTP:Close()
               end if

            end if

         end if

      end if

   end if

   CursorWe()

return .t.

//---------------------------------------------------------------------------//

Function StartDialog( oScript, cTxtFile )

   oScript:oDlg:Disable()

   oScript:InitDialog()

   oScript:Exportacion( cTxtFile, .f. )

   oScript:oDlg:Enable()

   oScript:oDlg:End()

return .t.

//---------------------------------------------------------------------------//