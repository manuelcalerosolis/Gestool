/*
Actualización de las estaciones de servicio del Garrido, de turnos a sesiones
*/

#include "FiveWin.Ch"
#include "Factu.ch" 
#include "Font.ch"
#include "MesDbf.ch"

CLASS TTur2Ses

   DATA oArt
   DATA oArtNew

   DATA oDbfTikT
   DATA oDbfTikL
   DATA oDbfTikP
   DATA oDbfTurT
   DATA oDbfTurL
   DATA oAlbCliT
   DATA oAlbCliL
   DATA oFacCliT
   DATA oFacCliL
   DATA oFacCliP
   DATA oPedPrvT
   DATA oPedPrvL
   DATA oAlbPrvT
   DATA oAlbPrvL
   DATA oFacPrvT
   DATA oFacPrvL
   DATA oFacPrvP

   METHOD New()

   METHOD DefNew()

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHOD App()

END CLASS

//---------------------------------------------------------------------------//

/*
Abrimos los ficheros
*/

METHOD OpenFiles( cSufDes ) CLASS TTur2Ses

   ::oFacCliT := TDataCenter():oFacCliT() 

   DATABASE NEW ::oDbfTikT PATH ( cPatEmp() ) FILE "TIKET.DBF"    VIA ( cDriver() )INDEX "TIKET.CDX"
   DATABASE NEW ::oDbfTikL PATH ( cPatEmp() ) FILE "TIKEL.DBF"    VIA ( cDriver() )INDEX "TIKEL.CDX"
   ::oAlbCliT := TDataCenter():oAlbCliT()
   DATABASE NEW ::oAlbCliL PATH ( cPatEmp() ) FILE "ALBCLIL.DBF"  VIA ( cDriver() )INDEX "ALBCLIL.CDX"
   DATABASE NEW ::oFacCliL PATH ( cPatEmp() ) FILE "FACCLIL.DBF"  VIA ( cDriver() )INDEX "FACCLIL.CDX"
   ::oFacCliP := TDataCenter():oFacCliP()
   DATABASE NEW ::oAlbPrvT PATH ( cPatEmp() ) FILE "AlbProvT.DBF" VIA ( cDriver() )INDEX "AlbProvT.CDX"
   DATABASE NEW ::oAlbPrvL PATH ( cPatEmp() ) FILE "AlbProvL.DBF" VIA ( cDriver() )INDEX "AlbProvL.CDX"
   DATABASE NEW ::oFacPrvT PATH ( cPatEmp() ) FILE "FacPrvT.DBF"  VIA ( cDriver() )INDEX "FacPrvT.CDX"
   DATABASE NEW ::oFacPrvL PATH ( cPatEmp() ) FILE "FacPrvL.DBF"  VIA ( cDriver() )INDEX "FACPrvL.CDX"
   DATABASE NEW ::oFacPrvP PATH ( cPatEmp() ) FILE "FacPrvP.DBF"  VIA ( cDriver() )INDEX "FACPrvP.CDX"

RETURN .T.

// ----------------------------------------------------------------------------- //

/*
Cerramos ficheros
*/

METHOD CloseFiles()

   ::oArt:End()
   ::oArtNew:End()

   ::oDbfTikT:End()
   ::oDbfTikL:End()
   ::oAlbCliT:End()
   ::oAlbCliL:End()
   ::oFacCliT:End()
   ::oFacCliL:End()
   ::oFacCliP:End()
   ::oAlbPrvT:End()
   ::oAlbPrvL:End()
   ::oFacPrvT:End()
   ::oFacPrvL:End()
   ::oFacPrvP:End()

RETURN .T.

// ----------------------------------------------------------------------------- //

METHOD DefNew()

   local n
   local aSufDes     := { "31", "32", "33", "34", "35", "36", "38", "39" }

   /*
   Apertura de ficheros
   */

   for n := 1 to len( aSufDes )

   if !::OpenFiles( aSufDes[ n ] )
      Return Nil
   end if

   ::oDbfTikT:AppendFrom( FullCurDir() + "EMP" + aSufDes[ n ] + "\" + "TIKET.DBF"    )
   ::oDbfTikL:AppendFrom( FullCurDir() + "EMP" + aSufDes[ n ] + "\" + "TIKEL.DBF"    )
   ::oAlbCliT:AppendFrom( FullCurDir() + "EMP" + aSufDes[ n ] + "\" + "ALBCLIT.DBF"  )
   ::oAlbCliL:AppendFrom( FullCurDir() + "EMP" + aSufDes[ n ] + "\" + "ALBCLIL.DBF"  )
   ::oFacCliT:AppendFrom( FullCurDir() + "EMP" + aSufDes[ n ] + "\" + "FACCLIT.DBF"  )
   ::oFacCliL:AppendFrom( FullCurDir() + "EMP" + aSufDes[ n ] + "\" + "FACCLIL.DBF"  )
   ::oFacCliP:AppendFrom( FullCurDir() + "EMP" + aSufDes[ n ] + "\" + "FACCLIP.DBF"  )
   ::oAlbPrvT:AppendFrom( FullCurDir() + "EMP" + aSufDes[ n ] + "\" + "AlbProvT.DBF" )
   ::oAlbPrvL:AppendFrom( FullCurDir() + "EMP" + aSufDes[ n ] + "\" + "AlbProvL.DBF" )
   ::oFacPrvT:AppendFrom( FullCurDir() + "EMP" + aSufDes[ n ] + "\" + "FacPrvT.DBF"  )
   ::oFacPrvL:AppendFrom( FullCurDir() + "EMP" + aSufDes[ n ] + "\" + "FacPrvL.DBF"  )
   ::oFacPrvP:AppendFrom( FullCurDir() + "EMP" + aSufDes[ n ] + "\" + "FacPrvP.DBF"  )

   ::CloseFiles()

   next

RETURN Self

// ----------------------------------------------------------------------------- //

METHOD App( cTitle, oOrigen, oDestino )

   while !( oDestino:cAlias )->( Eof() )
      dbPass( oOrigen:cAlias, oDestino:cAlias, .t. )
      Titulo( cTitle + Str( ( oDestino:cAlias )->( Recno() ) ) )
      ( oDestino:cAlias )->( dbSkip() )
   end while

RETURN Self

// ----------------------------------------------------------------------------- //

Method New()

   local n
   local aSufDes     := { "31", "32", "33", "34", "35", "36", "38", "39" }

   /*
   Apertura de ficheros
   */

   for n := 1 to len( aSufDes )

   if !::OpenFiles( aSufDes[ n ] )
      Return Nil
   end if

   while !::oArtNew:Eof()

      if !::oArt:Seek( ::oArtNew:Cod )
         dbPass( ::oArtNew:cAlias, ::oArt:cAlias, .t. )
      end if

      ::oArtNew:Skip()

   end while

   ::CloseFiles()

   next

RETURN Self

// ----------------------------------------------------------------------------- //