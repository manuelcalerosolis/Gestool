#include "FiveWin.Ch"
#include "Report.ch"
#include "Xbrowse.ch"
#include "MesDbf.ch"
#include "Factu.ch" 
#include "FastRepH.ch"

#define IDFOUND            3
#define _MENUITEM_         "01050"

//--------------------------------------------------------------------------//

CLASS TDetSeriesMovimientos FROM TDet

   METHOD DefineFiles()

   METHOD OpenFiles( lExclusive )
   METHOD CloseFiles()

   MESSAGE OpenService( lExclusive )   METHOD OpenFiles( lExclusive )

   METHOD Load( lAppend )

   METHOD Save()

   METHOD RollBack()

   METHOD Resource( nMode, lLiteral )

END CLASS

//--------------------------------------------------------------------------//

METHOD DefineFiles( cPath, cDriver, lUniqueName, cFileName ) CLASS TDetSeriesMovimientos

   local oDbf

   DEFAULT cPath        := ::cPath
   DEFAULT cDriver      := ::cDriver
   DEFAULT lUniqueName  := .f.
   DEFAULT cFileName    := "MovSer"

   if lUniqueName
      cFileName         := cGetNewFileName( cFileName, , , cPath )
   end if

   DEFINE TABLE oDbf FILE ( cFileName ) CLASS ( cFileName ) ALIAS ( cFileName ) PATH ( cPath ) VIA ( cDriver ) COMMENT "Números de serie de movimientos de almacen"

      FIELD NAME "nNumRem"    TYPE "N" LEN  9  DEC 0 PICTURE "999999999"                        HIDE        OF oDbf
      FIELD NAME "cSufRem"    TYPE "C" LEN  2  DEC 0 PICTURE "@!"                               HIDE        OF oDbf
      FIELD NAME "dFecRem"    TYPE "D" LEN  8  DEC 0                                            HIDE        OF oDbf
      FIELD NAME "nNumLin"    TYPE "N" LEN 04  DEC 0 COMMENT "Número de línea"                  COLSIZE  60 OF oDbf
      FIELD NAME "cCodArt"    TYPE "C" LEN 18  DEC 0 COMMENT "Artículo"                         COLSIZE  60 OF oDbf
      FIELD NAME "cAlmOrd"    TYPE "C" LEN 16  DEC 0 COMMENT "Almacén"                          COLSIZE  50 OF oDbf
      FIELD NAME "lUndNeg"    TYPE "L" LEN 01  DEC 0 COMMENT "Lógico de unidades en negativo"   HIDE        OF oDbf
      FIELD NAME "cNumSer"    TYPE "C" LEN 30  DEC 0 COMMENT "Número de serie"                  HIDE        OF oDbf

      INDEX TO ( cFileName ) TAG "cNumOrd" ON "Str( nNumRem ) + cSufRem + Str( nNumLin )"       NODELETED   OF oDbf
      INDEX TO ( cFileName ) TAG "cCodArt" ON "cCodArt + cAlmOrd + cNumSer"                     NODELETED   OF oDbf
      INDEX TO ( cFileName ) TAG "cNumSer" ON "cNumSer"                                         NODELETED   OF oDbf
      INDEX TO ( cFileName ) TAG "nNumLin" ON "Str( nNumLin ) + cCodArt"                        NODELETED   OF oDbf

   END DATABASE oDbf

RETURN ( oDbf )

//--------------------------------------------------------------------------//

METHOD OpenFiles( lExclusive ) CLASS TDetSeriesMovimientos

   local lOpen             := .t.
   local oBlock

   DEFAULT  lExclusive     := .f.

   oBlock                  := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      if empty( ::oDbf )
         ::oDbf            := ::DefineFiles()
      end if

      ::oDbf:Activate( .f., !lExclusive )

   RECOVER

      msgstop( "Imposible abrir todas las bases de datos" )
      lOpen                := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

   if !lOpen
      ::CloseFiles()
   end if

RETURN ( lOpen )

//--------------------------------------------------------------------------//

METHOD CloseFiles() CLASS TDetSeriesMovimientos

   if ::oDbf != nil .and. ::oDbf:Used()
      ::oDbf:End()
      ::oDbf         := nil
   end if

RETURN .t.

//---------------------------------------------------------------------------//

