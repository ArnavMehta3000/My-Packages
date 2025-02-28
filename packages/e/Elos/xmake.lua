package("Elos")
	set_description("A colletion C++ helper classes")
	add_urls("https://github.com/ArnavMehta3000/Elos.git")
	add_versions("1.0.0", "2eeeaf93ce1eb1adbe27ba87f684f1de4b88710d")
	set_license("MIT")
	set_kind("library")

	on_install("windows|x64", function (package)
		package:add("syslinks", "user32", "gdi32", "dwmapi", "shcore", "Comctl32")
		package:add("defines", "UNICODE", "_UNICODE", "NOMINMAX", "NOMCX", "NOSERVICE", "NOHELP", "WIN32_LEAN_AND_MEAN")

		local configs = {}

		if package:config("shared") then
			configs.BuildShared = true
		end

		if package:config("debug") then
			configs.mode = "debug"
			package:add("defines", "ELOS_BUILD_DEBUG=1")
		else
			configs.mode = "release"
			package:add("defines", "ELOS_BUILD_DEBUG=0")
		end

		if package:config("shared") then
			package:add("defines", "ELOS_EXPORTS")
		end

		import("package.tools.xmake").install(package, configs, { target = "Elos" })
	end)

	on_test(function (package)
		assert(package:check_cxxsnippets({ test = [[
			void Test()
			{
				Elos::i32 i = -1;
				Elos::u32 u = 0;
			}
		]] }, { configs = {languages = "c++23"}, includes = "Elos/Common/StandardTypes.h"}))
	end)

package_end()