#include "FiveWin.ch"

#define CRLF chr( 13 ) + chr( 10 )

//---------------------------------------------------------------------------//

Function Inicio()

   FacturasClientesRisi():New()

Return ( nil )

//---------------------------------------------------------------------------//

CREATE CLASS FacturasClientesRisi

   DATA nView

   DATA oUve

   DATA hProducto

   DATA dInicio             INIT    ( BoM( Date() ) ) 
   DATA dFin                INIT    ( EoM( Date() ) ) 

   DATA oDlg
   DATA oSayDesde
   DATA oGetDesde
   DATA oSayHasta
   DATA oGetHasta
   DATA oSayMessage

   DATA cDelegacion

   DATA aClientesExcluidos  INIT    { }

   CLASSDATA aProductos     INIT  { { "Codigo" => "V001004", "Nombre" => "GUSANITOS 35 g x 30 u",             "Codigo unidades" => "8411859550103",  "Codigo cajas" => "18411859550100", "Codigo interno" => "" },;
                                    { "Codigo" => "V001005", "Nombre" => "GUSANITOS  KETCHUP 35 g x 30 u",    "Codigo unidades" => "8411859550110",  "Codigo cajas" => "18411859550117", "Codigo interno" => "" },;
                                    { "Codigo" => "V001007", "Nombre" => "GUSANITOS 18 g x 40 u",             "Codigo unidades" => "8411859550134",  "Codigo cajas" => "18411859550131", "Codigo interno" => "" },;
                                    { "Codigo" => "V001009", "Nombre" => "GUSANITOS KETCHUP 85 g x 8 u",      "Codigo unidades" => "8411859553258",  "Codigo cajas" => "18411859553255", "Codigo interno" => "" },;
                                    { "Codigo" => "V001010", "Nombre" => "GUSANITOS 85 g x 8 u",              "Codigo unidades" => "8411859553180",  "Codigo cajas" => "18411859553187", "Codigo interno" => "" },;
                                    { "Codigo" => "V001012", "Nombre" => "GUSANITOS 85 g x 16 u",             "Codigo unidades" => "8411859553180",  "Codigo cajas" => "28411859553184", "Codigo interno" => "" },;
                                    { "Codigo" => "V002010", "Nombre" => "TEJITAS 35 g x 30 u",               "Codigo unidades" => "8411859550233",  "Codigo cajas" => "18411859550230", "Codigo interno" => "" },;
                                    { "Codigo" => "V002011", "Nombre" => "TEJITAS 100 g. x 8 u.",             "Codigo unidades" => "8411859553111",  "Codigo cajas" => "18411859553118", "Codigo interno" => "" },;
                                    { "Codigo" => "V003002", "Nombre" => "SURTIS 35 g x 30 u",                "Codigo unidades" => "8411859550097",  "Codigo cajas" => "18411859550094", "Codigo interno" => "" },;
                                    { "Codigo" => "V003005", "Nombre" => "SURTIS 4U 37 g x 40 u",             "Codigo unidades" => "8411859550080",  "Codigo cajas" => "18411859550087", "Codigo interno" => "" },;
                                    { "Codigo" => "V003007", "Nombre" => "SURTIS 4U 37  G. x 30 u.",          "Codigo unidades" => "8411859550080",  "Codigo cajas" => "38411859550081", "Codigo interno" => "" },;
                                    { "Codigo" => "V004001", "Nombre" => "PALOMITAS 35 g x 30 u",             "Codigo unidades" => "8411859550073",  "Codigo cajas" => "18411859550070", "Codigo interno" => "" },;
                                    { "Codigo" => "V004002", "Nombre" => "PALOMITAS KET-MOSTAZA 35gx30 u",    "Codigo unidades" => "8411859550561",  "Codigo cajas" => "18411859550568", "Codigo interno" => "" },;
                                    { "Codigo" => "V004003", "Nombre" => "PALOMITAS XTRA SABOR 35g x 30u",    "Codigo unidades" => "8411859550554",  "Codigo cajas" => "18411859550551", "Codigo interno" => "" },;
                                    { "Codigo" => "V004005", "Nombre" => "PALOMITAS 90 g x 8 u",              "Codigo unidades" => "8411859553173",  "Codigo cajas" => "18411859553170", "Codigo interno" => "" },;
                                    { "Codigo" => "V004009", "Nombre" => "PALOMITAS KET-MOSTAZA 90gx8 u",     "Codigo unidades" => "8411859553265",  "Codigo cajas" => "18411859553262", "Codigo interno" => "" },;
                                    { "Codigo" => "V004011", "Nombre" => "PALOMITAS CHOCOLATE 30 g x40 u",    "Codigo unidades" => "8411859550578",  "Codigo cajas" => "18411859550575", "Codigo interno" => "" },;
                                    { "Codigo" => "V004012", "Nombre" => "PALOMITAS  CHOC.BLANCO 30gx40u",    "Codigo unidades" => "8411859550585",  "Codigo cajas" => "18411859550582", "Codigo interno" => "" },;
                                    { "Codigo" => "V004013", "Nombre" => "PALOMITAS CHOC.BLANCO 120gx16u",    "Codigo unidades" => "8411859553241",  "Codigo cajas" => "18411859553248", "Codigo interno" => "" },;
                                    { "Codigo" => "V004014", "Nombre" => "PALOMITAS CHOCOLATE 120 g x16u",    "Codigo unidades" => "8411859553234",  "Codigo cajas" => "18411859553231", "Codigo interno" => "" },;
                                    { "Codigo" => "V004016", "Nombre" => "PALOMITAS 90 g x 16 u.",            "Codigo unidades" => "8411859553173",  "Codigo cajas" => "28411859553177", "Codigo interno" => "" },;
                                    { "Codigo" => "V004017", "Nombre" => "PALOMITAS KET.MOSTAZ.90g x 16u",    "Codigo unidades" => "8411859553265",  "Codigo cajas" => "28411859553269", "Codigo interno" => "" },;
                                    { "Codigo" => "V004018", "Nombre" => "LINKS 30 g x 30 u.",                "Codigo unidades" => "8411859550639",  "Codigo cajas" => "18411859550636", "Codigo interno" => "" },;
                                    { "Codigo" => "V004020", "Nombre" => "LINKS 95 g x 16 u.",                "Codigo unidades" => "8411859553524",  "Codigo cajas" => "18411859553521", "Codigo interno" => "" },;
                                    { "Codigo" => "V006001", "Nombre" => "TRISKY 20 g x 70 u",                "Codigo unidades" => "8411859551087",  "Codigo cajas" => "18411859551084", "Codigo interno" => "" },;
                                    { "Codigo" => "V006002", "Nombre" => "TRISKY 35 g x 40 u",                "Codigo unidades" => "8411859551124",  "Codigo cajas" => "18411859551121", "Codigo interno" => "" },;
                                    { "Codigo" => "V006006", "Nombre" => "TRISKYS 85 g x 28 u",               "Codigo unidades" => "8411859553159",  "Codigo cajas" => "18411859553156", "Codigo interno" => "" },;
                                    { "Codigo" => "V006007", "Nombre" => "TRISKYS JAMON 35 g x 40 u",         "Codigo unidades" => "8411859551117",  "Codigo cajas" => "18411859551114", "Codigo interno" => "" },;
                                    { "Codigo" => "V006010", "Nombre" => "TRISKYS 115 g x 16 u",              "Codigo unidades" => "8411859553074",  "Codigo cajas" => "18411859553071", "Codigo interno" => "" },;
                                    { "Codigo" => "V006011", "Nombre" => "TRISKYS JAMON 115 g X 16 u",        "Codigo unidades" => "8411859553401",  "Codigo cajas" => "18411859553408", "Codigo interno" => "" },;
                                    { "Codigo" => "V006013", "Nombre" => "TRISKYS 115 g x 24 u",              "Codigo unidades" => "8411859553074",  "Codigo cajas" => "28411859553078", "Codigo interno" => "" },;
                                    { "Codigo" => "V007001", "Nombre" => "PAJITAS 20 g x 40 u",               "Codigo unidades" => "8411859551001",  "Codigo cajas" => "18411859551008", "Codigo interno" => "" },;
                                    { "Codigo" => "V007002", "Nombre" => "PAJITAS KETCHUP 12 g x 60 u",       "Codigo unidades" => "8411859551018",  "Codigo cajas" => "18411859551015", "Codigo interno" => "" },;
                                    { "Codigo" => "V007004", "Nombre" => "PAJITAS KETCHUP 20 g x 40 u",       "Codigo unidades" => "8411859552244",  "Codigo cajas" => "18411859552241", "Codigo interno" => "" },;
                                    { "Codigo" => "V008005", "Nombre" => "RISKETOS 40 g x 40 u",              "Codigo unidades" => "8411859552756",  "Codigo cajas" => "18411859552753", "Codigo interno" => "01059" },;
                                    { "Codigo" => "V008007", "Nombre" => "RISKETOS KETCHUP 40 g x 40 u",      "Codigo unidades" => "8411859551056",  "Codigo cajas" => "18411859551053", "Codigo interno" => "" },;
                                    { "Codigo" => "V008010", "Nombre" => "RISKETOS 120 g x 16 u.",            "Codigo unidades" => "8411859553081",  "Codigo cajas" => "18411859553088", "Codigo interno" => "" },;
                                    { "Codigo" => "V008013", "Nombre" => "RISKETOS LIGHT 105 g x 16 u",       "Codigo unidades" => "8411859553098",  "Codigo cajas" => "18411859553095", "Codigo interno" => "" },;
                                    { "Codigo" => "V008015", "Nombre" => "RISKETOS 80 g x 28 u.",             "Codigo unidades" => "8411859554606",  "Codigo cajas" => "18411859554603", "Codigo interno" => "" },;
                                    { "Codigo" => "V008018", "Nombre" => "RISKETOS 80 g x 30 u.",             "Codigo unidades" => "8411859554606",  "Codigo cajas" => "28411859554600", "Codigo interno" => "" },;
                                    { "Codigo" => "V008019", "Nombre" => "RISKETOS 120 g x 24 u.",            "Codigo unidades" => "8411859553081",  "Codigo cajas" => "28411859553085", "Codigo interno" => "" },;
                                    { "Codigo" => "V008022", "Nombre" => "RISKETOS40+LINKS12 8 tirasx14u",    "Codigo unidades" => "8411859551438",  "Codigo cajas" => "18411859551435", "Codigo interno" => "" },;
                                    { "Codigo" => "V016002", "Nombre" => "FRITOS KETCHUP 25 g x 40 u",        "Codigo unidades" => "8411859551261",  "Codigo cajas" => "18411859551268", "Codigo interno" => "" },;
                                    { "Codigo" => "V017001", "Nombre" => "CUCURUCHIS 25 g x 40 u",            "Codigo unidades" => "8411859552855",  "Codigo cajas" => "18411859552852", "Codigo interno" => "" },;
                                    { "Codigo" => "V018001", "Nombre" => "RISIBOL 110 g x 8 u",               "Codigo unidades" => "8411859553340",  "Codigo cajas" => "18411859553347", "Codigo interno" => "" },;
                                    { "Codigo" => "V018002", "Nombre" => "TAPITAS 100 g x 8 u",               "Codigo unidades" => "8411859553128",  "Codigo cajas" => "18411859553125", "Codigo interno" => "" },;
                                    { "Codigo" => "V018003", "Nombre" => "SURTIS 100 g x 8 u",                "Codigo unidades" => "8411859553104",  "Codigo cajas" => "18411859553101", "Codigo interno" => "" },;
                                    { "Codigo" => "V018008", "Nombre" => "BUSCALIOS BBQ 110 g x 16 u",        "Codigo unidades" => "8411859553296",  "Codigo cajas" => "18411859553293", "Codigo interno" => "" },;
                                    { "Codigo" => "V018010", "Nombre" => "PAJITAS KETCHUP 100 g x 9 u",       "Codigo unidades" => "8411859553500",  "Codigo cajas" => "18411859553507", "Codigo interno" => "" },;
                                    { "Codigo" => "V018011", "Nombre" => "FRITOS PAPRIKA 95 g x 16 u",        "Codigo unidades" => "8411859553517",  "Codigo cajas" => "18411859553514", "Codigo interno" => "" },;
                                    { "Codigo" => "V018012", "Nombre" => "PAJITAS DE PATATA 100 g.x 9 u",     "Codigo unidades" => "8411859553395",  "Codigo cajas" => "18411859553392", "Codigo interno" => "" },;
                                    { "Codigo" => "V018013", "Nombre" => "SURTIS 4U 110 g  x 16 u",           "Codigo unidades" => "8411859553418",  "Codigo cajas" => "18411859553415", "Codigo interno" => "" },;
                                    { "Codigo" => "V018014", "Nombre" => "BUSCALIOS BBQ 140 g x 12 u.",       "Codigo unidades" => "8411859553425",  "Codigo cajas" => "18411859553422", "Codigo interno" => "" },;
                                    { "Codigo" => "V018016", "Nombre" => "MATCHBALL 90 g x 12 u.",            "Codigo unidades" => "8411859553210",  "Codigo cajas" => "18411859553217", "Codigo interno" => "" },;
                                    { "Codigo" => "V022006", "Nombre" => "PATATAS ONDULADAS 50 g x 20 u",     "Codigo unidades" => "8411859554507",  "Codigo cajas" => "18411859554504", "Codigo interno" => "" },;
                                    { "Codigo" => "V022007", "Nombre" => "PATATAS ONDUL.JAMON 50 g x 20u",    "Codigo unidades" => "8411859554514",  "Codigo cajas" => "18411859554511", "Codigo interno" => "" },;
                                    { "Codigo" => "V022008", "Nombre" => "PATATAS CASERAS 50 g x 20 u",       "Codigo unidades" => "8411859554521",  "Codigo cajas" => "18411859554528", "Codigo interno" => "" },;
                                    { "Codigo" => "V023001", "Nombre" => "CORAZONCITOS 25 g x 40 u",          "Codigo unidades" => "8411859551353",  "Codigo cajas" => "18411859551350", "Codigo interno" => "" },;
                                    { "Codigo" => "V025001", "Nombre" => "ONDULADAS ORIGINALES 100gX8 u",     "Codigo unidades" => "8411859553012",  "Codigo cajas" => "18411859553019", "Codigo interno" => "" },;
                                    { "Codigo" => "V025002", "Nombre" => "PATATAS CASERAS 100 g x 8 u",       "Codigo unidades" => "8411859553050",  "Codigo cajas" => "18411859553057", "Codigo interno" => "" },;
                                    { "Codigo" => "V025006", "Nombre" => "PATATAS ONDUL.JAMON 100 g x 8u",    "Codigo unidades" => "8411859553029",  "Codigo cajas" => "18411859553026", "Codigo interno" => "" },;
                                    { "Codigo" => "V025010", "Nombre" => "PATATAS CASERAS B.PAPEL 120X8u",    "Codigo unidades" => "8411859553043",  "Codigo cajas" => "18411859553040", "Codigo interno" => "" },;
                                    { "Codigo" => "V025012", "Nombre" => "PATATAS CASERAS 30 g x 35 u",       "Codigo unidades" => "8411859552114",  "Codigo cajas" => "18411859552111", "Codigo interno" => "" },;
                                    { "Codigo" => "V025013", "Nombre" => "PATATAS O.CAMPESINA 30g.x 35 u",    "Codigo unidades" => "8411859552176",  "Codigo cajas" => "18411859552173", "Codigo interno" => "" },;
                                    { "Codigo" => "V025014", "Nombre" => "PATATAS OND.IBERICOS 100g x 8u",    "Codigo unidades" => "8411859553036",  "Codigo cajas" => "18411859553033", "Codigo interno" => "" },;
                                    { "Codigo" => "V025017", "Nombre" => "PATATAS ONDULADAS 30 g. x 35 u",    "Codigo unidades" => "8411859552152",  "Codigo cajas" => "18411859552159", "Codigo interno" => "" },;
                                    { "Codigo" => "V025018", "Nombre" => "PATATAS OND.JAMON 30 g. x 35 u",    "Codigo unidades" => "8411859552169",  "Codigo cajas" => "18411859552166", "Codigo interno" => "" },;
                                    { "Codigo" => "V025023", "Nombre" => "PATATAS O.CAMPESINA 100g.x 8 u",    "Codigo unidades" => "8411859553005",  "Codigo cajas" => "18411859553002", "Codigo interno" => "" },;
                                    { "Codigo" => "V025024", "Nombre" => "PATATA FRITA ARTESANA 90gx12u",     "Codigo unidades" => "8411859553326",  "Codigo cajas" => "18411859553323", "Codigo interno" => "" },;
                                    { "Codigo" => "V025025", "Nombre" => "PATATAS O.VINAGRETA 30g x 35 u",    "Codigo unidades" => "8411859552183",  "Codigo cajas" => "18411859552180", "Codigo interno" => "" },;
                                    { "Codigo" => "V025026", "Nombre" => "PATATAS O.VINAGRETA 100g x 8 u",    "Codigo unidades" => "8411859553319",  "Codigo cajas" => "18411859553316", "Codigo interno" => "" },;
                                    { "Codigo" => "V025027", "Nombre" => "ONDULADA CHEESE&ONION 30gx35u",     "Codigo unidades" => "8411859552193",  "Codigo cajas" => "18411859552197", "Codigo interno" => "" },;
                                    { "Codigo" => "V025028", "Nombre" => "ONDULADA CHEESE&ONION 100gx8u",     "Codigo unidades" => "8411859553286",  "Codigo cajas" => "18411859553286", "Codigo interno" => "" },;
                                    { "Codigo" => "V025034", "Nombre" => "ONDUL. TANGY TOMATO 100g. x 8u",    "Codigo unidades" => "8411859553357",  "Codigo cajas" => "18411859553354", "Codigo interno" => "" },;
                                    { "Codigo" => "V025035", "Nombre" => "ONDUL.TANGY TOMATO 30g. x 35u.",    "Codigo unidades" => "8411859552251",  "Codigo cajas" => "18411859552258", "Codigo interno" => "" },;
                                    { "Codigo" => "V026004", "Nombre" => "CUT THE ROPE 30 g x 40",            "Codigo unidades" => "8411859550622",  "Codigo cajas" => "18411859550629", "Codigo interno" => "" },;
                                    { "Codigo" => "V027001", "Nombre" => "RISIBOL 35 g x 35 u",               "Codigo unidades" => "8411859550516",  "Codigo cajas" => "28411859550513", "Codigo interno" => "" },;
                                    { "Codigo" => "V027003", "Nombre" => "MATCHBALL 30 g. x 30 unid.",        "Codigo unidades" => "8411859550516",  "Codigo cajas" => "18411859550513", "Codigo interno" => "" },;
                                    { "Codigo" => "V028003", "Nombre" => "GUSANITOS SUPER  3 g x 75 u",       "Codigo unidades" => "8411859550158",  "Codigo cajas" => "18411859550155", "Codigo interno" => "" },;
                                    { "Codigo" => "V032005", "Nombre" => "BUSCALIOS BBQ  35 g x 40u",         "Codigo unidades" => "8411859551445",  "Codigo cajas" => "18411859551442", "Codigo interno" => "" },;
                                    { "Codigo" => "V040004", "Nombre" => "PATATAS CASERAS 450 g x 4 u",       "Codigo unidades" => "8411859556129",  "Codigo cajas" => "18411859556126", "Codigo interno" => "" },;
                                    { "Codigo" => "V046004", "Nombre" => "TU PACK GUSANITOS x 14 u.",         "Codigo unidades" => "8411859556075",  "Codigo cajas" => "18411859556072", "Codigo interno" => "" },;
                                    { "Codigo" => "V046013", "Nombre" => "TU PACK ESTRELLA x 10 Bolsas",      "Codigo unidades" => "8411859556105",  "Codigo cajas" => "18411859556102", "Codigo interno" => "" },;
                                    { "Codigo" => "V060006", "Nombre" => "PICARITAS 200 UNDS.",               "Codigo unidades" => "8411859557027",  "Codigo cajas" => "18411859557024", "Codigo interno" => "" },;
                                    { "Codigo" => "V060007", "Nombre" => "PICARITAS FRESA 200 UNDS.",         "Codigo unidades" => "8411859557041",  "Codigo cajas" => "18411859557048", "Codigo interno" => "" },;
                                    { "Codigo" => "V060008", "Nombre" => "PICARITAS BLANCAS 200 UNDS",        "Codigo unidades" => "8411859557034",  "Codigo cajas" => "18411859557031", "Codigo interno" => "" },;
                                    { "Codigo" => "V800101", "Nombre" => "Exp. 4 Modulos",                    "Codigo unidades" => "8411859559946",  "Codigo cajas" => "18411859559943", "Codigo interno" => "" },;
                                    { "Codigo" => "V800201", "Nombre" => "Exp. Mostrador 5 bandejas alim",    "Codigo unidades" => "8411859559939",  "Codigo cajas" => "18411859559936", "Codigo interno" => "" },;
                                    { "Codigo" => "V800303", "Nombre" => "Exp.fam.5 bandejas grand.plast",    "Codigo unidades" => "8411859559915",  "Codigo cajas" => "18411859559912", "Codigo interno" => "" },;
                                    { "Codigo" => "V800403", "Nombre" => "Exp.Cajas 2 Bandejas plastico",     "Codigo unidades" => "8411859559922",  "Codigo cajas" => "18411859559929", "Codigo interno" => "" },;
                                    { "Codigo" => "V800404", "Nombre" => "Exp.ruedas familiar Plastico",      "Codigo unidades" => "8411859559960",  "Codigo cajas" => "18411859559967", "Codigo interno" => "" },;
                                    { "Codigo" => "V800501", "Nombre" => "Exp. Extrusión",                    "Codigo unidades" => "8411859559977",  "Codigo cajas" => "18411859559974", "Codigo interno" => "" } }

   METHOD New()                                 CONSTRUCTOR

   METHOD Dialog()
   METHOD Run()

   METHOD OpenFiles()
   METHOD CloseFiles()                          INLINE ( D():DeleteView( ::nView ) )

   METHOD SendFile()
   METHOD ProcessFile()

   METHOD findMainCodeInHash( cCodigoBarra )
   METHOD findCodigoInternoInHash( cCodigoInterno )

   METHOD validateInvoice()       

   METHOD getCantidad()
   METHOD getPrecioBase()

   METHOD getDelegacion()                       INLINE ( oUser():cDelegacion() )

