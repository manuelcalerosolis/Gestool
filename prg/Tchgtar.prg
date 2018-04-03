#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

function ChgTarifa( oMenuItem, oWnd )

   local nLevel

   nLevel   := Auth():Level( oMenuItem )

   if nAnd( nLevel, 1 ) == 0
      msgStop( "Acceso no permitido." )
      return nil
   end if

   /*
   Cerramos todas las ventanas
   */

   if oWnd != nil
      SysRefresh(); oWnd:CloseAll(); SysRefresh()
   end if

   with object TChgTarifa():New()
               if :OpenFiles()
                  :Resource()
                  :CloseFiles()
               end if
   end

return ( nil )

//---------------------------------------------------------------------------//

CLASS TChgTarifa FROM TInfGen

   DATA  oEmp        AS OBJECT
   DATA  oFacCliT    AS OBJECT
   DATA  oFacCliL    AS OBJECT
   DATA  oCliAtp     AS OBJECT
   DATA  cCodEmp

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHOD Resource( cFld )

   METHOD lGenerate()

   METHOD PutPrecio()

END CLASS

//---------------------------------------------------------------------------//

METHOD OpenFiles( cPatEmp ) CLASS TChgTarifa

   local lOpen       := .t.
   local oBlock      := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   DEFAULT cPatEmp   := cPatEmp()

   BEGIN SEQUENCE

      ::oFacCliT     := TDataCenter():oFacCliT()  

      DATABASE NEW ::oFacCliL PATH ( cPatEmp ) FILE "FACCLIL.DBF" VIA ( cDriver() ) SHARED INDEX "FACCLIL.CDX"

      DATABASE NEW ::oCliAtp  PATH ( cPatEmp() ) FILE "CLIATP.DBF" VIA ( cDriver() ) SHARED INDEX "CLIATP.CDX"
      ::oCliAtp:OrdSetFocus( "cCodArt" )

   RECOVER

      msgStop( "Imposible abrir todas las bases de datos" )
      ::CloseFiles()

      lOpen          := .f.

   END SEQUENCE
   ErrorBlock( oBlock )

RETURN lOpen

//---------------------------------------------------------------------------//

METHOD CloseFiles() CLASS TChgTarifa

   if ::oDbfCli != nil .and. ::oDbfCli:Used()
      ::oDbfCli:End()
   end if

   if ::oDbfEmp != nil .and. ::oDbfEmp:Used()
      ::oDbfEmp:End()
   end if

   if ::oCliAtp != nil .and. ::oCliAtp:Used()
      ::oCliAtp:End()
   end if

   if ::oFacCliT != nil .and. ::oFacCliT:Used()
      ::oFacCliT:End()
   end if

   if ::oFacCliL != nil .and. ::oFacCliL:Used()
      ::oFacCliL:End()
   end if

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD Resource() CLASS TChgTarifa

   DEFINE DIALOG ::oDlg RESOURCE "GETIMPFAC" OF oWnd()

   ::oDefEmpInf( 90, 91, ::oDlg )

   /*
   Monta los almacenes de manera automatica
   */

   ::oDefIniInf( 100, ::oDlg )
   ::oDefFinInf( 110, ::oDlg )

   /*
   Monta los articulos de manera automatica
   */

   if !::oDefCliInf( 120, 121, 130, 131, ::oDlg )
      Return .f.
   end if

   ::oDefMetInf( 140, ::oDlg )

   ::oDefSerInf( ::oDlg )

   REDEFINE BUTTON ;
      ID       IDOK ;
      OF       ::oDlg ;
      ACTION   ( ::lGenerate() )

   REDEFINE BUTTON ;
      ID       IDCANCEL ;
      OF       ::oDlg ;
      ACTION   ( ::oDlg:end() )

	REDEFINE BUTTON ;
      ID       599;
      OF       ::oDlg ;
      ACTION   ( nil )

   ::oDlg:AddFastKey( VK_F5, {|| ::lGenerate() } )

   ACTIVATE DIALOG ::oDlg CENTER

RETURN ( Self )

//---------------------------------------------------------------------------//
/*
Esta funcion crea la base de datos para generar posteriormente el informe
*/

METHOD lGenerate() CLASS TChgTarifa

   ::oDlg:Disable()

   /*
   Damos valor al meter
   */

   ::oMtrInf:SetTotal( ::oFacCliT:Lastrec() )

   /*
   Nos movemos por las cabeceras de los albaranes a proveedores
	*/

   ::oFacCliT:GoTop()
   while ! ::oFacCliT:Eof()

      if ::oFacCliT:dFecFac >= ::dIniInf                                                    .AND.;
         ::oFacCliT:dFecFac <= ::dFinInf                                                    .AND.;
         ::oFacCliT:cCodCli >= ::cCliOrg                                                    .AND.;
         ::oFacCliT:cCodCli <= ::cCliDes                                                    .AND.;
         lChkSer( ::oFacCliT:cSerie, ::aSer )

         /*
         Posicionamos en las lineas de detalle --------------------------------
         */

         if ::oFacCliL:Seek( ::oFacCliT:cSerie + Str( ::oFacCliT:nNumFac ) + ::oFacCliT:cSufFac )

            while ::oFacCliT:cSerie + Str( ::oFacCliT:nNumFac ) + ::oFacCliT:cSufFac == ::oFacCliL:cSerie + Str( ::oFacCliL:nNumFac ) + ::oFacCliL:cSufFac .AND. ! ::oFacCliL:eof()

               if !Empty( ::oFacCliL:cRef )

                  if ::oCliAtp:Seek( ::oFacCliT:cCodCli + ::oFacCliL:cRef )

                     ::oCliAtp:Load()
                     ::PutPrecio()
                     ::oCliAtp:Save()

                  else

                     ::oCliAtp:Append()
                     ::oCliAtp:cCodCli := ::oFacCliT:cCodCli
                     ::oCliAtp:cCodArt := ::oFacCliL:cRef
                     ::PutPrecio()
                     ::oCliAtp:Save()

                  end if

               end if

               ::oFacCliL:Skip()

            end while

         end if

      end if

      ::oFacCliT:Skip()

      ::oMtrInf:AutoInc()

   end while

   ::oMtrInf:AutoInc( ::oFacCliT:LastRec() )

   ::oDlg:Enable()

   MsgInfo( "Porceso finalizado con exito." )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD PutPrecio() CLASS TChgTarifa

   do case
      case ::oFacCliT:nTarifa == 1
         ::oCliAtp:nPrcArt    := ::oFacCliL:nPreUnit
      case ::oFacCliT:nTarifa == 2
         ::oCliAtp:nPrcArt2   := ::oFacCliL:nPreUnit
      case ::oFacCliT:nTarifa == 3
         ::oCliAtp:nPrcArt3   := ::oFacCliL:nPreUnit
      case ::oFacCliT:nTarifa == 4
         ::oCliAtp:nPrcArt4   := ::oFacCliL:nPreUnit
      case ::oFacCliT:nTarifa == 5
         ::oCliAtp:nPrcArt5   := ::oFacCliL:nPreUnit
      case ::oFacCliT:nTarifa == 6
         ::oCliAtp:nPrcArt6   := ::oFacCliL:nPreUnit
   end case

   ::oCliAtp:lAplPre := .t.
   ::oCliAtp:lAplPed := .t.
   ::oCliAtp:lAplAlb := .t.
   ::oCliAtp:lAplFac := .t.

RETURN ( Self )

//---------------------------------------------------------------------------//