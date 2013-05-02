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

Notes.allow
	insert : (userId, doc) ->
		# no shenan.. shinan.. shenanigans
		doc.user is userId
	update : (userId, doc) ->
		doc.user is userId
	remove : (userId, doc) ->
		doc.user is userId

Notes.deny
	update : (userId, doc, fields) ->
		_.contains(fields, 'user')

Notes.createNote = (note) ->
	activeGroupID = Session.get 'activeGroupID'
	activeGroup = Groups.findOne(activeGroupID)
	timestamp = moment().unix()
	label = $('#groupSelection').val()

	if activeGroup
		activeGroupLabel = Groups.label(activeGroup)

	if not activeGroup or activeGroupLabel isnt label
		activeGroupID = Groups.createGroup label, true

	Notes.insert
		group : activeGroupID
		note : note
		time : timestamp
		isNew : true
		user : Meteor.userId()

@Groups = new Meteor.Collection 'groups'

Groups.allow
	insert : (userId, doc) ->
		doc.user is userId
	update : (userId, doc) ->
		doc.user is userId
	remove : (userId, doc) ->
		doc.user is userId

Groups.deny
	update : (userId, doc, fields) ->
		_.contains(fields, 'user') or doc.readOnly

Groups.createGroup = (label, setActive = false) ->
	groupRecord = 
		time: moment().unix()
		label : label
		user : Meteor.userId()

	activeGroupID = Groups.insert groupRecord

	if setActive
		Session.set 'activeGroupID', activeGroupID

	activeGroupID


Groups.label = (group) ->
	group.label or 'Started ' + moment.unix(group.time).calendar()

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

	Meteor.publish 'groups', ->
		Groups.find({user: {$in: ["public", this.userId]}})
	Meteor.publish 'notes', ->
		Notes.find({user: {$in: ["public", this.userId]}})


# 
# Client Logic
# 
if Meteor.isClient
	Handlebars.registerHelper(
		'canEditPopover', ->
			'data-toggle="popover" data-trigger="hover" data-placement="left" data-content="Click to Edit"'
	)

	Meteor.autorun ->
		Meteor.subscribe 'groups'
		Meteor.subscribe 'notes'
