Template.note.events
	'click .deleteButton' : (event) ->
		Notes.remove(@_id)

	'click #create' : (event, template) ->
		$target = $(template.find('textarea'))
		Notes.createNote($target.val())

		$target.val('')

	'keypress textarea.noteEditor, keypress #groupSelection' : (e, template) ->
		if e.which is 13 and e.shiftKey
			e.preventDefault()
			$editor = $(template.find('textarea.noteEditor'))

			if Session.get 'activeId'
				Notes.update(
					Session.get('activeId'),
					$set : 
						note : $editor.val()
						time : moment().unix()
					)

				$('#createNote').focus()
			else
				Notes.createNote($editor.val())
				$editor.val('')
				$('#createNote').focus()


Template.note.helpers
	timestamp : (time) ->
		moment.unix(time).calendar()
	visible : ->
		result = 'hide'
		if Session.get('activeId') == @_id or (not Session.get('activeId') and not @_id)
			result = 'show'
		result
	entrance : ->
		if @isNew
			# Is this appropriate here? Should the model reassign this value? 
			setIsNewToFalse = =>
				Notes.update(@_id, $set: {isNew: false})

			setTimeout(setIsNewToFalse, 1000)
			'animated fadeIn'

# Template.note.created = ->
# 	console.log @

Template.note.rendered = ->
	$('#create').popover()