#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS TInfEsp FROM TInfGen

   DATA  oDbfArt           AS OBJECT
   DATA  oDbfFam           AS OBJECT
   DATA  oDbfKit           AS OBJECT
   DATA  oDbfDiv           AS OBJECT
   DATA  oDbfIva           AS OBJECT
   DATA  oBrwArticulo      AS OBJECT
   DATA  oBrwFamilia       AS OBJECT
   DATA  oBrwSeleccion     AS OBJECT
   DATA  oGetFamilia       AS OBJECT
   DATA  oGetArticulo      AS OBJECT
   DATA  oCodigo           AS OBJECT
   DATA  cGetArticulo
   DATA  cGetFamilia
   DATA  cCodigo
   DATA  lFiltrarFamilias  AS LOGIC    INIT .t.
   DATA  aCbxFamilia       AS ARRAY    INIT { 'Código', 'Nombre' }
   DATA  oCbxFamilia       AS OBJECT
   DATA  aCbxArticulo      AS ARRAY    INIT { 'Código', 'Nombre', 'Código de barras', 'Família + Código', 'Família + Nombre' }
   DATA  oCbxArticulo      AS OBJECT

   Method Create()

   Method OpenFiles()

   Method CloseFiles()

   Method lResource( cFld )

   Method lGenerate()

   Method AgregarArticulo()

   Method AgregarTodos( cCodFam )

   Method BorrarArticulo()

   Method InsertarArticulo()

   Method EscribeArticulo( lAppend )

   Method ActualizaArticulo()

   Method GuardarArchivo()

   Method CargarArchivo()

   Method ChangeFamilias()

   Method SeekFamilia( nKey, nFlags )

   Method SeekArticulo( nKey, nFlags )

   Method EditColumn()

   Method SubirArticulo( lAppend )

   Method BajarArticulo( lAppend )

   METHOD BorrarTodosArticulos()       INLINE   ( ::oDbf:Zap(), ::oBrwSeleccion:Refresh() )

END CLASS

//---------------------------------------------------------------------------//

