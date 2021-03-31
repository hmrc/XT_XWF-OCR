unit XT_API;

{$MODE Delphi}

interface

uses Windows;

type
	TLicenseInfo=packed record
		nSize: DWord;
		nLicFlags: DWord;
		nUsers: DWord;
		nExpDate: TFILETIME;
		nLicID: array[0..15] of Byte;
	end;
	
	PRasterImageInfo=^TRasterImageInfo;
	TRasterImageInfo=packed record
		nSize: DWord;
		nItemID: LongInt;
		hItem: THandle;
		nFlags, nWidth, nHeight, nResSize: DWord;
	end;

	PSearchHitInfo=^TSearchHitInfo;
	TSearchHitInfo=packed record
		nSize: LongInt;
		nItemID: LongInt;
		nRelOfs, nAbsOfs: Int64;
		lpOptionalHitPtr: PAnsiChar;
		nSearchTermID, nLength, nCodePage, nFlags: Word;
		hOptionalItemOrVolume: THandle;
	end;

	PSearchInfo=^TSearchInfo;
	TSearchInfo=packed record
		nSize: LongInt;
		hVolume: THandle;
		lpSearchTerms: PWideChar;
		nFlags: DWord;
		nSearchWindow: DWord;
	end;

	PCodePages=^TCodePages;
	TCodePages=packed record
		nSize: LongInt;
		nCodePage: array[0..4] of Word;
	end;

	PPrepareSearchInfo=^TPrepareSearchInfo;
	TPrepareSearchInfo=packed record
		nSize: LongInt;
		lpSearchTerms: PWideChar;
		nBufLen: DWord;
		nFlags: DWord;
	end;

	PEventInfo=^TEventInfo;
	TEventInfo=packed record
		nSize: LongInt;
		hEvidence: THandle;
		nEvtType: DWord;
		nFlags: DWord;
		Timestamp: TFileTime;
		nItemID: Integer;
		nOfs: Int64;
		lpDescr: PAnsiChar;
	end;

	PDataSource=^TDataSource;
	TDataSource=packed record
	 nSize: DWord;
	 nDrive: LongInt;
	 nParentDrive: LongInt;
	 nBytesPerSector: DWord;
	 nSectorCount: Int64;
	 nParentSectorCount: Int64;
	 nStartSectorOnParent: Int64;
	 lpPrivate: Pointer;
	end;

        PSrcInfo=^TSrcInfo;
        TSrcInfo=packed record
          nStructSize : DWord;
          nBufSize : INT64;
          pBuffer : LPVOID;
        end;

