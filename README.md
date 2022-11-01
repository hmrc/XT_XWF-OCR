# XT_XWF-OCR 

### XT_XWF-OCR X-Tension by Ted Smith with contributions from Sam Lockwood
   Most recently tested on XWF : v20.6

### Functionality Overview
  The X-Tension will examine every picture file (or tagged picture file).
  If it is a confirmed picture file larger than 2Kb, it will attempt to
  conduct OCR and generate a text file containing the output.
  These can be filtered for recursively post execution using a filename filter "OCREXTRACT-*"
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
  This version was created using the Lazarus IDE and Freepascal
  (www.lazarus-ide.org) and contains helpful collaborative improvements from Sam Lockwood. <br>