METHOD Create()

   ::AddField( "cCodArt", "C", 18, 0, {|| "@!" },            'Art.',           .t., 'Código artículo'       , 14, .f. )
   ::AddField( "cNomArt", "C",100, 0, {|| "@!" },            'Descripción',    .t., 'Descripción artículo'  , 80, .f. )
   ::AddField( "cCodFam", "C", 16, 0, {|| "@!" },            'Fam.',           .f., 'Familia'               ,  5, .f. )
   ::AddField( "cNomFam", "C", 40, 0, {|| "@!" },            'Nom. Fam.',      .f., 'Nombre familia'        , 20, .f. )
   ::AddField( "pCosto",  "N", 15, 6, {|| cPinDiv() },       'Costo',          .f., 'Precio de costo'       , 15, .f. )
   ::AddField( "pVenta1", "N", 15, 6, {|| ::cPicImp },       'Precio 1',       .t., 'Precio 1'              , 15, .f. )
   ::AddField( "pVtaIva1","N", 15, 6, {|| ::cPicImp },       'Precio " + cImp() + " 1',   .f., 'Precio " + cImp() + " 1'          , 15, .f. )
   ::AddField( "pVenta2", "N", 15, 6, {|| ::cPicImp },       'Precio 2',       .f., 'Precio 2'              , 15, .f. )
   ::AddField( "pVtaIva2","N", 15, 6, {|| ::cPicImp },       'Precio " + cImp() + " 2',   .f., 'Precio " + cImp() + " 2'          , 15, .f. )
   ::AddField( "pVenta3", "N", 15, 6, {|| ::cPicImp },       'Precio 3',       .f., 'Precio 3'              , 15, .f. )
   ::AddField( "pVtaIva3","N", 15, 6, {|| ::cPicImp },       'Precio " + cImp() + " 3',   .f., 'Precio " + cImp() + " 3'          , 15, .f. )
   ::AddField( "pVenta4", "N", 15, 6, {|| ::cPicImp },       'Precio 4',       .f., 'Precio 4'              , 15, .f. )
   ::AddField( "pVtaIva4","N", 15, 6, {|| ::cPicImp },       'Precio " + cImp() + " 4',   .f., 'Precio " + cImp() + " 4'          , 15, .f. )
   ::AddField( "pVenta5", "N", 15, 6, {|| ::cPicImp },       'Precio 5',       .f., 'Precio 5'              , 15, .f. )
   ::AddField( "pVtaIva5","N", 15, 6, {|| ::cPicImp },       'Precio " + cImp() + " 5',   .f., 'Precio " + cImp() + " 5'          , 15, .f. )
   ::AddField( "pVenta6", "N", 15, 6, {|| ::cPicImp },       'Precio 6',       .f., 'Precio 6'              , 15, .f. )
   ::AddField( "pVtaIva6","N", 15, 6, {|| ::cPicImp },       'Precio " + cImp() + " 6',   .f., 'Precio " + cImp() + " 6'          , 15, .f. )
   ::AddField( "nNumArt", "N",  9, 0, {|| "@!" },            'Num.',           .f., 'Posición en el informe', 10, .f. )

   ::AddTmpIndex ( "cCodFam", "cCodFam + cCodArt" )
   ::AddTmpIndex ( "cNomFam", "cNomFam + Str( nNumArt )" )
   ::AddTmpIndex ( "nNumArt", "Str( nNumArt )" )

   ::AddGroup( {|| ::oDbf:cNomFam }, {|| "Familia  : " + Rtrim( ::oDbf:cCodFam ) + "-" + Rtrim( ::oDbf:cNomFam ) }, {|| "" } )

   ::lDefSerInf   := .f.
   ::lDefFecInf   := .f.
   ::lDefDivInf   := .f.
   ::lDefTitInf   := .f.
   ::lDefMetInf   := .f.

   ::bPreGenerate := {|| ::oDbf:ordSetFocus( "cNomFam" ), ::oDbf:GoTop() }
   ::bPostGenerate:= {|| ::oDbf:ordSetFocus( "nNumArt" ), ::oDbf:GoTop() }

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD OpenFiles()

   local lOpen    := .t.
   local oBlock   := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

   DATABASE NEW ::oDbfArt  PATH ( cPatArt() ) FILE "ARTICULO.DBF" VIA ( cDriver() ) SHARED INDEX "ARTICULO.CDX"

   DATABASE NEW ::oDbfFam  PATH ( cPatArt() ) FILE "FAMILIAS.DBF" VIA ( cDriver() ) SHARED INDEX "FAMILIAS.CDX"

   DATABASE NEW ::oDbfKit  PATH ( cPatArt() )   FILE "ARTKIT.DBF"   VIA ( cDriver() ) SHARED INDEX "ARTKIT.CDX"

   DATABASE NEW ::oDbfDiv PATH ( cPatDat() )  FILE "DIVISAS.DBF"  VIA ( cDriver() ) SHARED INDEX "DIVISAS.CDX"

   DATABASE NEW ::oDbfIva PATH ( cPatDat() )  FILE "TIVA.DBF"     VIA ( cDriver() ) SHARED INDEX "TIVA.CDX"

   RECOVER

      msgStop( 'Imposible abrir todas las bases de datos' )
      ::CloseFiles()
      lOpen       := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD CloseFiles()

   if !Empty( ::oDbfArt ) .and. ::oDbfArt:Used()
      ::oDbfArt:End()
   end if
   if !Empty( ::oDbfFam ) .and. ::oDbfFam:Used()
      ::oDbfFam:End()
   end if
   if !Empty( ::oDbfKit ) .and. ::oDbfKit:Used()
      ::oDbfKit:End()
   end if
   if !Empty( ::oDbfDiv ) .and. ::oDbfDiv:Used()
      ::oDbfDiv:End()
   end if
   if ! Empty( ::oDbfIva ) .and. ::oDbfIva:Used()
      ::oDbfIva:End()
   end if

   ::oDbfArt := nil
   ::oDbfFam := nil
   ::oDbfKit := nil
   ::oDbfDiv := nil

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD lResource ( cFld )

   local cCbxFamilia          := 'Nombre'
   local cCbxArticulo         := 'Código'

   ::lBig                     := .t.

   if !::StdResource( "INFESPECIAL" )
      return .f.
   end if

   ::lLoadDivisa()

   ::oDbfArt:OrdSetFocus( "cFamCod" )
   ::oDbfFam:OrdSetFocus( "cNomFam" )

   REDEFINE GET ::oGetFamilia VAR ::cGetFamilia;
      ID       100 ;
      PICTURE  "@!" ;
      COLOR    CLR_GET ;
      OF       ::oFld:aDialogs[1]

      ::oGetFamilia:bChange   := { |nKey, nFlags| ::SeekFamilia( nKey, nFlags ) }
      ::oGetFamilia:bValid    := { || ::oDbfFam:OrdClearScope(), ::oBrwFamilia:Refresh(), .t. }

   REDEFINE COMBOBOX ::oCbxFamilia ;
      VAR      cCbxFamilia ;
      ID       110 ;
      ITEMS    ::aCbxFamilia ;
      OF       ::oFld:aDialogs[1]

      ::oCbxFamilia:bChange   := {|| ::oDbfFam:ordSetFocus( ::oCbxFamilia:nAt ), ::oBrwFamilia:Refresh(), ::oBrwArticulo:Refresh(), ::oGetFamilia:SetFocus() }

   REDEFINE GET ::oGetArticulo VAR ::cGetArticulo;
      ID       220 ;
      PICTURE  "@!" ;
      COLOR    CLR_GET ;
      OF       ::oFld:aDialogs[1]

      ::oGetArticulo:bValid   := { || ::oDbfArt:OrdClearScope(), ::oBrwArticulo:Refresh(), .t. }
      ::oGetArticulo:bKeyDown := { | nKey | if( nKey == VK_RETURN, ::AgregarArticulo(), ), ::oGetArticulo:lValid() }
      ::oGetArticulo:bChange  := { | nKey, nFlags | ::SeekArticulo( nKey, nFlags ) }

   REDEFINE COMBOBOX ::oCbxArticulo ;
      VAR      cCbxArticulo ;
      ID       230 ;
      ITEMS    ::aCbxArticulo ;
      OF       ::oFld:aDialogs[1]

      ::oCbxArticulo:bChange  := {|| ::oDbfArt:ordSetFocus( ::oCbxArticulo:nAt ), ::oBrwArticulo:Refresh(), ::oGetArticulo:SetFocus() }

   ::oBrwFamilia                    := IXBrowse():New( ::oFld:aDialogs[1] )

   ::oBrwFamilia:bClrSel            := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
   ::oBrwFamilia:bClrSelFocus       := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

   ::oDbfFam:SetBrowse( ::oBrwFamilia )

   ::oBrwFamilia:nMarqueeStyle      := 5

   ::oBrwFamilia:bChange            := {|| ::ChangeFamilias() }

   ::oBrwFamilia:lRecordSelector    := .f.

   ::oBrwFamilia:CreateFromResource( 120 )

   with object ( ::oBrwFamilia:AddCol() )
      :cHeader                      := "Código"
      :bEditValue                   := {|| ::oDbfFam:cCodFam }
      :nWidth                       := 75
   end with

   with object ( ::oBrwFamilia:AddCol() )
      :cHeader                      := "Familia"
      :bEditValue                   := {|| ::oDbfFam:cNomFam }
      :nWidth                       := 160
   end with

   ::oBrwArticulo                   := IXBrowse():New( ::oFld:aDialogs[1] )

   ::oBrwArticulo:bClrSel           := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
   ::oBrwArticulo:bClrSelFocus      := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

   ::oBrwArticulo:blDblClick        := { || ::AgregarArticulo() }

   ::oDbfArt:SetBrowse( ::oBrwArticulo )

   ::oBrwArticulo:lRecordSelector   := .f.

   ::oBrwArticulo:nMarqueeStyle     := 5

   ::oBrwArticulo:CreateFromResource( 130 )

   with object ( ::oBrwArticulo:AddCol() )
      :cHeader                      := "Referencia"
      :bEditValue                   := {|| ::oDbfArt:Codigo }
      :nWidth                       := 90
   end with

   with object ( ::oBrwArticulo:AddCol() )
      :cHeader                      := "Descripción"
      :bEditValue                   := {|| ::oDbfArt:Nombre }
      :nWidth                       := 290
   end with

   with object ( ::oBrwArticulo:AddCol() )
      :cHeader                      := "Precio 1 EUR"
      :bEditValue                   := {|| Trans( ::oDbfArt:pVenta1,  ::cPicImp ) }
      :nWidth                       := 90
      :nDataStrAlign                := 1
      :nHeadStrAlign                := 1
   end with

   with object ( ::oBrwArticulo:AddCol() )
      :cHeader                      := "Precio 1 " + cImp() + " EUR"
      :bEditValue                   := {|| Trans( ::oDbfArt:pVtaIva1, ::cPicImp ) }
      :nWidth                       := 90
      :nDataStrAlign                := 1
      :nHeadStrAlign                := 1
   end with

   with object ( ::oBrwArticulo:AddCol() )
      :cHeader                      := "Precio 2 EUR"
      :bEditValue                   := {|| Trans( ::oDbfArt:pVenta2,  ::cPicImp ) }
      :nWidth                       := 90
      :nDataStrAlign                := 1
      :nHeadStrAlign                := 1
   end with

   with object ( ::oBrwArticulo:AddCol() )
      :cHeader                      := "Precio 2 " + cImp() + " EUR"
      :bEditValue                   := {|| Trans( ::oDbfArt:pVtaIva2, ::cPicImp ) }
      :nWidth                       := 90
      :nDataStrAlign                := 1
      :nHeadStrAlign                := 1
   end with

   with object ( ::oBrwArticulo:AddCol() )
      :cHeader                      := "Precio 3 EUR"
      :bEditValue                   := {|| Trans( ::oDbfArt:pVenta3,  ::cPicImp ) }
      :nWidth                       := 90
      :nDataStrAlign                := 1
      :nHeadStrAlign                := 1
   end with

   with object ( ::oBrwArticulo:AddCol() )
      :cHeader                      := "Precio 3 " + cImp() + " EUR"
      :bEditValue                   := {|| Trans( ::oDbfArt:pVtaIva3, ::cPicImp ) }
      :nWidth                       := 90
      :nDataStrAlign                := 1
      :nHeadStrAlign                := 1
   end with

   with object ( ::oBrwArticulo:AddCol() )
      :cHeader                      := "Precio 4 EUR"
      :bEditValue                   := {|| Trans( ::oDbfArt:pVenta4,  ::cPicImp ) }
      :nWidth                       := 90
      :nDataStrAlign                := 1
      :nHeadStrAlign                := 1
   end with

   with object ( ::oBrwArticulo:AddCol() )
      :cHeader                      := "Precio 4 " + cImp() + " EUR"
      :bEditValue                   := {|| Trans( ::oDbfArt:pVtaIva4, ::cPicImp ) }
      :nWidth                       := 90
      :nDataStrAlign                := 1
      :nHeadStrAlign                := 1
   end with

   with object ( ::oBrwArticulo:AddCol() )
      :cHeader                      := "Precio 5 EUR"
      :bEditValue                   := {|| Trans( ::oDbfArt:pVenta5,  ::cPicImp ) }
      :nWidth                       := 90
      :nDataStrAlign                := 1
      :nHeadStrAlign                := 1
   end with

   with object ( ::oBrwArticulo:AddCol() )
      :cHeader                      := "Precio 5 " + cImp() + " EUR"
      :bEditValue                   := {|| Trans( ::oDbfArt:pVtaIva5, ::cPicImp ) }
      :nWidth                       := 90
      :nDataStrAlign                := 1
      :nHeadStrAlign                := 1
   end with

   with object ( ::oBrwArticulo:AddCol() )
      :cHeader                      := "Precio 6 EUR"
      :bEditValue                   := {|| Trans( ::oDbfArt:pVenta6,  ::cPicImp ) }
      :nWidth                       := 90
      :nDataStrAlign                := 1
      :nHeadStrAlign                := 1
   end with

   with object ( ::oBrwArticulo:AddCol() )
      :cHeader                      := "Precio 6 " + cImp() + " EUR"
      :bEditValue                   := {|| Trans( ::oDbfArt:pVtaIva6, ::cPicImp ) }
      :nWidth                       := 90
      :nDataStrAlign                := 1
      :nHeadStrAlign                := 1
   end with


   /*REDEFINE LISTBOX ::oBrwArticulo ;
      FIELDS ;
               ::oDbfArt:Codigo,;
               ::oDbfArt:Nombre,;
               Trans( ::oDbfArt:pVenta1,  ::cPicImp ),;
               Trans( ::oDbfArt:pVtaIva1, ::cPicImp ),;
               Trans( ::oDbfArt:pVenta2,  ::cPicImp ),;
               Trans( ::oDbfArt:pVtaIva2, ::cPicImp ),;
               Trans( ::oDbfArt:pVenta3,  ::cPicImp ),;
               Trans( ::oDbfArt:pVtaIva3, ::cPicImp ),;
               Trans( ::oDbfArt:pVenta4,  ::cPicImp ),;
               Trans( ::oDbfArt:pVtaIva4, ::cPicImp ),;
               Trans( ::oDbfArt:pVenta5,  ::cPicImp ),;
               Trans( ::oDbfArt:pVtaIva5, ::cPicImp ),;
               Trans( ::oDbfArt:pVenta6,  ::cPicImp ),;
               Trans( ::oDbfArt:pVtaIva6, ::cPicImp );
      HEAD;
               'Referencia',;
               'Descripción',;
               'Precio 1 EUR',;
               'Precio 1 " + cImp() + " EUR',;
               'Precio 2 EUR',;
               'Precio 2 " + cImp() + " EUR',;
               'Precio 3 EUR',;
               'Precio 3 " + cImp() + " EUR',;
               'Precio 4 EUR',;
               'Precio 4 " + cImp() + " EUR',;
               'Precio 5 EUR',;
               'Precio 5 " + cImp() + " EUR',;
               'Precio 6 EUR',;
               'Precio 6 " + cImp() + " EUR';
      FIELDSIZES ;
               120,;
               330,;
               90,;
               90,;
               90,;
               90,;
               90,;
               90,;
               90,;
               90,;
               90,;
               90,;
               90,;
               90;
      ID       130 ;
      OF       ::oFld:aDialogs[1]

      ::oDbfArt:SetBrowse( ::oBrwArticulo )

      ::oBrwArticulo:blDblClick   := { || ::AgregarArticulo() }
      ::oBrwArticulo:aJustify     := { .f., .f., .t., .t., .t., .t., .t., .t., .t., .t., .t., .t., .t., .t. }*/

   REDEFINE BUTTON ;
         ID       260 ;
         OF       ::oFld:aDialogs[1] ;
         ACTION   ( ::BorrarTodosArticulos() )

   REDEFINE BUTTON ;
         ID       240 ;
         OF       ::oFld:aDialogs[1] ;
         ACTION   ( ::SubirArticulo() )

   REDEFINE BUTTON ;
         ID       250 ;
         OF       ::oFld:aDialogs[1] ;
         ACTION   ( ::BajarArticulo() )

   REDEFINE BUTTON ;
         ID       140 ;
         OF       ::oFld:aDialogs[1] ;
         ACTION   ( ::AgregarArticulo() )

   REDEFINE BUTTON ;
         ID       150 ;
         OF       ::oFld:aDialogs[1] ;
         ACTION   ( ::AgregarTodos( ::oDbfFam:cCodFam ) )

   REDEFINE BUTTON ;
         ID       160 ;
         OF       ::oFld:aDialogs[1] ;
         ACTION   ( ::BorrarArticulo() )

   REDEFINE BUTTON ;
         ID       190 ;
         OF       ::oFld:aDialogs[1] ;
         ACTION   ( ::GuardarArchivo() )

   REDEFINE BUTTON ;
         ID       200 ;
         OF       ::oFld:aDialogs[1] ;
         ACTION   ( ::CargarArchivo() )

   REDEFINE BUTTON ;
         ID       210 ;
         OF       ::oFld:aDialogs[1] ;
         ACTION   ( ::ActualizaArticulo() )


   ::oBrwSeleccion                   := IXBrowse():New( ::oFld:aDialogs[1] )

   ::oBrwSeleccion:bClrSel           := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
   ::oBrwSeleccion:bClrSelFocus      := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

   ::oBrwSeleccion:lFastEdit         := .t.

   ::oDbf:SetBrowse( ::oBrwSeleccion )

   ::oBrwSeleccion:lRecordSelector   := .f.

   ::oBrwSeleccion:nMarqueeStyle     := 5

   ::oBrwSeleccion:CreateFromResource( 170 )

   with object ( ::oBrwSeleccion:AddCol() )
      :cHeader                      := "Num."
      :bEditValue                   := {|| Trans( ::oDbf:nNumArt, "999999" ) }
      :nWidth                       := 40
      :nDataStrAlign                := 1
      :nHeadStrAlign                := 1
   end with

   with object ( ::oBrwSeleccion:AddCol() )
      :cHeader                      := "Referencia"
      :bEditValue                   := {|| ::oDbf:cCodArt }
      :nWidth                       := 120
   end with

   with object ( ::oBrwSeleccion:AddCol() )
      :cHeader                      := "Familia"
      :bEditValue                   := {|| ::oDbf:cCodFam }
      :nWidth                       := 70
   end with

   with object ( ::oBrwSeleccion:AddCol() )
      :cHeader                      := "Descripción"
      :bEditValue                   := {|| ::oDbf:cNomArt }
      :nWidth                       := 330
      :nEditType                    := 1
      :bOnPostEdit                  := { | oCol, xVal | ::oDbf:cNomArt  := xVal  }
   end with

   with object ( ::oBrwSeleccion:AddCol() )
      :cHeader                      := "Costo"
      :bEditValue                   := {|| Trans( ::oDbf:pCosto, cPinDiv() ) }
      :nWidth                       := 90
      :nDataStrAlign                := 1
      :nHeadStrAlign                := 1
   end with

   with object ( ::oBrwSeleccion:AddCol() )
      :cHeader                      := "Precio 1 EUR"
      :bEditValue                   := {|| Trans( ::oDbf:pVenta1, ::cPicImp ) }
      :nWidth                       := 90
      :nDataStrAlign                := 1
      :nHeadStrAlign                := 1
   end with

   with object ( ::oBrwSeleccion:AddCol() )
      :cHeader                      := "Precio 1 " + cImp() + " EUR"
      :bEditValue                   := {|| Trans( ::oDbf:pVtaIva1, ::cPicImp ) }
      :nWidth                       := 90
      :nDataStrAlign                := 1
      :nHeadStrAlign                := 1
   end with

   with object ( ::oBrwSeleccion:AddCol() )
      :cHeader                      := "Precio 2 EUR"
      :bEditValue                   := {|| Trans( ::oDbf:pVenta2, ::cPicImp ) }
      :nWidth                       := 90
      :nDataStrAlign                := 1
      :nHeadStrAlign                := 1
   end with

   with object ( ::oBrwSeleccion:AddCol() )
      :cHeader                      := "Precio 2 " + cImp() + " EUR"
      :bEditValue                   := {|| Trans( ::oDbf:pVtaIva2, ::cPicImp ) }
      :nWidth                       := 90
      :nDataStrAlign                := 1
      :nHeadStrAlign                := 1
   end with

   with object ( ::oBrwSeleccion:AddCol() )
      :cHeader                      := "Precio 3 EUR"
      :bEditValue                   := {|| Trans( ::oDbf:pVenta3, ::cPicImp ) }
      :nWidth                       := 90
      :nDataStrAlign                := 1
      :nHeadStrAlign                := 1
   end with

   with object ( ::oBrwSeleccion:AddCol() )
      :cHeader                      := "Precio 3 " + cImp() + " EUR"
      :bEditValue                   := {|| Trans( ::oDbf:pVtaIva3, ::cPicImp ) }
      :nWidth                       := 90
      :nDataStrAlign                := 1
      :nHeadStrAlign                := 1
   end with

   with object ( ::oBrwSeleccion:AddCol() )
      :cHeader                      := "Precio 4 EUR"
      :bEditValue                   := {|| Trans( ::oDbf:pVenta4, ::cPicImp ) }
      :nWidth                       := 90
      :nDataStrAlign                := 1
      :nHeadStrAlign                := 1
   end with

   with object ( ::oBrwSeleccion:AddCol() )
      :cHeader                      := "Precio 4 " + cImp() + " EUR"
      :bEditValue                   := {|| Trans( ::oDbf:pVtaIva4, ::cPicImp ) }
      :nWidth                       := 90
      :nDataStrAlign                := 1
      :nHeadStrAlign                := 1
   end with

   with object ( ::oBrwSeleccion:AddCol() )
      :cHeader                      := "Precio 5 EUR"
      :bEditValue                   := {|| Trans( ::oDbf:pVenta5, ::cPicImp ) }
      :nWidth                       := 90
      :nDataStrAlign                := 1
      :nHeadStrAlign                := 1
   end with

   with object ( ::oBrwSeleccion:AddCol() )
      :cHeader                      := "Precio 5 " + cImp() + " EUR"
      :bEditValue                   := {|| Trans( ::oDbf:pVtaIva5, ::cPicImp ) }
      :nWidth                       := 90
      :nDataStrAlign                := 1
      :nHeadStrAlign                := 1
   end with

   with object ( ::oBrwSeleccion:AddCol() )
      :cHeader                      := "Precio 6 EUR"
      :bEditValue                   := {|| Trans( ::oDbf:pVenta6, ::cPicImp ) }
      :nWidth                       := 90
      :nDataStrAlign                := 1
      :nHeadStrAlign                := 1
   end with

   with object ( ::oBrwSeleccion:AddCol() )
      :cHeader                      := "Precio 6 " + cImp() + " EUR"
      :bEditValue                   := {|| Trans( ::oDbf:pVtaIva6, ::cPicImp ) }
      :nWidth                       := 90
      :nDataStrAlign                := 1
      :nHeadStrAlign                := 1
   end with






      /*REDEFINE LISTBOX ::oBrwSeleccion ;
         FIELDS ;
                  Trans( ::oDbf:nNumArt, "999999" ),;
                  ::oDbf:cCodArt,;
                  ::oDbf:cCodFam,;
                  ::oDbf:cNomArt,;
                  Trans( ::oDbf:pCosto,   cPinDiv() ),;
                  Trans( ::oDbf:pVenta1,  ::cPicImp ),;
                  Trans( ::oDbf:pVtaIva1, ::cPicImp ),;
                  Trans( ::oDbf:pVenta2,  ::cPicImp ),;
                  Trans( ::oDbf:pVtaIva2, ::cPicImp ),;
                  Trans( ::oDbf:pVenta3,  ::cPicImp ),;
                  Trans( ::oDbf:pVtaIva3, ::cPicImp ),;
                  Trans( ::oDbf:pVenta4,  ::cPicImp ),;
                  Trans( ::oDbf:pVtaIva4, ::cPicImp ),;
                  Trans( ::oDbf:pVenta5,  ::cPicImp ),;
                  Trans( ::oDbf:pVtaIva5, ::cPicImp ),;
                  Trans( ::oDbf:pVenta6,  ::cPicImp ),;
                  Trans( ::oDbf:pVtaIva6, ::cPicImp );
         HEAD;
                  'Num.',;
                  'Referencia',;
                  'Familia',;
                  'Descripción',;
                  'Costo',;
                  'Precio 1 EUR',;
                  'Precio 1 " + cImp() + " EUR',;
                  'Precio 2 EUR',;
                  'Precio 2 " + cImp() + " EUR',;
                  'Precio 3 EUR',;
                  'Precio 3 " + cImp() + " EUR',;
                  'Precio 4 EUR',;
                  'Precio 4 " + cImp() + " EUR',;
                  'Precio 5 EUR',;
                  'Precio 5 " + cImp() + " EUR',;
                  'Precio 6 EUR',;
                  'Precio 6 " + cImp() + " EUR';
         FIELDSIZES ;
                  40,;
                  120,;
                  70,;
                  330,;
                  80,;
                  90,;
                  90,;
                  90,;
                  90,;
                  90,;
                  90,;
                  90,;
                  90,;
                  90,;
                  90,;
                  90,;
                  90;
         ID       170 ;
         OF       ::oFld:aDialogs[1]

      ::oDbf:SetBrowse( ::oBrwSeleccion )

      ::oBrwSeleccion:blDblClick   := { || ::EditColumn() }
      ::oBrwSeleccion:aJustify     := { .t., .f., .f., .f., .t., .t., .t., .t., .t., .t., .t., .t., .t., .t., .t., .t., .t. }

      */

      ::CreateFilter( aItmArt(), ::oDbfArt:cAlias )

