unit class_extra;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Math, Dialogs, ParseMath;

type
  TExtra = class
    cant: integer;
    points: TStringList;
    procedure execute;

    private
      function lineal(): string;
      function exponencial(): string;
      function logaritmica(): string;
      function senoidal(): string;

      function f(x: real; fxion: String):real;

    public
      rLi,
      rE,
      rLog,
      rSin: real;
      dfunx,
      fsol: String;
      frpt,
      Rrpt: TStringList;
      constructor create;
      destructor Destroy; override;

  end;

implementation
var promX, promY: real;
constructor TExtra.create;
begin
  points:= TStringList.Create;
  frpt:= TStringList.Create;
  Rrpt:= TStringList.Create;

end;

destructor TExtra.Destroy;
begin
   points.Destroy;
   frpt.Destroy;
   Rrpt.Destroy;
end;

procedure TExtra.execute;
begin
          frpt.Add(lineal());
          ShowMessage('e '+exponencial());
          frpt.Add(exponencial());
          ShowMessage('l '+logaritmica());
          frpt.Add(logaritmica());
          //frpt.Add(senoidal());

          Rrpt.Add(FloatToStr(rLi));
          Rrpt.Add(FloatToStr(rE));
          Rrpt.Add(FloatToStr(rLog));
          //Rrpt.Add(FloatToStr(rSin));
end;

function TExtra.f(x: real; fxion: string): real;
var Parse: TParseMath;
begin
  try
      Parse:= TParseMath.create();
      Parse.AddVariable('x',x);
      Parse.Expression:= fxion;
      result:=Parse.Evaluate();
  except
      exit;
  end;
  Parse.destroy;
end;

function TExtra.lineal: String;
var i: integer;
    vfy, vfx: real;
    rpta: string;
    sumX, sumY,
    promX, promY,
    sumRY, sumYY,
    tmp: real;
begin
    vfx:= 0;  vfy:=0;
    sumX:=0;  sumY:=0;
    i:=0;
    while (i < points.Count) do begin
        sumX:= sumX + StrToFloat(points[i]);
        sumY:= sumY + StrToFloat(points[i+1]);
        i:=i+2;
    end;
    promX:= sumX/cant;
    promY:= sumY/cant;
    i:=0;
    while (i < points.Count) do begin
        vfy:= vfy + ((StrToFloat(points[i])- promX)*(StrToFloat(points[i+1]) - promY));
        vfx:= vfx + power((StrToFloat(points[i]) - promX),2);
        i:= i+2;
    end;
    rpta:=FloatToStr(vfy/vfx)+'*x'+ FloatToStr(promY - (vfy/vfx)*promX);                 //y= mx + b

    //hallando r al cuadrado
    sumRY:=0;    i:=0;
    while (i < points.Count) do begin
       tmp:= f(StrToFloat(points[i]), rpta);
       sumRY:= sumRY + power((tmp - promY), 2);
       i:=i+2;
    end;
    sumYY:=0;     i:=0;
    while (i < points.Count) do begin
      sumYY:=sumYY + power((StrToFloat(points[i+1]) - promY),2);
      i:=i+2;
    end;

    rLi:=sqrt(sumRY/sumyy);
    Result:=rpta;
end;

function TExtra.exponencial: String;
var i: integer;
    vfy, vfx,
    A,
    sumX, sumY,
    sumRY, sumYY,
    aux: real;
    pt,
    rpta: string;
    tmp: TStringList;
