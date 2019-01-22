unit intersec;

{$mode objfpc}{$H+}

interface

uses
  Classes, Dialogs, SysUtils, ParseMath,math;

type
  TInter = class
      min_,
      max_,
      Error:real;
      procedure execute();
    //function biseccion(a:real; b:real):real;
    //procedure secante();
    private
      step: Integer;
      xn,
      xnant,
      ErrorCal: real;
      //Parse: TParseMath;
      procedure interseccion();
      procedure biseccion(a:real; b:real);
      procedure secante();
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
  //ErrorCal:=1000000;
  Error:=0.0001;
end;

destructor TInter.Destroy;
begin
   //Parse.destroy;
   Lfunxions.Destroy;
   Lr.Destroy;
   Lfr:= TStringList.Create;
end;

procedure TInter.execute();
begin
   interseccion();
end;

//sin(x)/x^2+ln(x)-x
//1-x

procedure TInter.interseccion();
var
  Varx,
  vx: real;
begin
  Lr.Clear;  Lfr.Clear;
  Varx:= max_;
  vx:=0.2;
  while Varx > min_ do begin
      ErrorCal:=1000000;
      biseccion(Varx,Varx+vx);
      Varx:=Varx-vx;
       //else begin ShowMessage('no hay interseccion'); exit; end
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
procedure TInter.biseccion(a:real; b:real);
var StayInWhile: Boolean;
    s:real;
begin
  //Lr.Clear; Lfr.Clear;
  step:= 0;
  xn:=0;
  StayInWhile:= ( ErrorCal >= Error );

  if (IsNan(f(a)) or IsNan(f(b))) then begin //exit;
           exit; end;
  if (f(a)*f(b))>0 then begin
     exit;     end
  //else if f(a)=0 then begin xn:=a; exit; end
  //else if f(b)=0 then begin xn:=b; exit; end
  else begin
   while StayInWhile do begin
        xnant:= xn;
        xn:= (a+b)/2;
        s:= f(a)*f(xn);
        if(s<0) then begin
           b:=xn;  end
        else begin a:=xn;  end;
        //Lxn.Add( FloatToStr( xn ) );
        //Lsig.Add(  sign  );
        ErrorCal:= abs( xn - xnant );
        step:= step + 1;
        StayInWhile:= ( ErrorCal >= Error ) and (step < MaxIteration);
    end; ShowMessage('xxxxx'+FloatToStr(xn));
    Lr.Add(FloatToStr(xn)); //save raices
         ShowMessage('f_xxxxx'+FloatToStr(f_(xn,Lfunxions[0])));
    Lfr.Add(FloatToStr(f_(xn,Lfunxions[0])));
   end;
end;
  {
procedure Show;
begin
   ShowPoints:=true;
end;
 }
procedure TInter.secante;
var StayInWhile: Boolean;
    s,
    h,
    xi:real;
begin
  //Lxn.Clear;
  h:=Error/10;
  step:= 0;
  xn:=0;
  StayInWhile:= ( ErrorCal >= Error );
    while StayInWhile do begin
        xnant:= xn;
        xn:= xi-((2*h*f(xi))/(f(xi+h)-f(xi-h)));

        //Lxn.Add( FloatToStr( xn ) );
        ErrorCal:= abs( xn - xnant );
        xi:=xn;
        step:= step + 1;
        StayInWhile:= ( ErrorCal >= Error ) and (step < MaxIteration);
   // Result:= xn;
   end;
end;


end.

