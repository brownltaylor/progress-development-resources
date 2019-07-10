DEFINE QUERY q1 FOR customer SCROLLING.   // scrolling window to show customer data
DEFINE VARIABLE credit-left AS DECIMAL LABEL "Credit Left". 
DEFINE BROWSE b1 QUERY q1 DISPLAY NAME creditlimit balance  // browse defines what data the query will show
(creditlimit - balance) @ credit-left ENABLE creditlimit    // enable credit limit-- makes this column changeable , @ credit-left defines a new column that displays credit-left data(creditlimit minus balance)
WITH 10 DOWN SEPARATORS TITLE "Update Credit Limits". // will show 10 instances at a time
DEFINE VARIABLE method-return AS LOGICAL.  // LOGICAL will be concretely defined later
DEFINE VARIABLE wh AS WIDGET-HANDLE.   // defines what part of the widgit we are dealing with
DEFINE VARIABLE lblflag AS LOGICAL.  //using later
DEFINE FRAME f1  // defines a new frame
    b1           // that will show the browse widgit b1
    WITH SIDE-LABELS CENTERED. // Centers the frame
ON END-SEARCH OF b1 IN FRAME f1  // when you are finished searching or not searching
   DO:
 

IF lblflag THEN
    wh:LABEL = "Name".  //defines lblflag as being the title of column 2
lblflag = FALSE.       //  the flag is set to false by default (defines lblflag as boolean)
END.

ON START-SEARCH OF b1 IN FRAME f1  // how to initialize search
DO:
    wh = b1:CURRENT-COLUMN. 
    IF wh:LABEL = "name" THEN   // when the selected column is name
    DO:
     lblflag = TRUE.     // set lblflag to true
     wh:LABEL = "Searching...".    // widgit handle label is changed
     MESSAGE "Incremental Search?" VIEW-AS ALERT-BOX QUESTION    // will throw popup screen that will ask user if they want to start search
     BUTTONS YES-NO-CANCEL TITLE "Search Mode"   // defines the buttons on the alert-box question
     UPDATE answ AS LOGICAL.   // defines the users choice 
     CASE answ:      // start of switch statement
     WHEN TRUE THEN     // when yes is selected 
     DO:
     method-return = b1:SET-REPOSITIONED-ROW(3, "CONDITIONAL").  // defines logical method-return, moves cursor to row 3 (credit-limit)
     RUN inc-src.   //runs procedure inc-src defined below
     RETURN. // after completion will return to original state
     END.
     WHEN FALSE THEN DO: 
     MESSAGE "Search mode defaults to the first character."   //throws a popup
     VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.  // states that OK button will be on alert
     RETURN NO-APPLY.   //return to original state and doesn't make changes 
     END.
     OTHERWISE   // another word for "ELSE"
         APPLY "END-SEARCH" TO SELF. // will auto end the search after another action
     END CASE.   //end of switch statement
    END.
END.

OPEN QUERY q1 FOR EACH customer NO-LOCK BY customer.NAME. // will allow the query to display all customers in database, NO-LOCK makes scrolling constant and query will search by name
ENABLE ALL WITH FRAME f1.  //put all in frame f1
WAIT-FOR WINDOW-CLOSE OF CURRENT-WINDOW. // will terminate when window is closed 

PROCEDURE inc-src:      // this procedure is run when "yes" is selected for incremental search pop-up 
DEFINE VARIABLE curr-record AS RECID. //   this defines a variable as a RECID, which is what the user has selected
DEFINE VARIABLE initial-str AS CHARACTER.  // defines as a character but is not initialized
APPLY "START-SEARCH" TO BROWSE b1. //
ON ANY-PRINTABLE OF b1 IN FRAME f1 // any character entered in search mode
DO: 
ASSIGN curr-record = RECID(customer)  // cursor will move to customers that match the search input from user
initial-str = initial-str + LAST-EVENT:LABEL. // as you type the program will concatenate the characters
match-string: 
DO ON ERROR UNDO match-string, LEAVE match-string: // when search can not continue concatenation, it will leave and start fresh search
IF RETRY THEN initial-str = LAST-EVENT:LABEL.  // search will start new search with first unknown character
FIND NEXT customer WHERE customer.NAME BEGINS initial-str  // will find customer name that matches the intital-str 
USE-INDEX NAME NO-LOCK NO-ERROR. // will take user to customer will matching characters, query will continue to allow scroll
IF AVAILABLE customer THEN  // if a customer is there
curr-record = RECID(customer).  // cursor will begin on currently selected customer
ELSE IF RETRY THEN DO:
initial-str = "".  // will blank out the inital string and start fresh search
BELL.  // click out event???
END.
ELSE 
UNDO match-string, RETRY match-string.
END.
REPOSITION q1 TO RECID curr-record. // will move cursor to customer and allow for editing
END.
ON VALUE-CHANGED OF b1 IN FRAME f1  // if value is changed
DO: 
initial-str = "".   // erased previously searched characters
END.
WAIT-FOR "END-SEARCH" OF BROWSE b1.  // will wait for user to end the search 
APPLY "ENTRY" TO customer.NAME IN BROWSE B1.  // will apply changes to changed value 
END PROCEDURE. 
