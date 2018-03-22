#include "FiveWin.ch"
#include "Factu.ch" 
#include "MesDbf.ch"
#include "Report.ch"
#include "XBrowse.ch"
#include "FastRepH.ch"

#define expAll             0
#define expEnd             1
#define expStand           2
#define expActions         3

memvar oDbf
memvar cDbf
memvar oDbfCol
memvar cDbfCol
memvar oDbfAlm
memvar cDbfAlm
memvar oDbfSec
memvar cDbfSec
memvar cPouDivPro
memvar cDetPro
memvar cDetMat
memvar cDetHPer
memvar cDetMaq
memvar oThis
memvar nPagina
memvar lEnd
memvar cTiempoEmp
memvar nProd
memvar nMat
memvar nPer
memvar nMaq
memvar nParte

//---------------------------------------------------------------------------//

Function StartTExpediente()

   local oExpediente

   oExpediente    := TExpediente():New( cPatEmp(), oWnd(), "expedientes" )
   if !Empty( oExpediente )
      oExpediente:Activate()
   end if

Return nil

//---------------------------------------------------------------------------//

CLASS TExpediente FROM TMasDet

   DATA  cMru                 INIT "gc_folder_document_16"
   DATA  cBitmap              INIT clrTopExpedientes

   DATA  oArt
   DATA  oCli
   DATA  oAlbPrvT
   DATA  oAlbPrvL
   DATA  oFacPrvT
   DATA  oFacPrvL
   DATA  oStock
   DATA  oPro
   DATA  oTblPro
   DATA  oFam
   DATA  oKitArt
   DATA  oDbfDoc
   DATA  oDbfCount
   DATA  oDbfEmp
   DATA  oDbfFilter

   DATA  oDetActuaciones

   DATA  oOperario
   DATA  oSeccion
   DATA  oTipoExpediente
   DATA  oEntidad
   DATA  oColaborador
   DATA  oActuaciones

   DATA  oOperarioActuaciones

   DATA  oGetTotalUnidades
   DATA  nGetTotalUnidades    INIT  0

   DATA  cTmpEmp
   DATA  cTiempoEmpleado      INIT  0

   DATA  oTotProducido
   DATA  oTotMaterias
   DATA  oTotPersonal
   DATA  oTotMaquinaria

   DATA  cOldCodSec           INIT ""
   DATA  cOldCodOpe           INIT ""
   DATA  dOldFecIni           INIT Ctod( "" )
   DATA  dOldFecFin           INIT Ctod( "" )
   DATA  cOldHorIni           INIT ""
   DATA  cOldHorFin           INIT ""

   DATA  aCal
   DATA  cTime

   DATA  lOperarioIndex       INIT .f.

   DATA  oDbfTemporal

   DATA  cFileName

   DATA  oButtonOld

   METHOD New( cPath, oWndParent, oMenuItem )
   METHOD Create( cPath, oWndParent )

   METHOD Activate()

   METHOD OpenFiles( lExclusive )
   METHOD OpenService( lExclusive )

   METHOD CloseFiles()
   METHOD CloseService()

   METHOD DefineFiles()

   METHOD Resource( nMode, aDatosAnterior )

   Method lPreSave( oGetAlm, oGetSec, oGetOpe, oHorFin, nMode, oDlg )

   Method ChangeExpEnd( oFecFin, oHorFin )

   METHOD lTiempoEmpleado( oTmpEmp )

   METHOD nTotUnidades()   INLINE   ( NotCaja( ::oDbf:nCajArt ) * ::oDbf:nUndArt )
   METHOD lTotUnidades()   INLINE   ( ::oGetTotalUnidades:cText( Round( ::nTotUnidades(), ::nDouDiv ) ), .t. )

   METHOD GetNewCount()

   METHOD GenExpediente( nDevice, cCaption, cCodDoc, cPrinter )

   METHOD lGenExpediente( oBrw, oBtn, nDevice )

   METHOD bGenExpediente( nDevice, cTitle, cCodDoc )

   METHOD nGenExpediente( nDevice, cTitle, cCodDoc, cPrinter, nCopy )

   METHOD nEstado( cDocumento )

   METHOD DataReport( oFr )

   METHOD DesignReport( oFr, dbfDoc )

   METHOD PrintReport( nDevice, nCopies, cPrinter, dbfDoc )

   METHOD PrnSerie()

   METHOD StartPrint( cFmtDoc, cDocIni, cDocFin, oDlg, cPrinter, lCopiasPre, nNumCop, lInvOrden )

   Method PutOperarioIndex( nTypeExp, oButton )

   Method QuitOperarioIndex( lExpEnd, oButton )

   Method RestoreOperarioButton()

ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( cPath, oWndParent, oMenuItem )

   DEFAULT cPath           := cPatEmp()
   DEFAULT oWndParent      := GetWndFrame()

   if oMenuItem != nil .and. ::nLevel == nil
      ::nLevel             := nLevelUsr( oMenuItem )
   else
      ::nLevel             := 0
   end if

   if nAnd( ::nLevel, 1 ) != 0
      msgStop( "Acceso no permitido." )
      return nil
   end if

   ::cPath                 := cPath
   ::oWndParent            := oWndParent

   ::cTipoDocumento        := EXP_CLI

   ::bFirstKey             := {|| if( !Empty( ::oDbf ) .and. ( ::oDbf:Used() ), ( ::oDbf:cSerExp + Str( ::oDbf:nNumExp ) + ::oDbf:cSufExp ), "" ) }

   ::oOperario             := TOperarios():Create()

   ::oOperarioActuaciones  := TOperarios():Create()

   ::oColaborador          := TColaboradores():Create()

   ::oTipoExpediente       := TTipoExpediente():CreateInit()

   ::oSeccion              := TSeccion():Create()

   ::oEntidad              := TEntidades():Create()

   ::oActuaciones          := TActuaciones():Create()

   ::oDetActuaciones       := TDetActuacion():New( cPath, cDriver(), Self )
   ::AddDetail( ::oDetActuaciones )

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD Create( cPath, oWndParent )

   DEFAULT cPath           := cPatEmp()
   DEFAULT oWndParent      := GetWndFrame()

   ::cPath                 := cPath
   ::oWndParent            := oWndParent

   ::oOperario             := TOperarios():Create( cPath )

   ::oOperarioActuaciones  := TOperarios():Create( cPath )

   ::oColaborador          := TColaboradores():Create( cPath )

   ::oTipoExpediente       := TTipoExpediente():CreateInit( cPath )

   ::oEntidad              := TEntidades():Create( cPath )

   ::oActuaciones          := TActuaciones():Create( cPath )

   ::oDetActuaciones       := TDetActuacion():New( cPath, cDriver(), Self )
   ::AddDetail( ::oDetActuaciones )

   ::bFirstKey             := {|| if( !Empty( ::oDbf ) .and. ( ::oDbf:Used() ), ( ::oDbf:cSerExp + Str( ::oDbf:nNumExp ) + ::oDbf:cSufExp ), "" ) }

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD Activate()

   local oImp
   local oPrv
   local oPdf
   local oExp
   local oMisExp
   local oPdtExp
   local oFinExp
   local oActExp

   if ::oWndParent != nil
      ::oWndParent:CloseAll()
   end if

   if !::OpenFiles()
      return nil
   end if

   DEFINE SHELL ::oWndBrw FROM 2, 10 TO 18, 70 ;
      XBROWSE ;
      TITLE    "Expedientes" ;
      PROMPT   "Número",;
               "Fecha inicio",;
               "Cliente",;
               "Nombre cliente",;
               "Tipo",;
               "Subtipo",;
               "Operario",;
               "Entidad",;
               "Colaborador";
      MRU      "gc_folder_document_16";
      BITMAP   Rgb( 197, 227, 9 ) ;
      ALIAS    ( ::oDbf ) ;
      APPEND   ::Append() ;
      EDIT     ::Edit() ;
      DELETE   ::Del() ;
      DUPLICAT ::Dup() ;
      OF       ::oWndParent

      // Imagen adicional -----------------------------------------------------

      ::oWndBrw:AddImageList( "gc_worker2_16" )

      // Columnas ---------------------------------------------------------------

      with object ( ::oWndBrw:AddXCol() )
         :cHeader          := "Finalizado"
         :nHeadBmpNo       := 3
         :bStrData         := {|| "" }
         :bEditValue       := {|| ::oDbf:FieldGetByName( "lExpEnd" ) }
         :nWidth           := 20
         :SetCheck( { "Sel16", "Nil16" } )
         :AddResource( "gc_folder_open_check_16" )
      end with

      with object ( ::oWndBrw:AddXCol() )
         :cHeader          := "Estado"
         :nHeadBmpNo       := 4
         :bStrData         := {|| "" }
         :bBmpData         := {|| ::nEstado( ::oDbf:FieldGetByName( "cSerExp" ) + Str( ::oDbf:FieldGetByName( "nNumExp" ) ) + ::oDbf:FieldGetByName( "cSufExp" ) ) }
         :nWidth           := 20
         :AddResource( "gc_delete_12" )
         :AddResource( "gc_shape_square_12" )
         :AddResource( "gc_check_12" )
         :AddResource( "gc_trafficlight_on_16" )
      end with

      with object ( ::oWndBrw:AddXCol() )
         :cHeader          := "Número"
         :cSortOrder       := "cNumExp"
         :bEditValue       := {|| ::oDbf:FieldGetByName( "cSerExp" ) + "/" + AllTrim( Str( ::oDbf:FieldGetByName( "nNumExp" ) ) ) + "/" + ::oDbf:FieldGetByName( "cSufExp" ) }
         :nWidth           := 100
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | ::oWndBrw:ClickOnHeader( oCol ) }
      end with

      with object ( ::oWndBrw:AddXCol() )
         :cHeader          := "Fecha inicio"
         :cSortOrder       := "dFecOrd"
         :bEditValue       := {|| Dtoc( ::oDbf:FieldGetByName( "dFecOrd" ) ) + "-" + Trans( ::oDbf:FieldGetByName( "cHorOrd" ), "@R 99:99" ) }
         :nWidth           := 100
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | ::oWndBrw:ClickOnHeader( oCol ) }
      end with

      with object ( ::oWndBrw:AddXCol() )
         :cHeader          := "Fecha fin"
         :bEditValue       := {|| Dtoc( ::oDbf:FieldGetByName( "dFecVto" ) ) + "-" + Trans( ::oDbf:FieldGetByName( "cHorVto" ), "@R 99:99" ) }
         :nWidth           := 100
      end with

      with object ( ::oWndBrw:AddXCol() )
         :cHeader          := "Cliente"
         :cSortOrder       := "cCodCli"
         :bEditValue       := {|| ::oDbf:FieldGetByName( "cCodCli" ) }
         :nWidth           := 80
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | ::oWndBrw:ClickOnHeader( oCol ) }
      end with

      with object ( ::oWndBrw:AddXCol() )
         :cHeader          := "Nombre cliente"
         :cSortOrder       := "cNomCli"
         :bEditValue       := {|| ::oDbf:FieldGetByName( "cNomCli" ) }
         :nWidth           := 200
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | ::oWndBrw:ClickOnHeader( oCol ) }
      end with

      with object ( ::oWndBrw:AddXCol() )
         :cHeader          := "Tipo"
         :cSortOrder       := "cCodTip"
         :bEditValue       := {|| ::oDbf:FieldGetByName( "cCodTip" ) + " - " + oRetFld( ::oDbf:FieldGetByName( "cCodTip" ), ::oTipoExpediente:oDbf, "cNomTip", "cCodTip" ) }
         :nWidth           := 200
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | ::oWndBrw:ClickOnHeader( oCol ) }
      end with

      with object ( ::oWndBrw:AddXCol() )
         :cHeader          := "Subtipo"
         :cSortOrder       := "cCodSub"
         :bEditValue       := {|| ::oDbf:FieldGetByName( "cCodSub" ) + " - " + oRetFld( ::oDbf:FieldGetByName( "cCodTip" ) + ::oDbf:FieldGetByName( "cCodSub" ), ::oTipoExpediente:oSubTipoExpediente:oDbf, "cNomSub", "cCodSub" ) }
         :nWidth           := 200
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | ::oWndBrw:ClickOnHeader( oCol ) }
      end with

      with object ( ::oWndBrw:AddXCol() )
         :cHeader          := "Operario"
         :cSortOrder       := "cCodTra"
         :bEditValue       := {|| ::oDbf:FieldGetByName( "cCodTra" ) + " - " + oRetFld( ::oDbf:FieldGetByName( "cCodTra" ), ::oOperario:oDbf, "cNomTra", "cCodTra" ) }
         :nWidth           := 200
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | ::oWndBrw:ClickOnHeader( oCol ) }
      end with

      with object ( ::oWndBrw:AddXCol() )
         :cHeader          := "Entidad"
         :cSortOrder       := "cCodEnt"
         :bEditValue       := {|| ::oDbf:FieldGetByName( "cCodEnt" ) + " - " + oRetFld( ::oDbf:FieldGetByName( "cCodEnt" ), ::oEntidad:oDbf, "cDesEnt", "cCodEnt" ) }
         :nWidth           := 200
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | ::oWndBrw:ClickOnHeader( oCol ) }
      end with

      with object ( ::oWndBrw:AddXCol() )
         :cHeader          := "Colaborador"
         :cSortOrder       := "cCodCol"
         :bEditValue       := {|| ::oDbf:FieldGetByName( "cCodCol" ) + " - " + oRetFld( ::oDbf:FieldGetByName( "cCodCol" ), ::oColaborador:oDbf, "cDesCol", "cCodCol" ) }
         :nWidth           := 200
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | ::oWndBrw:ClickOnHeader( oCol ) }
      end with

      ::oWndBrw:CreateXFromCode()

   DEFINE BTNSHELL RESOURCE "BUS" OF ::oWndBrw ;
      NOBORDER ;
      ACTION   ( ::oWndBrw:SearchSetFocus() ) ;
      TOOLTIP  "(B)uscar" ;
      HOTKEY   "B";

      ::oWndBrw:AddSeaBar()

   DEFINE BTNSHELL RESOURCE "NEW" OF ::oWndBrw ;
      NOBORDER ;
      ACTION   ( ::oWndBrw:RecAdd() );
      ON DROP  ( ::oWndBrw:RecAdd() );
      TOOLTIP  "(A)ñadir";
      BEGIN GROUP ;
      HOTKEY   "A" ;
      LEVEL    ACC_APPD

   DEFINE BTNSHELL RESOURCE "DUP" OF ::oWndBrw ;
      NOBORDER ;
      ACTION   ( ::oWndBrw:RecDup() );
      TOOLTIP  "(D)uplicar";
      HOTKEY   "D" ;
      LEVEL    ACC_APPD

   DEFINE BTNSHELL RESOURCE "EDIT" OF ::oWndBrw ;
      NOBORDER ;
      ACTION   ( ::oWndBrw:RecEdit() );
      TOOLTIP  "(M)odificar";
      HOTKEY   "M" ;
      LEVEL    ACC_EDIT

   DEFINE BTNSHELL RESOURCE "ZOOM" OF ::oWndBrw ;
      NOBORDER ;
      ACTION   ( ::Zoom() );
      TOOLTIP  "(Z)oom";
      HOTKEY   "Z" ;
      LEVEL    ACC_ZOOM

   DEFINE BTNSHELL RESOURCE "DEL" OF ::oWndBrw ;
      NOBORDER ;
      ACTION   ( ::oWndBrw:RecDel() );
      TOOLTIP  "(E)liminar";
      HOTKEY   "E";
      LEVEL    ACC_DELE

   DEFINE BTNSHELL oImp RESOURCE "IMP" OF ::oWndBrw ;
      NOBORDER ;
      ACTION   ( ::nGenExpediente( IS_PRINTER ) ) ;
      TOOLTIP  "(I)mprimir";
      HOTKEY   "I";
      LEVEL    ACC_IMPR

      ::lGenExpediente( ::oWndBrw:oBrw, oImp, IS_PRINTER )

   DEFINE BTNSHELL RESOURCE "GC_PRINTER2_" OF ::oWndBrw ;
      NOBORDER ;
      ACTION   ( ::PrnSerie() ) ;
      TOOLTIP  "Imp(r)imir series";
      HOTKEY   "R";
      LEVEL    ACC_IMPR

   DEFINE BTNSHELL oPrv RESOURCE "PREV1" OF ::oWndBrw ;
      NOBORDER ;
      ACTION   ( ::nGenExpediente( IS_SCREEN ) ) ;
      TOOLTIP  "(P)revisualizar";
      HOTKEY   "P";
      LEVEL    ACC_IMPR

      ::lGenExpediente( ::oWndBrw:oBrw, oPrv, IS_SCREEN )

   DEFINE BTNSHELL oPdf RESOURCE "DOCLOCK" OF ::oWndBrw ;
      NOBORDER ;
      ACTION   ( ::nGenExpediente( IS_PDF ) ) ;
      TOOLTIP  "Pd(f)";
      HOTKEY   "F";
      LEVEL    ACC_IMPR

      ::lGenExpediente( ::oWndBrw:oBrw, oPdf, IS_PDF )

   DEFINE BTNSHELL RESOURCE "IMP" OF ::oWndBrw ;
      ACTION   ( EInfDiaExpediente():New( "Diario detallado de expedientes" ):Play() ) ;
      TOOLTIP  "(L)istado";
      HOTKEY   "L";
      LEVEL    ACC_IMPR

   DEFINE BTNSHELL RESOURCE "IMP" OF ::oWndBrw ;
      ACTION   ( EInfDiaActuaciones():New( "Diario detallado de actuaciones" ):Play() ) ;
      TOOLTIP  "Lis(t)ado de actuaciones";
      HOTKEY   "T";
      LEVEL    ACC_IMPR

   if !Empty( oUser():cOperario )

   DEFINE BTNSHELL oExp RESOURCE "Worker2_folder_document_" OF ::oWndBrw ;
      NOBORDER ;
      ACTION   ( oExp:Expand() ) ;
      TOOLTIP  "Mis expedientes" ;
      HOTKEY   "X"

   DEFINE BTNSHELL oMisExp RESOURCE "Worker2_folder_document_" OF ::oWndBrw ;
      NOBORDER ;
      ACTION   ( ::PutOperarioIndex( expAll, oMisExp ) ) ;
      FROM     oExp ;
      TOOLTIP  "Todos" ;
      HOTKEY   "X"

   DEFINE BTNSHELL oPdtExp RESOURCE "Worker2_folder_document_" OF ::oWndBrw ;
      NOBORDER ;
      ACTION   ( ::PutOperarioIndex( expStand, oPdtExp ) ) ;
      FROM     oExp ;
      TOOLTIP  "Pendientes" ;
      HOTKEY   "P"

   DEFINE BTNSHELL oFinExp RESOURCE "Worker2_folder_document_" OF ::oWndBrw ;
      NOBORDER ;
      ACTION   ( ::PutOperarioIndex( expEnd, oFinExp ) ) ;
      FROM     oExp ;
      TOOLTIP  "Finalizados" ;
      HOTKEY   "F"

   DEFINE BTNSHELL oActExp RESOURCE "Worker2_folder_document_" OF ::oWndBrw ;
      NOBORDER ;
      ACTION   ( ::PutOperarioIndex( expActions, oActExp ) ) ;
      FROM     oExp ;
      TOOLTIP  "Actuaciones" ;
      HOTKEY   "T"

   DEFINE BTNSHELL RESOURCE "Worker2_folder_document_" OF ::oWndBrw ;
      NOBORDER ;
      ACTION   ( ::QuitOperarioIndex() ) ;
      FROM     oExp ;
      TOOLTIP  "Quitar mis expedientes" ;
      HOTKEY   "Q"

   end if


   DEFINE BTNSHELL RESOURCE "END" GROUP OF ::oWndBrw ;
      NOBORDER ;
      ACTION   ( ::oWndBrw:end() ) ;
      TOOLTIP  "(S)alir" ;
      HOTKEY   "S"

   if ::cHtmlHelp != nil
      ::oWndBrw:cHtmlHelp  := ::cHtmlHelp
   end if

   ::LoadFilter()

   ACTIVATE WINDOW ::oWndBrw VALID ( ::CloseFiles() )

   if !Empty( oUser():cOperario )

      oExp:Expand()

      ::PutOperarioIndex( nil, oMisExp )

   end if

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD OpenFiles( lExclusive )

   local lOpen          := .t.
   local oError
   local oBlock

   DEFAULT  lExclusive  := .f.

   oBlock               := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      if Empty( ::oDbf )
         ::oDbf         := ::DefineFiles()
      end if
      
      ::oDbf:Activate( .f., !lExclusive )

      ::OpenDetails()

      DATABASE NEW ::oDbfEmp     PATH ( cPatDat() )   FILE "Empresa.Dbf"   VIA ( cDriver() ) SHARED INDEX "Empresa.Cdx"

      DATABASE NEW ::oCli        PATH ( cPatCli() )   FILE "Client.Dbf"    VIA ( cDriver() ) SHARED INDEX "Client.Cdx"

      DATABASE NEW ::oDbfDoc     PATH ( cPatEmp() )   FILE "rDocumen.Dbf"  VIA ( cDriver() ) SHARED INDEX "rDocumen.Cdx"
      ::oDbfDoc:OrdSetFocus( "cTipo" )

      DATABASE NEW ::oDbfCount   PATH ( cPatEmp() )   FILE "nCount.Dbf"    VIA ( cDriver() ) SHARED INDEX "nCount.Cdx"

      DATABASE NEW ::oDbfFilter  PATH ( cPatDat() )   FILE "CnfFlt.Dbf"    VIA ( cDriver() ) SHARED INDEX "CnfFlt.Cdx"

      if !::oTipoExpediente:OpenFiles()
         lOpen          := .f.
      end if

      if !::oOperario:OpenFiles()
         lOpen          := .f.
      end if

      if !::oOperarioActuaciones:OpenFiles()
         lOpen          := .f.
      end if

      if !::oColaborador:OpenFiles()
         lOpen          := .f.
      end if

      if !::oEntidad:OpenFiles()
         lOpen          := .f.
      end if

      if !::oActuaciones:OpenFiles()
         lOpen          := .f.
      end if

   RECOVER USING oError

      lOpen             := .f.

      msgStop( ErrorMessage( oError ), "Imposible abrir todas las bases de datos" )

   END SEQUENCE

   ErrorBlock( oBlock )

   if !lOpen
      ::CloseFiles()
   end if

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD OpenService( lExclusive, cPath )

   local lOpen          := .t.
   local oError
   local oBlock         := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   DEFAULT lExclusive   := .f.

   BEGIN SEQUENCE

      if Empty( ::oDbf )
         ::oDbf         := ::DefineFiles( cPath )
      end if

      ::oDbf:Activate( .f., !lExclusive )

   RECOVER USING oError

      lOpen             := .f.
      
      msgStop( "Imposible abrir todas las bases de datos" + CRLF + ErrorMessage( oError ) )
      
      ::CloseService()

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD CloseService()

   if ::oDbf != nil .and. ::oDbf:Used()
      ::oDbf:End()
   end if

   ::oDbf   := nil

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD CloseFiles()

   ::CloseDetails()

   if ::oCli != nil .and. ::oCli:Used()
      ::oCli:End()
      ::oCli         := nil
   end if

   if ::oDbfDoc != nil .and. ::oDbfDoc:Used()
      ::oDbfDoc:End()
      ::oDbfDoc      := nil
   end if

   if ::oDbfCount != nil .and. ::oDbfCount:Used()
      ::oDbfCount:End()
      ::oDbfCount    := nil
   end if

   if ::oDbfEmp != nil .and. ::oDbfEmp:Used()
      ::oDbfEmp:End()
      ::oDbfEmp      := nil
   end if

   if ::oDbfFilter != nil .and. ::oDbfFilter:Used()
      ::oDbfFilter:End()
      ::oDbfFilter   := nil
   end if

   if ::oOperario != nil
      ::oOperario:End()
      ::oOperario    := nil
   end if

   if ::oOperarioActuaciones != nil
      ::oOperarioActuaciones:End()
      ::oOperarioActuaciones  := nil
   end if

   if ::oColaborador != nil
      ::oColaborador:End()
      ::oColaborador := nil
   end if

   if ::oTipoExpediente != nil
      ::oTipoExpediente:End()
      ::oTipoExpediente := nil
   end if

   if ::oEntidad != nil
      ::oEntidad:End()
      ::oEntidad        := nil
   end if

   if ::oActuaciones != nil
      ::oActuaciones:End()
      ::oActuaciones := nil
   end if

   if ::oDbf != nil .and. ::oDbf:Used()
      ::oDbf:End()
      ::oDbf         := nil
   end if

