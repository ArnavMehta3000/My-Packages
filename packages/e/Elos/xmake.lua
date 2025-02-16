package("Elos")
	set_description("A colletion C++ helper classes")
	add_urls("https://github.com/ArnavMehta3000/Elos.git")
	add_versions("1.0.0", "58b8065eba0fa86283d26cb73592d471b99cf32a")
	set_license("MIT")
	set_kind("library")

    add_configs("debug", { builtin = true, description = "Enable debug symbols.", default = false, type = "boolean", readonly = true })
	add_configs("shared", { description = "Build shared library.", default = false, type = "boolean", readonly = true })

    on_install("windows|x64", function (package)
		package:add("syslinks", "user32", "gdi32", "dwmapi", "shcore", "Comctl32")
		package:add("defines", "UNICODE", "_UNICODE", "NOMINMAX", "NOMCX", "NOSERVICE", "NOHELP", "WIN32_LEAN_AND_MEAN")
		
    	local configs = {}

		if package:config("shared") then
            configs.BuildShared = true
        end

		if package:config("debug") then
            configs.mode = "debug"
            configs.runtimes = "MDd"
			package:add("defines", "ELOS_BUILD_DEBUG=1")
        else
            configs.mode = "release"
            configs.runtimes = "MD"
			package:add("defines", "ELOS_BUILD_DEBUG=0")
        end
		
		if package:config("shared") then
			package:add("defines", "ELOS_EXPORTS")
		end

    	import("package.tools.xmake").install(package, configs)

		print(package:installdir())
    end)

	on_test(function (package)
        assert(package:check_cxxsnippets({ test = [[
            void test() 
			{
                Elos::i32 = -1;
                Elos::u32 = 0;
            }
        ]] }, { configs = {languages = "c++23"}, includes = "Elos/Common/StandardTypes.h"}))
    end)

package_end()