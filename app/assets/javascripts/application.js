// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.  //= require jquery3
  //= require popper
  //= require bootstrap-sprockets

//
//= require rails-ujs
//= require activestorage
//= require turbolinks
//= require_tree .

const words = ["Explore", "Experiment", "Express", "Experience"];
let i = 0;
let timer;

function typingEffect() {
	let word = words[i].split("");
	var loopTyping = function() {
		if (word.length > 0) {
			document.getElementById('word').innerHTML += word.shift();
		} else {
			deletingEffect();
			return false;
		};
		timer = setTimeout(loopTyping, 500);
	};
	loopTyping();
};

function deletingEffect() {
	let word = words[i].split("");
	var loopDeleting = function() {
		if (word.length > 0) {
			word.pop();
			document.getElementById('word').innerHTML = word.join("");
		} else {
			if (words.length > (i + 1)) {
				i++;
			} else {
				i = 0;
			};
			typingEffect();
			return false;
		};
		timer = setTimeout(loopDeleting, 200);
	};
	loopDeleting();
};

typingEffect();



<script type="text/javascript" src="http://code.jquery.com/jquery-1.6.3.min.js"></script>
<script type="text/javascript" src="scripts/jquery.cycle.all.2.74.js"></script>
<script>
$(document).ready(function() {
	$('#slideshow').cycle({
	fx: 'fade',
	pager: '#smallnav',
	pause:   1,
	speed: 1800,
	timeout:  3500
	});
});
</script>