library solidworks;

{$mode objfpc}{$H+}
{$include calling.inc}

uses
  Classes,
  sysutils,
  WLXPlugin,fpolebasic, fpsutils, fpstypes, fpsstrings, dibimagereader,
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
  DataSize : DWord;
  aImage: TFPMemoryImage;
  aHandler: TLazReaderDIB;
begin
  MemStream := TMemoryStream.Create;
  OLEStorage := TOLEStorage.Create;
  try
    // Only one stream is necessary for any number of worksheets
    OLEDocument.Stream := MemStream;
    OLEStorage.ReadOLEFile(FileToLoad, OLEDocument,'Preview');
    MemStream.Position:=0;
    MemStream.Read(DataSize,sizeof(DataSize));
    aImage := TFPMemoryImage.create(0,0);
    aHandler := TLazReaderDIB.Create;
    aImage.LoadFromStream(MemStream,aHandler);
    aImage.SaveToFile(OutputPath+'thumb.png');
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

