/**
 * 
 */

// config var for this page
var selectStartDate = rollBackSevenDay;
var selectEndDate = yesterday;
if (urlMaster.getParam('where[full_date.between]') == '') {
	var dateRange = selectStartDate.format('yyyy-mm-dd') + '..'
			+ selectEndDate.format('yyyy-mm-dd');
	urlMaster.replaceParam('where[full_date.between]', dateRange);
} else {
	var dateRange = urlMaster.getParam('where[full_date.between]');
	var dateRangeArray = dateRange.split("..");
	selectStartDate = verveDateConvert(dateRangeArray[0]);
	selectEndDate = verveDateConvert(dateRangeArray[1]);
}

////////////////////////
// register variable
///////////////////////
var chart;// chart object
var subtitle; // subtitle of chart
var title; // titile of chart
var categories = [ '2013/10/01', '2013/10/02', '2013/10/03', '2013/10/04',
		'2013/10/05', '2013/10/06', '2013/10/07' ];
var firstData = [ 75210.53, 60458.54, 59711.42, 48817.37, 77542.50, 75413.57,
		76140.97 ];
var secondData = [ 49077790, 69571356, 60724855, 73158140, 53020304, 81620436,
		74791664 ];
var thirdData = [ 49077790, 69571356, 0, 73158140, 53020304, 81620436, 74791664 ];
var fourData = [ 49077790, 69571356, 0, 73158140, 53020304, 81620436, 74791664 ];
var table_data = []; // data to show by table
var myTable; // table object
var myDateRangeInput; // Date rang input object
/////////////////////////////////
// start page ready
////////////////////////////////
$(document).ready(
		function() {
			generateDateBox();
			generateAngencyFilter();
			setTabActive("overview");
			loadChart();
		});
