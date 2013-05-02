Template.groupSection.helpers
	label : ->
		Groups.label @
	editable : ->
		'contentEditable="true"' if not @readOnly

Template.groupSection.events
	'focus .noteEditor' : ->
		Session.set('activeNoteID', @_id) if not @readOnly

	'keydown h1, blur h1' : (event) ->
		editingGroupID = Session.get('editingGroupID')
		if not editingGroupID
			null

		if event.type is 'keydown' and event.which is 13
			event.preventDefault()
			shouldSave = true

		if event.type is 'blur' or shouldSave
			Groups.update(
				editingGroupID,
				$set : 
					label : event.target.innerText
			)

	'focus h1' : ->
		Session.set('editingGroupID', @_id) if not @readOnly
