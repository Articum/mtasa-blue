require 'utils'

premake.modules.install_data = {}

-- Config variables
local BIN_DIR = "Bin"
local DATA_DIR = "Shared/data/MTA San Andreas"

local NET_PATH_X64_WIN = "https://mirror-cdn.multitheftauto.com/bdata/net_64.dll"
local NETC_PATH_WIN = "https://mirror-cdn.multitheftauto.com/bdata/netc.dll"

newaction {
	trigger = "install_data",
	description = "Installs data files",

	execute = function()
		-- Make Bin directory if not exists
		local success, message = os.mkdir(BIN_DIR)
		if not success then
			errormsg("ERROR: Couldn't create Bin directory", "\n"..message)
			os.exit(1)
			return
		end

		-- Copy data files
		if os.host() == "windows" then
			local success, message = os.copydir(DATA_DIR, BIN_DIR)
			if not success then
				errormsg("ERROR: Couldn't create copy data directory", "\n"..message)
				os.exit(1)
				return
			end
		end

		-- Copy configs if they don't already exist
		local success, message = os.copydir("Server/mods/deathmatch", BIN_DIR.."/server/mods/deathmatch", "*.conf", false, true)
		if not success then
			errormsg("ERROR: Couldn't copy server config files", "\n"..message)
			os.exit(1)
			return
		end

		local success, message = os.copydir("Server/mods/deathmatch", BIN_DIR.."/server/mods/deathmatch", "mtaserver.conf.template", false, true)
		if not success then
			errormsg("ERROR: Couldn't copy server config files", "\n"..message)
			os.exit(1)
			return
		end

		local success, message = os.copydir("Server/mods/deathmatch", BIN_DIR.."/server/mods/deathmatch", "*.xml", false, true)
		if not success then
			errormsg("ERROR: Couldn't copy server xml files", "\n"..message)
			os.exit(1)
			return
		end

		-- Make sure server/x64 directory exists
		local success, message = os.mkdir(BIN_DIR.."/server/x64")
		if not success then
			errormsg("ERROR: Couldn't create server/x64 directory", "\n"..message)
			os.exit(1)
			return
		end

		if os.host() == "windows" then
			local success = http.download_print_errors(NET_PATH_X64_WIN, BIN_DIR.."/server/x64/net.dll")
			success = success and http.download_print_errors(NETC_PATH_WIN, BIN_DIR.."/MTA/netc.dll")

			-- A download failed
			if not success then
				os.exit(1)
				return
			end

			if not os.copyfile(BIN_DIR.."/MTA/netc.dll", BIN_DIR.."/MTA/netc_d.dll") then
				errormsg("ERROR: Could not copy netc.dll")
				os.exit(1)
				return
			end

			if not os.copyfile(BIN_DIR.."/server/x64/net.dll", BIN_DIR.."/server/x64/net_d.dll") then
				errormsg("ERROR: Could not copy server/x64/net.dll")
				os.exit(1)
				return
			end
		end
	end
}

return premake.modules.install_data
