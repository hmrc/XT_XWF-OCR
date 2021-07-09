library XT_XWF_OCR;
{

# XT_XWF-OCR 

### XT_XWF-OCR X-Tension by Ted Smith
   Most recently tested on XWF : v20.0

### Functionality Overview
  The X-Tension will examine every picture file (or tagged picture file).
  If it is a confirmed picture file larger than 2Kb, it will attempt to
  conduct OCR and generate a text file containing the output.
  These can be filtered for recursively post execution using a filename filter "*_OCR-EXTRACT.txt"
  For better results, tag picture files that look OCR'able first, and then run
  RVS over tagged items only. If you run this over EVERY picture file you
  WILL waste time....a lot of it.

  NOT MULTI-THREAD ENABLED. If you use more threads, it will appear to hang.

### Requirements
  This X-Tension is designed for use only with X-Ways Forensics v19.1 or higher
  This X-Tension is not designed for use on Linux or OSX platforms.

  === All users Note ====

  Host OS requires Microsoft C++ 2017 Redistributable Package
  https://aka.ms/vs/16/release/vc_redist.x86.exe - 32-bit
  https://aka.ms/vs/16/release/vc_redist.x64.exe - 64-bit

  All files must be held in a folder called \bin.
    1) XT_XWF_OCR.DLL must be in the root of \bin
    2) libtesseract32.dll must be in the root of \bin
    3) libtesseract64.dll must be in the root of \bin
    4) "eng.traineddata" must be in a subfolder of \bin, called "\tessdata", i.e. \YourFolder\bin\tessdata
  X-Tension must be executed via the RVS process of XWF (F10)

  === Software developers note: ===
  LCLBase Package is required for project compilation

  msys2 (https://www.msys2.org/) is required to compile DLL's of
  Leptonica and TesseractOCR.

  However, as of 08/07/21, a single DLL for both x64 and x86 is bundled providing
  Tesseract v4.1.1 capability, supplying both the Tesseract and Leptonica
  functionality combined without the need for about a dozen other DLLs.
  This is with great thanks to the libTesseract project :
  https://github.com/ollydev/libTesseract

  But others wishing to pursue the route manually can do so via :

  Leptonica
  https://packages.msys2.org/package/mingw-w64-x86_64-leptonica?repo=mingw64

  TesseractOCR :
  https://packages.msys2.org/package/mingw-w64-x86_64-tesseract-ocr?repo=mingw64

  Build using MSYS2 terminal as follows, which should generate DLL's in the MSYS2 bin folder :

  pacman -S mingw-w64-x86_64-leptonica

  pacman -S mingw-w64-x86_64-tesseract-ocr

### Usage Disclaimer
  PRODUCTION USE STATUS : Proof of Concept Prototype

### TODOs
     User manual etc

### Licenses
  This code is open source software licensed under the
  [Apache 2.0 License]("http://www.apache.org/licenses/LICENSE-2.0.html")
  and The Open Government Licence (OGL) v3.0.
  (http://www.nationalarchives.gov.uk/doc/open-government-licence and
   http://www.nationalarchives.gov.uk/doc/open-government-licence/version/3/).

  Tesseract, which this code relies upon, is an open source text recognition (OCR)
  Engine from Google, available under the Apache 2.0 license
  http://www.apache.org/licenses/LICENSE-2.0

  TTesseractOCR4, which this code relies upon, is an Object Orientated Pascal binding for Tesseract-ocr 4,
  an optical character recognition engine licensed under MIT
  https://github.com/r1me/TTesseractOCR4

  libTesseract, which this code relies upon, is courtesy of
  https://github.com/ollydev/libTesseract (no license stated as of 08/07/21)

  Leptonica, which this code relies upon, is licensed by Dan Bloomberg under a
  Creative Commons Attribution 3.0 United States License.
  https://github.com/DanBloomberg/leptonica


### Collaboration
  Collaboration is welcomed, particularly from Delphi or Freepascal developers.
  This version was created using the Lazarus IDE v2.0.12 and Freepascal v3.2.0.
  (www.lazarus-ide.org), x64 and x86 edition

}
{$mode Delphi}{$H+}

uses
  Classes, XT_API, windows, sysutils, contnrs, md5, LazUTF8, lazutf8classes,
  tesseractocr;

  const
    BufEvdNameLen=256;
var
  // These are global vars
  MainWnd                  : THandle;
  CurrentVolume            : THandle;
  // For a log file to save details of any failures
  slLogFile                : TStringList;
  // Evidence name is global for later filesave by name
  pBufEvdName              : array[0..BufEvdNameLen-1] of WideChar;
  // We want the output folder to be set only once, otherwise the user will be asked
  // repeatedly for the output path for every evidence object during RVS. Once set
  // we switch a flag to true so that the location is not asked for again
  OutputFolder             : Unicodestring = Default(UnicodeString);
  OutputFolderIsSpecified  : boolean = Default(Boolean);
  // To check release version of XWF for compatability
  VerRelease               : LongInt = Default(LongInt);
  ServiceRelease           : Byte    = Default(Byte);

// The first call needed by the X-Tension API. Must return 1 for the X-Tension to continue.
function XT_Init(nVersion, nFlags: DWord; hMainWnd: THandle; lpReserved: Pointer): LongInt; stdcall; export;
begin
  // Get high 2 bytes from nVersion
  VerRelease := Hi(nVersion);
  // Get 3rd high byte for service release. We dont need it yet but we might one day
  ServiceRelease := HiByte(nVersion);

  if VerRelease < 1910 then
  begin
     MessageBox(MainWnd, 'Error: ' +
                        ' Please execute this X-Tension using v19.1 or above ',
                        'XT_XWF-OCR', MB_ICONINFORMATION);
    result := -1;  // Should abort and not run any further
  end
  else
    begin
      result := 1;  // Continue, with no need for warning
      // Just make sure everything is hunkydory and set to zero
      OutputFolder             := '';   // Set this to empty to start with
      FillChar(pBufEvdName, SizeOf(pBufEvdName), $00);
      // Check XWF is ready to go. 1 is normal mode, 2 is thread-safe. Using 1 for now
      if Assigned(XWF_OutputMessage) then
      begin
        Result := 1; // lets go
        MainWnd:= hMainWnd;
      end
      else Result := -1; // stop
    end;
end;

// Used by the button in the X-Tension dialog to tell the user about the X-Tension
// Must return 0
function XT_About(hMainWnd : THandle; lpReserved : Pointer) : Longword; stdcall; export;
begin
  result := 0;
  MessageBox(MainWnd,  ' XT_XWF-OCR ' +
                       ' Description : X-Tension to enable OCR scanning of files ' +
                       ' Developed by Ted Smith. Released under the OGL (Open Government License)' +
                       ' Intended use : via RVS only'
                      ,'XT_XWF-OCR', MB_ICONINFORMATION);
end;
// GetOutputLocation : Gets the output location
// Returns empty string on failure
function GetOutputLocation() : widestring; stdcall; export;
const
  BufLen=2048;
var
  Buf, outputmessage : array[0..Buflen-1] of WideChar;
  UsersSpecifiedPath : array[0..Buflen-1] of WideChar;
  UserInputResultVal : Int64 = Default(Int64);
  OutputOK           : Boolean = Default(Boolean);
begin
  result             := Default(widestring);
  outputmessage      := '';

  FillChar(outputmessage,      Length(outputmessage),      $00);
  FillChar(UsersSpecifiedPath, Length(UsersSpecifiedPath), $00);
  FillChar(Buf,                Length(Buf),                $00);

  // Set default output location
  UsersSpecifiedPath := 'C:\temp\';

  // Ask XWF to ask the user if s\he wants to override that default location
  UserInputResultVal := XWF_GetUserInput('Save log file to folder...', @UsersSpecifiedPath, Length(UsersSpecifiedPath), $00000002);
  if UserInputResultVal > 0 then
    begin
    // If output location exists, use it, otherwise, create it
    if DirectoryExists(UsersSpecifiedPath) then
    begin
      result            := UTF8ToUTF16(IncludeTrailingPathDelimiter(UsersSpecifiedPath));
      outputmessage     := 'Log file will be saved to existing folder : ' + UsersSpecifiedPath;
      lstrcpyw(Buf, outputmessage);
      XWF_OutputMessage(@Buf[0], 0);
    end
    else
    begin
      OutputOK := ForceDirectories(UsersSpecifiedPath);
      if OutputOK then
      begin
        result            := UTF8ToUTF16(IncludeTrailingPathDelimiter(UsersSpecifiedPath));
        outputmessage     := 'Log file will be saved to new folder : ' + UsersSpecifiedPath;
        lstrcpyw(Buf, outputmessage);
        XWF_OutputMessage(@Buf[0], 0);
      end;
    end;
  end;
end;

// Returns a human formatted version of the time
function TimeStampIt(TheDate : TDateTime) : string; stdcall; export;
begin
  result := FormatDateTime('DD/MM/YYYY HH:MM:SS', TheDate);
end;

// Gets the case name, currently selected evidence object, image size
// Returns true on success. False otherwise.
function GetEvdData(hEvd : THandle) : boolean; stdcall; export;
const
  BufLen=256;
var
  Buf            : array[0..BufLen-1] of WideChar;
  pBufCaseName   : array[0..Buflen-1] of WideChar;
  pBufEvdName    : array[0..Buflen-1] of WideChar;
  CaseProperty, EvdSize, intEvdName : Int64;

begin
  result := false;
  // Get the case name, to act as the title in the output file, and store in pBufCaseName
  // XWF_CASEPROP_TITLE = 1, thus that value passed
  CaseProperty := -1;
  CaseProperty := XWF_GetCaseProp(nil, 1, @pBufCaseName[0], Length(pBufCaseName));

  // Get the item size of the evidence object. 16 = Evidence Total Size
  EvdSize := -1;
  EvdSize := XWF_GetEvObjProp(hEvd, 16, nil);

  // Get the evidence object name and store in pBufEvdName. 8 = abbreviated ext. ev. obj. title (e.g. "HD123, P2)
  intEvdName := -1;
  intEvdName := XWF_GetEvObjProp(hEvd, 8, @pBufEvdName[0]);

  lstrcpyw(Buf, 'Case properties established : OK');
  XWF_OutputMessage(@Buf[0], 0);
  result := true;
end;

// This is used for every evidence object when executed via RVS and for each item
// XT_ProcessItem is called
function XT_Prepare(hVolume, hEvidence : THandle; nOpType : DWord; lpReserved : Pointer) : integer; stdcall; export;
const
  BufLen=1024;
var
  outputmessage : array[0..Buflen-1] of WideChar;
  Buf           : array[0..Buflen-1] of WideChar;
begin
  if nOpType <> 1 then
  begin
    MessageBox(MainWnd, 'Advisory: ' +
                        ' Please execute this X-Tension via the RVS (F10) option only' +
                        ' and apply it to your selected evidence object(s).'
                       ,'XWF OCR X-Tension', MB_ICONINFORMATION);
    // Tell XWF to abort if the user attempts another mode of execution, by returning -3
    result := -3;
  end
  else
    begin
      if OutputFolderIsSpecified = false then
      begin
        OutputFolder := GetOutputLocation();
        if DirectoryExists(OutputFolder) then
        begin
          OutputFolderIsSpecified := true;
          result := XT_PREPARE_CALLPI;      // Set Result. Tell XWF to proceed and call XT_ProcessItem
          CurrentVolume := hVolume;
          slLogFile := TStringList.Create;
          outputmessage := 'Execution of X-Tension started at ' + FormatDateTime('YYYY-MM-DD-HH:MM', Now);
          lstrcpyw(Buf, @outputmessage[0]);
          XWF_OutputMessage(@Buf[0], 0);
        end
        else
        begin
          outputmessage := 'Could not create output folder for log file. Stopping';
          lstrcpyw(Buf, outputmessage);
          XWF_OutputMessage(@Buf[0], 0);
          OutputFolderIsSpecified := false;
          result := -3  // Tell XWF to abort
        end;
       end
      else if OutputFolderIsSpecified = true then
      begin
        // We need our X-Tension to return 0x01, 0x08, 0x10, and 0x20, depending on exactly what we want
        // We can change the result using or combinations as we need, as follows:
        // Call XT_ProcessItem for each item in the evidence object : (0x01)  : XT_PREPARE_CALLPI
        result := XT_PREPARE_CALLPI;  // Set Result. Tell XWF to proceed and call XT_ProcessItem
        CurrentVolume := hVolume;
        outputmessage := 'Execution of X-Tension started at ' + FormatDateTime('YYYY-MM-DD-HH:MM', Now);
        lstrcpyw(Buf, @outputmessage[0]);
        XWF_OutputMessage(@Buf[0], 0);
      end;
    end;

    // XWF will intelligently skip certain items due to, for example, first cluster not known etc
    // In the future, if we need to change it to do all items regardless, change the result
    // of this function to 0 and then uncomment the for loop code below.
    // Then XWF will call XT_ProcessItem for every item in the evidence object
    // even if the file is non-sensicle.
    {
    for i := 0 to itemcount -1 do
    begin
     XT_ProcessItem(i, nil);
    end;
    }
end;

// Called for each item in the volume snapshot by XWF.
// Must return 0! -1 if fails.
function XT_ProcessItem(nItemID : LongWord; lpReserved : Pointer) : integer; stdcall; export;
const
  BufLen=1024;
var
  ItemSize            : Int64 = Default(Int64);
  lpTypeDescr         : array[0..Buflen-1] of WideChar;
  lpFileName          : array[0..Buflen-1] of WideChar;
  Buf                 : array[0..Buflen-1] of WideChar;
  strItemFileName     : array[0..Buflen-1] of WideChar;
  strOCRItemFileName  : array[0..Buflen-1] of WideChar;
  strItemParentName   : array[0..Buflen-1] of WideChar;
  lpReportTableString : array[0..Buflen-1] of WideChar;
  outputmessage       : array[0..Buflen-1] of WideChar;
  itemtypeinfoflag    : Integer = Default(integer);
  OCRFileID           : Integer = Default(integer);
  ParentHasChildren   : Boolean = Default(Boolean);
  IsAValidPictureFile : Boolean = Default(Boolean);
  PicReadyForOCR      : Boolean = Default(Boolean);
  ItemInfoSetOK       : Boolean = Default(Boolean);
  hOpenResult         : THandle = Default(THandle);
  OCRInstance         : TTesseractOCR4;
  strOCRResult        : string = Default(string);
  pSrcBuffer          : PSrcInfo;

  // For RasterImage version only
  // numBytesPerLine   : Integer = Default(integer);
  // ForOCR_RII        : PRasterImageInfo;
  // pPicBuff          : Pointer;
  // intItemParentID   : Integer = Default(integer);
  //

  // For the filestreamed method only
  InputBytesBuffer  : TBytes;
  intBytesRead      : Int64 = Default(Int64);
  BytesWritten      : Int64 = Default(Int64);
  RTAdditionSuccess : Integer = Default(Integer);
  OutputStream      : TFileStream;
  DelFileOK         : Boolean = Default(Boolean);
  scratchfilename   : string = Default(string);

begin
  // Make sure buffers are empty and filled with zeroes
  FillChar(lpTypeDescr,         Length(lpTypeDescr),        $00);
  FillChar(Buf,                 Length(lpTypeDescr),        $00);
  FillChar(lpFileName,          Length(lpFileName),         $00);
  FillChar(strOCRItemFileName,  Length(strOCRItemFileName), $00);
  FillChar(strItemFileName,     Length(strItemFileName),    $00);
  FillChar(strItemParentName,   Length(strItemParentName),  $00);
  FillChar(InputBytesBuffer,    Length(InputBytesBuffer),   $00);
  FillChar(lpReportTableString, Length(lpReportTableString),$00);
  FillChar(outputmessage,       Length(outputmessage),      $00);

  itemtypeinfoflag := XWF_GetItemType(nItemID, @lpTypeDescr, Length(lpTypeDescr) or $40000000);
   {0=not verified,
    1=too small,
    2=totally unknown,
    3=confirmed,
    4=not confirmed,
    5=newly identified,
    6 (v18.8 and later only)=mismatch detected.
    -1 means error
   }
  if itemtypeinfoflag > 2 then
  begin
    // Get the size of the item
    ItemSize := XWF_GetItemSize(nItemID);
    // If its a picture, and greater than 2K bytes, and potentially a valid file, then attempt to OCR it
    if (lpTypeDescr = 'Pictures') and (ItemSize > 2000) and (itemtypeinfoflag > 2) then
    begin
      IsAValidPictureFile := true;
      try
        OCRInstance := TTesseractOCR4.Create;
        if OCRInstance.Initialize('tessdata' + PathDelim, 'eng') then
        begin
          // For now, we will load pictures into RAM then write to disk
          // but need to incorporate a filestream method from XWF to disk, ideally
          // to account for big files. But as its 2021, I can't imagine many
          // pic files being too big for the RAM of most digital forensics machines
          SetLength(InputBytesBuffer, ItemSize);

          // Read the native file item into InputBytesBuffer buffer
          hOpenResult := XWF_OpenItem(CurrentVolume, nItemID, $01);
          if hOpenResult > 0 then
          begin
            intBytesRead := XWF_Read(hOpenResult, 0, @InputBytesBuffer[0], ItemSize);
            if intBytesRead > 0 then
            begin
              // Write the native file out to disk using the above declared stream
              // Use a GUID as a temp filename, or 'tempfile.raw' if that fails,
              // then write content of InputBytesBuffer to it
              scratchfilename := TGUID.NewGuid.ToString(true);
              try
                if Length(scratchfilename) > 0 then
                begin
                  OutputStream := TFileStream.Create(IncludeTrailingPathDelimiter(OutputFolder) + scratchfilename, fmCreate);
                end
                else
                begin
                  scratchfilename := 'tempfile.raw';
                  OutputStream := TFileStream.Create(IncludeTrailingPathDelimiter(OutputFolder) + scratchfilename, fmCreate);
                end;
                if OutPutStream.Handle > 0 then
                begin
                  BytesWritten := -1;
                  BytesWritten := OutputStream.Write(InputBytesBuffer[0], intBytesRead);
                  OutputStream.Free;
                end;
              finally
                // nothing needed
              end;
              // Now read the temp copy of the file from disk, and begin OCR work
              if BytesWritten > 0 then
               begin
                 Tesseract := OCRInstance; // Still dont understand why this is necessary, but it is
                 PicReadyForOCR := OCRInstance.SetImage(IncludeTrailingPathDelimiter(OutputFolder) + scratchfilename);
                 if PicReadyForOCR then
                   begin
                     strOCRResult := OCRInstance.RecognizeAsText;
                     if Length(strOCRResult) > 0 then
                       begin
                         strItemFileName    := XWF_GetItemName(nItemID);
                         strOCRItemFileName := strItemFileName + '_OCR-EXTRACT.txt';
                         New(pSrcBuffer);
                         pSrcBuffer.nStructSize := SizeOf(TSrcInfo);  // Should return 16 on 32-bit systems
                         pSrcBuffer.nBufSize    := Length(strOCRResult);
                         pSrcBuffer.pBuffer     := @strOCRResult[1];

                         OCRFileID := XWF_CreateFile(@strOCRItemFileName, $00000010, nItemID, pSrcBuffer);
                         if OCRFileID > 0 then
                           begin
                             // if parsed text is recovered, assign a child file item, then
                             // mark parent with the "has children" flag (0x02)
                             XWF_SetItemParent(OCRFileID, nItemID);
                             ParentHasChildren := XWF_SetItemInformation(nItemID, XWF_ITEM_INFO_FLAG_HASCHILDREN, $00000002);

                             // Add Report Table for the current itemID to
                             // highlight that OCR text data available for it
                             // Note this is not a RT for the OCR'd text - for its parent.
                             lpReportTableString := 'OCR text extracted to child';
                             RTAdditionSuccess := XWF_AddToReportTable(nItemID, @lpReportTableString[0], $04);
                             lpReportTableString := '';
                             // Add a report table for the new OCR Item itself too
                             lpReportTableString := 'OCR text extracted from parent';
                             RTAdditionSuccess := XWF_AddToReportTable(OCRFileID, @lpReportTableString[0], $04);
                             slLogFile.Add(IntToStr(OCRFileID) + #9 + strOCRItemFileName + #9 + ' text extracted from ' + #9 + strItemFileName + ' (Item ' + IntToStr(nItemID) + ')');
                           end
                           else
                           begin
                             slLogFile.Add(XWF_GetItemName(nItemID) + ' (Item ' + IntToStr(nItemID) + ') was examined but a new OCR item could not be added to the case');
                           end;
                         // Free memory used by the source data buffer
                         Dispose(pSrcBuffer);
                       end // End of strOCRResult validation check
                     else
                       begin
                         // Free memory used by the open item ID here too, even if read was unsuccessfull
                         XWF_Close(hOpenResult);
                         strItemFileName := XWF_GetItemName(nItemID);
                         outputmessage := 'Unable to extract OCR data from file ' + strItemFileName + ' (Item ' + IntToStr(nItemID) + ')';
                         lstrcpyw(Buf, @outputmessage[0]);
                         XWF_OutputMessage(@Buf[0], 0);
                         slLogFile.Add(IntToStr(nItemID) + #9 + strItemFileName + #9 + ' was examined but no OCR data could be extracted.');
                       end;
                   end;
                 Tesseract.Free;
               end // BytesWritten > 0
              else
                begin
                  outputmessage := 'Unable to write temp file for OCR recognition for file: ' + IntToStr(nItemID);
                  lstrcpyw(Buf, @outputmessage[0]);
                  XWF_OutputMessage(@Buf[0], 0);
                  slLogFile.Add(XWF_GetItemName(nItemID) + #9 + IntToStr(nItemID) + #9 + ' could not be copied and written out from XWF for OCR analysis.');
                end;
             end // intBytesRead > 0
            else
              begin
                // No need for XWF_Close(hOpenResult) because the item was not opened anyway
                outputmessage := 'Unable to read ' + IntToStr(nItemID);
                lstrcpyw(Buf, @outputmessage[0]);
                XWF_OutputMessage(@Buf[0], 0);
                slLogFile.Add(XWF_GetItemName(nItemID) + #9 + IntToStr(nItemID) + #9 + ' could not be read or examined at all.');
              end;
           end // hOpenResult > 0
          else
          begin
            // No need for XWF_Close(hOpenResult) at this point because the item was not opened anyway
            outputmessage := 'Unable to open ' + IntToStr(nItemID);
            lstrcpyw(Buf, @outputmessage[0]);
            XWF_OutputMessage(@Buf[0], 0);
            slLogFile.Add(XWF_GetItemName(nItemID) + #9 + IntToStr(nItemID) + #9 + ' could not be opened and thus could not be examined for OCR.');
          end;
         end // OCRInstance.Initialize
        else
          begin
            // No need for XWF_Close(hOpenResult) at this point because the item was not opened anyway
            outputmessage := 'Unable to start OCR engine for file ' + IntToStr(nItemID);
            lstrcpyw(Buf, @outputmessage[0]);
            XWF_OutputMessage(@Buf[0], 0);
            slLogFile.Add('Tesseract or Leptonica OCR Libraries could not be loaded when examining file ' + XWF_GetItemName(nItemID) + ' (Item ' + IntToStr(nItemID) + ').');
          end;
      finally
        // End of OCRInstance creation try finally statement. Cleanup.
        if Length(scratchfilename) > 0 then
        begin
          DelFileOK := DeleteFile(IncludeTrailingPathDelimiter(OutputFolder) + scratchfilename);
        end;
      end;
    end
    else IsAValidPictureFile := false;
  end; // End of ItemSize check

  // The ALL IMPORTANT 0 return value!!
  result := 0;

  { Method 2 : The Golden Goose Solution : Avoids using filestreams and instead
    uses a buffer of XWF_GetRasterImage. But, not using it for now because OCR
    recognition wasn't working properly on the output. And I cant work out why.
    Most likely is the Number of Bytes per Line or Resolution Value being wrong.

   begin
   hOpenResult := XWF_OpenItem(CurrentVolume, nItemID, $01);
   if hOpenResult > 0 then
     begin
       try
         New(ForOCR_RII);                               // Allocate type PRasterImageInfo from XWF API
         ForOCR_RII.nSize    := SizeOf(TRasterImageInfo)// Expect 32 bytes on x86. 36 on x64 because LONG (for nItemID) can be 8 bytes on 64-bit instead of 4.
         ForOCR_RII.nItemID  := nItemID;                // Item ID of picture file
         ForOCR_RII.hItem    := hOpenResult;            // Handle to Item ID
         ForOCR_RII.nFlags   := $00;                    // Get a raw copy of the picture file from X-Ways
         ForOCR_RII.nWidth   := 0;                      // Will be set by the return value from XWF
         ForOCR_RII.nHeight  := 0;                      // Will be set by the return value from XWF
         ForOCR_RII.nResSize := 0;                      // Will be set by the return value from XWF

         // Get a pointer to a buffer holding a valid raster BMP image of the picture file
         // and populate values nWidth, nHeight and nResSize
         pPicBuff := XWF_GetRasterImage(ForOCR_RII);

         // If XWF_GetRasterImage worked, buffer will not be null.
         if pPicBuff <> nil then
           begin
             numBytesPerLine:=  ForOCR_RII.nWidth * 3;
               if (numBytesPerLine mod 4 <>0) then                // calculate if division by 4 delivers remainder of 0
                 inc(numBytesPerLine, 4-(numBytesPerLine mod 4)); // if no, increase by the number of bytes required to make up the difference

             // Now pass the BMP buffered image to the OCR engine with the parameters
             // Will return true if that step succeeded
             PicReadyForOCR := OCRInstance.SetImage(pPicBuff,
                                                    ForOCR_RII.nWidth,
                                                    ForOCR_RII.nHeight,
                                                    3, // ForOCR_RII.nResSize
                                                    numBytesPerLine);
             if PicReadyForOCR then
               begin
                 // And now run the OCR'ing over the image. The text is returned on success
                 Tesseract         := OCRInstance;  // Bizzarely it is still necessary to assign the API global var Tesseract to the OCRInstance. Not sure why
                 strOCRResult      := OCRInstance.RecognizeAsText;
                 if Length(strOCRResult) > 0 then
                   begin
                     strItemFileName   := 'OCRData-' + IntToStr(nItemID) +'_' + XWF_GetItemName(nItemID) + '.txt';
                     intItemParentID   := XWF_GetItemParent(nItemID);
                     //strItemParentName := XWF_GetItemName(intItemParentID);

                     New(pSrcBuffer);
                     pSrcBuffer.nStructSize := SizeOf(TSrcInfo);
                     pSrcBuffer.nBufSize    := Length(strOCRResult);
                     pSrcBuffer.pBuffer     := @strOCRResult[1];
                     OCRFileID := XWF_CreateFile(@strItemFileName, $00000010, intItemParentID, pSrcBuffer);
                     if OCRFileID > -1 then
                       begin
                         ItemInfoSetOK := XWF_SetItemInformation(OCRFileID, XWF_ITEM_INFO_FLAGS, $00000008);
                       end;
                     Dispose(pSrcBuffer);
                   end; // End of strOCRResult validation check
                 Tesseract.Free;
               end; // End of PicReadyForOCR validation check
           end;  // End of pPicBuff validation check
       finally
         // Free resources used by XWF_GetRasterImage
         Dispose(ForOCR_RII);
         Windows.VirtualFree(pPicBuff, 0, MEM_RELEASE);
       end;
     end; // End of hOpenResult validation check
  end; // End of OCRInstance validation check   }
end;

// Called after all items in the evidence objects have been itterated.
// Return -1 on failure. 0 on success.
function XT_Finalize(hVolume, hEvidence : THandle; nOpType : DWord; lpReserved : Pointer) : integer; stdcall; export;
const
 BufLen=1024;
var
  outputmessage   : array[0..Buflen-1] of WideChar;
  OutputFileName  : array[0..Buflen-1] of WideChar;
  Buf             : array[0..Buflen-1] of WideChar;
begin
  FillChar(Buf, SizeOf(Buf), $00);
  FillChar(OutputFileName, SizeOf(OutputFileName), $00);

  if DirectoryExists(OutputFolder) then
    begin
      OutputFileName := 'XT_XWF-OCR-' + FormatDateTime('YYYY-MM-DD-HH-MM-SS', Now) + '.txt';
      slLogFile.SaveToFile(OutputFolder+OutputFileName);
    end
  else
  begin
    outputmessage := ('Could not write log file. Output folder does not exist or unwritable ' + OutputFolder);
    lstrcpyw(Buf, @outputmessage[0]);
    XWF_OutputMessage(@Buf[0], 0);
  end;

  slLogFile.Free;

  outputmessage := ('Execution of X-Tension ended at ' + FormatDateTime('YYYY-MM-DD-HH:MM:SS', Now) + '. Find results via FileName filter "_OCR-EXTRACT" or Report Table filter "OCR text extracted from parent"');
  lstrcpyw(Buf, @outputmessage[0]);
  XWF_OutputMessage(@Buf[0], 0);
  result := 0;
end;

// called just before the DLL is unloaded to give XWF chance to dispose any allocated memory,
// Should return 0.
function XT_Done(lpReserved: Pointer) : integer; stdcall; export;
begin
  result := 0;
end;


exports
  XT_Init,
  XT_About,
  XT_Prepare,
  XT_ProcessItem,
  XT_Finalize,
  XT_Done,
  // The following functions may not be exported in future. Left in for now.
  GetOutputLocation,
  TimeStampIt;
begin

end.



