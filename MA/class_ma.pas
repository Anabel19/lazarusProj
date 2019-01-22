unit class_ma;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Math;

type
  TMA = class
    Error: Real;
    xi: real;
    MAType: Integer;
    function execute: Real;

    private
      step: Integer;
      xn,
      xnant,
      ErrorCal: real;
      function newton(): real;
      function secante(): real;

      function f(x:real):real;
      function df(x:real):real;
      //function signo(a,xi:double):string;

    public
      Lxn: TStringList;
      constructor create;
      destructor Destroy; override;

  end;

const
  F_B = 0;
  F_FP = 1;

implementation

const
  MaxIteration = 10000;

constructor TMA.create;
begin
  Lxn:= TStringList.Create;
  xn:= 0;
  xnant:= 0;
  step:= 0;
  ErrorCal:= 1000000;

end;

destructor TMA.Destroy;
begin
   Lxn.Destroy;
end;

function TMA.execute: Real;
begin
     case MAType of
          F_B: Result:= newton();
          F_FP: Result:= secante();

     end;
end;

function TMA.f(x: real): real;
begin
  try
      f:=ln(x)/x+exp(x)/power(x,2)+power(2,x)/x-power(3,x)/(x-1)-power(x,4)+(3*power(x,3));
   //f:=335-2510*ln((2.8*power(10,6))/((2.8*power(10,6))-((13.3*power(10,3))*x)))-9.81*x;//sin(x)+3*cos(x)-2;
  except
    //ShowMessage('error en la funcion');
    exit;
  end;
end;

function TMA.df(x:real):real;
var
  dp:Double;
begin
  try
   dp:=cos(x)-3*sin(x);//-4*power(x,3)+(exp(x)*(x-2))/power(x,3)+(9*power(x,2))-(power(2,x)/power(x,2))+(1/(power(x,2)))-((ln(x)/ln(10))/power(x,2))+(power(3,x)/(power(x-1,2)))-((power(3,x)*(ln(3)/ln(10)))/(x-1))+((power(2,x)*(ln(2)/ln(10)))/x);
   if dp=0 then
     begin
     //showMessage('la derivacion da cero');
     dp:=dp+0.0000001;
     end;
   df:=dp;
   except
   //ShowMessage('error en la derivacion');
   exit;
  end;
end;

function TMA.newton: Real;
var StayInWhile: Boolean;
    s:real;
begin
  Lxn.Clear;
  step:= 0;
  xn:=0;
  StayInWhile:= ( ErrorCal >= Error );
    while StayInWhile do begin
        xnant:= xn;
        xn:= xn-(f(xi)/df(xi));

        Lxn.Add( FloatToStr( xn ) );
        ErrorCal:= abs( xn - xnant );
        xi:=xn;
        step:= step + 1;
        StayInWhile:= ( ErrorCal >= Error ) and (step < MaxIteration);

    Result:= xn;
   end;
end;

function TMA.secante: Real;
var StayInWhile: Boolean;
    s,
    h:real;
begin
  Lxn.Clear;
  h:=Error/10;
  step:= 0;
  xn:=0;
  StayInWhile:= ( ErrorCal >= Error );
    while StayInWhile do begin
        xnant:= xn;
        xn:= xi-((2*h*f(xi))/(f(xi+h)-f(xi-h)));

        Lxn.Add( FloatToStr( xn ) );
        ErrorCal:= abs( xn - xnant );
        xi:=xn;
        step:= step + 1;
        StayInWhile:= ( ErrorCal >= Error ) and (step < MaxIteration);
    Result:= xn;
   end;
end;
{
function TMC.falsa_posicion: Real;
var StayInWhile: Boolean;
begin
  Lxn.Clear;
  step:= 0;
  xn:=0;
  StayInWhile:= ( ErrorCal >= Error );
  while StayInWhile do begin
      xnant:= xn;
      xn := xn + exponential( -1, step ) * exponential( a, 2 * step ) / (factorial( 2* step ));
      Lxn.Add( FloatToStr( xn ) );
      ErrorCal:= abs( xn - xnant );
      step:= step + 1;
      StayInWhile:= ( ErrorCal >= Error ) and (step < MaxIteration);
  end;
  Result:= xn;
end;
}
end.

