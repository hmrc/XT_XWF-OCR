unit tesseractocr.consts;

{ The MIT License (MIT)

 TTesseractOCR4
 Copyright (c) 2018 Damian Woroch, http://rime.ddns.net/

 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE. }

interface

{$IFDEF FPC}
type
  PUTF8Char = PAnsiChar;
{$ENDIF}

{$DEFINE USE_CPPAN_BINARIES}

const
  {$IFDEF USE_CPPAN_BINARIES}
  libleptonica = {$IFDEF Linux}'libpvt.cppan.demo.danbloomberg.leptonica-1.76.0.so'{$ELSE}'pvt.cppan.demo.danbloomberg.leptonica-1.76.0.dll'{$ENDIF}; // 'libleptonica-5-x64.dll'{$ENDIF};
  libtesseract = {$IFDEF Linux}'libpvt.cppan.demo.google.tesseract.libtesseract-master.so'{$ELSE}'pvt.cppan.demo.google.tesseract.libtesseract-master.dll'{$ENDIF}; // libtesseractocr-4-1-x64.dll {$ENDIF};
  {$ELSE}
  libleptonica = {$IFDEF Linux}'liblept.so.5'{$ELSE}'liblept-5.dll'{$ENDIF};
  libtesseract = {$IFDEF Linux}'libtesseract.so.4'{$ELSE}'libtesseract-4.dll'{$ENDIF};
  {$ENDIF}

implementation

end.
