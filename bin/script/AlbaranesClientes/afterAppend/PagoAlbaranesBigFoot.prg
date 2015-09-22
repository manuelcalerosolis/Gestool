#include "C:\fw195\Gestool\bin\include\Factu.ch"

static dbfAlbCliP
static lOpenFiles       := .f.

//---------------------------------------------------------------------------//

function AddEntradaAlbaranes( aTmp, nView )

	if !OpenFiles()
		return .f.
	end if

	( dbfAlbCliP )->( dbappend() )

		( dbfAlbCliP )->cSerAlb     := ( D():Get( "AlbCliT", nView ) )->cSerAlb
		( dbfAlbCliP )->nNumAlb     := ( D():Get( "AlbCliT", nView ) )->nNumAlb
		( dbfAlbCliP )->cSufAlb     := ( D():Get( "AlbCliT", nView ) )->cSufAlb
		( dbfAlbCliP )->nNumRec     := 1
		( dbfAlbCliP )->nImporte    := ( D():Get( "AlbCliT", nView ) )->nTotAlb
      ( dbfAlbCliP )->cDescrip    := "Pago inicial por defecto"
      ( dbfAlbCliP )->cCodCaj     := ( D():Get( "AlbCliT", nView ) )->cCodCaj
      ( dbfAlbCliP )->cTurRec     := ( D():Get( "AlbCliT", nView ) )->cTurAlb
      ( dbfAlbCliP )->cCodCli     := ( D():Get( "AlbCliT", nView ) )->cCodCli
      ( dbfAlbCliP )->dEntrega    := ( D():Get( "AlbCliT", nView ) )->dFecAlb
      ( dbfAlbCliP )->cDivPgo     := ( D():Get( "AlbCliT", nView ) )->cDivAlb
      ( dbfAlbCliP )->nVdvPgo     := ( D():Get( "AlbCliT", nView ) )->nVdvAlb
      ( dbfAlbCliP )->cCodAge     := ( D():Get( "AlbCliT", nView ) )->cCodAge
      ( dbfAlbCliP )->cCodPgo     := ( D():Get( "AlbCliT", nView ) )->cCodPago      

	( dbfAlbCliP )->( dbUnLock() )

   if D():Lock( "AlbCliT", nView ) 
      ( D():Get( "AlbCliT", nView ) )->nTotPag  := ( D():Get( "AlbCliT", nView ) )->nTotAlb
      D():UnLock( "AlbCliT", nView )
   end if

   /* mostrar el total en la columna entregado
   nTotPag
   */
   CloseFiles()

Return nil

static function OpenFiles()

	local oError
   local oBlock

   if lOpenFiles
      MsgStop( 'Imposible abrir ficheros' )
      Return ( .f. )
   end if

   CursorWait()

   oBlock         := ErrorBlock( { | oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      lOpenFiles  := .t.

      USE ( cPatCli() + "ALBCLIP.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ALBCLIP", @dbfAlbCliP ) )
      SET ADSINDEX TO ( cPatCli() + "ALBCLIP.CDX" ) ADDITIVE

   RECOVER USING oError

      lOpenFiles           := .f.

      msgStop( ErrorMessage( oError ), 'Imposible abrir las bases de datos' )

   END SEQUENCE

   ErrorBlock( oBlock )

   if !lOpenFiles
      CloseFiles()
   end if

   CursorWE()

return ( lOpenFiles )

static function CloseFiles()

	if dbfAlbCliP != nil
		(dbfAlbCliP )->( dbCloseArea() )
   end if

   dbfAlbCliP      := nil

   lOpenFiles     := .f.

return ( .t. )

