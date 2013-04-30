# Template.byGroup.events
# 	'keydown h1, blur h1' : (event) ->
# 		if not Session.get('editingGroup')
# 			null

# 		if event.type is 'keydown' and event.which is 13
# 			event.preventDefault()
# 			save = true

# 		if event.type is 'blur' or save
# 			Groups.update(
# 				Session.get('editingGroup'),
# 				$set : 
# 					label : event.target.innerText
# 			)
# 			if Session.get('editingGroup') is Session.get('activeGroupID')
# 				Session.set 'activeGroupLabel', event.target.innerText

# 	'focus h1' : (event) ->
# 		Session.set 'editingGroup', @_id

# Template.byGroup.rendered = ->
# 	$popoverTarget = $(this.findAll('[data-toggle="popover"]'))
# 	$popoverTarget.popover('destroy')
# 	$popoverTarget.popover()

# Template.byGroup.helpers
# 	label : (time) ->
# 		@label or 'Started ' + moment.unix(time).calendar()
# 	hasNotes : (group) ->
# 		group.notes.count()