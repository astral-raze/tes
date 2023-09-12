script_name("SAMPLUA")
script_version("1.00")

local sampev = require 'lib.samp.events'
local imgui = require 'imgui'
local encoding = require 'encoding'
encoding.default = 'CP1251'
u8 = encoding.UTF8


local main_window_state = imgui.ImBool(false)
local sizeX, sizeY = getScreenResolution()


function autoupdate(json_url, prefix, url)
  lua_thread.create(function()
      local dlstatus = require('moonloader').download_status
      local json = getWorkingDirectory() .. '\\'..thisScript().name..'-version.json'
      if doesFileExist(json) then os.remove(json) end
      downloadUrlToFile(json_url, json,
      function(id, status, p1, p2)
          if status == dlstatus.STATUSEX_ENDDOWNLOAD then
          if doesFileExist(json) then
              local f = io.open(json, 'r')
              if f then
              local info = decodeJson(f:read('*a'))
              updatelink = info.updateurl
              updateversion = info.latest
              f:close()
              os.remove(json)
              if updateversion ~= thisScript().version then
                  lua_thread.create(function(prefix)
                  local dlstatus = require('moonloader').download_status
                  local color = -1
                  msg('Обнаружено обновление. Пытаюсь обновиться c '..thisScript().version..' на '..updateversion)
                  wait(250)
                  downloadUrlToFile(updatelink, thisScript().path,
                      function(id3, status1, p13, p23)
                      if status1 == dlstatus.STATUS_DOWNLOADINGDATA then
                          print(string.format('Загружено %d из %d.', p13, p23))
                      elseif status1 == dlstatus.STATUS_ENDDOWNLOADDATA then
                          print('Загрузка обновления завершена.')
                          msg('Обновление завершено!')
                          goupdatestatus = true
                          lua_thread.create(function() wait(500) thisScript():reload() end)
                      end
                      if status1 == dlstatus.STATUSEX_ENDDOWNLOAD then
                          if goupdatestatus == nil then
                          msg('Обновление прошло неудачно. Запускаю устаревшую версию.')
                          update = false
                          end
                      end
                      end
                  )
                  end, prefix
                  )
              else
                  update = false
                  msg('Обновление не требуется.')
              end
              end
          else
              msg('Не могу проверить обновление. Смиритесь или проверьте самостоятельно на '..url)
              update = false
          end
          end
      end
      )
      while update ~= false do wait(100) end
  end)
end

function main()
    if not isSampLoaded() or not isSampfuncsLoaded() then return end
    while not isSampAvailable() do wait(0) end
    if not doesDirectoryExist('moonloader/config/Ghetto Helper') then createDirectory('moonloader/config/Ghetto Helper') end
    if not doesFileExist(getWorkingDirectory()..'/config/Ghetto Helper/Ghetto Helper.ini') then inicfg.save(cfg, 'Ghetto Helper/Ghetto Helper.ini') end
    if not doesFileExist(getWorkingDirectory()..'/config/Ghetto Helper/bell.wav') then
        downloadUrlToFile('https://github.com/Venibon/Ghetto-Helper/raw/main/bell.wav', getWorkingDirectory()..'/config/Ghetto Helper/bell.wav')
    end
    if not doesFileExist(getWorkingDirectory()..'/resource/fonts/fontawesome-webfont.tt') then 
        downloadUrlToFile('https://github.com/Venibon/Ghetto-Helper/raw/main/fontawesome-webfont.ttf', getWorkingDirectory()..'/resource/fonts/fontawesome-webfont.tt')
    end
        imgui.Process = false
        local json = getWorkingDirectory() .. '\\'..thisScript().name..'-version.json'
        if doesFileExist(json) then os.remove(json) end
        downloadUrlToFile('https://raw.githubusercontent.com/astral-raze/tes/main/TEST.json', json,
          function(id, status, p1, p2)
            if status == dlstatus.STATUSEX_ENDDOWNLOAD then
              if doesFileExist(json) then
                local f = io.open(json, 'r')
                if f then
                  local info = decodeJson(f:read('*a'))
                  updateversion = info.latest
                  f:close()
                  os.remove(json)
                end
              end
            end
        end)
        msg('Загружен! Автор VRush. Открыть меню: /'..cfg.config.CommandAct)         
        if cfg.config.AutoUpdate == 1 then
            autoupdate("https://raw.githubusercontent.com/astral-raze/tes/main/TEST.json", '['..string.upper(thisScript().name)..']: ', "https://www.blast.hk/threads/138165/")
        elseif cfg.config.AutoUpdate == 2 then
            msg('Автообновление было выключено, проверьте обновление в Главном меню')
        end
    sampRegisterChatCommand('banana', function ()  main_window_state.v = not  main_window_state.v end)
while true do
    wait(0)
    imgui.Process =  main_window_state.v
    imgui.ShowCursor =  main_window_state.v
end
end

