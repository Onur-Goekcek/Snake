unit Test;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls;

type
  TForm1 = class(TForm)
    SpieleFeld: TPaintBox;
    Timer1: TTimer;
    procedure Timer1Timer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private-Deklarationen }
    FGrafik: TBitMap;
    FSpieleBmp:TBitmap;
    AnimationsBreite:Integer;
  public
    { Public-Deklarationen }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.FormCreate(Sender: TObject);
begin
FSpieleBmp:= TBitMap.Create;
FGrafik := TBitmap.Create;
FSpieleBmp.Width:= 30;
FSpieleBmp.Height:= 30;
Timer1.Enabled:=false;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin

    FSpieleBmp.Canvas.Pen.Color := clBlack;
    FSpieleBmp.Canvas.Brush.Color := clBlack;
FSpieleBmp.Canvas.FillRect(rect(0,0,AnimationsBreite+3,30));
AnimationsBreite:=AnimationsBreite+3;
SpieleFeld.Canvas.Draw(0, 0, FGrafik);
  if AnimationsBreite=30 then begin
  Timer1.Enabled:=false;
  AnimationsBreite:=3;
  end;
end;

end.
