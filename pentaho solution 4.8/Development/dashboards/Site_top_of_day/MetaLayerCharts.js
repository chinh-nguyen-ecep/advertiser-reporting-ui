var yesterday="2011-07-12";
var oneDayAgo="2011-07-11";
var sevenDayAgo="2011-07-05";
var thirtyDayAgo="2011-06-05";
var selectedMeasures="Impression count";
var selectedSite="AP_iPhone Client App";

var MetaLayerCharts ={
	/*startDate: MetaLayer.getLastMonthDate(), // Default start date
	endDate: MetaLayer.getCurrentDate(), // Default end date
	startMonth: MetaLayer.getMonth(), // Default month date*/
};

MetaLayerCharts =  {
	siteSelecClicked: function(value){
		selectedSite=value;	
		Dashboards.fireChange("selectedSite",selectedSite);
	},
	topSitesOfYesterdayChartDefinition:{
		width: "997",
		height: "250",
		chartType: "BarChart",				
		datasetType: "CategoryDataset",
		is3d: "false",
		isStacked: "false",
		includeLegend: "false",		
		//orientation: 'horizontal',
		queryType: 'mdx',
		catalog: 'solution:ad_serving/DoubleClick.xml',
		jndi: "dw3",
		urlTemplate: "javascript:MetaLayerCharts.siteSelecClicked(encode_prepare('{site}'))",
		parameterName: "site",
		query: function(){
			var query = "select NON EMPTY {[Measures].["+selectedMeasures+"]} ON COLUMNS,NON EMPTY TopCount([Site].[All Sites].Children, 10.0, [Measures].["+selectedMeasures+"]) ON ROWS from [daily_agg_site_day] where Crossjoin({[Full date].["+yesterday+"]}, {[Is active].[true]})";
			return query;
		}
	},
	topSitesOf1DayAgoChartDefinition:{
		width: "330",
		height: "200",
		chartType: "BarChart",				
		datasetType: "CategoryDataset",
		is3d: "false",
		isStacked: "false",
		includeLegend: "false",		
		//orientation: 'horizontal',
		queryType: 'mdx',
		catalog: 'solution:ad_serving/DoubleClick.xml',
		jndi: "dw3",
		urlTemplate: "javascript:MetaLayerCharts.siteSelecClicked(encode_prepare('{site}'))",
		parameterName: "site",
		query: function(){
			var query = "select NON EMPTY {[Measures].["+selectedMeasures+"]} ON COLUMNS,NON EMPTY TopCount([Site].[All Sites].Children, 10.0, [Measures].["+selectedMeasures+"]) ON ROWS from [daily_agg_site_day] where Crossjoin({[Full date].["+oneDayAgo+"]}, {[Is active].[true]})";
			return query;
		}
	},
	topSitesOf7DayAgoChartDefinition:{
		width: "330",
		height: "200",
		chartType: "BarChart",				
		datasetType: "CategoryDataset",
		is3d: "false",
		isStacked: "false",
		includeLegend: "false",		
		//orientation: 'horizontal',
		queryType: 'mdx',
		catalog: 'solution:ad_serving/DoubleClick.xml',
		jndi: "dw3",
		urlTemplate: "javascript:MetaLayerCharts.siteSelecClicked(encode_prepare('{site}'))",
		parameterName: "site",
		query: function(){
			var query = "select NON EMPTY {[Measures].["+selectedMeasures+"]} ON COLUMNS,NON EMPTY TopCount([Site].[All Sites].Children, 10.0, [Measures].["+selectedMeasures+"]) ON ROWS from [daily_agg_site_day] where Crossjoin({[Full date].["+sevenDayAgo+"]}, {[Is active].[true]})";
			return query;
		}
	},
	topSitesOf30DayAgoChartDefinition:{
		width: "328",
		height: "200",
		chartType: "BarChart",				
		datasetType: "CategoryDataset",
		is3d: "false",
		isStacked: "false",
		includeLegend: "false",		
		//orientation: 'horizontal',
		queryType: 'mdx',
		catalog: 'solution:ad_serving/DoubleClick.xml',
		jndi: "dw3",
		urlTemplate: "javascript:MetaLayerCharts.siteSelecClicked(encode_prepare('{site}'))",
		parameterName: "site",
		query: function(){
			var query = "select NON EMPTY {[Measures].["+selectedMeasures+"]} ON COLUMNS,NON EMPTY TopCount([Site].[All Sites].Children, 10.0, [Measures].["+selectedMeasures+"]) ON ROWS from [daily_agg_site_day] where Crossjoin({[Full date].["+thirtyDayAgo+"]}, {[Is active].[true]})";
			return query;
		}
	},
	compareChartDefinition:{
		width: "997",
		height: "200",
		chartType: "LineChart",				
		datasetType: "CategoryDataset",
		is3d: "false",
		isStacked: "false",
		includeLegend: "false",		
		//orientation: 'horizontal',
		queryType: 'mdx',
		catalog: 'solution:ad_serving/DoubleClick.xml',
		jndi: "dw3",
		query: function(){
			var query = "select NON EMPTY {[Measures].["+selectedMeasures+"]} ON COLUMNS," +
					" NON EMPTY {[Full date].["+thirtyDayAgo+"], [Full date].["+sevenDayAgo+"],[Full date].["+oneDayAgo+"], [Full date].["+yesterday+"]} ON ROWS" +
					" from [daily_agg_site_day]" +
					" where Crossjoin({[Is active].[true]}, {[Site].["+selectedSite+"]})";
			return query;
		}
	},
	executeQueryComponentDefinition: {
		queryType: 'mdx',
		catalog: 'solution:ad_serving/DoubleClick.xml',
		jndi: "dw3",		
		query: function(){
			return "select NON EMPTY {[Measures].[Impression count]} ON COLUMNS," +
					" NON EMPTY {[Full date].[All Full dates].LastChild} ON ROWS" +
					" from [daily_agg_site_day]" +
					" where {[Is active].[true]}";
		}
	}
	
};

  