RETURN ( .t. )

//----------------------------------------------------------------------------//

METHOD DefineFiles( cPath, cDriver )

   local oDbf

   DEFAULT cPath        := ::cPath
   DEFAULT cDriver      := cDriver()

   DEFINE DATABASE oDbf FILE "ExpCab.Dbf" CLASS "ExpCab" ALIAS "ExpCab" PATH ( cPath ) VIA ( cDriver ) COMMENT "Expediente de producción"

      FIELD NAME "cSerExp" TYPE "C" LEN 01  DEC 0 COMMENT "Serie"                                                                       OF oDbf
      FIELD NAME "nNumExp" TYPE "N" LEN 09  DEC 0 COMMENT "Número"                                                                      OF oDbf
      FIELD NAME "cSufExp" TYPE "C" LEN 02  DEC 0 COMMENT "Sufijo"                                                                      OF oDbf
      FIELD NAME "lExpEnd" TYPE "L" LEN 01  DEC 0 COMMENT "Expediente finalizado"                                                       OF oDbf
      FIELD NAME "dFecOrd" TYPE "D" LEN 08  DEC 0 COMMENT "Fecha inicio"                                                                OF oDbf
      FIELD NAME "cHorOrd" TYPE "C" LEN 05  DEC 0 COMMENT "Hora de inicio"          PICTURE "@R 99:99"                                  OF oDbf
      FIELD NAME "dFecVto" TYPE "D" LEN 08  DEC 0 COMMENT "Fecha vencimiento"                                                           OF oDbf
      FIELD NAME "cHorVto" TYPE "C" LEN 05  DEC 0 COMMENT "Hora de vencimiento"     PICTURE "@R 99:99"                                  OF oDbf
      FIELD NAME "cCodCli" TYPE "C" LEN 12  DEC 0 COMMENT "Cliente"                                                                     OF oDbf
      FIELD NAME "cNomCli" TYPE "C" LEN 80  DEC 0 COMMENT "Nombre cliente"                                                              OF oDbf
      FIELD NAME "cCodTip" TYPE "C" LEN 03  DEC 0 COMMENT "Código tipo expediente"                                                      OF oDbf
      FIELD NAME "cCodSub" TYPE "C" LEN 03  DEC 0 COMMENT "Código subtipo expediente"                                                   OF oDbf
      FIELD NAME "cCodSec" TYPE "C" LEN 03  DEC 0 COMMENT "Sección"                                                                     OF oDbf
      FIELD NAME "cCodCol" TYPE "C" LEN 03  DEC 0 COMMENT "Colaborador"                                                                 OF oDbf
      FIELD NAME "cCodTra" TYPE "C" LEN 05  DEC 0 COMMENT "Operario"                                                                    OF oDbf
      FIELD NAME "cCodEnt" TYPE "C" LEN 14  DEC 0 COMMENT "Entidad"                                                                     OF oDbf
      FIELD NAME "dFecAsg" TYPE "D" LEN 08  DEC 0 COMMENT "Fecha de asignación"                                                         OF oDbf

      INDEX TO "ExpCab.Cdx" TAG "cNumExp" ON "cSerExp + Str( nNumExp, 9 ) + cSufExp"   COMMENT "Número"           NODELETED             OF oDbf
      INDEX TO "ExpCab.Cdx" TAG "dFecOrd" ON "dFecOrd"                                 COMMENT "Fecha inicio"     NODELETED             OF oDbf
      INDEX TO "ExpCab.Cdx" TAG "cCodCli" ON "cCodCli"                                 COMMENT "Cliente"          NODELETED             OF oDbf
      INDEX TO "ExpCab.Cdx" TAG "cNomCli" ON "cNomCli"                                 COMMENT "Nombre cliente"   NODELETED             OF oDbf
      INDEX TO "ExpCab.Cdx" TAG "cCodTip" ON "cCodTip"                                 COMMENT "Tipo"             NODELETED             OF oDbf
      INDEX TO "ExpCab.Cdx" TAG "cCodSub" ON "cCodSub"                                 COMMENT "Subtipo"          NODELETED             OF oDbf
      INDEX TO "ExpCab.Cdx" TAG "cCodTra" ON "cCodTra"                                 COMMENT "Operario"         NODELETED             OF oDbf
      INDEX TO "ExpCab.Cdx" TAG "cCodEnt" ON "cCodEnt"                                 COMMENT "Entidad"          NODELETED             OF oDbf
      INDEX TO "ExpCab.Cdx" TAG "cCodCol" ON "cCodCol"                                 COMMENT "Colaborador"      NODELETED             OF oDbf

   END DATABASE oDbf