type
	TXWF_GetSize = function (hVolumeOrItem: THandle; lpOptional: Pointer): Int64; stdcall;
        TXWF_GetProp = function (hVolumeOrItem: THandle; nPropType : DWORD; lpBuffer : PVOID) : Int64; stdcall;
	TXWF_GetVolumeName = procedure (hVolume: THandle; lpString: PWideChar; nType: DWord); stdcall;
	TXWF_GetVolumeInformation = procedure (hVolume: THandle; nFileSystem: PLongInt; nBytesPerSector, nSectorsPerCluster: PDWord; nClusterCount, nFirstClusterSectorNo: PInt64); stdcall;
	TXWF_GetBlock = function (hVolumeOrItem: THandle; lpStartOfs, lpEndOfs: PInt64): BOOL; stdcall;
	TXWF_SetBlock = function (hVolumeOrItem: THandle; nStartOfs, nEndOfs: Int64): BOOL; stdcall;
	TXWF_GetSectorContents = function (hVolume: THandle; nSectorNo: Int64; lpDescr: PWideChar; lpItemID: PLongInt): BOOL; stdcall;
	TXWF_OpenItem = function (hVolume: THandle; nItemID: LongInt; nFlags: DWord): THandle; stdcall;
	TXWF_Close = procedure (hVolumeOrItem: THandle); stdcall;
	TXWF_Read = function (hVolumeOrItem: THandle; Ofs: Int64; lpBuffer: PAnsiChar; nNumberOfBytesToRead: DWord): DWord; stdcall;
	TXWF_SectorIO = function (nDrive: LongInt; nSector: Int64; nCount: DWord; lpBuffer: Pointer; nFlags: PDWord): DWord; stdcall;

	TXWF_SelectVolumeSnapshot = procedure (hVolume: THandle); stdcall;
	TXWF_GetVSProp = function (nPropType: LongInt; pBuffer: Pointer): Int64; stdcall;
	TXWF_GetItemCount = function (pReserved: Pointer): DWord; stdcall;
	TXWF_GetFileCount = function (nDirID: LongInt): DWord; stdcall;

	TXWF_CreateItem = function (lpName: PWideChar; Flags: DWord): LongInt; stdcall;
	TXWF_CreateFile = function (lpName: PWideChar; Flags: DWord; nParentItemID: LongInt; pSourceInfo: Pointer): LongInt; stdcall;
	TXWF_GetItemName = function (nItemID: LongInt): PWideChar; stdcall;
	TXWF_GetItemSize = function (nItemID: LongInt): Int64; stdcall;
	TXWF_SetItemSize = procedure (nItemID: LongInt; Size: Int64); stdcall;
	TXWF_GetItemOfs = procedure (nItemID: LongInt; var DefOfs, StartSector: Int64); stdcall;
	TXWF_SetItemOfs = procedure (nItemID: LongInt; nDefOfs, nStartSector: Int64); stdcall;
	TXWF_GetItemTimeStamps = procedure (nItemID: LongInt; lpCreationTime, lpModificationTime, lpLastAccessTime, lpEntryModificationTime, lpDeletionTime, lpInternalCreationTime: PFileTime); stdcall;
	TXWF_SetItemTimeStamps = procedure (nItemID: LongInt; lpCreationTime, lpModificationTime, lpLastAccessTime, lpEntryModificationTime, lpDeletionTime, lpInternalCreationTime: PFileTime); stdcall;
	TXWF_GetItemInformation = function (nItemID: LongInt; nInfoType: LongInt; lpSuccess: PBOOL): Int64; stdcall;
	TXWF_SetItemInformation = function (nItemID: LongInt; nInfoType: LongInt; nInfoValue: Int64): BOOL; stdcall;
	TXWF_GetItemType = function (nItemID: LongInt; lpTypeDescr: PWideChar; nBufferLenAndFlags: DWord): LongInt; stdcall;
	TXWF_SetItemType = procedure (nItemID: LongInt; lpTypeDescr: PWideChar; nTypeStatus: LongInt); stdcall;
	TXWF_GetItemParent = function (nItemID: LongInt): LongInt; stdcall;
	TXWF_SetItemParent = procedure (nChildItemID: LongInt; nParentItemID: LongInt); stdcall;
	TXWF_GetReportTableAssocs = function (nItemID: LongInt; lpBuffer: PWideChar; nBufferLen: LongInt): DWord; stdcall;
	TXWF_AddToReportTable = function (nItemID: LongInt; lpReportTableName: PWideChar; nFlags: DWord): LongInt; stdcall;
	TXWF_GetComment = function (nItemID: LongInt): PWideChar; stdcall;
	TXWF_AddComment = function (nItemID: LongInt; lpComment: PWideChar; nHowToAdd: DWord): BOOL; stdcall;
	TXWF_GetExtractedMetadata = function (nItemID: LongInt): PWideChar; stdcall;
	TXWF_AddExtractedMetadata = function (nItemID: LongInt; lpComment: PWideChar; nHowToAdd: DWord): BOOL; stdcall;
	TXWF_GetHashValue = function (nItemID: LongInt; lpBuffer: Pointer): BOOL; stdcall;

	TXWF_GetMetadata = function (nItemID: LongInt; hItem: THandle): PWideChar; stdcall;
	TXWF_GetMetadataEx = function (hItem: THandle; var nFlags: DWord): PAnsiChar; stdcall;
	TXWF_GetRasterImage = function (RII: PRasterImageInfo): Pointer; stdcall;

	TXWF_CreateContainer = function (lpFileName: PWideChar; nFlags: DWord; pReserved: Pointer): THandle; stdcall;
	TXWF_CloseContainer = function (hContainer: THandle; pReserved: Pointer): LongInt; stdcall;
	TXWF_CopyToContainer = function (CtrHdl: THandle; hItem: THandle; nFlags, nMode: DWord; nStartOfs, nEndOfs: Int64; pReserved: Pointer): LongInt; stdcall;

	TXWF_GetCaseProp = function (pReserved: Pointer; nPropType: LongInt; pBuffer: PWideChar; nBufSize: LongInt): Int64; stdcall;
	TXWF_CreateEvObj = function (nType: DWord; nDiskID: LongInt; lpPath: PWideChar; pReserved: Pointer): THandle; stdcall;
	TXWF_GetFirstEvObj = function (pReserved: Pointer): THandle; stdcall;
	TXWF_GetNextEvObj = function (hPrevEvidence: THandle; pReserved: Pointer): THandle; stdcall;
	TXWF_OpenEvObj = function (hEvidence: THandle; nFlags: DWord): THandle; stdcall;
	TXWF_CloseEvObj = procedure (hEvidence: THandle); stdcall;
	TXWF_GetEvObjProp = function (hEvidence: THandle; nPropType: DWord; pBuffer: Pointer): Int64; stdcall;
	TXWF_GetEvObj = function (nEvObjID: DWord): THandle; stdcall;
	TXWF_GetReportTableInfo = function (pReserved: Pointer; nReportTableID, nOptional: LongInt): Pointer; stdcall;
	TXWF_GetEvObjReportTableAssocs = function (hEvidence: THandle; nFlags: LongInt; lpValue: PLongInt): Pointer; stdcall;

	TXWF_Search = function (SearchInfo: PSearchInfo; CodePages: PCodePages): LongInt; stdcall;
	TXWF_GetSearchTerm = function (nSearchTermID: LongInt; lpReserved: Pointer): PWideChar; stdcall;
	TXWF_AddSearchTerm = function (lpSearchTermName: PWideChar; nFlags: DWord): LongInt; stdcall;
	TXWF_AddEvent = function (EvtInfo: PEventInfo): LongInt; stdcall;
	TXWF_GetEvent = function (EventNo: DWord; EvtInfo: PEventInfo): DWord; stdcall;

	TXWF_OutputMessage = procedure (lpMessage: PWideChar; nFlags: DWord); stdcall;
        TXWF_GetUserInput = function (lpMessage, lpBuffer: PWideChar; nBufferLen, nFlags: DWord): Int64; stdcall;
	TXWF_ShowProgress = procedure (lpCaption: PWideChar; nFlags: DWord); stdcall;
	TXWF_SetProgressPercentage = procedure (nPercent: DWord); stdcall;
	TXWF_SetProgressDescription = procedure (lpStr: PWideChar); stdcall;
	TXWF_ShouldStop = function: BOOL; stdcall;
	TXWF_HideProgress = procedure; stdcall;
	TXWF_ReleaseMem = function (MemP: PAnsiChar): BOOL; stdcall;

