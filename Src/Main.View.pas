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
  MCP.DM,
  Log.View, FMX.Menus;

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
    pnLoading: TPanel;
    AniIndicator1: TAniIndicator;
    ckLimparChat: TCheckBox;
    ckLimparPrompt: TCheckBox;
    PopupMenu1: TPopupMenu;
    MenuItemPromptsDefault1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    MenuItem5: TMenuItem;
    MenuItem6: TMenuItem;
    MenuItem1: TMenuItem;
    MenuItem7: TMenuItem;
    MenuItem8: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure btnSettingsClick(Sender: TObject);
    procedure btnAskClick(Sender: TObject);
    procedure btnToolsLogClick(Sender: TObject);
    procedure MenuItemPromptsDefault1Click(Sender: TObject);
  private
    procedure MCPClientExecuted(Sender: TObject; AResponse: string; AHttpStatusCode: Integer; AHttpResult: string);
    procedure SendToAI;
    procedure AddChatQuestion(const AStr: string);
    procedure AddChatResponse(const AStr: string);
    procedure LoadSettings;
    procedure LoadMCPServers;
    procedure cBoxIAServiceFill;
    procedure ShowLoading(const AShow: Boolean);
  public

  end;

var
  MainView: TMainView;

implementation

{$R *.fmx}

procedure TMainView.FormCreate(Sender: TObject);
begin
  ReportMemoryLeaksOnShutdown := True;

  MCPDM.MCPClient.OnExecuted := Self.MCPClientExecuted;

  Self.cBoxIAServiceFill;
  Self.LoadSettings;
  Self.LoadMCPServers;
  Self.ShowLoading(False);
end;

procedure TMainView.MCPClientExecuted(Sender: TObject; AResponse: string; AHttpStatusCode: Integer;
  AHttpResult: string);
begin
  Self.ShowLoading(False);

  if AHttpStatusCode <> 200 then
  begin
    Self.AddChatResponse('# HTTP error code: ' + AHttpStatusCode.ToString + sLineBreak + AHttpResult);
    Exit;
  end;

  Self.AddChatResponse(AResponse);

  if ckLimparPrompt.IsChecked then
    mmQuestion.Lines.Clear;
end;

procedure TMainView.cBoxIAServiceFill;
begin
  cBoxIAService.Items.Clear;
  cBoxIAService.Items.Assign(MCPDm.MCPClient.LLM.GetServices(True));
  cBoxIAService.ItemIndex := 6;
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
    MCPDM.MCPClient.LLM.Settings.OllamaModel := LIni.ReadString('Models', 'OllamaModel', MCPDM.MCPClient.LLM.Settings.OllamaModel);
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
  if ckLimparChat.IsChecked then
   mmChat.Lines.Clear;

  mmChat.Lines.Add('Eu:');
  mmChat.Lines.Add(AStr.Trim);
  mmChat.Lines.Add(StringOfChar('-', 100));
  mmChat.GoToTextEnd;
end;

procedure TMainView.AddChatResponse(const AStr: string);
begin
  if AStr.Trim.IsEmpty then
    Exit;

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

procedure TMainView.ShowLoading(const AShow: Boolean);
begin
  pnLoading.Visible := AShow;
  AniIndicator1.Enabled := AShow;
end;

procedure TMainView.SendToAI;
begin
  if Trim(mmQuestion.Text).IsEmpty then
    raise Exception.Create('Informe um prompt para continuar');

  MCPDM.MCPClient.LLM.Service := TTMSMCPCloudAIService(cboxIAService.Items.Objects[cboxIAService.ItemIndex]);
  MCPDM.MCPClient.Execute(mmQuestion.Text);

  Self.AddChatQuestion(mmQuestion.Text);
  Self.ShowLoading(True);
end;

procedure TMainView.btnToolsLogClick(Sender: TObject);
var
  LLogView: TLogView;
begin
  LLogView := TLogView.Create(nil);
  try
    LLogView.ShowModal;
  finally
    LLogView.Free;
  end;
end;

procedure TMainView.MenuItemPromptsDefault1Click(Sender: TObject);
begin
  if TMenuItem(Sender).Text = MenuItemPromptsDefault1.Text then
    Exit;

  mmQuestion.Lines.Text := TMenuItem(Sender).Text;
  mmQuestion.SelStart := mmQuestion.Text.Length;
end;


end.
