{
    Copyright (C) 2010,2013 João Marcelo S. Vaz

    This file is part of Scriptoria, a program that helps you to transcribe
    scanned old documents, with an interface that combines a text editor
    and an image viewer.

    Scriptoria is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    Scriptoria is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.

}

unit uDialogs;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Utils;

type

  { TCustomDialog }

  TCustomDialog = class
  private
    FHeight: integer;
    FWidth: integer;
    FOnCanClose: TCloseQueryEvent;
    FOnClose : TNotifyEvent;
    FOnShow: TNotifyEvent;
    FTitle : string;
    FHelpContext: THelpContext;
    procedure SetHeight(const AValue: integer);
    procedure SetWidth(const AValue: integer);
    function DoExecute : boolean; virtual;
    procedure DoShow; virtual;
    procedure DoCanClose(var CanClose: Boolean); virtual;
    procedure DoClose; virtual;
  protected
    Dialog: TForm;
  protected // to override
    function DefaultTitle: string; virtual;
    function CreateDialog: TForm; virtual; abstract;
    procedure PutPropertiesOnDialog; virtual;
    procedure GetPropertiesFromDialog; virtual;
  public
    constructor Create; virtual;
    destructor Destroy; override;
    function Execute: boolean; virtual;
  published
    property OnClose: TNotifyEvent read FOnClose write FOnClose;
    property OnCanClose: TCloseQueryEvent read FOnCanClose write FOnCanClose;
    property OnShow: TNotifyEvent read FOnShow write FOnShow;
    property HelpContext: THelpContext read FHelpContext write FHelpContext default 0;
    property Width: integer read FWidth write SetWidth default 0;
    property Height: integer read FHeight write SetHeight default 0;
    property Title: string read FTitle write FTitle;
  end;

  { TAboutBoxDialog }

  TAboutBoxDialog = class(TCustomDialog)
  private
    fAbout: TStrings;
    fAboutTabCaption: string;
    fCopyright: string;
    fCopyrightYear: string;
    fCredits: TStrings;
    fCreditsTabCaption: string;
    fHistory: TStrings;
    fHistoryTabCaption: string;
    fHomePage: string;
    fInfo: TStrings;
    fInfoTabCaption: string;
    fLicense: TStrings;
    fLicenseTabCaption: string;
    fProgramTitle: string;
    fProgramVersion: string;
    fShowCreditsTab: boolean;
    fShowHistoryTab: Boolean;
    fShowLicenseTab: Boolean;
    procedure SetAbout(const AValue: TStrings);
    procedure SetAboutTabCaption(const AValue: string);
    procedure SetCopyright(const AValue: string);
    procedure SetCredits(const AValue: TStrings);
    procedure SetCreditsTabCaption(const AValue: string);
    procedure SetHistory(const AValue: TStrings);
    procedure SetHistoryTabCaption(const AValue: string);
    procedure SetHomePage(const AValue: string);
    procedure SetInfo(const AValue: TStrings);
    procedure SetInfoTabCaption(const AValue: string);
    procedure SetLicense(const AValue: TStrings);
    procedure SetLicenseTabCaption(const AValue: string);
    procedure SetProgramTitle(const AValue: string);
    procedure SetProgramVersion(const AValue: string);
    procedure SetShowCreditsTab(const AValue: boolean);
    procedure SetShowHistoryTab(const AValue: Boolean);
    procedure SetShowLicenseTab(const AValue: Boolean);
  protected // override
    function DefaultTitle: string; override;
    function CreateDialog: TForm; override;
    procedure PutPropertiesOnDialog; override;
  public
    constructor Create; override;
    destructor Destroy; override;
  published
    property ProgramTitle: string read fProgramTitle write SetProgramTitle;
    property ProgramVersion: string read fProgramVersion write SetProgramVersion;
    property HomePage: string read fHomePage write SetHomePage;
    property Copyright: string read fCopyright write SetCopyright;
    property AboutTabCaption: string read fAboutTabCaption write SetAboutTabCaption;
    property CreditsTabCaption: string read fCreditsTabCaption write SetCreditsTabCaption;
    property HistoryTabCaption: string read fHistoryTabCaption write SetHistoryTabCaption;
    property LicenseTabCaption: string read fLicenseTabCaption write SetLicenseTabCaption;
    property InfoTabCaption: string read fInfoTabCaption write SetInfoTabCaption;
    property ShowCreditsTab: Boolean read fShowCreditsTab write SetShowCreditsTab;
    property ShowHistoryTab: Boolean read fShowHistoryTab write SetShowHistoryTab;
    property ShowLicenseTab: Boolean read fShowLicenseTab write SetShowLicenseTab;
    property About: TStrings read fAbout write SetAbout;
    property Credits: TStrings read fCredits write SetCredits;
    property History: TStrings read fHistory write SetHistory;
    property License: TStrings read fLicense write SetLicense;
    property Info: TStrings read fInfo write SetInfo;
  end;

  { TImageEnhancerDialog }

  TImageEnhancerDialog = class(TCustomDialog)
    private
      fPicture: TPicture;
      procedure SetPicture(AValue: TPicture);
    protected
      function GetEnhancer: TCustomImageEnhancer; virtual; abstract;
      procedure PutPropertiesOnDialog; override;
    public
      constructor Create; override;
      destructor Destroy; override;
    published
      property Enhancer: TCustomImageEnhancer read GetEnhancer;
      property Picture: TPicture read fPicture write SetPicture;
  end;

  { TBrightnessContrastDialog }

  TBrightnessContrastDialog = class(TImageEnhancerDialog)
    private
      fBrightness: Integer;
      fContrast: Integer;
    protected // override
      function DefaultTitle: string; override;
      function CreateDialog: TForm; override;
      procedure GetPropertiesFromDialog; override;
      procedure PutPropertiesOnDialog; override;
      function GetEnhancer: TCustomImageEnhancer; override;
    public
      constructor Create; override;
    published
      property Brightness: Integer read fBrightness;
      property Contrast: Integer read fContrast;
  end;

  { TColorBalanceDialog }

  TColorBalanceDialog = class(TImageEnhancerDialog)
    private
      fBlue: Integer;
      fGreen: Integer;
      fRed: Integer;
    protected // override
      function DefaultTitle: string; override;
      function CreateDialog: TForm; override;
      procedure GetPropertiesFromDialog; override;
      procedure PutPropertiesOnDialog; override;
      function GetEnhancer: TCustomImageEnhancer; override;
    public
      constructor Create; override;
    published
      property Red: Integer read fRed;
      property Green: Integer read fGreen;
      property Blue: Integer read fBlue;
  end;

