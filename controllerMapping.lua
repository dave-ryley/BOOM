M = {}

-- Create table to map each controller's axis number to a usable name
M.axis = {}
M.axis["Gamepad 1"] = {}
M.axis["Gamepad 1"][1] = "left_x"
M.axis["Gamepad 1"][2] = "left_y"
M.axis["Gamepad 1"][5] = "left_trigger"
M.axis["Gamepad 1"][3] = "right_x"
M.axis["Gamepad 1"][4] = "right_y"
M.axis["Gamepad 1"][6] = "right_trigger"

return M