RETURN .t.

//---------------------------------------------------------------------------//

METHOD lGenerate()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//

METHOD AgregarArticulo()

   local lAppend  := .f.

   ::oBrwArticulo:Refresh()

   msgWait( "", "", 0.01 )

   ::oDbf:OrdSetFocus( "cCodFam" )

   lAppend        := !( ::oDbf:Seek( ::oDbfArt:Familia + ::oDbfArt:Codigo ) )

   ::EscribeArticulo( lAppend )

   ::oDbf:OrdSetFocus( "nNumArt" )

   ::oBrwSeleccion:Refresh()

   ::oGetArticulo:SetFocus()
   ::oGetArticulo:SelectAll()

RETURN nil
//---------------------------------------------------------------------------//

METHOD AgregarTodos( cCodFam )

   CursorWait()

   ::oDbf:OrdSetFocus( "cCodFam" )

   ::oDbfArt:GetStatus()

   ::oDbfArt:GoTop()
   while !::oDbfArt:Eof()

      if ::oDbfArt:Familia == cCodFam
         if !::oDbf:Seek( ::oDbfArt:Familia + ::oDbfArt:Codigo )
            ::EscribeArticulo( .t. )
         else
            ::EscribeArticulo( .f. )
         end if

      end if

      ::oDbfArt:Skip()

   end while

   ::oDbfArt:SetStatus()

   ::oDbf:OrdSetFocus( "nNumArt" )

   ::oBrwSeleccion:Refresh()

   CursorWE()