RETURN ( oDbf )

//---------------------------------------------------------------------------//

METHOD Resource( nMode, aDatosAnterior )

   local oFld
   local oDlg
   local oGetSer
   local oGetCli
   local oGetNom
   local oGetTip
   local oGetSub
   local oSayTip
   local cSayTip
   local oSaySub
   local cSaySub
   local oGetEnt
   local oSayEnt
   local cSayEnt
   local oGetTra
   local oSayTra
   local cSayTra
   local oGetCol
   local oSayCol
   local cSayCol
   local oHorIni
   local oHorFin
   local oTmpEmp
   local oFecAsg
   local oFecIni
   local oFecFin
   local oBrwActuacion
   local oBmpGeneral

   if nMode == APPD_MODE

      if !Empty( cDefSer() )
         ::oDbf:cSerExp    := cDefSer()
      else
         ::oDbf:cSerExp    := "A"
      end if

      ::oDbf:cCodTra       := oUser():cOperario()
      ::oDbf:dFecOrd       := GetSysDate()
      ::oDbf:cHorOrd       := uFieldEmpresa( "cIniJor" )
      ::oDbf:dFecVto       := Ctod( "" )
      ::oDbf:dFecAsg       := GetSysDate()

   end if

   cSayTip                 := oRetFld( ::oDbf:cCodTip, ::oTipoExpediente:oDbf, "cNomTip", "cCodTip" )
   cSaySub                 := oRetFld( ::oDbf:cCodTip + ::oDbf:cCodSub, ::oTipoExpediente:oSubTipoExpediente:oDbf, "cNomSub", "cCodSub" )
   cSayEnt                 := oRetFld( ::oDbf:cCodEnt, ::oEntidad:oDbf, "cDesEnt", "cCodEnt" )
   cSayTra                 := oRetFld( ::oDbf:cCodTra, ::oOperario:oDbf, "cNomTra", "cCodTra" )
   cSayCol                 := oRetFld( ::oDbf:cCodCol, ::oColaborador:oDbf, "cDesCol", "cCodCol" )

   ::lTiempoEmpleado()

   DEFINE DIALOG oDlg RESOURCE "Expediente" TITLE LblTitle( nMode ) + "expedientes"

      REDEFINE FOLDER oFld;
         ID       400 ;
			OF 		oDlg ;
         PROMPT   "&Expedientes" ;
         DIALOGS  "Expediente_1"

      /*
      Serie numero y sufijo del documento--------------------------------------
      */

      REDEFINE BITMAP oBmpGeneral ;
        ID       990 ;
        RESOURCE "gc_folder_document_48" ;
        TRANSPARENT ;
        OF       oFld:aDialogs[1]

      REDEFINE GET oGetSer VAR ::oDbf:cSerExp ;
         ID       100 ;
         PICTURE  "@!" ;
         SPINNER ;
         ON UP    ( UpSerie( oGetSer ) );
         ON DOWN  ( DwSerie( oGetSer ) );
         WHEN     ( nMode == APPD_MODE .or. nMode == DUPL_MODE );
         VALID    ( ::oDbf:cSerExp >= "A" .and. ::oDbf:cSerExp <= "Z" ) ;
			OF 		oFld:aDialogs[1]

      REDEFINE GET ::oDbf:nNumExp ;
			ID 		110 ;
			PICTURE 	"999999999" ;
         WHEN     ( .f. );
			OF 		oFld:aDialogs[1]

      REDEFINE GET ::oDbf:cSufExp ;
         ID       120 ;
         PICTURE  "@!" ;
         WHEN     ( .f. );
			OF 		oFld:aDialogs[1]

      /*
      Expediente finalizado----------------------------------------------------
      */

      REDEFINE CHECKBOX ::oDbf:lExpEnd ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ON CHANGE( ::ChangeExpEnd( oFecFin, oHorFin, oTmpEmp ) ) ;
         ID       160 ;
			OF 		oFld:aDialogs[1]

      /*
      Fecha de asignación, solo la cambia el administrador---------------------
      */

      REDEFINE GET oFecAsg VAR ::oDbf:dFecAsg ;
         ID       170 ;
			SPINNER ;
         WHEN     ( nMode != ZOOM_MODE .and. lUsrMaster() ) ;
         OF       oFld:aDialogs[1]

      /*
      Fecha y horas del documento----------------------------------------------
      */

      REDEFINE GET oFecIni VAR ::oDbf:dFecOrd ;
			ID 		130 ;
			SPINNER ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[1]

      oFecIni:bValid    := {|| ::lTiempoEmpleado( oTmpEmp ) }
      oFecIni:bChange   := {|| ::lTiempoEmpleado( oTmpEmp ) }

      REDEFINE GET oHorIni VAR ::oDbf:cHorOrd ;
         PICTURE  "@R 99:99" ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         SPINNER ;
         ON UP    ( UpTime( oHorIni ) ) ;
         ON DOWN  ( DwTime( oHorIni ) ) ;
         ID       131 ;
         OF       oFld:aDialogs[1]

      oHorIni:bValid    := {|| if( validHourMinutes( oHorIni ), ::lTiempoEmpleado( oTmpEmp ), .f. ) }
      oHorIni:bChange   := {|| ::lTiempoEmpleado( oTmpEmp ) }

      REDEFINE GET oFecFin VAR ::oDbf:dFecVto ;
         ID       140 ;
			SPINNER ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[1]

      oFecFin:bValid    := {|| ::lTiempoEmpleado( oTmpEmp ) }
      oFecFin:bChange   := {|| ::lTiempoEmpleado( oTmpEmp ) }

      REDEFINE GET oHorFin VAR ::oDbf:cHorVto ;
         PICTURE  "@R 99:99" ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         SPINNER ;
         ON UP    ( UpTime( oHorFin ) );
         ON DOWN  ( DwTime( oHorFin ) );
         ID       141 ;
         OF       oFld:aDialogs[1]

      oHorFin:bValid    := {|| if( validHourMinutes( oHorFin ), ::lTiempoEmpleado( oTmpEmp ), .f. ) }
      oHorFin:bChange   := {|| ::lTiempoEmpleado( oTmpEmp ) }

      REDEFINE GET oTmpEmp ;
         VAR      ::cTmpEmp ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ID       150 ;
         OF       oFld:aDialogs[1]

      /*
      Cliente------------------------------------------------------------------
      */

      REDEFINE GET oGetCli VAR ::oDbf:cCodCli ;
         ID       200 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    cClient( oGetCli, ::oCli:cAlias, oGetNom );
         BITMAP   "LUPA" ;
         OF       oFld:aDialogs[1]

      oGetCli:bHelp     := {|| BrwClient( oGetCli, oGetNom ) }

      REDEFINE GET oGetNom VAR ::oDbf:cNomCli  ;
         ID       201 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[1]

      /*
      Tipo---------------------------------------------------------------------
      */

      REDEFINE GET oGetTip VAR ::oDbf:cCodTip ;
         ID       210 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         BITMAP   "LUPA" ;
			OF 		oFld:aDialogs[1]

         oGetTip:bHelp     := {|| ::oTipoExpediente:BuscarEspecial( oGetTip, oGetSub ) }
         oGetTip:bValid    := {|| ::oTipoExpediente:Existe( oGetTip, oSayTip, "cNomTip", .t. ) }

      REDEFINE GET oSayTip VAR cSayTip ;
         ID       211 ;
         WHEN     .f. ;
         OF       oFld:aDialogs[1]

      /*
      Tipo---------------------------------------------------------------------
      */

      REDEFINE GET oGetSub VAR ::oDbf:cCodSub ;
         ID       250 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         BITMAP   "LUPA" ;
			OF 		oFld:aDialogs[1]

         oGetSub:bHelp     := {|| ::oTipoExpediente:BuscarEspecial( oGetTip, oGetSub ) }
         oGetSub:bValid    := {|| ::oTipoExpediente:oSubTipoExpediente:Existe( oGetTip:VarGet() + oGetSub:VarGet(), oSaySub, "cNomSub", .t., .f., nil, "cCodSub" ) }

      REDEFINE GET oSaySub VAR cSaySub ;
         ID       251 ;
         WHEN     .f. ;
         OF       oFld:aDialogs[1]

      /*
      Entidad------------------------------------------------------------------
      */

      REDEFINE GET oGetEnt VAR ::oDbf:cCodEnt ;
         ID       220 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         BITMAP   "LUPA" ;
			OF 		oFld:aDialogs[1]

         oGetEnt:bHelp     := {|| ::oEntidad:Buscar( oGetEnt ) }
         oGetEnt:bValid    := {|| ::oEntidad:Existe( oGetEnt, oSayEnt, "cDesEnt", .t. ) }

      REDEFINE GET oSayEnt VAR cSayEnt ;
         ID       221 ;
         WHEN     .f. ;
         OF       oFld:aDialogs[1]

      /*
      Operario-----------------------------------------------------------------
      */

      REDEFINE GET oGetTra VAR ::oDbf:cCodTra ;
         ID       230 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         BITMAP   "LUPA" ;
			OF 		oFld:aDialogs[1]

         oGetTra:bHelp     := {|| ::oOperario:Buscar( oGetTra ) }
         oGetTra:bValid    := {|| ::oOperario:Existe( oGetTra, oSayTra, "cNomTra", .t., .t., "0" ) }

      REDEFINE GET oSayTra VAR cSayTra ;
         ID       231 ;
         WHEN     .f. ;
         OF       oFld:aDialogs[1]

      /*
      Colaboradores------------------------------------------------------------
      */

      REDEFINE GET oGetCol VAR ::oDbf:cCodCol ;
         ID       240 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         BITMAP   "LUPA" ;
			OF 		oFld:aDialogs[1]

         oGetCol:bHelp     := {|| ::oColaborador:Buscar( oGetCol ) }
         oGetCol:bValid    := {|| ::oColaborador:Existe( oGetCol, oSayCol, "cDesCol", .t., .t., "0" ) }

      REDEFINE GET oSayCol VAR cSayCol ;
         ID       241 ;
         WHEN     .f. ;
         OF       oFld:aDialogs[1]

      /*
      Actuaciones----------------------------------------------------------
      */

      REDEFINE BUTTON ;
			ID 		500 ;
         OF       oFld:aDialogs[1] ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( ::oDetActuaciones:Append( oBrwActuacion ) )

		REDEFINE BUTTON ;
			ID 		501 ;
         OF       oFld:aDialogs[1] ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( ::oDetActuaciones:Edit( oBrwActuacion ) )

		REDEFINE BUTTON ;
			ID 		502 ;
         OF       oFld:aDialogs[1] ;
         ACTION   ( ::oDetActuaciones:Zoom() )

      REDEFINE BUTTON ;
         ID       503 ;
         OF       oFld:aDialogs[1] ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( ::oDetActuaciones:Del( oBrwActuacion ) )

      oBrwActuacion                 := IXBrowse():New( oFld:aDialogs[1] )

      oBrwActuacion:bClrSel         := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      oBrwActuacion:bClrSelFocus    := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      oBrwActuacion:nMarqueeStyle   := 6
      oBrwActuacion:cName           := "Expediente.Lineas de actuacion"

      ::oDetActuaciones:oDbfVir:SetBrowse( oBrwActuacion )

      with object ( oBrwActuacion:AddCol() )
         :cHeader          := "Finalizada"
         :bStrData         := {|| "" }
         :bEditValue       := {|| ::oDetActuaciones:oDbfVir:lActEnd }
         :nWidth           := 65
         :SetCheck( { "Sel16", "Nil16" } )
      end with

      with object ( oBrwActuacion:AddCol() )
         :cHeader          := "Tipo actuación"
         :bStrData         := {|| ::oDetActuaciones:oDbfVir:cCodAct + Space( 1 ) + oRetFld( ::oDetActuaciones:oDbfVir:cCodAct, ::oActuaciones:oDbf, "cDesAct" ) }
         :nWidth           := 255
      end with

      with object ( oBrwActuacion:AddCol() )
         :cHeader          := "Operario"
         :bStrData         := {|| ::oDetActuaciones:oDbfVir:cCodTra + Space( 1 ) + oRetFld( ::oDetActuaciones:oDbfVir:cCodTra, ::oOperarioActuaciones:oDbf, "cNomTra" ) }
         :nWidth           := 255
      end with

      with object ( oBrwActuacion:AddCol() )
         :cHeader          := "Actuación"
         :bEditValue       := {|| Dtoc( ::oDetActuaciones:oDbfVir:dFecIni ) + Space( 1 ) + if( !Empty( ::oDetActuaciones:oDbfVir:cHorIni ), Trans( ::oDetActuaciones:oDbfVir:cHorIni, "@R 99:99" ), "" ) }
         :nWidth           := 135
      end with

      with object ( oBrwActuacion:AddCol() )
         :cHeader          := "Limite"
         :bEditValue       := {|| Dtoc( ::oDetActuaciones:oDbfVir:dFecFin ) + Space( 1 ) + if( !Empty( ::oDetActuaciones:oDbfVir:cHorFin ), Trans( ::oDetActuaciones:oDbfVir:cHorFin, "@R 99:99" ), "" ) }
         :nWidth           := 135
      end with

      oBrwActuacion:CreateFromResource( 300 )

   REDEFINE BUTTON ;
      ID       IDOK ;
		OF 		oDlg ;
      ACTION   ( ::lPreSave( oGetCli, oGetTip, oGetSub, oGetTra, oDlg ) )

   REDEFINE BUTTON ;
      ID       IDCANCEL ;
		OF 		oDlg ;
      ACTION   ( oDlg:end() )

   oDlg:AddFastKey( VK_F2, {|| ::oDetActuaciones:Append( oBrwActuacion ) } )
   oDlg:AddFastKey( VK_F3, {|| ::oDetActuaciones:Edit( oBrwActuacion ) } )
   oDlg:AddFastKey( VK_F4, {|| ::oDetActuaciones:Del( oBrwActuacion ) } )

   oDlg:AddFastKey( VK_F5, {|| ::lPreSave( oGetCli, oGetTip, oGetSub, oGetTra, oDlg ) } )

   ACTIVATE DIALOG oDlg CENTER

   oBmpGeneral:End()