ENDCLASS

//---------------------------------------------------------------------------//

   METHOD New() CLASS FacturasClientesRisi

      if empty( ::getDelegacion() )
         msgStop( "Código delegación esta vacio" )
         Return ( Self )
      end if 

      if !::OpenFiles()
         Return ( Self )
      end if 

   	::Dialog() 

      ::CloseFiles()

      msgInfo( "Porceso finalizado : " + ::oUve:cFile )

   Return ( Self )

//---------------------------------------------------------------------------//

   METHOD Run()

      ::oDlg:Disable()

      ::ProcessFile()

      // ::SendFile()

      ::oDlg:Enable()
      ::oDlg:End()

   RETURN ( Self )

//---------------------------------------------------------------------------//

   METHOD Dialog() CLASS FacturasClientesRisi

      local oBtn
      local getFechaFin

      ::oDlg 		    := TDialog():New( 5, 5, 18, 60, "Exportacion Risi" )

      ::oSayDesde       := TSay():New( 1, 1, {|| "Desde" }, ::oDlg )      

      ::oGetDesde       := TGetHlp():New( 1, 4, { | u | if( pcount() == 0, ::dInicio, ::dInicio := u ) }, , 40, 10 )

      ::oSayHasta       := TSay():New( 2, 1, {|| "Hasta" }, ::oDlg )      

      ::oGetHasta       := TGetHlp():New( 2, 4, { | u | if( pcount() == 0, ::dFin, ::dFin := u ) }, , 40, 10 )

      ::oSayMessage     := TSay():New( 3, 1, {|| "Proceso" }, ::oDlg, , , , , , , , , 150, 12 )      

      TButton():New( 4, 4, "&Aceptar", ::oDlg, {|| ( ::Run() ) }, 40, 12 )

      TButton():New( 4, 12, "&Cancel", ::oDlg, {|| ::oDlg:End() }, 40, 12 )

      ::oDlg:Activate( , , , .t. )

   Return ( nil )

