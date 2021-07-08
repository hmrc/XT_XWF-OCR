unit tesseractocr.capi;

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
uses
  tesseractocr.leptonica,
  tesseractocr.consts,
Windows;

type
  TessResultRenderer = Pointer;
  TessTextRenderer = Pointer;
  TessHOcrRenderer = Pointer;
  TessPDFRenderer = Pointer;
  TessUnlvRenderer = Pointer;
  TessBoxTextRenderer = Pointer;
  TessBaseAPI = Pointer;
  TessPageIterator = Pointer;
  TessResultIterator = Pointer;
  TessMutableIterator = Pointer;
  TessChoiceIterator = Pointer;

type
  TessOcrEngineMode = (OEM_TESSERACT_ONLY, OEM_LSTM_ONLY, OEM_TESSERACT_LSTM_COMBINED, OEM_DEFAULT);

type
  TessPageSegMode = (PSM_OSD_ONLY, PSM_AUTO_OSD, PSM_AUTO_ONLY, PSM_AUTO, PSM_SINGLE_COLUMN, PSM_SINGLE_BLOCK_VERT_TEXT,
    PSM_SINGLE_BLOCK, PSM_SINGLE_LINE, PSM_SINGLE_WORD, PSM_CIRCLE_WORD, PSM_SINGLE_CHAR, PSM_SPARSE_TEXT,
    PSM_SPARSE_TEXT_OSD, PSM_RAW_LINE, PSM_COUNT);

type
  TessPageIteratorLevel = (RIL_BLOCK, RIL_PARA, RIL_TEXTLINE, RIL_WORD, RIL_SYMBOL);

type
  TessPolyBlockType = (PT_UNKNOWN, PT_FLOWING_TEXT, PT_HEADING_TEXT, PT_PULLOUT_TEXT,
    PT_EQUATION, PT_INLINE_EQUATION, PT_TABLE, PT_VERTICAL_TEXT, PT_CAPTION_TEXT,
    PT_FLOWING_IMAGE, PT_HEADING_IMAGE, PT_PULLOUT_IMAGE,
    PT_HORZ_LINE, PT_VERT_LINE, PT_NOISE, PT_COUNT);

type
  TessOrientation = (ORIENTATION_PAGE_UP, ORIENTATION_PAGE_RIGHT,
    ORIENTATION_PAGE_DOWN, ORIENTATION_PAGE_LEFT);

type
  TessParagraphJustification = (JUSTIFICATION_UNKNOWN, JUSTIFICATION_LEFT,
    JUSTIFICATION_CENTER, JUSTIFICATION_RIGHT);

type
  TessWritingDirection = (WRITING_DIRECTION_LEFT_TO_RIGHT,
    WRITING_DIRECTION_RIGHT_TO_LEFT, WRITING_DIRECTION_TOP_TO_BOTTOM);

type
  TessTextlineOrder = (TEXTLINE_ORDER_LEFT_TO_RIGHT, TEXTLINE_ORDER_RIGHT_TO_LEFT,
    TEXTLINE_ORDER_TOP_TO_BOTTOM);

type
  float = Single;
  BOOL = LongBool;
  size_t = NativeUInt;
  int = Integer;
  Pint = ^int;

type
  CANCEL_FUNC = function(cancel_this: Pointer; words: int): Boolean; cdecl;
  PROGRESS_FUNC = function(progress: int; left, right, top, bottom: int): Boolean; cdecl;

type
  EANYCODE_CHAR = record
    char_code: UINT16;
    left: INT16;
    right: INT16;
    top: INT16;
    bottom: INT16;
    font_index: INT16;
    confidence: UINT8;
    point_size: UINT8;
    blanks: INT8;
    formatting: UINT8;
  end;

type
  ETEXT_DESC = record
    count: INT16;
    progress: INT16;
    more_to_come: INT8;
    ocr_alive: INT8;
    err_code: INT8;
    cancel: CANCEL_FUNC;
    progress_callback: PROGRESS_FUNC;
    end_time: Integer;
    text: array[0..0] of EANYCODE_CHAR;
  end;
  PETEXT_DESC = ^ETEXT_DESC;

type
  PPUTF8Char = ^PUTF8Char;

