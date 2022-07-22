# Translator.coffee

import {
	undef, assert, isEmpty, nonEmpty, OL, croak,
	} from '@jdeighan/coffee-utils'
import {LOG} from '@jdeighan/coffee-utils/log'
import {debug} from '@jdeighan/coffee-utils/debug'

import {slurpTAML} from '@jdeighan/mapper/taml'

# ---------------------------------------------------------------------------

export class Translator

	constructor: (dictPath=undef) ->

		debug "enter Translator()"
		@hDict = {}
		if dictPath
			@load(dictPath)
		@lFound = undef
		debug "return from Translator()", @hDict

	# ..........................................................

	translate: (word) ->

		return @hDict[word.toLowerCase()]

	# ..........................................................

	found: (str, trans, pos, end) ->

		@lFound.push([str, trans, pos, end])
		return

	# ..........................................................

	findWords: (sent, lPhrases=[]) ->
		# --- lPhrases should have list of {en, zh, pinyin}
		# --- returns [ [<word>, <trans>, <startPos>, <endPos>], .. ]

		debug "enter findWords()", sent
		if nonEmpty(lPhrases)
			debug "lPhrases", lPhrases
		@lFound = []

		lcSent = sent.toLowerCase()
		for h in lPhrases
			phrase = h.en.toLowerCase()
			start = lcSent.indexOf(phrase)
			if (start == -1)
				LOG "   Phrase not found"
				LOG "      #{h.en}"
				LOG "      #{sent}"
			else
				end = start + phrase.length
				@found phrase, "#{h.zh} #{h.pinyin}", start, end

		# --- We need to use a "fat arrow" function here
		#     to prevent 'this' being replaced
		func = (match, start) =>
			end = start + match.length
			if trans = @translate(match)
				# --- Don't add if it overlaps with other entry in @lFound
				if ! @hasOverlap(start, end)
					@found match, trans, start, end
			return match

		# --- This will find all matches - it doesn't actually replace
		newString = sent.replace(/\w+/g, func)
		lFound = @lFound
		@lFound = undef
		debug "return from findWords()", lFound
		return lFound

	# ..........................................................

	hasOverlap: (start, end) ->

		assert start <= end, "hasOverlap(): Bad positions"
		for lInfo in @lFound
			[_, _, pStart, pEnd] = lInfo
			assert pStart <= pEnd, "hasOverlap(): Bad phrase positions"
			if (start <= pEnd) && (end >= pStart)
				return true
		return false

	# ..........................................................

	load: (dictPath) ->

		debug "enter load('#{dictPath}')"
		for key,trans of slurpTAML(dictPath)
			lWords = splitKey(key)
			if (lWords == undef)
				croak "Bad key: #{OL(key)}"
			debug "lWords", lWords
			for word in lWords
				if (@hDict[word] == undef)
					@hDict[word] = trans
		nKeys = Object.keys(@hDict).length
		debug "return #{nKeys} keys from load()"
		return

# ---------------------------------------------------------------------------

export splitKey = (key) ->
	# --- returns [<word>,...] or undef

	debug "enter splitKey(#{OL(key)})"
	if lMatches = key.match(///^
			([^\(\/]+)
			(
				(?:
					\(
					-*
					[\'a-z]*
					\)
					)*
				)
			(
				\/
				[a-z]+    # normally one of n, v, adj, adv, prep, art
				)?
			$///)
		[_, base, strExtensions, part] = lMatches
		debug 'base', base
		debug 'strExtensions', strExtensions
		debug 'part', part
		if nonEmpty(part)
			lWords = [base, base + part]
		else
			lWords = [base]
		baselen = base.length
		if nonEmpty(strExtensions)
			for lMatches from strExtensions.matchAll(///
					\(
					(-*)
					([\'a-z]*)
					\)
					///g)
				[_, dashes, ext] = lMatches
				toDel = dashes.length
				word = base.substring(0, baselen-toDel) + ext
				lWords.push word
				if nonEmpty(part)
					lWords.push word + part
		debug "return from splitKey()", lWords
		return lWords
	else
		debug "return undef from splitKey() - no match"
		return undef

# ---------------------------------------------------------------------------

combine = (word, ext) ->

	if ext.indexOf('--') == 0
		len = word.length
		return word.substring(0, len-2) + ext.substring(2)
	else if ext.indexOf('-') == 0
		len = word.length
		return word.substring(0, len-1) + ext.substring(1)
	return word + ext
