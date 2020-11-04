Macro{
  id="696B1377-27A6-421B-98C4-258FB6847DBC";
  area="Shell";
  key="CtrlPgDn";
  description="Prevent out";
  priority=60;
  condition=function() return APanel.Root end;
  action=function() Panel.SetPosIdx(0,0) end;
}
