#include "FiveWin.Ch"
#include "Struct.ch"
#include "Factu.ch" 
#include "Ini.ch"
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS TImpBellerin

   DATA nLevel
   DATA oDbfCli

   METHOD New()

   METHOD Create( oMenuItem, oWnd ) INLINE ( if( ::New( oMenuItem, oWnd ) != nil, ::Activate(), ) )

   METHOD lOpenFiles()

   METHOD CloseFiles()

   METHOD Activate( oWnd )

END CLASS

//---------------------------------------------------------------------------//
/*Método constructor*/

METHOD New( oMenuItem, oWnd )

   DEFAULT oMenuItem    := "01102"

   ::nLevel             := Auth():Level( oMenuItem )

   if nAnd( ::nLevel, 1 ) != 0
      msgStop( "Acceso no permitido." )
      Return ( nil )
   end if

   if oWnd != nil
      SysRefresh(); oWnd:CloseAll(); SysRefresh()
   end if

RETURN ( Self )

//---------------------------------------------------------------------------//
/*Método para abrir ficheros que necesitaremos*/

METHOD lOpenFiles()

   local lOpen    := .t.
   local oBlock   := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

   DATABASE NEW ::oDbfCli     FILE "CLIENT.DBF"     PATH ( cPatEmp() )  VIA ( cLocalDriver() ) SHARED INDEX  "CLIENT.CDX"

   RECOVER

      msgStop( "Imposible abrir todas las bases de datos" )
      ::CloseFiles()
      lOpen       := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//
/*Método que cierra los ficheros abiertos*/

METHOD CloseFiles()

   if !Empty ( ::oDbfCli )
      ::oDbfCli:End()
   end if

   ::oDbfCli     := nil

RETURN ( Self )

//---------------------------------------------------------------------------//
/*Método que monta el diálogo y con el que ya pasamos a la acción*/