implementation

uses uStrings, uAbout, EnhanceImageFrm;

{ TCustomDialog }

procedure TCustomDialog.SetHeight(const AValue: integer);
begin
  if FHeight=AValue then exit;
  FHeight:=AValue;
end;

procedure TCustomDialog.SetWidth(const AValue: integer);
begin
  if FWidth=AValue then exit;
  FWidth:=AValue;
end;

function TCustomDialog.DefaultTitle: string;
begin
  Result:= '';
end;

procedure TCustomDialog.PutPropertiesOnDialog;
begin
  Dialog.Caption:= Title;
  if Height <> 0 then
    Dialog.Height:= Height;
  if Width <> 0 then
    Dialog.Width:= Width;
end;

procedure TCustomDialog.GetPropertiesFromDialog;
begin
  //to be overriden if necessary
end;

procedure TCustomDialog.DoShow;
begin
  if Assigned(FOnShow) then
    FOnShow(Self);
end;

procedure TCustomDialog.DoCanClose(var CanClose: Boolean);
begin
  if Assigned(FOnCanClose) then
    OnCanClose(Self, CanClose);
end;

procedure TCustomDialog.DoClose;
begin
  if Assigned(FOnClose) then
    FOnClose(Self);
end;

function TCustomDialog.DoExecute: boolean;
var
  CanClose: boolean;
  UserChoice: integer;
begin
  if not Assigned(Dialog) then exit;
  DoShow;
  PutPropertiesOnDialog;
  UserChoice:= Dialog.ShowModal;
  if (UserChoice <> mrNone) then
    begin
      CanClose:= True;
      DoCanClose(CanClose);
      if not CanClose then
        UserChoice:= mrNone;
    end;
  Result:= (UserChoice = mrOk);
  GetPropertiesFromDialog;
  DoClose;
end;

constructor TCustomDialog.Create;
begin
  inherited Create;
  FTitle := DefaultTitle;
  Dialog:= CreateDialog;
end;

