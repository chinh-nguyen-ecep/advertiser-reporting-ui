/**
 * 
 */
setTabActive("overview");
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
var chart;// chart object
var chart2;// chart object
var subtitle; // subtitle of chart
var title; // titile of chart
var table_data = []; // data to show by table
var myTable; // table object

var series_chartData = [ {
							borderWidth : 1,
							nullColor : '#EFEFEF',
							colsize : 0.03,
							animation: true,
							tooltip : {
								headerFormat: '',
								pointFormat : '<b>Bid Price: ${point.x}</b><br/>Winrate: {point.y:.2f}% <br/>Wins: {point.value:,.0f}',
							},
							data : [ [ 0.079, 5.38, 37 ],
									[ 0.16342, 2.10, 778 ] ]
						} ];
var series_chartData2 = [ {
							    name: 'Bids',
							    color: '#0489B1',
							    type: 'line', 
							    data: [[0.01,100],[0.02,120],[0.03,90]]
							},{
							    name: 'Wins',
							    color: '#FA5858',
							    type: 'line',
							    data: [[0.01,90],[0.02,100],[0.03,80]]    
							}];
var myDateRangeInput; // Date rang input object
$(document).ready(
		function() {
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
			loadChart();
		});

function loadChart() {
	myDateRangeInput.disable();
	var dateRange_value = 'where[full_date.between]='+ urlMaster.getParam('where[full_date.between]');
	var where_value='';
	if($('#exchange_filter').val()!='All Exchanges'){
		where_value="&where[exchange]="+$('#exchange_filter').val(); 			
	}
	var url = apiRootUrl+ '/dailyExchangeWinrate?select=bid_price&limit=999999999&'+ dateRange_value + "&by=bids|wins&order=bid_price"+where_value;
	if (myAjaxStore.isLoading(url)) {
		console.log('Your request is loading...');
		console.log('Callback after ' + loadingCallback + 's...');
		delayTimeout(loadingCallback, function() {
			loadChart();
		});
		return;
	}
	if (chart != null && chart2 != null) {
		chart.showLoading();
		chart2.showLoading();
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
		// unable date range input
		myDateRangeInput.unable();
		//
		var responseStatus = json.responseStatus;
		var page = json.page;
		if (responseStatus == 'OK' && page == 1) {
			// generate table data
			table_data = [];
			for (var i = 0; i < json.data.length; i++) {
				var bid_price = parseFloat(json.data[i][0]);
				var bid_count = parseFloat(json.data[i][1]);
				var impression_count = parseFloat(json.data[i][2]);
				var win_rate = impression_count / bid_count;
				table_data.push([ bid_price, bid_count, impression_count,
						win_rate ]);
			}
			

			// generate chart data
			series_chartData[0].data = [];
			series_chartData2[0].data=[];
			series_chartData2[1].data=[];
			for (var i = 0; i < table_data.length; i++) {
				var bid_price = table_data[i][0];
				var bid_cnt= table_data[i][1];
				var impression_count = table_data[i][2];
				var win_rate = table_data[i][3];
				series_chartData[0].data.push([ bid_price, win_rate * 100,impression_count ]);
				series_chartData2[0].data[i]=([bid_price,bid_cnt]);
				series_chartData2[1].data[i]=([bid_price,impression_count]);
			}
			// draw chart
			drawChart();
			// draw second chart
			drawChart2();
			
			myTable = new drawTableFromArray({
				table_id : 'winrate_dataTable',
				table_colums : [ 'Bid Price', 'Bids', 'Wins','Winrate%' ],
				columns_format : [ 'money', 'number', 'number', '%' ],
				table_data : table_data,
				page_items : 10,
				paging : true,
				sort_by : 'Bid Price',
				sortable : true,
				onClickRow : function(row) {
					// alert(row[0]);
				}
			});
		}
	}
	function drawChart() {
		var chart_title="Winrate Heatmap per Bid Price";
		var exchange=$('#exchange_filter').val();
		if(exchange !="All Exchanges"){
 			chart_title=capitalise(exchange)+' '+chart_title;
 		}
		$('#chart-container').highcharts(
						{
							chart : {
								type : 'heatmap'
							},
							title : {
								text : chart_title
							},
							subtitle : {
								text : 'From '+selectStartDate.format('yyyy-mm-dd')+' To '+selectEndDate.format('yyyy-mm-dd')
							},
							credits:{
				            	href: 'http://www.vervemobile.com',
				            	text: 'vervemobile.com'
				            },
							tooltip : {
								backgroundColor : null,
								borderWidth : 0,
								distance : 10,
								shadow : false,
								useHTML : true,
								style : {
									padding : 0,
									color : 'black'
								}
							},
							xAxis : {
								min : 0,
								labels : {
									align : 'left',
									x : 0.1,
									format : '${value}' // long month
								},
								showLastLabel : false,
								tickLength : 0.5,
								title : {
									text : 'Bid Price'
								}
							},
							yAxis : {
								title: {
					                text: 'Winrate (wins/bids %)'					               
					            },
								labels : {
									format : '{value}%'
								},								
								tickPositions : [ 0, 10, 20, 30, 40, 50, 60,70, 80, 90, 100 ],
								tickWidth : 1,
								min : 0,
								max : 100
							},
							colorAxis : {
								stops : [ [0, '#0080FF' ],[ 1, '#DF0101' ] ],
								labels : {
									format : '{value:,.0f}'
								},
								min: 0,
					            //max: 25,
					            startOnTick: false,
					            endOnTick: false,
							},
							series : series_chartData

						});
		chart=$('#chart-container').highcharts();
		$('#chart-container').removeClass('loading');
	}
}

