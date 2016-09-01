unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls;

type

  { TForm1 }

  TForm1 = class(TForm)
    ChooseFileButton: TButton;
    Label1: TLabel;
    ChooseFileDialog: TOpenDialog;
    RGBLabel: TLabel;
    SaveFileButton: TButton;
    Image1: TImage;
    Panel1: TPanel;
    DiscolorToggle: TToggleBox;
    ScrollBox1: TScrollBox;
    procedure ChooseFileButtonClick(Sender: TObject);
    procedure Image1MouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer
      );
    procedure GetRGB(Col: TColor; var R, G, B: Byte);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.Image1MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var
  ColNumb: TColor;
  R, G, B: Byte;
begin
  ColNumb := Image1.Canvas.Pixels[X, Y]; {The image can't be a JPG}
  GetRGB(ColNumb, R, G, B);

  RGBLabel.Caption := IntToStr(R) + ', ' + IntToStr(G) + ', ' + IntToStr(B);
end;

procedure TForm1.ChooseFileButtonClick(Sender: TObject);
var
  Filename: string;
begin
  ChooseFileDialog.InitialDir := ExtractFilePath(ParamStr(0));

  if ChooseFileDialog.Execute then
  begin
    Filename := ChooseFileDialog.Filename;

    Image1.Picture.LoadFromFile(Filename);
  end;
end;

procedure TForm1.GetRGB(Col: TColor; var R, G, B: Byte);
var
  Color2: $0..$FFFFFFFF;
begin
  Color2 := ColorToRGB(Col);
  R := ($000000FF and Color2);
  G := ($0000FF00 and Color2) Shr 8;
  B := ($00FF0000 and Color2) Shr 16;
end;

end.

