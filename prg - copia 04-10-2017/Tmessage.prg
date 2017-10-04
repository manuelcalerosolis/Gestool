//----------------------------------------------------------------------------//
//  AUTOR.....: Manuel Exp¢sito Su rez   Soft 4U                              //
//  e-Mail....: maex14@dipusevilla.es                                         //
//  CLASE.....: General                                                       //
//  FECHA MOD.: 24/01/2002                                                    //
//  VERSION...: 11.00                                                         //
//  PROPOSITO.: Funciones auxiliares para TDbf para controlar lenguaje        //
//----------------------------------------------------------------------------//

function SetLang( nLang ) ; return( if( ValType( nLang ) != "N", 0, nLang ) )

//----------------------------------------------------------------------------//

function GetMsg( nLang )

    local aMsg := {}

    DO CASE
      CASE nLang == 0 //---------------------------------------------- Espa¤ol
            aMsg := { OemToAnsi( " S¡ " ), ;
                      " No ", ;
                      OemToAnsi( " ¨Contin£a? " ), ;
                      OemToAnsi( " ¨Cancela? " ), ;
                      OemToAnsi( " ¨Reintenta? " ), ;
                      OemToAnsi( " Elija una opci¢n " ), ;
                      " Registro bloqueado " , ;
                      " No se puede abrir la Base de Datos ", ;
                      " No hay campos definidos ", ;
                      " ERROR SCOPE - Los tipos de datos no coinciden ", ;
                      " ERROR SCOPE - Topes no nivelados ", ;
                      OemToAnsi( " Registro borrado. ¨Lo recupera? " ), ;
                      " Error asignando los CodeBlock del Browse ", ;
                      " El valor asignado no es correcto ", ;
                      " Registros borrados ", ;
                      " No hay orden activo ", ;
                      " Falta especificar el nombre del fichero DBF ",;
                      " Imposible borrar el fichero MEMO ", ;
                      " Imposible renombrar el fichero MEMO " }
      CASE nLang == 1 //- Por Joaquim Ferrer ------------------------ Catalan
            aMsg := { " Sí ", ;
                      " No ", ;
                      OemToAnsi( " ¨Continuar? " ), ;
                      OemToAnsi( " ¨Cancel.lar? " ), ;
                      OemToAnsi( " ¨Reintenteu? " ), ;
                      OemToAnsi( " Escollir una opci¢ " ), ;
                      " Registre bloquejat " , ;
                      " No és possible obrir la Base de Dades ", ;
                      " No hi ha camps definits ", ;
                      " ERROR SCOPE - Els tipus de dades no coincideixen ", ;
                      " ERROR SCOPE - Valor superior menor que l'inferior ", ;
                      OemToAnsi( " Registre esborrat. ¨Vol recuperar-l'ho? " ), ;
                      " Error assignant els CodeBlock del Browse ", ;
                      " El valor assignat no és el correcte ", ;
                      " Registres esborrats ", ;
                      " No hi ha orden definit ", ;
                      " Falta especificar el nombre del fichero DBF ",;
                      " Imposible borrar el fichero MEMO ", ;
                      " Imposible renombrar el fichero MEMO " }
    end

return( aMsg )

//----------------------------------------------------------------------------//

