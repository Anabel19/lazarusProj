unit frame_graphics;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, TAGraph, TASeries, TAFuncSeries, Forms, Controls,
  StdCtrls, ExtCtrls, Dialogs, ComCtrls, ParseMath;

type

  { TFrame1 }

  TFrame1 = class(TFrame)
    Chart1: TChart;
    Area: TAreaSeries;
    Chart1LineSeries1: TLineSeries;
    colorbtnFunction: TColorButton;
    ediMax: TEdit;
    ediMin: TEdit;
    ediStep: TEdit;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Panel1: TPanel;
    Points: TLineSeries;
    ScrollBox1: TScrollBox;
    StatusBar1: TStatusBar;
    TrackBar1: TTrackBar;
    trbarVisible: TTrackBar;
    //procedure FuncionCalculate(const AX: Double; out AY: Double);

  private
    Parse: TParseMath;

    FunctionList:TList;
    ActiveFunction: Integer;
    funtion:TStringList;

    procedure crearLineSeries();
    function f( x: Real ): Real;
    procedure Graficar2D();

  public
    a,
    f_a,
    min,
    max,
    h: real;
    procedure GraficarFunciones(funciones:TStringList);
    procedure Ploteo;
    procedure ShowArea;
    procedure Point;
  end;

 var
   Frame: TFrame1;


implementation
const
  FunctionSeriesName = 'FunctionLines';
{$R *.lfm}


procedure TFrame1.crearlineSeries();
//procedure TFrame1.crearLineSeries();
begin
   FunctionList.Add(TLineSeries.Create(Chart1));
   with TLineSeries(FunctionList[FunctionList.Count-1]) do begin
       Name:=FunctionSeriesName+IntToStr(FunctionList.Count);
       Tag:=FunctionList.Count-1;
   end;
   Chart1.AddSeries(TLineSeries(FunctionList[FunctionList.Count-1]));
end;

procedure TFrame1.GraficarFunciones(funciones:TStringList);
var
  i:Integer;
begin
  //crear los TLineSeries en el tchart
  Parse:=TParseMath.create();
  Parse.AddVariable('x',0);
  FunctionList:= TList.Create;
  funtion:=funciones;
 {FunctionList.Add( TLineSeries.Create( Chart1 ) ); //aqui creamos un LineSeries
   with TLineSeries( FunctionList[ FunctionList.Count - 1 ] ) do begin //a este lineSeries tiene nombre una etiqueta
        Name:= FunctionSeriesName + IntToStr( FunctionList.Count );
        Tag:= EditList.Count - 1; // Edit Asossiated  //etiqueta con elnumero de tag que es

   end;
   Chart1.AddSeries( TLineSeries( FunctionList[ FunctionList.Count - 1 ] ) ); }
   for i:=0 to funciones.Count-1 do begin
        ActiveFunction:=i;
        crearLineSeries();
        Graficar2D();
   end;

end;

function TFrame1.f( x : Real ): Real;
begin
  //func:= TEdit( EditList[ ActiveFunction ] ).Text;
  Parse.Expression:= funtion[ActiveFunction];
  Parse.NewValue('x', x);
  Result:= Parse.Evaluate();

end;
{
function TFrame1.f( x: Real ): Real;
begin
  //func:= TEdit( EditList[ ActiveFunction ] ).Text;
  Parse.Expression:= funtion[ActiveFunction];
  for i:=0 to vari;
      Parse.NewValue(VX[i], vari[i]);
  //Parse.NewValue('x', x);
  Result:= Parse.Evaluate();

end;
 }
procedure TFrame1.Graficar2D();
var
  x,y:Real;
begin
  with TLineSeries( FunctionList[ ActiveFunction ] ) do begin
      // LinePen.Color:= colorbtnFunction.ButtonColor;
       LinePen.Width:= 2;

  end;

  x:= min;
  TLineSeries( FunctionList[ ActiveFunction ] ).Clear;
  with TLineSeries( FunctionList[ ActiveFunction ] ) do
  repeat
       TLineSeries( FunctionList[ ActiveFunction ] ).ShowLines:=True;
       AddXY( x, f(x) );
       x:= x + h
  until ( x>= max);
 { Parse:=TParseMath.create();
  Parse.Expression:=funcion;
  Parse.AddVariable('x',0);

   with LineSeries do begin
       //LinePen.Color:=clBlack
       LinePen.Width:=2;
  end;

  x:= min;
  LineSeries.Clear;
  with LineSeries do
  repeat
       LineSeries.ShowLines:=True;
       Parse.NewValue('x',x);
       y:=Parse.Evaluate();
       if not IsNan(y)  then
          AddXY(x,y);
       x:= x + h
  until (x>=max+h); }
end;

procedure TFrame1.Ploteo;
var i: Integer;
begin
   with Points do
       Points.ShowPoints:= True;

   Points.AddXY(a, f_a);
end;

procedure TFrame1.ShowArea;
var _H,
    Maxi,
    NewY,
    NewX: real;
    intervalo: Boolean;
begin
   Maxi:= max;
   NewX:= min;
   _H:= abs(h);
   while Maxi > NewX do begin
       NewY := f(NewX);
       intervalo:=(NewX>= min) and (NewX<= max);
      if intervalo then
         Area.AddXY(NewX, NewY);
       NewX:= NewX + _H;
   end;
end;

procedure TFrame1.Point;
var i: Integer;
begin
   with Points do
       Points.ShowPoints:= True;

   Points.AddXY(a, f_a);
   Points.LineType:= ltNone;
end;

end.

