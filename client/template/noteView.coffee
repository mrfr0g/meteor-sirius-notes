Template.noteView.rendered = ->
	# @todo render this in the lexer instead
	@findAll('a').forEach (anchor) ->
		$(anchor).attr('target', '_blank')

Template.noteView.events
	'click' : (event) ->
		if not $(event.target).is('a') and @editable
			Session.set('activeNoteID', @_id)

		event.stopImmediatePropagation()