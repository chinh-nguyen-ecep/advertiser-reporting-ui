var globalTimeout = null;
function delay_timeout(second_time, func) {
	if (globalTimeout != null)
		clearTimeout(globalTimeout);
	globalTimeout = setTimeout(function() {
		func();
	}, second_time);
}
// this function paser param from url
function gup(name) {
	name = name.replace(/[\[]/, "\\\[").replace(/[\]]/, "\\\]");
	var regexS = "[\\?&]" + name + "=([^&#]*)";
	var regex = new RegExp(regexS);
	var results = regex.exec(window.location.href);
	if (results == null)
		return "";
	else
		return results[1];
}

var solution = gup('solution');
var path = gup('path');
var rootPath = 'ViewAction?solution=' + solution + '&path=' + path
		+ '&action=ba_national_management.xaction';
var rootPath_Information = 'ViewAction?solution=' + solution + '&path=' + path
		+ '/ba_national_management' + '&action=information_management.xaction';
var rootPath_Biiling = 'ViewAction?solution=' + solution + '&path=' + path
		+ '/ba_national_management' + '&action=billing_management.xaction';
var rootPath_AjustedUnits = 'ViewAction?solution=' + solution + '&path=' + path
		+ '/ba_national_management'
		+ '&action=ajusted_units_management.xaction';

// end process start date , end date
$(document).ready(function() {
	console.log("ready!");
	console.log("jQuery verion: " + jQuery.fn.jquery);
	initProcessingPage();
});

// *******************************
// Script code on Processing page
// *******************************
var initProcessingPage = function() {
	loadPage();
};
// *******************************
// Script code on Processing page
// *******************************

function loadPage() {
	var page = urlMaster.getParam('page');
	var actionPath = urlMaster.getParam('actionPath');
	if (page == '') {
		page = 'billing_script';
		actionPath = 'billing_management';
		urlMaster.addParam('page', page);
		urlMaster.addParam('actionPath', actionPath);
	}
	var url = 'ViewAction?solution=' + solution + '&path=' + path
			+ '/ba_national_management' + '&action=' + actionPath + '.xaction'
			+ '&actions=' + page;
	$('#summary-content div.content').load(url, function() {
		$('#summary-content').removeClass('loading');
	});
}
function activeTab(tabTitle) {
	$('#page-tab li').removeClass('active');
	$('#page-tab li[title=' + tabTitle + ']').addClass('active');
}
function goHomePage() {
	var page = 'billing_script';
	var actionPath = 'billing_management';
	urlMaster.replaceParam('page', page);
	urlMaster.replaceParam('actionPath', actionPath);
	loadPage();
}

function goInformationPage() {
	var page = 'information_script';
	var actionPath = 'information_management';
	urlMaster.replaceParam('page', page);
	urlMaster.replaceParam('actionPath', actionPath);
	loadPage();
}



