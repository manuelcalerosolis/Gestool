#include "FiveWin.Ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS TImpDbfToSql

   DATA oDbfEmpresa     AS OBJECT
   DATA oSqlEmpresa     AS OBJECT

   DATA oBrwEmp         AS OBJECT

   DATA aEmpresas       AS ARRAY    INIT  {}

   DATA oDlgWait
   DATA oMsgWait
   DATA oTxtWait

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHOD Activate( oMenuItem, oWnd )

   METHOD SelEmpresa()

   METHOD AllEmpresa( lSel )

   METHOD Import( oDlg )

   METHOD SynSql( cFile )

   METHOD AppSql( cEmpDbf, cEmpSql, cFile )

END CLASS

//---------------------------------------------------------------------------//

METHOD OpenFiles()

   local oBlock
   local oError
   local lOpenFiles     := .t.

   oBlock               := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      DATABASE NEW ::oDbfEmpresa  PATH ( cPatDat() ) FILE "EMPRESA.DBF" VIA ( cLocalDriver() )      SHARED INDEX "EMPRESA.CDX"

      DATABASE NEW ::oSqlEmpresa  PATH ( cPatDat() ) FILE "EMPRESA.DBF" VIA ( cDriver() ) SHARED INDEX "EMPRESA.CDX"

   RECOVER USING oError

      msgStop( ErrorMessage( oError ), "Imposible abrir las bases de datos" )

      ::CloseFiles()

      lOpenFiles     := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpenfiles )

//---------------------------------------------------------------------------//

