METHOD InitMod19( oDlg )

   local nHandle
   local cBuffer
   local cHeader
   local cBanCli
   local nImpRec
   local cCodCli
   local nTotImp  := 0
   local nTotRec  := 0
   local nTotLin  := 0
   local cPreMon  := if( cDivEmp() == "EUR", "5", "0" )

   oDlg:Disable()

   if file( Rtrim( ::cPatExp ) )
      fErase( Rtrim( ::cPatExp ) )
   end if

   nHandle        := fCreate( Rtrim( ::cPatExp ) )

   if nHandle > 0

      /*
      Cabecera de registro--------------------------------------------------------
      */

      cHeader  := ::oCtaRem:oDbf:cNifPre     // Nif del presentador
      cHeader  += ::oCtaRem:oDbf:cSufCta     // SubClave

      /*
      Datos del presentador-------------------------------------------------------
      */

      cBuffer  := cPreMon
      cBuffer  += "1"
      cBuffer  += "8"                        // Constante para el modelo 19
      cBuffer  += "0"                        // Numero de linea
      cBuffer  += cHeader                    // Cabecera
      cBuffer  += Left( Dtoc( ::dCarCta ), 2) + SubStr( Dtoc( ::dCarCta ), 4, 2 ) + Right( Dtoc( ::dCarCta ), 2 )
      cBuffer  += Space( 6 )                 // Libre
      cBuffer  += ::oCtaRem:oDbf:cNomPre     // Nombre
      cBuffer  += Space( 20 )                // Libre
      cBuffer  += ::oCtaRem:oDbf:cEntPre     // Entidad
      cBuffer  += ::oCtaRem:oDbf:cAgcPre     // Agencia
      cBuffer  := Padr( cBuffer, 162 )       // Para q llege a los 162 caracteres
      cBuffer  += CRLF

      fWrite( nHandle, cBuffer )
      nTotLin  ++

      /*
      Datos del propietario-------------------------------------------------------
      */

      cBuffer  := cPreMon
      cBuffer  += "3"                        // Cte para la empresa
      cBuffer  += "8"                        // Constante para el modelo 19
      cBuffer  += "0"                        // Numero de linea
      cBuffer  += cHeader                    // Cabecera
      cBuffer  += Left( Dtoc( ::dCarCta ), 2) + SubStr( Dtoc( ::dCarCta ), 4, 2 ) + Right( Dtoc( ::dCarCta ), 2 )
      cBuffer  += Left( Dtoc( ::dCarCta ), 2) + SubStr( Dtoc( ::dCarCta ), 4, 2 ) + Right( Dtoc( ::dCarCta ), 2 )
      cBuffer  += ::oCtaRem:oDbf:cNomPre     // Nombre de la empresa igual a del presentador
      cBuffer  += ::oCtaRem:oDbf:cEntBan     // Entidad
      cBuffer  += ::oCtaRem:oDbf:cAgcBan     // Agencia
      cBuffer  += ::oCtaRem:oDbf:cDgcBan     // Digito de control
      cBuffer  += ::oCtaRem:oDbf:cCtaBan     // Cuenta
      cBuffer  += Space( 8 )                 // Libre
      cBuffer  += "01"                       // Para la 19
      cBuffer  := Padr( cBuffer, 162 )       // Para q llege a los 162 caracteres
      cBuffer  += CRLF

      fWrite( nHandle, cBuffer )
      nTotLin  ++

      /*
      Traspaso de recibos------------------------------------------------------
      */

      if ::oDbfDet:Seek( Str( ::oDbf:nNumRem, 9 ) + ::oDbf:cSufRem )

         while Str( ::oDbf:nNumRem, 9 ) + ::oDbf:cSufRem == Str( ::oDbfDet:nNumRem ) + ::oDbfDet:cSufRem

            cCodCli        := ::oDbfDet:cCodCli

            if ::oClientes:Seek( cCodCli )
               cBanCli     := ::oClientes:Cuenta
            else
               cBanCli     := ""
            end if

            if !Empty( cBanCli )

               if ::lAgruparRecibos
                  nImpRec  := ::nAllRecCli( cCodCli )
               else
                  nImpRec  := nTotRecCli( ::oDbfDet, ::oDivisas:cAlias, cDivEmp() )
               end if

               nTotImp     += nImpRec
               nTotRec     ++

               cBuffer     := cPreMon
               cBuffer     += "6"                        // Constante para las lineas de recibos
               cBuffer     += "8"                        // Constante para el modelo 19
               cBuffer     += "0"                        // Numero de linea
               cBuffer     += cHeader                    // Cabecera
               cBuffer     += Right( AllTrim( ::oDbfDet:cCodCli ), 6 )  // Codigo del cliente
               cBuffer     += Space( 6 )
               cBuffer     += Left( Alltrim( ::oClientes:Titulo ), 40 )   // Nombre del cliente
               cBuffer     += cBanCli                          // Banco del cliente
               cBuffer     += cToCeros( nImpRec, ::cPorDiv )   // Importe del recibo
               cBuffer     += Space( 6 )
               cBuffer     += ::oDbfDet:cSerie + cToCeros( ::oDbfDet:nNumFac, "99999", 5 ) // Numero del recibo
               cBuffer     += Left( "Recibo Nº" + ::oDbfDet:cSerie + "/" + AllTrim( Str( ::oDbfDet:nNumFac ) ) + "/" +  Alltrim( ::oDbfDet:cSufFac ) + "-" + Alltrim( Str( ::oDbfDet:nNumRec ) ) + " de " + Dtoc( ::oDbfDet:dEntrada ), 40 )
               cBuffer     := Padr( cBuffer, 162 )       // Para q llege a los 162 caracteres
               cBuffer     += CRLF

               fWrite( nHandle, cBuffer )
               nTotLin     ++

               /*
               Detalles de la factura------------------------------------------
               */

               cBuffer     := cPreMon
               cBuffer     += "6"                        // Constante para las lineas de recibos
               cBuffer     += "8"                        // Constante para el modelo 19
               cBuffer     += "1"                        // Numero de linea
               cBuffer     += cHeader                    // Cabecera
               cBuffer     += Right( AllTrim( ::oDbfDet:cCodCli ), 6 )  // Codigo del cliente
               cBuffer     += Space( 6 )
               cBuffer     += "Factura Nº" + ::oDbfDet:cSerie + "/" + AllTrim( Str( ::oDbfDet:nNumFac ) ) + "/" +  ::oDbfDet:cSufFac + " de " + Dtoc( ::oDbfDet:dEntrada )
               cBuffer     += Space( 2 )                       // Para q llege a los 162 caracteres
               cBuffer     := Padr( cBuffer, 162 )       // Para q llege a los 162 caracteres
               cBuffer     += CRLF

               fWrite( nHandle, cBuffer )
               nTotLin     ++

               /*
               Detalles del cliente--------------------------------------------
               */

               cBuffer     := cPreMon
               cBuffer     += "6"                        // Constante para las lineas de recibos
               cBuffer     += "8"                        // Constante para el modelo 19
               cBuffer     += "2"                        // Numero de linea
               cBuffer     += cHeader                    // Cabecera
               cBuffer     += Right( AllTrim( ::oDbfDet:cCodCli ), 6 )  // Codigo del cliente
               cBuffer     += Space( 6 )
               cBuffer     += Left( ::oClientes:Titulo, 40 )   // Nombre del cliente
               cBuffer     += Left( ::oClientes:Domicilio, 40 )// Domicilio del cliente
               cBuffer     += ::oClientes:CodPostal            // Codigo postal
               cBuffer     += Space( 1 )
               cBuffer     += ::oClientes:Poblacion            // Población
               cBuffer     := Padr( cBuffer, 162 )             // Para q llege a los 162 caracteres
               cBuffer     += CRLF

               fWrite( nHandle, cBuffer )
               nTotLin     ++

            end if

            if ::lAgruparRecibos
               while cCodCli == ::oDbfDet:cCodCli .and. !::oDbfDet:Eof()
                  ::oDbfDet:Skip()
               end while
            else
               ::oDbfDet:Skip()
            end if

         end while

      end if

      /*
      Total de presentador-----------------------------------------------------
      */

      cBuffer  := cPreMon
      cBuffer  += "8"                              // Constante para las lineas de recibos
      cBuffer  += "8"                              // Constante para el modelo 19
      cBuffer  += "0"                              // Numero de linea
      cBuffer  += cHeader                          // Cabecera
      cBuffer  += Space( 72 )
      cBuffer  += cToCeros( nTotImp, ::cPorDiv )   // Importe total del Recibos
      cBuffer  += Space( 6 )
      cBuffer  += cToCeros( nTotRec )              // Numero de recibos por ordenante
      cBuffer  += cToCeros( nTotLin )              // Numero Total de lineas
      cBuffer  := Padr( cBuffer, 162 )       // Para q llege a los 162 caracteres
      cBuffer  += CRLF

      fWrite( nHandle, cBuffer )
      nTotLin  ++

      /*
      Total de archivo---------------------------------------------------------
      */

      cBuffer  := cPreMon
      cBuffer  += "9"                              // Constante para las lineas de recibos
      cBuffer  += "8"                              // Constante para el modelo 19
      cBuffer  += "0"                              // Numero de linea
      cBuffer  += cHeader                          // Cabecera
      cBuffer  += Space( 52 )
      cBuffer  += "0001"                           // Modificación para BCH internet
      cBuffer  += Space( 16 )
      cBuffer  += cToCeros( nTotImp, ::cPorDiv )   // Importe total del Recibos
      cBuffer  += Space( 6 )
      cBuffer  += cToCeros( nTotRec )              // Numero de recibos por ordenante
      cBuffer  += cToCeros( ++nTotLin )            // Numero Total de lineas del fichero
      cBuffer  := Padr( cBuffer, 162 )       // Para q llege a los 162 caracteres
      cBuffer  += CRLF
      fWrite( nHandle, cBuffer )

   end if

   fClose( nHandle )

   oDlg:Enable()
   oDlg:End()

   if ApoloMsgNoYes( "Proceso de exportación realizado con éxito" + CRLF + ;
                "¿ Desea abrir el fichero resultante ?", "Elija una opción." )
      ShellExecute( 0, "open", ::cPatExp, , , 1 )
   end if

RETURN ( Self )

//---------------------------------------------------------------------------//