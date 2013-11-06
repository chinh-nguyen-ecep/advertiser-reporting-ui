loadScript(root_folder + "/scripts/highcharts-2.3.5/js/highcharts.js");
loadScript(root_folder + "/scripts/highcharts-2.3.5/js/highcharts-more.js");
loadScript(root_folder + "/scripts/highcharts-2.3.5/js/modules/exporting.js");
//loadScript(root_folder + "/scripts/highcharts-2.3.5/js/themes/gray.js");
loadScript(root_folder + "/scripts/utils/table2CSV.js");
loadScript(root_folder + "/scripts/utils/extractCSV.js");

function initChartPageTemplate(settings){
	settings=$.extend({},{
						controlPanle_width: 300,
						controlPanle_height: 'auto',
						mainDomCotentForm: $('div[name=dialog-form]'),						
						generateFormContent: function(domContentForm,completedFn){},
						formValidation: function(domContentForm){return true},
						doWhenOpenControlPanel: function(domCotentForm){},
						reportName:'Report name',
						timeout: 120000,
						timeoutMessage: 'Request time out. Please try again!',
						},
						settings);
	var controlPanle_width=settings.controlPanle_width;
	var controlPanle_height=settings.controlPanle_height;
	var generateFormContent=settings.generateFormContent;	
	var formValidation=settings.formValidation;
	var controlBT=$('<img class="button_icon" id="open_control" title="Open control panel" src="'+root_folder+'/images/control_panel 16x16.png"/>');
	var chartCompareModeBT=$('<img class="button_icon" id="chart_compare_mode" title="Go to chart compration mode" src="'+root_folder+'/images/compare_chart.png"/>');
	var chartSingleModeBT=$('<img class="button_icon" id="chart_single_mode" title="Back to chart single mode" src="'+root_folder+'/images/1363012211_undo.png"/>');
	var comentDom=$('<span style="font-size: 8pt;font-weight: normal;">We are updating new script. If report don\'t work, please clear your browser\'s cache and try again</span>');
	var logoDom=$('<img title="vervemobile.com" src="'+root_folder+'/images/vervelogo.png" height="16"/>');
	var columnChartBT=$('<img class="button_icon" id="column_chart" title="Column chart" src="'+root_folder+'/images/column_chart.png"/>');
	var barChartBT=$('<img class="button_icon" id="bar_chart" title="Bar chart" src="'+root_folder+'/images/bar_chart.png"/>');
	var lineChartBT=$('<img class="button_icon" id="line_chart" title="Spline chart" src="'+root_folder+'/images/line_chart.png"/>');
	var areaChartBT=$('<img class="button_icon" id="area_chart" title="Area chart" src="'+root_folder+'/images/area_chart.png"/>');
	
	var polarCheckox=$('<div class="group"><label title="The function will be effect when resubmit" for="p_chart_polar">polar<input type="checkbox" value="true" id="p_chart_polar" /></label></div>')
	//Set title
	$('head title').html(settings.reportName);
	//Get content html from template
	var initContentHTMLCode=function(){
		$.ajax({
		  url: root_folder+'/html_template/chartCommonScript.html',
		  dataType: 'html',
		  success: function(data){
			$('body').append(data);
		  },
		  async: false
		});	
	}
	initContentHTMLCode();
	//end
	//init the tool bar
	var initToolBar=function(){
		//left group
		$('div#toolbar div.leftGroup').append(controlBT);
		$('div#toolbar div.leftGroup').append(chartCompareModeBT);
		$('div#toolbar div.leftGroup').append(chartSingleModeBT);
		$('div#toolbar div.leftGroup').append('<span class="slip"/>');
		$('div#toolbar div.leftGroup').append('<span class="reportName">'+settings.reportName+'</span>');
		//right group

		$('div#toolbar div.rightGroup').append(comentDom);
		$('div#toolbar div.rightGroup').append('<span class="slip"/>');	
		$('div#toolbar div.rightGroup').append(polarCheckox);
		$('div#toolbar div.rightGroup').append(columnChartBT);		
		$('div#toolbar div.rightGroup').append(barChartBT);
		$('div#toolbar div.rightGroup').append(lineChartBT);
		$('div#toolbar div.rightGroup').append(areaChartBT);
		
		
		$('#configbt1').click(function(){
			var width=$('#compareScreen').find('iframe[name=theoutput1]').width();
			var height=$('#compareScreen').find('iframe[name=theoutput1]').height();
		});
		$('#configbt2').click(function(){
			var width=$('#compareScreen').find('iframe[name=theoutput2]').width();
			var height=$('#compareScreen').find('iframe[name=theoutput2]').height();
		});
		chartSingleModeBT.hide();
		chartCompareModeBT.click(function(){
			//hiden main frame
			$('#mainFrame').hide();
			controlBT.hide();
			columnChartBT.hide();
			barChartBT.hide();
			lineChartBT.hide();
			areaChartBT.hide();
			$(this).hide();
			//set display
			//$('#compareScreen').css('display','');
			$('#compareScreen').fadeIn('slow', function(){});
			chartSingleModeBT.show();
		});
		chartSingleModeBT.click(function(){
			//set hidden compare mode
			$(this).hide();
			$('#compareScreen').hide();
			//set display main frame
			$('#mainFrame').fadeIn('slow', function(){});
			controlBT.show();
			chartCompareModeBT.show();
			columnChartBT.show();
			barChartBT.show();
			lineChartBT.show();
			areaChartBT.show();
		});
	}
	//chart type select
	var changeChartType=function(chartType){		
		var mainDomCotentForm=$('div[name=dialog-form]');
		var form=mainDomCotentForm.children('form');
		form.find('select[name=chart_type]').val(chartType);		
		var option=mainDomCotentForm.dialog( "option","buttons" );
		option.Submit();
	}
	columnChartBT.click(function(){
		changeChartType('column');
	});
	barChartBT.click(function(){
		changeChartType('bar');
	});
	lineChartBT.click(function(){
		changeChartType('spline');
	});
	areaChartBT.click(function(){
		changeChartType('area');
	});	
	//generate the control pannel
	var generateControlPanles=function(){
		var mainDomCotentForm=$('div[name=dialog-form]');
		mainDomCotentForm.width(controlPanle_width);
		mainDomCotentForm.height(controlPanle_height);
		
		//config left chart 
		var controlBT1=$('#configbt1');
		var domContentForm1=$(mainDomCotentForm.clone());
		domContentForm1.width(controlPanle_width);
		domContentForm1.height(controlPanle_height);
		domContentForm1.attr('name','dialog-form1');
		domContentForm1.hide();
		$('body').append(domContentForm1);
		domContentForm1=$('div[name=dialog-form1]');
		var divResult1=$('div[name=theoutput1]');
	
		//config right chart
		var controlBT2=$('#configbt2');
		var domContentForm2=$(mainDomCotentForm.clone());
		domContentForm2.width(controlPanle_width);
		domContentForm2.height(controlPanle_height);
		domContentForm2.attr('name','dialog-form2');
		domContentForm2.hide();
		$('body').append(domContentForm2);
		domContentForm2=$('div[name=dialog-form2]');
		var divResult2=$('div[name=theoutput2]');
	
		//config main chart
		var domContentForm0=mainDomCotentForm;
		var divResult=$('div[name=theoutput]');
		
		//generate main chart
		var dataMainChart=function(){
			var result={
				chartSingleMode:'true',
				chartName: 'mainChart',
				p_chart_polar: polarCheckox.find('input:checked').attr('value')
			};
			return result;
		}
		initControlPanel({
			validationFn: function(){return settings.formValidation(domContentForm0)},
			generateContentFn: function(){settings.generateFormContent(domContentForm0,divResult)},
			domResult: divResult,
			params: dataMainChart,
			//height: controlPanle_height,
			timeout: settings.timeout,
			timeoutMessage: settings.timeoutMessage,
			domContentForm: domContentForm0,
			textAlert: 'Generate chart...',
			controlBT: controlBT,
			//buttons: exportButtons,
			autoOpen: true,
			open: function(){settings.doWhenOpenControlPanel(domContentForm0)},
			//position:[15,33],
			draggable: true,
			success: function(){
				
			}
		});	
		//generate left chart
		var dataLeftChart=function(){
			var result={
				chartSingleMode:'false',
				chartName: 'leftChart',
				chartHeight: 350,
				p_chart_polar: polarCheckox.find('input:checked').attr('value')
			};
			return result;
		}
		initControlPanel({
			validationFn: function(){return settings.formValidation(domContentForm1)},
			generateContentFn: settings.generateFormContent(domContentForm1,divResult1),
			domResult: divResult1,
			params: dataLeftChart,
			//height: controlPanle_height,
			timeout: settings.timeout,
			timeoutMessage: settings.timeoutMessage,
			domContentForm: domContentForm1,
			textAlert: 'Generate left chart...',
			controlBT: controlBT1,
			//buttons: exportButtons,
			autoOpen: false,
			open: function(){settings.doWhenOpenControlPanel(domContentForm1)},
			//position:[15,33],
			draggable: true,
			success: function(){
			
			}
		});
		//generate right chart
		var dataRightChart=function(){
			var result={
				chartSingleMode:'false',
				chartName: 'rightChart',
				chartHeight: 350,
				p_chart_polar: polarCheckox.find('input:checked').attr('value')
			};
			return result;
		}
		initControlPanel({
			validationFn: function(){return settings.formValidation(domContentForm2)},
			generateContentFn: settings.generateFormContent(domContentForm2,divResult2),
			domResult: divResult2,
			params: dataRightChart,
			//height: controlPanle_height,
			timeout: settings.timeout,
			timeoutMessage: settings.timeoutMessage,
			domContentForm: domContentForm2,
			textAlert: 'Generate right chart...',
			controlBT: controlBT2,
			//buttons: exportButtons,
			autoOpen: false,
			open: function(){settings.doWhenOpenControlPanel(domContentForm2)},
			//position:[15,33],
			draggable: true,
			success: function(){
				
			}
		});	
	}
	//event when window resized
	var windowResize=function(){
		var mainWidth=$(window).width()-50; 
		var mainHeight=$(window).height()-65; 
		$('#chartWidthValue').attr('value',mainWidth-20);
		//$('#chartHeightValue').attr('value',mainHeight-9);
		
		$('#mainFrame').css({
				width: mainWidth,
				'min-height': mainHeight
		});
		$('#compareScreen').css({
				width: mainWidth,
				'min-height': mainHeight
		});
		
		$('#toolbar').css({
			width: $(window).width()-10,
			left: 5
		});
		delay_timeout(1000,function(){
			

		});
	}
	//window resize
	windowResize();
	$(window).resize(function(){
		windowResize();
	});
	
	initToolBar();
	generateControlPanles();
}
