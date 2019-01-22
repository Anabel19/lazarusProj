unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  Grids, StdCtrls, matrix;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    Edit5: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label9: TLabel;
    Panel1: TPanel;
    RadioGroup1: TRadioGroup;
    StringGrid1: TStringGrid;
    StringGrid2: TStringGrid;
    StringGrid3: TStringGrid;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure RadioGroup1Click(Sender: TObject);
  private
    function readMatrix(Grid: TStringGrid): mmatrix;

  public

  end;

var
  Form1: TForm1;

implementation
const
 h = 0.25;
 col_pos = 0;
 col_x = 1;
 col_fx = 2;
 col_rv = 3;

{$R *.lfm}

{ TForm1 }

function TForm1.readMatrix(Grid: TStringGrid): mmatrix;
var
  cols, rows: Integer;
  i,j : Integer;
begin
  cols := Grid.ColCount;
  rows := Grid.RowCount;

  SetLength(Result,rows, cols);
  for i:=0 to rows-1 do
  begin
    for j:=0 to cols-1 do  begin
        Result[i,j] := StrToFloat(Grid.Cells[j,i]);
    end;

  end;
  {
  for i:=0 to rows-1 do
  begin
    for j:=0 to cols-1 do
        Result[i,j] := StrToFloat(Grid.Cells[j,i]);
  end;
  }
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  StringGrid1.RowCount:=StrToInt(Edit1.Text);
  StringGrid1.ColCount:=StrToInt(Edit2.Text);
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
  StringGrid2.RowCount:=StrToInt(Edit3.Text);
  StringGrid2.ColCount:=StrToInt(Edit4.Text);
end;

//For matrix operations we only need rows of StringGrid1
//                               and cols of StringGrid2
procedure TForm1.Button1Click(Sender: TObject);
var rpta: mmatrix;
    det, rpt: real;
    r1, c1, r2, c2,
    i, j: Integer;
    M: TMatrix;
begin
    StringGrid3.Clean;
    M:= TMatrix.create;

    //r1:=StringGrid1.RowCount;   c1:=StringGrid1.ColCount;
    //r2:=StringGrid2.RowCount;   c2:=StringGrid2.ColCount;

    M.TMatType:= RadioGroup1.ItemIndex;
    //M.m1_:= readMatrix(StringGrid1);
    //M.m2_:= readMatrix(StringGrid2);

    if (RadioGroup1.ItemIndex = 0) or (RadioGroup1.ItemIndex = 1) or (RadioGroup1.ItemIndex = 2) then begin
       r1:=StringGrid1.RowCount;   c1:=StringGrid1.ColCount;
       r2:=StringGrid2.RowCount;   c2:=StringGrid2.ColCount;
       //ShowMessage('if not '+String(readMatrix(StringGrid1)));
       M.m1_:= readMatrix(StringGrid1);
       for  i:=0 to r1-1 do
         for j:=0 to c1-1 do
            //ShowMessage('see '+ FloatToStr(M.m1_[i][j]));
       M.m2_:= readMatrix(StringGrid2);
       StringGrid3.RowCount:=r1;
       StringGrid3.ColCount:=c2;
    end
    else  begin
        r1:=StringGrid1.RowCount;   c1:=StringGrid1.ColCount;
       r2:=StringGrid2.RowCount;   c2:=StringGrid2.ColCount;
        M.m1_:= readMatrix(StringGrid1);
        StringGrid3.ColCount:= c1;
        StringGrid3.RowCount:= r1;
        //M.escalar:= StrToFloat( Edit5.Text );
        //M.x_:= StrToInt( Edit5.Text );
        if RadioGroup1.ItemIndex = 3 then begin //inversa
           ShowMessage(IntToStr(c1));
           ShowMessage(IntToStr(c1));
            det:=M.det(M.m1_);
            ShowMessage('det '+FloatToStr(det));
            if det = 0 then begin
                ShowMessage('Matriz no invertible, Determinante 0');
                exit;
            end;
            if c1 <> r1 then begin
                ShowMessage('matriz no cuadrada');  exit;
            end;
        end
        else if RadioGroup1.ItemIndex = 4 then begin
            if c1 <> r1 then begin
               ShowMessage('matriz no cuadrada');  exit;
            end
            else begin
               rpt:= M.execute; ShowMessage('determinante '+FloatToStr(rpt));
               exit;
            end;
        end
        else if RadioGroup1.ItemIndex = 5 then begin
            StringGrid3.ColCount:= r1;
            StringGrid3.RowCount:= c1;
        end
        else if RadioGroup1.ItemIndex = 6 then begin
            M.escalar:= StrToFloat( Edit5.Text );
        end
        else if RadioGroup1.ItemIndex = 7 then begin
            M.x_:= StrToInt( Edit5.Text );
            if c1 <> r1 then begin
               ShowMessage('matriz no cuadrada');  exit;
            end;
        end
    end;

    rpta:= M.execute;
    for i:=0 to r1-1 do
       for j:=0 to c2-1 do
          StringGrid3.Cells[j, i]:= FloatToStr(rpta[i][j]);

    M.Destroy;

end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  StringGrid3.Clean;
end;

procedure TForm1.RadioGroup1Click(Sender: TObject);
begin

end;

end.