RETURN ( oDlg:nResult == IDOK )

//--------------------------------------------------------------------------//

METHOD lPreSave( oGetCli, oGetTip, oGetSub, oGetTra, oDlg )

   if Empty( oGetCli:VarGet() )
      MsgStop( "Tiene que seleccionar un cliente." )
      oGetCli:SetFocus()
      Return nil
   end if

   if Empty( oGetTip:VarGet() )
      MsgStop( "Tiene que seleccionar un tipo." )
      oGetTip:SetFocus()
      Return nil
   end if

   if Empty( oGetSub:VarGet() )
      MsgStop( "Tiene que seleccionar un subtipo." )
      oGetSub:SetFocus()
      Return nil
   end if

   if Empty( oGetTra:VarGet() )
      MsgStop( "Tiene que seleccionar un trabajador." )
      oGetTra:SetFocus()
      Return nil
   end if

   oDlg:End( IDOK )

Return ( .t. )

//--------------------------------------------------------------------------//

Method ChangeExpEnd( oFecFin, oHorFin, oTmpEmp )

   if ::oDbf:lExpEnd
      oFecFin:cText( GetSysDate() )
      oHorFin:cText( SubStr( Time(), 1, 2 ) + SubStr( Time(), 4, 2 ) )
   else
      oFecFin:cText( Ctod( "" ) )
      oHorFin:cText( Space( 5 ) )
   end if

   if !Empty( oTmpEmp )
      ::lTiempoEmpleado( oTmpEmp )
   end if

