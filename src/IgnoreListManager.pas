unit IgnoreListManager;

interface

uses
  SysUtils, Classes;

type
  TIgnoreEntry = record
    FilePath: string;
    ErrorCode: string;
    Timestamp: TDateTime;
  end;

  TIgnoreListManager = class
  private
    FIgnoreFile: string;
    function GetIgnoreCount: Integer;
    procedure SetIgnoreCount(Value: Integer);
    function GetIgnoreEntry(Index: Integer): TIgnoreEntry;
    procedure SetIgnoreEntry(Index: Integer; const Value: TIgnoreEntry);
  public
    constructor Create(const AIgnoreFile: string = 'docto.ignore.txt');
    function AddEntry(const AFilePath, AErrorCode: string): Integer;
    function RemoveEntry(const AFilePath: string): Boolean;
    function ContainsEntry(const AFilePath: string): Boolean;
    function GetEntryByFilePath(const AFilePath: string): TIgnoreEntry;
    procedure LoadIgnoreList();
    procedure SaveIgnoreList();
    property IgnoreCount: Integer read GetIgnoreCount write SetIgnoreCount;
    property IgnoreEntries[Index: Integer]: TIgnoreEntry read GetIgnoreEntry write SetIgnoreEntry;
  end;

var
  IgnoreList: TIgnoreListManager;

implementation

uses
  IniFiles;

constructor TIgnoreListManager.Create(const AIgnoreFile: string);
begin
  inherited Create;
  FIgnoreFile := AIgnoreFile;
end;

function TIgnoreListManager.GetIgnoreCount: Integer;
var
  IniFile: TIniFile;
begin
  IniFile := TIniFile.Create(FIgnoreFile);
  try
    Result := IniFile.ReadInteger('IgnoreList', 'IGNORECOUNT', 0);
  finally
    IniFile.Free;
  end;
end;

procedure TIgnoreListManager.SetIgnoreCount(Value: Integer);
var
  IniFile: TIniFile;
begin
  IniFile := TIniFile.Create(FIgnoreFile);
  try
    IniFile.WriteInteger('IgnoreList', 'IGNORECOUNT', Value);
  finally
    IniFile.Free;
  end;
end;

function TIgnoreListManager.GetIgnoreEntry(Index: Integer): TIgnoreEntry;
var
  IniFile: TIniFile;
  EntryStr: string;
  Parts: TStringList;
begin
  Result.FilePath := '';
  Result.ErrorCode := '';
  Result.Timestamp := 0;

  IniFile := TIniFile.Create(FIgnoreFile);
  try
    EntryStr := IniFile.ReadString('IgnoreList', 'IGNOREFILE' + IntToStr(Index), '');
  finally
    IniFile.Free;
  end;

  if EntryStr <> '' then
  begin
    Parts := TStringList.Create;
    try
      ExtractStrings(['|'], [], PChar(EntryStr), Parts);
      if Parts.Count >= 1 then
        Result.FilePath := Parts[0];
      if Parts.Count >= 2 then
        Result.ErrorCode := Parts[1];
      if Parts.Count >= 3 then
        Result.Timestamp := StrToDateTime(Parts[2]);
    finally
      Parts.Free;
    end;
  end;
end;

procedure TIgnoreListManager.SetIgnoreEntry(Index: Integer; const Value: TIgnoreEntry);
var
  IniFile: TIniFile;
  EntryStr: string;
begin
  EntryStr := Value.FilePath + '|' + Value.ErrorCode + '|' + DateTimeToStr(Value.Timestamp);
  IniFile := TIniFile.Create(FIgnoreFile);
  try
    IniFile.WriteString('IgnoreList', 'IGNOREFILE' + IntToStr(Index), EntryStr);
  finally
    IniFile.Free;
  end;
end;

function TIgnoreListManager.AddEntry(const AFilePath, AErrorCode: string): Integer;
var
  Count: Integer;
  Entry: TIgnoreEntry;
begin
  Count := IgnoreCount;
  Entry.FilePath := AFilePath;
  Entry.ErrorCode := AErrorCode;
  Entry.Timestamp := Now;
  IgnoreEntries[Count] := Entry;
  IgnoreCount := Count + 1;
  Result := Count;
end;

function TIgnoreListManager.RemoveEntry(const AFilePath: string): Boolean;
var
  Count: Integer;
  I, J: Integer;
  Entry: TIgnoreEntry;
begin
  Result := False;
  Count := IgnoreCount;
  for I := 0 to Count - 1 do
  begin
    Entry := IgnoreEntries[I];
    if SameText(Entry.FilePath, AFilePath) then
    begin
      // Shift entries down
      for J := I to Count - 2 do
        IgnoreEntries[J] := IgnoreEntries[J + 1];
      // Remove last entry
      IgnoreCount := Count - 1;
      Result := True;
      Break;
    end;
  end;
end;

function TIgnoreListManager.ContainsEntry(const AFilePath: string): Boolean;
var
  Count: Integer;
  I: Integer;
  Entry: TIgnoreEntry;
begin
  Result := False;
  Count := IgnoreCount;
  for I := 0 to Count - 1 do
  begin
    Entry := IgnoreEntries[I];
    if SameText(Entry.FilePath, AFilePath) then
    begin
      Result := True;
      Break;
    end;
  end;
end;

function TIgnoreListManager.GetEntryByFilePath(const AFilePath: string): TIgnoreEntry;
var
  Count: Integer;
  I: Integer;
  Entry: TIgnoreEntry;
begin
  Result.FilePath := '';
  Result.ErrorCode := '';
  Result.Timestamp := 0;

  Count := IgnoreCount;
  for I := 0 to Count - 1 do
  begin
    Entry := IgnoreEntries[I];
    if SameText(Entry.FilePath, AFilePath) then
    begin
      Result := Entry;
      Break;
    end;
  end;
end;

procedure TIgnoreListManager.LoadIgnoreList();
// This method is a placeholder for future enhancements
// Currently, the ignore list is loaded on demand by GetIgnoreCount and GetIgnoreEntry
begin
end;

procedure TIgnoreListManager.SaveIgnoreList();
// This method is a placeholder for future enhancements
// Currently, the ignore list is saved immediately by SetIgnoreCount and SetIgnoreEntry
begin
end;

initialization
  IgnoreList := TIgnoreListManager.Create;

finalization
  IgnoreList.Free;

end.