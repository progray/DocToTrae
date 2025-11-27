unit ErrorCodes;

interface

uses
  SysUtils;

const
  // Error codes
  SKIPPED_TOC = 'SKIPPED_TOC';
  SKIPPED_PASSWORD = 'SKIPPED_PASSWORD';
  TIMEOUT = 'TIMEOUT';
  COM_ERROR = 'COM_ERROR';
  UNKNOWN = 'UNKNOWN';

  // Error messages
  MSG_SKIPPED_TOC = 'Document skipped because it contains a Table of Contents';
  MSG_SKIPPED_PASSWORD = 'Document skipped because it is password protected';
  MSG_TIMEOUT = 'Conversion timed out';
  MSG_COM_ERROR = 'COM error occurred during conversion';
  MSG_UNKNOWN = 'Unknown error occurred';

function GetErrorMessage(ErrorCode: string): string;
function FormatError(ErrorCode: string; const Args: array of const): string;

implementation

function GetErrorMessage(ErrorCode: string): string;
begin
  Result := '';
  if ErrorCode = SKIPPED_TOC then
    Result := MSG_SKIPPED_TOC
  else if ErrorCode = SKIPPED_PASSWORD then
    Result := MSG_SKIPPED_PASSWORD
  else if ErrorCode = TIMEOUT then
    Result := MSG_TIMEOUT
  else if ErrorCode = COM_ERROR then
    Result := MSG_COM_ERROR
  else if ErrorCode = UNKNOWN then
    Result := MSG_UNKNOWN;
end;

function FormatError(ErrorCode: string; const Args: array of const): string;
begin
  Result := Format(GetErrorMessage(ErrorCode), Args);
end;

end.