function checkForm(form)
{
	var flag=false;
	for(i=0;i<form.elements.length;i++)
	{
		//if((form.elements[i].name=="song_ids[]"||form.elements[i].name=="album_ids[]"||form.elements[i].name=="artist_ids[]")&&form.elements[i].checked)
		if(form.elements[i].checked)
		{
			flag=true;
			break;
		}
	}
	if(flag==false)
	{
		alert("请选择批量处理的ID!");
		return false;
	}
	//if(!confirm("确实要删除么?改操作不可恢复!"))
	//{
	 //  return false;
	//}
	//form.submit();
}

function CheckOthers(form,src)
{
	for (var i=0;i<form.elements.length;i++)
	{
		var e = form.elements[i];
			if (e.checked==false&&e.name==src)
			{
				e.checked = true;// form.chkall.checked;
			}
			else if(e.checked==true&&e.name==src)
			{
				e.checked = false;
			}
	}
}

function CheckAll(form,src)
{
	for (var i=0;i<form.elements.length;i++)
	{
		var e = form.elements[i];
		if(e.name==src)
		{
			e.checked = true;
		}
	}
}