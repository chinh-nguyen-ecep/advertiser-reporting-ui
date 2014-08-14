/**
 * 
 */
var dmaArray=["662|Abilene-Sweetwater TX","525|Albany GA","532|Albany-Schenectady-Troy NY","790|Albuquerque-Santa Fe NM","644|Alexandria LA","583|Alpena MI","634|Amarillo TX","743|Anchorage AK","524|Atlanta GA","520|Augusta GA","635|Austin TX","800|Bakersfield CA","512|Baltimore MD","537|Bangor ME","716|Baton Rouge LA","692|Beaumont-Port Arthur TX","821|Bend OR","756|Billings MT","746|Biloxi-Gulfport MS","502|Binghamton NY","630|Birmingham AL","559|Bluefield-Beckley-Oak Hill","757|Boise ID","506|Boston MA-Manchester NH","736|Bowling Green KY","514|Buffalo NY","523|Burlington VT-Plattsburgh ","754|Butte-Bozeman MT","767|Casper-Riverton WY","637|Cedar Rapids-Waterloo-Iowa","648|Champaign & Springfield-De","519|Charleston SC","564|Charleston-Huntington WV","517|Charlotte NC","584|Charlottesville VA","575|Chattanooga TN","759|Cheyenne WY-Scottsbluff NE","602|Chicago IL","868|Chico-Redding CA","515|Cincinnati OH","598|Clarksburg-Weston WV","510|Cleveland-Akron (Canton) O","752|Colorado Springs-Pueblo CO","546|Columbia SC","604|Columbia-Jefferson City MO","522|Columbus GA","535|Columbus OH","673|Columbus-Tupelo-West Point","600|Corpus Christi TX","623|Dallas-Ft. Worth TX","682|Davenport IA-Rock Island-M","542|Dayton OH","751|Denver CO","679|Des Moines-Ames IA","505|Detroit MI","606|Dothan AL","676|Duluth MN-Superior WI","765|El Paso TX","565|Elmira NY","516|Erie PA","801|Eugene OR","802|Eureka CA","649|Evansville IN","745|Fairbanks AK","724|Fargo-Valley City ND","513|Flint-Saginaw-Bay City MI","570|Florence-Myrtle Beach SC","866|Fresno-Visalia CA","571|Ft. Myers-Naples FL","670|Ft. Smith-Fayetteville-Spr","509|Ft. Wayne IN","592|Gainesville FL","798|Glendive MT","773|Grand Junction-Montrose CO","563|Grand Rapids-Kalamazoo-Bat","755|Great Falls MT","658|Green Bay-Appleton WI","518|Greensboro-High Point-Wins","545|Greenville-New Bern-Washin","567|Greenville-Spartanburg SC-","647|Greenwood-Greenville MS","636|Harlingen-Weslaco-Brownsvi","566|Harrisburg-Lancaster-Leban","569|Harrisonburg VA","533|Hartford & New Haven CT","710|Hattiesburg-Laurel MS","766|Helena MT","744|Honolulu HI","618|Houston TX","691|Huntsville-Decatur (Floren","758|Idaho Falls-Pocatello ID","527|Indianapolis IN","718|Jackson MS","639|Jackson TN","561|Jacksonville FL","574|Johnstown-Altoona PA","734|Jonesboro AR","603|Joplin MO-Pittsburg KS","747|Juneau AK","616|Kansas City MO","557|Knoxville TN","702|La Crosse-Eau Claire WI","582|Lafayette IN","642|Lafayette LA","643|Lake Charles LA","551|Lansing MI","749|Laredo TX","839|Las Vegas NV","541|Lexington KY","558|Lima OH","722|Lincoln & Hastings-Kearney","693|Little Rock-Pine Bluff AR","803|Los Angeles CA","529|Louisville KY","651|Lubbock TX","503|Macon GA","669|Madison WI","737|Mankato MN","553|Marquette MI","813|Medford-Klamath Falls OR","640|Memphis TN","711|Meridian MS","528|Miami-Ft. Lauderdale FL","617|Milwaukee WI","613|Minneapolis-St. Paul MN","687|Minot-Bismarck-Dickinson(W","762|Missoula MT","686|Mobile AL-Pensacola (Ft. W","628|Monroe LA-El Dorado AR","828|Monterey-Salinas CA","698|Montgomery (Selma) AL","659|Nashville TN","622|New Orleans LA","501|New York NY","544|Norfolk-Portsmouth-Newport","740|North Platte NE","633|Odessa-Midland TX","650|Oklahoma City OK","652|Omaha NE","534|Orlando-Daytona Beach-Melb","631|Ottumwa IA-Kirksville MO","632|Paducah KY-Cape Girardeau ","804|Palm Springs CA","656|Panama City FL","597|Parkersburg WV","675|Peoria-Bloomington IL","504|Philadelphia PA","753|Phoenix AZ","508|Pittsburgh PA","820|Portland OR","500|Portland-Auburn ME","552|Presque Isle ME","521|Providence RI-New Bedford ","717|Quincy IL-Hannibal MO-Keok","560|Raleigh-Durham (Fayettevil","764|Rapid City SD","811|Reno NV","556|Richmond-Petersburg VA","573|Roanoke-Lynchburg VA","611|Rochester MN-Mason City IA","538|Rochester NY","610|Rockford IL","862|Sacramento-Stockton-Modest","576|Salisbury MD","770|Salt Lake City UT","661|San Angelo TX","641|San Antonio TX","825|San Diego CA","807|San Francisco-Oakland-San ","855|Santa Barbara-Santa Maria-","507|Savannah GA","819|Seattle-Tacoma WA","657|Sherman TX-Ada OK","612|Shreveport LA","624|Sioux City IA","725|Sioux Falls(Mitchell) SD","588|South Bend-Elkhart IN","881|Spokane WA","619|Springfield MO","543|Springfield-Holyoke MA","638|St. Joseph MO","609|St. Louis MO","555|Syracuse NY","530|Tallahassee FL-Thomasville","539|Tampa-St. Petersburg (Sara","581|Terre Haute IN","547|Toledo OH","605|Topeka KS","540|Traverse City-Cadillac MI","531|Tri-Cities TN-VA","789|Tucson (Sierra Vista) AZ","671|Tulsa OK","760|Twin Falls ID","709|Tyler-Longview(Lufkin & Na","526|Utica NY","626|Victoria TX","625|Waco-Temple-Bryan TX","511|Washington DC (Hagerstown ","549|Watertown NY","705|Wausau-Rhinelander WI","548|West Palm Beach-Ft. Pierce","554|Wheeling WV-Steubenville O","627|Wichita Falls TX & Lawton ","678|Wichita-Hutchinson KS","577|Wilkes Barre-Scranton PA","550|Wilmington NC","810|Yakima-Pasco-Richland-Kenn","536|Youngstown OH","771|Yuma AZ-El Centro CA","596|Zanesville OH"];
var categories_dma_selected=["662|Abilene-Sweetwater TX","525|Albany GA","532|Albany-Schenectady-Troy NY","790|Albuquerque-Santa Fe NM","644|Alexandria LA"];// distance category of chart
var categories_dma_selected_temp=[];// use when dma filter