return .t.

//---------------------------------------------------------------------------//

METHOD GetNewCount()

   ::oDbf:nNumExp    := nNewDoc( ::oDbf:cSerExp, ::oDbf:nArea, "nExpedi" )

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD lTiempoEmpleado( oTmpEmp )

   ::cTiempoEmpleado    := nTiempoEntreFechas( ::oDbf:dFecOrd, ::oDbf:dFecVto, ::oDbf:cHorOrd, ::oDbf:cHorVto )
   ::cTmpEmp            := cFormatoDDHHMM( ::cTiempoEmpleado )

   if oTmpEmp != nil
      oTmpEmp:cText( ::cTmpEmp )
      oTmpEmp:Refresh()
   end if

RETURN .t.

//---------------------------------------------------------------------------//

METHOD GenExpediente( nDevice, cCaption, cCodDoc, cPrinter, nCopies )

   local oInf
   local oDevice
   local cNumeroParte

   DEFAULT nDevice      := IS_PRINTER
   DEFAULT cCaption     := "Imprimiendo expediente"
   DEFAULT cCodDoc      := cFormatoDocumento( ::oDbf:cSerExp, "nExpedi", ::oDbfCount:cAlias )
   DEFAULT nCopies      := nCopiasDocumento(  ::oDbf:cSerExp, "nExpedi", ::oDbfCount:cAlias )

   if ::oDbf:Lastrec() == 0
      Return nil
   end if

   if Empty( cCodDoc )
      cCodDoc           := if( ::oDbf:cSerExp == "A", "EDA", "EDB" )
   end if

   if !lExisteDocumento( cCodDoc, ::oDbfDoc:cAlias )
      Return nil
   end if

   cNumeroParte         := ::oDbf:cSerExp + Str( ::oDbf:nNumExp ) + ::oDbf:cSufExp

   ::oDbf:GetStatus( .t. )

   if ::oDbf:Seek( cNumeroParte )
      ::PrintReport( nDevice, nCopies, cPrinter, ::oDbfDoc:cAlias )
   end if

   ::oDbf:SetStatus()