METHOD Activate( oWnd )

   local oError
   local oBlock
   local cDirectory  := Space( 255 )
   local aFiles
   local n           := 1
   local oOleExcel
   local cNombre
   local cDireccion
   local cPoblacion
   local cTelefono
   local cNif
   local cNewCodCli
   local cMovil      := Space( 20 )
   local nPos

   if ! ::lOpenFiles()
      Return ( Self )
   end if

   MsgGet( "Seleccione un directorio", "Directorio: ", @cDirectory )

   aFiles                              := Directory( AllTrim( cDirectory ) + "*.*" )

   for n := 1 to Len( aFiles )

      msgwait( aFiles[ n, 1 ], "Fichero " + Str( n ), 0.5 )

      cNombre                          := Space(1)
      cDireccion                       := Space(1)
      cPoblacion                       := Space(1)
      cTelefono                        := Space(1)
      cNif                             := Space(1)

      oBlock                           := ErrorBlock( {| oError | ApoloBreak( oError ) } )
      BEGIN SEQUENCE

      oOleExcel                        := TOleExcel():New( "Importando hoja de excel", "Conectando...", .f. )

      oOleExcel:oExcel:Visible         := .f.
      oOleExcel:oExcel:DisplayAlerts   := .f.

      if File( AllTrim( cDirectory ) + aFiles[ n, 1 ] )

         oOleExcel:oExcel:WorkBooks:Open( AllTrim( cDirectory ) + aFiles[ n, 1 ] )

         /*
         Tomamos los valores de la hoja de calculo de las distintas hojas------
         */

         oOleExcel:oExcel:WorkSheets( 1 ):Activate()   //Hoja de albaranes

         cNombre           := oOleExcel:oExcel:ActiveSheet:Range( "B6" ):Value

         cDireccion        := oOleExcel:oExcel:ActiveSheet:Range( "B7" ):Value

         cPoblacion        := oOleExcel:oExcel:ActiveSheet:Range( "B8" ):Value

         cTelefono         := oOleExcel:oExcel:ActiveSheet:Range( "D8" ):Value


         if !Empty( cTelefono ) .and. ValType( cTelefono ) != "C"

            cTelefono      := Str( cTelefono )

            if "." $ cTelefono
               cTelefono   := Left( cTelefono, ( At( ".", cTelefono ) - 1 ) )
            end if

         end if

         if oOleExcel:oExcel:WorkSheets:Count >= 4

            oOleExcel:oExcel:WorkSheets( 4 ):Activate()   //Hoja de factura para coger dni

            cNif              := oOleExcel:oExcel:ActiveSheet:Range( "E6" ):Value

            if ValType( cNif ) != "C" .and. cNif != nil
               cNif           := Str( cNif )
            end if

         end if

         oOleExcel:oExcel:WorkBooks:Close()

         /*
         Vemos si en la poblacion o en el telefono tiene mas de un dato
         */

         //?"Compruebo mas de un telefono"

         if !Empty( cTelefono )

            if "-" $ cTelefono
               nPos                    := At( "-", cTelefono )
               cMovil                  := Right( cTelefono, ( nPos - 1 ) )
               cTelefono               := Left( cTelefono, ( nPos - 1 ) )
            end if

            if "/" $ cTelefono
               nPos                    := At( "/", cTelefono )
               cMovil                  := Right( cTelefono, ( nPos - 1 ) )
               cTelefono               := Left( cTelefono, ( nPos - 1 ) )
            end if

         end if

         /*
         Comprobamos que el cliente no exista y lo añadimos a la tabla---------
         */

         if !::oDbfCli:SeekInOrd( Padr( cNombre, 80 ), "TITULO" )

            cNewCodCli              := RJust( NextVal( dbLast( ::oDbfCli, 1 ) ), "0", RetNumCodCliEmp() )

            ::oDbfCli:Append()

            ::oDbfCli:Cod           := cNewCodCli
            //?"Meto nombre"
            if !Empty( cNombre )
               ::oDbfCli:Titulo        := Padr( cNombre, 80 )
            end if
            //?"Meto nif"
            if !Empty( cNif )
               ::oDbfCli:Nif           := Padr( cNif, 15 )
            end if
            //?"Meto direccion"
            if !Empty( cDireccion )
               ::oDbfCli:Domicilio     := Padr( cDireccion, 100 )
            end if
            //?"Meto población"
            if !Empty( cPoblacion )
               ::oDbfCli:Poblacion     := Padr( cPoblacion, 35 )
            end if
            //?"Meto telefono"
            if !Empty( cTelefono )
               ::oDbfCli:Telefono      := Padr( AllTrim( cTelefono ), 20 )
            end if
            //?"Meto el movil"
            //?Valtype( cMovil )
            if !Empty( cMovil )
               ::oDbfCli:Movil         := Padr( AllTrim( cMovil ), 20 )
            end if

            //?"ya tenemos todos los datos"

            ::oDbfCli:lSndInt       := .t.
            ::oDbfCli:lModDat       := .f.
            ::oDbfCli:lChgPre       := .t.
            ::oDbfCli:CopiasF       := 1
            ::oDbfCli:nLabel        := 1
            ::oDbfCli:nTarifa       := 1
            ::oDbfCli:nTipCli       := 2
            ::oDbfCli:cDtoEsp       := Padr( "General", 50 )
            ::oDbfCli:cDpp          := Padr( "Pronto pago", 50 )
            ::oDbfCli:cDtoAtp       := Padr( "Atipico", 50 )
            ::oDbfCli:lReq          := .f.
            ::oDbfCli:lMayorista    := .f.
            ::oDbfCli:lBlqCli       := .f.
            ::oDbfCli:lMosCom       := .f.
            ::oDbfCli:nSbrAtp       := 1

            ::oDbfCli:Save()

         end if

      end if

      cMovil                        := Space( 20 )

      oOleExcel:oExcel:Quit()

      oOleExcel:oExcel:DisplayAlerts   := .t.

      oOleExcel:End()

      RECOVER USING oError

         msgWait( "Error :" + CRLF + ErrorMessage( oError ), 0.1 )

      END SEQUENCE
      ErrorBlock( oBlock )

   next

   ::CloseFiles()

RETURN ( Self )

//---------------------------------------------------------------------------//