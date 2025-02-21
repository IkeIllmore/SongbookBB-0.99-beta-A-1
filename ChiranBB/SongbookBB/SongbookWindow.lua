---@diagnostic disable: lowercase-global, duplicate-set-field
SongbookWindow = class( Turbine.UI.Window );

-- Fix to prevent Vindar patch from messing up anything since it's not needed
SongbookLoad = Turbine.PluginData.Load;
SongbookSave = Turbine.PluginData.Save;

-- Listbox
ListBoxScrolled = class( Turbine.UI.ListBox ); -- Listbox with child scrollbar and separator
ListBoxCharColumn = class( ListBoxScrolled ); -- Listbox with single char column

SuccessRGB = "<rgb=#00FF00>"
FailRGB = "<rgb=#FF0000>"

function SetDefault_AssignWnd( settings )
	if settings.Assign.wndAssign == nil then
		settings.Assign.wndAssign =
		{
			pos = { Left = "430", Top = "0", Width = "400", Height = "300" },
			visible = "no",
			targetChat = "g",
			listOrderBy = "n"
		}
	end
end
function SetDefault_AssignSkills( settings )
	if settings.Assign.wndSkills == nil then
		settings.Assign.wndSkills =
		{
			pos = { Left = "430", Top = "300", Width = "400", Height = "550" },
			visible = "no"
		}
	end
end
function SetDefault_AssignPrios( settings )
	if settings.Assign.wndPrios == nil then
		settings.Assign.wndPrios =
		{
			pos = { Left = "830", Top = "0", Width = "400", Height = "300" },
			visible = "no",
			playerFilter = "c"
		}
	end
end
function AmendSettings_BBzT( settings )
	if not settings then return; end
	if not settings.Assign then settings.Assign = { }; end
	SetDefault_AssignWnd( settings )
	SetDefault_AssignSkills( settings )
	SetDefault_AssignPrios( settings )
end
function AmendSettings_BBz( settings )
	if not settings then return; end
	if not settings.Assign then settings.Assign = { }; end
	SetDefault_AssignWnd( settings )
	SetDefault_AssignSkills( settings )
	SetDefault_AssignPrios( settings )
end
function AmendSettings_BB( settings )
	if not settings then return; end
	AmendSettings_BBz( settings ) -- add assignment settings
	settings.InstrsHeight = "40"
	if not settings.DirHeight then settings.DirHeight = "95"; end
	if not settings.TracksHeight then settings.TracksHeight = "215"; end
	local th = tonumber( settings.TracksHeight )
	local dh = tonumber( settings.DirHeight )
	local wh = tonumber( settings.WindowPosition.Height )
	if th and dh and wh then settings.SongsHeight = tostring( wh - 240 - th - dh - 40 )
	else settings.SongsHeight = "150"; end
end

function Settings_Mod( wndPos, f )
	wndPos.Left = f( wndPos.Left )
	wndPos.Top = f( wndPos.Top )
	wndPos.Width = f( wndPos.Width )
	wndPos.Height = f( wndPos.Height )
end
function ModifySettings( settings, f ) 
	Settings_Mod( settings.Assign.wndAssign.pos, f )
	Settings_Mod( settings.Assign.wndSkills.pos, f )
	Settings_Mod( settings.Assign.wndPrios.pos, f )
end

-- Deferred creation of windows which need settings to be loaded  TODO: use constructor parameter instead
function WindowsInitialized( )
	assignWindow:Create( )
	skillsWindow:Create( )
	priosWindow:Create( )
	--if wndPlaylist then wndPlaylist:Create( ); end
	mainWnd:Initialized( )
end

-- Notify windows they are about to be destroyed, so they can save state to Settings 
function DestroyWindows( )
	assignWindow:Save()
	skillsWindow:Save()
end

function SX( v ) return v; end
function SY( v ) return v; end
function S( x, y ) return x, y; end
-- Settings Default Values
-- ZEDMOD: Adding SongsHeight and InstrsHeight default values
Settings = { 
	Version = "0.98",
	WindowPosition = { 
		Left = "0", -- ZEDMOD: OriginalBB value: 700
		Top = "0", -- ZEDMOD: OriginalBB value: 20
		Width = "430", -- ZEDMOD: OriginalBB value: 342
		Height = "750" -- ZEDMOD: OriginalBB value: 398
		}, 
	WindowVisible = "yes", -- ZEDMOD: OriginalBB value: no
	WindowOpacity = "0.9", 
	DirHeight = "95", -- BB, was 40 ZEDMOD: OriginalBB value: 100
	SongsHeight = "155", -- BB, was 40 ZEDMOD
	TracksHeight = "215", -- BB, was 40 ZEDMOD: OriginalBB value: 50
	InstrsHeight = "40", -- ZEDMOD
	TracksVisible = "yes", -- ZEDMOD: OriginalBB value: no
	ToggleVisible = "yes", 
	ToggleLeft = tostring( Turbine.UI.Display.GetWidth() - 75 ), -- ZEDMOD: OriginalBB value -55
	ToggleTop = "0", 
	ToggleOpacity = "1", -- ZEDMOD: OriginalBB value 0.25
	SearchVisible = "yes", 
	DescriptionVisible = "no", 
	DescriptionFirst = "no",
	LastDirOnLoad = "no" 
	};

-- Lang
-- if ( ( lang == "de" ) or ( lang == "fr") ) then
	-- if ( ( Turbine.Engine.GetLocale() == "de" ) or ( Turbine.Engine.GetLocale() == "fr" ) ) then
		-- Settings.WindowOpacity = "0,9";
	-- end
-- end

euroFormat = ( tonumber( "1,000" ) == 1 );
if ( euroFormat ) then
	Settings.WindowOpacity = "0,9";
	--Settings.ToggleOpacity = "0,25"; -- ZEDMOD: OriginalBB
else
	Settings.WindowOpacity = "0.9";
	--Settings.ToggleOpacity = "0.25"; -- ZEDMOD: OriginalBB
end

-- Dir
selectedDir = "/"; -- set the default dir
dirPath = {}; -- table holding directory path
dirPath[1] = "/"; -- set first item as root dir

-- Library Size
librarySize = 0;

-- Song
selectedSong = ""; -- set the default song
selectedSongIndex = 1;

-- Track
selectedTrack = 1; -- set the default track

-- Char settings
if ( Settings.LastDirOnLoad == "yes" ) then
	CharSettings = {
		dirPath = {} -- table holding directory path
	};
	CharSettings.dirPath[1] = "/"; -- set first item as root dir
else
	CharSettings = {};
end

-- Song DB
SongDB = {
	Directories = {},
	Songs = {}
};

UI =
{
	indLeft = 10,
	hTextBox = 20,
	hStdBtn = 20,
	hStdCb = 20,
	font = Turbine.UI.Lotro.Font.Verdana16, -- original:LucidaConsole12,
	sep = 
	{
		s = 10, -- separator size
		sHandle = 20, -- separator handle size
		sMain = 16, -- main separator size
		hdgFont = Turbine.UI.Lotro.Font.TrajanPro16,
	},
	hInstrAlert = 23,
	yInstrAlert = 88,
	xBiscuit = 380, yBiscuit = 58,
	xCounter = 322, yCounter = 54,
	hPlayerBtn = 0,
	listFrame =
	{
		y = 134,
		hHdg = 13,
		font = Turbine.UI.Lotro.Font.TrajanPro13
	},
	lb =
	{
		hItem = 20,
		sScrollbar = 10, -- scrollbar size
		font = Turbine.UI.Lotro.Font.Verdana16, -- original:LucidaConsole12
		players =
		{
			fontLead = Turbine.UI.Lotro.Font.TrajanPro16
		},
		tracks =
		{
			font = Turbine.UI.Lotro.Font.Verdana16,
		},
		instr =
		{
			font = Turbine.UI.Lotro.Font.Verdana16,
		},
	},
	wCharCol = 20,
	scs = 
	{
		w = 32, h = 30,
		y = 50,
		xMusic = 20,
		xPlay = 60,
		xReady = 100, -- orig 120, Zed 110
		xSync = 140, -- orig 161, Zed 151
		xTrack = 190, -- orig 247, Zed 237
		xShare = 230, -- orig 287, Zed 270
		xSyncStart = 280,-- orig 202, Zed 192
	},

	search = 
	{
		yPos = 110,
		height = 20,
		wiChecks = 65,
		wiInput = 135,
		wiSearchBtn = 60,
		wiTags = 70,
		wiMode = 27,
		wiModeLb = 150,
		wiModeOvl = 6,
		wiClearBtn = 55,
		xSpacing = 5,
		rightInd = 10,
	},

	fonts =
	{
		listFrameHdg = Turbine.UI.Lotro.Font.TrajanPro13,
		listItem = Turbine.UI.Lotro.Font.LucidaConsole12,
	},

	colour =
	{
		listFrame = Turbine.UI.Color( 1, 0.15, 0.15, 0.15 ),
		defHighlighted = Turbine.UI.Color( 1, 0.15, 0.95, 0.15 ), -- Green Light
		readyHighlighted = Turbine.UI.Color( 1, 0.15, 0.60, 0.15 ), -- Green Dark
		readyMultipleHighlighted = Turbine.UI.Color( 1, 0.7, 0.7, 1 ), -- Purple Light
		default = Turbine.UI.Color( 1, 1, 1, 1 ), -- White
		ready = Turbine.UI.Color( 1, 0.4, 0.4, 0 ), -- Green Yellow
		readyMultiple = Turbine.UI.Color( 1, 0.6, 0.6, 0.95 ), -- Purple
		differentSong = Turbine.UI.Color( 1, 0, 0 ), -- Red
		differentSetup = Turbine.UI.Color( 1, 0.6, 0 ), -- Orange
		wrongInstrument = Turbine.UI.Color( 1, 0.6, 0 ), -- Orange
		backDefault = Turbine.UI.Color( 1, 0, 0, 0 ), -- Black
		backHighlight = Turbine.UI.Color( 1, 0.1, 0.1, 0.1 ), -- Grey
		active = Turbine.UI.Color( 1, 0.92, 0.80, 0.55 ), --0.91, 0.67, 0.24 );
		btnFont = Turbine.UI.Color( 1, 1, 1, 0.05 ), 
		black = Turbine.UI.Color( 1, 0, 0, 0 ), -- Black
		alert = Turbine.UI.Color( 1, 0.60, 0.10, 0.10 ),
		},

	aWidths =
	{
		["en"] =
		{
			["filters"] = 75,
		},
	},
	W = function( self, v ) return self.aWidths[lang][ v ]; end,
}

	
local function Update( self )
	if self.bCounterActive then self:UpdateCounter( ); end
	if self.bPeriodicActive then self:UpdatePeriodic( ); end
end

local function LoadEvHandlerSongDB( d )
	if not d or #d.Songs <= 0 then
		WRITE( FailRGB..Strings["SongsReloadFail"].."</rgb>" )
		mainWnd:SongsLoadFail( )
		return; end
	SongDB = d
	WRITE( SuccessRGB..Strings["SongsReloadOk"].."</rgb>" )
	selectedDir = "/"
	mainWnd:InitListsForSongDB( )
end


function SongbookWindow:ReloadSongDB( )
	SongbookLoad( Turbine.DataScope.Account, "SongbookData", LoadEvHandlerSongDB )
end


function SongbookWindow:LoadCharSettings( )
	local charSets = SongbookLoad( Turbine.DataScope.Character, gSettings )
	if not charSets or not charSets.Version then -- old version, see if there are newer ones
		local BBzT = SongbookLoad( Turbine.DataScope.Character, "SongbookSettingsBBzT" )
		if BBzT then WRITE( "Loaded BBzT version of CharSettings." ); return BBzT; end
		local BBz = SongbookLoad( Turbine.DataScope.Character, "SongbookSettingsBBz" )
		if BBz then WRITE( Strings["loadCharBBz"] ); return BBz; end
	else return charSets; end
	if charSets then WRITE( Strings["loadCharBB"] )
	else WRITE( Strings["noChar"] ); end
	return charSets	
end

function SongbookWindow:LoadSettings( )
	ServerData:Load( SongbookDataTag )
	if not ServerData:IsValid( ) then ServerData:Load( "SongbookBBzT" ); end
	ServerData:Verify( )
	SkillsData:CopyFromSD( );
	PriosData:CopyFromSD( );
	
	local settings = SongbookLoad( Turbine.DataScope.Account, "SongbookSettingsBB" )
	if not settings or not settings.Version then
		WRITE( Strings["noCurChar"] )
		local BBzT = SongbookLoad( Turbine.DataScope.Account, "SongbookSettingsBBzT" ) -- Try test version settings first
		if BBzT then
WRITE( "BBzT version found, attempting to convert skills/preferences." ) -- TODO: remove BBzT
			SkillsData:CheckVersion( BBzT ); PriosData:CheckVersion( BBzT ) -- convert old data if present
			settings = BBzT; AmendSettings_BBzT( settings ) -- BBzT version supersedes old BB version
		else
			local BBz = SongbookLoad( Turbine.DataScope.Account, "SongbookSettingsBBz" ) -- BBz closer than BB, still needs to be amended
			if BBz then settings = BBz; AmendSettings_BBz( settings )
				WRITE( Strings["loadServerBBz"] )
			elseif settings then
				WRITE( Strings["loadServerBB"].."\n" ); AmendSettings_BB( settings )
			end
		end
	end
	if not settings then
		settings = SongbookLoad( Turbine.DataScope.Account, "SongbookSettings" )
		if settings then WRITE( Strings["loadServerOrig"].."\n" );
		else settings = Settings; WRITE( Strings["noServer"].."\n" ); end
		AmendSettings_BB( settings )
	end
	SkillsData:Init( )
	PriosData:Init( )
	return settings
end


local function SetupInstrShortcutChanged( w, i )
	local si = tostring( i )
	w.instrSlot[i].ShortcutChanged = function( sender, args )
		local bResult, sError = pcall( function() 
			local sc = sender:GetShortcut();
			CharSettings.InstrSlots[si].qsType = tostring( sc:GetType() );
			CharSettings.InstrSlots[si].qsData = sc:GetData();
			-- Added for backpack instr update:
			local item = sc:GetItem() 
			if item and ( not CharSettings.InstrMap or not CharSettings.InstrMap.bNoRef ) then
				if not CharSettings.InstrMap then CharSettings.InstrMap = {}; end
				CharSettings.InstrMap[ item:GetName() ] = { ["type"] = tostring( sc:GetType() ), data = sc:GetData() }
	 			CharSettings.InstrSlots[si].item = item:GetName()
--TRACE( "Setting up "..item:GetName().." reference for slot #"..si)
			end
		end )
		if not bResult then ERROR( sError ); end
	end
end

local instrdrag = false;
local function SetupInstrDragLeave( w, i )
	w.instrSlot[i].DragLeave = function( sender, args )
		if not instrdrag then return; end
		local si = tostring( i )
		CharSettings.InstrSlots[si].qsType =""
		CharSettings.InstrSlots[si].qsData = ""
		CharSettings.InstrSlots[si].item = nil
		local sc = Turbine.UI.Lotro.Shortcut( "", "" )
		w.instrSlot[i]:SetShortcut( sc );
		instrdrag = false;
	end
end

--------------------------
-- Songbook Main Window --
--------------------------
-- Songbook Window : Constructor
function SongbookWindow:Constructor()
	Turbine.UI.Lotro.Window.Constructor( self );
	
	Instruments:Setup( )
	-- Song Database : Load
	SongDB = SongbookLoad( Turbine.DataScope.Account, "SongbookData" ) or SongDB;
	
	-- Settings : Load
	Settings = self:LoadSettings( )
	if not Settings.Assign then AmendSettings_BB( Settings ); end
	Settings.Version = "1.0"
	
