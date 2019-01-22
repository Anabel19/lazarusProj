unit intersec;

{$mode objfpc}{$H+}

interface

uses
  Classes, Dialogs, SysUtils, ParseMath,math, class_mc, class_ma;

type
  TInter = class
      min_,
      max_,
      Error,
      vx:real;
      pointt: Real;
      procedure execute();
    //function biseccion(a:real; b:real):real;
    //procedure secante();
    private
      step: Integer;
      xn:Real;
      //xnant,
      //ErrorCal: real;
      //Parse: TParseMath;
      MC: TMC;
      MA: TMA;
      procedure interseccion();
      function VerifBolzano(a:real;b:real):Boolean;
      //procedure biseccion(a:real; b:real);

      function f(x_:real):real;
      function f_(x_: real; fx:String): real;
      //procedure Show;
    public
      Lr,
      Lfr,
      Lfunxions: TStringList;
      constructor create;
      destructor Destroy; override;
   end;

implementation
const
  MaxIteration = 10000;

constructor TInter.create;
begin
  //Parse:=TParseMath.create();
  Lfunxions:= TStringList.Create;
  Lr:= TStringList.Create;
  Lfr:= TStringList.Create;
  MC:=TMC.create;
  MA:=TMA.create;
  //ErrorCal:=1000000;
  //Error:=0.0001;
end;

destructor TInter.Destroy;
begin
   //Parse.destroy;
   Lfunxions.Destroy;
   Lr.Destroy;
   Lfr.Destroy;
   MC.Destroy;
   MA.Destroy;
end;

procedure TInter.execute();
begin
   interseccion();
end;

//sin(x)/x^2+ln(x)-x
//1-x

procedure TInter.interseccion();
var
  Varx: Real;
begin
  Lr.Clear;  Lfr.Clear;
  Varx:= max_;
  while Varx > min_ do begin
      MC.ErrorCal:=1000000;
      MC.Error:=0.0001;
      if VerifBolzano(Varx,Varx+vx) = True then begin
         MC.funx:=Lfunxions[0]+'-'+'('+Lfunxions[1]+')'; //new function[f(x)-g(x)];
         MC.a:=Varx;
         MC.b:=Varx+vx;
         xn:= MC.biseccion();
         Lr.Add(FloatToStr(xn));
         Lfr.Add(FloatToStr(f_(xn,Lfunxions[0])));
         end;
      {else begin
         MA.funx:=Lfunxions[0]+'-'+'('+Lfunxions[1]+')';
         MA.xi:=pointt;
         xn:=MA.secante();
         Lr.Add(FloatToStr(xn));
         Lfr.Add(FloatToStr(f_(xn,Lfunxions[0])));
      end;}
      //biseccion(Varx,Varx+vx);
      Varx:=Varx-vx;
    end;
  if Lr.Count=0 then begin
     //Lr.Add('no hay interseccion');
     ShowMessage('no hay interseccion');
     exit;
  //Result:= xnf;
  end;

end;

function TInter.f(x_: real): real;
var Parse: TParseMath;
begin
  try
      Parse:=TParseMath.create();
      Parse.AddVariable('x',x_) ;
      Parse.Expression:=Lfunxions[0]+'-'+'('+Lfunxions[1]+')'; //new function[f(x)-g(x)];
      f:=Parse.Evaluate();
  except
    //ShowMessage('error en la funcion');
    exit;
  end;
  Parse.destroy;
end;

function TInter.f_(x_: real; fx:String): real;
var Parse: TParseMath;
begin
  try
      Parse:=TParseMath.create();
      Parse.AddVariable('x',x_) ;
      Parse.Expression:=fx;
      f_:=Parse.Evaluate();
  except
    //ShowMessage('error en la funcion');
    exit;
  end;
  Parse.destroy;
end;

//sin(x)/x^2+ln(x)-x  //sin(x)/power(x,2)+ln(x)-x
//1-x

//1/x
//(x/10)^2-200
function TInter.VerifBolzano(a:real;b:real):Boolean;
begin
  if (IsNan(f(a)) or IsNan(f(b))) then begin
     //  Result:=False;
       exit;
  end;
  if (f(a)*f(b))>0 then begin
       //NoSeSabe();
       Result:=False;
    // exit;
  end
  else begin
      Result:=True;
  end;
end;

end.

