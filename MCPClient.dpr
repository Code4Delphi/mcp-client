program MCPClient;

uses
  System.StartUpCopy,
  FMX.Forms,
  Main.View in 'Src\Main.View.pas' {MainView};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TMainView, MainView);
  Application.Run;
end.
