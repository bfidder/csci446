window.onload = function() {
	document.getElementById('submit').onclick = function() {
		var check = document.getElementById('feelinginput').value;
		if(check == '' || check == NULL) {
			alert('Surely you feel something!');
		}
	}
	var links = document.getElementsByClassName('disable');
	for(var i = 0; i < links.length;i++) {
		links[i].onclick = function() {
			return false;
		}
	}
};