/////////////////////////////////
// generate date box
////////////////////////////////
function generateDateBox(){
	myDateRangeInput = new generateDateRange({
		stargetId : "overview-date_range",
		start_date : selectStartDate,
		end_date : selectEndDate,
		callback : function(start_date, end_date, value) {
			selectStartDate = start_date;
			selectEndDate = end_date;
			var dateRange = selectStartDate.format('yyyy-mm-dd') + '..'
					+ selectEndDate.format('yyyy-mm-dd');
			urlMaster.replaceParam('where[full_date.between]',
					dateRange);
			loadChart();
		}
	});
}
////////////////////////////
// load agency filter
////////////////////////////
function generateAngencyFilter(){
	var url=apiRootUrl+'/LookupNetworks?select=network_id|title&where[dt_expire]=9999-12-31';
	$.ajax({
		dataType : "json",
		url : url,
		success: function(json){
			processData(json.data);
		}
	});
	function processData(data){
		var rows=[];
		var row='<option value="0">All Agency</option>';
		rows.push(row);
		for(var i=0;i<data.length;i++){
			var value=data[i][0];
			var name=data[i][1];
			row='<option value="'+value+'">'+name+'</option>';
			rows.push(row);
		}
		$('#selectbox_agency').html(rows.join(""));
		urlMaster.replaceParam('where[network_id]',$('#selectbox_agency').val());
	}
	$('#selectbox_agency').change(function(){
		urlMaster.replaceParam('where[network_id]',$('#selectbox_agency').val());
		delayTimeout(1000, function(){
			loadChart();
		});
		
	});
	

}
////////////////////////////
// function loadChart
////////////////////////////
function loadChart() {
	console.log('Load overview chart group by Date');
	myDateRangeInput.disable();
	var dateRange_value = 'where[full_date.between]='
							+ urlMaster.getParam('where[full_date.between]');
	var agencyFilter = '';
	if(urlMaster.getParam('where[network_id]')>0){
		agencyFilter = '&where[network_id]='+urlMaster.getParam('where[network_id]');
	}
	
	var url = apiRootUrl
				+ '/dailyAggDemandByOffer?select=full_date&limit=2000&'
				+ dateRange_value + "&by=imps|clicks"+agencyFilter;
	console.log('Url: ' + url);
	if (myAjaxStore.isLoading(url)) {
		console.log('Your request is loading...');
		console.log('Callback after ' + loadingCallback + 's...');
		delayTimeout(loadingCallback, function() {
			loadChart();
		});
		return;
	}
	if (chart != null) {
		chart.showLoading();
	}
	var ajaxData = myAjaxStore.get(url);
	if (ajaxData == null) {
		myAjaxStore.registe(url);
		$.ajax({
			dataType : "json",
			url : url,
			timeout : 10000,
			xhrFields : {
				withCredentials : true
			},
			success : function(json) {
				myAjaxStore.add(url, json);
				console.log('Load ajax request successfull with url: ' + url);
				loadChart();

			},
			error : function(xhr, status, error) {
				myAjaxStore.remove(url);
				console.log('Request url error: ' + url);
				console.log('Status:  ' + status);
				console.log('Error:  ' + error);
				console.log('Reload chart!');
				if (error == 'timeout') {
					loadChart();
				} else {
					delayTimeout(2000, function() {
						// location.reload(false);
					});
				}
			},
			complete : function() {

			}

		});
	} else {
		processData(ajaxData);
		if (ajaxData.data.length == 0) {
			var mydialog = new contentDialog();
			mydialog.setTitle("Dashboard Overview Message!");
			mydialog
					.setContent("Your data from "
							+ selectStartDate.format('yyyy-mm-dd') + " to "
							+ selectEndDate.format('yyyy-mm-dd')
							+ " is not available.");
			mydialog.open();
		}
	}
	function processData(json) {
		var responseStatus = json.responseStatus;
		var page = json.page;
		if (responseStatus == 'OK' && page == 1) {
			data = json.data;
			// generate table data
			table_data=[];
			//add any value
			
			for(var i=0;i<data.length;i++){
					var date=data[i][0];
					var imp=data[i][1];
					var click=data[i][2];
					var ctr=parseFloat(click)/parseFloat(imp);
					table_data[i]=[date,imp,click,ctr];
			}
			
			myTable = new drawTableFromArray({
				table_id : 'dashboard-overview-dataTable',
				table_colums : [ 'Date', 'Impressions', 'Clicks', 'CTR' ],
				columns_format : [ '', 'number', 'number', '%' ],
				table_data : table_data,
				page_items : 31,
				paging : true,
				sort_by : 'Date',
				sortable : true,
				onClickRow : function(row) {
					// alert(row[0]);
				}
			});

			// generate data for chart
			categories = [];
			firstData = [];
			secondData = [];
			//thirdData = [];
			//fourData = [];
			var temp_data = table_data;
			temp_data.reverse();
			$.each(temp_data, function(index, row) {
				var category_value = row[0];
				categories.push(category_value);
				var first_value = parseFloat(row[1]);
				var second_value = parseFloat(row[2]);
				//var third_value = parseFloat(row[3]);
				// var four_value=parseFloat(row[4]);
				firstData.push(first_value);
				secondData.push(second_value);
				//thirdData.push(third_value);
				// fourData.push(four_value);
			});
			// draw chart
			if (chart) {
				chart.hideLoading();
			}
			rawChart();

			// Caculate Average Values
			var temp_data = table_data;
			temp_data.reverse();
			var total_first_value = 0;
			var total_second_value = 0;
			//var total_third_value = 0;
			//var total_four_value = 0;
			$.each(temp_data,
					function(index, row) {
						var first_value = row[1];
						var second_value = row[2];
						var third_value = row[3];
						// var four_value=row[4];
						total_first_value = total_first_value
								+ parseFloat(first_value);
						total_second_value = total_second_value
								+ parseFloat(second_value);
						//total_third_value = total_third_value + parseFloat(third_value);
						// total_four_value=total_four_value+parseFloat(four_value);
					});
			// Set average value
			$('span.av-impression').html(
					''
							+ accounting.formatNumber(total_first_value
									/ temp_data.length));
			$('span.av-clicks').html(
					''
							+ accounting.formatNumber(total_second_value
									/ temp_data.length));
			//$('span.av-cta-any').html(
			//				+ accounting.formatNumber(total_third_value
			//						/ temp_data.length));
			// $('span.av-bid-price').html(''+accounting.formatMoney(total_four_value/temp_data.length));

		}
		// unable date range input
		myDateRangeInput.unable();
	}
}
///////////////////////////////////
// function generate height chart
//////////////////////////////////
function rawChart() {
	var chart_title = "VLMO";
	$('#container').highcharts(
			{
				chart : {
					zoomType : 'xy'
				},
				title : {
					text : chart_title
				},
				subtitle : {
					text : 'From ' + selectStartDate.format('yyyy-mm-dd')
							+ ' To ' + selectEndDate.format('yyyy-mm-dd')
				},
				credits : {
					href : 'http://www.vervemobile.com',
					text : 'vervemobile.com'
				},
				xAxis : [ {
					categories : categories,
					// tickmarkPlacement: 'on',
					title : {
						enabled : false
					},
					// gridLineWidth: 1,
					labels : {
						rotation : -45,
						formatter : function() {
							var value = this.value;							
							var now = verveDateConvert(value);
							return now.format("mmm dd");
						}
					}
				} ],
				yAxis : [ { // Primary
					labels : {
						formatter : function() {
							return accounting.formatNumber(this.value);
						},
						style : {
							color : '#58ACFA '
						}
					},
					title : {
						text : 'Clicks',
						style : {
							color : '#58ACFA'
						}
					},
					opposite : true

				}, { // Tertiary
					labels : {
						formatter : function() {
							return accounting.formatNumber(this.value);
						},
						style : {
							color : '#848484'
						}
					},
					title : {
						text : 'Impressions',
						style : {
							color : '#848484'
						}
					}
					
				} ],
				tooltip : {
					shared : true,
					formatter : function() {
						console.log(this.x);
						var date_Value = verveDateConvert(this.x);
						var s = '<b>' + date_Value.format('mmm d, yyyy')
								+ '</b>';
						$.each(this.points, function(i, point) {
							if (point.series.name == 'Impressions') {
								s += '<br/><font style="color: #848484;">'
										+ point.series.name + ': '
										+ accounting.formatNumber(point.y)
										+ '</font>';
							} else if (point.series.name == 'Clicks') {
								s += '<br/><font style="color: #58ACFA;">'
										+ point.series.name + ': '
										+ accounting.formatNumber(point.y)
										+ '</font>';
							} else if (point.series.name == 'Cta any') {
								s += '<br/><font style="color: #80FF00;">'
										+ point.series.name + ': '
										+ accounting.formatNumber(point.y)
										+ '</font>';
							} else {
								s += '<br/>' + point.series.name + ': '
										+ accounting.formatMoney(point.y);
							}

						});
						return s;
					}
				},
				legend : {
					// layout: 'vertical',
					// align: 'left',
					// x: 100,
					// verticalAlign: 'top',
					// y: 0,
					// floating: true,
					backgroundColor : '#FFFFFF'
				},
				series : [ {
					name : 'Impressions',
					color : '#848484',
					type : 'column',					
					data : firstData,
					yAxis : 1
				} ,
				{
					name : 'Clicks',
					color : '#58ACFA',
					type : 'line',
					data : secondData
				}]
			});
	chart = $('#container').highcharts();
}
/////////////////////////////////////////////
// function load data for hour level
////////////////////////////////////////////
function loadDataForByHour() {
	var dateRange_value = 'where[full_date.between]='
			+ urlMaster.getParam('where[full_date.between]');
	var url = apiRootUrl
			+ '/revenueByHour?select=full_date|hour24_of_day&limit=2000&'
			+ dateRange_value + "&by=pais|pid";
	if (myAjaxStore.isLoading(url)) {
		return;
	}
	var ajaxData = myAjaxStore.get(url);
	if (ajaxData == null) {
		myAjaxStore.registe(url);
		$.ajax({
			dataType : "json",
			url : url,
			timeout : ajaxRequestTimeout,
			xhrFields : {
				withCredentials : true
			},
			success : function(json) {
				myAjaxStore.add(url, json);
			},
			error : function(xhr, status, error) {
				myAjaxStore.remove(url);
			},
			complete : function() {

			}

		});
	} else {
	}
}
//////////////////////////////////////
// Review export data
//////////////////////////////////////
function reviewExportData() {
	var network_id = $('#selectbox_agency').val();
	var title= $('#selectbox_agency option:selected').text();
	var mydialog = new contentDialog();
	mydialog.setTitle('Daily VLMO by Date From '
			+ selectStartDate.format('yyyy-mm-dd') + ' To '
			+ selectEndDate.format('yyyy-mm-dd'));
	var randomID = new Date().valueOf();
	mydialog.setContent('<div title="' + randomID
			+ '" class="loadingDots" style=""></div>');
	mydialog.setWidth(700);
	mydialog.open();

	mydialog.setTitle('Daily VLMO by Date From '
			+ selectStartDate.format('yyyy-mm-dd') + ' To '
			+ selectEndDate.format('yyyy-mm-dd'));
	var exchanger = $('#exchange_filter').val();
	var loadingUrl = rootUrl + '/GenerateJasperReport'
			+ '?export_type=html&jrxml=daily_vlmo&p_end_date='
			+ selectEndDate.format('yyyy-mm-dd') + '&p_start_date='
			+ selectStartDate.format('yyyy-mm-dd') + '&path=vlmo'
			+ "&p_network_id=" + network_id+"&p_title="+title;
	var htmlResult;

	if (myAjaxStore.isLoading(loadingUrl)) {
		mydialog
				.setContent('Your request is being processed. Please come back later 30s!');
	} else {
		htmlResult = myAjaxStore.get(loadingUrl);
		if (htmlResult == null) {
			myAjaxStore.registe(loadingUrl);
			$.ajax({
				url : loadingUrl,
				dataType : 'html',
				success : function(data) {
					myAjaxStore.add(loadingUrl, data);
					mydialog.setContent(data);
				},
				error : function(xhr, status, error) {
					myAjaxStore.remove(loadingUrl);
					console.log('Generate report fail! ');
					console.log('Url: ' + loadingUrl);
				},
				complete : function(jqXHR, textStatus) {

				}
			});
		} else {
			console.log('Set content for div id title=' + randomID);
			mydialog.setContent(htmlResult);
		}
	}
}
///////////////////////////////////
// export data to pdf,csv,xls
///////////////////////////////////
function exportReport(exportType) {
	var network_id = $('#selectbox_agency').val();
	var title= $('#selectbox_agency option:selected').text();
	var loadingUrl = rootUrl + '/GenerateJasperReport' + '?export_type='
			+ exportType + '&jrxml=daily_vlmo&p_end_date='
			+ selectEndDate.format('yyyy-mm-dd') + '&p_start_date='
			+ selectStartDate.format('yyyy-mm-dd') + '&path=vlmo'
			+ "&p_network_id=" + network_id+"&p_title="+title;
	window.open(loadingUrl);
}
