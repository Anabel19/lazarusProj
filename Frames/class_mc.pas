unit class_mc;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Math;

type
  TMC = class
    Error: Real;
    a: real;
    b: real;
    MCType: Integer;
    function execute: Real;

    private
      step: Integer;
      xn,
      xnant,
      ErrorCal: real;
      sign:String;
      function biseccion(): real;
      function falsa_posicion(): real;

      function f(x:real):real;
      //function signo(a,xi:double):string;

    public
      Lxn: TStringList;
      Lsig: TStringList;
      constructor create;
      destructor Destroy; override;

  end;

const
  F_B = 0;
  F_FP = 1;

implementation

const
  MaxIteration = 10000;

constructor TMC.create;
begin
  Lxn:= TStringList.Create;
  Lsig:= TStringList.Create;
  xn:= 0;
  xnant:= 0;
  step:= 0;
  ErrorCal:= 1000000;

end;

destructor TMC.Destroy;
begin
   Lxn.Destroy;
   Lsig.Destroy;
end;

function TMC.execute: Real;
begin
     case MCType of
          F_B: Result:= biseccion();
          F_FP: Result:= falsa_posicion();

     end;
end;

function TMC.f(x:real):Real;
begin
   //Result:=tan(x)-10;
   Result:= exp(x)/x+x-power(x,2)-4;
end;

function TMC.biseccion: Real;
var StayInWhile: Boolean;
    s:real;
begin
  Lxn.Clear; Lsig.Clear;
  step:= 0;
  xn:=0;
  StayInWhile:= ( ErrorCal >= Error );
  if (f(a)*f(b))>0 then
     exit

  else begin
    while StayInWhile do begin
        xnant:= xn;
        xn:= (a+b)/2;
        s:= f(a)*f(xn);
        if(s<0) then begin
           b:=xn; sign:='-'; end
        else begin a:=xn; sign:='+'; end;
        //xn := xn + exponential( -1, step ) * exponential( x, 2 * step + 1 ) / (factorial( 2* step + 1 ));
        Lxn.Add( FloatToStr( xn ) );
        Lsig.Add(  sign  );
        ErrorCal:= abs( xn - xnant );
        step:= step + 1;
        StayInWhile:= ( ErrorCal >= Error ) and (step < MaxIteration);
    end;
    Result:= xn;
   end;
end;

function TMC.falsa_posicion: Real;
var StayInWhile: Boolean;
    s:real;
begin
  Lxn.Clear; Lsig.Clear;
  step:= 0;
  xn:=0;
  StayInWhile:= ( ErrorCal >= Error );
  if (f(a)*f(b))>0 then
     exit

  else begin
    while StayInWhile do begin
        xnant:= xn;
        xn:= (a-f(a)*(b-a))/(f(b)-f(a));//a-(f(a)*(b-a/(f(b)-f(a))));
        s:= f(a)*f(xn);
        if(s<0) then begin
           b:=xn; sign:='-'; end
        else begin a:=xn; sign:='+'; end;
        //xn := xn + exponential( -1, step ) * exponential( x, 2 * step + 1 ) / (factorial( 2* step + 1 ));
        Lxn.Add( FloatToStr( xn ) );
        Lsig.Add(  sign  );
        ErrorCal:= abs( xn - xnant );
        step:= step + 1;
        StayInWhile:= ( ErrorCal >= Error ) and (step < MaxIteration);
    end;
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

