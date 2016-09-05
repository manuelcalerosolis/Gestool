#include "hbclass.ch"

#define CRLF chr( 13 ) + chr( 10 )

//---------------------------------------------------------------------------//

Function Inicio()

   local oJackJonesInformation
   local cOld              := HB_LangSelect( "EN" )

   oJackJonesInformation   := JackJonesInformation():New()

   HB_LangSelect( cOld )

Return ( nil )

//---------------------------------------------------------------------------//

CREATE CLASS JackJonesInformation

   DATA nView

   DATA dInicio               INIT  ( BoM( Date() ) ) 
   DATA dFin                  INIT  ( EoM( Date() ) ) 

   DATA hProduct
   DATA aProducts             INIT {}
   DATA aProductsSales        INIT {}

   DATA oExcel

   METHOD New()               CONSTRUCTOR

   METHOD Dialog()
   METHOD OpenFiles()
   METHOD CloseFiles()        INLINE ( D():DeleteView( ::nView ) )

   METHOD processInformation()

   METHOD buildProduct()
      METHOD sortProductsBySales() 

   METHOD openExcel()
      METHOD writeInExcel()
         METHOD writeTopTen()
         METHOD writeWeekSales()
         METHOD writeClient()
         METHOD writeDetail()
      METHOD writeInLine( nRow )
      METHOD closeExcel()

ENDCLASS

//---------------------------------------------------------------------------//

METHOD New() CLASS JackJonesInformation

   if !::Dialog() 
      Return ( Self )
   end if 

   if !::OpenFiles()
      Return ( Self )
   end if 

   ::aProducts       := {}
   ::aProductsSales  := {}      

   MsgRun( "Porcesando tickets", "Espere por favor...", {|| ::processInformation() } )

   ::sortProductsBySales()

   ::writeInExcel()

   ::CloseFiles()

   msgInfo( "Porceso finalizado" )

Return ( Self )

//---------------------------------------------------------------------------//

METHOD Dialog() CLASS JackJonesInformation

   local oDlg
   local oBtn
   local getFechaFin

   oDlg 						:= TDialog():New( 5, 5, 15, 40, "Exportación semanal información : VILA" )

   TSay():New( 1, 1, {|| "Desde" }, oDlg )      

   TGetHlp():New( 1, 4, { | u | if( pcount() == 0, ::dInicio, ::dInicio := u ) }, , 40, 10 )

   TSay():New( 2, 1, {|| "Hasta" }, oDlg )      

   TGetHlp():New( 2, 4, { | u | if( pcount() == 0, ::dFin, ::dFin := u ) }, , 40, 10 )

   TButton():New( 3, 4, "&Aceptar", oDlg, {|| ( oDlg:End(1) ) }, 40, 12 )

   TButton():New( 3, 12, "&Cancel", oDlg, {|| oDlg:End() }, 40, 12 )

   oDlg:Activate( , , , .t. )

Return ( oDlg:nResult == 1 )

//---------------------------------------------------------------------------//

