Template.welcome.helpers
	groups : ->
		Groups.findWithNotes(null, {type: 'welcome'})