var
	XWF_GetSize: TXWF_GetSize;
        XWF_GetProp: TXWF_GetProp;
	XWF_GetVolumeName: TXWF_GetVolumeName;
	XWF_GetVolumeInformation: TXWF_GetVolumeInformation;
	XWF_GetBlock: TXWF_GetBlock;
	XWF_SetBlock: TXWF_SetBlock;

	XWF_GetSectorContents: TXWF_GetSectorContents;
	XWF_OpenItem: TXWF_OpenItem;
	XWF_Close: TXWF_Close;
	XWF_Read: TXWF_Read;
	XWF_SectorIO: TXWF_SectorIO;

	XWF_SelectVolumeSnapshot: TXWF_SelectVolumeSnapshot;
	XWF_GetVSProp: TXWF_GetVSProp;
	XWF_GetItemCount: TXWF_GetItemCount;
	XWF_GetFileCount: TXWF_GetFileCount;

	XWF_CreateItem: TXWF_CreateItem;
	XWF_CreateFile: TXWF_CreateFile;
	XWF_GetItemName: TXWF_GetItemName;
	XWF_GetItemSize: TXWF_GetItemSize;
	XWF_SetItemSize: TXWF_SetItemSize;
	XWF_GetItemOfs: TXWF_GetItemOfs;
	XWF_SetItemOfs: TXWF_SetItemOfs;
	XWF_GetItemTimeStamps: TXWF_GetItemTimeStamps;
	XWF_SetItemTimeStamps: TXWF_SetItemTimeStamps;
	XWF_GetItemInformation: TXWF_GetItemInformation;
	XWF_SetItemInformation: TXWF_SetItemInformation;
	XWF_GetItemType: TXWF_GetItemType;
	XWF_SetItemType: TXWF_SetItemType;
	XWF_GetItemParent: TXWF_GetItemParent;
	XWF_SetItemParent: TXWF_SetItemParent;
	XWF_GetReportTableAssocs: TXWF_GetReportTableAssocs;
	XWF_AddToReportTable: TXWF_AddToReportTable;
	XWF_GetComment: TXWF_GetComment;
	XWF_AddComment: TXWF_AddComment;
	XWF_GetExtractedMetadata: TXWF_GetExtractedMetadata;
	XWF_AddExtractedMetadata: TXWF_AddExtractedMetadata;
	XWF_GetHashValue: TXWF_GetHashValue;

	XWF_GetMetadata: TXWF_GetMetadata;
	XWF_GetMetadataEx: TXWF_GetMetadataEx;
	XWF_GetRasterImage: TXWF_GetRasterImage;

	XWF_CreateContainer: TXWF_CreateContainer;
	XWF_CloseContainer: TXWF_CloseContainer;
	XWF_CopyToContainer: TXWF_CopyToContainer;

	XWF_GetCaseProp: TXWF_GetCaseProp;
	XWF_CreateEvObj: TXWF_CreateEvObj;
	XWF_GetFirstEvObj: TXWF_GetFirstEvObj;
	XWF_GetNextEvObj: TXWF_GetNextEvObj;
	XWF_OpenEvObj: TXWF_OpenEvObj;
	XWF_CloseEvObj: TXWF_CloseEvObj;
	XWF_GetEvObjProp: TXWF_GetEvObjProp;
	XWF_GetEvObj: TXWF_GetEvObj;
	XWF_GetReportTableInfo: TXWF_GetReportTableInfo;
	XWF_GetEvObjReportTableAssocs: TXWF_GetEvObjReportTableAssocs;

	XWF_Search: TXWF_Search;
	XWF_GetSearchTerm: TXWF_GetSearchTerm;
	XWF_AddSearchTerm: TXWF_AddSearchTerm;
	XWF_AddEvent: TXWF_AddEvent;
	XWF_GetEvent: TXWF_GetEvent;

	XWF_OutputMessage: TXWF_OutputMessage;
        XWF_GetUserInput : TXWF_GetUserInput;
	XWF_ShowProgress: TXWF_ShowProgress;
	XWF_SetProgressPercentage: TXWF_SetProgressPercentage;
	XWF_SetProgressDescription: TXWF_SetProgressDescription;
	XWF_ShouldStop: TXWF_ShouldStop;
	XWF_HideProgress: TXWF_HideProgress;
	XWF_ReleaseMem: TXWF_ReleaseMem;

