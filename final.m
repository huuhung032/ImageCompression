function varargout = final(varargin)
% FINAL MATLAB code for final.fig
%      FINAL, by itself, creates a new FINAL or raises the existing
%      singleton*.
%
%      H = FINAL returns the handle to a new FINAL or the handle to
%      the existing singleton*.
%
%      FINAL('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FINAL.M with the given input arguments.
%
%      FINAL('Property','Value',...) creates a new FINAL or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before final_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to final_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help final

% Last Modified by GUIDE v2.5 07-Apr-2021 10:28:52

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @final_OpeningFcn, ...
                   'gui_OutputFcn',  @final_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before final is made visible.
function final_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to final (see VARARGIN)

% Choose default command line output for final
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes final wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = final_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global infilename;
global AG;
[infilename,pathname]=uigetfile({'.bmp;.jpg;*.png;*.tiff;';'.'},'Ban hay chon buc anh');
if ~isequal(infilename,0)  
    S = imread([pathname,infilename]);                  %Ham imread doc file anh
    axes(handles.axes1);
    imshow(S);                                          %Ham imshow hien thi buc anh
          %Ham iminfo truy xuat thong tin buc anh
                          %FileSize kich thuoc buc anh mac dinh Byte nen chia 1024 ra KB
        info=imfinfo(fullfile(pathname,infilename));           
		AG = (info.FileSize)/1024;                              						          
        set(handles.KB1,'String',AG);
else
    msgbox('Ban hay chon buc anh!')
end

% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global infilename;
global nenfilename;
global Q;
global h;
global w;
global q50;
global Y;
global HS;
global ok
HS = get(handles.HeSo,'value');
    switch HS
        case 1
if~(ischar(infilename))
               errordlg('Ban hay chon buc anh');
            else
Y = imread(infilename);
% Y = I;
[h, w] = size(Y);
r = h/8;
c = w/8;
s = 1;
q50 = [16 11 10 16 24 40 51 61;
       12 12 14 19 26 58 60 55;
       14 13 16 24 40 57 69 56;
       14 17 22 29 51 87 80 62;
       18 22 37 56 68 109 103 77;
       24 35 55 64 81 104 113 92;
       49 64 78 87 103 121 120 101;
       72 92 95 98 112 100 103 99];
   ok=[0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ];
%    COMPRESSION
for i=1:r
    e = 1;
    for j=1:c
        block = Y(s:s+7,e:e+7);
        cent = double(block) - 128;
        for m=1:8
            for n=1:8
                if m == 1
                    u = 1/sqrt(8);
                else
                    u = sqrt(2/8);
                end
                if n == 1
                    v = 1/sqrt(8);
                else
                    v = sqrt(2/8);
                end
                comp = 0;
                for x=1:8
                    for y=1:8
                        comp = comp + cent(x, y)*(cos((((2*(x-1))+1)*(m-1)*pi)/16))*(cos((((2*(y-1))+1)*(n-1)*pi)/16));
                    end
                end
                  F(m, n) = v*u*comp;
              end
          end
          for x=1:8
              for y=1:8
                  cq(x, y) = round(F(x, y)/q50(x, y));
              end
          end
          Q(s:s+7,e:e+7) = cq;
          e = e + 8;
      end
      s = s + 8;
end
            axes(handles.axes2);
            imshow(Q);
end
        case 2
            if~(ischar(infilename))
               errordlg('Ban hay chon buc anh');
            else
Y = imread(infilename);
% Y = I;
[h, w] = size(Y);
r = h/8;
c = w/8;
s = 1;
q50 = [17	18	24	47	99	99	99	99
18	21	26	66	99	99	99	99
24	26	56	99	99	99	99	99
47	66	99	99	99	99	99	99
99	99	99	99	99	99	99	99
99	99	99	99	99	99	99	99
99	99	99	99	99	99	99	99
99	99	99	99	99	99	99	99];
   ok=[0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ];
%    COMPRESSION
for i=1:r
    e = 1;
    for j=1:c
        block = Y(s:s+7,e:e+7);
        cent = double(block) - 128;
        for m=1:8
            for n=1:8
                if m == 1
                    u = 1/sqrt(8);
                else
                    u = sqrt(2/8);
                end
                if n == 1
                    v = 1/sqrt(8);
                else
                    v = sqrt(2/8);
                end
                comp = 0;
                for x=1:8
                    for y=1:8
                        comp = comp + cent(x, y)*(cos((((2*(x-1))+1)*(m-1)*pi)/16))*(cos((((2*(y-1))+1)*(n-1)*pi)/16));
                    end
                end
                  F(m, n) = v*u*comp;
              end
          end
          for x=1:8
              for y=1:8
                  cq(x, y) = round(F(x, y)/q50(x, y));
              end
          end
          Q(s:s+7,e:e+7) = cq;
          e = e + 8;
      end
      s = s + 8;
end
            axes(handles.axes2);
            imshow(Q);
            end
        case 3
               if~(ischar(infilename))
               errordlg('Ban hay chon buc anh');
            else
Y = imread(infilename);
% Y = I;
[h, w] = size(Y);
r = h/8;
c = w/8;
s = 1;
q50 = [16    16    99    99    99    99    99    99;
16    16    99    99    99    99    99    99;
16    99    99    99    99    99    99    99;
99    99    99    99    99    99    99    99;
99    99    99    99    99    99    99    99;
99    99    99    99    99    99    99    99;
99    99    99    99    99    99    99    99;
99    99    99    99    99    99    99    99];
   ok=[0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ];
%    COMPRESSION
for i=1:r
    e = 1;
    for j=1:c
        block = Y(s:s+7,e:e+7);
        cent = double(block) - 128;
        for m=1:8
            for n=1:8
                if m == 1
                    u = 1/sqrt(8);
                else
                    u = sqrt(2/8);
                end
                if n == 1
                    v = 1/sqrt(8);
                else
                    v = sqrt(2/8);
                end
                comp = 0;
                for x=1:8
                    for y=1:8
                        comp = comp + cent(x, y)*(cos((((2*(x-1))+1)*(m-1)*pi)/16))*(cos((((2*(y-1))+1)*(n-1)*pi)/16));
                    end
                end
                  F(m, n) = v*u*comp;
              end
          end
          for x=1:8
              for y=1:8
                  cq(x, y) = round(F(x, y)/q50(x, y));
              end
          end
          Q(s:s+7,e:e+7) = cq;
          e = e + 8;
      end
      s = s + 8;
end
            axes(handles.axes2);
            imshow(Q);
               end
        case 4
               if~(ischar(infilename))
               errordlg('Ban hay chon buc anh');
            else
Y = imread(infilename);
% Y = I;
[h, w] = size(Y);
r = h/8;
c = w/8;
s = 1;
q50 = [16    99    99    99    99    99    99    99;
99    99    99    99    99    99    99    99;
99    99    99    99    99    99    99    99;
99    99    99    99    99    99    99    99;
99    99    99    99    99    99    99    99;
99    99    99    99    99    99    99    99;
99    99    99    99    99    99    99    99;
99    99    99    99    99    99    99    99];
   ok=[0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ];
%    COMPRESSION
for i=1:r
    e = 1;
    for j=1:c
        block = Y(s:s+7,e:e+7);
        cent = double(block) - 128;
        for m=1:8
            for n=1:8
                if m == 1
                    u = 1/sqrt(8);
                else
                    u = sqrt(2/8);
                end
                if n == 1
                    v = 1/sqrt(8);
                else
                    v = sqrt(2/8);
                end
                comp = 0;
                for x=1:8
                    for y=1:8
                        comp = comp + cent(x, y)*(cos((((2*(x-1))+1)*(m-1)*pi)/16))*(cos((((2*(y-1))+1)*(n-1)*pi)/16));
                    end
                end
                  F(m, n) = v*u*comp;
              end
          end
          for x=1:8
              for y=1:8
                  cq(x, y) = round(F(x, y)/q50(x, y));
              end
          end
          Q(s:s+7,e:e+7) = cq;
          e = e + 8;
      end
      s = s + 8;
end
            axes(handles.axes2);
            imshow(Q);
            end
    end

% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.KB1,'String','');
set(handles.KB2,'String','');
set(handles.PSNR,'String','');
cla(handles.axes1,'reset');
cla(handles.axes2,'reset');
set(handles.axes1,'visible','off');
set(handles.axes2,'visible','off');
clear all;


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global outfilename;
global h;
global w;
global Q;
global q50;
global AN;
global Y;
global data1;
r = h/8;
c = w/8;
count=1;
s=1;
for i=1:r
    e = 1;
    for j=1:c
        blk = Q(s:s+7,e:e+7); 
        zigzag=ZigZagscan(blk);
        zigzag_stream(count:count+63) =zigzag;
        count=count+64;
        e = e + 8;
      end
      s = s + 8;