--	Settings = SongbookLoad( Turbine.DataScope.Account, gSettings ) or Settings;
--	AmendSettings_BBz( Settings ) -- Nim: Add the default settings for the auto assignment feature
	
	-- ZEDMOD: Fix Local and Langue when FR/DE Lotro client switched in EN Language; Nim: Split up combined function
	Settings.ToggleOpacity = FixLocLangFormat( euroFormat, Settings.ToggleOpacity );
	Settings.WindowOpacity = FixLocLangFormat( euroFormat, Settings.WindowOpacity );
	
	-- Character Settings : Load
	CharSettings = self:LoadCharSettings( ) or CharSettings
	CharSettings.Version = "1.0"
	
	if ( Settings.LastDirOnLoad == "yes" ) then
		if (CharSettings.dirPath ~= nil) then
			for i = 1, #CharSettings.dirPath do
				dirPath[i] = CharSettings.dirPath[i];
			end
		end
	
		-- init selectedDir from dirPath
		selectedDir = "";
		for i = 1, #dirPath do
			selectedDir = selectedDir .. dirPath[i];
		end
	end

	-- Badger Variables for Filters, Players list, Setups
	self.player = nil
	self.party = nil
	self.sFilterPartcount = nil; -- A char for every acceptable part count, with 'A' being solo, 'B' two parts, etc.
	self.maxTrackCount = 25; -- Assumed maximum number of track setups (adjust if necessary)
	self.bFilter = false; -- show/hide filter UI -- ZEDMOD: Now,separate to Players list
	self.bWaitingForSongname = false -- retrieve announcement song name
	self.bChiefMode = true; -- enables sync start shortcut, uses party object ( seems to work for FS leader )
	self.bSoloMode = true; -- enables play start shortcut
	self.bShowAllBtns = false; -- show/hide R, S, and track selector
	self.bShowPlayers = true; -- show/hide players listbox (used for auto-hide, but disabled for now)
	self.aFilteredIndices = {}; -- Array for filtered indices, k = display index; v = SongDB index
	self.aPlayers = {}; -- k = player name, v = ready track, 0 if no track ready
	self.nPlayers = 0; -- number of players (unfortunately not as simple as #self.aPlayers)
	self.sPlayerName = nil; -- name of player
	self.sLeaderName = nil; -- name of FS/Raid leader
	self.aCurrentSongReady = {}; -- k = player name; v = track ready state (see GetTrackReadyState())
	self.aReadyTracks = ""; -- indicates which tracks are ready (A = 1st, B = 2nd, etc). Used for setup checks
	self.aSetupTracksIndices = {}; -- when tracks are filtered for a setup, this array contains track indices
	self.aSetupListIndices = {}; -- list index for tracks that are part of the currently selected setup
	self.iCurrentSetup = nil; -- indicates which setup is currently selected
	self.selectedSetupCount = 'A'; -- Stores the code of the current setup to select it on song change, if available
	self.maxPartCount = nil; -- the number of parts to use as filter (nil if not filtering, else player count)
	self.alignTracksRight = false; -- if true, track names are listed right-aligned (resize will reset to left aligned)
	self.listboxSetupsWidth = 20; -- width of the setups listbox (to the left of the tracks list)
	self.setupsWidth = self.listboxSetupsWidth + UI.lb.sScrollbar; -- total width of setup list including scrollbar
	self.bShowSetups = false; -- show/hide setups (autohide for songs with no setups defined)
	self.anCpt = {}
	self.bCheckInstrument = true;
	self.bInstrumentOk = true;
	self.bDisplayTimer = false;
	self.bTimerCountdown = false;
	self.bShowReadyChars = true;
	self.bHighlightReadyCol = false;
	self.chNone = " ";
	self.chReady = "~";
	self.chWrongSong = "S";
	self.chWrongPart = "P";
	self.chMultiple = "M";

	self.ButtonRow = { xPos = 30,
		wiReload = 28, wiSettings = 70, wiTrackAnc = 70, wiInform = 80, wiAssign = 75,
		height = 20, spacing = 5, btmIndent = 11 }

	self.bParty = false; -- ZEDMOD: show/hide party UI
	
	-- ZEDMOD: New Instrument Slots Settings
	self.bInstrumentsVisible = false; -- Instrument Slots Visible Horizontal
	self.bInstrumentsVisibleHForced = false; -- Instrument Slots Visible Horizontal
	
	--************
	--* Settings *
	--************
	-- Legacy fixes
	self:FixIfNotSettings( Settings, SongDB, CharSettings );
	
	-- Unstringify Settings values
	Settings.WindowPosition.Left = tonumber( Settings.WindowPosition.Left );
	Settings.WindowPosition.Top = tonumber( Settings.WindowPosition.Top );
	Settings.WindowPosition.Width = tonumber( Settings.WindowPosition.Width );
	Settings.WindowPosition.Height = tonumber( Settings.WindowPosition.Height );
	Settings.ToggleTop = tonumber( Settings.ToggleTop );
	Settings.ToggleLeft = tonumber( Settings.ToggleLeft );
	Settings.DirHeight = tonumber( Settings.DirHeight );
	Settings.DirWidth = tonumber( Settings.DirWidth )
	Settings.FiltersWidth = tonumber( Settings.FiltersWidth );
	Settings.SongsHeight = tonumber( Settings.SongsHeight ); -- ZEDMOD
	Settings.TracksHeight = tonumber( Settings.TracksHeight );
	Settings.InstrsHeight = tonumber( Settings.InstrsHeight ); -- ZEDMOD
	Settings.WindowOpacity = tonumber( Settings.WindowOpacity );
	Settings.ToggleOpacity = tonumber( Settings.ToggleOpacity );
	CharSettings.InstrSlots["number"] = tonumber( CharSettings.InstrSlots["number"] );
	ModifySettings( Settings, tonumber )
	--CheckSettings_Assignment( Settings )

	-- Fix to prevent window or toggle to travel outside of the screen
	self:ValidateWindowPosition( Settings.WindowPosition );
	--self:FixWindowSettings( Settings.WindowPosition ); -- ZEDMOD: OriginalBB disabled
	self:FixToggleSettings( Settings.ToggleTop, Settings.ToggleLeft ); -- ZEDMOD: Moved original code in function
	
	--CreateWindows()
	
	--*******************************
	--* Hide UI when F12 is pressed *
	--*******************************
	local hideUI = false;
	local wasVisible;
	self:SetWantsKeyEvents( true );
	self.KeyDown = function( sender, args )
		if ( args.Action == 268435635 ) then
			if ( not hideUI ) then
				hideUI = true;
				if ( self:IsVisible() ) then
					wasVisible = true;
					self:SetVisible( false );
				else
					wasVisible = false;
				end
				settingsWindow:SetVisible( false );
				assignWindow:SetVisible( false );
				skillsWindow:SetVisible( false );
				toggleWindow:SetVisible( false );
			else
				hideUI = false;
				if ( wasVisible ) then
					self:SetVisible( true );
					settingsWindow:SetVisible( false );
					assignWindow:SetVisible( false );
					skillsWindow:SetVisible( false );
				end
				if ( Settings.ToggleVisible == "yes" ) then
					toggleWindow:SetVisible( true );
				end
			end
		end
	end
	
	--************************
	--* Songbook Main Window *
	--************************
	-- Songbook Window Set Position
	self:SetPosition( Settings.WindowPosition.Left, Settings.WindowPosition.Top );
	
	-- Songbook Window Set Size
	self:SetSize( Settings.WindowPosition.Width, Settings.WindowPosition.Height );
	
	-- Songbook Window Set Z Order
	--self:SetZOrder( 10 );
	
	-- Songbook Window Set Opacity
	self:SetOpacity( Settings.WindowOpacity );
	
	-- Songbook Window Set Text
	self:SetText( "Songbook " .. Plugins[gPlugin]:GetVersion() .. Strings["title"] );
	
	-- Songbook Window Min and Max values
	local displayWidth, displayHeight = Turbine.UI.Display.GetSize();
	self.minWidth = 393; -- ZEDMOD: OriginalBB value: 342
	self.minHeight = 294; -- ZEDMOD: OriginalBB value: 308
	self.maxWidth = displayWidth;
	self.maxHeight = displayHeight;
	
	-- Songbook Window X Coords for ListFrame and ListContainer
	self.lFXmod = 20; -- listFrame x coord modifier -- ZEDMOD: OriginalBB value: 23
	self.lCXmod = 24; -- listContainer x coord modifier ( old value: 42) -- ZEDMOD: OriginalBB value: 28
	
	-- ZEDMOD: Add Songbook Window Y Coords for ListFrame and ListContainer
	self.lFYmod = 169; -- listFrame y coord modifier = difference between bottom pixels and window bottom
	self.lCYmod = 188; -- listContainer y coord modifier = difference between bottom pixels and window bottom
	
	--**************
	--* List Frame *
	--**************
	-- List Frame
	self.listFrame = Turbine.UI.Control();
	self.listFrame:SetParent( self );
	self.listFrame:SetBackColor( UI.colour.listFrame );
	self.listFrame:SetPosition( 10, UI.listFrame.y ); -- ZEDMOD: OriginalBB value: ( 12, 134 )
	--self.listFrame:SetSize( self:GetWidth() - self.lFXmod, self:GetHeight() - self.lFYmod );
	
	-- Liste Frame Header
	self.listFrame.heading = Turbine.UI.Label();
	self.listFrame.heading:SetParent( self.listFrame );
	self.listFrame.heading:SetLeft( 5 );
	self.listFrame.heading:SetSize( self.listFrame:GetWidth(), UI.listFrame.hHdg );
	self.listFrame.heading:SetFont( UI.listFrame.font );
	--self.listFrame.heading:SetText( Strings["ui_dirs"] ); -- ZEDMOD: OriginalBB
	self.listFrame.heading:SetText( "" );
	
	-- ZEDMOD: Create Message Txt box for timer and instruments
	self:CreateInstrLabel( ) -- (Nim) Added instrument indicator
	self:CreateAlertLabel(); -- Adding message for timer and instruments to header
	self:CreateTimerLabel() -- (Nim) split off separate label for the timer
	
	--******************
	--* List Container *
	--******************
	-- List Container
	self.listContainer = Turbine.UI.Control();
	self.listContainer:SetParent( self );
	self.listContainer:SetBackColor( Turbine.UI.Color( 1, 0, 0, 0 ) );
	self.listContainer:SetPosition( 12, 147 ); -- ZEDMOD: OriginalBB value ( 18, 147 )
	--self.listContainer:SetSize( self:GetWidth() - self.lCXmod, self:GetHeight() - self.lCYmod );
	
	--*******************
	--* List Separators *
	--*******************
	-- ZEDMOD: Dir Header Separator
	self.sepDirs = self:CreateMainSeparator( UI.sep.sMain );
	self.sepDirs:SetVisible( true );
	self.sepDirs.hdgDir = self:CreateSeparatorHeading( self.sepDirs, Strings["ui_dirs"], 200 ); -- ZEDMOD
	--self.sepDirs.hdgFilter = self:CreateSeparatorHeading( self.sepDirs, Strings["ui_filters"] ); -- ZEDMOD

	-- Separator1 : sepDirsSongs : between Dir List and Song List (0, DirHeight)
	-- ZEDMOD: OriginalBB Separator1 renamed as sepDirsSongs
	--self.separator1 = self:CreateMainSeparator( Settings.DirHeight ); -- ZEDMOD: OriginalBB
	self.sepDirsSongs = self:CreateMainSeparator( Settings.DirHeight ); -- ZEDMOD
	--self.separator1:SetVisible(true); -- ZEDMOD: OriginalBB
	self.sepDirsSongs:SetVisible( true ); -- ZEDMOD
	--self.separator1.heading = self:CreateSeparatorHeading( self.separator1, Strings["ui_songs"] ); -- ZEDMOD: OriginalBB
	self.sepDirsSongs.hdgPlayers = self:CreateSeparatorHeading( self.sepDirsSongs, Strings["players"] ); -- ZEDMOD
	self.sepDirsSongs.hdgSongs = self:CreateSeparatorHeading( self.sepDirsSongs, Strings["ui_songs"] ); -- ZEDMOD
	self.sArrows1 = self:CreateSeparatorArrows( self.sepDirsSongs );
	
	-- Separator2 : sepSongsTracks : between Song List and Track List
	--self.sepSongsTracks = self:CreateMainSeparator( self.listContainer:GetHeight() - Settings.TracksHeight - 13 ); -- ZEDMOD: OriginalBB
	self.sepSongsTracks = self:CreateMainSeparator( Settings.DirHeight + UI.sep.sMain + Settings.SongsHeight ); -- ZEDMOD
	self.sepSongsTracks:SetVisible( false );
	self.sepSongsTracks.heading = self:CreateSeparatorHeading( self.sepSongsTracks, Strings["ui_parts"] );
	self.sArrows2 = self:CreateSeparatorArrows( self.sepSongsTracks );
	
	-- ZEDMOD: Add separator between Tracks and Instruments
	-- Separator3 : sepTracksInstrs : between Track List and Instrument List (SongsHeight + 13, TracksHeight)
	self:CreateTrackInstrSep( )
	
	--***********
	--* Tooltip *
	--***********
	self.tipLabel = Turbine.UI.Label();
	self.tipLabel:SetParent( self );
	self.tipLabel:SetPosition( self:GetWidth() - 270, 27 );
	self.tipLabel:SetSize( 245, 30 );
	self.tipLabel:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleRight );
	self.tipLabel:SetText( "" );
	
	--***********
	--* Buttons *
	--***********
	-- Nim: Moved the sync start button to the right and changed to signal
	-- colour, so users don't mix it up with sync

	-- Music mode button
	self.musicSlot = self:CreateMainShortcut(UI.scs.xMusic);
	-- Trying to fix the problem with unresponsive buttons. Haven't found out yet how to disable
	-- dragging from a quickslot altogether, so for now this just restores the shortcut.
	self.musicSlotShortcut = Turbine.UI.Lotro.Shortcut( Turbine.UI.Lotro.ShortcutType.Alias, Strings["cmd_music"]);
	self.musicSlot.DragDrop =
	function( sender, args )
		if( self.musicSlotShortcut ) then
			self.musicSlot:SetShortcut( self.musicSlotShortcut ); -- restore shortcut
		end
	end
	self.musicSlot:SetShortcut( self.musicSlotShortcut );
	self.musicSlot:SetVisible( true );
	
	-- Play button
	-- NOTE: since the cmd depends on the track name, the shortcut is created below in SelectTrack()
	self.playSlot = self:CreateMainShortcut(UI.scs.xPlay); -- Nim: orig 60
	self.playSlot.DragDrop =
	function( sender, args )
		if( self.playSlotShortcut ) then
			self.playSlot:SetShortcut( self.playSlotShortcut ); -- restore shortcut
		end
	end
	
	-- Ready check button
	self.readySlot = self:CreateMainShortcut(UI.scs.xReady); -- Nim: orig 120
	self.readySlot:SetShortcut( Turbine.UI.Lotro.Shortcut( Turbine.UI.Lotro.ShortcutType.Alias, Strings["cmd_ready"]));
	self.readySlot:SetVisible( self.bShowAllBtns );
	
	-- Sync button, NOTE: as for play, shortcut is created below in SelectTrack()
	self.syncSlot = self:CreateMainShortcut(UI.scs.xSync); -- Nim: orig 161
	self.syncSlot.DragDrop =
	function( sender, args )
		if( self.syncSlotShortcut ) then
			self.syncSlot:SetShortcut( self.syncSlotShortcut ); -- restore shortcut
		end
	end
	
	-- Share button
	self.shareSlot = self:CreateMainShortcut(UI.scs.xShare); -- Nim: orig 287
	if (Settings.Commands[Settings.DefaultCommand]) then
		self.shareSlot:SetShortcut( Turbine.UI.Lotro.Shortcut( Turbine.UI.Lotro.ShortcutType.Alias, self:ExpandCmd(Settings.DefaultCommand)));
	end

	-- Sync start button
	-- Nim: Moved all the way to the right so it is less often accidentally clicked instead of sync
	self.syncStartSlot = self:CreateMainShortcut(UI.scs.xSyncStart); -- Nim: orig 202
	self.syncStartSlotShortcut = Turbine.UI.Lotro.Shortcut( Turbine.UI.Lotro.ShortcutType.Alias, Strings["cmd_start"] );
	self.syncStartSlot.DragDrop =
	function( sender, args )
		if( self.syncStartSlotShortcut ) then
			self.syncStartSlot:SetShortcut( self.syncStartSlotShortcut ); -- restore shortcut
		end
	end
	self.syncStartSlot:SetShortcut(self.syncStartSlotShortcut);

	self:InitBiscuitCounter( ) -- BISCUIT!

		-- Track label
	self.trackLabel = Turbine.UI.Label();
	self.trackLabel:SetParent( self );
	self.trackLabel:SetPosition( UI.scs.xTrack, 63 ); -- Nim: orig 247
	self.trackLabel:SetSize(30, 12);
	self.trackLabel:SetZOrder(200);
	self.trackLabel:SetText("X:");

	-- Track number
	self.trackNumber = Turbine.UI.Label();
	self.trackNumber:SetParent( self );
	self.trackNumber:SetPosition(UI.scs.xTrack+15, 63);
	self.trackNumber:SetWidth(20);
	
	-- Track up arrow
	self.trackPrev = Turbine.UI.Control();
	self.trackPrev:SetParent( self );
	self.trackPrev:SetPosition(UI.scs.xTrack+5, 51);
	self.trackPrev:SetSize(12, 8);
	self.trackPrev:SetBackground(gDir .. "arrowup.tga");
	self.trackPrev:SetBackground(gDir .. "arrowup.tga");
	self.trackPrev:SetBlendMode( Turbine.UI.BlendMode.AlphaBlend );
	self.trackPrev:SetVisible( false );
	
	-- Track down arrow
	self.trackNext = Turbine.UI.Control();
	self.trackNext:SetParent( self );
	self.trackNext:SetPosition(UI.scs.xTrack+5, 78);
	self.trackNext:SetSize(12, 8);
	self.trackNext:SetBackground(gDir .. "arrowdown.tga");
	self.trackNext:SetBlendMode( Turbine.UI.BlendMode.AlphaBlend );
	self.trackNext:SetVisible( false );
	
	self.trackLabel:SetVisible( self.bShowAllBtns )
	self.trackNumber:SetVisible( self.bShowAllBtns )

	-- Track actions for track change
	self.trackPrev.MouseClick = function( sender, args )
		if ( args.Button == Turbine.UI.MouseButton.Left ) then
			self:SelectTrack( selectedTrack - 1 );
		end
	end
	
	-- Track actions for track change
	self.trackNext.MouseClick = function( sender, args )
		if ( args.Button == Turbine.UI.MouseButton.Left ) then
			self:SelectTrack( selectedTrack + 1 );
		end
	end
	
	--****************
	--* Mouse Events *
	--****************
	
	-- Music Slot : Mouse Enter
	self.musicSlot.MouseEnter = function( sender, args )
		self.musicIcon:SetBackground( gDir .. "icn_m_hover.tga" );
		self.tipLabel:SetText( Strings["tt_music"] );
	end
	
	-- Music Slot : Mouse Leave
	self.musicSlot.MouseLeave = function( sender, args )
		self.musicIcon:SetBackground( gDir .. "icn_m.tga" );
		self.tipLabel:SetText( "" );
	end
	
	-- Play Slot : Mouse Enter
	self.playSlot.MouseEnter = function( sender, args )
		self.playIcon:SetBackground( gDir .. "icn_p_hover.tga" );
		self.tipLabel:SetText( Strings["tt_play"] );
	end
	
	-- Play Slot : Mouse Leave
	self.playSlot.MouseLeave = function( sender, args )
		self.playIcon:SetBackground( gDir .. "icn_p.tga" );
		self.tipLabel:SetText( "" );
	end
	
	-- Ready Slot : Mouse Enter
	self.readySlot.MouseEnter = function( sender, args )
		self.readyIcon:SetBackground( gDir .. "icn_r_hover.tga" );
		self.tipLabel:SetText( Strings["tt_ready"] );
	end
	
	-- Ready Slot : Mouse Leave
	self.readySlot.MouseLeave = function( sender, args )
		self.readyIcon:SetBackground( gDir .. "icn_r.tga" );
		self.tipLabel:SetText( "" );
	end
	
	-- Sync Slot : Mouse Enter
	self.syncSlot.MouseEnter = function( sender, args )
		self.syncIcon:SetBackground( gDir .. "icn_s_new_hover.tga" );
		self.tipLabel:SetText( Strings["tt_sync"] );
	end
	
	-- Sync Slot : Mouse Leave
	self.syncSlot.MouseLeave = function( sender, args )
		self.syncIcon:SetBackground( gDir .. "icn_s_new.tga" );
		self.tipLabel:SetText( "" );
	end
	
	-- Sync Start Slot : Mouse Enter
	self.syncStartSlot.MouseEnter = function( sender, args )
		self.syncStartIcon:SetBackground( gDir .. "icn_ss_hover.tga" );
		self.tipLabel:SetText( Strings["tt_start"] );
	end
	
	-- Sync Start Slot : Mouse Leave
	self.syncStartSlot.MouseLeave = function( sender, args )
		self.syncStartIcon:SetBackground( gDir .. "icn_ss.tga" );
		self.tipLabel:SetText( "" );
	end
	
	-- Share Slot : Mouse Enter
	self.shareSlot.MouseEnter = function( sender, args )
		self.shareIcon:SetBackground( gDir .. "icn_sh_hover.tga" );
		if ( Settings.Commands[Settings.DefaultCommand].Title ) then
			self.tipLabel:SetText( Settings.Commands[Settings.DefaultCommand].Title );
		end
	end
	
	-- Share Slot : Mouse Leave
	self.shareSlot.MouseLeave = function( sender, args )
		self.shareIcon:SetBackground( gDir .. "icn_sh.tga" );
		self.tipLabel:SetText( "" );
	end
	
	-- Share Slot : Mouse Wheel
	self.shareSlot.MouseWheel = function( sender, args )
		local nextCmd = tonumber( Settings.DefaultCommand ) - args.Direction;
		local size = SettingsWindow:CountCmds();
		
		if ( nextCmd == 0 ) then
			Settings.DefaultCommand = tostring( size );
		elseif ( nextCmd > size ) then
			Settings.DefaultCommand = "1";
		else
			Settings.DefaultCommand = tostring( nextCmd );
		end
		self.shareSlot:SetShortcut( Turbine.UI.Lotro.Shortcut( Turbine.UI.Lotro.ShortcutType.Alias, self:ExpandCmd( Settings.DefaultCommand ) ) );
		self.shareSlot:SetVisible( self.bShowAllBtns );
	end
	
	-- Track Label : Mouse Click
	self.trackLabel.MouseClick = function( sender, args )
		if ( args.Button == Turbine.UI.MouseButton.Left ) then
			self:ToggleTracks();
		end
	end
	
	--********************
	-- Icons for Buttons *
	--********************
	-- icons that hide default quick slots
	self.musicIcon = self:CreateMainIcon( UI.scs.xMusic, "icn_m" );
	self.playIcon = self:CreateMainIcon( UI.scs.xPlay, "icn_p" );
	self.readyIcon = self:CreateMainIcon( UI.scs.xReady, "icn_r" ); -- ZEDMOD: 110, OriginalBB value: 120
	self.syncIcon = self:CreateMainIcon( UI.scs.xSync, "icn_s_new" ); -- ZEDMOD: 151, OriginalBB value: 161
	self.shareIcon = self:CreateMainIcon( UI.scs.xShare, "icn_sh" ); -- ZEDMOD: 270, OriginalBB value: 287
	self.syncStartIcon = self:CreateMainIcon( UI.scs.xSyncStart, "icn_ss" ); -- ZEDMOD: 192, OriginalBB value: 202
	self.readyIcon:SetVisible( self.bShowAllBtns );
	self.shareIcon:SetVisible( self.bShowAllBtns );
	
	
	--**************
	--* Song Title *
	--**************
	-- selected song display
	self.songTitle = Turbine.UI.Label();
	self.songTitle:SetParent( self );
	self.songTitle:SetFont( Turbine.UI.Lotro.Font.Verdana16 );
	self.songTitle:SetForeColor( UI.colour.defHighlighted );
	self.songTitle:SetPosition( 23, 90 );
	self.songTitle:SetSize( self:GetWidth() - 35, 16 ); -- ZEDMOD: OriginalBB values ( -52, 16 )

	self:CreateButtonRow( )
	
	--***************************************
	--* Songbook Main Window Resize Control *
	--***************************************
	self.resizeCtrl = Turbine.UI.Control();
	self.resizeCtrl:SetParent( self );
	self.resizeCtrl:SetSize( 20, 20 );
	self.resizeCtrl:SetZOrder( 200 );
	self.resizeCtrl:SetPosition( self:GetWidth() - 20, self:GetHeight() - 20 );
	
	--******************************
	--* Main Window Closing Action *
	--******************************
	-- Action for closing window and saving position
	self.Closed = function( sender, args )
		self:SaveSettings();
		self:SetVisible( false );
	end
	
	self:CreateSearchUI( )
	self:AdjustPosSearchUI( UI.search.yPos )
	
	-- hide search components if not toggled
	if ( Settings.SearchVisible == "yes" ) then
		self.searchInput:SetVisible( true );
		self.searchBtn:SetVisible( true );
		self.searchMode:SetVisible( true );
		self.clearBtn:SetVisible( true );
	--end -- ZEDMOD: OriginalBB
	else -- ZEDMOD
		-- adjust to search visibility
		--if ( Settings.SearchVisible == "no" ) then -- ZEDMOD: OriginalBB
		self:ToggleSearch( "off" );
	end
	
	--*****************
	--* Chief Minimum *
	--*****************
	self:SetChiefMode( Settings.ChiefMode == "true" );
	self:ShowAllButtons( Settings.ShowAllBtns == "true" )
	
	--*****************
	--* Solo Minimum *
	--*****************
	self:SetSoloMode( Settings.SoloMode == "true" );

	--************
	--* Timer UI *
	--************
	self.Update = Update
	self.currentTime = -1
	self.bDisplayTimer = ( Settings.TimerState == "true" );
	self.bTimerCountdown = ( Settings.TimerCountdown == "true" );
	self.bCounterActive = false
	
	self.aPeriodic	= {}
	self.bPeriodicActive = false
	--******************
	--* Directory List *
	--******************
	self.dirlistBox = ListBoxScrolled:New( 10, 10, false );
	self.dirlistBox:SetParent( self.listContainer );
	self.dirlistBox:SetVisible( true );
	
	--**************
	--* Filters UI *
	--**************
	self:CreateFilterUI(); -- Creates the UI elements for the filters
	
	-- Show Filters UI
	self.bFilter = ( Settings.FiltersState == "true" )
	self:ShowFilterUI( self.bFilter );
	
	--*************
	--* Song List *
	--*************
	self.songlistBox = ListBoxScrolled:New( 10, 10, false );
	self.songlistBox:SetParent( self.listContainer );
	self.songlistBox:SetVisible( true );

	
	--*******************
	--* Players list UI *
	--*******************
	self.bShowReadyChars = ( Settings.ReadyColState == "true" );
	self.bHighlightReadyCol = ( Settings.ReadyColHighlight == "true" );
	
	self:CreatePartyUI(); -- Creates the UI elements for the players list
	
	-- Show Player list UI
	self.bParty = ( Settings.PartyState == "true" )
	self:ShowPartyUI( self.bParty )
	
	-- Players List
	self:RefreshPlayerListbox(); -- lists the current party members; more will be added through chat messages
	
	--**************
	--* Track List *
	--**************
	self.tracklistBox = ListBoxCharColumn:New( 10, 10, false, UI.wiCharColumn );
	self.tracklistBox:CreateChildScrollbarHor( 10, 0.7, 1.0 )
	self.tracklistBox:SetHorizontalScrollBar( nil ); -- (mis-)used for items
	self.tracklistBox:SetParent( self.listContainer );
	self.tracklistBox:EnableCharColumn( self.bShowReadyChars );
	
	self:HightlightReadyColumns( self.bHighlightReadyCol );
	
	-- Adjust Tracklist Left Position
	--self:AdjustTracklistLeft( ); -- ZEDMOD: OriginalBB
	
	-- Show Tracklist if Toggled On/Off
	self:ShowTrackListbox( Settings.TracksVisible == "yes" )
	
	--*************
	--* Setups UI *
	--*************
	self:CreateSetupsUI();
	
	-- ZEDMOD: New Instrument Slot List
	--*******************
	--* Instrument List *
	--*******************
	self.instrlistBox = ListBoxScrolled:New( 10, 10, true );
	self.instrlistBox:SetParent( self.listContainer );
	self.instrlistBox:SetVisible( false );
	
	--********************
	--* Instrument Slots *
	--********************
	self.instrSlot = {};
	
	-- Set Instruments Slots
	for i = 1, CharSettings.InstrSlots["number"] do
		self.instrSlot[i] = Turbine.UI.Lotro.Quickslot();
		--self.instrSlot[i]:SetParent( self.instrContainer ); -- ZEDMOD: OriginalBB
		self.instrSlot[i]:SetParent( self.instrlistBox ); -- ZEDMOD
		--self.instrSlot[i]:SetPosition( 40 * ( i - 1 ), 0 ); -- ZEDMOD: OriginalBB
		self.instrSlot[i]:SetSize( 35, 40 ); -- ZEDMOD: OrignalBB value: ( 37, 37 )
		self.instrSlot[i]:SetZOrder( 100 );
		self.instrSlot[i]:SetAllowDrop( true );
		self.instrlistBox:AddItem( self.instrSlot[i] ); -- ZEDMOD
		if ( CharSettings.InstrSlots[tostring( i )].data ~= "" ) then
			pcall( function()
				local sc = Turbine.UI.Lotro.Shortcut( CharSettings.InstrSlots[tostring( i )].qsType, CharSettings.InstrSlots[tostring( i )].qsData );
				self.instrSlot[i]:SetShortcut( sc );
			end );
		end
		SetupInstrShortcutChanged( self, i )
		SetupInstrDragLeave( self, i )
		self.instrSlot[i].MouseDown = function( sender, args )
			if ( args.Button == Turbine.UI.MouseButton.Left ) then
				instrdrag = true;
			end
		end
	end
	
	--*************************************************
	--* Instrument Slots Visible Forced to Horizontal *
	--*************************************************
	-- Set Instrument Slots Visible Forced Horizontal
	if ( CharSettings.InstrSlots["visHForced"] == "true" ) then
		self.bInstrumentsVisibleHForced = true;
	end
	
	-- show instruments if toggled
	self:ShowInstrListbox( CharSettings.InstrSlots["visible"] == "yes" );
	
	--************
	--* Database *
	--************
	-- initialize list items from song database
	self:InitListsForSongDB( )
	-- Action for Dir List : Selecting a Dir
	self.dirlistBox.SelectedIndexChanged = function( sender, args )
		local i = sender:GetSelectedIndex( )
		sender:SetSelectedIndex( i )
		mainWnd:SelectDir( i );
	end
	-- Action for Song List : Selecting a Song
	self.songlistBox.SelectedIndexChanged = function( sender, args )
		local i = sender:GetSelectedIndex( )
		mainWnd:SelectListSong( i );
	end
	-- Action for Track List : Selecting a Track
	self.tracklistBox.SelectedIndexChanged = function( sender, args )
		local i = sender:GetSelectedIndex( )
		if self.bShowReadyChars then i = math.floor( ( i + 1 ) / 2 ); end -- mouseclick can select ready column too
		if i > 0 then mainWnd:SelectTrack( i, true ); end
	end
	-- Action for Track List : Realign Tracks Names
	self.tracklistBox.MouseClick = function( sender, args )
		if ( args.Button == Turbine.UI.MouseButton.Right ) then
			mainWnd:RealignTracknames();
		end
	end
	
	
	-- Action for Separator between Song List and Track List
	self.sepSongsTracks.MouseClick = self.tracklistBox.MouseClick;
	-- Action for Separator between Track List and Instrument List
	self.sepTracksInstrs.MouseClick = self.instrlistBox.MouseClick; -- ZEDMOD

	-- Main Window Resize Control : Mouse Down
	self.resizeCtrl.MouseDown = function( sender, args )
		sender.dragStartX = args.X;
		sender.dragStartY = args.Y;
		sender.dragging = true;
	end
	
	-- Main Window Resize Control : Mouse Up
	self.resizeCtrl.MouseUp = function( sender, args )
		sender.dragging = false;
		Settings.WindowPosition.Width = self:GetWidth(); -- Update Window Settings Width
		Settings.WindowPosition.Height = self:GetHeight(); -- Update Window Settings Height
	end
	
	-- ZEDMOD: Main Window Resize Control : Mouse Move
	self.resizeCtrl.MouseMove = function( sender, args )
		
		-- Get Main Window Width and Height
		local width, height = self:GetSize();
		
		-- Set Minimum Height Value
		local minheight = self:GetMinHeight();
		
		-- ZEDMOD: Get Main Window Height and Container Height
		local windowHeight = self:GetHeight();
		
		local containerHeight = self.listContainer:GetHeight();
		
		local unallowedHeight = windowHeight - containerHeight;
		
		if ( sender.dragging ) then
			width = width + args.X - sender.dragStartX;
			height = height + args.Y - sender.dragStartY;
			
			-- Set Main Window Minimum Width
			if ( width < self.minWidth ) then
				width = self.minWidth;
			elseif ( width > self.maxWidth - self:GetLeft() ) then
				width = self.maxWidth - self:GetLeft();
			end
			
			-- Set Main window Minimum Height
			if ( height < minheight ) then
				height = minheight;
			elseif ( height > self.maxHeight - self:GetTop() ) then
				height = self.maxHeight - self:GetTop();
			end
			
			-- Main Window Resize
			self:SetSize( width, height );
			
			-- Resize All Elements
			self:SetContainer();
			self:SetSBControls();
			
			-- Get New Container Height
			local newcontainerHeight = self.listContainer:GetHeight();
			
			-- If Mouse Up
			if ( newcontainerHeight < containerHeight ) then
				self:AdjustPosSearchUI( UI.search.yPos )
								-- Resize Dirlist
				self:ResizeDirlist();
				
				-- Resize Songlist
				self:ResizeSonglist();
				
			-- If Mouse Down
			else
				self:AdjustPosSearchUI( UI.search.yPos )
				
				-- Resize Songlist
				self:ResizeSonglist();
				
				-- Resize Dirlist
				self:ResizeDirlist();
			end
			
			if ( ( Settings.TracksVisible == "yes" ) and ( CharSettings.InstrSlots["visible"] == "no") ) then
				
				-- Get Track list Height
				local tracklistheight = self:TracklistGetHeight();
				
				-- Set Track list Height
				self.listboxPlayers:SetHeight( self.songlistBox:GetHeight() - UI.hPlayerBtn );
				self.tracklistBox:SetHeight( tracklistheight );
				self.listboxSetups:SetHeight( tracklistheight );
				
				-- Set Track list Position
				local tracklistpos = self.listContainer:GetHeight() - tracklistheight - UI.sep.sMain;
				
				-- Adjust Track list Position
				self:AdjustTracklistPosition( tracklistpos );
				
			elseif ( ( Settings.TracksVisible == "yes" ) and ( CharSettings.InstrSlots["visible"] == "yes") ) then
			
				-- Get Track list Height
				local tracklistheight = self:TracklistGetHeight();
				
				-- Set Track list Height
				self.tracklistBox:SetHeight( tracklistheight );
				self.listboxPlayers:SetHeight( self.songlistBox:GetHeight() - UI.hPlayerBtn );
				self.listboxSetups:SetHeight( tracklistheight );
				
				-- Get Instrument list Height
				local instrlistheight = self:InstrlistGetHeight();
				
				-- Set Instrument list Height
				self.instrlistBox:SetHeight( instrlistheight );
				
				-- Set Track list Position
				local tracklistpos = self.listContainer:GetHeight() - tracklistheight - instrlistheight - 2 * UI.sep.sMain;
				if ( self.bInstrumentsVisibleHForced == true ) then
					tracklistpos = tracklistpos - UI.lb.sScrollbar;
				end
				
				-- Adjust Track list Position
				self:AdjustTracklistPosition( tracklistpos );
				
				-- Set Instrument list Position
				local instrlistpos = self.listContainer:GetHeight() - instrlistheight - UI.sep.sMain;
				if ( self.bInstrumentsVisibleHForced == true ) then
					instrlistpos = instrlistpos - UI.lb.sScrollbar;
				end
				
				-- Adjust Instrument list Position
				self:AdjustInstrlistPosition( instrlistpos );
				
				-- Adjust Instrument Slot
				self:AdjustInstrumentSlots();
				
			elseif ( ( Settings.TracksVisible == "no" ) and ( CharSettings.InstrSlots["visible"] == "yes") ) then
				
				-- Get Instrument ist Height
				local instrlistheight = self:InstrlistGetHeight();
				
				-- Set Instrument list Height
				self.instrlistBox:SetHeight( instrlistheight );
				
				-- Set Instrument list Position
				local instrlistpos = self.listContainer:GetHeight() - instrlistheight - UI.sep.sMain;
				if ( self.bInstrumentsVisibleHForced == true ) then
					instrlistpos = instrlistpos - UI.lb.sScrollbar;
				end
				
				-- Adjust Instrument list Position
				self:AdjustInstrlistPosition( instrlistpos );
				
				-- Adjust Instrument Slot
				self:AdjustInstrumentSlots();
			end
		end
		sender:SetPosition( self:GetWidth() - sender:GetWidth(), self:GetHeight() - sender:GetHeight() );
	end
	
	--*****************************************************
	--* Dir list and Song list Separator Position Control *
	--*****************************************************
	-- Dir list and Song list ratio adjust
	--self.separator1.MouseDown = function( sender, args ) -- OriginalBB
	self.sepDirsSongs.MouseDown = function( sender, args ) -- ZEDMOD
		sender.dragStartX = args.X;
		sender.dragStartY = args.Y;
		sender.dragging = true;
	end
	
	-- Separator 1 : Mouse Up
	--self.separator1.MouseUp = function( sender, args ) -- OriginalBB
	self.sepDirsSongs.MouseUp = function( sender, args ) -- ZEDMOD
		sender.dragging = false;
		Settings.DirHeight = self.dirlistBox:GetHeight(); -- Update Settings.DirHeight
		Settings.SongsHeight = self.songlistBox:GetHeight(); -- ZEDMOD: Update Settings.SongsHeight
	end
	
	-- ZEDMOD: Separator 1 : Mouse Move
	self.sepDirsSongs.MouseMove = function( sender, args )
		if ( sender.dragging ) then
			local y = self.sepDirsSongs:GetTop();
			local h = self.songlistBox:GetHeight() - args.Y + sender.dragStartY;
			
			-- Mouse Down (TODO:??)
			if h < 40 then h = 40 ; end
			
			-- Get Dir list Height
			local dirlistheight = self:DirlistGetHeight() + self.songlistBox:GetHeight() - h;
			if dirlistheight < 40 then dirlistheight = 40; end
			
			-- Set Dir list Height
			self.dirlistBox:SetHeight( dirlistheight );
			
			--self:DirlistBoxSetScrollBarH();
			
			-- Adjust FilterUI
			self:AdjustFilterUI();
			
			-- Mouse Up (??)
			
			-- Get Song list Height
			local songlistheight = self:SonglistGetHeight();
			
			-- Set Song list Height
			self.songlistBox:SetHeight( songlistheight );
			
			-- Adjust Song list Left
			--self:AdjustSonglistLeft();
			
			-- Set Players list Height
			self.listboxPlayers:SetHeight( songlistheight - UI.hPlayerBtn );
			
			-- Set Song list Position
			local songlistpos = self.dirlistBox:GetHeight() + UI.sep.sMain;
			
			-- Adjust Song list Position
			self:AdjustSonglistPosition( songlistpos );
			
			-- Adjust PartyUI
			--self:AdjustPartyUI();
		end
	end
	
	--*******************************************************
	--* Song list and Track list Separator Position Control *
	--*******************************************************
	-- Song list and Track list Ratio Adjust
	-- Separator Songs-Tracks Mouse Down
	self.sepSongsTracks.MouseDown = function( sender, args )
		sender.dragStartX = args.X;
		sender.dragStartY = args.Y;
		sender.dragging = true;
	end
	
	-- Separator Songs-Tracks Mouse Up
	self.sepSongsTracks.MouseUp = function( sender, args )
		sender.dragging = false;
		Settings.TracksHeight = self.tracklistBox:GetHeight(); -- Update Settings Tracks Height
	end
	
	-- ZEDMOD: Separator Songs-Tracks Mouse Move
	self.sepSongsTracks.MouseMove = function( sender, args )
		if ( sender.dragging ) then
			local y = self.sepSongsTracks:GetTop();
			local h = self.tracklistBox:GetHeight() - args.Y + sender.dragStartY;
			
			-- Mouse Down
			if ( h < 40 ) then
				h = 40;
			end
			
			-- Get Song list Height
			local songlistheight = self:SonglistGetHeight() + self.tracklistBox:GetHeight() - h;
			if ( songlistheight < 40 ) then
				songlistheight = 40;
			end
			
			-- Set Song list Height
			self.songlistBox:SetHeight( songlistheight );
			
			-- Adjust Song list Left
			--self:AdjustSonglistLeft();
			
			-- Set Players list Height
			self.listboxPlayers:SetHeight( songlistheight - UI.hPlayerBtn )
			
			-- Get Track list Height
			local tracklistheight = self:TracklistGetHeight();
			
			-- Set Track list Height
			self.tracklistBox:SetHeight( tracklistheight );
			self.listboxSetups:SetHeight( tracklistheight );
			
			-- Set Track list Position
			local tracklistpos = self.dirlistBox:GetHeight() + self.songlistBox:GetHeight() + 2 * UI.sep.sMain;
			
			-- Adjust Track list Position
			self:AdjustTracklistPosition( tracklistpos );
		end
	end
	
	--*************************************************************
	--* Track list and Instrument list Separator Position Control *
	--*************************************************************
	-- ZEDMOD: NEW Separator between Tracks List and Instruments List
	-- Track list and Instrument list Ratio Adjust
	-- Separator Tracks-Instruments Mouse Down
	self.sepTracksInstrs.MouseDown = function( sender, args )
		sender.dragStartX = args.X;
		sender.dragStartY = args.Y;
		sender.dragging = true;
	end
	
	-- Separator Tracks-Instruments Mouse Up
	self.sepTracksInstrs.MouseUp = function( sender, args )
		sender.dragging = false;
		Settings.InstrsHeight = self.instrlistBox:GetHeight(); -- Update Settings Instruments Height
	end
	
	-- Separator Tracks-Instruments Mouse Move
	self.sepTracksInstrs.MouseMove = function( sender, args )
		if ( self.bInstrumentsVisibleHForced == false ) then
			if ( sender.dragging ) then
				local y = self.sepTracksInstrs:GetTop();
				local h = self.instrlistBox:GetHeight() - args.Y + sender.dragStartY;
				
				-- Mouse Down
				if ( h < 40 ) then
					h = 40;
				end
					
				if ( Settings.TracksVisible == "yes" ) then
					-- Get Track list Height
					local tracklistheight = self:TracklistGetHeight() + self.instrlistBox:GetHeight() - h;
					if ( tracklistheight < 40 ) then tracklistheight = 40; end
					
					-- Set Track list Height
					self.tracklistBox:SetHeight( tracklistheight );
					self.listboxSetups:SetHeight( tracklistheight );
					
					-- Set Track list Position
					local tracklistpos = self.dirlistBox:GetHeight() + self.songlistBox:GetHeight() + 2 * UI.sep.sMain;
					
					-- Adjust Track list Position
					self:AdjustTracklistPosition( tracklistpos );
					
					-- Get Instrument list Height
					local instrlistheight = self:InstrlistGetHeight();
					
					-- Set Instrument list Height
					self.instrlistBox:SetHeight( instrlistheight );
					
					-- Set Instrument list Position
					local instrlistpos = self.dirlistBox:GetHeight() + self.songlistBox:GetHeight() + self.tracklistBox:GetHeight() + 3 * UI.sep.sMain;
					
					-- Adjust Instrument list Position
					self:AdjustInstrlistPosition( instrlistpos );
					
					-- Adjust Instrument Slot
					self:AdjustInstrumentSlots();
					
				else
					-- Get Song list Height
					local songlistheight = self:SonglistGetHeight() + self.instrlistBox:GetHeight() - h;
					if ( songlistheight < 40 ) then songlistheight = 40; end
						
					-- Set Song list Height
					self.songlistBox:SetHeight( songlistheight );
					
					-- Adjust Song list Left
					self:AdjustSonglistLeft();
					
					-- Set Players list Height
					self.listboxPlayers:SetHeight( songlistheight - UI.hPlayerBtn );
					
					-- Get Instrument list Height
					local instrlistheight = self:InstrlistGetHeight();
					
					-- Set Instrument list Height
					self.instrlistBox:SetHeight( instrlistheight );
					
					-- Set Instrument list Position
					local instrlistpos = self.dirlistBox:GetHeight() + self.songlistBox:GetHeight() + 2 * UI.sep.sMain;
					
					-- Adjust Instrument list Position
					self:AdjustInstrlistPosition( instrlistpos );
					
					-- Adjust Instrument Slot
					self:AdjustInstrumentSlots();
					
				end
			end
		end
	end
	
	-- ZEDMOD: Set List boxes height
	self.dirlistBox:SetHeight( Settings.DirHeight );
	self.songlistBox:SetHeight( Settings.SongsHeight );
	self.tracklistBox:SetHeight( Settings.TracksHeight );
	self.instrlistBox:SetHeight( Settings.InstrsHeight );
	
	-- Resize All
	self:ResizeAll(); -- Adjust variable sizes and positions to current main window size
	
	-- Callback
	AddCallback( Turbine.Chat, "Received", ChatHandler ); -- installs handler for chat messages (to catch ready messages)
	
	--*******************
	--* Songbook Unload *
	--*******************
	if ( Plugins["Songbook"] ~= nil ) then
		Plugins["Songbook"].Unload = function( sender, args )
			self:SaveSettings();
			RemoveCallback( Turbine.Chat, "Received", ChatHandler );
			local player = Turbine.Gameplay.LocalPlayer:GetInstance( )
			if player and player:GetBackpack( ) then
				RemoveCallback( player:GetBackpack( ), "ItemAdded", BackpackItemAdded ); end
			self:SetWantsUpdates( false )
		end
	end
	
	-- ZEDMOD: Hack to refresh Playerslist box when 1rst launch
	self:RefreshPlayerListbox(); -- lists the current party members; more will be added through chat messages
	
end -- SongbookWindow:Constructor()

function SongbookWindow:InitListsForSongDB( )
	librarySize = #SongDB.Songs;
	if librarySize ~= 0 and not SongDB.Songs[1].Realnames then
		self.dirlistBox:ClearItems( )
		self.songlistBox:ClearItems( )
		self.tracklistBox:ClearItems( )
		if ( Settings.LastDirOnLoad == "yes" ) then
			self:RefreshDirList();
		else
			for i = 1, #SongDB.Directories do
				local dirItem = Turbine.UI.Label();
				local _, dirLevel = string.gsub( SongDB.Directories[i], "/", "/" );
				if ( dirLevel == 2 ) then
					dirItem:SetText( string.sub( SongDB.Directories[i], 2 ) );
					dirItem:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleLeft );
					dirItem:SetSize( 1000, 20 );
					self.dirlistBox:AddItem( dirItem );
				end
			end
		end
		self.sepDirs.hdgDir:SetText( Strings["ui_dirs"] .. selectedDir );
		if ( self.dirlistBox:ContainsItem( 1 ) ) then
			local dirItem = self.dirlistBox:GetItem( 1 );
			dirItem:SetForeColor( UI.colour.defHighlighted );
		end
		-- Load Content to Song Listbox
		self:LoadSongs();
		-- Set first Item as initial Selection
		local found = self.songlistBox:GetItemCount();
		-- if ( found > 0 ) then
		-- 	self.songlistBox:SetSelectedIndex( 1 );
		-- 	--self:SelectSong( 1 );
		-- else
		-- 	self:ClearSongState();
		-- end
		-- Set Text to Separator1
		self.sepDirsSongs.hdgSongs:SetText( Strings["ui_songs"] .. " (" .. found .. ")" );
		
		self:SetStateForSongDB( true )
		
		if self.emptyLabel then self.emptyLabel:SetParent( nil ); self.emptyLabel = nil; end
		return true
	end
		
	self:SongsLoadFail( )
	-- show message when library is empty or database format has changed
	return false
end		

function SongbookWindow:SongsLoadFail( )
	self:SetStateForSongDB( false )
	if self.emptyLabel then return; end
	self.emptyLabel = Turbine.UI.Label();
	self.emptyLabel:SetParent( self );
	self.emptyLabel:SetPosition( 30, 165 );  -- ZEDMOD: OriginalBB value ( 30, 155 )
	self.emptyLabel:SetSize( 220, 240 );
	self.emptyLabel:SetText( Strings["err_nosongs"] );
end

function SongbookWindow:SetStateForSongDB( b )
	self.sepDirsSongs:SetVisible( b );
	self.sepTracksInstrs:SetVisible( b ); -- ZEDMOD
	self.sepDirs.hdgDir:SetVisible( b )
self:ShowTrackListbox( ( Settings.TracksVisible == "yes" ) and b )
	self.dirlistBox:SetVisible( b )
	self.songlistBox:SetVisible( b )
	self:ShowFilterUI( self.bFilter and b )
	self:ShowPartyUI( self.bParty and b )
	self:ShowInstrLabel( b )
	self:ShowInstrListbox( b );
	self.listFrame.heading:SetText( "" );
end		

function SongbookWindow:Initialized( )
TRACE( "LUA version: "..tostring(_VERSION) )
	self:SetPlayerEvents( )
	local s = Instruments:SetInstrCBs( self.SetEquippedInstrument, self.SetEquippedInstrument )
	if self.lblInstr then self.lblInstr:SetText( "Equipped: "..s ); end
	self:SetupBackpackItemAdd( ) -- Backpack instr update
end

local function InstrSlotsMenu( sender, args )
	if args.Button ~= Turbine.UI.MouseButton.Right then return; end
	
	local contextMenu = Turbine.UI.ContextMenu()
	local menuItems = contextMenu:GetItems( )
	
	menuItems:Add( ListBox.CreateMenuItem( "List Shortcuts", nil,
		function( s, a ) if mainWnd then mainWnd:PrintInstrShortcuts( ); end; end ) )
		
	-- menuItems:Add( ListBox.CreateMenuItem( "Refresh Shortcuts", nil,
	-- 	function( s, a ) if mainWnd then mainWnd:RestoreInstrumentSlots( ); end; end ) )

	contextMenu:ShowMenu( )
end


local function BiscuitCounterMenu( sender, args )
	if args.Button ~= Turbine.UI.MouseButton.Right then return; end
	
	local contextMenu = Turbine.UI.ContextMenu()
	local menuItems = contextMenu:GetItems( )
	
	menuItems:Add( ListBox.CreateMenuItem( Strings["sh_hide"], nil,
		function( s, a ) sender:Toggle( ); end ) )

	menuItems:Add( ListBox.CreateMenuItem( Strings["bc_stats"], nil,
		function( s, a ) sender:Print( ); end ) ) -- biscuit counter stat output

	menuItems:Add( ListBox.CreateMenuItem( Strings["bc_annStats"], nil,
		function( s, a ) sender:Announce( ); end ) )

	contextMenu:ShowMenu( )
end

