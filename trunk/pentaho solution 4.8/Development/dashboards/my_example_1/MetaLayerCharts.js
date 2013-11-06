var MetaLayerCharts ={
	/*startDate: MetaLayer.getLastMonthDate(), // Default start date
	endDate: MetaLayer.getCurrentDate(), // Default end date
	startMonth: MetaLayer.getMonth(), // Default month date*/
};

MetaLayerCharts =  {
	selectedSite: "Advance-AL Birmingham",
	selectedMeasures: "Impression count",
	topTenSitesChartClicked: function(value){
		MetaLayerCharts.selectedSite=value;		
		Dashboards.fireChange("MetaLayerCharts.selectedSite",MetaLayerCharts.selectedSite);
	},
	measuresChartClicked: function(value){
		MetaLayerCharts.selectedMeasures=value;
		Dashboards.fireChange("MetaLayerCharts.selectedMeasures",MetaLayerCharts.selectedMeasures);
	},
	topTenSitesChartDefinition:{
		width: "673",
		height: "430",
		chartType: "BarChart",				
		datasetType: "CategoryDataset",
		is3d: "false",
		isStacked: "false",
		includeLegend: "false",		
		//orientation: 'horizontal',
		queryType: 'mdx',
		catalog: 'solution:ad_serving/DoubleClick.xml',
		jndi: "dw3",
		urlTemplate: "javascript:MetaLayerCharts.topTenSitesChartClicked(encode_prepare('{site}'))",
		parameterName: "site",
		query: function(){
			var query = "select NON EMPTY {[Measures].["+MetaLayerCharts.selectedMeasures+"]} ON COLUMNS,NON EMPTY TopCount([Site].[All Sites].Children, 10.0, [Measures].["+MetaLayerCharts.selectedMeasures+"]) ON ROWS from [daily_agg_site_day] where {[Is active].[true]}"
			return query;
		}
	},
	siteDetailChartDefinition:{
		width: "300",
		height: "200",
		chartType: "PieChart",
		legendFontSize: 6,		
		datasetType: "CategoryDataset",
		orientation: 'horizontal',
		is3d: "false",
		isStacked: "false",
		includeLegend: "false",		
		queryType: 'mdx',
		catalog: 'solution:ad_serving/DoubleClick.xml',
		jndi: "dw3",
		query: function(){
			var query = "select NON EMPTY {[Measures].["+MetaLayerCharts.selectedMeasures+"]} ON COLUMNS,"+
			" NON EMPTY {[Calendar year month].[All Calendar year months].Children} ON ROWS"+
			" from [daily_agg_site_day]"+
			" where Crossjoin({[Is active].[true]}, {[Site].["+MetaLayerCharts.selectedSite+"]})";
			return query;
		}
	},
	measuresChartDefinition:{
		width: "310",
		height: "195",
		//chartType: "BarChart",
		legendFontSize: 6,		
		datasetType: "CategoryDataset",
		//orientation: 'horizontal',
		is3d: "false",
		isStacked: "false",
		includeLegend: "false",		
		queryType: 'mdx',
		catalog: 'solution:ad_serving/DoubleClick.xml',
		jndi: "dw3",
		urlTemplate: "javascript:MetaLayerCharts.measuresChartClicked(encode_prepare('{measures}'))",
		parameterName: "measures",
		query: function(){
			var query = "select NON EMPTY {[Site].[All Sites]} ON COLUMNS,"+
			" NON EMPTY {[Measures].[Impression count], [Measures].[Click count], [Measures].[Revenue total]} ON ROWS"+
			" from [daily_agg_site_day]"+
			" where {[Is active].[true]}";
			return query;
		}
	}
};


  