//------------------------------ DMA Filter Dialog ----------------------------------
//Install DmaFilter Dialog
	var dmaFilterDialog=new contentDialog();
	//install dma list
	var dmaDialogContent=$('<div class="selectItemCss"><div class="title">DMA</div><div class="title" style="padding-left: 15px;">Selected DMA</div><div class="items"></div><div class="selected"></div></div>');
	function itemsDmaShow(){
		dmaDialogContent.find('.items').first().empty();
		$.each(dmaArray, function(index,item){
			var id=item.split("|")[0];
			var name=item.split("|")[1];
			var fistChart=name.substring(0,1);
			var lastChart=name.substring(1);
			var div=$('<button style="margin: 2px;text-transform: lowercase;width: 200px;text-align: left;" type="button" class="btn btn-default btn-xs"><span class="glyphicon glyphicon-plus"></span> <span style="font-size: 12pt;font-weight:bold;text-transform: uppercase;">'+fistChart+'</span>'+lastChart+'</button>');
			div.click(function(){
				categories_dma_selected_temp.push(item);
				$(this).remove();
				selectedDmaShow();
			});
			if(categories_dma_selected_temp.indexOf(item)<0){
				dmaDialogContent.find('.items').first().append(div);
			}			
		});	
		selectedDmaShow();
	}
	//function draw selected dma
	function selectedDmaShow(){
		dmaDialogContent.find('.selected').first().empty();
		$.each(categories_dma_selected_temp,function(index,item){
			var id=item.split("|")[0];
			var name=item.split("|")[1];
			var fistChart=name.substring(0,1);
			var lastChart=name.substring(1);
			var btn=$('<button style="margin: 2px;text-transform: lowercase;text-align: left;width: 200px;" type="button" class="btn btn-default btn-xs"> <span class="glyphicon glyphicon-remove"></span> <span style="font-size: 12pt;font-weight:bold;text-transform: uppercase;">'+fistChart+'</span>'+lastChart+'</button>');
			dmaDialogContent.find('.selected').first().append(btn);
			btn.click(function(){
				categories_dma_selected_temp.splice(categories_dma_selected_temp.indexOf(item),1);
				selectedDmaShow();
				itemsDmaShow();
			});
		});
	}
	
	dmaFilterDialog.setTitle("DMA Filter");
	dmaFilterDialog.setWidth(540);
	dmaFilterDialog.addDom(dmaDialogContent);
	//Clean list event
	dmaFilterDialog.addButton({
		name: 'Clear All',
		btnClass: 'btn-info',
		action: function(){
			categories_dma_selected_temp=[];
			itemsDmaShow();
			selectedDmaShow();
		}
	});
	//Apply new dma list event
	dmaFilterDialog.addButton({
		name: 'Apply',
		btnClass: 'btn-primary',
		action: function(){
			if(categories_dma_selected_temp.length==0){
				alert("Please select Dma!");
				return;
			}else{
				//copy categories dma from temp to selected
				categories_dma_selected=new Array();
				$.each(categories_dma_selected_temp, function(index,item){
					categories_dma_selected.push(item);
				});
			}
			
			dmaFilterDialog.hide();
			loadChartByDma();
		}
	});
	
	//Open dialog button
	$("#dmaFilterBtn").click(function(){
		dmaFilterDialog.open();	
		//copy categories dma to temp
		categories_dma_selected_temp=[];
		$.each(categories_dma_selected, function(index,item){
			categories_dma_selected_temp.push(item);
		});
		itemsDmaShow();
		selectedDmaShow();
	});
	//------------------------------ DMA Filter Dialog End----------------------------------
	
