setTabActive("Running Revenue");

var runningRevenueApiUrl=apiRootUrl+'/runningRevenueOverview';
var runningRevenueAgencyApiUrl=apiRootUrl+'/agenciesRunningRevenue';
var runningTierRateApiUrl=apiLookupRootUrl+'/AgencyTierRate';
var runningDate;


$(document).ready(function(){ 
	urlMaster.replaceParam('page', 1);
	loadRunningDate();
	// change network event 
	$('#selectbox_agency').change(function(){
		if($('#selectbox_agency').val()!=0){
			urlMaster.replaceParam('page', 1);
			urlMaster.replaceParam('network_id', $('#selectbox_agency').val());
			loadRunningDetail();
		}	
	});
	
	//
	$('#search_input').keyup(function(){
		delayTimeout(2000, function(){
			urlMaster.replaceParam('page', 1);
			loadRunningDetail();
		});
	});
});

//////////////////////////
// load running date
///////////////////////////

function loadRunningDate(){
	$.ajax({
		url : runningRevenueApiUrl,
		dataType : 'json',
		cache: false,
		data : {
			select: 'full_date',
			order: 'full_date.desc'
		},
		success : function(json) {
			runningDate=json.data[0][0];
			loadRunningSummary();
		}
	});	
}

////////////////////////////
// loadSummaryTable
///////////////////////////

function loadRunningSummary(){
	$.ajax({
		url : runningRevenueAgencyApiUrl,
		dataType : 'json',
		cache: false,
		data : {
			select: 'full_date|network_id|network_title|publisher_id|billable_rate',
			by: 'delivered_imps|pub_net_revenue|profit_margin',
			'where[full_date]': runningDate,
			order: 'publisher_id'
		},
		success : function(json) {
			processData(json.data);
			loadRunningDetail();
		}
	});
	function processData(data){
		var rowsOption=[];
			rowsOption.push('<option value="0">-----</option>');
		var rows=[];
		for(var i=0;i<data.length;i++){
			var full_date=data[i][0];
			var network_id=data[i][1];
			var network_title=data[i][2];
			var account_id=data[i][3];
			var billable_rate=data[i][4];
			var delivered_imps=data[i][5];
			var gross_revenue=(parseFloat(delivered_imps)/1000)*parseFloat(billable_rate);
			var pub_net_revenue=data[i][6];
			var profit_margin=data[i][7];
			var row='<tr>'
					+	'<td><a href="#" onclick="urlMaster.replaceParam(\'rate\','+billable_rate+');urlMaster.replaceParam(\'network_id\','+network_id+');urlMaster.replaceParam(\'account_id\','+account_id+');urlMaster.replaceParam(\'page\','+1+');loadRunningDetail()"><b>'+network_title+'</b></a></td>'
					+	'<td>'+account_id+'</td>'
					+	'<td align="right">'+accounting.formatNumber(delivered_imps)+'</td>'
					+	'<td align="right">'+accounting.formatMoney(billable_rate)+'</td>'
					+	'<td align="right">'+accounting.formatMoney(gross_revenue)+'</td>'
					+	'<td align="right">'+accounting.formatMoney(pub_net_revenue)+'</td>'
					+	'<td align="right">'+accounting.formatMoney(profit_margin)+'</td>'
					+	'</tr>';
			rows.push(row);
			rowsOption.push('<option value="'+network_id+'">'+network_title+'</option>');
		}
		$('#summaryTable tbody').html(rows.join(""));
		$('#selectbox_agency').html(rowsOption.join(""));
		$('#dataDate').html(' month to date '+full_date);
	}
}
///////////////////////////////////
// running detail
///////////////////////////////////