type
  // General free functions
  TfnTessVersion = function: PUTF8Char; cdecl;
  TfnTessDeleteText = procedure(text: PUTF8Char); cdecl;
  TfnTessDeleteTextArray = procedure(arr: PPUTF8Char); cdecl;
  TfnTessDeleteIntArray = procedure(arr: Pointer); cdecl;

  // Renderer API
  TfnTessTextRendererCreate = function(const outputbase: PUTF8Char): TessResultRenderer; cdecl;
  TfnTessHOcrRendererCreate = function(const outputbase: PUTF8Char): TessResultRenderer; cdecl;
  TfnTessHOcrRendererCreate2 = function(const outputbase: PUTF8Char; font_info: BOOL): TessResultRenderer; cdecl;
  TfnTessPDFRendererCreate = function(const outputbase: PUTF8Char; const datadir: PUTF8Char;
    textonly: BOOL): TessResultRenderer; cdecl;
  TfnTessUnlvRendererCreate = function(const outputbase: PUTF8Char): TessResultRenderer; cdecl;
  TfnTessBoxTextRendererCreate = function(const outputbase: PUTF8Char): TessResultRenderer; cdecl;

  TfnTessDeleteResultRenderer = procedure(renderer: TessResultRenderer); cdecl;
  TfnTessResultRendererInsert = procedure(renderer: TessResultRenderer; next: TessResultRenderer); cdecl;
  TfnTessResultRendererNext = function(renderer: TessResultRenderer): TessResultRenderer; cdecl;
  TfnTessResultRendererBeginDocument = function(renderer: TessResultRenderer; const title: PUTF8Char): BOOL; cdecl;
  TfnTessResultRendererAddImage = function(renderer: TessResultRenderer; api: TessBaseAPI): BOOL; cdecl;
  TfnTessResultRendererEndDocument = function(renderer: TessResultRenderer): BOOL; cdecl;

  TfnTessResultRendererExtention = function(renderer: TessResultRenderer): PUTF8Char; cdecl;
  TfnTessResultRendererTitle = function(renderer: TessResultRenderer): PUTF8Char; cdecl;
  TfnTessResultRendererImageNum = function(renderer: TessResultRenderer): int; cdecl;

  // Base API
  TfnTessBaseAPICreate = function: TessBaseAPI; cdecl;
  TfnTessBaseAPIDelete = procedure(handle: TessBaseAPI); cdecl;

  TfnTessBaseAPIGetOpenCLDevice = function(handle: TessBaseAPI; device: PPointer): size_t; cdecl;

  TfnTessBaseAPISetInputName = procedure(handle: TessBaseAPI; const name: PUTF8Char); cdecl;
  TfnTessBaseAPIGetInputName = function(handle: TessBaseAPI): PUTF8Char; cdecl;

  TfnTessBaseAPISetInputImage = procedure(handle: TessBaseAPI; const pix: PPix); cdecl;
  TfnTessBaseAPIGetInputImage = function(handle: TessBaseAPI): PPix; cdecl;

  TfnTessBaseAPIGetSourceYResolution = function(handle: TessBaseAPI): int; cdecl;
  TfnTessBaseAPIGetDatapath = function(handle: TessBaseAPI): PUTF8Char; cdecl;

  TfnTessBaseAPISetOutputName = procedure(handle: TessBaseAPI; const name: PUTF8Char); cdecl;

  TfnTessBaseAPISetVariable = function(handle: TessBaseAPI; const name: PUTF8Char; const value: PUTF8Char): BOOL; cdecl;
  TfnTessBaseAPISetDebugVariable = function(handle: TessBaseAPI; const name: PUTF8Char; const value: PUTF8Char): BOOL; cdecl;

  TfnTessBaseAPIGetIntVariable = function(const handle: TessBaseAPI; const name: PUTF8Char; out value: int): BOOL; cdecl;
  TfnTessBaseAPIGetBoolVariable = function(const handle: TessBaseAPI; const name: PUTF8Char; out value: BOOL): BOOL; cdecl;
  TfnTessBaseAPIGetDoubleVariable = function(const handle: TessBaseAPI; const name: PUTF8Char; out value: double): BOOL; cdecl;
  TfnTessBaseAPIGetStringVariable = function(const handle: TessBaseAPI; const name: PUTF8Char): PUTF8Char; cdecl;

  TfnTessBaseAPIPrintVariables = procedure(const handle: TessBaseAPI; fp: Pointer); cdecl;
  TfnTessBaseAPIPrintVariablesToFile = function(const handle: TessBaseAPI; const filename: PUTF8Char): BOOL; cdecl;

  TfnTessBaseAPIInit1 = function(handle: TessBaseAPI; const datapath: PUTF8Char;
    const language: PUTF8Char; oem: TessOcrEngineMode; configs: PPUTF8Char; configs_size: int): int; cdecl;
  TfnTessBaseAPIInit2 = function(handle: TessBaseAPI; const datapath: PUTF8Char;
    const language: PUTF8Char; oem: TessOcrEngineMode): int; cdecl;
  TfnTessBaseAPIInit3 = function(handle: TessBaseAPI; const datapath: PUTF8Char; const language: PUTF8Char): int; cdecl;

  TfnTessBaseAPIInit4 = function(handle: TessBaseAPI; const datapath: PUTF8Char; const language: PUTF8Char; oem: TessOcrEngineMode;
    configs: PPUTF8Char; configs_size: int;
    vars_vec: PPUTF8Char; vars_values: PPUTF8Char; vars_vec_size: size_t;
    set_only_non_debug_params: BOOL): int; cdecl;

  TfnTessBaseAPIGetInitLanguagesAsString = function(const handle: TessBaseAPI): PUTF8Char; cdecl;
  TfnTessBaseAPIGetLoadedLanguagesAsVector = function(const handle: TessBaseAPI): PPUTF8Char; cdecl;
  TfnTessBaseAPIGetAvailableLanguagesAsVector = function(const handle: TessBaseAPI): PPUTF8Char; cdecl;

  TfnTessBaseAPIInitLangMod = function(handle: TessBaseAPI; const datapath: PUTF8Char; const language: PUTF8Char): int; cdecl;
  TfnTessBaseAPIInitForAnalysePage = procedure(handle: TessBaseAPI); cdecl;

  TfnTessBaseAPIReadConfigFile = procedure(handle: TessBaseAPI; const filename: PUTF8Char); cdecl;
  TfnTessBaseAPIReadDebugConfigFile = procedure(handle: TessBaseAPI; const filename: PUTF8Char); cdecl;

  TfnTessBaseAPISetPageSegMode = procedure(handle: TessBaseAPI; mode: TessPageSegMode); cdecl;
  TfnTessBaseAPIGetPageSegMode = function(handle: TessBaseAPI): TessPageSegMode; cdecl;

  TfnTessBaseAPIRect = function(handle: TessBaseAPI; const imagedata: PByte; bytes_per_pixel: int;
    bytes_per_line: int; left: int; top: int; width: int; height: int): PUTF8Char; cdecl;

  TfnTessBaseAPIClearAdaptiveClassifier = procedure(handle: TessBaseAPI); cdecl;

  TfnTessBaseAPISetImage = procedure(handle: TessBaseAPI; const imagedata: PByte;
    width: int; height: int; bytes_per_pixel: int; bytes_per_line: int); cdecl;
  TfnTessBaseAPISetImage2 = procedure(handle: TessBaseAPI; pix: PPix); cdecl;

  TfnTessBaseAPISetSourceResolution = procedure(handle: TessBaseAPI; ppi: int); cdecl;

  TfnTessBaseAPISetRectangle = procedure(handle: TessBaseAPI; left: int; top: int; width: int; height: int); cdecl;

  TfnTessBaseAPIGetThresholdedImage = function(handle: TessBaseAPI): PPix; cdecl;
  TfnTessBaseAPIGetRegions = function(handle: TessBaseAPI; var pixa: PPixa): PBoxa; cdecl;
  TfnTessBaseAPIGetTextlines = function(handle: TessBaseAPI; var pixa: PPixa; var blockids: Pint): PBoxa; cdecl;
  TfnTessBaseAPIGetTextlines1 = function(handle: TessBaseAPI; const raw_image: BOOL; const raw_padding: int;
    var pixa: PPixa; var blockids: Pint; var paraids: Pint): PBoxa; cdecl;
  TfnTessBaseAPIGetStrips = function(handle: TessBaseAPI; var pixa: PPixa; var blockids: Pint): PBoxa; cdecl;
  TfnTessBaseAPIGetWords = function(handle: TessBaseAPI; var pixa: PPixa): PBoxa; cdecl;
  TfnTessBaseAPIGetConnectedComponents = function(handle: TessBaseAPI; var cc: PPixa): PBoxa; cdecl;
  TfnTessBaseAPIGetComponentImages = function(handle: TessBaseAPI; const level: TessPageIteratorLevel;
    const text_only: BOOL; var pixa: PPixa; var blockids: Pint): PBoxa; cdecl;
  TfnTessBaseAPIGetComponentImages1 = function(handle: TessBaseAPI; const level: TessPageIteratorLevel;
    const text_only: BOOL; const raw_image: BOOL; const raw_padding: int;
    var pixa: PPixa; var blockids: Pint; var paraids: Pint): PBoxa; cdecl;

  TfnTessBaseAPIGetThresholdedImageScaleFactor = function(const handle: TessBaseAPI): int; cdecl;

  TfnTessBaseAPIAnalyseLayout = function(handle: TessBaseAPI): TessPageIterator; cdecl;

  TfnTessBaseAPIRecognize = function(handle: TessBaseAPI; var monitor: ETEXT_DESC): int; cdecl;
  TfnTessBaseAPIRecognizeForChopTest = function(handle: TessBaseAPI; var monitor: ETEXT_DESC): int; cdecl;
  TfnTessBaseAPIProcessPages = function(handle: TessBaseAPI; const filename: PUTF8Char;
    const retry_config: PUTF8Char; timeout_millisec: int; renderer: TessResultRenderer): BOOL; cdecl;
  TfnTessBaseAPIProcessPage = function(handle: TessBaseAPI; pix: PPix; page_index: int; const filename: PUTF8Char;
    const retry_config: PUTF8Char; timeout_millisec: int; renderer: TessResultRenderer): BOOL; cdecl;

  TfnTessBaseAPIGetIterator = function(handle: TessBaseAPI): TessResultIterator; cdecl;
  TfnTessBaseAPIGetMutableIterator = function(handle: TessBaseAPI): TessMutableIterator; cdecl;

  TfnTessBaseAPIGetUTF8Text = function(handle: TessBaseAPI): PUTF8Char; cdecl;
  TfnTessBaseAPIGetHOCRText = function(handle: TessBaseAPI; page_number: int): PUTF8Char; cdecl;
  TfnTessBaseAPIGetBoxText = function(handle: TessBaseAPI; page_number: int): PUTF8Char; cdecl;
  TfnTessBaseAPIGetUNLVText = function(handle: TessBaseAPI): PUTF8Char; cdecl;
  TfnTessBaseAPIMeanTextConf = function(handle: TessBaseAPI): int; cdecl;
  TfnTessBaseAPIAllWordConfidences = function(handle: TessBaseAPI): Pint; cdecl;
  TfnTessBaseAPIAdaptToWordStr = function(handle: TessBaseAPI; mode: TessPageSegMode; const wordstr: PUTF8Char): BOOL; cdecl;

  TfnTessBaseAPIClear = procedure(handle: TessBaseAPI); cdecl;
  TfnTessBaseAPIEnd = procedure(handle: TessBaseAPI); cdecl;

  TfnTessBaseAPIIsValidWord = function(handle: TessBaseAPI; const word: PUTF8Char): int; cdecl;
  TfnTessBaseAPIGetTextDirection = function(handle: TessBaseAPI; var out_offset: int; var out_slope: float): BOOL; cdecl;

  TfnTessBaseAPIGetUnichar = function(handle: TessBaseAPI; unichar_id: int): PUTF8Char; cdecl;

  TfnTessBaseAPISetMinOrientationMargin = procedure(handle: TessBaseAPI; margin: double); cdecl;

  // Page iterator
  TfnTessPageIteratorDelete = procedure(handle: TessBaseAPI); cdecl;
  TfnTessPageIteratorCopy = function(const handle: TessBaseAPI): TessPageIterator; cdecl;

  TfnTessPageIteratorBegin = procedure(handle: TessPageIterator); cdecl;
  TfnTessPageIteratorNext = function(handle: TessPageIterator; level: TessPageIteratorLevel): BOOL; cdecl;
  TfnTessPageIteratorIsAtBeginningOf = function(const handle: TessPageIterator; level: TessPageIteratorLevel): BOOL; cdecl;
  TfnTessPageIteratorIsAtFinalElement = function(const handle: TessPageIterator; level: TessPageIteratorLevel;
    element: TessPageIteratorLevel): BOOL; cdecl;

  TfnTessPageIteratorBoundingBox = function(const handle: TessPageIterator; level: TessPageIteratorLevel;
    out left: int; out top: int; out right: int; out bottom: int): BOOL; cdecl;

  TfnTessPageIteratorBlockType = function(const handle: TessPageIterator): TessPolyBlockType; cdecl;

  TfnTessPageIteratorGetBinaryImage = function(const handle: TessPageIterator; level: TessPageIteratorLevel): PPix; cdecl;
  TfnTessPageIteratorGetImage = function(const handle: TessPageIterator; level: TessPageIteratorLevel;
    padding: int; original_image: PPix; var left: int; var top: int): PPix; cdecl;

  TfnTessPageIteratorBaseline = function(const handle: TessPageIterator; level: TessPageIteratorLevel;
    out x1: int; out y1: int; out x2: int; out y2: int): BOOL; cdecl;

  TfnTessPageIteratorOrientation = procedure(handle: TessPageIterator; out orientation: TessOrientation;
    out writing_direction: TessWritingDirection; out textline_order: TessTextlineOrder;
    out deskew_angle: float); cdecl;

  TfnTessPageIteratorParagraphInfo = procedure(handle: TessPageIterator; out justification: TessParagraphJustification;
    out is_list_item: BOOL; out is_crown: BOOL; out first_line_indent: int); cdecl;

  // Result iterator
  TfnTessResultIteratorDelete = procedure(handle: TessResultIterator); cdecl;
  TfnTessResultIteratorCopy = function(const handle: TessResultIterator): TessResultIterator; cdecl;
  TfnTessResultIteratorGetPageIterator = function(const handle: TessResultIterator): TessPageIterator; cdecl;
  TfnTessResultIteratorGetPageIteratorConst = function(const handle: TessResultIterator): TessPageIterator; cdecl;
  TfnTessResultIteratorGetChoiceIterator = function(const handle: TessResultIterator): TessChoiceIterator; cdecl;

  TfnTessResultIteratorNext = function(handle: TessResultIterator; level: TessPageIteratorLevel): BOOL; cdecl;
  TfnTessResultIteratorGetUTF8Text = function(const handle: TessResultIterator; level: TessPageIteratorLevel): PUTF8Char; cdecl;
  TfnTessResultIteratorConfidence = function(const handle: TessResultIterator; level: TessPageIteratorLevel): float; cdecl;
  TfnTessResultIteratorWordRecognitionLanguage = function(const handle: TessResultIterator): PUTF8Char; cdecl;
  TfnTessResultIteratorWordFontAttributes = function(const handle: TessResultIterator;
    out is_bold: BOOL; out is_italic: BOOL;
    out is_underlined: BOOL; out is_monospace: BOOL; out is_serif: BOOL;
    out is_smallcaps: BOOL; out pointsize: int; out font_id: int): PUTF8Char; cdecl;

  TfnTessResultIteratorWordIsFromDictionary = function(const handle: TessResultIterator): BOOL; cdecl;
  TfnTessResultIteratorWordIsNumeric = function(const handle: TessResultIterator): BOOL; cdecl;
  TfnTessResultIteratorSymbolIsSuperscript = function(const handle: TessResultIterator): BOOL; cdecl;
  TfnTessResultIteratorSymbolIsSubscript = function(const handle: TessResultIterator): BOOL; cdecl;
  TfnTessResultIteratorSymbolIsDropcap = function(const handle: TessResultIterator): BOOL; cdecl;

  TfnTessChoiceIteratorDelete = procedure(handle: TessChoiceIterator); cdecl;
  TfnTessChoiceIteratorNext = function(handle: TessChoiceIterator): BOOL; cdecl;
  TfnTessChoiceIteratorGetUTF8Text = function(const handle: TessChoiceIterator): PUTF8Char; cdecl;
  TfnTessChoiceIteratorConfidence = function(const handle: TessChoiceIterator): float; cdecl;