-- BISCUIT
function SongbookWindow:InitBiscuitCounter( )

	self.biscuitCounter = Turbine.UI.Label( )
	self.biscuitCounter:SetParent( self )
	self.biscuitCounter:SetPosition( UI.xBiscuit, UI.yBiscuit )
	self.biscuitCounter:SetSize( 40, 20)
	self.biscuitCounter:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleCenter );
	self.biscuitCounter:SetZOrder( 200 )
	self.biscuitCounter:SetFont( Turbine.UI.Lotro.Font.Verdana20 );
	self.biscuitCounter:SetForeColor( UI.colour.black );
	self.biscuitCounter:SetVisible( false )
	self.biscuitCounter.icon = CreateIconJPG( self, "icn_hb_noframe_25" )
	self.biscuitCounter.icon:SetParent( self )
	self.biscuitCounter.icon:SetPosition( UI.xBiscuit + 4, UI.yBiscuit - 5 )
	self.biscuitCounter.icon:SetSize( 32, 32 )
	self.biscuitCounter.icon:SetZOrder( 110 )
	self.biscuitCounter.icon:SetAllowDrop( false )
	self.biscuitCounter.icon:SetVisible( false )
	self.biscuitCounter.icon:SetMouseVisible( true )
	self.biscuitCounter.icon.MouseClick = function( s, a ) BiscuitCounterMenu( s, a ); end
	self.biscuitCounter.icon.MouseEnter = function( s, a )
		if not mainWnd.biscuitCounter.bFlash then return; end
		mainWnd.biscuitCounter.bFlash = false
		s:SetBackground( gDir .. "icn_hb_noframe" .. ".jpg" )
		mainWnd.biscuitCounter:Show( true ); end
	
	self.biscuitCounter.bFlash = true
	self.biscuitCounter.v = 0 -- value
	self.biscuitCounter.bVisible = false;
	self.biscuitCounter.bVisibleBk = false
	self.biscuitCounter.bActive = false -- set when player name = Lina
	self.biscuitCounter.bForAll = false -- biscuit counter active for any player
	self.biscuitCounter.bOnAnn = true -- tally biscuits on Announce rather than Create
	self.biscuitCounter.UpdDisplay = function( s ) s:SetText( tostring(s.v) ); end
	self.biscuitCounter.Show = function( s, b )
		if b == nil then b = true; end
		s.bVisible = b; s:SetVisibility( b ); end
	self.biscuitCounter.SetIconVisibility = function( s, b ) s.icon:SetVisible( b ); end
	self.biscuitCounter.SetVisibility = function( s, b ) s:SetVisible( b ); s.icon:SetVisible( b ); end
	self.biscuitCounter.Toggle = function( s ) s:Show( not s.bVisible ); end
	self.biscuitCounter.Reset = function( s ) s:ClearTags( ); s.v = 0; s.aLoaded = {}; end
	self.biscuitCounter.Change = function( s, msg, d )
		d = d or 1; s.v = s.v + d
		if msg and s.bVisible then WRITE( msg ); end
		s:UpdDisplay( ); end
	self.biscuitCounter.Increment = function( s, msg ) s:Change( msg, 1 ); end
	self.biscuitCounter.Decrement = function( s, msg ) s:Change( msg, -1 ); end
	self.biscuitCounter.ClearTags = function( s ) s.aTags = {}; end
	self.biscuitCounter.AddTag = function( s, sTag, d )
		d = d or 1; if not s.aTags then s.aTags = {}; end
		if s.aTags[ sTag ] then s.aTags[ sTag ] = s.aTags[ sTag ] + d
		else s.aTags[ sTag ] = d; end; end
	self.biscuitCounter.IsTrigger = function( s, sCode )
		if sCode == "A" and s.bOnAnn then return true; end
		if sCode == "C" and not s.bOnAnn then return true; end
		return false; end
	self.biscuitCounter.Unload = function( s ) s.aLoaded = { }; end
	self.biscuitCounter.Load = function( s, sTag, sMsg, d )
		if not s.bForAll and not s.bActive then return; end
		d = d or 1; if not s.aLoaded then s.aLoaded = {}; end
		for i = 1, #s.aLoaded do
			if s.aLoaded[i].sTag == sTag then self.aLoaded[i].d = self.aLoaded[i].d + d; return; end; end
		s.aLoaded[ #s.aLoaded + 1 ] = { ["tag"] = sTag, ["msg"] = sMsg, ["d"] = d }; end
	self.biscuitCounter.Fire = function( s, sCaller )
		if not s:IsTrigger( sCaller ) then return; end
		if not s.bForAll and not s.bActive then return; end
		if not s.aLoaded or #s.aLoaded <= 0 then return; end
		local bBiscuit = false
		for i = 1, #s.aLoaded do
			s:AddTag( s.aLoaded[i].tag, s.aLoaded[i].d  )
			s:Change( s.aLoaded[i].msg, s.aLoaded[i].d ) --TRACE("  Change: "..s.aLoaded[i].msg.."->"..tostring(s.aLoaded[i].d) ); 
			if s.aLoaded[i].d > 0 then bBiscuit = true; end; end -- got at least one biscuit
			if s.bFlash and bBiscuit then s:Flash( ); end
		s.aLoaded = {}; end
	self.biscuitCounter.Flash = function( s )
		if not s.bForAll and not s.bActive then return; end
		s.dc = 0.12
		local f1 = function( ) s:SetIconVisibility( true ); s.dc = s.dc / 2; if s.dc < 0.005 then s.dc = 0.005; end; return s.dc; end
		local f2 = function( ) s:SetIconVisibility( false ); return 0.06 - s.dc; end
		local ft = function( ) s:SetIconVisibility( s.bVisible ); end
		mainWnd:AddPeriodic( 30, 0.05, f1, f2, ft, function() return s.bVisible; end ); end
	self.biscuitCounter.StatString = function( self )
		local sStats = "\nState of biscuit affairs:"
		for sTag,v in pairs( self.aTags ) do
			local ind = ( v >= 0 and ' ' or '' )
			sStats = sStats .. "\n" .. ind .. tostring( v ) .. " (" .. sTag .. ")"; end
		sStats = sStats .. "\n" .. string.rep( "-",22 )
		local ind = ( self.v >= 0 and ' ' or '' )
		sStats = sStats .. "\n" .. ind .. tostring( self.v ) .. " (Grand biscuit total)"
		if self.v < 0 then sStats = sStats .. "\nA Biscuit Officer will come by later to collect your biscuit debt."; end
		return sStats; end
	self.biscuitCounter.Announce = function( self )
		if not self.floatSC then self.floatSC = FloatSC:New( 125, 29, "icn_send" ); end
		local sCmd = Announcement.sPrefix .. " ." .. self:StatString()
		local x, y = mainWnd:GetMousePosition( )
		self.floatSC:Activate( mainWnd, sCmd, x, y - 20 ) --336, 88 )
		end
	self.biscuitCounter.Print = function( self )
		WRITE( self:StatString() ); end
	self.biscuitCounter.MouseClick = function( s, a ) BiscuitCounterMenu( s, a ); end
	self.biscuitCounter:UpdDisplay( );
end

function SongbookWindow:ToggleBiscuitCounter( ) self.biscuitCounter:Toggle( ); end
function SongbookWindow:ToggleBiscuitCounterTrigger( )
	self.biscuitCounter.bOnAnn = not self.biscuitCounter.bOnAnn
	if self.biscuitCounter.bOnAnn then WRITE( Strings["bcTriggerAnn"] )
	else WRITE( Strings["bcTriggerCreate"] ); end
end
function SongbookWindow:ToggleBiscuitCounterForAll( )
	if self.biscuitCounter.bActive then return; end -- bc always active for player Lina
	self.biscuitCounter.bForAll = not self.biscuitCounter.bForAll
	if self.biscuitCounter.bForAll then
		WRITE( Strings["bcforall"] )
		self.biscuitCounter.bVisible = self.biscuitCounter.bVisible or self.biscuitCounter.bVisibleBk
		self.biscuitCounter:Show( self.biscuitCounter.bVisible )
	else
		WRITE( Strings["bcforlina"] )
		self.biscuitCounter.bVisibleBk = self.biscuitCounter.bVisible
		self.biscuitCounter:Show( false )
	end
end
-- /BISCUIT


local function InstrSlotsEnter( sender, args ) sender:SetBackColor( mainWnd.colourActive ); end
local function InstrSlotsLeave( sender, args ) sender:SetBackColor( mainWnd.colorListFrame ); end
	

function SongbookWindow:CreateTrackInstrSep( )
	self.sepTracksInstrs = self:CreateMainSeparator( Settings.DirHeight + Settings.SongsHeight + Settings.TracksHeight + 2 * UI.sep.sMain );
	self.sepTracksInstrs:SetVisible( false );
	self.sepTracksInstrs.heading = self:CreateSeparatorHeading( self.sepTracksInstrs, Strings["ui_instrs"] );
	self.sepTracksInstrs.heading:SetMouseVisible( true );
	self.sepTracksInstrs.heading.MouseClick = InstrSlotsMenu
	self.sArrows3 = self:CreateSeparatorArrows( self.sepTracksInstrs );
end


local function GetQS( i )
	local qs = mainWnd.instrSlot[ i ]
	if not qs then mainWnd.searchInput:SetText( "No valid quickslot at #"..i ); return; end
	return qs
end
local function GetSC( i )
	local qs = GetQS( i )
	if not qs then return; end
	local sc = qs:GetShortcut( ) 
	if not sc then mainWnd.searchInput:SetText( "No valid shortcut in quickslot at #"..i ); return; end
	return sc, qs
end