/////////////////////////////
//
////////////////////////////
var totalPageDetail=1;
function loadRunningDetail(){
	$('#detailDiv').show();
	$('#tiers_and_rate').hide();
	var network_id=urlMaster.getParam("network_id");
	var detailBy=urlMaster.getParam("detail");
	var page=urlMaster.getParam("page");
	var search=$('#search_input').val();
	var is_campaign;
	var is_subscription;
	var selectStament='merchant_id|merchant_name|publisher_id|campaign_id|campaign_title|billable_rate';
	
	//check network id
	if(network_id==''){
		return;
	}
	
	//set default page = 1
	if(page==''){
		page=1;
		urlMaster.replaceParam("page",page);
	}
	//set default detail = campaign
	if(detailBy==''){
		detailBy='campaign';
		urlMaster.replaceParam("detail",'campaign');
	}
	
	// remove all active in sub tab
	$('#subTab li').removeClass('active');
	
	//Active tab
	if(detailBy=='campaign'){
		is_campaign='true';
		is_subscription='false';
		//active tab campaign
		$('#subTab li[title="Campaign"]').addClass('active');
		$('#detailTable th[name=detailType]').html('Campaign');
	}else if(detailBy=='offer'){
		is_campaign='false';
		is_subscription='false';
		selectStament='merchant_id|merchant_name|publisher_id|offer_id|offer_title|billable_rate';
		//active tab offer
		$('#subTab li[title="Offer"]').addClass('active');
		$('#detailTable th[name=detailType]').html('Offer');
	}else if(detailBy=='subscription'){
		is_campaign='false';
		is_subscription='true';
		selectStament='merchant_id|merchant_name|publisher_id|subscription_id|subscription_title|billable_rate';
		//active tab offer
		$('#subTab li[title="Subscription"]').addClass('active');
		$('#detailTable th[name=detailType]').html('Subscription');
	}else if(detailBy=='tierRate'){
		loadAgencyTierRate();
		return;
	}
	
	
	// set titlte for detail table
	$('span.detailTitlte').html($('#selectbox_agency option[value='+network_id+']').text());
	
	// select network list set value to current network
	$('#selectbox_agency').val(network_id);
	
	// process search keyword
	search=$.trim(search.toLowerCase());
	
	
	$.ajax({
		url : runningRevenueApiUrl,
		dataType : 'json',
		cache: false,
		data : {
			select: selectStament,
			by: 'booked_imps|imps|clicks|billable_imps',
			'where[full_date]': runningDate,
			'where[network_id]': network_id,
			'where[is_campaign]': is_campaign,
			'where[is_subscription]': is_subscription,
			'where[merchant_name.like]':search,
			order: 'publisher_id',
			limit: 10,
			page: page
		},
		success : function(json) {
			processData(json.data);
			if(json.page==1){
				totalPageDetail=json.totalPage;
			}
			processPaging(totalPageDetail,json.page);
		}
	});
	function processData(data){
		var rows=[];
		for(var i=0;i<data.length;i++){
			var merchant_id=data[i][0];
			var merchant_name=data[i][1];
			var account_id=data[i][2];
			var campaign_id=data[i][3];
			var campaign_title=data[i][4];
			var billable_rate=data[i][5];
			var booked_imps=data[i][6];
			var delivered_imps=data[i][7];
			var clicks=data[i][8];
			var billable_imps=data[i][9];
			var gross_revenue=(parseFloat(delivered_imps)/1000)*parseFloat(billable_rate);
			
			var row='<tr>'
				+	'<td>'+merchant_name+'<br/><i style="color: gray;">#'+merchant_id+'</i></td>'
				+	'<td>'+campaign_title+'<br><i style="color: gray;">#'+campaign_id+'</i></td>'
				+	'<td align="right">'+accounting.formatNumber(booked_imps)+'</td>'
				+	'<td align="right">'+accounting.formatNumber(delivered_imps)+'</td>'
				+	'<td align="right">'+accounting.formatNumber(billable_imps)+'</td>'
				+	'<td align="right">'+accounting.formatNumber(clicks)+'</td>'
				+	'<td align="right">'+accounting.formatMoney(billable_rate)+'</td>'
				+	'<td align="right">'+accounting.formatMoney(gross_revenue)+'</td>'
				+	'</tr>';
		rows.push(row);
		}
		$('#detailTable tbody').html(rows.join(""));
	}
	function processPaging(totalPage,currentPage){
		if(currentPage==null){
			currentPage=1;
		}
		var start=currentPage-4;
		var end=currentPage+4;
		
		while(start<=0){
			start++;
		}
		while(end>totalPage){
			end--;
		}
		
		$('#detailPaging').empty();
		
		if(start>3){
			var row='<li><a href="#" onclick="urlMaster.replaceParam(\'page\', '+1+');loadRunningDetail();">'+1+'</a></li>';
			row+='<li><a href="#">...</a></li>';
			$('#detailPaging').html(row);
		}
		
		for(var i=start;i<=end;i++){
			var row='<li><a href="#" onclick="urlMaster.replaceParam(\'page\', '+i+');loadRunningDetail();">'+i+'</a></li>';
			if(i==currentPage){
				row='<li class="active"><a href="#" onclick="urlMaster.replaceParam(\'page\', '+i+');loadRunningDetail();">'+i+'</a></li>';
			}
			
			$('#detailPaging').append($(row));
		}
		
		if(end<totalPage-1){
			var row='<li><a href="#">...</a></li>';
			$('#detailPaging').append($(row));
		}
		
		//add lastpage
		if(end<totalPage){
			var row='<li><a href="#" onclick="urlMaster.replaceParam(\'page\', '+totalPage+');loadRunningDetail();">'+totalPage+'</a></li>';
			$('#detailPaging').append($(row));
		}
		
		//
		$('a').click(function(event){
			console.log();
			if($(this).attr('href')=='#'){
				event.preventDefault();
			}
		});
		
	}

}

