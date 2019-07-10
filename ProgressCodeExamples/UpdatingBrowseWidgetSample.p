DEFINE QUERY q1 FOR customer SCROLLING.   // queries for customer data, allows scrolling
DEFINE BROWSE b1 QUERY q1 DISPLAY NAME creditlimit 
    ENABLE creditlimit WITH 10 DOWN SEPARATORS NO-ASSIGN   // browse widgets are NO-LOCK by default (which makes them uneditable) even with an ENABLE keyword, NO-ASSIGN overrides this 
    TITLE "Update Credit Limits".                    // defines browse widget and makes credit limit editable
    
DEFINE FRAME f1
    b1
        WITH SIDE-LABELS ROW 2 CENTERED NO-BOX.   // frame f1 shows the browse widget
        
ON ROW-LEAVE OF BROWSE b1 DO:   // ROW-LEAVE defines an event that is triggered when a user clicks on a different row 
    IF INTEGER(customer.creditlimit:SCREEN-VALUE IN BROWSE b1) > 100000   // if the edited value in credit limit column is over 100,000
    THEN DO:
        MESSAGE "Credit limits over $100,000 need a manager's approval."
        VIEW-AS ALERT-BOX ERROR BUTTONS OK    // sends a pop-up error box with an "OK" button to close
        TITLE "Invalid Credit Limit".
       DISPLAY creditlimit WITH BROWSE b1. // will display original state after exit of popup error
       RETURN NO-APPLY.  // enables editing  
    END.
    
    DO TRANSACTION:    // TRANSACTION: executes entirely or not at all
        GET CURRENT q1 EXCLUSIVE-LOCK NO-WAIT.  // GET CURRENT retrieves the data value of the change if it is valid-- EXCLUSIVE-LOCK NO-WAIT is used when a user has changed row data, initiates the retrieval of the updated record. (If NO changes were made, the transaction does not execute)
        IF CURRENT-CHANGED(customer) THEN DO:  // CURRENT-CHANGED: checks to make sure another user did not change the customer's record while the query was retrieving the info
            MESSAGE "The record changed while you were working."
                VIEW-AS ALERT-BOX ERROR BUTTONS OK TITLE "New Data".  // popup bocks for successful update 
            DISPLAY creditlimit WITH BROWSE b1. //returns to original state
            RETURN NO-APPLY. // enables editing
        END.
        ELSE ASSIGN INPUT BROWSE b1 creditlimit.  // assigns new credit limit value to record
    END.
    GET CURRENT q1 NO-LOCK. // returns data object to an uneditable state until selected again
END.
OPEN QUERY q1 FOR EACH customer NO-LOCK. // returns table to uneditable state until record is selected
ENABLE ALL WITH FRAME f1.   // enables all user interface objects in frame
WAIT-FOR WINDOW-CLOSE OF CURRENT-WINDOW. // process terminates when window is exited
