Template.noteEditor.saveNote = (editor) ->
	$editor = $(editor)

	if Session.get 'activeNoteID'
		Notes.update(
			Session.get('activeNoteID'),
			$set : 
				note : $editor.val()
				time : moment().unix()
			)
	else
		Notes.createNote($editor.val())
		$editor.val('')

	$('.noteCreator textarea').focus()

Template.noteEditor.events
	# Focus on main editor, clear the active editor
	'focus textarea.noteEditor' : ->
		if not @_id
			Session.set 'activeNoteID', null

	# ⌘+],CTRL+] as tab replacement	
	'keydown .noteEditor' : (event) ->
		if (event.metaKey or event.ctrlKey) and event.which is 221
			event.preventDefault()
			$(event.target).selection 'insert',
				text: '\t',
				mode: 'before'

	# Enable shift+enter shortcut save on editor/groupSelection field
	'keypress textarea.noteEditor, keypress #groupSelection' : (event, template) ->
		if event.shiftKey and event.which is 13
			event.preventDefault()
			Template.noteEditor.saveNote template.find('textarea.noteEditor')