end

count1=1;
sz=size(zigzag_stream);
x=sz(2)/64;
sz1=0;
dem=1;
for i=1:x
    if(i==1)
      for j=1:64
          oldz(j)=0;
      end
    end
    zz=zigzag_stream(count1:count1+63);
    dcbit=DCencode(oldz,zz);
    oldz=zz;
    acbit=ACencode(zz);
    sdc=size(dcbit);
    sac=size(acbit);
    bits(1+sz1:sz1+sdc(2))=dcbit(:);
    bits(sz1+sdc(2)+1:sz1+sdc(2)+sac(2))=acbit(:);
    sz1=sz1+sdc(2)+sac(2);
    count1=count1+64;
    si(dem)=sdc(2)+sac(2);
    dem=dem+1;
end
[data1,pathname]=uiputfile({'*.txt'},'Chon luu file bin');
fileid=fopen('pathname','w');
fprintf(fileid,'%d',bits);
size_bits=size(bits);
down=0;
dem1=1;
count2=1
for i=1:size_bits(2)
    if(down==size_bits(2))
        break
    end
    base=bits(1+down:size_bits(2));
    base1=coeffdecode(base);
    down=down+si(dem1);
    dem1=dem1+1;
    zizi(count2:count2+63)=base1;
    if(count2>1)
        zizi(count2)=zizi(count2)+zizi(count2-64);
    end
    count2=count2+64;
