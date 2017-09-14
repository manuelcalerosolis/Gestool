#include "FiveWin.Ch"
#include "Factu.ch" 
#include "MesDbf.ch"
#include "XBrowse.ch"

//--------------------------------------------------------------------------//

CLASS TDetPersonal FROM TDet

   DATA  oGetTotalTime
   DATA  cGetTotalTime
   DATA  cTiempoEmpleado
   DATA  cTmpEmp
   DATA  oTmpEmp

   DATA  oBrwHorasTrabajador

   DATA  lAppendTrabajador                   INIT  .f.

   METHOD New( cPath, cDriver, oParent )  
   
   METHOD DefineFiles()

   METHOD OpenFiles( lExclusive )
   METHOD CloseFiles()

   METHOD Resource( nMode, lLiteral )

   METHOD SaveDetails()
   METHOD DeleteDetails()
   METHOD SaveLines()

   METHOD lValidTrabajador( oGetTra, oGetSec, oGetOpe, nMode )

   METHOD cTotTime( oDbf )
   METHOD lTotTime( oDbf )

   METHOD nHorasTrabajador( oDbf )
   METHOD nTotalTrabajador( oDbf )
   METHOD cTotalTrabajador( cKeyTra, oDbf )  INLINE ( Trans( ::nTotalTrabajador( cKeyTra, oDbf ), ::oParent:cPorDiv ) )

   METHOD nTotal( oDbf, oDbfHor )
   METHOD cTotal( oDbf, oDbfHor )            INLINE ( Trans( ::nTotal( oDbf, oDbfHor ), ::oParent:cPorDiv ) )

   METHOD lTiempoEmpleado()

END CLASS

//--------------------------------------------------------------------------//

METHOD New( cPath, cDriver, oParent ) 

   DEFAULT cPath        := cPatEmp()
   DEFAULT cDriver      := cDriver()

   ::cPath              := cPath
   ::oParent            := oParent
   ::cDriver            := cDriver

   ::bOnPreSaveDetail   := {|| ::SaveDetails() }
   ::bOnPreDelete       := {|| ::DeleteDetails() }

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD DefineFiles( cPath, cVia, lUniqueName, cFileName )

   local oDbf

   DEFAULT cPath        := ::cPath
   DEFAULT lUniqueName  := .f.
   DEFAULT cFileName    := "ProPer"
   DEFAULT cVia         := cDriver()

   if lUniqueName
      cFileName         := cGetNewFileName( cFileName, , , cPath )
   end if

   DEFINE TABLE oDbf FILE ( cFileName ) CLASS ( cFileName ) ALIAS ( cFileName ) PATH ( cPath ) VIA ( cVia ) COMMENT "personal"

      FIELD NAME "cSerOrd" TYPE "C" LEN 01  DEC 0 COMMENT "Serie"          OF oDbf
      FIELD NAME "nNumOrd" TYPE "N" LEN 09  DEC 0 COMMENT "Número"         OF oDbf
      FIELD NAME "cSufOrd" TYPE "C" LEN 02  DEC 0 COMMENT "Sufijo"         OF oDbf
      FIELD NAME "cCodTra" TYPE "C" LEN 05  DEC 0 COMMENT "Trabajador"     OF oDbf
      FIELD NAME "cCodSec" TYPE "C" LEN 03  DEC 0 COMMENT "Sección"        OF oDbf
      FIELD NAME "cCodOpe" TYPE "C" LEN 03  DEC 0 COMMENT "Operación"      OF oDbf
      FIELD NAME "dFecIni" TYPE "D" LEN 08  DEC 0 COMMENT "Fecha inicio"   OF oDbf
      FIELD NAME "dFecFin" TYPE "D" LEN 08  DEC 0 COMMENT "Fecha fin"      OF oDbf
      FIELD NAME "cHorIni" TYPE "C" LEN 05  DEC 0 COMMENT "Hora inicio"    OF oDbf
      FIELD NAME "cHorFin" TYPE "C" LEN 05  DEC 0 COMMENT "Hora fin"       OF oDbf

      FIELD CALCULATE NAME "cKeyOrd" LEN 12  DEC 0  ;
         VAL {|| oDbf:FieldGetByName( "cSerOrd" ) + Str( oDbf:FieldGetByName( "nNumOrd" ), 9 ) + oDbf:FieldGetByName( "cSufOrd" ) };
         OF oDbf

      FIELD CALCULATE NAME "cKeyTra" LEN 17  DEC 0  ;
         VAL {|| oDbf:FieldGetByName( "cSerOrd" ) + Str( oDbf:FieldGetByName( "nNumOrd" ), 9 ) + oDbf:FieldGetByName( "cSufOrd" ) + oDbf:FieldGetByName( "cCodTra" ) };
         OF oDbf

      INDEX TO ( cFileName ) TAG "cNumOrd" ON "cSerOrd + Str( nNumOrd, 9 ) + cSufOrd"   NODELETED OF oDbf
      INDEX TO ( cFileName ) TAG "cCodTra" ON "cCodTra"                                 NODELETED OF oDbf
      INDEX TO ( cFileName ) TAG "cCodSec" ON "cCodSec"                                 NODELETED OF oDbf
      INDEX TO ( cFileName ) TAG "cCodOpe" ON "cCodOpe"                                 NODELETED OF oDbf

   END DATABASE oDbf

