local function chex(hn,pth,ft,r)
local ICId = "E186306E-3B0D-48C1-9668-ED7CF64C0E65";

-- The function for calculating file checksums with support full or relative
-- UNC paths specified relative to the current panel directory, controlled
-- recursive processing of directories, partial correction of input errors
-- for UNC paths and checking the availability of the target object (the user
-- may not have access rights to it).
--
-- User can break calculation if pressed ESC key then returned ErrCode = 4.
--
-- Input parameters:
--
-- hn  - is hash algorithm name, string
-- pth - target UNC path, string
-- ft  - output record format code, false - GNU (default), true - BSD, boolean;
-- r   - recursion flag true - enable, false - disable (default), boolean;
--
-- Returned table included fields by order:
--
-- ErrCode    - Error code, integer, value is:
--               0 - Success, no errors, HashSumm is valid;
--               1 - Empty folder, recursion is disabled or no files found, HashSumm
--                   is empty and ObjPath is UNC path;
--               2 - Target not exist, HashSumm is invalid and ObjPath is UNC path;
--               3 - File Access Denied, FileErrCnt greater 0, HashSumm exclude this files;
--               4 - User press break hotkey, FileSucCnt is valid, DirCnt is wrong,
--                   HashSumm last string is "Cancel";
-- HashSumm   - calculated hash sum, string, substring separator is "\n";
-- ObjPath    - UNC path to object, string;
-- DirCnt     - scaned directories count, integer;
-- FileAllCnt - files all count, integer;
-- FileSucCnt - files success count, integer;
-- FileErrCnt - files error count, integer;

   local r0,sum0,s0,f0,d0,p,pnt,dc,ec,err,fc,fa,ft0 = false,"","","","","","",0,0,0,0,0,false;
   r = tostring(r)
   if r:find("true") then r0 = true elseif r:find("false") then r0 = false else r0 = false end;
   if pth:find("\\$") then p = pth:sub(0,-2) elseif pth:find("/$") then
    p = pth:sub(0,-2) else p = pth end;
   ft = tostring(ft)
    if ft:find("true") then ft0 = true elseif ft:find("false") then ft0 = false end;
   if mf.fexist(p) then
    if #mf.fsplit(p,1) == 0 then p = far.ConvertPath(p); pnt = win.GetFileInfo(p).FileName.."\\"; else pnt = "" end
    local dr,da,dn = far.GetDirList(p),{},{};
    if #dr == 0 then
     f0 = win.GetFileInfo(p).FileName
     d0 = p:sub(0, - #f0 - 2);
     fc = 1
     dc = 0
     sum0 = tostring(Plugin.SyncCall(ICId,"gethash",""..hn.."",""..p.."",true));
     if sum0:find("nil") then
      ec = 1
      err = 3
     elseif sum0:find("userabort") then
      ec = 1
      err = 4
      sum0 = "Cancel"
     else
      if ft0 then s0 = hn.." ("..f0..") = "..sum0 else s0 = sum0.." *"..f0; end;
      fa = 1
     end;
    else
     local sem = false;
     d0 = p
     dc = #dr;
     for j = 1,#dr do
      da[j] = dr[j].FileAttributes
      dn[j] = dr[j].FileName
      if not da[j]:find("d") then
       f0 = dn[j]:sub(#p + 2)
       if r0 then sem = true else if not dn[j]:find("\\",#p + 2) then sem = true else sem = false end end;
       if sem then
        fa = fa + 1
         sum0 = tostring(Plugin.SyncCall(ICId,"gethash",""..hn.."",""..dn[j].."",true));
        if sum0 == "userabort" then
         ec = ec + 1
         err = math.max(err,4)
         sum0 = "Cancel"
         break
        elseif sum0 == "nil" then
         ec = ec + 1
         err = math.max(err,3)
        else
         fc = fc + 1
         if ft0 then s0 = s0..hn.." ("..pnt..f0..") = "..sum0.."\n" else s0 = s0..sum0.." *"..pnt..f0.."\n" end;
        end
       end
      end;
     end
      if r0 then dc = dc - fa else dc = 0 end
    end
     if #s0 == 0 and r0 then err = math.max(err,1) end
   else
     err = 2
     s0 = ""
     d0 = p
   end
   local ret = { ErrCode = err, HashSumm = mf.trim(s0), ObjPath = d0, DirCnt = dc, FileAllCnt = fa, FileSucCnt = fc, FileErrCnt = ec };
   return ret;
 end;