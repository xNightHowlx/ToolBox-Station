/proc/emoji_parse(text)
	. = text
	if(!CONFIG_GET(flag/emojis))
		return
	var/static/list/emojis = icon_states(icon('icons/emoji.dmi'))
	var/static/list/emojistoolbox = icon_states(icon('icons/oldschool/toolboxemojis.dmi'))
	var/parsed = ""
	var/pos = 1
	var/search = 0
	var/emoji = ""
	while(1)
		search = findtext(text, ":", pos)
		parsed += copytext(text, pos, search)
		if(search)
			pos = search
			search = findtext(text, ":", pos+1)
			if(search)
				emoji = lowertext(copytext(text, pos+1, search))
				if(emoji in emojis)
					parsed += icon2html('icons/emoji.dmi', world, emoji)
					pos = search + 1
				else if(emoji in emojistoolbox)
					parsed += icon2html('icons/oldschool/toolboxemojis.dmi', world, emoji)
					pos = search + 1
				else
					parsed += copytext(text, pos, search)
					pos = search
				emoji = ""
				continue
			else
				parsed += copytext(text, pos, search)
		break
	return parsed

/datum/asset/simple/icon_states/toolboxemojis
	icon = 'icons/oldschool/toolboxemojis.dmi'
	generic_icon_names = TRUE

/proc/emoji_sanitize(text) //cuts any text that would not be parsed as an emoji
	. = text
	if(!CONFIG_GET(flag/emojis))
		return
	var/static/list/emojis = icon_states(icon('icons/emoji.dmi'))
	var/final = "" //only tags are added to this
	var/pos = 1
	var/search = 0
	while(1)
		search = findtext(text, ":", pos)
		if(search)
			pos = search
			search = findtext(text, ":", pos + length(text[pos]))
			if(search)
				var/word = lowertext(copytext(text, pos + length(text[pos]), search))
				if(word in emojis)
					final += lowertext(copytext(text, pos, search + length(text[search])))
				pos = search + length(text[search])
				continue
		break
	return final