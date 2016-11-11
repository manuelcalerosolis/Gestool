#include "FiveWin.Ch"

#include "Hbxml.ch"
#include "Hbclass.ch"
#include "Fileio.ch"

#include "Factu.ch" 
      
//---------------------------------------------------------------------------//

Function ImportarExcelClientesMarpicon( nView )                	 
	      
   local oImportarExcel    := TImportarExcelClientesMarpicon():New( nView )

   oImportarExcel:Run()

Return nil

//---------------------------------------------------------------------------//

CLASS TImportarExcelClientesMarpicon FROM TImportarExcel

   METHOD New()

   METHOD procesaFicheroExcel()

   METHOD importarCampos()   

   METHOD getCampoClave()        INLINE ( strzero( ::getExcelNumeric( ::cColumnaCampoClave ), 6 ) )

   METHOD existeRegistro()       INLINE ( D():gotoCliente( ::getCampoClave(), ::nView ) )

   METHOD appendRegistro()       INLINE ( ( D():Clientes( ::nView ) )->( dbappend() ), logwrite( 'appendRegistro' + ::getCampoClave() ) )

   METHOD bloqueaRegistro()      INLINE ( ( D():Clientes( ::nView ) )->( dbrlock() ), logwrite( 'bloqueaRegistro' + ::getCampoClave() ) )

   METHOD desbloqueaRegistro()   INLINE ( ( D():Clientes( ::nView ) )->( dbcommit() ),;
                                          ( D():Clientes( ::nView ) )->( dbunlock() ) )


END CLASS

//----------------------------------------------------------------------------//

METHOD New( nView )

   ::Super:New( nView )

   /*
   Cambiar el nombre del fichero
   */

   ::cFicheroExcel            := "C:\Users\calero\Desktop\clientes_marpicon.csv"

   /*
   Cambiar la fila de cominezo de la importacion
   */

   ::nFilaInicioImportacion   := 2

   /*
   Columna de campo clave
   */

   ::cColumnaCampoClave       := "C"


Return ( Self )

//----------------------------------------------------------------------------// 

METHOD procesaFicheroExcel()

   ::openExcel()

   while ( ::filaValida() )

      if ::existeRegistro()
        ::bloqueaRegistro()
      else
         ::appendRegistro()
      end if 

      if !( neterr() )      

         ::importarCampos()

         ::desbloqueaRegistro()

      endif

      ::siguienteLinea()

   end if

   ::closeExcel()

Return nil

//---------------------------------------------------------------------------//

METHOD importarCampos()

   ( D():Clientes( ::nView ) )->Cod       := ::getCampoClave()
   ( D():Clientes( ::nView ) )->Titulo    := ::getExcelValue( "D" )
   ( D():Clientes( ::nView ) )->Nif       := ::getExcelString( "P" )  
   ( D():Clientes( ::nView ) )->Riesgo    := ::getExcelNumeric( "G" )
   ( D():Clientes( ::nView ) )->cCodWeb   := ::getExcelNumeric( "AB" )

Return nil

//---------------------------------------------------------------------------//

#include "ImportarExcel.prg"