//////////////////////////////////////////////
// Second chart
/////////////////////////////////////////////
	//function generate chart 
	function drawChart2(){
		console.log(series_chartData2);
		var exchange=$('#exchange_filter').val();
		var chart_title="Wins and Bids Distribution per Bid Price Points";
		if(exchange !="All Exchanges"){
			chart_title=capitalise(exchange)+' '+chart_title;
 		}
		$('#chart-container-2').highcharts({
        chart: {
            zoomType: 'xy',
            panning: true,
            panKey: 'shift'
        },
        title: {
            text: chart_title
        },
        subtitle: {
            text: 'From '+selectStartDate.format('yyyy-mm-dd')+' To '+selectEndDate.format('yyyy-mm-dd')
        },
        credits:{
        	href: 'http://www.vervemobile.com',
        	text: 'vervemobile.com'
        },
        xAxis: [{
            title: {
                enabled: false
            },
            labels: {
                rotation: -45,
                formatter: function() {
                    return accounting.formatMoney(this.value);;
                }
            }
        }],
        tooltip: {
            shared: true,
            formatter: function() {
            	var value=this.x;
            	var s = '<b>Bid Price: '+ accounting.formatMoney(value)+'</b>';                    
                $.each(this.points, function(i, point) {
                	if(point.series.name=='Wins'){
                		s += '<br/><font style="color: #FA5858;">'+ point.series.name +': '+
                        accounting.formatNumber(point.y)+'</font>';                    		
                	}else if(point.series.name=='Bids'){
                		s += '<br/><font style="color: #0489B1;">'+ point.series.name +': '+
                        accounting.formatNumber(point.y)+'</font>';                    		
                	}
                    
                });
                return s;                    
            }
        },
        yAxis: [{ // Primary
        	min: 0,
            labels: {
                formatter: function() {
                    return accounting.formatNumber(this.value);
                }                
            },
            title: {
                text: null               
            },

        }],
        series: series_chartData2
    });
		chart2=$('#chart-container-2').highcharts();
	}
