var root_folder='/verve-lib';
//This function load javascript from url
function loadScript(p_url){
	//alert(p_url);
	$.ajax({
	  url: p_url,
	  dataType: 'script',
	  success: function(){
		//alert("Loaded script... "+p_url);
	  },
	  async: false
	});
}
loadScript(root_folder + "/scripts/jquery-ui-1.8.24.custom/js/jquery-ui-1.8.24.custom.min.js");
loadScript(root_folder + "/scripts/utils/jquery.fileDownload.js");
loadScript(root_folder + "/scripts/utils/pentaho_utils.js");
loadScript(root_folder + "/scripts/utils/pentaho_ajax.js");
loadScript(root_folder + "/scripts/utils/pentaho_form_view.js");
loadScript(root_folder + "/scripts/utils/pentaho_control_pannel.js");