RETURN ( NIL )

//---------------------------------------------------------------------------//

METHOD lGenExpediente( oBrw, oBtn, nDevice )

   local bAction

   DEFAULT nDevice   := IS_PRINTER

   if !::oDbfDoc:Seek( "ED" )

      DEFINE BTNSHELL RESOURCE "GC_DOCUMENT_WHITE_" OF ::oWndBrw ;
         NOBORDER ;
         ACTION   ( msgStop( "No hay documentos predefinidos" ) );
         TOOLTIP  "No hay documentos" ;
         HOTKEY   "N";
         FROM     oBtn ;
         CLOSED ;
         LEVEL    ACC_EDIT

   else

      while ::oDbfDoc:cTipo == "ED" .and. !::oDbfDoc:eof()

         bAction  := ::bGenExpediente( nDevice, "Imprimiendo expedientes", ::oDbfDoc:Codigo )

         ::oWndBrw:NewAt( "gc_document_white_", , , bAction, Rtrim( ::oDbfDoc:cDescrip ) , , , , , oBtn )

         ::oDbfDoc:Skip()

      end do

   end if

RETURN nil

//---------------------------------------------------------------------------//

METHOD bGenExpediente( nDevice, cTitle, cCodDoc )

   local bGen
   local nDev        := by( nDevice )
   local cTit        := by( cTitle  )
   local cCod        := by( cCodDoc )

   bGen              := {|| ::nGenExpediente( nDev, cTit, cCod ) }

RETURN ( bGen )

//---------------------------------------------------------------------------//

METHOD nGenExpediente( nDevice, cTitle, cCodDoc, cPrinter, nCopy )

   local nExp
   local nImpYet     := 1

   DEFAULT nDevice   := IS_PRINTER
   DEFAULT nCopy     := nCopiasDocumento( , "nParPrd", ::oDbfCount:cAlias )

   nCopy             := Max( nCopy, 1 )

   CursorWait()

   for each nExp in ( ::oWndBrw:oBrw:aSelected )

      ::oDbf:GoTo( nExp )

      ::GenExpediente( nDevice, cTitle, cCodDoc, cPrinter , nCopy )

   next

   CursorWE()

return nil

//---------------------------------------------------------------------------//
//
// Devuelve el estado en codigo de color Rojo [No iniciado], Ambar [no finalizado], Verde [Finalñizado]
//

METHOD nEstado( cDocumento )

   local nTotal   := 0
   local nFinal   := 0
   local nEstado  := 1
   local nRec     := ::oDetActuaciones:oDbf:Recno()
   local nOrd     := ::oDetActuaciones:oDbf:OrdSetFocus( "cNumExp" )

   if ::oDetActuaciones:oDbf:Seek( cDocumento )

      while ::oDetActuaciones:oDbf:cSerExp + Str( ::oDetActuaciones:oDbf:nNumExp, 9 ) + ::oDetActuaciones:oDbf:cSufExp == cDocumento .and. !::oDetActuaciones:oDbf:Eof()

         nTotal++

         if ::oDetActuaciones:oDbf:lActEnd
            nFinal++
         end if

         ::oDetActuaciones:oDbf:Skip()

      end while

   end if

   ::oDetActuaciones:oDbf:OrdSetFocus( nOrd )
   ::oDetActuaciones:oDbf:GoTo( nRec )

   do case
      case nFinal == 0
         nEstado  := 1
      case nTotal > nFinal
         nEstado  := 2
      case nFinal >= nTotal
         nEstado  := 3
   end case

RETURN ( nEstado )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
#include "FastRepH.ch"

METHOD DataReport( oFr )

   /*
   Zona de datos---------------------------------------------------------------
   */

   oFr:ClearDataSets()

   ::oTipoExpediente:oSubTipoExpediente:oDbf:OrdSetFocus( "cCodSub" )

   oFr:SetWorkArea(     "Expediente", ::oDbf:nArea, .f., { FR_RB_CURRENT, FR_RB_CURRENT, 0 } )
   oFr:SetFieldAliases( "Expediente", cObjectsToReport( ::oDbf ) )

   oFr:SetWorkArea(     "Actuaciones", ::oDetActuaciones:oDbf:nArea )
   oFr:SetFieldAliases( "Actuaciones", cObjectsToReport( ::oDetActuaciones:oDbf ) )

   oFr:SetWorkArea(     "Empresa", ::oDbfEmp:nArea )
   oFr:SetFieldAliases( "Empresa", cItemsToReport( aItmEmp() ) )

   oFr:SetWorkArea(     "Clientes", ::oCli:nArea )
   oFr:SetFieldAliases( "Clientes", cItemsToReport( aItmCli() ) )

   oFr:SetWorkArea(     "Operarios", ::oOperario:oDbf:nArea )
   oFr:SetFieldAliases( "Operarios", cObjectsToReport( ::oOperario:oDbf ) )

   oFr:SetWorkArea(     "Colaboradores", ::oColaborador:oDbf:nArea )
   oFr:SetFieldAliases( "Colaboradores", cObjectsToReport( ::oColaborador:oDbf ) )

   oFr:SetWorkArea(     "Tipo expediente", ::oTipoExpediente:oDbf:nArea )
   oFr:SetFieldAliases( "Tipo expediente", cObjectsToReport( ::oTipoExpediente:oDbf ) )

   oFr:SetWorkArea(     "Subtipo expediente", ::oTipoExpediente:oSubTipoExpediente:oDbf:nArea )
   oFr:SetFieldAliases( "Subtipo expediente", cObjectsToReport( ::oTipoExpediente:oSubTipoExpediente:oDbf ) )

   oFr:SetWorkArea(     "Entidades", ::oEntidad:oDbf:nArea )
   oFr:SetFieldAliases( "Entidades", cObjectsToReport( ::oEntidad:oDbf ) )

   oFr:SetWorkArea(     "Tipos de actuaciones", ::oActuaciones:oDbf:nArea )
   oFr:SetFieldAliases( "Tipos de actuaciones", cObjectsToReport( ::oActuaciones:oDbf ) )

   oFr:SetWorkArea(     "Operarios de actuaciones", ::oOperarioActuaciones:oDbf:nArea )
   oFr:SetFieldAliases( "Operarios de actuaciones", cObjectsToReport( ::oOperarioActuaciones:oDbf ) )

   oFr:SetMasterDetail( "Expediente", "Actuaciones",           {|| ::oDbf:cSerExp + Str( ::oDbf:nNumExp ) + ::oDbf:cSufExp } )
   oFr:SetMasterDetail( "Expediente", "Empresa",               {|| cCodigoEmpresaEnUso() } )
   oFr:SetMasterDetail( "Expediente", "Clientes",              {|| ::oDbf:cCodCli } )
   oFr:SetMasterDetail( "Expediente", "Operario",              {|| ::oDbf:cCodTra } )
   oFr:SetMasterDetail( "Expediente", "Colaboradores",         {|| ::oDbf:cCodCol } )
   oFr:SetMasterDetail( "Expediente", "Entidades",             {|| ::oDbf:cCodEnt } )
   oFr:SetMasterDetail( "Expediente", "Tipo expediente",       {|| ::oDbf:cCodTip } )
   oFr:SetMasterDetail( "Expediente", "Subtipo expediente",    {|| ::oDbf:cCodTip + ::oDbf:cCodSub } )

   oFr:SetMasterDetail( "Actuaciones", "Tipos de actuaciones",       {|| ::oDetActuaciones:oDbf:cCodAct } )
   oFr:SetMasterDetail( "Actuaciones", "Operarios de actuaciones",   {|| ::oDetActuaciones:oDbf:cCodTra } )

   oFr:SetResyncPair(   "Expediente", "Actuaciones" )
   oFr:SetResyncPair(   "Expediente", "Empresa" )
   oFr:SetResyncPair(   "Expediente", "Clientes" )
   oFr:SetResyncPair(   "Expediente", "Operario" )
   oFr:SetResyncPair(   "Expediente", "Colaboradores" )
   oFr:SetResyncPair(   "Expediente", "Entidades" )
   oFr:SetResyncPair(   "Expediente", "Tipo expediente" )
   oFr:SetResyncPair(   "Expediente", "Subtipo expediente" )

   oFr:SetResyncPair(   "Actuaciones", "Tipos de actuaciones" )
   oFr:SetResyncPair(   "Actuaciones", "Operarios de actuaciones" )

Return nil

//---------------------------------------------------------------------------//