function SongbookWindow:PrintInstrShortcuts( )
	local aInfo = {}
	for i = 1, self.instrlistBox:GetItemCount( ) do -- CharSettings.InstrSlots["number"]
		local qs = self.instrSlot[ i ]
		if qs then
			local si = tostring( i )
			local sLine = ""
			local sc = qs:GetShortcut( )
			if sc and sc:GetData() and sc:GetData() ~= "" and sc:GetType() then
				local item = sc:GetItem( )
				local sItem = item and item:GetName( ) or "-"
				sLine = si..": \""..tostring(sc:GetType()).."\", \""..tostring(sc:GetData()).."\" ("..sItem..")"
			end
			local aSlot = CharSettings.InstrSlots
			if aSlot[si] and aSlot[si].qsData and aSlot[si].qsData ~= "" and aSlot[si].qsType and sc:GetData() ~= aSlot[si].qsData then
				if sLine:len() > 0 then sLine = sLine .. '\n'; end
				sLine = sLine.."<rgb=#C02000>"..si.."r: \""..tostring(aSlot[si].qsType).."\", \""..tostring(aSlot[si].qsData).."\" ("..tostring(aSlot[si].item)..")</rgb>"
			end
			if sLine:len() > 0 then aInfo[ #aInfo + 1 ] = sLine; end
		end
	end
	if #aInfo > 0 then WRITE( "Instrument Shortcuts:\n"..table.concat( aInfo, "\n" ) )
	else WRITE( "All instrument slots are empty." ); end
end

function SongbookWindow:GetBackpack( )
	local player = Turbine.Gameplay.LocalPlayer:GetInstance( )
	if not player then return; end
	local pack = player:GetBackpack( )
	if not pack then return; end
--	TRACE( "Backpack size "..tostring( pack:GetSize( ) ) )
	return pack
end

function SongbookWindow:GetVault( )
	local player = Turbine.Gameplay.LocalPlayer:GetInstance();
	if not player then return; end
	local vault = player:GetVault( )
	if not vault then return; end
--	TRACE( "Vault size "..tostring(vault:GetCapacity())..", "..tostring(vault:GetChestCount()).." chests" )
	return vault
end

function SongbookWindow:GetSharedVault( )
	local player = Turbine.Gameplay.LocalPlayer:GetInstance();
	if not player then return; end
	local vault = player:GetSharedStorage( )
	if not vault then return; end
--	TRACE( "Shared vault size "..tostring(vault:GetCapacity())..", "..tostring(vault:GetChestCount()).." chests" )
	return vault
end


-- Restore instrument shortcuts
function BackpackItemAdded( s, a )
	local item = s:GetItem( a.Index )
	if not item then return; end
	local itemInfo = item:GetItemInfo( )
	if itemInfo and itemInfo:GetCategory( ) ~= 11 then return; end -- only operate on instruments
	--TraceItemInfo( item )
	for i = 1, mainWnd.instrlistBox:GetItemCount( ) do
		if CharSettings.InstrSlots[tostring(i)].item == item:GetName() then
			local sc = mainWnd.instrSlot[ i ]:GetShortcut()
			if sc and sc:GetData( ) == "" then
				sc:SetData( CharSettings.InstrMap[ item:GetName() ].data )
				sc:SetType( CharSettings.InstrMap[ item:GetName() ].type )
				CharSettings.InstrMap.bNoRef = true
				mainWnd.instrSlot[ i ]:SetShortcut( sc )
				CharSettings.InstrMap.bNoRef = nil;
			end
		end
	end
end

function TraceItemInfo( item )
	local ii = item:GetItemInfo( )
	TRACE( "Item name:"..tostring(ii:GetName()))
	-- TRACE( "ImgID:"..tostring(ii:GetIconImageID()))
	-- TRACE( "QualImgID:"..tostring(ii:GetQualityImageID()))
	-- TRACE( "ShaImgID:"..tostring(ii:GetShadowImageID()))
	-- TRACE( "UndImgID:"..tostring(ii:GetUnderlayImageID()))
	local sc = Turbine.UI.Lotro.Shortcut( item )
	TRACE( "SC ID: \""..tostring(sc:GetData()).."\"")
	TRACE( "SC item:"..tostring(sc:GetItem()))
	local sc1 = mainWnd.instrSlot[ 1 ]:GetShortcut()
	TRACE( "SC 1 ID:"..tostring(sc1:GetData()))
	TRACE( "SC 1 item:"..tostring(sc1:GetItem()))

end

function SongbookWindow:SetupBackpackItemAdd( )
	local pack = self:GetBackpack( )
	AddCallback( pack, "ItemAdded", BackpackItemAdded )
end

function SongbookWindow:RestoreInstrumentSlots( )
	local aSlotData = CharSettings.InstrSlots
	for i = 1, self.instrlistBox:GetItemCount( ) do -- CharSettings.InstrSlots["number"]
		local qs = self.instrSlot[ i ]
		local sIdx = tostring( i )
		if aSlotData[ sIdx ] and aSlotData[ sIdx ].data ~= "" and aSlotData[ sIdx ].qsType then
			pcall( function()
				local sc = Turbine.UI.Lotro.Shortcut( aSlotData[ sIdx ].qsType, aSlotData[ sIdx ].qsData );
				qs:SetShortcut( sc ); end )
		end
	end
end


function SongbookWindow.SetEquippedInstrument( item )
	if mainWnd.lbSlots and mainWnd.lbSlots:IsVisible( ) then mainWnd.lbSlots:SetVisible( false ); end
	if item then mainWnd.lblInstr:SetText( "Equipped: "..item:GetName( ) ); end; end

function SongbookWindow:CreateInstrSelectList( )
	self.lbSlots = ListBoxScrolled:New( 10, 10, false )
	self.lbSlots:SetParent( self )
	self.lbSlots:SetVisible( false )
	self.lbSlots:SetBackColor( Turbine.UI.Color( 1, 0.1, 0.1, 0.1 ) )
	self.lbSlots:SetZOrder( 320 )
	local x = self:GetWidth() - 22 - self.lbSlots:GetWidth( )
	local y = UI.listFrame.y + 8 + self.lblInstr:GetHeight( )
	self.lbSlots:SetPosition( x, y )
	self.lbSlots.FocusLost = function(s,a) s:SetVisible( false ); end
end

function SongbookWindow:ListInstruments( )
	TRACE( "ListInstruments" )
	if not self.aUix then
		local song = SongDB.Songs[ selectedSongIndex ]
		if song then self.aUix = Assigner:GetSongUix( song, self.iCurrentSetup ); end; end --iSetup
	if not self.aUix then return; end
	TRACE( "  aUix present" )
	if not self.lbSlots then self:CreateInstrSelectList( ); end
	self.lbSlots.bStale = true
	local n = Instruments:ListRelevantSlots( self.aUix, self.lbSlots )
	if n <= 0 then return; end
	local height = 40 * n + 10
	local heightLimit = self.listFrame:GetTop( ) + self.listFrame:GetHeight( ) - self.lblInstr:GetTop( ) - self.lblInstr:GetHeight( )
	if height > heightLimit then height = heightLimit; end
	self.lbSlots:SetSize( 225, height )
	local x = self:GetWidth() - 22 - self.lbSlots:GetWidth( )
	local y = UI.listFrame.y + 8 + self.lblInstr:GetHeight( )
	self.lbSlots.bStale = false
	self.lbSlots:SetPosition( x, y )
	self.lbSlots:SetVisible( true )
end

-- Used to create the buttons along the bottom border
function SongbookWindow:CreateButton( parent, sCode, funcMouseClick, xPos, yPos, width, height )

	--* Settings button *
	local button = Turbine.UI.Lotro.Button();
	button:SetParent( parent );
	button:SetPosition( xPos, yPos );
	button:SetSize( width, height );
	if sCode then button:SetText( Strings[sCode] ); end
	button.MouseClick = funcMouseClick
	return button
end


local function InformLeader( s, a )
	if a.Button ~= Turbine.UI.MouseButton.Left then return; end
	mainWnd:CreateInformQS( )
end


local function InformTB_Show( self, parent, sTxt, x, y, w, h, bkCol )
	if not self.tb then
		self.tb = Turbine.UI.Lotro.TextBox()
		self.tb:SetParent( parent )
		self.tb:SetFont( Turbine.UI.Lotro.Font.Verdana14 )
		bkCol = bkCol or mainWnd.colorBlack
		self.tb:SetBackColor( bkCol )
		self.tb:SetMultiline( true )
		self.tb:SetReadOnly( true )
		self.tb.FocusLost = function(s,a) s:SetVisible( false ); end
	end
	self.tb:SetText( sTxt )
	self.tb:SetPosition( x, y )
	self.tb:SetSize( w, h )
	self.tb:SetVisible( true )
end

local function InformTB_Activate( self, parent, sTxt, f, x, y, w, h, bkCol )
	if f ~= nil and self:IsActive( ) then f( ); self.tb:SetVisible( false ); return; end
	if w > parent:GetWidth( ) then w = parent:GetWidth( ); end
	if h > parent:GetHeight( ) then h = parent:GetHeight( ); end
	if x + w > parent:GetWidth( ) then x = parent:GetWidth( ) - w; end
	if y + h > parent:GetHeight( ) then y = parent:GetHeight( ) - h; end
	self:Show( parent, sTxt, x, y, w, h, bkCol )
	self.tb:Focus( )
end

InformTB =
{
	tb = nil,
	btn = nil,
	wBtn = 70, hBtn = 20,
	New = function( self ) local obj = {}; setmetatable( obj, self ); self.__index = self; return obj; end,
	Show = InformTB_Show,
	Activate = InformTB_Activate,
	IsActive = function( self ) return self.tb and self.tb:IsVisible( ); end,
	Hide = function( self, parent ) if self.qs and self.qs:HasFocus( ) then parent:Focus( ); end; end,
	Above = function( ctrl, w, h, bkCol ) return ctrl:GetLeft( ), ctrl:GetTop( ) - h - 5, w, h, bkCol; end,
	Below = function( ctrl, w, h, bkCol ) return ctrl:GetLeft( ), ctrl:GetTop( ) + ctrl:GetHeight( ) + 5, w, h, bkCol; end,
}

function SongbookWindow:PlaceInformTB( )
	local w, h = self.instrlistBox:GetLeft( ) + self.instrlistBox:GetWidth( ) - self.ButtonRow.xPos, 100
	local xPos = self.ButtonRow.xPos
	local yPos = self:GetHeight() - self.ButtonRow.height - self.ButtonRow.btmIndent - h - 10
	self.tb:SetPosition( xPos, yPos )
	self.tb:SetSize( w, h )
end

function SongbookWindow:CreateInformTB( )
	if self.tb then self.tb:SetVisible( true ); self:PlaceInformTB( ); return; end
	self.tb = Turbine.UI.Lotro.TextBox()
	self.tb:SetParent( self )
	self:PlaceInformTB( )
	self.tb:SetFont( Turbine.UI.Lotro.Font.Verdana14 )
	self.tb:SetBackColor( UI.colour.black )
	self.tb:SetMultiline( true )
	self.tb:SetReadOnly( true )
	self.tb:SetVisible( true )
end

function SongbookWindow:CreateInformQS( )
	local player = self:GetPlayer( ) --Turbine.Gameplay.LocalPlayer:GetInstance();
	if not player then return; end
	local party = player:GetParty( );
	if not party then WRITE( Strings["asn_needFsOrRaid"] ); return; end
	local leader = party:GetLeader( )
	if not leader then return; end
	local sPlayer = player:GetName( )
	if not Instruments:SlotsToSkills( self.instrSlot, sPlayer ) then return; end
	self:CreateInformTB( )
	self.tb:SetText( Strings["asn_postSkills1"]..tostring( leader:GetName( ) )..Strings["asn_postSkills2"]..
		"\n\n"..Strings["asn_postSkills3"] )
	if not self.floatSC then
		self.floatSC = FloatSC:New( 57, 18, "icn_btnSend", "icn_btnSend_a" ); end
	local sCmd = skillsWindow:PrepareData( player:GetName( ), leader:GetName( ) )
	if not sCmd then return; end
	local x = self.tb:GetWidth( ) - self.floatSC.width - 3
	local y = self.tb:GetHeight( ) - self.floatSC.height - 3
	self.floatSC:Activate( self.tb, sCmd, x, y, self.tb )
	skillsWindow:UpdateSkills( sPlayer )
end


function SongbookWindow:CreateIconButton( parent, x, y, w, h, sImg, sImgActive )
	local iconBtn = CreateIcon( parent, sImg )
	iconBtn:SetPosition( x, y )
	iconBtn:SetSize( w, h )
	iconBtn:SetMouseVisible( true )
	iconBtn.sIcon = sImg
	iconBtn.sIcon_a = sImgActive
	iconBtn.MouseEnter = function(s,a) s:SetBackground( gDir..s.sIcon_a ); end
	iconBtn.MouseLeave = function(s,a) s:SetBackground( gDir..s.sIcon ); end
	return iconBtn
end

function SongbookWindow:CreateIconBtnLbl( parent, x, y, w, h, sImg, sImgActive, xOffLbl, yOffLbl )
	local iconBtn = CreateIcon( parent, sImg )
	iconBtn:SetPosition( x, y )
	iconBtn:SetSize( w, h )
	iconBtn:SetMouseVisible( true )
	iconBtn:SetVisible( true )
	iconBtn.sIcon = sImg
	iconBtn.sIcon_a = sImgActive
	iconBtn.label = Turbine.UI.Label();
	iconBtn.label:SetParent( iconBtn )
	iconBtn.label:SetFont( Turbine.UI.Lotro.Font.TrajanPro14 );
	iconBtn.label:SetForeColor( UI.colour.btnFont )
	iconBtn.label:SetOutlineColor( UI.colour.black )
	iconBtn.label:SetFontStyle( Turbine.UI.FontStyle.Outline );
	iconBtn.label:SetParent( iconBtn )
	iconBtn.label:SetMouseVisible( true )
	local xOffLbl = xOffLbl or 0
	local yOffLbl = yOffLbl or 0
	iconBtn.label:SetPosition( xOffLbl, yOffLbl )
	iconBtn.SetText = function( s, t ) s.label:SetText( t ); end
	iconBtn.MouseEnter = function(s,a) s:SetBackground( gDir..s.sIcon_a ); end
	iconBtn.MouseLeave = function(s,a) s:SetBackground( gDir..s.sIcon ); end
	iconBtn.label.MouseClick = function(s,a) local p = s:GetParent( ); if p and p.MouseClick then p:MouseClick(a); end; end
	iconBtn.label.MouseWheel = function(s,a) local p = s:GetParent( ); if p and p.MouseWheel then p:MouseWheel(a); end; end
	return iconBtn
end

-- Create the buttons at the bottom of the main window
function SongbookWindow:CreateButtonRow( )

	local cfg = self.ButtonRow
	local yPos = self:GetHeight() - cfg.height - cfg.btmIndent
	local xPos = cfg.xPos
	
	if not self.informTB then self.informTB = InformTB:New( ); end
	local fRel = function(s,a) mainWnd:ReloadSongDB( ); end
	self.btnReload = self:CreateIconButton( self, xPos, yPos, cfg.wiReload, cfg.height, "icn_reload.tga", "icn_reload_a.tga" )
	self.btnReload.MouseClick = function ( s, a )
		if a.Button == Turbine.UI.MouseButton.Left then
			--local x, y = self.btnReload:GetLeft( ), self.btnReload:GetTop( ) + self.btnReload:GetHeight( ) - h - 110
			self.informTB:Activate( self, Strings["reloadMsg"], fRel, InformTB.Above( self.btnReload, 300, 110 ) ); end; end

	xPos = xPos + cfg.wiReload + cfg.spacing
	local f = function(s,a) if a.Button == Turbine.UI.MouseButton.Left then settingsWindow:SetVisible( true ) end; end
	self.btnSettings = self:CreateButton( self, "ui_settings", f, xPos, yPos, cfg.wiSettings, cfg.height )

	xPos = xPos + cfg.wiSettings + cfg.spacing * 2
	self.cbTrackAnc = self:CreateAnnounceTrackerCb( )
	self.cbTrackAnc:SetPosition( xPos, yPos )
	self.cbTrackAnc:SetSize( cfg.wiTrackAnc, cfg.height + 2 )

	xPos = xPos + cfg.wiTrackAnc + cfg.spacing
	self.btnInform = self:CreateButton( self, "informBtn", InformLeader, xPos, yPos, cfg.wiInform, cfg.height )

	xPos = xPos + cfg.wiInform + cfg.spacing
	f = function(s,a) if a.Button == Turbine.UI.MouseButton.Left then mainWnd:LaunchAssignWindow( );
		-- mainWnd.biscuitCounter:Load( "Nim/Drums", "Nimelia + Drums = A biscuit!" );
		-- mainWnd.biscuitCounter:Fire( );
	end; end
	self.btnAssign = self:CreateButton( self, "assignBtn", f, xPos, yPos, cfg.wiAssign, cfg.height )

	self.MouseClick = function( s, a )
		if s.floatSC then s.floatSC:Hide( s ); end
		if s.informTB and s.informTB.tb then s.informTB.tb:SetVisible( false ); end; end
end


function SongbookWindow:SongAndSetupSelected( )
	return selectedSongIndex and selectedSongIndex > 0 and self.iCurrentSetup and self.iCurrentSetup > 0; end

function SongbookWindow:SelectSetupForCount( c )
	if selectedSongIndex <= 0 then return false; end
	local iSetup = self:SetupIndexForCount( selectedSongIndex, c )
	if not iSetup then return false; end
	self:SelectSetup( iSetup )
	--self.iCurrentSetup = iSetup
	return true
end

function SongbookWindow:CountForSetup( iSetup )
	iSetup = iSetup or self.iCurrentSetup
	local song = SongDB.Songs[ selectedSongIndex ]
	if song and song.Setups and iSetup <= #song.Setups then return #song.Setups[ iSetup ]; end
	return nil
end

function SongbookWindow:LaunchAssignWindow( )
	DEBUG_Prep( ) --TODO: REMOVE
	assignWindow:Launch( )
end


-- Reposition the buttons on window resize
function SongbookWindow:MoveButtonRow( )

	local right = self:GetWidth() - 25
	local yPos = self:GetHeight() - self.ButtonRow.height - self.ButtonRow.btmIndent
	
	local xPos = self.ButtonRow.xPos
	self.btnReload:SetPosition( xPos, yPos )

	xPos = xPos + self.ButtonRow.wiReload + self.ButtonRow.spacing
	self.btnSettings:SetPosition( xPos, yPos )

	xPos = right - self.ButtonRow.wiAssign
	self.btnAssign:SetPosition( xPos, yPos )
	
	xPos = xPos - self.ButtonRow.wiAssign - self.ButtonRow.spacing
	self.btnInform:SetPosition( xPos, yPos )

	xPos = xPos - self.ButtonRow.wiTrackAnc - self.ButtonRow.spacing
	self.cbTrackAnc:SetPosition( xPos, yPos )
end


---------------------
-- Songbook Window --
---------------------
-- Songbook Window : Resize All
function SongbookWindow:ResizeAll()
	
	-- ZEDMOD: Set Container and Frame Size
	self:SetContainer();
	
	-- Set Instrument Container Top
	--self.instrContainer:SetTop( self:GetHeight() - 75 ); -- ZEDMOD: OriginalBB
	
	-- ZEDMOD: Get Main Window Height and Container Height
	local windowHeight = self:GetHeight();
	local containerHeight = self.listContainer:GetHeight();
	local unallowedHeight = windowHeight - containerHeight;
	
	-- ZEDMOD: Set Position
	local posrep = 0;
	
	--************
	--* DIR List *
	--************
	-- Get Dir list Height
	--local dirlistheight = Settings.DirHeight; -- ZEDMOD: OriginalBB
	local dirlistheight = self:DirlistGetHeight(); -- ZEDMOD
	
	-- Set Dir List Height
	--self.dirlistBox:SetHeight( Settings.DirHeight ); -- ZEDMOD: OriginalBB
	self.dirlistBox:SetHeight( dirlistheight ); -- ZEDMOD
	
	-- Adjust Dir List Position
	--self:AdjustDirlistPosition(); -- ZEDMOD: OriginalBB
	self:AdjustDirlistPosition( posrep ); -- ZEDMOD
	
	-- ZEDMOD: Update Position
	posrep = posrep + dirlistheight + UI.sep.sMain;
	
	-- ZEDMOD: Update Settings Dir list Height
	Settings.DirHeight = self.dirlistBox:GetHeight();
	
	--*************
	--* Song list *
	--*************
	-- Get Song List Height
	local songlistheight = self:SonglistGetHeight(); -- ZEDMOD
	
	-- Set Song List Height
	-- self:AdjustSonglistHeight(); -- ZEDMOD: OriginalBB
	self.songlistBox:SetHeight( songlistheight ); -- ZEDMOD
	
	-- ZEDMOD: Set Songlist Left
	--self:AdjustSonglistLeft();
	
	-- ZEDMOD: Set Players List
	self.listboxPlayers:SetHeight( songlistheight - UI.hPlayerBtn )
	
	-- ZEDMOD: Set Position
	local songlistpos = posrep;
	
	-- Adjust Song List Position
	--self:AdjustSonglistPosition(); -- ZEDMOD: OriginalBB
	self:AdjustSonglistPosition( songlistpos ); -- ZEDMOD
	
	-- ZEDMOD: Update Position
	posrep = posrep + UI.sep.sMain + songlistheight;
	
	-- ZEDMOD: Update Settings Song List Height
	Settings.SongsHeight = self.songlistBox:GetHeight();
	
	--************************************
	--* Tracks List and Instruments List *
	--************************************
	-- ZEDMOD:
	if ( ( Settings.TracksVisible == "yes" ) and ( CharSettings.InstrSlots["visible"] == "no") ) then
		
		-- Get Track List Height
		local tracklistheight = self:TracklistGetHeight();
		
		-- Set Track List Height and Width
		self:AdjustTracklistLeft();
		self:AdjustTracklistWidth();
		self.tracklistBox:SetHeight( tracklistheight );
		self.listboxSetups:SetHeight( tracklistheight );
		
		-- Set Position
		local tracklistpos = posrep;
		
		-- Adjust Track List Position
		self:AdjustTracklistPosition( tracklistpos );
		
		-- Update Position
		posrep = posrep + UI.sep.sMain + tracklistheight;
		
		-- Update Settings Track List Height
		Settings.TracksHeight = self.tracklistBox:GetHeight();
		
		-- Update Main Window and Container Size
		self:UpdateContainer( posrep );
		self:UpdateMainWindow( unallowedHeight );
		self:SetContainer();
		
	elseif ( ( Settings.TracksVisible == "yes" ) and ( CharSettings.InstrSlots["visible"] == "yes") ) then
	
		-- Get Track List Height
		local tracklistheight = self:TracklistGetHeight();
		
		-- Set Track List Height and Width
		self:AdjustTracklistLeft();
		self:AdjustTracklistWidth();
		self.tracklistBox:SetHeight( tracklistheight );
		self.listboxSetups:SetHeight( tracklistheight );
		
		-- Set Position
		local tracklistpos = posrep;
		
		-- Adjust Track List Position
		self:AdjustTracklistPosition( tracklistpos );
		
		-- Update Position
		posrep = posrep + UI.sep.sMain + tracklistheight;
		
		-- Update Settings Track List Height
		Settings.TracksHeight = self.tracklistBox:GetHeight();
		
		-- Get Instrument List Height
		local instrlistheight = self:InstrlistGetHeight();
		
		-- Set Instrument List Height
		self.instrlistBox:SetHeight( instrlistheight );
		
		-- Set Position
		local instrlistpos = posrep;
		
		-- Adjust Instrument List Position
		self:AdjustInstrlistPosition( instrlistpos );
		
		-- Adjust Instrument Slot
		self:AdjustInstrumentSlots();
		
		-- Update Position
		posrep = posrep + UI.sep.sMain + instrlistheight;
		
		-- Update Settings Instrument List Height
		Settings.InstrsHeight = self.instrlistBox:GetHeight();
		
		-- Update Main Window and Container Size
		if ( self.bInstrumentsVisibleHForced == false ) then
			self:UpdateContainer( posrep );
		else
			self:UpdateContainer( posrep + 10 );
		end
		self:UpdateMainWindow( unallowedHeight );
		self:SetContainer();
		
	elseif ( ( Settings.TracksVisible == "no" ) and ( CharSettings.InstrSlots["visible"] == "yes") ) then
		
		-- Get Instrument List Height
		local instrlistheight = self:InstrlistGetHeight();
		
		-- Set Instrument List Height
		self.instrlistBox:SetHeight( instrlistheight );
		
		-- Set Position
		local instrlistpos = posrep;
		
		-- Adjust Instrument List Position
		self:AdjustInstrlistPosition( instrlistpos );
		
		-- Adjust Instrument Slot
		self:AdjustInstrumentSlots();
		
		-- Update Position
		posrep = posrep + UI.sep.sMain + instrlistheight;
		
		-- Update Settings Instrument List Height
		Settings.InstrsHeight = self.instrlistBox:GetHeight();
		
		-- Update Main Window and Container Size
		if ( self.bInstrumentsVisibleHForced == false ) then
			self:UpdateContainer( posrep );
		else
			self:UpdateContainer( posrep + 10 );
		end
		self:UpdateMainWindow( unallowedHeight );
		self:SetContainer();
	else
		-- Update Main Window and Container Size
		if ( self.bInstrumentsVisibleHForced == false ) then
			self:UpdateContainer( posrep );
		else
			self:UpdateContainer( posrep + 10 );
		end
		self:UpdateMainWindow( unallowedHeight );
		self:SetContainer();
	end
	-- /ZEDMOD
	
	--********************
	--* Adjust Filter UI *
	--********************
	self:AdjustFilterUI();
	
	--********************
	--* Adjust Party UI *
	--********************
	self:AdjustPartyUI();
end

-------------------------------------
-- ZEDMOD: Adjust Instrument Slots --
-------------------------------------
function SongbookWindow:AdjustInstrumentSlots( args )
	if ( self.bInstrumentsVisibleHForced == false ) then
		self.instrlistBox:SetOrientation( Turbine.UI.Orientation.Horizontal );
	else
		self.instrlistBox:SetOrientation( Turbine.UI.Orientation.Vertical );
	end
	local width, height = self.instrlistBox:GetSize();
	local itemWidth = 35;
	local itemHeight = 40;
	local listWidth = width;
	local listHeight = height;
	local itemsPerRowV = listWidth / itemWidth;
	local itemsPerRowH = listHeight / itemHeight;
	if ( self.bInstrumentsVisibleHForced == false ) then
		self.instrlistBox:SetMaxItemsPerLine( itemsPerRowV );
	else
		self.instrlistBox:SetMaxItemsPerLine( itemsPerRowH );
	end
end

-----------------------------------
-- Validate Main Window Position --
-----------------------------------
-- TODO: add complete set of checks
function SongbookWindow:ValidateWindowPosition( winPos )
	local displayWidth, displayHeight = Turbine.UI.Display.GetSize();
	-- Max Width
	if ( winPos.Width > displayWidth ) then
		winPos.Width = displayWidth;
	end
	-- Max Height
	if ( winPos.Height > displayHeight ) then
		winPos.Height = displayHeight;
	end
	-- Any value < 0
	if ( winPos.Left < 0 or winPos.Top < 0 or winPos.Width < 0 or winPos.Height < 0 ) then
		winPos.Left = 0; -- ZEDMOD : OLD 700 Default Settings Left Value
		winPos.Top = 0; -- ZEDMOD : OLD 20 Default Settings Top Value
		winPos.Width = 323; -- ZEDMOD : OLD 342 Default Settings Width Value
		winPos.Height = 400; -- ZEDMOD : OLD 398 Default Settings Height Value
	end
	-- Max Width + Left
	if ( winPos.Left + winPos.Width - 1 > displayWidth ) then
		winPos.Left = 0;
		winPos.Width = winPos.Width;
	end
	-- Max Height + Top
	if ( winPos.Top + winPos.Height - 1 > displayHeight ) then
		winPos.Top = 0;
		winPos.Height = winPos.Height;
	end
end

function SongbookWindow:FixToggleSettings( tglTop, tglLeft )
	local displayWidth, displayHeight = Turbine.UI.Display.GetSize();
	-- Out of Bottom
	if ( tglTop + 35 > displayHeight ) then
		tglTop = displayHeight - 35;
	end
	-- Toggle Top
	if ( tglTop < 0 ) then
		tglTop = 0;
	end
	-- Out of Right
	if ( tglLeft + 35 > displayWidth ) then
		tglLeft = displayWidth - 35;
	end
	-- Toggle Left
	if ( tglLeft < 0 ) then
		tglLeft = 0;
	end
end

-- Fix values settings to default values when no settings for
function SongbookWindow:FixIfNotSettings( Settings, SongDB, CharSettings )
	if ( not Settings.DirHeight ) then
		Settings.DirHeight = "40"; -- ZEDMOD: OriginalBB value: 100
	end
	if ( not Settings.TracksHeight ) then
		Settings.TracksHeight = "40";
	end
	if ( not Settings.TracksVisible ) then
		Settings.TracksVisible = "yes"; -- ZEDMOD: OriginalBB value: no
	end
	if ( not Settings.WindowVisible ) then
		Settings.WindowVisible = "yes"; -- ZEDMOD: OriginalBB value: no
	end	
	if ( not Settings.SearchVisible ) then
		Settings.SearchVisible = "yes";
	end
	if ( not Settings.DescriptionVisible ) then
		Settings.DescriptionVisible = "no";
	end
	if ( not Settings.DescriptionFirst ) then
		Settings.DescriptionFirst = "no";
	end
	if ( not Settings.LastDirOnLoad ) then
		Settings.LastDirOnLoad = "no";
	end
	if ( not Settings.ToggleOpacity ) then
		Settings.ToggleOpacity = "1"; -- ZEDMOD: OriginalBB value 1/4
	end
	if not Settings.FiltersState then Settings.FiltersState = "true"; end
	if not Settings.ChiefMode then Settings.ChiefMode = "true"; end
	if ( not Settings.SoloMode ) then
		Settings.SoloMode = "true";
	end
	if not Settings.ShowAllBtns then Settings.ShowAllBtns = "false"; end
	if not Settings.TimerState then Settings.TimerState = "true"; end -- ZEDMOD: OriginalBB value: false
	if not Settings.TimerCountdown then Settings.TimerCountdown = "true"; end
 	if not Settings.ReadyColState then Settings.ReadyColState = "true"; end
 	if ( not Settings.ReadyColHighlight ) then
		Settings.ReadyColHighlight = "false";
	end
	-- ZEDMOD: Adding Songs Height default value
	if ( not Settings.SongsHeight ) then
		Settings.SongsHeight = "40";
	end
	-- ZEDMOD: Adding Instruments Height default value
	if ( not Settings.InstrsHeight ) then
		Settings.InstrsHeight = "40";
	end
	-- ZEDMOD: Party on/off
	if not Settings.PartyState then Settings.PartyState = "true"; end -- ZEDMOD: OriginalBB value: false
	
	if ( not SongDB.Songs ) then
		SongDB = {
			Directories = {},
			Songs = {}
		};
	end
	
	if ( not Settings.Commands ) then
		Settings.Commands = {};
		Settings.Commands["1"] = { Title = Strings["cmd_demo1_title"], Command = Strings["cmd_demo1_cmd"] };
		Settings.Commands["2"] = { Title = Strings["cmd_demo2_title"], Command = Strings["cmd_demo2_cmd"] };
		Settings.Commands["3"] = { Title = Strings["cmd_demo3_title"], Command = Strings["cmd_demo3_cmd"] };
		Settings.DefaultCommand = "1";
	end
	
	-- Instruments Slots
	if ( not CharSettings.InstrSlots ) then
		CharSettings.InstrSlots = {};
		CharSettings.InstrSlots["visible"] = "yes"; -- ZEDMOD: OriginalBB value: yes
		CharSettings.InstrSlots["visHForced"] = "false"; -- ZEDMOD
		CharSettings.InstrSlots["number"] = 16; -- ZEDMOD: OriginalBB value 8
		for i = 1, CharSettings.InstrSlots["number"] do
			CharSettings.InstrSlots[tostring( i )] = { qsType = "", qsData = "" };
		end
	end
	
	if ( not CharSettings.InstrSlots["number"] ) then
		CharSettings.InstrSlots["number"] = 16; -- ZEDMOD: OriginalBB value 8
	end
	for i = 1, CharSettings.InstrSlots["number"] do
		local si = tostring(i)
		CharSettings.InstrSlots[si].qsType = tonumber( CharSettings.InstrSlots[si].qsType );
	end
	
	-- ZEDMOD
	if ( not CharSettings.InstrSlots["visible"] ) then
		CharSettings.InstrSlots["visible"] = "yes"; -- ZEDMOD: OriginalBB value: no
	end
	-- ZEDMOD: if Instrument Slots is visible, force to one horizontal line
	if ( not CharSettings.InstrSlots["visHForced"] ) then
		CharSettings.InstrSlots["visHForced"] = "false";
	end
end

---------------------------
-- Database : Select Dir --
---------------------------
-- action for selecting a directory
function SongbookWindow:SelectDir( iDir )
	local selectedItem = self:SetListboxColours( self.dirlistBox ); --, iDir )
	if not selectedItem then return; end
	if ( selectedItem:GetText() == ".." ) then
		-- go up one directory level
		selectedDir = "";
		table.remove( dirPath, #dirPath );
		for i = 1, #dirPath do
			selectedDir = selectedDir .. dirPath[i];
		end
	else
		-- go down one directory level into selected directory
		selectedDir = selectedDir .. selectedItem:GetText();
		dirPath[#dirPath + 1] = selectedItem:GetText();
	end
	self:UpdateDirList( )
end

-- Refresh Dir List
function SongbookWindow:UpdateDirList( iSongInDir )
	if ( string.len( selectedDir ) < 61 ) then
		-- display whole directory path
		self.sepDirs.hdgDir:SetText( Strings["ui_dirs"] .. selectedDir ); -- ZEDMOD
	else
		-- truncate directory path
		self.sepDirs.hdgDir:SetText( Strings["ui_dirs"] .. string.sub( selectedDir, string.len( selectedDir ) - 60 ) ); -- ZEDMOD
	end
	-- Refresh Dir List
	self:RefreshDirList();
	
	-- Refresh Song List
	self:LoadSongs(iSongInDir);
end
---------------------------------
-- Database : Refresh Dir List --
---------------------------------
-- Refresh Dir List
function SongbookWindow:RefreshDirList()
	-- Clear Dir List
	self.dirlistBox:ClearItems();
	if selectedDir ~= "/" then self:AddDirItem( ".." ); end
	for i = 1, #SongDB.Directories do
		local _, dirLevelIni = string.gsub( selectedDir, "/", "/" );
		local _, dirLevel = string.gsub( SongDB.Directories[i], "/", "/" );
		if ( dirLevel == dirLevelIni + 1 ) then
			if ( selectedDir ~= "/" ) then
				local matchPos,_ = string.find( SongDB.Directories[i], selectedDir, 0, true );
				if ( matchPos == 1 ) then
					local _,cutPoint = string.find( SongDB.Directories[i], dirPath[#dirPath], 0, true );
					self:AddDirItem( string.sub( SongDB.Directories[i], cutPoint + 1 ) )
				end
			else
				self:AddDirItem( string.sub( SongDB.Directories[i], 2 ) )
			end
		end
	end
end

function SongbookWindow:AddDirItem( sText )
	local item = Turbine.UI.Label();
	item:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleLeft );
	item:SetSize( 1000, UI.lb.hItem );
	item:SetFont( UI.lb.font )
	item:SetText( sText );
	self.dirlistBox:AddItem( item );
end


---------------------------------------
-- Database : Load Songs to Songlist --
---------------------------------------

function SongbookWindow:GetPartsFilter( filters ) -- TODO: Set display track count self.selectedSetupCount
	if not self.aFilters['p'].cb or not self.aFilters['p'].cb:IsChecked( ) then return; end
	local sFilter = self.aFilters['p'].edit:GetText();
	if sFilter == "" then
		if not self.maxPartCount then return -- no limit given and no global limit set
		else sFilter = "1-" .. tostring( self.maxPartCount ); end
	end
	filters.sPartsPattern = self:ParsePartsFilter( sFilter )
end

function SongbookWindow:GetLengthFilter( filters )
	if not self.aFilters['l'].cb or not self.aFilters['l'].cb:IsChecked( ) then return; end
	local edit = self.aFilters['l'].edit
	--local sInput = edit:GetText( )
	local secsLow, secsHigh
	local minsLow = edit:GetText( ):match( "%f[%d:-](%d+)%f[^%d:]" )
	if minsLow then secsLow = 0
	else minsLow, secsLow = edit:GetText( ):match( "%f[%d:-](%d+):(%d+)%f[^%d]" ); end
	local minsHigh = edit:GetText( ):match( "-(%d+)%f[^%d:]" )
	if minsHigh then secsHigh = 0
	else minsHigh, secsHigh = edit:GetText( ):match( "-(%d+):(%d+)" ); end
	if not minsLow or not secsLow then return; end
	if minsHigh and secsHigh then
		filters.minLength = minsLow * 60 + secsLow
		filters.maxLength = minsHigh * 60 + secsHigh		
	else
		local length = minsLow * 60 + secsLow
		local range = length/10
		if range > 15 then range = 15; end
		filters.minLength = length - range
		filters.maxLength = length + range
	end
end

function SongbookWindow:ClearSongList( )
	self.songlistBox:ClearItems( ); selectedSongIndex = nil
	self:ClearTrackList( )
	self:ClearSongState( )
end

function SongbookWindow:ClearTrackList( )
	self.tracklistBox:ClearItems( ); selectedTrack = nil
	self:ClearSetupList( )
end

function SongbookWindow:ClearSetupList( )
	self.listboxSetups:ClearItems( ); self.iCurrentSetup = nil
end
-- load content to song list box
function SongbookWindow:LoadSongs( iSongInDir )
	self:ClearSongList( )
	local nFiltered = 0;
	local filters = {}; self:GetPartsFilter( filters ); self:GetLengthFilter( filters )
	for i = 1, librarySize do
		-- Added function to filter song data
		if ( SongDB.Songs[i].Filepath == selectedDir and self:ApplyFilters( SongDB.Songs[i], filters ) ) then
			local songItem = Turbine.UI.Label();
			songItem:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleLeft );
			songItem:SetSize( 1000, UI.lb.hItem );
			songItem:SetFont( UI.lb.font )
			if ( Settings.DescriptionVisible == "yes" ) then
				if ( Settings.DescriptionFirst == "yes" ) then
					songItem:SetText( SongDB.Songs[i].Tracks[1].Name .. " / " .. SongDB.Songs[i].Filename );
				else
					songItem:SetText( SongDB.Songs[i].Filename .. " / " .. SongDB.Songs[i].Tracks[1].Name );
				end
			else
				songItem:SetText( SongDB.Songs[i].Filename );
			end
			self.songlistBox:AddItem( songItem );
			nFiltered = nFiltered + 1;
			self.aFilteredIndices[nFiltered] = i; -- Create filtered index
		end
	end
	local bSelected = iSongInDir
	iSongInDir = iSongInDir or 1
	ASSERT( nFiltered <= 0 or iSongInDir < nFiltered, "iSongInDir < nFiltered" )
	if nFiltered > 0 and iSongInDir <= nFiltered then
		self:SelectListSong( iSongInDir, bSelected ); end

	self:InitSonglist( );
end

function SongbookWindow:GetSongName( iSong )
	iSong = iSong or selectedSongIndex
--	if ( SongDB.Songs[iSong].Tracks[1].Name ~= "" ) then
--		return SongDB.Songs[iSong].Tracks[1].Name
--	end
	return SongDB.Songs[iSong].Filename
end

---------------------------
-- Database : Select Song -
---------------------------

-- Action for selecting a song; iSong is index in list
function SongbookWindow:SelectListSong( iSong, bSelected )
	if iSong < 1 or iSong > self.songlistBox:GetItemCount() then return; end
	--if not bNoSelect then self.songlistBox:SetSelectedIndex( iSong ); end
	self.songlistBox:SetSelectedIndex( iSong )
	if bSelected then self.songlistBox:EnsureVisible( iSong ); end
	if self.aFilteredIndices and self.aFilteredIndices[iSong] then
		iSong = self.aFilteredIndices[iSong]; end -- get song db index
	self:SelectDbSong( iSong )
end

function SongbookWindow:SelectDbSong( iSong )
	if iSong == selectedSongIndex then return; end
	selectedSongIndex = iSong
	selectedTrack = nil
	self.aSetupTracksIndices = {};
	self.aSetupListIndices = {};
	self.iCurrentSetup = nil;
	-- clear focus
	self:SetListboxColours( self.songlistBox ); --, iSong )
	local song = SongDB.Songs[iSong]
	selectedSong = song.Filename;
	if song.Tracks and #song.Tracks > 1 and song.Tracks[1].Name and song.Tracks[1].Name ~= "" then
		self.songTitle:SetText( song.Tracks[1].Name );
	else
		self.songTitle:SetText( song.Filename );
	end
	self.trackNumber:SetText( song.Tracks[1].Id );
	self.trackPrev:SetVisible( false );
	if ( #song.Tracks > 1 ) then
		self.trackNext:SetVisible( self.bShowAllBtns );
	else
		self.trackNext:SetVisible( false );
	end
	self:SetTags( song )
	self:ClearPlayerReadyStates();
	self:SetPlayerColours();
	self:ListSetups( iSong );
	if not song.Setups then
		self:ListTracks( iSong )
		--self.tracklistBox:SetSelectedIndex( 1 )
		self:SelectTrack( 1 )
	else
		local iSetup = self:SetupIndexForCount( iSong, self.selectedSetupCount );
		self:SelectSetup( iSetup );
	end
	self:UpdateSetupColours();

	local found = self.tracklistBox:GetItemCount();
	self.sepSongsTracks.heading:SetText( Strings["ui_parts"] .. tostring(found) );
	if assignWindow then assignWindow:NewSongSelected( iSong ); end
end

function SongbookWindow:SetTags( song )
	self.aEditTags['c']:SetText( song.Artist and song.Artist or "" )
	self.aEditTags['m']:SetText( song.Mood and song.Mood or "" )
	self.aEditTags['g']:SetText( song.Genre and song.Genre or "" )
	self.aEditTags['a']:SetText( song.Transcriber and song.Transcriber or "" )
end

function SongbookWindow:PreSelectTrack( iSong, sTrack )
	self.preSelTrack = nil
	if not sTrack then return; end -- could be individual announcement, and we're not in it
	local song = SongDB.Songs[iSong]
	if not song or not song.Tracks or #song.Tracks <= 0 or not sTrack then return; end
	local sID, sInstr = sTrack:match( "%[(%d+)%]%s+(.+)")
	for i = 1, #song.Tracks do
		if song.Tracks[ i ].Id == sID  or ( sInstr and song.Tracks[ i ].Name:find( sInstr.."$" ) ) then
			self.preSelTrack = i; return; end
	end
end

------------------------------
-- Database : Selected Track -
------------------------------
-- Track list : Selected Track Index
function SongbookWindow:SelectedTrackIndex( iList )
	iList = iList or selectedTrack; -- use global selected track index if none provided
	if self.iCurrentSetup and self.aSetupTracksIndices[iList] then
		return self.aSetupTracksIndices[iList];
	end
	return iList;
end

-- Track list action for repopulating the track list when song is changed
function SongbookWindow:ListTracks( songId )
	self.tracklistBox:ClearItems();
	self.alignTracksRight = false
	local maxLength, iMax = 0, 0
	for i = 1, #SongDB.Songs[songId].Tracks do
		local length = self:AddTrackToList( songId, i )
		if maxLength < length then maxLength = length; iMax = i; end
	end
	--self.tracklistBox:GetItem( iMax ):SetHorizontalScrollBar( self.tracklistBox.scrollBarh )
	for i = self.tracklistBox:GetItemCount(), 1, -1 do
		if i ~= 0 then self.tracklistBox:GetItem( i ):SetHorizontalScrollBar( self.tracklistBox.scrollBarh ); end
	end
	--TRACE(" iMax="..tostring(iMax) )
	--Turbine.Chat.Received = self.ChatHandler; -- Enable chat monitoring for ready messages to update track colours
end


function SongbookWindow:CreateTrackItem( )
	local item = Turbine.UI.Label();
	item:SetMultiline( false );
	item:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleLeft );
	item:SetFont( UI.lb.tracks.font )
	item.MouseClick = self.sepSongsTracks.MouseClick;
	item:SetForeColor( UI.colour.default );
	item.PositionChanged = function(s,a)
		if not s.bBlockMoveCB and mainWnd.alignTracksRight then 
			for i = 1, mainWnd.tracklistBox:GetItemCount() do
				s.bBlockMoveCB = true
				mainWnd.tracklistBox:GetItem( i ):SetLeft( mainWnd.tracklistBox:GetWidth() - mainWnd.tracklistBox.contentColWidth - 10 )
				s.bBlockMoveCB = nil
			end
		end
	end
	return item
end

-- Track list : Add Track to List
function SongbookWindow:AddTrackToList( iSong, iTrack )
	local sTerseName = self:TerseTrackname( SongDB.Songs[iSong].Tracks[iTrack].Name );
	local trackItem = self:CreateTrackItem( )
	local sText = "[" .. SongDB.Songs[iSong].Tracks[iTrack].Id .. "]" .. sTerseName
	trackItem:SetText( sText );
	--trackItem:SetHorizontalScrollBar( self.tracklistBox.scrollBarh )
	self.tracklistBox:AddItem( trackItem );
	return sText:len( )
end

-- Track list : Right-align track names (so user can quickly check then end of the track name)
function SongbookWindow:RealignTracknames( )
	self.alignTracksRight = not self.alignTracksRight
	if self.alignTracksRight then
		self.tracklistBox:ShiftLeft( )
	else
		self.tracklistBox:CancelShift( )
	end
end

-- Find track name in tracklistBox and select
function SongbookWindow:SelectTrackByName( sTrack )
	local sID, sInstr = sTrack:match( "%[(%d+)%]%s+(.+)")
	sID = "^%["..sID.."%]"
	for i = 1, self.tracklistBox:GetItemCount( ) do --self.tracklistBox:GetItemCount( ) do
		local sItemTrack = self.tracklistBox:GetItem( i ):GetText( )
		if self:CheckTrackForAnn( sItemTrack, sID, sInstr ) then
			self:SelectTrack( i )
			return
		end
	end
end

-- announcement is "[nn] instr" (without track/song name)
function SongbookWindow:CheckTrackForAnn( sTrack, sID, sInstr )
	if sID and sTrack:find( sID ) then return true; end
	if sInstr and sTrack:find( sInstr.."$" ) then return true; end
	return false
end

-- Track list : action for changing track selection (trackid is listbox index)
function SongbookWindow:SelectTrack( trackId, bNoSelect )
	if self.preSelTrack then
		if not self.aSetupListIndices[self.preSelTrack] then trackId = self.preSelTrack
		else trackId = self.aSetupListIndices[self.preSelTrack]; end
		self.preSelTrack = nil; end

	if selectedTrack == trackId then return; end
	selectedTrack = trackId;
	self.tracklistBox:SetSelectedIndex( trackId )
	--if not bNoSelect then self.tracklistBox:SetSelectedIndex( trackId ); end
	local song = SongDB.Songs[selectedSongIndex]
	local iTrack = self:SelectedTrackIndex( trackId );
	if not song.Tracks[iTrack] then
		WRITE( FailRGB.."Inv.track #"..tostring(iTrack)..", id="..tostring(trackId)..", pre="..tostring(self.preSelTrack).."</rgb>")
		return; end
	self.trackPrev:SetVisible( selectedTrack > 1 and self.bShowAllBtns );
	self.trackNext:SetVisible( selectedTrack < #song.Tracks and self.bShowAllBtns )
	self.trackNumber:SetText( song.Tracks[iTrack].Id ); -- TODO: can be invalid
	self.songTitle:SetText( song.Tracks[iTrack].Name );
	self.playSlotShortcut = Turbine.UI.Lotro.Shortcut( Turbine.UI.Lotro.ShortcutType.Alias, Strings["cmd_play"] .. " \"" .. song.Filepath .. selectedSong .. "\" " .. song.Tracks[iTrack].Id );
	self.playSlot:SetShortcut( self.playSlotShortcut );
	self.playSlot:SetVisible( Settings.SoloMode == "true" );
	self.syncSlotShortcut = Turbine.UI.Lotro.Shortcut( Turbine.UI.Lotro.ShortcutType.Alias, Strings["cmd_play"] .. " \"" .. song.Filepath .. selectedSong .. "\" " .. song.Tracks[iTrack].Id .. " " .. Strings["cmd_sync"] );
	self.syncSlot:SetShortcut( self.syncSlotShortcut );
	self.syncSlot:SetVisible( true );
	self.shareSlot:SetShortcut( Turbine.UI.Lotro.Shortcut( Turbine.UI.Lotro.ShortcutType.Alias, self:ExpandCmd( Settings.DefaultCommand ) ) );
	self.shareSlot:SetVisible( self.bShowAllBtns );
	self:SetTrackColours( selectedTrack );
end

-- Track list : action for setting focus on the track list
function SongbookWindow:SetTrackColours( iSelectedTrack )
	if not self.tracklistBox or self.tracklistBox:GetItemCount() < 1 then return; end
	self:ClearPlayerReadyStates(); -- Clear ready states for currently displayed song
	local aTracks = SongDB.Songs[selectedSongIndex].Tracks
	for iTrack = 1, #aTracks do
		if Count( self.aSetupListIndices ) <= 0 or self.aSetupListIndices[iTrack] then -- not setup or in it
			local iList = ( self.aSetupListIndices[iTrack] and self.aSetupListIndices[iTrack] or iTrack )
			local readyState = self:GetTrackReadyState( aTracks[iTrack].Name );
			local item = self.tracklistBox:GetItem( iList );
			item:SetForeColor( self:GetColourForTrack( readyState, iList == iSelectedTrack ) );
			item:SetBackColor( self:GetBackColourForTrack( readyState ) );
			self:SetTrackReadyChar( iList, readyState );
		else -- not part of setup
			self:GetTrackReadyState( aTracks[iTrack].Name, 3 );
		end
	end
end

-- Track list : return track colour based on readyState retrieved from GetTrackReadyState(...)
function SongbookWindow:GetColourForTrack( readyState, bSelectedTrack )
	if bSelectedTrack then
		if not readyState then -- track not ready
			return UI.colour.defHighlighted;
		elseif readyState == 0 then -- track is ready by more than one player
			return UI.colour.readyMultipleHighlighted;
		else -- track ready by one player
			return UI.colour.readyHighlighted;
		end
	else
		if not readyState then return UI.colour.default;
		elseif readyState == 0 then return UI.colour.readyMultiple;
		else return UI.colour.ready;
		end
	end
end

-- Track list : background colour indicates the track one has ready
-- TODO: blue (multiple ready track) overrides wrong instrument indicator
function SongbookWindow:GetBackColourForTrack( readyState )
	if not readyState or readyState ~= self.sPlayerName then
		return UI.colour.backDefault; end
	return UI.colour.backHighlight;
	--if self.bInstrumentOk then return UI.colour.backHighlight; end
	--return self.backColourWrongInstrument
end

-- Track list : set track ready indicator
function SongbookWindow:SetTrackReadyChar( iList, readyState )
	if ( not readyState ) then -- track not ready
		self.tracklistBox:SetColumnChar( iList, self.chNone, false );
	elseif ( readyState == 0 ) then -- track is ready by more than one player
		self.tracklistBox:SetColumnChar( iList, self.chMultiple, true );
	else -- track ready by one player
		self.tracklistBox:SetColumnChar( iList, self.chReady, false );
	end
end

-----------------
-- Message Box --
-----------------

local function LblInstr_Click( s, a )
	if a.Button ~= Turbine.UI.MouseButton.Left then return; end
	if UI.indLeft + s:GetWidth( ) - a.X > 130 then return; end
	if not mainWnd.instrSelDrop:IsVisible( ) then return; end
	local lb = mainWnd.lbSlots
	if not lb or lb.bStale then mainWnd:ListInstruments( )
	else lb:SetVisible( not lb:IsVisible( ) ); end
end

function SongbookWindow:CreateInstrLabel( )
	self.lblInstr = Turbine.UI.Label();
	self.lblInstr:SetParent( self ); -- self.listFrame
	self.lblInstr:SetVisible( true );
	self.lblInstr:SetMultiline( false );
	self.lblInstr:SetSize( -UI.indLeft + self:GetWidth( ) - 2 - 12 - UI.sep.sMain, 18 )
	self.lblInstr:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleRight );
	self.lblInstr:SetZOrder( 360 );
	self.lblInstr:SetPosition( UI.indLeft, UI.listFrame.y - 7 );
	self.lblInstr.MouseClick = LblInstr_Click
	self:SetTextModeNormal( self.lblInstr )
	
	self.instrSelDrop = Turbine.UI.Control( );
	self.instrSelDrop:SetParent( self );
	self.instrSelDrop:SetSize( 14, 9 );
	self.instrSelDrop:SetPosition( UI.indLeft + 1 + self.lblInstr:GetWidth( ), UI.listFrame.y + UI.sep.sMain );
	self.instrSelDrop.MouseClick = LblInstr_Click
	self.instrSelDrop:SetBackground( gDir.."droparrow_a.tga" ) -- now hiding it when inactive, so only active state needed
	--self.instrSelDrop:SetBackground( gDir .. "droparrow.tga" );
	self.instrSelDrop:SetBlendMode( Turbine.UI.BlendMode.AlphaBlend );
	self.instrSelDrop:SetZOrder( 360 );
	self.instrSelDrop:SetVisible( false );
end

function SongbookWindow:ShowInstrLabel( b )
	self.lblInstr:SetVisible( b )
	self.instrSelDrop:SetVisible( b );
end

function SongbookWindow:SetInstrLabelActive( b )
	if self.lbSlots then self.lbSlots:SetVisible( false ); self.lbSlots.bStale = true; end -- new song/track selection, so need to relist instr
	self.instrSelDrop:SetVisible( b )
	if b then self.lblInstr:SetForeColor( UI.colour.active )
	else self.lblInstr:SetForeColor( UI.colour.default ); end
end
		

-- ZEDMOD: Create Message
function SongbookWindow:CreateAlertLabel( )
	self.lblInstrAlert = Turbine.UI.Label();
	self.lblInstrAlert:SetParent( self ); -- self.listFrame
	self.lblInstrAlert:SetVisible( false );
	self.lblInstrAlert:SetMultiline( false );
	self.lblInstrAlert:SetBackColor( g_cfgUI.colorLbItemSelected );
	self.lblInstrAlert:SetSize( -UI.indLeft + self:GetWidth( ) - UI.sep.sMain, UI.hInstrAlert );
	self.lblInstrAlert:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleCenter );
	self.lblInstrAlert:SetZOrder( 360 );
	--self.lblInstrAlert:SetPosition( self:GetWidth( ) - 22 - self.lblInstrAlert:GetWidth(), UI.listFrame.y - 9 ); -- ,0
	self.lblInstrAlert.MouseClick = function( s, a ) s:SetVisible( false ); end
	self:SetTextModeNormal( self.lblInstrAlert )
end

-- (Nim) split up the message/timer label into one for alerts and one for the timer
function SongbookWindow:CreateTimerLabel( )
	self.lblTimer = Turbine.UI.Label();
	self.lblTimer:SetParent( self ); -- self.listFrame
	self.lblTimer:SetMultiline( false );
	self.lblTimer:SetSize( 50, 28 );
	self.lblTimer:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleRight );
	self.lblTimer:SetZOrder( 350 );
	self.lblTimer:SetPosition( UI.xCounter, UI.yCounter )
	--self.lblTimer:SetPosition( self:GetWidth() - 10 - self.lblTimer:GetWidth(), UI.listFrame.y - 28 )
	self.lblTimer:SetVisible( false );
	--self.lblTimer:SetBackColor( UI.colour.defHighlighted )
	self:SetTimerModeNormal( self.lblTimer )
end

function SongbookWindow:SetTextModeNormal( lbl )
	lbl:SetFont( Turbine.UI.Lotro.Font.TrajanPro16 ) --TrajanPro16  BookAntiquaBold22
	lbl:SetForeColor( Turbine.UI.Color( 1, 1, 1, 1 ) )
	--lbl:SetBackColor( UI.colour.listFrame )
end

function SongbookWindow:SetTextModeWarn( lbl )
	lbl:SetFont( Turbine.UI.Lotro.Font.TrajanProBold16 )--TrajanPro19 ) --BookAntiquaBold26 )
	lbl:SetForeColor( Turbine.UI.Color( 1, 1, 0.3, 0.3 ) )
	--lbl:SetBackColor( UI.colour.listFrame )
end

function SongbookWindow:SetTextModeAlert( lbl )
	lbl:SetFont( Turbine.UI.Lotro.Font.TrajanProBold22 )--TrajanPro20 ) --BookAntiquaBold26 )
	lbl:SetForeColor( Turbine.UI.Color( 1, 1, 0.3, 0.4 ) )
	--lbl:SetBackColor( Turbine.UI.Color( 1, 0.9, 0.9, 0.9 ) )
end


-----------
-- Timer --
-----------

function SongbookWindow:SetTimerModeNormal( lbl )
	lbl:SetFont( Turbine.UI.Lotro.Font.TrajanPro21 ) --TrajanPro16  BookAntiquaBold22
	lbl:SetForeColor( Turbine.UI.Color( 1, 1, 1, 1 ) )
end

