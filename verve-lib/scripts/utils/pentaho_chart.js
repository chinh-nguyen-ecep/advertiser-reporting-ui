loadScript(root_folder + "/scripts/highcharts-2.3.5/js/highcharts.js");
loadScript(root_folder + "/scripts/highcharts-2.3.5/js/highcharts-more.js");
loadScript(root_folder + "/scripts/highcharts-2.3.5/js/modules/exporting.js");
//loadScript(root_folder + "/scripts/highcharts-2.3.5/js/themes/gray.js");
loadScript(root_folder + "/scripts/utils/pivot/jquery.dataTables.min.js");
loadScript(root_folder + "/scripts/utils/pivot/dataTables.bootstrap.js");
loadScript(root_folder + "/scripts/utils/pivot/pivot.js");
loadScript(root_folder + "/scripts/utils/pivot/jquery_pivot.js");

//This function will genera chart from json content in divResult content
var generateChart=function(settings){
	settings=$.extend({},{
						divResult: '',
						jsonData: {},	
						chartTitle: 'Chart title',
						chartSubTitle: function(){return 'Sub title'}, //can be string or an function
						miniMode: false
						},
						settings);
	var divResult=settings.divResult;
	var jsonData=settings.jsonData;
	var miniMode=settings.miniMode;
	
	var jsonObject=jsonData;
	//alert(jsonObject.chartTitle);
	//return true;
	divResult.empty();

	var chartTitle=settings.chartTitle;		
	var chartSubTitle='';
	if($.type(settings.chartSubTitle)=='function'){
		chartSubTitle=settings.chartSubTitle();
	}else{
		chartSubTitle=settings.chartSubTitle;
	}
	var chartType=jsonObject.chartType;
	var chart_polar=jsonObject.chart_polar;
	var chartSingleMode=jsonObject.chartSingleMode;
	var data=jsonObject.chartData;
	var agg=jsonObject.agg;
	var fields=jsonObject.fields;
	//Check data query if no data
	var jsonData=jQuery.parseJSON(data);	
	if(jsonData.length==1){
		alertText('Result no data!');
		return;
	}
	
	//end check data
	var chartName=divResult.attr('id')+'_pivot_chart';
	if(divResult.attr('id') === undefined){
		chartName=divResult.attr('name')+'_pivot_chart';
	}
	var chartDom=$('<div class="chartBackground" style=""><div id="'+chartName+'"></div></div>');
	var v_result_table=$('<div name="results_table"></div>');
	var pivot_div=$('<div></div>');

	if(chartSingleMode==false){
		chartDom=$('<div style="height: 100%;width:100%;" id="'+chartName+'"></div>');
		v_result_table.hide();
	}	
	//append chartDom and result table to divResult
	divResult.append(chartDom);
	divResult.append(v_result_table);
	
	//setup data table
	
    $.extend( $.fn.dataTable.defaults, {
        "bFilter": false,
        "bPaginate": false,
        "bLengthChange": false,
        //"bSort": false,
        "bInfo": false,
		"bSortable": false
    } );
	
	var setupPivot=function(input){
		input.callbacks = {afterUpdateResults: function(){
		  v_result_table.find('table').dataTable({
			"sDom": "<'row'<'span6'l><'span6'f>>t<'row'<'span6'i><'span6'p>>",
			"iDisplayLength": 50,
			"aLengthMenu": [[25, 50, 100, -1], [25, 50, 100, "All"]],
			"sPaginationType": "bootstrap",
			"oLanguage": {
			  "sLengthMenu": "_MENU_ records per page"
			},	
			"fnDrawCallback": function( oSettings ) {
			  drawChart();
			}
		  });
		}};
		pivot_div.pivot_display('setup', input);
	  };


	//draw chart
	var chart=null;
	var drawChart=function(){
		if(chart != null){
			chart.destroy();
		}	
		var table = v_result_table.find('table'),
		options = {
			chart: {
				renderTo: chartName,
				backgroundColor: 'none',
				defaultSeriesType:chartType,
				zoomType: 'xy',
				polar: chart_polar
			},
			credits:{
				text: 'Vervemobile.com',
				href: 'http://www.vervemobile.com/'
			},
			title: {
				text: chartTitle
			},
			subtitle: {
				text: chartSubTitle
			},
			tooltip: {
				backgroundColor: {
					linearGradient: [0, 0, 0, 60],
					stops: [
						[0, '#FFFFFF'],
						[1, '#E0E0E0']
					]
				},
				borderWidth: 1,
				borderColor: '#AAA'
			},
			legend: {
				layout: 'vertical',
				backgroundColor: '#FFFFFF',
				align: 'right',
				verticalAlign: 'top',
				x: -20,
				y: 70,
				floating: false,
				shadow: true
			},
			plotOptions: {
				bar: {
					dataLabels: {
						enabled: true
					}
				},
				column: {
					dataLabels: {
						enabled: true
					}
				}
			},
			xAxis: {
				type: 'date',
				dateTimeLabelFormats: {
					day: '%y-%m-%e'                
				}
			},
		   yAxis: {
			  title: {
				 text: 'Unit Count'
			  }
		   },
		   tooltip: {
			  formatter: function() {
				 return '<b>'+ this.series.name +'</b><br/>'+
					this.y +' '+ this.x.toLowerCase();
			  }
		   }
		};
		if(miniMode==true){
			options.legend={
				layout: 'horizontal',
				backgroundColor: '#FFFFFF',
				floating: false,
				shadow: true				
			}
			options.plotOptions={
				bar: {
					dataLabels: {
						enabled: false
					}
				},
				column: {
					dataLabels: {
						enabled: false
					}
				}			
			}
		
		}
		var visualize = function(table, options) {
			// the categories
			options.xAxis.categories = [];
			$('tbody tr', table).each( function(i) {
				options.xAxis.categories.push($(this).children(':first').text());
			});

			// the data series
			options.series = [];
			$('tr', table).each( function(i) {
				var tr = this;
				$('th, td', tr).each( function(j) {
					if (j > 0) { // skip first column
						if (i == 0) { // get the name and init the series
							options.series[j - 1] = {
								name: this.innerHTML,
								data: []
							};
						} else { // add values
							var value=this.innerText;
							value = value.replace(/^\s+|\s+$/g,'');
							if(value==''){
								value='0';
							}
							options.series[j - 1].data.push(parseFloat(value));
						}
					}
				});
			});

			var chart = new Highcharts.Chart(options);
			return chart;
		}
		chart=visualize(table, options); 
		
	}

	//alert(fields[3].summarizable);
	agg=$.extend({},{json:data, fields: fields,result_table:v_result_table},agg);
    setupPivot(agg);
	pivot_div.pivot_display('reprocess_display', agg);
	
}