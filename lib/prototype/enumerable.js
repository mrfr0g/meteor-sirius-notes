// Partial import of Prototype's enumberable class.
// Modified to:
// 	* Use underscore methods
//  * Attach to the underscore global
// @url https://ajax.googleapis.com/ajax/libs/prototype/1.7.0.0/prototype.js

function eachSlice(arr, number, iterator, context) {
	var index = -number, slices = [], array = _.toArray(arr);
	if (number < 1) return array;
	while ((index += number) < array.length)
		slices.push(array.slice(index, index+number));
	return _.map(slices, iterator, context);
}

// In Groups Of, does NOT fill an empty value now
// Example:
//    _.inGroupsOf([1], 3); 		// returns [[1]]
//    _.inGroupsOf([1,2,3,4], 3); 	// returns [[1,2,3],[4]]
// I find that this works better with Spark
_.inGroupsOf = function(arr, number) {
	return eachSlice(arr, number, function(slice) {
		return slice;
	});
}