const
	XT_ACTION_RUN = 0; // simply run directly from the main menu
	XT_ACTION_RVS = 1; // volume snapshot refinement starting
	XT_ACTION_LSS = 2; // logical simultaneous search starting
	XT_ACTION_PSS = 3; // physical simultaneous search starting
	XT_ACTION_DBC = 4; // directory browser context menu command invoked
	XT_ACTION_SHC = 5; // search hit context menu command invoked

	XT_INIT_XWF = $01;
	XT_INIT_WHX = $02;
	XT_INIT_XWI = $04;
	XT_INIT_BETA = $08;
	XT_INIT_UNDOCUMENTED = $10;
	XT_INIT_QUICKCHECK = $20;
	XT_INIT_ABOUTONLY = $40;

	XT_PREPARE_CALLPI = $01;
	XT_PREPARE_CALLPILATE = $02;
	XT_PREPARE_EXPECTMOREITEMS = $04;
	XT_PREPARE_DONTOMIT = $08;
	XT_PREPARE_TARGETDIRS = $10;

const
	XWF_CASEPROP_TITLE = 1;
	XWF_CASEPROP_EXAMINER = 3;
	XWF_CASEPROP_FILE = 5;
	XWF_CASEPROP_DIR = 6;

const
	XWF_VSPROP_SPECIALITEMID = 10;
	XWF_VSPROP_HASHTYPE1 = 20;
	XWF_VSPROP_HASHTYPE2 = 21;

