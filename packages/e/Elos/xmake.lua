package("Elos")
	set_description("A colletion C++ helper classes")
	add_urls("https://github.com/ArnavMehta3000/Elos.git")
	add_versions("1.0.0", "5cf880513f12efaa28b7109ab96188da229b8274")
	set_license("MIT")

    add_configs("debug", { builtin = true, description = "Enable debug symbols.", default = false, type = "boolean", readonly = true })
	add_configs("shared", { description = "Build shared library.", default = true, type = "boolean", readonly = true })

    on_install("windows|x64", function (package)
		package:add("links", "user32", "gdi32", "dwmapi", "shcore", "Comctl32")
		
    	local configs = {}

		if package:config("shared") then
            configs.BuildShared = true
        end

		if package:debug() then
            configs.mode = "debug"
            configs.runtimes = "MDd"
			package:add("defines", "ELOS_BUILD_DEBUG=1")
        else
            configs.mode = "release"
            configs.runtimes = "MD"
			package:add("defines", "ELOS_BUILD_DEBUG=0")
        end

    	import("package.tools.xmake").install(package, configs)
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