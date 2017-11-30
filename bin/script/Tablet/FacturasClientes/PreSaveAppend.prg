 #include "hbclass.ch"

#define CRLF chr( 13 ) + chr( 10 )

//---------------------------------------------------------------------------//

Function Inicio( oThis )

   PreSaveAppend():New( oThis ):run()

Return ( nil )

//---------------------------------------------------------------------------//

CLASS PreSaveAppend

   DATA oThis

   DATA aArticulosEspeciales        INIT {}

   DATA aLines                      INIT {}

   DATA cSerieToChange

   METHOD New()
   
   METHOD run()

   METHOD loadArticulosEspeciales()

   METHOD loadLines()

   METHOD changeSerie( Clave, Valor )

   METHOD changeHeader( Valor )

ENDCLASS

//---------------------------------------------------------------------------//

METHOD New( oThis ) CLASS PreSaveAppend

   ::oThis           := oThis
   ::loadArticulosEspeciales()
   ::loadLines()
   ::cSerieToChange  := "C"

Return ( Self )

//---------------------------------------------------------------------------//

METHOD run()

   aEval( ::aArticulosEspeciales, {| h | hEval( h, {| k, v | ::changeSerie( k, v ) } ) } )

Return ( Self )

//---------------------------------------------------------------------------//

METHOD loadLines() CLASS PreSaveAppend

   local hLine
   
   for each hLine in ::oThis:oDocumentLines:aLines
      aAdd( ::aLines, hLine:hDictionary )
   next

Return ( Self )

//---------------------------------------------------------------------------//

METHOD loadArticulosEspeciales() CLASS PreSaveAppend

   ::aArticulosEspeciales     := {}

   aAdd( ::aArticulosEspeciales, { "1" => "Especial 1" } )
   aAdd( ::aArticulosEspeciales, { "2" => "Especial 2" } )
   aAdd( ::aArticulosEspeciales, { "3" => "Especial 3" } )

Return ( Self )

//---------------------------------------------------------------------------//

METHOD changeSerie( Clave, cComentario ) CLASS PreSaveAppend

   aEval( ::aLines, {| h | if( AllTrim( hGet( h, "Articulo" ) ) == Clave, ::changeHeader( cComentario ), ) } )

Return ( Self )

//---------------------------------------------------------------------------//

METHOD changeHeader( cComentario )

   local cComent  := ""

   hSet( ::oThis:hDictionaryMaster, "Serie", ::cSerieToChange )

   cComent        := hGet( ::oThis:hDictionaryMaster, "Comentarios" )

   hSet( ::oThis:hDictionaryMaster, "Comentarios", cComent + cComentario )

Return ( Self )

//---------------------------------------------------------------------------//