function SongbookWindow:SetTimerModeAlert( lbl )
	lbl:SetFont( Turbine.UI.Lotro.Font.TrajanProBold24 ) --TrajanPro16  BookAntiquaBold22
	lbl:SetForeColor( Turbine.UI.Color( 1, 1, 0.3, 0.3 ) )
end

-- Print the given current time in seconds to the timer label
function SongbookWindow:WriteTimeMsg( tCurrent )
	local mins = math.floor( tCurrent / 60 );
	local secs = tCurrent - mins * 60
	self.lblTimer:SetText( string.format( "%u:%02u", mins, secs ) ); -- ZEDMOD
	return mins == 0 and secs < 10 -- return true if in last seconds
end

function SongbookWindow:AddDelayedCall( nSecs, fCallback )
	mainWnd:AddPeriodic( 1, nSecs, fCallback, nil )
end


-- Activate timer count in Update(); call SetWantsUpdates if necessary
function SongbookWindow:StartCounter( )
	self.startTimer = Turbine.Engine.GetLocalTime();
	
	self.songDuration = self:GetRunningTime( )
	
	if ( ( self.bTimerCountdown == true ) and ( self.songDuration > 0 ) ) then
		self.currentTime = self.songDuration;
	else
		self.currentTime = 0;
	end
	
	self:WriteTimeMsg( self.currentTime );
	self.lblTimer:SetVisible( true )
	
	self:StartTimer( )
	self.bCounterActive = true
end

function SongbookWindow:UpdateCounter( )
	if not self.lblTimer then return; end
	local time = Turbine.Engine.GetLocalTime() - self.startTimer
	if time == self.currentTime then return; end
	self.currentTime = time --Turbine.Engine.GetLocalTime() - self.startTimer
	
	local bKeepRunning = ( self.songDuration == 0 or self.currentTime <= self.songDuration )
	if self.bTimerCountdown == true and self.songDuration > 0 then
		self.currentTime = self.songDuration - self.currentTime
		bKeepRunning = self.currentTime >= 0
	end
	
	if bKeepRunning then
		self:WriteTimeMsg( self.currentTime )
		if self.currentTime < 10 and self.bTimerCountdown then self:SetTimerModeAlert( self.lblTimer ); end
	else
		self:StopCounter();
		if self.bTimerCountdown then self:SetTimerModeNormal( self.lblTimer ); end
	end
end

function SongbookWindow:StopCounter( )
	self.bCounterActive = false
	self:StopTimer( )

	self.lblTimer:SetVisible( false )
end

function SongbookWindow:ActivateCounter( bActivate )
	self.bDisplayTimer = bActivate;
	if not bActivate and self.bCounterActive then self:StopCounter( ); end
end