RETURN ( oDbf )

//--------------------------------------------------------------------------//

METHOD OpenFiles( lExclusive, cPath ) CLASS TDetPersonal

   local lOpen          := .t.
   local oBlock         := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   DEFAULT  lExclusive  := .f.

   BEGIN SEQUENCE

      if Empty( ::oDbf )
         ::oDbf         := ::DefineFiles()
      end if

      ::oDbf:Activate( .f., !lExclusive )

   RECOVER

      lOpen             := .f.

      ::CloseFiles()

      msgStop( "Imposible abrir todas las bases de datos" )

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//--------------------------------------------------------------------------//

METHOD CloseFiles()

   if ::oDbf != nil .and. ::oDbf:Used()
      ::oDbf:End()
      ::oDbf      := nil
   end if

RETURN .t.

//--------------------------------------------------------------------------//

METHOD Resource( nMode ) CLASS TDetPersonal

   local oDlg
   local oGetTra
   local oSayTra
   local cSayTra
   local oGetSec
   local oSaySec
   local cSaySec
   local oGetOpe
   local oSayOpe
   local cSayOpe
   local nOrdAnt
   local oFecIni
   local oFecFin
   local oHorIni
   local oHorFin

   nOrdAnt                 := ::oParent:oDetHorasPersonal:oDbfVir:OrdSetFocus( "cNumTra" )

   if nMode == APPD_MODE

      ::oDbfVir:dFecIni    := ::oParent:oDbf:dFecOrd
      ::oDbfVir:dFecFin    := ::oParent:oDbf:dFecFin
      ::oDbfVir:cHorIni    := ::oParent:oDbf:cHorIni
      ::oDbfVir:cHorFin    := ::oParent:oDbf:cHorFin
      ::oDbfVir:cCodOpe    := ::oParent:oDbf:cCodOpe

      while ::oParent:oDetHorasPersonal:oDbfVir:Seek( Space( 5 ) ) .and. !::oParent:oDetHorasPersonal:oDbfVir:Eof()
         ::oParent:oDetHorasPersonal:oDbfVir:Delete(.f.)
      end if

      if IsChar( ::oDbfVir:cKeyOrd )
         ::oParent:oDetHorasPersonal:oDbfVir:OrdScope( ::oDbfVir:cKeyOrd + Space( 5 ) )
      end if 

      ::lAppendTrabajador  := .f.

   else

      if IsChar( ::oDbfVir:cKeyTra )
         ::oParent:oDetHorasPersonal:oDbfVir:OrdScope( ::oDbfVir:cKeyTra )
      end if 

   end if

   ::oParent:oDetHorasPersonal:oDbfVir:GoTop()

   ::lTiempoEmpleado()

   /*
   Etiquetas-------------------------------------------------------------------
   */

   cSayTra                 := oRetFld( ::oDbfVir:cCodTra, ::oParent:oOperario:oDbf )
   cSaySec                 := oRetFld( ::oDbfVir:cCodSec, ::oParent:oSeccion:oDbf )
   cSayOpe                 := oRetFld( ::oDbfVir:cCodOpe, ::oParent:oOperacion:oDbf )

   /*
   Caja de dialogo-------------------------------------------------------------
   */

   DEFINE DIALOG oDlg RESOURCE "LPersonal" TITLE LblTitle( nMode ) + "partes de personal"

      /*
      Código de personal-------------------------------------------------------
      */

      REDEFINE GET oGetTra VAR ::oDbfVir:cCodTra;
         ID       110 ;
         WHEN     ( nMode == APPD_MODE );
         BITMAP   "LUPA" ;
         OF       oDlg

      oGetTra:bHelp  := {|| ::oParent:oOperario:Buscar( oGetTra ) }
      oGetTra:bValid := {|| ::lValidTrabajador( oGetTra, oGetSec, oGetOpe, oSayTra, nMode ) }

      REDEFINE GET oSayTra VAR cSayTra ;
         ID       111 ;
         WHEN     ( .f. ) ;
			OF 		oDlg

      /*
      Código de la seccion a la q pertenece------------------------------------
      */

      REDEFINE GET oGetSec VAR ::oDbfVir:cCodSec;
         ID       120 ;
         WHEN     ( nMode != ZOOM_MODE );
         BITMAP   "LUPA" ;
         OF       oDlg

      oGetSec:bHelp  := {|| ::oParent:oSeccion:Buscar( oGetSec ) }
      oGetSec:bValid := {|| ::oParent:oSeccion:Existe( oGetSec, oSaySec, "cDesSec", .t., .t., "0" ) }

      REDEFINE GET oSaySec VAR cSaySec ;
         ID       121 ;
         WHEN     ( .f. ) ;
			OF 		oDlg

      /*
      Código de la operacion a la q pertenece----------------------------------
      */

      REDEFINE GET oGetOpe VAR ::oDbfVir:cCodOpe;
         ID       130 ;
         WHEN     ( nMode != ZOOM_MODE );
         BITMAP   "LUPA" ;
         OF       oDlg

      oGetOpe:bHelp  := {|| ::oParent:oOperacion:Buscar( oGetOpe ) }
      oGetOpe:bValid := {|| ::oParent:oOperacion:Existe( oGetOpe, oSayOpe, "cDesOpe", .t., .t., "0" ) }

      REDEFINE GET oSayOpe VAR cSayOpe ;
         ID       131 ;
         WHEN     ( .f. ) ;
			OF 		oDlg

      /*
      Fechas y Horas-----------------------------------------------------------
      */

      REDEFINE GET oFecIni VAR ::oDbfVir:dFecIni ;
         ID       140 ;
			SPINNER ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         OF       oDlg

         oFecIni:bValid    := {|| ::lTiempoEmpleado() }
         oFecIni:bChange   := {|| ::lTiempoEmpleado() }

      REDEFINE GET oFecFin VAR ::oDbfVir:dFecFin ;
         ID       150 ;
			SPINNER ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         OF       oDlg

         oFecFin:bValid    := {|| ::lTiempoEmpleado() }
         oFecFin:bChange   := {|| ::lTiempoEmpleado() }

      REDEFINE GET oHorIni ;
         VAR      ::oDbfVir:cHorIni ;
         PICTURE  "@R 99:99" ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         SPINNER ;
         ON UP    ( UpTime( oHorIni ) );
         ON DOWN  ( DwTime( oHorIni ) );
         ID       141 ;
         OF       oDlg

         oHorIni:bValid    := {|| if( validHourMinutes( oHorIni ), ::lTiempoEmpleado(), .f. ) }
         oHorIni:bChange   := {|| ::lTiempoEmpleado() }

      REDEFINE GET oHorFin ;
         VAR      ::oDbfVir:cHorFin ;
         PICTURE  "@R 99:99" ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         SPINNER ;
         ON UP    ( UpTime( oHorFin ) );
         ON DOWN  ( DwTime( oHorFin ) );
         ID       151 ;
         OF       oDlg

         oHorFin:bValid    := {|| if( validHourMinutes( oHorFin ), ::lTiempoEmpleado(), .f. ) }
         oHorFin:bChange   := {|| ::lTiempoEmpleado() }

      REDEFINE GET ::oTmpEmp ;
         VAR      ::cTmpEmp ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ID       160 ;
         OF       oDlg

      /*
      Precios por horas-------------------------------------------------------
      */

		REDEFINE BUTTON ;
			ID 		500 ;
         OF       oDlg ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( ::oParent:oDetHorasPersonal:Append( ::oBrwHorasTrabajador ) )

		REDEFINE BUTTON ;
			ID 		501 ;
         OF       oDlg ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( ::oParent:oDetHorasPersonal:Edit( ::oBrwHorasTrabajador ) )

		REDEFINE BUTTON ;
			ID 		502 ;
         OF       oDlg ;
         ACTION   ( ::oParent:oDetHorasPersonal:Zoom() )

      REDEFINE BUTTON ;
         ID       503 ;
         OF       oDlg ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( ::oParent:oDetHorasPersonal:Del( ::oBrwHorasTrabajador ) )

      ::oBrwHorasTrabajador                 := IXBrowse():New( oDlg )

      ::oBrwHorasTrabajador:bClrSel         := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      ::oBrwHorasTrabajador:bClrSelFocus    := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      ::oParent:oDetHorasPersonal:oDbfVir:SetBrowse( ::oBrwHorasTrabajador )

      ::oBrwHorasTrabajador:nMarqueeStyle   := 6

      ::oBrwHorasTrabajador:CreateFromResource( 200 )

      with object ( ::oBrwHorasTrabajador:AddCol() )
         :cHeader          := "Código"
         :bStrData         := {|| ::oParent:oDetHorasPersonal:oDbfVir:FieldGetByName( "cCodHra" ) }
         :nWidth           := 60
      end with

      with object ( ::oBrwHorasTrabajador:AddCol() )
         :cHeader          := "Tipo de hora"
         :bStrData         := {|| oRetFld( ::oParent:oDetHorasPersonal:oDbfVir:FieldGetByName( "cCodHra" ), ::oParent:oHoras:oDbf, , "cCodHra" ) }
         :nWidth           := 200
      end with

      with object ( ::oBrwHorasTrabajador:AddCol() )
         :cHeader          := "Horas"
         :bStrData         := {|| Trans( ::oParent:oDetHorasPersonal:oDbfVir:FieldGetByName( "nNumHra" ), "99.99" ) }
         :nWidth           := 60
         :nDataStrAlign    := AL_RIGHT
         :nHeadStrAlign    := AL_RIGHT
      end with

      with object ( ::oBrwHorasTrabajador:AddCol() )
         :cHeader          := "Precio"
         :bStrData         := {|| Trans( ::oParent:oDetHorasPersonal:oDbfVir:FieldGetByName( "nCosHra" ), ::oParent:cPouDiv ) }
         :nWidth           := 80
         :nDataStrAlign    := AL_RIGHT
         :nHeadStrAlign    := AL_RIGHT
      end with

      with object ( ::oBrwHorasTrabajador:AddCol() )
         :cHeader          := "Total"
         :bStrData         := {|| Trans( ::oParent:oDetHorasPersonal:oDbfVir:FieldGetByName( "nNumHra" ) * ::oParent:oDetHorasPersonal:oDbfVir:FieldGetByName( "nCosHra" ), ::oParent:cPorDiv ) }
         :nWidth           := 80
         :nDataStrAlign    := AL_RIGHT
         :nHeadStrAlign    := AL_RIGHT
      end with

      if nMode != ZOOM_MODE
         ::oBrwHorasTrabajador:bLDblClick   := {|| ::oParent:oDetHorasPersonal:Edit( ::oBrwHorasTrabajador ) }
      else
         ::oBrwHorasTrabajador:bLDblClick   := {|| ::oParent:oDetHorasPersonal:Zoom() }
      end if

      REDEFINE BUTTON ;
         ID       IDOK ;
			OF 		oDlg ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( if( ::SaveLines( oGetTra, oSayTra, nMode ), oDlg:end( IDOK ), ) )

		REDEFINE BUTTON ;
         ID       IDCANCEL ;
			OF 		oDlg ;
			ACTION 	( oDlg:end() )

      if nMode != ZOOM_MODE
         oDlg:AddFastKey( VK_F2, {|| ::oParent:oDetHorasPersonal:Append( ::oBrwHorasTrabajador ) } )
         oDlg:AddFastKey( VK_F3, {|| ::oParent:oDetHorasPersonal:Edit( ::oBrwHorasTrabajador ) } )
         oDlg:AddFastKey( VK_F4, {|| ::oParent:oDetHorasPersonal:Del( ::oBrwHorasTrabajador ) } )
         oDlg:AddFastKey( VK_F5, {|| if( ::SaveLines( oGetTra, oSayTra, nMode ), oDlg:end( IDOK ), ) } )
      end if

   ACTIVATE DIALOG oDlg CENTER

   /*
   Quitamos el filtro----------------------------------------------------------
   */

   ::oParent:oDetHorasPersonal:oDbfVir:OrdClearScope()
   ::oParent:oDetHorasPersonal:oDbfVir:OrdSetFocus( nOrdAnt )

