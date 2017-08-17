function pushIfNotExist(jsonArray, jsonObject, propertyName, value) {
	for (var i=0; i < jsonArray.length; i++) {
		if (jsonArray[i][propertyName] == value)
			return jsonArray;
	}
	jsonArray.push(jsonObject);
	return jsonArray;
}

function pushIfNotExist(jsonArray, jsonObject, propertyName) {
	for (var i=0; i < jsonArray.length; i++) {
		if (jsonArray[i][propertyName] == jsonObject[propertyName])
			return jsonArray;
	}
	jsonArray.push(jsonObject);
	return jsonArray;
}

function removeIfExist(jsonArray, propertyName, value) {
	var newArray = new Array();
	for (var i=0; i < jsonArray.length; i++) {
		if (jsonArray[i][propertyName] != value) {
			newArray.push(jsonArray[i]);
		}
	}
	return newArray;
}

function getElementHavingPropertyWithValue(jsonArray, propertyName, value) {
	for (var i=0; i < jsonArray.length; i++) {
		if (jsonArray[i][propertyName] == value) {
			return (jsonArray[i]);
		}
	}
	return null;
}

function pushUniqueValue(array, value) {
	if (array.indexOf(value) < 0) {
		array.push(value);
	}
	return array;
}
function popByValue(array, value) {
	if (array.indexOf(value) >= 0) {
		var spliced = array.splice(array.indexOf(value));
		spliced.shift(1);
		return array.concat(spliced);
	} else {
		return array;
	}
}