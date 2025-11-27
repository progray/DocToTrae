unit TimeoutWatcher;

interface

uses
  SysUtils, Classes, Windows, SyncObjs;

type
  TTimeoutWatcher = class(TThread)
  private
    FTimeout: Integer;
    FEvent: TEvent;
    FOnTimeout: TNotifyEvent;
  protected
    procedure Execute; override;
  public
    constructor Create(ATimeout: Integer; AOnTimeout: TNotifyEvent);
    destructor Destroy; override;
    procedure Reset;
    procedure Stop;
  end;

implementation

constructor TTimeoutWatcher.Create(ATimeout: Integer; AOnTimeout: TNotifyEvent);
begin
  inherited Create(True);
  FTimeout := ATimeout;
  FOnTimeout := AOnTimeout;
  FEvent := TEvent.Create(nil, True, False, '');
  FreeOnTerminate := True;
end;

destructor TTimeoutWatcher.Destroy;
begin
  FEvent.Free;
  inherited;
end;

procedure TTimeoutWatcher.Execute;
begin
  while not Terminated do
  begin
    if FEvent.WaitFor(FTimeout * 1000) = wrTimeout then
    begin
      if Assigned(FOnTimeout) then
        Synchronize(FOnTimeout);
      // Reset event after timeout
      FEvent.ResetEvent;
    end;
  end;
end;

procedure TTimeoutWatcher.Reset;
begin
  FEvent.ResetEvent;
end;

procedure TTimeoutWatcher.Stop;
begin
  Terminate;
  FEvent.SetEvent;
end;

end.