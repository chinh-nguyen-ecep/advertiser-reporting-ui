<style>

</style>
<script>
	//Set locate
	urlMaster.replaceParam('page', 'template');
	urlMaster.replaceParam('actionPath', 'adjusted_units_management');
	activeTab('Adjustment');
</script>
<div class="page-header">
	<div class="btn-group pull-right">
	<a class="btn" href="" onclick="loadPage()"><i class="icon-chevron-left icon-black"></i>
		Back
	</a>
	</div>
	<h1 id="page_header">Add Adjusted Units</h1>
</div>
<form class="form-horizontal" role="form"  onsubmit="return formAction();">
	<div class="form-group">
		<label for="selectbox_month_sk" class="required control-label">Month<abbr title="Required">*</abbr></label>
		<select	class="form-control" id="selectbox_month_sk">									
		</select>
	</div>
	<div class="form-group">
	<label for="combined_ids" class="required control-label">Combined IDs <abbr title="Required">*</abbr></label>
	<input class="input-xlarge" id="selectbox_combined_ids" type="hidden" name="combined_ids" data-placeholder="Select Combined IDs" style="width: 100%"/>
	</div>
	<div class="form-group">
		<label for="adjusted_units" class="required control-label">Adjusted Units<abbr title="Required">*</abbr></label>
		<input type="text" class="form-control" id="adjusted_units" maxlength="10" placeholder="Enter adjusted units" name="adjusted_units" value="{p_adjusted_units}">
	</div>
	<div class="form-group">
		<label for="comment" class="required control-label">Comment</label>
		<input type="text" class="form-control" id="comment" maxlength="255" placeholder="Enter comment" name="comment" value="">
	</div>
	<div class="form-actions">
	<input class="btn btn-primary" data-disable-with="Please wait ..." name="commit" type="submit" value="Create">
	<a class="btn" href="#" onclick="loadPage()">Cancel</a>
	</div>
</form>  

<script>
	// Set default value for comment to the current month
	var now=new Date();
	$('#comment').val("Billing for "+now.format('yyyy-mmm'));
	
	//////////////////////////////
	// Load list of combined ids
	/////////////////////////////
	function loadListOfCombinedIDs(input){
		this.input = $.extend({}, {
			p_month_sk: '',
			p_start_date: '',
			p_end_date: '',
			success : function() {
			}
		}, input);
		
		$('#selectbox_combined_ids').select2({
			minimumInputLength: 0,
			ajax: {
				url: rootPath_AdjustedUnits,
				quietMillis: 1000,
				dataType: 'json',
				data: function (term, page) {
					return {
						actions: 'loadListCombinedIDs',
						page: page,
						limit: 20,
						data: 'json',
						term: term,
						p_month_sk: input.p_month_sk,
						p_start_date: input.p_start_date,
						p_end_date: input.p_end_date
					};
				},
				results: function (data, page) {
					var resultData=data;
					var myData=[];
					var more=false;
					if(resultData.length==20){
						more=true;
					}
					$.each(resultData,function(index,item){
						var row={
							id: item.combined_ids,
							text: item.displayed_name
						};
						myData.push(row);
					});
					return { results: myData ,  more: more};
				}
			}
		}).change(function(e){
		});
	}

	/////////////////////////////////////
	// Load list of month
	//////////////////////////////////////
	function loadSelectBoxMonthOfAdjustedUnits(){
		loadListMonthForAdd({
			success: function(arrayJson){
				var rows=[];
				for(var i=0;i<arrayJson.length;i++){
					var month_sk=arrayJson[i].month_id;
					var month=arrayJson[i].calendar_year_month;
					if(i==0){
						row='<option value="'+month_sk+'" selected>'
							+	month
							+	'</option>';
					}else{
						row='<option value="'+month_sk+'">'
							+	month
							+	'</option>';
					}
					rows.push(row);
				}
				$('#selectbox_month_sk').html(rows.join(""));
				
				var month_id = $('#selectbox_month_sk').val();
				loadListOfCombinedIDs({
					p_month_sk: month_id.split(";")[0],
					p_start_date: month_id.split(";")[1],
					p_end_date: month_id.split(";")[2],
					success: function(){				
					}
				});
			}
		});
		$('#selectbox_month_sk').change(function(){
			var month_id = $('#selectbox_month_sk').val();
			loadListOfCombinedIDs({
				p_month_sk: month_id.split(";")[0],
				p_start_date: month_id.split(";")[1],
				p_end_date: month_id.split(";")[2],
				success: function(){				
				}
			});
		});
	}
	loadSelectBoxMonthOfAdjustedUnits();

	function formAction(){
		var month_id       = $('#selectbox_month_sk').val();
		var combined_ids   = $('#selectbox_combined_ids').select2('val');
		var adjusted_units = $('#adjusted_units').val();
		var comment        = $('#comment').val();

		addAdjustedUnits({
			p_combined_ids: combined_ids,
			p_io_orders_id: combined_ids.split("-")[0],
			p_io_line_item_id: combined_ids.split("-")[1],
			p_adjusted_units: adjusted_units,
			p_month_sk: month_id.split(";")[0],
			p_comment: comment,
			success: function(data){
				var msg=data[0].fn_ba_national_dim_adjustment_insert;
				if(msg=='SUCCESSED'){
					alert("Added successfully");
					loadPage();
				}
			}
		});
		return false;
	}

</script>