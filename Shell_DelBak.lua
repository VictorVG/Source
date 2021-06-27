-- VictorVG, VikSoft.Ru©, Russia, Moscow. All Right Reserved. 1996 - 2021
-- v1.0 Initial release
-- 08.07.2021 18:55:41 +0300
-- v1.1 Rewrite clear(), small refactoring
-- 14.07.2021 03:21:58 +0300

local Msk1="/.+\\.(bak\\d*)$/i";
local Msk2="/.+\\.(log|tmp|temp|(~\\w?|\\s?)tmp(~|\\s?)\\w?log|dir|xml|c|h|(c|h)pp|txt|(h|i)\\.(\\w?|\\s?|(c|h)pp|c|h|rc))$/i";
local function clear(Mask)
   local Q,T,p = "\nDo you like delete all (%d units) files?","Delete unused files";
   Panel.Select(0,1,3,Mask)
   if APanel.Selected and msgbox(T,Q:format(APanel.SelCount),0x20000)==1 then
    p =  Panel.SetPosIdx(0,0)
    for j=1,APanel.SelCount do
      Panel.SetPosIdx(0,j,1)
      win.DeleteFile(APanel.Current)
    end
     Panel.SetPosIdx(0,p)
    end
 end;

Macro{
  id="3CCFF979-B268-4983-A00E-C3003086807A";
  area="Shell";
  key="AltB";
  description="Delete backup files";
  priority=60;
  condition=function() return not APanel.Empty end;
  action=function()
   clear(Msk1)
   panel.UpdatePanel(nil,1,false)
  end;
}

Macro{
  id="E446E62C-1BC3-4CDF-8E54-1A5C1FF32663";
  area="Shell";
  key="AltT";
  description="Delete temporary files";
  priority=60;
  condition=function() return not APanel.Empty end;
  action=function()
   clear(Msk2)
   panel.UpdatePanel(nil,1,false)
  end;
}