end
count3=1;
s=1;
for i=1:r
    e = 1;
    for j=1:c
        z1=zizi(count3:count3+63);
        bk=izigzag(z1,8,8);
        Q2(s:s+7,e:e+7)=bk;
        count3=count3+64;
        e = e + 8;
      end
      s = s + 8;
end
% % % % % % % % % % % % % % %     
% % DECOMPRESSION
% % % % % % % 
s = 1;
for i=1:r
    e = 1;
    for j=1:c
        cq = Q2(s:s+7,e:e+7);
        for x=1:8
            for y=1:8
                DQ(x, y) = q50(x, y)*cq(x, y); 
            end
        end
        for x = 1:8
        for y = 1:8
            comp = 0;
            for m = 1:8
                for n = 1:8
                    if m == 1
                        u = 1/sqrt(2);
                    else
                        u = 1;
                    end
                    if n == 1
                        v = 1/sqrt(2);
                    else
                        v = 1;
                    end
                    
                    comp = comp + u*v*DQ(m, n)*(cos((((2*(x-1))+1)*(m-1)*pi)/16))*(cos((((2*(y-1))+1)*(n-1)*pi)/16));
                end
            end
           bf(x, y) =  round((1/4) *comp + 128);           
        end
        end
           Org(s:s+7,e:e+7) = bf;
           e = e + 8;
      end
      s = s + 8;
end
      [outfilename,pathname]=uiputfile({'*.jpg'},'Chon luu file JPG');
            imwrite(uint8(Org),[pathname,outfilename]);
            info = imfinfo(fullfile(pathname,outfilename));
            AN =  (info.FileSize)/1024;
            psng=PSNR(Y,uint8(Org))
            set(handles.PSNR,'String',psng);
            set(handles.KB2,'String',AN);
            axes(handles.axes2);
            imshow(uint8(Org));


function KB1_Callback(hObject, eventdata, handles)
% hObject    handle to KB1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of KB1 as text
%        str2double(get(hObject,'String')) returns contents of KB1 as a double


% --- Executes during object creation, after setting all properties.
function KB1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to KB1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function KB2_Callback(hObject, eventdata, handles)
% hObject    handle to KB2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of KB2 as text
%        str2double(get(hObject,'String')) returns contents of KB2 as a double


% --- Executes during object creation, after setting all properties.
function KB2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to KB2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function PSNR_Callback(hObject, eventdata, handles)
% hObject    handle to PSNR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of PSNR as text
%        str2double(get(hObject,'String')) returns contents of PSNR as a double


% --- Executes during object creation, after setting all properties.
function PSNR_CreateFcn(hObject, eventdata, handles)
% hObject    handle to PSNR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double


% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in HeSo.
function HeSo_Callback(hObject, eventdata, handles)
% hObject    handle to HeSo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns HeSo contents as cell array
%        contents{get(hObject,'Value')} returns selected item from HeSo


% --- Executes during object creation, after setting all properties.
function HeSo_CreateFcn(hObject, eventdata, handles)
% hObject    handle to HeSo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
