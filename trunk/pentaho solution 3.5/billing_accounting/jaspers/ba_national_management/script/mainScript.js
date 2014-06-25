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
var rootUrl=window.location.protocol+'//'+window.location.hostname+':'+window.location.port+"/pentaho/"+rootPath;
var rootPath_Information = 'ViewAction?solution=' + solution + '&path=' + path
		+ '/ba_national_management' + '&action=information_management.xaction';
var rootPath_Billing = 'ViewAction?solution=' + solution + '&path=' + path
		+ '/ba_national_management' + '&action=billing_management.xaction';
var rootPath_AdjustedUnits = 'ViewAction?solution=' + solution + '&path=' + path
		+ '/ba_national_management'
		+ '&action=adjusted_units_management.xaction';

// end process start date , end date
$(document).ready(function() {
	console.log("ready!");
	console.log("jQuery verion: " + jQuery.fn.jquery);
	initProcessingPage();
	if(window.location.hash === "open")
    {
		loadPage();
    }
	
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
	// call request to insert information
	var request = $.ajax({
		url : url,
		type : "POST",		
		dataType : "html"
	});
	request.done(function(html) {
		$('#summary-content div.content').html(html);
		$('#summary-content').removeClass('loading');
	});

	request.fail(function(jqXHR, textStatus) {
		alert("Request failed: " + textStatus);
	});
}
function activeTab(tabTitle) {
	$('#page-tab li').removeClass('active');
	$('#page-tab li[title=\'' + tabTitle + '\']').addClass('active');
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

function goAdjustedUnitPage(){
	urlMaster.clear();
	urlMaster.replaceParam('page','template');
	urlMaster.replaceParam('actionPath','adjusted_units_management');
	loadPage();	
}



