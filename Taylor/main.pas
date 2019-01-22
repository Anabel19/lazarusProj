unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  Grids, StdCtrls, class_taylor;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Edit1: TEdit;
    Edit2: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Panel1: TPanel;
    RadioGroup1: TRadioGroup;
    StringGrid1: TStringGrid;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private

    procedure CleanStringGrid;
    procedure CalculateErrors;

  public

  end;

var
  Form1: TForm1;

implementation
const
 col_pos = 0;
 col_suc = 1;
 col_err1 = 2;
 col_err2 = 3;
 col_err3 = 4;

{$R *.lfm}

{ TForm1 }

procedure TForm1.CalculateErrors;
var iRow,
    CantDecimals: Integer;
    xn,
    xant: Real;
begin
   CantDecimals:= trunc( 1 / StrToFloat( Edit2.Text ) );
   with StringGrid1 do
   for iRow:= 2 to RowCount - 1 do begin
     Cells[ col_pos, iRow ]:= IntToStr( iRow );
     xn:= StrToFloat( Cells[ col_suc,  iRow ] );
     xant:= StrToFloat( Cells[ col_suc,  iRow - 1 ] );
     Cells[ col_err1, iRow ]:= FloatToStr( abs( xant - xn ) );
     Cells[ col_err2, iRow ]:= FloatToStr( abs( (xant - xn)/ xn ) );
     Cells[ col_err3, iRow ]:= FloatToStr( round( abs( (xant - xn)/ xn )*CantDecimals )/CantDecimals ) + '%';
   end;

end;

procedure TForm1.CleanStringGrid;
begin
  with StringGrid1 do begin
    Clean;
    RowCount:= 1;
    Columns[ col_pos ].Title.Caption:= 'n';
    Columns[ col_suc ].Title.Caption:= 'Xn';
    Columns[ col_err1 ].Title.Caption:= '|Xn+1 - Xn|';
    Columns[ col_err2 ].Title.Caption:= '|(Xn+1 - Xn)/(Xn+1)|';
    Columns[ col_err3 ].Title.Caption:= '|(Xn+1 - Xn)/(Xn+1)| * 100%';
  end;
end;

procedure TForm1.Button1Click(Sender: TObject);
var Taylor: TTaylor;
begin
  CleanStringGrid;
  Taylor:= TTaylor.create;
  Taylor.TaylorType:= RadioGroup1.ItemIndex;
  Taylor.x:= StrToFloat( Edit1.Text );
  Taylor.Error:= StrToFloat( Edit2.Text );
  Label1.Caption:= RadioGroup1.Items[ RadioGroup1.ItemIndex ] +
                   '( ' + Edit1.Text + ' ) = ' +
                   FloatToStr(  Taylor.execute );
  StringGrid1.RowCount:= Taylor.Lxn.Count;
  StringGrid1.Cols[ col_suc ].Assign( Taylor.Lxn );
  CalculateErrors;
  Taylor.Destroy;

end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  CleanStringGrid;
end;

end.

