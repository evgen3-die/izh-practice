unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, ExtDlgs, ComCtrls, GraphType, LazUTF8, LResources;

type

  { TForm1 }

  TForm1 = class(TForm)
    CutLeftTop: TButton;
    CutButton: TButton;
    CutTop: TButton;
    CutRightTop: TButton;
    CutLeft: TButton;
    CutRight: TButton;
    CutCenter: TButton;
    CutRightBottom: TButton;
    CutBottom: TButton;
    CutLeftBottom: TButton;
    height_image: TEdit;
    CutHeight: TEdit;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    width_image: TEdit;
    resizeButton: TButton;
    ChooseFileButton: TButton;
    Label1: TLabel;
    ChooseFileDialog: TOpenDialog;
    resizeImage1: TButton;
    RGBLabel: TLabel;
    SaveFileButton: TButton;
    Image1: TImage;
    Panel1: TPanel;
    SavePictureDialog1: TSavePictureDialog;
    ScrollBox1: TScrollBox;
    CutWidth: TEdit;
    procedure CutButtonClick(Sender: TObject);
    procedure CutPositionButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure resizeButtonClick(Sender: TObject);
    procedure resizeImageClick(Sender: TObject);
    procedure ChooseFileButtonClick(Sender: TObject);
    procedure Image1MouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure GetRGB(Col: TColor; var R, G, B: Byte);
    procedure SaveFileButtonClick(Sender: TObject);
    procedure BitmapToGrayscale(Bitmap: TBitmap);
    function ResizeBitmap(BmpIn : TBitmap; NewWidth, NewHeight : Integer) : TBitmap;
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  Form1: TForm1;
  CutPosition: String;

implementation

{$R Unit1.lfm}

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

procedure TForm1.resizeImageClick(Sender: TObject);
var
   Bmp: TBitmap;
begin
  Bmp := TBitmap.Create;
  Bmp.Width := Image1.Picture.Width;
  Bmp.Height := Image1.Picture.Height;
  Bmp.Canvas.Draw(0, 0, Image1.Picture.Graphic);

  BitmapToGrayscale(Bmp);

  Image1.Picture.Bitmap := Bmp;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
     CutPosition := 'CutLeftTop';
end;

procedure TForm1.CutPositionButtonClick(Sender: TObject);
begin
     TButton(FindComponent(CutPosition)).Enabled := true;

     CutPosition := TButton(Sender).Name;
     TButton(Sender).Enabled := false;

end;

procedure TForm1.CutButtonClick(Sender: TObject);
var r: Trect;
   w, h, x, y: integer;
   Bmp : TBitmap;
begin
    x := 0;
    y := 0;

    w := strToInt(CutWidth.text);
    h := strToInt(CutHeight.text);

    case CutPosition of
      'CutTop' : begin
          x := Image1.width div 2 - w div 2;
       end;
      'CutRightTop' : begin
          x := Image1.width - w;
       end;
      'CutRight' : begin
          x := Image1.width - w;
          y := Image1.height div 2 - h div 2;
       end;
      'CutRightBottom' : begin
          x := Image1.width - w;
          y := Image1.height - h;
       end;
      'CutBottom' : begin
          x := Image1.width div 2 - w div 2;
          y := Image1.height - h;
       end;
      'CutLeftBottom' : begin
          y := Image1.height - h;
       end;
      'CutCenter' : begin
          x := Image1.width div 2 - w div 2;
          y := Image1.height div 2 - h div 2;
       end;
    end;

  Bmp := TBitmap.Create;

  Bmp.Width:=w;
  Bmp.Height:=h;

  Bmp.Canvas.CopyRect(Rect(0,0,w,h), Image1.Canvas, Rect(x,y,x+w,y+h));

  Image1.Picture.Bitmap.Assign(Bmp);
end;

procedure TForm1.resizeButtonClick(Sender: TObject);
var
  Bmp: TBitmap;
  widthImg, heightImg: Integer;
begin
  Bmp := TBitmap.Create;
  Bmp.Width := Image1.Picture.Width;
  Bmp.Height := Image1.Picture.Height;
  Bmp.Canvas.Draw(0, 0, Image1.Picture.Graphic);

  widthImg := StrToInt(width_image.text);
  heightImg := StrToInt(height_image.text);

  Image1.Picture.Bitmap := ResizeBitmap(Bmp, widthImg, heightImg);
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

procedure TForm1.SaveFileButtonClick(Sender: TObject);
begin
  if SavePictureDialog1.Execute then
         Image1.Picture.SaveToFile(SavePictureDialog1.FileName);
end;

procedure TForm1.BitmapToGrayscale(Bitmap: TBitmap);
var
  x, y, Color3: integer;
begin;
  with Bitmap do
    for y:=0 to Height-1 do
      for x:=0 to Width-1 do begin;
        Color3:=Canvas.Pixels[x, y];
        Canvas.Pixels[x, y]:=((77 * (Color3        and $FF)  //Red
                            + 150 * (Color3 shr 8  and $FF)  //Green
                             + 29 * (Color3 shr 16 and $FF)  //Blue
                              ) shr 8
                             ) * $00010101;
        end;
  end;

function TForm1.ResizeBitmap(BmpIn : TBitmap; NewWidth, NewHeight : Integer) : TBitmap;
begin
Result := TBitmap.Create;
try
Result.Width := NewWidth;
Result.Height := NewHeight;
Result.PixelFormat := BmpIn.PixelFormat;
Result.Canvas.StretchDraw(Rect(0, 0, Result.Width, Result.Height), BmpIn);
except
Result.Free;
end;
end;

end.



