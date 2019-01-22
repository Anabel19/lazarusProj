unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, uCmdBox, TAGraph, Forms, Controls, Graphics,
  Dialogs, Menus, ExtCtrls, Buttons, StdCtrls, ValEdit, ComCtrls, DbCtrls,
  Grids, //ParseMath,
  frame_graphics, parsemethod, intersec;

type
  { TForm1 }

  TForm1 = class(TForm)
    CmdBox: TCmdBox;
    Memo1: TMemo;
    PageControl1: TPageControl;
    PanelG: TPanel;
    PanelRight: TPanel;
    Frame : TFrame1;
    Splitter1: TSplitter;
    Splitter2: TSplitter;
    StringGrid1: TStringGrid;
    TSvar: TTabSheet;
    TScom: TTabSheet;
    tvwHistory: TTreeView;
    ValueListEditor1: TValueListEditor;
    FrameGraph: TFrame;

    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure CmdBoxInput(ACmdBox: TCmdBox; Input: string);

  private
    MAT1,
    MAT2: string;
    condicion: Integer;
    //Parse: TParseMath;
    ParseMeth: TPMeth;
    nf,
    ListVar: TStringList;
    //interseccion
    mmax,
    mmin,
    vvar: Real;
    p: TStringList;
    funxions: TStringList;
    procedure StartCommand();
    function FindVar(sel: string): string;
    procedure AddVariable( EndVarNamePos: integer; FinalLine: string );
  public
    procedure InstanFrame;
  end;

var
  Form1: TForm1;

const
  L = 0;
  E = 1;
  Log = 2;
  S = 3;

implementation

{$R *.lfm}

procedure TForm1.InstanFrame;
begin
   if Assigned(FrameGraph) then
     FrameGraph.Free;
   FrameGraph:= TFrame1.Create( PanelG );

      FrameGraph.Parent:= PanelG;
   FrameGraph.Align:= alClient;
end;

procedure TForm1.StartCommand();
begin
   CmdBox.StartRead( clBlack, clWhite,  'MiniLab--> ', clBlack, clWhite);
end;

function TForm1.FindVar(sel: string): string;
var i: integer;
begin
    for i:=0 to ValueListEditor1.RowCount-3 do begin  //-fileDefault -nameCol
        if ListVar.Names[i] = sel then
           Result:= ListVar.ValueFromIndex[i];
    end;
end;

