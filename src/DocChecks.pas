unit DocChecks;

interface

uses
  SysUtils, Classes, ComObj;

type
  TDocCheckResult = record
    HasTOC: Boolean;
    IsPasswordProtected: Boolean;
    HasMacro: Boolean;
  end;

function CheckWordDocument(const FilePath: string): TDocCheckResult;
function CheckExcelDocument(const FilePath: string): TDocCheckResult;

implementation

function CheckWordDocument(const FilePath: string): TDocCheckResult;
var
  WordApp: Variant;
  Doc: Variant;
  I: Integer;
begin
  Result.HasTOC := False;
  Result.IsPasswordProtected := False;
  Result.HasMacro := False;

  try
    // Create Word application
    WordApp := CreateOleObject('Word.Application');
    WordApp.Visible := False;
    WordApp.DisplayAlerts := False;

    try
      // Try to open document without password
      Doc := WordApp.Documents.Open(FilePath, False, True, False, '');

      // Check if document is password protected
      if Doc.ProtectionType <> 0 then // wdNoProtection = 0
        Result.IsPasswordProtected := True;

      // Check if document has TOC
      for I := 1 to Doc.TablesOfContents.Count do
      begin
        Result.HasTOC := True;
        Break;
      end;

      // Check if document has macros
      if Doc.HasVBProject then
        Result.HasMacro := True;

      // Close document without saving
      Doc.Close(False);
    except
      on E: Exception do
      begin
        // If opening failed, assume it's password protected
        Result.IsPasswordProtected := True;
      end;
    end;
  finally
    // Quit Word application
    if not VarIsEmpty(WordApp) then
    begin
      WordApp.Quit(False);
      WordApp := Unassigned;
    end;
  end;
end;

function CheckExcelDocument(const FilePath: string): TDocCheckResult;
var
  ExcelApp: Variant;
  Workbook: Variant;
  I: Integer;
begin
  Result.HasTOC := False; // Excel doesn't have TOC
  Result.IsPasswordProtected := False;
  Result.HasMacro := False;

  try
    // Create Excel application
    ExcelApp := CreateOleObject('Excel.Application');
    ExcelApp.Visible := False;
    ExcelApp.DisplayAlerts := False;

    try
      // Try to open workbook without password
      Workbook := ExcelApp.Workbooks.Open(FilePath, False, True, 5, '');

      // Check if workbook is password protected
      if Workbook.ProtectStructure or Workbook.ProtectWindows then
        Result.IsPasswordProtected := True;

      // Check if workbook has macros
      if Workbook.HasVBProject then
        Result.HasMacro := True;

      // Close workbook without saving
      Workbook.Close(False);
    except
      on E: Exception do
      begin
        // If opening failed, assume it's password protected
        Result.IsPasswordProtected := True;
      end;
    end;
  finally
    // Quit Excel application
    if not VarIsEmpty(ExcelApp) then
    begin
      ExcelApp.Quit;
      ExcelApp := Unassigned;
    end;
  end;
end;

end.