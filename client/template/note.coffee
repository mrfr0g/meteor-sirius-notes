Template.note.helpers
	viewOrComponent : ->
		activeNoteID = Session.get 'activeNoteID'
		if @_id is activeNoteID then Template.noteEditor(@) else Template.noteView(@)
	timestamp : ->
		moment.unix(@time).calendar()
	entrance : ->
		if @isNew
			# @todo Is this appropriate here? Should the model reassign this value? 
			setIsNewToFalse = =>
				Notes.update(@_id, $set: {isNew: false})

			setTimeout(setIsNewToFalse, 1000)
			'animated fadeIn'


Template.note.events
	'click .deleteButton' : (event) ->
		Notes.remove(@_id)