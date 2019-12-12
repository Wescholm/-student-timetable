unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Grids, ComCtrls;
type TPred=record    //�������� ��������
day: integer;     //���� ������
predmet: string[30];  //�������
prepod: string[30];   //�������������
tip:integer;        //��� �������
room:string[10];    //�������
end;
node = ^S;  {����������� ��������� �� ������� ������}
S=record  {����������� ������, ���������� ��������� ������}
v:TPred;  //�������
next:node; {��������� �� ��������� ������� ������}
end;
type
  TForm1 = class(TForm)
    DateTimePicker1: TDateTimePicker;
    StringGrid1: TStringGrid;
    Button1: TButton;
    Memo1: TMemo;
    Button2: TButton;
    SaveDialog1: TSaveDialog;
    Button3: TButton;
    procedure FormCreate(Sender: TObject);
    procedure DateTimePicker1Change(Sender: TObject);
    Procedure Add(var l : node; val : TPred);
    procedure Button2Click(Sender: TObject);
    function CollectSubj:TStringList;
    procedure Button1Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private
    { Private declarations }
  public
  rasp:node;    //������ � �����������
  tips:TStringList;   //���� ���������
  function mintotime(m:integer):string;
  Procedure UpdateSG(var sg:TStringGrid;day:integer);
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses Unit2;

{$R *.dfm}
//�������� ������� �����
procedure TForm1.FormCreate(Sender: TObject);
var
startmin,i,fs,nday,dow:integer;
f:file of TPred;
r:TPred;
begin
DateTimePicker1.Date:=now;
//��������� ���� ���������
tips:=TStringList.Create;
tips.Add('');
tips.Add('������');
tips.Add('�������');
tips.Add('��������');
tips.Add('������������ ������');
tips.Add('������');
//��������� ������� ������ �������
StringGrid1.Cells[1, 0]:='�������';
StringGrid1.Cells[2, 0]:='�������������';
StringGrid1.Cells[3, 0]:='��� ����';
StringGrid1.Cells[4, 0]:='�������';
//��������� ������� � �������� �������
startmin:=8*60;
for i:=1 to 8 do
  begin
  StringGrid1.Cells[0, i]:=mintotime(startmin);
  startmin:=startmin+90;
  end;

rasp:=nil;
//���� ���������� ���� � �����������
if FileExists('rsp.dat') then
  begin
  AssignFile(f,'rsp.dat');
  Reset(f);   //��������� ����
  fs:=FileSize(f);
  //��������� � ������� ���������� � ������
  for i:=1 to fs do
    begin
    read(f,r);
    Add(rasp,r);
    end;
  CloseFile(f);
  end
else //���� ��� �����, ������� ������ � ������ �����������
  begin
  for nday:=0 to 4 do
    for i:=1 to 8 do
      begin
        r.day:=nday;
        r.predmet:='';
        r.prepod:='';
        r.tip:=0;
        r.room:='';
        Add(rasp,r);
      end;
  end;
//���������� ����� ������� ���� ������
dow:=DayOfWeek(now)-1;
dow:=(dow+6) mod 7;
//������� � ������� ���������� �� �������
UpdateSG(StringGrid1,dow);
end;
//�������������� ���������� ����� � ������ ����� � ������ �� ��������
function TForm1.mintotime(m: integer): string;
var
hr,mn:integer;
begin
hr:=m div 60;
mn:=m mod 60;
result:='';
if hr<10 then result:=result+'0';
result:=result+IntToStr(hr);
result:=result+':';
if mn<10 then result:=result+'0';
result:=result+IntToStr(mn);
end;
//���������� ������� ����������� ��� day
procedure TForm1.UpdateSG(var sg: TStringGrid; day: integer);
var
x:node;
row,i,j:integer;
begin
x:=rasp;
row:=1;   //������� ������ �������
//������� �������
for i:=1 to 8 do
  for j:=1 to 4 do
    sg.Cells[j, i]:='';
