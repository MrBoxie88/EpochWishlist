-------------------------------------------------------------------------------
-- EpochWishlist  v2.0.0
-- Multi-list gear wishlist for Project Epoch (vanilla content, 3.3.5 client)
-- Zero external libraries — no Ace3, LibBabble, DewdropLib, or LibStub.
-------------------------------------------------------------------------------

local ADDON_NAME  = "EpochWishlist"
local VERSION     = "2.0.0"
local COMM_PREFIX = "EpochWL"   -- addon message prefix (max 16 chars)

-- ============================================================
--  SavedVariables
--  Global: EpochWishlistDB (declared in .toc)
--  Layout: { chars = { ["Name-Realm"] = { lists, activeList,
--                                         windowPos, windowSize } } }
-- ============================================================
local db       -- shortcut to current character's data table
local charKey  -- "Name-Realm"

local function InitDB()
    if type(EpochWishlistDB) ~= "table" then EpochWishlistDB = {} end
    if type(EpochWishlistDB.chars) ~= "table" then EpochWishlistDB.chars = {} end

    charKey = UnitName("player") .. "-" .. GetRealmName()

    if type(EpochWishlistDB.chars[charKey]) ~= "table" then
        EpochWishlistDB.chars[charKey] = {}
    end
    local c = EpochWishlistDB.chars[charKey]

    if c.lists      == nil then c.lists      = {}                              end
    if c.activeList == nil then c.activeList = nil                             end
    if c.windowPos  == nil then c.windowPos  = {point="CENTER", x=0, y=0}     end
    if c.windowSize == nil then c.windowSize = {w=440, h=540}                 end

    db = c
end

-- ============================================================
--  Utility
-- ============================================================
local function Trim(s) return (s or ""):match("^%s*(.-)%s*$") end

local function Print(msg)
    DEFAULT_CHAT_FRAME:AddMessage("|cffFFD700[EW]|r " .. (msg or ""))
end

local QUALITY_COLOR = {
    [0]="|cff9d9d9d", [1]="|cffffffff", [2]="|cff1eff00",
    [3]="|cff0070dd",  [4]="|cffa335ee", [5]="|cffff8000",
}
local function QualityColor(q) return QUALITY_COLOR[q] or QUALITY_COLOR[1] end