begin
    tmp:= TStringList.Create;
    vfy:=0;   vfx:=0;
    sumX:=0;  sumY:=0;
    i:=0;
    while (i < points.Count) do begin
        tmp.Add(points[i]);
        tmp.Add(FloatToStr(ln(StrToFloat(points[i+1]))));
        i:=i+2;
    end;
    i:=0;
    while (i < tmp.Count) do begin
        sumX:= sumX + StrToFloat(tmp[i]);
        sumY:= sumY + StrToFloat(tmp[i+1]);
        i:=i+2;
    end;
    promX:= sumX/cant;
    promY:= sumY/cant;
    i:=0;
    while (i< tmp.Count) do begin
        vfy:= vfy+ ((StrToFloat(tmp[i+1]) - promY) * (StrToFloat(tmp[i])- promX));
        vfx:= vfx+ power(StrToFloat(tmp[i]) - promX, 2);
        i:= i+2;
    end;
    A:= exp(promY - (vfy/vfx)*promX);
    rpta:= FloatToStr(A)+'*'+ 'exp('+ FloatToStr(vfy/vfx)+'*x )'; //y= a*exp(b*x)

    //hallando r al cuadrado
    sumRY:=0;    i:=0;
    while (i < points.Count) do begin
       aux:= f(StrToFloat(points[i]), rpta);
       sumRY:= sumRY + power((aux - promY), 2);
       i:=i+2;
    end;
    sumYY:=0;     i:=0;
    while (i < points.Count) do begin
      sumYY:=sumYY + power((StrToFloat(points[i+1]) - promY),2);
      i:=i+2;
    end;

    rE:=sqrt(sumRY/sumyy);
    Result:=rpta;
    tmp.Destroy;
end;

function TExtra.logaritmica: string;
var i: integer;
    vfy, vfx,
    A, B,
    xx, xy,
    sumX, sumY,
    sumRY, sumYY,
    aux: real;
    rpta: string;
    tmp: TStringList;
begin
    tmp:= TStringList.Create;
    vfy:=0;   vfx:=0;
    sumX:=0;  sumY:=0;
    xx:=0;    xy:=0;
    i:=0;
    while (i < points.Count) do begin
        tmp.Add(FLoatToStr(ln(StrToFloat(points[i]))));
        tmp.Add(points[i+1]);
        i:=i+2;
    end;
    i:=0;
    while (i < tmp.Count) do begin
        sumX:= sumX + StrToFloat(tmp[i]);
        sumY:= sumY + StrToFloat(tmp[i+1]);
        i:=i+2;
    end;
    promX:= sumX/cant;
    promY:= sumY/cant;
    i:=0;
    while (i< tmp.Count) do begin
        vfy:= vfy+ ((StrToFloat(tmp[i+1]) - promY) * (StrToFloat(tmp[i])- promX));
        vfx:= vfx+ power(StrToFloat(tmp[i]) - promX, 2);
        xy:= xy + (StrToFloat(tmp[i])*StrToFloat(tmp[i+1]));
        xx:= xx + (power(StrToFloat(tmp[i]),2));
        i:= i+2;
    end;
    //A:= (xy - (promY*xx))/(xx-((sumX/(tmp.Count/2))*sumX))
    //B:= promY-(A*(sumX/(tmp.Count/2)))
    rpta:= FloatToStr(promY-(vfy/vfx)*promX)+'+'+ FloatToStr(vfy/vfx)+'*ln(x)'; //y=A+B*LNX
    {if(B<0) then
        rpta:= '('+floatToStr(A)+'*ln(x))-'+FloatToStr(Abs(B))   //y=A+B*LNX
    else
        rpta:= '('+floatToStr(A)+'*ln(x))+'+FloatToStr(B);
     }

     //hallando r al cuadrado
    sumRY:=0;    i:=0;
    while (i < points.Count) do begin
       aux:= f(StrToFloat(points[i]), rpta);
       sumRY:= sumRY + power((aux - promY), 2);
       i:=i+2;
    end;
    sumYY:=0;     i:=0;
    while (i < points.Count) do begin
      sumYY:=sumYY + power((StrToFloat(points[i+1]) - promY),2);
      i:=i+2;
    end;

    rLog:=sqrt(sumRY/sumyy);
    Result:=rpta;
    tmp.Destroy;
end;

//y=Ae^cx -> lny = lnAe^cx
//bias=lnA -> e^bias=A
function TExtra.senoidal: string;
begin

end;

end.

