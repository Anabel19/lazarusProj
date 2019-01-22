unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  Grids, StdCtrls, TAGraph, TASeries, TAFuncSeries, ParseMath, class_intg;

type

  { TForm1 }

  TForm1 = class(TForm)
    a_: TEdit;
    Button1: TButton;
    b_: TEdit;
    Chart1: TChart;
    Area: TAreaSeries;
    funxion: TFuncSeries;
    ejey: TConstantLine;
    ejex: TConstantLine;
    ComboBox1: TComboBox;
    Label1: TLabel;
    Label2: TLabel;
    n_: TEdit;
    Panel1: TPanel;
    RadioGroup1: TRadioGroup;
    procedure FuncionCalcular(const x:Double ;out y:Double);
    procedure Button1Click(Sender: TObject);
  private
    function f(x: real): real;
    procedure GraficaFunxion();
  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }
function TForm1.f(x: real): real;
var Parse: TParseMath;
begin
  try
      Parse:=TParseMath.create();
      Parse.AddVariable('x',x) ;
      Parse.Expression:= ComboBox1.Text;
      //ShowMessage('Parse.Expression: '+Parse.Expression);
      f:=Parse.Evaluate();
  except
    //ShowMessage('error en la funcion');
    exit;
  end;
  Parse.destroy;
end;

procedure TForm1.FuncionCalcular(const x:Double ;out y:Double);
begin
      //y:=x*x*x;
   y := f(x);
end;

procedure TForm1.GraficaFunxion();
var H,
    Max,
    NewY,
    NewMin:real;
  intervalo:Boolean;
begin
   with funxion do begin
     Active:=False;
     Extent.XMax:=StrToFloat(b_.Text);
     Extent.XMin:=StrToFloat(a_.Text);
     Extent.UseXMax:=true;
     Extent.UseXMin:=true;
     Active:=True;
   end;
   Max:= StrToFloat(b_.Text);
   NewMin:= StrToFloat(a_.Text);
   H:= abs((Max-NewMin)/StrToFloat(n_.text));
   while Max > NewMin do begin
       NewY := f(NewMin);
       ShowMessage('nmx...'+FloatToStr(NewY));
       ShowMessage('nmin...'+FloatToStr(NewMin));
       intervalo:=(NewMin>=StrToFloat(a_.Text)) and (NewMin<=StrToFloat(b_.Text));
      if intervalo then
         Area.AddXY(NewMin,NewY);
       NewMin:= NewMin + h;
   end;
end;

procedure TForm1.Button1Click(Sender: TObject);
var MI: TIntGral;
begin
  MI:= TIntGral.create;
  MI.MIntgType:= RadioGroup1.ItemIndex;
  MI.funx:= ComboBox1.Text;
  MI.a:= StrToFloat( a_.Text );
  MI.b:= StrToFloat( b_.Text );
  MI.N:= StrToFloat( n_.Text );
  {Label1.Caption:= RadioGroup1.Items[ RadioGroup1.ItemIndex ] +
                   '( ' + a_.Text + ' ) = ' +
                   FloatToStr(  MC.execute ); }
  Label1.Caption:=FloatToStr(MI.execute);
  Area.Clear;
  GraficaFunxion();
  Area.Active:=True;
  MI.Destroy;

end;

end.