//////////////////////////////////////////////
//
///////////////////////////////
	//echanger filter 
	$("#exchange_filter").select2({
	    placeholder: "Select Exchange",
	    allowClear: true
	});
	$("#exchange_filter").change(function(){
		loadChart();		
	});
//////////////////////////////////////////////
///
///////////////////////////////////////////////
	function reviewExportData(){
		var mydialog=new contentDialog();
		var randomID=new Date().valueOf();
		mydialog.setContent('<div title="'+randomID+'" class="loadingDots" style=""></div>');
		mydialog.setWidth(700);
		mydialog.open();
		
		mydialog.setTitle('Exchange Winrate Analysis From '+selectStartDate.format('yyyy-mm-dd')+' To '+selectEndDate.format('yyyy-mm-dd'));
		var exchanger=$('#exchange_filter').val();
		var	loadingUrl=rootUrl+'/GenerateJasperReport'+'?export_type=html&jrxml=exchange_winrate&p_end_date='+selectEndDate.format('yyyy-mm-dd')+'&p_start_date='+selectStartDate.format('yyyy-mm-dd')+'&path=exchangePayout'+"&p_exchange="+exchanger;
		var htmlResult;
		
		if(myAjaxStore.isLoading(loadingUrl)){
			mydialog.setContent('Your request is being processed. Please come back later 30s!');
		}else{
			htmlResult=myAjaxStore.get(loadingUrl);
			if(htmlResult==null){
				myAjaxStore.registe(loadingUrl);
				$.ajax({
					url: loadingUrl,
					dataType : 'html',
					success: function(data){
						myAjaxStore.add(loadingUrl,data);
						mydialog.setContent(data);
					},
					error: function(xhr,status,error){
						myAjaxStore.remove(loadingUrl);
						console.log('Generate report fail! ');
						console.log('Url: '+loadingUrl);
					},
					complete: function(jqXHR,textStatus){
						
					}
				});
			}else{
				console.log('Set content for div id title='+randomID);
				mydialog.setContent(htmlResult);
			}
		}
	}
	
	function exportReport(exportType){
		var exchanger=$('#exchange_filter').val();
		var	loadingUrl=rootUrl+'/GenerateJasperReport'+'?export_type='+exportType+'&jrxml=exchange_winrate&p_end_date='+selectEndDate.format('yyyy-mm-dd')+'&p_start_date='+selectStartDate.format('yyyy-mm-dd')+'&path=exchangePayout'+"&p_exchange="+exchanger;
		window.open(loadingUrl);
	}
	
	
	
	
/////////////////////////////////////////////
/// install plugin heatmap for hightchart
////////////////////////////////////////////////
/**
 * This plugin extends Highcharts in two ways: - Use HTML5 canvas instead of SVG
 * for rendering of the heatmap squares. Canvas outperforms SVG when it comes to
 * thousands of single shapes. - Add a K-D-tree to find the nearest point on
 * mouse move. Since we no longer have SVG shapes to capture mouseovers, we need
 * another way of detecting hover points for the tooltip.
 */