RETURN nil

//---------------------------------------------------------------------------//

METHOD BorrarArticulo()

   ::oDbf:Delete()
   ::oBrwSeleccion:Refresh()

RETURN nil

//---------------------------------------------------------------------------//

METHOD InsertarArticulo()

   ::oDbfArt:GetStatus()

   ::oDbf:OrdSetFocus( "cCodFam" )

   if ::oDbfArt:Seek( ::cCodigo )

      if !::oDbf:Seek( ::oDbfArt:Familia + ::oDbfArt:Codigo )
         ::EscribeArticulo( .t. )
         ::oBrwSeleccion:Refresh()
      else
         ::EscribeArticulo( .f. )
         ::oBrwSeleccion:Refresh()
      end if

      ::oBrwArticulo:Refresh()

   else

      msginfo( 'Código artículo no encontrado' )

   end if

   ::oDbf:OrdSetFocus( "nNumArt" )

   ::oDbfArt:SetStatus()

RETURN nil

//---------------------------------------------------------------------------//

METHOD EscribeArticulo( lAppend )

   if lAppend
      ::oDbf:Append()
   else
      ::oDbf:Load()
   end if

   ::oDbf:cCodArt    := ::oDbfArt:Codigo
   ::oDbf:cNomArt    := ::oDbfArt:Nombre
   ::oDbf:cCodFam    := ::oDbfArt:Familia
   ::oDbf:cNomFam    := cNomFam( ::oDbfArt:Familia, ::oDbfFam )
   ::oDbf:pVenta1    := ::oDbfArt:pVenta1
   ::oDbf:pVtaIva1   := ::oDbfArt:pVtaIva1
   ::oDbf:pVenta2    := ::oDbfArt:pVenta2
   ::oDbf:pVtaIva2   := ::oDbfArt:pVtaIva2
   ::oDbf:pVenta3    := ::oDbfArt:pVenta3
   ::oDbf:pVtaIva3   := ::oDbfArt:pVtaIva3
   ::oDbf:pVenta4    := ::oDbfArt:pVenta4
   ::oDbf:pVtaIva4   := ::oDbfArt:pVtaIva4
   ::oDbf:pVenta5    := ::oDbfArt:pVenta5
   ::oDbf:pVtaIva5   := ::oDbfArt:pVtaIva5
   ::oDbf:pVenta6    := ::oDbfArt:pVenta6
   ::oDbf:pVtaIva6   := ::oDbfArt:pVtaIva6
   ::oDbf:pCosto     := nCosto( nil, ::oDbfArt:cAlias, ::oDbfKit:cAlias, .f., nil, ::oDbfDiv )

   if lAppend
      ::oDbf:nNumArt := ::oDbf:LastRec()
   end if

   ::oDbf:Save()

