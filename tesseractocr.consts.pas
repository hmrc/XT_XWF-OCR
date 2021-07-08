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
  // Original library declaration as stated in the TTesseractOCR4 library
  // https://github.com/r1me/TTesseractOCR4
   { {$ifdef CPU64}
      libleptonica = pvt.cppan.demo.danbloomberg.leptonica-1.76.0.dll;
      libtesseract = pvt.cppan.demo.google.tesseract.libtesseract-master.dll;
    {$endif}
    {$ifdef CPU32}
      libleptonica = pvt.cppan.demo.danbloomberg.leptonica-1.76.0.dll;
      libtesseract = pvt.cppan.demo.google.tesseract.libtesseract-master.dll;
    {$endif}   }

  // Modified declaration to utilise the more convenient self-encompassed C libTesseract library
  // https://github.com/ollydev/libTesseract
  {$ifdef CPU64}
      libtesseract = 'libtesseract64.dll';
      libleptonica = libtesseract;         // Point up to x64 libtesseract as libTesseract DLL contains both function calls
    {$endif}
    {$ifdef CPU32}
      libtesseract = 'libtesseract32.dll';
      libleptonica = libtesseract;         // Point up to x86 libtesseract as libTesseract DLL contains both function calls
    {$endif}
  {$ENDIF}

implementation

end.
