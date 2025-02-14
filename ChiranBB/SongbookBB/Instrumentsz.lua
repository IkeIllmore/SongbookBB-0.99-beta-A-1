-----------------------
-- Check Instruments --
-----------------------

function CheckInstrument( sTrack )
	
	--*************************
	--* Get Player Instrument *
	--*************************
	-- Get Local Player Instance
	local player = Turbine.Gameplay.LocalPlayer:GetInstance();
	if not player then return; end
	-- Get Player Equipment
	local equip = player:GetEquipment();
	if not equip then return; end
	--  Get Player Item category Instrument equipped
	local item = equip:GetItem( Turbine.Gameplay.Equipment.Instrument );
	if not item then return; end

	local sCleanTrack = CleanString( sTrack:lower() );
	mainWnd.bInstrumentOk = true; -- only set to false if we can successfully determine track and equipped instrument

	local sPlayerInstrument = item:GetName():lower()
	local iTypePlayer, typePlayer, iVarPlayer, varPlayer = GetTrackInstrument( sPlayerInstrument ) -- to apply special instrument name conversions
	local iTypeTrack, typeTrack, iVarTrack, varTrack = GetTrackInstrument( sCleanTrack )
	-- TRACE( "Player: "..tostring(iTypePlayer)..", \""..tostring(typePlayer).."\", "..tostring(iVarPlayer)..", \""..tostring(varPlayer).."\"" )
	-- TRACE( " Track: "..tostring(iTypeTrack)..", \""..tostring(typeTrack).."\", "..tostring(iVarTrack)..", \""..tostring(varTrack).."\"" )
	if not varPlayer or not varTrack then return; end

	if varPlayer == varTrack then TRACE( "Instrument OK" )
	else mainWnd.bInstrumentOk = false; end
	mainWnd:SetInstrumentMessage( varTrack )
end

------------------
-- Clean String --
------------------
function CleanString( sString )
	
	-- INIT Special Char
	-- set û : \195\187
	local sU1 = "\195\187";
	
	-- set ü : \195\188
	local sU2 = "\195\188";
	
	-- change to u
	local scU = "u"
	
	-- set é : \195\169
	local sE1 = "\195\169"; --string.char(\195\169)
	
	-- set è : \195\168
	local sE2 = "\195\168"; --string.char(\195\168)
	
	-- change to e
	local scE = "e";
	
	-- set ö : \195\182
	local sO1 = "\195\182"; --string.char(\195\182)
	
	-- change to o
	local scO = "o";
	
	-- set - : 
	local sTild = "%-";
	
	-- change to " "
	local scTild = " "
	
	-- Search for Special Char
	-- û : \195\187
	local sT = string.find( sString, sU1 );
	if ( sT ~= nil ) then
		sString = string.gsub( sString, sU1, scU );
	end
	
	-- ü : \195\188
	local sT = string.find( sString, sU2 );
	if ( sT ~= nil ) then
		sString = string.gsub( sString, sU2, scU );
	end
	
	-- é : \195\169
	local sT = string.find( sString, sE1 );
	if ( sT ~= nil ) then
		sString = string.gsub( sString, sE1, scE );
	end
	
	-- è : \195\168
	local sT = string.find( sString, sE2 );
	if ( sT ~= nil ) then
		sString = string.gsub( sString, sE2, scE );
	end
	
	-- ö : \195\182
	local sT = string.find( sString, sO1 );
	if ( sT ~= nil ) then
		sString = string.gsub( sString, sO1, scO );
	end
	
		-- set - : 
	local sT = string.find( sString, sTild );
	if ( sT ~= nil ) then
		sString = string.gsub( sString, sTild, scTild );
	end
	
	return sString;
end

----------------------------------------------------------
-- Get Player Instrument LOC Index and LOC Generic Name --
----------------------------------------------------------
function GetPlayerInstrumentLOC( sName )
	for index, name in pairs( ILang.aLocNames ) do
		if ( sName:find( name ) ) then
			return index, name;
		end
	end
	for name, index in pairs( Instruments.aSpecials ) do
		if ( sName:find( name ) ) then
			return index, ILang.aLocNames[ index ];
		end
	end
	return nil, nil;
end

