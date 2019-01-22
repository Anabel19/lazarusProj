unit class_intg;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Dialogs, ParseMath;

type
  TIntGral = class
    funx:String;
    a,
    b,
    N: real; //nro particiones
    MIntgType: Integer;
    function execute: Real;

    private
      step,
      stepi: Integer;
      xn: real;
      function trapecio(): real;
      function simpsom1_3(): real;
      function simpsom3_8(): real;
      function primitiva(): real;

      function f(x:real):real;

    public
      constructor create;
      destructor Destroy; override;

  end;

const
  F_T = 0;
  F_S13 = 1;
  F_S38 = 2;
  F_P = 3;

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

function TIntGral.execute: Real;
begin
     case MIntgType of
          F_T: Result:= trapecio();
          F_S13: Result:= simpsom1_3();
          F_S38: Result:= simpsom3_8();
          F_P: Result:= primitiva();
     end;
end;

function TIntGral.f(x: real): real;
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

function TIntGral.primitiva: Real;
begin
    Result:= f(a)-f(b)
end;

function TIntGral.trapecio: Real;
var InWhile:Boolean;
    xi,
    h:real;
    sum_xi:real;

begin
  sum_xi:= 0;
  step:= 1;
  xn:=0;
  xi:=a;
  InWhile:= (b >= xi);
  h:=(b-a)/(N);
  while InWhile do begin
        xi:= xi+ h;
        sum_xi:=sum_xi+ f(xi);
        //ShowMessage('sum '+ FloatToStr(sum_xi));
        step:= step + 1;
        InWhile:= (b >= xi) and (step< N);
  end;
  xn:=(h/2)*(f(a)+f(b)+2*(sum_xi));
  Result:=xn;
end;

function TIntGral.simpsom1_3: Real;
var InWhile:Boolean;
    xi,
    h:real;
    sum_par,
    sum_imp:real;

begin
  sum_par:= 0;  sum_imp:=0;
  step:= 2;
  xn:=0;
  xi:=a;
  InWhile:= (b >= xi);
  h:=(b-a)/(2*N);
  while InWhile do begin
        xi:= xi+ 2*h;
        sum_par:=sum_par+ f(xi);
        step:= step + 2;
        InWhile:= (b >= xi) and (step< 2*N);
  end;
  InWhile:= (b >= xi);
  xi:=a+h;
  stepi:=3;   //porq el primer value dont find in the add[sum_imp]
  while InWhile do begin
        xi:= xi+ 2*h;
        sum_imp:=sum_imp+ f(xi);
        stepi:= stepi + 2;
        InWhile:= (b >= xi) and (stepi< 2*N);
  end;
   //ShowMessage('iiii'+FloatToStr(sum_imp+f(a+h)));  ShowMessage('pppp'+FloatToStr(sum_par));
  xn:=(h/3)*(f(a)+f(b)+2*(sum_par)+4*(sum_imp+f(a+h)));
  Result:=xn;
end;

function TIntGral.simpsom3_8: real;
var
  xi,h,rpta,
  sum_1,
  sum_2,
  sum_3: real;
begin
  sum_1:=0;
  sum_2:=0;
  sum_3:=0;
  h:=(b-a)/N;
  xi:=a+h;

  repeat
    sum_1:=sum_1+ f(xi);
    xi:=xi+ 3*h;
  until (xi> b-2*h);

  xi:= a+2*h;
  repeat
    sum_2:=sum_2+ f(xi);
    xi:= xi+3*h;
  until (xi> b-h);

  xi:= a+3*h;
  repeat
    sum_3:=sum_3+ f(xi);
    xi:=xi+3*h;
  until (xi> b-3*h);

  //ShowMessage(FloatToStr((3*h)/8)*(f(a)+f(b)+3*(sum_1)+3*(sum_2)+ 2*(sum_3)));
  rpta:=((3*h)/8)*(f(a)+f(b)+3*(sum_1)+3*(sum_2)+ 2*(sum_3));
  ShowMessage(FloatToStr(rpta));
  xn:=((3*h)/8)*(f(a)+f(b)+3*(sum_1)+3*(sum_2)+ 2*(sum_3));
  Result:=xn; //(3*h/8)*(f(a)+f(b))+(9*h/8)*sum_1+(9*h/8)*sum_2+(6*h/8)*sum_3;
end;

 {
function TIntGral.simpsom3_8: real;
var InWhile: Boolean;
  xi,h,i,
  sum_1,
  sum_2,
  sum_3: real;
begin
  sum_1:=0;
  sum_2:=0;
  sum_3:=0;
  h:=(b-a)/(3*N);

  xi:=a+h;
  InWhile:= (xi <= b-2*h);
  while InWhile do begin
    xi:=xi+ 3*h;
    sum_1:=sum_1+ f(xi);
    InWhile:= (xi <= b-2*h);
  end;

  xi:= a+2*h;
  InWhile:= (xi <= b-h);
  while  InWhile do begin
    xi:= xi+3*h;
    sum_2:=sum_2+ f(xi);
    InWhile:= (xi <= b-h);
  end;

  xi:= a+3*h;
  InWhile:= (xi <= b-3*h);
  while InWhile do begin
    xi:=xi+3*h;
    sum_3:=sum_3+ f(xi);
    InWhile:= (xi <= b-3*h);
  end;

  xn:=((3*h)/8)*(f(a)+f(b)+3*(sum_1+f(a+h))+3*(sum_2+f(a+2*h))+ 2*(sum_3+f(a+3*h)));
  ShowMessage(FloatToStr(xn));
  Result:=xn; //(3*h/8)*(f(a)+f(b))+(9*h/8)*sum_1+(9*h/8)*sum_2+(6*h/8)*sum_3;
end;
 }
end.

