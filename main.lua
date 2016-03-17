display.setStatusBar( display.HiddenStatusBar )

local controls = {}

local inputDevices = system.getInputDevices()
for i = 1,#inputDevices do
	local device = inputDevices[i]
	controls[device.descriptor] = presetControls.presetForDevice( device )
end