-----------------------------------------------------------
-- Get Player Instrument LOC/SB Type Index and Type Name --
-----------------------------------------------------------
function GetPlayerInstrumentLOCSBType( iIndex, sName )

	-- Set aInstrumentsLOCType and aInstrumentsSBType
	local aInstrumentsLOCType, aInstrumentsSBType = nil, nil;
	-- If Instrument Name is bassoon or basson or fagott : index = 2
	if ( iIndex == IMap.Id["bassoon"] ) then -- Bassoon
		aInstrumentsLOCType = ILang.aVariantsBassoon;
		aInstrumentsSBType = IMap.aBassoon;
	
	-- If Instrument Name is Cowbell or Cloche or Glocke : index = 4
	elseif ( iIndex == IMap.Id["cowbell"] ) then -- Cowbell
		aInstrumentsLOCType = ILang.aVariantsCowbell;
		aInstrumentsSBType = IMap.aCowbell;
		
	-- If Instrument Name is fiddle or violon or fiedel or geige : index = 6 or 7
	elseif ( iIndex == IMap.Id["fiddle"] ) then -- Fiddle
		aInstrumentsLOCType = ILang.aVariantsFiddle;
		aInstrumentsSBType = IMap.aFiddle;
	
	-- If Instrument Name is harp or harpe or harfe : index = 9
	elseif ( iIndex == IMap.Id["harp"] ) then -- Harp
		aInstrumentsLOCType = ILang.aVariantsHarp;
		aInstrumentsSBType = IMap.aHarp;
		
	-- If Instrument Name is Lute or luth or laute : index = 11
	elseif ( iIndex == IMap.Id["lute"] ) then -- Lute
		aInstrumentsLOCType = ILang.aVariantsLute;
		aInstrumentsSBType = IMap.aLute;
	else
		aInstrumentsLOCType = Instruments.aInstruments;
		aInstrumentsSBType = Instruments.aInstruments;
	end
	
	-- Get Instrument LOC Type Index and LOC Type Name from LOC Name
	local instrumentLOCTypeIndex, instrumentLOCTypeName = GetInstrumentLOCType( sName, aInstrumentsLOCType );
	local instrumentSBTypeIndex = instrumentLOCTypeIndex
	local instrumentSBTypeName
	if ( not instrumentLOCTypeIndex ) then
		instrumentLOCTypeIndex = 1;
		instrumentLOCTypeName = nil;
		instrumentSBTypeIndex = 1;
		instrumentSBTypeName = nil;
	else
		instrumentSBTypeName = Instruments.aInstruments[instrumentSBTypeIndex];
	end
	return instrumentLOCTypeIndex, instrumentLOCTypeName, instrumentSBTypeIndex, instrumentSBTypeName
end

------------------------------------------------
-- Get Instrument LOC Type Index and LOC Name --
------------------------------------------------
function GetInstrumentLOCType( sName, aInstrumentsLOCType )
	local searchType = nil;
	for index, name in pairs( aInstrumentsLOCType ) do
		searchType = string.find( name, sName:lower() );
		if ( searchType ~= nil ) then
			return index, name;
		end
	end
	return nil, nil;
end

---------------------------------
-- Get Track Instrument LOC/SB --
---------------------------------
function GetVariant( sBasename, sTrack )
	local aVars = ILang.aVariants[ sBasename ]
	if aVars then
		for index, name in pairs( aVars ) do
			if ContainsPhrase( sTrack, name ) then
				return index, name; end
		end
		return 1, aVars[ 1 ]
	end
	return 1, sBasename
end

function GetTrackInstrument( sTrack, s )
	for k, v in pairs( ILang.aMapping ) do -- check for abbrev
		if ContainsPhrase( sTrack, k ) then
			local varIdx = IMap.iVariant[ v.name ]
			if not varIdx then varIdx = 1; end
			return IMap.Id[ v.type ], v.type, varIdx, v.name
		end
	end
	for k, v in pairs( ILang.aLocNames ) do -- check for base
		if ContainsPhrase( sTrack, v ) then
			local varIdx, varName = GetVariant( v, sTrack )
			return k, v, varIdx, varName
		end
	end

	return nil, nil, nil, nil
end


-- wrapper for assignment
function GetTrackInstrumentIndex( sTrack, aInstrumentsLang )
	local iInstr, _, _, _ = GetTrackInstrument( sTrack, aInstrumentsLang )
	return iInstr
end