RETURN ( oDlg:nResult == IDOK )

//----------------------------------------------------------------------------//

METHOD SaveLines( oGetTra, oSayTra, nMode )

   /*
   Comprobar si el trabajador ya esta en el parte de produccion y existe en la
   base de datos
   */

   if nMode == APPD_MODE

      if !::oParent:oOperario:Existe( oGetTra, oSayTra, "cNomTra", .f., .t., "0" )
         msgStop( "El trabajador " + oGetTra:VarGet() + " no existe en la base de datos." )
         Return .f.
      end if

      /*if ::oDbfVir:SeekBack( oGetTra:VarGet(), "cCodTra" )
         msgStop( "Ya existe un parte para el trabajador " + oGetTra:VarGet() + "." )
         oGetTra:SetFocus()
         Return .f.
      end if*/

   end if

RETURN ( .t. )

//----------------------------------------------------------------------------//

METHOD lValidTrabajador( oGetTra, oGetSec, oGetOpe, oSayTra, nMode )

   local nOrdAnt
   local cCodTra

   /*
   if ::lAppendTrabajador
      Return .t.
   end if

   ::lAppendTrabajador  := .t.
   */

   if Empty( oGetTra:VarGet() )
      Return .t.
   end if

   if !::oParent:oOperario:Existe( oGetTra, oSayTra, "cNomTra", .f., .t., "0" )
      msgStop( "El trabajador " + oGetTra:VarGet() + " no existe en la base de datos." )
      Return .f.
   end if

   cCodTra              := oGetTra:VarGet()

   /*if ::oDbfVir:SeekBack( cCodTra, "cCodTra" )
      msgStop( "Ya existe un parte para el trabajador " + cCodTra + "." )
      Return .f.
   end if*/

   /*
   Este valor no se puede mover------------------------------------------------
   */

   oGetTra:Disable()

   ::oParent:oDetHorasPersonal:oDbfVir:OrdClearScope()
   ::oParent:oDetHorasPersonal:oDbfVir:OrdScope( cCodTra )

   nOrdAnt              := ::oParent:oDetHoras:oDbf:OrdSetFocus( "cCodTra" )

   if nMode == APPD_MODE

      /*
      Cargamos la seccion a la que pertenece-----------------------------------
      */

      if ::oParent:oOperario:oDbf:Seek( cCodTra )

         oGetSec:cText( ::oParent:oOperario:oDbf:cCodSec )
         oGetSec:lValid()

      end if

      if ::oParent:oDetHoras:oDbf:Seek( cCodTra )

         while ::oParent:oDetHoras:oDbf:cCodTra == cCodTra .and. !::oParent:oDetHoras:oDbf:Eof()

            if ::oParent:oDetHoras:oDbf:lDefHor

               ::oParent:oDetHorasPersonal:oDbfVir:Append()

               ::oParent:oDetHorasPersonal:oDbfVir:cCodTra := cCodTra
               ::oParent:oDetHorasPersonal:oDbfVir:cCodHra := ::oParent:oDetHoras:oDbf:cCodHra
               ::oParent:oDetHorasPersonal:oDbfVir:nNumHra := ::cTiempoEmpleado
               ::oParent:oDetHorasPersonal:oDbfVir:nCosHra := ::oParent:oDetHoras:oDbf:nCosHra

               ::oParent:oDetHorasPersonal:oDbfVir:Save()

            end if

            ::oParent:oDetHoras:oDbf:Skip()

         end while

      end if

   end if

   ::oParent:oDetHoras:oDbf:OrdSetFocus( nOrdAnt )

   ::oParent:oDetHorasPersonal:oDbfVir:GoTop()
   ::oParent:oDetHorasPersonal:oDbfVir:GoTop()

   ::oBrwHorasTrabajador:Refresh()

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD cTotTime( oDbf )

   local nHoras
   local nMinutos
   local nTotalMinutos

   DEFAULT oDbf      := ::oDbf

   nTotalMinutos     := nElapTime( oDbf:cIniOpe, oDbf:cFinOpe )

   nHoras            := Int( nTotalMinutos / 60 )
   nMinutos          := Mod( nTotalMinutos, 60 )

