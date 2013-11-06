//This function create a completed control panel
//  controlBT: the Dom object, you click on to open control panel
//  domContentForm: the div element content form html
//  divResult: the div element will be content the htlm result when you click Submit
//  generateContentFn: the function you use to generate content of form
//  validationFn: this function return false or true.
function initControlPanel(settings){
		settings=$.extend({},{
							validationFn:function(){},
							generateContentFn:function(){},
							params:function(){var arrayParams={}; return arrayParams;},// it is a function return params value
							height: 'auto',
							success: function(data){},
							timeout: 600000,
							timeoutMessage: 'Request timeout!',
							domResult:'',
							domContentForm: '',
							textAlert:'Loading...',
							controlBT: '',
							buttons:{},
							autoOpen: false,
							open: function(){},
							ajaxUrl:'',
							dataType: 'html',
							position:{
								my: 'center center',
								at: 'center center',
								collision: 'fit',
								of: window,
								using: function(pos) {					
									var topOffset = $(this).css(pos).offset().top;
									//alert(topOffset+'-'+pos.top+' window.pageXOffset:'+window.pageXOffset+" window.pageYOffset:"+window.pageYOffset+" window.innerWidth:"+window.innerWidth+" window.innerHeight:"+window.innerHeight);
									
									$(this).css({
										top: (window.innerHeight - $(this).height()) / 2+window.pageYOffset,
										left: (window.innerWidth - $(this).width()) / 2+window.pageXOffset
									});					
									
								}
							},
							draggable :true
							},
							settings);
							
		var controlBT=settings.controlBT;
		var domContentForm=settings.domContentForm;
		var divResult=settings.domResult;
		var generateContentFn=settings.generateContentFn;
		var validationFn=settings.validationFn;
		var autoOpen=settings.autoOpen;
		var completedFn=settings.success;
		var p_textAlert=settings.textAlert;
		var ajaxUrl=settings.ajaxUrl;
		
		var controlPanelWidth=domContentForm.width();
		var controlPanelHeight=domContentForm.height();
		var buttonArray=$.extend({},settings.buttons,{
                "Submit": function() {
					var validated=validationFn();
					var myForm=domContentForm.find('form');
					if(validated==true){
						if(ajaxUrl==''){
							var paramsObj=settings.params();
							doFormAjax({
								domResult:divResult,
								form: myForm,
								dataType: settings.dataType,
								params: paramsObj,
								success: completedFn,
								textAlert: p_textAlert,
								timeout: settings.timeout,
								timeoutMessage: settings.timeoutMessage
							});
						}else{
							//alert(ajaxUrl);
							pentahoActionAjax({
								dom: divResult,
								url: ajaxUrl,
								dataType: settings.dataType,
								params: myForm.serialize(),
								textAlert: p_textAlert,
								timeout: settings.timeout,
								timeoutMessage: settings.timeoutMessage
							});
						}
						domContentForm.dialog( "close" );
					}
                }                
            })
		domContentForm.dialog({            
			resizable: false,
			width:controlPanelWidth,
			autoOpen: autoOpen,
			open: settings.open,
            height:settings.height,
			position:settings.position,
			draggable: settings.draggable,
            modal: true,
            buttons: buttonArray
		});

		controlBT.click(function(){
			domContentForm.dialog("open");
		});
		generateContentFn();
}