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