object FormMain: TFormMain
  Left = 98
  Top = 121
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = #36855#23467' - RICOL'#21046#20316
  ClientHeight = 289
  ClientWidth = 460
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  Menu = MainMenu1
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyDown = FormKeyDown
  OnPaint = FormPaint
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 13
  object PaintBoxMain: TPaintBox
    Left = 0
    Top = 0
    Width = 460
    Height = 289
    Align = alClient
    Color = clWhite
    ParentColor = False
    OnPaint = PaintBoxMainPaint
  end
  object MainMenu1: TMainMenu
    object MenuGame: TMenuItem
      Caption = #28216#25103
      object MenuGameStart: TMenuItem
        Caption = #24320#22987
        OnClick = MenuGameStartClick
      end
      object MenuGameSeperator1: TMenuItem
        Caption = '-'
      end
      object MenuGameLow: TMenuItem
        Caption = #21021#32423
        OnClick = MenuGameLowClick
      end
      object MenuGameMedium: TMenuItem
        Caption = #20013#32423
        OnClick = MenuGameMediumClick
      end
      object MenuGameHigh: TMenuItem
        Caption = #39640#32423
        OnClick = MenuGameHighClick
      end
      object MenuGameSpecial: TMenuItem
        Caption = #29305#39640
        OnClick = MenuGameSpecialClick
      end
      object MenuGameDefine: TMenuItem
        Caption = #33258#23450#20041
        OnClick = MenuGameDefineClick
      end
      object MenuGameSeperator2: TMenuItem
        Caption = '-'
      end
      object MenuGameExit: TMenuItem
        Caption = #36864#20986
        OnClick = MenuGameExitClick
      end
    end
    object MenuPath: TMenuItem
      Caption = #36335#24452
      object MenuSearchPath: TMenuItem
        Caption = #25628#32034
        object MenuSearchUp: TMenuItem
          Caption = #21521#19978#36870#26102#38024#20248#20808
          OnClick = MenuSearchUpClick
        end
        object MenuSearchRight: TMenuItem
          Caption = #21521#21491#36870#26102#38024#20248#20808
          OnClick = MenuSearchRightClick
        end
        object MenuSearchDown: TMenuItem
          Caption = #21521#19979#36870#26102#38024#20248#20808
          OnClick = MenuSearchDownClick
        end
        object MenuSearchLeft: TMenuItem
          Caption = #21521#24038#36870#26102#38024#20248#20808
          OnClick = MenuSearchLeftClick
        end
        object MenuSearchUpOther: TMenuItem
          Caption = #21521#19978#39034#26102#38024#20248#20808
          OnClick = MenuSearchUpOtherClick
        end
        object MenuSearchRightOther: TMenuItem
          Caption = #21521#21491#39034#26102#38024#20248#20808
          OnClick = MenuSearchRightOtherClick
        end
        object MenuSearchDownOther: TMenuItem
          Caption = #21521#19979#39034#26102#38024#20248#20808
          OnClick = MenuSearchDownOtherClick
        end
        object MenuSearchLeftOther: TMenuItem
          Caption = #21521#24038#39034#26102#38024#20248#20808
          OnClick = MenuSearchLeftOtherClick
        end
      end
      object MenuMazeRePaint: TMenuItem
        Caption = #21047#26032
        OnClick = MenuMazeRePaintClick
      end
    end
    object MenuHelp: TMenuItem
      Caption = #24110#21161
      object MenuHelpAbout: TMenuItem
        Caption = #20851#20110
        OnClick = MenuHelpAboutClick
      end
    end
  end
end