---------------------------------------------------
-- Get Track Instrument Type Index and Type Name --
---------------------------------------------------
function GetType( sName, aInstrumentsType )
	local sLower = sName:lower()
	for index, name in pairs( aInstrumentsType ) do
		local aSynonyms = ILang.aSynonyms[ name ]
		if aSynonyms then
			local sFullName = CheckSynonyms( sLower, aSynonyms )
			if sFullName then
				return index, sFullName;
			end
		end
		if string.find( name, sLower ) then
			return index, name;
		end
	end
	return nil, nil;
end

function ContainsPhrase( s, sPhrase )
    return string.match( s, "%f[%a]"..sPhrase.."%f[%A]" )
end

function CheckSynonyms( sTrack, aSynonyms )
	--TRACE("Checking synonyms: "..table.StringV( aSynonyms ) )
	for i = 1, #aSynonyms do
		local sResult = ContainsPhrase( sTrack, aSynonyms[i] )
		if sResult then
			return sResult
		end
	end
	return nil
end

--------------------------------
-- Get Track Instrument Index --
--------------------------------
function GetTrackInstrumentIndex( sName, aInstruments )
	local sNameLC = sName:lower()
	for index, name in pairs( aInstruments ) do
		local pattern = "%A"..name:lower()
		if ( sNameLC:find( pattern ) ) then
			return index;
		end
	end
	return nil;
end

-----------------------------------------
-- Get Track Instrument Index and Name --
-----------------------------------------
function GetInstrument( sTrack, aInstruments )
	for index, name in pairs( aInstruments ) do
		local sFullName = FindInstrWithSynonyms( sTrack, name )
		if sFullName then
		--if sTrack:find( name ) then
			return index, name;
		end
	end
	
	return nil, nil;
end

function FindInstrWithSynonyms( sTrack, sInstr )
	if ContainsPhrase( sTrack, sInstr ) then
		return true;
	end
	
	local aSynonyms = ILang.aSynonyms[ sInstr ]

	if aSynonyms and CheckSynonyms( sTrack, aSynonyms ) then
		return true
	end
	
	return nil
end

function IsSameInstrument( s1, s2 )
	local s1Mapped = Instruments:NameAbbrev( s1 )
	local s2Mapped = Instruments:NameAbbrev( s2 )
	return s1Mapped == s2Mapped
end

function ContainsInstrOrAbbrev( s, sInstr, bDebug )
	if bDebug then TRACE( "ContainsInstrOrAbbrev: s=\""..s.."\", sInstr=\""..tostring(sInstr).."\"" ); end
	local sInstrMapped = Instruments:NameAbbrev( sInstr )
	if not sInstrMapped then -- no abbreviation
		if not Instruments:IsPlainInstr( sInstr ) then
			--WRITE( "Invalid instrument name: \""..tostring( sInstr) .. "\"" )
			return false; end -- no valid instrument name
		-- if Instruments:IsBasicInstr( sInstr ) then
		-- 	return false; end
		return s:find( sInstr )
	end
	if bDebug then TRACE( "  sInstrMapped=\""..tostring(sInstrMapped).."\"" ); end
	if s:find( sInstrMapped ) then
		if bDebug then TRACE( "  found mapped "..tostring(sInstrMapped).." for \""..tostring(s).."\"" ); end
		return true; end
	local aAbbrev = ILang.aAbbrev[ sInstrMapped ].vars
	for i = 1,#aAbbrev do
		if bDebug then TRACE( "  searching "..tostring(aAbbrev[i]).." in \""..tostring(s).."\"" ); end
		if s:find( aAbbrev[ i ] ) then
			if bDebug then TRACE( "  found "..tostring(aAbbrev[ i ]).." for \""..tostring(sInstrMapped).."\"" ); end
			return true
		end
	end
	return false
end

function ContainsInstrument( sTrackInstr, sInstr, iStart, bDebug )
	if bDebug then TRACE( "ContainsInstrument: sTrackInstr=\""..tostring(sTrackInstr).."\", sInstr=\""..tostring(sInstr).."\", iStart="..tostring(iStart) ); end
	--if bDebug then TRACE( "ContainsInstrument: sTrackInstr="..sTrackInstr..", sInstr="..sInstr ); end
	if iStart and iStart >= 1 then sTrackInstr = sTrackInstr:sub( iStart + 1 ); end
	return ContainsInstrOrAbbrev( sTrackInstr, sInstr, bDebug )
end
