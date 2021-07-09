# XT_XWF-OCR 

### XT_XWF-OCR X-Tension by Ted Smith
   Most recently tested on XWF : v20.0<br>

### Functionality Overview
  The X-Tension will examine every picture file (or tagged picture file).<br>
  If it is a confirmed picture file larger than 2Kb, it will attempt to
  conduct OCR and generate a text file containing the output.<br>
  These can be filtered for recursively post execution using a filename filter "*_OCR-EXTRACT.txt"<br>
  For better results, tag picture files that look OCR'able first, and then run
  RVS over tagged items only. If you run this over EVERY picture file you
  WILL waste time....a lot of it.<br>
  
  NOT MULTI-THREAD ENABLED. If you use more threads, it will appear to hang. <br>

### Requirements
  This X-Tension is designed for use only with X-Ways Forensics v19.1 or higher<br>
  This X-Tension is not designed for use on Linux or OSX platforms.<br>

  ==== All users Note ====<br>

  Host OS requires Microsoft C++ 2017 Redistributable Package<br>
  https://aka.ms/vs/16/release/vc_redist.x86.exe - 32-bit<br>
  https://aka.ms/vs/16/release/vc_redist.x64.exe - 64-bit<br>

  All files must be held in a folder called \bin.<br>
    1) XT_XWF_OCR.DLL must be in the root of \bin<br>
    2) libtesseract32.dll must be in the root of \bin<br>
    3) libtesseract64.dll must be in the root of \bin<br>
    4) "eng.traineddata" must be in a subfolder of \bin, called "\tessdata", i.e. \YourFolder\bin\tessdata<br>
  X-Tension must be executed via the RVS process of XWF (F10)<br>

  === Software developers note: ===<br>
  LCLBase Package is required for project compilation<br>

  msys2 (https://www.msys2.org/) is required to compile DLL's of
  Leptonica and TesseractOCR.<br>

  However, as of 08/07/21, a single DLL for both x64 and x86 is bundled providing
  Tesseract v4.1.1 capability, supplying both the Tesseract and Leptonica
  functionality combined without the need for about a dozen other DLLs.
  This is with great thanks to the libTesseract project :<br>
  https://github.com/ollydev/libTesseract<br>

  But others wishing to pursue the route manually can do so via :<br>

  Leptonica<br>
  https://packages.msys2.org/package/mingw-w64-x86_64-leptonica?repo=mingw64<br>

  TesseractOCR :<br>
  https://packages.msys2.org/package/mingw-w64-x86_64-tesseract-ocr?repo=mingw64<br>

  Build using MSYS2 terminal as follows, which should generate DLL's in the MSYS2 bin folder :<br>

  pacman -S mingw-w64-x86_64-leptonica<br>

  pacman -S mingw-w64-x86_64-tesseract-ocr<br>

### Usage Disclaimer
  PRODUCTION USE STATUS : Proof of Concept Prototype<br>

### TODOs
     Use native XWF memory streams instead of writing the files out and OCR'ing them and then pulling the output back in. <br>
     User manual etc<br>

### Licenses
  This code is open source software licensed under the
  [Apache 2.0 License]("http://www.apache.org/licenses/LICENSE-2.0.html")
  and The Open Government Licence (OGL) v3.0.<br>
  (http://www.nationalarchives.gov.uk/doc/open-government-licence and
   http://www.nationalarchives.gov.uk/doc/open-government-licence/version/3/).<br>

  Tesseract, which this code relies upon, is an open source text recognition (OCR)
  Engine from Google, available under the Apache 2.0 license<br>
  http://www.apache.org/licenses/LICENSE-2.0<br>

  TTesseractOCR4, which this code relies upon, is an Object Orientated Pascal binding for Tesseract-ocr 4,
  an optical character recognition engine licensed under MIT<br>
  https://github.com/r1me/TTesseractOCR4<br>

  libTesseract, which this code relies upon, is courtesy of
  https://github.com/ollydev/libTesseract (no license stated as of 08/07/21)<br>

  Leptonica, which this code relies upon, is licensed by Dan Bloomberg under a
  Creative Commons Attribution 3.0 United States License.<br>
  https://github.com/DanBloomberg/leptonica<br>


### Collaboration
  Collaboration is welcomed, particularly from Delphi or Freepascal developers.
  This version was created using the Lazarus IDE v2.0.12 and Freepascal v3.2.0.
  (www.lazarus-ide.org), x64 and x86 edition  <br>