unit Add;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TFAdd = class(TForm)
    EAuthor: TEdit;
    EName: TEdit;
    EYear: TEdit;
    BCompleteAdd: TButton;
    BCancel: TButton;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    BCompleteChange: TButton;
    procedure BCancelClick(Sender: TObject);
    procedure BCompleteAddClick(Sender: TObject);
    procedure BCompleteChangeClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FAdd: TFAdd;

implementation

{$R *.dfm}

uses Records, Lib;

procedure TFAdd.BCancelClick(Sender: TObject);
begin
  Close
end;

procedure TFAdd.BCompleteAddClick(Sender: TObject);
begin
  if (EAuthor.Text <> '') and (EName.Text <> '') and (EYear.Text <> '') then
  begin
    if CheckBook(first, EAuthor.Text, EName.Text, StrToInt(EYear.Text)) then
      ShowMessage('����� ����� ��� ����')
    else
    begin
      Addrecord(first, EAuthor.Text, EName.Text, StrToInt(EYear.Text));
      showdata(first, FRecord.StringGrid1);
      Close;
    end;
  end
  else
    ShowMessage('��������� ��� ����');
end;

procedure TFAdd.BCompleteChangeClick(Sender: TObject);
begin
  if (EAuthor.Text <> '') and (EName.Text <> '') and (EYear.Text <> '') then
  begin
    q^.Element.Author := EAuthor.Text;
    q^.Element.NameOfBook := EName.Text;
    q^.Element.Year := StrToInt(EYear.Text);
    showdata(first, FRecord.StringGrid1);
    Close;
  end
  else
    ShowMessage('��������� ��� ����');
end;

end.