function imgui.OnDrawFrame()
    if main_window_state.v then 
      imgui.SetNextWindowSize(imgui.ImVec2(430, 110), imgui.Cond.FirstUseEver) 
      imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
      imgui.Begin('Information for bot', main_window_state, imgui.WindowFlags.NoResize + imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoScrollbar)
      imgui.Text(u8'ПРОВЕРКА АВТО ОБНОВЛЕНИЯ НУ ПИЗДЕЦ КТО ЭТОТ LUA ПРИДУМАЛ')
      imgui.End()
    end
  end

  function theme()
    imgui.SwitchContext()
local style = imgui.GetStyle()
local colors = style.Colors
local clr = imgui.Col
local ImVec4 = imgui.ImVec4
local ImVec2 = imgui.ImVec2

style.WindowPadding = ImVec2(15, 15)
style.WindowRounding = 6.0
style.FramePadding = ImVec2(5, 5)
style.FrameRounding = 4.0
style.ItemSpacing = ImVec2(12, 8)
style.ItemInnerSpacing = ImVec2(8, 6)
style.IndentSpacing = 25.0
style.ScrollbarSize = 15.0
style.ScrollbarRounding = 9.0
style.GrabMinSize = 5.0
style.GrabRounding = 3.0

colors[clr.Text] = ImVec4(0.80, 0.80, 0.83, 1.00)
colors[clr.TextDisabled] = ImVec4(0.24, 0.23, 0.29, 1.00)
colors[clr.WindowBg] = ImVec4(0.06, 0.05, 0.07, 1.00)
colors[clr.ChildWindowBg] = ImVec4(0.07, 0.07, 0.09, 1.00)
colors[clr.PopupBg] = ImVec4(0.07, 0.07, 0.09, 1.00)
colors[clr.Border] = ImVec4(0.80, 0.80, 0.83, 0.88)
colors[clr.BorderShadow] = ImVec4(0.92, 0.91, 0.88, 0.00)
colors[clr.FrameBg] = ImVec4(0.10, 0.09, 0.12, 1.00)
colors[clr.FrameBgHovered] = ImVec4(0.24, 0.23, 0.29, 1.00)
colors[clr.FrameBgActive] = ImVec4(0.56, 0.56, 0.58, 1.00)
colors[clr.TitleBg] = ImVec4(0.76, 0.31, 0.00, 1.00)
colors[clr.TitleBgCollapsed] = ImVec4(1.00, 0.98, 0.95, 0.75)
colors[clr.TitleBgActive] = ImVec4(0.80, 0.33, 0.00, 1.00)
colors[clr.MenuBarBg] = ImVec4(0.10, 0.09, 0.12, 1.00)
colors[clr.ScrollbarBg] = ImVec4(0.10, 0.09, 0.12, 1.00)
colors[clr.ScrollbarGrab] = ImVec4(0.80, 0.80, 0.83, 0.31)
colors[clr.ScrollbarGrabHovered] = ImVec4(0.56, 0.56, 0.58, 1.00)
colors[clr.ScrollbarGrabActive] = ImVec4(0.06, 0.05, 0.07, 1.00)
colors[clr.ComboBg] = ImVec4(0.19, 0.18, 0.21, 1.00)
colors[clr.CheckMark] = ImVec4(1.00, 0.42, 0.00, 0.53)
colors[clr.SliderGrab] = ImVec4(1.00, 0.42, 0.00, 0.53)
colors[clr.SliderGrabActive] = ImVec4(1.00, 0.42, 0.00, 1.00)
colors[clr.Button] = ImVec4(0.10, 0.09, 0.12, 1.00)
colors[clr.ButtonHovered] = ImVec4(0.24, 0.23, 0.29, 1.00)
colors[clr.ButtonActive] = ImVec4(0.56, 0.56, 0.58, 1.00)
colors[clr.Header] = ImVec4(0.10, 0.09, 0.12, 1.00)
colors[clr.HeaderHovered] = ImVec4(0.56, 0.56, 0.58, 1.00)
colors[clr.HeaderActive] = ImVec4(0.06, 0.05, 0.07, 1.00)
colors[clr.ResizeGrip] = ImVec4(0.00, 0.00, 0.00, 0.00)
colors[clr.ResizeGripHovered] = ImVec4(0.56, 0.56, 0.58, 1.00)
colors[clr.ResizeGripActive] = ImVec4(0.06, 0.05, 0.07, 1.00)
colors[clr.CloseButton] = ImVec4(0.40, 0.39, 0.38, 0.16)
colors[clr.CloseButtonHovered] = ImVec4(0.40, 0.39, 0.38, 0.39)
colors[clr.CloseButtonActive] = ImVec4(0.40, 0.39, 0.38, 1.00)
colors[clr.PlotLines] = ImVec4(0.40, 0.39, 0.38, 0.63)
colors[clr.PlotLinesHovered] = ImVec4(0.25, 1.00, 0.00, 1.00)
colors[clr.PlotHistogram] = ImVec4(0.40, 0.39, 0.38, 0.63)
colors[clr.PlotHistogramHovered] = ImVec4(0.25, 1.00, 0.00, 1.00)
colors[clr.TextSelectedBg] = ImVec4(0.25, 1.00, 0.00, 0.43)
colors[clr.ModalWindowDarkening] = ImVec4(1.00, 0.98, 0.95, 0.73)
end
theme()

