unit MCP.DM;

interface

uses
  System.SysUtils,
  System.Classes,
  System.TypInfo,
  System.IniFiles,
  TMS.MCP.CustomDialog,
  TMS.MCP.Client.SettingsDialog,
  TMS.MCP.CustomComponent,
  TMS.MCP.Client;

type
  TMCPDM = class(TDataModule)
    MCPClient: TTMSMCPClient;
    SettingsDialog: TTMSMCPClientSettingsDialog;
    procedure SettingsDialogAPIKeysChanged(Sender: TObject);
    procedure SettingsDialogServersChanged(Sender: TObject);
    procedure MCPClientLog(Sender: TObject; AServer: TTMSMCPClientServerItem; ATimeStamp: TDateTime;
      ALevel: TTMSMCPLoggingLevel; AMessage: string);
    procedure DataModuleCreate(Sender: TObject);
  private
    FLog: string;
  public
    property Log: string read FLog write FLog;
  end;

var
  MCPDM: TMCPDM;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

{$R *.dfm}

procedure TMCPDM.DataModuleCreate(Sender: TObject);
begin
  FLog := '';
end;

procedure TMCPDM.SettingsDialogAPIKeysChanged(Sender: TObject);
var
  LIni: TiniFile;
  LFileNameIni: string;
begin
  LFileNameIni := ChangeFileExt(ParamStr(0), '.ini');
  MCPClient.LLM.APIKeys.SaveToFile(LFileNameIni, ParamStr(0));
  LIni := TiniFile.Create(LFileNameIni);
  try
    LIni.WriteString('Settings', 'OllamaHost', MCPClient.LLM.Settings.OllamaHost);
    LIni.WriteInteger('Settings', 'OllamaPort', MCPClient.LLM.Settings.OllamaPort);
  finally
    LIni.Free;
  end;
end;

procedure TMCPDM.SettingsDialogServersChanged(Sender: TObject);
begin
  MCPClient.Servers.SaveToJSONFile(ChangeFileExt(ParamStr(0), '-config.json'));
end;

procedure TMCPDM.MCPClientLog(Sender: TObject; AServer: TTMSMCPClientServerItem; ATimeStamp: TDateTime;
  ALevel: TTMSMCPLoggingLevel; AMessage: string);
var
  LLevel: string;
  LLog: string;
begin
  LLevel := GetEnumName(TypeInfo(TTMSMCPLoggingLevel), Ord(ALevel));
  Delete(LLevel, 1, 2);
  LLevel := '[' + LLevel + ']';

  LLog := '';
  if Assigned(AServer) and (AServer.ServerName <> '') then
    LLog := ' (Calling server: ' + AServer.ServerName + ')';

  FLog := FLog + LLevel + DateTimeToStr(ATimeStamp) + ': ' + AMessage + LLog + sLineBreak;
end;

end.
