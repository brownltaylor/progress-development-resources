DEFINE QUERY q1 FOR customer SCROLLING.
DEFINE VARIABLE credit-left AS DECIMAL LABEL "Credit Left".
DEFINE BROWSE b1 QUERY q1 DISPLAY customer.NAME creditlimit balance
    (creditlimit - balance) @ credit-left
    WITH 10 DOWN SEPARATORS NO-ASSIGN TITLE "Update Customer Information".
DEFINE VARIABLE method-return AS LOGICAL.
DEFINE VARIABLE lblflag AS LOGICAL.
DEFINE VARIABLE wh AS WIDGET-HANDLE. 
DEFINE BUTTON btn_1 LABEL "Search by Name".
DEFINE BUTTON btn_2 LABEL "Search".
DEFINE BUTTON btn_3 LABEL "Update".
DEFINE BUTTON btn_4 LABEL "Return to Directory".

DEFINE FRAME dir-frame 
    b1
    SKIP(0.5) btn_1 TO 40 SPACE
WITH SIDE-LABELS.
DEFINE FRAME edit-frame.
DEFINE FRAME cust-dtl.
    

ON CHOOSE OF btn_1
DO:
PROMPT-FOR customer.NAME.
FIND customer USING customer.NAME.
 DISPLAY customer.NAME creditlimit balance 
 SKIP(0.5) btn_4 TO 40 SPACE WITH FRAME cust-dtl.
 ENABLE btn_4 WITH FRAME cust-dtl.

ON CHOOSE OF btn_4
DO:
    OPEN QUERY q1 FOR EACH customer.
END.
END.




ON END-SEARCH OF b1 IN FRAME dir-frame  
DO:
    IF lblflag THEN
        wh:LABEL = "Name".
    lblflag = FALSE.
END.
    
ON START-SEARCH OF b1 IN FRAME dir-frame 
DO:
    wh = b1:CURRENT-COLUMN.
    IF wh:LABEL = "Name" THEN DO:
    lblflag = TRUE.
    wh:LABEL = "Searching...".
    MESSAGE "Incremental Search?" VIEW-AS ALERT-BOX QUESTION
    BUTTONS YES-NO-CANCEL TITLE "Search Mode"
    UPDATE answ AS LOGICAL.
    CASE answ:
    WHEN TRUE THEN DO:
        method-return = b1:SET-REPOSITIONED-ROW(3, "CONDITIONAL").
        RUN inc-src.
        RETURN.    
    END.
    WHEN FALSE THEN DO:
        MESSAGE "Search mode defaults to first character"
        VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
        RETURN NO-APPLY.
        END.
    OTHERWISE APPLY "END-SEARCH" TO SELF.
   END CASE.     
 END.     
 END.
 
OPEN QUERY q1 FOR EACH customer NO-LOCK BY customer.NAME.
ENABLE ALL WITH FRAME dir-frame.
WAIT-FOR WINDOW-CLOSE OF CURRENT-WINDOW.

PROCEDURE inc-src: 
DEFINE VARIABLE curr-record AS RECID.
DEFINE VARIABLE initial-str AS CHARACTER.
APPLY "START-SEARCH" TO BROWSE b1.
ON ANY-PRINTABLE OF b1 IN FRAME dir-frame 
DO:
    ASSIGN curr-record = RECID(customer)
        initial-str = initial-str + LAST-EVENT:LABEL.
    
    match-string: 
    DO ON ERROR UNDO match-string, LEAVE match-string:
    IF RETRY THEN 
        initial-str = LAST-EVENT:LABEL.
    
    FIND NEXT customer WHERE customer.NAME BEGINS initial-str 
        USE-INDEX NAME NO-LOCK NO-ERROR.
        IF AVAILABLE customer THEN
        curr-record = RECID(customer).
    ELSE IF RETRY THEN DO:
    initial-str = "".
    BELL.
    END.
    ELSE
        UNDO match-string, RETRY match-string.
 END.
 REPOSITION q1 TO RECID curr-record.
 END. 
 
 
 WAIT-FOR "END-SEARCH" OF BROWSE b1.
 END PROCEDURE.
        
   
