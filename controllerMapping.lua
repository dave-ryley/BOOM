local M = {}

-- Create table to map each controller's axis number to a usable name
	M.axis = {}
	M.axis[1] = "left_x"
	M.axis[2] = "left_y"
	M.axis[5] = "left_trigger"
	M.axis[3] = "right_x"
	M.axis[4] = "right_y"
	M.axis[6] = "right_trigger"

return M