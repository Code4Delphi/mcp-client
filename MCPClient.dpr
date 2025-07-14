program MCPClient;

uses
  System.StartUpCopy,
  FMX.Forms,
  Main.View in 'Src\Main.View.pas' {MainView},
  MCP.DM in 'Src\MCP.DM.pas' {MCPDM: TDataModule},
  Log.View in 'Src\Log.View.pas' {LogView};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TMCPDM, MCPDM);
  Application.CreateForm(TMainView, MainView);
  Application.Run;
end.
