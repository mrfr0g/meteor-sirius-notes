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
	action : ->
		activeNoteID = Session.get 'activeNoteID'
		if @_id is activeNoteID then 'save' else 'edit'
	actionLabel : ->
		activeNoteID = Session.get 'activeNoteID'
		if @_id is activeNoteID then 'Save' else 'Edit'
	showToolbar : ->
		activeNoteID = Session.get 'activeNoteID'
		@_id is activeNoteID and 'display: block'



Template.note.events
	'click .deleteButton' : ->
		Notes.remove @_id
	'click .editButton' : ->
		Session.set 'activeNoteID', @_id
	'click .saveButton' : (event, template) ->
		Template.noteEditor.saveNote template.find('textarea.noteEditor')