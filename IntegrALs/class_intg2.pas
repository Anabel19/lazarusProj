unit class_intg2;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Dialogs, ParseMath, Math;

type
  TIntGral = class
    funx:String;
    a,
    b,
    N: float; //nro particiones
    MIntgType: Integer;
    function execute: float;

    private
      //MiParse: TParseMath;
      step,
      stepi: Integer;
      xn: float;
      function trapecio(): float;
      function simpsom1_3(): float;
      function simpsom3_8(): float;

      function f(x:real):float;

    public
      constructor create;
      destructor Destroy; override;

  end;

const
  F_T = 0;
  F_S13 = 1;
  F_S38 = 2;

implementation

constructor TIntGral.create;
begin
  xn:= 0;
  step:= 0;
  stepi:= 0;
end;

destructor TIntGral.Destroy;
begin

end;

function TIntGral.execute: float;
begin
     case MIntgType of
          F_T: Result:= trapecio();
          F_S13: Result:= simpsom1_3();
          F_S38: Result:= simpsom3_8();
     end;
end;

function TIntGral.f(x: real): float;
var Parse: TParseMath;
begin
  try
      Parse:=TParseMath.create();
      Parse.AddVariable('x',x) ;
      Parse.Expression:= funx;
      //ShowMessage('Parse.Expression: '+Parse.Expression);
      f:=Parse.Evaluate();
  except
    //ShowMessage('error en la funcion');
    exit;
  end;
  Parse.destroy;
end;

function TIntGral.trapecio: float;
var InWhile:Boolean;
    xi,
    h:float;
    sum_xi: float;

begin
    h:=(b-a)/N;
    sum_xi:=0;

    xi:=a+h;
    repeat
      sum_xi:=sum_xi + f(xi);
      xi:=xi+h;
    until xi >= b;
  xn:=0.5*h*(f(a)+f(b))+h*sum_xi;

end;

function TIntGral.simpsom1_3: float;
var InWhile:Boolean;
    xi,
    h:real;
    sum_par,
    sum_imp: float;

begin
    h:=(b-a)/N;
    sum_par:=0;
    sum_imp:=0;

    xi:= a+h;
    repeat
       sum_par:=sum_par+ f(xi);
       xi:=xi+ 2*h;
    until xi >= b;

    xi:= a+2*h;
    repeat
      sum_imp:=sum_imp+ f(xi);
      xi:=xi+2*h;
    until xi >= b-h;

    xn:=(h/3)*(f(a)+f(b))+(2*h/3)*sum_par+(4*h/3)*sum_imp;
    Result:=xn;
end;

function TIntGral.simpsom3_8: float;
var InWhile: Boolean;
    xi,h,i,
    sum_1,
    sum_2,
    sum_3: float;
begin
    h:=(b-a)/N;
    sum_1:=0;
    sum_2:=0;
    sum_3:=0;

    xi:= a+h;
    repeat
       sum_1:=sum_1+ f(xi);
       xi:=xi+3*h;
    until (xi > b-2*h);

    xi:= a+2*h;
    repeat
      sum_2:=sum_2+ f(xi);
      xi:= xi+3*h;
    until (xi > b-h);

    xi:= a+3*h;
    repeat
       sum_3:=sum_3+ f(xi);
       xi:= xi+3*h;
    until (xi > b-3*h);

  Result:=(3*h/8)*(f(a)+f(b))+(9*h/8)*sum_1+(9*h/8)*sum_2+(6*h/8)*sum_3;
end;

end.