function SongbookWindow:AddPeriodic( nCycles, time, f1, f2, ft, fe )
	local nt = Turbine.Engine.GetGameTime() + time
	self.aPeriodic[ #self.aPeriodic + 1 ] = { ["nt"]=nt, ["n"]=nCycles, ["t"]=time, ["f1"]=f1, ["f2"]=f2, ["ft"]=ft, ["fe"]=fe }
	self:StartPeriodic( )
end

function SongbookWindow:StartPeriodic( )
	self:StartTimer( )
	self.bPeriodicActive = true
end

function SongbookWindow:UpdatePeriodic( )
	local bAllDone = true
	for i = #self.aPeriodic, 1, -1 do
		local p = self.aPeriodic[ i ]
		if p.fe and p.fe( ) then --terminate
			if p.ft then p.ft(); end;
			table.remove( self.aPeriodic, i ); break; end
		local ct = Turbine.Engine.GetGameTime()
		if ct > p.nt then
			local tnew = p.f1( ); p.f1, p.f2 = p.f2, p.f1
			if tnew then p.t = tnew; end
			p.nt = ct + p.t
			p.n = p.n - 1
			if p.n <= 0 then if p.ft then p.ft(); end;
				table.remove( self.aPeriodic, i ); break; end
		end
		bAllDone = false
	end
	if bAllDone then self:StopPeriodic( ); end
end

function SongbookWindow:StopPeriodic( )
	self.bPeriodicActive = false
	self:StopTimer( )
end

-- Activate message blinking in Update(); call SetWantsUpdates if necessary
function SongbookWindow:StartMessageBlink( )
	local f1 = function( ) self.lblInstrAlert:SetVisible( false ); end
	local f2 = function( ) self.lblInstrAlert:SetVisible( true ); end
	local ft = function( ) f1( ); self.songTitle:SetVisible( true ); end
	self.songTitle:SetVisible( false );
	mainWnd:AddPeriodic( 12, 0.25, f1, f2, ft, function() return self.bInstrumentOk; end )
end

-- Start Timer
function SongbookWindow:StartTimer()
	if not self.bCounterActive and not self.bPeriodicActive then self:SetWantsUpdates( true ); end
end

-- Stop Timer
function SongbookWindow:StopTimer()
	if not self.bCounterActive and not self.bPeriodicActive then self:SetWantsUpdates( false ); end
end

-- Scan track names for durations; take the longest
function SongbookWindow:GetRunningTime()
	local songDuration = 0;
	local item, songTime;
	for i = 1, self.tracklistBox:GetItemCount() do
		item = self.tracklistBox:GetItem( i ); -- attempt to extract a running time from the track name
		local sMinutes, sSeconds = string.match( item:GetText(), ".*%((%d+):(%d+)%).*" ); -- try (mm:ss)
		if ( ( not sMinutes ) or ( not sSeconds ) ) then
			sMinutes, sSeconds = string.match( item:GetText(), ".*(%d+):(%d+).*" ); -- no luck, try just mm:ss, should still be safe
		end
		if ( ( sMinutes ) and ( sSeconds ) and ( tonumber( sMinutes ) < 60 ) and ( tonumber( sSeconds ) < 60 ) ) then
			songTime = sMinutes * 60 + sSeconds;
			if ( songTime > songDuration ) then  -- need longest track
				songDuration = songTime;
			end
		end
	end
	return songDuration
end


------------
-- Search --
------------

function SongbookWindow:GetSearchIndices( fCmp )
	local iStart = 1
	while iStart < librarySize and not fCmp( SongDB.Songs[iStart].Filepath, selectedDir) do iStart = iStart + 1; end
	if iStart < librarySize then
		local iEnd = iStart
		while iEnd < librarySize and fCmp( SongDB.Songs[iEnd].Filepath, selectedDir ) do iEnd = iEnd + 1; end
		return iStart, iEnd - 1
	end
	return -1, -1
end

TestItem = 1
function SongbookWindow:LbTracksStats( )
	for i = 1, LBScroll.GetItemCount( self.tracklistBox ) do
		local item = LBScroll.GetItem( self.tracklistBox, i )
		TRACE( "item#"..tostring(i)..": "..tostring(item:GetWidth()).."x"..tostring(item:GetHeight())..", '"..tostring(item:GetText()).."'")
	end
end

function SongbookWindow:SelectSongByName( sName, sTrack )
	if not SongDB or not SongDB.Songs then return; end
	for iSong = 1, librarySize do
		local sCleanName = SongDB.Songs[ iSong ].Filename:gsub( " +", " " ) -- client sanitizes shortcut strings
		if sCleanName == sName then
			mainWnd:PreSelectTrack( iSong, sTrack )
			if selectedSongIndex ~= iSong or self.preSelTrack ~= selectedTrack then
				if selectedSongIndex == iSong and not self.preSelTrack then return; end -- probably individual announcement
				if mainWnd.anCpt.setupCountPrev and mainWnd.anCpt.setupCount < mainWnd.anCpt.setupCountPrev then
					mainWnd.anCpt.setupCount = mainWnd.anCpt.setupCountPrev; end -- individual announcement, select setup as previous
					selectedDir = SongDB.Songs[ iSong ].Filepath
				local iSongInDir = 1
				for j = iSong-1,1,-1 do
					if SongDB.Songs[ j ].Filepath ~= selectedDir then break; end
					iSongInDir = iSongInDir + 1
				end
				dirPath = {}
				for d in selectedDir:gmatch( "(.-/)" ) do dirPath[#dirPath+1] = d; end
				self:UpdateDirList( iSongInDir )
			end
		end
	end
end


local function ModifyFilters( sSearch, chFilter, sFilter )
	if not sFilter or not sFilter:find( "[%w%p]" ) then
		sSearch = sSearch:gsub( "%W?"..chFilter..Patterns["quotedKwVal"].."%W?", ' ' )
		sSearch = sSearch:gsub( "%W?"..chFilter..Patterns["kwVal"].."%W?", ' ' )
	else
		if sFilter:find( "%s" ) then
			sSearch = sSearch .. " " .. chFilter .. ":\"" .. sFilter .."\""
		else
			sSearch = sSearch .. " " .. chFilter .. ":" .. sFilter
		end
	end
	return sSearch
end


local function ApplySearchterm( song, sSearch )
	if string.find( string.lower( song.Filename ), sSearch ) then return true; end
	-- if not song.Tracks then return false; end
	-- for j = 1, #song.Tracks do
	-- 	if string.find( string.lower( song.Tracks[j].Name ), sSearch ) then return true; end
	-- end
	return false
end

-- action to search songs
-- chFilter will be added (sFilter~=nil) or removed from search string
function SongbookWindow:SearchSongs( chFilter, sFilter )
	local sSearch = self.searchInput:GetText():lower()
	if ( not sSearch or sSearch == "" ) and not self:FiltersActive( ) then
		self:LoadSongs( ); return; end
	if chFilter then
		sSearch = ModifyFilters( sSearch, chFilter, sFilter )
		self.searchInput:SetText( sSearch:gsub( " +", " " ) )
	end
	sSearch = self:ParseKeywords( sSearch ):gsub( " +", " " )
	if sSearch == " " then sSearch = ""; end
	self:ClearSongList( ) --self.songlistBox:ClearItems( );
	local matchFound;
	local nFound = 0;
	self.aFilteredIndices = {};
	local filters = {}; self:GetPartsFilter( filters ); self:GetLengthFilter( filters )
	local iStart, iEnd = 1, librarySize
	if self.searchMode then
		if self.searchMode:SearchCurrent( ) then iStart, iEnd = self:GetSearchIndices( function(s) return s==selectedDir; end )
		elseif self.searchMode:SearchSubfolders( ) then iStart, iEnd = self:GetSearchIndices( function(s) return s:find( selectedDir, 1, true) == 1; end )
		end
	end
	--if self.bSearchDirOnly then iStart, iEnd = self:GetSearchIndices( ); end
	if iStart >= 0 then
		for i = iStart, iEnd do
			local song = SongDB.Songs[i]
			if ApplySearchterm( song, sSearch ) and self:ApplyFilters( song, filters ) then
				local songItem = Turbine.UI.Label();
				songItem:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleLeft );
				songItem:SetSize( 1000, UI.lb.hItem );
				songItem:SetFont( UI.lb.font )
				if ( Settings.DescriptionVisible == "yes" ) then
					songItem:SetText( song.Filename .. " / " .. song.Tracks[1].Name );
				else
					songItem:SetText( song.Filename );
				end
				self.songlistBox:AddItem( songItem );
				nFound = nFound + 1;
				self.aFilteredIndices[nFound] = i; -- Create index redirect table
			end
		end
	end
	--local found = self.songlistBox:GetItemCount();
	if nFound > 0 then self:SelectListSong( 1 )
	else
		if self.searchMode:SearchCurrent( ) then WRITE( Strings["noSongsFoundInDir"] .. selectedDir .."'." )
		elseif self.searchMode:SearchSubfolders( ) then
			WRITE( Strings["noSongsFoundInDir"] .. selectedDir .. Strings["noSongsFoundInSubDirs"] )
		else WRITE( Strings["noSongsFound"] ); end
		--self:ClearSongState();
	end
	self:InitSonglist( )
end


function SongbookWindow:ParseKeywords( sSearch )
	local bFa = self.bFilterCbActive; self.bFilterCbActive = false
	local bFoundKw
	sSearch, bFoundKw = self:ParseKeywordsQuoted( sSearch )
	for k, v in sSearch:gmatch( "(%a)" .. Patterns["iterKwVal"] ) do
		if not bFoundKw then self:ClearFilters( ); bFoundKw = true; end
		self:CopyKwVal( k, v )
	end
	self.bFilterCbActive = bFa
	return sSearch:gsub( "%W?%a"..Patterns["kwVal"].."%W?", ' ' )
end

function SongbookWindow:ParseKeywordsQuoted( sSearch )
	local bFoundKw = false
	for k, v in sSearch:gmatch( "(%a)" .. Patterns["iterQuotedKwVal"] ) do
		if not bFoundKw then self:ClearFilters( ); bFoundKw = true; end
		self:CopyKwVal( k, v )
	end
	return sSearch:gsub( "%W?%a"..Patterns["quotedKwVal"].."%W?", ' ' ), bFoundKw 
end

local function GetKwVal( v, cb, edit ) if cb then cb:SetChecked( true ); edit:SetText( v ); end; end
function SongbookWindow:CopyKwVal( k, v )
	if not self.aSearchKw:find( k, 1, true ) then
		WRITE( Strings["filterUnknown"] .. " '" .. tostring(k) .. "'" )
		local flt = {}
		for i = 1, self.aSearchKw:len() do
			local ch = self.aSearchKw:sub( i, i ); flt[ #flt + 1 ] = ch; end
		WRITE( Strings["filterValid"]..table.concat( flt, ", " ) )
		return; end
	GetKwVal( v, self.aFilters[k].cb, self.aFilters[k].edit )
end

-- action for toggling search function on and off
function SongbookWindow:ToggleSearch( mode )
	if Settings.SearchVisible == "yes" or mode == "off" then
		Settings.SearchVisible = "no";
		self:SetSearch( -20, false );
	else
		Settings.SearchVisible = "yes";
		self:SetSearch( 20, true );
	end
end

function SongbookWindow:SetSearch( delta, bShow )
	self.searchInput:SetVisible( bShow );
	self.searchBtn:SetVisible( bShow );
	self.searchMode:SetVisible( bShow );
	self.clearBtn:SetVisible( bShow );
	self.lFYmod = self.lFYmod + delta;
	self.lCYmod = self.lCYmod + delta;
	self.listFrame:SetTop( self.listFrame:GetTop() + delta );
	self.listContainer:SetTop( self.listContainer:GetTop() + delta );
	local windowHeight = self:GetHeight() + delta; -- ZEDMOD
	local containerHeight = self.listContainer:GetHeight(); -- ZEDMOD
	local unallowedHeight = windowHeight - containerHeight; -- ZEDMOD
	self:UpdateMainWindow( unallowedHeight ); -- ZEDMOD
	--self:SetSonglistHeight( self.songlistBox:GetHeight() - delta ); -- ZEDMOD: OriginalBB
	--self:MoveTracklistTop( -delta ); -- ZEDMOD: OriginalBB
end

----------------------
-- Song Description --
----------------------
-- action for toggling description on and off
function SongbookWindow:ToggleDescription()
	if ( Settings.DescriptionVisible == "yes" ) then
		Settings.DescriptionVisible = "no";
	else
		Settings.DescriptionVisible = "yes";
	end
	self:LoadSongs();
end

-- action for toggling description on and off
function SongbookWindow:ToggleDescriptionFirst()
	if ( Settings.DescriptionFirst == "yes" ) then
		Settings.DescriptionFirst = "no";
	else
		Settings.DescriptionFirst = "yes";
	end
	if ( Settings.DescriptionVisible == "yes" ) then
		self:LoadSongs();
	end
end

-- action for toggling last dir on and off
function SongbookWindow:ToggleLastDirOnLoad()
	if ( Settings.LastDirOnLoad == "yes" ) then
		Settings.LastDirOnLoad = "no";
	else
		Settings.LastDirOnLoad = "yes";
	end
end

------------
-- Tracks --
------------
-- action for toggling tracks display on and off
function SongbookWindow:ToggleTracks()
	-- Get Window height and Container height
	local windowHeight = self:GetHeight();
	local containerHeight = self.listContainer:GetHeight();
	local unallowedHeight = windowHeight - containerHeight;
	
	-- If track list is visible
	if ( Settings.TracksVisible == "yes" ) then
		Settings.TracksVisible = "no";
		
		-- Get listboxes height
		local height = self.dirlistBox:GetHeight() + self.songlistBox:GetHeight() + 2 * UI.sep.sMain;
		if ( CharSettings.InstrSlots["visible"] == "yes") then
			height = height + self.instrlistBox:GetHeight() + UI.sep.sMain;
		end
		
		-- If container height got enough space
		
		if ( height < containerHeight ) then
			-- if songlist height got enough space
			if ( self.bInstrumentsVisibleHForced == false ) then
				if ( self.songlistBox:GetHeight() - self.tracklistBox:GetHeight() - 2 * UI.sep.sMain > 40 ) then
					-- Set songlist height
					local songheight = self.songlistBox:GetHeight() + self.tracklistBox:GetHeight() + 2 * UI.sep.sMain;
					self.songlistBox:SetHeight( songheight );
					
					-- ZEDMOD: Set Players list Height
					self.listboxPlayers:SetHeight( songheight - UI.hPlayerBtn )
					
				-- if songlist height got not enough space
				else
					-- Update window height and container height with more space
					self:UpdateContainer( height );
					self:UpdateMainWindow( unallowedHeight );
					self:SetContainer();
				end
			else
				if ( self.songlistBox:GetHeight() - self.tracklistBox:GetHeight() - 2 * UI.sep.sMain > 40 ) then
					-- Set songlist height
					local songheight = self.songlistBox:GetHeight() + self.tracklistBox:GetHeight() + 2 * UI.sep.sMain;
					self.songlistBox:SetHeight( songheight );
					
					-- ZEDMOD: Set Players list Height
					self.listboxPlayers:SetHeight( songheight - UI.hPlayerBtn )
					
				-- if songlist height got not enough space
				else
					-- Update window height and container height with more space
					self:UpdateContainer( height );
					self:UpdateMainWindow( unallowedHeight );
					self:SetContainer();
				end
			end
		end
		
		-- Set Song List Height
		--self:SetSonglistHeight(self.listContainer:GetHeight() - self.dirlistBox:GetHeight() - 13); -- ZEDMOD: OriginalBB
		
		-- Hide Tracklist
		self:ShowTrackListbox( false );
		
		-- Hide Setups
		self.listboxSetups:SetVisible( false );
		
		-- Set Message Position
		--self.tracksMsg:SetPosition( self.dirlistBox:GetLeft() + self.dirlistBox:GetWidth() - 150, self.dirlistBox:GetTop() + self.dirlistBox:GetHeight() ); -- ZEDMOD: OriginalBB
		
	-- If track list is not visible
	else
		-- Show Tracklist
		Settings.TracksVisible = "yes";
		self:ShowTrackListbox( true );
		
		-- Show Setups
		self.listboxSetups:SetVisible( self.bShowSetups ); -- ZEDMOD: OriginalBB
		
		-- ZEDMOD: Get Song List Height
		local height = self.dirlistBox:GetHeight() + self.songlistBox:GetHeight() + self.tracklistBox:GetHeight() + 3 * UI.sep.sMain;
		if ( CharSettings.InstrSlots["visible"] == "yes" ) then
			height = height + self.instrlistBox:GetHeight() + UI.sep.sMain;
		end
	end
	
	-- ZEDMOD: Resize All Elements
	self:ResizeAll();
end

-- ZEDMOD
-----------------
-- Instruments --
-----------------
-- Action for toggling instruments display on and off
function SongbookWindow:ToggleInstruments( bChecked )
	self.bInstrumentsVisible = bChecked;
	
	-- Get Window height and Container height
	local windowHeight = self:GetHeight();
	local containerHeight = self.listContainer:GetHeight();
	local unallowedHeight = windowHeight - containerHeight;
	
	-- If instrument list is visible
	if ( self.bInstrumentsVisible == false ) then
		CharSettings.InstrSlots["visible"] = "no";
		
		-- Get listboxes height
		local height = self.dirlistBox:GetHeight() + self.songlistBox:GetHeight() + 2 * UI.sep.sMain;
		if ( Settings.TracksVisible == "yes") then
			height = height + self.tracklistBox:GetHeight() + UI.sep.sMain;
		end
		
		-- If container height got enough space
		if ( height < containerHeight ) then
		
		-- if songlist height got enough space
			if ( self.bInstrumentsVisibleHForced == false ) then
				if ( self.songlistBox:GetHeight() - self.instrlistBox:GetHeight() - 2 * UI.sep.sMain > 40 ) then
					-- Set songlist height
					local songheight = self.songlistBox:GetHeight() + self.instrlistBox:GetHeight() + 2 * UI.sep.sMain;
					self.songlistBox:SetHeight( songheight );
					
					-- ZEDMOD: Set Players list Height
					self.listboxPlayers:SetHeight( songheight - UI.hPlayerBtn );
					
				-- if songlist height got not enough space
				else
					-- Update window height and container height with more space
					self:UpdateContainer( height );
					self:UpdateMainWindow( unallowedHeight );
					self:SetContainer();
				end
			else
				if ( self.songlistBox:GetHeight() - self.instrlistBox:GetHeight() - 2* UI.sep.sMain > 45 ) then
					-- Set songlist height
					local songheight = self.songlistBox:GetHeight() + self.instrlistBox:GetHeight() + 2 * UI.sep.sMain;
					self.songlistBox:SetHeight( songheight );
					
					-- ZEDMOD: Set Players list Height
					self.listboxPlayers:SetHeight( songheight - UI.hPlayerBtn )
					
				-- if songlist height got not enough space
				else
					-- Update window height and container height with more space
					self:UpdateContainer( height );
					self:UpdateMainWindow( unallowedHeight );
					self:SetContainer();
				end
			end
		end
		
		-- Hide Instrlist
		self:ShowInstrListbox( false );
		
	-- If instrument list is not visible
	else
	-- Show Instrlist
		CharSettings.InstrSlots["visible"] = "yes";
		self:ShowInstrListbox( true );
		
		-- ZEDMOD: Get Song List Height
		local height = self.dirlistBox:GetHeight() + self.songlistBox:GetHeight() + self.instrlistBox:GetHeight() + 3 * UI.sep.sMain;
		if ( Settings.TracksVisible == "yes") then
			height = height + self.tracklistBox:GetHeight() + UI.sep.sMain;
		end
		
		-- if containerlist got not enough space
		if ( height > containerHeight ) then
			
			-- if songlist got not enough space
			if ( self.songlistBox:GetHeight() == 40 ) then
				-- Update Window height and Container height with more space
				self:UpdateContainer( height );
				self:UpdateMainWindow( unallowedHeight );
				self:SetContainer();
			end
		end
	end
	-- ZEDMOD: Resize All Elements
	self:ResizeAll();
end

-----------------------
-- Instruments Slots --
-----------------------

function SongbookWindow:ClearSlots()
	for i = 1, CharSettings.InstrSlots["number"] do
		CharSettings.InstrSlots[tostring( i )].qsType ="";
		CharSettings.InstrSlots[tostring( i )].qsData = "";
		local sc = Turbine.UI.Lotro.Shortcut( "", "" );
		self.instrSlot[i]:SetShortcut( sc );
	end
end

function SongbookWindow:AddSlot()
	--if ( self:GetWidth() > 10 + ( CharSettings.InstrSlots["number"] + 1 ) * 40 ) then -- ZEDMOD: OriginalBB
	local newslot = tonumber( CharSettings.InstrSlots["number"] ) + 1;
	CharSettings.InstrSlots["number"] = newslot;
	self.instrSlot[newslot] = Turbine.UI.Lotro.Quickslot();
	self.instrSlot[newslot]:SetParent( self.instrContainer );
	--self.instrSlot[newslot]:SetPosition( 40 * ( newslot - 1 ), 0 ); -- ZEDMOD: OriginalBB
	self.instrSlot[newslot]:SetSize( 35, 40 ); -- ZEDMOD: OriginalBB value: ( 37, 37 )
	self.instrSlot[newslot]:SetZOrder( 100 );
	self.instrSlot[newslot]:SetAllowDrop( true );
	--self.instrContainer:SetWidth( self.instrContainer:GetWidth() + 40 ); -- ZEDMOD: OriginalBB
	self.instrlistBox:AddItem( self.instrSlot[newslot] ); -- ZEDMOD
	local sc = Turbine.UI.Lotro.Shortcut( "", "" );
	self.instrSlot[newslot]:SetShortcut( sc );
	CharSettings.InstrSlots[tostring(newslot)] = { qsType = "", qsData = "" };
	SetupInstrShortcutChanged( self, newslot )
	SetupInstrDragLeave( self, newslot )
	self.instrSlot[newslot].MouseDown = function( sender, args )
		if ( args.Button == Turbine.UI.MouseButton.Left ) then
			instrdrag = true;
		end
	end
	--end -- ZEDMOD: OriginalBB
end

function SongbookWindow:DelSlot()
	CharSettings.InstrSlots["number"] = tonumber( CharSettings.InstrSlots["number"] );
	if ( CharSettings.InstrSlots["number"] > 1 ) then
		local delslot = CharSettings.InstrSlots["number"];
		if delSlot == nil then return; end
		CharSettings.InstrSlots["number"] = CharSettings.InstrSlots["number"] - 1;
		--self.instrContainer:SetWidth( self.instrContainer:GetWidth() - 40 ); -- ZEDMOD: OriginalBB
		self.instrlistBox:RemoveItemAt( delslot ); -- ZEDMOD
		self.instrSlot[delslot] = nil;
		CharSettings.InstrSlots[tostring( delslot )] = nil;
	end
end

--------------------
-- Expand Command --
--------------------
function SongbookWindow:ExpandCmd( cmdId )
	local selTrack = self:SelectedTrackIndex();
	if ( librarySize ~= 0 ) then
		local cmd = Settings.Commands[cmdId].Command;
		if ( SongDB.Songs[selectedSongIndex].Tracks[selTrack] ) then
			cmd = string.gsub( cmd, "%%name", SongDB.Songs[selectedSongIndex].Tracks[selTrack].Name );
			cmd = string.gsub( cmd, "%%file", SongDB.Songs[selectedSongIndex].Filename );
			if ( selTrack ~= 1 ) then
				cmd = string.gsub( cmd, "%%part", selTrack );
			else
				cmd = string.gsub( cmd, "%%part", "" );
			end
		elseif ( SongDB.Songs[selectedSongIndex].Filename ) then
			cmd = string.gsub( cmd, "%%name", SongDB.Songs[selectedSongIndex].Filename );
			cmd = string.gsub( cmd, "%%file", SongDB.Songs[selectedSongIndex].Filename );
			if ( selTrack ~= 1 ) then
				cmd = string.gsub( cmd, "%%part", selTrack );
			else
				cmd = string.gsub( cmd, "%%part", "" );
			end
		else
			cmd = "";
		end
		return cmd;
	end
end

-------------------
-- Save Settings --
-------------------
function SongbookWindow:SaveSettings()
	Settings.WindowPosition.Left = tostring( self:GetLeft() );
	Settings.WindowPosition.Top = tostring( self:GetTop() );
	Settings.WindowPosition.Width = tostring( self:GetWidth() );
	Settings.WindowPosition.Height = tostring( self:GetHeight() );
	Settings.ToggleTop = tostring( Settings.ToggleTop );
	Settings.ToggleLeft = tostring( Settings.ToggleLeft );
	--Settings.DirHeight = tostring( Settings.DirHeight ); -- ZEDMOD: OriginalBB
	Settings.DirHeight = tostring( self.dirlistBox:GetHeight() ); -- ZEDMOD
	Settings.DirWidth = tostring( self.dirlistBox:GetWidth() )
	Settings.FiltersWidth = tostring( self.lbFilters:GetWidth( ) )
	--Settings.SongsHeight = tostring( Settings.SongsHeight ); -- ZEDMOD
	Settings.SongsHeight = tostring( self.songlistBox:GetHeight() ); -- ZEDMOD
	--Settings.TracksHeight = tostring( Settings.TracksHeight ); -- ZEDMOD: OriginalBB
	Settings.TracksHeight = tostring( self.tracklistBox:GetHeight() ); -- ZEDMOD
	--Settings.InstrsHeight = tostring( Settings.InstrsHeight ); -- ZEDMOD
	Settings.InstrsHeight = tostring( self.instrlistBox:GetHeight() ); -- ZEDMOD
	Settings.WindowOpacity = tostring( Settings.WindowOpacity );
	Settings.ToggleOpacity = tostring( Settings.ToggleOpacity );
	Settings.FiltersState = tostring( self.bFilter );
	Settings.ChiefMode = tostring( self.bChiefMode );
	Settings.SoloMode = tostring( self.bSoloMode );
	Settings.ShowAllBtns = tostring( self.bShowAllBtns );
	Settings.TimerState = tostring( self.bDisplayTimer );
	Settings.TimerCountdown = tostring( self.bTimerCountdown );
	Settings.ReadyColState = tostring( self.bShowReadyChars );
	Settings.ReadyColHighlight = tostring( self.bHighlightReadyCol );
	Settings.PartyState = tostring( self.bParty ); -- ZEDMOD
	for i = 1, CharSettings.InstrSlots["number"] do
		if CharSettings.InstrSlots[i] then
			CharSettings.InstrSlots[i].qsType = tostring( CharSettings.InstrSlots[i].qsType );
			CharSettings.InstrMap[ i ].type = tostring( CharSettings.InstrMap[ i ].type ); end
	end
	CharSettings.InstrSlots["number"] = tostring( CharSettings.InstrSlots["number"] );
	CharSettings.InstrSlots["visHForced"] = tostring( self.bInstrumentsVisibleHForced ); -- ZEDMOD
	CharSettings.dirPath = {} -- table holding directory path
	for i = 1, #dirPath do
		CharSettings.dirPath[i] = dirPath[i];
	end
	ModifySettings( Settings, tostring )

	SongbookSave( Turbine.DataScope.Account, gSettings, Settings,
		function( result, message )
			if ( result ) then
				Turbine.Shell.WriteLine( SuccessRGB.." Account : " .. Strings["sh_saved"] .. "</rgb>" );
			else
				Turbine.Shell.WriteLine( FailRGB.." Account : " .. Strings["sh_notsaved"] .. " " .. message .. "</rgb>" );
			end
		end );
	SongbookSave( Turbine.DataScope.Character, gSettings, CharSettings,
		function( result, message )
			if ( result ) then
				Turbine.Shell.WriteLine( SuccessRGB.." Character : " .. Strings["sh_saved"] .. "</rgb>" );
			else
				Turbine.Shell.WriteLine( FailRGB.." Character : " .. Strings["sh_notsaved"] .. " " .. message .. "</rgb>" );
			end
		end );
	
	SkillsData:CopyToSD( )
	PriosData:CopyToSD( )
	ServerData:Save( )
end

-------------
-- Filters --
-------------

Patterns =
{
	["instrList"] = ",?(%a[%a%s]+),?",
	["songLength"] = "%((%d+):(%d+)%)",
	["iterKwVal"] = ":([%w%-,:]+)",
	["kwVal"] = ":[%w%-,:]+",
	["iterQuotedKwVal"] = ":[%\"%'](.-)[%\"%']",
	["quotedKwVal"] = ":[%\"%'].-[%\"%']",
	["searchKwSplit"] = "(%a):(.+)",
}

-- Parse filter string entered by the user.
function SongbookWindow:ParsePartsFilter( sText )
	local sPattern = "";
	local iEnd = 0;
	local number, numberTo, iEndTo, temp;
	for maxTracks = 1, self.maxTrackCount do
		iEnd = iEnd + 1;
		temp, iEnd, number = string.find( sText, "%s*(%d+)%s*", iEnd );
		if ( iEnd == nil ) then
			break;
		end
		iEnd = iEnd + 1;
		if ( string.sub( sText, iEnd, iEnd ) == "-" ) then
			temp, iEndTo, numberTo = string.find( sText, "%s*(%d+)%s*", iEnd + 1 );
			if ( iEndTo == nil ) then
				numberTo = self.maxTrackCount;
			else
				iEnd = iEndTo + 1;
			end
		else
			numberTo = number;
		end
		for i = number, numberTo do
			sPattern = sPattern .. string.char( 0x40 + i ); -- 0x40 is ASCII-code 'A' - 1
		end
	end
	if sPattern == "" then return "a-z"; end
	return sPattern
end -- ParsePartsFilter

-- return true if at least one word is in both string lists 
function SongbookWindow:MatchStringList( list1, list2 )
	for word1 in string.gmatch( list1, "%a+" ) do
		for word2 in string.gmatch( list2, "%a+" ) do
			if word1 == word2 then
				return true;
			end
		end
	end
	return false;
end

-- Check whether the given song fits all the filters that are currently set 
function SongbookWindow:ApplyFilters( song, filters )
	if ( song == nil ) then return false; end
	local sParts = nil

	if self:MatchFail( 'c', song.Artist ) then return false; end
	if self:MatchFail( 'a', song.Transcriber ) then return false; end
	if self:MatchFail( 'g', song.Genre ) then return false; end
	if self:MatchFail( 'm', song.Mood ) then return false; end

	if filters.sPartsPattern then
		if not song.Partcounts then return false; end
		self.sFilterPartcount = '[' .. filters.sPartsPattern .. ']'
		if string.match( song.Partcounts, self.sFilterPartcount ) == nil then
			return false; end -- Song does not have a setup with an acceptable number of players
		if self.aFilters['i'].cb and self.aFilters['i'].cb:IsChecked( ) then
			local sInstr = self.aFilters['i'].edit:GetText( ):lower( )
			if sInstr and #sInstr > 0 and not self:FindInstrInSetups( sInstr, filters.sPartsPattern, song ) then
				return false; end
		end
	else
		if self.aFilters['i'].cb and self.aFilters['i'].cb:IsChecked( ) then
			local sInstr = self.aFilters['i'].edit:GetText( ):lower( )
			if sInstr and #sInstr > 0 and not self:FindInstrInTracks( sInstr, song ) then
				return false; end
		end
	end

	if filters.minLength and song.Tracks[1] then
		local songMins, songSecs = song.Tracks[1].Name:match( Patterns["songLength"] )
		if not songMins or not songSecs then return false; end
		local songDur = songMins * 60 + songSecs
		if songDur < filters.minLength or songDur > filters.maxLength then return false; end
	end

	if filters.sPartsPattern and #filters.sPartsPattern > 0 then
		self.selectedSetupCount = filters.sPartsPattern:byte(1) - 0x40; end
	return true;
end -- ApplyFilters

function SongbookWindow:MatchFail( ch, sData )
	if not self.aFilters[ch].cb or not self.aFilters[ch].cb:IsChecked() then return false; end
	local sFilter = string.lower( self.aFilters[ch].edit:GetText() );
	if not sFilter or not sFilter:find( "[%w%p]") then return false; end
	if not sData or not sData:find( "[%w%p]") then return true; end
	if not self:MatchStringList( sFilter, string.lower( sData ) ) then return true; end
	return false
end

function SongbookWindow:FiltersActive( )
	for i = 1, self.aSearchKw:len() do
		local ch = self.aSearchKw:sub( i, i )
		if self.aFilters[ch].cb:IsChecked( ) then return true; end
	end
	return false;
end

function SongbookWindow:ClearFilters( )
	self:SetFilterCbs( false )
end

function SongbookWindow:FindInstrInSetups( sInstrs, sSetupCodes, song )
	local iSetup = 1
	for iCh = 1, #sSetupCodes do
		local setupCount = sSetupCodes:byte( iCh ) - 64
		while iSetup <= #song.Setups and song.Setups[ iSetup ] and #song.Setups[ iSetup ] < setupCount do
			iSetup = iSetup + 1; end
		if iSetup > #song.Setups then return false; end 
		if self:FindInstrInLineup( sInstrs, song, iSetup ) then return true; end
	end
	return false
end

function SongbookWindow:FindInstrInLineup( sInstrs, song, iSetup )
	local bMatch
	for sInstr in sInstrs:gmatch( Patterns["instrList"] ) do
		bMatch = false
		for i = 1, #song.Setups[ iSetup ] do
			local iTrack = song.Setups[ iSetup ]:byte( i ) - 64
			if iTrack and self:FindInstrInTrack( sInstr, song.Tracks[ iTrack ] ) then bMatch = true; break; end
		end
		if not bMatch then return false; end
	end
	return true
end

function SongbookWindow:FindInstrInTracks( sInstrs, song )
	for sInstr in sInstrs:gmatch( Patterns["instrList"] ) do
		bMatch = false
		for i, track in pairs( song.Tracks ) do
			if self:FindInstrInTrack( sInstr, track ) then bMatch = true; break; end
		end
		if not bMatch then return false; end
	end
	return true
end

function SongbookWindow:FindInstrInTrack( sInstr, track )
	local sCleanTrack = CleanString( track.Name:lower( ) ).." "
	local _, iEnd = sCleanTrack:find( "%(%d+:%d+%)[%s%A%*]*" )
	return ContainsInstrument( sCleanTrack, sInstr, iEnd, false )
end

---------------
-- Song List --
---------------

-- Song List : Initialize Song - List tracks, set/clear chat handler, set headings
function SongbookWindow:InitSonglist( )
	local nSongs = self.songlistBox:GetItemCount();
	if nSongs <= 0 then
		self:ClearTrackList( );
		self:ClearSongState( );
		self.sepSongsTracks.heading:SetText( Strings["ui_parts"] .. "0" );
	end
	self.sepDirsSongs.hdgSongs:SetText( Strings["ui_songs"] .. tostring(nSongs) );
end

-- Song List : Clear Song State
function SongbookWindow:ClearSongState()
	self.aReadyTracks = "";
	self:ClearPlayerStates();
	self:ClearSetups();
	self:SetTrackColours( selectedTrack );
	self:SetPlayerColours();
end

----------------
-- Track Name --
----------------
-- Create compact track name by removing the title.
-- Note: Many of our older songs have quite different naming schemes; not sure if it's even worth parsing.
function SongbookWindow:TerseTrackname( sTrack )
	return sTrack; -- disabled for now.
end

----------
-- Song --
----------
function SongbookWindow:SongStarted()
	self:ClearSongState();
	if ( self.bInstrumentOk == false ) then
		--self.tracksMsg:SetForeColor( UI.colour.default ); -- ZEDMOD: OriginalBB
		self.lblInstrAlert:SetForeColor( UI.colour.default ); -- ZEDMOD
		--self.trackMsg:SetVisible( false ); -- ZEDMOD: OriginalBB
		self.lblInstrAlert:SetVisible( false ); -- ZEDMOD
		self.bInstrumentOk = true;
	end
	if ( self.bDisplayTimer ) then
		self:StartCounter();
	--else
		--self:StopTimer(); -- in case it is still counting ...
	end
end

function SongbookWindow:SelectAnnCapture( )
GDebug = true
	if not mainWnd.anCpt.sSong then return; end
	if mainWnd.anCpt.timeStamp > Turbine.Engine.GetLocalTime() + 300 then
		mainWnd.anCpt.sSong = nil; return; end

	if mainWnd:FiltersActive( ) or mainWnd.searchInput:GetText( ):len() > 0 then -- Hack: need to make sure song can be displayed
		mainWnd:ClearFilters( ); mainWnd.searchInput:SetText( "" ); mainWnd:LoadSongs(); end
	if mainWnd.anCpt.setupCount then mainWnd.selectedSetupCount = mainWnd.anCpt.setupCount; end
	mainWnd:SelectSongByName( mainWnd.anCpt.sSong, mainWnd.anCpt.sTrack )
GDebug = false
end

------------------
-- Chat Handler --
------------------
-- Handler for chat messages to indicate players readying tracks
function ChatHandler( sender, args )
	local sMessage = args.Message;
	if not sMessage or sMessage:len() <= 0 then return; end
	
	if ( args.ChatType == Turbine.ChatType.Tell ) then
		if sMessage:match( "^SB~Sk0~" ) and skillsWindow then skillsWindow:ReceiveData( sMessage ); end
		return
	end
	
	if args.ChatType ~= Turbine.ChatType.Standard then
		-- Announcement (in /f or /ra)
		-- local sAnnouncer = sMessage:match( ".-%>(%a+)%<" )
		--local sSong = sMessage:match( Strings["asn_nextSong"]..":\n(.-)\n" )
		local sCount, sSong = sMessage:match( Strings["asn_nextSong"].."(.*):\n(.-)\n" )
		if sSong and not sMessage:find( "%[To " ) then -- only when not announcing yourself
			local prevCount = mainWnd.anCpt.setupCount
			mainWnd.anCpt = { }

			if sCount and sCount ~= "" then -- get setup count
				local sSub, sFull = sCount:match( ".*%((%d+)/(%d+)%)" )
				if sFull and sFull ~= "" then sCount = sFull
				else sCount = sCount:match( ".*%((%d+)%)" ); end
			end
			if sCount and sCount ~= "" then mainWnd.anCpt.setupCount = tonumber( sCount )
				;
			else
				mainWnd.anCpt.setupCount = select( 2, sMessage:gsub( "\n%* ", "") )
				mainWnd.anCpt.setupCountPrev = prevCount; end -- no count given, need to check later for indiv. announce

			mainWnd.anCpt.timeStamp = Turbine.Engine.GetLocalTime()
			mainWnd.anCpt.sSong = sSong
			if mainWnd.sPlayerName then
				mainWnd.anCpt.sTrack = sMessage:match( "\n* "..mainWnd.sPlayerName..": (.-)\n" )
			end
			if mainWnd.cbTrackAnc:IsChecked( ) then mainWnd:SelectAnnCapture( ); end
		end
--mainWnd:LbTracksStats( )
		return -- Player ready messages appear in the standard chat
	end
	
	-- Play Begin or Play Begin Self
	if string.find( sMessage, Strings["chat_playBegin"] ) or string.find( sMessage, Strings["chat_playBeginSelf"] ) then
		mainWnd:SongStarted();
		return;
	end
	
	-- Player Join
	if ( string.find( sMessage, Strings["chat_playerJoin"] ) ~= nil ) then
		mainWnd:PlayerJoined( sMessage );
		return;
	end
	
	-- Player Leave
	if ( string.find( sMessage, Strings["chat_playerLeave"] ) ~= nil ) then
		mainWnd:PlayerLeft( sMessage );
		return;
	end
	
	-- ZEDMOD: Added Player Join Self and Player Leave Self
	-- Player Join Self
	if ( string.find( sMessage, Strings["chat_playerJoinSelf"] ) ~= nil ) then
		mainWnd:PlayerJoinedSelf( sMessage );
		return;
	end
	
	-- Player Leave Self
	if ( string.find( sMessage, Strings["chat_playerLeaveSelf"] ) ~= nil ) then
		mainWnd:PlayerLeftSelf( sMessage );
		return;
	end
	
	-- (Nim) added player dismissed case
	if ( string.find( sMessage, Strings["chat_playerDismissSelf"] ) ~= nil ) then
		mainWnd:PlayerDismissedSelf( sMessage )
		return;
	end
	if ( string.find( sMessage, Strings["chat_playerDismiss"] ) ~= nil ) then
		mainWnd:PlayerDismissed( sMessage )
		return;
	end
	
	if ( string.find( sMessage, Strings["chat_playerLinkDead"] ) ~= nil ) then
		mainWnd:PlayerLinkDead( sMessage )
		return;
	end
	
	local temp, sPlayerName, sTrackName;
	temp, temp, sPlayerName, sTrackName = string.find( sMessage, Strings["chat_playReadyMsg"] );
	if ( ( not sPlayerName ) or ( not sTrackName ) ) then
		
		-- Get Local Player Instance
		--sPlayerName = songbookWindow.sPlayerName -- ZEDMOD: OriginalBB
		if ( mainWnd ~= nil ) then
			sPlayerName = mainWnd.sPlayerName -- ZEDMOD: OriginalBB
		end
		temp, temp, sTrackName = string.find( sMessage, Strings["chat_playSelfReadyMsg"] ); -- ZEDMOD: OriginalBB
	end
	
	if sPlayerName and sTrackName and mainWnd.aPlayers then
		if mainWnd.sPlayerName and sPlayerName == mainWnd.sPlayerName then
			--songbookWindow:StopTimer(); -- in case it is still counting ...
			sPlayerName = mainWnd.sPlayerName;
			if mainWnd.bCheckInstrument and sTrackName then
				CheckInstrument( sTrackName );
			end
		end
		if ( not mainWnd.aPlayers[sPlayerName] ) then -- Player not yet registered 
			mainWnd.nPlayers = mainWnd.nPlayers + 1;
			mainWnd:AddPlayerToList( sPlayerName ); -- add to player listbox
			mainWnd:UpdateMaxPartCount();
		end
		mainWnd.aPlayers[sPlayerName] = sTrackName; -- and to player array with the track name
		mainWnd:SetTrackColours( selectedTrack );
		mainWnd:SetPlayerColours();
		mainWnd:UpdateSetupColours();
	end
end


function SongbookWindow:CreateSearchUI( )
	self.searchInput = Turbine.UI.Lotro.TextBox();
	self.searchInput:SetParent( self );
	self.searchInput:SetPosition( UI.indLeft, UI.search.yPos ); -- ZEDMOD: OriginalBB value: ( 17, 110 )
	self.searchInput:SetSize( UI.search.wiInput, UI.hTextBox ); -- ZEDMOD: OriginalBB value: ( 150, 20 ), nim: reduced further from 145 to make room for timer
	self.searchInput:SetFont( Turbine.UI.Lotro.Font.Verdana14 );
	self.searchInput:SetMultiline( false );
	self.searchInput:SetVisible( false );
	self.searchInput.bHasFocus = false;
	self.searchInput.KeyDown = function( sender, args )
		--if args.Action == 75 then sender:SetAssocBtnStates( sender:GetText( ):len() > 0 ); end
		if args.Action == 162 and sender.bHasFocus then self:SearchSongs(); end; end
	self.searchInput.FocusGained = function( sender, args ) sender.bHasFocus = true; end
	self.searchInput.FocusLost = function( sender, args ) sender.bHasFocus = false; end
	self.searchInput.SetAssocBtnStates = function( sender, bState )
		mainWnd.clearBtn:SetEnabled( bState )
		mainWnd.btnSearchMode:SetEnabled( bState )
		mainWnd.searchBtn:SetEnabled( bState ); end
	
	-- search button
	self.searchBtn = Turbine.UI.Lotro.Button();
	self.searchBtn:SetParent( self );
	local xPos = UI.search.wiInput + 15
	self.searchBtn:SetPosition( xPos, UI.search.yPos ); -- ZEDMOD: OriginalBB value: ( 172, 110 )
	self.searchBtn:SetSize( UI.search.wiSearchBtn, UI.hStdBtn )
	xPos = xPos + UI.search.wiSearchBtn
	self.searchBtn:SetText( Strings["ui_search"] );
	self.searchBtn:SetVisible( false );
	--self.searchBtn:SetEnabled( false );
	self.searchBtn.MouseClick = function( sender, args ) self:SearchSongs( ); end
	
	-- search mode
	self.searchMode =self:CreateIconBtnLbl( self, xPos-6, UI.search.yPos, UI.search.wiMode, 20, "btnDrop.jpg", "btnDrop_a.jpg", 6, 3 )
	self.searchMode:SetZOrder( 1 )
	xPos = xPos + 30
	self.searchMode:SetVisible( false );
	self.searchMode.aStates = "CSA"
	self.searchMode.cbActive = true
	self.searchMode.bCbUpdate = true
	self.searchMode.aLabels = { ["C"] = "Current folder", ["S"] = "Current + subfolders", ["A"] = "All folders" }
	self.searchMode.State = function( s, i ) return s.aStates:sub( i, i ); end
	self.searchMode.CurState = function( s ) return s:State( s.curState ); end
	self.searchMode.SearchCurrent = function( s ) return s.curState == 1; end
	self.searchMode.SearchSubfolders = function( s ) return s.curState == 2; end
	self.searchMode.SearchAll = function( s ) return s.curState == 3; end
	self.searchMode.SetStateText = function( s ) s:SetText( ""..s:State( s.curState ) ); end
	self.searchMode.SetState = function( s, state ) s.curState = state; s:ApplyState( ); end
	self.searchMode.ApplyState = function( s )
		s.bCbUpdate = false
		for i = 1, #s.aCbs do
			s.aCbs[ i ]:SetChecked( i == s.curState )
			s.aCbs[ i ]:SetEnabled( i ~= s.curState ); end
		s.bCbUpdate = true; s:SetStateText( ); end
	self.searchMode.Label = function( s, state ) return s.aLabels[ state ]; end
	self.searchMode.LbCreate = function( s )
		if s.lbChecks then return; end
		s.lbChecks = Turbine.UI.ListBox( )
		s.lbChecks:SetParent( s:GetParent( ) );
		s.lbChecks:SetSize( UI.search.wiModeLb, 60 )
		s.lbChecks:SetZOrder( 380 )
		s.lbChecks:SetBackColor( g_cfgUI.colorLbItemSelected )
		local yPos = s:GetTop( ) + s:GetHeight( )
		s.lbChecks:SetPosition( s:GetLeft( ) + UI.search.wiMode - UI.search.wiModeLb, yPos )
		s.lbChecks:SetVisible( false );
		s.aCbs = {}
		for i = 1, s.aStates:len() do
			local cb = Turbine.UI.Lotro.CheckBox();
			cb:SetSize( UI.search.wiModeLb, UI.hStdCb );
			cb:SetMultiline( false );
			cb:SetFont( UI.lb.font )
			cb:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleRight );
			cb:SetCheckAlignment( Turbine.UI.ContentAlignment.MiddleRight );
			cb:SetText( s:Label( s:State( i ) ) )
			cb.i = i
			cb.CheckedChanged = function( cb, _ ) if s.bCbUpdate then s:SetState( cb.i ); s:LbToggle( ); end; end
			--cb:SetBackColor( g_cfgUI.colorDefaultBack )
			cb:SetVisible( true );
			s.aCbs[ #s.aCbs + 1 ] =  cb
			s.lbChecks:AddItem( cb )
		end
	end
	self.searchMode.LbToggle = function( s )
		s.lbChecks:SetVisible( not s.lbChecks:IsVisible( ) ); end
	self.searchMode.SetPosition = function( s, x, y )
		if s.lbChecks then s.lbChecks:SetLeft( x + UI.search.wiMode - UI.search.wiModeLb ); end
		Turbine.UI.Control.SetPosition( s, x, y ); end
	self.searchMode.MouseClick = function( s, _ ) s:LbToggle( ); end
	self.searchMode.MouseWheel = function( s, a )
		s:SetState( ( s.curState - a.Direction - 1 ) % s.aStates:len( ) + 1 ); end
	self.searchMode:LbCreate( )
	self.searchMode:SetState( 2 )
	
	-- clear search button
	self.clearBtn = Turbine.UI.Lotro.Button();
	self.clearBtn:SetParent( self );
	self.clearBtn:SetPosition( xPos, 110 )
	self.clearBtn:SetSize( UI.search.wiClearBtn, UI.hStdBtn );
	self.clearBtn:SetText( Strings["ui_clear"] );
	self.clearBtn:SetVisible( false );
	--self.clearBtn:SetEnabled( false );
	self.clearBtn.MouseClick = function( sender, args )
		self.searchInput:SetText( "" )
		self:SetFilterCbs( false )
		self:LoadSongs();
		--self.songlistBox:SetSelectedIndex( 1 )
		--self:SelectSong( 1 )
	end
end

--------------
-- Party UI --
--------------
-- ZEDMOD: Create the Party UI elements: Edit boxes for player count
function SongbookWindow:CreatePartyUI( args )
	self:CreatePartyListbox();
end

---------------
-- Setups UI --
---------------
function SongbookWindow:CreateSetupsUI( args )
	self:CreateSetupsListbox();
end

---------------
-- Filter UI --
---------------
-- Create the filter UI elements: Edit boxes for player count, transcriber, mood, genre
function SongbookWindow:CreateFilterUI( )
	self.aSearchKw = "pcgmail"
	self:CreateSearchCtrls( )
	self.bFilterCbActive = true
	self:SearchShowFilters( )

	self.fModeToggle = function( cbThis, cbOther )
		if cbThis:IsChecked( ) then
			cbOther:SetChecked( false ); cbOther:SetEnabled( true ); cbThis:SetEnabled( false );end; end
	self.cbModeTags = Turbine.UI.Lotro.CheckBox( )
	self.cbModeTags:SetParent( self )
	self.cbModeTags:SetSize( UI.search.wiChecks, 16 );
	self.cbModeTags:SetPosition( UI.indLeft , self.listContainer:GetTop( ) - 2 )
	self.cbModeTags:SetFont( UI.lb.font )
	self.cbModeTags:SetMultiline( false );
	self.cbModeTags:SetText( Strings["ui_tags"] )
	self.cbModeTags:SetChecked( false )
	self.cbModeTags:SetZOrder( 361 );
	self.cbModeTags.CheckedChanged = function(cb,_) mainWnd.fModeToggle( cb, mainWnd.cbModeFilters ); mainWnd:SearchShowTags( ); end

	self.cbModeFilters = Turbine.UI.Lotro.CheckBox( )
	self.cbModeFilters:SetParent( self )
	self.cbModeFilters:SetSize( UI.search.wiChecks, 16 );
	self.cbModeFilters:SetPosition( UI.indLeft+ UI.search.wiTags, self.listContainer:GetTop( ) - 2 )
	self.cbModeFilters:SetFont( UI.lb.font )
	self.cbModeFilters:SetMultiline( false );
	self.cbModeFilters:SetText( Strings["ui_filters"] )
	self.cbModeFilters:SetChecked( true )
	self.cbModeFilters:SetEnabled( false )
	self.cbModeFilters:SetZOrder( 361 );
	self.cbModeFilters.CheckedChanged = function(cb,_) mainWnd.fModeToggle( cb, mainWnd.cbModeTags ); mainWnd:SearchShowFilters( ); end

	self.bShowTags = false
	self.SetMode = function( s, b )
		s.bShowTags = b 
		if b then s.hdgFilter:SetText( Strings["ui_tags"] )
		else s.hdgFilter:SetText( Strings["ui_filters"] ); end; end
end


function SongbookWindow:CreateLbFilters( )
	local lb = ListBoxScrolled:New( 10, 10, false );
	lb:SetParent( self.listContainer );
	lb:SetVisible( false );
	lb:SetOrientation( Turbine.UI.Orientation.Horizontal );
	lb:SetMaxColumns( 2 )
	lb.arrows = self:CreateSeparatorArrowsLR( lb.separatorv )
	lb.arrows:SetVisible( true )
	lb.ResizeCol = function( self, iStart, w )
		for i = iStart,self:GetItemCount( ),2 do self:GetItem( i ):SetWidth( w ); end; end
	lb.SetWidth = function( self, w )
		local wCbs = UI.search.wiChecks
		local w1, w2; if w / 2 > wCbs then w1 = w - wCbs; w2 = w; else w1 = w/2; w2 = w/2; end
		self:SetColWidths( w, w1, w2 ); end
	lb.SetColWidths = function( self, w, w1, w2 )
		self:ResizeCol( 1, w1 ); self:ResizeCol( 2, w2 )
		ListBoxScrolled.SetWidth( self, w ); end
	lb.GetColWidths = function( self )
		if self:GetItemCount( ) <= 0 then return nil, nil; end
		return self:GetItem( 1 ):GetWidth( ), self:GetItem( 2 ):GetWidth( ); end
	lb.SetHeight = function( self, h )
		ListBoxScrolled.SetHeight( self, h )
		self.arrows:SetPosition( 1, self.separatorv:GetHeight( ) / 2 - 10 ); end
	lb.SetSize = function( self, w, h ) self:SetWidth( w ); self:SetHeight( h ); end
	lb.separatorv.MouseDown = function( sender, args ) --scrollBarv self.lbTags.separatorv
		sender.dragStartX = args.X
		sender.dragging = true; end
	lb.separatorv.MouseUp = function( sender, args )
		sender.dragging = false
		Settings.FiltersWidth = lb:GetWidth()
		Settings.DirWidth = self.dirlistBox:GetWidth(); end
	lb.separatorv.MouseMove = function( sender, args )
		if not sender.dragging then return; end
		local dx = args.X - sender.dragStartX;
		local w = lb:GetWidth( )
		local xLim = self.listContainer:GetWidth() - 60
		if w + dx < 120 then dx = 120 - w; end
		if w + dx > xLim then dx = xLim - w; end
		if dx == 0 then return; end
		lb:SetWidth( w + dx );
		--self.cbModeTags self.cbModeFilters
		--self.sepDirs.hdgFilter:SetWidth( w + dx )
		local xDir = self.dirlistBox:GetLeft( ) + dx
		local wDir = self.dirlistBox:GetWidth( ) - dx
		self.dirlistBox:SetLeft( xDir ) 
		self.dirlistBox:SetWidth( wDir ) 
		self.sepDirs.hdgDir:SetLeft( xDir )
		self.sepDirs.hdgDir:SetWidth( wDir )
	end

	local wFilters = Settings.FiltersWidth or 156
	lb:SetSize( wFilters, self.dirlistBox:GetHeight() );
	lb:SetPosition( 0, UI.sep.sMain );
	return lb
end

function SongbookWindow:SearchShowFilters( )
	self.lbFilters:ClearItems( )
	self.lbFilters:SetMaxColumns( 2 )
	for i = 1, self.aSearchKw:len() do
		local ch = self.aSearchKw:sub( i, i )
		local item = self.aFilters[ch].edit
		item:SetSize( self.lbFilters:GetWidth( ) - UI.search.wiChecks, UI.lb.hItem )
		item:SetFont( UI.lb.font )
		self.lbFilters:AddItem( item )
		item = self.aFilters[ch].cb
		item:SetFont( UI.lb.font )
		item:SetSize( UI.search.wiChecks, UI.lb.hItem )
		self.lbFilters:AddItem( item )
	end
end

function SongbookWindow:SearchShowTags( )
	self.lbFilters:ClearItems( )
	self.lbFilters:SetMaxColumns( 1 )
	for i = 1, self.aSearchKw:len() do
		local ch = self.aSearchKw:sub( i, i )
		local item = self.aEditTags[ ch ]
		item:SetSize( self.lbFilters:GetWidth( ), UI.lb.hItem )
		item:SetFont( UI.lb.font )
		self.lbFilters:AddItem( item )
	end
end

function SongbookWindow:CreateSearchCtrls( )
	self.aFilterNames = {
		['p'] = Strings["filterParts"], ['c'] = Strings["filterArtist"], ['g'] = Strings["filterGenre"], ['m'] = Strings["filterMood"],
		['a'] = Strings["filterAuthor"], ['i'] = Strings["filterInstr"], ['l'] = Strings["filterLength"], }
	self.aEditTags = { }
	self.aFilters = { }
	for i = 1, self.aSearchKw:len() do
		local ch = self.aSearchKw:sub( i, i )
		self.aEditTags[ ch ] = self:CreateFilterEditItem( )
		self.aFilters[ ch ] = {
			["edit"] = self:CreateFilterEditItem( ),
			["cb"] = self:CreateFilterCheckboxItem( self.aFilterNames[ ch ], ch ), }
	end

	self.lbFilters = self:CreateLbFilters( )
end

-- create a filter edit as item in listbox
function SongbookWindow:CreateFilterEditItem( )
	local edit = Turbine.UI.Lotro.TextBox();
	edit:SetSize( 86, 20 );
	edit:SetFont( Turbine.UI.Lotro.Font.Verdana14 );
	edit:SetMultiline( false );
	edit:SetVisible( true );
	edit.KeyDown = function( sender, keyargs ) if keyargs.Action == 162 then self:SearchSongs(); end; end
	edit.MouseDoubleClick = function( s, a ) s:SelectAll( ); end
 	return edit;
end

-- Create a filter checkbox as lbFilter item
function SongbookWindow:CreateFilterCheckboxItem( sLabel, chFilter )
	local cb = Turbine.UI.Lotro.CheckBox();
	--cb:SetParent( self.listContainer );
	cb:SetSize( UI.search.wiChecks, 20 );
	cb:SetMultiline( false );
	cb:SetFont( UI.lb.font )
	cb:SetText( sLabel );
	cb.CheckedChanged = function( s, _ ) -- take SearchSongs out of callback
		if not mainWnd.bFilterCbActive or not s:IsShiftKeyDown( ) then return; end
		--mainWnd:SearchSongs( chFilter, mainWnd.aEditTags[ chFilter ]:GetText( ) )
		local sFilter = nil
		if s:IsChecked( ) then sFilter =  mainWnd.aFilters[chFilter].edit:GetText( ); end
		mainWnd:AddDelayedCall( 0.05, function( ) mainWnd:SearchSongs( chFilter, sFilter ); end )
	end
	cb:SetVisible( true );
	return cb;
end

function SongbookWindow:SetFilterCbs( bState )
	local bOldState = self.bFilterCbActive
	self.bFilterCbActive = false
	for i = 1, self.aSearchKw:len() do
		local ch = self.aSearchKw:sub( i, i )
		self.aFilters[ch].cb:SetChecked( bState )
	end
	self.bFilterCbActive = bOldState
end

-- Switch between filter UI display (true) and track listbox (false)
function SongbookWindow:ShowFilterUI( bFilter )
	self.lbFilters:SetVisible( bFilter )
	self.cbModeFilters:SetVisible( bFilter )
	self.cbModeTags:SetVisible( bFilter )
	
	self:AdjustFilterUI();
	self:AdjustDirlistPosition( 0 );
end

-- ZEDMOD: Show Players list Party UI
function SongbookWindow:ShowPartyUI( bParty )
	self.listboxPlayers:SetVisible( bParty );
	self.sepDirsSongs.hdgPlayers:SetVisible( bParty );
	self:AdjustPartyUI();
	self:AdjustSonglistPosition( self.dirlistBox:GetHeight() + UI.sep.sMain );
end

-- Reposition the filter UI for dir listbox size changes
function SongbookWindow:AdjustFilterUI()
	if ( not self.bFilter ) then
		return;
	end
	local dirHeight = self.dirlistBox:GetHeight();
	if ( dirHeight < 40 ) then
		dirHeight = 40;
	end
	self.lbFilters:SetHeight( dirHeight )
end

-- Reposition the Party UI for song listbox size changes
function SongbookWindow:AdjustPartyUI()
	if not self.bParty then return; end
	--if ( not self.cbFilters:IsChecked() ) then
		--return;
	--end
	local songheight = self.songlistBox:GetHeight();
	if ( songheight < 40 ) then
		songheight = 40;
	end
	--self.separatorParty:SetHeight( songheight ); -- ZEDMOD: OriginalBB
end

-------------------------------
-- Set Instrument Message    --
-------------------------------
function SongbookWindow:SetInstrumentMessage( sInstr )
	if ( self.bInstrumentOk or sInstr == nil ) then
		self:SetTextModeNormal( self.lblInstrAlert )
		self.lblInstrAlert:SetVisible( false ); -- ZEDMOD
	else
		self:SetTextModeAlert( self.lblInstrAlert )
		--self.lblInstrAlert:SetForeColor( UI.colour.wrongInstrument ); -- ZEDMOD
		self.lblInstrAlert:SetText( Strings["instr"]..sInstr ); -- ZEDMOD
		self.lblInstrAlert:SetVisible( true ); -- ZEDMOD
		self:StartMessageBlink( )
	end
end

------------
-- Player --
------------

function SongbookWindow:UpdatePlayerCount( )
	self.nPlayers = self.listboxPlayers:GetItemCount()
	self.sepDirsSongs.hdgPlayers:SetText( tostring( self.nPlayers ).." "..Strings["players"] )
	PartyMembers:Update( self.aPlayers )
end

local function PartyPlayerMenu( sender, args )
	local lbParent = mainWnd.listboxPlayers
	if args.Button ~= Turbine.UI.MouseButton.Right then return; end
	
	local contextMenu = Turbine.UI.ContextMenu();
	local menuItems = contextMenu:GetItems( )
	local id = lbParent:IndexOfItem( sender )
	
	menuItems:Add( ListBox.CreateMenuItem( Strings["asn_addPlayer"], id,
		function( s, a ) ListBox.PlayerEntry( lbParent, 100, 20 ); end ) )

	menuItems:Add( ListBox.CreateMenuItem( Strings["asn_removePlayer"], id,
		function( s, a ) mainWnd:RemovePlayerAt( s.ID ); mainWnd:UpdatePlayerCount( ); end ) )

	contextMenu:ShowMenu( )
end

-- Add player to the fellowship list
function SongbookWindow:AddPlayerToList( sPlayername )
	if self.listboxPlayers == nil then return; end -- Listbox not created yet
	
	local memberItem = Turbine.UI.Label();
	memberItem:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleLeft );
	memberItem:SetSize( 100, UI.lb.hItem );
	memberItem:SetFont( UI.lb.font )
	memberItem:SetText( sPlayername );
	memberItem.MouseClick = PartyPlayerMenu
	if sPlayername == self.sLeaderName then memberItem:SetFont( UI.lb.players.fontLead ); end
	self.listboxPlayers:AddItem( memberItem );
end

-- Remove player from the fellowship list
function SongbookWindow:RemovePlayerFromList( sPlayername )
	if self.listboxPlayers == nil then return; end -- Listbox not created yet
	local iDel, item = self:GetItemFromList( self.listboxPlayers, sPlayername );
	if not iDel then return; end
	self.listboxPlayers:RemoveItemAt( iDel );
end

-- Get index and item for player name from player listbox
function SongbookWindow:GetItemFromList( listbox, sText )
	local item;
	for i = 1, listbox:GetItemCount() do
		item = listbox:GetItem( i );
		if ( item:GetText() == sText ) then
			return i, item;
		end
	end
	return nil, nil;
end

----------------------------
-- Player : Ready Columns --
----------------------------
-- Enable Ready Columns
function SongbookWindow:EnableReadyColumns( bOn )
	self.listboxPlayers:EnableCharColumn( bOn );
	self.tracklistBox:EnableCharColumn( bOn );
end

-- Show Ready Columns
function SongbookWindow:ShowReadyColumns( bShow )
	if ( self.bShowReadyChars == bShow ) then
		return;
	end
	self.bShowReadyChars = bShow;
	self:EnableReadyColumns( bShow );
	if ( selectedSongIndex ) then
		--self:ListTracks( selectedSongIndex );
		--self:RefreshPlayerListbox();
		self:SetTrackColours( selectedTrack );
		self:SetPlayerColours();
	end
end

-- Hightlight Ready Columns
function SongbookWindow:HightlightReadyColumns( bOn )
	self.listboxPlayers.bHighlightReadyCol = bOn;
	self.tracklistBox.bHighlightReadyCol = bOn;
end

---------------------------
-- Player : Party Member --
---------------------------
-- Read party member names and add them to the party members listbox
-- TODO: Party object does not seem to report party members correctly?
function SongbookWindow:RefreshPlayerListbox()
	if ( self.listboxPlayers == nil ) then return; end
	
	self.listboxPlayers:ClearItems();
	
	local player = self:GetPlayer( ) --Turbine.Gameplay.LocalPlayer:GetInstance();
	if ( self.sPlayerName == nil ) then self.sPlayerName = player:GetName(); end
	
	local party = player:GetParty();
	if ( party == nil or party:GetMemberCount() <= 0 ) then
		self:AddPlayerToList( self.sPlayerName );
		self.aPlayers[ self.sPlayerName ] = 0;
		self:UpdatePlayerCount( )
		return;
	end
	
	-- ZEDMOD: Player Party : Get Leader
	local partyLeader = party:GetLeader();
	self.sLeaderName = partyLeader:GetName();
	
	--if ( self.bChiefMode ) then
	if self.sPlayerName == self.sLeaderName then
		self.aPlayers = {};
		self.aCurrentSongReady = {};
	else
		self:ListKnownPlayers( party );
	end
	
	self:ListPartyObjectPlayers( party )
		
	self:SetPlayerColours(); -- restore current states
	self:UpdateMaxPartCount();
	if ( self.maxPartCount ) then
		self:SearchSongs();
	end
	self:UpdateSetupColours();
	self:UpdatePlayerCount( )
end


local function PartyChanged( s, a ) if mainWnd then mainWnd:PartyChanged( a ); end; end
local function RaidChanged( s, a ) if mainWnd then mainWnd:RaidChanged( a ); end; end
local function IsLinkDeadChanged( s, a ) if mainWnd then mainWnd:IsLinkDeadChanged( a ); end; end

function SongbookWindow:SetPlayerEvents( )
	self.player = self:GetPlayer( )
	if not self.player then return; end
	self.player.PartyChanged = PartyChanged
	self.player.RaidChanged = RaidChanged
	self.player.IsLinkDeadChanged = IsLinkDeadChanged
	self:GetParty( )
	if self.party then self:SetPartyEvents( ); end
end

function SongbookWindow:PartyChanged( args )
	local bHadParty = self.party ~= nil
	self.party = self:RenewParty( )
	
	if self.party then self:PartyJoinedEvent( ); if bHadParty then self:RaidSwitch( ); end
	else self:PartyLeftEvent( ); self:ResetParty( ); end
INFO( "+++ PartyChanged" )
	self:RelistPlayers( )
end

function SongbookWindow:RaidChanged( args )
	local raid = self:GetRaid( )
INFO( "+++ RaidChanged" )
end

function SongbookWindow:RaidSwitch( )
INFO( "+++ RaidSwitch" ); 
end

function SongbookWindow:IsLinkDeadChanged( args )
INFO( "+++ LinkDeadChanged" )
end
	
local function LeaderChanged( s, a ) if mainWnd then mainWnd:ChangeLeader( ); end; end
local function MemberAdded( s, a ) if mainWnd then mainWnd:MemberAdded( a ); end; end
local function MemberRemoved( s, a ) if mainWnd then mainWnd:MemberRemoved( a ); end; end

function SongbookWindow:SetPartyEvents( )
	self.party = self.party or self:GetParty( )
	if not self.party then return; end
	self.party.LeaderChanged = LeaderChanged
	self.party.MemberAdded = MemberAdded
	self.party.MemberRemoved = MemberRemoved
end

function SongbookWindow:ChangeLeader( )
	local party = self:GetParty( )
	if not party or not party:GetLeader( ) then return; end
	local sNewLeader = party:GetLeader( ):GetName( )
	
	for i = 1, self.listboxPlayers:GetItemCount( ) do
		local item = self.listboxPlayers:GetItem( i )
		if item then
			if item:GetText( ) == sNewLeader then
				item:SetFont( Turbine.UI.Lotro.Font.TrajanPro14 ); item:SetText( sNewLeader )
			elseif item:GetText( ) == self.sLeaderName then
				item:SetFont( Turbine.UI.Lotro.Font.LucidaConsole12 ); item:SetText( self.sLeaderName )
			end
		end
	end
	self.sLeaderName = sNewLeader
end

function SongbookWindow:MemberAdded( args )
INFO( "+++ MemberAdded" )
end

function SongbookWindow:MemberRemoved( args )
INFO( "+++ MemberRemoved" )
end

function SongbookWindow:PartyJoinedEvent( )
INFO( "+++ Party joined" )
end

function SongbookWindow:PartyLeftEvent( )
INFO( "+++ Party left" )
end


function SongbookWindow:GetPlayer( )
	self.player = self.player or Turbine.Gameplay.LocalPlayer:GetInstance()
	if not self.player then 
INFO( "### WARN: LocalPlayer:GetInstance failed." )
		return nil
	end
	if not self.sPlayerName then
		self.sPlayerName = self.player:GetName( )
		self.biscuitCounter.bActive  = ( self.sPlayerName == "Lina" )
	end
	return self.player
end

function SongbookWindow:GetParty( )
	self:GetPlayer( )
	if not self.player then self:ResetParty( ); return nil; end
	self.party = self.party or self.player:GetParty( )
	if self.party then return self.party; end
--INFO( "### WARN: GetParty failed." )
	return nil
end

function SongbookWindow:RenewParty( )
	self:GetPlayer( )
	if not self.player then self:ResetParty( ); return nil; end
	if self.party then
		self:ResetParty( )
	end
	self.party = self.player:GetParty( )
	if not self.party then
--INFO( "### WARN: player:GetParty failed." )
		return nil
	end
	self:SetPartyEvents( )
	self:ListPartyObjectPlayers( )
	return self.party
end

function SongbookWindow:ResetParty( )
--INFO( "+++ Party reset" )
	self.party = nil
	self.aPlayers = {};
	self.aCurrentSongReady = {};
end

function SongbookWindow:ListPartyObjectPlayers( party )
	party = party or self:GetParty( )
	for iPlayer = 1, party:GetMemberCount( ) do
		local member = party:GetMember( iPlayer );
		local sName = member:GetName( );
		if ( self.aPlayers[ sName ] == nil ) then self:AddPlayer( sName )
		end
	end
end

function SongbookWindow:RelistPlayers( ) -- from aPlayers
	if not self.listboxPlayers then return; end
	self.listboxPlayers:ClearItems();
	
	local player = self:GetPlayer( ) --Turbine.Gameplay.LocalPlayer:GetInstance();
	if not player then return; end
	
	local party = player:GetParty(); -- TODO: is this necessary?
	if not party or party:GetMemberCount() <= 0 then
		self:AddPlayerToList( self.sPlayerName );
		self.aPlayers[self.sPlayerName] = 0;
		self:UpdatePlayerCount( )
		return;
	end
	
	self:ListKnownPlayers( party );
	
	self:SetTrackColours( selectedTrack );
	self:SetPlayerColours(); -- restore current states
	self:UpdateMaxPartCount();
	if ( self.maxPartCount ) then
		self:SearchSongs();
	end
	self:UpdateSetupColours();
	self:UpdatePlayerCount( )
end

-- Add player to arrays
function SongbookWindow:AddPlayer( sName )
	if self.aPlayers[ sName ] then return; end
	self.aCurrentSongReady[ sName ] = false;
	self:AddPlayerToList( sName );
	self.aPlayers[ sName ] = 0;
end

-- Remove player from arrays
function SongbookWindow:RemovePlayer( sName )
	if ( not self.aPlayers[sName] ) then
		return;
	end
	self.aCurrentSongReady[ sName ] = nil;
	self:RemovePlayerFromList( sName );
	self.aPlayers[ sName ] = nil;
end

function SongbookWindow:RemovePlayerAt( i )
	if not self.listboxPlayers then return; end
	local item = self.listboxPlayers:GetItem( i )
	if item then self:RemovePlayer( item:GetText( ) ); end
end

-- Write known players to player listbox
function SongbookWindow:ListKnownPlayers( party )
	if ( not self.aPlayers ) then
		return;
	end
	
	for key, value in pairs( self.aPlayers ) do
		self:AddPlayerToList( key );
	end
	self:UpdatePlayerCount( )
end

-- Parse player join message, add player
function SongbookWindow:PlayerJoined( sMsg )
	local sPlayerName = string.match( sMsg, "(%a+)"..Strings["chat_playerJoin"] );
	if sPlayerName then self:AddPlayer( sPlayerName ); end
	self:RelistPlayers( );
end

-- ZEDMOD:
function SongbookWindow:PlayerJoinedSelf( sMsg )
	local _, _, sPlayerName = string.find( sMsg, "(%a+)" .. Strings["chat_playerJoinSelf"] );
	self:RefreshPlayerListbox( )
end

-- Parse player left message, remove player
function SongbookWindow:PlayerLeft( sMsg )
	local _, _, sPlayerName = string.find( sMsg, "(%a+)" .. Strings["chat_playerLeave"] );
	if sPlayerName then self:RemovePlayer( sPlayerName ); end
	self:RelistPlayers( );
end

-- 'you dismissed player'
function SongbookWindow:PlayerDismissedSelf( sMsg )
	local sPlayerName = string.match( sMsg, Strings["chat_playerDismissSelf"].."(%a+)" );
	if sPlayerName then self:RemovePlayer( sPlayerName ); end
	self:RelistPlayers( );
end

-- 'player was dismissed'
function SongbookWindow:PlayerDismissed( sMsg )
	local sPlayerName = string.match( sMsg, "(%a+)"..Strings["chat_playerDismiss"] );
	if sPlayerName then self:RemovePlayer( sPlayerName ); end
	self:RelistPlayers( );
end

function SongbookWindow:PlayerLinkDead( sMsg )
	local sPlayerName = string.match( sMsg, "(%a+)"..Strings["chat_playerLinkDead"] )
	if sPlayerName and assignWindow then
		local iPlayer = Players:Index( sPlayerName )
		assignWindow.lbAssigns:MarkPlayer( iPlayer, Marks.tag.inactive )
	end
end

-- ZEDMOD:
-- Parse player left message, remove player
function SongbookWindow:PlayerLeftSelf( sMsg )
	local temp, sPlayerName, sTrackName;
	temp, temp, sPlayerName = string.find( sMsg, "(%a+)" .. Strings["chat_playerLeaveSelf"] );
	self:RefreshPlayerListbox( );
end


-- Clear the ready states for players
function SongbookWindow:ClearPlayerStates()
	if ( not self.aPlayers ) then
		return;
	end
	for key in pairs( self.aPlayers ) do
		self.aPlayers[key] = 0; -- present, no song ready
	end
end

-- Update item colours in party listbox to indicate ready states
function SongbookWindow:SetPlayerColours()
	if ( ( not self.aPlayers ) or ( not self.listboxPlayers ) ) then
		return;
	end
	for iMember = 1, self.listboxPlayers:GetItemCount() do
		local item = self.listboxPlayers:GetItem( iMember );
		if ( self.aPlayers[item:GetText()] == nil ) then -- should not happen
			item:SetForeColor( UI.colour.default );
			if ( self.bShowReadyChars ) then
				self.listboxPlayers:SetColumnChar( iMember, self.chNone, false );
			end
		elseif ( self.aPlayers[item:GetText()] == 0 ) then -- present, but no song ready
			item:SetForeColor( UI.colour.default );
			if ( self.bShowReadyChars ) then
				self.listboxPlayers:SetColumnChar( iMember, self.chNone, false );
			end
		elseif ( ( self.aCurrentSongReady ) and ( self.aCurrentSongReady[item:GetText()] == 1 ) ) then
			item:SetForeColor( UI.colour.ready ); -- Track from the currently displayed song ready
			if ( self.bShowReadyChars ) then
				self.listboxPlayers:SetColumnChar( iMember, self.chReady, false );
			end
		elseif ( ( self.aCurrentSongReady ) and ( self.aCurrentSongReady[item:GetText()] == 2 ) ) then
			item:SetForeColor( UI.colour.readyMultiple ); -- Correct song, but same track as another player
			if ( self.bShowReadyChars ) then
				self.listboxPlayers:SetColumnChar( iMember, self.chMultiple, true );
			end
		elseif ( ( self.aCurrentSongReady ) and ( self.aCurrentSongReady[item:GetText()] == 3 ) ) then
			item:SetForeColor( UI.colour.differentSetup ); -- Correct song, but track not in current setup
			if ( self.bShowReadyChars ) then
				self.listboxPlayers:SetColumnChar( iMember, self.chWrongPart, true );
			end
		else
			item:SetForeColor( UI.colour.differentSong ); -- Track ready, but different song
			if ( self.bShowReadyChars ) then
				self.listboxPlayers:SetColumnChar( iMember, self.chWrongSong, true );
			end
		end
	end
end


local function PartyListboxMenu( sender, args )
	if args.Button ~= Turbine.UI.MouseButton.Right then return; end
	
	local contextMenu = Turbine.UI.ContextMenu()
	local menuItems = contextMenu:GetItems( )
	
	menuItems:Add( ListBox.CreateMenuItem( Strings["asn_addPlayer"], nil,
		function( s, a ) ListBox.PlayerEntry( sender, 100, 20 ); end ) )

	contextMenu:ShowMenu( )
end


local function LbPlayers_LbCb_AddPlayer( self, sPlayer )
	mainWnd:AddPlayer( sPlayer )
end

local function LbPlayers_LbCb_PlayersEntered( self, n )
	mainWnd:UpdatePlayerCount( )
end

local function LbPlayer_AddPlayer( self, sPlayer )
	local item = Turbine.UI.Label();
	item:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleLeft );
	item:SetSize( 100, UI.lb.hItem );
	item:SetFont( UI.lb.font )
	item:SetText( sPlayer );
	item.MouseClick = PartyPlayerMenu
	self:AddItem( item )
	return item
