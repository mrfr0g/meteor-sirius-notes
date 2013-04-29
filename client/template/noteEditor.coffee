Template.noteEditor.events
	'keydown textarea.noteEditor' : (event, template) ->
		# ⌘+],CTRL+] as tab replacement
		if (event.metaKey or event.ctrlKey) and event.which is 221
			event.preventDefault()
			$(event.target).selection('insert', {
				text: '\t',
				mode: 'before'
			})

	'focus .noteEditor' : (event, template) ->
		Session.set('activeId', @_id) if Meteor.Router.page() is 'notes'

Template.noteEditor.helpers
	showEditor : ->
		not @_id or Session.get('activeId') is @_id
	createNote : ->
		if not @_id
			'id="createNote"'

Template.noteEditor.rendered = ->
	activeId = Session.get 'activeId'
	if activeId
		$(this.find("textarea[data-id=#{activeId}]")).focus()

# Template.noteEditor.created = ->
# 	console.log @data
