
*This repository includes a link to download Progress Classroom Kit Edition easily. As I gain more knowledge in programming with Progress 4GL, I will be uploading application examples and tutorials, as I have found that there is a dearth of information on this legacy language.*

---------------------------------------------------------------------------------------------------------------------------------------
**Getting Started with Progress Classroom Kit**

*For screenshots, please utilize "Getting Started with Progress with Windows Download" PDF*

Download Progress for Windows 
1.	Click this link and download the zip file: 

**https://drive.google.com/file/d/15oUffIHhes3_NIZZGmQkooyMPNg0rbZk/view?usp=sharing**

2.	Right click inside the folder and select "Extract All..."
3.	In the extracted folder, double-click the setup.exe file *(If you cannot see the file extensions, click "View" on the toolbar and click the checkbox "File name extensions" 
4.	Follow the prompts in the setup wizard. You do not need to make any changes. 
5.	Once the program is downloaded, in your computer's search bar, type "OpenEdge Explorer". 
6.	Right-click on the file and select "Open file location" 
7.	To start writing code, use the GUI Procedure Editor. 
8.	*Tip: I would pin the Developer Console and the Procedure Editor to your taskbar, along with the Proenv.

-------------------------------------------------------------------------------------------------------------------------------------

**Copying sports2000 Database** 

1. Navigate to the file location for OpenEdge Explorer and select "Proenv".
2. Type in the commands as follows:
```
    cd \
    cd mkdir db
    mkdir sports2000
    cd sports2000 
    prodb mySportsDb sports2000 (Syntax: prodb name-of-new-database name-and-path-of-source-database)
   ```
-------------------------------------------------------------------------------------------------------------------------------------

**Running and Terminating sports2000 Database Copy**

1. Navigate to the folder containing the copy you created and cd into it 
2. Type the command as follows: 
```
	      proserve mySportsDb
  ```
3. To terminate the server:
```
	proshut mySportsDb
	Select Option 2 - Unconditional Shutdown
```
 
---------------------------------------------------------------------------------------------------------------------------------------

**Using the Procedure Editor with sports2000 Database Copy**

1. Ensure that there are no servers running for MySportsDb.db in Proenv. (See: Running and Terminating sports2000 Database Copy).
2. Open the "GUI Procedure Editor" from the "OpenEdge Explorer" file path. 
 
3.Hover over "Tools" from the toolbar and select "Data Dictionary".
4. Select the "Connect to an Existing Database" radio button and click "OK".
5. In the "Physical Name" field, use "Browse..." to find the copy of the sports2000 database. For "Logical Name", type in MySportsDb.db and click "OK".
 
6. Exit the "Data Dictionary" window. Do not make any changes to the table. 

---------------------------------------------------------------------------------------------------------------------------------------

**Connecting the Developer Console to sports2000 Database Copy**

*Note: In order to use this database in the Procedure Editor, the server must not be running.*


1. Navigate to folder containing copy you created and cd into it 
2. Run a server for your database *(See: Running and Terminating sports2000 Database Copy)*
3. Open Developer Console 
4. Hover over "Window" on toolbar and select "Preferences" 
5. On the left hand navigation bar, open "Progress OpenEdge" dropdown
6. Select "Database Connections" 
7. Click "New..."
8. In the "Connection Name" field, enter a unique name for your database. Typically, you would make this the same as the true name.
9. In the "Physical Name" field, click "Browse..." and navigate to your C:\ drive, select the "db" file you created, and select mySportsDb.db.
10. Click "Test Connection" to ensure that your server is running properly. 
11. Click "Finish".
