#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS TGruFam FROM TInfGen

   DATA  oDbfFam  AS OBJECT

   METHOD create()

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHOD lResource( cFld )

   METHOD lGenerate()

END CLASS

//---------------------------------------------------------------------------//

METHOD Create()

   ::AddField( "cGrpFam", "C",  3, 0, {|| "@!" },        "Grp. grupo",    .f., "Cod. grupo"        ,  5, .f. )
   ::AddField( "cNomGrp", "C", 20, 0, {|| "@!" },        "Nom. grupo",    .f., "Nom. grupo"        , 20, .f. )
   ::AddField( "cCodFam", "C", 16, 0, {|| "@!" },        "Familia",       .t., "Familia"           , 15, .f. )
   ::AddField( "cNomFam", "C", 40, 0, {|| "@!" },        "Nom. fam.",     .t., "Nombre familia"    , 50, .f. )

   ::AddTmpIndex( "CGRPFAM", "CGRPFAM + CCODFAM" )

   ::AddGroup( {|| ::oDbf:cGrpFam }, {|| "Grupo de familia  : " + Rtrim( ::oDbf:cGrpFam ) + "-" + Rtrim( ::oDbf:cNomGrp ) }, {||"Total grupo de familia..."} )

   ::lDefSerInf := .f.
   ::lDefFecInf := .f.
   ::lDefDivInf := .f.

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD OpenFiles()

   local lOpen    := .t.
   local oBlock   := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

   DATABASE NEW ::oDbfFam PATH ( cPatEmp() ) FILE "FAMILIAS.DBF" VIA ( cDriver() ) SHARED INDEX "FAMILIAS.CDX"

   RECOVER

      msgStop( 'Imposible abrir todas las bases de datos' )
      ::CloseFiles()
      lOpen          := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD CloseFiles()

   if !Empty( ::oDbfFam ) .and. ::oDbfFam:Used()
      ::oDbfFam:End()
   end if

   ::oDbfFam := nil

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD lResource ( cFld )

   if !::StdResource( "INF_GRU_FAM" )
      return .f.
   end if

   if !::oDefGrfInf( 70, 80, 90, 100, 150 )
      return .f.
   end if

   ::oMtrInf:SetTotal( ::oDbfFam:Lastrec() )

   ::CreateFilter( aItmFam(), ::oDbfFam:cAlias )

RETURN .t.

//---------------------------------------------------------------------------//
/*
Esta funcion crea la base de datos para generar posteriormente el informe
*/

METHOD lGenerate()

   local cExpFam  := ""

   ::oDlg:Disable()
   ::oBtnCancel:Enable()
   ::oDbf:Zap()

   ::aHeader      := {  {|| "Fecha         : " + Dtoc( Date() ) },;
                        {|| "Grp. familias : " + if( ::lAllGrp, "Todos", AllTrim( ::cGruFamOrg ) + " > " + AllTrim( ::cGruFamDes ) ) } }

   ::oDbfFam:OrdSetFocus( "cCodFam" )

   if !::lAllGrp
      cExpFam      += 'cCodGrp >= "' + Rtrim( ::cGruFamOrg ) + '" .and. cCodGrp <= "' + Rtrim( ::cGruFamDes ) + '"'
   else
      cExpFam      += '.t.'
   end if


   if !Empty( ::oFilter:cExpresionFilter )
      cExpFam      += ' .and. ' + ::oFilter:cExpresionFilter
   end if

   ::oDbfFam:AddTmpIndex( Auth():Codigo(), GetFileNoExt( ::oDbfFam:cFile ), ::oDbfFam:OrdKey(), ( cExpFam ), , , , , , , , .t. )

   ::oMtrInf:SetTotal( ::oDbfFam:OrdKeyCount() )

   /*
   Nos movemos por la base de datos de familias
	*/

   ::oDbfFam:GoTop()

   while !::lBreak .and. !::oDbfFam:Eof()

      ::oDbf:Append()

      ::oDbf:cGrpFam  := ::oDbfFam:cCodGrp
      ::oDbf:cNomGrp  := oRetFld( ::oDbfFam:cCodGrp, ::oGruFam:oDbf )
      ::oDbf:cCodFam  := ::oDbfFam:cCodFam
      ::oDbf:cNomFam  := ::oDbfFam:cNomFam

      ::oDbf:Save()

      ::oDbfFam:Skip()

      ::oMtrInf:AutoInc( ::oDbfFam:OrdKeyNo() )

   end while

   ::oDbfFam:IdxDelete( Auth():Codigo(), GetFileNoExt( ::oDbfFam:cFile ) )

   ::oMtrInf:AutoInc( ::oDbfFam:Lastrec() )

   ::oDlg:Enable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//