/*
   aAdd( aBase, { "Cod",       "C", 12, 0, "Código",                                        "Codigo",                "", "( cDbfCli )", nil } )
   aAdd( aBase, { "Titulo",    "C", 80, 0, "Nombre",                                        "Nombre",                "", "( cDbfCli )", nil } )
   aAdd( aBase, { "Nif",       "C", 30, 0, "NIF",                                           "NIF",                   "", "( cDbfCli )", nil } )
   aAdd( aBase, { "Domicilio", "C",200, 0, "Domicilio",                                     "Domicilio",             "", "( cDbfCli )", nil } )
   aAdd( aBase, { "Poblacion", "C",200, 0, "Población",                                     "Poblacion",             "", "( cDbfCli )", nil } )
   aAdd( aBase, { "Provincia", "C",100, 0, "Provincia",                                     "Provincia",             "", "( cDbfCli )", nil } )
   aAdd( aBase, { "CodPostal", "C", 15, 0, "Código postal",                                 "CodigoPostal",          "", "( cDbfCli )", nil } )
   aAdd( aBase, { "Telefono",  "C", 50, 0, "Teléfono",                                      "Telefono",              "", "( cDbfCli )", nil } )
   aAdd( aBase, { "Fax",       "C", 50, 0, "Fax",                                           "",                      "", "( cDbfCli )", nil } )
   aAdd( aBase, { "Movil",     "C", 50, 0, "Móvil",                                         "",                      "", "( cDbfCli )", nil } )
   aAdd( aBase, { "NbrEst",    "C",200, 0, "Nombre del establecimiento" ,                   "NombreEstablecimiento", "", "( cDbfCli )", nil } )
   aAdd( aBase, { "Direst",    "C",200, 0, "Domicilio del servicio" ,                       "",                      "", "( cDbfCli )", nil } )
   aAdd( aBase, { "DiaPago",   "N",  2, 0, "Primer día de pago",                            "",                      "", "( cDbfCli )", nil } )
   aAdd( aBase, { "DiaPago2",  "N",  2, 0, "Segundo día de pago",                           "",                      "", "( cDbfCli )", nil } )
   aAdd( aBase, { "Banco",     "C", 50, 0, "Nombre del banco",                              "",                      "", "( cDbfCli )", nil } )
   aAdd( aBase, { "DirBanco",  "C", 35, 0, "Domicilio del banco",                           "",                      "", "( cDbfCli )", nil } )
   aAdd( aBase, { "PobBanco",  "C", 25, 0, "Población del banco",                           "",                      "", "( cDbfCli )", nil } )
   aAdd( aBase, { "cProBanco", "C", 20, 0, "Provincia del banco",                           "",                      "", "( cDbfCli )", nil } )
   aAdd( aBase, { "Cuenta",    "C", 20, 0, "",                                              "",                      "", "( cDbfCli )", nil } )
   aAdd( aBase, { "nTipCli",   "N",  1, 0, "Tipo",                                          "TipoCliente",           "", "( cDbfCli )", nil } )
   aAdd( aBase, { "CodPago",   "C",  2, 0, "Código del tipo de pago",                       "",                      "", "( cDbfCli )", nil } )
   aAdd( aBase, { "cDtoEsp",   "C", 50, 0, "Descripción del descuento por factura" ,        "",                      "", "( cDbfCli )", nil } )
   aAdd( aBase, { "nDtoEsp",   "N",  6, 2, "Porcentaje de descuento por factura" ,          "",                      "", "( cDbfCli )", nil } )
   aAdd( aBase, { "cDpp",      "C", 50, 0, "Descripción del descuento por pronto pago" ,    "",                      "", "( cDbfCli )", nil } )
   aAdd( aBase, { "nDpp",      "N",  6, 2, "Porcentaje de descuento por pronto pago" ,      "",                      "", "( cDbfCli )", nil } )
   aAdd( aBase, { "nDtoCnt",   "N",  6, 2, "Porcentaje del primer dto personalizado" ,      "",                      "", "( cDbfCli )", nil } )
   aAdd( aBase, { "nDtoRap",   "N",  6, 2, "Porcentaje del segundo dto personalizado" ,     "",                      "", "( cDbfCli )", nil } )
   aAdd( aBase, { "cDtoUno",   "C", 50, 0, "Descripción del primer dto personalizado" ,     "",                      "", "( cDbfCli )", nil } )
   aAdd( aBase, { "cDtoDos",   "C", 50, 0, "Descripción del segundo dto personalizado" ,    "",                      "", "( cDbfCli )", nil } )
   aAdd( aBase, { "nDtoPtf",   "N",  6, 2, "Importe de descuento plataforma" ,              "",                      "", "( cDbfCli )", nil } )
   aAdd( aBase, { "Riesgo",    "N", 16, 6, "Importe maximo autorizado para operaciones",    "",                      "", "( cDbfCli )", nil } )
   aAdd( aBase, { "CopiasF",   "N",  1, 0, "Número de facturas a imprimir",                 "",                      "", "( cDbfCli )", nil } )
   aAdd( aBase, { "Serie",     "C",  1, 0, "Código de la serie de facturas",                "",                      "", "( cDbfCli )", nil } )
   aAdd( aBase, { "nRegIva",   "N",  1, 0, "Regimen de " + cImp(),                          "",                      "", "( cDbfCli )", nil } )
   aAdd( aBase, { "lReq",      "L",  1, 0, "Lógico para recargo de equivalencia (S/N)",     "",                      "", "( cDbfCli )", nil } )
   aAdd( aBase, { "Subcta",    "C", 12, 0, "Subcuenta cliente enlace contaplus",            "",                      "", "( cDbfCli )", nil } )
   aAdd( aBase, { "CtaVenta",  "C",  3, 0, "Cuenta venta cliente contaplus",                "",                      "", "( cDbfCli )", nil } )
   aAdd( aBase, { "cAgente",   "C",  3, 0, "Código agente comercial",                       "CodigoAgente",          "", "( cDbfCli )", {|| accessCode():cAgente } } )
   aAdd( aBase, { "lMayorista","L",  1, 0, "Utilizar precio de mayorista (S/N)" ,           "",                      "", "( cDbfCli )", nil } )
   aAdd( aBase, { "nTarifa",   "N",  1, 0, "Tarifa a aplicar" ,                             "",                      "", "( cDbfCli )", nil } )
   aAdd( aBase, { "lLabel",    "L",  1, 0, "Lógico para etiquetado (S/N)" ,                 "",                      "", "( cDbfCli )", nil } )
   aAdd( aBase, { "nLabel",    "N",  5, 0, "Número de etiquetas a imprimir" ,               "",                      "", "( cDbfCli )", nil } )
   aAdd( aBase, { "cCodTar",   "C",  5, 0, "Código de tarifa" ,                             "",                      "", "( cDbfCli )", nil } )
   aAdd( aBase, { "mComent",   "M", 10, 0, "Memo para comentarios" ,                        "",                      "", "( cDbfCli )", nil } )
   aAdd( aBase, { "cCodRut",   "C",  4, 0, "Código de ruta" ,                               "CodigoRuta",            "", "( cDbfCli )", nil } )
   aAdd( aBase, { "cCodRut2",  "C",  4, 0, "Código de ruta alternativa" ,                   "",                      "", "( cDbfCli )", nil } ) 
   aAdd( aBase, { "cCodPai",   "C",  4, 0, "Código de país" ,                               "",                      "", "( cDbfCli )", nil } )
   aAdd( aBase, { "cCodGrp",   "C",  4, 0, "Código de grupo de cliente" ,                   "",                      "", "( cDbfCli )", nil } )
   aAdd( aBase, { "cCodRem",   "C",  3, 0, "Código de remesa" ,                             "",                      "", "( cDbfCli )", nil } )
   aAdd( aBase, { "cMeiInt",   "C",240, 0, "Correo electrónico" ,                           "Email",                 "", "( cDbfCli )", nil } )
   aAdd( aBase, { "cWebInt",   "C", 65, 0, "Página web" ,                                   "",                      "", "( cDbfCli )", nil } )
   aAdd( aBase, { "lChgPre",   "L",  1, 0, "Lógico para autorización de venta de crédito" , "",                      "", "( cDbfCli )", nil } )
   aAdd( aBase, { "lCreSol",   "L",  1, 0, "Lógico para bloquear con riesgo alcanzado" ,    "",                      "", "( cDbfCli )", nil } )
   aAdd( aBase, { "lPntVer",   "L",  1, 0, "Lógico para operar con punto verde" ,           "",                      "", "( cDbfCli )", nil } )
   aAdd( aBase, { "cUsrDef01", "C",100, 0, "Campo definido 1" ,                             "",                      "", "( cDbfCli )", nil } )
   aAdd( aBase, { "cUsrDef02", "C",100, 0, "Campo definido 2" ,                             "",                      "", "( cDbfCli )", nil } )
   aAdd( aBase, { "cUsrDef03", "C",100, 0, "Campo definido 3" ,                             "",                      "", "( cDbfCli )", nil } )
   aAdd( aBase, { "cUsrDef04", "C",100, 0, "Campo definido 4" ,                             "",                      "", "( cDbfCli )", nil } )
   aAdd( aBase, { "cUsrDef05", "C",100, 0, "Campo definido 5" ,                             "",                      "", "( cDbfCli )", nil } )
   aAdd( aBase, { "cUsrDef06", "C",100, 0, "Campo definido 6" ,                             "",                      "", "( cDbfCli )", nil } )
   aAdd( aBase, { "cUsrDef07", "C",100, 0, "Campo definido 7" ,                             "",                      "", "( cDbfCli )", nil } )
   aAdd( aBase, { "cUsrDef08", "C",100, 0, "Campo definido 8" ,                             "",                      "", "( cDbfCli )", nil } )
   aAdd( aBase, { "cUsrDef09", "C",100, 0, "Campo definido 9" ,                             "",                      "", "( cDbfCli )", nil } )
   aAdd( aBase, { "cUsrDef10", "C",100, 0, "Campo definido 10" ,                            "",                      "", "( cDbfCli )", nil } )
   aAdd( aBase, { "lVisLun",   "L",  1, 0, "" ,                                             "lVisLun",               "", "( cDbfCli )", nil } ) 
   aAdd( aBase, { "lVisMar",   "L",  1, 0, "" ,                                             "lVisMar",               "", "( cDbfCli )", nil } )
   aAdd( aBase, { "lVisMie",   "L",  1, 0, "" ,                                             "lVisMie",               "", "( cDbfCli )", nil } )
   aAdd( aBase, { "lVisJue",   "L",  1, 0, "" ,                                             "lVisJue",               "", "( cDbfCli )", nil } )
   aAdd( aBase, { "lVisVie",   "L",  1, 0, "" ,                                             "lVisVie",               "", "( cDbfCli )", nil } )
   aAdd( aBase, { "lVisSab",   "L",  1, 0, "" ,                                             "lVisSab",               "", "( cDbfCli )", nil } )
   aAdd( aBase, { "lVisDom",   "L",  1, 0, "" ,                                             "lVisDom",               "", "( cDbfCli )", nil } )
   aAdd( aBase, { "nVisLun",   "N",  4, 0, "" ,                                             "",                      "", "( cDbfCli )", nil } )
   aAdd( aBase, { "nVisMar",   "N",  4, 0, "" ,                                             "",                      "", "( cDbfCli )", nil } )
   aAdd( aBase, { "nVisMie",   "N",  4, 0, "" ,                                             "",                      "", "( cDbfCli )", nil } )
   aAdd( aBase, { "nVisJue",   "N",  4, 0, "" ,                                             "",                      "", "( cDbfCli )", nil } )
   aAdd( aBase, { "nVisVie",   "N",  4, 0, "" ,                                             "",                      "", "( cDbfCli )", nil } )
   aAdd( aBase, { "nVisSab",   "N",  4, 0, "" ,                                             "",                      "", "( cDbfCli )", nil } )
   aAdd( aBase, { "nVisDom",   "N",  4, 0, "" ,                                             "",                      "", "( cDbfCli )", nil } )
   aAdd( aBase, { "cAgeLun",   "C",  3, 0, "Código agente para visita lunes",               "",                      "", "( cDbfCli )", nil } )
   aAdd( aBase, { "cAgeMar",   "C",  3, 0, "Código agente para visita martes",              "",                      "", "( cDbfCli )", nil } )
   aAdd( aBase, { "cAgeMie",   "C",  3, 0, "Código agente para visita miercoles",           "",                      "", "( cDbfCli )", nil } )
   aAdd( aBase, { "cAgeJue",   "C",  3, 0, "Código agente para visita jueves",              "",                      "", "( cDbfCli )", nil } )
   aAdd( aBase, { "cAgeVie",   "C",  3, 0, "Código agente para visita viernes",             "",                      "", "( cDbfCli )", nil } )
   aAdd( aBase, { "cAgeSab",   "C",  3, 0, "Código agente para visita sabado",              "",                      "", "( cDbfCli )", nil } )
   aAdd( aBase, { "cAgeDom",   "C",  3, 0, "Código agente para visita domingo",             "",                      "", "( cDbfCli )", nil } )
   aAdd( aBase, { "lSndInt",   "L",  1, 0, "Lógico para envio por internet" ,               "",                      "", "( cDbfCli )", nil } )
   aAdd( aBase, { "cPerCto",   "C",200, 0, "Persona de contacto" ,                          "",                      "", "( cDbfCli )", nil } )
   aAdd( aBase, { "cCodAlm",   "C", 16, 0, "Código de almacén",                             "",                      "", "( cDbfCli )", nil } )
   aAdd( aBase, { "nMesVac",   "N",  2, 0, "Mes de vacaciones",                             "",                      "", "( cDbfCli )", nil } )
   aAdd( aBase, { "nImpRie",   "N", 16, 6, "Riesgo alcanzado",                              "",                      "", "( cDbfCli )", nil } )
   aAdd( aBase, { "nColor",    "N", 10, 0, "",                                              "",                      "", "( cDbfCli )", nil } )
   aAdd( aBase, { "SubCtaDto", "C", 12, 0, "Código subcuenta descuento",                    "",                      "", "( cDbfCli )", nil } )
   aAdd( aBase, { "lBlqCli",   "L",  1, 0, "Cliente bloqueado" ,                            "",                      "", "( cDbfCli )", nil } )
   aAdd( aBase, { "lMosCom",   "L",  1, 0, "Mostrar comentario" ,                           "",                      "", "( cDbfCli )", nil } )
   aAdd( aBase, { "lTotAlb",   "L",  1, 0, "Totalizar albaranes" ,                          "",                      "", "( cDbfCli )", nil } )
   aAdd( aBase, { "cDtoAtp",   "C", 50, 0, "Descripción del descuento atipico" ,            "",                      "", "( cDbfCli )", nil } )
   aAdd( aBase, { "nDtoAtp",   "N",  6, 2, "Porcentaje de descuento atípico" ,              "",                      "", "( cDbfCli )", nil } )
   aAdd( aBase, { "nSbrAtp",   "N",  1, 0, "" ,                                             "",                      "", "( cDbfCli )", nil } )
   aAdd( aBase, { "cCodUsr",   "C",  3, 0, "Código de usuario que realiza el cambio" ,      "",                      "", "( cDbfCli )", nil } )
   aAdd( aBase, { "dFecChg",   "D",  8, 0, "Fecha de cambio" ,                              "",                      "", "( cDbfCli )", nil } )
   aAdd( aBase, { "cTimChg",   "C",  5, 0, "Hora de cambio" ,                               "",                      "", "( cDbfCli )", nil } )
   aAdd( aBase, { "nTipRet",   "N",  1, 0, "Tipo de retención ( 1-Base / 2-Base+IVA )",     "",                      "", "( cDbfCli )", nil } )
   aAdd( aBase, { "nPctRet",   "N",  6, 2, "Porcentaje de retención",                       "",                      "", "( cDbfCli )", nil } )
   aAdd( aBase, { "dFecBlq",   "D",  8, 0, "Fecha de bloqueo del cliente",                  "",                      "", "( cDbfCli )", nil } )
   aAdd( aBase, { "cMotBlq",   "C",250, 0, "Motivo del bloqueo del cliente",                "",                      "", "( cDbfCli )", nil } )
   aAdd( aBase, { "lModDat",   "L",  1, 0, "Lógico para no modificar datos en la venta" ,   "",                      "", "( cDbfCli )", nil } )
   aAdd( aBase, { "lMail",     "L",  1, 0, "Lógico para enviar mail" ,                      "",                      "", "( cDbfCli )", nil } )
   aAdd( aBase, { "cCodTrn",   "C",  9, 0, "Código del transportista" ,                     "",                      "", "( cDbfCli )", nil } )
   aAdd( aBase, { "mObserv",   "M", 10, 0, "Observaciones",                                 "",                      "", "( cDbfCli )", nil } )
   aAdd( aBase, { "lPubInt",   "L",  4, 0, "Lógico para publicar en internet (S/N)",        "",                      "", "( cDbfCli )", nil } )
   aAdd( aBase, { "cClave",    "C", 40, 0, "Contraseña cliente para Web",                   "",                      "", "( cDbfCli )", nil } )
   aAdd( aBase, { "cCodWeb",   "N", 11, 0, "Código del cliente en la web",                  "",                      "", "( cDbfCli )", nil } )
   aAdd( aBase, { "cCodEdi",   "C", 17, 0, "Código del cliente en EDI (EAN)",               "",                      "", "( cDbfCli )", nil } )
   aAdd( aBase, { "cFacAut",   "C",  3, 0, "Código de factura automática",                  "",                      "", "( cDbfCli )", nil } )
   aAdd( aBase, { "lWeb",      "L",  4, 0, "Lógico para creado desde internet (S/N)",       "",                      "", "( cDbfCli )", nil } )
   aAdd( aBase, { "nDtoArt",   "N",  1, 0, "Descuento de artículo",                         "",                      "", "( cDbfCli )", nil } )
   aAdd( aBase, { "lExcFid",   "L",  1, 0, "Lógico para creado desde internet (S/N)",       "",                      "", "( cDbfCli )", nil } )
   aAdd( aBase, { "mFacAut",   "M", 10, 0, "Plantillas de facturas automáticas",            "",                      "", "( cDbfCli )", nil } )
   aAdd( aBase, { "dFecNaci",  "D",  8, 0, "Fecha de nacimiento",                           "",                      "", "( cDbfCli )", nil } )
   aAdd( aBase, { "nSexo",     "N",  1, 0, "Sexo del cliente",                              "",                      "", "( cDbfCli )", nil } )
   aAdd( aBase, { "nTarCmb",   "N",  1, 0, "Tarifa a aplicar para combinar en táctil" ,     "",                      "", "( cDbfCli )", nil } )
   aAdd( aBase, { "dLlaCli",   "D",  8, 0, "Última llamada del cliente" ,                   "",                      "", "( cDbfCli )", nil } )
   aAdd( aBase, { "cTimCli",   "C",  5, 0, "Hora última llamada del cliente" ,              "",                      "", "( cDbfCli )", nil } )
   aAdd( aBase, { "cTipInci",  "C",  5, 0, "Tipo de incidencia" ,                           "",                      "", "( cDbfCli )", nil } )
   aAdd( aBase, { "Telefono2", "C", 50, 0, "Segundo teléfono",                              "Telefono2",             "", "( cDbfCli )", nil } )
   aAdd( aBase, { "Movil2",    "C", 50, 0, "Segundo móvil",                                 "Movil2",                "", "( cDbfCli )", nil } )
   aAdd( aBase, { "cAgente2",  "C",  3, 0, "Código de segundo agente comercial ",           "CodigoAgente2",         "", "( cDbfCli )", {|| accessCode():cAgente } } )
   aAdd( aBase, { "cDeparta",  "C",  4, 0, "Código de departamento",                        "Departamento",          "", "( cDbfCli )", nil } )
   aAdd( aBase, { "cDomEnt",   "C",200, 0, "Domicilio de entrega",                          "DomicilioEntrega",      "", "( cDbfCli )", nil } )
   aAdd( aBase, { "cPobEnt",   "C",200, 0, "Población de entrega",                          "PoblacionEntrega",      "", "( cDbfCli )", nil } )
   aAdd( aBase, { "cCPEnt",    "C", 15, 0, "Código postal de entrega",                      "CodigoPostalEntrega",   "", "( cDbfCli )", nil } )
   aAdd( aBase, { "cPrvEnt",   "C",200, 0, "Provincia de entrega",                          "ProvinciaEntrega",      "", "( cDbfCli )", nil } )
   aAdd( aBase, { "cProvee",   "C", 50, 0, "Código de proveedor",                           "CodigoProveedor",       "", "( cDbfCli )", nil } )
   aAdd( aBase, { "cCodBic",   "C", 50, 0, "Código Bic",                                    "",                      "", "( cDbfCli )", nil } )
   aAdd( aBase, { "cHorario",  "C", 50, 0, "Horario",                                       "",                      "", "( cDbfCli )", nil } )
   aAdd( aBase, { "cEntidad",  "C", 25, 0, "Entidad",                                       "",                      "", "( cDbfCli )", nil } )
   aAdd( aBase, { "dPetRie",   "D",  8, 0, "Fecha de petición de riesgo",                   "",                      "", "( cDbfCli )", nil } )
   aAdd( aBase, { "dConRie",   "D",  8, 0, "Fecha de concesión de riesgo",                  "",                      "", "( cDbfCli )", nil } )
   aAdd( aBase, { "lInaCli",   "L",  1, 0, "Lógico para cliente inactivo",                  "",                      "", "( cDbfCli )", nil } )
   aAdd( aBase, { "dFecIna",   "D",  8, 0, "Fecha de inactividad del cliente",              "",                      "", "( cDbfCli )", nil } )
   aAdd( aBase, { "cMotIna",   "C",250, 0, "Motivo de inactividad del cliente",             "",                      "", "( cDbfCli )", nil } )
   aAdd( aBase, { "dAlta",     "D",  8, 0, "Fecha de alta del cliente",                     "",                      "", "( cDbfCli )", nil } )
*/