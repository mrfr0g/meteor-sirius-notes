# Overkill?
Toolbar = new Meteor.Collection null

Toolbar.insert
	'path' : '/'
	'view' : 'notes'
	'label' : 'Notes'

Toolbar.insert
	'path' : '/acknowledgements'
	'view' : 'acknowledgements'
	'label' : 'Acknowledgements'

Toolbar.find().forEach (item) ->
	route = {}
	route[item.path] = item.view
	Meteor.Router.add(route)

Meteor.Router.beforeRouting = ->
	Session.set 'activeId', null

Template.toolbar.helpers
	menu : ->
		Toolbar.find().fetch()

	active : (item) ->
		path = Meteor.Router[Meteor.Router.page() + 'Path']()
		'active' if item.path is path