const
	XWF_ITEM_INFO_ORIG_ID = 1;
	XWF_ITEM_INFO_ATTR = 2;
	XWF_ITEM_INFO_FLAGS = 3;
	XWF_ITEM_INFO_DELETION = 4;
	XWF_ITEM_INFO_CLASSIFICATION = 5;
	XWF_ITEM_INFO_LINKCOUNT = 6;
	XWF_ITEM_INFO_COLORANALYSIS = 7;
	XWF_ITEM_INFO_PIXELINDEX = 8;
	XWF_ITEM_INFO_FILECOUNT = 11;
	XWF_ITEM_INFO_EMBEDDEDOFFSET = 16;

	XWF_ITEM_INFO_CREATIONTIME = 32;
	XWF_ITEM_INFO_MODIFICATIONTIME = 33;
	XWF_ITEM_INFO_LASTACCESSTIME = 34;
	XWF_ITEM_INFO_ENTRYMODIFICATIONTIME = 35;
	XWF_ITEM_INFO_DELETIONTIME = 36;
	XWF_ITEM_INFO_INTERNALCREATIONTIME = 37;

	XWF_ITEM_INFO_FLAGS_SET = 64;
	XWF_ITEM_INFO_FLAGS_REMOVE = 65;

const
	XWF_ITEM_INFO_FLAG_ISDIR=$1;
	XWF_ITEM_INFO_FLAG_HASCHILDREN=$2; //for files only!
	XWF_ITEM_INFO_FLAG_DIRHASSUBDIRS=$4; //valid for directories only!
	XWF_ITEM_INFO_FLAG_FICTITIOUSITEM=$8;
	XWF_ITEM_INFO_FLAG_HIDDEN=$10;
	XWF_ITEM_INFO_FLAG_TAGGED=$20;
	XWF_ITEM_INFO_FLAG_TAGGEDPARTIALLY=$40;
	XWF_ITEM_INFO_FLAG_VIEWED=$80;

	XWF_ITEM_INFO_FLAG_ISNOTUTCTIME=$100;
	XWF_ITEM_INFO_FLAG_INTCREATIONISNOTUTCTIME=$200;
	XWF_ITEM_INFO_FLAG_FATTIMESTAMPS_=$400;
	XWF_ITEM_INFO_FLAG_NTFSORIGIN=$800;
	XWF_ITEM_INFO_FLAG_UNIXATTR=$1000;

	XWF_ITEM_INFO_FLAG_HASCOMMENT=$2000;
	XWF_ITEM_INFO_FLAG_HASMETADATA=$4000;

	XWF_ITEM_INFO_FLAG_ONLYMETADATAAVAILABLE=$8000; //file contents cannot be read from anywhere at all
	XWF_ITEM_INFO_FLAG_FILEPARTIALLYNOTREADABLE=$10000; //file contents partially cannot be read from anywhere
	

	XWF_ITEM_INFO_FLAG_HASH1ALREADYCOMPUTED=$40000; //valid for files only!
	XWF_ITEM_INFO_FLAG_HASDUPLICATES=$80000;
	XWF_ITEM_INFO_FLAG_HASH2ALREADYCOMPUTED=$100000; //valid for files only!
	XWF_ITEM_INFO_FLAG_KNOWN_GOOD=$200000;
	XWF_ITEM_INFO_FLAG_KNOWN_BAAD=$400000;

	XWF_ITEM_INFO_FLAG_VSC=$800000; //NTFS: found in volume shadow copy, next3: identifies a special snapshot file (or its parent directory)
	XWF_ITEM_INFO_FLAG_DATA_WELL_KNOWN=$1000000; // for deleted files
	XWF_ITEM_INFO_FLAG_STATUS_FLAG_FORMAT_OK=$2000000;
	XWF_ITEM_INFO_FLAG_STATUS_FLAG_CORRUPT=$4000000;

	XWF_ITEM_INFO_FLAG_FILEARCHIVEEXPLORED=$10000000;
	XWF_ITEM_INFO_FLAG_EMAILARCHIVEORVIDEOPROCESSED=$20000000;
	XWF_ITEM_INFO_FLAG_EMBEDDEDDATAUNCOVERED=$40000000;
	XWF_ITEM_INFO_FLAG_METADATAEXTRACTED=$80000000;

	XWF_ITEM_INFO_FLAG_EMBEDDEDFILE=$100000000;
	XWF_ITEM_INFO_FLAG_EXTERNALLYSTORED=$200000000;
	XWF_ITEM_INFO_FLAG_ALTERNATIVE_DATA_AVAILABLE=$400000000;

