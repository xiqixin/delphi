unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls,Contnrs;

type
  TForm1 = class(TForm)
    Memo1: TMemo;
    Button1: TButton;
    Edit1: TEdit;
    btn1: TButton;
    procedure Button1Click(Sender: TObject);
    procedure btn1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    function jisuanstring(astr :string):Double;
function jisuanstring2(astr :string):Double;

  end;

var
  Form1: TForm1;
  stack:TStack;


implementation

{$R *.dfm}
//��������ȼ�
function priority( s: string):Integer;
begin
  if s = '+'then
  begin
    Result := 1;
  end
  else if s =  '-' then
  begin
    Result := 1;
  end
  else if s = '*' then
  begin
    Result := 2;
  end
  else if s = '/' then
  begin
    Result := 2;
  end
  else if s = '(' then
  begin
    Result := -1;
  end
  else
  begin
    Result := 0;
  end;
end;

function isNum( s:string):Boolean ;
begin
   Result := False;
   if (s = '0') or (s = '1')
        or (s = '2') or (s = '3')
        or (s = '4') or (s = '5')
        or (s = '6') or (s = '7')
        or (s = '8') or (s = '9')then
   begin
     Result := True;
   end;
end;

function isOperator(const s:string):Boolean;
begin
   Result := False;
   if (s = '+') or (s = '-')or (s = '*') or (s = '/')then
   begin
     Result := True;
   end;
end;


function TForm1.jisuanstring2(astr :string):Double;
var
  Estr:string;
  I:integer;
  lvstr :string;
  lvBoStart :boolean;
  lvstr2Bak :string;
  lvFind :boolean;
  rStr :string;
begin
{1+1+(2+3+(1+1))}
  Result := 0;
  Estr := astr;
  lvstr := ''; lvBoStart := false;  lvstr2Bak := '';
  rStr := '';

  for I := 1 to Length(Estr) do
  begin
    if lvBoStart and (Estr[i] <> ')') and (Estr[i] <> '(') then
      lvstr := lvstr + Estr[i]
    else
    begin
      if not (Estr[i] in ['(',')']) then
      begin
        lvstr2Bak := lvstr2Bak + Estr[i]
      end;
    end;
    {���������Ŵ������}
    if Estr[i] = '(' then
    begin
      lvBoStart := True;
      if lvBoStart and (Trim(lvstr) <> '') then
      begin
        lvstr2Bak := lvstr2Bak + '(' + lvstr;
        lvstr := '';
        rStr := rStr+')';
        Continue;
      end;
    end;

    if (Estr[i] = ')') and lvBoStart then
    begin
      lvBoStart := False;
      if Trim(lvstr)<>'' then
      begin
        lvstr := FloatToStr(jisuanstring(lvstr));
        lvstr2Bak := lvstr2Bak +lvstr;
        if rStr <>'' then
            lvstr2Bak := lvstr2Bak + rStr;

        lvstr := '';
        //rStr := '';
      end;
    end;
  end;

  lvFind := False;
  for I := 1 to Length(lvstr2Bak) do
  begin
    if (lvstr2Bak[i] = ')') or (lvstr2Bak[i] = '(') then
    begin
      lvFind := True;
      Break;
    end;
  end;

  if lvFind then
    Result := jisuanstring2(lvstr2Bak)
  else
    Result := jisuanstring(lvstr2Bak);
end;

function TForm1.jisuanstring(astr :string):Double;
var
  Estr:string;
  Elm,RElm:string;
  I,J,K,M:integer;
  array1,array2:array of string;
  Rstarray:array of Double;
  tmpArray:array of string;
  num1,num2,tmpResult:Double;
  lvstr :string;
  lvBoStart :boolean;
  lvstr2 :string;
