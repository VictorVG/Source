-- V2.1, 09.03.2020 06:48:18 +0300
--
-- This function for calculating file checksums with support full or relative
-- UNC paths specified relative to the current panel directory, controlled
-- recursive processing of directories, partial correction of input errors
-- for UNC paths and checking the availability of the target object (the user
-- may not have access rights to it). Also user can break calculation if pressed
-- ESC key.
--
-- Input parameters:
--
-- hn  - is hash algorithm name, string
-- pth - target UNC path, string
-- fh  - output path mode, false - Windows (default), true - UNIX, boolean;
-- ft  - output record format code, false - GNU (default), true - BSD, boolean;
-- r   - recursion flag true - enable, false - disable (default), boolean;
-- sld - selection dir flag, boolean
--
-- Returned:
--
-- ret  - table included fields by order, handle:
--
-- DirSW      - Path to folder for save HashSumm, string;
-- FileCnt    - files processing count, integer;
-- ErrCnt     - files error count, integer;
-- RetCode    - Return code, integer, value is:
--               0 - Success, no errors, HashSumm is valid;
--               1 - Directory is empty;
--               2 - Recursion is disabled and the specified object was not found;
--               3 - File, access denied, HashSum valid for processed files;
--               4 - Directory, access denied, HashSum valid for processed files;
--               5 - Target not exist;
--               6 - User press break hotkey, HashSum is valid for processed files;
-- HashSumm  - calculated hashsum list, string
--
local function chex (pth,hn,fh,ft,r,sld)
local ds,ec,fc,fl,pt,rn,rt,s0 = "",0,0,4,"",0,"","";
pth = tostring(pth)
if tostring(r):find("true") then r = true else r = false end;
if tostring(ft):find("true") then ft = true else ft = false end;
 if #mf.fsplit(pth,1) == 0 then
  if pth:find("\\",1,1) then pth = pth:sub(2) elseif pth:find("/",1,1) then pth = pth:sub(2) end
  pt = APanel.Path.."\\"..pth
 else
  pt = pth
 end
 pt = mf.fsplit(pt,1)..mf.fsplit(pt,2)..mf.fsplit(pt,4)..mf.fsplit(pt,8)
 if mf.fexist(pth) then
  local f = mf.testfolder(pth)
  if f == 2 then
    local df = ""
    if r then fl = 6 else fl = 4 end;
    pt = pth
    if sld then df = win.GetFileInfo(pt).FileName.."\\" else df = "" end
     far.RecursiveSearch(""..pt.."","*>>D",function (itm,fp,hn,ft)
     rt = tostring(Plugin.SyncCall(ICId,"gethash",""..hn.."",""..fp.."",true));
     if rt == "userabort" then
      rn = 6
      return rn;
     else
      if rt ~= "false" and #rt ~= 0 then
       fc = fc + 1
       if fp:find("\\\\") then fp = fp:sub(#pt + 1) else fp = fp:sub(#pt + 2) end
       fp = df..fp
       if fh then fp = fp:gsub("\\","/") end
       if ft then s0 = s0..hn.." ("..fp..") = "..rt.."\n" else s0 = s0..rt.." *"..fp.."\n" end
      else
       if f == -1 then
        rn = math.max(rn,4)
        ec = ec + 1
       elseif #rt == 0 then
        rn = math.max(rn,3)
        ec = ec + 1
       end
      end
     end
    end,fl,hn,ft)
    ds = pth
  else
   local obj = win.GetFileInfo(pt)
   if not not obj then
    rt = tostring(Plugin.SyncCall(ICId,"gethash",""..hn.."",""..pt.."",true));
    if rt == "userabort" then
     rn = 6
     ec = 1
    else
     if rt ~= "false" and #rt ~= 0 then
      fc = 1
      if ft then s0 = hn.." ("..obj.FileName..") = "..rt else s0 = rt.." *"..obj.FileName end;
      ds = pt:sub(1,#pt - #obj.FileName - 1)
     elseif #rt == 0 then
      rn = 3
      ec = 1
     end
    end
   end
  end
 end
 local ret = {RetCode = rn, FileCnt = fc, ErrCnt = ec, HashSumm = mf.trim(s0), DirSW = ds }
 return ret
end;