METHOD CloseFiles()

   if !Empty( ::oDbfEmpresa )
      ::oDbfEmpresa:End()
   end if

   if !Empty( ::oSqlEmpresa )
      ::oSqlEmpresa:End()
   end if

   ::oDbfEmpresa  := nil
   ::oSqlEmpresa  := nil

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD Activate( oMenuItem, oWnd )

   local oDlg
   local oBmp
   local nBmp           := LoadBitmap( GetResources(), "BGREEN" )

   DEFAULT  oMenuItem   := "01112"
   DEFAULT  oWnd        := oWnd()

   ::aEmpresas          := {}

   // Nivel de usuario---------------------------------------------------------

   if nLevelUsr( oMenuItem ) == 5
      msgStop( "Acceso no permitido." )
      return nil
   end if

   // Cerramos todas las ventanas----------------------------------------------

   if oWnd != nil
      SysRefresh(); oWnd:CloseAll(); SysRefresh()
   end if

   //Comprobamos que sea un proceso exclusivo----------------------------------

   if nUsrInUse() > 1
      msgStop( "Hay más de un usuario conectado a la aplicación", "Atención" )
      return nil
   end if

   if !::OpenFiles()
      return nil
    end if

   //Meto todas las empresas en un array---------------------------------------

   while !::oDbfEmpresa:Eof()
      aAdd( ::aEmpresas, SEmpresa():New( .f., ::oDbfEmpresa:CodEmp, ::oDbfEmpresa:cNombre ) )
      ::oDbfEmpresa:Skip()
   end do

   //Montamos el diálogo-------------------------------------------------------

   DEFINE DIALOG oDlg RESOURCE "TIMPDBFTOSQL"

   REDEFINE BITMAP oBmp;
      RESOURCE "ConvertirDBFtoSQL" ;
      ID       100 ;
      OF       oDlg

   REDEFINE BUTTON;
      ID       110 ;
      OF       oDlg ;
      ACTION   ( ::SelEmpresa() )

   REDEFINE BUTTON;
      ID       120 ;
      OF       oDlg ;
      ACTION   ( ::AllEmpresa( .t. ) )

   REDEFINE BUTTON;
      ID       130 ;
      OF       oDlg ;
      ACTION   ( ::AllEmpresa( .f. ) )

   REDEFINE LISTBOX ::oBrwEmp ;
      FIELDS      If ( ::aEmpresas[ ::oBrwEmp:nAt ]:lSelect, nBmp, "" ),;
                  ::aEmpresas[ ::oBrwEmp:nAt ]:cCodigo,;
                  ::aEmpresas[ ::oBrwEmp:nAt ]:cNombre ;
      HEAD        "S",;
                  "Código",;
                  "Nombre" ;
      FIELDSIZES  17,;
                  50,;
                  250;
      ID          140 ;
      OF          oDlg

   ::oBrwEmp:SetArray( ::aEmpresas )
   ::oBrwEmp:bLDblClick     := {|| ::SelEmpresa() }
   ::oBrwEmp:aJustify       := { .f., .f., .f. }

   REDEFINE BUTTON;
      ID       500 ;
      OF       oDlg ;
      ACTION   ( ::Import( oDlg ) )

   REDEFINE BUTTON;
      ID       550 ;
      OF       oDlg ;
      ACTION   ( oDlg:End() )

   ACTIVATE DIALOG oDlg CENTER

   oDlg:AddFastKey( VK_F5, {|| ::Import( oDlg ) } )

   ::CloseFiles()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD SelEmpresa()

   ::aEmpresas[ ::oBrwEmp:nAt ]:lSelect := !::aEmpresas[ ::oBrwEmp:nAt ]:lSelect

   ::oBrwEmp:Refresh()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD AllEmpresa( lSel )

   aEval( ::aEmpresas, { |aItem| aItem:lSelect := lSel } )

   ::oBrwEmp:Refresh()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD Import( oDlg )

   local aEmpresa
   local cMsgWait    := "Procesando"
   local cTxtWait    := ""
   local cTitle      := "Espere por favor..."
   local lSynDat     := .f.

   CursorWait()

   oDlg:Disable()

   DEFINE DIALOG ::oDlgWait NAME "WAIT_MOVE" TITLE cTitle

   TAnimat():Redefine( ::oDlgWait, 100, { "BAR_01" }, 1 )

   REDEFINE SAY ::oMsgWait PROMPT cMsgWait ID 110 OF ::oDlgWait

   REDEFINE SAY ::oTxtWait PROMPT cTxtWait ID 120 OF ::oDlgWait

   ACTIVATE DIALOG ::oDlgWait CENTER NOWAIT

   for each aEmpresa in ::aEmpresas

      if aEmpresa:lSelect  //Comprobamos que la empresa esté seleccionada---

         ::oDlgWait:cTitle( "Importando empresa: " + aEmpresa:cCodigo + " - " + aEmpresa:cNombre )

         //Pasamos el registro de la empresa desde DBF a SQL ------------------

         ::oMsgWait:SetText( "Añadiendo el registro a la nueva tabla de empresas" )

         if !::oSqlEmpresa:SeekInOrd( aEmpresa:cCodigo, "CodEmp" ) .and. ;
            ::oDbfEmpresa:SeekInOrd( aEmpresa:cCodigo, "CodEmp" )

            dbPass( ::oDbfEmpresa:cAlias, ::oSqlEmpresa:cAlias, .t. )

         else

            ::oMsgWait:SetText( "Empresa existente" )

         end if

         //Creamos la estructura de la nueva empresa---------------------------

         mkPathEmp( aEmpresa:cCodigo, aEmpresa:cNombre, , , .f., .f., , ::oMsgWait )

         //Pasamos los datos de las tablas una a una---------------------------

         if !lSynDat

            ::oMsgWait:SetText( "Sincronizando el directorio de datos" )

            ::SynSql( "Users" )
            ::SynSql( "Mapas" )

            ::SynSql( "Divisas" )

            ::SynSql( "TVta" )

            ::SynSql( "TIva" )

            ::SynSql( "TMov" )

            ::SynSql( "TBlCnv" )

            ::SynSql( "CnfFlt" )

            ::SynSql( "AgendaUsr" )

            ::SynSql( "Agenda" )

            ::SynSql( "Cajas" )

            ::SynSql( "ImpTik" )
            ::SynSql( "Visor" )
            ::SynSql( "CajPorta" )

            ::SynSql( "Situa" )

            ::SynSql( "TipoNotas" )

            ::SynSql( "Captura" )
            ::SynSql( "CapturaCampos" )

            lSynDat  := .t.

         end if

         //Pasamos los datos de las tablas una a una---------------------------

         ::oMsgWait:SetText( "Convirtiendo las tablas de familias" )
         ::AppSql( "EMP" + aEmpresa:cCodigo, "EMP" + aEmpresa:cCodigo, "FAMILIAS" )
         ::AppSql( "EMP" + aEmpresa:cCodigo, "EMP" + aEmpresa:cCodigo, "FAMPRV" )

         ::oMsgWait:SetText( "Convirtiendo las tablas de categorias" )
         ::AppSql( "EMP" + aEmpresa:cCodigo, "EMP" + aEmpresa:cCodigo, "CATEGORIAS" )

         ::oMsgWait:SetText( "Convirtiendo las tablas de grupos de familias")
         ::AppSql( "EMP" + aEmpresa:cCodigo, "EMP" + aEmpresa:cCodigo, "GRPFAM" )

         ::oMsgWait:SetText( "Convirtiendo las tablas de grupos de clientes" )
         ::AppSql( "EMP" + aEmpresa:cCodigo, "EMP" + aEmpresa:cCodigo, "GRPCLI" )

         ::oMsgWait:SetText( "Convirtiendo las tablas de grupos de proveedor" )
         ::AppSql( "EMP" + aEmpresa:cCodigo, "EMP" + aEmpresa:cCodigo, "GRPPRV" )

         ::oMsgWait:SetText( "Convirtiendo las tablas de remesas" )
         ::AppSql( "EMP" + aEmpresa:cCodigo, "EMP" + aEmpresa:cCodigo, "CTAREM" )

         ::oMsgWait:SetText( "Convirtiendo las tablas de tipos de artículos" )
         ::AppSql( "EMP" + aEmpresa:cCodigo, "EMP" + aEmpresa:cCodigo, "TIPART" )

         ::oMsgWait:SetText( "Convirtiendo las tablas de catalogos" )
         ::AppSql( "EMP" + aEmpresa:cCodigo, "EMP" + aEmpresa:cCodigo, "CATALOGO" )

         ::oMsgWait:SetText( "Convirtiendo las tablas de unidades de medición" )
         ::AppSql( "EMP" + aEmpresa:cCodigo, "EMP" + aEmpresa:cCodigo, "UNDMED" )

         ::oMsgWait:SetText( "Convirtiendo las tablas de frases publicitarias" )
         ::AppSql( "EMP" + aEmpresa:cCodigo, "EMP" + aEmpresa:cCodigo, "FRAPUB" )

         ::oMsgWait:SetText( "Convirtiendo las tablas de impuestos especiales" )
         ::AppSql( "EMP" + aEmpresa:cCodigo, "EMP" + aEmpresa:cCodigo, "NEWIMP" )

         ::oMsgWait:SetText( "Convirtiendo las tablas de transportistas" )
         ::AppSql( "EMP" + aEmpresa:cCodigo, "EMP" + aEmpresa:cCodigo, "TRANSPOR" )

         ::oMsgWait:SetText( "Convirtiendo las tablas de paises" )
         ::AppSql( "EMP" + aEmpresa:cCodigo, "EMP" + aEmpresa:cCodigo, "PAIS" )

         ::oMsgWait:SetText( "Convirtiendo las tablas de formas de pago" )
         ::AppSql( "EMP" + aEmpresa:cCodigo, "EMP" + aEmpresa:cCodigo, "FPAGO" )

         ::oMsgWait:SetText( "Convirtiendo las tablas de documentos" )
         ::AppSql( "EMP" + aEmpresa:cCodigo, "EMP" + aEmpresa:cCodigo, "RDOCUMEN" )
         ::AppSql( "EMP" + aEmpresa:cCodigo, "EMP" + aEmpresa:cCodigo, "RITEMS" )
         ::AppSql( "EMP" + aEmpresa:cCodigo, "EMP" + aEmpresa:cCodigo, "RCOLUM" )
         ::AppSql( "EMP" + aEmpresa:cCodigo, "EMP" + aEmpresa:cCodigo, "RBITMAP" )
         ::AppSql( "EMP" + aEmpresa:cCodigo, "EMP" + aEmpresa:cCodigo, "RBOX" )

         ::oMsgWait:SetText( "Convirtiendo las formatos de tickets" )
         ::AppSql( "EMP" + aEmpresa:cCodigo, "EMP" + aEmpresa:cCodigo, "RTikDoc" )
         ::AppSql( "EMP" + aEmpresa:cCodigo, "EMP" + aEmpresa:cCodigo, "RTikDet" )

         ::oMsgWait:SetText( "Convirtiendo las promociones" )
         ::AppSql( "EMP" + aEmpresa:cCodigo, "EMP" + aEmpresa:cCodigo, "PromoT" )
         ::AppSql( "EMP" + aEmpresa:cCodigo, "EMP" + aEmpresa:cCodigo, "PromoL" )
         ::AppSql( "EMP" + aEmpresa:cCodigo, "EMP" + aEmpresa:cCodigo, "PromoC" )

         ::oMsgWait:SetText( "Convirtiendo los artículos" )
         ::AppSql( "EMP" + aEmpresa:cCodigo, "EMP" + aEmpresa:cCodigo, "Articulo"  )
         ::AppSql( "EMP" + aEmpresa:cCodigo, "EMP" + aEmpresa:cCodigo, "ProvArt"   )
         ::AppSql( "EMP" + aEmpresa:cCodigo, "EMP" + aEmpresa:cCodigo, "ArtDiv"    )
         ::AppSql( "EMP" + aEmpresa:cCodigo, "EMP" + aEmpresa:cCodigo, "ArtKit"    )
         ::AppSql( "EMP" + aEmpresa:cCodigo, "EMP" + aEmpresa:cCodigo, "ArtCodebar")

         ::oMsgWait:SetText( "Convirtiendo los clientes" )
         ::AppSql( "EMP" + aEmpresa:cCodigo, "EMP" + aEmpresa:cCodigo, "Client"  )
         ::AppSql( "EMP" + aEmpresa:cCodigo, "EMP" + aEmpresa:cCodigo, "CliAtp"  )
         ::AppSql( "EMP" + aEmpresa:cCodigo, "EMP" + aEmpresa:cCodigo, "ObrasT"  )
         ::AppSql( "EMP" + aEmpresa:cCodigo, "EMP" + aEmpresa:cCodigo, "CliBnc"  )
         ::AppSql( "EMP" + aEmpresa:cCodigo, "EMP" + aEmpresa:cCodigo, "CliInc"  )
         ::AppSql( "EMP" + aEmpresa:cCodigo, "EMP" + aEmpresa:cCodigo, "ClientD" )

         ::oMsgWait:SetText( "Convirtiendo los proveedores" )
         ::AppSql( "EMP" + aEmpresa:cCodigo, "EMP" + aEmpresa:cCodigo, "Provee"  )
         ::AppSql( "EMP" + aEmpresa:cCodigo, "EMP" + aEmpresa:cCodigo, "PrvBnc"  )
         ::AppSql( "EMP" + aEmpresa:cCodigo, "EMP" + aEmpresa:cCodigo, "ProveeD" )

         ::oMsgWait:SetText( "Convirtiendo los agentes" )
         ::AppSql( "EMP" + aEmpresa:cCodigo, "EMP" + aEmpresa:cCodigo, "Agentes" )
         ::AppSql( "EMP" + aEmpresa:cCodigo, "EMP" + aEmpresa:cCodigo, "AgeCom"  )

         ::oMsgWait:SetText( "Convirtiendo las rutas" )
         ::AppSql( "EMP" + aEmpresa:cCodigo, "EMP" + aEmpresa:cCodigo, "Ruta" )

         ::oMsgWait:SetText( "Convirtiendo los almacenes" )
         ::AppSql( "EMP" + aEmpresa:cCodigo, "EMP" + aEmpresa:cCodigo, "Almacen" )

         ::oMsgWait:SetText( "Convirtiendo los ubicaciones" )
         ::AppSql( "EMP" + aEmpresa:cCodigo, "EMP" + aEmpresa:cCodigo, "UbicaT" )
         ::AppSql( "EMP" + aEmpresa:cCodigo, "EMP" + aEmpresa:cCodigo, "UbicaL" )

         ::oMsgWait:SetText( "Convirtiendo historicos de movimientos" )
         ::AppSql( "EMP" + aEmpresa:cCodigo, "EMP" + aEmpresa:cCodigo, "HisMov" )

         ::oMsgWait:SetText( "Convirtiendo grupos de ventas" )
         ::AppSql( "EMP" + aEmpresa:cCodigo, "EMP" + aEmpresa:cCodigo, "GrpVent" )

         ::oMsgWait:SetText( "Convirtiendo pedidos a proveedor" )
         ::AppSql( "EMP" + aEmpresa:cCodigo, "EMP" + aEmpresa:cCodigo, "PedProvT" )
         ::AppSql( "EMP" + aEmpresa:cCodigo, "EMP" + aEmpresa:cCodigo, "PedProvL" )
         ::AppSql( "EMP" + aEmpresa:cCodigo, "EMP" + aEmpresa:cCodigo, "PedPrvI" )
         ::AppSql( "EMP" + aEmpresa:cCodigo, "EMP" + aEmpresa:cCodigo, "PedPrvD" )

         ::oMsgWait:SetText( "Convirtiendo albaranes a proveedor" )
         ::AppSql( "EMP" + aEmpresa:cCodigo, "EMP" + aEmpresa:cCodigo, "AlbProvT" )
         ::AppSql( "EMP" + aEmpresa:cCodigo, "EMP" + aEmpresa:cCodigo, "AlbProvL" )
         ::AppSql( "EMP" + aEmpresa:cCodigo, "EMP" + aEmpresa:cCodigo, "AlbPrvI" )
         ::AppSql( "EMP" + aEmpresa:cCodigo, "EMP" + aEmpresa:cCodigo, "AlbPrvD" )

         ::oMsgWait:SetText( "Convirtiendo facturas a proveedor" )
         ::AppSql( "EMP" + aEmpresa:cCodigo, "EMP" + aEmpresa:cCodigo, "FacPrvT" )
         ::AppSql( "EMP" + aEmpresa:cCodigo, "EMP" + aEmpresa:cCodigo, "FacPrvL" )
         ::AppSql( "EMP" + aEmpresa:cCodigo, "EMP" + aEmpresa:cCodigo, "FacPrvI" )
         ::AppSql( "EMP" + aEmpresa:cCodigo, "EMP" + aEmpresa:cCodigo, "FacPrvD" )

         ::oMsgWait:SetText( "Convirtiendo recibos a proveedor" )
         ::AppSql( "EMP" + aEmpresa:cCodigo, "EMP" + aEmpresa:cCodigo, "FacPrvP" )

         ::oMsgWait:SetText( "Convirtiendo presupuestos de clientes" )
         ::AppSql( "EMP" + aEmpresa:cCodigo, "EMP" + aEmpresa:cCodigo, "PreCliT" )
         ::AppSql( "EMP" + aEmpresa:cCodigo, "EMP" + aEmpresa:cCodigo, "PreCliL" )
         ::AppSql( "EMP" + aEmpresa:cCodigo, "EMP" + aEmpresa:cCodigo, "PreCliI" )
         ::AppSql( "EMP" + aEmpresa:cCodigo, "EMP" + aEmpresa:cCodigo, "PreCliD" )

         ::oMsgWait:SetText( "Convirtiendo pedidos de clientes" )
         ::AppSql( "EMP" + aEmpresa:cCodigo, "EMP" + aEmpresa:cCodigo, "PedCliT" )
         ::AppSql( "EMP" + aEmpresa:cCodigo, "EMP" + aEmpresa:cCodigo, "PedCliL" )
         ::AppSql( "EMP" + aEmpresa:cCodigo, "EMP" + aEmpresa:cCodigo, "PedCliI" )
         ::AppSql( "EMP" + aEmpresa:cCodigo, "EMP" + aEmpresa:cCodigo, "PedCliD" )
         ::AppSql( "EMP" + aEmpresa:cCodigo, "EMP" + aEmpresa:cCodigo, "PedCliP" )

         ::oMsgWait:SetText( "Convirtiendo albaranes de clientes" )
         ::AppSql( "EMP" + aEmpresa:cCodigo, "EMP" + aEmpresa:cCodigo, "AlbCliT" )
         ::AppSql( "EMP" + aEmpresa:cCodigo, "EMP" + aEmpresa:cCodigo, "AlbCliL" )
         ::AppSql( "EMP" + aEmpresa:cCodigo, "EMP" + aEmpresa:cCodigo, "AlbCliI" )
         ::AppSql( "EMP" + aEmpresa:cCodigo, "EMP" + aEmpresa:cCodigo, "AlbCliD" )
         ::AppSql( "EMP" + aEmpresa:cCodigo, "EMP" + aEmpresa:cCodigo, "AlbCliP" )

         ::oMsgWait:SetText( "Convirtiendo facturas de clientes" )
         ::AppSql( "EMP" + aEmpresa:cCodigo, "EMP" + aEmpresa:cCodigo, "FacCliT" )
         ::AppSql( "EMP" + aEmpresa:cCodigo, "EMP" + aEmpresa:cCodigo, "FacCliL" )
         ::AppSql( "EMP" + aEmpresa:cCodigo, "EMP" + aEmpresa:cCodigo, "FacCliI" )
         ::AppSql( "EMP" + aEmpresa:cCodigo, "EMP" + aEmpresa:cCodigo, "FacCliD" )

         ::oMsgWait:SetText( "Convirtiendo recibos de clientes" )
         ::AppSql( "EMP" + aEmpresa:cCodigo, "EMP" + aEmpresa:cCodigo, "FacCliP" )

         ::oMsgWait:SetText( "Convirtiendo facturas rectificativas de clientes" )
         ::AppSql( "EMP" + aEmpresa:cCodigo, "EMP" + aEmpresa:cCodigo, "FacRecT" )
         ::AppSql( "EMP" + aEmpresa:cCodigo, "EMP" + aEmpresa:cCodigo, "FacRecL" )
         ::AppSql( "EMP" + aEmpresa:cCodigo, "EMP" + aEmpresa:cCodigo, "FacRecI" )
         ::AppSql( "EMP" + aEmpresa:cCodigo, "EMP" + aEmpresa:cCodigo, "FacRecD" )

         ::oMsgWait:SetText( "Convirtiendo entradas y salidas de caja" )
         ::AppSql( "EMP" + aEmpresa:cCodigo, "EMP" + aEmpresa:cCodigo, "EntSal" )

         ::oMsgWait:SetText( "Convirtiendo sesiones" )
         ::AppSql( "EMP" + aEmpresa:cCodigo, "EMP" + aEmpresa:cCodigo, "Turno" )
         ::AppSql( "EMP" + aEmpresa:cCodigo, "EMP" + aEmpresa:cCodigo, "TurnoC" )
         ::AppSql( "EMP" + aEmpresa:cCodigo, "EMP" + aEmpresa:cCodigo, "TurnoL" )

         ::oMsgWait:SetText( "Convirtiendo ordenes de carga" )
         ::AppSql( "EMP" + aEmpresa:cCodigo, "EMP" + aEmpresa:cCodigo, "OrdCarP" )

         ::oMsgWait:SetText( "Convirtiendo tikets de clientes" )
         ::AppSql( "EMP" + aEmpresa:cCodigo, "EMP" + aEmpresa:cCodigo, "TikeT" )
         ::AppSql( "EMP" + aEmpresa:cCodigo, "EMP" + aEmpresa:cCodigo, "TikeL" )
         ::AppSql( "EMP" + aEmpresa:cCodigo, "EMP" + aEmpresa:cCodigo, "TikeP" )
         ::AppSql( "EMP" + aEmpresa:cCodigo, "EMP" + aEmpresa:cCodigo, "TikeC" )

         ::oMsgWait:SetText( "Convirtiendo depositos" )
         ::AppSql( "EMP" + aEmpresa:cCodigo, "EMP" + aEmpresa:cCodigo, "DepAgeT" )
         ::AppSql( "EMP" + aEmpresa:cCodigo, "EMP" + aEmpresa:cCodigo, "DepAgeL" )

         ::oMsgWait:SetText( "Convirtiendo existencias" )
         ::AppSql( "EMP" + aEmpresa:cCodigo, "EMP" + aEmpresa:cCodigo, "ExtAgeT" )
         ::AppSql( "EMP" + aEmpresa:cCodigo, "EMP" + aEmpresa:cCodigo, "ExtAgeL" )

         ::oMsgWait:SetText( "Convirtiendo remesas de clientes" )
         ::AppSql( "EMP" + aEmpresa:cCodigo, "EMP" + aEmpresa:cCodigo, "RemCliT" )

         ::oMsgWait:SetText( "Convirtiendo anticipos de clientes" )
         ::AppSql( "EMP" + aEmpresa:cCodigo, "EMP" + aEmpresa:cCodigo, "AntCliT" )
         ::AppSql( "EMP" + aEmpresa:cCodigo, "EMP" + aEmpresa:cCodigo, "AntCliI" )
         ::AppSql( "EMP" + aEmpresa:cCodigo, "EMP" + aEmpresa:cCodigo, "AntCliD" )

         ::oMsgWait:SetText( "Convirtiendo movimientos de almacen" )
         ::AppSql( "EMP" + aEmpresa:cCodigo, "EMP" + aEmpresa:cCodigo, "RemMovT" )

         ::oMsgWait:SetText( "Convirtiendo logs de envio" )
         ::AppSql( "EMP" + aEmpresa:cCodigo, "EMP" + aEmpresa:cCodigo, "SndLog" )
         ::AppSql( "EMP" + aEmpresa:cCodigo, "EMP" + aEmpresa:cCodigo, "SndFil" )

         ::oMsgWait:SetText( "Convirtiendo secciones" )
         ::AppSql( "EMP" + aEmpresa:cCodigo, "EMP" + aEmpresa:cCodigo, "Seccion" )

         ::oMsgWait:SetText( "Convirtiendo horas" )
         ::AppSql( "EMP" + aEmpresa:cCodigo, "EMP" + aEmpresa:cCodigo, "Horas" )

         ::oMsgWait:SetText( "Convirtiendo producción" )
         ::AppSql( "EMP" + aEmpresa:cCodigo, "EMP" + aEmpresa:cCodigo, "OpeT" )
         ::AppSql( "EMP" + aEmpresa:cCodigo, "EMP" + aEmpresa:cCodigo, "OpeL" )
         ::AppSql( "EMP" + aEmpresa:cCodigo, "EMP" + aEmpresa:cCodigo, "ProHPer" )
         ::AppSql( "EMP" + aEmpresa:cCodigo, "EMP" + aEmpresa:cCodigo, "Operacio" )
         ::AppSql( "EMP" + aEmpresa:cCodigo, "EMP" + aEmpresa:cCodigo, "TipOpera" )
         ::AppSql( "EMP" + aEmpresa:cCodigo, "EMP" + aEmpresa:cCodigo, "Costes" )
         ::AppSql( "EMP" + aEmpresa:cCodigo, "EMP" + aEmpresa:cCodigo, "MaqCosT" )
         ::AppSql( "EMP" + aEmpresa:cCodigo, "EMP" + aEmpresa:cCodigo, "MaqCosL" )
         ::AppSql( "EMP" + aEmpresa:cCodigo, "EMP" + aEmpresa:cCodigo, "ProCab" )
         ::AppSql( "EMP" + aEmpresa:cCodigo, "EMP" + aEmpresa:cCodigo, "ProLin" )
         ::AppSql( "EMP" + aEmpresa:cCodigo, "EMP" + aEmpresa:cCodigo, "ProPer" )
         ::AppSql( "EMP" + aEmpresa:cCodigo, "EMP" + aEmpresa:cCodigo, "ProHPer" )
         ::AppSql( "EMP" + aEmpresa:cCodigo, "EMP" + aEmpresa:cCodigo, "ProMat" )
         ::AppSql( "EMP" + aEmpresa:cCodigo, "EMP" + aEmpresa:cCodigo, "ProMaq" )

         ::oTxtWait:SetText( "" )

         with object ( TReindex():New( nil, nil, "EMP" + aEmpresa:cCodigo + "\" ) )
            :lEmpresa   := .f.
            :GenIndices( ::oMsgWait )
         end

      end if

   next

   ::oDlgWait:End( IDOK )

   oDlg:Enable()

   oDlg:End( IDOK )

   CursorWE()

RETURN ( .t. )

//---------------------------------------------------------------------------//

Method SynSql( cFile )

   local oBlock
   local oError
   local dbfOld
	local dbfTmp
   local dbfDbf      := FullCurDir() + "Datos\" + cFile + ".Dbf"
   local cdxDbf      := FullCurDir() + "Datos\" + cFile + ".Cdx"
   local dbfSql      := "Datos\" + cFile + ".Dbf"
   local cdxSql      := "Datos\" + cFile + ".Cdx"

   if !File( dbfDbf )
      Return nil
   end if

   if !lExistTable( dbfSql )
      Return nil
   end if

   oBlock            := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      // DBFCDX ------------------------------------------------------------------

      USE ( dbfDbf ) NEW VIA ( cLocalDriver() ) ALIAS ( cCheckArea( "OLD", @dbfOld ) )
      if File( cdxDbf )
         SET ADSINDEX TO ( cdxDbf ) ADDITIVE
      end if

      // SQLRDD ------------------------------------------------------------------

      USE ( dbfSql ) NEW VIA "SQLRDD" ALIAS ( cCheckArea( "TMP", @dbfTmp ) )
      if lExistIndex( cdxSql )
         SET ADSINDEX TO ( cdxSql ) ADDITIVE
      end if

      // Pasamos los datos---------------------------------------------------------

      while !( dbfOld )->( eof() )

         if !( dbfTmp )->( dbSeek( ( dbfOld )->( OrdKeyVal() ) ) )
            dbPass( dbfOld, dbfTmp, .t. )
         end if

         ( dbfOld )->( dbSkip() )

         sysrefresh()

      end while

   RECOVER USING oError

      msgStop( "Imposible abrir todas las bases de datos " + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

	CLOSE ( dbfOld )
	CLOSE ( dbfTmp )

Return nil

//--------------------------------------------------------------------------//

Method AppSql( cEmpDbf, cEmpSql, cFile )

   local nCurrent
   local nLast
   local oBlock
   local oError
   local dbfOld
	local dbfTmp
   local dbfDbf      := FullCurDir() + cEmpDbf + "\" + cFile + ".Dbf"
   local cdxDbf      := FullCurDir() + cEmpDbf + "\" + cFile + ".Cdx"
   local dbfSql      := cEmpSql + "\" + cFile + ".Dbf"
   local cdxSql      := cEmpSql + "\" + cFile + ".Cdx"

   if !File( dbfDbf )
      Return nil
   end if

   if !lExistTable( dbfSql )
      Return nil
   end if

   oBlock            := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      // DBFCDX ------------------------------------------------------------------

      USE ( dbfDbf ) NEW VIA ( cLocalDriver() ) ALIAS ( cCheckArea( "OLD", @dbfOld ) )
      if File( cdxDbf )
         SET ADSINDEX TO ( cdxDbf ) ADDITIVE
      end if

      // SQLRDD ------------------------------------------------------------------

      USE ( dbfSql ) NEW VIA "SQLRDD" ALIAS ( cCheckArea( "TMP", @dbfTmp ) )
      if lExistIndex( cdxSql )
         SET ADSINDEX TO ( cdxSql ) ADDITIVE
      end if

      // Pasamos los datos---------------------------------------------------------

      nCurrent       := 1
      nLast          := ( dbfOld )->( LastRec() )

      while !( dbfOld )->( eof() )

         ::oTxtWait:SetText( "Registro : " + Ltrim( Trans( nCurrent++, "99999999" ) ) + " de " + Ltrim( Trans( nLast, "99999999" ) ) )

         dbPass( dbfOld, dbfTmp, .t. )

         ( dbfOld )->( dbSkip() )

         sysrefresh()

      end while

   RECOVER USING oError

      msgStop( "Imposible abrir todas las bases de datos " + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

	CLOSE ( dbfOld )
	CLOSE ( dbfTmp )

RETURN NIL

//--------------------------------------------------------------------------//
//--------------------------------------------------------------------------//
//--------------------------------------------------------------------------//

CLASS SEmpresa

   DATA lSelect
   DATA cCodigo
   DATA cNombre

   METHOD New( lSelect, cCodigo, cNombre )

END CLASS

METHOD New( lSelect, cCodigo, cNombre ) CLASS SEmpresa

   ::lSelect   := lSelect
   ::cCodigo   := cCodigo
   ::cNombre   := cNombre

RETURN ( Self )

//---------------------------------------------------------------------------//