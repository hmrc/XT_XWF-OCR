v0.5 Alpha<br>
At last, we have the XWF_GetRastorImage method working which superseeds both the filestreamed method, and then the TPicture class method so the code is shorter and the performance much faster

v0.4 Alpha<br>
The Tesseract lib is now only loaded once, instead of being loaded and unloaded for every item, making it faster<br>
Rather than creating a temporary copy of the file on disk to OCR, its now done in a TPicture memory stream, making it faster<br>
Added Interfaces library to enable the above. <br>
Added seconds to the "started at" value instead of just date, hours and minutes. <br>

v0.3 Alpha<br>
XWF_Close was being called in areas of the loop where the failure of XWF_OpenItem made it impossible to close anyway, which caused Unable to free memory" errors. That was fixed. <br>
Log file reports failed file items using the same structure as successful items, i.e. ID, name, message<br>
Both the log file and the temporary files are now saved to the same specified output location defined by the user (C:\temp by default), as opposed to the temp files going to the root of where the DLL is being executed from.<br>
If the user forgets to add a backslash to the output location folder name, it will now be added automatically.  <br>

v0.2 Alphas Release<br>
64-bit and 32-bit version available
Tesseract and Leptonica now held in one single DLL<br>
All files for which OCR is successfully conducted now saved quite fully as tab seperated values to the logfile, as opposed to just errors<br>
OCR Text extracts now correctly inserted as child objects of the parent picture file. 
Log file was not being saved and was causing exception error due to inclusion of the colon character from the time. Thast was fixed by using hyphen char instead<br>
LICENSES folder added holding copies of several of the open-source licenses that this project adheres to, and is protected by. 

v0.1 Alpha Release<br>
Released as PoC in 32-bit mode.<br> 