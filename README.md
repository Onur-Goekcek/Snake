# Snake
unit AddresseBuch;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls;

type
spieleStatus=(sSnake,SnakeKopf, sPower, sleer,SnakeEnde,sHinderniss);
  TForm2 = class(TForm)
    SpieleFeld: TPaintBox;
    SnakeMove: TTimer;
    AnimationTimer: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure SnakeMoveTimer(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure AnimationTimerTimer(Sender: TObject);
  private
    { Private-Deklarationen }
    FGrafik: TBitMap;
    breite:Integer;
    a,b:Integer;
    SnakeEndePos,SnakeEndePos2:Integer;
    rechts,Oben,links,unten:Boolean;
    Eingabe:Integer;
    andereEingabe:Integer;
    AnimationsBreite:Integer;
    KopfHoehe:Integer;
    KopfBreite:Integer;
    spielaktive:Boolean;
    SnakeLen:Integer;
    schlange:array  of array of Integer;
    SpielStatus:array of array  of spieleStatus;
    FSpieleBmp: array[spieleStatus] of TBitmap;
    procedure Gitter();
    procedure Bewegungerkennen;
    procedure PowerErstellen;
    procedure SymbolErstellen(breite: Integer; spieler: spieleStatus);
    procedure Pruefen;
    procedure NeuesSpiel;
    procedure AnimationBewegung;
  public
    { Public-Deklarationen }
  end;

var
  Form2: TForm2;

implementation
uses test;

{$R *.dfm}

procedure TForm2.AnimationBewegung;
begin
  if oben=True then begin
    FSpieleBmp[SnakeKopf].Canvas.FillRect(rect(0,breite,breite,Breite-animationsbreite));             //nach oben
  end

  else if Links=True then begin
    FSpieleBmp[SnakeKopf].Canvas.FillRect(rect(breite,breite,breite-animationsbreite,0));      //nach links
  end

  else if rechts=true then begin
    FSpieleBmp[SnakeKopf].Canvas.FillRect(rect(0,0,animationsbreite,breite));          //nach rechts
  end

  else if unten=true then  begin
    FSpieleBmp[SnakeKopf].Canvas.FillRect(rect(0,0,breite,animationsbreite));          //nach unten
  end;

  if (SnakeEndePos=Schlange[0,1]-1) then  begin            //rechts leer
  FSpieleBmp[SnakeEnde].Canvas.Pen.Color:=clblack;
  FSpieleBmp[SnakeEnde].Canvas.Brush.Color:=clblack;
  FSpieleBmp[SnakeEnde].Canvas.Rectangle(0,0,FSpieleBmp[SnakeEnde].Width, FSpieleBmp[SnakeEnde].Height);
  FSpieleBmp[SnakeEnde].Canvas.Brush.Color:=clwhite;
  FSpieleBmp[SnakeEnde].Canvas.FillRect(rect(0,0,animationsbreite+3,Breite));
  end

  else if (SnakeEndePos=Schlange[0,1]+1) then begin                       //links leer
  FSpieleBmp[SnakeEnde].Canvas.Pen.Color:=clblack;
  FSpieleBmp[SnakeEnde].Canvas.Brush.Color:=clblack;
  FSpieleBmp[SnakeEnde].Canvas.Rectangle(0,0,FSpieleBmp[SnakeEnde].Width, FSpieleBmp[SnakeEnde].Height);
  FSpieleBmp[SnakeEnde].Canvas.Brush.Color:=clwhite;
  FSpieleBmp[SnakeEnde].Canvas.FillRect(rect(breite,breite,breite-animationsbreite,0));
  end

  else if (SnakeEndePos2=Schlange[0,0]-1)  then begin         //links unten
  FSpieleBmp[SnakeEnde].Canvas.Pen.Color:=clblack;
  FSpieleBmp[SnakeEnde].Canvas.Brush.Color:=clblack;
  FSpieleBmp[SnakeEnde].Canvas.Rectangle(0,0,FSpieleBmp[SnakeEnde].Width, FSpieleBmp[SnakeEnde].Height);
  FSpieleBmp[SnakeEnde].Canvas.Brush.Color:=clwhite;
  FSpieleBmp[SnakeEnde].Canvas.FillRect(rect(0,0,breite,animationsbreite));
  end

  else if (SnakeEndePos2=Schlange[0,0]+1)  then begin         //links oben
  FSpieleBmp[SnakeEnde].Canvas.Pen.Color:=clblack;
  FSpieleBmp[SnakeEnde].Canvas.Brush.Color:=clblack;
  FSpieleBmp[SnakeEnde].Canvas.Rectangle(0,0,FSpieleBmp[SnakeEnde].Width, FSpieleBmp[SnakeEnde].Height);
  FSpieleBmp[SnakeEnde].Canvas.Brush.Color:=clwhite;
  FSpieleBmp[SnakeEnde].Canvas.FillRect(rect(0,breite,breite,Breite-animationsbreite));
  end

//  end;
end;

procedure TForm2.AnimationTimerTimer(Sender: TObject);
var
Frame:Integer;
begin

FSpieleBmp[SnakeKopf].Canvas.Pen.Color:=clWhite;
FSpieleBmp[SnakeKopf].Canvas.Brush.Color:=clWhite;
FSpieleBmp[SnakeKopf].Canvas.Rectangle(0,0,FSpieleBmp[SnakeKopf].Width, FSpieleBmp[SnakeKopf].Height);
FSpieleBmp[SnakeKopf].Canvas.Pen.Color := clBlack;
FSpieleBmp[SnakeKopf].Canvas.Brush.Color := clBlack;



AnimationBewegung;
//FSpieleBmp[SnakeKopf].Canvas.Rectangle(0,0,animationsbreite,breite);                //essen animation
  if SnakeMove.Interval<=200 then begin
  Frame:=10;
  end

  else begin
    Frame:=6;
  end;

AnimationsBreite:=AnimationsBreite+Frame;
FGrafik.Canvas.Draw(KopfBreite*breite,KopfHoehe*breite,FSpieleBmp[SnakeKopf]);
FGrafik.Canvas.Draw(SnakeEndePos*breite,SnakeEndePos2*breite,FSpieleBmp[SnakeEnde]);
SpieleFeld.Canvas.Draw(0, 0, FGrafik);
  if AnimationsBreite=breite then begin
  AnimationsBreite:=0;
  AnimationTimer.Interval:=SnakeMove.Interval div 8;
  SpielStatus[SnakeEndePos,SnakeEndePos2]:=sLeer;
  AnimationTimer.Enabled:=False;
  end;



end;

procedure TForm2.Bewegungerkennen;
var
i:Integer;
begin
KopfHoehe:=KopfHoehe+andereEingabe;
KopfBreite:=KopfBreite+Eingabe;
  if SpielStatus[KopfBreite,KopfHoehe]=sLeer then begin
    SnakeEndePos:=schlange[0,1];
    SnakeEndePos2:=schlange[0,0];
    SpielStatus[KopfBreite,KopfHoehe]:=sSnake;
      for i := 0 to snakelen-1 do begin
      schlange[i,1]:=schlange[i+1,1];
      schlange[i,0]:=schlange[i+1,0];
      end;
    schlange[snakelen,1]:=Kopfbreite;
    schlange[snakelen,0]:=KopfHoehe;
    AnimationTimer.Enabled:=True;
  end

  else if SpielStatus[KopfBreite,KopfHoehe]=sPower then begin
    inc(SnakeLen);
    setLength(schlange,SnakeLen+1,2);
    SpielStatus[KopfBreite,KopfHoehe]:=sSnake;
    schlange[snakelen,1]:=KopfBreite;
    schlange[snakelen,0]:=KopfHoehe;
    Powererstellen;
     AnimationTimer.Enabled:=True;
  end

  else if SpielStatus[Kopfbreite,Kopfhoehe]=sSnake then begin
  SnakeMove.Enabled:=false;
  showmessage('Verloren Schlangen länge '+inttostr(SnakeLen+1));
  exit;
  end;
end;

procedure TForm2.FormCreate(Sender: TObject);


begin
FGrafik := TBitmap.Create;
FSpieleBmp[sSnake]:= TBitMap.Create;
FspieleBmp[sLeer]:= TBitMap.Create;
FspieleBmp[sPower]:= TBitMap.Create;
FSpieleBmp[SnakeKopf]:= TBitMap.Create;
FSpieleBmp[SnakeEnde]:= TBitMap.Create;
FGrafik.Width := SpieleFeld.Width;
FGrafik.Height := SpieleFeld.Height;
Gitter;
a:=FGrafik.Width div 30+1;
b:=FGrafik.height div 30+1;
SetLength(SpielStatus,a,b);
breite:=30;
AnimationsBreite:=0;
AnimationTimer.Interval:=SnakeMove.Interval div 6;
form2.DoubleBuffered:=True;



end;

procedure TForm2.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin

  if (Key=VK_LEFT) and not (schlange[snakelen,1]-1=schlange[snakelen-1,1]) then begin
    Eingabe:=-1;
    andereEingabe:=0;
    links:=True;
    rechts:=false;
    oben:=false;
    unten:=false;
  end
  else if (Key=VK_Right) and not (schlange[snakelen,1]+1=schlange[snakelen-1,1]) then begin
    Eingabe:=1;
    andereEingabe:=0;
    links:=false;
    rechts:=True;
    oben:=false;
    unten:=false;
  end
  else if (Key=VK_Up) and not (schlange[snakelen,0]-1=schlange[snakelen-1,0]) then begin
    andereEingabe:=-1;
    Eingabe:=0;
    links:=false;
    rechts:=false;
    oben:=True;
    unten:=false;
  end
  else if (Key=VK_Down) and not (schlange[snakelen,0]+1=schlange[snakelen-1,0]) then begin
    andereEingabe:=1;
    Eingabe:=0;
    links:=false;
    rechts:=false;
    oben:=false;
    unten:=True;
  end;

  if Key=vk_f5 then begin
    NeuesSpiel;
  end;

end;



procedure TForm2.FormPaint(Sender: TObject);

begin

gitter;
Symbolerstellen(breite,sSnake);
Symbolerstellen(breite,sLeer);
symbolerstellen(breite,sPower);
symbolerstellen(breite,SnakeKopf);
symbolerstellen(breite,SnakeEnde);
NeuesSpiel;
end;

procedure TForm2.Gitter;
var
  i,j: Integer;
begin
FGrafik.Canvas.Pen.Color:=clWhite;
FGrafik.Canvas.Brush.Color:=clWhite;
FGrafik.Canvas.Rectangle(0,0,FGrafik.Width, FGrafik.Height);
  FGrafik.Canvas.Pen.Color := clBlack;

  for I:=0  to a-1 do begin
    for j := 0 to b-1 do begin
      if (i=KopfBreite) and (j=KopfHoehe) then  begin
//      FGrafik.Canvas.Draw(i*breite,j*breite,FSpieleBmp[SpielStatus[i,j]])
      end
//      else if (i=SnakeEndePos) and (j=SnakeEndePos2) then begin
//
//      end


      else
    FGrafik.Canvas.Draw(i*breite,j*breite,FSpieleBmp[SpielStatus[i,j]])
    end;
  end;
  SpieleFeld.Canvas.Draw(0, 0, FGrafik);
end;



procedure animation; begin

end;
procedure TForm2.NeuesSpiel;
var
i,j:Integer;
begin
snakelen:=2;
setLength(schlange,snakelen+1,2);
schlange[2,1]:=3;
schlange[2,0]:=3;
schlange[1,1]:=2;
schlange[1,0]:=3;
schlange[0,1]:=1;
schlange[0,0]:=3;
KopfHoehe:=3;
KopfBreite:=3;
for i := 0 to a-1 do
  begin
    for j := 0 to b-1 do
      SpielStatus[i,j] := sLeer;
  end;
SpielStatus[3,3]:=sSnake;
SpielStatus[2,3]:=sSnake;
SpielStatus[1,3]:=sSnake;
Powererstellen;
spielaktive:=True;
Eingabe:=1;
andereEingabe:=0;
SnakeMove.Enabled:=True;

end;

procedure TForm2.PowerErstellen;var
PowerBreite,PowerLaenge,i,j:Integer;
begin
i:=a-1;
j:=b-1;
    PowerBreite:=random(i);
    PowerLaenge:=random(j);
      while Spielstatus[PowerBreite,PowerLaenge]=sSnake do begin
      PowerBreite:=random(i);
      PowerLaenge:=random(j);
      end;
    Spielstatus[PowerBreite,PowerLaenge]:=sPower;

end;

procedure TForm2.Pruefen;
begin
  if (KopfBreite>a-2) or (KopfBreite<0)or (KopfHoehe>b-2) or (KopfHoehe<0) then begin
  spielaktive:=false;

  end;

end;

procedure TForm2.SnakeMoveTimer(Sender: TObject);
begin
  if SnakeMove.Interval>100 then begin
  SnakeMove.Interval:= 500-50*SnakeLen;
  end;
pruefen;
  if not spielaktive then begin
  SnakeMove.Enabled:=false;
  showmessage('Verloren Schlangen länge '+inttostr(SnakeLen+1));
  exit;
  end;

Bewegungerkennen;

gitter;


end;

procedure TForm2.SymbolErstellen(breite: Integer; spieler: spieleStatus);
begin
FSpieleBmp[spieler].Width:= Breite;
FSpieleBmp[spieler].Height:= Breite;
FSpieleBmp[spieler].Canvas.Pen.Color := clWhite;
FSpieleBmp[spieler].Canvas.Brush.Color := clWhite;
FSpieleBmp[spieler].Canvas.Rectangle(0,0,breite,breite);
  if spieler=sLeer then begin
    FSpieleBmp[spieler].Canvas.Pen.Color := clWhite;
    FSpieleBmp[spieler].Canvas.Brush.Color := clWhite;
  end

  else if spieler=sSnake then begin
    FSpieleBmp[spieler].Canvas.Pen.Color := clBlack;
    FSpieleBmp[spieler].Canvas.Brush.Color := clBlack;
  end

  else if spieler=sPower then begin
    FSpieleBmp[spieler].Canvas.Pen.Color := clGreen;
    FSpieleBmp[spieler].Canvas.Brush.Color := clGreen;
  end;

FSpieleBmp[spieler].Canvas.Rectangle(0,0,breite,breite) ;
end;

end.
