local S = {}
	local function spawn()
		local V = {}
		local v = require "SpriteSeq.satan_seq"
		V.anim = ""
		V.sounds = {}
		V.flip = 1
		V.visuals = v.spawn()

		local function animate(angle, ext) -- angle i.e 90, ext is the extension onto the animation, i.e "Shoot" or "Stand"
			-- Animate Upper Body
			local anim = ""
			if angle > 337 or angle < 23 then
				anim = "Up"
				V.flip = 1
			elseif angle < 68 then
				anim = "UpRight"
				V.flip = 1
			elseif angle < 113 then
				anim = "Right"
				V.flip = 1
			elseif angle < 158 then
				anim = "DownRight"
				V.flip = 1
			elseif angle < 203 then
				anim = "Down"
				V.flip = 1
			elseif angle < 248 then
				anim = "DownLeft"
				V.flip = -1
			elseif angle < 293 then
				anim = "Left"
				V.flip = -1
			elseif angle <= 337 then
				anim = "UpLeft"
				V.flip = -1
			end

			anim = anim .. ext

			if V.anim ~= anim then
				V.visuals.xScale = math.abs(V.visuals.xScale) * V.flip
				V.visuals:setSequence(anim)
				V.visuals:play()
				V.anim = anim
			end
		end
		V.animate = animate
		return V
	end
	S.spawn = spawn
return S
