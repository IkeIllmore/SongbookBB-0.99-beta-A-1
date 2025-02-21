lang = "en";
Strings = {};
if ( Turbine.Shell.IsCommand("spielen") ) then
	lang = "de";
end
if ( Turbine.Shell.IsCommand("lire") ) then
	lang = "fr";
end
if ( lang == "en" ) then 
	Strings["cmd_music"] = "/music";
	Strings["cmd_play"] = "/play";
	Strings["cmd_ready"] = "/readycheck";
	Strings["cmd_start"] = "/playstart";
	Strings["cmd_sync"] = "sync";
	Strings["cmd_demo1_title"] = "Now playing";
	Strings["cmd_demo1_cmd"] = "/e is now playing %name";
	Strings["cmd_demo2_title"] = "Sync command to /f";
	Strings["cmd_demo2_cmd"] = "/f /play %file sync %part";
	Strings["cmd_demo3_title"] = "Paste filename";
	Strings["cmd_demo3_cmd"] = "/f %file";
	Strings["ui_filters"] = "Filters";
	Strings["ui_tags"] = "Tags";
	Strings["ui_dirs"] = "Dir: ";
	Strings["ui_songs"] = "Songs: ";
	Strings["ui_parts"] = "Parts: ";
	Strings["ui_instrs"] = "Instruments";
	Strings["ui_cmds"] = "Commands";
	Strings["ui_settings"] = "Settings";
	Strings["ui_search"] = "Search";
	Strings["ui_searchCurDir"] = "Search Dir";
	Strings["ui_clear"] = "Clear";
	Strings["ui_general"] = "General settings";
	Strings["ui_custom"] = "Custom commands";
	Strings["ui_save"] = "Save";
	Strings["ui_ok"] = "Ok";
	Strings["ui_cancel"] = "Cancel";
	Strings["ui_icon"] = "Songbook button settings";
	Strings["ui_instr"] = "Instrument slots settings";
	Strings["cb_parts"] = "Song part list visible";
	Strings["cb_search"] = "Search enabled";
	Strings["cb_desc"] = "Show song list description";
	Strings["cb_descfirst"] = "In first";
	Strings["cb_windowvis"] = "Window visible on load";
	Strings["cb_lastdir"] = "Remember Last Folder";
	Strings["cb_iconvis"] = "Songbook button visible";
	Strings["cb_instrvis"] = "Show Instruments";
	Strings["cb_instrvisHForced"] = "Horizontal"; -- ZEDMOD
	Strings["ui_btn_opacity"] = "Songbook button opacity";
	-- Badgers
	Strings["title"] = ": The Badger Z Chapter";
	Strings["filters"] = "Filters";
	Strings["filterParts"] = "#Parts";
	Strings["filterArtist"] = "Comp.";
	Strings["filterGenre"] = "Genre";
	Strings["filterMood"] = "Mood";
	Strings["filterAuthor"] = "Author";
	Strings["filterInstr"] = "Instr.";
	Strings["filterLength"] = "Length"
	Strings["filterUnknown"] = "Unknown filter"
	Strings["filterValid"] = "Valid search filters are: "
	Strings["chat_playBegin"] = "playing is about to begin";
	Strings["chat_playBeginSelf"] = "You begin playing ";
	Strings["chat_playReadyMsg"] = "(%a+) is ready to play \"(.+).\".*";
	Strings["chat_playSelfReadyMsg"] = "You are ready to play \"(.+).\".*";
	Strings["chat_playerJoin"] = " has joined your";
	Strings["chat_playerJoinSelf"] = " have joined a"; -- ZEDMOD
	Strings["chat_playerLeave"] = " has left your";
	Strings["chat_playerLeaveSelf"] = " leave your"; -- ZEDMOD
	Strings["chat_playerDismissSelf"] = "You dismiss ";
	Strings["chat_playerDismiss"] = " has been dismissed";
	Strings["chat_playerLinkDead"] = " has gone link dead"
	Strings["ui_badger"] = "Badger settings";
	Strings["cb_chief"] = "Chief mode";
	Strings["cb_solo"] = "Solo mode";
	Strings["cb_timer"] = "Show timer";
	Strings["cb_timerDown"] = "Count down";
	Strings["cb_rdyCol"] = "Sync column";
	Strings["cb_rdyColHL"] = "Highlighting";
	Strings["instr"] = "Required: ";
	Strings["playerlist"] = "Players list"; -- ZEDMOD
	Strings["players"] = "Players";
	-- Badgers additions for V095+ (auto assignment with instr. skills/preferences, instr. drop list, etc.)
	Strings["noSongsFoundInDir"] = "No matching songs found in folder '"
	Strings["noSongsFoundInSubDirs"] = "' (including sub-folders)."
	Strings["noSongsFound"] = "No matching songs found."
	Strings["noCurChar"] = "No current BB settings file found."
	Strings["loadCharBBz"] = "Using BBz version of CharSettings."
	Strings["loadCharBB"] = "Using BB version of CharSettings."
	Strings["noChar"] = "No CharSettings file found, using defaults."
	Strings["loadServerBBz"] = "Using BBz version of server settings."
	Strings["loadServerBB"] = "Using BB version of server settings."
	Strings["loadServerOrig"] = "Using original 0.92 version of server settings."
	Strings["noServer"] = "No settings file found, using defaults."
	Strings["cb_buttons"] = "Show all buttons";
	Strings["SongsReloadOk"] = "Song data reloaded."
	Strings["SongsReloadFail"] = "Could not load song data."
	Strings["SDOk"] = " Server: SongbookBB data saved.";
	Strings["SDFail"] = "(SongbookBB) Could not save server data: ";
	Strings["reloadBtn"] = "Reload song database";
	Strings["reloadMsg"] = "This will reload the song database without having to reload the Songbook plugin.\nNote that there will be a delay - watch for the message in the chat window.\n\nClick reload again to proceed, or anywhere outside this panel to close."
	Strings["overlenMsg1"] = "Due to a limit in the length of shortcut text, this announcement had to be split up into multiple parts.\n\nPlease click the Announce button "
	Strings["overlenMsg2"] = " times."
	Strings["autoSel"] = " Auto\n select"
	Strings["tt_autoSel"] = "Automatically select assigned song/part";
	Strings["informBtn"] = "Post Skills";
	Strings["assignBtn"] = "Assign...";
	Strings["assignWnd"] = "Parts Assignment";
	Strings["asnSkillsWnd"] = "Instrument Skills";
	Strings["assignPriosWnd"] = "Instrument Preferences";
	Strings["asnInstrWnd"] = "Instrument Definition";
	Strings["edit_skills"] = "Edit";
	Strings["receive_skills"] = "Receive";
	Strings["asn_list"] = "Parts List";
	Strings["asn_player"] = "Player";
	Strings["asn_part"] = "Part";
	Strings["asn_inactive"] = "(inactive)";
	Strings["asn_nextSong"] = "Next song";
	Strings["asn_chat"] = "Announce to";
	--Strings["asn_chat_auto"] = "Auto";
	Strings["asn_chat_group"] = "Group";
	Strings["asn_chat_raid"] = "Raid";
	Strings["asn_chat_custom"] = "Custom:";
	Strings["asn_btn_create"] = "Create";
	Strings["asnSk_btnLaunch"] = "Skills...";
	Strings["asnPrio_btnLaunch"] = "Preferences...";
	Strings["asn_btn_announce"] = "Announce";
	Strings["asn_removePartial"] = "Remove from partial announce"
	Strings["asn_addPartial"] = "Add to partial announce"
	Strings["asn_clearPartial"] = "Clear partial announcement"
	Strings["asn_include"] = "Include"
	Strings["asn_exclude"] = "Exclude"
	Strings["asn_clearExclusion"] = "Clear exclusions"
	Strings["asn_vocalist"] = "Vocalist"
	Strings["asn_clearVocalists"] = "Clear vocalists"
	Strings["asn_clearSelection"] = "Clear Selection"
	Strings["asn_assign"] = "Assign"
	Strings["asnSk_setcol"] = "Set all in column"; -- tick all checkboxes in the column
	Strings["asnSk_setall"] = "Set all"; -- tick all checkboxes
	Strings["asnSk_clrcol"] = "Clear all in column";
	Strings["asnSk_clrall"] = "Clear all";
	Strings["asnSk_clrsel"] = "Clear Selection";
	Strings["asnSk_copycol"] = "Copy column"
	Strings["asnSk_pastecol"] = "Paste column"
	Strings["asnSk_transfer"] = "Check Instrument Slots"
	Strings["asnSk_rejectcol"] = "Reject column changes"
	Strings["asnSk_acceptcol"] = "Accept column changes"
	Strings["asnSk_rejectall"] = "Reject all changes"
	Strings["asnSk_acceptall"] = "Accept all changes"
	Strings["asnSk_send"] = "Send to >"
	Strings["asnSk_wrongFormat"] = "Incorrect data string format received"
	Strings["asnSk_wrongVersion"] = "Possible version mismatch"
	Strings["asnSk_invalidData"] = "Invalid data received"
	Strings["asnSk_invalidHdr"] = "Invalid data header received"
	Strings["asnSk_noData"] = "No skill info available for "
	Strings["asn_prios_current"] = "Party/Raid";
	Strings["asn_prios_all"] = "Known players";
	Strings["asn_addPlayer"] = "Add player";
	Strings["asn_enterPlayer"] = "Enter player"
	Strings["asn_removePlayer"] = "Remove player";
	Strings["asn_removeSelPlayers"] = "Remove selected players";
	Strings["asn_notEnoughPlayers"] = "Not enough players available";
	Strings["asn_noSkillsSingular"] = "doesn't";
	Strings["asn_noSkillsPlural"] = "don't";
	Strings["asn_noSkillsEnding"] = " seem to have any suitable instrument skills for this song.";
	Strings["asn_noInstrument"] = "(No instrument detected)"
	Strings["asn_selSongSetup"] = "Please select a song (and a setup if available) in the main window."
	Strings["asn_noInstrDet"] = "No instrument detected in"
	Strings["asn_noSetupAvail"] = "No setup for the number of active players available."
	Strings["asn_needFsOrRaid"] = "You need to be in a fellowship or raid."
	Strings["asn_postSkills1"] = "This will scan your instrument quickslots and notify your group leader ("
	Strings["asn_postSkills2"] = ") of the instruments you can play, so they can do the instrument assignments."
	Strings["asn_postSkills3"] = "Click the 'Send' button to proceed."
	Strings["asn_asDone"] = "Assignment done."
	Strings["asn_asFail"] = "No assignment found"
	Strings["asn_asNoPlayers"] = "no player left for "
	Strings["bc_stats"] = "Show stats"
	Strings["bc_annStats"] = "Announce stats"
	Strings["sh_bctoggle"] = "bctoggle" -- biscuit counter toggle command
	Strings["sh_bcforall"] = "bcforall" -- biscuit counter active even if player isn't Lina
	Strings["sh_bcOnAnn"] = "bctrigger" -- change biscuit counter trigger (Create or Announce)
	Strings["bcTriggerCreate"] = "Biscuit counter now triggered on Create."
	Strings["bcTriggerAnn"] = "Biscuit counter now triggered on Announce."
	Strings["bcforall"] = "Biscuit counter for everybody!"
	Strings["bcforlina"] = "Biscuit counter for Lina only."
	Strings["maxLen"] = "maxlength"
	Strings["annLimit"] = "Announcement length limit is now "
	Strings["dbg_printSkillsCurrent"] = "Print instrument skills for group"
	Strings["dbg_printSkillsAll"] = "Print known instrument skills"
	Strings["dbg_printListCurrent"] = "Print instrument skill lists for group"
	Strings["dbg_printListAll"] = "Print known instrument skill lists"
	
	-- ZEDMOD: Add New Instruments ( Fiddle and Bassoon )
	-- doubling word fiddle because german got two word as fiedel and giese
	-- (Nim) Removed doubled fiddle and made Fiedel and Geige synonyms
	--aInstrumentsLoc = { "bagpipe", "clarinet", "cowbell", "drum", "flute", "harp", "horn", "lute", "pibgorn", "theorbo" }; -- Original
	ILang =
	{
		aLocNames =
		{	-- (Nim) Removed the doubled base entry for fiddle: German Geige is now a syn for Fiedel
		--"bagpipe", "bassoon", "clarinet", "cowbell", "drum", "fiddle", "fiddle", "flute", "harp", "horn", "lute", "pibgorn", "theorbo"
			"bagpipe", "bassoon", "clarinet", "cowbell", "drum", "fiddle", "flute", "harp", "horn", "lute", "pibgorn", "theorbo"
		},
		-- /ZEDMOD
		-- ZEDMOD: Additonnal Instruments to distinguish between basic and specifics
		aVariantsBassoon = { "basic bassoon", "lonely mountain bassoon", "brusque bassoon" },
		aVariantsFiddle = { "basic fiddle", "student's fiddle", "traveller's trusty fiddle", "sprightly fiddle", "lonely mountain fiddle", "bardic fiddle" },
		aVariantsHarp = { "basic harp", "misty mountain harp" },
		aVariantsLute = { "basic lute", "lute of ages" },
		aVariantsCowbell = { "basic cowbell", "moor cowbell"},
		-- /ZEDMOD
		aVariants =
		{
			bassoon = { "basic bassoon", "lonely mountain bassoon", "brusque bassoon" },
			fiddle = { "basic fiddle", "student's fiddle", "traveller's trusty fiddle", "sprightly fiddle", "lonely mountain fiddle", "bardic fiddle" },
			harp = { "basic harp", "misty mountain harp" },
			lute = { "basic lute", "lute of ages" },
			cowbell = { "basic cowbell", "moor cowbell"},
		},
	
		aSynonyms =
		{	-- type detection
			lute = { "loa", "lute oa", "luteoa" },
			fiddle = { "lmfiddle", "ttfiddle", "bardic fiddle" }, 
			bassoon = { "lmbassoon" },
			drum = { "drums" },
			bagpipe = { "bagpipes" },
			clarinet = { "cla" },
			harp = { "satakieli", "gl�owine�s harp", "mmharp" },
			flute = { "simple pipe", "crafted pipe", "superior pipe" },
			-- variant detection
			["lute of ages"] = { "loa", "lute oa", "luteoa" },
			["lonely mountain fiddle"] = { "lm fiddle", "lmfiddle" },--, "summer celebration fiddle" },
			--["summer celebration fiddle"] = { "lonely mountain fiddle" }, --HACK
			["traveller's trusty fiddle"] = { "tt fiddle", "ttfiddle" },
			["lonely mountain bassoon"] = { "lm bassoon", "lmbassoon" },
			["misty mountain harp"] = { "mm harp", "mmharp" },
		},
		aAbbrev = 
		{	-- instr - list of abbreviations

			["lute of ages"] = { vars = { "lute oa", "luteoa", "loa" }, ["type"]="lute" },
			["lonely mountain fiddle"] = { vars = { "summer celebration fiddle", "lm fiddle", "lmfiddle" }, ["type"]="fiddle" },
			["traveller's trusty fiddle"] = { vars = { "tt fiddle", "ttfiddle" }, ["type"]="fiddle" },
			["bardic fiddle"] = { vars = { "b fiddle", "bfiddle" }, ["type"]="fiddle" },
			["student's fiddle"] = { vars = { "studentfiddle", "s fiddle", "sfiddle" }, ["type"]="fiddle" },
			["lonely mountain bassoon"] = { vars = { "lm bassoon", "lmbassoon" }, ["type"]="bassoon" },
			["misty mountain harp"] = { vars = { "mm harp", "mmharp" }, ["type"]="harp" },
			["drums"] = { vars = { "drum" }, ["type"]="drum" },
			["bagpipes"] = { vars = { "bagpipe" }, ["type"]="bagpipe" },
			["clarinet"] = { vars = { "cla" }, ["type"]="clarinet" },
			["flute"] = { vars = { "simple pipe", "crafted pipe", "superior pipe" }, ["type"]="flute" },
			["moor cowbell"] = { vars = { "moorcowbell", "m cowbell", "mcowbell" }, ["type"]="cowbell" },
			-- special instruments that need remapping:
			["basic harp"] = { vars = { "satakieli", "gl�owine�s harp" }, ["type"]="harp" },
		},
		aMapping = 
		{	-- instr/abbrev - full name and type
			["lute of ages"] = { name="lute of ages", ["type"]="lute" },
			["loa"] = { name="lute of ages", ["type"]="lute" },
			["lute oa"] = { name="lute of ages", ["type"]="lute" },
			["luteoa"] = { name="lute of ages", ["type"]="lute" },
			["lonely mountain fiddle"] = { name="lonely mountain fiddle", ["type"]="fiddle" },
			["lmfiddle"] = { name="lonely mountain fiddle", ["type"]="fiddle" },
			["lm fiddle"] = { name="lonely mountain fiddle", ["type"]="fiddle" },
			["traveller's trusty fiddle"] = { name="traveller's trusty fiddle", ["type"]="fiddle" },
			["ttfiddle"] = { name="traveller's trusty fiddle", ["type"]="fiddle" },
			["tt fiddle"] = { name="traveller's trusty fiddle", ["type"]="fiddle" },
			["bardic fiddle"] = { name="bardic fiddle", ["type"]="fiddle" },
			["bfiddle"] = { name="bardic fiddle", ["type"]="fiddle" },
			["student's fiddle"] = { name="student's fiddle", ["type"]="fiddle" },
			["sfiddle"] = { name="student's fiddle", ["type"]="fiddle" },
			["studentfiddle"] = { name="student's fiddle", ["type"]="fiddle" },
			["lonely mountain bassoon"] = { name="lonely mountain bassoon", ["type"]="bassoon" },
			["lmbassoon"] = { name="lonely mountain bassoon", ["type"]="bassoon" },
			["lm bassoon"] = { name="lonely mountain bassoon", ["type"]="bassoon" },
			["drums"] = { name="drum", ["type"]="drum" },
			["bagpipes"] = { name="bagpipe", ["type"]="bagpipe" },
			["cla"] = { name="clarinet", ["type"]="clarinet" },
			["misty mountain harp"] = { name="misty mountain harp", ["type"]="harp" },
			["mmharp"] = { name="misty mountain harp", ["type"]="harp" },
			["mm harp"] = { name="misty mountain harp", ["type"]="harp" },
			["simple pipe"] = { name="flute", ["type"]="flute" },
			["crafted pipe"] = { name="flute", ["type"]="flute" },
			["superior pipe"] = { name="flute", ["type"]="flute" },
			["rowan bow"] = { name="lonely mountain fiddle", ["type"]="fiddle" },
			["moor cowbell"] = { name="moor cowbell", ["type"]="cowbell" },
			["mcowbell"] = { name="moor cowbell", ["type"]="cowbell" },
			-- ["bagpipe"] = { name="bagpipe", ["type"]="bagpipe" },
			-- ["bassoon"] = { name="bassoon", ["type"]="bassoon" },
			-- ["clarinet"] = { name="clarinet", ["type"]="clarinet" },
			-- ["cowbell"] = { name="cowbell", ["type"]="cowbell" },
			-- ["drum"] = { name="drum", ["type"]="drum" },
			-- ["fiddle"] = { name="fiddle", ["type"]="fiddle" },
			-- ["flute"] = { name="flute", ["type"]="flute" },
			-- ["harp"] = { name="harp", ["type"]="harp" },
			-- ["horn"] = { name="horn", ["type"]="horn" },
			-- ["lute"] = { name="lute", ["type"]="lute" },
			-- ["pibgorn"] = { name="pibgorn", ["type"]="pibgorn" },
			-- ["theorbo"] = { name="theorbo", ["type"]="theorbo" },
			["satakieli"] = { name="basic harp", ["type"]="harp" },
			["gl�owine�s harp"] = { name="basic harp", ["type"]="harp" },
			["summer celebration fiddle"] = { name="lonely mountain fiddle", ["type"]="fiddle" },
			--["basic bassoon"] = { name="lonely mountain fiddle", ["type"]="fiddle" },
		},
		-- aSpecials =
		-- {
		-- 	["gl�owine�s harp"] = IMap.Id["harp"],
		-- 	["satakieli"] = IMap.Id["harp"],
		-- 	["simple pipe"] = IMap.Id["flute"], -- mariner instruments (associated skill is flute)
		-- 	["crafted pipe"] = IMap.Id["flute"],
		-- 	["superior pipe"] = IMap.Id["flute"],
		-- },
	}

	-- /Badgers
	Strings["ui_clr_slots"] = "Clear slots";
	Strings["ui_add_slot"] = "Add";
	Strings["ui_del_slot"] = "Remove";
	Strings["ui_cus_add"] = "Add";
	Strings["ui_cus_edit"] = "Edit";
	Strings["ui_cus_del"] = "Remove";
	Strings["ui_cus_winadd"] = "Add Command";
	Strings["ui_cus_winedit"] = "Edit Command";
	Strings["ui_cus_title"] = "Title:";
	Strings["ui_cus_command"] = "Command:";
	Strings["ui_cus_help"] = "Command aliases:\n\n%name - song/part name\n%file - filename\n%part - part number";
	Strings["ui_cus_err"] = "Please enter Title and Command";
	Strings["tt_music"] = "Toggle music mode";
	Strings["tt_play"] = "Play song";
	Strings["tt_ready"] = "Make a ready check";
	Strings["tt_sync"] = "Play with sync";
	Strings["tt_start"] = "Start sync play";
	Strings["tt_parts"] = "Parts display on/off";
	Strings["sh_saved"] = "Songbook settings saved.";
	Strings["sh_notsaved"] = "Songbook failed to save settings";
	Strings["sh_show"] = "show";
	Strings["sh_hide"] = "hide";
	Strings["sh_toggle"] = "toggle";
	Strings["sh_help1"] = gPlugin .. " show: Display Songbook Window";
	Strings["sh_help2"] = gPlugin .. " hide: Hide Songbook Window";
	Strings["sh_help3"] = gPlugin .. " toggle: Toggle Songbook Window";
	Strings["err_nosongs"] = "The song library is empty. Make sure you have abc files in your Music directory and run the songbook.hta file to build the library. Then, reload the plugin.\n\nIf you upgraded from a previous version, run first the new songbook.hta before loading the plugin.";
