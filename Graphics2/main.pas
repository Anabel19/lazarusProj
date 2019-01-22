unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, TAGraph, Forms, Controls,
  Graphics, Dialogs, StdCtrls, LCLType, ExtCtrls, ColorBox, ComCtrls, ParseMath,
  TASeries,
  TAFuncSeries, TARadialSeries, TATools
  , Types, intersec;

type

  { TForm1 }

  TForm1 = class(TForm)
    PanToolButton: TButton;
    ToolBar1: TToolBar;
    Chart1: TChart;
    ZoomToolButton: TButton;
    ChartToolset1PanMouseWheelTool_vert: TPanMouseWheelTool;
    ChartToolset1PanMouseWheelTool_hor: TPanMouseWheelTool;
    Points: TLineSeries;
    ChartToolset1: TChartToolset;
    ChartToolset1DataPointClickTool1: TDataPointClickTool;
    colorbtnFunction: TColorButton;
    ediMin: TEdit;
    ediMax: TEdit;
    ediStep: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Panel1: TPanel;
    ScrollBox1: TScrollBox;
    StatusBar1: TStatusBar;
    TrackBar1: TTrackBar;
    trbarVisible: TTrackBar;


    procedure FormDestroy(Sender: TObject);
    procedure FunctionSeriesCalculate(const AX: Double; out AY: Double);
    procedure FormShow(Sender: TObject);
    procedure FunctionsEditKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
    procedure trbarVisibleChange(Sender: TObject);
    procedure ChartToolset1DataPointClickTool1PointClick(
  ATool: TChartTool; APoint: TPoint);
    //procedure ZoomPanToolClick(Sender: TObject);

  private
    Ti:TInter;
    FunctionList,
    EditList: TList;
    ActiveFunction: Integer;
    min,
    max: Real;
    Parse  : TparseMath;
    function f( x: Real ): Real;
    procedure CreateNewFunction;
    procedure Graphic2D;
    procedure Point(a: String; f_a: String);

  public

  end;

var
  Form1: TForm1;

implementation

const
  FunctionEditName = 'FunctionEdit';
  FunctionSeriesName = 'FunctionLines';

procedure TForm1.FormCreate(Sender: TObject);
begin
  FunctionList:= TList.Create;
  EditList:= TList.Create;
  min:= -5.0;
  max:= 5.0;
  Parse:= TParseMath.create();
  Parse.AddVariable('x', min);

  Ti:=TInter.Create;

end;

procedure TForm1.trbarVisibleChange(Sender: TObject);
begin
  Self.AlphaBlendValue:= trbarVisible.Position;
end;

function TForm1.f( x: Real ): Real;
begin
  //func:= TEdit( EditList[ ActiveFunction ] ).Text;
  Parse.Expression:= TEdit( EditList[ ActiveFunction ] ).Text;
  Parse.NewValue('x', x);
  Result:= Parse.Evaluate();

end;



procedure TForm1.FormDestroy(Sender: TObject);
begin
  Parse.destroy;
  FunctionList.Destroy;
  EditList.Destroy;
  Ti.Destroy;
end;

procedure TForm1.FunctionSeriesCalculate(const AX: Double; out AY: Double);
begin
   // AY:= f( AX )

end;

procedure TForm1.FormShow(Sender: TObject);
begin
  CreateNewFunction;
end;

procedure TForm1.FunctionsEditKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
begin

  if not (key = VK_RETURN) then
     exit;

   with TEdit( Sender ) do begin
       ActiveFunction:= Tag;
       Graphic2D;
       if tag = EditList.Count - 1 then
          CreateNewFunction;
   end;

end;

procedure TForm1.Graphic2D; //sen(x) cos(x)
var x, h: Real;

begin
  h:= StrToFloat( ediStep.Text );
  min:= StrToFloat( ediMin.Text );
  max:= StrToFloat( ediMax.Text );
  Ti.min_:=min;
  Ti.max_:=max;
  with TLineSeries( FunctionList[ ActiveFunction ] ) do begin
       LinePen.Color:= colorbtnFunction.ButtonColor;
       LinePen.Width:= TrackBar1.Position;

  end;

  x:= min;
  TLineSeries( FunctionList[ ActiveFunction ] ).Clear;
  with TLineSeries( FunctionList[ ActiveFunction ] ) do
  repeat
      AddXY( x, f(x) );
      x:= x + h
  until ( x>= max );


