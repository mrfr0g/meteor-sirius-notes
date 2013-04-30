Meteor.startup ->
	Meteor.autorun ->
		groups = Groups.find().fetch()
		if groups.length
			groups = _.map groups, (group) ->
				label = Template.groupSection.label(group)
				_id : group._id
				value : label

			Session.set 'autocompleteGroups', groups

	# Update query name computation
	Meteor.autorun ->
		activeGroup = Groups.findOne(Session.get('activeGroupID'))

		if activeGroup
			$('#groupSelection').val(Template.groupSection.label(activeGroup))


Template.groupSelection.rendered = ->
	$('#groupSelection').autocomplete
		select : (event, ui) ->
			Session.set 'activeGroupID', ui.item._id
		source : (req, res) ->
			# Create a temporary collection to search
			# @todo figure out a better way to do this dude... this is sad
			# An easy method may be to just use the Groups collection et al
			autocompleteGroups = Session.get 'autocompleteGroups'

			groups = new Meteor.Collection null
			_.each autocompleteGroups, (doc) ->
				groups.insert doc

			result = groups.find(
				value : new RegExp(req.term, 'ig')
			)
			.fetch()

			formattedResult = _.map result, (item) ->
				_id : item._id
				value : item.value
				label : item.value

			res(formattedResult)