procedure TForm1.AddVariable( EndVarNamePos: integer; FinalLine: string );
var PosVar: Integer;
    const NewVar= -1;
 begin
    //trim[returns a copy of S with blanks characters on the left and right stripped off]
    PosVar:= ListVar.IndexOfName( trim( Copy( FinalLine, 1, EndVarNamePos  ) ) );
    ShowMessage('....'+IntToStr(PosVar));
    with ValueListEditor1 do
    case PosVar of
         NewVar: begin
                  ListVar.Add(  FinalLine );
                  ShowMessage(FinalLine[Pos('=', FinalLine)+1]);
                  ShowMessage('''');
                  if FinalLine[Pos('=',FinalLine)+1] = '[' then  begin
                      ParseMeth.AddString( ListVar.Names[ ListVar.Count - 1 ], ListVar.ValueFromIndex[ ListVar.Count - 1 ])
                  end
                  else if FinalLine[Pos('=', FinalLine)+1] = '''' then
                      ParseMeth.AddString( ListVar.Names[ ListVar.Count - 1 ], ListVar.ValueFromIndex[ ListVar.Count - 1 ])
                  else
                      ParseMeth.AddVariable( ListVar.Names[ ListVar.Count - 1 ], StrToFloat( ListVar.ValueFromIndex[ ListVar.Count - 1 ]) );

                  Cells[ 0, RowCount - 1 ]:= ListVar.Names[ ListVar.Count - 1 ];
                  Cells[ 1, RowCount - 1 ]:= ListVar.ValueFromIndex[ ListVar.Count - 1 ];
                  RowCount:= RowCount + 1;

         end else begin
              ListVar.Delete( PosVar );
              ListVar.Insert( PosVar,  FinalLine );
              Cells[ 0, PosVar + 1 ]:= ListVar.Names[ PosVar ] ;
              Cells[ 1, PosVar + 1 ]:= ListVar.ValueFromIndex[ PosVar ];
              if FinalLine[Pos('=', FinalLine)+1]= '[' then begin
                  ParseMeth.AddString( ListVar.Names[ ListVar.Count - 1 ], ListVar.ValueFromIndex[ ListVar.Count - 1 ])
              end
              else if FinalLine[Pos('=', FinalLine)+1] = '''' then
                  ParseMeth.AddString( ListVar.Names[ ListVar.Count - 1 ], ListVar.ValueFromIndex[ ListVar.Count - 1 ])
                  //ParseMeth.NewStr( Copy(Input, 1,Pos('=',FinalLine)-1), Copy(Input, Pos('=',FinalLine)+1, Length(Input)))
              else
                  ParseMeth.NewValue( ListVar.Names[ PosVar ], StrToFloat( ListVar.ValueFromIndex[ PosVar ] ) ) ;
          end;

    end;


end;

procedure TForm1.CmdBoxInput(ACmdBox: TCmdBox; Input: string);
var FinalLine: string;
    i: Integer;
    vx, h: Real;
   //teorema del valor medio
   //minimos cuadrads  //int analit->suma
        procedure Execute();
        begin
            ParseMeth.Expression:= Input ;
            CmdBox.TextColors(clBlack,clWhite);
            CmdBox.Writeln( LineEnding +  FloatToStr( ParseMeth.Evaluate() )  + LineEnding);
        end;

begin
  try
     Input:= Trim(Input);
     case input of
       'help': ShowMessage( 'help ');
       'exit': Application.Terminate;
       'clear': begin CmdBox.Clear;   TFrame1(FrameGraph).Destroy;  StartCommand() end;
       'clearhistory': CmdBox.ClearHistory;

        else begin
             FinalLine:=  StringReplace ( Input, ' ', '', [ rfReplaceAll ] );
             if (Pos( '=', FinalLine ) > 0) then
                AddVariable( Pos( '=', FinalLine ) - 1, FinalLine )
             else if pos('plot', FinalLine) > 0 then  begin
                 InstanFrame;
                 TFrame1(FrameGraph).max:=mmax;
                 TFrame1(FrameGraph).min:=mmin;
                 TFrame1(FrameGraph).h  :=vvar;

                 if funxions.Count<>0 then begin
                    {
                    if (Pos('(', FinalLine)+1 = 0) then
                        funxions.Add(ParseMeth.LfexTra[0])
                    else if(Pos('(', FinalLine)+1 = 1) then
                        funxions.Add(ParseMeth.LfexTra[1])
                    else if(Pos('(', FinalLine)+1 = 2) then
                        funxions.Add(ParseMeth.LfexTra[2])
                    else if(Pos('(', FinalLine)+1 = 3) then
                        funxions.Add(ParseMeth.LfexTra[3]);
                    }
                    TFrame1(FrameGraph).GraficarFunciones(funxions);
                 end;
                 if(p.Count<>0) then  begin
                     i:=0;
                     while i<p.Count do begin;
                        TFrame1(FrameGraph).a:=StrToFloat(p[i]);
                        TFrame1(FrameGraph).f_a:=StrToFloat(p[i+1]);
                        if funxions.Count<>0 then
                            TFrame1(FrameGraph).Point
                        else TFrame1(FrameGraph).Ploteo;
                        i:=i+2;
                     end;
                     p.Clear;
                 end
                 else if condicion=1 then begin
                       TFrame1(FrameGraph).ShowArea;
                       condicion:= 0;
                 end;
                 funxions.Clear;
             end
             //MATRIZ
             else if (Pos( '+', FinalLine )>0) then begin
                     //(Pos( 'det', FinalLine )>0)  or (Pos( '*escalar', FinalLine )>0) or (Pos( '^', FinalLine )>0)then begin
                     if (Pos('A', FinalLine )>0) or  (Pos('B', FinalLine )>0) then begin
                         MAT1:= FindVar('A');         MAT2:=FindVar('B');
                         CmdBox.Writeln(LineEnding+ ParseMeth.EvaluateOpM(MAT1+'+'+MAT2)+ LineEnding);
                     end
                     else CmdBox.Writeln(LineEnding+ ParseMeth.EvaluateOpM(FinalLine)+ LineEnding);
             end
             else if  (Pos( '-', FinalLine )>0) then begin
                     if (Pos('A', FinalLine )>0) or  (Pos('B', FinalLine )>0) then begin
                         MAT1:= FindVar('A');         MAT2:=FindVar('B');
                         CmdBox.Writeln(LineEnding+ ParseMeth.EvaluateOpM(MAT1+'-'+MAT2)+ LineEnding);
                     end
                     else CmdBox.Writeln(LineEnding+ ParseMeth.EvaluateOpM(FinalLine)+ LineEnding);
             end
             else if  (Pos( '*', FinalLine )>0) then begin
                     if (Pos('A', FinalLine )>0) or  (Pos('B', FinalLine )>0) then begin
                         MAT1:= FindVar('A');         MAT2:=FindVar('B');
                         CmdBox.Writeln(LineEnding+ ParseMeth.EvaluateOpM(MAT1+'*'+MAT2)+ LineEnding);
                     end
                     else CmdBox.Writeln(LineEnding+ ParseMeth.EvaluateOpM(FinalLine)+ LineEnding);
             end
             else if  (Pos( 'I', FinalLine )>0) then begin
                     if (Pos('A', FinalLine )>0) then begin
                         MAT1:= FindVar('A');
                         CmdBox.Writeln(LineEnding+ ParseMeth.EvaluateOpM1(MAT1+'I-1')+ LineEnding);
                     end
                     else CmdBox.Writeln(LineEnding+ ParseMeth.EvaluateOpM1(FinalLine)+ LineEnding);
             end
             else if  (Pos( 'T', FinalLine )>0) then begin
                     if (Pos('A', FinalLine )>0) then begin
                         MAT1:= FindVar('A');
                         CmdBox.Writeln(LineEnding+ ParseMeth.EvaluateOpM1(MAT1+'^T')+ LineEnding);
                     end
                     else CmdBox.Writeln(LineEnding+ ParseMeth.EvaluateOpM1(FinalLine)+ LineEnding);
             end
             else begin
                Execute;
                 if (pos('interseccion', FinalLine) > 0) then begin
                     i:=0;
                     while (i< ParseMeth.ResultInts.Count) do   begin
                          CmdBox.Write( '('+ParseMeth.ResultInts[i]+' ; '+ ParseMeth.ResultInts[i+1] + ')');
                          p.Add(ParseMeth.ResultInts[i]);
                          p.Add(ParseMeth.ResultInts[i+1]);
                          i:=i+2;
                     end;
                     funxions.Add(ParseMeth.f1);   funxions.Add(ParseMeth.f2);
                end
                 else if (pos('integral', FinalLine) > 0) then begin
                     condicion:=1;
                     funxions.Add(ParseMeth.f1);
                end
                 else if (pos('edo', FinalLine) > 0) then begin
                    vx:= ParseMeth.varx;         h:=(ParseMeth.hedo);
                          //CmdBox.Writeln(LineEnding+'|'+'    n    '              +'|'+'     Xi        '               +'|'+'       f(Xi)      '                 +'|'+'     RealValue      '               +'|' +LineEnding);
                    for i:=0 to ParseMeth.Lfunxedo.Count-1 do begin
                          //CmdBox.Writeln(LineEnding+'|'+'    '+IntToStr(i)+'    '+'|'+'        '+FloatToStr(vx)+'    '+'|'+'     '+ParseMeth.Lfunxedo[i]+'     '+'|'+'      '+ParseMeth.Lsolxedo[i]+'    '+'|' +LineEnding);
                          CmdBox.Write('('+FloatToStr(vx)+','+ParseMeth.Lfunxedo[i]+')');
                          p.Add(FloatToStr(vx));
                          p.Add(ParseMeth.Lfunxedo[i]);
                          vx:= vx + h;
                    end;
                end
                 else if (Pos('extrapolar', FinalLine) > 0) then begin
                    i:=0;
                    while i < ParseMeth.pointss.Count do begin
                          p.Add(ParseMeth.pointss[i]);
                          p.Add(ParseMeth.pointss[i+1]);
                          i:= i+2;
                    end;
                    for i:=0 to ParseMeth.LfexTra.Count-1 do begin
                          ShowMessage(nf[i]+ParseMeth.LfexTra[i]);
                          CmdBox.Writeln(nf[i] + LineEnding + ParseMeth.LfexTra[i]);
                    end;
                    for i:=0 to ParseMeth.LRexTra.Count-1 do begin
                          ShowMessage(ParseMeth.LRexTra[i]);
                          CmdBox.Writeln(ParseMeth.LRexTra[i]);
                    end;

                end;
                 mmax:= ParseMeth.max;
                 mmin:= ParseMeth.min;
                 vvar:= ParseMeth.varx;
             end;

        end;

  end;

  finally
     StartCommand()
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  CmdBox.StartRead( clBlack, clBlue,  'MiniLab-->', clBlack, clBlue);
  with ValueListEditor1 do begin
    Cells[ 0, 0]:= 'Name ';
    Cells[ 1, 0]:= 'Value';
    Clear;

  end;
  Memo1.Clear;
  Memo1.Lines.Add('f1,f2:string, min, max, vx)');
  Memo1.Lines.Add('interseccion(''sin(x)'',''cos(x)'',-5,5,0.2)');
  Memo1.Lines.Add('f1: string, a,b: real, Npart, TIPO)');
  Memo1.Lines.Add('integral(''530*power(x,2)+20*power(x,-6)+1.71*x-315'',3,8,6,1)');
  Memo1.Lines.Add('f1: string, xo, yo, N, TIPO)');
  Memo1.Lines.Add('edo(''x*y'', ''exp((1/2*power(x,2))-2)*4'',2,4,4,0)');
  Memo1.Lines.Add('edo(''x*y'',2,4,4,0)');
  Memo1.Lines.Add('extrapolar(''ejemplo'')');
  condicion:= 0;
  ListVar:= TStringList.Create;
  //Parse:= TParseMath.create();
  ParseMeth:= TPMeth.create();
  //ParsePlot:= TParseMath.create();
  //ParsePlot.AddVariable( 'x', 0 );
  funxions:= TStringList.Create;
  p:=TStringList.Create;
  nf:= TStringList.Create;
  nf.Add('lineal');  nf.Add('exponencial');  nf.Add('logaritmica');     nf.Add('senoidal');
  StartCommand();

end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  ListVar.Destroy;
  //Parse.Destroy;
  ParseMeth.Destroy;
  funxions.Destroy;
  p.Destroy;
  nf.Destroy;
  //ParsePlot.destroy;

end;
end.