end;

procedure TForm1.CreateNewFunction;
var i:Integer;
begin
   EditList.Add( TEdit.Create(ScrollBox1) );

   //We create Edits with functions
   with Tedit( EditList.Items[ EditList.Count - 1 ] ) do begin
        Parent:= ScrollBox1;
        Align:= alTop;
        name:= FunctionEditName + IntToStr( EditList.Count );//no se repite
        OnKeyUp:= @FunctionsEditKeyUp;
        Font.Size:= 15;
        Text:= EmptyStr;
        Tag:= EditList.Count - 1;
        SetFocus;

   end;

   //We create serial functions
   FunctionList.Add( TLineSeries.Create( Chart1 ) );
   with TLineSeries( FunctionList[ FunctionList.Count - 1 ] ) do begin
        Name:= FunctionSeriesName + IntToStr( FunctionList.Count );
        Tag:= EditList.Count - 1; // Edit Asossiated

   end;


   Chart1.AddSeries( TLineSeries( FunctionList[ FunctionList.Count - 1 ] ) );
end;

procedure TForm1.ChartToolset1DataPointClickTool1PointClick(
  ATool: TChartTool; APoint: TPoint);
var
  i, cant: Integer;
  x,
  y: Double;
begin
  with ATool as TDatapointClickTool do
    if (Series is TLineSeries) then
      with TLineSeries(Series) do begin
        x := GetXValue(PointIndex);
        y := GetYValue(PointIndex);
        Statusbar1.SimpleText := TEdit(EditList[Tag]).Caption;
        //Statusbar1.SimpleText := Format('%s: x = %f, y = %f', [Title, x, y]);

        if Ti.Lfunxions.Count<2 then begin;
            ShowMessage(TEdit(EditList[Tag]).Caption);
            Ti.Lfunxions.Add(TEdit(EditList[Tag]).Caption);
        end;
        if Ti.Lfunxions.Count=2 then begin
            Ti.execute();
            i:=0;
            cant:=Ti.Lr.Count;
            while i<cant do begin
              ShowMessage('('+Ti.Lr[i]+','+Ti.Lfr[i]+')');
              //StatusBar1.SimpleText:= '('+Ti.Lr[i]+','+Ti.Lfr[i]+')';
              Point(Ti.Lr[i],Ti.Lfr[i]);
              i:=i+1;
            end;
        end
        else exit;
      end
    else
      Statusbar1.SimpleText := '';


end;
 {
procedure TForm1.ZoomPanToolClick(Sender: TObject);
begin
  ChartToolset1PanMouseWheelTool_vert.Enabled := PanToolButton;
  ChartToolset1PanMouseWheelTool_hor.Enabled := PanToolButton;
end;
  }

procedure TForm1.Point(a: String; f_a: String);
var i:Integer;
begin
   with Points do begin
      //Points.Clear;
      Points.ShowPoints:=True;
    end;
    //for i:=0 to Ti.Lr.Count-1 do begin
      Points.AddXY(StrToFloat(a),StrToFloat(f_a));//show
      Points.LineType:=ltNone;
      //Points.AddXY(0,1);

    //end;
end;

{
procedure TForm1.ChartToolset1DataPointClickTool1PointClick(
  ATool: TChartTool; APoint: TPoint);
var
  x, y: Double;  i:Integer;
begin
  //ShowMessage('lll');
  {
  for i:=0 to 3 do begin
      ShowMessage(TLineSeries[0]);
  end;  }
  with ATool as TDatapointClickTool do
    if (Series <> nil) then
      with (Series as TLineSeries) do begin
        x := GetXValue(PointIndex);
        y := GetYValue(PointIndex);
        { --- next line removed --- }
//        Statusbar1.SimpleText := Format('%s: x = %f, y = %f', [Title, x, y]);
        { --- next line added --- }
         //ShowMessage();
        //ListSource.Item[PointIndex]^.Text := Format('x = %f'#13#10'y = %f', [x,y]);
        //ParentChart.Repaint;
        // in newer Lazarus versions you can use (which already contains the Repaint):
        // ListSource.SetText(PointIndex, Format('x = %f'#13#10'y = %f', [x,y]));
      end;
end;}

{$R *.lfm}

end.