const
	XWF_CTR_OPEN=$01;
	XWF_CTR_RESERVED=$02;
	XWF_CTR_SECURE=$04;
	XWF_CTR_TOPLEVELDIR_COMPLETE=$08;
	XWF_CTR_INCLDIRDATA=$10;
	XWF_CTR_FILEPARENTS=$20;
	XWF_CTR_USERREPORTTABLES=$0100;
	XWF_CTR_SYSTEMREPORTTABLES=$0200;
	XWF_CTR_ALLCOMMENTS=$0800;
	XWF_CTR_TOPLEVELDIR_PARTIAL=$1000;

const
	XWF_SEARCH_LOGICAL=$00000001;
	XWF_SEARCH_TAGGEDOBJ=$00000004;

	XWF_SEARCH_MATCHCASE=$00000010;
	XWF_SEARCH_WHOLEWORDS=$00000020;
	XWF_SEARCH_GREP=$00000040;
	XWF_SEARCH_OVERLAPPED=$00000080;

	XWF_SEARCH_COVERSLACK=$00000100;
	XWF_SEARCH_COVERSLACKEX=$00000200;
	XWF_SEARCH_DECODETEXT=$00000400;
	XWF_SEARCH_DECODETEXTEX=$00000800; //not yet supported

	XWF_SEARCH_1HITPERFILE=$00001000;
	XWF_SEARCH_COVERSLACK2=$00002000;
	XWF_SEARCH_WHOLEWORDS2=$00004000;
	XWF_SEARCH_GREP2=$00008000;

	XWF_SEARCH_OMITIRRELEVANT=$00010000;
	XWF_SEARCH_OMITHIDDEN=$00020000;
	XWF_SEARCH_OMITFILTERED=$00040000;
	XWF_SEARCH_DATAREDUCTION=$00080000;
	XWF_SEARCH_OMITDIRS=$00100000;

	XWF_SEARCH_CALLPSH=$01000000;
	XWF_SEARCH_IGNORECODEPAGES=$02000000;
	XWF_SEARCH_DISPLAYHITS=$04000000;

implementation

var
	Hdl: THandle;
