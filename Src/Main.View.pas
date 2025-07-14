unit Main.View;

interface

uses
  System.SysUtils,
  System.Types,
  System.UITypes,
  System.Classes,
  System.Variants,
  System.IOUtils,
  System.IniFiles,
  System.TypInfo,
  FMX.Types,
  FMX.Controls,
  FMX.Forms,
  FMX.Graphics,
  FMX.Dialogs,
  FMX.ListBox,
  FMX.StdCtrls,
  FMX.Controls.Presentation,
  FMX.Memo.Types,
  FMX.ScrollBox,
  FMX.Memo,
  TMS.MCP.CloudAI,
  MCP.DM;

type
  TMainView = class(TForm)
    pnBackAll: TPanel;
    Label1: TLabel;
    pnBottom: TPanel;
    btnSettings: TButton;
    btnToolsLog: TButton;
    btnAsk: TButton;
    cboxIAService: TComboBox;
    mmQuestion: TMemo;
    Splitter1: TSplitter;
    mmChat: TMemo;
    procedure FormCreate(Sender: TObject);
    procedure btnSettingsClick(Sender: TObject);
    procedure btnAskClick(Sender: TObject);
  private
    procedure MCPClientExecuted(Sender: TObject; AResponse: string; AHttpStatusCode: Integer; AHttpResult: string);
    procedure SendToAI;
    procedure AddChatQuestion(const AStr: string);
    procedure AddChatResponse(const AStr: string);
    procedure LoadSettings;
    procedure LoadMCPServers;
    procedure cBoxIAServiceFill;
  public

  end;

var
  MainView: TMainView;

implementation

{$R *.fmx}

procedure TMainView.FormCreate(Sender: TObject);
begin
  ReportMemoryLeaksOnShutdown := True;

  mmChat.Lines.Clear;
  MCPDM.MCPClient.OnExecuted := Self.MCPClientExecuted;
  //MCPDM.MCPClient.OnLog := MCPClientLog;

  //Application.CreateForm(TFormLog, FormLog);
  Self.LoadSettings;
  Self.LoadMCPServers;

  Self.cBoxIAServiceFill;
end;

procedure TMainView.MCPClientExecuted(Sender: TObject; AResponse: string; AHttpStatusCode: Integer;
  AHttpResult: string);
begin
  if AResponse.Trim.IsEmpty then
    Exit;

  Self.AddChatResponse(AResponse);
  //ShowLoading(False);
end;

procedure TMainView.cBoxIAServiceFill;
//var
//  Service: TTMSMCPCloudAIService;
begin
  cBoxIAService.Items.Clear;
//  for Service := Low(TTMSMCPCloudAIService) to High(TTMSMCPCloudAIService) do
//    cBoxIAService.Items.Add(GetEnumName(TypeInfo(TTMSMCPCloudAIService), Ord(Service)));
//  cBoxIAService.ItemIndex := 3;

  cBoxIAService.Items.Assign(MCPDm.MCPClient.LLM.GetServices(True));
  cBoxIAService.ItemIndex := 0;
end;

procedure TMainView.LoadSettings;
var
  LIni: TiniFile;
  LFileNameIni: string;
begin
  LFileNameIni := ChangeFileExt(ParamStr(0), '.ini');
  LIni := TiniFile.Create(LFileNameIni);
  try
    MCPDM.MCPClient.LLM.Settings.OllamaHost := LIni.ReadString('Settings', 'OllamaHost', 'localhost');
    MCPDM.MCPClient.LLM.Settings.OllamaPort := LIni.ReadInteger('Settings', 'OllamaPort', 11434);
  finally
    LIni.Free;
  end;

  MCPDM.MCPClient.LLM.APIKeys.LoadFromFile(LFileNameIni, ParamStr(0));
end;

procedure TMainView.LoadMCPServers;
var
  I: Integer;
begin
  if TFile.Exists(ChangeFileExt(ParamStr(0), '-config.json')) then
    MCPDM.MCPClient.Servers.LoadFromJSONFile(ChangeFileExt(ParamStr(0), '-config.json'));

  for I := 0 to Pred(MCPDM.MCPClient.Servers.Count) do
    MCPDM.MCPClient.Servers[I].Start;
end;

procedure TMainView.AddChatQuestion(const AStr: string);
begin
  mmChat.Lines.Add('Eu:');
  mmChat.Lines.Add(AStr.Trim);
  mmChat.Lines.Add(StringOfChar('-', 100));
  mmChat.GoToTextEnd;
end;

procedure TMainView.AddChatResponse(const AStr: string);
begin
  mmChat.Lines.Add(cboxIAService.Text + ':');
  mmChat.Lines.Add(AStr.Trim);
  mmChat.Lines.Add(StringOfChar('-', 100));
  mmChat.GoToTextEnd;
end;

procedure TMainView.btnSettingsClick(Sender: TObject);
begin
  MCPDM.SettingsDialog.Execute;
end;

procedure TMainView.btnAskClick(Sender: TObject);
begin
  Self.SendToAI;
end;

procedure TMainView.SendToAI;
begin
  //MCPDM.MCPClient.LLM.Service := aiClaude;
  //MCPDM.MCPClient.APIKeys.Claude := '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';
  MCPDM.MCPClient.LLM.Service := TTMSMCPCloudAIService(cboxIAService.ItemIndex);

  Self.AddChatQuestion(mmQuestion.Text);

  MCPDM.MCPClient.Execute(mmQuestion.Text);
  mmQuestion.Lines.Clear;

  //ShowLoading(True);
end;

end.
