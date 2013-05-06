# Overkill?
Toolbar = new Meteor.Collection null

Toolbar.insert
	'path' : '/'
	'view' : 'notes'
	'label' : 'Home'

Toolbar.insert
	'path' : '/acknowledgements'
	'view' : 'acknowledgements'
	'label' : 'Acknowledgements'

Toolbar.find().forEach (item) ->
	route = {}
	route[item.path] = item.view
	route['as'] = item.view
	Meteor.Router.add(route)

Meteor.Router.add
	'/welcome' :
		as : 'welcome'

Meteor.Router.beforeRouting = ->
	Session.set 'activeNoteID', null

Meteor.Router.filters
	'checkLoggedIn' : (page) ->
		if page is 'notes' and not Meteor.user()
			return 'welcome'
		page

Meteor.Router.filter 'checkLoggedIn', only : 'notes'

Template.toolbar.helpers
	menu : ->
		Toolbar.find().fetch()

	active : (item) ->
		path = Meteor.Router[Meteor.Router.page() + 'Path']()
		'active' if item.path is path