///////////////////////////////
// load agency tier rate
///////////////////////////////
function loadAgencyTierRate(){
	var page=urlMaster.getParam("page");
	var account_id=urlMaster.getParam("account_id");
	var network_id=urlMaster.getParam("network_id");
	var rate=urlMaster.getParam("rate");
	// set titlte for detail table
	$('span.detailTitlte').html($('#selectbox_agency option[value='+network_id+']').text());
	
	if(account_id==''){
		return;
	}else{
		//show agency tier rate detail
		$('#detailDiv').hide();
		$('#tiers_and_rate').show();
		//active tab
		$('#subTab li').removeClass('active');
		$('#subTab li[title="Tiers and rate"]').addClass('active');
	}
	
	if(page==''){
		page=1;
		urlMaster.replaceParam("page", page);
	}
	$.ajax({
		url : runningTierRateApiUrl,
		dataType : 'json',
		data : {
			select: 'account_id|account_name|imps_text|tier_rate',
			'where[account_id.in]': account_id,
			order: 'is_tier.desc|account_id|min_imps',
			limit: 100,
			page: page
		},
		success : function(json) {
			processData(json.data);
		}
	});	
	
	function processData(data){
		var rows=[];
		for(var i=0;i<data.length;i++){
			var account_id=data[i][0];
			var account_name=data[i][1];
			var imps_text=data[i][2];
			var tier_rate=data[i][3];
			
			var row='<tr>'
				+	'<td>'+account_name+'</td>'
				+	'<td align="right">'+imps_text+'</td>'
				+	'<td align="right">'+accounting.formatMoney(tier_rate)+'</td>'
				+	'</tr>';
			
			if(tier_rate==rate){
				row='<tr class="success">'
					+	'<td>'+account_name+'</td>'
					+	'<td align="right">'+imps_text+'</td>'
					+	'<td align="right">'+accounting.formatMoney(tier_rate)+'</td>'
					+	'</tr>';
			}
		rows.push(row);
		}
		$('#detailTableTierAndRate tbody').html(rows.join(""));		
	}
	
}