METHOD OpenFiles() CLASS JackJonesInformation

   local oError
   local oBlock
   local lOpenFiles     := .t.

   oBlock               := ErrorBlock( { | oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      ::nView           := D():CreateView()

      D():Tikets( ::nView )
      ( D():Tikets( ::nView ) )->( ordsetfocus( "dFecTik" ) )

      D():TiketsLineas( ::nView )

      D():Clientes( ::nView )

      D():Articulos( ::nView )

      D():TipoArticulos( ::nView )
      
      D():Get( "ArtCodebar", ::nView )  

      D():Get( "Ruta", ::nView )

      D():Get( "Agentes", ::nView )

      D():Get( "Categorias", ::nView )

   RECOVER USING oError

      lOpenFiles        := .f.

      msgStop( "Imposible abrir todas las bases de datos" + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

Return ( lOpenFiles )

//---------------------------------------------------------------------------//

METHOD processInformation() CLASS JackJonesInformation

   CursorWait()

   ( D():Tikets( ::nView ) )->( dbseek( ::dInicio, .t. ) )
   
   while ( D():Tikets( ::nView ) )->dFecTik <= ::dFin .and. ( D():Tikets( ::nView ) )->( !eof() )

      if ( D():TiketsLineas( ::nView ) )->( dbSeek( D():TiketsId( ::nView ) ) )

         while ( D():TiketsId( ::nView ) == D():TiketsLineasId( ::nView ) ) .and. ( D():TiketsLineas( ::nView ) )->( !eof() ) 

            if ( nTotNTpv( D():TiketsLineas( ::nView ) ) ) > 0 .and. ( D():Articulos( ::nView ) )->( dbSeek( ( D():TiketsLineas( ::nView ) )->cCbaTil ) )

               if alltrim( ( D():Articulos( ::nView ) )->cCodFab ) == "014"

                  ::buildProduct()
            
               end if 

            end if 

            ( D():TiketsLineas( ::nView ) )->( dbSkip() ) 
      
         end while
   
      end if 

      ( D():Tikets( ::nView ) )->( dbskip() )

   end while

   CursorWE()

Return ( Self )

//---------------------------------------------------------------------------//

METHOD buildProduct()


   local aProduct    := {  "Codigo" =>       alltrim( ( D():Articulos( ::nView ) )->Codigo ),;
                           "Nombre" =>       alltrim( ( D():Articulos( ::nView ) )->Nombre ),;
                           "Categoria" =>    alltrim( ( retFld( ( D():Articulos( ::nView ) )->cCodTip, D():TipoArticulos( ::nView ), "cNomTip" ) ) ),;
                           "Fecha" =>        ( D():TiketsLineas( ::nView ) )->dFecTik,;
                           "Hora" =>         ( D():Tikets( ::nView ) )->cHorTik,;
                           "Documento" =>    ( D():TiketsLineasId( ::nView ) ),;
                           "Cdow" =>         ( cdow( ( D():TiketsLineas( ::nView ) )->dFecTik ) ),;
                           "Unidades" =>     ( D():TiketsLineas( ::nView ) )->nUntTil,;
                           "Venta" =>        ( nTotLTpv( D():TiketsLineas( ::nView ) ) ),;
                           "Costo" =>        ( nCosLTpv( D():TiketsLineas( ::nView ) ) ) } 

   // msgAlert( hb_valtoexp( aProduct ) , "nUntTil" )

   aadd( ::aProducts, aProduct )

Return ( Self )

//---------------------------------------------------------------------------//

METHOD writeInExcel()

   if !::openExcel()
      Return ( Self )
   end if 

   ::writeWeekSales()

   ::writeTopTen()

   ::writeClient()

   ::writeDetail()

   ::closeExcel()

Return ( Self ) 

//---------------------------------------------------------------------------//

METHOD writeTopTen()

   local hProduct
   local nRowNoos          := 8
   local nWriteInNoos      := 0
   local nRowTemp          := 24
   local nWriteInTemp      := 0

   for each hProduct in ::aProductsSales

      if ( "NOOS" $ hProduct["Nombre"] )
         if ( nWriteInNoos < 10 )
            ::writeInLine( hProduct, nRowNoos++ )
         end if 
         ++nWriteInNoos
      else
         if ( nWriteInTemp < 10 )
            ::writeInLine( hProduct, nRowTemp++ )
         end if 
         ++nWriteInTemp
      end if 

   next

Return ( Self ) 

//---------------------------------------------------------------------------//

METHOD writeWeekSales()

   local nTotalVenta    := 0
   local nTotalCosto    := 0
   local nTotalUnidades := 0
   local cDow  
   local hProduct    
   local hDato
   local hDatos         := {  "Venta" => 0, "Costo" => 0 }
   local hDias          := {  "Sunday" =>    { "Venta" => 0, "Costo" => 0, "Unidades" => 0 },;
                              "Monday" =>    { "Venta" => 0, "Costo" => 0, "Unidades" => 0 },;
                              "Tuesday" =>   { "Venta" => 0, "Costo" => 0, "Unidades" => 0 },;
                              "Wednesday" => { "Venta" => 0, "Costo" => 0, "Unidades" => 0 },;
                              "Thursday" =>  { "Venta" => 0, "Costo" => 0, "Unidades" => 0 },;
                              "Friday" =>    { "Venta" => 0, "Costo" => 0, "Unidades" => 0 },;
                              "Saturday" =>  { "Venta" => 0, "Costo" => 0, "Unidades" => 0 } }

   for each hProduct in ::aProducts

      hDato    := hGet( hDias, hProduct[ "Cdow" ] )
      if !empty( hDato )
         hDato[ "Venta" ]     += hProduct[ "Venta" ]
         hDato[ "Costo" ]     += hProduct[ "Costo" ]
         hDato[ "Unidades" ]  += hProduct[ "Unidades" ]
      else
         msgAlert( cDow, "no encontrado")
      end if 

      nTotalVenta             += hProduct[ "Venta" ]
      nTotalCosto             += hProduct[ "Costo" ]
      nTotalUnidades          += hProduct[ "Unidades" ]

   next

   ::oExcel:oExcel:WorkSheets( 1 ):Cells( 5, 3 ):Value := hDias[ "Monday", "Venta" ]
   ::oExcel:oExcel:WorkSheets( 1 ):Cells( 5, 4 ):Value := hDias[ "Tuesday", "Venta" ]
   ::oExcel:oExcel:WorkSheets( 1 ):Cells( 5, 5 ):Value := hDias[ "Wednesday", "Venta" ]
   ::oExcel:oExcel:WorkSheets( 1 ):Cells( 5, 6 ):Value := hDias[ "Thursday", "Venta" ]
   ::oExcel:oExcel:WorkSheets( 1 ):Cells( 5, 7 ):Value := hDias[ "Friday", "Venta" ]
   ::oExcel:oExcel:WorkSheets( 1 ):Cells( 5, 8 ):Value := hDias[ "Saturday", "Venta" ]
   ::oExcel:oExcel:WorkSheets( 1 ):Cells( 5, 9 ):Value := hDias[ "Sunday", "Venta" ]

   ::oExcel:oExcel:WorkSheets( 1 ):Cells( 6, 3 ):Value := hDias[ "Monday", "Costo" ]
   ::oExcel:oExcel:WorkSheets( 1 ):Cells( 6, 4 ):Value := hDias[ "Tuesday", "Costo" ]
   ::oExcel:oExcel:WorkSheets( 1 ):Cells( 6, 5 ):Value := hDias[ "Wednesday", "Costo" ]
   ::oExcel:oExcel:WorkSheets( 1 ):Cells( 6, 6 ):Value := hDias[ "Thursday", "Costo" ]
   ::oExcel:oExcel:WorkSheets( 1 ):Cells( 6, 7 ):Value := hDias[ "Friday", "Costo" ]
   ::oExcel:oExcel:WorkSheets( 1 ):Cells( 6, 8 ):Value := hDias[ "Saturday", "Costo" ]
   ::oExcel:oExcel:WorkSheets( 1 ):Cells( 6, 9 ):Value := hDias[ "Sunday", "Costo" ]

   ::oExcel:oExcel:WorkSheets( 1 ):Cells( 9, 3 ):Value := hDias[ "Monday", "Unidades" ]
   ::oExcel:oExcel:WorkSheets( 1 ):Cells( 9, 4 ):Value := hDias[ "Tuesday", "Unidades" ]
   ::oExcel:oExcel:WorkSheets( 1 ):Cells( 9, 5 ):Value := hDias[ "Wednesday", "Unidades" ]
   ::oExcel:oExcel:WorkSheets( 1 ):Cells( 9, 6 ):Value := hDias[ "Thursday", "Unidades" ]
   ::oExcel:oExcel:WorkSheets( 1 ):Cells( 9, 7 ):Value := hDias[ "Friday", "Unidades" ]
   ::oExcel:oExcel:WorkSheets( 1 ):Cells( 9, 8 ):Value := hDias[ "Saturday", "Unidades" ]
   ::oExcel:oExcel:WorkSheets( 1 ):Cells( 9, 9 ):Value := hDias[ "Sunday", "Unidades" ]

   ::oExcel:oExcel:WorkSheets( 1 ):Cells( 15, 6 ):Value := nTotalVenta
   ::oExcel:oExcel:WorkSheets( 1 ):Cells( 16, 6 ):Value := nTotalCosto
   ::oExcel:oExcel:WorkSheets( 1 ):Cells( 19, 6 ):Value := nTotalUnidades

Return ( Self ) 

//---------------------------------------------------------------------------//

METHOD openExcel()

   local oError
   local oBlock
   local lError      := .f.

   oBlock            := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      ::oExcel                        := TOleExcel():New( "Importando hoja de excel", "Conectando...", .F. )

      ::oExcel:oExcel:Visible         := .t.
      ::oExcel:oExcel:DisplayAlerts   := .f.
      ::oExcel:oExcel:WorkBooks:Open( fullCurDir() + "PlantillaJJ.xlsx" )

      ::oExcel:oExcel:WorkSheets( 1 ):Activate()

   RECOVER USING oError

      lError        := .t.

      msgStop( "Error al abrir hoja de calculo " + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

Return ( !lError )      

//---------------------------------------------------------------------------//

METHOD writeInLine( hProduct, nRow )

   local oError
   local oBlock

   oBlock            := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   ::oExcel:oExcel:WorkSheets( 2 ):Cells( nRow, 3 ):Value := hProduct["Codigo"]
   ::oExcel:oExcel:WorkSheets( 2 ):Cells( nRow, 4 ):Value := hProduct["Nombre"]
   ::oExcel:oExcel:WorkSheets( 2 ):Cells( nRow, 5 ):Value := hProduct["Unidades"]
   ::oExcel:oExcel:WorkSheets( 2 ):Cells( nRow, 6 ):Value := hProduct["Venta"]
   ::oExcel:oExcel:WorkSheets( 2 ):Cells( nRow, 7 ):Value := hProduct["Costo"]
   ::oExcel:oExcel:WorkSheets( 2 ):Cells( nRow, 10):Value := hProduct["Categoria"]

   RECOVER USING oError

   END SEQUENCE

   ErrorBlock( oBlock )

Return ( Self ) 

//---------------------------------------------------------------------------//

METHOD writeClient()

   ::oExcel:oExcel:WorkSheets( 1 ):Cells( 2, 6 ):Value := "Abucoco Market S.L. - JACK JONES"
   ::oExcel:oExcel:WorkSheets( 1 ):Cells( 3, 6 ):Value := "Desde " +  dtoc(::dInicio) + " hasta " + dtoc(::dFin)

Return ( Self ) 

//---------------------------------------------------------------------------//

METHOD closeExcel()

Return ( Self ) 

//---------------------------------------------------------------------------//

METHOD sortProductsBySales()

   local nPos
   local hProduct
   local aProducts   := aclone( ::aProducts )

   for each hProduct in aProducts

      nPos := ascan( ::aProductsSales, {|h| h[ "Codigo" ] == hProduct[ "Codigo" ] } ) 
      if nPos != 0
         ::aProductsSales[ nPos, "Unidades" ]    += hProduct[ "Unidades" ]
         ::aProductsSales[ nPos, "Venta" ]       += hProduct[ "Venta" ]
         ::aProductsSales[ nPos, "Costo" ]       += hProduct[ "Costo" ]
      else
         aAdd( ::aProductsSales, hProduct )
      end if 

   next

   aSort( ::aProductsSales, , , {|x,y| x[ "Venta" ] > y[ "Venta" ] } )   

Return ( Self ) 

//---------------------------------------------------------------------------//

METHOD writeDetail()

   local hProduct

   ::oExcel:oExcel:WorkSheets( 3 ):Cells( 1, 1 ):Value := "Documento"
   ::oExcel:oExcel:WorkSheets( 3 ):Cells( 1, 2 ):Value := "Fecha"
   ::oExcel:oExcel:WorkSheets( 3 ):Cells( 1, 3 ):Value := "Hora"
   ::oExcel:oExcel:WorkSheets( 3 ):Cells( 1, 4 ):Value := "Codigo"
   ::oExcel:oExcel:WorkSheets( 3 ):Cells( 1, 5 ):Value := "Nombre"
   ::oExcel:oExcel:WorkSheets( 3 ):Cells( 1, 6 ):Value := "Unidades"
   ::oExcel:oExcel:WorkSheets( 3 ):Cells( 1, 7 ):Value := "Venta"
   ::oExcel:oExcel:WorkSheets( 3 ):Cells( 1, 8 ):Value := "Costo"
   ::oExcel:oExcel:WorkSheets( 3 ):Cells( 1, 9 ):Value := "Categoria"

   for each hProduct in ::aProducts

      ::oExcel:oExcel:WorkSheets( 3 ):Cells( hb_enumindex() + 1, 1 ):Value := hProduct["Documento"]
      ::oExcel:oExcel:WorkSheets( 3 ):Cells( hb_enumindex() + 1, 2 ):Value := hProduct["Fecha"]
      ::oExcel:oExcel:WorkSheets( 3 ):Cells( hb_enumindex() + 1, 3 ):Value := hProduct["Hora"]
      ::oExcel:oExcel:WorkSheets( 3 ):Cells( hb_enumindex() + 1, 4 ):Value := hProduct["Codigo"]
      ::oExcel:oExcel:WorkSheets( 3 ):Cells( hb_enumindex() + 1, 5 ):Value := hProduct["Nombre"]
      ::oExcel:oExcel:WorkSheets( 3 ):Cells( hb_enumindex() + 1, 6 ):Value := hProduct["Unidades"]
      ::oExcel:oExcel:WorkSheets( 3 ):Cells( hb_enumindex() + 1, 7 ):Value := hProduct["Venta"]
      ::oExcel:oExcel:WorkSheets( 3 ):Cells( hb_enumindex() + 1, 8 ):Value := hProduct["Costo"]
      ::oExcel:oExcel:WorkSheets( 3 ):Cells( hb_enumindex() + 1, 9 ):Value := hProduct["Categoria"]

   next

Return ( Self ) 

//---------------------------------------------------------------------------//