elseif ( lang == "de" ) then
	--Turbine.Shell.WriteLine("2. SongbookLang.lua : lang = de");
	Strings["cmd_music"] = "/musik";
	Strings["cmd_play"] = "/spielen";
	Strings["cmd_ready"] = "/bereitschaftspr�fung";
	Strings["cmd_start"] = "/spielstart";
	Strings["cmd_sync"] = "sync";
	Strings["cmd_e"] = "/e";
	Strings["cmd_f"] = "/g";
	Strings["cmd_demo1_title"] = "Emote mit dem Liedtitel";
	Strings["cmd_demo1_cmd"] = "/e spielt %name";
	Strings["cmd_demo2_title"] = "Sync-Befehl an Gruppe senden";
	Strings["cmd_demo2_cmd"] = "/g /spielen %file sync %part";
	Strings["cmd_demo3_title"] = "Dateiname an Gruppe senden";
	Strings["cmd_demo3_cmd"] = "/g %file";
	Strings["ui_dirs"] = "Verzeichnisse: ";
	Strings["ui_songs"] = "Lieder: ";
	Strings["ui_parts"] = "Teile: ";
	Strings["ui_instrs"] = "Instrumenten";
	Strings["ui_cmds"] = "Befehle";
	Strings["ui_settings"] = "Einstellungen";
	Strings["ui_search"] = "Suchen";
	Strings["ui_clear"] = "Leeren";
	Strings["ui_general"] = "Allgemeine Einstellungen";
	Strings["ui_custom"] = "Benutzerdefinierte Befehle";
	Strings["ui_save"] = "Speichern";
	Strings["ui_ok"] = "Ok";
	Strings["ui_cancel"] = "Abbrechen";
	Strings["ui_icon"] = "Songbookknopf Einstellungen";
	Strings["ui_instr"] = "Instrumentenleiste Einstellungen";
	Strings["cb_parts"] = "Liste mit Liedteilen anzeigen";
	Strings["cb_search"] = "Suche erlauben";
	Strings["cb_desc"] = "Beschreibung Liedliste anzeigen";
	Strings["cb_descfirst"] = "Zuerst";
	Strings["cb_windowvis"] = "Fenster beim Start anzeigen";
	Strings["cb_lastdir"] = "Letzten Ordner merken";
	Strings["cb_iconvis"] = "Songbookknopf anzeigen";
	Strings["cb_instrvis"] = "Instrumente anzeigen";
	Strings["cb_instrvisHForced"] = "Horizontale"; -- ZEDMOD
	Strings["ui_btn_opacity"] = "Songbookknopf Sichtbarkeit";
	-- Badgers additions for V0.94+ (players list, ready state indication, filters, etc.)
	Strings["title"] = ": Das Z Badger-Kapitel";
	Strings["filters"] = "Filter";
	Strings["filterParts"] = "#Spieler";
	Strings["filterArtist"] = "K\195\188nstler";
	Strings["filterGenre"] = "Genre";
	Strings["filterMood"] = "Stimmung";
	Strings["filterAuthor"] = "Autor";
	Strings["filterInstr"] = "Instr";
	Strings["filterLength"] = "Dauer"
	Strings["chat_playBegin"] = "Synchronisiertes Spiel beginnt bald.";
	Strings["chat_playBeginSelf"] = "Du spielst ";
	Strings["chat_playReadyMsg"] = "(%a+) ist bereit \"(.+)\" zu spielen";
	Strings["chat_playSelfReadyMsg"] = "\"(.+)\" kann nun gespielt werden";
	Strings["chat_playerJoin"] = " hat sich Eure";
	Strings["chat_playerJoinSelf"] = " habt Euch einer Gruppe"; -- ZEDMOD
	Strings["chat_playerLeave"] = " hat Eure";
	Strings["chat_playerLeaveSelf"] = " verlasst Eure Gruppe"; -- ZEDMOD
	Strings["chat_playerDismissSelf"] = "You dismiss ";
	Strings["chat_playerDismiss"] = " has been dismissed";
	Strings["chat_playerLinkDead"] = " has gone link dead from"
	Strings["ui_badger"] = "Badger-Einstellungen";
	Strings["cb_chief"] = "Bandleader";
	Strings["cb_solo"] = "Solo-modus";
	Strings["cb_timer"] = "Laufzeit";
	Strings["cb_timerDown"] = "R\195\188ckw\195\164rts";
	Strings["cb_rdyCol"] = "Sync-Spalte";
	Strings["cb_rdyColHL"] = "Sync-Hervorhebung";
	Strings["instr"] = "Ben\195\182tigt: ";
	Strings["playerlist"] = "Spielerliste"; -- ZEDMOD
	Strings["players"] = "Spieler";
	-- Neue Strings fuer Badgers-Version V095+ (automatische Stimmzuweisung mit Faehigkeiten/Vorlieben, Auswahlliste, etc.)
	Strings["noCurChar"] = "Keine aktuelle BB Konfigurationsdatei gefunden."
	Strings["loadCharBBz"] = "Lade BBz-Version der Charakter-Konfiguration."
	Strings["loadCharBB"] = "Lade BB-Version der Charakter-Konfiguration."
	Strings["noChar"] = "Keine Charakter-Konfigurationsdatei gefunden, verwende Grundeinstellungen."
	Strings["loadServerBBz"] = "Lade BBz-Version der Server-Konfiguration."
	Strings["loadServerBB"] = "Lade BB-Version der Server-Konfiguration."
	Strings["loadServerOrig"] = "Lade originale 0.92 Version der Server-Konfiguration."
	Strings["noServer"] = "Keine Server-Konfiguration gefunden, verwende Grundeinstellungen."
	Strings["cb_buttons"] = "Alle Schaltfl\195\164chen anzeigen";
	Strings["SongsReloadOk"] = "Lieder-Datenbank geladen."
	Strings["SongsReloadFail"] = "Lieder-Datenbank konnte nicht geladen werden."
	Strings["SDOk"] = " Server: SongbookBB-Konfiguration gespeichert.";
	Strings["SDFail"] = " Server: SongbookBB-Konfiguration konnte nicht gespeichert werden: ";
	Strings["reloadBtn"] = "Lieder neu laden";
	Strings["reloadMsg"] = "Hiermit wird die Lieder-Datenbank neu geladen, ohne Songbook schlie\195\159en zu m\195\188ssen.\nNach erfolgtem Laden erscheint eine entsprechende Nachricht im Chatfenster.\n\nBitte zum Fortfahren Schaltfl\195\164che nochmal klicken, oder irgendwo au\195\159erhalb des dieses Textfensters zum schlie\195\159en."
	Strings["overlenMsg"] = "Max. Shortcut-L\195\164nge \195\188berschritten, bitte zweimal hintereinander klicken."
	Strings["tt_autoSel"] = "Automatisch zugewiesenes Lied/Stimme ausw\195\164hlen";
	Strings["autoSel"] = " Autom.\n Auswahl"
	Strings["informBtn"] = "Post Skills";
	Strings["assignBtn"] = "Zuweisen...";
	Strings["assignWnd"] = "Stimmzuweisung";
	Strings["asnSkillsWnd"] = "Instrument-F\195\164higkeiten";
	Strings["assignPriosWnd"] = "Instrument-Vorlieben";
	Strings["asnInstrWnd"] = "Instrumentverwaltung";
	Strings["edit_skills"] = "\195\132ndern";
	Strings["receive_skills"] = "Empfangen";
	Strings["asn_list"] = "Stimmen";
	Strings["asn_player"] = "Spieler";
	Strings["asn_part"] = "Stimme";
	Strings["asn_inactive"] = "(inaktiv)";
	Strings["asn_nextSong"] = "N\195\164chstes Lied";
	Strings["asn_chat"] = "Bekanntgeben in";
	--Strings["asn_chat_auto"] = "Auto";
	Strings["asn_chat_group"] = "Gruppe";
	Strings["asn_chat_raid"] = "Raid";
	Strings["asn_chat_custom"] = "andere:";
	Strings["asn_btn_create"] = "Anlegen";
	Strings["asnSk_btnLaunch"] = "F\195\164higkeiten...";
	Strings["asnPrio_btnLaunch"] = "Vorlieben...";
	Strings["asn_btn_announce"] = "Bekanntgeben";
	Strings["asn_removePartial"] = "Aus individueller Bekanntgabe entfernen"
	Strings["asn_addPartial"] = "Zu individueller Bekanntgabe hinzuf\195\188gen"
	Strings["asn_clearPartial"] = "Individuelle Bekanntgabe l\195\182schen"
	Strings["asn_include"] = "Einschlie\195\159en"
	Strings["asn_exclude"] = "Ausschlie\195\159en"
	Strings["asn_clearExclusion"] = "Ausschl\195\188sse entfernen"
	Strings["asn_vocalist"] = "Singstimme (keine Blasinstrumente)"
	Strings["asn_clearVocalists"] = "Singstimmen entfernen"
	Strings["asn_clearSelection"] = "Auswahl aufheben"
	Strings["asn_assign"] = "Zuweisen"
	Strings["asnSk_setcol"] = "Alle in Spalte ankreuzen"; -- tick all checkboxes in the column
	Strings["asnSk_setall"] = "Alle ankreuzen"; -- tick all checkboxes
	Strings["asnSk_clrcol"] = "Alle in Spalte abw\195\164hlen";
	Strings["asnSk_clrall"] = "Alle abw\195\164hlen";
	Strings["asnSk_clrsel"] = "Auswahl aufheben";
	Strings["asnSk_copycol"] = "Spalte kopieren"
	Strings["asnSk_pastecol"] = "Spalte einf\195\188gen"
	Strings["asnSk_transfer"] = "Ankreuzen entsprechend Instrumentenleiste"
	Strings["asnSk_rejectcol"] = "\195\132nderungen in Spalte verwerfen"
	Strings["asnSk_acceptcol"] = "\195\132nderungen in Spalte \195\188bernehmen"
	Strings["asnSk_rejectall"] = "Alle \195\132nderungen verwerfen"
	Strings["asnSk_acceptall"] = "Alle \195\132nderungen \195\188bernehmen"
	Strings["asnSk_send"] = "Senden an >"
	Strings["asnSk_wrongFormat"] = "Daten in falschem Format empfangen"
	Strings["asnSk_wrongVersion"] = "Eventuell nicht \195\188bereinstimmende Versionen"
	Strings["asnSk_invalidData"] = "Ung\195\188ltige Daten empfangen"
	Strings["asnSk_invalidHdr"] = "Ung\195\188ltige Datenkennung empfangen"
	Strings["asnSk_noData"] = "Keine F\195\164higkeiten bekannt f\195\188r "
	Strings["asn_prios_current"] = "Gruppe/Raid";
	Strings["asn_prios_all"] = "Bekannte Spieler";
	Strings["asn_addPlayer"] = "Spieler hinzuf\195\188gen";
	Strings["asn_enterPlayer"] = "Spieler eingeben"
	Strings["asn_removePlayer"] = "Spieler entfernen";
	Strings["asn_removeSelPlayers"] = "Ausgew\195\164hlte Spieler entfernen";
	Strings["asn_notEnoughPlayers"] = "Zu wenige Spieler";
	Strings["asn_noSkillsSingular"] = "hat";
	Strings["asn_noSkillsPlural"] = "haben";
	Strings["asn_noSkillsEnding"] = " keine passenden Instrumenten-F\195\164higkeiten f\195\188r dieses Lied.";
	Strings["asn_noInstrument"] = "(kein Instrument erkannt)"
	Strings["asn_selSongSetup"] = "Bitte im Hauptfenster ein Lied (und eine Besetzung, falls vorhanden) ausw\195\164hlen."
	Strings["asn_noInstrDet"] = "Kein Instrument erkannt in"
	Strings["asn_noSetupAvail"] = "Keine Besetzung f\195\188r die momentane Anzahl Spieler gefunden."
	Strings["asn_needFsOrRaid"] = "Sie mf\195\188rssen daf\195\188r in einer Gruppe/einem Raid sein."
	Strings["asn_postSkills1"] = "Hiermit werden die Instrumente in der Instrumentenleiste als F\195\164higkeiten an den/die Leiter/in ("
	Strings["asn_postSkills2"] = ") gesendet, um die automatische Stimmzuweisung zu erm\195\182glichen."
	Strings["asn_postSkills3"] = "Bitte die Senden-Schaltfl\195\164che anklicken, um obiges durchzuf\195\188hren."
	Strings["asn_asDone"] = "Zuweisung erstellt."
	Strings["asn_asFail"] = "Keine geeignete Zuweisung gefunden"
	Strings["asn_asNoPlayers"] = "kein Spieler mehr f\195\188r "

