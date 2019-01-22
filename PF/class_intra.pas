unit class_intra;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Math, Dialogs, ParseMath;

type
  TIntr = class
  TIntrType: Integer;
    cant: integer;
    points: TStringList;
    procedure execute;

    private
      function lagrange(): string;

      function f(x: real; fxion: String):real;

    public
      mx,
      mn,
      num_: real;
      dfunx,
      fsol: String;
      frpt,
      Vrpt: TStringList;
      constructor create;
      destructor Destroy; override;

  end;

const
  F_L= 0;

implementation

constructor TIntr.create;
begin
  points:= TStringList.Create;
  frpt:= TStringList.Create;
  Vrpt:= TStringList.Create;
end;

destructor TIntr.Destroy;
begin
   points.Destroy;
   frpt.Destroy;
   Vrpt.Destroy;
end;

procedure TIntr.execute;
begin
          case TIntrType of
             F_L:lagrange();
          end;
end;

function TIntr.f(x: real; fxion: string): real;
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

function TIntr.lagrange: String;
var
   l,
   val,valor:real;
   i,j,igual:integer;
   polinomio,lx: String;
begin
    val:=0;
    polinomio:='';

    i:=0;
    while i<= cant do begin
      if (mx<StrToFloat(points[i]))  then
         mx:=StrToFloat(points[i]);
      if (mn>StrToFloat(points[i]))  then
         mn:= StrToFloat(points[i]);
      i:=i+2;
    end;

    if(num_ > mx) or (num_ < mn) then
         begin
          ShowMessage('min: '+FloatToStr(mn));
          ShowMessage('max: '+FloatToStr(mx));
          //Memo1.Lines.Add('el valor no se encuentra dentro del intervalo');
          ShowMessage('el valor no se encuentra dentro del intervalo');
          exit;
         end;
    i:=0;
    ShowMessage('cccc '+IntToStr(points.Count));
    while i < points.Count do begin
          l:=StrToFloat(points[i+1]);
          j:=0;
          while j < points.Count do begin
              if i=j then
                igual:=i;
              if i<>j then
                begin
                l:=(l*(num_-StrToFloat(points[j]))/(StrToFloat(points[i])-StrToFloat(points[j])));
                end;
              j:=j+2;
          end;
          i:=i+2;
          val:=val+l;

     end;
     valor:=1;
     i:=0;
     while i < points.Count do begin
          lx:='';
          valor:=1;
          j:=0;
          while j < points.Count do begin
              if i<>j then begin
                lx:=lx+'*(x-'+ points[j]+')';
                valor:=valor*(StrToFloat(points[i])-StrToFloat(points[j]));
              end;
              j:=j+2;
          end;
          if i=0 then begin
             polinomio:=points[i+1]+'/'+FloatToStr(valor)+lx;
          end
          else begin
             polinomio:=polinomio+'+'+points[i+1]+'/'+FloatToStr(valor)+lx;;
          end;
          i:=i+2;
     end;
     frpt.Add(polinomio);
     Vrpt.Add('Reemplazando con el dato: '+FloatToStr(val));

end;

//y=Ae^cx -> lny = lnAe^cx
//bias=lnA -> e^bias=A

end.

