Template.notes.helpers
	groups : ->
		Groups.findWithNotes(null, {type: "note"})

Template.notes.events
	'click #create' : (event, template) ->
		$target = $(template.find('textarea'))
		Notes.createNote($target.val())

		$target.val('')