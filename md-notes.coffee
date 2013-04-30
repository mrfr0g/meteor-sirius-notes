# 
# Lib 
#
Meteor.Collection.prototype.truncate = ->
	@find().forEach (item) =>
		@remove item._id

# 
# Collections
# 
@Notes = new Meteor.Collection 'notes'

Notes.createNote = (note) ->
	activeGroupID = Session.get 'activeGroupID'
	activeGroup = Groups.findOne(activeGroupID)
	timestamp = moment().unix()
	label = $('#groupSelection').val()

	if activeGroup
		activeGroupLabel = Template.byGroup._tmpl_data.helpers.label.call(activeGroup, activeGroup.time)

	if not activeGroup or activeGroupLabel isnt label
		groupRecord = 
			time: timestamp
			label : label

		activeGroupID = Groups.insert groupRecord

		Session.set 'activeGroupID', activeGroupID
		Session.set 'activeGroupLabel', Template.byGroup._tmpl_data.helpers.label.call(groupRecord, timestamp)

	Notes.insert
		group : activeGroupID
		note : note
		time : timestamp
		isNew : true

@Groups = new Meteor.Collection 'groups'

Groups.findWithNotes = (groupSelector = {}, noteSelector = {}) ->
	# Join groups and notes, sorting by time descending
	Groups.find(groupSelector, {sort: {time : -1}}).map (group) ->
		group.notes = []
		
		noteSelector = _.extend(noteSelector, {group: group._id})

		notes = Notes.find(noteSelector, {sort: {time : -1}}).fetch()
		if notes.length
			group.notes = _.inGroupsOf(notes, 3, {})
		group


# 
# Server Logic
# 
if Meteor.isServer
	# Clear empty groups
	Notes.find().observe
		removed : (note) ->
			if not Notes.findOne({group: note.group})
				Groups.remove(note.group)

	marked.setOptions
		smartLists: true

	# Render Markdown on save/create
	Notes.find().observeChanges
		added: (id, fields) ->
			if fields.note isnt undefined
				Notes.update(id, {$set: {md: marked fields.note}})
			fields
		changed: (id, fields) ->
			if fields.note isnt undefined
				Notes.update(id, {$set: {md: marked fields.note}})
			fields

	# @todo filter by login
	Meteor.publish 'groups', ->
		Groups.find()
	Meteor.publish 'notes', ->
		Notes.find()

# 
# Client Logic
# 
if Meteor.isClient
	Handlebars.registerHelper(
		'canEditPopover', ->
			'data-toggle="popover" data-trigger="hover" data-placement="left" data-content="Click to Edit"'
	)
	
Deps.autorun ->
	if Meteor.isClient
		Meteor.subscribe 'groups'
		Meteor.subscribe 'notes'