RETURN nil

//---------------------------------------------------------------------------//

Method GuardarArchivo()

   local cArchivoOrigen   := ::cFileName
   local cArchivoDestino  := cGetFile( "Informe ( *.Dat ) | " + "*.Dat", "Seleccione el nombre del fichero a guardar", , , .t. )

   if !Empty( cArchivoDestino )
      cArchivoDestino     := cNoExt( cArchivoDestino ) + ".Dat"
   else
      Return nil
   end if

   if !Empty( ::oDbf ) .and. ::oDbf:Used()

     CursorWait()

     ::oBrwSeleccion:Hide()

     ::oDbf:Close()
      __CopyFile( cArchivoOrigen, cArchivoDestino )
     ::oDbf:ReActivate()

     ::oBrwSeleccion:Show()

     msgInfo( cArchivoDestino + ' exportado con exito.' )

     CursorWE()

   end if

Return Nil

//---------------------------------------------------------------------------//

Method CargarArchivo()

   local cArchivoDestino  := cGetFile( 'Informe ( *.Dat ) | ' + '*.Dat', 'Seleccione el nombre del fichero a cargar' )

   if !Empty( cArchivoDestino ) .and. File( cArchivoDestino )

      CursorWait()

      ::oBrwSeleccion:Hide()

      ::oDbf:Zap()
      ::oDbf:AppendFrom( cArchivoDestino )
      ::oDbf:ReindexAll()
      ::oDbf:GoTop()

      ::oBrwSeleccion:Show()

      CursorWE()

      msgInfo( 'Archivo ' + cArchivoDestino + ' cargado satisfactoriamente' )

   end if

   ::oBrwSeleccion:Refresh()

