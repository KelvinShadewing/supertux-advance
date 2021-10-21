::meLanguage <- [
	
]
::languageList <- null
::selectLanguage <- function() {
	meLanguage = []
	if(languageList==null)
		languageList = jsonRead(fileRead("lang/languages.json"))
	for(local i = 0; i < languageList["languages"].len(); i+=1) {
		meLanguage.push(
			{
				languageIndex = i,
				name = function() { return languageList["languages"][languageIndex][0] },
				func = function() {
					config.lang = languageList["languages"][languageIndex][1]
					cursor = i
					menu = meOptions
					gvLangObj = jsonRead(fileRead("lang/en.json"))
					gvLangObj = mergeTable(gvLangObj, jsonRead(fileRead("lang/" + config.lang + ".json")))
				}
			}
		)
	}
	menu = meLanguage
}