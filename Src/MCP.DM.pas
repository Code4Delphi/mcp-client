unit MCP.DM;

interface

uses
  System.SysUtils,
  System.Classes,
  IniFiles,
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
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MCPDM: TMCPDM;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

{$R *.dfm}

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
  MCPClient.Servers.SaveToJSONFile(ChangeFileExt(ParamStr(0),'-config.json'));
end;

end.