Return Nil
//---------------------------------------------------------------------------//

METHOD ActualizaArticulo()

   ::oDbfArt:GetStatus( .t. )

   ::oDbf:GoTop()
   while !::oDbf:Eof()
      if ::oDbfArt:Seek( ::oDbf:cCodArt )
         ::EscribeArticulo( .f. )
      end if
      ::oDbf:Skip()
   end while
   ::oDbf:GoTop()

   ::oDbfArt:SetStatus()

   ::oBrwSeleccion:Refresh()
   ::oBrwArticulo:Refresh()

   msginfo( 'Registros actualizados satisfactoriamente' )

Return nil

//---------------------------------------------------------------------------//

Method ChangeFamilias()

   ::oDbfArt:OrdSetFocus( "cFamCod" )
   ::oDbfArt:OrdScope( ::oDbfFam:cCodFam )
   ::oDbfArt:GoTop()

   ::oCbxArticulo:Set( 'Família + Código' )

   ::oBrwArticulo:Refresh()

Return Self

//---------------------------------------------------------------------------//

Method SeekFamilia( nKey, nFlags )

   local lAutoseek   := AutoSeek( nKey, nFlags, ::oGetFamilia, ::oBrwFamilia, ::oDbfFam:cAlias, .t. )

   if lAutoSeek
      ::ChangeFamilias()
   end if

