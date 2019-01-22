unit class_intra;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Math, Dialogs, ParseMath;

type
  TInter = class
  TInterType: Integer;
    cant: integer;
    points: TStringList;
    procedure execute;

    private
      function lagrange(): string;

      function f(x: real; fxion: String):real;

    public
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

constructor TInter.create;
begin
  points:= TStringList.Create;
  frpt:= TStringList.Create;
  Vrpt:= TStringList.Create;
end;

destructor TInter.Destroy;
begin
   points.Destroy;
   frpt.Destroy;
   Vrpt.Destroy;
end;

procedure TInter.execute;
begin
          case TInterType of
             F_L:lagrange();
          end;
end;

function TInter.f(x: real; fxion: string): real;
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

function TInter.lagrange: String;
var
   mx,mn, //max-min
   l,val,valor:real;
   i,j,igual:integer;
   polinomio,lx: String;
begin
    val:=0;
    polinomio:='';

    i:=0;
    mx:=StrToFloat(points[0]);
    mn:=StrToFloat(points[0]);
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
    while i < cant*2 do begin
          l:=StrToFloat(points[i+1]);
          //ejey:=StrToFloat(StringGrid3.Cells[1,i]);
          j:=0;
          while j < cant*2 do begin
            ShowMessage('||||| '+IntToStr(j));
              if i=j then
                igual:=i;
              if i<>j then
                begin
                 //ShowMessage(IntToStr(i)+'------'+IntToStr(j));

                 //ShowMessage('jjj....'+points[j]);
                //ShowMessage('ii....'+points[i]);
                l:=(l*(num_-StrToFloat(points[j]))/(StrToFloat(points[i])-StrToFloat(points[j])));
                ShowMessage('l....'+FloatToStr(l));
                end;
              j:=j+2;
          end;
          i:=i+2;
          val:=val+l;

     end;
     valor:=1;
     i:=0;
     while i < cant*2 do begin
          lx:='';
          valor:=1;
          j:=0;
          while j < cant*2 do begin
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

