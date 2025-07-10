unit Main.View;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.ListBox, FMX.StdCtrls, FMX.Controls.Presentation,
  FMX.Memo.Types, FMX.ScrollBox, FMX.Memo;

type
  TMainView = class(TForm)
    pnBackAll: TPanel;
    Label1: TLabel;
    pnBottom: TPanel;
    btnSettings: TButton;
    btnToolsLog: TButton;
    cbModel: TComboBox;
    btnAsk: TButton;
    mmQuestion: TMemo;
    Splitter1: TSplitter;
    mmChat: TMemo;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MainView: TMainView;

implementation

{$R *.fmx}

end.