METHOD Save() CLASS TDetSeriesMovimientos

   local nNumRem  := ::oParent:oDbf:nNumRem
   local cSufRem  := ::oParent:oDbf:cSufRem
   local dFecRem  := ::oParent:oDbf:dFecRem
   local cAlmDes  := ::oParent:oDbf:cAlmDes

   ::oDbfVir:OrdSetFocus( 0 )

   ( ::oDbfVir:nArea )->( dbGoTop() )
   while !( ::oDbfVir:nArea )->( eof() )

      ( ::oDbf:nArea )->( dbAppend() )

      if !( ::oDbf:nArea )->( NetErr() )

         ( ::oDbf:nArea )->nNumRem  := nNumRem
         ( ::oDbf:nArea )->cSufRem  := cSufRem
         ( ::oDbf:nArea )->dFecRem  := dFecRem
         ( ::oDbf:nArea )->cAlmOrd  := cAlmDes
         ( ::oDbf:nArea )->nNumLin  := ( ::oDbfVir:nArea )->nNumLin
         ( ::oDbf:nArea )->cCodArt  := ( ::oDbfVir:nArea )->cCodArt
         ( ::oDbf:nArea )->lUndNeg  := ( ::oDbfVir:nArea )->lUndNeg
         ( ::oDbf:nArea )->cNumSer  := ( ::oDbfVir:nArea )->cNumSer

         ( ::oDbf:nArea )->( dbUnLock() )

      end if

      ( ::oDbfVir:nArea )->( dbSkip() )

      if !empty( ::oParent ) .and. !empty( ::oParent:oMeter )
         ::oParent:oMeter:AutoInc()
      end if

   end while

   ::Cancel()

   if !empty( ::oParent ) .and. !empty( ::oParent:oMeter )
      ::oParent:oMeter:Refresh()
   end if

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD RollBack() CLASS TDetSeriesMovimientos

   local cKey  := ::oParent:cFirstKey
   local nArea := ::oDbf:nArea

   if cKey != nil

      while ( nArea )->( dbSeek( cKey ) ) // ::oDbf:Seek( cKey )

         if ( nArea )->( dbRlock() )
            ( nArea )->( dbDelete() )     // ::oDbf:Delete( .f. )
         end if

         if !empty( ::oParent ) .and. !empty( ::oParent:oMeter )
            ::oParent:oMeter:AutoInc()
         end if

      end while

   end if

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD Resource( nMode ) CLASS TDetSeriesMovimientos

   ::oDbfVir:GetStatus()
   ::oDbfVir:OrdSetFocus( "nNumLin" )

   with object ( TNumerosSerie() )

      :nMode            := nMode

      :lCompras         := ( ::oParent:oDbf:nTipMov != 1 )

      :cCodArt          := ::oParent:oDetMovimientos:oDbfVir:cRefMov

      :nNumLin          := ::oParent:oDetMovimientos:oDbfVir:nNumLin
      :cCodAlm          := ::oParent:oDbf:cAlmDes

      :nTotalUnidades   := nTotNMovAlm( ::oParent:oDetMovimientos:oDbfVir )

      :oStock           := ::oParent:oStock

      :uTmpSer          := ::oDbfVir

      :Resource()

   end with

   ::oDbfVir:SetStatus()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD Load( lAppend )

   DEFAULT lAppend   := .f.

   ::nRegisterLoaded := 0

   if empty( ::oDbfVir )
      ::oDbfVir      := ::DefineFiles( cPatTmp(), cLocalDriver(), .t. )
   end if

   if !( ::oDbfVir:Used() )
      ::oDbfVir:Activate( .f., .f. )
   end if

   ::oDbfVir:Zap()   

   if ::oParent:cFirstKey != nil

      if ( lAppend ) .and. ::oDbf:Seek( ::oParent:cFirstKey )

         while !empty( ::oDbf:OrdKeyVal() ) .and. ( str( ::oDbf:nNumRem ) + ::oDbf:cSufRem == ::oParent:cFirstKey ) .and. !( ::oDbf:Eof() )

            if ::bOnPreLoad != nil
               Eval( ::bOnPreLoad, Self )
            end if

            ::oDbfVir:AppendFromObject( ::oDbf )

            ::nRegisterLoaded++

            if ::bOnPostLoad != nil
               Eval( ::bOnPostLoad, Self )
            end if

            ::oDbf:Skip()

         end while

      end if

   end if

   ::oDbfVir:GoTop()

Return ( Self )

//---------------------------------------------------------------------------//

