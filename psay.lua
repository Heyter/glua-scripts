PSAY = PSAY or {}
local PSAY = PSAY

if SERVER then
	util.AddNetworkString ("psay_alert")

	function PSAY.Alert (msg, caller)
		umsg.Start ("psay_alert")
			umsg.String (msg)
			umsg.Long (caller:EntIndex())
		umsg.End ()
	end

	-- aowl commands
	local function RegisterAowlCommands ()
		if not aowl then return false end

		local PSAY_Alert = PSAY.Alert
		aowl.AddCommand ("psay", function (caller, msg) PSAY_Alert (msg, caller) end, "developers")

		return true
	end

	if not RegisterAowlCommands () then
		hook.Add ("AowlInitialized", "PSAY.RegisterAowlCommands", function ()
			RegisterAowlCommands()
		end)
	end
elseif CLIENT then
	include ("glib/glib.lua")

	-- Settings
	PSAY.Rendering = {}
	local PSAY_Rendering = PSAY.Rendering

	PSAY.Rendering.Font            = "DermaLarge"

	local function InitializeColors ()
		if not GLib or not GLib.Colors then return false end

		PSAY.Rendering.BackgroundColor = Color(0,150,130)
		PSAY.Rendering.TextColor       = Color(255,255,255)
		PSAY.Rendering.StripeColor     = Color(255,255,255)
		
		return true
	end

	if not InitializeColors () then
		hook.Add ("GLibStage2Loaded", "PSAY.Rendering.Colors", function ()
			InitializeColors ()
		end)
	end

	PSAY.Rendering.StripeHeight    = 12
	PSAY.Rendering.StripeMeshWidth = 0
	PSAY.Rendering.RectangleHeight = 64
	PSAY.Rendering.StripeSpeed     = -64

	-- Mesh building
	local vertices = {}

	local material = Material ("debug/debugvertexcolor")
	local mesh = nil

	local function AddVertex (x, y, z, color)
		vertices [#vertices + 1] =
		{
			pos   = Vector (x, y, z),
			color = color or GLib.Colors.White
		}
	end

	local function AddQuad (x, color)
		local size = PSAY.Rendering.StripeHeight
		AddVertex (x +     size,    0, 1, color)
		AddVertex (x + 3 * size,    0, 1, color)
		AddVertex (x + 2 * size, size, 1, color)
		AddVertex (x + 2 * size, size, 1, color)
		AddVertex (x +        0, size, 1, color)
		AddVertex (x +     size,    0, 1, color)
	end

	local function BuildMesh ()
		PSAY.Rendering.StripeMeshWidth = 0
		for x = 0, ScrW (), 4 * PSAY.Rendering.StripeHeight do
			-- AddQuad (x, PSAY.Rendering.BackgroundColor)
			AddQuad (x + 2 * PSAY.Rendering.StripeHeight, PSAY.Rendering.StripeColor)
			PSAY.Rendering.StripeMeshWidth = math.max (PSAY.Rendering.StripeMeshWidth, x + 3 * PSAY.Rendering.StripeHeight)
		end

		-- Build the mesh
		mesh = Mesh ()
		mesh:BuildFromTriangles (vertices)
		vertices = nil
	end

	local function GetMesh ()
		if not mesh then
			BuildMesh ()
		end
		return mesh
	end

	-- Rendering
	local v1 = Vector ()
	local v2 = Vector ()

	-- Animation
	local slideDuration = 0.2
	local holdDuration = 5
	local function k (t)
		local k = 0

		if t < slideDuration then
			k = t / slideDuration
		elseif t < slideDuration + holdDuration then
			k = 1
		elseif t < slideDuration + holdDuration + slideDuration then
			t = t - slideDuration - holdDuration
			k = 1 - t / slideDuration
		else
			k = 0
		end

		return k
	end

	PSAY.ChatsoundsWhitelist = {
		["play it loud"] = function ()
			chatsounds.Say (LocalPlayer (), "play it loud", 0)
			return true
		end,
		["breadfish loop"] = function ()
			sound.PlayURL("http://dl.dropboxusercontent.com/s/s1dj4pigikcmws4/The%20Marvellous%20Breadfish.ogg", "noblock", function (tmp)
				if IsValid (tmp) then
					tmp:EnableLooping (true)
					tmp:Play ()
				end
			end)
			return false
		end,
		["all sounds at once"] = function (caller)
			if not caller:IsAdmin () then return end
			local str = ""
			for k, v in pairs (PSAY.ChatsoundsWhitelist) do
				if not isfunction (v) and k:lower () ~= "sh" then
					str = str .. (isbool(v) and k or v) .. ";"
				end
			end
			chatsounds.Say (LocalPlayer (), str, 0)
		end,
	}

	local chatsoundsWhitelist = chatsounds.SortedListKeys

	function PSAY.Alert (msg, caller)
		msg = msg or ""
		msg = string.Trim (msg)

		local faallal = {"Message not found.",
					"No Message.",
					"faallal",
					"PSAY",
					"Please try again.",
					"Please input a message.",
					"WTF!? No message?",}

		msg = msg ~= "" and msg or table.Random(faallal)

		-- Message lines
		local messageLines = string.Split (msg, "\n")

		-- Animation parameters
		local t0 = SysTime ()
		local matrix = Matrix ()

		local intensify = false


		if string.find (string.lower (msg), "%[.*intensifies.*%]") then
			intensify = true
		 -- function string.isallcaps(txt) return txt:upper() == txt end
		elseif msg:upper() == msg then
			intensify = true
		end

		local lowMessage = string.lower (msg)
		local chatsound
		for k, v in pairs(chatsoundsWhitelist) do
			if not chatsound then
				chatsound = lowMessage:match("([%s%w]*)") == k and v or nil
			end
		end
		if lowMessage:sub (1, 3) == "cs:" and #lowMessage > 3 then
			chatsounds.Say (LocalPlayer(), lowMessage:sub (4, #lowMessage), math.random (0, 2^16))
		elseif lowMessage:sub (1, 4) == "snd:" and #lowMessage > 4 then
			surface.PlaySound (msg:sub(5, #msg))
		elseif chatsound then
			if isstring(chatsound) then
				chatsounds.Say (LocalPlayer (), chatsound, 0)
			elseif isfunction(chatsound) then
				intensify = chatsound(caller)
			else
				chatsounds.Say (LocalPlayer (), lowMessage, 0)
			end
		end
		LocalPlayer():EmitSound("ui/hint.wav") --music/mvm_class_select.wav --mvm/mvm_warning.wav

		hook.Add ("HUDPaint", "PSAY.Alert",
			function ()
				
				local y0 = -PSAY_Rendering.RectangleHeight
				local y_final = ScrH () * 0.6

				local t = SysTime () - t0
				local k = k (t)

				if k == 0 and t > 0 then
					hook.Remove ("HUDPaint", "PSAY.Alert")
					return
				end

				local y = y0 + (y_final - y0) * k

				local dx = 0
				local dy = 0

				if intensify then
					dx = 8 * (math.random () - 0.5) * 2
					dy = 8 * (math.random () - 0.5) * 2

					y = y + dy
				end

				y = math.floor (y + 0.5)

				-- Background
				surface.SetDrawColor (PSAY_Rendering.BackgroundColor)
				surface.DrawRect (0, y, ScrW (), PSAY_Rendering.RectangleHeight)

				-- Text
				surface.SetFont (PSAY_Rendering.Font)
				surface.SetTextColor (PSAY_Rendering.TextColor)

				local _, lineHeight = surface.GetTextSize ("#")
				local messageHeight = #messageLines * lineHeight
				for i = 1, #messageLines do
					local lineWidth = surface.GetTextSize (messageLines [i])
					surface.SetTextPos (
						ScrW () / 2 + dx - lineWidth / 2,
						y + dy + PSAY_Rendering.RectangleHeight / 2 - messageHeight / 2 + lineHeight * (i - 1)
					)
					surface.DrawText (messageLines [i])
				end

				-- Edges
				render.SetMaterial (material)

				local mesh = GetMesh ()

				v1.x = (SysTime () * PSAY_Rendering.StripeSpeed) % ScrW ()
				v2.x = v1.x - PSAY_Rendering.StripeMeshWidth - PSAY_Rendering.StripeHeight

				-- Top edge
				v1.y = y
				v2.y = y

				matrix:SetTranslation (v1)
				cam.PushModelMatrix (matrix)
				mesh:Draw ()
				cam.PopModelMatrix ()

				matrix:SetTranslation (v2)
				cam.PushModelMatrix (matrix)
				mesh:Draw ()
				cam.PopModelMatrix ()

				-- Bottom edge
				v1.y = y + PSAY_Rendering.RectangleHeight - PSAY_Rendering.StripeHeight
				v2.y = v1.y

				matrix:SetTranslation (v1)
				cam.PushModelMatrix (matrix)
				mesh:Draw ()
				cam.PopModelMatrix ()

				matrix:SetTranslation (v2)
				cam.PushModelMatrix (matrix)
				mesh:Draw ()
				cam.PopModelMatrix ()
			end
		)
	end

	local PSAY_Alert = PSAY.Alert
	_G.PSAY_Alert    = PSAY.Alert
	_G.FGFC820      = PSAY.Alert
	usermessage.Hook ("psay_alert",
		function (umsg)
			local msg = umsg:ReadString ()
			local caller = Entity (umsg:ReadLong ())
			PSAY_Alert (msg, caller)
		end
	)

	hook.Add ("ShutDown", "PSAY.Cleanup",
		function ()
			hook.Remove ("HUDPaint", "PSAY.Alert")
		end
	)
end