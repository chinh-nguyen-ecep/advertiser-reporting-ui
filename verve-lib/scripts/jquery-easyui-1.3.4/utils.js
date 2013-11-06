function simpleObjInspect(oObj, key, tabLvl)
{
    key = key || "";
    tabLvl = tabLvl || 1;
    var tabs = "";
    for(var i = 1; i < tabLvl; i++){
        tabs += "\t";
    }
    var keyTypeStr = " (" + typeof key + ")";
    if (tabLvl == 1) {
        keyTypeStr = "(self)";
    }
    var s = tabs + key + keyTypeStr + " : ";
    if (typeof oObj == "object" && oObj !== null) {
        s += typeof oObj + "\n";
        for (var k in oObj) {
            if (oObj.hasOwnProperty(k)) {
                s += simpleObjInspect(oObj[k], k, tabLvl + 1);
            }
        }
    } else {
        s += "" + oObj + " (" + typeof oObj + ") \n";
    }
    return s;
}

var clearDataGrid=function(dataGridObject){
	console.log('Clear dataGrid object');	
	var rows=dataGridObject.datagrid('getRows');	
	var row_number=rows.length;	
	for(var i=0;i<row_number;i++){									
		var index=dataGridObject.datagrid('getRowIndex',rows[i]);									
		dataGridObject.datagrid('deleteRow',index);
	}
}
var createDateDialog=function(settings){
	settings=$.extend({},{
		current: new Date(),
		title: 'Calendar',
		onSelect: function(date){}
	},settings);
	var default_date=new Date();
	var dialog=$('<div></div>');	
	var my_calendar=$('<div></div>');
	my_calendar.appendTo(dialog);
	my_calendar.calendar({		
		current: settings.current,
		onSelect: function(date){
			default_date=date;
		}
	});
	
	dialog.dialog({
		title: settings.title,
		closed: false,
		cache: false,   
		modal: true,
		closable: false,
		buttons:[{
			text:'Current date',
			handler:function(){				
				dialog.dialog('close');
				my_calendar.calendar('moveTo', new Date());
				default_date=new Date();
				settings.onSelect(default_date);
				
			}	
		},{
			text:'OK',
			handler:function(){
				dialog.dialog('close');
				settings.onSelect(default_date);
			}	
		}]
	});
}