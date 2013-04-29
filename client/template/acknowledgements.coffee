Template.acknowledgements.helpers
	groups : ->
		Groups.findWithNotes(null, {type: 'acknowledgement'})