-- ZEDMOD: Add New Instruments ( Fiddle and Bassoon )
	--aInstrumentsLoc = { "dudelsack", "klarinette", "glocke", "trommel", "fl\195\182te", "harfe", "horn", "laute", "pibgorn", "theorbe" }; -- Original
	ILang.aLocNames =
	{	-- removed the separate entry for Geige, which is now a syn
	--"dudelsack", "fagott", "klarinette", "glocke", "trommel", "fiedel", "geige", "flote", "harfe", "horn", "laute", "pibgorn", "theorbe"
		"dudelsack", "fagott", "klarinette", "glocke", "trommel", "fiedel", "flote", "harfe", "horn", "laute", "pibgorn", "theorbe"
	};
	-- /ZEDMOD
	-- ZEDMOD: Additonnal Instruments to distinguish between basic and specifics
	ILang.aVariantsBassoon = { "standard-fagott", "fagott vom einsamen berg", "schroffes fagott" };
	ILang.aVariantsFiddle = { "standard-fiedel", "schulerfiedel", "geige des reisenden", "muntere geige", "geige vom einsamen berg", "barden geige" };
	ILang.aVariantsHarp = { "standard-harfe", "harfe des nebelgebirges" };
	ILang.aVariantsLute = { "standard-laute", "laute vergangener zeiten" };
	ILang.aVariantsCowbell = { "standard-glocke", "moorkuh glocke "};
	-- /ZEDMOD
	-- /Badgers
	Strings["ui_clr_slots"] = "Leiste leeren";
	Strings["ui_add_slot"] = "Hinzuf\195\188gen";
	Strings["ui_del_slot"] = "Entfernen";
	Strings["ui_cus_add"] = "Hinzuf\195\188gen";
	Strings["ui_cus_edit"] = "Editieren";
	Strings["ui_cus_del"] = "Entfernen";
	Strings["ui_cus_winadd"] = "Befehl einf\195\188gen";
	Strings["ui_cus_winedit"] = "Befehl editieren";
	Strings["ui_cus_title"] = "Titel:";
	Strings["ui_cus_command"] = "Befehl:";
	Strings["ui_cus_help"] = "Befehl aliase:\n\n%name - Lied/Liedteilname\n%file - Dateiname\n%part - Liedteilnummer";
	Strings["ui_cus_err"] = "Bitte Titel und Befehl eingeben";
	Strings["tt_music"] = "Musikmodusschalter";
	Strings["tt_play"] = "Lied abspielen";
	Strings["tt_ready"] = "Bereitschaftskontrolle";
	Strings["tt_sync"] = "Spielen mit sync";
	Strings["tt_start"] = "Spielstart";
	Strings["tt_parts"] = "Teile anzeigen an/aus";
	Strings["sh_saved"] = "Songbookeinstellungen gesichert.";
	Strings["sh_notsaved"] = "Songbook konnte die Einstellungen nicht sichern";
	Strings["sh_show"] = "anzeigen";
	Strings["sh_hide"] = "verstecken";
	Strings["sh_toggle"] = "umschalten";
	Strings["sh_help1"] = gPlugin .. " anzeigen: Songbookfenster anzeigen";
	Strings["sh_help2"] = gPlugin .. " verstecken: Songbookfenster verstecken";
	Strings["sh_help3"] = gPlugin .. " umschalten: Songbookfenster ein/aus";
	Strings["err_nosongs"] = "Keine Lieder gefunden. Du musst im '/music'-Ordner ABC-Dateien haben und mindestens einmal die songbook.hta ausf\195\188hren. Danach bitte Plugin neu laden.\n\nBei neuer Version des Plugins, starte die neue songbook.hta um die Datenbank neu zu erstellen.";