//---------------------------------------------------------------------------//

METHOD OpenFiles() CLASS FacturasClientesRisi

   local oError
   local oBlock
   local lOpenFiles     := .t.

   oBlock               := ErrorBlock( { | oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      ::nView           := D():CreateView()

      D():FacturasClientes( ::nView )
      ( D():FacturasClientes( ::nView ) )->( ordsetfocus( "dFecFac" ) )

      D():FacturasClientesLineas( ::nView )    
      ( D():FacturasClientesLineas( ::nView ) )->( ordsetfocus( "nNumLin" ) )

      D():Clientes( ::nView )

      D():Articulos( ::nView )

      D():GrupoClientes( ::nView )

      D():Get( "ArtCodebar", ::nView )  

      D():Get( "Ruta", ::nView )

      D():Get( "Agentes", ::nView )

   RECOVER USING oError

      lOpenFiles        := .f.

      msgStop( "Imposible abrir todas las bases de datos" + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

Return ( lOpenFiles )

//---------------------------------------------------------------------------//

METHOD ProcessFile() CLASS FacturasClientesRisi

   local cCodigoRuta    := ""
   local cCodigoGrupo   := ""
   local cNombreGrupo   := ""
   local cCodigoBarra   := ""
   local cCodigoInterno := ""
   local cUbicacion     := ""
   local cCodigoAgente  := ""
   local cNombreProducto:= ""
   local lFamiliaRisi   := .f.

   CursorWait()

   ::oUve               := Uve():New()

   ( D():FacturasClientes( ::nView ) )->( dbseek( ::dInicio, .t. ) )
   
   while ( D():FacturasClientes( ::nView ) )->dFecFac <= ::dFin .and. ( D():FacturasClientes( ::nView ) )->( !eof() )

      ::oSayMessage:setText( "Progreso : " + alltrim( str( ( D():FacturasClientes( ::nView ) )->( ordkeyno() ) ) ) + " de " + alltrim( str( ( D():FacturasClientes( ::nView ) )->( ordkeycount() ) ) ) )

      if ( ::validateInvoice() ) .and. ( D():FacturasClientesLineas( ::nView ) )->( dbSeek( D():FacturasClientesId( ::nView ) ) )

         while ( D():FacturasClientesId( ::nView ) == D():FacturasClientesLineasId( ::nView ) ) .and. ( D():FacturasClientesLineas( ::nView ) )->( !eof() ) 

            if ( D():Articulos( ::nView ) )->( dbSeek( ( D():FacturasClientesLineas( ::nView ) )->cRef ) )

               // Codigo de la familia-----------------------------------------

               cCodigoInterno             := ( D():Articulos( ::nView ) )->Codigo
               cCodigoBarra               := ( D():Articulos( ::nView ) )->CodeBar
               cUbicacion                 := ( D():Articulos( ::nView ) )->cDesUbi 
               cNombreProducto            := ( D():Articulos( ::nView ) )->Nombre
               lFamiliaRisi 		      := alltrim( ( D():Articulos( ::nView ) )->cCodFab ) == "001"

               /*
               lFamiliaRisi               := alltrim( ( D():Articulos( ::nView ) )->Familia ) == "00000000" .or. alltrim( ( D():Articulos( ::nView ) )->Familia ) == "00000001" .or. alltrim( ( D():Articulos( ::nView ) )->Familia ) == "00000002" .or. alltrim( ( D():Articulos( ::nView ) )->Familia ) == "00000003" .or. alltrim( ( D():Articulos( ::nView ) )->Familia ) == "00000004" .or. alltrim( ( D():Articulos( ::nView ) )->Familia ) == "00000005" .or. alltrim( ( D():Articulos( ::nView ) )->Familia ) == "00000006".or. alltrim( ( D():Articulos( ::nView ) )->Familia ) == "00000007" .or. alltrim( ( D():Articulos( ::nView ) )->Familia ) == "00000008" .or. alltrim( ( D():Articulos( ::nView ) )->Familia ) == "00000009" .or. alltrim( ( D():Articulos( ::nView ) )->Familia ) == "00000010"    .or. alltrim( ( D():Articulos( ::nView ) )->Familia ) == "00000011" .or. alltrim( ( D():Articulos( ::nView ) )->Familia ) == "00000012" .or. alltrim( ( D():Articulos( ::nView ) )->Familia ) == "00010" 
               */
               // Busqueda en productos de Risi--------------------------------

               if lFamiliaRisi

                  ::findMainCodeInHash( cUbicacion )

                  // Codigo del grupo-------------------------------------------

                  if ( D():Clientes( ::nView ) )->( dbSeek( ( D():FacturasClientes( ::nView ) )->cCodCli ) )
                     cCodigoGrupo         := ( D():Clientes( ::nView ) )->cCodGrp

                     if !empty(cCodigoGrupo)
                        cNombreGrupo      := RetFld( cCodigoGrupo, D():GrupoClientes( ::nView ), "cNomGrp" )
                     end if

                  end if 

                  // Codigo de la ruta--------------------------------------------

                  cCodigoRuta             := ( D():FacturasClientes( ::nView ) )->cCodRut
                  if empty( cCodigoRuta )
                     cCodigoRuta          := ( D():Clientes( ::nView ) )->cCodRut
                  end if 

                  // Codigo del agente--------------------------------------------

                  cCodigoAgente           := ( ( D():FacturasClientes( ::nView ) )->cCodAge )
                  if empty( cCodigoAgente )
                     cCodigoAgente        := ( D():Clientes( ::nView ) )->cAgente
                  end if 

                  // carga de datos-----------------------------------------------

                  ::oUve:NumFactura(      D():FacturasClientesLineasId( ::nView ) ) 
                  ::oUve:NumLinea(        ( D():FacturasClientesLineas( ::nView ) )->nNumLin ) 
                  ::oUve:CodigoProducto(  alltrim( cCodigoInterno ) ) 
                  ::oUve:DescProducto(    cNombreProducto )
                  ::oUve:Fabricante(      'RISI' )

                  ::oUve:CodigoProdFab( cUbicacion )             // RetFld( , D():Get( "ArtCodebar", ::nView ), "cCodBar", "cDefArt" )

                  // el producto no enctrado en tabla de risi---------------------

                  if isnil( ::hProducto )   
                      ::oUve:EAN13(       "" )
                  else
                      ::oUve:EAN13(       ::hProducto[ "Codigo unidades" ] )    // RetFld( ( D():FacturasClientesLineas( ::nView ) )->cRef, D():Get( "ArtCodebar", ::nView ), "cCodBar", "cDefArt" )
                  end if 

                  ::oUve:Cantidad(        ::getCantidad() )

                  ::oUve:UM(              'UN' )
                  ::oUve:PrecioBase(      ::getPrecioBase() )
                  ::oUve:Descuentos(      nDtoLFacCli( D():FacturasClientesLineas( ::nView ) ) / ::getCantidad() )
                  ::oUve:PrecioBrutoTotal(nTotLFacCli( D():FacturasClientesLineas( ::nView ) ) )

                  ::oUve:FechaFra(        ( D():FacturasClientes( ::nView ) )->dFecFac )
                  ::oUve:Ejercicio(       Year( ( D():FacturasClientes( ::nView ) )->dFecFac ) )
                  ::oUve:CodigoCliente(   ( alltrim( ( D():FacturasClientes( ::nView ) )->cCodCli ) ) )
                  ::oUve:RazonSocial(     ( D():FacturasClientes( ::nView ) )->cNomCli )
                  ::oUve:Nombre(          ( D():Clientes( ::nView ) )->NbrEst )
                  ::oUve:CIF(             ( D():FacturasClientes( ::nView ) )->cDniCli )
                  ::oUve:Direccion(       ( D():FacturasClientes( ::nView ) )->cDirCli )
                  ::oUve:Poblacion(       ( D():FacturasClientes( ::nView ) )->cPobCli )
                  ::oUve:CodigoPostal(    ( D():FacturasClientes( ::nView ) )->cPosCli )
                  ::oUve:Ruta(            cCodigoRuta )
                  ::oUve:NombreRuta(      retFld( cCodigoRuta, D():Get( "Ruta", ::nView ), "cDesRut" ) )
                  ::oUve:CodigoComercial( cCodigoAgente )
                  ::oUve:NombreComercial( alltrim( retFld( cCodigoAgente, D():Get( "Agentes", ::nView ), "cNbrAge" ) ) + space( 1 ) + alltrim( retFld( cCodigoAgente, D():Get( "Agentes", ::nView ), "cApeAge" ) ) )
                  ::oUve:Peso()
                  ::oUve:UMPeso()
                  ::oUve:TipoCliente(     cCodigoGrupo )
                  ::oUve:Telefono(        ( D():FacturasClientes( ::nView ) )->cTlfCli ) 
                  ::oUve:DescTipoCliente( cNombreGrupo )

                  ::oUve:SerializeASCII()

               end if 

            end if 

            ( D():FacturasClientesLineas( ::nView ) )->( dbSkip() ) 
      
         end while
   
      end if 

      ( D():FacturasClientes( ::nView ) )->( dbskip() )

      sysrefresh()

   end while

   ::oUve:WriteASCII()

   CursorWE()

   ::oSayMessage:setText( "Fichero generado " + ::oUve:cFile )

Return ( Self )

//---------------------------------------------------------------------------//

METHOD SendFile() CLASS FacturasClientesRisi

      local oInt
      local oFtp
      local cUrl
      local oFile
      local lOpen
      local cDelegacion 
      local cFile      
      local cUserFtp    := "manolo"
      local cPasswdFtp  := "123Ab456"
      local cHostFtp    := "ftp.gestool.es"

      cUrl              := "ftp://" + cUserFtp + ":" + cPasswdFtp + "@" + cHostFtp
      cDelegacion       := ::getDelegacion()
      cFile             := ::oUve:cFile

      if !file( cFile )
         Return ( Self )
      end if

      ::oSayMessage:setText( "Subiendo fichero " + cFile )

      oInt              := TUrl():New( cUrl )
      oFtp              := TIPClientFTP():New( oInt, .t. )
      oFtp:nConnTimeout := 20000
      oFtp:bUsePasv     := .f.

      lOpen             := oFTP:Open( oInt )

      if empty( oFtp ) .or. !( oFtp:Open( oInt ) )
         msgStop( "Imposible crear la conexión con servidor ftp.", "Error" )
         return ( Self )
      end if   

      oFtp:Cwd( "httpdocs" )
      oFtp:Cwd( "uve" )

      if !empty( cDelegacion )
         oFtp:MKD( cDelegacion )
         oFtp:Cwd( cDelegacion )
      end if 

      oFtp:UploadFile( cFile ) 
      oFtp:Close()

      ::oSayMessage:setText( "Fichero " + cFile + " subido." )

RETURN ( Self )

//---------------------------------------------------------------------------//

   METHOD findMainCodeInHash( cMainCode ) CLASS FacturasClientesRisi

      local hProducto

      ::hProducto             := nil

      cMainCode               := alltrim( cMainCode )

      if empty( cMainCode )
            RETURN .f.
      end if 

      for each hProducto in ::aProductos

         if hProducto[ "Codigo" ] == cMainCode
            ::hProducto       := hProducto
         end if 

      next 

   RETURN ( .t. )

//---------------------------------------------------------------------------//

   METHOD findCodigoInternoInHash( cCodigoInterno ) CLASS FacturasClientesRisi

      local hProducto

      ::hProducto             := nil

      cCodigoInterno          := alltrim( cCodigoInterno )

      for each hProducto in ::aProductos

         if hProducto[ "Codigo interno" ] == cCodigoInterno
            ::hProducto       := hProducto
         end if 

      next 

   RETURN ( ::hProducto != nil )

//---------------------------------------------------------------------------//

METHOD getCantidad() CLASS FacturasClientesRisi

      local nUnidades   := ( D():Articulos( ::nView ) )->nUniCaja 
      local nCantidad   := nTotNFacCli( D():FacturasClientesLineas( ::nView ) )

      if nUnidades != 0
            nCantidad   := nCantidad / nUnidades
      end if 

RETURN ( nCantidad )

//---------------------------------------------------------------------------//

METHOD getPrecioBase() CLASS FacturasClientesRisi

      local nUnidades   := ( D():Articulos( ::nView ) )->nUniCaja 
      local nPrecioBase := nTotUFacCli( D():FacturasClientesLineas( ::nView ) )

      if nUnidades != 0
            nPrecioBase := nPrecioBase * nUnidades
      end if 

RETURN ( nPrecioBase )

//---------------------------------------------------------------------------//

METHOD validateInvoice() CLASS FacturasClientesRisi

    if !( ( D():FacturasClientes( ::nView ) )->cSerie $ "AB" )
        Return .f.
    end if 

    if ascan( ::aClientesExcluidos, {|cCodigoCliente| alltrim( ( D():FacturasClientes( ::nView ) )->cCodCli ) == cCodigoCliente } ) != 0
        Return .f.
    end if 

Return .t.

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS Uve FROM Cuaderno

   DATA cFile                       INIT FullCurDir() + 'VentasDistribuidor' + dtos( date() ) + timeToString() + '.csv'
   DATA aLineas                     INIT {}

   METHOD New()                     INLINE ( Self )
   METHOD Separator()               INLINE ( ';' )

   METHOD WriteASCII()
   METHOD SerializeASCII()

   DATA cNumFactura                 INIT ''
   METHOD NumFactura(uValue)        INLINE ( if( !isnil(uValue), ::cNumFactura         := uValue, trimpadr( strtran( ::cNumFactura, " ", "" ), 20 ) ) )
   DATA nNumLinea                   INIT 0
   METHOD NumLinea(uValue)          INLINE ( if( !isnil(uValue), ::nNumLinea           := uValue, trimpadr( trans( ::nNumLinea, "@E 9999999.99" ), 10 ) ) )
   DATA cCodigoProducto             INIT ''
   METHOD CodigoProducto(uValue)    INLINE ( if( !isnil(uValue), ::cCodigoProducto     := uValue, trimpadr( ::cCodigoProducto, 18 ) ) )
   DATA cDescProducto               INIT ''
   METHOD DescProducto(uValue)      INLINE ( if( !isnil(uValue), ::cDescProducto       := uValue, trimpadr( ::cDescProducto, 50 ) ) )
   DATA cFabricante                 INIT ''
   METHOD Fabricante(uValue)        INLINE ( if( !isnil(uValue), ::cFabricante         := uValue, trimpadr( ::cFabricante, 10 ) ) )
   DATA cCodigoProdFab              INIT ''
   METHOD CodigoProdFab(uValue)     INLINE ( if( !isnil(uValue), ::cCodigoProdFab      := uValue, trimpadr( ::cCodigoProdFab, 18 ) ) )
   DATA cEAN13                      INIT ''
   METHOD EAN13(uValue)             INLINE ( if( !isnil(uValue), ::cEAN13              := uValue, trimpadr( ::cEAN13, 13 ) ) )
   DATA nCantidad                   INIT 0
   METHOD Cantidad(uValue)          INLINE ( if( !isnil(uValue), ::nCantidad           := uValue, trimpadr( trans( ::nCantidad, "@E 9999999999.999" ), 14 ) ) )
   DATA cUM                         INIT ''
   METHOD UM(uValue)                INLINE ( if( !isnil(uValue), ::cUM                 := uValue, trimpadr( ::cUM, 5 ) ) )
   DATA nPrecioBase                 INIT 0
   METHOD PrecioBase(uValue)        INLINE ( if( !isnil(uValue), ::nPrecioBase         := uValue, trimpadr( trans( ::nPrecioBase, "@E 9999999999.999" ), 14 ) ) )
   DATA nDescuentos                 INIT 0
   METHOD Descuentos(uValue)        INLINE ( if( !isnil(uValue), ::nDescuentos         := uValue, trimpadr( trans( ::nDescuentos, "@E 9999999999.999" ), 14 ) ) )
   DATA nPrecioBrutoTotal           INIT 0
   METHOD PrecioBrutoTotal(uValue)  INLINE ( if( !isnil(uValue), ::nPrecioBrutoTotal   := uValue, trimpadr( trans( ::nPrecioBrutoTotal, "@E 9999999999.999" ), 14 ) ) )
   DATA dFechaFra                   INIT date()
   METHOD FechaFra(uValue)          INLINE ( if( !isnil(uValue), ::dFechaFra           := uValue, dtos( ::dFechaFra ) ) )
   DATA nEjercicio                  INIT 0
   METHOD Ejercicio(uValue)         INLINE ( if( !isnil(uValue), ::nEjercicio          := uValue, str( ::nEjercicio, 4 ) ) )
   DATA cCodigoCliente              INIT ''
   METHOD CodigoCliente(uValue)     INLINE ( if( !isnil(uValue), ::cCodigoCliente      := uValue, trimpadr( ::cCodigoCliente, 15 ) ) )
   DATA cNombre                     INIT ''
   METHOD Nombre(uValue)            INLINE ( if( !isnil(uValue), ::cNombre             := uValue, trimpadr( ::cNombre, 50 ) ) )
   DATA cRazonSocial                INIT ''
   METHOD RazonSocial(uValue)       INLINE ( if( !isnil(uValue), ::cRazonSocial        := uValue, trimpadr( ::cRazonSocial, 50 ) ) )
   DATA cCIF                        INIT ''
   METHOD CIF(uValue)               INLINE ( if( !isnil(uValue), ::cCIF                := uValue, trimpadr( ::cCIF, 15 ) ) )
   DATA cDireccion                  INIT ''
   METHOD Direccion(uValue)         INLINE ( if( !isnil(uValue), ::cDireccion          := uValue, trimpadr( ::cDireccion, 100 ) ) ) 
   DATA cPoblacion                  INIT ''
   METHOD Poblacion(uValue)         INLINE ( if( !isnil(uValue), ::cPoblacion          := uValue, trimpadr( ::cPoblacion, 50 ) ) )
   DATA cCodigoPostal               INIT ''
   METHOD CodigoPostal(uValue)      INLINE ( if( !isnil(uValue), ::cCodigoPostal       := uValue, trimpadr( ::cCodigoPostal, 5 ) ) )
   DATA cRuta                       INIT ''
   METHOD Ruta(uValue)              INLINE ( if( !isnil(uValue), ::cRuta               := uValue, trimpadr( ::cRuta, 10 ) ) )
   DATA cNombreRuta                 INIT ''
   METHOD NombreRuta(uValue)        INLINE ( if( !isnil(uValue), ::cNombreRuta         := uValue, trimpadr( ::cNombreRuta, 50 ) ) )
   DATA cCodigoComercial            INIT ''
   METHOD CodigoComercial(uValue)   INLINE ( if( !isnil(uValue), ::cCodigoComercial    := uValue, trimpadr( ::cCodigoComercial, 10 ) ) )
   DATA cNombreComercial            INIT ''
   METHOD NombreComercial(uValue)   INLINE ( if( !isnil(uValue), ::cNombreComercial    := uValue, trimpadr( ::cNombreComercial, 50 ) ) )
   DATA nPeso                       INIT 0
   METHOD Peso(uValue)              INLINE ( if( !isnil(uValue), ::nPeso               := uValue, trimpadr( trans( ::nPeso, "@E 9999999999.999" ), 14 ) ) )
   DATA cUMPeso                     INIT ''
   METHOD UMPeso(uValue)            INLINE ( if( !isnil(uValue), ::cUMPeso             := uValue, trimpadr( ::cUMPeso, 5 ) ) )
   DATA cTipoCliente                INIT ''
   METHOD TipoCliente(uValue)       INLINE ( if( !isnil(uValue), ::cTipoCliente        := uValue, trimpadr( ::cTipoCliente, 6 ) ) )
   DATA cTelefono                   INIT ''
   METHOD Telefono(uValue)          INLINE ( if( !isnil(uValue), ::cTelefono           := uValue, trimpadr( ::cTelefono, 11 ) ) )
   DATA cDescTipoCliente            INIT ''
   METHOD DescTipoCliente(uValue)   INLINE ( if( !isnil(uValue), ::cDescTipoCliente    := uValue, trimpadr( ::cDescTipoCliente, 50 ) ) )

   METHOD isRepeatLine( cBuffer )
   METHOD isSameLine( aLinea, cBuffer )

ENDCLASS

   //------------------------------------------------------------------------//

   METHOD SerializeASCII() CLASS Uve 

      local cBuffer

      cBuffer         := ::NumFactura()       + ::Separator()
      cBuffer         += ::NumLinea()         + ::Separator()
      cBuffer         += ::CodigoProducto()   + ::Separator()
      cBuffer         += ::DescProducto()     + ::Separator()
      cBuffer         += ::Fabricante()       + ::Separator()
      cBuffer         += ::CodigoProdFab()    + ::Separator()
      cBuffer         += ::EAN13()            + ::Separator()
      cBuffer         += ::Cantidad()         + ::Separator()
      cBuffer         += ::UM()               + ::Separator()
      cBuffer         += ::PrecioBase()       + ::Separator()
      cBuffer         += ::Descuentos()       + ::Separator()
      cBuffer         += ::PrecioBrutoTotal() + ::Separator()
      cBuffer         += ::FechaFra()         + ::Separator()
      cBuffer         += ::Ejercicio()        + ::Separator()
      cBuffer         += ::CodigoCliente()    + ::Separator()
      cBuffer         += ::Nombre()           + ::Separator()
      cBuffer         += ::RazonSocial()      + ::Separator()
      cBuffer         += ::CIF()              + ::Separator()
      cBuffer         += ::Direccion()        + ::Separator()
      cBuffer         += ::Poblacion()        + ::Separator()
      cBuffer         += ::CodigoPostal()     + ::Separator()
      cBuffer         += ::Ruta()             + ::Separator()
      cBuffer         += ::NombreRuta()       + ::Separator()
      cBuffer         += ::CodigoComercial()  + ::Separator()
      cBuffer         += ::NombreComercial()  + ::Separator()
      cBuffer         += ::Peso()             + ::Separator()
      cBuffer         += ::UMPeso()           + ::Separator()
      cBuffer         += ::TipoCliente()      + ::Separator()
      cBuffer         += ::Telefono()         + ::Separator()
      cBuffer         += ::DescTipoCliente()  + ::Separator()
      cBuffer         += CRLF

      if !::isRepeatLine( cBuffer )
         aadd( ::aLineas, cBuffer )
      end if

   Return ( ::aLineas )

//---------------------------------------------------------------------------//

   METHOD isRepeatLine( cBuffer )  CLASS Uve 
      
      local aLastLine   := atail( ::aLineas )

      if empty( aLastLine )
         return ( .f. )
      end if 

      // msgAlert( hb_valtoexp( aLastLine ), "aLastLine" )
      // msgAlert( cBuffer, "cBuffer")
      // msgAlert( ::isSameLine( aLastLine, cBuffer ), "isSameLine" )

   Return ( ::isSameLine( aLastLine, cBuffer ) )

//---------------------------------------------------------------------------//

   METHOD isSameLine( cLinea, cBuffer )  CLASS Uve 

       local aLinea     := hb_atokens( cLinea, ";" )
       local aBuffer    := hb_atokens( cBuffer, ";" )

   Return ( aLinea[ 1 ] + aLinea[ 2 ] == aBuffer[ 1 ] + aBuffer[ 2 ] )

//---------------------------------------------------------------------------//

   METHOD WriteASCII( bWriteLine ) CLASS Uve

      local cLinea

      if empty( ::aLineas )
         msgAlert( "Lineas vacias." )
         Return ( .f. )
      end if

      ::hFile  := fCreate( ::cFile )

      if !empty( ::hFile )
         for each cLinea in ::aLineas
            fWrite( ::hFile, cLinea )
         next
         fClose( ::hFile )
      end if

   Return ( Self )

//---------------------------------------------------------------------------//

Static Function TrimPadr( cString, nLen )

Return ( alltrim( padr( cString, nLen ) ) )

//---------------------------------------------------------------------------//