var
  // General free functions
  TessVersion: TfnTessVersion;
  TessDeleteText: TfnTessDeleteText;
  TessDeleteTextArray: TfnTessDeleteTextArray;
  TessDeleteIntArray: TfnTessDeleteIntArray;
  // Renderer API
  TessTextRendererCreate: TfnTessTextRendererCreate;
  TessHOcrRendererCreate: TfnTessHOcrRendererCreate;
  TessHOcrRendererCreate2: TfnTessHOcrRendererCreate2;
  TessPDFRendererCreate: TfnTessPDFRendererCreate;
  TessUnlvRendererCreate: TfnTessUnlvRendererCreate;
  TessBoxTextRendererCreate: TfnTessBoxTextRendererCreate;
  TessDeleteResultRenderer: TfnTessDeleteResultRenderer;
  TessResultRendererInsert: TfnTessResultRendererInsert;
  TessResultRendererNext: TfnTessResultRendererNext;
  TessResultRendererBeginDocument: TfnTessResultRendererBeginDocument;
  TessResultRendererAddImage: TfnTessResultRendererAddImage;
  TessResultRendererEndDocument: TfnTessResultRendererEndDocument;
  TessResultRendererExtention: TfnTessResultRendererExtention;
  TessResultRendererTitle: TfnTessResultRendererTitle;
  TessResultRendererImageNum: TfnTessResultRendererImageNum;
  // Base API
  TessBaseAPICreate: TfnTessBaseAPICreate;
  TessBaseAPIDelete: TfnTessBaseAPIDelete;
  TessBaseAPIGetOpenCLDevice: TfnTessBaseAPIGetOpenCLDevice;
  TessBaseAPISetInputName: TfnTessBaseAPISetInputName;
  TessBaseAPIGetInputName: TfnTessBaseAPIGetInputName;
  TessBaseAPISetInputImage: TfnTessBaseAPISetInputImage;
  TessBaseAPIGetInputImage: TfnTessBaseAPIGetInputImage;
  TessBaseAPIGetSourceYResolution: TfnTessBaseAPIGetSourceYResolution;
  TessBaseAPIGetDatapath: TfnTessBaseAPIGetDatapath;
  TessBaseAPISetOutputName: TfnTessBaseAPISetOutputName;
  TessBaseAPISetVariable: TfnTessBaseAPISetVariable;
  TessBaseAPISetDebugVariable: TfnTessBaseAPISetDebugVariable;
  TessBaseAPIGetIntVariable: TfnTessBaseAPIGetIntVariable;
  TessBaseAPIGetBoolVariable: TfnTessBaseAPIGetBoolVariable;
  TessBaseAPIGetDoubleVariable: TfnTessBaseAPIGetDoubleVariable;
  TessBaseAPIGetStringVariable: TfnTessBaseAPIGetStringVariable;
  TessBaseAPIPrintVariables: TfnTessBaseAPIPrintVariables;
  TessBaseAPIPrintVariablesToFile: TfnTessBaseAPIPrintVariablesToFile;
  TessBaseAPIInit1: TfnTessBaseAPIInit1;
  TessBaseAPIInit2: TfnTessBaseAPIInit2;
  TessBaseAPIInit3: TfnTessBaseAPIInit3;
  TessBaseAPIInit4: TfnTessBaseAPIInit4;
  TessBaseAPIGetInitLanguagesAsString: TfnTessBaseAPIGetInitLanguagesAsString;
  TessBaseAPIGetLoadedLanguagesAsVector: TfnTessBaseAPIGetLoadedLanguagesAsVector;
  TessBaseAPIGetAvailableLanguagesAsVector: TfnTessBaseAPIGetAvailableLanguagesAsVector;
  TessBaseAPIInitLangMod: TfnTessBaseAPIInitLangMod;
  TessBaseAPIInitForAnalysePage: TfnTessBaseAPIInitForAnalysePage;
  TessBaseAPIReadConfigFile: TfnTessBaseAPIReadConfigFile;
  TessBaseAPIReadDebugConfigFile: TfnTessBaseAPIReadDebugConfigFile;
  TessBaseAPISetPageSegMode: TfnTessBaseAPISetPageSegMode;
  TessBaseAPIGetPageSegMode: TfnTessBaseAPIGetPageSegMode;
  TessBaseAPIRect: TfnTessBaseAPIRect;
  TessBaseAPIClearAdaptiveClassifier: TfnTessBaseAPIClearAdaptiveClassifier;
  TessBaseAPISetImage: TfnTessBaseAPISetImage;
  TessBaseAPISetImage2: TfnTessBaseAPISetImage2;
  TessBaseAPISetSourceResolution: TfnTessBaseAPISetSourceResolution;
  TessBaseAPISetRectangle: TfnTessBaseAPISetRectangle;
  TessBaseAPIGetThresholdedImage: TfnTessBaseAPIGetThresholdedImage;
  TessBaseAPIGetRegions: TfnTessBaseAPIGetRegions;
  TessBaseAPIGetTextlines: TfnTessBaseAPIGetTextlines;
  TessBaseAPIGetTextlines1: TfnTessBaseAPIGetTextlines1;
  TessBaseAPIGetStrips: TfnTessBaseAPIGetStrips;
  TessBaseAPIGetWords: TfnTessBaseAPIGetWords;
  TessBaseAPIGetConnectedComponents: TfnTessBaseAPIGetConnectedComponents;
  TessBaseAPIGetComponentImages: TfnTessBaseAPIGetComponentImages;
  TessBaseAPIGetComponentImages1: TfnTessBaseAPIGetComponentImages1;
  TessBaseAPIGetThresholdedImageScaleFactor: TfnTessBaseAPIGetThresholdedImageScaleFactor;
  TessBaseAPIAnalyseLayout: TfnTessBaseAPIAnalyseLayout;
  TessBaseAPIRecognize: TfnTessBaseAPIRecognize;
  TessBaseAPIRecognizeForChopTest: TfnTessBaseAPIRecognizeForChopTest;
  TessBaseAPIProcessPages: TfnTessBaseAPIProcessPages;
  TessBaseAPIProcessPage: TfnTessBaseAPIProcessPage;
  TessBaseAPIGetIterator: TfnTessBaseAPIGetIterator;
  TessBaseAPIGetMutableIterator: TfnTessBaseAPIGetMutableIterator;
  TessBaseAPIGetUTF8Text: TfnTessBaseAPIGetUTF8Text;
  TessBaseAPIGetHOCRText: TfnTessBaseAPIGetHOCRText;
  TessBaseAPIGetBoxText: TfnTessBaseAPIGetBoxText;
  TessBaseAPIGetUNLVText: TfnTessBaseAPIGetUNLVText;
  TessBaseAPIMeanTextConf: TfnTessBaseAPIMeanTextConf;
  TessBaseAPIAllWordConfidences: TfnTessBaseAPIAllWordConfidences;
  TessBaseAPIAdaptToWordStr: TfnTessBaseAPIAdaptToWordStr;
  TessBaseAPIClear: TfnTessBaseAPIClear;
  TessBaseAPIEnd: TfnTessBaseAPIEnd;
  TessBaseAPIIsValidWord: TfnTessBaseAPIIsValidWord;
  TessBaseAPIGetTextDirection: TfnTessBaseAPIGetTextDirection;
  TessBaseAPIGetUnichar: TfnTessBaseAPIGetUnichar;
  TessBaseAPISetMinOrientationMargin: TfnTessBaseAPISetMinOrientationMargin;
  // Page iterator
  TessPageIteratorDelete: TfnTessPageIteratorDelete;
  TessPageIteratorCopy: TfnTessPageIteratorCopy;
  TessPageIteratorBegin: TfnTessPageIteratorBegin;
  TessPageIteratorNext: TfnTessPageIteratorNext;
  TessPageIteratorIsAtBeginningOf: TfnTessPageIteratorIsAtBeginningOf;
  TessPageIteratorIsAtFinalElement: TfnTessPageIteratorIsAtFinalElement;
  TessPageIteratorBoundingBox: TfnTessPageIteratorBoundingBox;
  TessPageIteratorBlockType: TfnTessPageIteratorBlockType;
  TessPageIteratorGetBinaryImage: TfnTessPageIteratorGetBinaryImage;
  TessPageIteratorGetImage: TfnTessPageIteratorGetBinaryImage;
  TessPageIteratorBaseline: TfnTessPageIteratorBaseline;
  TessPageIteratorOrientation: TfnTessPageIteratorOrientation;
  TessPageIteratorParagraphInfo: TfnTessPageIteratorParagraphInfo;
  // Result iterator
  TessResultIteratorDelete: TfnTessResultIteratorDelete;
  TessResultIteratorCopy: TfnTessResultIteratorCopy;
  TessResultIteratorGetPageIterator: TfnTessResultIteratorGetPageIterator;
  TessResultIteratorGetPageIteratorConst: TfnTessResultIteratorGetPageIteratorConst;
  TessResultIteratorGetChoiceIterator: TfnTessResultIteratorGetChoiceIterator;
  TessResultIteratorNext: TfnTessResultIteratorNext;
  TessResultIteratorGetUTF8Text: TfnTessResultIteratorGetUTF8Text;
  TessResultIteratorConfidence: TfnTessResultIteratorConfidence;
  TessResultIteratorWordRecognitionLanguage: TfnTessResultIteratorWordRecognitionLanguage;
  TessResultIteratorWordFontAttributes: TfnTessResultIteratorWordFontAttributes;
  TessResultIteratorWordIsFromDictionary: TfnTessResultIteratorWordIsFromDictionary;
  TessResultIteratorWordIsNumeric: TfnTessResultIteratorWordIsNumeric;
  TessResultIteratorSymbolIsSuperscript: TfnTessResultIteratorSymbolIsSuperscript;
  TessResultIteratorSymbolIsSubscript: TfnTessResultIteratorSymbolIsSubscript;
  TessResultIteratorSymbolIsDropcap: TfnTessResultIteratorSymbolIsDropcap;
  TessChoiceIteratorDelete: TfnTessChoiceIteratorDelete;
  TessChoiceIteratorNext: TfnTessChoiceIteratorNext;
  TessChoiceIteratorGetUTF8Text: TfnTessChoiceIteratorGetUTF8Text;
  TessChoiceIteratorConfidence: TfnTessChoiceIteratorConfidence;