RETURN ( StrZero( nHoras, 2 ) + StrZero( nMinutos, 2 ) )

//--------------------------------------------------------------------------//

METHOD lTotTime( oDbf )

   DEFAULT oDbf   := ::oDbf

RETURN ( ::oGetTotalTime:cText( ::cTotTime( oDbf ) ), .t. )

//--------------------------------------------------------------------------//

METHOD nHorasTrabajador( cKeyTra, oDbf )

   local nTotal   := 0

   DEFAULT oDbf   := ::oDbf

   oDbf:GetStatus()
   oDbf:OrdSetFocus( "cNumTra" )

   if oDbf:Seek( cKeyTra )
      while cKeyTra == oDbf:cSerOrd + Str( oDbf:nNumOrd, 9 ) + oDbf:cSufOrd + oDbf:cCodTra .and. !oDbf:Eof()
         nTotal   += oDbf:nNumHra
         oDbf:Skip()
      end while
   end if

   oDbf:SetStatus()

RETURN ( nTotal )

//---------------------------------------------------------------------------//

METHOD nTotalTrabajador( cKeyTra, oDbf )

   local nTotal   := 0

   DEFAULT oDbf   := ::oDbf

   oDbf:GetStatus()
   oDbf:OrdSetFocus( "cNumTra" )

   if oDbf:Seek( cKeyTra )
      while cKeyTra == oDbf:cSerOrd + Str( oDbf:nNumOrd, 9 ) + oDbf:cSufOrd + oDbf:cCodTra .and. !oDbf:Eof()
         nTotal   += oDbf:nNumHra * oDbf:nCosHra
         oDbf:Skip()
      end while
   end if

   oDbf:SetStatus()

