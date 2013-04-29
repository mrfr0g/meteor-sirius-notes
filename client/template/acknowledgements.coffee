Template.acknowledgements.helpers
	groups : ->
		Groups.findWithNotes({type: 'acknowledgements'})