-- ============================================================
--  Data layer
-- ============================================================
local function GetListNames()
    local t = {}
    for k in pairs(db.lists) do t[#t+1] = k end
    table.sort(t)
    return t
end

local function CreateList(name)
    if db.lists[name] then return false, "A list with that name already exists." end
    db.lists[name] = {}
    if not db.activeList then db.activeList = name end
    return true
end

local function DeleteList(name)
    db.lists[name] = nil
    if db.activeList == name then db.activeList = GetListNames()[1] end
end

local function RenameList(old, new)
    if not db.lists[old] then return false, "List not found."     end
    if db.lists[new]     then return false, "Name already taken." end
    db.lists[new] = db.lists[old]
    db.lists[old] = nil
    if db.activeList == old then db.activeList = new end
    return true
end

local function AddItem(listName, itemId, itemLink, note)
    if not db.lists[listName] then return false, "List not found." end
    for _, e in ipairs(db.lists[listName]) do
        if e.itemId == itemId then return false, "Item already in this list." end
    end
    table.insert(db.lists[listName], {itemId=itemId, itemLink=itemLink, note=note or ""})
    return true
end

local function RemoveItem(listName, itemId)
    local list = db.lists[listName]
    if not list then return end
    for i, e in ipairs(list) do
        if e.itemId == itemId then
            table.remove(list, i)
            return
        end
    end
end

local function MoveItem(listName, fromIdx, toIdx)
    local list = db.lists[listName]
    if not list then return end
    toIdx = math.max(1, math.min(toIdx, #list))
    if fromIdx == toIdx then return end
    table.insert(list, toIdx, table.remove(list, fromIdx))
end

-- ============================================================
--  Export / Import
--  Format:  [ListName]\n<itemId>|<note>\n...
--  Pipe chars in notes are percent-encoded to avoid collisions.
-- ============================================================
local function EncNote(s) return (s or ""):gsub("|","%%7C") end
local function DecNote(s) return (s or ""):gsub("%%7C","|") end

local function ExportList(listName)
    local list = db.lists[listName]
    if not list then return nil, "List not found." end
    local lines = {"[" .. listName .. "]"}
    for _, e in ipairs(list) do
        lines[#lines+1] = tostring(e.itemId) .. "|" .. EncNote(e.note)
    end
    return table.concat(lines, "\n")
end

local RefreshListDropdown, RefreshItemRows, RefreshCellChecks   -- forward-declared; set inside CreateMainFrame

-- Hidden tooltip used to force the client to request uncached item data.
-- SetHyperlink on a GameTooltip is the most reliable way on 3.3.5 to
-- trigger a server fetch for custom/unknown item IDs.
local EWFetchTooltip = CreateFrame("GameTooltip", "EWFetchTooltip", UIParent, "GameTooltipTemplate")
EWFetchTooltip:SetOwner(UIParent, "ANCHOR_NONE")
EWFetchTooltip:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", 0, 0)  -- off-screen

local fetchQueue   = {}   -- {itemId, callback} queue
local fetchPending = {}   -- itemId -> true, currently waiting
local fetchFrame   = CreateFrame("Frame")
local FETCH_INTERVAL = 0.1  -- seconds between fetches to avoid flooding

local function FetchItem(itemId, callback)
    if GetItemInfo(itemId) then
        if callback then callback(itemId) end
        return
    end
    if fetchPending[itemId] then return end
    fetchPending[itemId] = true
    fetchQueue[#fetchQueue+1] = { id=itemId, cb=callback }
end

fetchFrame:RegisterEvent("GET_ITEM_INFO_RECEIVED")
fetchFrame:SetScript("OnEvent", function(_, _, id)
    if not fetchPending[id] then return end
    fetchPending[id] = nil
    local cbs = {}
    for i = #fetchQueue, 1, -1 do
        if fetchQueue[i].id == id then
            cbs[#cbs+1] = fetchQueue[i].cb
            table.remove(fetchQueue, i)
        end
    end
    -- Use OnUpdate to defer by one frame (C_Timer not reliable at all call sites)
    local deferFrame = CreateFrame("Frame")
    deferFrame:SetScript("OnUpdate", function(self)
        self:SetScript("OnUpdate", nil)
        for _, cb in ipairs(cbs) do
            if cb then cb(id) end
        end
    end)
end)

-- Ticker: pump the queue via OnUpdate accumulator (avoids C_Timer at load time)
local fetchAccum = 0
fetchFrame:SetScript("OnUpdate", function(self, elapsed)
    fetchAccum = fetchAccum + elapsed
    if fetchAccum < FETCH_INTERVAL then return end
    fetchAccum = 0
    for _, entry in ipairs(fetchQueue) do
        if fetchPending[entry.id] and not GetItemInfo(entry.id) then
            pcall(function()
                EWFetchTooltip:SetHyperlink("item:"..entry.id)
            end)
        end
    end
end)

local function QueueLinkRefresh(listName)
    -- Listens for GET_ITEM_INFO_RECEIVED and backfills placeholder links.
    local f = CreateFrame("Frame")
    local deadline = GetTime() + 60
    f:RegisterEvent("GET_ITEM_INFO_RECEIVED")
    f:SetScript("OnEvent", function(self, _, id)
        if GetTime() > deadline then self:UnregisterAllEvents(); return end
        local list = db.lists[listName]
        if not list then self:UnregisterAllEvents(); return end
        local _, link = GetItemInfo(id)
        if link then
            for _, e in ipairs(list) do
                if e.itemId == id and (e.itemLink or ""):find("Item #") then
                    e.itemLink = link
                end
            end
        end
    end)
end

local function ImportList(text, overwrite)
    if not text or Trim(text) == "" then return nil, 0, "Nothing to import." end
    local lines = {}
    for line in (text.."\n"):gmatch("([^\n]*)\n") do lines[#lines+1] = Trim(line) end

    local header
    for _, l in ipairs(lines) do if l ~= "" then header = l; break end end
    if not header then return nil, 0, "Empty input." end

    local listName = header:match("^%[(.+)%]$")
    if not listName or Trim(listName) == "" then
        return nil, 0, "First line must be [ListName]."
    end
    listName = Trim(listName)

    if db.lists[listName] then
        if overwrite then
            db.lists[listName] = {}
        else
            local base, n = listName, 2
            while db.lists[listName] do listName = base.." ("..n..")"; n = n+1 end
        end
    end
    db.lists[listName] = db.lists[listName] or {}
    if not db.activeList then db.activeList = listName end

    local imported, skipped = 0, 0
    for i = 2, #lines do
        if lines[i] ~= "" then
            local idStr, noteEnc = lines[i]:match("^(%d+)|(.*)$")
            if not idStr then idStr = lines[i]:match("^(%d+)$") end
            local itemId = idStr and tonumber(idStr)
            if itemId then
                local _, link = GetItemInfo(itemId)
                link = link or ("|cff0070dd[Item #"..itemId.."]|r")
                if AddItem(listName, itemId, link, noteEnc and DecNote(noteEnc) or "") then
                    imported = imported + 1
                else
                    skipped = skipped + 1
                end
            end
        end
    end
    QueueLinkRefresh(listName)
    return listName, imported, nil, skipped
end

-- ============================================================
--  Chat sharing
-- ============================================================
local function ShareListToChannel(listName, channel)
    local list = db.lists[listName]
    if not list then Print("|cffFF4444List not found.|r"); return end
    local function send(msg)
        if channel and channel ~= "" then SendChatMessage(msg, channel) else print(msg) end
    end
    send(string.format("|cffFFD700[EpochWishlist]|r %s (%d items):", listName, #list))
    for i, e in ipairs(list) do
        local note = (e.note ~= "") and (" — "..e.note) or ""
        send(i..". "..(e.itemLink or "Item #"..e.itemId)..note)
    end
end

-- ============================================================
--  Addon messaging (no AceComm — hand-rolled chunked protocol)
--
--  START:<listname>  →  begin receiving
--  DATA:<chunk>      →  append chunk
--  END               →  deserialise and import
--
--  Payload format (same as export): [name]\nid|note\n...
-- ============================================================
local inbound = {}   -- [sender] = {chunks={}}

local function SendListViaAddonMsg(listName, target)
    local list = db.lists[listName]
    if not list then Print("|cffFF4444List not found.|r"); return end

    local lines = {"[" .. listName .. "]"}
    for _, e in ipairs(list) do
        lines[#lines+1] = tostring(e.itemId) .. "|" .. EncNote(e.note)
    end
    local payload = table.concat(lines, "\n")

    local channel, dest
    if target then
        channel, dest = "WHISPER", target
    elseif IsInRaid() then
        channel = "RAID"
    elseif IsInGroup() then
        channel = "PARTY"
    else
        Print("|cffFF4444Not in a group — use /ew send <list> <player>.|r"); return
    end

    SendAddonMessage(COMM_PREFIX, "START:"..listName,  channel, dest)
    local CHUNK = 200
    for pos = 1, #payload, CHUNK do
        SendAddonMessage(COMM_PREFIX, "DATA:"..payload:sub(pos, pos+CHUNK-1), channel, dest)
    end
    SendAddonMessage(COMM_PREFIX, "END", channel, dest)
    Print(string.format("Sent |cffFFD700%s|r to %s.", listName, dest or channel))
end

local function OnAddonMsg(prefix, message, _, sender)
    if prefix ~= COMM_PREFIX then return end
    if sender == UnitName("player") then return end

    if message:sub(1,6) == "START:" then
        inbound[sender] = {chunks={}}
    elseif message:sub(1,5) == "DATA:" and inbound[sender] then
        table.insert(inbound[sender].chunks, message:sub(6))
    elseif message == "END" and inbound[sender] then
        local raw = table.concat(inbound[sender].chunks)
        inbound[sender] = nil
        local listName, count, err = ImportList(raw, false)
        if err then
            Print("|cffFF4444Receive error from "..sender..": "..err.."|r")
        else
            Print(string.format("|cff00FF00Received|r |cffFFD700%s|r from |cffFFFFFF%s|r (%d items).",
                listName, sender, count))
            db.activeList = listName
            if mainFrame and mainFrame:IsShown() then
                RefreshListDropdown(); RefreshItemRows()
            end
        end
    end
end

-- ============================================================
--  Drop data is in EpochWishlist_Items.lua (loaded first via .toc)
-- ============================================================
-- EW_DROP_DATA is declared as a global in EpochWishlist_Items.lua

-- ============================================================
--  Drop-source lookup  (reads from local table above)
-- ============================================================
local function EpochDropInfo(itemId)
    if not itemId then return nil end
    return EW_DROP_DATA[itemId] or EW_DROP_DATA[tonumber(itemId)]
end

-- ============================================================
--  Tooltip (AtlasLoot-safe)
--
--  Uses SetItemByID when only an itemId is available (works for
--  uncached items on 3.3.5 — the client fetches from server).
--  Falls back to SetHyperlink when a full link is already known.
-- ============================================================
local function ShowItemTooltip(owner, itemLink, itemId)
    local cur = GameTooltip:GetOwner()
    local atlasOwned = cur and cur:GetName() and cur:GetName():find("^AtlasLootItem_")

    if not atlasOwned then
        GameTooltip:SetOwner(owner, "ANCHOR_RIGHT")
        if itemLink then
            GameTooltip:SetHyperlink(itemLink)
        elseif itemId then
            GameTooltip:SetItemByID(itemId)
        else
            return
        end
    end

    local info = EpochDropInfo(itemId)
    if info then
        GameTooltip:AddLine(" ")
        GameTooltip:AddLine("|cffC8A96EDrop Source:|r")
        GameTooltip:AddLine("  "..info.source, 1, 1, 1)
        if info.chance then
            local c   = info.chance
            local col = c >= 50 and "|cff00FF00" or c >= 15 and "|cffffff00" or "|cffFF9933"
            GameTooltip:AddLine(string.format("  %s%s%%|r drop chance", col, (c < 0.1 and string.format("%.2f", c) or string.format("%.1f", c))))
        end
    end
    GameTooltip:Show()
end

-- ============================================================
--  Pure-Lua context menu  (replaces DewdropLib)
-- ============================================================
local ContextMenu
do
    local frame = CreateFrame("Frame", "EWContextMenu", UIParent)
    frame:SetFrameStrata("TOOLTIP")
    frame:SetClampedToScreen(true)
    frame:Hide()
    frame:SetBackdrop({
        bgFile   = "Interface\\ChatFrame\\ChatFrameBackground",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        tile=true, tileSize=16, edgeSize=12,
        insets={left=3,right=3,top=3,bottom=3},
    })
    frame:SetBackdropColor(0.06, 0.04, 0.02, 0.97)
    frame:SetBackdropBorderColor(0.5, 0.38, 0.10, 1)

    local pool = {}
    local ROW_H = 18
    local PAD   = 5

    local function Close()
        frame:Hide()
        frame:SetScript("OnUpdate", nil)
    end

    -- items = { {text, func, isTitle, isSep, color, disabled}, ... }
    local function Open(anchor, items)
        for _, b in ipairs(pool) do b:Hide() end

        local width = 120
        local y     = -PAD

        for i, item in ipairs(items) do
            local btn = pool[i]
            if not btn then
                btn = CreateFrame("Button", nil, frame)
                local fs = btn:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
                fs:SetPoint("LEFT",  btn, "LEFT",  PAD, 0)
                fs:SetPoint("RIGHT", btn, "RIGHT", -PAD, 0)
                fs:SetJustifyH("LEFT")
                btn.fs = fs
                pool[i] = btn
            end

            btn:ClearAllPoints()
            btn:SetPoint("TOPLEFT", frame, "TOPLEFT", 0, y)

            if item.isSep then
                btn:SetHeight(6)
                btn:EnableMouse(false)
                btn:SetHighlightTexture(nil)
                btn.fs:SetText("")
                local line = btn:CreateTexture(nil, "ARTWORK")
                line:SetTexture(1, 1, 1, 0.15)
                line:SetHeight(1)
                line:SetPoint("LEFT",  btn, "LEFT",  PAD, 0)
                line:SetPoint("RIGHT", btn, "RIGHT", -PAD, 0)
                line:SetPoint("CENTER",btn, "CENTER")
                btn:SetScript("OnClick", nil)
                y = y - 6
            elseif item.isTitle then
                btn:SetHeight(ROW_H)
                btn:EnableMouse(false)
                btn:SetHighlightTexture(nil)
                btn.fs:SetText("|cff9a7a32"..item.text.."|r")
                btn:SetScript("OnClick", nil)
                y = y - ROW_H
            else
                btn:SetHeight(ROW_H)
                btn:EnableMouse(not item.disabled)
                if not item.disabled then
                    btn:SetHighlightTexture(
                        "Interface\\QuestFrame\\UI-QuestLogTitleHighlight", "ADD")
                else
                    btn:SetHighlightTexture(nil)
                end
                local col = item.disabled and "|cff555555"
                          or (item.color or "|cffDDCCAA")
                btn.fs:SetText(col..item.text.."|r")
                local fn = item.func
                btn:SetScript("OnClick", function()
                    Close()
                    if not item.disabled and fn then fn() end
                end)
                y = y - ROW_H
            end

            local needed = btn.fs:GetStringWidth() + PAD*2
            if needed > width then width = math.min(needed, 260) end
            btn:Show()
        end

        local totalH = -y + PAD
        frame:SetSize(width, totalH)
        for _, b in ipairs(pool) do
            if b:IsShown() then b:SetWidth(width) end
        end

        frame:ClearAllPoints()
        local ax, ay = anchor:GetCenter()
        local s = UIParent:GetEffectiveScale()
        ax = ax * anchor:GetEffectiveScale() / s
        ay = ay * anchor:GetEffectiveScale() / s
        if ay - totalH < 0 then
            frame:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", ax, ay)
        else
            frame:SetPoint("TOPLEFT",    UIParent, "BOTTOMLEFT", ax, ay)
        end
        frame:Show()

        frame:SetScript("OnUpdate", function(self)
            if (IsMouseButtonDown("LeftButton") or IsMouseButtonDown("RightButton"))
                and not MouseIsOver(self) then
                Close()
            end
        end)
    end

    ContextMenu = {Open=Open, Close=Close}
end

-- ============================================================
--  Pure-Lua dropdown  (replaces UIDropDownMenuTemplate)
--
--  One shared popup, anchors below (or above) its owner button.
--  Each dropdown stores a *builder function* that is called
--  fresh every time the popup opens, so the list is always
--  current without needing an explicit refresh call.
--
--  Item table format:
--    { text, onClick }            normal clickable row
--    { text, disabled=true }      greyed-out, non-clickable
--    { text, isHeader=true }      gold section label
-- ============================================================
local DD_POPUP  -- created once on first use
local DD_OWNER  -- button that currently owns the popup
local DD_MAX_H  = 320

local function CloseDropdown()
    if DD_POPUP then DD_POPUP:Hide() end
    DD_OWNER = nil
end

local function EnsureDDPopup()
    if DD_POPUP then return DD_POPUP end

    local f = CreateFrame("Frame", "EWDropdownPopup", UIParent)
    f:SetFrameStrata("FULLSCREEN_DIALOG")
    f:SetClampedToScreen(true)
    f:SetBackdrop({
        bgFile   = "Interface\\ChatFrame\\ChatFrameBackground",
        edgeFile = "Interface\\ChatFrame\\ChatFrameBackground",
        tile=true, tileSize=16, edgeSize=1,
        insets={left=1,right=1,top=1,bottom=1},
    })
    f:SetBackdropColor(0.07, 0.055, 0.02, 0.98)
    f:SetBackdropBorderColor(0.55, 0.42, 0.06, 1)
    f:Hide()

    local sf = CreateFrame("ScrollFrame", "EWDropdownScroll", f,
        "UIPanelScrollFrameTemplate")
    f.sf = sf

    local content = CreateFrame("Frame", nil, sf)
    content:SetHeight(1)
    sf:SetScrollChild(content)
    f.content = content

    f.pool   = {}
    f.active = {}

    local ROW_H    = 20
    local HEADER_H = 16

    function f:Populate(items, popW)
        for _, b in ipairs(self.active) do b:Hide() end
        wipe(self.active)

        local totalH = 0
        for _, item in ipairs(items) do
            totalH = totalH + (item.isHeader and HEADER_H or ROW_H)
        end
        local needsScroll = totalH > DD_MAX_H
        local innerW = popW - 4 - (needsScroll and 16 or 0)

        local popH = math.min(totalH + 4, DD_MAX_H)
        self:SetSize(popW, popH)

        sf:SetPoint("TOPLEFT",     self, "TOPLEFT",    2,  -2)
        sf:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT",
            needsScroll and -18 or -2, 2)

        content:SetWidth(innerW)
        content:SetHeight(totalH)
        sf:SetVerticalScroll(0)

        local y = 0
        for i, item in ipairs(items) do
            local btn = self.pool[i]
            if not btn then
                btn = CreateFrame("Button", nil, content)

                -- hover highlight
                local hl = btn:CreateTexture(nil,"HIGHLIGHT")
                hl:SetAllPoints()
                hl:SetTexture("Interface\\ChatFrame\\ChatFrameBackground")
                hl:SetVertexColor(0.72, 0.56, 0.08, 0.15)

                local fs = btn:CreateFontString(nil,"OVERLAY","GameFontNormalSmall")
                fs:SetPoint("LEFT",  btn,"LEFT",  8, 0)
                fs:SetPoint("RIGHT", btn,"RIGHT", -4, 0)
                fs:SetJustifyH("LEFT")
                btn.fs = fs
                self.pool[i] = btn
            end

            local h = item.isHeader and HEADER_H or ROW_H
            btn:ClearAllPoints()
            btn:SetPoint("TOPLEFT", content,"TOPLEFT", 0, -y)
            btn:SetSize(innerW, h)
            btn:Show()

            if item.isHeader then
                btn:EnableMouse(false)
                btn:SetScript("OnClick", nil)
                btn.fs:SetTextColor(0.72, 0.56, 0.08)
                btn.fs:SetFont("Fonts\\FRIZQT__.TTF", 9, "OUTLINE")
                btn.fs:SetText(item.text)
                if not btn.hdrBg then
                    btn.hdrBg = btn:CreateTexture(nil,"BACKGROUND")
                    btn.hdrBg:SetAllPoints()
                    btn.hdrBg:SetTexture("Interface\\ChatFrame\\ChatFrameBackground")
                end
                btn.hdrBg:SetVertexColor(0.10, 0.07, 0.02, 1); btn.hdrBg:Show()
            elseif item.disabled then
                btn:EnableMouse(false)
                btn:SetScript("OnClick", nil)
                btn.fs:SetTextColor(0.40, 0.36, 0.22)
                btn.fs:SetFont("Fonts\\FRIZQT__.TTF", 10, "")
                btn.fs:SetText(item.text)
                if btn.hdrBg then btn.hdrBg:Hide() end
            else
                btn:EnableMouse(true)
                btn.fs:SetTextColor(0.88, 0.78, 0.50)
                btn.fs:SetFont("Fonts\\FRIZQT__.TTF", 10, "")
                btn.fs:SetText(item.text)
                if btn.hdrBg then btn.hdrBg:Hide() end
                local fn = item.onClick
                btn:SetScript("OnClick", function()
                    CloseDropdown()
                    if fn then fn() end
                end)
                btn:SetScript("OnEnter", function(self2)
                    self2.fs:SetTextColor(1, 0.90, 0.60)
                end)
                btn:SetScript("OnLeave", function(self2)
                    self2.fs:SetTextColor(0.88, 0.78, 0.50)
                end)
            end

            -- thin separator line between rows
            if not btn.sep then
                btn.sep = btn:CreateTexture(nil,"BACKGROUND")
                btn.sep:SetTexture("Interface\\ChatFrame\\ChatFrameBackground")
                btn.sep:SetPoint("BOTTOMLEFT",  btn,"BOTTOMLEFT",  0, 0)
                btn.sep:SetPoint("BOTTOMRIGHT", btn,"BOTTOMRIGHT", 0, 0)
                btn.sep:SetHeight(1)
                btn.sep:SetVertexColor(0.25, 0.19, 0.05, 0.5)
            end

            y = y + h
            self.active[i] = btn
        end
    end

    f:SetScript("OnMouseDown", function() end)

    local catcher = CreateFrame("Frame", "EWDDCatcher", UIParent)
    catcher:SetAllPoints(UIParent)
    catcher:SetFrameStrata("DIALOG")
    catcher:EnableMouse(true)
    catcher:Hide()
    catcher:SetScript("OnMouseDown", function()
        CloseDropdown()
        catcher:Hide()
    end)
    f.catcher = catcher

    DD_POPUP = f
    return f
end

local function OpenDropdown(ownerBtn, builderFn)
    local popup = EnsureDDPopup()

    if popup:IsShown() and DD_OWNER == ownerBtn then
        CloseDropdown()
        popup.catcher:Hide()
        return
    end

    DD_OWNER = ownerBtn

    local items = builderFn()
    local popW  = math.max(ownerBtn:GetWidth(), 120)
    popup:Populate(items, popW)

    popup:ClearAllPoints()

    local scale    = ownerBtn:GetEffectiveScale()
    local uiScale  = UIParent:GetEffectiveScale()
    local ratio    = scale / uiScale

    local bLeft    = (ownerBtn:GetLeft()   or 0) * ratio
    local bBottom  = (ownerBtn:GetBottom() or 0) * ratio
    local bTop     = (ownerBtn:GetTop()    or 0) * ratio
    local popH     = popup:GetHeight()

    if bBottom - popH < 0 then
        popup:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", bLeft, bTop)
    else
        popup:SetPoint("TOPLEFT",    UIParent, "BOTTOMLEFT", bLeft, bBottom)
    end

    popup:Show()
    popup.catcher:Show()
end

local function CreateDropdown(parent, width)
    local btn = CreateFrame("Button", nil, parent)
    btn:SetSize(width, 20)

    btn:SetBackdrop({
        bgFile   = "Interface\\ChatFrame\\ChatFrameBackground",
        edgeFile = "Interface\\ChatFrame\\ChatFrameBackground",
        edgeSize = 1,
        insets   = {left=1, right=1, top=1, bottom=1},
    })
    btn:SetBackdropColor(0.18, 0.14, 0.04, 1)
    btn:SetBackdropBorderColor(0.55, 0.42, 0.06, 0.9)

    local label = btn:CreateFontString(nil,"OVERLAY","GameFontNormalSmall")
    label:SetPoint("LEFT",  btn,"LEFT",   6, 0)
    label:SetPoint("RIGHT", btn,"RIGHT", -18, 0)
    label:SetJustifyH("LEFT")
    label:SetTextColor(0.88, 0.78, 0.50)
    btn.label = label

    -- Arrow triangle using a simple texture
    local arrow = btn:CreateFontString(nil,"OVERLAY","GameFontNormalSmall")
    arrow:SetPoint("RIGHT", btn,"RIGHT", -5, 0)
    arrow:SetText("|cff9a7a32v|r")
    arrow:SetFont("Fonts\\FRIZQT__.TTF", 8, "")

    btn:SetScript("OnEnter", function(self)
        self:SetBackdropColor(0.28, 0.22, 0.06, 1)
        self:SetBackdropBorderColor(0.85, 0.65, 0.10, 1)
        self.label:SetTextColor(1, 0.90, 0.60)
    end)
    btn:SetScript("OnLeave", function(self)
        self:SetBackdropColor(0.18, 0.14, 0.04, 1)
        self:SetBackdropBorderColor(0.55, 0.42, 0.06, 0.9)
        self.label:SetTextColor(0.88, 0.78, 0.50)
    end)
    btn:SetScript("OnMouseDown", function(self)
        self:SetBackdropColor(0.10, 0.08, 0.02, 1)
    end)
    btn:SetScript("OnMouseUp", function(self)
        self:SetBackdropColor(0.18, 0.14, 0.04, 1)
    end)

    function btn:SetItems(builderFn)
        self:SetScript("OnClick", function(self2)
            OpenDropdown(self2, builderFn)
        end)
    end

    function btn:SetSelectedText(text)
        self.label:SetText(text or "|cff666644(none)|r")
    end

    return btn
end


-- ============================================================
--  Export/Import/Share popup frame
-- ============================================================
local shareFrame
local mainFrame   -- set when first opened

local function CreateShareFrame()
    local sf = CreateFrame("Frame", "EWShareFrame", UIParent)
    sf:SetSize(500, 440)
    sf:SetPoint("CENTER", UIParent, "CENTER", 60, 0)
    sf:SetMovable(true); sf:EnableMouse(true); sf:SetClampedToScreen(true)
    sf:SetFrameStrata("DIALOG"); sf:SetFrameLevel(100)
    sf:RegisterForDrag("LeftButton")
    sf:SetScript("OnDragStart", sf.StartMoving)
    sf:SetScript("OnDragStop",  sf.StopMovingOrSizing)
    sf:SetBackdrop({
        bgFile   = "Interface\\DialogFrame\\UI-DialogBox-Background",
        edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
        tile=true, tileSize=32, edgeSize=32,
        insets={left=11,right=12,top=12,bottom=11},
    })
    sf:SetBackdropColor(0.04, 0.04, 0.07, 0.97)
    sf:SetBackdropBorderColor(0.8, 0.65, 0.1, 1)

    local titleBar = sf:CreateTexture(nil,"BACKGROUND",nil,1)
    titleBar:SetTexture("Interface\\DialogFrame\\UI-DialogBox-Header")
    titleBar:SetSize(340, 64); titleBar:SetPoint("TOP", sf, "TOP", 0, 12)

    local titleText = sf:CreateFontString(nil,"OVERLAY","GameFontNormalLarge")
    titleText:SetPoint("TOP", sf, "TOP", 0, -4)
    sf.titleText = titleText

    local closeBtn = CreateFrame("Button", nil, sf, "UIPanelCloseButton")
    closeBtn:SetPoint("TOPRIGHT", sf, "TOPRIGHT", -4, -4)
    closeBtn:SetScript("OnClick", function() sf:Hide() end)

    local tabExport = CreateFrame("Button", nil, sf, "UIPanelButtonTemplate")
    tabExport:SetSize(80, 24); tabExport:SetPoint("TOPLEFT", sf, "TOPLEFT", 16, -36)
    tabExport:SetText("Export")

    local tabImport = CreateFrame("Button", nil, sf, "UIPanelButtonTemplate")
    tabImport:SetSize(80, 24); tabImport:SetPoint("LEFT", tabExport, "RIGHT", 4, 0)
    tabImport:SetText("Import")

    local instrLabel = sf:CreateFontString(nil,"OVERLAY","GameFontNormalSmall")
    instrLabel:SetPoint("TOPLEFT",  sf, "TOPLEFT",  16, -64)
    instrLabel:SetPoint("TOPRIGHT", sf, "TOPRIGHT", -16, -64)
    instrLabel:SetJustifyH("LEFT"); instrLabel:SetTextColor(0.75, 0.75, 0.5)
    sf.instrLabel = instrLabel

    local scrollBg = CreateFrame("Frame", nil, sf)
    scrollBg:SetPoint("TOPLEFT",     sf, "TOPLEFT",     14, -80)
    scrollBg:SetPoint("BOTTOMRIGHT", sf, "BOTTOMRIGHT", -14, 106)
    scrollBg:SetBackdrop({
        bgFile="Interface\\ChatFrame\\ChatFrameBackground",
        edgeFile="Interface\\Tooltips\\UI-Tooltip-Border",
        tile=true, tileSize=16, edgeSize=12,
        insets={left=3,right=3,top=3,bottom=3},
    })
    scrollBg:SetBackdropColor(0,0,0,0.75)
    scrollBg:SetBackdropBorderColor(0.45,0.45,0.45,0.9)

    local scroll = CreateFrame("ScrollFrame","EWShareScroll",scrollBg,"UIPanelScrollFrameTemplate")
    scroll:SetPoint("TOPLEFT",     scrollBg, "TOPLEFT",     6,  -6)
    scroll:SetPoint("BOTTOMRIGHT", scrollBg, "BOTTOMRIGHT", -26, 6)

    local editBox = CreateFrame("EditBox","EWShareEditBox",scroll)
    editBox:SetSize(scroll:GetWidth(), 400)
    editBox:SetMultiLine(true); editBox:SetAutoFocus(false); editBox:SetMaxLetters(0)
    editBox:SetFontObject(ChatFontNormal); editBox:SetTextColor(0.9,0.9,0.75)
    editBox:SetScript("OnEscapePressed", function(s) s:ClearFocus() end)
    scroll:SetScrollChild(editBox)
    sf.editBox = editBox

    local selectAllBtn = CreateFrame("Button",nil,sf,"UIPanelButtonTemplate")
    selectAllBtn:SetSize(86,24); selectAllBtn:SetPoint("BOTTOMLEFT",sf,"BOTTOMLEFT",14,74)
    selectAllBtn:SetText("Select All")
    selectAllBtn:SetScript("OnClick", function() editBox:SetFocus(); editBox:HighlightText() end)

    local clearBtn = CreateFrame("Button",nil,sf,"UIPanelButtonTemplate")
    clearBtn:SetSize(60,24); clearBtn:SetPoint("LEFT",selectAllBtn,"RIGHT",4,0)
    clearBtn:SetText("Clear")
    clearBtn:SetScript("OnClick", function() editBox:SetText(""); editBox:SetFocus() end)

    local doImportBtn = CreateFrame("Button",nil,sf,"UIPanelButtonTemplate")
    doImportBtn:SetSize(120,24); doImportBtn:SetPoint("BOTTOMRIGHT",sf,"BOTTOMRIGHT",-14,74)
    doImportBtn:SetText("Import List")
    sf.doImportBtn = doImportBtn

    local overwriteChk = CreateFrame("CheckButton",nil,sf,"UICheckButtonTemplate")
    overwriteChk:SetSize(20,20); overwriteChk:SetPoint("RIGHT",doImportBtn,"LEFT",-6,0)
    local overwriteLbl = sf:CreateFontString(nil,"OVERLAY","GameFontNormalSmall")
    overwriteLbl:SetPoint("RIGHT",overwriteChk,"LEFT",-2,0)
    overwriteLbl:SetText("Overwrite"); overwriteLbl:SetTextColor(0.8,0.8,0.6)
    sf.overwriteChk = overwriteChk; sf.overwriteLbl = overwriteLbl

    local shareLabel = sf:CreateFontString(nil,"OVERLAY","GameFontNormal")
    shareLabel:SetPoint("BOTTOMLEFT",sf,"BOTTOMLEFT",14,42)
    shareLabel:SetText("|cffFFD700Share to:|r")

    local chanBtns = {}
    local prev
    for _, chan in ipairs({"SAY","PARTY","RAID","GUILD"}) do
        local b = CreateFrame("Button",nil,sf,"UIPanelButtonTemplate")
        b:SetSize(62,22)
        if not prev then b:SetPoint("LEFT",shareLabel,"RIGHT",6,0)
        else              b:SetPoint("LEFT",prev,"RIGHT",3,0) end
        b:SetText(chan)
        local c = chan
        b:SetScript("OnClick", function()
            if db.activeList then
                ShareListToChannel(db.activeList, c)
                Print(string.format("Posted |cffFFD700%s|r to %s.", db.activeList, c))
            end
        end)
        prev=b; chanBtns[#chanBtns+1]=b
    end
    sf.chanBtns = chanBtns

    local sendLabel = sf:CreateFontString(nil,"OVERLAY","GameFontNormalSmall")
    sendLabel:SetPoint("BOTTOMLEFT",sf,"BOTTOMLEFT",14,18)
    sendLabel:SetText("|cffAAAAAASend via addon message to player:|r")

    local playerBox = CreateFrame("EditBox",nil,sf,"InputBoxTemplate")
    playerBox:SetSize(120,18); playerBox:SetPoint("LEFT",sendLabel,"RIGHT",4,0)
    playerBox:SetAutoFocus(false); playerBox:SetText("PlayerName")
    sf.playerBox = playerBox

    local sendBtn = CreateFrame("Button",nil,sf,"UIPanelButtonTemplate")
    sendBtn:SetSize(60,22); sendBtn:SetPoint("LEFT",playerBox,"RIGHT",4,0)
    sendBtn:SetText("Send")
    sendBtn:SetScript("OnClick", function()
        local target = Trim(playerBox:GetText())
        if db.activeList and target ~= "" and target ~= "PlayerName" then
            SendListViaAddonMsg(db.activeList, target)
        end
    end)

    local statusLine = sf:CreateFontString(nil,"OVERLAY","GameFontNormalSmall")
    statusLine:SetPoint("BOTTOM",sf,"BOTTOM",0,4)
    statusLine:SetJustifyH("CENTER"); statusLine:SetTextColor(0.55,0.55,0.55)
    sf.statusLine = statusLine

    local function SetExportMode(listName)
        titleText:SetText("|cffFFD700Epoch Wishlist — Export|r")
        instrLabel:SetText("Copy the text below. Others paste it in the Import tab.")
        doImportBtn:Hide(); overwriteChk:Hide(); overwriteLbl:Hide()
        shareLabel:Show()
        for _,b in ipairs(chanBtns) do b:Show() end
        sendLabel:Show(); playerBox:Show(); sendBtn:Show()
        tabExport:SetEnabled(false); tabImport:SetEnabled(true)

        local target = listName or db.activeList
        if target then
            local text, err = ExportList(target)
            if text then
                editBox:SetText(text)
                local n = #(db.lists[target] or {})
                statusLine:SetText(string.format(
                    "Exporting: |cffFFD700%s|r  (%d item%s)  — Select All → Ctrl+C",
                    target, n, n==1 and "" or "s"))
                editBox:SetFocus(); editBox:HighlightText()
            else
                editBox:SetText(""); statusLine:SetText("|cffFF4444"..(err or "Error").."|r")
            end
        else
            editBox:SetText(""); statusLine:SetText("No active list.")
        end
    end

    local function SetImportMode()
        titleText:SetText("|cffFFD700Epoch Wishlist — Import|r")
        instrLabel:SetText("Paste an exported list here, then click |cffFFD700Import List|r.")
        doImportBtn:Show(); overwriteChk:Show(); overwriteLbl:Show()
        shareLabel:Hide()
        for _,b in ipairs(chanBtns) do b:Hide() end
        sendLabel:Hide(); playerBox:Hide(); sendBtn:Hide()
        tabExport:SetEnabled(true); tabImport:SetEnabled(false)
        editBox:SetText("")
        statusLine:SetText("First line must be [ListName].")
        editBox:SetFocus()
    end

    tabExport:SetScript("OnClick", function() SetExportMode() end)
    tabImport:SetScript("OnClick", function() SetImportMode() end)

    doImportBtn:SetScript("OnClick", function()
        local listName, count, err, skipped = ImportList(editBox:GetText(), overwriteChk:GetChecked())
        if err then
            Print("|cffFF4444Import error:|r "..err)
        else
            local msg = string.format("|cff00FF00Imported|r |cffFFD700%s|r — %d item%s.",
                listName, count, count==1 and "" or "s")
            if skipped and skipped > 0 then
                msg = msg..string.format(" (%d duplicate%s skipped.)", skipped, skipped==1 and "" or "s")
            end
            Print(msg)
            db.activeList = listName
            sf:Hide()
            if mainFrame and mainFrame:IsShown() then RefreshListDropdown(); RefreshItemRows() end
        end
    end)

    sf.SetExportMode = SetExportMode
    sf.SetImportMode = SetImportMode
    sf:Hide()
    return sf
end

local function OpenExportFrame(listName)
    if not shareFrame then shareFrame = CreateShareFrame() end
    shareFrame.SetExportMode(listName); shareFrame:Show()
end
local function OpenImportFrame()
    if not shareFrame then shareFrame = CreateShareFrame() end
    shareFrame.SetImportMode(); shareFrame:Show()
end

-- ============================================================
--  Main window
-- ============================================================
local ROW_HEIGHT = 28
local PAD        = 4

local function CreateMainFrame()
    local f = CreateFrame("Frame","EpochWishlistFrame",UIParent)
    f:SetSize(db.windowSize.w, db.windowSize.h)
    f:SetPoint(db.windowPos.point, UIParent, db.windowPos.point,
               db.windowPos.x, db.windowPos.y)
    f:SetMovable(true); f:SetResizable(true); f:EnableMouse(true)
    f:SetClampedToScreen(true); f:SetToplevel(true)
    f:RegisterForDrag("LeftButton")
    f:SetScript("OnDragStart", f.StartMoving)
    f:SetScript("OnDragStop", function(self)
        self:StopMovingOrSizing()
        local pt,_,_,x,y = self:GetPoint()
        db.windowPos.point=pt; db.windowPos.x=x; db.windowPos.y=y
    end)
    f:SetBackdrop({
        bgFile   = "Interface\\ChatFrame\\ChatFrameBackground",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        tile=true, tileSize=16, edgeSize=16,
        insets={left=4,right=4,top=4,bottom=4},
    })
    f:SetBackdropColor(0.06, 0.05, 0.03, 0.97)
    f:SetBackdropBorderColor(0.72, 0.56, 0.08, 1)

    -- Inner top bar (title background) - taller for fancier title
    local titleBar = f:CreateTexture(nil,"BACKGROUND",nil,1)
    titleBar:SetTexture("Interface\\ChatFrame\\ChatFrameBackground")
    titleBar:SetPoint("TOPLEFT",  f, "TOPLEFT",  5, -5)
    titleBar:SetPoint("TOPRIGHT", f, "TOPRIGHT", -5, -5)
    titleBar:SetHeight(32)
    titleBar:SetVertexColor(0.10, 0.07, 0.02, 1)

    -- Subtle inner highlight strip at top of title bar
    local titleShine = f:CreateTexture(nil,"ARTWORK",nil,1)
    titleShine:SetTexture("Interface\\ChatFrame\\ChatFrameBackground")
    titleShine:SetPoint("TOPLEFT",  f, "TOPLEFT",  5, -5)
    titleShine:SetPoint("TOPRIGHT", f, "TOPRIGHT", -5, -5)
    titleShine:SetHeight(3)
    titleShine:SetVertexColor(0.90, 0.70, 0.15, 0.4)

    -- Gold line under title bar
    local titleLine = f:CreateTexture(nil,"ARTWORK")
    titleLine:SetTexture("Interface\\ChatFrame\\ChatFrameBackground")
    titleLine:SetPoint("TOPLEFT",  f, "TOPLEFT",  5, -37)
    titleLine:SetPoint("TOPRIGHT", f, "TOPRIGHT", -5, -37)
    titleLine:SetHeight(1)
    titleLine:SetVertexColor(0.85, 0.65, 0.10, 1)

    -- Thinner accent line just below gold line
    local titleLine2 = f:CreateTexture(nil,"ARTWORK")
    titleLine2:SetTexture("Interface\\ChatFrame\\ChatFrameBackground")
    titleLine2:SetPoint("TOPLEFT",  f, "TOPLEFT",  5, -38)
    titleLine2:SetPoint("TOPRIGHT", f, "TOPRIGHT", -5, -38)
    titleLine2:SetHeight(1)
    titleLine2:SetVertexColor(0.45, 0.32, 0.04, 0.6)

    -- Shadow text (offset 1px for depth effect)
    local titleShadow = f:CreateFontString(nil,"ARTWORK")
    titleShadow:SetPoint("TOP", f, "TOP", 1, -15)
    titleShadow:SetFont("Fonts\\FRIZQT__.TTF", 15, "OUTLINE")
    titleShadow:SetTextColor(0.10, 0.07, 0.02, 1)
    titleShadow:SetText("Epoch  Wishlist")

    -- Main title — "Epoch" in bright gold, "Wishlist" in warm silver
    local titleFS = f:CreateFontString(nil,"OVERLAY")
    titleFS:SetPoint("TOP", f, "TOP", 0, -14)
    titleFS:SetFont("Fonts\\FRIZQT__.TTF", 15, "OUTLINE")
    titleFS:SetText("|cffFFD700Epoch|r  |cffD4B96EWishlist|r")

    -- Small decorative dots either side of the title
    local dotL = f:CreateFontString(nil,"OVERLAY")
    dotL:SetFont("Fonts\\FRIZQT__.TTF", 9, "")
    dotL:SetPoint("RIGHT", titleFS, "LEFT", -4, 0)
    dotL:SetText("|cff7a5a14* *|r")

    local dotR = f:CreateFontString(nil,"OVERLAY")
    dotR:SetFont("Fonts\\FRIZQT__.TTF", 9, "")
    dotR:SetPoint("LEFT", titleFS, "RIGHT", 4, 0)
    dotR:SetText("|cff7a5a14* *|r")

    local closeBtn = CreateFrame("Button",nil,f,"UIPanelCloseButton")
    closeBtn:SetPoint("TOPRIGHT",f,"TOPRIGHT",-2,-4)
    closeBtn:SetScript("OnClick", function() f:Hide() end)

    -- ── Toolbar row ──────────────────────────────────────────
    local listLabel = f:CreateFontString(nil,"OVERLAY","GameFontNormal")
    listLabel:SetPoint("TOPLEFT",f,"TOPLEFT",16,-46)
    listLabel:SetText("|cffC8A96EList:|r")

    -- Pure-Lua dropdown (no UIDropDownMenuTemplate)
    local listDD = CreateDropdown(f, 150)
    listDD:SetPoint("LEFT", listLabel, "RIGHT", 4, 0)

    RefreshListDropdown = function()
        listDD:SetSelectedText(db.activeList or nil)
        listDD:SetItems(function()
            local names = GetListNames()
            local items = {}
            if #names == 0 then
                items[1] = { text="|cff888888(no lists)|r", disabled=true }
            else
                for _, n in ipairs(names) do
                    local name = n
                    items[#items+1] = {
                        text    = (name==db.activeList and "|cffFFD700" or "")..name.."|r",
                        onClick = function()
                            db.activeList = name
                            listDD:SetSelectedText(name)
                            RefreshItemRows()
                        end,
                    }
                end
            end
            return items
        end)
    end

    -- Toolbar background strip
    local toolbarBg = f:CreateTexture(nil,"BACKGROUND",nil,1)
    toolbarBg:SetTexture("Interface\\ChatFrame\\ChatFrameBackground")
    toolbarBg:SetPoint("TOPLEFT",  f, "TOPLEFT",  5, -40)
    toolbarBg:SetPoint("TOPRIGHT", f, "TOPRIGHT", -5, -40)
    toolbarBg:SetHeight(26)
    toolbarBg:SetVertexColor(0.09, 0.07, 0.02, 1)

    local function Btn(w, label, anchor, xOff, tip, fn)
        local b = CreateFrame("Button", nil, f)
        b:SetSize(w, 20)
        b:SetPoint("LEFT", anchor, "RIGHT", xOff or 2, 0)

        b:SetBackdrop({
            bgFile   = "Interface\\ChatFrame\\ChatFrameBackground",
            edgeFile = "Interface\\ChatFrame\\ChatFrameBackground",
            edgeSize = 1,
            insets   = {left=1, right=1, top=1, bottom=1},
        })
        b:SetBackdropColor(0.18, 0.14, 0.04, 1)
        b:SetBackdropBorderColor(0.55, 0.42, 0.06, 0.9)

        local fs = b:CreateFontString(nil,"OVERLAY","GameFontNormalSmall")
        fs:SetAllPoints()
        fs:SetJustifyH("CENTER")
        fs:SetText("|cffC8A96E"..label.."|r")
        b.label = fs

        b:SetScript("OnEnter", function(self)
            self:SetBackdropColor(0.28, 0.22, 0.06, 1)
            self:SetBackdropBorderColor(0.85, 0.65, 0.10, 1)
            if tip then
                GameTooltip:SetOwner(self,"ANCHOR_RIGHT")
                GameTooltip:SetText(tip); GameTooltip:Show()
            end
        end)
        b:SetScript("OnLeave", function(self)
            self:SetBackdropColor(0.18, 0.14, 0.04, 1)
            self:SetBackdropBorderColor(0.55, 0.42, 0.06, 0.9)
            GameTooltip:Hide()
        end)
        b:SetScript("OnMouseDown", function(self)
            self:SetBackdropColor(0.10, 0.08, 0.02, 1)
        end)
        b:SetScript("OnMouseUp", function(self)
            self:SetBackdropColor(0.18, 0.14, 0.04, 1)
        end)
        if fn then b:SetScript("OnClick", fn) end
        return b
    end

    local newBtn = Btn(24, "+",      listDD, 2, "New list",
        function() StaticPopup_Show("EW_CREATE_LIST") end)
    local delBtn = Btn(24, "×",      newBtn, 2, "Delete active list",
        function() if db.activeList then StaticPopup_Show("EW_DELETE_LIST",db.activeList) end end)
    local renBtn = Btn(52, "Rename", delBtn, 2, "Rename active list",
        function() if db.activeList then StaticPopup_Show("EW_RENAME_LIST",db.activeList) end end)
    local expBtn = Btn(56, "Export", renBtn, 8, "Export to text",
        function()
            if db.activeList then OpenExportFrame(db.activeList)
            else Print("|cffFF4444No active list.|r") end
        end)
    local impBtn = Btn(54, "Import", expBtn, 2, "Import from text", function() OpenImportFrame() end)

    -- Loot Council export button
    local lcBtn = Btn(48, "Council", impBtn, 8,
        "Copy a loot-council summary to clipboard\n(list name, priorities, obtained status)",
        function()
            local active = db.activeList
            local list   = active and db.lists[active]
            if not list or #list == 0 then
                Print("|cffFF4444No items to export.|r"); return
            end
            local lines = { "=== "..active.." ===" }
            -- Sort a copy: unobtained first, then by priority desc
            local sorted = {}
            for _, e in ipairs(list) do sorted[#sorted+1] = e end
            table.sort(sorted, function(a, b)
                if (a.obtained and 1 or 0) ~= (b.obtained and 1 or 0) then
                    return (a.obtained and 1 or 0) < (b.obtained and 1 or 0)
                end
                local pa = a.priority or 0
                local pb = b.priority or 0
                return pa > pb
            end)
            for _, e in ipairs(sorted) do
                local name = e.itemLink
                    and e.itemLink:gsub("|c%x%x%x%x%x%x%x%x",""):gsub("|r",""):gsub("%[(.-)%]","%1")
                    or ("Item #"..e.itemId)
                local pStr = e.priority and e.priority > 0 and (" [P"..e.priority.."]") or ""
                local oStr = e.obtained and " [GOT]" or ""
                local nStr = e.note ~= "" and (" -- "..e.note) or ""
                lines[#lines+1] = name..pStr..oStr..nStr
            end
            local out = table.concat(lines, "\n")
            -- Copy to clipboard via a hidden EditBox trick
            if not f._lcBox then
                local eb = CreateFrame("EditBox", nil, f)
                eb:SetSize(1,1); eb:SetPoint("CENTER")
                eb:SetAutoFocus(false); eb:SetMaxLetters(0)
                eb:Hide(); f._lcBox = eb
            end
            f._lcBox:Show()
            f._lcBox:SetText(out)
            f._lcBox:SetFocus()
            f._lcBox:HighlightText()
            -- Hide it after user copies (focus lost)
            f._lcBox:SetScript("OnEditFocusLost", function(self) self:Hide() end)
            Print("|cff00FF00Loot council list ready — press Ctrl+C to copy.|r")
        end)

    -- ── Tab buttons ──────────────────────────────────────────
    local TAB_Y = -74   -- top of tab row (below toolbar divider)

    local function MakeTab(label, point, relFrame, relPoint, xOff)
        local t = CreateFrame("Button", nil, f)
        t:SetSize(92, 22)
        t:SetPoint(point, relFrame, relPoint, xOff, 0)

        t.bg = t:CreateTexture(nil,"BACKGROUND")
        t.bg:SetAllPoints()
        t.bg:SetTexture("Interface\\ChatFrame\\ChatFrameBackground")
        t.bg:SetVertexColor(0.09, 0.07, 0.02, 1)

        -- bottom accent line (gold when active)
        t.accent = t:CreateTexture(nil,"OVERLAY")
        t.accent:SetTexture("Interface\\ChatFrame\\ChatFrameBackground")
        t.accent:SetPoint("BOTTOMLEFT",  t, "BOTTOMLEFT",  0, 0)
        t.accent:SetPoint("BOTTOMRIGHT", t, "BOTTOMRIGHT", 0, 0)
        t.accent:SetHeight(2)
        t.accent:SetVertexColor(0.55, 0.42, 0.06, 0.6)

        t.fs = t:CreateFontString(nil,"OVERLAY","GameFontNormalSmall")
        t.fs:SetAllPoints()
        t.fs:SetJustifyH("CENTER")
        t.fs:SetText(label)

        t.SetActive = function(self, active)
            if active then
                self.bg:SetVertexColor(0.18, 0.14, 0.05, 1)
                self.accent:SetVertexColor(0.85, 0.65, 0.10, 1)
                self.fs:SetTextColor(1, 0.82, 0.0)
            else
                self.bg:SetVertexColor(0.09, 0.07, 0.02, 1)
                self.accent:SetVertexColor(0.35, 0.27, 0.05, 0.5)
                self.fs:SetTextColor(0.70, 0.60, 0.35)
            end
        end
        t:SetActive(false)

        t:SetScript("OnEnter", function(self)
            if not self._active then
                self.bg:SetVertexColor(0.14, 0.11, 0.03, 1)
            end
        end)
        t:SetScript("OnLeave", function(self)
            if not self._active then
                self.bg:SetVertexColor(0.09, 0.07, 0.02, 1)
            end
        end)
        return t
    end

    local tabWishlist = MakeTab("Wishlist",     "TOPLEFT", f, "TOPLEFT", 16)
    tabWishlist:SetPoint("TOPLEFT", f, "TOPLEFT", 16, TAB_Y)
    local tabSearch   = MakeTab("Search Drops", "LEFT", tabWishlist, "RIGHT", 4)

    -- thin gold line under tabs
    local tabDiv = f:CreateTexture(nil,"ARTWORK")
    tabDiv:SetTexture("Interface\\ChatFrame\\ChatFrameBackground")
    tabDiv:SetHeight(1)
    tabDiv:SetPoint("TOPLEFT",  f, "TOPLEFT",  5, TAB_Y - 23)
    tabDiv:SetPoint("TOPRIGHT", f, "TOPRIGHT", -5, TAB_Y - 23)
    tabDiv:SetVertexColor(0.55, 0.42, 0.06, 0.6)

    -- ── WISHLIST PANEL ────────────────────────────────────────
    local wishPanel = CreateFrame("Frame", nil, f)
    wishPanel:SetPoint("TOPLEFT",     f, "TOPLEFT",   0, TAB_Y - 26)
    wishPanel:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", 0, 28)

    -- Add-item bar
    local addLabel = wishPanel:CreateFontString(nil,"OVERLAY","GameFontNormal")
    addLabel:SetPoint("TOPLEFT", wishPanel, "TOPLEFT", 16, -6)
    addLabel:SetText("|cffC8A96EAdd:|r")

    local addBox = CreateFrame("EditBox","EWAddItemBox", wishPanel,"InputBoxTemplate")
    addBox:SetSize(200,20); addBox:SetPoint("LEFT", addLabel, "RIGHT", 4, 0)
    addBox:SetAutoFocus(false)

    local addBtn = CreateFrame("Button", nil, wishPanel)
    addBtn:SetSize(46, 20); addBtn:SetPoint("LEFT", addBox, "RIGHT", 4, 0)
    addBtn:SetBackdrop({
        bgFile="Interface\\ChatFrame\\ChatFrameBackground",
        edgeFile="Interface\\ChatFrame\\ChatFrameBackground",
        edgeSize=1, insets={left=1,right=1,top=1,bottom=1},
    })
    addBtn:SetBackdropColor(0.18, 0.14, 0.04, 1)
    addBtn:SetBackdropBorderColor(0.55, 0.42, 0.06, 0.9)
    local addBtnFS = addBtn:CreateFontString(nil,"OVERLAY","GameFontNormalSmall")
    addBtnFS:SetAllPoints(); addBtnFS:SetJustifyH("CENTER")
    addBtnFS:SetText("|cffC8A96EAdd|r")
    addBtn:SetScript("OnEnter", function(s) s:SetBackdropColor(0.28,0.22,0.06,1); s:SetBackdropBorderColor(0.85,0.65,0.10,1) end)
    addBtn:SetScript("OnLeave", function(s) s:SetBackdropColor(0.18,0.14,0.04,1); s:SetBackdropBorderColor(0.55,0.42,0.06,0.9) end)
    addBtn:SetScript("OnMouseDown", function(s) s:SetBackdropColor(0.10,0.08,0.02,1) end)
    addBtn:SetScript("OnMouseUp",   function(s) s:SetBackdropColor(0.18,0.14,0.04,1) end)

    -- ── Progress bar row ──────────────────────────────────────
    local pbBar = CreateFrame("Frame", nil, wishPanel)
    pbBar:SetHeight(14)
    pbBar:SetPoint("TOPLEFT",  wishPanel, "TOPLEFT",   16, -31)
    pbBar:SetPoint("TOPRIGHT", wishPanel, "TOPRIGHT",  -32, -31)

    -- Outer border
    local pbBorder = pbBar:CreateTexture(nil,"BACKGROUND")
    pbBorder:SetAllPoints()
    pbBorder:SetTexture("Interface\\ChatFrame\\ChatFrameBackground")
    pbBorder:SetVertexColor(0.45, 0.34, 0.05, 1)

    -- Dark inner background (inset 1px)
    local pbBgTex = pbBar:CreateTexture(nil,"ARTWORK")
    pbBgTex:SetTexture("Interface\\ChatFrame\\ChatFrameBackground")
    pbBgTex:SetPoint("TOPLEFT",     pbBar, "TOPLEFT",     1, -1)
    pbBgTex:SetPoint("BOTTOMRIGHT", pbBar, "BOTTOMRIGHT", -1, 1)
    pbBgTex:SetVertexColor(0.06, 0.05, 0.02, 1)

    local pbFill = pbBar:CreateTexture(nil,"OVERLAY")
    pbFill:SetTexture("Interface\\ChatFrame\\ChatFrameBackground")
    pbFill:SetPoint("TOPLEFT",    pbBar, "TOPLEFT",    1, -1)
    pbFill:SetPoint("BOTTOMLEFT", pbBar, "BOTTOMLEFT", 1,  1)
    pbFill:SetWidth(1)
    pbFill:SetVertexColor(0.12, 0.65, 0.18, 1)

    -- Bright top-edge highlight on fill
    local pbShine = pbBar:CreateTexture(nil,"OVERLAY",nil,1)
    pbShine:SetTexture("Interface\\ChatFrame\\ChatFrameBackground")
    pbShine:SetPoint("TOPLEFT",  pbFill, "TOPLEFT",  0,  0)
    pbShine:SetPoint("TOPRIGHT", pbFill, "TOPRIGHT", 0,  0)
    pbShine:SetHeight(3)
    pbShine:SetVertexColor(0.40, 1.0, 0.45, 0.35)

    local pbLabel = pbBar:CreateFontString(nil,"OVERLAY","GameFontNormalSmall")
    pbLabel:SetPoint("TOPLEFT",     pbBar, "TOPLEFT",     1, -1)
    pbLabel:SetPoint("BOTTOMRIGHT", pbBar, "BOTTOMRIGHT", -1, 1)
    pbLabel:SetJustifyH("CENTER")
    pbLabel:SetFont("Fonts\\FRIZQT__.TTF", 9, "OUTLINE")
    pbLabel:SetTextColor(1, 1, 1, 1)

    local pbFrac = 0
    local function UpdateProgressBar(list)
        if not list or #list == 0 then
            pbFrac = 0; pbFill:SetWidth(1); pbShine:SetWidth(1)
            pbLabel:SetText(""); return
        end
        local total, got = #list, 0
        for _, e in ipairs(list) do if e.obtained then got = got + 1 end end
        pbFrac = got / total
        local w = pbBar:GetWidth() - 2
        local fw = w > 0 and math.max(1, w * pbFrac) or 1
        pbFill:SetWidth(fw)
        pbShine:SetWidth(fw)
        -- Colour shifts green → gold as you near completion
        local r = math.min(1, pbFrac * 2)
        local g = math.min(1, 0.65 + pbFrac * 0.35)
        pbFill:SetVertexColor(r * 0.5, g, r * 0.1 + 0.15, 1)
        pbLabel:SetText(string.format("|cffFFFFFF%d|r / %d obtained", got, total))
    end

    pbBar:SetScript("OnSizeChanged", function(self, w)
        if w > 0 then
            local fw = math.max(1, (w-2) * pbFrac)
            pbFill:SetWidth(fw); pbShine:SetWidth(fw)
        end
    end)

    -- ── Sort / filter toolbar ─────────────────────────────────
    -- State
    local sortMode    = "manual"   -- "manual" | "priority" | "slot" | "obtained"
    local hideObtained = false

    local sfBg = wishPanel:CreateTexture(nil,"BACKGROUND")
    sfBg:SetTexture("Interface\\ChatFrame\\ChatFrameBackground"); sfBg:SetHeight(18)
    sfBg:SetPoint("TOPLEFT",  wishPanel, "TOPLEFT",   16, -43)
    sfBg:SetPoint("TOPRIGHT", wishPanel, "TOPRIGHT", -32, -43)
    sfBg:SetVertexColor(0.12, 0.09, 0.04, 0.7)

    local function SortBtn(label, anchor, xOff, tip)
        local b = CreateFrame("Button", nil, wishPanel)
        b:SetSize(58, 16)
        b:SetPoint("LEFT", anchor, "RIGHT", xOff, 0)
        b:SetBackdrop({
            bgFile="Interface\\ChatFrame\\ChatFrameBackground",
            edgeFile="Interface\\ChatFrame\\ChatFrameBackground",
            edgeSize=1, insets={left=1,right=1,top=1,bottom=1},
        })
        b:SetBackdropColor(0.18, 0.14, 0.04, 1)
        b:SetBackdropBorderColor(0.55, 0.42, 0.06, 0.9)
        local fs = b:CreateFontString(nil,"OVERLAY")
        fs:SetAllPoints(); fs:SetJustifyH("CENTER")
        fs:SetFont("Fonts\\FRIZQT__.TTF", 9, "OUTLINE")
        fs:SetTextColor(0.78, 0.67, 0.40)
        fs:SetText(label)
        b.fs = fs
        b:SetScript("OnEnter", function(s)
            s:SetBackdropColor(0.28,0.22,0.06,1)
            s:SetBackdropBorderColor(0.85,0.65,0.10,1)
            s.fs:SetTextColor(1, 0.82, 0.0)
            if tip then GameTooltip:SetOwner(s,"ANCHOR_RIGHT"); GameTooltip:SetText(tip); GameTooltip:Show() end
        end)
        b:SetScript("OnLeave", function(s)
            s:SetBackdropColor(0.18,0.14,0.04,1)
            s:SetBackdropBorderColor(0.55,0.42,0.06,0.9)
            s.fs:SetTextColor(0.78, 0.67, 0.40)
            GameTooltip:Hide()
        end)
        b:SetScript("OnMouseDown", function(s) s:SetBackdropColor(0.10,0.08,0.02,1) end)
        b:SetScript("OnMouseUp",   function(s) s:SetBackdropColor(0.18,0.14,0.04,1) end)
        return b
    end

    local sortLabel = wishPanel:CreateFontString(nil,"OVERLAY","GameFontNormalSmall")
    sortLabel:SetPoint("LEFT", wishPanel, "LEFT", 18, 0)
    sortLabel:SetPoint("TOP",  sfBg, "TOP", 0, -1)
    sortLabel:SetPoint("BOTTOM", sfBg, "BOTTOM", 0, 1)
    sortLabel:SetText("|cff9a7a32Sort:|r")

    local btnPriority = SortBtn("Priority", sortLabel,   2, "Sort by priority (highest first)")
    local btnSlot     = SortBtn("Slot",     btnPriority, 2, "Sort by equipment slot")
    local btnObtained = SortBtn("Obtained", btnSlot,     2, "Sort: unobtained first")
    local btnManual   = SortBtn("Manual",   btnObtained, 2, "Restore manual drag order")

    local hideBtn = CreateFrame("Button", nil, wishPanel)
    hideBtn:SetSize(86, 16)
    hideBtn:SetPoint("RIGHT",  wishPanel, "RIGHT", -34, 0)
    hideBtn:SetPoint("TOP",    sfBg, "TOP",    0, -1)
    hideBtn:SetPoint("BOTTOM", sfBg, "BOTTOM", 0,  1)
    hideBtn:SetBackdrop({
        bgFile="Interface\\ChatFrame\\ChatFrameBackground",
        edgeFile="Interface\\ChatFrame\\ChatFrameBackground",
        edgeSize=1, insets={left=1,right=1,top=1,bottom=1},
    })
    hideBtn:SetBackdropColor(0.18, 0.14, 0.04, 1)
    hideBtn:SetBackdropBorderColor(0.55, 0.42, 0.06, 0.9)
    local hideBtnFS = hideBtn:CreateFontString(nil,"OVERLAY")
    hideBtnFS:SetAllPoints(); hideBtnFS:SetJustifyH("CENTER")
    hideBtnFS:SetFont("Fonts\\FRIZQT__.TTF", 9, "OUTLINE")
    hideBtnFS:SetTextColor(0.78, 0.67, 0.40)
    hideBtn.fs = hideBtnFS
    hideBtn:SetScript("OnEnter", function(s) s:SetBackdropColor(0.28,0.22,0.06,1); s:SetBackdropBorderColor(0.85,0.65,0.10,1); s.fs:SetTextColor(1,0.82,0) end)
    hideBtn:SetScript("OnLeave", function(s) s:SetBackdropColor(0.18,0.14,0.04,1); s:SetBackdropBorderColor(0.55,0.42,0.06,0.9); s.fs:SetTextColor(0.78,0.67,0.40) end)
    hideBtn:SetScript("OnMouseDown", function(s) s:SetBackdropColor(0.10,0.08,0.02,1) end)
    hideBtn:SetScript("OnMouseUp",   function(s) s:SetBackdropColor(0.18,0.14,0.04,1) end)

    local function UpdateHideBtnText()
        hideBtn.fs:SetText(hideObtained and "Show All" or "Hide Obtained")
    end
    UpdateHideBtnText()

    hideBtn:SetScript("OnClick", function()
        hideObtained = not hideObtained
        UpdateHideBtnText()
        RefreshItemRows()
    end)

    -- Column headers  (shifted down: -63 instead of -30, to sit below sort bar)
    local hdrBg = wishPanel:CreateTexture(nil,"ARTWORK")
    hdrBg:SetTexture("Interface\\ChatFrame\\ChatFrameBackground"); hdrBg:SetHeight(15)
    hdrBg:SetPoint("TOPLEFT",  wishPanel, "TOPLEFT",   16, -63)
    hdrBg:SetPoint("TOPRIGHT", wishPanel, "TOPRIGHT", -32, -63)
    hdrBg:SetVertexColor(0.15,0.11,0.04,0.9)

    local hdrItem = wishPanel:CreateFontString(nil,"OVERLAY","GameFontNormalSmall")
    hdrItem:SetPoint("TOPLEFT", wishPanel, "TOPLEFT", 36, -63)
    hdrItem:SetText("|cff9a7a32Item|r")

    local hdrPri = wishPanel:CreateFontString(nil,"OVERLAY","GameFontNormalSmall")
    hdrPri:SetPoint("TOPRIGHT", wishPanel, "TOPRIGHT", -300, -63)
    hdrPri:SetText("|cff9a7a32Pri|r")

    local hdrDrop = wishPanel:CreateFontString(nil,"OVERLAY","GameFontNormalSmall")
    hdrDrop:SetPoint("TOPRIGHT", wishPanel, "TOPRIGHT", -228, -63)
    hdrDrop:SetText("|cff9a7a32Drop Source|r")

    local hdrChance = wishPanel:CreateFontString(nil,"OVERLAY","GameFontNormalSmall")
    hdrChance:SetPoint("TOPRIGHT", wishPanel, "TOPRIGHT", -22, -63)
    hdrChance:SetWidth(46); hdrChance:SetJustifyH("RIGHT")
    hdrChance:SetText("|cff9a7a32Chance|r")

    -- Scroll frame (wishlist items) — shifted down to make room for progress + sort bars
    local sf = CreateFrame("ScrollFrame","EWScrollFrame", wishPanel,"UIPanelScrollFrameTemplate")
    sf:SetPoint("TOPLEFT",     wishPanel, "TOPLEFT",    16, -80)
    sf:SetPoint("BOTTOMRIGHT", wishPanel, "BOTTOMRIGHT",-32,  0)

    local content = CreateFrame("Frame", nil, sf)
    content:SetSize(sf:GetWidth(), 1)
    sf:SetScrollChild(content)

    -- Status bar (anchored to main frame bottom)
    local statusFS = f:CreateFontString(nil,"OVERLAY","GameFontNormalSmall")
    statusFS:SetPoint("BOTTOMLEFT",  f, "BOTTOMLEFT",   16, 8)
    statusFS:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -16, 8)
    statusFS:SetJustifyH("CENTER"); statusFS:SetTextColor(0.7,0.65,0.4)
    f.statusText = statusFS

    -- Resize grip
    local grip = CreateFrame("Button", nil, f)
    grip:SetSize(16,16); grip:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -2, 2)
    grip:SetNormalTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Up")
    grip:SetHighlightTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Highlight")
    grip:SetPushedTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Down")
    grip:SetScript("OnMouseDown", function() f:StartSizing("BOTTOMRIGHT") end)
    grip:SetScript("OnMouseUp", function()
        f:StopMovingOrSizing()
        db.windowSize.w = f:GetWidth(); db.windowSize.h = f:GetHeight()
        content:SetWidth(sf:GetWidth())
        RefreshItemRows()
    end)

    -- ── Row pool ─────────────────────────────────────────────
    local rowPool, activeRows = {}, {}

    local function GetRow()
        local row = table.remove(rowPool)
        if not row then
            row = CreateFrame("Button", nil, content)
            row:SetHeight(ROW_HEIGHT)
            row:RegisterForDrag("LeftButton"); row:SetMovable(true)

            -- Row background (set per-row in render loop)
            row.rowBg = row:CreateTexture(nil,"BACKGROUND")
            row.rowBg:SetAllPoints()
            row.rowBg:SetTexture("Interface\\ChatFrame\\ChatFrameBackground")
            row.rowBg:SetVertexColor(0,0,0,0)

            -- Left accent bar (quality colour strip)
            row.accentBar = row:CreateTexture(nil,"BORDER")
            row.accentBar:SetTexture("Interface\\ChatFrame\\ChatFrameBackground")
            row.accentBar:SetWidth(3)
            row.accentBar:SetPoint("TOPLEFT",    row, "TOPLEFT",  0, 0)
            row.accentBar:SetPoint("BOTTOMLEFT", row, "BOTTOMLEFT", 0, 0)
            row.accentBar:SetVertexColor(0.5, 0.5, 0.5, 0)

            -- Highlight on hover
            local hl = row:CreateTexture(nil,"HIGHLIGHT")
            hl:SetAllPoints()
            hl:SetTexture("Interface\\ChatFrame\\ChatFrameBackground")
            hl:SetVertexColor(0.72, 0.56, 0.08, 0.08)

            row.icon = row:CreateTexture(nil,"ARTWORK")
            row.icon:SetSize(ROW_HEIGHT-4, ROW_HEIGHT-4)
            row.icon:SetPoint("LEFT", row, "LEFT", 6, 0)
            row.icon:SetTexCoord(0.08,0.92,0.08,0.92)

            -- Thin icon border
            row.iconBorder = row:CreateTexture(nil,"OVERLAY")
            row.iconBorder:SetTexture("Interface\\ChatFrame\\ChatFrameBackground")
            row.iconBorder:SetSize(ROW_HEIGHT-2, ROW_HEIGHT-2)
            row.iconBorder:SetPoint("CENTER", row.icon, "CENTER")
            row.iconBorder:SetVertexColor(0,0,0,0)

            -- Green check overlay shown when item is obtained
            row.check = row:CreateTexture(nil,"OVERLAY")
            row.check:SetSize(ROW_HEIGHT-4, ROW_HEIGHT-4)
            row.check:SetPoint("LEFT", row, "LEFT", 6, 0)
            row.check:SetTexture("Interface\\RaidFrame\\ReadyCheck-Ready")
            row.check:Hide()

            -- Priority badge (small number left of drop source column)
            row.priBadge = row:CreateFontString(nil,"OVERLAY","GameFontNormalSmall")
            row.priBadge:SetPoint("RIGHT", row, "RIGHT", -298, 0)
            row.priBadge:SetWidth(20); row.priBadge:SetJustifyH("CENTER")

            -- Item name: left portion, ends before priority badge
            row.link = row:CreateFontString(nil,"OVERLAY","GameFontNormal")
            row.link:SetPoint("LEFT",  row.icon, "RIGHT", 6, 2)
            row.link:SetPoint("RIGHT", row, "RIGHT", -322, 0)
            row.link:SetJustifyH("LEFT"); row.link:SetWordWrap(false)

            row.slotLabel = row:CreateFontString(nil,"OVERLAY","GameFontNormalSmall")
            row.slotLabel:SetPoint("BOTTOMLEFT", row.icon, "BOTTOMRIGHT", 6, -1)
            row.slotLabel:SetTextColor(0.5,0.45,0.28)

            -- Drop source: middle column, anchored from both sides
            row.dropText = row:CreateFontString(nil,"OVERLAY","GameFontNormalSmall")
            row.dropText:SetPoint("LEFT",  row, "RIGHT", -228, 0)
            row.dropText:SetPoint("RIGHT", row, "RIGHT",  -68, 0)
            row.dropText:SetJustifyH("LEFT"); row.dropText:SetWordWrap(false)

            -- Chance: 44px wide, right of drop source, before X button
            row.chanceText = row:CreateFontString(nil,"OVERLAY","GameFontNormalSmall")
            row.chanceText:SetPoint("RIGHT", row, "RIGHT", -22, 0)
            row.chanceText:SetWidth(44); row.chanceText:SetJustifyH("RIGHT")

            row.removeBtn = CreateFrame("Button", nil, row, "UIPanelCloseButton")
            row.removeBtn:SetSize(20,20); row.removeBtn:SetPoint("RIGHT", row, "RIGHT", -2, 0)
        end
        return row
    end

    local function ReleaseRow(row)
        row:Hide(); row:ClearAllPoints()
        row._itemId = nil
        table.insert(rowPool, row)
    end

    -- ── RefreshItemRows ──────────────────────────────────────
    local AutoQueryVisible  -- defined after RefreshItemRows; used inside it
    RefreshItemRows = function()
        for _, row in ipairs(activeRows) do ReleaseRow(row) end
        wipe(activeRows)

        local active = db.activeList
        local list   = active and db.lists[active]
        if not list then
            content:SetHeight(1)
            statusFS:SetText("|cff888888No list selected.|r")
            UpdateProgressBar(nil)
            RefreshListDropdown()
            return
        end

        UpdateProgressBar(list)

        -- Build display list (apply filter + sort)
        local display = {}
        for idx, entry in ipairs(list) do
            if not (hideObtained and entry.obtained) then
                display[#display+1] = { entry=entry, origIdx=idx }
            end
        end

        if sortMode == "priority" then
            table.sort(display, function(a, b)
                local pa = a.entry.priority or 0
                local pb = b.entry.priority or 0
                if pa ~= pb then return pa > pb end
                return a.origIdx < b.origIdx
            end)
        elseif sortMode == "slot" then
            table.sort(display, function(a, b)
                local _,_,_,_,_,_,_,_,sA = GetItemInfo(a.entry.itemId)
                local _,_,_,_,_,_,_,_,sB = GetItemInfo(b.entry.itemId)
                sA = sA or ""; sB = sB or ""
                if sA ~= sB then return sA < sB end
                return a.origIdx < b.origIdx
            end)
        elseif sortMode == "obtained" then
            table.sort(display, function(a, b)
                local oa = a.entry.obtained and 1 or 0
                local ob = b.entry.obtained and 1 or 0
                if oa ~= ob then return oa < ob end
                return a.origIdx < b.origIdx
            end)
        end
        -- "manual" = keep display order as-is

        local count = #display
        content:SetWidth(sf:GetWidth() - 4)
        content:SetHeight(math.max(count * ROW_HEIGHT + PAD, 1))

        for i, rec in ipairs(display) do
            local entry   = rec.entry
            local rowIndex = rec.origIdx   -- used for MoveItem (always refers to real list)

            local row = GetRow()
            row:SetParent(content); row:ClearAllPoints()
            row:SetPoint("TOPLEFT",  content, "TOPLEFT",  0, -(i-1)*ROW_HEIGHT - PAD)
            row:SetPoint("TOPRIGHT", content, "TOPRIGHT", 0, -(i-1)*ROW_HEIGHT - PAD)
            row:SetHeight(ROW_HEIGHT); row:Show()

            if i % 2 == 0 then
                row.rowBg:SetVertexColor(0.10, 0.08, 0.03, 0.55)
            else
                row.rowBg:SetVertexColor(0.07, 0.055, 0.02, 0.3)
            end

            local _,_,quality,itemLvl,_,_,itemSubType,_,equipLoc,texture =
                GetItemInfo(entry.itemId)
            row.icon:SetTexture(texture or "Interface\\Icons\\INV_Misc_QuestionMark")

            -- Accent bar colour matches item quality
            local qc = QUALITY_COLOR[quality or 1] or QUALITY_COLOR[1]
            -- parse hex from color code string "|cffRRGGBB"
            local qs = qc:match("|cff(%x%x%x%x%x%x)")
            if qs then
                local r = tonumber(qs:sub(1,2),16)/255
                local g = tonumber(qs:sub(3,4),16)/255
                local b = tonumber(qs:sub(5,6),16)/255
                row.accentBar:SetVertexColor(r, g, b, obtained and 0.3 or 0.7)
            else
                row.accentBar:SetVertexColor(0.5, 0.5, 0.5, 0.4)
            end

            -- Obtained state: dim icon, grey out text, show check
            local obtained = entry.obtained
            if obtained then
                row.icon:SetVertexColor(0.4, 0.4, 0.4)
                row.check:Show()
            else
                row.icon:SetVertexColor(1, 1, 1)
                row.check:Hide()
            end

            local linkText = entry.itemLink or (QualityColor(quality or 1).."Item #"..entry.itemId.."|r")
            if obtained then
                linkText = "|cff666666"..linkText:gsub("|c%x%x%x%x%x%x%x%x",""):gsub("|r","").."|r"
            end
            row.link:SetText(linkText)

            -- Priority badge
            local pri = entry.priority or 0
            if pri > 0 then
                local priCol = pri >= 4 and "|cffFF4444"
                            or pri >= 3 and "|cffFF9933"
                            or pri >= 2 and "|cffffff00"
                            or              "|cff888888"
                row.priBadge:SetText(priCol..pri.."|r")
            else
                row.priBadge:SetText("")
            end

            local slotStr = (equipLoc and equipLoc ~= "") and (_G[equipLoc] or "") or ""
            row.slotLabel:SetText(slotStr ~= "" and ("|cff666644"..slotStr.."|r") or "")

            local drop = EpochDropInfo(entry.itemId)
            if drop then
                row.dropText:SetText("|cffA09060"..drop.source.."|r")
                if drop.chance then
                    local c   = drop.chance
                    local col = c >= 50 and "|cff00FF00"
                             or c >= 15 and "|cffffff00"
                             or c >=  5 and "|cffFF9933"
                             or              "|cffFF4444"
                    local cStr = c < 0.1 and string.format("%.2f", c) or string.format("%.1f", c)
                    row.chanceText:SetText(string.format("%s%s%%|r", col, cStr))
                else
                    row.chanceText:SetText("|cff555555—|r")
                end
            else
                row.dropText:SetText("|cff444444—|r")
                row.chanceText:SetText("")
            end

            local entryRef  = entry
            local rowItemId = entry.itemId
            row._itemId     = rowItemId
            -- rowIndex is already set from rec.origIdx above

            row.removeBtn:SetScript("OnClick", function()
                RemoveItem(active, rowItemId); RefreshItemRows()
            end)

            row:RegisterForClicks("LeftButtonUp","RightButtonUp")
            row:SetScript("OnClick", function(self, button)
                if button == "LeftButton" then
                    entryRef.obtained = not entryRef.obtained or nil
                    RefreshItemRows()
                    return
                end
                if button ~= "RightButton" then return end
                ContextMenu.Close()

                local listLen = #(db.lists[active] or {})
                local items   = {}

                items[#items+1] = {isTitle=true,
                    text = entry.itemLink or ("|cffFFD700Item #"..rowItemId.."|r")}
                if itemLvl and itemLvl > 0 then
                    items[#items+1] = {isTitle=true,
                        text=string.format("|cff888888iLvl %d  %s|r", itemLvl, itemSubType or "")}
                end
                items[#items+1] = {isSep=true}
                items[#items+1] = {
                    text = entryRef.obtained and "|cff00CC44Mark as Needed|r" or "|cff888888Mark as Obtained|r",
                    func = function()
                        entryRef.obtained = not entryRef.obtained or nil
                        RefreshItemRows()
                    end,
                }
                -- Priority picker
                local curPri = entryRef.priority or 0
                local priLabels = {
                    [0]="|cff888888None|r",
                    [1]="|cff888888P1 - Low|r",
                    [2]="|cffffff00P2 - Normal|r",
                    [3]="|cffFF9933P3 - High|r",
                    [4]="|cffFF4444P4 - Must Have|r",
                    [5]="|cffFF0000P5 - Prio|r",
                }
                for p = 0, 5 do
                    local pv = p
                    items[#items+1] = {
                        text = (curPri==pv and "> " or "  ")..priLabels[pv],
                        func = function()
                            entryRef.priority = pv > 0 and pv or nil
                            RefreshItemRows()
                        end,
                    }
                end
                items[#items+1] = {isSep=true}
                items[#items+1] = {
                    text = entryRef.note ~= "" and "Edit Note" or "Add Note",
                    func = function()
                        StaticPopup_Show("EW_EDIT_NOTE",nil,nil,
                            {listName=active,itemId=rowItemId,note=entryRef.note})
                    end,
                }
                items[#items+1] = {
                    text="Move to Top", disabled=(rowIndex==1),
                    func=function() MoveItem(active,rowIndex,1); RefreshItemRows() end,
                }
                items[#items+1] = {
                    text="Move to Bottom", disabled=(rowIndex==listLen),
                    func=function() MoveItem(active,rowIndex,listLen); RefreshItemRows() end,
                }
                local others = {}
                for _, ln in ipairs(GetListNames()) do
                    if ln ~= active then others[#others+1] = ln end
                end
                if #others > 0 then
                    items[#items+1] = {isSep=true}
                    for _, tl in ipairs(others) do
                        local target = tl
                        items[#items+1] = {
                            text = "Copy to: "..target,
                            func = function()
                                local _,lk = GetItemInfo(rowItemId)
                                AddItem(target, rowItemId, lk or entryRef.itemLink, entryRef.note)
                                Print("Copied to |cffFFD700"..target.."|r.")
                            end,
                        }
                    end
                end
                items[#items+1] = {isSep=true}
                items[#items+1] = {
                    text="Remove from list", color="|cffFF5555",
                    func=function() RemoveItem(active,rowItemId); RefreshItemRows() end,
                }
                ContextMenu.Open(self, items)
            end)

            row:SetScript("OnDragStart", function(self)
                self.dragStartY    = select(2, GetCursorPosition())
                self.dragOrigIndex = rowIndex
            end)
            row:SetScript("OnDragStop", function(self)
                local _, curY = GetCursorPosition()
                local scale   = UIParent:GetEffectiveScale()
                local steps   = math.floor((self.dragStartY-curY)/scale/ROW_HEIGHT + 0.5)
                if steps ~= 0 then
                    MoveItem(active, self.dragOrigIndex, self.dragOrigIndex+steps)
                    RefreshItemRows()
                end
            end)

            row:SetScript("OnEnter", function(self)
                ShowItemTooltip(self, entryRef.itemLink, rowItemId)
            end)
            row:SetScript("OnLeave", function() GameTooltip:Hide() end)

            table.insert(activeRows, row)
        end

        statusFS:SetText(string.format(
            "|cffC8A96E%s|r  |cffFFD700%d|r item%s",
            active, count, count==1 and "" or "s"))
        RefreshListDropdown()
        RefreshCellChecks()
        C_Timer.After(0, AutoQueryVisible)  -- run after layout settles
    end

    -- Auto-query: forward declared so RefreshItemRows can call it
    local autoQueryPending = {}  -- kept for scroll hook dedup (unused now, FetchItem deduplicates)
    local autoQueryFrame   = CreateFrame("Frame")  -- kept for legacy compat
    local function SetSort(mode)
        sortMode = mode
        RefreshItemRows()
    end
    btnPriority:SetScript("OnClick", function() SetSort("priority") end)
    btnSlot:SetScript("OnClick",     function() SetSort("slot")     end)
    btnObtained:SetScript("OnClick", function() SetSort("obtained") end)
    btnManual:SetScript("OnClick",   function() SetSort("manual")   end)

    -- Define AutoQueryVisible now that activeRows and sf exist
    AutoQueryVisible = function()
        local sfTop    = sf:GetTop()
        local sfBottom = sf:GetBottom()
        if not sfTop then return end

        for _, row in ipairs(activeRows) do
            local rTop = row:GetTop()
            if rTop and rTop <= sfTop and rTop >= sfBottom then
                local id = row._itemId
                if id and not GetItemInfo(id) then
                    FetchItem(id, function(receivedId)
                        local active = db.activeList
                        local list   = active and db.lists[active]
                        if list then
                            local _, lk = GetItemInfo(receivedId)
                            if lk then
                                for _, e in ipairs(list) do
                                    if e.itemId == receivedId and
                                       (not e.itemLink or e.itemLink:find("Item #")) then
                                        e.itemLink = lk
                                    end
                                end
                            end
                        end
                        RefreshItemRows()
                    end)
                end
            end
        end
    end

    sf:SetScript("OnVerticalScroll", function(self, offset)
        self:SetVerticalScroll(offset)
        AutoQueryVisible()
    end)

    -- DoAdd (wishlist add-item logic)
    local function DoAdd()
        local text = addBox:GetText()
        if not text or text == "" then return end
        local itemId = tonumber(text:match("item:(%d+)") or text:match("^%d+$"))
        if not itemId then Print("|cffFF4444Paste an item link or enter an item ID.|r"); return end
        if not db.activeList then Print("|cffFF4444Select or create a list first.|r"); return end

        local _, itemLink = GetItemInfo(itemId)
        if not itemLink then
            itemLink = "|cff0070dd[Item #"..itemId.."]|r"
            local rf = CreateFrame("Frame")
            rf:RegisterEvent("GET_ITEM_INFO_RECEIVED")
            rf:SetScript("OnEvent", function(self2, _, id)
                if id ~= itemId then return end
                local _, lk = GetItemInfo(id)
                if lk then
                    local lst = db.lists[db.activeList]
                    if lst then
                        for _, e in ipairs(lst) do
                            if e.itemId == id then e.itemLink = lk end
                        end
                    end
                    if mainFrame and mainFrame:IsShown() then RefreshItemRows() end
                end
                self2:UnregisterAllEvents()
            end)
        end
        local ok, err = AddItem(db.activeList, itemId, itemLink, "")
        if ok then addBox:SetText(""); RefreshItemRows()
        else Print("|cffFF4444"..(err or "Error").."|r") end
    end

    addBox:SetScript("OnEnterPressed", DoAdd)
    addBtn:SetScript("OnClick", DoAdd)
    addBox:SetScript("OnEnter", function(s)
        GameTooltip:SetOwner(s,"ANCHOR_RIGHT")
        GameTooltip:SetText("Shift-click an item link or type an ID, then press Enter.")
        GameTooltip:Show() end)
    addBox:SetScript("OnLeave", function() GameTooltip:Hide() end)
    addBox:SetScript("OnReceiveDrag", function(self)
        local t, id, link = GetCursorInfo()
        if t == "item" then self:SetText(link or tostring(id)); ClearCursor() end end)

    -- ── SEARCH PANEL  (AtlasLoot-style browser) ──────────────
    --
    --  Top of left pane: dropdown to pick  Raids | Dungeons
    --  Body of left pane: zone list → expand to see bosses
    --  Right pane: icon grid for selected boss
    -- ──────────────────────────────────────────────────────────

    local searchPanel = CreateFrame("Frame", nil, f)
    searchPanel:SetPoint("TOPLEFT",     f, "TOPLEFT",   0, TAB_Y - 26)
    searchPanel:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", 0, 28)
    searchPanel:Hide()

    -- ── Constants ─────────────────────────────────────────────
    local ICON_SIZE  = 42
    local ICON_COLS  = 4
    local ICON_PAD   = 6
    local LEFT_W     = 160
    local ZONE_H     = 22
    local BOSS_H     = 20
    local L_PAD      = 4
    local QUALITY_BORDER = {
        [0]={0.62,0.62,0.62}, [1]={1,1,1},
        [2]={0.12,0.90,0.12}, [3]={0,0.44,0.87},
        [4]={0.64,0.21,0.93}, [5]={1,0.50,0},
        [6]={0.90,0.80,0.50},
    }

    -- ── Classify zones from EW_DROP_DATA ──────────────────────
    local EW_DUNGEON_ZONES = {
        ["The Deadmines"]=true, ["Wailing Caverns"]=true,
        ["Shadowfang Keep"]=true, ["Blackfathom Deeps"]=true,
        ["The Stockade"]=true, ["Gnomeregan"]=true,
        ["Razorfen Kraul"]=true, ["Razorfen Downs"]=true,
        ["SM Graveyard"]=true, ["SM Library"]=true,
        ["SM Armory"]=true, ["SM Cathedral"]=true,
        ["Uldaman"]=true, ["Zul'Farrak"]=true,
        ["Maraudon"]=true, ["Sunken Temple"]=true,
        ["Blackrock Depths"]=true, ["LBRS"]=true, ["UBRS"]=true,
        ["DM East"]=true, ["DM West"]=true, ["DM North"]=true,
        ["Stratholme"]=true, ["Scholomance"]=true,
        ["Glittermurk Mines"]=true, ["Baradin Hold"]=true,
        ["Ragefire Chasm"]=true,
    }

    local EW_BROWSE_DATA = {}  -- [zone][boss] = {itemId,...}
    local EW_BOSS_ORDER  = {}  -- [zone] = {boss,...} sorted
    local EW_RAID_ZONES  = {}
    local EW_DUNG_ZONES  = {}
    local EW_SET_ZONES   = {}  -- sets & collections
    local _zoneSet       = {}

    -- Zones that are sets/collections (not raid/dungeon content)
    local EW_COLLECTION_ZONES = {
        ["Tier 0"]          = true,
        ["Tier 0.5"]        = true,
        ["Tier 1"]          = true,
        ["BoE World Drops"] = true,
        ["Rune Warder Set"] = true,
        ["Fang Set"]        = true,
        ["Uldic Set"]       = true,
    }

    for itemId, info in pairs(EW_DROP_DATA) do
        if info and info.source then
            local boss, zone = info.source:match("^(.-)%s+—%s+(.+)$")
            boss = boss or info.source
            zone = zone or "Unknown"
            if not EW_BROWSE_DATA[zone] then
                EW_BROWSE_DATA[zone] = {}
                EW_BOSS_ORDER[zone]  = {}
                if not _zoneSet[zone] then
                    _zoneSet[zone] = true
                    if EW_COLLECTION_ZONES[zone] then
                        EW_SET_ZONES[#EW_SET_ZONES+1] = zone
                    elseif EW_DUNGEON_ZONES[zone] then
                        EW_DUNG_ZONES[#EW_DUNG_ZONES+1] = zone
                    else
                        EW_RAID_ZONES[#EW_RAID_ZONES+1] = zone
                    end
                end
            end
            if not EW_BROWSE_DATA[zone][boss] then
                EW_BROWSE_DATA[zone][boss] = {}
                EW_BOSS_ORDER[zone][#EW_BOSS_ORDER[zone]+1] = boss
            end
            EW_BROWSE_DATA[zone][boss][#EW_BROWSE_DATA[zone][boss]+1] = itemId
        end
    end
    table.sort(EW_RAID_ZONES)
    table.sort(EW_DUNG_ZONES)
    -- Keep sets in definition order (T0, T0.5, T1, BoE)
    for _, zone in ipairs(EW_RAID_ZONES) do
        table.sort(EW_BOSS_ORDER[zone])
        for _, items in pairs(EW_BROWSE_DATA[zone]) do table.sort(items) end
    end
    for _, zone in ipairs(EW_DUNG_ZONES) do
        table.sort(EW_BOSS_ORDER[zone])
        for _, items in pairs(EW_BROWSE_DATA[zone]) do table.sort(items) end
    end
    for _, zone in ipairs(EW_SET_ZONES) do
        -- Don't sort boss order for sets — keep class order as defined
        for _, items in pairs(EW_BROWSE_DATA[zone]) do table.sort(items) end
    end

    -- ── Left pane ─────────────────────────────────────────────
    local leftPane = CreateFrame("Frame", nil, searchPanel)
    leftPane:SetPoint("TOPLEFT",    searchPanel, "TOPLEFT",   14, -8)
    leftPane:SetPoint("BOTTOMLEFT", searchPanel, "BOTTOMLEFT", 14,  0)
    leftPane:SetWidth(LEFT_W)
    leftPane:SetBackdrop({
        bgFile   = "Interface\\ChatFrame\\ChatFrameBackground",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        tile=true, tileSize=16, edgeSize=10,
        insets={left=3,right=3,top=3,bottom=3},
    })
    leftPane:SetBackdropColor(0.04,0.03,0.02,0.85)
    leftPane:SetBackdropBorderColor(0.35,0.28,0.08,1)

    -- Category dropdown sits at the very top of the left pane
    local catDD = CreateDropdown(leftPane, LEFT_W - 8)
    catDD:SetPoint("TOPLEFT", leftPane, "TOPLEFT", 4, -4)

    -- Scroll frame for zone/boss list below the dropdown
    local leftSF = CreateFrame("ScrollFrame","EWBrowserLeftScroll",
        leftPane, "UIPanelScrollFrameTemplate")
    leftSF:SetPoint("TOPLEFT",     leftPane, "TOPLEFT",     4, -30)
    leftSF:SetPoint("BOTTOMRIGHT", leftPane, "BOTTOMRIGHT",-20,  4)

    local leftContent = CreateFrame("Frame", nil, leftSF)
    leftContent:SetWidth(leftSF:GetWidth())
    leftContent:SetHeight(1)
    leftSF:SetScrollChild(leftContent)

    -- ── Right pane ────────────────────────────────────────────
    local rightPane = CreateFrame("Frame", nil, searchPanel)
    rightPane:SetPoint("TOPLEFT",     searchPanel, "TOPLEFT",  LEFT_W+22, -8)
    rightPane:SetPoint("BOTTOMRIGHT", searchPanel, "BOTTOMRIGHT", -14,     0)
    rightPane:SetBackdrop({
        bgFile   = "Interface\\ChatFrame\\ChatFrameBackground",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        tile=true, tileSize=16, edgeSize=10,
        insets={left=3,right=3,top=3,bottom=3},
    })
    rightPane:SetBackdropColor(0.03,0.03,0.05,0.85)
    rightPane:SetBackdropBorderColor(0.35,0.28,0.08,1)

    local bossHeader = rightPane:CreateFontString(nil,"OVERLAY","GameFontNormalLarge")
    bossHeader:SetPoint("TOP", rightPane,"TOP", 0,-10)
    bossHeader:SetText("|cff888888Select a boss|r")

    local bossSubHeader = rightPane:CreateFontString(nil,"OVERLAY","GameFontNormalSmall")
    bossSubHeader:SetPoint("TOP", bossHeader,"BOTTOM", 0,-2)
    bossSubHeader:SetTextColor(0.55,0.50,0.32)
    bossSubHeader:SetText("")

    local rhDiv = rightPane:CreateTexture(nil,"ARTWORK")
    rhDiv:SetTexture("Interface\\Tooltips\\UI-Tooltip-Border"); rhDiv:SetHeight(1)
    rhDiv:SetPoint("TOPLEFT",  rightPane,"TOPLEFT",   8,-38)
    rhDiv:SetPoint("TOPRIGHT", rightPane,"TOPRIGHT",  -8,-38)
    rhDiv:SetVertexColor(0.4,0.32,0.10,0.8)

    local rightSF = CreateFrame("ScrollFrame","EWBrowserRightScroll",
        rightPane,"UIPanelScrollFrameTemplate")
    rightSF:SetPoint("TOPLEFT",     rightPane,"TOPLEFT",    6,-44)
    rightSF:SetPoint("BOTTOMRIGHT", rightPane,"BOTTOMRIGHT",-20, 4)

    local gridContent = CreateFrame("Frame", nil, rightSF)
    gridContent:SetWidth(rightSF:GetWidth())
    gridContent:SetHeight(1)
    rightSF:SetScrollChild(gridContent)

    -- ── Icon cell pool ─────────────────────────────────────────
    local cellPool, activeCells = {}, {}

    RefreshCellChecks = function()
        for _, cell in ipairs(activeCells) do
            if cell._itemId then
                if IsInWishlist(cell._itemId) then cell.check:Show() else cell.check:Hide() end
            end
        end
    end

    local function GetCell()
        local cell = table.remove(cellPool)
        if not cell then
            cell = CreateFrame("Button", nil, gridContent)
            cell:SetSize(ICON_SIZE+2, ICON_SIZE+22)

            cell.border = cell:CreateTexture(nil,"BACKGROUND")
            cell.border:SetAllPoints(cell)

            cell:SetHighlightTexture("Interface\\Buttons\\ButtonHilight-Square","ADD")

            cell.icon = cell:CreateTexture(nil,"ARTWORK")
            cell.icon:SetSize(ICON_SIZE, ICON_SIZE)
            cell.icon:SetPoint("TOP", cell,"TOP", 0,0)
            cell.icon:SetTexCoord(0.08,0.92,0.08,0.92)

            cell.check = cell:CreateTexture(nil,"OVERLAY")
            cell.check:SetSize(18,18)
            cell.check:SetPoint("BOTTOMRIGHT", cell.icon,"BOTTOMRIGHT", 2,-2)
            cell.check:SetTexture("Interface\\RaidFrame\\ReadyCheck-Ready")
            cell.check:Hide()

            cell.nameFS = cell:CreateFontString(nil,"OVERLAY","GameFontNormalSmall")
            cell.nameFS:SetPoint("TOPLEFT",  cell.icon,"BOTTOMLEFT",  0,-2)
            cell.nameFS:SetPoint("TOPRIGHT", cell.icon,"BOTTOMRIGHT", 0,-2)
            cell.nameFS:SetHeight(20)
            cell.nameFS:SetJustifyH("CENTER")
            cell.nameFS:SetWordWrap(true)
        end
        return cell
    end

    local function ReleaseCell(cell)
        cell:Hide(); cell:ClearAllPoints()
        cell:SetScript("OnClick", nil)
        cell:SetScript("OnEnter", nil)
        cell:SetScript("OnLeave", nil)
        cell._itemId = nil
        table.insert(cellPool, cell)
    end

    local function IsInWishlist(itemId)
        if not db.activeList then return false end
        local list = db.lists[db.activeList]
        if not list then return false end
        for _, e in ipairs(list) do
            if e.itemId == itemId then return true end
        end
        return false
    end

    -- ── LoadBossLoot ──────────────────────────────────────────
    --
    --  GetItemInfo() returns nil for items not yet in the client
    --  cache.  We call it up-front to trigger a server request,
    --  then register a GET_ITEM_INFO_RECEIVED listener that
    --  backfills any cells that are still showing "?".
    --  The listener cleans itself up once all cells are filled
    --  or the boss changes (loadId guard).
    -- ──────────────────────────────────────────────────────────

    -- Shared event frame reused across loads (one at a time)
    local itemEventFrame = CreateFrame("Frame")
    local currentLoadId  = 0   -- incremented each LoadBossLoot call

    -- cellById[itemId] = cell  — lets the listener find the cell fast
    local cellById = {}

    local function ApplyCellData(cell, itemId)
        local _, itemLink, quality, _, _, _, _, _, _, texture = GetItemInfo(itemId)
        local q  = quality or 1
        local bc = QUALITY_BORDER[q] or QUALITY_BORDER[1]

        cell.icon:SetTexture(texture or "Interface\\Icons\\INV_Misc_QuestionMark")
        cell.border:SetTexture("Interface\\Buttons\\UI-ActionButton-Border")
        cell.border:SetVertexColor(bc[1], bc[2], bc[3], 0.9)

        local plain = itemLink
            and itemLink:gsub("|c%x%x%x%x%x%x%x%x",""):gsub("|r",""):gsub("%[(.-)%]","%1")
            or ("ID "..itemId)
        cell.nameFS:SetText(QualityColor(q)..plain.."|r")

        -- store resolved border colours on the cell so OnEnter/Leave work
        cell.bc = bc
        return texture ~= nil   -- true = fully resolved
    end

    local function LoadBossLoot(zone, boss)
        -- Invalidate any previous listener
        currentLoadId = currentLoadId + 1
        local myLoadId = currentLoadId
        itemEventFrame:UnregisterAllEvents()
        wipe(cellById)

        for _, cell in ipairs(activeCells) do ReleaseCell(cell) end
        wipe(activeCells)

        local items = EW_BROWSE_DATA[zone] and EW_BROWSE_DATA[zone][boss]
        if not items or #items == 0 then
            bossHeader:SetText("|cff888888(no items)|r")
            bossSubHeader:SetText("")
            gridContent:SetHeight(1)
            return
        end

        bossHeader:SetText("|cffFFD700"..boss.."|r")
        bossSubHeader:SetText("|cffA09060"..zone.."|r  -  |cff9a7a32"
            ..#items.." item"..(#items==1 and "" or "s").."|r")

        local cellW   = ICON_SIZE + 2
        local cellH   = ICON_SIZE + 24
        local stepX   = cellW + ICON_PAD
        local stepY   = cellH + ICON_PAD
        local rows    = math.ceil(#items / ICON_COLS)
        local totalW  = ICON_COLS * stepX - ICON_PAD
        local offsetX = math.max(0, (gridContent:GetWidth() - totalW) / 2)

        gridContent:SetWidth(rightSF:GetWidth() - 4)
        gridContent:SetHeight(rows * stepY + ICON_PAD * 2)
        rightSF:SetVerticalScroll(0)

        local pendingCount = 0

        for i, itemId in ipairs(items) do
            local col = (i-1) % ICON_COLS
            local row = math.floor((i-1) / ICON_COLS)
            local cx  = offsetX + col * stepX
            local cy  = -(ICON_PAD + row * stepY)

            local cell = GetCell()
            cell:SetParent(gridContent); cell:ClearAllPoints()
            cell:SetPoint("TOPLEFT", gridContent,"TOPLEFT", cx, cy)
            cell:SetSize(cellW, cellH)
            cell:Show()

            local resolved = ApplyCellData(cell, itemId)
            if not resolved then
                local captCell  = cell
                local captLoad  = myLoadId
                FetchItem(itemId, function(id)
                    if currentLoadId ~= captLoad then return end
                    if captCell and captCell:IsShown() then
                        ApplyCellData(captCell, id)
                    end
                end)
                cellById[itemId] = cell
                pendingCount = pendingCount + 1
            end

            if IsInWishlist(itemId) then cell.check:Show() else cell.check:Hide() end

            local captId = itemId
            cell._itemId = itemId
            cell:SetScript("OnClick", function()
                if not db.activeList then
                    Print("|cffFF4444Select or create a list first.|r"); return
                end
                local _, lk = GetItemInfo(captId)
                local ok, err = AddItem(db.activeList, captId,
                    lk or ("|cff0070dd[Item #"..captId.."]|r"), "")
                if ok then
                    cell.check:Show()
                    RefreshItemRows()
                    Print(string.format("Added %s to |cffFFD700%s|r.",
                        lk or "Item #"..captId, db.activeList))
                else
                    Print("|cffFF4444"..(err or "Already in list.").."|r")
                end
            end)
            cell:SetScript("OnEnter", function(self)
                local _, lk = GetItemInfo(captId)
                ShowItemTooltip(self, lk, captId)
                local bc = self.bc or QUALITY_BORDER[1]
                self.border:SetVertexColor(bc[1]*1.3, bc[2]*1.3, bc[3]*1.3, 1)
            end)
            cell:SetScript("OnLeave", function(self)
                GameTooltip:Hide()
                local bc = self.bc or QUALITY_BORDER[1]
                self.border:SetVertexColor(bc[1], bc[2], bc[3], 0.9)
            end)
            table.insert(activeCells, cell)
        end

        -- If any cells are still pending, listen for their data
        if pendingCount > 0 then
            itemEventFrame:RegisterEvent("GET_ITEM_INFO_RECEIVED")
            itemEventFrame:SetScript("OnEvent", function(_, _, receivedId)
                if currentLoadId ~= myLoadId then
                    itemEventFrame:UnregisterAllEvents(); return
                end
                local cell = cellById[receivedId]
                if cell and cell:IsShown() then
                    ApplyCellData(cell, receivedId)
                    cellById[receivedId] = nil
                    pendingCount = pendingCount - 1
                    if pendingCount <= 0 then
                        itemEventFrame:UnregisterAllEvents()
                    end
                end
            end)
        end
    end

    -- ── Zone/boss list ────────────────────────────────────────
    local expandedZones  = {}
    local allBossButtons = {}
    local activeEntries  = {}

    local function RelayoutList(contentW)
        local y = -L_PAD
        for _, e in ipairs(activeEntries) do
            e.zBtn:SetWidth(contentW)
            e.zBtn:ClearAllPoints()
            e.zBtn:SetPoint("TOPLEFT", leftContent,"TOPLEFT", 0, y)
            y = y - ZONE_H
            if expandedZones[e.zone] then
                e.zArrow:SetText("v")
                for _, bb in ipairs(e.bossBtns) do
                    bb:SetWidth(contentW)
                    bb:ClearAllPoints()
                    bb:SetPoint("TOPLEFT", leftContent,"TOPLEFT", 0, y)
                    bb:Show()
                    y = y - BOSS_H
                end
            else
                e.zArrow:SetText(">")
                for _, bb in ipairs(e.bossBtns) do bb:Hide() end
            end
        end
        return -(y - L_PAD)
    end

    local function LoadCategory(zoneList)
        -- Hide and clear previous entries
        for _, e in ipairs(activeEntries) do
            e.zBtn:Hide()
            for _, bb in ipairs(e.bossBtns) do bb:Hide() end
        end
        wipe(activeEntries)
        wipe(expandedZones)
        wipe(allBossButtons)

        -- Clear right pane
        for _, cell in ipairs(activeCells) do ReleaseCell(cell) end
        wipe(activeCells)
        bossHeader:SetText("|cff888888Select a boss|r")
        bossSubHeader:SetText("")
        gridContent:SetHeight(1)

        local contentW = math.max(leftContent:GetWidth(), 10)

        for _, zone in ipairs(zoneList) do
            -- Zone button
            local zBtn = CreateFrame("Button", nil, leftContent)
            zBtn:SetSize(contentW, ZONE_H)
            zBtn:SetHighlightTexture(
                "Interface\\QuestFrame\\UI-QuestLogTitleHighlight","ADD")

            local zBg = zBtn:CreateTexture(nil,"BACKGROUND")
            zBg:SetAllPoints(); zBg:SetTexture(0.12,0.09,0.03,0.85)

            local zFS = zBtn:CreateFontString(nil,"OVERLAY","GameFontNormal")
            zFS:SetPoint("LEFT",  zBtn,"LEFT",  8, 0)
            zFS:SetPoint("RIGHT", zBtn,"RIGHT",-18, 0)
            zFS:SetJustifyH("LEFT"); zFS:SetWordWrap(false)
            zFS:SetText("|cffFFD700"..zone.."|r")

            local zArrow = zBtn:CreateFontString(nil,"OVERLAY","GameFontNormalSmall")
            zArrow:SetPoint("RIGHT", zBtn,"RIGHT", -4, 0)
            zArrow:SetText(">")
            zArrow:SetTextColor(0.6,0.5,0.2)

            -- Boss buttons (hidden until zone expanded)
            local bossBtns = {}
            for _, boss in ipairs(EW_BOSS_ORDER[zone] or {}) do
                local bBtn = CreateFrame("Button", nil, leftContent)
                bBtn:SetSize(contentW, BOSS_H)
                bBtn:SetHighlightTexture(
                    "Interface\\QuestFrame\\UI-QuestLogTitleHighlight","ADD")

                local bFS = bBtn:CreateFontString(nil,"OVERLAY","GameFontNormalSmall")
                bFS:SetPoint("LEFT",  bBtn,"LEFT",  20, 0)
                bFS:SetPoint("RIGHT", bBtn,"RIGHT",  -4, 0)
                bFS:SetJustifyH("LEFT"); bFS:SetWordWrap(false)
                bFS:SetText(boss)
                bFS:SetTextColor(0.75,0.70,0.45)

                bBtn.bFS  = bFS
                bBtn.zone = zone
                bBtn.boss = boss

                local cZone = zone
                local cBoss = boss
                local cFS   = bFS
                bBtn:SetScript("OnClick", function()
                    for _, ob in ipairs(allBossButtons) do
                        if ob.bFS then ob.bFS:SetTextColor(0.75,0.70,0.45) end
                    end
                    cFS:SetTextColor(1,0.85,0.1)
                    LoadBossLoot(cZone, cBoss)
                end)

                bBtn:Hide()
                allBossButtons[#allBossButtons+1] = bBtn
                bossBtns[#bossBtns+1] = bBtn
            end

            local entry = {zone=zone, zBtn=zBtn, zArrow=zArrow, bossBtns=bossBtns}
            activeEntries[#activeEntries+1] = entry
            allBossButtons[#allBossButtons+1] = zBtn

            local cZone = zone
            zBtn:SetScript("OnClick", function()
                expandedZones[cZone] = not expandedZones[cZone]
                leftContent:SetHeight(math.max(RelayoutList(contentW), 1))
            end)
        end

        leftContent:SetHeight(math.max(RelayoutList(contentW), 1))
        leftSF:SetVerticalScroll(0)

        -- Auto-expand first zone and load its first boss
        if #zoneList > 0 then
            expandedZones[zoneList[1]] = true
            leftContent:SetHeight(math.max(RelayoutList(contentW), 1))
            local firstBoss = EW_BOSS_ORDER[zoneList[1]] and EW_BOSS_ORDER[zoneList[1]][1]
            if firstBoss then
                LoadBossLoot(zoneList[1], firstBoss)
                for _, bb in ipairs(allBossButtons) do
                    if bb.zone==zoneList[1] and bb.boss==firstBoss and bb.bFS then
                        bb.bFS:SetTextColor(1,0.85,0.1)
                    end
                end
            end
        end
    end

    -- ── Wire up the category dropdown ────────────────────────
    --  One item per zone, with "Raids" and "Dungeons" section
    --  headers. Selecting a zone loads its bosses directly.
    local function BuildZoneDropdown()
        catDD:SetItems(function()
            local ddItems = {}
            if #EW_RAID_ZONES > 0 then
                ddItems[#ddItems+1] = { isHeader=true, text="-- Raids --" }
                for _, zone in ipairs(EW_RAID_ZONES) do
                    local cZone = zone
                    ddItems[#ddItems+1] = {
                        text    = zone,
                        onClick = function()
                            catDD:SetSelectedText(cZone)
                            LoadCategory({ cZone })
                        end,
                    }
                end
            end
            if #EW_DUNG_ZONES > 0 then
                ddItems[#ddItems+1] = { isHeader=true, text="-- Dungeons --" }
                for _, zone in ipairs(EW_DUNG_ZONES) do
                    local cZone = zone
                    ddItems[#ddItems+1] = {
                        text    = zone,
                        onClick = function()
                            catDD:SetSelectedText(cZone)
                            LoadCategory({ cZone })
                        end,
                    }
                end
            end
            if #EW_SET_ZONES > 0 then
                ddItems[#ddItems+1] = { isHeader=true, text="-- Sets & Collections --" }

                -- Sub-groups within sets
                local setSubGroups = {
                    { header="- Dungeon Sets -",   zones={"Fang Set", "Uldic Set", "Rune Warder Set"} },
                    { header="- Raid Sets -",      zones={"Tier 0", "Tier 0.5", "Tier 1"} },
                    { header="- World Drops -",    zones={"BoE World Drops"} },
                }

                -- Build a lookup of which set zones actually exist
                local setZoneSet = {}
                for _, z in ipairs(EW_SET_ZONES) do setZoneSet[z] = true end

                local listed = {}
                for _, group in ipairs(setSubGroups) do
                    local any = false
                    for _, z in ipairs(group.zones) do
                        if setZoneSet[z] then any = true; break end
                    end
                    if any then
                        ddItems[#ddItems+1] = { isHeader=true, text=group.header }
                        for _, z in ipairs(group.zones) do
                            if setZoneSet[z] then
                                local cZone = z
                                listed[z] = true
                                ddItems[#ddItems+1] = {
                                    text    = z,
                                    onClick = function()
                                        catDD:SetSelectedText(cZone)
                                        LoadCategory({ cZone })
                                    end,
                                }
                            end
                        end
                    end
                end

                -- Fallback: any set zones not in a sub-group
                for _, zone in ipairs(EW_SET_ZONES) do
                    if not listed[zone] then
                        local cZone = zone
                        ddItems[#ddItems+1] = {
                            text    = zone,
                            onClick = function()
                                catDD:SetSelectedText(cZone)
                                LoadCategory({ cZone })
                            end,
                        }
                    end
                end
            end
            return ddItems
        end)
        local first = EW_RAID_ZONES[1] or EW_DUNG_ZONES[1] or EW_SET_ZONES[1]
        if first then catDD:SetSelectedText(first) end
    end

    -- Build on first show
    searchPanel:SetScript("OnShow", function(self)
        self:SetScript("OnShow", nil)
        BuildZoneDropdown()
        local first = EW_RAID_ZONES[1] or EW_DUNG_ZONES[1]
        if first then LoadCategory({ first }) end
    end)


    -- ── Tab switching ─────────────────────────────────────────
    local function ShowTab(tab)
        if tab == "wishlist" then
            wishPanel:Show(); searchPanel:Hide()
            tabWishlist:SetActive(true);  tabSearch:SetActive(false)
            tabWishlist._active = true;   tabSearch._active = false
            statusFS:Show()
        else
            wishPanel:Hide(); searchPanel:Show()
            tabWishlist:SetActive(false); tabSearch:SetActive(true)
            tabWishlist._active = false;  tabSearch._active = true
            statusFS:Hide()
        end
    end

    tabWishlist:SetScript("OnClick", function() ShowTab("wishlist") end)
    tabSearch:SetScript("OnClick",   function() ShowTab("search")   end)
    ShowTab("wishlist")  -- start on wishlist tab

    -- Defer first refresh so the frame has real screen dimensions
    f:SetScript("OnShow", function(self)
        RefreshListDropdown()
        RefreshItemRows()
    end)

    f.RefreshItemRows = RefreshItemRows
    tinsert(UISpecialFrames, "EpochWishlistFrame")
    return f
end


-- ============================================================
--  Static popups
-- ============================================================
StaticPopupDialogs["EW_CREATE_LIST"] = {
    text="New list name:", button1="Create", button2="Cancel",
    hasEditBox=1, maxLetters=40, timeout=0, whileDead=1, hideOnEscape=1,
    OnAccept = function(self)
        local name = Trim(self.editBox:GetText())
        if name ~= "" then
            local ok, err = CreateList(name)
            if ok then
                db.activeList = name
                if mainFrame and mainFrame:IsShown() then
                    RefreshListDropdown(); RefreshItemRows()
                end
            else Print("|cffFF4444"..err.."|r") end
        end
    end,
    EditBoxOnEnterPressed = function(self)
        StaticPopupDialogs["EW_CREATE_LIST"].OnAccept(self:GetParent())
        self:GetParent():Hide()
    end,
}

StaticPopupDialogs["EW_DELETE_LIST"] = {
    text='Delete list "%s"? This cannot be undone.',
    button1="Delete", button2="Cancel",
    timeout=0, whileDead=1, hideOnEscape=1,
    OnAccept = function(_, listName)
        DeleteList(listName)
        if mainFrame and mainFrame:IsShown() then
            RefreshListDropdown(); RefreshItemRows()
        end
    end,
}

StaticPopupDialogs["EW_RENAME_LIST"] = {
    text='Rename list "%s" to:',
    button1="Rename", button2="Cancel",
    hasEditBox=1, maxLetters=40, timeout=0, whileDead=1, hideOnEscape=1,
    OnAccept = function(self, oldName)
        local newName = Trim(self.editBox:GetText())
        if newName ~= "" then
            local ok, err = RenameList(oldName, newName)
            if ok then
                if mainFrame and mainFrame:IsShown() then
                    RefreshListDropdown(); RefreshItemRows()
                end
            else Print("|cffFF4444"..err.."|r") end
        end
    end,
    EditBoxOnEnterPressed = function(self)
        StaticPopupDialogs["EW_RENAME_LIST"].OnAccept(
            self:GetParent(), self:GetParent().data)
        self:GetParent():Hide()
    end,
}

StaticPopupDialogs["EW_EDIT_NOTE"] = {
    text="Edit note:", button1="Save", button2="Cancel",
    hasEditBox=1, maxLetters=128, timeout=0, whileDead=1, hideOnEscape=1,
    OnShow   = function(self)
        if self.data then self.editBox:SetText(self.data.note or "") end
    end,
    OnAccept = function(self)
        local d = self.data
        if d then
            local list = db.lists[d.listName]
            if list then
                for _, e in ipairs(list) do
                    if e.itemId == d.itemId then e.note = self.editBox:GetText() end
                end
            end
            if mainFrame and mainFrame:IsShown() then RefreshItemRows() end
        end
    end,
}

-- ============================================================
--  Minimap button
-- ============================================================
local function CreateMinimapButton()
    local btn = CreateFrame("Button","EWMinimapButton",Minimap)
    btn:SetSize(32,32); btn:SetFrameStrata("MEDIUM"); btn:SetFrameLevel(8)
    btn:SetHighlightTexture("Interface\\Minimap\\UI-Minimap-ZoomButton-Highlight")

    local icon = btn:CreateTexture(nil,"BACKGROUND")
    icon:SetTexture("Interface\\Icons\\INV_Misc_Note_01")
    icon:SetSize(20,20); icon:SetPoint("CENTER")

    local border = btn:CreateTexture(nil,"OVERLAY")
    border:SetTexture("Interface\\Minimap\\MiniMap-TrackingBorder")
    border:SetSize(56,56); border:SetPoint("TOPLEFT")

    local angle, radius = -math.pi/4, 80
    btn:SetPoint("CENTER",Minimap,"CENTER",
        radius*math.cos(angle), radius*math.sin(angle))

    btn:SetScript("OnClick", function()
        if not mainFrame then mainFrame = CreateMainFrame() end
        if mainFrame:IsShown() then mainFrame:Hide()
        else mainFrame:Show() end
    end)
    btn:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self,"ANCHOR_LEFT")
        GameTooltip:SetText("|cffFFD700Epoch Wishlist|r\nClick to open\nRight-drag to move")
        GameTooltip:Show() end)
    btn:SetScript("OnLeave", function() GameTooltip:Hide() end)

    btn:RegisterForDrag("RightButton"); btn:SetMovable(true)
    btn:SetScript("OnDragStart", function(self)
        self:SetScript("OnUpdate", function(self2)
            local mx,my = Minimap:GetCenter()
            local cx,cy = GetCursorPosition()
            local s = UIParent:GetEffectiveScale()
            local a = math.atan2(cy/s-my, cx/s-mx)
            self2:SetPoint("CENTER",Minimap,"CENTER",
                radius*math.cos(a), radius*math.sin(a))
        end)
    end)
    btn:SetScript("OnDragStop", function(self)
        self:SetScript("OnUpdate",nil) end)
end

-- ============================================================
--  Slash commands
-- ============================================================
local function HandleSlash(msg)
    local cmd, arg = (msg or ""):match("^(%S*)%s*(.-)%s*$")
    cmd = (cmd or ""):lower()

    if cmd=="" or cmd=="show" or cmd=="open" then
        if not mainFrame then mainFrame = CreateMainFrame() end
        if mainFrame:IsShown() then mainFrame:Hide()
        else mainFrame:Show() end

    elseif cmd=="hide" or cmd=="close" then
        if mainFrame then mainFrame:Hide() end

    elseif cmd=="new" then
        if arg ~= "" then
            local ok,err = CreateList(arg)
            if ok then
                db.activeList = arg
                Print("Created '"..arg.."'.")
                if mainFrame and mainFrame:IsShown() then
                    RefreshListDropdown(); RefreshItemRows() end
            else Print("|cffFF4444"..err.."|r") end
        else Print("Usage: /ew new <name>") end

    elseif cmd=="del" or cmd=="delete" then
        if arg ~= "" then
            DeleteList(arg); Print("Deleted '"..arg.."'.")
            if mainFrame and mainFrame:IsShown() then
                RefreshListDropdown(); RefreshItemRows() end
        else Print("Usage: /ew del <name>") end

    elseif cmd=="list" then
        local names = GetListNames()
        if #names == 0 then Print("No lists yet. Use /ew new <n>.")
        else Print("|cffFFD700Lists:|r "..table.concat(names,", ")) end

    elseif cmd=="export" then
        local target = (arg~="") and arg or db.activeList
        if target then OpenExportFrame(target) else Print("No list specified.") end

    elseif cmd=="import" then
        OpenImportFrame()

    elseif cmd=="share" then
        local target = (arg~="") and arg or db.activeList
        if target then ShareListToChannel(target,nil) else Print("No list specified.") end

    elseif cmd=="send" then
        local parts = {}
        for p in arg:gmatch("%S+") do parts[#parts+1]=p end
        local listName, player
        if     #parts==1 then listName=db.activeList; player=parts[1]
        elseif #parts>=2 then listName=parts[1];      player=parts[2] end
        if listName and player then SendListViaAddonMsg(listName, player)
        else Print("Usage: /ew send [listname] <player>") end

    elseif cmd=="help" then
        Print("|cffFFD700EpochWishlist v"..VERSION.."|r")
        Print("  /ew             — open/close window")
        Print("  /ew new <n>     — create list")
        Print("  /ew del <n>     — delete list")
        Print("  /ew list        — show all lists")
        Print("  /ew export [n]  — export to text")
        Print("  /ew import      — import from text")
        Print("  /ew share [n]   — post to chat")
        Print("  /ew send [n] <player>  — send to player")
    else
        Print("Unknown command. /ew help for help.")
    end
end

SLASH_EW1          = "/ew"
SLASH_EW2          = "/wishlist"
SLASH_EW3          = "/epochwishlist"
SlashCmdList["EW"] = HandleSlash

-- ============================================================
--  Event frame — handles ADDON_LOADED + CHAT_MSG_ADDON
-- ============================================================
local events = CreateFrame("Frame")
events:RegisterEvent("ADDON_LOADED")
events:RegisterEvent("CHAT_MSG_ADDON")
events:RegisterEvent("PLAYER_LOGIN")
events:SetScript("OnEvent", function(_, event, a1, a2, a3, a4)
    if event == "ADDON_LOADED" and a1 == ADDON_NAME then
        InitDB()
        CreateMinimapButton()
        Print("v"..VERSION.." loaded — |cffFFD700/ew|r to open.")

    elseif event == "PLAYER_LOGIN" then
        if RegisterAddonMessagePrefix then
            RegisterAddonMessagePrefix(COMM_PREFIX)
        end

    elseif event == "CHAT_MSG_ADDON" then
        OnAddonMsg(a1, a2, a3, a4)
    end
end)