destructor TCustomDialog.Destroy;
begin
  Dialog.Release;
  inherited Destroy;
end;

function TCustomDialog.Execute: boolean;
begin
  Result:= DoExecute;
end;


{ TAboutBoxDialog }

procedure TAboutBoxDialog.SetProgramTitle(const AValue: string);
begin
  if fProgramTitle=AValue then exit;
  fProgramTitle:=AValue;
end;

procedure TAboutBoxDialog.SetHomePage(const AValue: string);
begin
  if fHomePage=AValue then exit;
  fHomePage:=AValue;
end;

procedure TAboutBoxDialog.SetInfo(const AValue: TStrings);
begin
  if Assigned(AValue) then
    fInfo.Assign(AValue);
end;

procedure TAboutBoxDialog.SetInfoTabCaption(const AValue: string);
begin
  if fInfoTabCaption=AValue then exit;
  fInfoTabCaption:=AValue;
end;

procedure TAboutBoxDialog.SetLicense(const AValue: TStrings);
begin
  if Assigned(AValue) then
    fLicense.Assign(AValue);
end;

procedure TAboutBoxDialog.SetLicenseTabCaption(const AValue: string);
begin
  if fLicenseTabCaption=AValue then exit;
  fLicenseTabCaption:=AValue;
end;


procedure TAboutBoxDialog.SetCredits(const AValue: TStrings);
begin
  if Assigned(AValue) then
    fCredits.Assign(AValue);
end;

procedure TAboutBoxDialog.SetCreditsTabCaption(const AValue: string);
begin
  if fCreditsTabCaption=AValue then exit;
  fCreditsTabCaption:=AValue;
end;

procedure TAboutBoxDialog.SetHistory(const AValue: TStrings);
begin
  if Assigned(AValue) then
    fHistory.Assign(AValue);
end;

procedure TAboutBoxDialog.SetHistoryTabCaption(const AValue: string);
begin
  if fHistoryTabCaption=AValue then exit;
  fHistoryTabCaption:=AValue;
end;

procedure TAboutBoxDialog.SetAboutTabCaption(const AValue: string);
begin
  if fAboutTabCaption=AValue then exit;
  fAboutTabCaption:=AValue;
end;

procedure TAboutBoxDialog.SetCopyright(const AValue: string);
begin
  if fCopyright=AValue then exit;
  fCopyright:=AValue;
end;

procedure TAboutBoxDialog.SetAbout(const AValue: TStrings);
begin
  if Assigned(AValue) then
    fAbout.Assign(AValue);
end;

procedure TAboutBoxDialog.SetProgramVersion(const AValue: string);
begin
  if fProgramVersion=AValue then exit;
  fProgramVersion:=AValue;
end;

procedure TAboutBoxDialog.SetShowCreditsTab(const AValue: boolean);
begin
  if fShowCreditsTab=AValue then exit;
  fShowCreditsTab:=AValue;
end;

procedure TAboutBoxDialog.SetShowHistoryTab(const AValue: Boolean);
begin
  if fShowHistoryTab=AValue then exit;
  fShowHistoryTab:=AValue;
end;

procedure TAboutBoxDialog.SetShowLicenseTab(const AValue: Boolean);
begin
  if fShowLicenseTab=AValue then exit;
  fShowLicenseTab:=AValue;
end;

function TAboutBoxDialog.DefaultTitle: string;
begin
  Result:= Format(sAboutBoxCaption, [Application.Title]);
end;

function TAboutBoxDialog.CreateDialog: TForm;
begin
  Result:= TAboutBox.Create(nil);
end;


procedure TAboutBoxDialog.PutPropertiesOnDialog;
begin
  inherited;
  with (Dialog as TAboutBox) do
    begin
      lbProgramTitle.Caption:= ProgramTitle;
      lbProgramVersion.Caption:= ProgramVersion;
      lbCopyright.Caption:= Copyright;
      lbHomePage.Caption:= HomePage;
      tsAbout.Caption:= AboutTabCaption;
      tsCredits.Caption:= CreditsTabCaption;
      tsHistory.Caption:= HistoryTabCaption;
      tsLicense.Caption:= LicenseTabCaption;
      tsInfo.Caption:= InfoTabCaption;
      mmAbout.Lines.Assign(fAbout);
      mmCredits.Lines.Assign(fCredits);
      mmHistory.Lines.Assign(fHistory);
      mmLicense.Lines.Assign(fLicense);
      mmInfo.Lines.Assign(fInfo);
      tsCredits.Visible:= ShowCreditsTab;
      tsHistory.Visible:= ShowHistoryTab;
      tsLicense.Visible:= ShowLicenseTab;
    end;
