unit Main.View;

interface

uses
  System.SysUtils,
  System.Types,
  System.UITypes,
  System.Classes,
  System.Variants,
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
    cboxLLMService: TComboBox;
    btnAsk: TButton;
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
  //LoadSettings;
  //LoadServers;
end;

procedure TMainView.MCPClientExecuted(Sender: TObject; AResponse: string; AHttpStatusCode: Integer;
  AHttpResult: string);
begin
  if AResponse.Trim.IsEmpty then
    Exit;

  Self.AddChatResponse(AResponse);
  //ShowLoading(False);
end;

procedure TMainView.AddChatQuestion(const AStr: string);
begin
  mmChat.Lines.Add('Eu:');
  mmChat.Lines.Add(AStr.Trim);
  mmChat.Lines.Add(StringOfChar('-', 100));
end;

procedure TMainView.AddChatResponse(const AStr: string);
begin
  mmChat.Lines.Add(cboxLLMService.Text + ':');
  mmChat.Lines.Add(AStr.Trim);
  mmChat.Lines.Add(StringOfChar('-', 100));
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
  MCPDM.MCPClient.LLM.Service := aiClaude;
  MCPDM.MCPClient.APIKeys.Claude := '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';

  Self.AddChatQuestion(mmQuestion.Text);

  MCPDM.MCPClient.Execute(mmQuestion.Text);
  mmQuestion.Lines.Clear;

  //ShowLoading(True);
end;

end.
