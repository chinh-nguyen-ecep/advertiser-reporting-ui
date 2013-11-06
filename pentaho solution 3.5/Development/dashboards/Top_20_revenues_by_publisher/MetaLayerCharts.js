var yesterday="2011-07-12";
var oneDayAgo="2011-07-11";
var sevenDayAgo="2011-07-05";
var thirtyDayAgo="2011-06-05";
var selectedMeasures="Revenue";
var selectedSite="All Publishers";
var report_date='';

var MetaLayerCharts ={
	/*startDate: MetaLayer.getLastMonthDate(), // Default start date
	endDate: MetaLayer.getCurrentDate(), // Default end date
	startMonth: MetaLayer.getMonth(), // Default month date*/
};

MetaLayerCharts =  {
	siteSelecClicked1: function(value){
		selectedSite=value;	
		Dashboards.fireChange("selectedSite",selectedSite);
		$('#comparebox').show();
	},
	topSitesOfYesterdayChartDefinition:{
	    colHeaders: ["Publisher","Revenue","Impressions","Clicks"],
	    colTypes: ['string','numeric','numeric','numeric'],
	    colFormats: [null,'%.0f','%.0f','%.0f'],
	    colWidths: ['630px','100px','100px','100px'],
	    queryType: 'mdx',
	    displayLength: 20,
	    sort: true,
	    sortBy: [[1,'desc']],
	    lengthChange: false,
	    catalog: 'solution:ad_serving/ADM.xml',
	    jndi: "dw3",
	    urlTemplate: "javascript:MetaLayerCharts.siteSelecClicked1(encode_prepare('{Publisher}'))",
		parameterName: "Publisher",
	    query: function(){
	    var query = "select NON EMPTY {[Measures].[Revenue],[Measures].[Impressions], [Measures].[Clicks]} ON COLUMNS," +
	    		"  NON EMPTY {[Publisher].[All Publishers].Children} ON ROWS " +
	    		"from [daily_agg_network_performance] " +
	    		"where Crossjoin({[Date].["+yesterday+"]}, {[Active].[true]})";
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
	    		"  NON EMPTY {[Date].["+yesterday+"]:[Date].["+thirtyDayAgo+"]} ON ROWS " +
	    		"from [daily_agg_network_performance] " +
	    		"where Crossjoin({[Publisher].["+selectedSite+"]}, {[Active].[true]})";
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
    		"  NON EMPTY {[Date].["+yesterday+"]:[Date].["+thirtyDayAgo+"]} ON ROWS " +
    		"from [daily_agg_network_performance] " +
    		"where Crossjoin({[Publisher].["+selectedSite+"]}, {[Active].[true]})";
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
    		"  NON EMPTY {[Date].["+yesterday+"]:[Date].["+thirtyDayAgo+"]} ON ROWS " +
    		"from [daily_agg_network_performance] " +
    		"where Crossjoin({[Publisher].["+selectedSite+"]}, {[Active].[true]})";
			return query;
		}
	},
	executeQueryComponentDefinition: {
		queryType: 'mdx',
		catalog: 'solution:ad_serving/ADM.xml',
		jndi: "dw3",		
		query: function(){
			return "select NON EMPTY {[Measures].[Revenue]} ON COLUMNS," +
					" NON EMPTY {[Date].[All Dates].LastChild} ON ROWS" +
					" from [daily_agg_network_performance]" +
					" where {[Active].[true]}";
		}
	}

	
};


  

