library solidworks;

{$mode objfpc}{$H+}
{$include calling.inc}

uses
  Classes,
  sysutils,
  WLXPlugin,fpolestorage, fpsutils, fpstypes, fpsstrings,
  FPimage,FPWritePNG;

procedure ListGetDetectString(DetectString:pchar;maxlen:integer); dcpcall;
begin
  StrCopy(DetectString, 'EXT="SLDPRT"|EXT="SLDASM"|EXT="EASM"');
end;

function ListGetPreviewBitmapFile(FileToLoad:pchar;OutputPath:pchar;width,height:integer;
    contentbuf:pchar;contentbuflen:integer):pchar; dcpcall;
var
  MemStream: TMemoryStream;
  OLEStorage: TOLEStorage;
  OLEDocument : TOLEDocument;
  aPreview: TFileStream;
begin
  MemStream := TMemoryStream.Create;
  OLEStorage := TOLEStorage.Create;
  try
    // Only one stream is necessary for any number of worksheets
    OLEDocument.Stream := MemStream;
    OLEStorage.ReadOLEFile(FileToLoad, OLEDocument,'Preview');
    aPreview := TFileStream.Create(OutputPath+'thumb.png',fmCreate);
    aPreview.CopyFrom(MemStream,0);
    aPreview.Free;
    Result := PChar(OutputPath+'thumb.png');
  finally
    OLEStorage.Free;
  end;
end;

exports
  ListGetDetectString,
  ListGetPreviewBitmapFile;

begin
end.

