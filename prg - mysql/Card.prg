     FUNCTION Test()
        LOCAL cCard:=Space(20)
        LOCAL nResult
        LOCAL acCardTypes:={"American Express", "Visa", "MasterCard", ;
                            "Discover", "Carte Blanche", "Diners", "JCB"}
        CLEAR
        @ 5, 5 SAY "Enter card number :" GET cCard PICTURE "@9"
        READ

        IF ( !Empty(cCard) )
           cCard:=Alltrim(cCard)
           nResult:=CCCheck(cCard)
           @ 6, 5 SAY "Card #" + cCard
           DO CASE
              CASE ( nResult < 0 )
                 @ Row(), Col() SAY " is invalid."
              CASE ( nResult == 0 )
                 @ Row(), Col() SAY " is of unknown type."
              CASE ( nResult > 0 )
                 @ Row(), Col() SAY " is a " + acCArdTypes[nResult]
           ENDCASE
        ENDIF
     RETURN ( NIL )











