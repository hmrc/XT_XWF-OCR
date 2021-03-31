
# XT_XWF-OCR


### XT_XWF-OCR X-Tension by Ted Smith
   Most recently tested on XWF : v20.0

###  *** Requirements ***
  This X-Tension is designed for use only with X-Ways Forensics, x86 edition
  This X-Tension is designed for use only with v19.1 of X-Ways Forensics or later.
  This X-Tension is not designed for use on Linux or OSX platforms.

  === All users Note ====
  
  Host OS requires Microsoft C++ 2017 Redistributable Package x86 for 32-bit XWF
  https://aka.ms/vs/16/release/vc_redist.x86.exe
  (When x64 version is ready, host OS will requires Microsoft C++ 2017
   Redistributable Package x64 for 64-bit XWF
  (https://aka.ms/vs/16/release/vc_redist.x64.exe) )

  All files must be held in a folder called /bin.
  XT_XWF_OCR.DLL must be in the root of /bin
  pvt.cppan.demo.google.tesseract.libtesseract-master.dll must exist in root of /bin
  pvt.cppan.demo.danbloomberg.leptonica-1.76.0.dll must exist in root of /bin
  eng.traineddata must be in a subfolder of /bin, called /tessdata
  X-Tension must be executed via the RVS process of XWF (F10)

  === Software developers note: ===
  LCLBase Package is required for project compilation

  msys2 (https://www.msys2.org/) is required to compile 64-bit DLL's of
  Leptonica 1.80.0 (7/28/20) and TesseractOCR

  Leptonica
  https://packages.msys2.org/package/mingw-w64-x86_64-leptonica?repo=mingw64
  
  TesseractOCR :
  https://packages.msys2.org/package/mingw-w64-x86_64-tesseract-ocr?repo=mingw64
  
  Build using MSYS2 terminal as follows, which should generate DLL's in the MSYS2 bin folder :
  
  pacman -S mingw-w64-x86_64-leptonica
  
  pacman -S mingw-w64-x86_64-tesseract-ocr

###  *** Usage Disclaimer ***
  PRODUCTION USE STATUS : Proof of Concept Prototype

###  *** Functionality Overview ***
  The X-Tension will examine every picture file. If it is a confirmed picture file
  larger than 2Kb, it will attempt to conduct OCR and generate a text file
  containing the output. These can be filtered for recursively post execution
  using a filename filter "*_OCR-EXTRACT_*

  Execution Method : "Refine Volume Snapshot" (RVS, F10)

###  TODOs
     Make 64-bit ready by creating Leptonica and Tesseract 64-bit DLLs

### Licenses
  This code is open source software licensed under the
  [Apache 2.0 License]("http://www.apache.org/licenses/LICENSE-2.0.html")
  and The Open Government Licence (OGL) v3.0.
  (http://www.nationalarchives.gov.uk/doc/open-government-licence and
   http://www.nationalarchives.gov.uk/doc/open-government-licence/version/3/).

  Tesseract is an open source text recognition (OCR) Engine from Google,
  available under the Apache 2.0 license
  http://www.apache.org/licenses/LICENSE-2.0

  TTesseractOCR4 is an Object Orientated Pascal binding for Tesseract-ocr 4,
  an optical character recognition engine licensed under MIT
  https://github.com/r1me/TTesseractOCR4

  Leptonica is licensed by Dan Bloomberg under a
  Creative Commons Attribution 3.0 United States License.
  https://github.com/DanBloomberg/leptonica


###  *** Collaboration ***
  Collaboration is welcomed, particularly from Delphi or Freepascal developers.
  This version was created using the Lazarus IDE v2.0.12 and Freepascal v3.2.0.
  (www.lazarus-ide.org), 32-bit edition  