function loadChartByDma(){
	myDateRangeInput.disable();
	series_clicks=[];
	series_impressions=[];
	series_cta=[];
	var dateRange_value='where[date.between]='+urlMaster.getParam('where[date.between]');
	var measureValue=$("#e2").val();
	var url=apiRootUrl+'/AdvertiserByDma?select=date|dma|dma_name&limit=2000&'+dateRange_value+"&by=impressions|clicks|cta_anys";
	//add dma filter
	var dmaIdsQuery='&where[dma.in]=';
	p_dma_ids=[];
	$.each(categories_dma_selected, function(index,item){
		var id=item.split("|")[0];
		//push ids to array use when give param for jasper
		p_dma_ids.push(id);
		if(index>0){
			dmaIdsQuery+=",";
		}
		dmaIdsQuery+=id;
	});
	url+=dmaIdsQuery;
	
	//Send request to got data
	if(myAjaxStore.isLoading(url)){
		console.log('Your request is loading...');
		console.log('Callback after '+loadingCallback+'s...');
		delayTimeout(loadingCallback,function(){
			loadChartByDma();
		});
		return;
	}
	if(chart !=null){
		chart.showLoading();
	}

	var ajaxData=myAjaxStore.get(url);
	if(ajaxData==null){
		myAjaxStore.registe(url);
		$.ajax({
			dataType: "json",
			url: url,
			timeout: ajaxRequestTimeout,
			xhrFields: {
				      withCredentials: true
	   		},
			success: function(json){
				  myAjaxStore.add(url,json);
				  loadChartByDma();
			},
			error: function(xhr,status,error){
				myAjaxStore.remove(url);
				console.log('Request url error: '+url);
				console.log('Status:  '+status);
				console.log('Error:  '+error);
				console.log('Reload chart!');
				if(error=='timeout'){
					loadChartByDma();
				}else{
					delayTimeout(2000,function(){
						location.reload(false);
					});
				}
			},
			complete: function(){
				
			}
			});			
	}else{
		processData(ajaxData);
		if(ajaxData.data.length==0){
			var mydialog=new contentDialog();
			mydialog.setTitle("Daily Advertiser Message!");
			mydialog.setContent("Your data from "+selectStartDate.format('yyyy-mm-dd')+" to "+selectEndDate.format('yyyy-mm-dd')+" is not available.");
			mydialog.open();
		}
	}
	function processData(json){
		title="Advertiser Clicks By Date Dma";
	  	subtitle="From "+selectStartDate.format("yyyy-mm-dd")+" to "+selectEndDate.format("yyyy-mm-dd");
	  	var responseStatus=json.responseStatus;
	  	var page=json.page;
	  	if(responseStatus=='OK' && page==1){
	  		data=json.data;
	  		var name='';
	  		//this loop add date to series

	  		
	  		for(var i=0;i<data.length;i++){				  			
	  			var row=data[i];
	  			var newName=row[0];
	  			if(newName!=name){
	  				//console.log("Add serie: "+newName);
//			  		var initDataArray=[categories_distance.length];
//			  		var initDataArray2=[categories_distance.length];
//			  		var initDataArray3=[categories_distance.length];
//			  		for(var i=0; i<categories_distance.length;i++){
//			  			initDataArray[i]=0;
//			  			initDataArray2[i]=0;
//			  			initDataArray3[i]=0;
//			  		}
	  				var row={name: newName,data:[]};
	  				var row2={name: newName,data:[]};
	  				var row3={name: newName,data:[]};
	  				series_clicks.push(row);
	  				series_impressions.push(row2);
	  				series_cta.push(row3);
	  				name=newName;
	  			}

	  		}
	  		//end loop add date to series
	  		console.log(categories_dma_selected);
	  		//begin add value
	  		for(var i=0;i<data.length;i++){
	  			var row=data[i];
	  			var newName=row[0];
	  			var dma=row[1]+'|'+row[2];
	  			var value=row[4];
	  			var value_imp=row[3];
	  			var value_cta=row[5];
	  			
	  			var index=categories_dma_selected.indexOf(dma);
	  			console.log("Add Value: "+newName+" ckl "+value+" im "+value_imp+" cta "+value_cta+ " index "+index +" dma "+dma);
	  			for(var j=0;j<series_clicks.length;j++){
		  			var item=series_clicks[j];	
		  			if(item.name==newName && index>=0){	
		  				console.log("Date "+newName+" "+j+" Add value "+ value+" At "+index);
		  				series_clicks[j].data[index]=parseFloat(value);
		  				series_impressions[j].data[index]=parseFloat(value_imp);
		  				series_cta[j].data[index]=parseFloat(value_cta);
		  			}
		  		}
	  		}
	  		//end add values
	  		
		  	//generate table data
		  	table_data=json.data;
		  	//end generate table data
		  	
		  	//generate table
		  	myTable=new drawTableFromArray({
		  		table_id: 'daily-advertiser-dataTable',
		  		table_colums: ['Date','Dma id','Dma name','Impressions','Clicks','Cta anys'],
		  		columns_format:['','','','number','number','number'],
		  		table_data: table_data,
		  		page_items: 25,
		  		paging: true,
		  		sort_by: 'Date',
		  		sortable: false,
		  		onClickRow: function(row){
		  			//alert(row[0]);
		  		}
		  	});
		  	
	  		
	  	}else{
	  		return;
	  	}
	  	// draw chart
	  	if(chart){
	  		chart.hideLoading();
	  	}
	  	categories_dma=[];
	  	$.each(categories_dma_selected,function(index,item){
	  		var name=item.split('|')[1];
	  		categories_dma.push(name);
	  	});
	  	drawChart(categories_dma,series_clicks,title,subtitle);
	  	  	
	  	//unable date range input
	  	myDateRangeInput.unable();		
	}
	
}