while x<>nil do   //���� �� ������
  begin
  if x^.v.day=day then   //���� ����� ���������� �� �������� ����
    begin //��������� ��� �������� � �������
    sg.Cells[1, row]:=x^.v.predmet;
    sg.Cells[2, row]:=x^.v.prepod;
    sg.Cells[3, row]:=tips[x^.v.tip];
    sg.Cells[4, row]:=x^.v.room;
    row:=row+1;   //��������� ������ �������
    end;
  x:=x^.next;     //��������� ������� ������
  end;
end;

{����� ����������� ��������}
function getprev(t,x:node):node;
begin
if (t=nil) or (t=x) then
  getprev:=nil
else
  begin
    {����� ������� ��������}
    while t^.next<>x do	{���� �� ��������� ������� ��������}
      begin
      t:=t^.next;	{��������� �������}
      end;
    getprev:=t;
  end;
end;
//�������� ����
procedure TForm1.DateTimePicker1Change(Sender: TObject);
var
dow:integer;
begin
//���������� ���� ������ ����� ����
dow:=DayOfWeek(DateTimePicker1.DateTime)-1;
dow:=(dow+6) mod 7;
//��������� ���������� �� ���� ����
UpdateSG(StringGrid1,dow);
end;
//���������� � ������
procedure TForm1.Add(var l: node; val: TPred);
var
t,x:node;
begin
  new(x);{������� ����� ������� ������}
  x^.v:=val;
  x^.next:=nil;{��������� ��������� ����� 0}
  if l<>nil then  {���� �� ������}
    begin
  {����� ���������� ��������}
    t:=getprev(l,nil);
    t^.next:=x;	{��������� � �����}
  end
  else  {��� ������� ������� ������ ������ �������}
    l:=x;
end;
//������������ ������ ���������
procedure TForm1.Button2Click(Sender: TObject);
var
subj: TStringList;
begin
subj:=CollectSubj;  //������� �������� �� ������
Memo1.Lines:=subj;
  SaveDialog1.FileName:='������ ���������.txt';
  if SaveDialog1.Execute then {���� ������� ����}
    begin   //��������� � ����
    Memo1.Lines.SaveToFile(SaveDialog1.FileName);
    end;
subj.Free;
end;
//���� ��������� �� ������
function TForm1.CollectSubj: TStringList;
var
mySet: TStringList;
x:node;
begin
mySet := TStringList.Create;  //������ ���������
x:=rasp;       //������ ������ ���������
while x<>nil do //���� �� ������
  begin //���� ������� �� ������ ������ �������� ��� � ������
  if (x^.v.predmet<>'') and (mySet.IndexOf(x^.v.predmet) = -1) Then
    mySet.Add(x^.v.predmet);  //�������� � ������ ���������
  x:=x^.next;       //��������� ������� ������
  end;
CollectSubj:=mySet;     //������� ��������� ��������
end;
//��������������
procedure TForm1.Button1Click(Sender: TObject);
begin
Form2.ShowModal();
end;
//���������� ���������� ��������
procedure TForm1.Button3Click(Sender: TObject);
var
x:node;
pair:integer;
subj,day:string;
begin
//���������� ������� � ���������� ������ �������
subj:=StringGrid1.Cells[1,StringGrid1.Row];
if subj='' then
  ShowMessage('�������� ������ � ������ ���������')
else
  begin //�������� ���������
  Memo1.Lines.Clear;
  Memo1.Lines.Add(subj+' ������:');
  x:=rasp;
  pair:=0;
  while x<>nil do    //���� �� ������
    begin
    if x^.v.predmet=subj then    //���� ��������� ������ ������� � ����������
      begin
      case x^.v.day of   //���������� ���� �� ������
      0:day:='�����������';
      1:day:='�������';
      2:day:='�����';
      3:day:='�������';
      4:day:='�������';
      end; //��������� � ����������
      Memo1.Lines.Add(day+' '+mintotime(8*60+pair*90) +' '+tips[x^.v.tip] + ' ������������� '+x^.v.prepod + ' � �������� '+x^.v.room);
      end;
    x:=x^.next;      //��������� ������� ������
    inc(pair);
    pair:=pair mod 8;
    end;
  SaveDialog1.FileName:=subj+'.txt';
  if SaveDialog1.Execute then {���� ������� ����}
    begin //�������� ��������� � ����
    Memo1.Lines.SaveToFile(SaveDialog1.FileName);
    end;
  end;
end;

end.
