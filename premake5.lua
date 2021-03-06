workspace "Hazel"
architecture "x64"

	configurations
	{
		"Debug",
		"Release",
		"Dist"
	}

outputdir = "%{cfg.buildcfg}-%{cfg.system}-%{cfg.architecture}"

-- Include directories relative to root folder (solution directory)
IncludeDir = {}
IncludeDir["GLFW"] = "Hazel/verdor/GLFW/include"

include "Hazel/verdor/GLFW"

project "Hazel"
	location "Hazel"
	kind "SharedLib"
	language "C++"

	targetdir("bin/" .. outputdir .. "/%{prj.name}")
	objdir("bin-int/" .. outputdir .. "/%{prj.name}")

	pchheader "hzpch.h"
	pchsource "Hazel/src/hzpch.cpp"

	files
	{
		"%{prj.name}/src/**.h",
		"%{prj.name}/src/**.cpp",
	}

	includedirs
	{
		"%{prj.name}/src",
		"%{prj.name}/verdor/spdlog/include",
		"%{IncludeDir.GLFW}"
	}

	links
	{
		"GLFW",
		"opengl32.lib"
	}


	filter "system:windows"
		cppdialect "C++17"
		staticruntime "on"
		systemversion "latest"

		defines
		{
			"_SCL_SECURE_NO_WARNINGS",
			"HZ_PLATFORM_WINDOWS",
			"HZ_BUILD_DLL",
		}

	postbuildcommands
	{
		("{COPY} %{cfg.buildtarget.relpath} ../bin/" .. outputdir .. "/Sandbox")
    }

	filter "configurations:Debug"
		defines "HZ_DEBUG"
		buildoptions "/MDd"
		symbols "On"

	filter "configurations:Release"
		defines "HZ_RELEASE"
		buildoptions "/MD"
		optimize "On"

	filter "configurations:Dist"
		defines "HZ_DIST"
		buildoptions "/MD"
		optimize "On"

project "Sandbox"
	location "Sandbox"
	kind "ConsoleApp"
	language "C++"

	targetdir("bin/" .. outputdir .. "/%{prj.name}")
	objdir("bin-int/" .. outputdir .. "/%{prj.name}")

	files
	{
		"%{prj.name}/src/**.h",
		"%{prj.name}/src/**.cpp",
	}

	includedirs
	{
		"Hazel/verdor/spdlog/include",
		"Hazel/src"
	}

	links
	{
		"Hazel"
	}

	filter "system:windows"
		cppdialect "C++17"
		staticruntime "on"
		systemversion "latest"

		defines
		{
			"_SCL_SECURE_NO_WARNINGS",
			"HZ_PLATFORM_WINDOWS",
		}


	filter "configurations:Debug"
		defines "HZ_DEBUG"
		buildoptions "/MDd"
		symbols "on"

	filter "configurations:Release"
		defines "HZ_RELEASE"
		buildoptions "/MD"
		optimize "on"

	filter "configurations:Dist"
		defines "HZ_DIST"
		buildoptions "/MD"
		optimize "on"