METHOD DesignReport( oFr, dbfDoc )

   if ::OpenFiles()

      /*
      Zona de datos------------------------------------------------------------
      */

      ::DataReport( oFr )

      /*
      Paginas y bandas---------------------------------------------------------
      */

      if !Empty( ( dbfDoc )->mReport )

         oFr:LoadFromBlob( ( dbfDoc )->( Select() ), "mReport")

      else

         oFr:SetProperty(     "Report",            "ScriptLanguage", "PascalScript" )

         oFr:AddPage(         "MainPage" )

         oFr:AddBand(         "CabeceraDocumento", "MainPage", frxPageHeader )
         oFr:SetProperty(     "CabeceraDocumento", "Top", 0 )
         oFr:SetProperty(     "CabeceraDocumento", "Height", 200 )

         oFr:AddBand(         "MasterData",  "MainPage", frxMasterData )
         oFr:SetProperty(     "MasterData",  "Top", 200 )
         oFr:SetProperty(     "MasterData",  "Height", 0 )
         oFr:SetProperty(     "MasterData",  "StartNewPage", .t. )
         oFr:SetObjProperty(  "MasterData",  "DataSet", "Expediente" )

         oFr:AddBand(         "DetalleColumnas",   "MainPage", frxDetailData  )
         oFr:SetProperty(     "DetalleColumnas",   "Top", 230 )
         oFr:SetProperty(     "DetalleColumnas",   "Height", 28 )
         oFr:SetObjProperty(  "DetalleColumnas",   "DataSet", "Actuaciones" )
         oFr:SetProperty(     "DetalleColumnas",   "OnMasterDetail", "DetalleOnMasterDetail" )

         oFr:AddBand(         "PieDocumento",      "MainPage", frxPageFooter )
         oFr:SetProperty(     "PieDocumento",      "Top", 930 )
         oFr:SetProperty(     "PieDocumento",      "Height", 110 )

      end if

      /*
      Zona de variables--------------------------------------------------------
      */

      oFr:SetTabTreeExpanded( FR_tvAll, .f. )

      /*
      Diseño de report---------------------------------------------------------
      */

      oFr:DesignReport()

      /*
      Destruye el diseñador----------------------------------------------------
      */

      oFr:DestroyFr()

      /*
      Cierra ficheros----------------------------------------------------------
      */

      ::CloseFiles()

   else

      Return .f.

   end if

Return .t.

//---------------------------------------------------------------------------//

METHOD PrintReport( nDevice, nCopies, cPrinter, dbfDoc )

   local oFr

   DEFAULT nDevice      := IS_SCREEN
   DEFAULT nCopies      := 1
   DEFAULT cPrinter     := PrnGetName()

   SysRefresh()

   oFr                  := frReportManager():New()

   oFr:LoadLangRes(     "Spanish.Xml" )

   oFr:SetIcon( 1 )

   oFr:SetTitle(        "Diseñador de documentos" )

   /*
   Manejador de eventos--------------------------------------------------------
   */

   oFr:SetEventHandler( "Designer", "OnSaveReport", {|| oFr:SaveToBlob( ( dbfDoc )->( Select() ), "mReport" ) } )

   /*
   Zona de datos---------------------------------------------------------------
   */

   ::DataReport( oFr )

   /*
   Cargar el informe-----------------------------------------------------------
   */

   if !Empty( ( dbfDoc )->mReport )

      oFr:LoadFromBlob( ( dbfDoc )->( Select() ), "mReport")

      /*
      Preparar el report-------------------------------------------------------
      */

      oFr:PrepareReport()

      /*
      Imprimir el informe------------------------------------------------------
      */

      do case
         case nDevice == IS_SCREEN
            oFr:ShowPreparedReport()

         case nDevice == IS_PRINTER
            oFr:PrintOptions:SetPrinter( cPrinter )
            oFr:PrintOptions:SetCopies( nCopies )
            oFr:PrintOptions:SetShowDialog( .f. )
            oFr:Print()

         case nDevice == IS_PDF
            oFr:SetProperty(  "PDFExport", "EmbeddedFonts",    .t. )
            oFr:SetProperty(  "PDFExport", "PrintOptimized",   .t. )
            oFr:SetProperty(  "PDFExport", "Outline",          .t. )
            oFr:DoExport(     "PDFExport" )

      end case

   end if

   /*
   Destruye el diseñador-------------------------------------------------------
   */

   oFr:DestroyFr()

Return .t.

//---------------------------------------------------------------------------//

METHOD PrnSerie()

	local oDlg
   local oFmtDoc
   local cFmtDoc     := cSelPrimerDoc( "ED" )
   local oSayFmt
   local cSayFmt
   local oSerIni
   local oSerFin
   local nRecno      := ::oDbf:Recno()
   local nOrdAnt     := ::oDbf:OrdSetFocus( "cNumExp" )
   local cSerIni     := ::oDbf:cSerExp
   local cSerFin     := ::oDbf:cSerExp
   local nDocIni     := ::oDbf:nNumExp
   local nDocFin     := ::oDbf:nNumExp
   local cSufIni     := ::oDbf:cSufExp
   local cSufFin     := ::oDbf:cSufExp
   local oPrinter
   local cPrinter    := PrnGetName()
   local lCopiasPre  := .t.
   local lInvOrden   := .f.
   local oNumCop
   local nNumCop     := nCopiasDocumento( ::oDbf:cSerExp, "nExpedi", ::oDbfCount:cAlias )

   DEFAULT cPrinter  := PrnGetName()

   cSayFmt           := cNombreDoc( cFmtDoc )

   nNumCop           := Max( nNumCop, 1 )

   DEFINE DIALOG oDlg RESOURCE "ImpSerDoc" TITLE "Imprimir series de partes de expedientes"

   REDEFINE GET oSerIni VAR cSerIni ;
      ID       100 ;
      PICTURE  "@!" ;
      UPDATE ;
      SPINNER ;
      ON UP    ( UpSerie( oSerIni ) );
      ON DOWN  ( DwSerie( oSerIni ) );
      VALID    ( cSerIni >= "A" .AND. cSerIni <= "Z"  );
      OF       oDlg

   REDEFINE GET oSerFin VAR cSerFin ;
      ID       110 ;
      PICTURE  "@!" ;
      UPDATE ;
      SPINNER ;
      ON UP    ( UpSerie( oSerFin ) );
      ON DOWN  ( DwSerie( oSerFin ) );
      VALID    ( cSerFin >= "A" .AND. cSerFin <= "Z"  );
      OF       oDlg

   REDEFINE GET nDocIni;
      ID       120 ;
		PICTURE 	"999999999" ;
      SPINNER ;
      OF       oDlg

   REDEFINE GET nDocFin;
      ID       130 ;
		PICTURE 	"999999999" ;
      SPINNER ;
      OF       oDlg

   REDEFINE GET cSufIni ;
      ID       140 ;
      PICTURE  "##" ;
      OF       oDlg

   REDEFINE GET cSufFin ;
      ID       150 ;
      PICTURE  "##" ;
      OF       oDlg

   REDEFINE CHECKBOX lInvOrden ;
      ID       500 ;
      OF       oDlg

   REDEFINE CHECKBOX lCopiasPre ;
      ID       170 ;
      OF       oDlg

   REDEFINE GET oNumCop VAR nNumCop;
      ID       180 ;
      WHEN     !lCopiasPre ;
      VALID    nNumCop > 0 ;
		PICTURE 	"999999999" ;
      SPINNER ;
      MIN      1 ;
      MAX      99999 ;
      OF       oDlg

   REDEFINE GET oFmtDoc VAR cFmtDoc ;
      ID       90 ;
      COLOR    CLR_GET ;
      VALID    ( cDocumento( oFmtDoc, oSayFmt, ::oDbfDoc:cAlias ) ) ;
      BITMAP   "LUPA" ;
      ON HELP  ( BrwDocumento( oFmtDoc, oSayFmt, "ED" ) ) ;
      OF       oDlg

   REDEFINE GET oSayFmt VAR cSayFmt ;
      ID       91 ;
      WHEN     ( .f. );
      COLOR    CLR_GET ;
      OF       oDlg

   TBtnBmp():ReDefine( 92, "gc_document_text_pencil_12",,,,,{|| EdtDocumento( cFmtDoc ) }, oDlg, .f., , .f.,  )

   REDEFINE GET oPrinter VAR cPrinter;
      WHEN     ( .f. ) ;
      ID       160 ;
      OF       oDlg

   TBtnBmp():ReDefine( 161, "gc_printer2_check_16",,,,,{|| PrinterPreferences( oPrinter ) }, oDlg, .f., , .f.,  )

   REDEFINE BUTTON ;
      ID       IDOK ;
		OF 		oDlg ;
      ACTION   (  ::StartPrint( SubStr( cFmtDoc, 1, 3 ), cSerIni + Str( nDocIni, 9 ) + cSufIni, cSerFin + Str( nDocFin, 9 ) + cSufFin, oDlg, cPrinter, lCopiasPre, nNumCop, lInvOrden ),;
                  oDlg:end( IDOK ) )

   REDEFINE BUTTON ;
      ID       IDCANCEL ;
		OF 		oDlg ;
      ACTION   ( oDlg:end() )

   oDlg:bStart := { || oSerIni:SetFocus() }

   oDlg:AddFastKey( VK_F5, {|| ::StartPrint( SubStr( cFmtDoc, 1, 3 ), cSerIni + Str( nDocIni, 9 ) + cSufIni, cSerFin + Str( nDocFin, 9 ) + cSufFin, oDlg, cPrinter, lCopiasPre, nNumCop, lInvOrden ), oDlg:end( IDOK ) } )

   ACTIVATE DIALOG oDlg CENTER

   ::oDbf:GoTo( nRecNo )
   ::oDbf:OrdSetFocus( nOrdAnt )

RETURN NIL

//--------------------------------------------------------------------------//