end

-- Create party member listbox
function SongbookWindow:CreatePartyListbox()
	local songHeight = self.songlistBox:GetHeight();
	local songTop = self.songlistBox:GetTop();
	self.listboxPlayers = ListBoxCharColumn:New( 10, 10, false, UI.wiCharColumn );
	self.listboxPlayers:EnableCharColumn( self.bShowReadyChars ); -- Create the Players Column
	self.listboxPlayers:SetParent( self.listContainer );
	self.listboxPlayers:SetSize( 80, songHeight - UI.hPlayerBtn );
	self.listboxPlayers:SetPosition( 2 , songTop + UI.hPlayerBtn );
	self.listboxPlayers:SetVisible( false );
	self.listboxPlayers.MouseClick = PartyListboxMenu
	self.listboxPlayers.AddPlayer = LbPlayer_AddPlayer
	self.listboxPlayers.LbCb_AddPlayer = LbPlayers_LbCb_AddPlayer
	self.listboxPlayers.LbCb_PlayersEntered = LbPlayers_LbCb_PlayersEntered
	
	self:AdjustPartyUI();
	self:AdjustSonglistPosition( songTop );
end

-- Use the number of currently listed players as limit for part counts
function SongbookWindow:SetMaxPartCount( bActivate )
	--self:RefreshPlayerListbox();
	if ( ( bActivate ) and ( self.listboxPlayers ) ) then
		self.maxPartCount = self.listboxPlayers:GetItemCount();
	else
		self.maxPartCount = nil;
	end
end

-- Due to party object issues, we only increase partcount here
function SongbookWindow:UpdateMaxPartCount()
	if ( ( self.maxPartCount ) and ( self.listboxPlayers ) and ( self.maxPartCount < self.listboxPlayers:GetItemCount() ) ) then
		self.maxPartCount = self.listboxPlayers:GetItemCount();
	end
end

--------------------
-- listbox Setups --
--------------------
-- Create listbox to show the possible setup counts
function SongbookWindow:CreateSetupsListbox()
	self.listboxSetups = ListBoxScrolled:New( 10 );
	self.listboxSetups:SetParent( self.listContainer );
	self.listboxSetups:SetSize( self.listboxSetupsWidth - 0, self.tracklistBox:GetHeight() );
	self.listboxSetups:SetPosition( 0, self.tracklistBox:GetTop() );
	self.listboxSetups:SetVisible( self.bShowSetups );
	self.listboxSetups.SelectedIndexChanged = function( sender, args )
		self:ListTracksForSetup( sender:GetSelectedIndex() );
	end
end

-- Select Setup
function SongbookWindow:SelectSetup( iSetup )
	if not self.listboxSetups then return; end
	if not iSetup or iSetup > self.listboxSetups:GetItemCount() then
		iSetup = self.listboxSetups:GetItemCount(); end
	if self.iCurrentSetup == iSetup then return; end -- don't reselect (usually callback)
	self:ListTracksForSetup( iSetup );

	if not mainWnd then return; end
	local song = SongDB.Songs[ selectedSongIndex ]
	self.aUix = nil
	if song then self.aUix = Assigner:GetSongUix( song, nil ); end
	local bShowInstr = self.aUix ~= nil and Instruments:HasRelevantSlots( self.aUix )
	self:SetInstrLabelActive( bShowInstr )
end

-- List Tracks for Setup
function SongbookWindow:ListTracksForSetup( iSetup )
	self.iCurrentSetup = iSetup
	self.listboxSetups:SetSelectedIndex( iSetup );
	local newTrack = ( selectedTrack and selectedTrack or 1 )
	selectedTrack = nil;
	newTrack = 1; 
	local song = SongDB.Songs[selectedSongIndex]
	if not song or not song.Setups then return; end
	for iItem = 1, self.listboxSetups:GetItemCount() do
		self.listboxSetups:GetItem( iItem ):SetBackColor( UI.colour.backDefault );
	end
	self.aSetupTracksIndices = {};
	self.aSetupListIndices = {};
	--self.iCurrentSetup = nil;
	if not iSetup or iSetup >= self.listboxSetups:GetItemCount() then
		self:ListTracks( selectedSongIndex ); --AHA! Bei A werden alle gelistet
		self.selectedSetupCount = nil;
	else
		self.iCurrentSetup = iSetup;
		self.tracklistBox:ClearItems();
		for i = 1, #song.Setups[iSetup] do
			local iTrack = song.Setups[iSetup]:byte( i ) - 64;
			self.aSetupTracksIndices[i] = iTrack;
			self.aSetupListIndices[iTrack] = i;
			self:AddTrackToList( selectedSongIndex, iTrack );
		end
		self.selectedSetupCount = #song.Setups[iSetup];
		self.aUix = Assigner:GetSongUix( song, iSetup )
	end
	local selItem = self.listboxSetups:GetSelectedItem( );
	if selItem then selItem:SetBackColor( UI.colour.backHighlight ); end
	self:SelectTrack( newTrack );
	self:SetPlayerColours();
	local found = self.tracklistBox:GetItemCount();
	self.sepSongsTracks.heading:SetText( Strings["ui_parts"] .. tostring(found) );
	local bShowInstr = self.aUix ~= nil and Instruments:HasRelevantSlots( self.aUix )
	self:SetInstrLabelActive( bShowInstr )
end

function SongbookWindow:HasSetups( iSong )
	iSong = iSong or selectedSongIndex
	return SongDB.Songs[iSong] and SongDB.Songs[iSong].Setups
end

function SongbookWindow:SetupIndexForCount( iSong, setupCount )
	if ( ( not setupCount ) or ( not SongDB.Songs[iSong] ) or ( not SongDB.Songs[iSong].Setups ) ) then
		return nil;
	end
	for i = 1, #SongDB.Songs[iSong].Setups do
		if ( setupCount == #SongDB.Songs[iSong].Setups[i] ) then
			return i;
		end
	end
	return nil;
end

-- Update Setup Colours
function SongbookWindow:UpdateSetupColours()
	if not self.listboxSetups or not SongDB.Songs[selectedSongIndex] or not SongDB.Songs[selectedSongIndex].Setups then
		return;
	end
	self:UpdateTrackReadyString();
	local item, matchPattern, antiMatchPattern, _
	local matchLength = 0
	for i = 1, self.listboxSetups:GetItemCount() - 1 do
		item = self.listboxSetups:GetItem( i );
		local sSetup = SongDB.Songs[selectedSongIndex].Setups[i]
		if not sSetup or #sSetup == 0 then break; end
		matchPattern = "[" .. sSetup .. "]";
		antiMatchPattern = "[^" .. sSetup .. "]";
		_, matchLength = string.gsub( self.aReadyTracks, matchPattern, " " );
		if ( SongDB.Songs[selectedSongIndex].Setups[i] == self.aReadyTracks ) then
			item:SetForeColor( UI.colour.ready );
		elseif ( string.match( self.aReadyTracks, antiMatchPattern ) ) then
			item:SetForeColor( Turbine.UI.Color( 0.7, 0, 0 ) );
		elseif ( matchLength and ( matchLength + 1 == #SongDB.Songs[selectedSongIndex].Setups[i] ) ) then
			item:SetForeColor( Turbine.UI.Color( 0, 0.7, 0 ) );
		else
			item:SetForeColor( UI.colour.default );
		end
	end
end

-- Clear Setups
function SongbookWindow:ClearSetups()
	if ( not self.listboxSetups ) then
		return;
	end
	local selItem = self:SetListboxColours( self.listboxSetups, true );
	if selItem then selItem:SetBackColor( UI.colour.backHighlight );
	end
end

-- Update Track Ready String
function SongbookWindow:UpdateTrackReadyString()
	self.aReadyTracks = "";
	for iList = 1, self.tracklistBox:GetItemCount() do
		local i = self:SelectedTrackIndex( iList );
		local song = SongDB.Songs[selectedSongIndex]
		if ( self:GetTrackReadyState( song.Tracks[i].Name ) ) then
			self.aReadyTracks = self.aReadyTracks .. string.char( 0x40 + i );
		end
	end
end

-- Add an item with the given text to the given listbox
function SongbookWindow:AddItemToList( sText, listbox, width )
	if ( listbox == nil ) then
		return;
	end -- Listbox not created yet
	local item = Turbine.UI.Label();
	item:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleCenter );
	item:SetSize( width, UI.lb.hItem );
	item:SetFont( UI.lb.font )
	item:SetText( sText );
	listbox:AddItem( item );
end

-- List Setups
function SongbookWindow:ListSetups( songID )
	if ( ( not self.listboxSetups ) or ( not self.listboxPlayers ) ) then
		return;
	end
	if self.listboxSetups:GetItemCount( ) > 0 then self:ClearSetupList( ); end
	if ( ( not SongDB ) or ( not SongDB.Songs[songID] ) or ( not SongDB.Songs[songID].Setups ) ) then
		self:ShowSetups( false ); return;
	end
	if self.tracklistBox:IsVisible() then self:ShowSetups( true );
	else self.bShowSetups = true; end
	local playerCount;
	if not self.maxPartCount then playerCount = 1000;
	else playerCount = self.maxPartCount; end
	--playerCount = 6;
	local countInSetup;
	for i = 1, #SongDB.Songs[songID].Setups do
		countInSetup = #SongDB.Songs[songID].Setups[i];
		if ( countInSetup <= playerCount ) then
			self:AddItemToList( countInSetup, self.listboxSetups, self.listboxSetupsWidth );
		end
	end
	self:AddItemToList( "A", self.listboxSetups, self.listboxSetupsWidth );
end

-- Get Track Ready State
-- Return a track state indicator:
-- nil = track not ready, name of a player = ready by this player, 0 = ready by more than one player
function SongbookWindow:GetTrackReadyState( sTrackName, indicator )
	local found = nil;
	local readyIndicator = 1;
	if ( indicator ) then
		readyIndicator = indicator;
	end
	if ( self.aPlayers ~= nil ) then
		for key, value in pairs( self.aPlayers ) do
			if ( value == string.sub( sTrackName, 1, 63 ) ) then
				if ( found == nil ) then
					found = key;
					self.aCurrentSongReady[key] = readyIndicator; -- track ready
				else
					self.aCurrentSongReady[key] = 2; -- track ready, but by other player too
					if ( found ~= 0 ) then
						self.aCurrentSongReady[found] = 2; -- set for other player as well
						found = 0;
					end
				end
			end
		end
	end
	return found; -- nil if not ready, player name if ready once, 0 if ready more than once
end


function SongbookWindow:CreateAnnounceTrackerCb( )
	local cb = Turbine.UI.Lotro.CheckBox();
	cb:SetParent( self );
	cb:SetSize( 100, 24 ) --cb:SetSize( UI:W( "filters" ), 20 );
	cb:SetMultiline( true );
	--cb:SetFont( UI.lb.font )
	cb:SetText( Strings["autoSel"] );
	cb.CheckedChanged = function( s, _ )
		if s:IsChecked( ) then s:SetBackColor( UI.colour.alert )
		else s:SetBackColor( self.colorDefault ); end
		--mainWnd.bTrackAnnounce = sender:IsChecked( )
		if s:IsChecked( ) then mainWnd:SelectAnnCapture( ); end
	end
	cb.MouseEnter = function( s, a ) self.tipLabel:SetText( Strings["tt_autoSel"] ); end
	cb.MouseLeave = function( s, a ) self.tipLabel:SetText( "" ); end
	cb:SetVisible( true );
	return cb;
end

-- Clear Player Ready States
function SongbookWindow:ClearPlayerReadyStates()
	if ( self.aPlayers ~= nil ) then
		for key, value in pairs( self.aPlayers ) do
			self.aCurrentSongReady[key] = false;
		end
	end
end

--------------------
-- Set Chief Mode --
--------------------
function SongbookWindow:SetChiefMode( bState )
	self.bChiefMode = ( bState == true );
	self.syncStartSlot:SetVisible( self.bChiefMode );
	self.syncStartIcon:SetVisible( self.bChiefMode );
	self.btnAssign:SetVisible( self.bChiefMode )
end

--------------------
-- Set Solo Mode --
--------------------
function SongbookWindow:SetSoloMode( bState )
	self.bSoloMode = ( bState == true );
	self.playSlot:SetVisible( self.bSoloMode );
	self.playIcon:SetVisible( self.bSoloMode );
end

function SongbookWindow:ShowAllButtons( bState )
	self.bShowAllBtns = bState
	self.shareSlot:SetVisible( bState )
	self.shareIcon:SetVisible( bState )
	self.readySlot:SetVisible( bState )
	self.readyIcon:SetVisible( bState )
	self.trackLabel:SetVisible( bState )
	self.trackNumber:SetVisible( bState )
	
	local song = SongDB.Songs[selectedSongIndex]
	if not song or not selectedTrack then return; end
	self.trackPrev:SetVisible( bState and ( selectedTrack > 1 ) )
	self.trackNext:SetVisible( bState and ( selectedTrack < #song.Tracks ) )
end	

-- ZEDMOD
-------------------------------------------
-- Instruments Visible Horizontal Forced --
-------------------------------------------
function SongbookWindow:InstrumentsVisibleHForced( bOn )
	
	-- Get Main Window Height and Container Height
	local windowHeight = self:GetHeight();
	local containerHeight = self.listContainer:GetHeight();
	local unallowedHeight = windowHeight - containerHeight;
	self.bInstrumentsVisibleHForced = bOn;
	if ( self.bInstrumentsVisibleHForced == false ) then
		self.sArrows3:SetVisible( true );
		self.instrlistBox.scrollBarv:SetVisible( true );
		self.instrlistBox.scrollBarh:SetVisible( false );
		
		-- Get Container Height
		containerHeight = containerHeight - 10;
		
		-- Set Container Height
		self.listContainer:SetHeight( containerHeight );
		
		-- Get New Window Height
		local newwindowHeight = self.listContainer:GetHeight() + unallowedHeight;
		
		-- Set New Window Height
		self:SetHeight( newwindowHeight );
		
		-- Set Controls
		self:SetSBControls();
		
		-- Set Container
		self:SetContainer();
		
		-- Adjust Instrument Slot
		self:AdjustInstrumentSlots();
		
	else
		self.sArrows3:SetVisible( false );
		self.instrlistBox.scrollBarv:SetVisible( false );
		self.instrlistBox.scrollBarh:SetVisible( true );
		self:ResizeAll();
	end
end

function SongbookWindow:GetTextWidth( sText, font )
	if not self.tbWidthTest then
		self.tbWidthTest = Turbine.UI.Label( )
		self.tbWidthTest:SetParent( self )
		self.tbWidthTest:SetZOrder( 420 );
		self.tbWidthTest:SetVisible( true )
		self.tbWidthTest:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleRight )
		self.tbWidthTest:SetPosition( 100, 50 )
		self.tbWidthTest:SetSize( 100, 50 )
		self.tbWidthTest:SetMultiline( false )
		self.scbWidthTest = Turbine.UI.Lotro.ScrollBar();
		self.scbWidthTest:SetParent( self );
		self.scbWidthTest:SetZOrder( 420 );
		self.scbWidthTest:SetVisible( true )
		self.scbWidthTest:SetOrientation( Turbine.UI.Orientation.Horizontal );
		self.scbWidthTest:SetPosition( 100, 100 )
		self.scbWidthTest:SetSize( 100, 10 );
		-- self.scbWidthTest:SetMinimum( 0 )
		-- self.scbWidthTest:SetMaximum( 100 )
		self.scbWidthTest.ValueChanged = function(s,a) TRACE( "val="..tostring(s:GetValue( ))..", a="..table.String(a)); end
		--self.tbWidthTest:SetHorizontalScrollBar( self.scbWidthTest )
	end
	self.tbWidthTest:SetFont( font )
	self.tbWidthTest:SetText( sText )
	TRACE( "scb btn: "..tostring(self.scbWidthTest:GetThumbButton()) )
	--self.tbWidthTest:SetHorizontalScrollBar( nil )
	TRACE( "scb btn: "..tostring(self.scbWidthTest:GetThumbButton()) )
	local min = self.scbWidthTest:GetMinimum( )
	local max = self.scbWidthTest:GetMaximum( )
	local val = self.scbWidthTest:GetValue( )
	local lc = self.scbWidthTest:GetLargeChange( )
	TRACE( "scb: min="..tostring(min)..", max="..tostring(max)..", val="..tostring(val)..", lc="..tostring(lc) )
	local btn = self.scbWidthTest:GetThumbButton()
	--TRACE( "scb btn: w="..tostring(btn:GetWidth())..", h="..tostring(btn:GetHeight()) )
	--self.tbWidthTest:SetHorizontalScrollBar( self.scbWidthTest )
end
---------------------
-- ListBoxScrolled --
---------------------
-- Listbox with scrollbar and separator
-- Listbox Scrolled : New
function ListBoxScrolled:New( scrollWidth, scrollHeight, bOrientation, listbox )
	listbox = listbox or ListBoxScrolled( scrollWidth, scrollHeight, bOrientation );
	setmetatable( listbox, self );
	self.__index = self;
	return listbox;
end

-- Listbox Scrolled : Constructor
function ListBoxScrolled:Constructor( scrollWidth, scrollHeight, bHorScroll )
	Turbine.UI.ListBox.Constructor( self );
	self:SetMouseVisible( true ); -- Turbine.UI.ListBox.SetMouseVisible( self, true );
	self:CreateChildScrollbar( scrollWidth );
	self:CreateChildSeparator( scrollWidth );
	if bHorScroll then
		self:CreateChildScrollbarHor( scrollHeight )
		self:CreateChildSeparatorHor( scrollHeight )
	end
	self.iSel = 0
end

-- 
function ListBoxScrolled:Initialize( listbox, scrollWidth, scrollHeight, bHorScroll )
	self.CreateChildScrollbar( listbox, scrollWidth );
	self.CreateChildSeparator( listbox, scrollWidth );
	if bHorScroll then
		self.CreateChildScrollbarHor( listbox, scrollHeight )
		self:CreateChildSeparatorHor( scrollHeight )
	end
end

-- Listbox Scrolled : Child Scrollbar
function ListBoxScrolled:CreateChildScrollbar( width )
	self.scrollBarv = Turbine.UI.Lotro.ScrollBar();
	self.scrollBarv:SetParent( self:GetParent() );
	self.scrollBarv:SetOrientation( Turbine.UI.Orientation.Vertical );
	self.scrollBarv:SetZOrder( 320 );
	self.scrollBarv:SetWidth( width );
	self.scrollBarv:SetTop( 0 );
	self.scrollBarv:SetValue( 0 );
	self:SetVerticalScrollBar( self.scrollBarv );
	self.scrollBarv:SetVisible( false );
end

-- Listbox Scrolled : Child Scrollbar
function ListBoxScrolled:CreateChildScrollbarHor( height, leftInd, rightInd )
	self.hcbLeft = leftInd or 0; self.hcbRight = rightInd or 1
	self.scrollBarh = Turbine.UI.Lotro.ScrollBar();
	self.scrollBarh:SetParent( self:GetParent() );
	self.scrollBarh:SetOrientation( Turbine.UI.Orientation.Horizontal );
	self.scrollBarh:SetZOrder( 420 );
	self.scrollBarh:SetHeight( height );
	self.scrollBarh:SetTop( self:GetHeight( ) );
	self.scrollBarh:SetMinimum( 0 );
	self.scrollBarh:SetMaximum( 100 );
	self.scrollBarh:SetValue( 0 );
	self:SetHorizontalScrollBar( self.scrollBarh );
	self.scrollBarh:SetVisible( false );
end

-- Listbox Scrolled : Child Separator
function ListBoxScrolled:CreateChildSeparator( width )
	self.separatorv = Turbine.UI.Control();
	self.separatorv:SetParent( self:GetParent() );
	self.separatorv:SetZOrder( 310 );
	self.separatorv:SetWidth( width );
	self.separatorv:SetTop( 0 );
	self.separatorv:SetBackColor( Turbine.UI.Color(1, 0.15, 0.15, 0.15) );
	self.separatorv:SetVisible( false );
end

-- Listbox Scrolled : Child Separator
function ListBoxScrolled:CreateChildSeparatorHor( height )
	self.separatorh = Turbine.UI.Control();
	self.separatorh:SetParent( self:GetParent() );
	self.separatorh:SetZOrder( 310 );
	self.separatorh:SetHeight( height );
	self.separatorh:SetTop( height );
	self.separatorh:SetBackColor( Turbine.UI.Color(1, 0.15, 0.15, 0.15) );
	self.separatorh:SetVisible( false );
end

-- Listbox Scrolled : Constructor
function ListBoxScrolled:SetSelectedIndex( iSel )
	iSel = iSel or 1
	if iSel < 1 or iSel > self:GetItemCount( ) then
		ASSERT( false, "Lb index "..tostring(iSel).." invalid. (max:"..tostring(self:GetItemCount()..")" ) )
		return; end
	self.iSel = iSel
end
	
function ListBoxScrolled:SelIdx( ) return self.iSel; end

function ListBoxScrolled:GetSelectedItem( )
	if self.iSel < 1 or self.iSel > self:GetItemCount( ) then TRACE("SelectedItem is nil"); return nil; end
	return Turbine.UI.ListBox.GetItem( self, self.iSel )
end

function ListBoxScrolled:ClearItems( )
	self.iSel = 0
	Turbine.UI.ListBox.ClearItems( self )
end

function ListBoxScrolled:HorScrollBarLeft( xPos, width )
	width = width or self:GetWidth( ); return xPos + self.hcbLeft * width; end
function ListBoxScrolled:HorScrollBarRight( xPos, width )
	width = width or self:GetWidth( ); return xPos + self.hcbRight * width; end
function ListBoxScrolled:HorScrollBarWidth( width )
	width = width or self:GetWidth( ); return ( self.hcbRight - self.hcbLeft ) * width; end
				
-- Listbox Scrolled : Set Left Position (x Position)
function ListBoxScrolled:SetLeft( xPos )
	Turbine.UI.ListBox.SetLeft( self, xPos );
	local width = self:GetWidth()
	self.scrollBarv:SetLeft( xPos + width );
	self.separatorv:SetLeft( xPos + width );
	
	-- ZEDMOD: Horizontal Scrollbar
	if self.scrollBarh then self.scrollBarh:SetLeft( self:HorScrollBarLeft( xPos, width ) ); end
	if self.separatorh then self.separatorh:SetLeft( xPos ); end
end

-- Listbox Scrolled : Set Top Position (y Position)
function ListBoxScrolled:SetTop( yPos )
	Turbine.UI.ListBox.SetTop( self, yPos );
	self.scrollBarv:SetTop( yPos );
	self.separatorv:SetTop( yPos );
	
	-- ZEDMOD: Horizontal Scrollbar
	local btm = yPos + self:GetHeight()
	if self.scrollBarh then self.scrollBarh:SetTop( btm ); end
	if self.separatorh then self.separatorh:SetTop( btm ); end
end

-- Listbox Scrolled : Set Position
function ListBoxScrolled:SetPosition( xPos, yPos )
	self:SetLeft( xPos );
	self:SetTop( yPos );
end

-- Listbox Scrolled : Set Width
function ListBoxScrolled:SetWidth( width )
	Turbine.UI.ListBox.SetWidth( self, width );
	local left = self:GetLeft( )
	self.scrollBarv:SetLeft( left + width );
	self.separatorv:SetLeft( left + width );
	
	-- ZEDMOD: Horizontal Scrollbar
	if self.scrollBarh then
		--TRACE( "ScBar hor: left="..tostring(self:HorScrollBarLeft( left, width ))..", width="..tostring(self:HorScrollBarWidth( width )) )
		self.scrollBarh:SetLeft( self:HorScrollBarLeft( left, width ) );
		self.scrollBarh:SetWidth( self:HorScrollBarWidth( width ) )
	end
	if self.separatorh then
		self.separatorh:SetLeft( left );
		self.separatorh:SetWidth( width );
	end
end

-- Listbox Scrolled : Set Height
function ListBoxScrolled:SetHeight( height )
	Turbine.UI.ListBox.SetHeight( self, height );
	self.scrollBarv:SetHeight( height );
	self.separatorv:SetHeight( height );
	
	-- ZEDMOD: Horizontal Scrollbar
	if self.scrollBarh then self.scrollBarh:SetTop( height ); end
	if self.separatorh then self.separatorh:SetTop( height ); end
end

-- Listbox Scrolled : Set Size
function ListBoxScrolled:SetSize( width, height )
	self:SetWidth( width );
	self:SetHeight( height );
end

-- Listbox Scrolled : Set Visible
function ListBoxScrolled:SetVisible( bVisible )
	Turbine.UI.ListBox.SetVisible( self, bVisible );
	self.scrollBarv:SetVisible( bVisible );
	self.separatorv:SetVisible( bVisible );
	
	-- ZEDMOD: Horizontal Scrollbar
	if self.scrollBarh then self.scrollBarh:SetVisible( bVisible ); end
	if self.separatorh then self.separatorh:SetVisible( bVisible ); end
	
	if bVisible then
		self.scrollBarv:SetParent( self:GetParent() );
		if self.scrollBarh then self.scrollBarh:SetParent( self:GetParent() ); end
	else
		self.scrollBarv:SetParent( self );
		if self.scrollBarh then self.scrollBarh:SetParent( self ); end
	end
end

-- Listbox Scrolled : Set Parent
function ListBoxScrolled:SetParent( parent )
	Turbine.UI.ListBox.SetParent( self, parent );
	self.scrollBarv:SetParent( parent );
	self.separatorv:SetParent( parent );
	
	-- ZEDMOD: Horizontal Scrollbar
	if self.scrollBarh then self.scrollBarh:SetParent( parent ); end
	if self.separatorh then self.separatorh:SetParent( parent ); end
end

-----------------------------
-- ListBox Ready Indicator
-- A scroll listbox with an optional single-char column before the main column
-----------------------------
-- Listbox Char Column : New
function ListBoxCharColumn:New( scrollWidth, scrollHeight, bOrientation, readyColWidth, listbox )
	listbox = listbox or ListBoxCharColumn( scrollWidth, scrollHeight, bOrientation, readyColWidth );
	setmetatable( listbox, self );
	self.__index = self;
	return listbox;
end

-- Listbox Char Column : Constructor
function ListBoxCharColumn:Constructor( scrollWidth, scrollHeight, bOrientation, readyColWidth )
	ListBoxScrolled.Constructor( self, scrollWidth, scrollHeight, bOrientation ); -- , readyColWidth
	self.readyColWidth = readyColWidth or UI.wCharCol
	self.contentColWidth = 700
	self.bShowReadyChars = false;
	self.bHighlightReadyCol = false;
	self.bShifted = false;
end

-- Listbox Char Column : Enable Char Column
function ListBoxCharColumn:EnableCharColumn( bColumn )
	if not self.bShowReadyChars == not bColumn then return; end
	self.bShowReadyChars = bColumn;
	if ListBoxScrolled.GetItemCount( self ) == 0 then return; end
	local itemCount = ListBoxScrolled.GetItemCount( self );
	if bColumn then -- Add a char item before every item in the list
		for iList = 1, itemCount * 2, 2 do
			local chItem = self:CreateCharItem();
			ListBoxScrolled.InsertItem( self, iList, chItem );
		end
		self:SetMaxItemsPerLine( 2 );
	else -- remove every item with odd index (the char items)
		for iList = 1, itemCount / 2 do
			ListBoxScrolled.RemoveItemAt( self, iList );
		end
		self:SetMaxItemsPerLine( 1 );
	end
	self:AdjustColWidth( self:GetWidth( ) )
end

function ListBoxCharColumn:AdjustIndex( iLine )
	return self.bShowReadyChars and iLine*2 or iLine; end

function ListBoxCharColumn:ContentLeftShifted( w )
	w = w or self:GetWidth()
	return w - self.contentColWidth - 10; end

function ListBoxCharColumn:ShiftLeft( w )
	w = w or self:GetWidth()
	self.bShifted = true
	for i = 1, self:GetItemCount() do
		local item = self:GetItem( i )
		item:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleRight )
		item:SetLeft( self:ContentLeftShifted( w ) )
	end
end

function ListBoxCharColumn:CancelShift( )
	self.bShifted = false
	for i = 1, self:GetItemCount() do
		local item = self:GetItem( i )
		item:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleLeft )
		item:SetLeft( 0 )
	end
end

function ListBoxCharColumn:ItemWidth( w )
	return self.contentColWidth; end
	--return ( w or self:GetWidth() ) - ( self.bShowReadyChars and self.readyColWidth or 0 ); end
-- function ListBoxCharColumn:SetSelectedIndex( iLine )
-- 	return ListBoxScrolled.SetSelectedIndex( self, self:AdjustIndex( iLine ) );
-- end

function ListBoxCharColumn:AdjustColWidth( w )
	for i = 1, self:GetItemCount() do
		local item = self:GetItem( i );
		item:SetWidth( self:ItemWidth(w) );
	end
end

-- Listbox Char Column : Get Item
function ListBoxCharColumn:GetItem( iLine )
	ASSERT( iLine > 0 and iLine <= self:GetItemCount(), "LBCharCol: raw i="..tostring(iLine)..", max="..tostring(self:GetItemCount()) )
	return ListBoxScrolled.GetItem( self, self:AdjustIndex( iLine ) );
end

-- Listbox Char Column : Get Char Column Item
function ListBoxCharColumn:GetCharColumnItem( iLine )
	if not self.bShowReadyChars then return nil; end
	return ListBoxScrolled.GetItem( self, iLine * 2 - 1 );
end

function ListBoxCharColumn:IndexOfItem( item )
	local i = ListBoxScrolled.IndexOfItem( self, item )
	if not i then return nil; end
	return self.bShowReadyChars and math.floor( i / 2 ) or i
end

-- Listbox Char Column : Set Column Char
function ListBoxCharColumn:SetColumnChar( iLine, ch, bHighlight )
	local charItem = self:GetCharColumnItem( iLine );
	if ( charItem ) then
		self:ApplyHighlight( charItem, bHighlight );
		charItem:SetText( ch );
	end
end

-- Listbox Char Column : Apply Highlight
function ListBoxCharColumn:ApplyHighlight( charItem, bHighlight )
	if ( ( bHighlight ) and ( self.bHighlightReadyCol ) ) then
		charItem:SetForeColor( Turbine.UI.Color( 1, 0, 0, 0 ) );
		charItem:SetBackColor( Turbine.UI.Color( 1, 0.7, 0.7, 0.7 ) );
	else
		charItem:SetForeColor( Turbine.UI.Color( 1, 1, 1, 1 ) );
		charItem:SetBackColor( Turbine.UI.Color( 1, 0, 0, 0 ) );
	end
end

-- Listbox Char Column : Get Item Count
function ListBoxCharColumn:GetItemCount()
	if ( self.bShowReadyChars ) then
		return math.floor( ListBoxScrolled.GetItemCount( self ) / 2 );
	end
	return ListBoxScrolled.GetItemCount( self );
end

-- Listbox Char Column : Clear Items
function ListBoxCharColumn:ClearItems()
	ListBoxScrolled.ClearItems( self );
	self.bShifted = false
	if ( self.bShowReadyChars ) then 
		self:SetMaxItemsPerLine( 2 );
	else
		self:SetMaxItemsPerLine( 1 );
	end
	self:SetOrientation( Turbine.UI.Orientation.Horizontal );
end

-- Listbox Char Column : Create Char Item
function ListBoxCharColumn:CreateCharItem()
	local charItem = Turbine.UI.Label();
	charItem:SetMultiline( false );
	charItem:SetSize( self.readyColWidth, UI.lb.hItem );
	charItem:SetFont( UI.lb.font )
	charItem:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleCenter );
	self:ApplyHighlight( charItem, false );
	charItem:SetText( " " )
	return charItem;