(function(H) {
	var wrap = H.wrap, seriesTypes = H.seriesTypes;

	/**
	 * Recursively builds a K-D-tree
	 */
	function KDTree(points, depth) {
		var axis, median, length = points && points.length;

		if (length) {

			// alternate between the axis
			axis = [ 'plotX', 'plotY' ][depth % 2];

			// sort point array
			points.sort(function(a, b) {
				return a[axis] - b[axis];
			});

			median = Math.floor(length / 2);

			// build and return node
			return {
				point : points[median],
				left : KDTree(points.slice(0, median), depth + 1),
				right : KDTree(points.slice(median + 1), depth + 1)
			};

		}
	}

	/**
	 * Recursively searches for the nearest neighbour using the given K-D-tree
	 */
	function nearest(search, tree, depth) {
		var point = tree.point, axis = [ 'plotX', 'plotY' ][depth % 2], tdist, sideA, sideB, ret = point, nPoint1, nPoint2;

		// Get distance
		point.dist = Math.pow(search.plotX - point.plotX, 2)
				+ Math.pow(search.plotY - point.plotY, 2);

		// Pick side based on distance to splitting point
		tdist = search[axis] - point[axis];
		sideA = tdist < 0 ? 'left' : 'right';

		// End of tree
		if (tree[sideA]) {
			nPoint1 = nearest(search, tree[sideA], depth + 1);

			ret = (nPoint1.dist < ret.dist ? nPoint1 : point);

			sideB = tdist < 0 ? 'right' : 'left';
			if (tree[sideB]) {
				// compare distance to current best to splitting point to decide
				// wether to check side B or not
				if (Math.abs(tdist) < ret.dist) {
					nPoint2 = nearest(search, tree[sideB], depth + 1);
					ret = (nPoint2.dist < ret.dist ? nPoint2 : ret);
				}
			}
		}
		return ret;
	}

	// Extend the heatmap to use the K-D-tree to search for nearest points
	H.seriesTypes.heatmap.prototype.setTooltipPoints = function() {
		var series = this;

		this.tree = null;
		setTimeout(function() {
			series.tree = KDTree(series.points, 0);
		});
	};
	H.seriesTypes.heatmap.prototype.getNearest = function(search) {
		if (this.tree) {
			return nearest(search, this.tree, 0);
		}
	};

	H.wrap(H.Pointer.prototype, 'runPointActions', function(proceed, e) {
		var chart = this.chart;
		proceed.call(this, e);

		// Draw independent tooltips
		H.each(chart.series, function(series) {
			var point;
			if (series.getNearest) {
				point = series.getNearest({
					plotX : e.chartX - chart.plotLeft,
					plotY : e.chartY - chart.plotTop
				});
				if (point) {
					point.onMouseOver(e);
				}
			}
		})
	});

	/**
	 * Get the canvas context for a series
	 */
	H.Series.prototype.getContext = function() {
		var canvas;
		if (!this.ctx) {
			canvas = document.createElement('canvas');
			canvas.setAttribute('width', this.chart.plotWidth);
			canvas.setAttribute('height', this.chart.plotHeight);
			canvas.style.position = 'absolute';
			canvas.style.left = this.group.translateX + 'px';
			canvas.style.top = this.group.translateY + 'px';
			canvas.style.zIndex = 0;
			canvas.style.cursor = 'crosshair';
			this.chart.container.appendChild(canvas);
			if (canvas.getContext) {
				this.ctx = canvas.getContext('2d');
			}
		}
		return this.ctx;
	}

	/**
	 * Wrap the drawPoints method to draw the points in canvas instead of the
	 * slower SVG, that requires one shape each point.
	 */
	H
			.wrap(
					H.seriesTypes.heatmap.prototype,
					'drawPoints',
					function(proceed) {

						var ctx;
						if (this.chart.renderer.forExport) {
							// Run SVG shapes
							proceed.call(this);

						} else {

							if (ctx = this.getContext()) {

								// draw the columns
								H
										.each(
												this.points,
												function(point) {
													var plotY = point.plotY, shapeArgs;

													if (plotY !== undefined
															&& !isNaN(plotY)
															&& point.y !== null) {
														shapeArgs = point.shapeArgs;

														ctx.fillStyle = point.pointAttr[''].fill;
														ctx
																.fillRect(
																		shapeArgs.x,
																		shapeArgs.y,
																		shapeArgs.width,
																		shapeArgs.height);
													}
												});

							} else {
								this.chart
										.showLoading("Your browser doesn't support HTML5 canvas, <br>please use a modern browser");

								// Uncomment this to provide low-level (slow)
								// support in oldIE. It will cause script errors
								// on
								// charts with more than a few thousand points.
								// proceed.call(this);
							}
						}
					});
}(Highcharts));

// /////////////////////////////////////
