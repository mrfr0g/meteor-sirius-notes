Template.noteView.rendered = ->
	# @todo render this in the lexer instead
	@findAll('a').forEach (anchor) ->
		$(anchor).attr('target', '_blank')