end

-- Listbox Char Column : Add Item
function ListBoxCharColumn:AddItem( item )
	if self.bShowReadyChars then -- add ready indicator (single char in first column)
		local charItem = self:CreateCharItem();
		ListBoxScrolled.AddItem( self, charItem );
	end
	item:SetMultiline( false )
	item:SetSize( self:ItemWidth( ), UI.lb.hItem )
	ListBoxScrolled.AddItem( self, item );
end

-- Listbox Char Column : Remove Item At
function ListBoxCharColumn:RemoveItemAt( i )
	if ( self.bShowReadyChars ) then
		ListBoxScrolled.RemoveItemAt( self, i * 2 );
		ListBoxScrolled.RemoveItemAt( self, i * 2 - 1 );
	else
		ListBoxScrolled.RemoveItemAt( self, i );
	end
end

function ListBoxCharColumn:RemoveItem( item )
	self:RemoveItemAt( self:IndexOfItem( item ) )
end


function ListBoxCharColumn:SetWidth( w )
	ListBoxScrolled.SetWidth( self, w )
	self:AdjustColWidth( w )
end

function ListBoxCharColumn:SetSize( w, h )
	ListBoxScrolled.SetSize( self, w, h )
	self:AdjustColWidth( w )
end
	

-- Listbox : Set Colours
function SongbookWindow:SetListboxColours( listbox, bNoSelectionHighlight )
	for i = 1, listbox:GetItemCount() do
		local item = listbox:GetItem( i );
		item:SetForeColor( UI.colour.default );
	end
	if bNoSelectionHighlight then return nil; end 
	local selectedItem = listbox:GetSelectedItem();
	if selectedItem then
		selectedItem:SetForeColor( UI.colour.defHighlighted );
	end
	return selectedItem;
end

-----------------------
-- Listbox Separator --
-----------------------
-- Listbox : Create Main Separator
function SongbookWindow:CreateMainSeparator( top )
	return self:CreateSeparator( 0, top, self.listContainer:GetWidth(), UI.sep.sMain );
end

-- Listbox : Create Separator
function SongbookWindow:CreateSeparator( left, top, width, height )
	local separator = Turbine.UI.Control();
	separator:SetParent( self.listContainer );
	separator:SetZOrder( 310 );
	separator:SetBackColor( UI.colour.listFrame );
	separator:SetPosition( left, top );
	separator:SetSize( width, height );
	separator:SetVisible( false );
	return separator;
end

-- Listbox : Create Separator Heading
function SongbookWindow:CreateSeparatorHeading( parent, sText, wiHdg, xPos )
	wiHdg = wiHdg or 100
	xPos = xPos or 0
	local heading = Turbine.UI.Label();
	heading:SetParent( parent );
	heading:SetMultiline( false );
	heading:SetLeft( xPos );
	heading:SetSize( wiHdg, UI.sep.sMain );
	heading:SetFont( UI.sep.hdgFont );
	heading:SetText( sText );
	heading:SetMouseVisible( false );
	return heading;
end

-- Listbox : Create Separator Arrows
function SongbookWindow:CreateSeparatorArrows( parent )
	local arrows = Turbine.UI.Control();
	arrows:SetParent( parent );
	arrows:SetZOrder( 300 );
	arrows:SetBackground( gDir .. "arrows.tga" );
	local w, h = UI.sep.sHandle, UI.sep.s
	arrows:SetSize( w, h ); 
	arrows:SetPosition( ( parent:GetWidth() - w ) / 2, ( parent:GetHeight() - h ) / 2 );
	arrows:SetMouseVisible( false );
	return arrows;
end
function SongbookWindow:CreateSeparatorArrowsLR( parent )
	local arrows = Turbine.UI.Control();
	arrows:SetParent( parent );
	arrows:SetZOrder( 340 );
	arrows:SetBackground( gDir .. "arrows_LR.tga" );
	arrows:SetSize( UI.sep.s, UI.sep.sHandle );
	arrows:SetPosition( ( parent:GetHeight() - UI.sep.sHandle ) / 2, 1 );
	arrows:SetMouseVisible( false );
	return arrows;
end

----------------------------
-- Button : Main Shortcut --
----------------------------
-- Create Main Shorcut
function SongbookWindow:CreateMainShortcut( left )
	local slot = Turbine.UI.Lotro.Quickslot();
	slot:SetParent( self );
	slot:SetPosition( left, UI.scs.y );
	slot:SetSize( UI.scs.w, UI.scs.h );
	slot:SetZOrder( 100 );
	slot:SetAllowDrop( false );
	slot:SetVisible( true );
	return slot;
end
------------------------
-- Button : Main Icon --
------------------------
-- Listbox : Create Main Icon
function SongbookWindow:CreateMainIcon( left, sImageName )
	local icon = Turbine.UI.Control();
	icon:SetParent( self );
	icon:SetPosition( left, 50 );
	icon:SetSize( 35, 35 );
	icon:SetZOrder( 110 );
	icon:SetMouseVisible( false );
	icon:SetBlendMode( Turbine.UI.BlendMode.AlphaBlend );
	icon:SetBackground( gDir .. sImageName .. ".tga" );
	return icon;
end



-- Adjust search button locations
function SongbookWindow:AdjustPosSearchUI( yPos )
	local xPos = self:GetWidth() - UI.search.rightInd - UI.search.wiClearBtn
	self.clearBtn:SetPosition( xPos, yPos )

	xPos = xPos - UI.search.xSpacing - UI.search.wiMode
	self.searchMode:SetPosition( xPos, yPos )

	xPos = xPos - UI.search.wiSearchBtn + UI.search.wiModeOvl
	self.searchBtn:SetPosition( xPos, yPos )

	xPos = xPos - UI.search.xSpacing
	self.searchInput:SetWidth( xPos - UI.indLeft )
	if yPos then self.searchInput:SetPosition( UI.indLeft, yPos ); end
end


-- Listbox : Adjust Dirlist Position
function SongbookWindow:AdjustDirlistPosition( yPos )
	local xPos = 0;
	if self.bFilter then xPos = xPos + self.lbFilters:GetWidth() + 11; end
	self.sepDirs:SetTop( yPos ); -- ZEDMOD
	self.sepDirs:SetWidth( self.listContainer:GetWidth() ); -- ZEDMOD
	local wLbDir = self.listContainer:GetWidth() - xPos - 1
	--xPos = xPos + 11
	self.dirlistBox:SetPosition( xPos, yPos + UI.sep.sMain ); -- ZEDMOD
	self.sepDirs.hdgDir:SetLeft( xPos )
	self.sepDirs.hdgDir:SetWidth( wLbDir )
	self.dirlistBox:SetWidth( wLbDir );
end

-- ZEDMOD
-- Listbox : Adjust Songlist Position
function SongbookWindow:AdjustSonglistPosition( songlistpos )
	local xPos = 0;
	if ( self.bParty ) then
		xPos = xPos + 95;
	end
	self.sepDirsSongs:SetTop( songlistpos );
	self.sepDirsSongs:SetWidth( self.listContainer:GetWidth() );
	self.sepDirsSongs.hdgSongs:SetLeft( xPos )
	self.sArrows1:SetLeft( ( self.sepDirsSongs:GetWidth() - UI.sep.sHandle ) / 2 );
	self.songlistBox:SetPosition( xPos , songlistpos + UI.sep.sMain );
	self.songlistBox:SetWidth( self.listContainer:GetWidth() - xPos - 10 );
	self.listboxPlayers:SetTop( songlistpos + UI.sep.sMain + UI.hPlayerBtn );
end

-- Listbox : Adjust Songlist Left
function SongbookWindow:AdjustSonglistLeft()
	local xPos = 0;
	if self.bParty and self.bShowPlayers then xPos = xPos + 95; end
	self.songlistBox:SetLeft( xPos );
	self.songlistBox:SetWidth( self.listContainer:GetWidth() - xPos - 10 );
end

-----------------
-- Tracks List --
-----------------
-- ZEDMOD
function SongbookWindow:AdjustTracklistPosition( tracklistpos )
	local width = self.listContainer:GetWidth() - 10;
	if ( self.bShowSetups ) then
		width = width - self.setupsWidth;
	end
	self.sepSongsTracks:SetTop( tracklistpos );
	self.sepSongsTracks:SetWidth( self.listContainer:GetWidth() );
	self.sArrows2:SetLeft( ( self.sepSongsTracks:GetWidth() - UI.sep.sHandle ) / 2 );
	if ( self.alignTracksRight == true ) then
		self:RealignTracknames();
	end
	self.listboxSetups:SetTop( tracklistpos + UI.sep.sMain );
	self.tracklistBox:SetTop( tracklistpos + UI.sep.sMain );
	self.tracklistBox:SetWidth( width );
end

-- Listbox : Show Tracklist Listbox
function SongbookWindow:ShowTrackListbox( bShow )
	self.tracklistBox:SetVisible( bShow );
	self.sepSongsTracks:SetVisible( bShow );
	self.sArrows2:SetVisible( bShow );
end

-- Listbox : Adjust Tracklist Left
function SongbookWindow:AdjustTracklistLeft()
	if ( self.bShowSetups ) then
		self.tracklistBox:SetLeft( self.setupsWidth );
	else
		self.tracklistBox:SetLeft( 0 );
	end
end

-- Listbox : Adjust Tracklist Width
function SongbookWindow:AdjustTracklistWidth()
	local width = self.listContainer:GetWidth() - 10;
	if ( self.bShowSetups ) then
		width = width - self.setupsWidth;
	end
	self.tracklistBox:SetWidth( width );
	if ( self.alignTracksRight == true ) then
		self:RealignTracknames();
	end
	self.sepSongsTracks:SetWidth( self.listContainer:GetWidth() );
	self.sArrows2:SetLeft( ( self.sepSongsTracks:GetWidth() - UI.sep.sMain ) / 2 );
	--self.tracksMsg:SetLeft( self.tracklistBox:GetLeft() + width - self.tracksMsg:GetWidth() ) -- ZEDMOD: OriginalBB
end

----------------------
-- Instruments List --
----------------------
-- ZEDMOD: Adjust Instrument list Position
function SongbookWindow:AdjustInstrlistPosition( instrlistpos )
	self.sepTracksInstrs:SetTop( instrlistpos );
	self.sepTracksInstrs:SetWidth( self.listContainer:GetWidth() );
	self.sArrows3:SetLeft( self.sepTracksInstrs:GetWidth() / 2 - 10 );
	self.instrlistBox:SetTop( instrlistpos + UI.sep.sMain );
	self.instrlistBox:SetWidth( self.listContainer:GetWidth() - 10 );
end

-- ZEDMOD: Show Instrument list
function SongbookWindow:ShowInstrListbox( bShow )
	self.instrlistBox:SetVisible( bShow );
	self.sepTracksInstrs:SetVisible( bShow );
	if ( self.bInstrumentsVisibleHForced == false ) then
		self.sArrows3:SetVisible( true );
		self.instrlistBox.scrollBarv:SetVisible( true );
		self.instrlistBox.scrollBarh:SetVisible( false );
	else
		self.sArrows3:SetVisible( false );
		self.instrlistBox.scrollBarv:SetVisible( false );
		self.instrlistBox.scrollBarh:SetVisible( true );
	end
end

-- ZEDMOD: Move Instrumentlist Top when Toggle Search On/Off
function SongbookWindow:MoveInstrlistTop( delta )
	self:SetInstrlistTop( self.instrlistBox:GetTop() + delta );
end

-- ZEDMOD: Set Instrumentlist Top when Toggle Search On/Off
function SongbookWindow:SetInstrlistTop( top )
	self.instrlistBox:SetTop( top );
	self.sepTracksInstrs:SetTop( top - UI.sep.sMain );
	self.listboxSetups:SetTop( top );
end

--------------------------
-- Setups : Show Setups --
--------------------------
function SongbookWindow:ShowSetups( bShow )
	if bShow and not self.bShowSetups then
		self.bShowSetups = true;
		self.listboxSetups:SetVisible( true );
		self:AdjustTracklistLeft();
		self:AdjustTracklistWidth();
	elseif not bShow and self.bShowSetups then
		self.bShowSetups = false;
		self.listboxSetups:ClearItems();
		self.listboxSetups:SetVisible( false );
		self:AdjustTracklistLeft();
		self:AdjustTracklistWidth();
	end
end

-----------------------------
-- ZEDMOD: Dir list Resize --
-----------------------------
function SongbookWindow:ResizeDirlist()
	-- Get Dir list Height
	local dirlistheight = self:DirlistGetHeight();
	
	-- Set Dir list Height
	self.dirlistBox:SetHeight( dirlistheight );
	
	-- Adjust Dir list Position
	self:AdjustDirlistPosition( 0 );
	
	-- Adjust FilterUI
	self:AdjustFilterUI();
end

------------------------------
-- ZEDMOD: Song list Resize --
------------------------------
function SongbookWindow:ResizeSonglist()
	-- Get Song list Height
	local songlistheight = self:SonglistGetHeight();
	
	-- Set Song list Height
	self.songlistBox:SetHeight( songlistheight );
	
	-- Adjust Song list Left
	--self:AdjustSonglistLeft();
	
	-- Set Players list Height
	self.listboxPlayers:SetHeight( songlistheight - UI.hPlayerBtn );
	
	-- Set Song list Position
	local songlistpos = self.dirlistBox:GetHeight() + UI.sep.sMain;
	
	-- Adjust Song list Position
	self:AdjustSonglistPosition( songlistpos );
end

----------------------------
-- ZEDMOD: Get Min Height --
----------------------------
function SongbookWindow:GetMinHeight()
	local minheight = 0;
	if ( ( Settings.TracksVisible == "yes" ) and ( CharSettings.InstrSlots["visible"] == "no" ) ) then
		minheight = self.minHeight + 40 + UI.sep.sMain
	elseif ( ( Settings.TracksVisible == "yes" ) and ( CharSettings.InstrSlots["visible"] == "yes" ) ) then
		if ( self.bInstrumentsVisibleHForced == false ) then
			minheight = self.minHeight + 2 * 40 + 2 * UI.sep.sMain
		else
			minheight = self.minHeight + 40 + 50 + 2 * UI.sep.sMain
		end
	elseif ( ( Settings.TracksVisible == "no" ) and ( CharSettings.InstrSlots["visible"] == "yes" ) ) then
		if ( self.bInstrumentsVisibleHForced == false ) then
			minheight = self.minHeight + 10 + UI.sep.sMain
		else
			minheight = self.minHeight + 50 + UI.sep.sMain
		end
	else
		minheight = self.minHeight
	end
	return minheight;
end

---------------------------------
-- ZEDMOD: Get Dir list Height --
---------------------------------
function SongbookWindow:DirlistGetHeight()
	local dirlistheight = self.listContainer:GetHeight() - self.songlistBox:GetHeight() - 2 * UI.sep.sMain;
	if ( ( Settings.TracksVisible == "yes" ) and ( CharSettings.InstrSlots["visible"] == "no") ) then
		dirlistheight = dirlistheight - self.tracklistBox:GetHeight() - UI.sep.sMain;
	elseif ( ( Settings.TracksVisible == "yes" ) and ( CharSettings.InstrSlots["visible"] == "yes") ) then
		dirlistheight = dirlistheight - self.tracklistBox:GetHeight() - self.instrlistBox:GetHeight() - 2 * UI.sep.sMain;
	elseif ( ( Settings.TracksVisible == "no" ) and ( CharSettings.InstrSlots["visible"] == "yes") ) then
		dirlistheight = dirlistheight - self.instrlistBox:GetHeight() - UI.sep.sMain;
	end
	if ( ( self.bInstrumentsVisibleHForced == true ) and ( CharSettings.InstrSlots["visible"] == "yes" ) ) then
		dirlistheight = dirlistheight - UI.lb.sScrollbar;
	end
	if ( dirlistheight < 40 ) then
		dirlistheight = 40;
	end
	return dirlistheight;
end

----------------------------------
-- ZEDMOD: Get Song list Height --
----------------------------------
function SongbookWindow:SonglistGetHeight()
	local songlistheight = self.listContainer:GetHeight() - self.dirlistBox:GetHeight() - 2 * UI.sep.sMain;
	if ( ( Settings.TracksVisible == "yes" ) and ( CharSettings.InstrSlots["visible"] == "no") ) then
		songlistheight = songlistheight - self.tracklistBox:GetHeight() - UI.sep.sMain;
	elseif ( ( Settings.TracksVisible == "yes" ) and ( CharSettings.InstrSlots["visible"] == "yes") ) then
		songlistheight = songlistheight - self.tracklistBox:GetHeight() - self.instrlistBox:GetHeight() - 2 * UI.sep.sMain;
	elseif ( ( Settings.TracksVisible == "no" ) and ( CharSettings.InstrSlots["visible"] == "yes") ) then
		songlistheight = songlistheight - self.instrlistBox:GetHeight() - UI.sep.sMain;
	end
	if ( ( self.bInstrumentsVisibleHForced == true ) and ( CharSettings.InstrSlots["visible"] == "yes" ) ) then
		songlistheight = songlistheight - UI.lb.sScrollbar;
	end
	if ( songlistheight < 40 ) then
		songlistheight = 40;
	end
	return songlistheight;
end

-----------------------------------
-- ZEDMOD: Get Track list Height --
-----------------------------------
function SongbookWindow:TracklistGetHeight()
	local tracklistheight = self.listContainer:GetHeight() - self.dirlistBox:GetHeight() - self.songlistBox:GetHeight() - 3 * UI.sep.sMain;
	if ( CharSettings.InstrSlots["visible"] == "yes" ) then
		tracklistheight = tracklistheight - self.instrlistBox:GetHeight() - UI.sep.sMain;
	end
	if ( ( self.bInstrumentsVisibleHForced == true ) and ( CharSettings.InstrSlots["visible"] == "yes" ) ) then
		tracklistheight = tracklistheight - UI.lb.sScrollbar;
	end
	if ( tracklistheight < 40 ) then
		tracklistheight = 40;
	end
	return tracklistheight;
end

----------------------------------------
-- ZEDMOD: Get Instrument list Height --
----------------------------------------
function SongbookWindow:InstrlistGetHeight()
	local instrlistheight = self.listContainer:GetHeight() - self.dirlistBox:GetHeight() - self.songlistBox:GetHeight() - 3 * UI.sep.sMain;
	if ( Settings.TracksVisible == "yes" ) then
		instrlistheight = instrlistheight - self.tracklistBox:GetHeight() - UI.sep.sMain;
	end
	if ( ( instrlistheight < 40 ) or ( self.bInstrumentsVisibleHForced == true ) ) then
		instrlistheight = 40;
	end
	return instrlistheight;
end

---------------------------------------------------------------------
-- ZEDMOD: Set Main Window Elements Position after a window resize --
---------------------------------------------------------------------
function SongbookWindow:SetSBControls()
	--self.resizeCtrl:SetPosition( self:GetWidth() - 20, self:GetHeight() - 20 );
	self:MoveButtonRow() --self.btnSettings:SetPosition( self:GetWidth() / 2 - 55, self:GetHeight() - 30 );
	--self.cbFilters:SetPosition( self:GetWidth() / 2 + 65, self:GetHeight() - 30 );
	self.tipLabel:SetLeft( self:GetWidth() - 270 );
	--self.songTitle:SetWidth( self:GetWidth() - 50 ); -- ZEDMOD: OriginalBB
	self.songTitle:SetWidth( self:GetWidth() - 35 ); -- ZEDMOD;
	self.lblInstrAlert:SetWidth( -UI.indLeft + self:GetWidth( ) - 10 );
	self.lblInstrAlert:SetPosition( UI.indLeft, UI.yInstrAlert ); --yListFrame - 7
	self.lblInstr:SetWidth( -UI.indLeft + self:GetWidth( ) - 2 - 12 - UI.sep.sMain )
	self.lblInstr:SetPosition( 10, UI.listFrame.y - 3 ); -- yListFrame + 9
	self.instrSelDrop:SetPosition( UI.indLeft + 1 + self.lblInstr:GetWidth( ) + 2, UI.listFrame.y + 3 );
	self.lblTimer:SetPosition( UI.xCounter, UI.yCounter )
	--self.lblTimer:SetPosition( self:GetWidth() - 10 - self.lblTimer:GetWidth(), UI.listFrame.y - 28 )
end

--------------------------------------------------------------------------
-- ZEDMOD: Set List Frame and List Container size after a window resize --
--------------------------------------------------------------------------
function SongbookWindow:SetContainer()
	-- Set Lists Frame Size
	self.listFrame:SetSize( self:GetWidth() - self.lFXmod, self:GetHeight() - self.lFYmod );
	
	-- Set Lists Container Size
	self.listContainer:SetSize( self:GetWidth() - self.lCXmod, self:GetHeight() - self.lCYmod );
	
	-- Set List Frame Header Size
	self.listFrame.heading:SetSize( self.listFrame:GetWidth(), UI.listFrame.hHdg );
end

------------------------------------------------------------------------
-- ZEDMOD: Update Main Window Height and Position after window resize --
------------------------------------------------------------------------
function SongbookWindow:UpdateMainWindow( unallowedHeight )
	local newwindowHeight = self.listContainer:GetHeight() + unallowedHeight;
	self:SetHeight( newwindowHeight );
	self:SetSBControls();
	self.resizeCtrl:SetPosition( self:GetWidth() - 20, self:GetHeight() - 20 );
end

------------------------------------------
-- ZEDMOD: Update List Container Height --
------------------------------------------
function SongbookWindow:UpdateContainer( posrep )
	local newcontainerHeight = posrep;
	self.listContainer:SetHeight( newcontainerHeight );
end


----------------------------------------------------------------------------
-- Zed: Fix Local and Langue when FR/DE Lotro client switched in EN Language
-- Nim: Split up combined function 
----------------------------------------------------------------------------
function FixLocLangFormat( eFormat, floatValue )
	if ( eFormat ) then
		floatValue = string.gsub( floatValue, "%.", ",");
	else
		floatValue = string.gsub( floatValue, ",", ".");
	end
	return floatValue;
end

--------------
-- Callback --
--------------
-- Add Callback
function AddCallback( object, event, callback )
	if ( object[event] == nil ) then
		object[event] = callback;
	else
		if ( type( object[event] ) == "table" ) then
			table.insert( object[event], callback );
		else
			object[event] = { object[event], callback };
		end
	end
	return callback;
end

-- Remove Callback
function RemoveCallback( object, event, callback )
	if ( object[event] == callback ) then
		object[event] = nil;
	else
		if ( type( object[event] ) == "table" ) then
			local size = #object[event] --table.getn( object[event] );
			for i = 1, size do
				if ( object[event][i] == callback ) then
					table.remove( object[event], i );
					break;
				end
			end
		end
	end
end

