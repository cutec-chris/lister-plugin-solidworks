library solidworks;

{$mode objfpc}{$H+}
{$include calling.inc}

uses
  Classes,
  sysutils,
  WLXPlugin, laz_fpspreadsheet,fpolestorage,
  FPimage,FPWritePNG;

procedure ListGetDetectString(DetectString:pchar;maxlen:integer); dcpcall;
begin
  StrCopy(DetectString, 'EXT="SLDPRT"|EXT="SLDASM"');
end;

function ListGetPreviewBitmapFile(FileToLoad:pchar;OutputPath:pchar;width,height:integer;
    contentbuf:pchar;contentbuflen:integer):pchar; dcpcall;
var
  MemStream: TMemoryStream;
  OLEStorage: TOLEStorage;
  OLEDocument : TOLEDocument;
begin
  MemStream := TMemoryStream.Create;
  OLEStorage := TOLEStorage.Create;
  try
    // Only one stream is necessary for any number of worksheets
    OLEDocument.Stream := MemStream;
    OLEStorage.ReadOLEFile(FileToLoad, OLEDocument,'WordDocument');
    {
    if MemStream.Seek($800,soFromBeginning) = $800 then
      begin
        Setlength(aContent,MemStream.Size-$800);
        MemStream.Read(aContent[1],MemStream.Size-$800);
        aContent2 := ConvertEncoding(aContent,EncodingUCS2LE,EncodingUTF8);
        aText:=StripUnwantedChar(aContent2);
      end;
    }
  finally
    OLEStorage.Free;
  end;
end;

exports
  ListGetDetectString,
  ListGetPreviewBitmapFile;

begin
end.