Return ( lAutoSeek )

//---------------------------------------------------------------------------//

Method SeekArticulo( nKey, nFlags )

   if ::oDbfArt:OrdSetFocus() $ "CFAMCOD CFAMNOM"
      ::oDbfArt:OrdSetFocus( "Codigo" )
      ::oCbxArticulo:Set( 'Código' )
   end if

Return ( AutoSeek( nKey, nFlags, ::oGetArticulo, ::oBrwArticulo, ::oDbfArt:cAlias, .t. ) )

//---------------------------------------------------------------------------//

Method EditColumn()

   local uVar           := ::oDbf:cNomArt
   local bValid         := { || .t. }

   if ::oBrwSeleccion:lEditCol( 4, @uVar, nil, bValid )

      if !Empty( uVar )

         ::oDbf:Load()
         ::oDbf:cNomArt := uVar
         ::oDbf:Save()

      end if

      ::oBrwSeleccion:DrawSelect()

   end if

Return Self

//---------------------------------------------------------------------------//

METHOD SubirArticulo()

   local nRecNuevo
   local nNumNuevo
   local nRecActual
   local nNumActual

   if ::oDbf:Bof()
      Return Self
   end if

   ::oDbf:GetStatus()

   nNumActual        := ::oDbf:nNumArt
   nRecActual        := ::oDbf:Recno()

   ::oDbf:Skip( -1 )

   nNumNuevo         := ::oDbf:nNumArt
   nRecNuevo         := ::oDbf:Recno()

   if Empty( nNumNuevo )
      Return Self
   end if

   ::oDbf:GoTo( nRecActual )

   ::oDbf:Load()
   ::oDbf:nNumArt    := nNumNuevo
   ::oDbf:Save()

   ::oDbf:GoTo( nRecNuevo )

   ::oDbf:Load()
   ::oDbf:nNumArt    := nNumActual
   ::oDbf:Save()

   ::oDbf:SetStatus()

   ::oBrwSeleccion:Refresh()

Return Self

//---------------------------------------------------------------------------//

METHOD BajarArticulo()

   local nRecNuevo
   local nNumNuevo
   local nRecActual
   local nNumActual

   if ::oDbf:Eof()
      Return Self
   end if

   ::oDbf:GetStatus()

   nNumActual        := ::oDbf:nNumArt
   nRecActual        := ::oDbf:Recno()

   ::oDbf:Skip( 1 )

   nNumNuevo         := ::oDbf:nNumArt
   nRecNuevo         := ::oDbf:Recno()

   if Empty( nNumNuevo )
      Return Self
   end if

   ::oDbf:GoTo( nRecActual )

   ::oDbf:Load()
   ::oDbf:nNumArt    := nNumNuevo
   ::oDbf:Save()

   ::oDbf:GoTo( nRecNuevo )

   ::oDbf:Load()
   ::oDbf:nNumArt    := nNumActual
   ::oDbf:Save()

   ::oDbf:SetStatus()

   ::oBrwSeleccion:Refresh()

Return Self

//---------------------------------------------------------------------------//