Meteor.startup ->
	# Update query name computation
	Meteor.autorun ->
		activeGroup = Groups.findOne(Session.get('activeGroupID'))

		if activeGroup
			$('#groupSelection').val(Groups.label(activeGroup))


Template.groupSelection.rendered = ->
	$('#groupSelection').autocomplete
		select : (event, ui) ->
			Session.set 'activeGroupID', ui.item._id
		source : (req, res) ->
			groups = Groups.find({editable: true, readOnly: false}).fetch()
			term = new RegExp(req.term, 'ig')

			formattedResult = _.map groups, (item) ->
				label = Groups.label(item)
				if term.test label
					return {
						_id : item._id
						value : label
						label : label
					}
				false

			res(_.filter(formattedResult, (item) -> item))