METHOD StartPrint( cFmtDoc, cDocIni, cDocFin, oDlg, cPrinter, lCopiasPre, nNumCop, lInvOrden )

   oDlg:Disable()

   if !lInvOrden

      ::oDbf:Seek( cDocIni, .t. )

      while ::oDbf:cSerExp + Str( ::oDbf:nNumExp ) + ::oDbf:cSufExp >= cDocIni .and. ;
            ::oDbf:cSerExp + Str( ::oDbf:nNumExp ) + ::oDbf:cSufExp <= cDocFin .and. ;
            !::oDbf:Eof()

         if lCopiasPre

            ::GenExpediente( IS_PRINTER, "Imprimiendo documento : " + ::oDbf:cSerExp + Str( ::oDbf:nNumExp ) + ::oDbf:cSufExp, cFmtDoc, cPrinter, nCopiasDocumento( ::oDbf:cSerExp, "nExpedi", ::oDbfCount:cAlias ) )

         else

            ::GenExpediente( IS_PRINTER, "Imprimiendo documento : " + ::oDbf:cSerExp + Str( ::oDbf:nNumExp ) + ::oDbf:cSufExp, cFmtDoc, cPrinter, nNumCop )

         end if

         ::oDbf:Skip( 1 )

      end do

   else

      ::oDbf:Seek( cDocFin )

      while ::oDbf:cSerExp + Str( ::oDbf:nNumExp ) + ::oDbf:cSufExp >= cDocIni .and.;
            ::oDbf:cSerExp + Str( ::oDbf:nNumExp ) + ::oDbf:cSufExp <= cDocFin .and.;
            !::oDbf:Bof()

         if lCopiasPre

            ::GenExpediente( IS_PRINTER, "Imprimiendo documento : " + ::oDbf:cSerExp + Str( ::oDbf:nNumExp ) + ::oDbf:cSufExp, cFmtDoc, cPrinter, nCopiasDocumento( ::oDbf:cSerExp, "nExpedi", ::oDbfCount:cAlias ) )

         else

            ::nGenExpediente( IS_PRINTER, "Imprimiendo documento : " + ::oDbf:cSerExp + Str( ::oDbf:nNumExp ) + ::oDbf:cSufExp, cFmtDoc, cPrinter, nNumCop )

         end if

         ::oDbf:Skip( -1 )

      end while

   end if

   oDlg:Enable()

RETURN NIL

//---------------------------------------------------------------------------//

Method PutOperarioIndex( nTypeExp, oButton )

   local nItemBitmap

   /*
   Ponemos los bitmaps a lo botones--------------------------------------------
   */

   ::RestoreOperarioButton()

   /*
   Vamos a poner los indices---------------------------------------------------
   */

   nItemBitmap                      := aScan( ::oWndBrw:oImageList:aBitmaps, {|o| Upper( o:cResName ) == Upper( "gc_worker2_16" ) } )
   if nItemBitmap != 0
      nItemBitmap := nItemBitmap - 2
      // TvSetItemImage( ::oWndBrw:oBtnBar:hWnd, oButton:hItem, nItemBitmap )
      ::oWndBrw:oBtnBar:SetItemImage( oButton, nItemBitmap )
   end if

   /*
   Por si hay filtros anteriores-----------------------------------------------
   */

   ::oDbf:SetFilter()

   /*
   Colocamos los filtros por indices-------------------------------------------
   */

   do case
      case ( nTypeExp == expAll )

         ::oWndBrw:oBtnTop:aSay[ 1, 3 ]   := "Expedientes : Operario " + oUser():cOperario + "-" + oRetFld( oUser():cOperario, ::oOperario:oDbf, "cNomTra", "cCodTra" )

         ::oDbf:AddTmpIndex( Auth():Codigo(), GetFileNoExt( ::oDbf:cFile ), ::oDbf:OrdKey(), ( 'cCodTra == "' + Rtrim( oUser():cOperario ) + '"' ), , , , , , , , .t. )

         ::oWndBrw:bChgIndex  := {|| ::oDbf:AddTmpIndex( Auth():Codigo(), GetFileNoExt( ::oDbf:cFile ), ::oDbf:OrdKey(), ( 'cCodTra == "' + Rtrim( oUser():cOperario ) + '"' ), , , , , , , , .t. ) }

      case ( nTypeExp == expEnd )

         ::oWndBrw:oBtnTop:aSay[ 1, 3 ]   := "Expedientes : Finalizados operario " + oUser():cOperario + "-" + oRetFld( oUser():cOperario, ::oOperario:oDbf, "cNomTra", "cCodTra" )

         ::oDbf:AddTmpIndex( Auth():Codigo(), GetFileNoExt( ::oDbf:cFile ), ::oDbf:OrdKey(), ( 'lExpEnd .and. cCodTra == "' + Rtrim( oUser():cOperario ) + '"' ), , , , , , , , .t. )

         ::oWndBrw:bChgIndex  := {|| ::oDbf:AddTmpIndex( Auth():Codigo(), GetFileNoExt( ::oDbf:cFile ), ::oDbf:OrdKey(), ( 'lExpEnd .and. cCodTra == "' + Rtrim( oUser():cOperario ) + '"' ), , , , , , , , .t. ) }

      case ( nTypeExp == expStand )

         ::oWndBrw:oBtnTop:aSay[ 1, 3 ]   := "Expedientes : Pendientes operario " + oUser():cOperario + "-" + oRetFld( oUser():cOperario, ::oOperario:oDbf, "cNomTra", "cCodTra" )

         ::oDbf:AddTmpIndex( Auth():Codigo(), GetFileNoExt( ::oDbf:cFile ), ::oDbf:OrdKey(), ( '!lExpEnd .and. cCodTra == "' + Rtrim( oUser():cOperario ) + '"' ), , , , , , , , .t. )

         ::oWndBrw:bChgIndex  := {|| ::oDbf:AddTmpIndex( Auth():Codigo(), GetFileNoExt( ::oDbf:cFile ), ::oDbf:OrdKey(), ( '!lExpEnd .and. cCodTra == "' + Rtrim( oUser():cOperario ) + '"' ), , , , , , , , .t. ) }

      case ( nTypeExp == expActions )

         ::oWndBrw:oBtnTop:aSay[ 1, 3 ]   := "Expedientes : Con actuaciones operario " + oUser():cOperario + "-" + oRetFld( oUser():cOperario, ::oOperario:oDbf, "cNomTra", "cCodTra" )

         ::oDbf:SetFilter( 'lActuaciones( cSerExp + Str( nNumExp ) + cSufExp,' + '"' + ::oDetActuaciones:oDbf:cAlias + '", "' + Rtrim( oUser():cOperario ) + '")' )

         // ::oWndBrw:bChgIndex  := {|| ::oDbf:SetFilter(), msginfo( "killfilter" ) }

   end case

   /*
   Guardamos el boton al que hemos puesto el filtro----------------------------
   */

   ::oButtonOld                        := oButton

   /*
   Refrescamos el browse-------------------------------------------------------
   */

   ::oDbf:GoTop()

   ::oWndBrw:Refresh()

Return Self

//---------------------------------------------------------------------------//

Method QuitOperarioIndex()

   /*
   Ponemos los bitmaps a lo botones--------------------------------------------
   */

   ::RestoreOperarioButton()

   /*
   Quitamos el codeblock para los cambios de indices---------------------------
   */

   ::oWndBrw:bChgIndex                 := nil

   ::oDbf:OrdSetFocus( ::oWndBrw:oWndBar:GetComboBoxAt() )

   /*
   Refrescamos el browse-------------------------------------------------------
   */

   ::oDbf:GoTop()

   ::oWndBrw:Refresh()

Return Self

//---------------------------------------------------------------------------//

Method RestoreOperarioButton()

   local nItemBitmap

   /*
   Ponemos los botones con su bitmap original----------------------------------
   */

   if !Empty( ::oButtonOld )

      ::oWndBrw:oBtnTop:aSay[ 1, 3 ]   := "Expedientes"

      nItemBitmap                      := aScan( ::oWndBrw:oImageList:aBitmaps, {|o| Upper( o:cResName ) == Upper( "gc_worker2_16" ) } )
      if nItemBitmap != 0
         nItemBitmap := nItemBitmap - 2
         // TvSetItemImage( ::oWndBrw:oBtnBar:hWnd, ::oButtonOld:hItem, nItemBitmap )
         ::oWndBrw:oBtnBar:SetItemImage( ::oButtonOld, nItemBitmap )
      end if

      ::oButtonOld                     := nil

   end if

Return Self

//---------------------------------------------------------------------------//

Function lActuaciones( cDocumento, dbfActuaciones, cOperario )

   local lAct     := .f.
   local nOrd     := ( dbfActuaciones )->( OrdSetFocus( "cNumExp" ) )

   if ( dbfActuaciones )->( dbSeek( cDocumento ) )

      while ( dbfActuaciones )->cSerExp + Str( ( dbfActuaciones )->nNumExp, 9 ) + ( dbfActuaciones )->cSufExp == cDocumento .and. !( dbfActuaciones )->( Eof() )

         if ( dbfActuaciones )->cCodTra == cOperario .and. !( dbfActuaciones )->lActEnd
            lAct  := .t.
         end if

         ( dbfActuaciones )->( dbSkip() )

      end while

   end if

   ( dbfActuaciones )->( OrdSetFocus( nOrd ) )

Return ( lAct )

//---------------------------------------------------------------------------//