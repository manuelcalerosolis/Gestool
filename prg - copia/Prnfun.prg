#include "FiveWin.Ch"

function PrnGetCopies()
return 1

function PrnBinSource()
return 1

function PrnGetPage()
return { 1, 1 }

function ImportRawF()
return nil

function LargeFonts()
return TFont():New( "Arial", 8, 26, .F., .T. )