var yesterday="2011-07-12";
var oneDayAgo="2011-07-11";
var sevenDayAgo="2011-07-05";
var thirtyDayAgo="2011-06-05";
var selectedMeasures="Revenue";
var selectedSite="All Order names";
var report_date='';

var MetaLayerCharts ={
	/*startDate: MetaLayer.getLastMonthDate(), // Default start date
	endDate: MetaLayer.getCurrentDate(), // Default end date
	startMonth: MetaLayer.getMonth(), // Default month date*/
};

MetaLayerCharts =  {
	siteSelecClicked1: function(value){
		selectedSite=value;	
		report_date=yesterday;
		Dashboards.fireChange("report_date",report_date);
		$('#comparebox').show();
	},
	siteSelecClicked2: function(value){
		selectedSite=value;	
		report_date=oneDayAgo;
		Dashboards.fireChange("report_date",report_date);
		$('#comparebox').show();
	},
	topSitesOfYesterdayChartDefinition:{
	    colHeaders: ["Order name","TDRank","YRank","BBudget","ABudget","Revenue","Impressions","Clicks","Pacing","MTDRevenue","RMBudget","NMBudget"],
	    colTypes: ['string','numeric','numeric','numeric','numeric','numeric','numeric','numeric','numeric','numeric','numeric','numeric'],
	    colFormats: [null,'%.0f','%.0f','%.0f','%.0f','%.0f','%.0f','%.0f','%.0f','%.0f','%.0f','%.0f'],
	    colWidths: ['300px','100px',null,null,null,null,null,null,null,null,null,null],
	    queryType: 'mdx',
	    displayLength: 20,
	    sort: true,
	    sortBy: [[5,'desc']],
	    lengthChange: false,
	    catalog: 'solution:ad_serving/ADM.xml',
	    jndi: "dw3",
	    urlTemplate: "javascript:MetaLayerCharts.siteSelecClicked1(encode_prepare('{site}'))",
		parameterName: "site",
	    query: function(){

	    var query = "select NON EMPTY {[Measures].[Rank], [Measures].[Yesterday Rank],[Measures].[Budget],[Measures].[ABudget],[Measures].[Revenue],[Measures].[Impressions], [Measures].[Clicks], [Measures].[Pacing], [Measures].[MTD Total Revenue], [Measures].[Remaining Monthly Budget], [Measures].[Next Month Budget]} ON COLUMNS," +
	    		"  NON EMPTY {[Order name].[All Order names].Children} ON ROWS " +
	    		"from [daily_agg_revenue_by_order] " +
	    		"where Crossjoin({[Full date].["+yesterday+"]}, {[Is active].[true]})";
	    return query;
	    }
	},
	topSitesOf1DayAgoChartDefinition:{
			colHeaders: ["Order name","YRank","TDRank","BBudget","ABudget","Revenue","Impressions","Clicks","Pacing","MTDRevenue","RMBudget","NMBudget"],
			colTypes: ['string','numeric','numeric','numeric','numeric','numeric','numeric','numeric','numeric','numeric','numeric','numeric'],
			colFormats: [null,'%.0f','%.0f','%.0f','%.0f','%.0f','%.0f','%.0f','%.0f','%.0f','%.0f','%.0f'],
			colWidths: ['300px','100px',null,null,null,null,null,null,null,null,null,null],
		    queryType: 'mdx',
		    displayLength: 20,
		    sort: true,
		    sortBy: [[1,'asc']],
		    lengthChange: false,
		    catalog: 'solution:ad_serving/ADM.xml',
		    jndi: "dw3",
		    urlTemplate: "javascript:MetaLayerCharts.siteSelecClicked2(encode_prepare('{site}'))",
			parameterName: "site",
		    query: function(){

		    var query = "select NON EMPTY {[Measures].[Yesterday Rank], [Measures].[TDRank],[Measures].[Budget],[Measures].[ABudget],[Measures].[Revenue],[Measures].[Impressions], [Measures].[Clicks],[Measures].[Pacing], [Measures].[MTD Total Revenue], [Measures].[Remaining Monthly Budget], [Measures].[Next Month Budget]} ON COLUMNS," +
		    		"  NON EMPTY {[Order name].[All Order names].Children} ON ROWS " +
		    		"from [daily_agg_revenue_by_order_yesterday] " +
		    		"where Crossjoin({[Full date].["+yesterday+"]}, {[Is active].[true]})";
		    return query;
		    }
	},
	compareChartDefinition1:{
		width: "330",
		height: "200",
		chartType: "BarChart",				
		datasetType: "CategoryDataset",
		is3d: "false",
		isStacked: "false",
		includeLegend: "false",		
		//orientation: 'horizontal',
		queryType: 'mdx',
		catalog: 'solution:ad_serving/ADM.xml',
		jndi: "dw3",
		query: function(){
			 var query = "select NON EMPTY {[Measures].[Revenue]} ON COLUMNS," +
	    		"  NON EMPTY {[Full date].["+yesterday+"]:[Full date].["+thirtyDayAgo+"]} ON ROWS " +
	    		"from [daily_agg_revenue_by_order] " +
	    		"where Crossjoin({[Order name].["+selectedSite+"]}, {[Is active].[true]})";
			return query;
		}
	},
	compareChartDefinition2:{
		width: "330",
		height: "200",
		chartType: "BarChart",				
		datasetType: "CategoryDataset",
		is3d: "false",
		isStacked: "false",
		includeLegend: "false",		
		//orientation: 'horizontal',
		queryType: 'mdx',
		catalog: 'solution:ad_serving/ADM.xml',
		jndi: "dw3",
		query: function(){
			var query = "select NON EMPTY {[Measures].[Impressions]} ON COLUMNS," +
    		"  NON EMPTY {[Full date].["+yesterday+"]:[Full date].["+thirtyDayAgo+"]} ON ROWS " +
    		"from [daily_agg_revenue_by_order] " +
    		"where Crossjoin({[Order name].["+selectedSite+"]}, {[Is active].[true]})";
			return query;
		}
	},
	compareChartDefinition3:{
		width: "335",
		height: "200",
		chartType: "BarChart",				
		datasetType: "CategoryDataset",
		is3d: "false",
		isStacked: "false",
		includeLegend: "false",
		legendFontSize: 4,
		//orientation: 'horizontal',
		queryType: 'mdx',
		catalog: 'solution:ad_serving/ADM.xml',
		jndi: "dw3",
		query: function(){
			var query = "select NON EMPTY {[Measures].[Clicks]} ON COLUMNS," +
    		"  NON EMPTY {[Full date].["+yesterday+"]:[Full date].["+thirtyDayAgo+"]} ON ROWS " +
    		"from [daily_agg_revenue_by_order] " +
    		"where Crossjoin({[Order name].["+selectedSite+"]}, {[Is active].[true]})";
			return query;
		}
	},
	executeQueryComponentDefinition: {
		queryType: 'mdx',
		catalog: 'solution:ad_serving/ADM.xml',
		jndi: "dw3",		
		query: function(){
			return "select NON EMPTY {[Measures].[Revenue]} ON COLUMNS," +
					" NON EMPTY {[Full date].[All Full dates].LastChild} ON ROWS" +
					" from [daily_agg_revenue_by_order]" +
					" where {[Is Active].[true]}";
		}
	}

	
};


  
var myFunctions={
		parseDate: function(date){
			var result='';
			var months = new Array('01','02','03','04','05','06','07','08','09','10','11','12');
			var tdate=date.getDate();
			if(tdate<10) tdate='0'+tdate;
			result=date.getFullYear()+'-'+months[date.getMonth()]+'-'+tdate;
			return result;
		}
};

