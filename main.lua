--[[
	  ______                 _ _   _______        _   
	 |  ____|               (_|_) |__   __|      | |  
	 | |__   _ __ ___   ___  _ _     | | _____  _| |_ 
	 |  __| | '_ ` _ \ / _ \| | |    | |/ _ \ \/ / __|
	 | |____| | | | | | (_) | | |    | |  __/>  <| |_ 
	 |______|_| |_| |_|\___/| |_|    |_|\___/_/\_\\__|
	                       _/ |                       
	                      |__/                        

	EmojiText by StrangeEggs
	Automatically replaces emoji names (e.g, :sob:) with their unicode counterpart.

	SETTINGS:
	AutoReplace [default: true]
	Automatically replace string while typing if EmojiText:Listen() was called on the instance.
	If set to false and the class is a TextBox, it will only replace on FocusLost.

	FUNCTIONS:
	EmojiText:Listen(instance)
	Listens to a text instance for any changes (e.g, FocusLost if AutoReplace is set to false
	or Changed event when it is set to true.
	EmojiText:Replace(string)
	Converts emojis in a string with ones from the emoji list.
	Returns the replaced string and the original string.
	
	ADDING EMOJIS:
	Should be self explanatory. Just look at how it's formatted, lol.
--]]

local EmojiText = {}

EmojiText.Settings = {
	["AutoReplace"] = true,
}

EmojiText.Emojis = {
	[":joy:"] = "😂",
	[":moyai:"] = "🗿",
	[":rolling_eyes:"] = "🙄",
	[":rofl:"] = "🤣",
	[":heart:"] = "❤️",
	[":sob:"] = "😭",
	[":cry:"] = "😢",
	[":100:"] = "💯",
	[":skull:"] = "💀",
	[":thinking:"] = "🤔",
	[":flushed:"] = "😳",
	[":pensive:"] = "😔",
	[":neutral_face:"] = "😐",
	[":sunglasses:"] = "😎",
	[":angry:"] = "😠",
	[":triumph:"] = "😤",
	[":weary:"] = "😩",
	[":stuck_out_tongue_closed_eyes:"] = "😝",
	[":face_with_raised_eyebrow"] = "🤨",
	[":eyes:"] = "👀",
	[":yum:"] = "😋",
	[":clap:"] = "👏",
	[":smile:"] = "😄",
	[":blush:"] = "😊",
	[":star_struck:"] = "🤩",
	[":rage:"] = "😡",
	[":hot_face:"] = "🥵",
	[":cold_face:"] = "🥶",
	[":smirk:"] = "😏",
	[":wink:"] = "😉",
	[":heart_eyes:"] = "😍",
	[":heart_eyes_cat:"] = "😻",
	[":see_no_evil:"] = "🙈",
	[":sweat_smile"] = "😅",
	[":nauseated_face:"] = "🤢",
	[":face_vomiting:"] = "🤮",
	[":mask:"] = "😷",
	[":grimacing:"] = "😬",
	[":expressionless:"] = "😑",
	[":partying_face:"] = "🥳",
	[":zany_face:"] = "🤪",
	[":money_mouth:"] = "🤑",
	[":alien:"] = "👽",
	[":woman_shrugging:"] = "🤷‍♀",
	[":man_shrugging:"] = "🤷‍♂️",
	[":perplexed:"] = "🥺",
	[":hammer:"] = "🔨",
	[":game_die:"] = "🎲",
	[":v:"] = "✌️",
	["/shrug"] = "¯\\_(ツ)_/¯",
	[":face_with_hand_over_mouth"] = "🤭",
	[":crown:"] = "👑",
	[":sleeping:"] = "😴",
	[":wave:"] = "👋",
	[":rainbow_flag:"] = "🏳️‍🌈",
	[":nail_care:"] = "💅",
	[":exploding_head:"] = "🤯",
	[":eye:"] = "👁️",
	[":unamused:"] = "😒",
	[":door:"] = "🚪",
	[":cat:"] = "🐱",
	[":crying_cat_face:"] = "😿",
	[":joy_cat:"] = "😹",
	[":kissing_cat:"] = "😽",
	[":pouting_cat:"] = "😾",
	[":scream_cat:"] = "🙀",
	[":smile_cat:"] = "😸",
	[":smiley_cat:"] = "😺",
	[":smirk_cat:"] = "😼",
	[":cat2:"] = "🐈",
	[":scream:"] = "😱",
	[":cold_sweat:"] = "😰",
	[":disappointed_relieved:"] = "😥",
	[":no_mouth:"] = "😶",
	[":zipper_mouth:"] = "🤐",
	[":confused:"] = "😕",
	[":smiling_imp:"] = "😈",
	[":imp:"] = "👿",
	[":clown:"] = "🤡",
	[":ghost:"] = "👻",
	[":ok_hand:"] = "👌",
	[":relaxed:"] = "☺️",
	[":disappointed:"] = "😞",
	[":confounded:"] = "😖",
	[":fearful:"] = "😨",
	[":sweat:"] = "😓",
	[":laughing:"] = "😆",
	[":innocent:"] = "😇",
	[":frowning:"] = "😦",
	[":cowboy:"] = "🤠",
	[":brain:"] = "🧠",
	[":bacon:"] = "🥓",
	[":tada:"] = "🎉",
	[":bulb:"] = "💡",
	[":question:"] = "❓",
	[":white_check_mark:"] = "✅",
	[":smiley:"] = "😃",
	["/tableflip"] = "(╯°□°）╯︵ ┻━┻",
	["/unflip"] = "┬─┬ ノ( ゜-゜ノ)",
}

function EmojiText:Replace(String)
	for EmojiName,Unicode in pairs(EmojiText.Emojis) do
		if string.find(String, EmojiName) then
			local Replaced,Matches = string.gsub(String, EmojiName, Unicode)
			return Replaced, String
		end
	end
	
	return String
end

function EmojiText:Listen(Label)
	if Label.ClassName:sub(1,4) == "Text" then
		Label:GetPropertyChangedSignal("Text"):Connect(function()
			if EmojiText.Settings.AutoReplace == true then
				Label.Text = EmojiText:Replace(Label.Text)
			end
		end)
		
		if Label:IsA("TextBox") then
			Label.FocusLost:Connect(function(enter)
				if EmojiText.Settings.AutoReplace == false then
					Label.Text = EmojiText:Replace(Label.Text)
				end
			end)
		end
	else
		error("EmojiText:Listen was not called on a Text instance.")
	end
end

return EmojiText
