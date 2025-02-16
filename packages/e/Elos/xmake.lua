package("Elos")
	set_description("A colletion C++ helper classes")
	add_urls("https://github.com/ArnavMehta3000/Elos")
	add_versions("v1.0.0", "5cf880513f12efaa28b7109ab96188da229b8274")
	set_license("MIT")

    add_configs("shared", { description = "Build as shared library", default = false, type = "boolean" })

    on_install("windows|x64", function (package)
    	if package:is_debug() then
    		package:add_defines("ELOS_BUILD_DEBUG=1")
    	else
    		package:add_defines("ELOS_BUILD_DEBUG=0")
    	end

    	local configs = {}

    	table.insert(configs, "--BuildShared=" .. (package:config("shared") and "y" or "n"))

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