end;

constructor TAboutBoxDialog.Create;
begin
  inherited Create;
  fAbout:= TStringList.Create;
  fCredits:= TStringList.Create;
  fHistory:= TStringList.Create;
  fLicense:= TStringList.Create;
  fInfo:= TStringList.Create;
end;

destructor TAboutBoxDialog.Destroy;
begin
  fAbout.Free;
  fCredits.Free;
  fHistory.Free;
  fLicense.Free;
  fInfo.Free;
  inherited Destroy;
end;

{ TImageEnhancerDialog }

procedure TImageEnhancerDialog.SetPicture(AValue: TPicture);
begin
  if fPicture=AValue then Exit;
  fPicture.Assign(AValue);
end;

procedure TImageEnhancerDialog.PutPropertiesOnDialog;
begin
  inherited;
  with (Dialog as TEnhanceImageForm) do
    begin
      SetEnhancer(GetEnhancer);
      SetImage(Picture);
    end;
end;

constructor TImageEnhancerDialog.Create;
begin
  inherited Create;
  fPicture:= TPicture.Create;
end;

destructor TImageEnhancerDialog.Destroy;
begin
  fPicture.Free;
  inherited Destroy;
end;

{ TBrightnessContrastDialog }

function TBrightnessContrastDialog.GetEnhancer: TCustomImageEnhancer;
begin
  Result:= TBrightnessContrastEnhancer.Create;
  try
    TBrightnessContrastEnhancer(Result).Contrast:= Contrast;
    TBrightnessContrastEnhancer(Result).Brightness:= Brightness;
  except
    Result:= nil;
  end;
end;

function TBrightnessContrastDialog.DefaultTitle: string;
begin
  Result:= sBrightnessContrastCaption;
end;

function TBrightnessContrastDialog.CreateDialog: TForm;
begin
  Result:= TEnhanceImageForm.Create(nil);
end;

procedure TBrightnessContrastDialog.GetPropertiesFromDialog;
begin
  inherited;
  with (Dialog as TEnhanceImageForm) do
    begin
      fBrightness:= GetBrightness;
      fContrast:= GetContrast;
    end;
end;

procedure TBrightnessContrastDialog.PutPropertiesOnDialog;
begin
  inherited;
  with (Dialog as TEnhanceImageForm) do
    begin
      SetDialogAsBrightnessAndContrast;
      SetBrightnessAndContrast(Brightness,Contrast);
    end;
end;

constructor TBrightnessContrastDialog.Create;
begin
  inherited Create;
  fBrightness:= 0;
  fContrast:= 0;
end;

{ TColorBalanceDialog }

function TColorBalanceDialog.GetEnhancer: TCustomImageEnhancer;
begin
   Result:= TColorBalanceEnhancer.Create;
  try
    TColorBalanceEnhancer(Result).Red:= Red;
    TColorBalanceEnhancer(Result).Green:= Green;
    TColorBalanceEnhancer(Result).Blue:= Blue;
  except
    Result:= nil;
  end;
end;

function TColorBalanceDialog.DefaultTitle: string;
begin
    Result:= sColorBalanceCaption;
end;

function TColorBalanceDialog.CreateDialog: TForm;
begin
  Result:= TEnhanceImageForm.Create(nil);
end;

procedure TColorBalanceDialog.GetPropertiesFromDialog;
begin
  inherited;
  with (Dialog as TEnhanceImageForm) do
    begin
      fRed:= GetRed;
      fGreen:= GetGreen;
      fBlue:= GetBlue;
    end;
end;

procedure TColorBalanceDialog.PutPropertiesOnDialog;
begin
  inherited;
  with (Dialog as TEnhanceImageForm) do
    begin
      SetDialogAsRedGreenBlue;
      SetRedGreenBlue(Red,Green,Blue);
    end;
end;

constructor TColorBalanceDialog.Create;
begin
  inherited Create;
  fRed:= 0;
  fGreen:= 0;
  fBlue:= 0;
end;


end.
