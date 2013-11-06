function initJasperPageTemplate(settings){
	settings=$.extend({},{
						controlPanle_width: 300,
						controlPanle_height: 'auto',
						mainDomCotentForm: $('div[name=dialog-form]'),						
						generateFormContent: function(){},
						formValidation: function(){return true},
						reportName:'Report name',
						miniMode:false,
						timeout: 120000,
						timeoutMessage: 'The report can be large. Please export to pdf or excel and view it on your computer!',
						iframeMode: true
						},
						settings);
	var controlPanle_width=settings.controlPanle_width;
	var controlPanle_height=settings.controlPanle_height;
	var generateFormContent=settings.generateFormContent;
	var formValidation=settings.formValidation;
	//Set title
	$('head title').html(settings.reportName);
	//Get content html from template
	var initContentHTMLCode=function(){
		$.ajax({
		  url: root_folder+'/html_template/jasperReportCommonScript.html',
		  dataType: 'html',
		  success: function(data){
			$('body').append(data);
		  },
		  async: false
		});	
	}
	initContentHTMLCode();
	//end
	
	var mainDomCotentForm=settings.mainDomCotentForm;
	var controlBT1=$('<img id="open_control" title="Open control panel" src="'+root_folder+'/images/control_panel 16x16.png"/>');
	var divResult=$('div[name=theoutput]');	
	
	//iframe mode == true
	if(settings.iframeMode==true){
		var iframeResult=$('<iframe name="theoutput" width="100%" height="100%" scrolling="yes" class="ui-corner-all jasper-content" style=""></iframe>');
		$('body').append(iframeResult);
		divResult.remove();
		divResult=iframeResult;
	}
	
	//Create toolbar function
	var initToolBar=function(){
		var pdfDom=$('<img src="'+root_folder+'/images/1352099310_pdf.png" title="Export Pdf file"/>');
		var xlsDom=$('<img src="'+root_folder+'/images/1352093588_table-excel.png" title="Export Xls file"/>');
		var csvDom=$('<img src="'+root_folder+'/images/1352093806_document-excel-csv.png" title="Export Csv file"/>');
		var xmlDom=$('<img src="'+root_folder+'/images/1352093785_file-xml.png" title="Export Xml file"/>');
		$('div#toolbar div.leftGroup').append(controlBT1);
		$('div#toolbar div.leftGroup').append('<span class="slip"/>');
		$('div#toolbar div.leftGroup').append(xlsDom);
		$('div#toolbar div.leftGroup').append(pdfDom);
		$('div#toolbar div.leftGroup').append('<span class="reportName">'+settings.reportName+'</span>');
		var form=mainDomCotentForm.children('form');
		pdfDom.click(function(){
			exportFile(form,'pdf');
		});
		xlsDom.click(function(){
			exportFile(form,'xls');
		});
		
		//right
		var jaspertDom=$('<span style="font-size: 8pt;font-weight: normal;">We are updating new script - If report don\'t work,Please clear your Browser\'s cache and try again</span>');
		var logoDom=$('<img title="vervemobile.com" src="'+root_folder+'/images/vervelogo.png" height="16"/>');
		//$('div#toolbar div.rightGroup').append(jaspertDom);
		$('div#toolbar div.rightGroup').append(logoDom);
		logoDom.click(function(){
			window.open('http://vervemobile.com','_blank','');
		});
	}
	//end
	
	//Create control pannel function
	var generateControlPanles=function(){	
		mainDomCotentForm.width(controlPanle_width);				
		//generate main chart		
		var domContentForm0=mainDomCotentForm;		
		var generateContent=function(){
			generateFormContent(domContentForm0,function(){
				//do some thing when generateFormContent completed
			});
		};
		var validation=function(){
			return formValidation(domContentForm0,divResult);
		};
		
		//export button in control pannel
		var exportButtons={
			'CSV':function(){
				var form=mainDomCotentForm.children('form');
				var result=exportFile(form,'csv');
				if(result){
					mainDomCotentForm.dialog( "close" );
				}
				
			},
			'PDF':function(){
				var form=mainDomCotentForm.children('form');
				var result=exportFile(form,'pdf');
				if(result){
					mainDomCotentForm.dialog( "close" );
				}
				
			},
			'XLS': function(){
				var form=mainDomCotentForm.children('form');
				var result=exportFile(form,'xls');
				if(result){
					mainDomCotentForm.dialog( "close" );
				}
			}
		}
		
		if(settings.miniMode==true){
			initControlPanel({
					validationFn: validation,
					generateContentFn: generateContent,
					domResult: divResult,
					height: controlPanle_height,
					timeout: settings.timeout,
					timeoutMessage: settings.timeoutMessage,
					domContentForm: domContentForm0,
					textAlert: 'Generate report...',
					controlBT: controlBT1,
					buttons: exportButtons,
					autoOpen: true,
					position:[15,33],
					draggable: false,
					success: function(){
						windowResize();
					}
				});					
		}else{
			initControlPanel({
					validationFn: validation,
					generateContentFn: generateContent,
					height: controlPanle_height,
					timeout: settings.timeout,
					timeoutMessage: settings.timeoutMessage,
					domResult: divResult,
					domContentForm: domContentForm0,
					textAlert: 'Generate report...',
					controlBT: controlBT1,
					buttons: exportButtons,
					autoOpen: true,
					success: function(){
						windowResize();
					}
				});			
		}

	}
	//end
	
	// export file function
	function exportFile(form,fileType){
		fileType=fileType.toLowerCase();
		var myForm=form;
		//myForm.find('select[name=p_output]').val(fileType);
		var params=myForm.serialize();
		//myForm.remove();
		var submitUrl='ViewAction?wrapper=false&'+params+'&p_output='+fileType;
		if(formValidation(mainDomCotentForm,divResult)){
				if(settings.iframeMode==true && fileType=='pdf'){
							divResult.html("Report is loading...");
							window.open(submitUrl,divResult.attr('name'));
				}else{
					$.fileDownload(submitUrl,{   successCallback: function (url) {				 
							alert('You just got a file download dialog or ribbon for this URL :' + url);
						},
						failCallback: function (html, url) {				 
							//alert('Your file download just failed for this URL:' + url + '\r\n' +
							//		'Here was the resulting error HTML: \r\n' + html
							//		);
							var url=submitUrl;
							window.open(url,'mywindow','');
							
					}});				
				}

			return true;
		}else{
			return false;
		}
		
	}
	//end
	
	//Action when window resize
	var windowResize=function(){
		var mainWidth=$(window).width()-200; 
		var mainHeight=$(window).height()-55; 
		if(settings.iframeMode==false){
			if(divResult.html()==''){
				divResult.css({
						width: mainWidth,
						'min-height': mainHeight,
						'margin-left': 'auto',
						'margin-right': 'auto'
				});
				
				$('#toolbar').css({
					width: $(window).width()-10,
					left: 5
				});		
			}else{
				var inner_width=divResult.children('table').width();
				inner_width=inner_width+10;
				if(inner_width>=$(window).width()){
					divResult.css({
							width: inner_width,
							'margin-left': 10,
							'margin-right': 10,
							float: 'left'
					});
					$('body.pentaho').width(inner_width+25);
					var toolbar_width=inner_width+2;
					$('#toolbar').css({
						width: toolbar_width,
						left: 4
					});				
				}else{
					$('body.pentaho').width($(window).width());
					$('#toolbar').css({
						width: $(window).width()-10,
						left: 5
					});	
				}

			}
		}else{
		//Iframe mode == true
			var if_width=$(window).width()-50; 
			var if_height=$(window).height()-45; 
				divResult.css({
						width: if_width,
						height: if_height,
						float: 'left',
						'margin-left': $(window).width()/2-if_width/2
				});
				
				$('#toolbar').css({
					width: $(window).width()-10,
					left: 5
				});	
		}
		
		delay_timeout(1000,function(){			

		});
	}
	//end
	

	windowResize();
	$(window).resize(function(){
		windowResize();
	});
	initToolBar();
	generateControlPanles();
}