RETURN ( nTotal )

//---------------------------------------------------------------------------//

METHOD SaveDetails()

   ::oDbfVir:cSerOrd := ::oParent:oDbf:cSerOrd
   ::oDbfVir:nNumOrd := ::oParent:oDbf:nNumOrd
   ::oDbfVir:cSufOrd := ::oParent:oDbf:cSufOrd

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD DeleteDetails()

   while ::oParent:oDetHorasPersonal:oDbfVir:SeekInOrd( ::oDbfVir:cCodTra, "cCodTra" )
      ::oParent:oDetHorasPersonal:oDbfVir:Delete(.f.)
   end while


RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD lTiempoEmpleado()

   ::cTiempoEmpleado    := nTiempoEntreFechas( ::oDbfVir:FieldGetByName( "dFecIni" ), ::oDbfVir:FieldGetByName( "dFecFin" ), ::oDbfVir:FieldGetByName( "cHorIni" ), ::oDbfVir:FieldGetByName( "cHorFin" ) )
   ::cTmpEmp            := cFormatoDDHHMM( ::cTiempoEmpleado )

   if ::oTmpEmp != nil
      ::oTmpEmp:cText( ::cTmpEmp )
      ::oTmpEmp:Refresh()
   end if

RETURN .t.

//---------------------------------------------------------------------------//

METHOD nTotal( oDbf, oDbfHor, lRound )

   local nTotal   := 0

   DEFAULT oDbf   := ::oDbf
   DEFAULT lRound := .t.

   oDbf:GetStatus()

   oDbf:GoTop()
   while !oDbf:Eof()
      nTotal      += ::nTotalTrabajador( oDbf:cKeyTra, oDbfHor )
      oDbf:Skip()
   end while

   oDbf:SetStatus()

RETURN ( if( lRound, Round( nTotal, ::oParent:nDorDiv ), nTotal ) )

//---------------------------------------------------------------------------//

