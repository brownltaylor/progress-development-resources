DEFINE VARIABLE credit-left AS DECIMAL LABEL "Credit-Left". //defining new table column
DEFINE QUERY q1 FOR customer SCROLLING. // queries for customer data , able to scroll through entries
DEFINE BROWSE b1 QUERY q1 DISPLAY NAME creditlimit balance  // browse window that displays q1 data 
(creditlimit - balance) @ credit-left        // defines data in "Credit-Left" column
ENABLE creditlimit WITH 10 DOWN SEPARATORS    // will show 10 entries on one page 
TITLE "Update Credit Limits".     //names the browse widget

DEFINE BUTTON b-ok LABEL "OK" SIZE 20 BY 1.  // defines button and button size

DEFINE FRAME f1   // defines frame f1 -- (there is a browse widget and a comment box in this frame)
    b1 SKIP(0.5)     // skip indicates the pixel space between the elements of the frame
    customer.comments VIEW-AS EDITOR INNER-LINES 3   // this shows comments in box fashioned like an editing box
    INNER-CHARS 62  // determines max number of characters allowed for a comment
    WITH SIDE-LABELS ROW 2 CENTERED NO-BOX.

DEFINE FRAME f2
    customer.comments NO-LABEL VIEW-AS EDITOR INNER-LINES 3 // defines a separate box to view comments-- will pop up over frame f1
        INNER-CHARS 62 SKIP (0.5)    
        b-ok TO 42 SKIP(0.5)    // adds "OK" button to frame
        WITH SIDE-LABELS ROW 2 CENTERED
        VIEW-AS DIALOG-BOX TITLE "Comments".  // frame will be shown as a pop-up box with the title "Comments"

ON VALUE-CHANGED OF b1   // when a new customer is selected...
DO:
    DISPLAY customer.comments WITH FRAME f1. // display the comments for that customer in frame f1
END.
ON DEFAULT-ACTION OF b1 // when a customer is clicked in the browse widget
DO:
    ASSIGN customer.comments:READ-ONLY IN FRAME f1 = TRUE. // display the comments in frame f1, but will be uneditable (READ-ONLY)
    DISPLAY customer.comments WITH FRAME f2. // the pop-up box appears to edit
    ENABLE customer.comments b-ok WITH FRAME f2.  // ENABLE makes the variable in frame f2 editable 
    WAIT-FOR CHOOSE OF b-ok. // will close out when "OK" button is clicked
    HIDE FRAME f2. // makes frame f2 not visible 
END.

ASSIGN customer.comments:READ-ONLY IN FRAME f1 = TRUE. 
OPEN QUERY q1 FOR EACH customer. // will return to original state
ENABLE ALL WITH FRAME f1.
WAIT-FOR WINDOW-CLOSE OF CURRENT-WINDOW.

/* Note: This example does NOT update the customer's comments. This is merely meant to show how 
to use pop-ups to focus in on specific data values. Please see UpdatingNo-LockBrowseWidgetsSample.p */
