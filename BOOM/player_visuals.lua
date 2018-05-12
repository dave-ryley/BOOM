local P = {}
	local function spawn()
		local V = {}

		V.lowerBodyAnim = ""
		V.upperBodyAnim = ""
		V.sounds = {}
		V.sounds.boomStick = audio.loadSound(GLOBAL_soundsPath.."Player/BOOMSTICK.ogg")
		V.sounds.step1 = audio.loadSound( GLOBAL_soundsPath.."Player/Step1.ogg" )
		V.sounds.step2 = audio.loadSound( GLOBAL_soundsPath.."Player/Step2.ogg" )
		V.sounds.torchIdle = audio.loadSound( GLOBAL_soundsPath.."Player/TorchIdle.ogg" )
		audio.play(V.sounds.torchIdle, { channel = 2, loops = -1, fadein = 0})
		audio.setVolume( 0.4, {channel = 2} )
		audio.setVolume( 1, {channel = 3} )
		audio.setVolume( 0.8, {channel = 28} )
		audio.setVolume( 0.8, {channel = 29} )
		-- Setting up the lower body Animation
		V.lowerBody = display.newGroup()

		local runSheetOptions =
		{
			width = 140,
			height = 110,
			numFrames = 152
		}
		local lowerBodyRun_sheet = graphics.newImageSheet( GLOBAL_animationPath.."RunnerLegs.png", runSheetOptions )
		local lowerBodyRun_sequences = require "SpriteSeq.runner_legs_seq"
		V.lowerBodyRun_sprite = display.newSprite( V.lowerBody, lowerBodyRun_sheet, lowerBodyRun_sequences )
		V.lowerBodyRun_sprite.y = 50

		-- Setting up the upper Body Animation
		V.upperBody = display.newGroup()
		-- Setting up the upper Body Animation

		local runUpperSheetOptions =
		{
			width = 210,
			height = 220,
			numFrames = 88
		}
		local upperBodyRun_sequences = require "SpriteSeq.runner_torso_seq"
		local upperBodyRun_sheet = graphics.newImageSheet( GLOBAL_animationPath.."RunnerTorso.png", runUpperSheetOptions )

		V.upperBodyRun_sprite = display.newSprite( V.upperBody, upperBodyRun_sheet, upperBodyRun_sequences )

		-- Setting up the V.torch Animation

		local torchSheetOptions =
		{
			width = 120,
			height = 220,
			numFrames = 8
		}
		local torch_sheet = graphics.newImageSheet( GLOBAL_animationPath.."Torch.png",
													torchSheetOptions )
		local torch_sequences =
		{
			{
				name = "default",
				start = 1,
				count = 8,
				time = 800,
				loopCount = 0,
				loopDirection = "forward"
			}
		}

		V.torch = display.newSprite( torch_sheet, torch_sequences )
		V.torch:play()
		V.upperBody:insert( V.torch )


		local function animate(aimAngle, directionAngle, moving, velocity)
			-- Animate Upper Body
			local upperBodyAnim = ""
			local lowerBodyAnim = ""
			if aimAngle > 337 or aimAngle < 23 then
				upperBodyAnim = "Up"
				V.torch.x = -70
				V.torch.y = -100
			elseif aimAngle < 68 then
				upperBodyAnim = "UpRight"
				V.torch.x = -65
				V.torch.y = -120
			elseif aimAngle < 113 then
				upperBodyAnim = "Right"
				V.torch.x = 65
				V.torch.y = -135
			elseif aimAngle < 158 then
				upperBodyAnim = "DownRight"
				V.torch.x = 65
				V.torch.y = -125
			elseif aimAngle < 203 then
				upperBodyAnim = "Down"
				V.torch.x = 60
				V.torch.y = -105
			elseif aimAngle < 248 then
				upperBodyAnim = "DownLeft"
				V.torch.x = 30
				V.torch.y = -120
			elseif aimAngle < 293 then
				upperBodyAnim = "Left"
				V.torch.x = -10
				V.torch.y = -115
			else
				upperBodyAnim = "UpLeft"
				V.torch.x = -45
				V.torch.y = -105
			end
			-- Animate Lower Body
			-- 1. Get the direction moving compared to the direction facing
			-- 2. Set the animation based on the direction facing
			local reverse = false
			local localAngle = (aimAngle+360 - directionAngle) % 360
			if localAngle > 110 and localAngle < 250 and moving >= 0.1 then
				reverse = true
			end
			if directionAngle > 337 or directionAngle < 23 then
				lowerBodyAnim = "Up"
			elseif directionAngle < 68 then
				lowerBodyAnim = "UpRight"
			elseif directionAngle < 113 then
				lowerBodyAnim = "Right"
			elseif directionAngle < 158 then
				lowerBodyAnim = "DownRight"
			elseif directionAngle < 203 then
				lowerBodyAnim = "Down"
			elseif directionAngle < 248 then
				lowerBodyAnim = "DownLeft"
			elseif directionAngle < 293 then
				lowerBodyAnim = "Left"
			else
				lowerBodyAnim = "UpLeft"
			end

			if moving < 0.1 then
				--lowerBodyAnim = lowerBodyAnim .. "Stand"
				upperBodyAnim = upperBodyAnim .. "Stand"
				lowerBodyAnim = upperBodyAnim
			elseif reverse then
				lowerBodyAnim = lowerBodyAnim .. "Back" .. "Run"
			else
				lowerBodyAnim = lowerBodyAnim .. "Run"
			end

			if V.upperBodyAnim ~= upperBodyAnim then
				V.upperBodyRun_sprite:setSequence(upperBodyAnim)
				V.upperBodyRun_sprite:play()
				V.upperBodyAnim = upperBodyAnim
			end
			if V.lowerBodyAnim ~= lowerBodyAnim then
				V.lowerBodyRun_sprite:setSequence(lowerBodyAnim)
				V.lowerBodyRun_sprite:play()
				V.lowerBodyAnim = lowerBodyAnim
			end
			if moving >= 0.1 then
				V.upperBodyRun_sprite.timeScale = math.min(moving/100, 2.0)
				V.lowerBodyRun_sprite.timeScale = math.min(moving/100, 2.0)
			else
				V.upperBodyRun_sprite.timeScale = 1.0
				V.lowerBodyRun_sprite.timeScale = 1.0
			end
		end

		V.animate = animate

		function animateShotgunBlast(aimAngle)
			local anim = ""
			if aimAngle > 337 or aimAngle < 23 then
				anim = "Up"
				V.torch.x = -70
				V.torch.y = -100
			elseif aimAngle < 68 then
				anim = "UpRight"
				V.torch.x = -65
				V.torch.y = -120
			elseif aimAngle < 113 then
				anim = "Right"
				V.torch.x = 65
				V.torch.y = -135
			elseif aimAngle < 158 then
				anim = "DownRight"
				V.torch.x = 65
				V.torch.y = -125
			elseif aimAngle < 203 then
				anim = "Down"
				V.torch.x = 60
				V.torch.y = -105
			elseif aimAngle < 248 then
				anim = "DownLeft"
				V.torch.x = 30
				V.torch.y = -120
			elseif aimAngle < 293 then
				anim = "Left"
				V.torch.x = -10
				V.torch.y = -115
			else
				anim = "UpLeft"
				V.torch.x = -45
				V.torch.y = -105
			end
			anim = anim .. "Shoot"
			V.upperBodyRun_sprite:setSequence(anim)
			V.lowerBodyRun_sprite:setSequence(anim)
			V.upperBodyRun_sprite:play()
			V.lowerBodyRun_sprite:play()
			V.upperBodyAnim = anim
			V.lowerBodyAnim = anim
		end

		V.animateShotgunBlast = animateShotgunBlast

		local function footsteps()
			if string.sub( V.lowerBodyRun_sprite.sequence, -3 ) == "Run" then
				if V.lowerBodyRun_sprite.frame == 3 then
					audio.play( V.sounds.step1, { channel = 28, loops=0})
				elseif V.lowerBodyRun_sprite.frame == 7 then
					audio.play( V.sounds.step2, { channel = 29, loops=0})
				end
			end
		end
		V.footsteps = footsteps

		return V
	end
	P.spawn = spawn
return P