elseif ( lang == "fr" ) then
	--Turbine.Shell.WriteLine("2. SongbookLang.lua : lang = fr");
	Strings["cmd_music"] = "/musique";
	Strings["cmd_play"] = "/lire";
	Strings["cmd_ready"] = "/voirpr�t";
	Strings["cmd_start"] = "/d�butmusique";
	Strings["cmd_sync"] = "synchro";
	Strings["cmd_e"] = "/e";
	Strings["cmd_f"] = "/f";
	Strings["cmd_demo1_title"] = "Jou\195\169 actuellement";
	Strings["cmd_demo1_cmd"] = "/e joue actuellement %name";
	Strings["cmd_demo2_title"] = "Commande synchro vers /comm";
	Strings["cmd_demo2_cmd"] = "/comm /lire %file sync %part";
	Strings["cmd_demo3_title"] = "Coller nom du fichier";
	Strings["cmd_demo3_cmd"] = "/comm %file";
	Strings["ui_dirs"] = "R\195\169pertoires: ";
	Strings["ui_songs"] = "Chansons: ";
	Strings["ui_parts"] = "Partitions: ";
	Strings["ui_instrs"] = "Instruments";
	Strings["ui_cmds"] = "Commandes";
	Strings["ui_settings"] = "Param\195\168tres";
	Strings["ui_search"] = "Recherche";
	Strings["ui_clear"] = "Vider";
	Strings["ui_general"] = "Param\195\168tres G\195\169n\195\169raux";
	Strings["ui_custom"] = "Commandes Perso";
	Strings["ui_save"] = "Sauver";
	Strings["ui_ok"] = "Ok";
	Strings["ui_cancel"] = "Annuler";
	Strings["ui_icon"] = "Param\195\168tres Bouton SongBook";
	Strings["ui_instr"] = "Param\195\168tres Liste Instruments";
	Strings["cb_parts"] = "Liste Partitions Visible";
	Strings["cb_search"] = "Recherche activ\195\169e";
	Strings["cb_desc"] = "Description liste chansons";
	Strings["cb_descfirst"] = "En premier";
	Strings["cb_windowvis"] = "Fen\195\170tre visible au chargement";
	Strings["cb_lastdir"] = "Souvenir dernier dossier";
	Strings["cb_iconvis"] = "Bouton SongBook visible";
	Strings["cb_instrvis"] = "Instruments Visibles";
	Strings["cb_instrvisHForced"] = "Horizontal"; -- ZEDMOD
	Strings["ui_btn_opacity"] = "Opacit\195\169 du bouton Songbook";
	-- Badgers
	Strings["title"] = ": The Badger Z Chapter";
	Strings["filters"] = "Filtres";
	Strings["filterParts"] = "#Joueurs";
	Strings["filterArtist"] = "Artiste";
	Strings["filterGenre"] = "Style";
	Strings["filterMood"] = "Ambiance";
	Strings["filterAuthor"] = "Auteur";
	Strings["filterInstr"] = "Instr.";
	Strings["chat_playBegin"] = "La lecture synchronis\195\169e va commencer";
	Strings["chat_playBeginSelf"] = "Vous commencez � jouer ";
	Strings["chat_playReadyMsg"] = "(%a+) va jouer \"(.+).\".*";
	Strings["chat_playSelfReadyMsg"] = "Vous allez jouer \"(.+).\".*";
	Strings["chat_playerJoin"] = " a rejoint votre ";
	Strings["chat_playerJoinSelf"] = " avez rejoint une"; -- ZEDMOD
	Strings["chat_playerLeave"] = " a quitt\195\169 votre ";
	Strings["chat_playerLeaveSelf"] = " quittez votre "; -- ZEDMOD
	Strings["chat_playerDismissSelf"] = "You dismiss ";
	Strings["chat_playerDismiss"] = " has been dismissed";
	Strings["chat_playerLinkDead"] = " has gone link dead from"
	Strings["ui_badger"] = "Param\195\168tres Badger";
	Strings["cb_chief"] = "Mode Chef";
	Strings["cb_solo"] = "Mode solo";
	Strings["cb_timer"] = "Voir compteur";
	Strings["cb_timerDown"] = "D\195\169compter";
	Strings["cb_rdyCol"] = "Colonne Synch"; -- Note: This needs to be rather short (two checkboxes on the same line)
	Strings["cb_rdyColHL"] = "Surbrillance";
	Strings["instr"] = "Requis: ";
	Strings["playerlist"] = "Liste Musiciens"; -- ZEDMOD
	Strings["players"] = "Musiciens";
	-- Badgers additions for V095+ (auto assignment with instr. skills/preferences, instr. drop list, etc.)
	Strings["noCurChar"] = "No current BB settings file found."
	Strings["loadCharBBz"] = "Using BBz version of CharSettings."
	Strings["loadCharBB"] = "Using BB version of CharSettings."
	Strings["noChar"] = "No CharSettings file found, using defaults."
	Strings["loadServerBBz"] = "Using BBz version of server settings."
	Strings["loadServerBB"] = "Using BB version of server settings."
	Strings["loadServerOrig"] = "Using original 0.92 version of server settings."
	Strings["noServer"] = "No settings file found, using defaults."
	Strings["cb_buttons"] = "Show all buttons";
	Strings["SongsReloadOk"] = "Song data reloaded."
	Strings["SongsReloadFail"] = "Could not load song data."
	Strings["SDOk"] = " Server: SongbookBB data saved.";
	Strings["SDFail"] = "(SongbookBB) Could not save server data: ";
	Strings["reloadBtn"] = "Reload song database";
	Strings["reloadMsg"] = "This will reload the song database without having to reload the Songbook plugin.\nNote that there will be a delay - watch for the message in the chat window.\n\nClick reload again to proceed, or anywhere outside this panel to close."
	Strings["overlenMsg"] = "Two part announcement due to shortcut-length limit, please click the announce-button a second time."
	Strings["tt_autoSel"] = "Automatically select assigned song/part";
	Strings["autoSel"] = " Auto\n select"
	Strings["informBtn"] = "Post Skills";
	Strings["assignBtn"] = "Assign...";
	Strings["assignWnd"] = "Parts Assignment";
	Strings["asnSkillsWnd"] = "Instrument Skills";
	Strings["assignPriosWnd"] = "Instrument Preferences";
	Strings["asnInstrWnd"] = "Instrument Definition";
	Strings["edit_skills"] = "Edit";
	Strings["receive_skills"] = "Receive";
	Strings["asn_list"] = "Parts List";
	Strings["asn_player"] = "Player";
	Strings["asn_part"] = "Part";
	Strings["asn_inactive"] = "(inactive)";
	Strings["asn_nextSong"] = "Next song";
	Strings["asn_chat"] = "Announce to";
	--Strings["asn_chat_auto"] = "Auto";
	Strings["asn_chat_group"] = "Group";
	Strings["asn_chat_raid"] = "Raid";
	Strings["asn_chat_custom"] = "Custom:";
	Strings["asn_btn_create"] = "Create";
	Strings["asnSk_btnLaunch"] = "Skills...";
	Strings["asnPrio_btnLaunch"] = "Preferences...";
	Strings["asn_btn_announce"] = "Announce";
	Strings["asn_removePartial"] = "Remove from partial announce"
	Strings["asn_addPartial"] = "Add to partial announce"
	Strings["asn_clearPartial"] = "Clear partial announcement"
	Strings["asn_include"] = "Include"
	Strings["asn_exclude"] = "Exclude"
	Strings["asn_clearExclusion"] = "Clear exclusions"
	Strings["asn_vocalist"] = "Vocalist"
	Strings["asn_clearVocalists"] = "Clear vocalists"
	Strings["asn_clearSelection"] = "Clear Selection"
	Strings["asn_assign"] = "Assign"
	Strings["asnSk_setcol"] = "Set all in column"; -- tick all checkboxes in the column
	Strings["asnSk_setall"] = "Set all"; -- tick all checkboxes
	Strings["asnSk_clrcol"] = "Clear all in column";
	Strings["asnSk_clrall"] = "Clear all";
	Strings["asnSk_clrsel"] = "Clear Selection";
	Strings["asnSk_copycol"] = "Copy column"
	Strings["asnSk_pastecol"] = "Paste column"
	Strings["asnSk_transfer"] = "Check Instrument Slots"
	Strings["asnSk_rejectcol"] = "Reject column changes"
	Strings["asnSk_acceptcol"] = "Accept column changes"
	Strings["asnSk_rejectall"] = "Reject all changes"
	Strings["asnSk_acceptall"] = "Accept all changes"
	Strings["asnSk_send"] = "Send to >"
	Strings["asnSk_wrongFormat"] = "Incorrect data string format received"
	Strings["asnSk_wrongVersion"] = "Possible version mismatch"
	Strings["asnSk_invalidData"] = "Invalid data received"
	Strings["asnSk_invalidHdr"] = "Invalid data header received"
	Strings["asnSk_noData"] = "No skill info available for "
	Strings["asn_prios_current"] = "Party/Raid";
	Strings["asn_prios_all"] = "Known players";
	Strings["asn_addPlayer"] = "Add player";
	Strings["asn_enterPlayer"] = "Enter player"
	Strings["asn_removePlayer"] = "Remove player";
	Strings["asn_removeSelPlayers"] = "Remove selected players";
	Strings["asn_notEnoughPlayers"] = "Not enough players available";
	Strings["asn_noSkillsSingular"] = "doesn't";
	Strings["asn_noSkillsPlural"] = "don't";
	Strings["asn_noSkillsEnding"] = " seem to have any suitable instrument skills for this song.";
	Strings["asn_noInstrument"] = "(No instrument detected)"
	Strings["asn_selSongSetup"] = "Please select a song (and a setup if available) in the main window."
	Strings["asn_noInstrDet"] = "No instrument detected in"
	Strings["asn_noSetupAvail"] = "No setup for the number of active players available."
	Strings["asn_needFsOrRaid"] = "You need to be in a fellowship or raid."
	Strings["asn_postSkills1"] = "This will scan your instrument quickslots and notify your group leader ("
	Strings["asn_postSkills2"] = ") of the instruments you can play, so they can do the instrument assignments."
	Strings["asn_postSkills3"] = "Click the 'Send' button to proceed."
	Strings["asn_asDone"] = "Assignment done."
	Strings["asn_asFail"] = "No assignment found"
	Strings["asn_asNoPlayers"] = "no player left for "

	-- ZEDMOD: Add New Instruments ( Fiddle and Bassoon )
	-- doubling word violon because german got two word as fiedel and giese
	-- aInstrumentsLoc = { "cornemuse", "clarinette", "cloche de vache", "tambour", "fl\195\187t", "harpe", "cor", "luth", "pibgorn", "th\195\169orbe" }; -- Original
	ILang.aLocNames =
	{
	--"cornemuse", "basson", "clarinette", "cloche", "tambour", "violon", "violon", "flute", "harpe", "cor", "luth", "pibgorn", "theorbe"
		"cornemuse", "basson", "clarinette", "cloche", "tambour", "violon", "flute", "harpe", "cor", "luth", "pibgorn", "theorbe"
	};
	-- /ZEDMOD
	-- ZEDMOD: Additonnal Instruments to distinguish between basic and specifics
	ILang.aVariantsBassoon = { "basson de base", "basson du mont solitaire", "basson brusque" };
	ILang.aVariantsFiddle = { "violon de base", "violon d'etudiant", "fidele violon de voyageur", "violon alerte", "violon du mont solitaire", "violon de barde" };
	ILang.aVariantsHarp = { "harpe de base", "harpe du mont brumeux" };
	ILang.aVariantsLute = { "luth de base", "luth des siecles" };
	ILang.aVariantsCowbell = { "cloche de vache de base", "cloche de vache des landes"};
	-- /ZEDMOD
	-- /Badgers
	Strings["ui_clr_slots"] = "Vider";
	Strings["ui_add_slot"] = "Ajouter";
	Strings["ui_del_slot"] = "Retirer";
	Strings["ui_cus_add"] = "Ajouter";
	Strings["ui_cus_edit"] = "Editer";
	Strings["ui_cus_del"] = "Retirer";
	Strings["ui_cus_winadd"] = "Ajouter Commande";
	Strings["ui_cus_winedit"] = "Editer Commande";
	Strings["ui_cus_title"] = "Nom:";
	Strings["ui_cus_command"] = "Commande:";
	Strings["ui_cus_help"] = "Variables de commande:\n\n%name - Nom du morceau\n%file - Fichier\n%part - Num\195\169ro de la partition";
	Strings["ui_cus_err"] = "Veuillez entrer un Nom et une Commande";
	Strings["tt_music"] = "Passe en mode Musique";
	Strings["tt_play"] = "Jouer la chanson";
	Strings["tt_ready"] = "Faire un appel";
	Strings["tt_sync"] = "Jouer en mode Synchro";
	Strings["tt_start"] = "D\195\169buter le jeu synchro";
	Strings["tt_parts"] = "Montrer/Cacher les partitions";
	Strings["sh_saved"] = "Param\195\168tres Songbook sauvegard\195\169s";
	Strings["sh_notsaved"] = "Echec de la sauvegarde des param\195\168tres de Songbook";
	Strings["sh_show"] = "afficher";
	Strings["sh_hide"] = "cacher";
	Strings["sh_toggle"] = "basculer";
	Strings["sh_help1"] = gPlugin .. " afficher: Afficher l'interface de SongBook";
	Strings["sh_help2"] = gPlugin .. " cacher: Cacher l'interface de SongBook";
	Strings["sh_help3"] = gPlugin .. " basculer: Basculer entre visible et cach\195\169";
	Strings["err_nosongs"] = "Le livre de chansons est vide. V\195\169rifiez que vous avez des fichiers pr\195\169sents dans le r\195\169pertoire music et executer le fichier songbook.hta (pr\195\169sent dans le r\195\169pertoire du plugin) pour g\195\169n\195\169rer la liste des chansons. Ensuite, recharger le plugin. \n\n Si vous avez mis \195\160 jour depuis une version pr\195\169c\195\169dente, ex\195\169cuter en premier le songbook.hta avant de charger le plugin.";
end