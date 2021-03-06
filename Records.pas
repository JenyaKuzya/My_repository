unit Records;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.StdCtrls, Vcl.Grids,
  Vcl.DBGrids;

type
  TFRecord = class(TForm)
    ESearch: TEdit;
    BSearch: TButton;
    RAuthor: TRadioButton;
    RBook: TRadioButton;
    Label1: TLabel;
    BAdd: TButton;
    BDelete: TButton;
    BChange: TButton;
    StringGrid1: TStringGrid;
    ComboBox1: TComboBox;
    Label2: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure RButtonClick(Sender: TObject);
    procedure BAddClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ESearchClick(Sender: TObject);
    procedure BDeleteClick(Sender: TObject);
    procedure DeleteARow(Grid: TStringGrid; ARow: Integer);
    procedure StringGrid1SelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure BChangeClick(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure BSearchClick(Sender: TObject);
    procedure ESearchKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FRecord: TFRecord;

implementation

{$R *.dfm}

uses Add, Lib;

type
  TMyGrid = class(TCustomGrid);

procedure TFRecord.DeleteARow(Grid: TStringGrid; ARow: Integer);
begin
  TMyGrid(Grid).DeleteRow(ARow);
end;

procedure TFRecord.BAddClick(Sender: TObject);
begin
  FAdd.Show;
  FAdd.BCompleteAdd.Visible := True;
  FAdd.BCompleteChange.Visible := False;
  FAdd.EAuthor.Text := '';
  FAdd.EName.Text := '';
  FAdd.EYear.Text := '';
end;

procedure TFRecord.BChangeClick(Sender: TObject);
var
  i: Integer;
  el: TBook;
begin
  if (first^.next <> nil) and (FRecord.StringGrid1.RowCount > 1) then
  begin
    FAdd.Show;
    FAdd.BCompleteAdd.Visible := False;
    FAdd.BCompleteChange.Visible := True;
    q := first;
    el.Author := FRecord.StringGrid1.cells[0,StringGrid1.row];
    el.NameOfBook := FRecord.StringGrid1.cells[1,StringGrid1.row];
    el.Year := StrToInt(FRecord.StringGrid1.cells[2,StringGrid1.row]);
    while (el.Author <> q^.Element.Author) and (el.NameOfBook <> q^.Element.NameOfBook) and (el.Year <> q^.Element.Year) do
      q := q^.next;
    FAdd.EAuthor.Text := q^.Element.Author;
    FAdd.EName.Text := q^.Element.NameOfBook;
    FAdd.EYear.Text := IntToStr(q^.Element.Year);
  end;
end;

procedure TFRecord.BDeleteClick(Sender: TObject);
begin
    if (first^.next <> nil) and (FRecord.StringGrid1.RowCount > 1) then
    begin
      DeleteBook(first, StringGrid1.row);
      DeleteARow(StringGrid1, StringGrid1.Row);
    end;
end;

procedure TFRecord.BSearchClick(Sender: TObject);
begin
  if RAuthor.Checked then
    SearchBook(first, ESearch.Text, 0);
  if RBook.Checked then
    SearchBook(first, ESearch.Text, 1);
end;

procedure TFRecord.ComboBox1Change(Sender: TObject);
begin
  if ComboBox1.Items[ComboBox1.ItemIndex] = '������� ����������' then
    showdata(first, StringGrid1)
  else
  begin
    if ComboBox1.Items[ComboBox1.ItemIndex] = '������' then
      sortlist(first, 0);
    if ComboBox1.Items[ComboBox1.ItemIndex] = '��������' then
      sortlist(first, 1);
  end;
end;

procedure TFRecord.ESearchClick(Sender: TObject);
begin
  if (ESearch.Text = '�����') or (ESearch.Text = '�������� �����') then
    ESearch.Text := '';
end;

procedure TFRecord.ESearchKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    Key := #0;
    BSearchClick(BSearch);
  end;
end;

procedure TFRecord.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Rewrite(f);
  q := first;
  while q^.next <> nil do
  begin
    q := q^.next;
    write(f, q^.Element);
  end;
  CloseFile(f);
  deletelist(first);
end;

procedure TFRecord.FormCreate(Sender: TObject);
begin
  RBook.Checked := True;
  with ComboBox1 do
  begin
    items.add('������� ����������');
    items.add('������');
    items.add('��������');
  end;
  ComboBox1.ItemIndex := 0;
  with StringGrid1 do
  begin
    Cells[0,0] := '�����';
    Cells[1,0] := '�������� �����';
    Cells[2,0] := '��� �������';
  end;
  New(first);
  q := first;
  q^.next := nil;
  AssignFile(f,'Books.txt');
  //Reset(F);
  if not FileExists('Books.txt') then
    ReWrite(F)
  else
    Reset(F);
  while not Eof(F) do
  begin
    New(q^.next);
    q := q^.next;
    read(f, q^.Element);
    q^.next := nil;
  end;
  showdata(first, StringGrid1);
  if first^.next = nil then
    StringGrid1.RowCount := 2;
  StringGrid1.Row := 1;
  CloseFile(f);
end;

procedure TFRecord.RButtonClick(Sender: TObject);
begin
  ESearch.Text := (Sender as TRadioButton).Caption;
end;

procedure TFRecord.StringGrid1SelectCell(Sender: TObject; ACol, ARow: Integer;
  var CanSelect: Boolean);
begin
  if ARow = 0 then
    CanSelect := False;
end;

end.
