Template.note.helpers
	viewOrComponent : ->
		activeNoteID = Session.get 'activeNoteID'
		if @_id is activeNoteID then Template.noteEditor(@) else Template.noteView(@)
	timestamp : ->
		moment.unix(@time).calendar()
	entrance : ->
		if @isNew
			# @todo Is this appropriate here? Should the model reassign this value? 
			unsetIsNew = =>
				Notes.update(@_id, $unset: {isNew: true})

			setTimeout(unsetIsNew, 1000)
			'animated fadeIn'


Template.note.events
	'click .deleteButton' : ->
		Notes.remove(@_id)