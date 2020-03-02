-- Test parameters
-- algorithm - CRC32; MD5; SHA1; SHA-256; SHA-512; SHA3-512; Whirlpool
-- format    - BSD or GNU
-- recursion - YES or NO
-- pth - any UNC or relative path
--
local algoritm, format, recursion = "SHA-256", "BSD", "YES";
--
-- local pth = APanel.Current;
-- local pth = APanel.Path.."\\1";
-- local pth = "//SERVER/share/";
local pth = APanel.Path;
-- local pth = "\\1";
-- local pth = "/1";
-- local pth = "\\\\SERVER\\share\\"
-- local pth = "\\\\SERVER\\share\\winrar-x64-590b3ru.exe"
--
-- This function for calculating file checksums with support full or relative
-- UNC paths specified relative to the current panel directory, controlled
-- recursive processing of directories, partial correction of input errors
-- for UNC paths and checking the availability of the target object (the user
-- may not have access rights to it). Also user can break calculation if pressed
-- ESC key. Symlink's today is not supported.
--
-- Input parameters:
--
-- hn  - is hash algorithm name, string
-- pth - target UNC path, string
-- ft  - output record format code, false - GNU (default), true - BSD, boolean;
-- r   - recursion flag true - enable, false - disable (default), boolean;
--
-- Returned:
-- ret  - table included fields by order:
--
-- DirSW      - Path to folder for save HashSumm, string;
-- FileAllCnt - files all count, integer;
-- FileErrCnt - files error count, integer;
-- RetCode    - Error code, integer, value is:
--               0 - Success, no errors, HashSumm is valid;
--               1 - Target not exist;
--               2 - Recursion is disabled then target can't found;
--               3 - Access deinned, HashSum is valid for current FileAllCnt;
--               4 - Dir is empty;
--               5 - File size = 0, HashSum is valid for current FileAllCnt;
--               6 - User press break hotkey, HashSum is valid for current FileAllCnt;
-- HashSumm  - calculated hashsum list, string
--
local ICId = "E186306E-3B0D-48C1-9668-ED7CF64C0E65";
local function chex (pth,hn,ft,r)
local ds,ec,fc,fe,fl,fz,pt,rt,s0 = "",0,0,0,4,0,"","","";
local function diag (ipt,irt)
local sz = tostring(win.GetFileInfo(ipt).FileSize)
 if sz == "0" then
  ec = math.max(ec,5)
  fz = fz + 1
 elseif sz == "nil" then
  ec = math.max(ec,3)
  fe = fe + 1
 end
end;
 r = tostring(r)
 pth = tostring(pth)
 if r:find("true") then r = true else r = false end;
 ft = tostring(ft)
 if ft:find("true") then ft = true else ft = false end;
 if #mf.fsplit(pth,1) == 0 then
  if not not pth:find("\\",1) then pth = pth:sub(2) elseif not not pth:find("/",1) then pth = pth:sub(2) end
  pt = APanel.Path.."\\"..pth
 else
  pt = pth
 end
 if mf.fexist(pth) then
  local f = mf.testfolder(pt)
  if f == 1 then
   ec = 4
   fe = 1
  elseif f == 2 then
   if r then fl = 6 else fl = 4 end;
   far.RecursiveSearch(pt,"*>>D",function (itm,fp,hn,ft)
     rt = tostring(Plugin.SyncCall(ICId,"gethash",""..hn.."",""..fp.."",true));
     if rt == "userabort" then
      ec = 6
      return ec;
     elseif rt == "false" then
      diag(pt,rt)
     else
      local fn
      fc = fc + 1
      if not not fp:find(pt) then fn = fp:sub(#pt + 1) else fn = fp end
      if fn:find("\\",1,1) then fn = fn:sub(2) end
      if ft then s0 = s0..hn.." ("..fn..") = "..rt.."\n" else s0 = s0..rt.." *"..fn.."\n" end
     end;
   end,fl,hn,ft)
   ds = pth
  elseif f == -2 then
   local obj = win.GetFileInfo(pt)
    rt = tostring(Plugin.SyncCall(ICId,"gethash",""..hn.."",""..pth.."",true));
    if rt == "userabort" then
     ec = 6
    elseif rt == "false" then
     diag(pt,rt)
    else
     fc = 1
     if ft then s0 = hn.." ("..obj.FileName..") = "..rt else s0 = rt.." *"..obj.FileName end;
     ds = mf.trim(mf.fsplit(pth,1).."\\"..mf.fsplit(pth,2))
    end
   else
    ec = 5
    fz = 1
   end
  else
   if r then
    ec = 1
    fe = 1
   else
    ec = 2
    fe = 1
   end
  end
 local ret = {RetCode = ec, FileAllCnt = fc, FileErrCnt = fe, FileEmpCnt = fz, HashSumm = mf.trim(s0), DirSW = ds }
 return ret
end;
if format == "BSD" then ft0 = true else ft0 = false end
if recursion == "YES" then r0 = true else r0 = false end
local h1 = chex(""..pth.."","".. algoritm.."",ft0,r0)
far.Show(h1.HashSumm.."\n\nStatistics\n\n".."Files       : "..h1.FileAllCnt.."\nEmpty files : "..h1.FileEmpCnt.."\nError       : "..h1.FileErrCnt.."\nReturn code : "..h1.RetCode)