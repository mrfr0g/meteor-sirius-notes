
# Template.notesLayout.helpers
# 	label : (time) ->

# 		@label or 'Started ' + moment.unix(time).calendar()
# 	hasNotes : (group) ->
# 		group.notes.count()
# 	canEditGroup : ->
# 		'contentEditable="true"' if Meteor.Router.page() is 'notes'