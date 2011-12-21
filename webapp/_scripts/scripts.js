/*jslint white: true, browser: true, onevar: true, undef: true, nomen: true, eqeqeq: true, plusplus: true, bitwise: true, regexp: true, newcap: true, immed: true, strict: true */
/*global $: false, window: false */

(function () {
	"use strict";
	
	window.CCARD2011 = {
		init: function () {
			this.method();
		},
		
		method: function () {
			console.log('CCARD2011');
		}
	};
	
	$(document).ready(function () {
		window.CCARD2011.init();
	});
}());
