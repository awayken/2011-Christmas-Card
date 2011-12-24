/*jslint white: true, browser: true, onevar: true, undef: true, nomen: true, eqeqeq: true, plusplus: true, bitwise: true, regexp: true, newcap: true, immed: true, strict: true */
/*global $: false, window: false */

(function () {
	"use strict";
	
	window.CCARD2011 = {
		init: function () {
			this.hidePopup();
		},
		
		hidePopup: function () {
			var pop = $('#popup');
			
			if (location.hash === '#nopopup') {
				pop.remove();
			}
		
			$('a[href="?nopopup"]')
				.click(function (e) {
					e.preventDefault();
					pop.fadeOut("fast", function () {
						pop.remove();
					});
					location.hash = 'nopopup';
				});
		}
	};
	
	$(document).ready(function () {
		window.CCARD2011.init();
	});
}());