begin
  Estr := Trim(astr);
    {Estr����������ַ���}

  {�����ַ���ȡ�����ֺ������}
  SetLength(array1,255);
  SetLength(array2,255);
  SetLength(tmpArray,255);
  SetLength(Rstarray,32);
  for I := 0 to 63 do
  begin
    tmpArray[I] := '-1';
  end;
  {��Edit���յ����ַ�������tmpArray}
  for I := 1 to Length(Estr) do
  begin
    tmpArray[I-1] :=  Estr[I];
  end;
  {����Array1������׺���ʽ}
  J := 0; //array1���±�
  K := 0; //array2���±�
  M := 0; //��¼�Ѿ���ӹ�������

  for I := 0 to 255 do
  begin
    if tmpArray[I] = '-1' then  Break;

    if isNum(tmpArray[I]) then
    begin
      if M = 0 then
      begin
        array1[J] := tmpArray[I];
        M := I+1;
      end
      else if M>I then
      begin
        continue; //���������Ѿ����뵽array1[J],����ֱ������
      end;
      array1[J] := tmpArray[I];
      M := I+1;
      while tmpArray[M]<> '-1'do
      begin
        if isNum(tmpArray[M])then
        begin
          array1[J] := array1[J]+ tmpArray[M];
          Inc(M);
        end
        else
        begin
          break;
        end;
    end;
    Inc(J);
    end
    else if isOperator(tmpArray[I]) or (tmpArray[I] = '(') or (tmpArray[I] = ')') then
    begin
      array1[J] := tmpArray[I];
      Inc(J);
    end
    else
    begin
      Memo1.Lines.Add('��������ȷ�ı��ʽ����');
      exit;
    end;
  end;
  for I := 0 to 255 do
  begin
    if array1[I] = '' then
    begin
      array1[I] := '#';
      break;
    end;
  end;
  J := 0;
  I := 0;
  stack := TStack.Create();


  {Array1������׺���ʽ��Array2�����׺���ʽ,��׺ת��׺}
  for I := 0 to 255 do
  begin
    if isOperator(Array1[I]) then
    begin
      if J = 0 then
      begin
        Memo1.Lines.Add('��������ȷ�ı��ʽ����');
        exit;
      end;
      if stack.count = 0 then
      begin
        stack.Push(Pointer(Array1[I]));
      end
      else
      begin
        Elm := string(stack.peek());
        Memo1.Lines.Add('��ǰջ��Ԫ��' + Elm);
        while ((stack.count) <> 0) and
          (priority(Elm) >= priority(Array1[I])) do
        begin
          Array2[J] := string(stack.peek());
          Inc(J);
          stack.Pop;
        end;
        stack.push(Pointer(Array1[I]));
        Elm := string(stack.peek());
        Memo1.Lines.Add('��������ջ' + Elm);
      end
    end
    else if Array1[I] = '('then
    begin
      stack.Push(Pointer(Array1[I]));
      //Elm := string(stack.peek());
      Memo1.Lines.Add('��ǰջ��Ԫ��' + Elm);
    end
    else if Array1[I] = ')'then
    begin
       Elm := string(stack.peek());
       while not(Elm = '(' )do
       begin
          //Elm := string(stack.peek());

          Elm := string(stack.pop());
          Memo1.Lines.Add(')����ʱ��ǰջ��Ԫ��' + Elm);
          Array2[J] := Elm;
          Inc(J);
          //stack.Pop;
       end;
       J := J-1;
       //stack.Pop;
    end
    else if Array1[I] = '#'then
    begin
       while stack.count <> 0 do
        begin
          Elm := string(stack.peek());
          Array2[J] := Elm;
          Inc(J);
          stack.Pop;
        end;
        break;
    end
    else
    begin
      Array2[J] := Array1[I];
      Inc(J);
    end;

  end;

  Memo1.Lines.Add('stack count: '+IntToStr(stack.count));//��ʾջ��Ԫ�ظ�����Ӧ��Ϊ0��
  stack.Free;
  for I := 0 to 255 do
  begin
    if (Array2[I] = '') then
    begin
      Break;
    end;
    Memo1.Lines.Add('��׺���ʽ��'+Array2[I]);
  end;
  //��Rstarray��ʼ��Ϊȫ0
  for I := 0 to 31 do
  begin
    Rstarray[I] := 0;
  end;

  //��׺���ʽ�ļ���,Array2�б�����Ǻ�׺���ʽ
  //��Rstarray����������
  J := 0;//Rsta

  tmpResult := 0;
  for I := 0 to 255 do
  begin
    if isOperator(Array2[I]) then
    begin
       if High(Rstarray) = Low(Rstarray) then
       begin
         Memo1.Lines.Add('��׺���ʽ����');
         Exit;
       end
       else
       begin
         if J>=1 then
         begin
           if array2[I] = '+' then
           begin
             J := J-1;
             if (J = 0) then
             begin
               Inc(J);
               Break;
             end;
             Rstarray[J-1] := Rstarray[J-1] + Rstarray[J];
             Rstarray[J] := 0;
             J := J - 1;
             if (J = 0) and (Array2[I+1] = '')then
             begin
               Memo1.Lines.Add('��������'+ FloatToStr(Rstarray[0]));
               Result := Rstarray[0];
               Exit;
             end
             else
             begin
               Inc(J);
             end;
           end
           else if array2[I] = '-' then
           begin
             J := J-1;
             if (J = 0) then
             begin
               Inc(J);
               Break;
             end;
             Rstarray[J-1] := Rstarray[J-1] - Rstarray[J];
             Rstarray[J] := 0;
             J := J-1;
             if (J = 0) and (Array2[I+1] = '')then
             begin
               Memo1.Lines.Add('��������'+ FloatToStr(Rstarray[0]));
               Result := Rstarray[0];
               Exit;
             end
             else
             begin
               Inc(J);
             end;
           end
           else if array2[I] = '*' then
           begin
             J := J-1;
             if (J = 0) then
             begin
               Inc(J);
               Break;
             end;
             Rstarray[J-1] := Rstarray[J-1] * Rstarray[J];
             Rstarray[J] := 0;
             J := J-1;
             if (J = 0) and (Array2[I+1] = '')then
             begin
               Memo1.Lines.Add('��������'+ FloatToStr(Rstarray[0]));
               Result := Rstarray[0];
               Exit;
             end
             else
             begin
               Inc(J);
             end;
           end
           else if array2[I] = '/' then
           begin
             J := J-1;
             if (J = 0) then
             begin
               Inc(J);
               Break;
             end;
             Rstarray[J-1] := Rstarray[J-1] / Rstarray[J];
             Rstarray[J] := 0;
             J := J-1;
             if (J = 0) and (Array2[I+1] = '')then
             begin
               Memo1.Lines.Add('��������'+ FloatToStr(Rstarray[0]));
               Result := Rstarray[0];
               Exit;
             end
             else
             begin
               Inc(J);
             end;
           end;
         end;
       end;
    end
    else
    begin
      //����Array2[I]��ʾ������
      if J = -1 then
      begin
        Memo1.Lines.Add('��������'+ FloatToStr(Rstarray[0]));
        Result := Rstarray[0];
        Exit;
      end
      else
      begin
        Rstarray[J] := StrToFloat(Array2[I]);
        Inc(J);
      end;
    end;
  end;
