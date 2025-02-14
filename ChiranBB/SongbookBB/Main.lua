import "Turbine.UI";
import "Turbine.UI.Lotro";
import "Turbine.Gameplay" -- needed for access to party object
-- Some global variables to differentiate between the patch version and the alternate (BB) version

gPlugin = "SongbookBB"
gDir = "ChiranBB/SongbookBB/"
gSettings = "SongbookSettingsBB"
SongbookDataTag = "SongbookBB"

import "ChiranBB.SongbookBB.Class"; -- Turbine library included so that there's no outside dependencies
import "ChiranBB.SongbookBB.ToggleWindow";
import "ChiranBB.SongbookBB.SettingsWindow";
import "ChiranBB.SongbookBB.SongbookLang";
import "ChiranBB.SongbookBB.Instrumentsz"; -- ZED
--import "ChiranBB.SongbookBB.___Debug"; -- Nim
import "ChiranBB.SongbookBB.InstrumentAssignments"; -- Nim
import "ChiranBB.SongbookBB.InstrAssignWindow"; -- Nim
import "ChiranBB.SongbookBB";

VERBOSITY = 10
function WRITE( s, v ) v = v or 0; if VERBOSITY > v then Turbine.Shell.WriteLine( s ); end; end
function ERROR( s ) Turbine.Shell.WriteLine( "<rgb=#D00000>"..s.."</rgb>" ); end
if not TRACE then
	if not TRACE then TRACE = function(s,v) end; end
	if not CTRACE then CTRACE = function(c,s,v) end; end
	if not INFO then INFO = function(v) end; end
	if not DEBUG_Prep then DEBUG_Prep = function( ) end; end
	if not ASSERT then ASSERT = function(c,s) end; end
	if not FS then FS = function(s) end; end 
	if not FE then FE = function(s) end; end 
end

mainWnd = ChiranBB.SongbookBB.SongbookWindow();
if ( Settings.WindowVisible == "yes" ) then
	mainWnd:SetVisible( true );
else
	mainWnd:SetVisible( false );
end

settingsWindow = ChiranBB.SongbookBB.SettingsWindow();
settingsWindow:SetVisible( false );

-- Nim: Added auto assignment windows
skillsWindow = ChiranBB.SongbookBB.InstrSkillsWindow( Settings.Assign.wndSkills, g_cfgUI.wndSkills );
skillsWindow:SetVisible( Settings.Assign.wndSkills.visible == "yes" );

assignWindow = ChiranBB.SongbookBB.InstrAssignWindow( Settings.Assign.wndAssign, g_cfgUI.wndAssign );
assignWindow:SetVisible( Settings.Assign.wndAssign.visible == "yes" );

priosWindow = ChiranBB.SongbookBB.InstrPrioWindow( Settings.Assign.wndPrios, g_cfgUI.wndPrios );
priosWindow:SetVisible( Settings.Assign.wndPrios.visible == "yes" );

WindowsInitialized()
-- Nim end

toggleWindow = ChiranBB.SongbookBB.ToggleWindow();
if ( Settings.ToggleVisible == "yes" ) then
	toggleWindow:SetVisible( true );
else 
	toggleWindow:SetVisible( false );
end

local function ParseCmdsBB( args )
	local bFoundCmd = false
	if args:find( Strings["sh_bctoggle"] ) then mainWnd:ToggleBiscuitCounter( ); bFoundCmd = true; end
	if args:find( Strings["sh_bcforall"] ) then mainWnd:ToggleBiscuitCounterForAll( ); bFoundCmd = true; end
	if args:find( Strings["sh_bcOnAnn"] ) then mainWnd:ToggleBiscuitCounterTrigger( ); bFoundCmd = true; end
	local iStart, iEnd = args:find( "debug" )
	if iEnd then bFoundCmd = g_debug:ParseCmds( args:sub( iEnd + 1 ) ); end
	iStart, iEnd = args:find( Strings["maxLen"] )
	if iStart then
		local sn = args:match( "%d+", iEnd + 1 )
		if not sn then Announcement.limit = 372
		else Announcement.limit = tonumber( sn ); end
		WRITE( Strings["annLimit"] .. tostring(Announcement.limit) )
		bFoundCmd = true
	end
	return bFoundCmd
end

songbookCommand = Turbine.ShellCommand();
function songbookCommand:Execute( cmd, args )
--WRITE( "args = " .. tostring( args ) )
	if ( args == Strings["sh_show"] ) then
		mainWnd:SetVisible( true );
	elseif ( args == Strings["sh_hide"] ) then
		mainWnd:SetVisible( false );
	elseif ( args == Strings["sh_toggle"] ) then
		mainWnd:SetVisible( not mainWnd:IsVisible() );
	elseif ParseCmdsBB( args ) then
	-- elseif ( args == Strings["sh_bctoggle"] ) then
	-- 	mainWnd:ToggleBiscuitCounter( )
	-- elseif ( args == Strings["sh_bcforall"] ) then
	-- 	mainWnd:ToggleBiscuitCounterForAll( )
	-- elseif ( args == Strings["sh_bcOnAnn"] ) then
	-- 	mainWnd:ToggleBiscuitCounterTrigger( )
	-- elseif ( string.sub( args, 1, #Strings["maxLen"] ) == Strings["maxLen"] ) then
	-- 	local sn = string.match( args, "%d+")
	-- 	if not sn then Announcement.limit = 372
	-- 	else Announcement.limit = tonumber( sn ); end
	-- 	WRITE( Strings["annLimit"] .. tostring(Announcement.limit) )
	elseif ( args ~= nil ) then
		songbookCommand:GetHelp();
	end
end

function songbookCommand:GetHelp()
	Turbine.Shell.WriteLine( Strings["sh_help1"] );
	Turbine.Shell.WriteLine( Strings["sh_help2"] );
	Turbine.Shell.WriteLine( Strings["sh_help3"] );
end
Turbine.Shell.AddCommand( "songbookBB", songbookCommand );
Turbine.Shell.WriteLine( "SongbookBB v"..Plugins["SongbookBB"]:GetVersion().." (Chiran, The Brandy Badgers, Zedrock)" );