$(document).ready(function() {
	$('div[class=mybox]').each(function(){
		var myBox=$(this);
		var myTile=$(this).children('div[class=title]');
		var myConent=$(this).children('div[class=box_content]');
		var myUp=$('<img src="resources/style/v_images/arrow_090_medium.png" class="bt"/>');
		var myHidden=$('<img src="resources/style/v_images/minimize_square.png" class="bt"/>');
		var myDown=$('<img style="display: none;" src="resources/style/v_images/arrow_270_medium.png" class="bt"/>');
		myHidden.appendTo(myTile);
		myUp.appendTo(myTile);
		myDown.appendTo(myTile);
		
		myUp.click(function(){
			myConent.slideUp('slow',function(){});
			myDown.show();
			myUp.hide();		
			myTile.width(myConent.outerWidth());
		});
		myDown.click(function(){
			myConent.slideDown('slow',function(){});
			myUp.show();
			myDown.hide();
		});
		myHidden.click(function(){
			myBox.fadeOut('slow',function(){
				myBox.detach();
				var hiddenDiv=$('#hiddenDiv');
				var myShowDivBt=$('<input type=button style="margin: 2px;"/>');
				myShowDivBt.attr('value',myTile.text());
				myShowDivBt.appendTo(hiddenDiv);
				myShowDivBt.fadeIn('slow',function(){});
				myShowDivBt.click(function(){
					myShowDivBt.remove();
					myBox.insertAfter($('#boxContenHiddenBoxs'));
					myBox.fadeIn('slow',function(){
						
					});
					
				});
			});
			
			
		});
	});
});