end;

procedure TForm1.btn1Click(Sender: TObject);
begin
  Memo1.Lines.Add(FloatToStr(jisuanstring2(Edit1.Text)));
end;

procedure TForm1.Button1Click(Sender: TObject);
var
  Estr:string;
  Elm,RElm:string;
  I,J,K,M:integer;
  array1,array2:array of string;
  Rstarray:array of Double;
  tmpArray:array of string;
  num1,num2,tmpResult:Double;
begin
  {Estr����������ַ���}
  Estr := Edit1.Text;
  Memo1.Lines.Add(Estr+' ���������ǣ� ');
  {�����ַ���ȡ�����ֺ������}
  SetLength(array1,32);
  SetLength(array2,32);
  SetLength(tmpArray,64);
  SetLength(Rstarray,32);
  for I := 0 to 63 do
  begin
    tmpArray[I] := '-1';
  end;
  {��Edit���յ����ַ�������tmpArray}
  for I := 1 to Length(Estr) do
  begin
    tmpArray[I-1] :=  Estr[I];
  end;
  {����Array1������׺���ʽ}
  J := 0; //array1���±�
  K := 0; //array2���±�
  M := 0; //��¼�Ѿ���ӹ�������

  for I := 0 to 63 do
  begin
    if tmpArray[I] = '-1' then  Break;

    if isNum(tmpArray[I]) then
    begin
      if M = 0 then
      begin
        array1[J] := tmpArray[I];
        M := I+1;
      end
      else if M>I then
      begin
        continue; //���������Ѿ����뵽array1[J],����ֱ������
      end;
      array1[J] := tmpArray[I];
      M := I+1;
      while tmpArray[M]<> '-1'do
      begin
        if isNum(tmpArray[M])then
        begin
          array1[J] := array1[J]+ tmpArray[M];
          Inc(M);
        end
        else
        begin
          break;
        end;
    end;
    Inc(J);
    end
    else if isOperator(tmpArray[I]) or (tmpArray[I] = '(') or (tmpArray[I] = ')') then
    begin
      array1[J] := tmpArray[I];
      Inc(J);
    end
    else
    begin
      Memo1.Lines.Add('��������ȷ�ı��ʽ����');
      exit;
    end;
  end;
  for I := 0 to 63 do
  begin
    if array1[I] = '' then
    begin
      array1[I] := '#';
      break;
    end;
  end;
  J := 0;
  I := 0;
  stack := TStack.Create();


  {Array1������׺���ʽ��Array2�����׺���ʽ,��׺ת��׺}
  for I := 0 to 31 do
  begin
    if isOperator(Array1[I]) then
    begin
      if J = 0 then
      begin
        Memo1.Lines.Add('��������ȷ�ı��ʽ����');
        exit;
      end;
      if stack.count = 0 then
      begin
        stack.Push(Pointer(Array1[I]));
      end
      else
      begin
        Elm := string(stack.peek());
        while ((stack.count) <> 0) and
          (priority(Elm) >= priority(Array1[I])) do
        begin
          Array2[J] := string(stack.peek());
          Inc(J);
          stack.Pop;
        end;
        stack.push(Pointer(Array1[I]));
      end
    end
    else if Array1[I] = '('then
    begin
      stack.Push(Pointer(Array1[I]));
    end
    else if Array1[I] = ')'then
    begin
       Elm := string(stack.peek());
       while not(Elm = '(' )do
       begin
          Elm := string(stack.pop());
          Array2[J] := Elm;
          Inc(J);
          //stack.Pop;
       end;
       J := J-1;
       //stack.Pop;
    end
    else if Array1[I] = '#'then
    begin
       while stack.count <> 0 do
        begin
          Elm := string(stack.peek());
          Array2[J] := Elm;
          Inc(J);
          stack.Pop;
        end;
        break;
    end
    else
    begin
      Array2[J] := Array1[I];
      Inc(J);
    end;

  end;

  Memo1.Lines.Add('stack count: '+IntToStr(stack.count));//��ʾջ��Ԫ�ظ�����Ӧ��Ϊ0��
  for I := 0 to 31 do
  begin
    if (Array2[I] = '') then
    begin
      Break;
    end;
    Memo1.Lines.Add('��׺���ʽ��'+Array2[I]);
  end;
  //��Rstarray��ʼ��Ϊȫ0
  for I := 0 to 31 do
  begin
    Rstarray[I] := 0;
  end;

  //��׺���ʽ�ļ���,Array2�б�����Ǻ�׺���ʽ
  //��Rstarray����������
  J := 0;//Rstarray���±�
  m := 0;
  tmpResult := 0;
  for I := 0 to 31 do
  begin
    if isOperator(Array2[I]) then
    begin
       if High(Rstarray) = Low(Rstarray) then
       begin
         Memo1.Lines.Add('��׺���ʽ����');
         Exit;
       end
       else
       begin
         if J>=1 then
         begin
           if array2[I] = '+' then
           begin
             J := J-1;
             if (J = 0) then
             begin
               Inc(J);
               Break;
             end;
             Rstarray[J-1] := Rstarray[J-1] + Rstarray[J];
             Rstarray[J] := 0;
             J := J - 1;
             if (J = 0) and (Array2[I+1] = '')then
             begin
               Memo1.Lines.Add('��������'+ FloatToStr(Rstarray[0]));
               Exit;
             end
             else
             begin
               Inc(J);
             end;
           end
           else if array2[I] = '-' then
           begin
             J := J-1;
             if (J = 0) then
             begin
               Inc(J);
               Break;
             end;
             Rstarray[J-1] := Rstarray[J-1] - Rstarray[J];
             Rstarray[J] := 0;
             J := J-1;
             if (J = 0) and (Array2[I+1] = '')then
             begin
               Memo1.Lines.Add('��������'+ FloatToStr(Rstarray[0]));
               Exit;
             end
             else
             begin
               Inc(J);
             end;
           end
           else if array2[I] = '*' then
           begin
             J := J-1;
             if (J = 0) then
             begin
               Inc(J);
               Break;
             end;
             Rstarray[J-1] := Rstarray[J-1] * Rstarray[J];
             Rstarray[J] := 0;
             J := J-1;
             if (J = 0) and (Array2[I+1] = '')then
             begin
               Memo1.Lines.Add('��������'+ FloatToStr(Rstarray[0]));
               Exit;
             end
             else
             begin
               Inc(J);
             end;
           end
           else if array2[I] = '/' then
           begin
             J := J-1;
             if (J = 0) then
             begin
               Inc(J);
               Break;
             end;
             Rstarray[J-1] := Rstarray[J-1] / Rstarray[J];
             Rstarray[J] := 0;
             J := J-1;
             if (J = 0) and (Array2[I+1] = '')then
             begin
               Memo1.Lines.Add('��������'+ FloatToStr(Rstarray[0]));
               Exit;
             end
             else
             begin
               Inc(J);
             end;
           end;
         end;
       end;
    end
    else
    begin
      //����Array2[I]��ʾ������
      if J = -1 then
      begin
        Memo1.Lines.Add('��������'+ FloatToStr(Rstarray[0]));
        Exit;
      end
      else
      begin
        Rstarray[J] := StrToFloat(Array2[I]);
        Inc(J);
      end;
    end;
  end;

  Memo1.Lines.Add('��������'+ FloatToStr(Rstarray[0]));
end;

end.
