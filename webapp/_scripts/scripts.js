/*jslint white: true, browser: true, onevar: true, undef: true, nomen: true, eqeqeq: true, plusplus: true, bitwise: true, regexp: true, newcap: true, immed: true, strict: true */
/*global $: false, window: false */

(function () {
	"use strict";
	
	window.CCARD2011 = {
		init: function () {
			this.hidePopup();
			this.handleMemories();
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
		},
		
		memoryTimer: 0,
		handleMemories: function () {
			var that = this, memories = $('.memories > ul > li');
			console.log('handle');
			if (memories.length) {
			console.log('memories length');
				memories
					.hover(function () {
						$(this).addClass('hover');
					},
					function () {
						that.hideMemory($(this));
					});
			}
		},
		hideMemory: function (memory) {
			var that = this;
			
			this.memoryTimer = setTimeout(function () {
				memory.fadeOut('fast', function () {
					memory.removeClass('hover');
					memory.show();
				});
				
			}, 1000);
		}
	};
	
	$(document).ready(function () {
		window.CCARD2011.init();
	});
}());
