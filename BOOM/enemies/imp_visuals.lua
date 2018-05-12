local T = {}

	local function spawn()
		local V = {}
		V.anim = ""
		V.sounds = {}
		local imp_sheetOptions =
		{
			width = 300,
			height = 240,
			numFrames = 64
		}
		local imp_sheet_stand = graphics.newImageSheet( GLOBAL_animationPath.."ImpStand.png", imp_sheetOptions )
		local imp_sequences = require "SpriteSeq.imp_seq"
		V.bounds = display.newSprite( imp_sheet_stand, imp_sequences )

		local function animate(angle, ext) -- angle i.e 90, ext is the extension onto the animation, i.e "Shoot" or "Stand"
			-- Animate Upper Body
			local anim = ""
			if angle > 337 or angle < 23 then
				anim = "Up"
			elseif angle < 68 then
				anim = "UpRight"
			elseif angle < 113 then
				anim = "Right"
			elseif angle < 158 then
				anim = "DownRight"
			elseif angle < 203 then
				anim = "Down"
			elseif angle < 248 then
				anim = "DownLeft"
			elseif angle < 293 then
				anim = "Left"
			else
				anim = "UpLeft"
			end

			anim = anim .. ext

			if V.anim ~= anim then
				V.bounds:setSequence(anim)
				V.bounds:play()
				V.anim = anim
			end
		end
		V.animate = animate
		return V
	end
	T.spawn = spawn
return T
