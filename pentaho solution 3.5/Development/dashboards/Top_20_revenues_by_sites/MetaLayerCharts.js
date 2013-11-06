var yesterday="2011-07-12";
var oneDayAgo="2011-07-11";
var sevenDayAgo="2011-07-05";
var thirtyDayAgo="2011-06-05";
var selectedMeasures="Revenue total";
var selectedSite="Philadelphia media holdings- Philly.com-Off Deck";


var MetaLayerCharts ={
	/*startDate: MetaLayer.getLastMonthDate(), // Default start date
	endDate: MetaLayer.getCurrentDate(), // Default end date
	startMonth: MetaLayer.getMonth(), // Default month date*/
};

MetaLayerCharts =  {
	siteSelecClicked: function(value){
		selectedSite=value;	
		
		Dashboards.fireChange("selectedSite",selectedSite);
		$('#comparebox').show();
	},
	topSitesOfYesterdayChartDefinition:{
	    colHeaders: ["Placements","Revenue","Impression","Click"],
	    colTypes: ['string','numeric','numeric','numeric'],
	    colFormats: [null,'%.0f'],
	    colWidths: ['697px','100px','100px','100px'],
	    queryType: 'mdx',
	    displayLength: 10,
	    sort: true,
	    sortBy: [[1,'desc']],
	    lengthChange: false,
	    catalog: 'solution:ad_serving/ADM.xml',
	    jndi: "dw3",
	    urlTemplate: "javascript:MetaLayerCharts.siteSelecClicked(encode_prepare('{site}'))",
		parameterName: "site",
	    query: function(){

	    var query = "select NON EMPTY {[Measures].["+selectedMeasures+"],[Measures].[Impression count],[Measures].[Click count]} ON COLUMNS,NON EMPTY TopCount([Placement].[All Placements].Children, 20.0, [Measures].["+selectedMeasures+"]) ON ROWS from [daily_agg_adm_data_feed] where Crossjoin({[Full date].["+yesterday+"]}, {[Is Active].[true]})";
	    return query;
	    }
	},
	topSitesOf1DayAgoChartDefinition:{
	    colHeaders: ["Placements","Revenue","Impression","Click"],
	    colTypes: ['string','numeric','numeric','numeric'],
	    colFormats: [null,'%.0f'],
	    colWidths: ['697px','100px','100px','100px'],
	    queryType: 'mdx',
	    displayLength: 10,
	    sort: true,
	    sortBy: [[1,'desc']],
	    lengthChange: false,
	    catalog: 'solution:ad_serving/ADM.xml',
	    jndi: "dw3",
	    urlTemplate: "javascript:MetaLayerCharts.siteSelecClicked(encode_prepare('{site}'))",
		parameterName: "site",
	    query: function(){

	    var query = "select NON EMPTY {[Measures].["+selectedMeasures+"],[Measures].[Impression count],[Measures].[Click count]} ON COLUMNS,NON EMPTY TopCount([Placement].[All Placements].Children, 20.0, [Measures].["+selectedMeasures+"]) ON ROWS from [daily_agg_adm_data_feed] where Crossjoin({[Full date].["+oneDayAgo+"]}, {[Is Active].[true]})";
	    return query;
	    }
	},
	topSitesOf7DayAgoChartDefinition:{
		colHeaders: ["Placements","Revenue","Impression","Click"],
	    colTypes: ['string','numeric','numeric','numeric'],
	    colFormats: [null,'%.0f'],
	    colWidths: ['697px','100px','100px','100px'],
	    queryType: 'mdx',
	    displayLength: 10,
	    sort: true,
	    sortBy: [[1,'desc']],
	    lengthChange: false,
	    catalog: 'solution:ad_serving/ADM.xml',
	    jndi: "dw3",
	    urlTemplate: "javascript:MetaLayerCharts.siteSelecClicked(encode_prepare('{site}'))",
		parameterName: "site",
		query: function(){

		    var query = "select NON EMPTY {[Measures].["+selectedMeasures+"],[Measures].[Impression count],[Measures].[Click count]} ON COLUMNS,NON EMPTY TopCount([Placement].[All Placements].Children, 20.0, [Measures].["+selectedMeasures+"]) ON ROWS from [daily_agg_adm_data_feed] where Crossjoin({[Full date].["+sevenDayAgo+"]}, {[Is Active].[true]})";
		    return query;
		    }
	},
	topSitesOf30DayAgoChartDefinition:{
		colHeaders: ["Placements","Revenue","Impression","Click"],
	    colTypes: ['string','numeric','numeric','numeric'],
	    colFormats: [null,'%.0f'],
	    colWidths: ['697px','100px','100px','100px'],
	    queryType: 'mdx',
	    displayLength: 10,
	    sort: true,
	    sortBy: [[1,'desc']],
	    lengthChange: false,
	    catalog: 'solution:ad_serving/ADM.xml',
	    jndi: "dw3",
	    urlTemplate: "javascript:MetaLayerCharts.siteSelecClicked(encode_prepare('{site}'))",
		parameterName: "site",
		query: function(){

		    var query = "select NON EMPTY {[Measures].["+selectedMeasures+"],[Measures].[Impression count],[Measures].[Click count]} ON COLUMNS,NON EMPTY TopCount([Placement].[All Placements].Children, 20.0, [Measures].["+selectedMeasures+"]) ON ROWS from [daily_agg_adm_data_feed] where Crossjoin({[Full date].["+thirtyDayAgo+"]}, {[Is Active].[true]})";
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
			var query = "select NON EMPTY {[Measures].[Revenue total]} ON COLUMNS," +
					" NON EMPTY {[Full date].["+thirtyDayAgo+"]:[Full date].["+yesterday+"]} ON ROWS" +
					" from [daily_agg_adm_data_feed]" +
					" where Crossjoin({[Is Active].[true]}, {[Placement].["+selectedSite+"]})";
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
			var query = "select NON EMPTY {[Measures].[Impression count]} ON COLUMNS," +
					" NON EMPTY {[Full date].["+thirtyDayAgo+"]:[Full date].["+yesterday+"]} ON ROWS" +
					" from [daily_agg_adm_data_feed]" +
					" where Crossjoin({[Is Active].[true]}, {[Placement].["+selectedSite+"]})";
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
			var query = "select NON EMPTY {[Measures].[Click count]} ON COLUMNS," +
					" NON EMPTY {[Full date].["+thirtyDayAgo+"]:[Full date].["+yesterday+"]} ON ROWS" +
					" from [daily_agg_adm_data_feed]" +
					" where Crossjoin({[Is Active].[true]}, {[Placement].["+selectedSite+"]})";
			return query;
		}
	},
	executeQueryComponentDefinition: {
		queryType: 'mdx',
		catalog: 'solution:ad_serving/ADM.xml',
		jndi: "dw3",		
		query: function(){
			return "select NON EMPTY {[Measures].["+selectedMeasures+"]} ON COLUMNS," +
					" NON EMPTY {[Full date].[All Full dates].LastChild} ON ROWS" +
					" from [daily_agg_adm_data_feed]" +
					" where {[Is Active].[true]}";
		}
	}

	
};


  

