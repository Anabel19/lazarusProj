unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  Grids, StdCtrls, class_edo;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    xo: TEdit;
    yo: TEdit;
    f: TComboBox;
    f_sol: TComboBox;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    n_: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Panel1: TPanel;
    RadioGroup1: TRadioGroup;
    StringGrid1: TStringGrid;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure RadioGroup1Click(Sender: TObject);
  private

    procedure CleanStringGrid;
    procedure CompleteValue;

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

procedure TForm1.CompleteValue;
var iRow: Integer;
    //CantDecimals: Integer;
    vx: Real;
begin
//CantDecimals:= trunc( 1 / StrToFloat( yo.Text ) );
   with StringGrid1 do  begin
   Cells[ col_x , 1] := xo.Text;
   for iRow:= 2 to RowCount - 1 do begin
     Cells[ col_pos, iRow ]:= IntToStr( iRow );

     vx:= StrToFloat( Cells[ col_x,  iRow - 1] );

     Cells[ col_x, iRow ]:= FloatToStr( vx + h  );
     //Cells[ col_err, iRow ]:= FloatToStr( abs( xn - xant ) );
  end;
  end;
end;

procedure TForm1.CleanStringGrid;
begin
  with StringGrid1 do begin
    Clean;
    RowCount:= 1;
    Columns[ col_pos ].Title.Caption:= 'n';
    Columns[ col_x ].Title.Caption:= 'Xi';
    Columns[ col_fx ].Title.Caption:= 'f(Xi)';
    Columns[ col_rv ].Title.Caption:= 'RealValue';
    Columns[ col_er ].Title.Caption:= 'ER';
    Columns[ col_ar ].Title.Caption:= 'EA';
  end;
end;

procedure TForm1.Button1Click(Sender: TObject);
var EDO: TEDO;
begin
  CleanStringGrid;
  EDO:= TEDO.create;
  EDO.EDOType:= RadioGroup1.ItemIndex;
  EDO.h:= h;
  //with StringGrid1 do
    //Cells[ col_x , 1] := xo.Text;
    //Cells[ col_fx , 1]:= yo.Text;
    EDO.x:= StrToFloat(xo.Text);//StrToFloat( Cells[col_x , 1] );
    EDO.y:= StrToFloat(yo.Text);//StrToFloat( Cells[col_fx , 1] );
  //end;
  EDO.N:= StrToFloat(n_.Text);
  EDO.dfunx:= f.Text;
  EDO.fsol:= f_sol.Text;
  {Label1.Caption:= RadioGroup1.Items[ RadioGroup1.ItemIndex ] +
                   '( ' + n_.Text + ' ) = ' +
                   FloatToStr(  MC.execute ); }
  EDO.execute;
  StringGrid1.RowCount:= EDO.Lfx.Count;
  //MA.Lxn.Add('hola');
  //ShowMessage(MA.Lxn[0]);
  StringGrid1.Cols[ col_fx ].Assign( EDO.Lfx );
  StringGrid1.Cols[ col_rv ].Assign( EDO.Lry );
  CompleteValue;
  EDO.Destroy;

end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  CleanStringGrid;
end;

procedure TForm1.RadioGroup1Click(Sender: TObject);
begin

end;

end.

