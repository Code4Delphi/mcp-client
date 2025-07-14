unit Log.View;

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
  FMX.Memo.Types,
  FMX.Controls.Presentation,
  FMX.ScrollBox,
  FMX.Memo,
  FMX.StdCtrls,
  MCP.DM;

type
  TLogView = class(TForm)
    mmLog: TMemo;
    pnBottom: TPanel;
    btnLogsClear: TButton;
    procedure btnLogsClearClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private

  public

  end;

implementation

{$R *.fmx}

procedure TLogView.FormShow(Sender: TObject);
begin
  mmLog.Text := MCPDM.Log;
end;

procedure TLogView.btnLogsClearClick(Sender: TObject);
begin
  MCPDM.Log := '';
  mmLog.Lines.Clear;
end;

end.