begin
	Hdl := GetModuleHandle(nil);

	XWF_GetSize := GetProcAddress(Hdl, 'XWF_GetSize');
        XWF_GetProp := GetProcAddress(Hdl, 'XWF_GetProp');
	XWF_GetVolumeName := GetProcAddress(Hdl, 'XWF_GetVolumeName');
	XWF_GetVolumeInformation := GetProcAddress(Hdl, 'XWF_GetVolumeInformation');
	XWF_GetSectorContents := GetProcAddress(Hdl, 'XWF_GetSectorContents');
	XWF_OpenItem := GetProcAddress(Hdl, 'XWF_OpenItem');
	XWF_Close := GetProcAddress(Hdl, 'XWF_Close');
	XWF_Read := GetProcAddress(Hdl, 'XWF_Read');
	XWF_SectorIO := GetProcAddress(Hdl, 'XWF_SectorIO');

	XWF_SelectVolumeSnapshot := GetProcAddress(Hdl, 'XWF_SelectVolumeSnapshot');
	XWF_GetVSProp := GetProcAddress(Hdl, 'XWF_GetVSProp');
	XWF_GetItemCount := GetProcAddress(Hdl, 'XWF_GetItemCount');
	XWF_GetFileCount := GetProcAddress(Hdl, 'XWF_GetFileCount');

	XWF_CreateItem := GetProcAddress(Hdl, 'XWF_CreateItem');
	XWF_CreateFile := GetProcAddress(Hdl, 'XWF_CreateFile');
	XWF_GetItemName := GetProcAddress(Hdl, 'XWF_GetItemName');
	XWF_GetItemSize := GetProcAddress(Hdl, 'XWF_GetItemSize');
	XWF_SetItemSize := GetProcAddress(Hdl, 'XWF_SetItemSize');
	XWF_GetItemOfs := GetProcAddress(Hdl, 'XWF_GetItemOfs');
	XWF_SetItemOfs := GetProcAddress(Hdl, 'XWF_SetItemOfs');
	XWF_GetItemTimeStamps := GetProcAddress(Hdl, 'XWF_GetItemTimeStamps');
	XWF_SetItemTimeStamps := GetProcAddress(Hdl, 'XWF_SetItemTimeStamps');
	XWF_GetItemInformation := GetProcAddress(Hdl, 'XWF_GetItemInformation');
	XWF_SetItemInformation := GetProcAddress(Hdl, 'XWF_SetItemInformation');
	XWF_GetItemType := GetProcAddress(Hdl, 'XWF_GetItemType');
	XWF_SetItemType := GetProcAddress(Hdl, 'XWF_SetItemType');
	XWF_GetItemParent := GetProcAddress(Hdl, 'XWF_GetItemParent');
	XWF_SetItemParent := GetProcAddress(Hdl, 'XWF_SetItemParent');
	XWF_GetReportTableAssocs := GetProcAddress(Hdl, 'XWF_GetReportTableAssocs');
	XWF_AddToReportTable := GetProcAddress(Hdl, 'XWF_AddToReportTable');
	XWF_GetComment := GetProcAddress(Hdl, 'XWF_GetComment');
	XWF_AddComment := GetProcAddress(Hdl, 'XWF_AddComment');
	XWF_GetExtractedMetadata := GetProcAddress(Hdl, 'XWF_GetExtractedMetadata');
	XWF_AddExtractedMetadata := GetProcAddress(Hdl, 'XWF_AddExtractedMetadata');
	XWF_GetHashValue := GetProcAddress(Hdl, 'XWF_GetHashValue');

	XWF_GetMetadata := GetProcAddress(Hdl, 'XWF_GetMetadata');
	XWF_GetMetadataEx := GetProcAddress(Hdl, 'XWF_GetMetadataEx');
	XWF_GetRasterImage := GetProcAddress(Hdl, 'XWF_GetRasterImage');

	XWF_CreateContainer := GetProcAddress(Hdl, 'XWF_CreateContainer');
	XWF_CloseContainer := GetProcAddress(Hdl, 'XWF_CloseContainer');
	XWF_CopyToContainer := GetProcAddress(Hdl, 'XWF_CopyToContainer');

	XWF_GetCaseProp := GetProcAddress(Hdl, 'XWF_GetCaseProp');
	XWF_CreateEvObj := GetProcAddress(Hdl, 'XWF_CreateEvObj');
	XWF_GetFirstEvObj := GetProcAddress(Hdl, 'XWF_GetFirstEvObj');
	XWF_GetNextEvObj := GetProcAddress(Hdl, 'XWF_GetNextEvObj');
	XWF_OpenEvObj := GetProcAddress(Hdl, 'XWF_OpenEvObj');
	XWF_CloseEvObj := GetProcAddress(Hdl, 'XWF_CloseEvObj');
	XWF_GetEvObjProp := GetProcAddress(Hdl, 'XWF_GetEvObjProp');
	XWF_GetReportTableInfo := GetProcAddress(Hdl, 'XWF_GetReportTableInfo');
	XWF_GetEvObjReportTableAssocs := GetProcAddress(Hdl, 'XWF_GetEvObjReportTableAssocs');

	XWF_Search := GetProcAddress(Hdl, 'XWF_Search');
	XWF_GetSearchTerm := GetProcAddress(Hdl, 'XWF_GetSearchTerm');
	XWF_AddSearchTerm := GetProcAddress(Hdl, 'XWF_AddSearchTerm');
	XWF_AddEvent := GetProcAddress(Hdl, 'XWF_AddEvent');
	XWF_GetEvent := GetProcAddress(Hdl, 'XWF_GetEvent');

	XWF_OutputMessage := GetProcAddress(Hdl, 'XWF_OutputMessage');
        XWF_GetUserInput  := GetProcAddress(Hdl, 'XWF_GetUserInput');
	XWF_ShowProgress  := GetProcAddress(Hdl, 'XWF_ShowProgress');
	XWF_SetProgressPercentage := GetProcAddress(Hdl, 'XWF_SetProgressPercentage');
	XWF_SetProgressDescription := GetProcAddress(Hdl, 'XWF_SetProgressDescription');
	XWF_ShouldStop := GetProcAddress(Hdl, 'XWF_ShouldStop');
	XWF_HideProgress := GetProcAddress(Hdl, 'XWF_HideProgress');
	XWF_ReleaseMem := GetProcAddress(Hdl, 'XWF_ReleaseMem');
end.