var
  hTesseractLib: THandle;

implementation
uses
  {$IFNDEF FPC}Winapi.Windows, System.SysUtils{$ELSE}dynlibs, SysUtils{$ENDIF};

procedure FreeTesseractLib;
begin
  if (hTesseractLib <> 0) then
  begin
    FreeLibrary(hTesseractLib);
    hTesseractLib := 0;
  end;
end;

function InitTesseractLib: Boolean;
VAR
  FULL_LIB_PATH : ansistring;
  PATH_OF_DLL : ansistring;

  function GetTesseractProcAddress(var AProcPtr: Pointer; AProcName: AnsiString): Boolean;
  begin
    AProcPtr := GetProcAddress(hTesseractLib, {$IFDEF FPC}AProcName{$ELSE}PAnsiChar(AProcName){$ENDIF});
    Result := Assigned(AProcPtr);
    if not Result then
      raise Exception.Create('Error while loading Tesseract function: ' + String(AProcName));
  end;

  // Calls GetModuleFileName which is used to call the path of a calling DLL
  // as opposed to the parent application that called the DLL (for which Application.ExeName is used)
  function GetModuleName : ansistring;
  var
    szDLLName: array[0..MAX_PATH] of Char;
  begin
    FillChar(szDLLName, SizeOf(szDLLName), #0);
    GetModuleFileName(hInstance, szDLLName, MAX_PATH);
    Result := szDLLName;
  end;

begin
  Result := False;

  if (hTesseractLib = 0) then
  begin
    // Returns the path and filename of the DLL itself
    PATH_OF_DLL := GetModuleName;
    // Now strip out the DLL name, leaving the path, and append the libtesseract filename to it
    FULL_LIB_PATH := ExtractFilePath(PATH_OF_DLL) + libtesseract;
    // Now check the libtesseract library exists
    if FileExists(FULL_LIB_PATH) then
    begin
      // and load it
      hTesseractLib := LoadLibraryA(PAnsiChar(FULL_LIB_PATH));
      if (hTesseractLib <> 0) then
      begin
        GetProcAddress(hTesseractLib, 'pixCreate');          // Leptonica - Added this to adhere to libTesseract library
        GetProcAddress(hTesseractLib, 'ZSTD_versionNumber'); // ZSTD      - Added this to adhere to libTesseract library

        // The following are default for the TTesseractOCR4 calling routines but still work fine with libTesseract too
        GetTesseractProcAddress(Pointer(TessVersion)                     , 'TessVersion');
        GetTesseractProcAddress(Pointer(TessDeleteText)                  , 'TessDeleteText');
        GetTesseractProcAddress(Pointer(TessDeleteTextArray)             , 'TessDeleteTextArray');
        GetTesseractProcAddress(Pointer(TessDeleteIntArray)              , 'TessDeleteIntArray');
        GetTesseractProcAddress(Pointer(TessTextRendererCreate)          , 'TessTextRendererCreate');
        GetTesseractProcAddress(Pointer(TessHOcrRendererCreate)          , 'TessHOcrRendererCreate');
        GetTesseractProcAddress(Pointer(TessHOcrRendererCreate2)         , 'TessHOcrRendererCreate2');
        GetTesseractProcAddress(Pointer(TessPDFRendererCreate)           , 'TessPDFRendererCreate');
        GetTesseractProcAddress(Pointer(TessUnlvRendererCreate)          , 'TessUnlvRendererCreate');
        GetTesseractProcAddress(Pointer(TessBoxTextRendererCreate)       , 'TessBoxTextRendererCreate');
        GetTesseractProcAddress(Pointer(TessDeleteResultRenderer)        , 'TessDeleteResultRenderer');
        GetTesseractProcAddress(Pointer(TessResultRendererInsert)        , 'TessResultRendererInsert');
        GetTesseractProcAddress(Pointer(TessResultRendererNext)          , 'TessResultRendererNext');
        GetTesseractProcAddress(Pointer(TessResultRendererBeginDocument) , 'TessResultRendererBeginDocument');
        GetTesseractProcAddress(Pointer(TessResultRendererAddImage)      , 'TessResultRendererAddImage');
        GetTesseractProcAddress(Pointer(TessResultRendererEndDocument)   , 'TessResultRendererEndDocument');
        GetTesseractProcAddress(Pointer(TessResultRendererExtention)     , 'TessResultRendererExtention');
        GetTesseractProcAddress(Pointer(TessResultRendererTitle)         , 'TessResultRendererTitle');
        GetTesseractProcAddress(Pointer(TessResultRendererImageNum)      , 'TessResultRendererImageNum');
        GetTesseractProcAddress(Pointer(TessBaseAPICreate)               , 'TessBaseAPICreate');
        GetTesseractProcAddress(Pointer(TessBaseAPIDelete)               , 'TessBaseAPIDelete');
        GetTesseractProcAddress(Pointer(TessBaseAPIGetOpenCLDevice)      , 'TessBaseAPIGetOpenCLDevice');
        GetTesseractProcAddress(Pointer(TessBaseAPISetInputName)         , 'TessBaseAPISetInputName');
        GetTesseractProcAddress(Pointer(TessBaseAPIGetInputName)         , 'TessBaseAPIGetInputName');
        GetTesseractProcAddress(Pointer(TessBaseAPISetInputImage)        , 'TessBaseAPISetInputImage');
        GetTesseractProcAddress(Pointer(TessBaseAPIGetInputImage)        , 'TessBaseAPIGetInputImage');
        GetTesseractProcAddress(Pointer(TessBaseAPIGetSourceYResolution) , 'TessBaseAPIGetSourceYResolution');
        GetTesseractProcAddress(Pointer(TessBaseAPIGetDatapath)          , 'TessBaseAPIGetDatapath');
        GetTesseractProcAddress(Pointer(TessBaseAPISetOutputName)        , 'TessBaseAPISetOutputName');
        GetTesseractProcAddress(Pointer(TessBaseAPISetVariable)          , 'TessBaseAPISetVariable');
        GetTesseractProcAddress(Pointer(TessBaseAPISetDebugVariable)     , 'TessBaseAPISetDebugVariable');
        GetTesseractProcAddress(Pointer(TessBaseAPIGetIntVariable)       , 'TessBaseAPIGetIntVariable');
        GetTesseractProcAddress(Pointer(TessBaseAPIGetBoolVariable)      , 'TessBaseAPIGetBoolVariable');
        GetTesseractProcAddress(Pointer(TessBaseAPIGetDoubleVariable)    , 'TessBaseAPIGetDoubleVariable');
        GetTesseractProcAddress(Pointer(TessBaseAPIGetStringVariable)    , 'TessBaseAPIGetStringVariable');
        GetTesseractProcAddress(Pointer(TessBaseAPIPrintVariables)       , 'TessBaseAPIPrintVariables');
        GetTesseractProcAddress(Pointer(TessBaseAPIPrintVariablesToFile) , 'TessBaseAPIPrintVariablesToFile');
        GetTesseractProcAddress(Pointer(TessBaseAPIInit1)                , 'TessBaseAPIInit1');
        GetTesseractProcAddress(Pointer(TessBaseAPIInit2)                , 'TessBaseAPIInit2');
        GetTesseractProcAddress(Pointer(TessBaseAPIInit3)                , 'TessBaseAPIInit3');
        GetTesseractProcAddress(Pointer(TessBaseAPIInit4)                , 'TessBaseAPIInit4');
        GetTesseractProcAddress(Pointer(TessBaseAPIGetInitLanguagesAsString)      , 'TessBaseAPIGetInitLanguagesAsString');
        GetTesseractProcAddress(Pointer(TessBaseAPIGetLoadedLanguagesAsVector)    , 'TessBaseAPIGetLoadedLanguagesAsVector');
        GetTesseractProcAddress(Pointer(TessBaseAPIGetAvailableLanguagesAsVector) , 'TessBaseAPIGetAvailableLanguagesAsVector');
        GetTesseractProcAddress(Pointer(TessBaseAPIInitLangMod)                   , 'TessBaseAPIInitLangMod');
        GetTesseractProcAddress(Pointer(TessBaseAPIInitForAnalysePage)            , 'TessBaseAPIInitForAnalysePage');
        GetTesseractProcAddress(Pointer(TessBaseAPIReadConfigFile)                , 'TessBaseAPIReadConfigFile');
        GetTesseractProcAddress(Pointer(TessBaseAPIReadDebugConfigFile)           , 'TessBaseAPIReadDebugConfigFile');
        GetTesseractProcAddress(Pointer(TessBaseAPISetPageSegMode)                , 'TessBaseAPISetPageSegMode');
        GetTesseractProcAddress(Pointer(TessBaseAPIGetPageSegMode)                , 'TessBaseAPIGetPageSegMode');
        GetTesseractProcAddress(Pointer(TessBaseAPIRect)                          , 'TessBaseAPIRect');
        GetTesseractProcAddress(Pointer(TessBaseAPIClearAdaptiveClassifier)       , 'TessBaseAPIClearAdaptiveClassifier');
        GetTesseractProcAddress(Pointer(TessBaseAPISetImage)                      , 'TessBaseAPISetImage');
        GetTesseractProcAddress(Pointer(TessBaseAPISetImage2)                     , 'TessBaseAPISetImage2');
        GetTesseractProcAddress(Pointer(TessBaseAPISetSourceResolution)           , 'TessBaseAPISetSourceResolution');
        GetTesseractProcAddress(Pointer(TessBaseAPISetRectangle)                  , 'TessBaseAPISetRectangle');
        GetTesseractProcAddress(Pointer(TessBaseAPIGetThresholdedImage)           , 'TessBaseAPIGetThresholdedImage');
        GetTesseractProcAddress(Pointer(TessBaseAPIGetRegions)                    , 'TessBaseAPIGetRegions');
        GetTesseractProcAddress(Pointer(TessBaseAPIGetTextlines)                  , 'TessBaseAPIGetTextlines');
        GetTesseractProcAddress(Pointer(TessBaseAPIGetTextlines1)                 , 'TessBaseAPIGetTextlines1');
        GetTesseractProcAddress(Pointer(TessBaseAPIGetStrips)                     , 'TessBaseAPIGetStrips');
        GetTesseractProcAddress(Pointer(TessBaseAPIGetWords)                      , 'TessBaseAPIGetWords');
        GetTesseractProcAddress(Pointer(TessBaseAPIGetConnectedComponents)        , 'TessBaseAPIGetConnectedComponents');
        GetTesseractProcAddress(Pointer(TessBaseAPIGetComponentImages)            , 'TessBaseAPIGetComponentImages');
        GetTesseractProcAddress(Pointer(TessBaseAPIGetComponentImages1)           , 'TessBaseAPIGetComponentImages1');
        GetTesseractProcAddress(Pointer(TessBaseAPIGetThresholdedImageScaleFactor), 'TessBaseAPIGetThresholdedImageScaleFactor');
        GetTesseractProcAddress(Pointer(TessBaseAPIAnalyseLayout)                 , 'TessBaseAPIAnalyseLayout');
        GetTesseractProcAddress(Pointer(TessBaseAPIRecognize)                     , 'TessBaseAPIRecognize');
        // GetTesseractProcAddress(Pointer(TessBaseAPIRecognizeForChopTest), 'TessBaseAPIRecognizeForChopTest'); // No longer exists
        GetTesseractProcAddress(Pointer(TessBaseAPIProcessPages)                  , 'TessBaseAPIProcessPages');
        GetTesseractProcAddress(Pointer(TessBaseAPIProcessPage)                   , 'TessBaseAPIProcessPage');
        GetTesseractProcAddress(Pointer(TessBaseAPIGetIterator)                   , 'TessBaseAPIGetIterator');
        GetTesseractProcAddress(Pointer(TessBaseAPIGetMutableIterator)            , 'TessBaseAPIGetMutableIterator');
        GetTesseractProcAddress(Pointer(TessBaseAPIGetUTF8Text)                   , 'TessBaseAPIGetUTF8Text');
        GetTesseractProcAddress(Pointer(TessBaseAPIGetHOCRText)                   , 'TessBaseAPIGetHOCRText');
        GetTesseractProcAddress(Pointer(TessBaseAPIGetBoxText)                    , 'TessBaseAPIGetBoxText');
        GetTesseractProcAddress(Pointer(TessBaseAPIGetUNLVText)                   , 'TessBaseAPIGetUNLVText');
        GetTesseractProcAddress(Pointer(TessBaseAPIMeanTextConf)                  , 'TessBaseAPIMeanTextConf');
        GetTesseractProcAddress(Pointer(TessBaseAPIAllWordConfidences)            , 'TessBaseAPIAllWordConfidences');
        GetTesseractProcAddress(Pointer(TessBaseAPIAdaptToWordStr)                , 'TessBaseAPIAdaptToWordStr');
        GetTesseractProcAddress(Pointer(TessBaseAPIClear)                         , 'TessBaseAPIClear');
        GetTesseractProcAddress(Pointer(TessBaseAPIEnd)                           , 'TessBaseAPIEnd');
        GetTesseractProcAddress(Pointer(TessBaseAPIIsValidWord)                   , 'TessBaseAPIIsValidWord');
        GetTesseractProcAddress(Pointer(TessBaseAPIGetTextDirection)              , 'TessBaseAPIGetTextDirection');
        GetTesseractProcAddress(Pointer(TessBaseAPIGetUnichar)                    , 'TessBaseAPIGetUnichar');
        GetTesseractProcAddress(Pointer(TessBaseAPISetMinOrientationMargin)       , 'TessBaseAPISetMinOrientationMargin');
        GetTesseractProcAddress(Pointer(TessPageIteratorDelete)                   , 'TessPageIteratorDelete');
        GetTesseractProcAddress(Pointer(TessPageIteratorCopy)                     , 'TessPageIteratorCopy');
        GetTesseractProcAddress(Pointer(TessPageIteratorBegin)                    , 'TessPageIteratorBegin');
        GetTesseractProcAddress(Pointer(TessPageIteratorNext)                     , 'TessPageIteratorNext');
        GetTesseractProcAddress(Pointer(TessPageIteratorIsAtBeginningOf)          , 'TessPageIteratorIsAtBeginningOf');
        GetTesseractProcAddress(Pointer(TessPageIteratorIsAtFinalElement)         , 'TessPageIteratorIsAtFinalElement');
        GetTesseractProcAddress(Pointer(TessPageIteratorBoundingBox)              , 'TessPageIteratorBoundingBox');
        GetTesseractProcAddress(Pointer(TessPageIteratorBlockType)                , 'TessPageIteratorBlockType');
        GetTesseractProcAddress(Pointer(TessPageIteratorGetBinaryImage)           , 'TessPageIteratorGetBinaryImage');
        GetTesseractProcAddress(Pointer(TessPageIteratorGetImage)                 , 'TessPageIteratorGetImage');
        GetTesseractProcAddress(Pointer(TessPageIteratorBaseline)                 , 'TessPageIteratorBaseline');
        GetTesseractProcAddress(Pointer(TessPageIteratorOrientation)              , 'TessPageIteratorOrientation');
        GetTesseractProcAddress(Pointer(TessPageIteratorParagraphInfo)            , 'TessPageIteratorParagraphInfo');
        GetTesseractProcAddress(Pointer(TessResultIteratorDelete)                 , 'TessResultIteratorDelete');
        GetTesseractProcAddress(Pointer(TessResultIteratorCopy)                   , 'TessResultIteratorCopy');
        GetTesseractProcAddress(Pointer(TessResultIteratorGetPageIterator)        , 'TessResultIteratorGetPageIterator');
        GetTesseractProcAddress(Pointer(TessResultIteratorGetPageIteratorConst)   , 'TessResultIteratorGetPageIteratorConst');
        GetTesseractProcAddress(Pointer(TessResultIteratorGetChoiceIterator)      , 'TessResultIteratorGetChoiceIterator');
        GetTesseractProcAddress(Pointer(TessResultIteratorNext)                   , 'TessResultIteratorNext');
        GetTesseractProcAddress(Pointer(TessResultIteratorGetUTF8Text)            , 'TessResultIteratorGetUTF8Text');
        GetTesseractProcAddress(Pointer(TessResultIteratorConfidence)             , 'TessResultIteratorConfidence');
        GetTesseractProcAddress(Pointer(TessResultIteratorWordRecognitionLanguage), 'TessResultIteratorWordRecognitionLanguage');
        GetTesseractProcAddress(Pointer(TessResultIteratorWordFontAttributes)     , 'TessResultIteratorWordFontAttributes');
        GetTesseractProcAddress(Pointer(TessResultIteratorWordIsFromDictionary)   , 'TessResultIteratorWordIsFromDictionary');
        GetTesseractProcAddress(Pointer(TessResultIteratorWordIsNumeric)          , 'TessResultIteratorWordIsNumeric');
        GetTesseractProcAddress(Pointer(TessResultIteratorSymbolIsSuperscript)    , 'TessResultIteratorSymbolIsSuperscript');
        GetTesseractProcAddress(Pointer(TessResultIteratorSymbolIsSubscript)      , 'TessResultIteratorSymbolIsSubscript');
        GetTesseractProcAddress(Pointer(TessResultIteratorSymbolIsDropcap)        , 'TessResultIteratorSymbolIsDropcap');
        GetTesseractProcAddress(Pointer(TessChoiceIteratorDelete)                 , 'TessChoiceIteratorDelete');
        GetTesseractProcAddress(Pointer(TessChoiceIteratorNext)                   , 'TessChoiceIteratorNext');
        GetTesseractProcAddress(Pointer(TessChoiceIteratorGetUTF8Text)            , 'TessChoiceIteratorGetUTF8Text');
        GetTesseractProcAddress(Pointer(TessChoiceIteratorConfidence)             , 'TessChoiceIteratorConfidence');

        Result := True;
      end;
  end
    else Result := false;
  end;
end;

initialization
  InitTesseractLib;

finalization
  FreeTesseractLib;

end.
