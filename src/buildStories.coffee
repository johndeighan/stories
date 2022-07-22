# buildStories.coffee

import {
	undef, assert, defined, isHash, isString, OL, words,
	} from '@jdeighan/coffee-utils'
import {arrayToBlock} from '@jdeighan/coffee-utils/block'
import {
	setLogger, log, LOG,
	} from '@jdeighan/coffee-utils/log'
import {
	mydir, mkpath, withExt, slurp, barf, forEachFile,
	} from '@jdeighan/coffee-utils/fs'
import {doMap} from '@jdeighan/mapper'
import {taml, slurpTAML} from '@jdeighan/mapper/taml'

import {Translator} from '@jdeighan/stories/trans'
import {StoryMapper} from '@jdeighan/stories/mapper'

dir = mydir(import.meta.url)
storiesDir = mkpath(dir, 'stories')

maxENlen = 55
maxZHlen = 26

dictPath = mkpath(dir, 'dictionary.taml')
translator = new Translator(dictPath)

hPrinted = undef  # which word translations have already been printed
lLines = undef    # cleared for each store - holds output lines
inclChinese = true
inclWords = false

# ---------------------------------------------------------------------------

main = () ->

	forEachFile storiesDir, buildOneStory, /\.taml$/
	return

# ---------------------------------------------------------------------------

buildOneStory = (filename, dir) ->
	# --- Returns total number of words/phrases looked up

	inPath = mkpath(dir, filename)

	nFound = 0
	hPrinted = {}
	lLines = []
	setLogger (line) -> lLines.push(line)

#	hStory = slurpTAML(inPath, {premapper: StoryMapper})
	contents = slurp(inPath)
	mapped = doMap(StoryMapper, contents, inPath)
	hStory = taml(mapped)

	assert isHash(hStory), "result is not a hash"
	log "#{hStory.title.en}  - by #{hStory.author.en}"
	log ''
	for hPara, i in hStory.lParagraphs
		for hSent, j in hPara.lSentences
			nFound += printSentence hSent, i, j
			log '-'.repeat(50)

	outPath = withExt(inPath, '.zh', {removeLeadingUnderScore: true})
	barf outPath, lLines
	LOG "buildOneStory('#{filename}') - #{nFound} words/phrases"
	return nFound

# ---------------------------------------------------------------------------

printSentence = (hSent, nPar, nSent) ->
	# --- Returns total number of words/phrases looked up

	# --- Get list of found phrases and/or words
	lFound = translator.findWords(hSent.en, hSent.lPhrases)

	checkSentence hSent, nPar, nSent
	logEnglish hSent.en
	if inclChinese
		log ''
		logChinese hSent.zh
		logEnglish hSent.pinyin
	if inclWords && (lFound.length > 0)
		log ''
		for [word, trans, _, _] in lFound
			if ! hPrinted[word]?
				log "   (#{word} #{trans})"
				hPrinted[word] = true
	return lFound.length

# ---------------------------------------------------------------------------

checkSentence = (hSent, nPar, nSent) ->

	if (hSent.en == undef)
		LOG "WARNING: Sentence #{nPar}/#{nSent} missing 'en'"
	if (hSent.zh == undef)
		LOG "WARNING: Sentence #{nPar}/#{nSent} missing 'zh'"
	if (hSent.pinyin == undef)
		LOG "WARNING: Sentence #{nPar}/#{nSent} missing 'pinyin'"
	return

# ---------------------------------------------------------------------------

logEnglish = (line) ->

	assert defined(line), "logEnglish(): line is undef"
	assert isString(line), "non-string: #{OL(line)}"

	lWords = []    # add words until too long, then log
	len = 0        # length of lWords.join(' ')

	lineNum = 0
	for word in words(line)
		# --- Remove any part of speech
		word = word.split('/')[0]

		# --- if adding word to lWords would make it too long
		if (len + 1 + word.length > maxENlen)
			if (lineNum == 0)
				log lWords.join(' ')
			else
				log '     ' + lWords.join(' ')
			lWords = [word]
			len = word.length
			lineNum += 1
		else
			lWords.push word
			len += word.length + 1

	if (lWords.length > 0)
		if (lineNum == 0)
			log lWords.join(' ')
		else
			log '     ' + lWords.join(' ')
	return

# ---------------------------------------------------------------------------

logChinese = (line) ->

	assert defined(line), "logChinese(): line is undef"
	assert isString(line), "non-string: #{OL(line)}"
	lineNum = 0
	while (line.length > maxZHlen)
		if (lineNum == 0)
			log line.substring(0, maxZHlen)
		else
			log '     ' + line.substring(0, maxZHlen)
		line = line.substring(maxZHlen)
		lineNum += 1
	if (line.length > 0)
		if (lineNum == 0)
			log line
		else
			log '     ' + line
	return

# ---------------------------------------------------------------------------

main()
