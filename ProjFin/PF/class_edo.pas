unit class_edo;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Math, Dialogs, ParseMath;

type
  TEDO = class
    Error: Real;
    xi: real;
    EDOType: Integer;
    procedure execute;

    private
      step: Integer;
      fx: real;
      procedure euler();
      procedure heun();
      procedure runge_kutta4();
      procedure dormand_price();

      function fD(x, y: real; fxion: String):real;

    public
      h,
      x,
      y,
      N: real;
      dfunx,
      fsol: String;
      Lry,
      Lfx: TStringList;
      constructor create;
      destructor Destroy; override;

  end;

const
  F_E = 0;
  F_H = 1;
  F_RK4 = 2;
  F_DP = 3;
implementation

constructor TEDO.create;
begin
  Lry:= TStringList.Create;
  Lfx:= TStringList.Create;
  fx:= 0;
  step:= 0;
  h:=0.25;
end;

destructor TEDO.Destroy;
begin
   Lry.Destroy;
   Lfx.Destroy;
end;

procedure TEDO.execute;
begin
     case EDOType of
          F_E: euler();
          F_H: heun();
          F_RK4: runge_kutta4();
          F_DP: dormand_price();
     end;
end;

function TEDO.fD(x, y: real; fxion: string): real;
var Parse: TParseMath;
begin
  try
      Parse:= TParseMath.create();
      Parse.AddVariable('x',x);
      Parse.AddVariable('y',y);
      Parse.Expression:= fxion;
      fD:=Parse.Evaluate();
  except
      exit;
  end;
  Parse.destroy;
end;

procedure TEDO.euler;
var
  i:integer;
  value_sol: real;
begin
     //h:=(y-x)/N;
     Lfx.Add(FloatToStr(y));
     Lry.Add(FloatToStr(x));
     i:=1;
     while i <= N do begin
         fx:=y + h*fD(x, y, dfunx );
         x:=x+h;

         Lfx.Add(FloatToStr(fx));
         //----origin valors
         //value_f_sol:=calcula(x,0,f_sol.Text);//value_f_sol:=calcula(x,fx,f_sol.Text);
         //StringGrid1.Cells[2,i+1]:=FloatToStr(RoundTo(value_f_sol,-6));
         value_sol:= fD(x, 0, fsol);
         Lry.Add(FloatToStr(value_sol));
         y:=fx;
         i:=i+1
        end;

end;

procedure TEDO.heun;
var
  i:integer;
  value_sol,
  f_x,
  r: real;
begin
     //h:=(y-x)/N;
     Lfx.Add(FloatToStr(y));
     Lry.Add(FloatToStr(x));
     i:=1;
     while i <= N do begin
         r:= fD(x, y, dfunx);
         f_x:=y + h*r;
         x:=x+h;

         fx:=y + h*(r+ fD(x, f_x, dfunx))/2;
         Lfx.Add(FloatToStr(fx));
         //StringGrid1.Cells[4,i+1]:=FloatToStr(RoundTo(fx,-6));
         value_sol:= fD(x, 0, fsol);
         Lry.Add(FloatToStr(value_sol));

         y:= fx;
         i:= i+1
        end;
end;

procedure TEDO.runge_kutta4;
var
  value_sol,
  pendiente,
  k1,k2,k3,k4: Real;
begin
  //h:=(y-x)/N;
  if N<0 then begin
      while x>= N do begin
             k1:=0; k2:=0; k3:=0; k4:=0;
             k1:=fD(x, y, dfunx);
             k2:=fD(x+h/2, y+k1*h/2, dfunx);
             k3:=fD(x+h/2, y+k2*h/2, dfunx);
             k4:=fD(x+h, y+k3*h, dfunx);

             pendiente:=(k1+2*k2+2*k3+k4)/6;
             Lfx.Add(FloatToStr(y));

             value_sol:= fD(x, 0, fsol);
             Lry.Add(FloatToStr(value_sol));

             y:=y+h*pendiente;
             x:=x-h;
          end;
  end
  else begin
        while x< N do begin
           k1:=0; k2:=0; k3:=0; k4:=0;
           k1:=fD(x, y, dfunx);
           k2:=fD(x+h/2, y+k1*h/2, dfunx);
           k3:=fD(x+h/2, y+k2*h/2, dfunx);
           k4:=fD(x+h, y+k3*h, dfunx);
           pendiente:=(k1+2*k2+2*k3+k4)/6;
           Lfx.Add(FloatToStr(y));

           value_sol:= fD(x, 0, fsol);
           Lry.Add(FloatToStr(value_sol));

           y:=y+ h*pendiente;
           x:=x+ h;
        end;
  end;
end;

procedure TEDO.dormand_price;
var
  value_sol,
  pendiente,
  k1,k2,k3,k4,k5,k6,k7: Real;
begin
   if N<0 then begin
       while x>=N do begin
          k1:=h*fD(x, y, dfunx);
          k2:=h*fD(x+h/5, y+1/5*k1, dfunx);
          k3:=h*fD(x+3/10*h, y+3/40*k1+9/40*k2,dfunx);
          k4:=h*fD(x+4/5*h, y+44/45*k1-56/15*k2+32/9*k3, dfunx);
          k5:=h*fD(x+8/9*h, y+19372/6561*k1-25360/2187*k2+64448/6561*k3-212/729*k4, dfunx);
          k6:=h*fD(x+h, y+9017/3168*k1-355/33*k2-46732/5247*k3+49/176*k4-5103/18656*k5, dfunx);
          k7:=h*fD(x+h, y+35/384*k1+500/1113*k3+125/192*k4-2187/6784*k5+11/84*k6, dfunx);
          pendiente:=35/384*k1+500/1113*k3+125/192*k4-2187/6784*k5+11/84*k6;
          Lfx.Add(FloatToStr(y));

          value_sol:= fD(x, 0, fsol);
          Lry.Add(FloatToStr(value_sol));
          y:=y+ pendiente;
          x:=x-h;
       end;
   end
   else begin
      while x<N do begin
         k1:=h*fD(x, y, dfunx);
          k2:=h*fD(x+h/5, y+1/5*k1, dfunx);
          k3:=h*fD(x+3/10*h, y+3/40*k1+9/40*k2,dfunx);
          k4:=h*fD(x+4/5*h, y+44/45*k1-56/15*k2+32/9*k3, dfunx);
          k5:=h*fD(x+8/9*h, y+19372/6561*k1-25360/2187*k2+64448/6561*k3-212/729*k4, dfunx);
          k6:=h*fD(x+h, y+9017/3168*k1-355/33*k2-46732/5247*k3+49/176*k4-5103/18656*k5, dfunx);
          k7:=h*fD(x+h, y+35/384*k1+500/1113*k3+125/192*k4-2187/6784*k5+11/84*k6, dfunx);
          pendiente:=35/384*k1+500/1113*k3+125/192*k4-2187/6784*k5+11/84*k6;
          Lfx.Add(FloatToStr(y));

          value_sol:= fD(x, 0, fsol);
          Lry.Add(FloatToStr(value_sol));
          y:=y+ pendiente;
          x:=x+h;
      end;
   end;
end;

end.

