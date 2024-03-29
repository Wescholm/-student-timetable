unit Unit2;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Grids;

type
  TForm2 = class(TForm)
    StringGrid1: TStringGrid;
    ComboBox1: TComboBox;
    ComboBox2: TComboBox;
    Button1: TButton;
    procedure FormCreate(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure ComboBox1Exit(Sender: TObject);
    procedure StringGrid1SelectCell(Sender: TObject; Col, Row: Integer;
      var CanSelect: Boolean);
    procedure ComboBox1CloseUp(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure ComboBox2Change(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

uses Unit1;

{$R *.dfm}

procedure TForm2.FormCreate(Sender: TObject);
var
startmin,i:integer;
begin
ComboBox1.Items:=Form1.tips;
//��������� ������� ������ �������
StringGrid1.Cells[1, 0]:='�������';
StringGrid1.Cells[2, 0]:='�������������';
StringGrid1.Cells[3, 0]:='��� ����';
StringGrid1.Cells[4, 0]:='�������';
//������ � combobox �� ��������� ����������, ������� �� �����
//��������� ������ � ����� ��� ������ combobox!
StringGrid1.DefaultRowHeight := ComboBox1.Height;
//�������� combobox
ComboBox1.Visible := False;
//��������� ������� � �������� �������
startmin:=8*60;
for i:=1 to 8 do
  begin
  StringGrid1.Cells[0, i]:=Form1.mintotime(startmin);
  startmin:=startmin+90;
  end;
end;

procedure TForm2.ComboBox1Change(Sender: TObject);
begin
//�������� ��������� ������� �� ComboBox � �������� ��� � ����
  StringGrid1.Cells[StringGrid1.Col,
   StringGrid1.Row] := ComboBox1.Items[ComboBox1.ItemIndex];
  ComboBox1.Visible := False;
  StringGrid1.SetFocus;
end;

procedure TForm2.ComboBox1Exit(Sender: TObject);
begin
{�������� ��������� ������� �� ComboBox � �������� ��� � ����}
 StringGrid1.Cells[StringGrid1.Col, StringGrid1.Row] := ComboBox1.Items[ComboBox1.ItemIndex];
 ComboBox1.Visible := False;
 StringGrid1.SetFocus;
end;
// ������ ComboBox � ������� ������ ������� �������� � StringGrid-�
Function ComboBoxNumIndex(TextGrid, TextCombo : String): Integer;

var
 NumIndex: Integer;
begin
  NumIndex := 0;
  while Pos(#13#10, TextCombo) <> 0 do
  begin
  if Copy(TextCombo, 0, Pos(#13#10, TextCombo)-1) = TextGrid then break
  else
  begin
  NumIndex := NumIndex + 1;
  TextCombo := Copy(TextCombo, Pos(#13#10, TextCombo)+2, Length(TextCombo));
  end;
  end;
  ComboBoxNumIndex := NumIndex;
end;

procedure TForm2.StringGrid1SelectCell(Sender: TObject; Col,
  Row: Integer; var CanSelect: Boolean);
var
 R: TRect;
begin
 if ((Col = 3) AND
  (Row <> 0)) then begin
  {������ � ������������ combobox ��������� ��� ������}
  R := StringGrid1.CellRect(Col, Row);
  R.Left := R.Left + StringGrid1.Left;
  R.Right := R.Right + StringGrid1.Left;
  R.Top := R.Top + StringGrid1.Top;
  R.Bottom := R.Bottom + StringGrid1.Top;
  ComboBox1.Left := R.Left + 1;
  ComboBox1.Top := R.Top + 1;
  ComboBox1.Width := (R.Right + 1) - R.Left;
  ComboBox1.Height := (R.Bottom + 1) - R.Top;
  //���������� ������
  ComboBox1.ItemIndex := ComboBoxNumIndex(StringGrid1.Cells[3, Row], ComboBox1.Items.Text);
  //���������� �omboBox
  ComboBox1.Visible := True;
  ComboBox1.SetFocus;
 end;
 CanSelect := True;
end;

procedure TForm2.ComboBox1CloseUp(Sender: TObject);
begin
{�������� ��������� ������� �� ComboBox � �������� ��� � ����}
 StringGrid1.Cells[StringGrid1.Col, StringGrid1.Row] := ComboBox1.Items[ComboBox1.ItemIndex];
 ComboBox1.Visible := False;
 StringGrid1.SetFocus;
end;
//��������� ���������
procedure TForm2.Button1Click(Sender: TObject);
var
f:file of TPred;
x:node;
row:integer;
begin
x:=Form1.rasp;  //������ ����������
//���� � ���������� ��������� ����
while x^.v.day<>ComboBox2.ItemIndex do
  x:=x^.next;          //��������� ������� ������
for row:=1 to 8 do
  begin
  //��������� � ���������� ������ �� �������
  if x^.v.day=ComboBox2.ItemIndex then
    begin
    x^.v.predmet:=StringGrid1.Cells[1, row];
    x^.v.prepod:=StringGrid1.Cells[2, row];
    x^.v.tip:=ComboBoxNumIndex(StringGrid1.Cells[3, row], ComboBox1.Items.Text);
    x^.v.room:=StringGrid1.Cells[4, row];
    end;
  x:=x^.next;        //��������� ������� ������
  end;
  AssignFile(f,'rsp.dat');
  Rewrite(f);   //��������� ����
  x:=Form1.rasp;
  //���������� ���������� � ����
  while x<>nil do //���� �� ������
    begin
    write(f,x^.v);
    x:=x^.next;        //��������� ������� ������
    end;
  Truncate(f);
  CloseFile(f);
end;

procedure TForm2.ComboBox2Change(Sender: TObject);
begin
Form1.UpdateSG(StringGrid1,ComboBox2.ItemIndex);
end;

procedure TForm2.FormShow(Sender: TObject);
var
dow:integer;
begin
dow:=DayOfWeek(Form1.DateTimePicker1.DateTime)-1;
dow:=(dow+6) mod 7;
if dow>4 then
  begin
  //���������� ����� ������� ���� ������
  dow:=DayOfWeek(now)-1;
  dow:=(dow+6) mod 7;
  end;
ComboBox2.ItemIndex:=dow;
Form1.UpdateSG(StringGrid1,dow);
end;

end.
