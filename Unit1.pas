unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Grids, ComCtrls;
type TPred=record    //описание предмета
day: integer;     //день недели
predmet: string[30];  //предмет
prepod: string[30];   //преподаватель
tip:integer;        //тип занятия
room:string[10];    //кабинет
end;
node = ^S;  {определение указателя на элемент списка}
S=record  {определение записи, являющейся элементом списка}
v:TPred;  //предмет
next:node; {указатель на следующий элемент списка}
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
  rasp:node;    //список с расписанием
  tips:TStringList;   //типы предметов
  function mintotime(m:integer):string;
  Procedure UpdateSG(var sg:TStringGrid;day:integer);
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses Unit2;

{$R *.dfm}
//создание главной формы
procedure TForm1.FormCreate(Sender: TObject);
var
startmin,i,fs,nday,dow:integer;
f:file of TPred;
r:TPred;
begin
DateTimePicker1.Date:=now;
//заполнить типы предметов
tips:=TStringList.Create;
tips.Add('');
tips.Add('Лекция');
tips.Add('Семинар');
tips.Add('Практика');
tips.Add('Лабораторная работа');
tips.Add('Другое');
//Заполнить верхнюю строку таблицы
StringGrid1.Cells[1, 0]:='Предмет';
StringGrid1.Cells[2, 0]:='Преподаватель';
StringGrid1.Cells[3, 0]:='Тип пары';
StringGrid1.Cells[4, 0]:='Кабинет';
//заполнить столбец с временем занятий
startmin:=8*60;
for i:=1 to 8 do
  begin
  StringGrid1.Cells[0, i]:=mintotime(startmin);
  startmin:=startmin+90;
  end;

rasp:=nil;
//если существует файл с расписанием
if FileExists('rsp.dat') then
  begin
  AssignFile(f,'rsp.dat');
  Reset(f);   //открываем файл
  fs:=FileSize(f);
  //считываем и заносим расписание в список
  for i:=1 to fs do
    begin
    read(f,r);
    Add(rasp,r);
    end;
  CloseFile(f);
  end
else //если нет файла, создаем список с пустым расписанием
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
//определяем какой сегодня день недели
dow:=DayOfWeek(now)-1;
dow:=(dow+6) mod 7;
//выводим в таблицу расписание на сегодня
UpdateSG(StringGrid1,dow);
end;
//преобразование количества минут с начала суток в строку со временем
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
//Обновление таблицы расписанием дня day
procedure TForm1.UpdateSG(var sg: TStringGrid; day: integer);
var
x:node;
row,i,j:integer;
begin
x:=rasp;
row:=1;   //текущая строка таблицы
//очищаем таблицу
for i:=1 to 8 do
  for j:=1 to 4 do
    sg.Cells[j, i]:='';
while x<>nil do   //цикл по списку
  begin
  if x^.v.day=day then   //если нашли расписание на заданный день
    begin //добавляем эти предметы в таблицу
    sg.Cells[1, row]:=x^.v.predmet;
    sg.Cells[2, row]:=x^.v.prepod;
    sg.Cells[3, row]:=tips[x^.v.tip];
    sg.Cells[4, row]:=x^.v.room;
    row:=row+1;   //следующая строка таблицы
    end;
  x:=x^.next;     //следующий элемент списка
  end;
end;

{поиск предыдущего элемента}
function getprev(t,x:node):node;
begin
if (t=nil) or (t=x) then
  getprev:=nil
else
  begin
    {поиск нужного элемента}
    while t^.next<>x do	{пока не достигнем нужного элемента}
      begin
      t:=t^.next;	{следующий элемент}
      end;
    getprev:=t;
  end;
end;
//извенили дату
procedure TForm1.DateTimePicker1Change(Sender: TObject);
var
dow:integer;
begin
//определяем день недели новой даты
dow:=DayOfWeek(DateTimePicker1.DateTime)-1;
dow:=(dow+6) mod 7;
//обновляем расписание на этот день
UpdateSG(StringGrid1,dow);
end;
//добавление в список
procedure TForm1.Add(var l: node; val: TPred);
var
t,x:node;
begin
  new(x);{создаем новый элемент списка}
  x^.v:=val;
  x^.next:=nil;{следующим элементом будет 0}
  if l<>nil then  {если не пустой}
    begin
  {поиск последнего элемента}
    t:=getprev(l,nil);
    t^.next:=x;	{вставляем в хвост}
  end
  else  {для пустого текущая голова станех фвостом}
    l:=x;
end;
//Сформировать список предметов
procedure TForm1.Button2Click(Sender: TObject);
var
subj: TStringList;
begin
subj:=CollectSubj;  //собрать предметы из списка
Memo1.Lines:=subj;
  SaveDialog1.FileName:='Список предметов.txt';
  if SaveDialog1.Execute then {если выбрали файл}
    begin   //сохранить в файл
    Memo1.Lines.SaveToFile(SaveDialog1.FileName);
    end;
subj.Free;
end;
//сбор предметов по списку
function TForm1.CollectSubj: TStringList;
var
mySet: TStringList;
x:node;
begin
mySet := TStringList.Create;  //список предметов
x:=rasp;       //начало списка предметов
while x<>nil do //цикл по списку
  begin //если предмет не пустая строка вредмета нет в списке
  if (x^.v.predmet<>'') and (mySet.IndexOf(x^.v.predmet) = -1) Then
    mySet.Add(x^.v.predmet);  //добавить в список предметов
  x:=x^.next;       //следующий элемент списка
  end;
CollectSubj:=mySet;     //вернуть собранные предметы
end;
//редактирование
procedure TForm1.Button1Click(Sender: TObject);
begin
Form2.ShowModal();
end;
//расписание выбранного предмета
procedure TForm1.Button3Click(Sender: TObject);
var
x:node;
pair:integer;
subj,day:string;
begin
//опредеряем предмет в выделенной строке таблицы
subj:=StringGrid1.Cells[1,StringGrid1.Row];
if subj='' then
  ShowMessage('Выберите строку с нужным предметом')
else
  begin //очистить результат
  Memo1.Lines.Clear;
  Memo1.Lines.Add(subj+' бывает:');
  x:=rasp;
  pair:=0;
  while x<>nil do    //цикл по списку
    begin
    if x^.v.predmet=subj then    //если встретили нужный предмет в расписании
      begin
      case x^.v.day of   //определяем день по номеру
      0:day:='Понедельник';
      1:day:='Вторник';
      2:day:='Среда';
      3:day:='Четверг';
      4:day:='Пятница';
      end; //добавляем в расписение
      Memo1.Lines.Add(day+' '+mintotime(8*60+pair*90) +' '+tips[x^.v.tip] + ' Преподаватель '+x^.v.prepod + ' в кабинете '+x^.v.room);
      end;
    x:=x^.next;      //следующий элемент списка
    inc(pair);
    pair:=pair mod 8;
    end;
  SaveDialog1.FileName:=subj+'.txt';
  if SaveDialog1.Execute then {если выбрали файл}
    begin //записать результат в файл
    Memo1.Lines.SaveToFile(SaveDialog1.FileName);
    end;
  end;
end;

end.
